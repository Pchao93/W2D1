class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

  def boss=(boss)
    if boss.nil? && !@boss.nil?
      @boss.employees.delete(self)
      @boss = boss #????????????????
    elsif !@boss.nil?
      @boss.employees.delete(self)
      @boss = boss
      boss.employees.push(self) unless boss.employees.include?(self)
    else
      @boss = boss
      boss.employees.push(self) unless boss.employees.include?(self)
    end
  end

  def add_employee(employee)
    employee.boss = self
    @employees.push(employee) unless @employees.include?(employee)
  end

end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss)
    @employees = []
    super
  end

  def bonus(multiplier)
    queue = []
    sum = 0
    queue = @employees.dup
    until queue.empty?
      employee = queue.shift
      sum += employee.salary
      if employee.class == (Manager)
        employee.employees.each do |worker|
          queue.push(worker)
        end
      end
    end
    sum *= multiplier
  end
end
