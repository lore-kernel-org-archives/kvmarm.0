Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD67CC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:14:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41CF260F9B
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41CF260F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7104B0B3;
	Mon, 25 Oct 2021 10:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6R2+MBXAgMWD; Mon, 25 Oct 2021 10:14:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 229724B129;
	Mon, 25 Oct 2021 10:14:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2B44B0B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:14:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1wpH8C-2T4oG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:14:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138E349FB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:14:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635171247;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Y7kdLh1gAibb40dMuQ3Jh5CoyoTAW5myWxAjnl8VLiA=;
 b=U17DKI+KTqABAjexjSHwS/O/pdf5LmsUXgreVvRRPw0XBHSV+Zri1Xnz9OE1eP31Wh4UUo
 eYt+6P8ie0L3u6CQt8NKUOUdUAe7it2Fz7vnTY6TB4C6pjAHpfVKR9Tj/oJ8X04ma0OPqB
 2RMZT9bE/IeITXLvB8Hm0ZMTiFEvJVY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Of8v3bTVPG2dkfz9YFj0BQ-1; Mon, 25 Oct 2021 10:14:04 -0400
X-MC-Unique: Of8v3bTVPG2dkfz9YFj0BQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 m16-20020a056402431000b003dd2005af01so8383049edc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Y7kdLh1gAibb40dMuQ3Jh5CoyoTAW5myWxAjnl8VLiA=;
 b=DhFIzWp1aNvE5dKqnL/pSEBFmuBWfzpjDTUCqu3UrPeCF7K5F88FzizJfTtJVV5qcb
 04yR1juKFDWVDP5SRH32PLuWpLcvEDz1niddqDa6OLapQlarTSX/UQXJiipGcIWFRKdo
 cHCU0B4NW2KJ197kMynOBTmNhOEDtOj6dAKtDOhIWvmvUSu8F+qRYfYNbu2k4xFF1HBg
 zyXJqiYJOY/k3tKrVJ8KO6AJVcCnMJjUJ/QDrjR2qWQZwpo5Rany6KFWLvRjU3i2uze5
 RRWinW+oYg3eLyCqhdVkbvyLwNXUXtAxi0fHNmrgHvijLwmEno1t75JmbfKTWpwGCMid
 bPug==
X-Gm-Message-State: AOAM530cZ+7+DDWOFV7PxLf15QBINHe61uhHHeHcd6i7yoHNTGKXeTwn
 EwAGQHWZpGxi59yyx5iIRFO2WvXvPTlG0KWw/HNkAnaA6KfHvGOb7Xj59tvkNHvobCfFGPcINKW
 NPYonx/5HeSPLh3XLACVC+C3R
X-Received: by 2002:a17:906:e85:: with SMTP id
 p5mr23119720ejf.159.1635171242847; 
 Mon, 25 Oct 2021 07:14:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyK5IfFyc+7Vmg+5R4lSOcrX0+AyAPjSbxoTCpVm6PUN+AjEhEtmloYpZcfK6N2LPBhJBDCSw==
X-Received: by 2002:a17:906:e85:: with SMTP id
 p5mr23119652ejf.159.1635171242301; 
 Mon, 25 Oct 2021 07:14:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n1sm2548649edf.45.2021.10.25.07.14.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:14:01 -0700 (PDT)
Message-ID: <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
Date: Mon, 25 Oct 2021 16:13:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/10/21 04:11, Sean Christopherson wrote:
> This is basically two series smushed into one.  The first "half" aims
> to differentiate between "halt" and a more generic "block", where "halt"
> aligns with x86's HLT instruction, the halt-polling mechanisms, and
> associated stats, and "block" means any guest action that causes the vCPU
> to block/wait.
> 
> The second "half" overhauls x86's APIC virtualization code (Posted
> Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
> to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
> vCPU's rcuwait status to determine when a blocking vCPU is being put and
> reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
> stumbled across when diving into the history of arm64's (un)blocking hooks.
> 
> The x86 APICv overhaul allows for killing off several sets of hooks in
> common KVM and in x86 KVM (to the vendor code).  Moving everything to
> vcpu_put/load() also realizes nice cleanups, especially for the Posted
> Interrupt code, which required some impressive mental gymnastics to
> understand how vCPU task migration interacted with vCPU blocking.
> 
> Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
> applied without much fuss so that future versions can be x86-only.
> 
> v2:
>   - Collect reviews. [Christian, David]
>   - Add patch to move arm64 WFI functionality out of hooks. [Marc]
>   - Add RISC-V to the fun.
>   - Add all the APICv fun.
> 
> v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com
> 
> Jing Zhang (1):
>    KVM: stats: Add stat to detect if vcpu is currently blocking
> 
> Sean Christopherson (42):
>    KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in
>      guest
>    KVM: SVM: Ensure target pCPU is read once when signalling AVIC
>      doorbell
>    KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
>    KVM: Force PPC to define its own rcuwait object
>    KVM: Update halt-polling stats if and only if halt-polling was
>      attempted
>    KVM: Refactor and document halt-polling stats update helper
>    KVM: Reconcile discrepancies in halt-polling stats
>    KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch
>      hook
>    KVM: Drop obsolete kvm_arch_vcpu_block_finish()
>    KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook
>    KVM: Don't block+unblock when halt-polling is successful
>    KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
>    KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
>    KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
>    KVM: Don't redo ktime_get() when calculating halt-polling
>      stop/deadline
>    KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
>    KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states
>    KVM: Add helpers to wake/query blocking vCPU
>    KVM: VMX: Skip Posted Interrupt updates if APICv is hard disabled
>    KVM: VMX: Clean up PI pre/post-block WARNs
>    KVM: VMX: Drop unnecessary PI logic to handle impossible conditions
>    KVM: VMX: Use boolean returns for Posted Interrupt "test" helpers
>    KVM: VMX: Drop pointless PI.NDST update when blocking
>    KVM: VMX: Save/restore IRQs (instead of CLI/STI) during PI pre/post
>      block
>    KVM: VMX: Read Posted Interrupt "control" exactly once per loop
>      iteration
>    KVM: VMX: Move Posted Interrupt ndst computation out of write loop
>    KVM: VMX: Remove vCPU from PI wakeup list before updating PID.NV
>    KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
>    KVM: Drop unused kvm_vcpu.pre_pcpu field
>    KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
>    KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
>    KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
>    KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
>    KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
>    KVM: SVM: Don't bother checking for "running" AVIC when kicking for
>      IPIs
>    KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with
>      APICv)
>    KVM: Drop defunct kvm_arch_vcpu_(un)blocking() hooks
>    KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
>    KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
>      vCPU
>    KVM: VMX: Pass desired vector instead of bool for triggering posted
>      IRQ
>    KVM: VMX: Fold fallback path into triggering posted IRQ helper
>    KVM: VMX: Don't do full kick when handling posted interrupt wakeup
> 
>   arch/arm64/include/asm/kvm_emulate.h |   2 +
>   arch/arm64/include/asm/kvm_host.h    |   1 -
>   arch/arm64/kvm/arch_timer.c          |   5 +-
>   arch/arm64/kvm/arm.c                 |  60 +++---
>   arch/arm64/kvm/handle_exit.c         |   5 +-
>   arch/arm64/kvm/psci.c                |   2 +-
>   arch/mips/include/asm/kvm_host.h     |   3 -
>   arch/mips/kvm/emulate.c              |   2 +-
>   arch/powerpc/include/asm/kvm_host.h  |   4 +-
>   arch/powerpc/kvm/book3s_pr.c         |   2 +-
>   arch/powerpc/kvm/book3s_pr_papr.c    |   2 +-
>   arch/powerpc/kvm/booke.c             |   2 +-
>   arch/powerpc/kvm/powerpc.c           |   5 +-
>   arch/riscv/include/asm/kvm_host.h    |   1 -
>   arch/riscv/kvm/vcpu_exit.c           |   2 +-
>   arch/s390/include/asm/kvm_host.h     |   4 -
>   arch/s390/kvm/interrupt.c            |   3 +-
>   arch/s390/kvm/kvm-s390.c             |   7 +-
>   arch/x86/include/asm/kvm-x86-ops.h   |   4 -
>   arch/x86/include/asm/kvm_host.h      |  29 +--
>   arch/x86/kvm/lapic.c                 |   4 +-
>   arch/x86/kvm/svm/avic.c              |  95 ++++-----
>   arch/x86/kvm/svm/svm.c               |   8 -
>   arch/x86/kvm/svm/svm.h               |  14 --
>   arch/x86/kvm/vmx/nested.c            |   2 +-
>   arch/x86/kvm/vmx/posted_intr.c       | 279 ++++++++++++---------------
>   arch/x86/kvm/vmx/posted_intr.h       |  14 +-
>   arch/x86/kvm/vmx/vmx.c               |  63 +++---
>   arch/x86/kvm/vmx/vmx.h               |   3 +
>   arch/x86/kvm/x86.c                   |  55 ++++--
>   include/linux/kvm_host.h             |  27 ++-
>   include/linux/kvm_types.h            |   1 +
>   virt/kvm/async_pf.c                  |   2 +-
>   virt/kvm/kvm_main.c                  | 138 +++++++------
>   34 files changed, 413 insertions(+), 437 deletions(-)
> 

Queued 1-20 and 22-28.  Initially I skipped 21 because I didn't receive 
it, but I have to think more about whether I agree with it.

In reality the CMPXCHG loops can really fail just once, because they 
only race with the processor setting ON=1.  But if the warnings were to 
trigger at all, it would mean that something iffy is happening in the 
pi_desc->control state machine, and having the check on every iteration 
is (very marginally) more effective.

It's all theoretical, granted.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
