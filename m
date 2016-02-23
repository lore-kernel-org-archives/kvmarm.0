From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 0/2] kvmtool: replace documentations stubs with manpage
Date: Tue, 23 Feb 2016 17:41:03 +0000
Message-ID: <1456249265-13751-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E37412F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 12:34:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QbogyVumoLlH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2016 12:34:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D522412E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 12:34:29 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, kvmarm@lists.cs.columbia.edu, Dimitri John Ledkov <dimitri.j.ledkov@intel.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

an update fixing the missing option enumeration for the run command
that Will complained about.
----------
As I got annoyed with the availability and quality of the
documentation and always wanted to write a manpage, I just took this
first step by replacing the stub text files in the Documentation
directory with a manpage.
This is clearly only the beginning, there is more functionality which
currently is not documented at all (networking comes to mind).

Cheers,
Andre.

Andre Przywara (2):
  Add a rudimentary manpage
  Documentation: remove documentation stubs and common-cmds.h generation

 .gitignore                    |   1 -
 Documentation/kvm-balloon.txt |  24 -----
 Documentation/kvm-debug.txt   |  16 ---
 Documentation/kvm-list.txt    |  16 ---
 Documentation/kvm-pause.txt   |  16 ---
 Documentation/kvm-resume.txt  |  16 ---
 Documentation/kvm-run.txt     |  62 ------------
 Documentation/kvm-sandbox.txt |  16 ---
 Documentation/kvm-setup.txt   |  15 ---
 Documentation/kvm-stat.txt    |  19 ----
 Documentation/kvm-stop.txt    |  16 ---
 Documentation/kvm-version.txt |  21 ----
 Documentation/kvmtool.1       | 226 ++++++++++++++++++++++++++++++++++++++++++
 Makefile                      |  10 --
 command-list.txt              |  15 ---
 include/common-cmds.h         |  19 ++++
 16 files changed, 245 insertions(+), 263 deletions(-)
 delete mode 100644 Documentation/kvm-balloon.txt
 delete mode 100644 Documentation/kvm-debug.txt
 delete mode 100644 Documentation/kvm-list.txt
 delete mode 100644 Documentation/kvm-pause.txt
 delete mode 100644 Documentation/kvm-resume.txt
 delete mode 100644 Documentation/kvm-run.txt
 delete mode 100644 Documentation/kvm-sandbox.txt
 delete mode 100644 Documentation/kvm-setup.txt
 delete mode 100644 Documentation/kvm-stat.txt
 delete mode 100644 Documentation/kvm-stop.txt
 delete mode 100644 Documentation/kvm-version.txt
 create mode 100644 Documentation/kvmtool.1
 delete mode 100644 command-list.txt
 create mode 100644 include/common-cmds.h

-- 
2.6.4
