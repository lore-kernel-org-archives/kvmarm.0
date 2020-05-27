Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B467CC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 06:48:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CC9B207CB
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 06:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRgGatOw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CC9B207CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50D54B1CA;
	Wed, 27 May 2020 02:48:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wSIxyqw0-9-I; Wed, 27 May 2020 02:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB39B4B1BD;
	Wed, 27 May 2020 02:48:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE234B198
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbu4EgVx0Xrs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 02:48:22 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8486B4B137
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:48:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590562102;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kiU8Ckw9a2Hcuqd8lZFrRVOihRmPVEkTFtK7IdzC5Gc=;
 b=GRgGatOwD4HcT1NMkupMpAS+5iAjZZyj+PIcDZvHFDG7aDsA5eD6z1F+XduO0F6tNcyO1J
 4s2RaHRebvpAExxg3gB9uHD0mrAAHYdZyY/Z4CQ18VCptog6NizWmrh+G/5Xf2GIgSIGT+
 SbM0LJkaWjfDwvtCROFhFv1Aqy1MDAA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-l02tdUfOPnC0EEy3Dr2f-A-1; Wed, 27 May 2020 02:48:19 -0400
X-MC-Unique: l02tdUfOPnC0EEy3Dr2f-A-1
Received: by mail-ed1-f70.google.com with SMTP id o12so9739126edj.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 23:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=kiU8Ckw9a2Hcuqd8lZFrRVOihRmPVEkTFtK7IdzC5Gc=;
 b=ZE59tE3WmA0TDQSHVyYVA/VVJvl5lFDap22aoaxnv9Q77uevy/mCdlCaf3efdd1fWA
 pMoWcCPiaRx+9rL3ZtlgCNx6nCl3r/ZV7xwZHVSmvJSJ7tdKvloRftBkD+VJc+/PIA4w
 Y/z9ZdMUYd7cXo3V3D+ZxjQLg0QXlBlB6Y05uaJjbkEZ318Ug/lGBjdSGrINwJd9H+CY
 g3h+fAXKFhHJMvAvAgfhM3KPdx3RXhJPVVrUg5TzedWzhK16YoL/h++RA0SWXwylDKui
 lmqpGlQFH3UZ/Pu5vBg1iB0+9pVOdkLxy78vzf4GKXMRQ5ekOluaTj8khWjWxPlPNMhj
 Inhg==
X-Gm-Message-State: AOAM533WghzNsjhobTxQp5JCY4jr+7EFDNgxOno+j6tSbu848Dfory3T
 sbEAd6oy6xBAxdw70e6uovNEynwpWIDOY4GXig+b2eXcBlUGy15LXKfQ9Y2wjHNHbtaSvHCcv/r
 5rml3kfbpwO99uCUJHog6dnl7
X-Received: by 2002:a17:906:aecc:: with SMTP id
 me12mr4814728ejb.525.1590562096763; 
 Tue, 26 May 2020 23:48:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/6rAflv4V1vbzjyPqiUI1Z0nCSxkC7tXsKMRLEx6UiKmtE2ofhEZoIdzpdyAWt1Z/ay+mqA==
X-Received: by 2002:a17:906:aecc:: with SMTP id
 me12mr4814688ejb.525.1590562096232; 
 Tue, 26 May 2020 23:48:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8?
 ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
 by smtp.gmail.com with ESMTPSA id ld9sm1812683ejb.30.2020.05.26.23.48.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 May 2020 23:48:15 -0700 (PDT)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
Date: Wed, 27 May 2020 08:48:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508032919.52147-10-gshan@redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi Gavin,

I definitely appreciate the work, but this is repeating most of the
mistakes done in the x86 implementation.  In particular:

- the page ready signal can be done as an interrupt, rather than an
exception.  This is because "page ready" can be handled asynchronously,
in contrast to "page not present" which must be done on the same
instruction that triggers it.  You can refer to the recent series from
Vitaly Kuznetsov that switched "page ready" to an interrupt.

- the page not present is reusing the memory abort exception, and
there's really no reason to do so.  I think it would be best if ARM
could reserve one ESR exception code for the hypervisor.  Mark, any
ideas how to proceed here?

- for x86 we're also thinking of initiating the page fault from the
exception handler, rather than doing so from the hypervisor before
injecting the exception.  If ARM leads the way here, we would do our
best to share code when x86 does the same.

- do not bother with using KVM_ASYNC_PF_SEND_ALWAYS, it's a fringe case
that adds a lot of complexity.

Also, please include me on further iterations of the series.

Thanks!

Paolo

On 08/05/20 05:29, Gavin Shan wrote:
> This supports asynchronous page fault for the guest. The design is
> similar to what x86 has: on receiving a PAGE_NOT_PRESENT signal from
> the host, the current task is either rescheduled or put into power
> saving mode. The task will be waken up when PAGE_READY signal is
> received. The PAGE_READY signal might be received in the context
> of the suspended process, to be waken up. That means the suspended
> process has to wake up itself, but it's not safe and prone to cause
> dead-lock on CPU runqueue lock. So the wakeup is delayed on returning
> from kernel space to user space or idle process is picked for running.
> 
> The signals are conveyed through the async page fault control block,
> which was passed to host on enabling the functionality. On each page
> fault, the control block is checked and switch to the async page fault
> handling flow if any signals exist.
> 
> The feature is put into the CONFIG_KVM_GUEST umbrella, which is added
> by this patch. So we have inline functions implemented in kvm_para.h,
> like other architectures do, to check if async page fault (one of the
> KVM para-virtualized features) is available. Also, the kernel boot
> parameter "no-kvmapf" can be specified to disable the feature.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/Kconfig                 |  11 +
>  arch/arm64/include/asm/exception.h |   3 +
>  arch/arm64/include/asm/kvm_para.h  |  27 +-
>  arch/arm64/kernel/entry.S          |  33 +++
>  arch/arm64/kernel/process.c        |   4 +
>  arch/arm64/mm/fault.c              | 434 +++++++++++++++++++++++++++++
>  6 files changed, 505 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 40fb05d96c60..2d5e5ee62d6d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1045,6 +1045,17 @@ config PARAVIRT
>  	  under a hypervisor, potentially improving performance significantly
>  	  over full virtualization.
>  
> +config KVM_GUEST
> +	bool "KVM Guest Support"
> +	depends on PARAVIRT
> +	default y
> +	help
> +	  This option enables various optimizations for running under the KVM
> +	  hypervisor. Overhead for the kernel when not running inside KVM should
> +	  be minimal.
> +
> +	  In case of doubt, say Y
> +
>  config PARAVIRT_TIME_ACCOUNTING
>  	bool "Paravirtual steal time accounting"
>  	select PARAVIRT
> diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
> index 7a6e81ca23a8..d878afa42746 100644
> --- a/arch/arm64/include/asm/exception.h
> +++ b/arch/arm64/include/asm/exception.h
> @@ -46,4 +46,7 @@ void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr);
>  void do_cp15instr(unsigned int esr, struct pt_regs *regs);
>  void do_el0_svc(struct pt_regs *regs);
>  void do_el0_svc_compat(struct pt_regs *regs);
> +#ifdef CONFIG_KVM_GUEST
> +void kvm_async_pf_delayed_wake(void);
> +#endif
>  #endif	/* __ASM_EXCEPTION_H */
> diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
> index 0ea481dd1c7a..b2f8ef243df7 100644
> --- a/arch/arm64/include/asm/kvm_para.h
> +++ b/arch/arm64/include/asm/kvm_para.h
> @@ -3,6 +3,20 @@
>  #define _ASM_ARM_KVM_PARA_H
>  
>  #include <uapi/asm/kvm_para.h>
> +#include <linux/of.h>
> +#include <asm/hypervisor.h>
> +
> +#ifdef CONFIG_KVM_GUEST
> +static inline int kvm_para_available(void)
> +{
> +	return 1;
> +}
> +#else
> +static inline int kvm_para_available(void)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_KVM_GUEST */
>  
>  static inline bool kvm_check_and_clear_guest_paused(void)
>  {
> @@ -11,17 +25,16 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>  
>  static inline unsigned int kvm_arch_para_features(void)
>  {
> -	return 0;
> +	unsigned int features = 0;
> +
> +	if (kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_APF))
> +		features |= (1 << KVM_FEATURE_ASYNC_PF);
> +
> +	return features;
>  }
>  
>  static inline unsigned int kvm_arch_para_hints(void)
>  {
>  	return 0;
>  }
> -
> -static inline bool kvm_para_available(void)
> -{
> -	return false;
> -}
> -
>  #endif /* _ASM_ARM_KVM_PARA_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index ddcde093c433..15efd57129ff 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -751,12 +751,45 @@ finish_ret_to_user:
>  	enable_step_tsk x1, x2
>  #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>  	bl	stackleak_erase
> +#endif
> +#ifdef CONFIG_KVM_GUEST
> +	bl	kvm_async_pf_delayed_wake
>  #endif
>  	kernel_exit 0
>  ENDPROC(ret_to_user)
>  
>  	.popsection				// .entry.text
>  
> +#ifdef CONFIG_KVM_GUEST
> +	.pushsection ".rodata", "a"
> +SYM_DATA_START(__exception_handlers_offset)
> +	.quad	0
> +	.quad	0
> +	.quad	0
> +	.quad	0
> +	.quad	el1_sync - vectors
> +	.quad	el1_irq - vectors
> +	.quad	0
> +	.quad	el1_error - vectors
> +	.quad	el0_sync - vectors
> +	.quad	el0_irq - vectors
> +	.quad	0
> +	.quad	el0_error - vectors
> +#ifdef CONFIG_COMPAT
> +	.quad	el0_sync_compat - vectors
> +	.quad	el0_irq_compat - vectors
> +	.quad	0
> +	.quad	el0_error_compat - vectors
> +#else
> +	.quad	0
> +	.quad	0
> +	.quad	0
> +	.quad	0
> +#endif
> +SYM_DATA_END(__exception_handlers_offset)
> +	.popsection				// .rodata
> +#endif /* CONFIG_KVM_GUEST */
> +
>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
>  /*
>   * Exception vectors trampoline.
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 56be4cbf771f..5e7ee553566d 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -53,6 +53,7 @@
>  #include <asm/processor.h>
>  #include <asm/pointer_auth.h>
>  #include <asm/stacktrace.h>
> +#include <asm/exception.h>
>  
>  #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
>  #include <linux/stackprotector.h>
> @@ -70,6 +71,9 @@ void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>  
>  static void __cpu_do_idle(void)
>  {
> +#ifdef CONFIG_KVM_GUEST
> +	kvm_async_pf_delayed_wake();
> +#endif
>  	dsb(sy);
>  	wfi();
>  }
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index c9cedc0432d2..cbf8b52135c9 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -19,10 +19,12 @@
>  #include <linux/page-flags.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/debug.h>
> +#include <linux/swait.h>
>  #include <linux/highmem.h>
>  #include <linux/perf_event.h>
>  #include <linux/preempt.h>
>  #include <linux/hugetlb.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/acpi.h>
>  #include <asm/bug.h>
> @@ -48,8 +50,31 @@ struct fault_info {
>  	const char *name;
>  };
>  
> +#ifdef CONFIG_KVM_GUEST
> +struct kvm_task_sleep_node {
> +	struct hlist_node	link;
> +	struct swait_queue_head	wq;
> +	u32			token;
> +	struct task_struct	*task;
> +	int			cpu;
> +	bool			halted;
> +	bool			delayed;
> +};
> +
> +struct kvm_task_sleep_head {
> +	raw_spinlock_t		lock;
> +	struct hlist_head	list;
> +};
> +#endif /* CONFIG_KVM_GUEST */
> +
>  static const struct fault_info fault_info[];
>  static struct fault_info debug_fault_info[];
> +#ifdef CONFIG_KVM_GUEST
> +extern char __exception_handlers_offset[];
> +static bool async_pf_available = true;
> +static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_data) __aligned(64);
> +static DEFINE_PER_CPU(struct kvm_task_sleep_head, apf_head);
> +#endif
>  
>  static inline const struct fault_info *esr_to_fault_info(unsigned int esr)
>  {
> @@ -717,10 +742,281 @@ static const struct fault_info fault_info[] = {
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 63"			},
>  };
>  
> +#ifdef CONFIG_KVM_GUEST
> +static inline unsigned int kvm_async_pf_read_enabled(void)
> +{
> +	return __this_cpu_read(apf_data.enabled);
> +}
> +
> +static inline void kvm_async_pf_write_enabled(unsigned int val)
> +{
> +	__this_cpu_write(apf_data.enabled, val);
> +}
> +
> +static inline unsigned int kvm_async_pf_read_reason(void)
> +{
> +	return __this_cpu_read(apf_data.reason);
> +}
> +
> +static inline void kvm_async_pf_write_reason(unsigned int val)
> +{
> +	__this_cpu_write(apf_data.reason, val);
> +}
> +
> +#define kvm_async_pf_lock(b, flags)					\
> +	raw_spin_lock_irqsave(&(b)->lock, (flags))
> +#define kvm_async_pf_trylock(b, flags)					\
> +	raw_spin_trylock_irqsave(&(b)->lock, (flags))
> +#define kvm_async_pf_unlock(b, flags)					\
> +	raw_spin_unlock_irqrestore(&(b)->lock, (flags))
> +#define kvm_async_pf_unlock_and_clear(b, flags)				\
> +	do {								\
> +		raw_spin_unlock_irqrestore(&(b)->lock, (flags));	\
> +		kvm_async_pf_write_reason(0);				\
> +	} while (0)
> +
> +static struct kvm_task_sleep_node *kvm_async_pf_find(
> +		struct kvm_task_sleep_head *b, u32 token)
> +{
> +	struct kvm_task_sleep_node *n;
> +	struct hlist_node *p;
> +
> +	hlist_for_each(p, &b->list) {
> +		n = hlist_entry(p, typeof(*n), link);
> +		if (n->token == token)
> +			return n;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void kvm_async_pf_wait(u32 token, int in_kernel)
> +{
> +	struct kvm_task_sleep_head *b = this_cpu_ptr(&apf_head);
> +	struct kvm_task_sleep_node n, *e;
> +	DECLARE_SWAITQUEUE(wait);
> +	unsigned long flags;
> +
> +	kvm_async_pf_lock(b, flags);
> +	e = kvm_async_pf_find(b, token);
> +	if (e) {
> +		/* dummy entry exist -> wake up was delivered ahead of PF */
> +		hlist_del(&e->link);
> +		kfree(e);
> +		kvm_async_pf_unlock_and_clear(b, flags);
> +
> +		return;
> +	}
> +
> +	n.token = token;
> +	n.task = current;
> +	n.cpu = smp_processor_id();
> +	n.halted = is_idle_task(current) ||
> +		   (IS_ENABLED(CONFIG_PREEMPT_COUNT) ?
> +		    preempt_count() > 1 || rcu_preempt_depth() : in_kernel);
> +	n.delayed = false;
> +	init_swait_queue_head(&n.wq);
> +	hlist_add_head(&n.link, &b->list);
> +	kvm_async_pf_unlock_and_clear(b, flags);
> +
> +	for (;;) {
> +		if (!n.halted) {
> +			prepare_to_swait_exclusive(&n.wq, &wait,
> +						   TASK_UNINTERRUPTIBLE);
> +		}
> +
> +		if (hlist_unhashed(&n.link))
> +			break;
> +
> +		if (!n.halted) {
> +			schedule();
> +		} else {
> +			dsb(sy);
> +			wfi();
> +		}
> +	}
> +
> +	if (!n.halted)
> +		finish_swait(&n.wq, &wait);
> +}
> +
> +/*
> + * There are two cases the suspended processed can't be waken up
> + * immediately: The waker is exactly the suspended process, or
> + * the current CPU runqueue has been locked. Otherwise, we might
> + * run into dead-lock.
> + */
> +static inline void kvm_async_pf_wake_one(struct kvm_task_sleep_node *n)
> +{
> +	if (n->task == current ||
> +	    cpu_rq_is_locked(smp_processor_id())) {
> +		n->delayed = true;
> +		return;
> +	}
> +
> +	hlist_del_init(&n->link);
> +	if (n->halted)
> +		smp_send_reschedule(n->cpu);
> +	else
> +		swake_up_one(&n->wq);
> +}
> +
> +void kvm_async_pf_delayed_wake(void)
> +{
> +	struct kvm_task_sleep_head *b;
> +	struct kvm_task_sleep_node *n;
> +	struct hlist_node *p, *next;
> +	unsigned int reason;
> +	unsigned long flags;
> +
> +	if (!kvm_async_pf_read_enabled())
> +		return;
> +
> +	/*
> +	 * We're running in the edging context, we need to complete
> +	 * the work as quick as possible. So we have a preliminary
> +	 * check without holding the lock.
> +	 */
> +	b = this_cpu_ptr(&apf_head);
> +	if (hlist_empty(&b->list))
> +		return;
> +
> +	/*
> +	 * Set the async page fault reason to something to avoid
> +	 * receiving the signals, which might cause lock contention
> +	 * and possibly dead-lock. As we're in guest context, it's
> +	 * safe to set the reason here.
> +	 *
> +	 * There might be pending signals. For that case, we needn't
> +	 * do anything. Otherwise, the pending signal will be lost.
> +	 */
> +	reason = kvm_async_pf_read_reason();
> +	if (!reason) {
> +		kvm_async_pf_write_reason(KVM_PV_REASON_PAGE_NOT_PRESENT +
> +					  KVM_PV_REASON_PAGE_READY);
> +	}
> +
> +	if (!kvm_async_pf_trylock(b, flags))
> +		goto done;
> +
> +	hlist_for_each_safe(p, next, &b->list) {
> +		n = hlist_entry(p, typeof(*n), link);
> +		if (n->cpu != smp_processor_id())
> +			continue;
> +		if (!n->delayed)
> +			continue;
> +
> +		kvm_async_pf_wake_one(n);
> +	}
> +
> +	kvm_async_pf_unlock(b, flags);
> +
> +done:
> +	if (!reason)
> +		kvm_async_pf_write_reason(0);
> +}
> +NOKPROBE_SYMBOL(kvm_async_pf_delayed_wake);
> +
> +static void kvm_async_pf_wake_all(void)
> +{
> +	struct kvm_task_sleep_head *b;
> +	struct kvm_task_sleep_node *n;
> +	struct hlist_node *p, *next;
> +	unsigned long flags;
> +
> +	b = this_cpu_ptr(&apf_head);
> +	kvm_async_pf_lock(b, flags);
> +
> +	hlist_for_each_safe(p, next, &b->list) {
> +		n = hlist_entry(p, typeof(*n), link);
> +		kvm_async_pf_wake_one(n);
> +	}
> +
> +	kvm_async_pf_unlock(b, flags);
> +
> +	kvm_async_pf_write_reason(0);
> +}
> +
> +static void kvm_async_pf_wake(u32 token)
> +{
> +	struct kvm_task_sleep_head *b = this_cpu_ptr(&apf_head);
> +	struct kvm_task_sleep_node *n;
> +	unsigned long flags;
> +
> +	if (token == ~0) {
> +		kvm_async_pf_wake_all();
> +		return;
> +	}
> +
> +again:
> +	kvm_async_pf_lock(b, flags);
> +
> +	n = kvm_async_pf_find(b, token);
> +	if (!n) {
> +		/*
> +		 * Async PF was not yet handled. Add dummy entry
> +		 * for the token. Busy wait until other CPU handles
> +		 * the async PF on allocation failure.
> +		 */
> +		n = kzalloc(sizeof(*n), GFP_ATOMIC);
> +		if (!n) {
> +			kvm_async_pf_unlock(b, flags);
> +			cpu_relax();
> +			goto again;
> +		}
> +		n->token = token;
> +		n->task = current;
> +		n->cpu = smp_processor_id();
> +		n->halted = false;
> +		n->delayed = false;
> +		init_swait_queue_head(&n->wq);
> +		hlist_add_head(&n->link, &b->list);
> +	} else {
> +		kvm_async_pf_wake_one(n);
> +	}
> +
> +	kvm_async_pf_unlock_and_clear(b, flags);
> +}
> +
> +static bool do_async_pf(unsigned long addr, unsigned int esr,
> +		       struct pt_regs *regs)
> +{
> +	u32 reason;
> +
> +	if (!kvm_async_pf_read_enabled())
> +		return false;
> +
> +	reason = kvm_async_pf_read_reason();
> +	if (!reason)
> +		return false;
> +
> +	switch (reason) {
> +	case KVM_PV_REASON_PAGE_NOT_PRESENT:
> +		kvm_async_pf_wait((u32)addr, !user_mode(regs));
> +		break;
> +	case KVM_PV_REASON_PAGE_READY:
> +		kvm_async_pf_wake((u32)addr);
> +		break;
> +	default:
> +		if (reason) {
> +			pr_warn("%s: Illegal reason %d\n", __func__, reason);
> +			kvm_async_pf_write_reason(0);
> +		}
> +	}
> +
> +	return true;
> +}
> +#endif /* CONFIG_KVM_GUEST */
> +
>  void do_mem_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  {
>  	const struct fault_info *inf = esr_to_fault_info(esr);
>  
> +#ifdef CONFIG_KVM_GUEST
> +	if (do_async_pf(addr, esr, regs))
> +		return;
> +#endif
> +
>  	if (!inf->fn(addr, esr, regs))
>  		return;
>  
> @@ -878,3 +1174,141 @@ void do_debug_exception(unsigned long addr_if_watchpoint, unsigned int esr,
>  	debug_exception_exit(regs);
>  }
>  NOKPROBE_SYMBOL(do_debug_exception);
> +
> +#ifdef CONFIG_KVM_GUEST
> +static int __init kvm_async_pf_available(char *arg)
> +{
> +	async_pf_available = false;
> +	return 0;
> +}
> +early_param("no-kvmapf", kvm_async_pf_available);
> +
> +static void kvm_async_pf_enable(bool enable)
> +{
> +	struct arm_smccc_res res;
> +	unsigned long *offsets = (unsigned long *)__exception_handlers_offset;
> +	u32 enabled = kvm_async_pf_read_enabled();
> +	u64 val;
> +	int i;
> +
> +	if (enable == enabled)
> +		return;
> +
> +	if (enable) {
> +		/*
> +		 * Asychonous page faults will be prohibited when CPU runs
> +		 * instructions between the vector base and the maximal
> +		 * offset, plus 4096. The 4096 is the assumped maximal
> +		 * length for individual handler. The hardware registers
> +		 * should be saved to stack at the beginning of the handlers,
> +		 * so 4096 shuld be safe enough.
> +		 */
> +		val = 0;
> +		for (i = 0; i < 16; i++) {
> +			if (offsets[i] > val)
> +				val = offsets[i];
> +		}
> +
> +		val += 4096;
> +		val |= BIT(62);
> +
> +		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
> +				     (u32)val, (u32)(val >> 32), &res);
> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn("Async PF configuration error %ld on CPU %d\n",
> +				res.a0, smp_processor_id());
> +			return;
> +		}
> +
> +		/* FIXME: Enable KVM_ASYNC_PF_SEND_ALWAYS */
> +		val = BIT(63);
> +		val |= virt_to_phys(this_cpu_ptr(&apf_data));
> +		val |= KVM_ASYNC_PF_ENABLED;
> +
> +		kvm_async_pf_write_enabled(1);
> +		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
> +				     (u32)val, (u32)(val >> 32), &res);
> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn("Async PF enable error %ld on CPU %d\n",
> +				res.a0, smp_processor_id());
> +			kvm_async_pf_write_enabled(0);
> +			return;
> +		}
> +	} else {
> +		val = BIT(63);
> +		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID,
> +				     (u32)val, (u32)(val >> 32), &res);
> +		if (res.a0 != SMCCC_RET_SUCCESS) {
> +			pr_warn("Async PF disable error %ld on CPU %d\n",
> +				res.a0, smp_processor_id());
> +			return;
> +		}
> +
> +		kvm_async_pf_write_enabled(0);
> +	}
> +
> +	pr_info("Async PF %s on CPU %d\n",
> +		enable ? "enabled" : "disabled", smp_processor_id());
> +}
> +
> +static void kvm_async_pf_cpu_reboot(void *unused)
> +{
> +	kvm_async_pf_enable(false);
> +}
> +
> +static int kvm_async_pf_cpu_reboot_notify(struct notifier_block *nb,
> +					  unsigned long code, void *unused)
> +{
> +	if (code == SYS_RESTART)
> +		on_each_cpu(kvm_async_pf_cpu_reboot, NULL, 1);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_async_pf_cpu_reboot_nb = {
> +	.notifier_call = kvm_async_pf_cpu_reboot_notify,
> +};
> +
> +static int kvm_async_pf_cpu_online(unsigned int cpu)
> +{
> +	struct kvm_task_sleep_head *b;
> +
> +	b = this_cpu_ptr(&apf_head);
> +	raw_spin_lock_init(&b->lock);
> +	kvm_async_pf_enable(true);
> +	return 0;
> +}
> +
> +static int kvm_async_pf_cpu_offline(unsigned int cpu)
> +{
> +	kvm_async_pf_enable(false);
> +	return 0;
> +}
> +
> +static int __init kvm_async_pf_cpu_init(void)
> +{
> +	struct kvm_task_sleep_head *b;
> +	int ret;
> +
> +	if (!kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) ||
> +	    !async_pf_available)
> +		return -EPERM;
> +
> +	register_reboot_notifier(&kvm_async_pf_cpu_reboot_nb);
> +	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> +			"arm/kvm:online", kvm_async_pf_cpu_online,
> +			kvm_async_pf_cpu_offline);
> +	if (ret < 0) {
> +		pr_warn("%s: Error %d to install cpu hotplug callbacks\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	b = this_cpu_ptr(&apf_head);
> +	raw_spin_lock_init(&b->lock);
> +	kvm_async_pf_enable(true);
> +
> +	return 0;
> +}
> +early_initcall(kvm_async_pf_cpu_init);
> +#endif /* CONFIG_KVM_GUEST */
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
