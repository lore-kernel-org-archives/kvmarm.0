From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 0/8] Provide the EL1 physical timer to the VM
Date: Mon, 26 Dec 2016 12:11:58 -0500
Message-ID: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69FFF40455
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fhX4wuwhIFRk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2016 12:22:52 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3A894019A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:52 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHM5nd062061
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:16 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id D7A2489
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:16 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 752E181
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:16 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHOGqD015241
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:16 -0500
Received: by mail-qt0-f198.google.com with SMTP id j29so104130126qtc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 09:24:16 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM architecture defines the EL1 physical timer and the virtual
timer, and it is reasonable for an OS to expect to be able to access
both.  However, the current KVM implementation does not provide the EL1
physical timer to VMs but terminates VMs on access to the timer.

On VHE systems, this would be as simple as allowing full access to the
EL1 physical timer to VMs because the KVM host does not use the EL1
physical timer.  However, on non-VHE systems, the KVM host already uses
the EL1 physical timer which prevents us from granting full access of
the EL1 physical timer to VMs.

This patchset enables VMs to use the EL1 physical timer through
trap-and-emulate.  The KVM host emulates each EL1 physical timer
register access and sets up the background timer accordingly.  When the
background timer expires, the KVM host injects EL1 physical timer
interrupts to the VM.  Alternatively, it's also possible to allow VMs to
access the EL1 physical timer without trapping.  However, this requires
somehow using the EL2 physical timer for the Linux host while running
the VM instead of the EL1 physical timer.  Right now I just implemented
trap-and-emulate because this was straightforward to do, and I leave it
to future work to determine if transferring the EL1 physical timer state
to the EL2 timer provides any performance benefit.

This feature will be useful for any OS that wishes to access the EL1
physical timer. Nested virtualization is one of those use cases. A
nested hypervisor running inside a VM would think it has full access to
the hardware and naturally tries to use the EL1 physical timer as Linux
would do. Other nested hypervisors may try to use the EL2 physical timer
as Xen would do, but supporting the EL2 physical timer to the VM is out
of scope of this patchset. This patchset will make it easy to add the
EL2 timer support in the future, though.

Note, Linux VMs booting in EL1 will be unaffected by this patch set and
will continue to use only the virtual timer and this patch set will
therefore not introduce any performance degredation as a result of
trap-and-emulate.

Jintack Lim (8):
  KVM: arm/arm64: Abstract virtual timer context into separate structure
  KVM: arm/arm64: Decouple kvm timer functions from virtual timer
  KVM: arm/arm64: Add the EL1 physical timer context
  KVM: arm/arm64: Initialize the emulated EL1 physical timer
  KVM: arm64: Add the EL1 physical timer access handler
  KVM: arm/arm64: Update the physical timer interrupt level
  KVM: arm/arm64: Set up a background timer for the physical timer
    emulation
  KVM: arm/arm64: Emulate the EL1 phys timer register access

 arch/arm/kvm/arm.c           |   3 +-
 arch/arm/kvm/reset.c         |   9 +-
 arch/arm64/kvm/reset.c       |   9 +-
 arch/arm64/kvm/sys_regs.c    |  63 +++++++++++++
 include/kvm/arm_arch_timer.h |  43 +++++----
 virt/kvm/arm/arch_timer.c    | 214 ++++++++++++++++++++++++++++++-------------
 virt/kvm/arm/hyp/timer-sr.c  |  16 ++--
 7 files changed, 264 insertions(+), 93 deletions(-)

-- 
1.9.1
