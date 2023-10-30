Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A18199B6
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihcMVwUQ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da07b5e6f75so4948086276.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 10:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698687882; x=1699292682; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=idn/LdV4vtD6KFi3tgjviSfh6YV722ckTPaKHt83kuI=;
        b=ihcMVwUQLRpJV/ZlyD/Kj6JcVv6/QVKj/5G6YQnu0uU2duXtE2CSz11CxqBw6msRA1
         uQSed1MoHDv3NsUF3Lp1ekS5ZB20qJjmjYc7EYoU+jdFIvIm99Lsnj2qtyWwEKeavppM
         rrSbR8B0Ms0Nvjbk9OhAGPxSEE1cH3J2sVq0+UOvEj+L3UHQdTdHh/jEptisatWcuZ1k
         MI8Niajc8KtEpw79W6whjEeSnYfA86gYPwu+omKAlI8sA/4JEa13ICNB/H8/cffSP34h
         Yl26d+VdOPzCSqU4BwnQiY705qFL1l0RgS7jxTt81W1G2MJAkj/okuP+7jEX+5amq9u5
         AoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698687882; x=1699292682;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idn/LdV4vtD6KFi3tgjviSfh6YV722ckTPaKHt83kuI=;
        b=X63kG92AwFa0YgRQS2Juv/q9BWrer+xwPoHcnPLLxaW1Ng0oRuHIx7MUa8oUPybSCN
         qjMc5wBmzP5ctKhIxjErsK8n7itRHoU7PATM2E39REMe25/5YHgW/BWZ64ZaLFDbql0i
         Ia5CMpYPPeDbzB7IKt9pYLSfIfvhLmxmdG/AxIY1eEkK8B3IZCnW9QH5wy3f9k5j49Ow
         uScOUQRPIB2Yk09qgziIHjcNEuKUtts8POalSk8FQW8U6U4oOI+K3nige6PGaie4GUFo
         gwrLlyjLj95enpq9lY6JCVIRkDFp735CFqHd0gqoi/PVsfsqioGLBaEazXISmNoJsOLP
         uocw==
X-Gm-Message-State: AOJu0YzaZpzRggbNiFNrDfjESA7gzc9JlbNKlQfidLWpKCRk/rv+6luO
	/Tn0N8wpzr9Un/R75PZBtC9JEHQ3sNmBuBPpcw==
X-Google-Smtp-Source: AGHT+IFB7hq3hyYEyvOfqxVjMYr3FOMDXc/6nt3W+mjLMLoX3u9KaOlSY2ZZpo7pcaHfHXw7SVJehlJSAGRnJhvidA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1444:b0:d9a:ca20:1911 with
 SMTP id a4-20020a056902144400b00d9aca201911mr6525ybv.4.1698687882097; Mon, 30
 Oct 2023 10:44:42 -0700 (PDT)
Date: Mon, 30 Oct 2023 17:44:41 +0000
In-Reply-To: <868r7p4jcu.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 26 Oct 2023 14:13:37 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv8aouhrq.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thank you for the prompt review though the mailing list keeps you
busy. For the record, I inherited this code a while ago with the request
to make it acceptable for upstream and there was a lot of work to
do. Most of your complaints aren't originally my doing, but it's my
responsibility now.

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 28 Sep 2023 22:02:01 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "delay.h"
>> +#include "arch_timer.h"
>> +#include "gic.h"
>> +#include "vgic.h"
>> +
>> +#define msecs_to_usecs(msec)		((msec) * 1000LL)
>> +
>> +#define CVAL_MAX			~0ULL
>> +/* tval is a signed 32-bit int. */
>> +#define TVAL_MAX			INT_MAX
>> +#define TVAL_MIN			INT_MIN
>> +
>> +#define GICD_BASE_GPA			0x8000000ULL
>> +#define GICR_BASE_GPA			0x80A0000ULL

> We already have 3 tests that do their own GIC setup. Maybe it is time
> someone either make vgic_v3_setup() deal with fixed addresses, or move
> this into a helper.

That's a good idea. I can work on something like that.

>> +	ctl = timer_get_ctl(timer);
>> +	cval = timer_get_cval(timer);
>> +	cnt = timer_get_cntct(timer);
>> +	timer_condition = cnt >= cval;
>> +	istatus = (ctl & CTL_ISTATUS) && (ctl & CTL_ENABLE);
>> +	GUEST_ASSERT_EQ(timer_condition, istatus);
>> +
>> +	/* Disable and mask the timer. */
>> +	timer_set_ctl(timer, CTL_IMASK);

> What is the point of masking if the timer is disabled?

There isn't a reason to both mask and disable the timer as this function
call does. It was there when I started working on this code and I left
it alone. Does it matter?

>> +
>> +	atomic_inc(&shared_data.handled);

> You don't have any ordering between atomic operations and system
> register access. Could it be a problem?

>> +
>> +out:
>> +	gic_set_eoi(intid);
>> +}
>> +
>> +static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
>> +			 uint32_t ctl)
>> +{
>> +	atomic_set(&shared_data.handled, 0);
>> +	atomic_set(&shared_data.spurious, 0);
>> +	timer_set_cval(timer, cval_cycles);
>> +	timer_set_ctl(timer, ctl);

> Same question.

Neither operation depends on whether the other is visible. Nothing
written to the system registers depends on the shared_data recording
variables (though that global deserves a better name). And after this
the number of handled IRQs can't possibly increase again until the timer
fires again, which happens long after the timer is reset here.

>> +}
>> +
>> +static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
>> +			 uint32_t ctl)
>> +{
>> +	atomic_set(&shared_data.handled, 0);
>> +	atomic_set(&shared_data.spurious, 0);
>> +	timer_set_tval(timer, tval_cycles);
>> +	timer_set_ctl(timer, ctl);
>> +}
>> +
>> +static void set_xval_irq(enum arch_timer timer, uint64_t xval, uint32_t  
>> ctl,
>> +			 enum timer_view tv)
>> +{
>> +	switch (tv) {
>> +	case TIMER_CVAL:
>> +		set_cval_irq(timer, xval, ctl);
>> +		break;
>> +	case TIMER_TVAL:
>> +		set_tval_irq(timer, xval, ctl);
>> +		break;
>> +	default:
>> +		GUEST_FAIL("Could not get timer %d", timer);
>> +	}
>> +}
>> +
>> +/*
>> + * Should be called with IRQs masked.
>> + *
>> + * Note that this can theoretically hang forever, so we rely on having
>> + * a timeout mechanism in the "runner", like:
>> + * tools/testing/selftests/kselftest/runner.sh.
>> + */
>> +static void wait_for_non_spurious_irq(void)
>> +{
>> +	int h;
>> +
>> +	for (h = atomic_read(&shared_data.handled); h ==  
>> atomic_read(&shared_data.handled);) {
>> +		asm volatile ("wfi\n"
>> +			      "msr daifclr, #2\n"
>> +			      /* handle IRQ */
>> +			      "msr daifset, #2\n":::"memory");

> There is no guarantee that a pending interrupt would fire at the point
> where the comment is. R_RBZYL clearly state that you need a context
> synchronisation event between these two instructions if you want
> interrupts to be handled.

Understood. Thanks for pointing this out.

>> +	}
>> +}
>> +
>> +/*
>> + * Wait for an non-spurious IRQ by polling in the guest (userspace=0)  
>> or in
>> + * userspace (e.g., userspace=1 and  
>> userspace_cmd=USERSPACE_SCHED_YIELD).
>> + *
>> + * Should be called with IRQs masked. Not really needed like the wfi  
>> above, but
>> + * it should match the others.
>> + *
>> + * Note that this can theoretically hang forever, so we rely on having
>> + * a timeout mechanism in the "runner", like:
>> + * tools/testing/selftests/kselftest/runner.sh.
>> + */
>> +static void poll_for_non_spurious_irq(bool userspace, enum sync_cmd  
>> userspace_cmd)
>> +{
>> +	int h;
>> +
>> +	h = atomic_read(&shared_data.handled);
>> +
>> +	local_irq_enable();

> So half of this code is using local_irq_*(), and the rest is directly
> poking at DAIF. Amusingly enough, the two aren't even playing with the
> same set of bits.

I agree that's wrong. I don't think it makes a functional difference
since the only difference is local_irq_*() includes FIQs which are
irrelevant to the whole test, but it looks much better to be consistent.

>> +	while (h == atomic_read(&shared_data.handled)) {
>> +		if (userspace)
>> +			USERSPACE_CMD(userspace_cmd);
>> +		else
>> +			cpu_relax();
>> +	}
>> +	local_irq_disable();
>> +}
>> +
>> +static void wait_poll_for_irq(void)
>> +{
>> +	poll_for_non_spurious_irq(false, -1);

> Am I the only one who cries when seeing this -1 cast on an unsuspected
> enum, together with a flag saying "hey, I'm giving you crap
> arguments"? What was wrong having an actual enum value for it?

Don't cry. I'll fix that. I agree there should be an actual enum value.

>> +}
>> +
>> +static void wait_sched_poll_for_irq(void)
>> +{
>> +	poll_for_non_spurious_irq(true, USERSPACE_SCHED_YIELD);
>> +}
>> +
>> +static void wait_migrate_poll_for_irq(void)
>> +{
>> +	poll_for_non_spurious_irq(true, USERSPACE_MIGRATE_SELF);
>> +}
>> +
>> +/*
>> + * Sleep for usec microseconds by polling in the guest (userspace=0) or  
>> in
>> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHEDULE).
>> + */
>> +static void guest_poll(enum arch_timer test_timer, uint64_t usec,
>> +		       bool userspace, enum sync_cmd userspace_cmd)
>> +{
>> +	uint64_t cycles = usec_to_cycles(usec);
>> +	/* Whichever timer we are testing with, sleep with the other. */
>> +	enum arch_timer sleep_timer = 1 - test_timer;
>> +	uint64_t start = timer_get_cntct(sleep_timer);
>> +
>> +	while ((timer_get_cntct(sleep_timer) - start) < cycles) {
>> +		if (userspace)
>> +			USERSPACE_CMD(userspace_cmd);
>> +		else
>> +			cpu_relax();
>> +	}
>> +}
>> +
>> +static void sleep_poll(enum arch_timer timer, uint64_t usec)
>> +{
>> +	guest_poll(timer, usec, false, -1);

> More of the same stuff...

> Frankly, I even have a hard time understanding what this code is
> trying to achieve, let alone the lack of correctness from an
> architecture perspective.

I presume you are talking about the polling rather than the test as a
whole. The goal is to provide a way to wait a while so there is a way to
test functionality when interrupts are masked. Did you have any
correctness concerns besides not having proper enum values?
