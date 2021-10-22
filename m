Return-Path: <SRS0=viiR=PK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69316C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Oct 2021 15:04:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E978561205
	for <kvmarm@archiver.kernel.org>; Fri, 22 Oct 2021 15:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E978561205
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C92140762;
	Fri, 22 Oct 2021 11:04:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tx5K+OS3yHRh; Fri, 22 Oct 2021 11:04:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DAF04B10D;
	Fri, 22 Oct 2021 11:04:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0084F40762
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Oct 2021 11:04:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RPbvHf5560tt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Oct 2021 11:04:13 -0400 (EDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D80A2405A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Oct 2021 11:04:12 -0400 (EDT)
Received: by mail-wm1-f53.google.com with SMTP id v127so3159815wme.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Oct 2021 08:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=T30FlJ5UKlkIRPt0AISR9G+L/3Q8enwrJccctT6p1g8=;
 b=MBtmLDJBwdIuSEGHsWnq13enuOMwfZw4/18uAeEnchCMIre5XYu/Vt8p/tQCYzsMop
 COAHxIk3w5JxNWzKs0XdOypZWDIIC5sFJ7ESkL1QmlSMivIp/SjRWF4do7Qy5ZEEpQot
 2zKwDwHd4DXKkSbzrAcJDcQ0n8+XwO6A2RydmoMn16Ya4tX1ZQ4jT+vP9y1HntYmUdWb
 uOg+NVoX7R+xMb3qTatR3G99+5P77NeNif+FnN9FZgOaIzhfFWIzrR1Gp+ZYjJLlI3Ow
 tPdMCc3fKgsHCPGC2/0di1W4P7SRM2YCIKidlaJVgJ5bQTcDh2TawkTyUJQS93SrKM7S
 +t/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=T30FlJ5UKlkIRPt0AISR9G+L/3Q8enwrJccctT6p1g8=;
 b=RxG03Mxfi2QMoQmNArTr9caAEcdmIQHMWZq1VAtzSFoSq1r/9uYUkoifi4u7qg7Ybm
 KNPV9cv8LS/GpWjkqFifsZ4SlvhgxBOub6oT0iuhjRGwUf2V8+6c312W9MbLuoSWga/P
 b0K6LaMeoVEGigIVE7haSM4THVakmdW7FzhLqpXeBbmKgYChEw05lUs/Tk+9b9oXx/Rw
 lDGctQUfFbFHxMJBFU27O0tI+heKOYdUFye4PEGeCVGbPtSHya8+B7TeZ7H4SKowWGRQ
 4UiAHetDzRcNzpXlq4NKPG4RUiNqAxjMzt3zrryc1ouMaICQYOyoSG/8E5k460kfh5wX
 lYOA==
X-Gm-Message-State: AOAM533Vd84Xoq8lVd66nLHhracedHxzwXISQJaB5mc+gx+Wp3budY8H
 8JSml2pO1NFSfdCgmf5OpeLIFAf7lrXYsE3GssF2EA==
X-Google-Smtp-Source: ABdhPJztGBg8weOQ78E8KVd7ncPE7BUNSaOVfTMsmKjCcFD2swST5/UMCgrVa+WC8Aj7pEdSctUqBqmByiVW+amI3bY=
X-Received: by 2002:a05:600c:354c:: with SMTP id
 i12mr277022wmq.59.1634915051483; 
 Fri, 22 Oct 2021 08:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-14-seanjc@google.com>
In-Reply-To: <20211009021236.4122790-14-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 22 Oct 2021 20:34:00 +0530
Message-ID: <CAAhSdy3QgT5PhNGqMG-m+qQ78WfAwQy2W5ENjxK3KrOJ7JGeOg@mail.gmail.com>
Subject: Re: [PATCH v2 13/43] KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
To: Sean Christopherson <seanjc@google.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 KVM General <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>,
 linux-riscv <linux-riscv@lists.infradead.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Anup Patel <anup.patel@wdc.com>,
 "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, Oct 9, 2021 at 7:43 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Rename kvm_vcpu_block() to kvm_vcpu_halt() in preparation for splitting
> the actual "block" sequences into a separate helper (to be named
> kvm_vcpu_block()).  x86 will use the standalone block-only path to handle
> non-halt cases where the vCPU is not runnable.
>
> Rename block_ns to halt_ns to match the new function name.
>
> No functional change intended.
>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

For KVM RISC-V:
Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

>  arch/arm64/kvm/arch_timer.c       |  2 +-
>  arch/arm64/kvm/arm.c              |  2 +-
>  arch/arm64/kvm/handle_exit.c      |  2 +-
>  arch/arm64/kvm/psci.c             |  2 +-
>  arch/mips/kvm/emulate.c           |  2 +-
>  arch/powerpc/kvm/book3s_pr.c      |  2 +-
>  arch/powerpc/kvm/book3s_pr_papr.c |  2 +-
>  arch/powerpc/kvm/booke.c          |  2 +-
>  arch/powerpc/kvm/powerpc.c        |  2 +-
>  arch/riscv/kvm/vcpu_exit.c        |  2 +-
>  arch/s390/kvm/interrupt.c         |  2 +-
>  arch/x86/kvm/x86.c                | 11 +++++++++--
>  include/linux/kvm_host.h          |  2 +-
>  virt/kvm/kvm_main.c               | 20 +++++++++-----------
>  14 files changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..7e8396f74010 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -467,7 +467,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  }
>
>  /*
> - * Schedule the background timer before calling kvm_vcpu_block, so that this
> + * Schedule the background timer before calling kvm_vcpu_halt, so that this
>   * thread is removed from its waitqueue and made runnable when there's a timer
>   * interrupt to handle.
>   */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1346f81b34df..268b1e7bf700 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -672,7 +672,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
>         vgic_v4_put(vcpu, true);
>         preempt_enable();
>
> -       kvm_vcpu_block(vcpu);
> +       kvm_vcpu_halt(vcpu);
>         kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>
>         preempt_disable();
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 4794563a506b..6d0baf71aa67 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -82,7 +82,7 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
>   *
>   * WFE: Yield the CPU and come back to this vcpu when the scheduler
>   * decides to.
> - * WFI: Simply call kvm_vcpu_block(), which will halt execution of
> + * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
>   * world-switches and schedule other host processes until there is an
>   * incoming IRQ or FIQ to the VM.
>   */
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..e275b2ca08b9 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -46,7 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>          * specification (ARM DEN 0022A). This means all suspend states
>          * for KVM will preserve the register state.
>          */
> -       kvm_vcpu_block(vcpu);
> +       kvm_vcpu_halt(vcpu);
>         kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>
>         return PSCI_RET_SUCCESS;
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 22e745e49b0a..b494d8d39290 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -952,7 +952,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
>         if (!vcpu->arch.pending_exceptions) {
>                 kvm_vz_lose_htimer(vcpu);
>                 vcpu->arch.wait = 1;
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>
>                 /*
>                  * We we are runnable, then definitely go off to user space to
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 6bc9425acb32..0ced1b16f0e5 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -492,7 +492,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
>
>         if (msr & MSR_POW) {
>                 if (!vcpu->arch.pending_exceptions) {
> -                       kvm_vcpu_block(vcpu);
> +                       kvm_vcpu_halt(vcpu);
>                         kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>                         vcpu->stat.generic.halt_wakeup++;
>
> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
> index ac14239f3424..1f10e7dfcdd0 100644
> --- a/arch/powerpc/kvm/book3s_pr_papr.c
> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
> @@ -376,7 +376,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>                 return kvmppc_h_pr_stuff_tce(vcpu);
>         case H_CEDE:
>                 kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>                 kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>                 vcpu->stat.generic.halt_wakeup++;
>                 return EMULATE_DONE;
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 977801c83aff..12abffa40cd9 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -718,7 +718,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
>
>         if (vcpu->arch.shared->msr & MSR_WE) {
>                 local_irq_enable();
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>                 kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>                 hard_irq_disable();
>
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index be22da157569..6a94545b99fc 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -236,7 +236,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
>                 break;
>         case EV_HCALL_TOKEN(EV_IDLE):
>                 r = EV_SUCCESS;
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>                 kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>                 break;
>         default:
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 13bbc3f73713..949bb9828aa5 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -146,7 +146,7 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,
>                 vcpu->stat.wfi_exit_stat++;
>                 if (!kvm_arch_vcpu_runnable(vcpu)) {
>                         srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> -                       kvm_vcpu_block(vcpu);
> +                       kvm_vcpu_halt(vcpu);
>                         vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>                         kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>                 }
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 520450a7956f..10bd648170b7 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1335,7 +1335,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
>         VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
>  no_timer:
>         srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> -       kvm_vcpu_block(vcpu);
> +       kvm_vcpu_halt(vcpu);
>         vcpu->valid_wakeup = false;
>         __unset_cpu_idle(vcpu);
>         vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9c23ae1d483d..e6c17bbed25c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8651,6 +8651,13 @@ void kvm_arch_exit(void)
>
>  static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  {
> +       /*
> +        * The vCPU has halted, e.g. executed HLT.  Update the run state if the
> +        * local APIC is in-kernel, the run loop will detect the non-runnable
> +        * state and halt the vCPU.  Exit to userspace if the local APIC is
> +        * managed by userspace, in which case userspace is responsible for
> +        * handling wake events.
> +        */
>         ++vcpu->stat.halt_exits;
>         if (lapic_in_kernel(vcpu)) {
>                 vcpu->arch.mp_state = state;
> @@ -9892,7 +9899,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>         if (!kvm_arch_vcpu_runnable(vcpu) &&
>             (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
>                 srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>                 vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>
>                 if (kvm_x86_ops.post_block)
> @@ -10126,7 +10133,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                         r = -EINTR;
>                         goto out;
>                 }
> -               kvm_vcpu_block(vcpu);
> +               kvm_vcpu_halt(vcpu);
>                 if (kvm_apic_accept_events(vcpu) < 0) {
>                         r = 0;
>                         goto out;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1ced2914d9ca..c2ea4004553a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -967,7 +967,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>  void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>  void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 227f6bbe0716..c13bf3367fda 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3223,17 +3223,14 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>         }
>  }
>
> -/*
> - * The vCPU has executed a HLT instruction with in-kernel mode enabled.
> - */
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  {
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>         bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>         bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>         ktime_t start, cur, poll_end;
>         bool waited = false;
> -       u64 block_ns;
> +       u64 halt_ns;
>
>         start = cur = poll_end = ktime_get();
>         if (do_halt_poll) {
> @@ -3275,7 +3272,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>                                 ktime_to_ns(cur) - ktime_to_ns(poll_end));
>         }
>  out:
> -       block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> +       /* The total time the vCPU was "halted", including polling time. */
> +       halt_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>
>         /*
>          * Note, halt-polling is considered successful so long as the vCPU was
> @@ -3289,24 +3287,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>                 if (!vcpu_valid_wakeup(vcpu)) {
>                         shrink_halt_poll_ns(vcpu);
>                 } else if (vcpu->kvm->max_halt_poll_ns) {
> -                       if (block_ns <= vcpu->halt_poll_ns)
> +                       if (halt_ns <= vcpu->halt_poll_ns)
>                                 ;
>                         /* we had a long block, shrink polling */
>                         else if (vcpu->halt_poll_ns &&
> -                                       block_ns > vcpu->kvm->max_halt_poll_ns)
> +                                halt_ns > vcpu->kvm->max_halt_poll_ns)
>                                 shrink_halt_poll_ns(vcpu);
>                         /* we had a short halt and our poll time is too small */
>                         else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -                                       block_ns < vcpu->kvm->max_halt_poll_ns)
> +                                halt_ns < vcpu->kvm->max_halt_poll_ns)
>                                 grow_halt_poll_ns(vcpu);
>                 } else {
>                         vcpu->halt_poll_ns = 0;
>                 }
>         }
>
> -       trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> +       trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_block);
> +EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
>
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
>  {
> --
> 2.33.0.882.g93a45727a2-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
