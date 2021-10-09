Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778DEC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:12:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E806A60F5E
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:12:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E806A60F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61C564B118;
	Fri,  8 Oct 2021 22:12:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vxV1lBGqNskW; Fri,  8 Oct 2021 22:12:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0EF4B0F1;
	Fri,  8 Oct 2021 22:12:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1664B0EC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XuqKu1NS1xXO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:12:42 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 460C34B08E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:12:42 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x15-20020a056902102f00b005ba71cd7dbfso4952326ybt.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:message-id:mime-version:subject:from:to:cc;
 bh=cS1lb71+JIYOSor7OwJgk2gnjH1VOs8uFvRzBEpw+bQ=;
 b=EYM8SrcNO1Csv5h/cAGhb86L7GGVUu/ZmEz7+V+AGrx+oVzewDqxj0wLNTU/xH6TNY
 N+FoJL8OJNuYof1Wa+yyqbM3Az9BEVljXvmvjmheCO9+baWSytH2Od7jpLSRuGkenjFq
 SWm+dSeSY1sryFqxTXdHds/BNzcbaZQxJWKJakz5ZC1hzhOUvNqg2MVhVJFcJ+pDmMyn
 Z0JnLSQRsdLSZgotZ2BYpbu02wXl1yrgFTIEju5mQmsle7w1VnuD8Dj1V67lIQ1QfN5I
 48JtSMNIe7dXvP0dpfRomToMbuDi+IDLjLvZ3UscgjGgeWh4dpuSDl952WD6dDs/gFZG
 0IwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
 :from:to:cc;
 bh=cS1lb71+JIYOSor7OwJgk2gnjH1VOs8uFvRzBEpw+bQ=;
 b=hLYfVkyz7tgc1faoiDD7e0PvfC+d+eMJ47rR3tGbS2EtMXKOK4t0JQHpTY95coTLVf
 00cWyuHnPALMMzUUeTB44+eJpm5uerPWt1FYHO8HuftOBeO1TGKyQMMH9vhHT2wFJ6E8
 ioWhDGvbKJh1ctzQU1C4gReKAvMVcajVS1OHBH8Fx7HWEddByRWSv1FEAcYztCkdBnyJ
 JuqYKF/gkJ2vtL5AkVt+E8G6fkqWfrgbz1OQpGOtE1MHijcgY0I3VDQSvyivbyVa5QxU
 bIIdKkLr2LXQpNoKIoo/qhYjYKDqCh6yo2K/nq1UAJ8TRVpP73wUx85gdfhh7JHNltyg
 UC0g==
X-Gm-Message-State: AOAM532639U1NPfVV1u7MXBv16EKrjURxBLW/ZMLRjmc77vW7xxfstkY
 7uFz4sCh/ER4qf6rFa5SqZUs/6y4qlI=
X-Google-Smtp-Source: ABdhPJzl93S733o8ZxchIrko0AydsKa+w/gF7Yyof3UCHWikEoxKTRDZmabSLPZBYZUolde90hyK7YjFH8Q=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:114a:: with SMTP id
 p10mr7381719ybu.91.1633745561743; Fri, 08 Oct 2021 19:12:41 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:11:53 -0700
Message-Id: <20211009021236.4122790-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This is basically two series smushed into one.  The first "half" aims
to differentiate between "halt" and a more generic "block", where "halt"
aligns with x86's HLT instruction, the halt-polling mechanisms, and
associated stats, and "block" means any guest action that causes the vCPU
to block/wait.

The second "half" overhauls x86's APIC virtualization code (Posted
Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
vCPU's rcuwait status to determine when a blocking vCPU is being put and
reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
stumbled across when diving into the history of arm64's (un)blocking hooks.

The x86 APICv overhaul allows for killing off several sets of hooks in
common KVM and in x86 KVM (to the vendor code).  Moving everything to
vcpu_put/load() also realizes nice cleanups, especially for the Posted
Interrupt code, which required some impressive mental gymnastics to
understand how vCPU task migration interacted with vCPU blocking.

Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
applied without much fuss so that future versions can be x86-only.

v2:
 - Collect reviews. [Christian, David]
 - Add patch to move arm64 WFI functionality out of hooks. [Marc]
 - Add RISC-V to the fun.
 - Add all the APICv fun.

v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com

Jing Zhang (1):
  KVM: stats: Add stat to detect if vcpu is currently blocking

Sean Christopherson (42):
  KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in
    guest
  KVM: SVM: Ensure target pCPU is read once when signalling AVIC
    doorbell
  KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
  KVM: Force PPC to define its own rcuwait object
  KVM: Update halt-polling stats if and only if halt-polling was
    attempted
  KVM: Refactor and document halt-polling stats update helper
  KVM: Reconcile discrepancies in halt-polling stats
  KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch
    hook
  KVM: Drop obsolete kvm_arch_vcpu_block_finish()
  KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook
  KVM: Don't block+unblock when halt-polling is successful
  KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
  KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
  KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
  KVM: Don't redo ktime_get() when calculating halt-polling
    stop/deadline
  KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
  KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states
  KVM: Add helpers to wake/query blocking vCPU
  KVM: VMX: Skip Posted Interrupt updates if APICv is hard disabled
  KVM: VMX: Clean up PI pre/post-block WARNs
  KVM: VMX: Drop unnecessary PI logic to handle impossible conditions
  KVM: VMX: Use boolean returns for Posted Interrupt "test" helpers
  KVM: VMX: Drop pointless PI.NDST update when blocking
  KVM: VMX: Save/restore IRQs (instead of CLI/STI) during PI pre/post
    block
  KVM: VMX: Read Posted Interrupt "control" exactly once per loop
    iteration
  KVM: VMX: Move Posted Interrupt ndst computation out of write loop
  KVM: VMX: Remove vCPU from PI wakeup list before updating PID.NV
  KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
  KVM: Drop unused kvm_vcpu.pre_pcpu field
  KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
  KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
  KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
  KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
  KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
  KVM: SVM: Don't bother checking for "running" AVIC when kicking for
    IPIs
  KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with
    APICv)
  KVM: Drop defunct kvm_arch_vcpu_(un)blocking() hooks
  KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
  KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
    vCPU
  KVM: VMX: Pass desired vector instead of bool for triggering posted
    IRQ
  KVM: VMX: Fold fallback path into triggering posted IRQ helper
  KVM: VMX: Don't do full kick when handling posted interrupt wakeup

 arch/arm64/include/asm/kvm_emulate.h |   2 +
 arch/arm64/include/asm/kvm_host.h    |   1 -
 arch/arm64/kvm/arch_timer.c          |   5 +-
 arch/arm64/kvm/arm.c                 |  60 +++---
 arch/arm64/kvm/handle_exit.c         |   5 +-
 arch/arm64/kvm/psci.c                |   2 +-
 arch/mips/include/asm/kvm_host.h     |   3 -
 arch/mips/kvm/emulate.c              |   2 +-
 arch/powerpc/include/asm/kvm_host.h  |   4 +-
 arch/powerpc/kvm/book3s_pr.c         |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c    |   2 +-
 arch/powerpc/kvm/booke.c             |   2 +-
 arch/powerpc/kvm/powerpc.c           |   5 +-
 arch/riscv/include/asm/kvm_host.h    |   1 -
 arch/riscv/kvm/vcpu_exit.c           |   2 +-
 arch/s390/include/asm/kvm_host.h     |   4 -
 arch/s390/kvm/interrupt.c            |   3 +-
 arch/s390/kvm/kvm-s390.c             |   7 +-
 arch/x86/include/asm/kvm-x86-ops.h   |   4 -
 arch/x86/include/asm/kvm_host.h      |  29 +--
 arch/x86/kvm/lapic.c                 |   4 +-
 arch/x86/kvm/svm/avic.c              |  95 ++++-----
 arch/x86/kvm/svm/svm.c               |   8 -
 arch/x86/kvm/svm/svm.h               |  14 --
 arch/x86/kvm/vmx/nested.c            |   2 +-
 arch/x86/kvm/vmx/posted_intr.c       | 279 ++++++++++++---------------
 arch/x86/kvm/vmx/posted_intr.h       |  14 +-
 arch/x86/kvm/vmx/vmx.c               |  63 +++---
 arch/x86/kvm/vmx/vmx.h               |   3 +
 arch/x86/kvm/x86.c                   |  55 ++++--
 include/linux/kvm_host.h             |  27 ++-
 include/linux/kvm_types.h            |   1 +
 virt/kvm/async_pf.c                  |   2 +-
 virt/kvm/kvm_main.c                  | 138 +++++++------
 34 files changed, 413 insertions(+), 437 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
