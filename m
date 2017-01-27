From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 00/10] Provide the EL1 physical timer to the VM
Date: Thu, 26 Jan 2017 20:04:50 -0500
Message-ID: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 086B340987
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQDi-ZJvciFl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:04:55 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F65440905
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:54 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R105BE049125
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 355D48E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 0CFF683
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:03 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R152j8011808
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:02 -0500
Received: by mail-qt0-f197.google.com with SMTP id q3so256343850qtf.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:02 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM architecture defines the EL1 physical timer and the virtual timer,
and it is reasonable for an OS to expect to be able to access both.
However, the current KVM implementation does not provide the EL1 physical
timer to VMs but terminates VMs on access to the timer.

This patch series enables VMs to use the EL1 physical timer through
trap-and-emulate.  The KVM host emulates each EL1 physical timer register
access and sets up the background timer accordingly.  When the background
timer expires, the KVM host injects EL1 physical timer interrupts to the
VM.  Alternatively, it's also possible to allow VMs to access the EL1
physical timer without trapping.  However, this requires somehow using the
EL2 physical timer for the Linux host while running the VM instead of the
EL1 physical timer.  Right now I just implemented trap-and-emulate because
this was straightforward to do, and I leave it to future work to determine
if transferring the EL1 physical timer state to the EL2 timer provides any
performance benefit.

This feature will be useful for any OS that wishes to access the EL1
physical timer. Nested virtualization is one of those use cases. A nested
hypervisor running inside a VM would think it has full access to the
hardware and naturally tries to use the EL1 physical timer as Linux would
do. Other nested hypervisors may try to use the EL2 physical timer as Xen
would do, but supporting the EL2 physical timer to the VM is out of scope
of this patch series. This patch series will make it easy to add the EL2
timer support in the future, though.

Note that Linux VMs booting in EL1 will be unaffected by this patch series
and will continue to use only the virtual timer and this patch series will
therefore not introduce any performance degredation as a result of
trap-and-emulate.

v1 => v2:
 - Rebase on kvm-arm-for-4.10-rc4
 - To make it simple, schedule the background timer for the EL1 physical timer
   emulation on every entry to the VM and cancel it on exit.
 - Change timer_context structure to have cntvoff and restore enable field back
   to arch_timer_cpu structure

Jintack Lim (10):
  KVM: arm/arm64: Abstract virtual timer context into separate structure
  KVM: arm/arm64: Move cntvoff to each timer context
  KVM: arm/arm64: Decouple kvm timer functions from virtual timer
  KVM: arm/arm64: Add the EL1 physical timer context
  KVM: arm/arm64: Initialize the emulated EL1 physical timer
  KVM: arm/arm64: Update the physical timer interrupt level
  KVM: arm/arm64: Set a background timer to the earliest timer
    expiration
  KVM: arm/arm64: Set up a background timer for the physical timer
    emulation
  KVM: arm64: Add the EL1 physical timer access handler
  KVM: arm/arm64: Emulate the EL1 phys timer register access

 arch/arm/include/asm/kvm_host.h   |   6 +-
 arch/arm/kvm/arm.c                |   3 +-
 arch/arm/kvm/reset.c              |   9 +-
 arch/arm64/include/asm/kvm_host.h |   4 +-
 arch/arm64/kvm/reset.c            |   9 +-
 arch/arm64/kvm/sys_regs.c         |  60 +++++++++++
 include/kvm/arm_arch_timer.h      |  39 ++++----
 virt/kvm/arm/arch_timer.c         | 204 ++++++++++++++++++++++++++++----------
 virt/kvm/arm/hyp/timer-sr.c       |  13 +--
 9 files changed, 261 insertions(+), 86 deletions(-)

-- 
1.9.1
