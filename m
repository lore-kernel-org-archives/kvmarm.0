From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/7] kvmtool: Cleanup kernel loading
Date: Fri, 30 Oct 2015 18:26:53 +0000
Message-ID: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this series cleans up kvmtool's kernel loading functionality a bit.
It has been broken out of a previous series I sent [1] and contains
just the cleanup and bug fix parts, which should be less controversial
and thus easier to merge ;-)
I will resend the pipe loading part later on as a separate series.

The first patch properly abstracts kernel loading to move
responsibility into each architecture's code. It removes quite some
ugly code from the generic kvm.c file.
The later patches address the naive usage of read(2) to, well, read
data from files. Doing this without coping with the subtleties of
the UNIX read semantics (returning with less or none data read is not
an error) can provoke hard to debug failures.
So these patches make use of the existing and one new wrapper function
to make sure we read everything we actually wanted to.
The last patch moves the ARM kernel loading code into the proper
location to be in line with the other architectures.

Please have a look and give some comments!

Find the branch on my kvmtool git tree on:
git://linux-arm.org/kvmtool.git (kern_load-v2 branch)
http://www.linux-arm.org/git?p=kvmtool.git;a=shortlog;h=refs/heads/kern_load-v2

Cheers,
Andre.

[1] http://marc.info/?l=kvm&m=143825354808135&w=2

Andre Przywara (7):
  Refactor kernel image loading
  provide generic read_file() implementation
  powerpc: use read_file() in kernel and initrd loading
  MIPS: use read wrappers in kernel loading
  x86: use read wrappers in kernel loading
  arm/arm64: use read_file() in kernel and initrd loading
  arm: move kernel loading into arm/kvm.c

 arm/fdt.c                | 99 +-----------------------------------------------
 arm/kvm.c                | 88 ++++++++++++++++++++++++++++++++++++++++++
 include/kvm/kvm.h        |  5 +--
 include/kvm/read-write.h |  2 +
 kvm.c                    | 42 ++------------------
 mips/kvm.c               | 57 ++++++++++++++++++----------
 powerpc/kvm.c            | 39 ++++++++++---------
 util/read-write.c        | 21 ++++++++++
 x86/kvm.c                | 62 +++++++++++++++---------------
 9 files changed, 207 insertions(+), 208 deletions(-)

-- 
2.5.1

