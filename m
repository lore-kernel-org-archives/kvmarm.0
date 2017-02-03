From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v4 00/10] Provide the EL1 physical timer to the VM
Date: Fri,  3 Feb 2017 10:19:58 -0500
Message-ID: <1486135208-13415-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E48E14096E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 10:19:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NEqIFWxpMn3z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 10:19:48 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0708C40284
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 10:19:47 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v13FI7BM025845
 for <kvmarm@lists.cs.columbia.edu>; Fri, 3 Feb 2017 10:20:12 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B65A981
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 10:20:12 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 21D8A82
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 10:20:11 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v13FKALY046585
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 3 Feb 2017 10:20:11 -0500
Received: by mail-qk0-f198.google.com with SMTP id d201so637926qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 07:20:11 -0800 (PST)
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
trap-and-emulate only on arm64. The KVM host emulates each EL1 physical
timer register access and sets up the background timer accordingly.  When
the background timer expires, the KVM host injects EL1 physical timer
interrupts to the VM.  Alternatively, it's also possible to allow VMs to
access the EL1 physical timer without trapping.  However, this requires
somehow using the EL2 physical timer for the Linux host while running the
VM instead of the EL1 physical timer.  Right now I just implemented
trap-and-emulate because this was straightforward to do, and I leave it to
future work to determine if transferring the EL1 physical timer state to
the EL2 timer provides any performance benefit.

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

v3 => v4:
 - Fix a bug that prevents a VM from booting on 32-bit architecture
 - Clarify that the emulated physical timer is only supported on arm64
   in the cover letter

v2 => v3:
 - Rebase on kvmarm/queue
 - Take kvm->lock to synchronize cntvoff across all vtimers
 - Remove unnecessary function parameters
 - Add comments

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
  KVM: arm/arm64: Emulate the EL1 phys timer registers

 arch/arm/include/asm/kvm_host.h   |   3 -
 arch/arm/kvm/arm.c                |   4 +-
 arch/arm/kvm/reset.c              |   9 +-
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/reset.c            |   9 +-
 arch/arm64/kvm/sys_regs.c         |  65 +++++++++++++
 include/kvm/arm_arch_timer.h      |  39 ++++----
 virt/kvm/arm/arch_timer.c         | 200 ++++++++++++++++++++++++++------------
 virt/kvm/arm/hyp/timer-sr.c       |  13 +--
 9 files changed, 249 insertions(+), 96 deletions(-)

-- 
1.9.1
