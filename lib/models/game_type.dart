enum GameType {
  addNumbers(
    'Add Two Numbers',
    'Add two numbers together',
    'Simply add the two numbers shown.\n\n'
    r'Example: $5 + 3 = 8$' '\n\n'
    'Just type the sum of the two numbers using the keyboard or number pad.',
  ),
  addMatrices(
    'Add 2x2 Matrices',
    'Add two 2x2 matrices together',
    'Add corresponding elements from both matrices.\n\n'
    'Example:\n'
    r'$\begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix} + \begin{pmatrix} 4 & 5 \\ 6 & 7 \end{pmatrix} = \begin{pmatrix} 5 & 7 \\ 9 & 11 \end{pmatrix}$'
    '\n\n'
    'Add each position: top-left with top-left, top-right with top-right, etc.',
  ),
  multiplyMatrices(
    'Multiply 2x2 Matrices',
    'Multiply two 2x2 matrices together',
    'Use the rule: (row × column) to find each element.\n\n'
    'Example:\n'
    r'$\begin{pmatrix} a & b \\ c & d \end{pmatrix} \times \begin{pmatrix} e & f \\ g & h \end{pmatrix} = \begin{pmatrix} ae+bg & af+bh \\ ce+dg & cf+dh \end{pmatrix}$'
    '\n\n'
    'For position (1,1): multiply row 1 of first matrix by column 1 of second.\n'
    'For position (1,2): multiply row 1 of first matrix by column 2 of second.\n'
    'And so on for each position.',
  ),
  squareMatrix(
    'Square a Matrix',
    'Calculate A × A for a 2x2 matrix',
    'Multiply the matrix by itself (A² = A × A).\n\n'
    'Example: If '
    r'$A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$, then:'
    '\n\n'
    r'$A^2 = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix} \times \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix} = \begin{pmatrix} 7 & 10 \\ 15 & 22 \end{pmatrix}$'
    '\n\n'
    'Use the same matrix multiplication rules.',
  ),
  determinant(
    'Determinant',
    'Calculate the determinant of a 2x2 matrix',
    'For a 2x2 matrix, the determinant is calculated as:\n\n'
    r'$\det\begin{pmatrix} a & b \\ c & d \end{pmatrix} = ad - bc$'
    '\n\n'
    'Example:\n'
    r'$\det\begin{pmatrix} 3 & 5 \\ 2 & 7 \end{pmatrix} = (3 \times 7) - (5 \times 2) = 21 - 10 = 11$'
    '\n\n'
    'Formula: det(A) = (top-left × bottom-right) - (top-right × bottom-left)',
  );

  final String name;
  final String description;
  final String instructions;

  const GameType(this.name, this.description, this.instructions);
}
