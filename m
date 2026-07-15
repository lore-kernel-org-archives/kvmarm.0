Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03A52E7383
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123338; cv=none; b=X3POJpm16syUAx0rVo9VInG+3fjef+d6RBevE/tKVWzssoVY2Rcx2atbPIU8d1+hwtQom/espItjWyVVCtmc5JCHFsg6sTXNVaCJmTodn5QP4NaHvfDZ3zDFFwEDrmnGQP1SRviELJsECdxkZd8fuYF+Hb1Op5DT5mvxYc+xN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123338; c=relaxed/simple;
	bh=R31e1SoerTZ8of3ARHekbq4thNd6ZQJ/0j9Rx7xDzHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9jiAsVBHPIEn8OGuMZWSKAsZyZJOTTXOI4nmRWWS8Jw5vq+2Z9M2l2M4giwfX1BtrEL5jZEwxH32aMTWuS9dK/eCcNRdp9iubHuRbK6WjMhHCYgaNrtVkipUWWJSvOme0lrS+BL0FjEwXOc0TeImRMBoJPdziw6QtT89e6D7XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YOvMpb7s; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YOvMpb7s"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47dec32798aso5666298f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784123335; x=1784728135; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OSkZawG7pcsTcJF66DLNdFJcFWhB9tSjWpIVbvD9zzY=;
        b=YOvMpb7sB2EPe6LV4cwBWS7/1K1ad4TRXd4hEWjoBveZZ1p2y2tGuNu7nCRVZetwAn
         csH+orU52eghmmR5w/S0PxrVMtoRacZpj/fiwQOiMY3tn58E2Z6SFjJnMFhztGexkEGk
         xTaKQozv+1B3xNg5oU93I9Vt1R3SmxRdRRUJQSMAoex8s0mCTYJJ788tRtWbWVbB2V2P
         /tvWWV4qm48smzJKQvSbDypq15J9BIVOabmllEzbRjsfFBDvaG2S/FbVOJppw5N4okWC
         Q/2pRnljE6bfSKDZtakV3fv/mgnbr5V1yEQWFOj560pb8a85Ueeq+7jNt498k/r1FcKM
         Z2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784123335; x=1784728135;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSkZawG7pcsTcJF66DLNdFJcFWhB9tSjWpIVbvD9zzY=;
        b=RHN+addeZP0ROxfdc29nPyfjeke5TOHI7L3T8R1//dPhVojLQ4fes7n7UPk9wsDWv5
         /ff9thMqYQ4gjU5gAQD4MjQ5J/C5WMLNetW8mx6qCkSkfC4RrBSH4jGcI3Yqysby15gj
         Mrjasi54l2JrNU0ojj9XegSIeXEEbSlp847tR71ptpuiKPqQRup6U7nlpvPuDYwU1NhQ
         3g0BL42PXK6fA2+SfbvmqURbjdzGwB342yqCJ7SAzUyK+Dwq71yzJ8ZKxvFrp6xOd/Qv
         KKUPJI0Oo4BkdqjHK12+pExdTETxO4iVsOzwiDBS2qjFOuRXyQ7D4WtjUxXfDwQtQnes
         lZaw==
X-Forwarded-Encrypted: i=1; AHgh+RruDzW1pqen3DvissX5Sxkw1Scw30ZUPSwq2EwFk/QhAyAA/t6FcU5U/EaCIB0uMU7doqh3PaQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywi+BN2NYqnV6qIKkIxleIMWP1wnlCniVN+5Qp9AcI6plIDM0lZ
	vFQ+RDMZ1jPVdeBmeSIfuXZiCIFGB3n9VWyU4dlQbhjpePG+kSXLEr/GDGGZ+B1U0A==
X-Gm-Gg: AfdE7clhg+j5Opy3ZdlxfChhMBpo2EvFTXlfIyq6wPxhOIuXjMI2bp1L3qgQdz1cFku
	0Bx2iDo5brVIb0DtGiIGt316WhrnVGQeeZ6fj8GwMPUWNvuSabHJOdabo3df2HH+IR4j57czRK2
	LCblaAylqvTglyC+QV5qfY1JFL03/VilQm2+L788GPPxWQj951Um95qxj961BfJq5cFQ+ORODXt
	FdT8KxUxzJpSDj7n6J79LHGJx4cWrqQHnhTSr395mCHPPFrIHHWmbd9GXz6PrmW0kA3z0Ju6LBc
	h74JHsmgN44FKYgyBMmI2l3BJpMDp/zYFY848gVhFYKvRD61SS8nGCOPbVdstNmMxpCPf4R9830
	vE/TspoEA/pqqtpTOGaCDHo/8lv5iai7A2BdDMgwe4RYYKS1dA9uMaCq0alfw8kuAJdXOiQ3usk
	QhbPQGuhaX90iKbOcJP8nBHhzosBLfmGzAk0tbVuDlZhsfzX/laBU=
X-Received: by 2002:a05:6000:491a:b0:473:24e3:fa8f with SMTP id ffacd0b85a97d-47f488a7656mr7712739f8f.47.1784123334603;
        Wed, 15 Jul 2026 06:48:54 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f476e9d02sm16837588f8f.19.2026.07.15.06.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 06:48:53 -0700 (PDT)
Date: Wed, 15 Jul 2026 14:48:50 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 01/24] KVM: arm64: Add a generic clock
Message-ID: <alePwq2eKV5g_7Gc@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715115906.2664882-2-smostafa@google.com>

[...]

> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
> index f3e2619db4e4..43d2cba4f810 100644
> --- a/arch/arm64/kvm/hyp/nvhe/clock.c
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -8,7 +8,12 @@
>  
>  #include <asm/arch_timer.h>
>  #include <asm/div64.h>
> +#include <linux/math64.h>
> +#include <vdso/time64.h>
>  
> +static u32 timer_freq;
> +
> +#ifdef CONFIG_NVHE_EL2_TRACING
>  static struct clock_data {
>  	struct {
>  		u32 mult;
> @@ -66,3 +71,27 @@ u64 trace_hyp_clock(void)
>  
>  	return (u64)ns + clock->data[bank].epoch_ns;
>  }
> +#endif /* CONFIG_NVHE_EL2_TRACING */
> +
> +int hyp_clock_init(void)
> +{
> +	timer_freq = read_sysreg(cntfrq_el0);
> +	/*
> +	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
> +	 * part of the boot protocol.
> +	 */
> +	if (!timer_freq)
> +		return -ENODEV;
> +
> +	/* Timer freq can't be larger than 1Ghz by spec. */
> +	if (timer_freq > NSEC_PER_SEC)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/* Return time in ns. */
> +u64 hyp_clock_ns(void)
> +{
> +	return mul_u64_u32_div(__arch_counter_get_cntvct(), NSEC_PER_SEC, timer_freq);

IIUC, this will overflow the u64 mult very quickly (in few minutes) and also I
see that we don't need such small nanoseconds accuracy.

So here we could always fallback to 128-bits mult... or update the epoch from
time to time. But I have something completely different to propose:

Instead of using a "clock" how about we just modify smmu_wait?

#define smmu_wait() {
    static u32 window = arch_timer_get_cntfrq() / ARM_SMMU_EL2_POLL_TIMEOUT_US
    u64 timeout = __arch_counter_get_cntvct() + window;
    u64 cur;

    ...

    while (!(__cond)) {
      ...

      cur = __arch_counter_get_cntvct();
      if (cur >= timeout)
          __ret = -ETIMEOUT;


No risk of overflowing u64
No init necessary


> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 75b00c323310..970c5cf342f5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -10,6 +10,7 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/kvm_pkvm.h>
>  
> +#include <nvhe/clock.h>
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/ffa.h>
>  #include <nvhe/gfp.h>
> @@ -320,6 +321,10 @@ void __noreturn __pkvm_init_finalise(void)
>  	if (ret)
>  		goto out;
>  
> +	ret = hyp_clock_init();
> +	if (ret)
> +		goto out;
> +
>  	ret = fix_host_ownership();
>  	if (ret)
>  		goto out;
> -- 
> 2.55.0.141.g00534a21ce-goog
> 
