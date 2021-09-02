Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE17CC432BE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:12:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 322CF610E5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 322CF610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B37EE4B090;
	Thu,  2 Sep 2021 10:12:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GxgNWeUNJoTn; Thu,  2 Sep 2021 10:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7E94B13E;
	Thu,  2 Sep 2021 10:12:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D40DF4B133
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:12:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rLRykN952KyW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 10:12:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0144B090
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:12:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630591964;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wE6+/Vrhwq4T1/jtKU4o2cvBNu2Pj3FE7J1tJqRcmHM=;
 b=eHRKzSnigo/fESSX1Wy6Qvm8MkjaYDUEBlGEZGdiXliel31vJn8mOysbhIPXYGT89aAFx7
 WgI8dUAiSWE3njwhNKIdCampINlrH0z0DigCUANopmlxln1RZ+meFjPNUWYr1LuGSzUWux
 zph8Tia1WZJ1e2YkZ9+KMRxSJq8Y8/0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-I74jQ6dAOTW-PtfTUj1UAA-1; Thu, 02 Sep 2021 10:12:41 -0400
X-MC-Unique: I74jQ6dAOTW-PtfTUj1UAA-1
Received: by mail-wm1-f72.google.com with SMTP id
 m22-20020a7bca56000000b002e7508f3faeso759748wml.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 07:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wE6+/Vrhwq4T1/jtKU4o2cvBNu2Pj3FE7J1tJqRcmHM=;
 b=URsz6P46/LAObVKIh8FFRW/yhqUQ4cx3kd9PzMgtB60wu7nZ/VV0pUDbnkO9Qg44mh
 zlwZgUpherLw7mM1V1wLHejUYQye33GvFw9LwnKGPrkx/OyQY+FhRM10+KIFqScEKFFp
 Xtc1r+4aMiM+PjthT3Sqd+OQyrWagEHe1cluPrzpE2inl24EGAqHCkll7skFMqprO6Bb
 zfgPCEnbjTIg8FgrMR13tyVjBT0AmAgJLPbeTJE4skeGsd6INB+g7KtJKY+Sqcn/owUA
 QbpJNN0ZIPM8lR5uM4rwb7RVsgyGgnUwwPNR/9WPrV+F8hu2tjOdh3THq4tqAvpJdSYW
 R7Kg==
X-Gm-Message-State: AOAM530IADvGNr7+IQBHF5tgeZoJ/sfyyFu3TWB2zFjXVXmUlLIyNKyR
 GKK9n/levJgnwn7QmuA9XjxfjoPsoqC2NLWI/fnZBLSJxZL3nOSvlJLmb2Lvre9bNkTCEi5Lpu2
 lHLgTbGxqCciU8ytDIfpQ4hFg
X-Received: by 2002:a1c:2684:: with SMTP id m126mr3450489wmm.65.1630591960606; 
 Thu, 02 Sep 2021 07:12:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtXz3TEVH3IBGGj1EQWgvfH/dex7qONnxSgYAC6xWL5W99QDZGCYHswtmsZBxRRw6IB0pnsg==
X-Received: by 2002:a1c:2684:: with SMTP id m126mr3450340wmm.65.1630591959082; 
 Thu, 02 Sep 2021 07:12:39 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id v62sm1775380wme.21.2021.09.02.07.12.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 07:12:38 -0700 (PDT)
Date: Thu, 2 Sep 2021 16:12:37 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 04/12] KVM: arm64: selftests: Add basic support for
 arch_timers
Message-ID: <20210902141237.vdp7z2gohdh732qs@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-5-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-5-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 01, 2021 at 09:14:04PM +0000, Raghavendra Rao Ananta wrote:
> Add a minimalistic library support to access the virtual timers,
> that can be used for simple timing functionalities, such as
> introducing delays in the guest.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/include/aarch64/arch_timer.h          | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> new file mode 100644
> index 000000000000..9df5b63abc47
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Timer specific interface
> + */
> +
> +#ifndef SELFTEST_KVM_ARCH_TIMER_H
> +#define SELFTEST_KVM_ARCH_TIMER_H
> +
> +#include "processor.h"
> +
> +enum arch_timer {
> +	VIRTUAL,
> +	PHYSICAL,
> +};
> +
> +#define CTL_ENABLE	(1 << 0)
> +#define CTL_IMASK	(1 << 1)
> +#define CTL_ISTATUS	(1 << 2)
> +
> +#define msec_to_cycles(msec)	\
> +	(timer_get_cntfrq() * (uint64_t)(msec) / 1000)
> +
> +#define usec_to_cycles(usec)	\
> +	(timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
> +
> +#define cycles_to_usec(cycles) \
> +	((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
> +
> +static inline uint32_t timer_get_cntfrq(void)
> +{
> +	return read_sysreg(cntfrq_el0);
> +}
> +
> +static inline uint64_t timer_get_cntct(enum arch_timer timer)
> +{
> +	isb();
> +
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntvct_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntpct_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
> +static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_cval_el0, cval);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_cval_el0, cval);

Huh, looks like we managed to merge a backwards write_sysreg into kvm
selftests. write_sysreg in the kernel and kvm-unit-tests is (value, reg).
We should post a patch fixing that before adding more calls to it.

> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline uint64_t timer_get_cval(enum arch_timer timer)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntv_cval_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntp_cval_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
> +static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_tval_el0, tval);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_tval_el0, tval);
> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_ctl_el0, ctl);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_ctl_el0, ctl);
> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline uint32_t timer_get_ctl(enum arch_timer timer)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntv_ctl_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntp_ctl_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}

I'll have to look at the test code that uses the above functions, but I
wonder if it wouldn't be better to define two test functions, one for
vtimer and one for ptimer where the sysreg accesses are direct, rather
than all these switched wrappers.

> +
> +static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
> +{
> +	uint64_t now_ct = timer_get_cntct(timer);
> +	uint64_t next_ct = now_ct + msec_to_cycles(msec);
> +
> +	timer_set_cval(timer, next_ct);
> +}
> +
> +static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
> +{
> +	timer_set_tval(timer, msec_to_cycles(msec));
> +}

I'll also look at how these wrappers are used, since open coding them may
be OK.

Thanks,
drew

> +
> +#endif /* SELFTEST_KVM_ARCH_TIMER_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
