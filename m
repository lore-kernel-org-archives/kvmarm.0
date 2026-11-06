Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793941236;
	b=Hqd3u3DvDwvMtG3M5kGKMXGcP5CfVDzV6uIUYXmdsazDYk37OhyFb4j7thiyiA7infv5
	 Qvm6lsWKWJAgHjciV9wJDdGHCOWygF95B3eZ/6ZbhBVQrfWY4bJ53+UBHKhnbhG/zxafG
	 XotEy3NHwCG5DgqK2XuczxDHrziSaW5vVtsJHSAhjmqegI2IgUKJtjJK5JdYELWrz4tgL
	 MtmPsnmROgsd4QITgjzbagME5WMAIJ6+NVfC1mUFwYHLZ5g5S6O69r68JKSH238KaEi5e
	 LqfUShn52bVpEYtSMhNwMhbciTpBsT57BUalulnlJ0QovgltUNPGaoaHHolZ9s8iBHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793941236;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=aNmrX4MC6Bh9Qcr+fK7YisQgvLZ4xp/IcO3qvAuBaEA=;
	b=k2j2p2sF4EzoYoL0QiceVP1q8V5pL/cQ9v9pe3ilwGUW7kuak9G1PtVa7Pl0P2ihYRfU
	 +jb7nhpgH8cq3po+PYsL2wAOWoJPkS50thTY0/Ga5pIVt5txAL7qzAiZrpfVspQh3mWHd
	 pOUmy4WRY00fXxSCGFO9xCCSY886tcFLGJFLlNbvxtSN0JTB6fWd7y453g6CqxSbqNGjq
	 A/mYjfq9AOnPIksBE6RuBMEFVh4LRzjyk9KcoE4HvLcX3axqkdaZ+2Tnh6L6VD/voV/3a
	 xbNbK6U6sXn9hkJqZPz7SIHJdHavzioLQg+MGbLcA4nNLWhKj4mPhkLRlXsjGbVZQ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KaxjhaO4;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C51606A328
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 05:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99C51606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KaxjhaO4
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FB591650;
	Thu,  5 Nov 2026 21:00:25 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3957E3F673;
	Thu,  5 Nov 2026 21:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793941228; bh=zoGeXWJG/zjj6ruzBbMLK2JJ8stAX3zjnqmT8z1h3wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KaxjhaO4zLWXGCtZ1XhvYm2z/F12nQaoh6L/amZKDbkfaUIpYg0A7vGGZGzK0Mr9m
	 /0Jttb63Rk+mKMHqyzsR+9wWlsamwgLP3JnBp1KvEeUWSPh9bSqYT6MLHptIxGfLec
	 hsZfEr+enxuk6yGmzT1JJzOUfNBKWEaJX2M6ece4=
Date: Fri, 6 Nov 2026 05:00:07 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, 
	lpieralisi@kernel.org, timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 10/16] KVM: arm64: gic-v5: Add ITS userspace register
 access
Message-ID: <tjeu7wiqhbgo3zukxjupht5jsjg7hjqgnkpivekvem3w5p4ivy@s66rdsewuqw7>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-11-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102194454.4086911-11-sascha.bischoff@arm.com>

On Mon, Nov 02, 2026 at 07:44:48PM +0000, Sascha Bischoff wrote:
> Userspace needs access to the emulated GICv5 ITS MMIO state in order
> to inspect and restore the device state around VM reset and migration.
> Expose the GICv5 ITS register frame through KVM_DEV_ARM_VGIC_GRP_ITS_REGS.
> 
> Reuse the same MMIO register descriptors used by the guest-facing
> IODEV, but apply the usual userspace access constraints: the ITS base
> address must have been configured, the register offset must map to an
> emulated ITS register, and userspace accesses must use the natural
> 32-bit or 64-bit register alignment.
> 
> Add control handling for KVM_DEV_ARM_ITS_CTRL_RESET. The reset is
> performed while all vCPUs are stopped and while holding the ITS lock,
> so it cannot race with guest MMIO updates or translation lookups. The
> reset clears guest-programmed state and cached translations while
> preserving the advertised ITS capability defaults.
> 
> Do not expose GICv5 ITS SAVE_TABLES or RESTORE_TABLES controls. For
> GICv5, the guest-owned DT and ITTs are the authoritative translation
> state, and the KVM translation cache is disposable state that can be
> rebuilt from guest memory.
> 
> Restore guest read-only IDR0-IDR2 through dedicated userspace writes,
> validating the advertised capabilities before changing them. Also
> allow userspace to restore READ_EVENT_DATAR while keeping guest writes
> to that result register ignored.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its-v5.c | 371 ++++++++++++++++++++++++++----
>  1 file changed, 322 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
> index b69a1d107c0ae..638ee47f6e27d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -688,6 +688,70 @@ static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
>  	}
>  }
>  
> +static int vgic_v5_uaccess_write_its_idr(struct kvm *kvm, void *dev,
> +					gpa_t addr, unsigned int len,
> +					unsigned long val)
> +{
> +	struct vgic_v5_its *its = dev;
> +	size_t offset = addr & (SZ_64K - 1);
> +	u64 mmfr0;
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	switch (offset) {
> +	case GICV5_ITS_IDR0:
> +		if (FIELD_GET(GICV5_ITS_IDR0_DOM, val) !=
> +		    GICV5_ITS_IDR0_DOMAIN_NON_SECURE ||
> +		    (val & ~(GICV5_ITS_IDR0_ITSID |
> +			     GICV5_ITS_IDR0_PA_RANGE | GICV5_ITS_IDR0_DOM)))
> +			return -EINVAL;
> +
> +		mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> +		if (FIELD_GET(GICV5_ITS_IDR0_PA_RANGE, val) >
> +		    cpuid_feature_extract_unsigned_field(mmfr0,
> +					ID_AA64MMFR0_EL1_PARANGE_SHIFT))
> +			return -EINVAL;
> +
> +		its->idr0.pa_range = FIELD_GET(GICV5_ITS_IDR0_PA_RANGE, val);

In addition to what Sashiko said, a pa_range change can also affect the
translation table walk, so I believe we should also invalidate the cache
here.

Thanks,
Wei-Lin Chang

> +		its->idr0.its_id = FIELD_GET(GICV5_ITS_IDR0_ITSID, val);
> +		return 0;
> +	case GICV5_ITS_IDR1:
> +		if ((val & ~(GICV5_ITS_IDR1_L2SZ |
> +			     GICV5_ITS_IDR1_ITT_LEVELS |
> +			     GICV5_ITS_IDR1_DT_LEVELS |
> +			     GICV5_ITS_IDR1_DEVICEID_BITS)) ||
> +		    FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS, val) >
> +		    VITS_V5_DEVICE_ID_BITS)
> +			return -EINVAL;
> +
> +		/*
> +		 * Userspace can change the DeviceID limit after translations have
> +		 * been cached. Drop them so the old limit cannot remain in effect.
> +		 */
> +		if (its->idr1.device_id_bits !=
> +		    FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS, val))
> +			its_cache_clear_translations(its);
> +
> +		its->idr1.device_id_bits = FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS,
> +							 val);
> +		its->idr1.dt_levels = !!(val & GICV5_ITS_IDR1_DT_LEVELS);
> +		its->idr1.itt_levels = !!(val & GICV5_ITS_IDR1_ITT_LEVELS);
> +		its->idr1.l2sz = FIELD_GET(GICV5_ITS_IDR1_L2SZ, val);
> +		return 0;
> +	case GICV5_ITS_IDR2:
> +		if ((val & ~GICV5_ITS_IDR2_EVENTID_BITS) ||
> +		    FIELD_GET(GICV5_ITS_IDR2_EVENTID_BITS, val) >
> +		    VITS_V5_EVENT_ID_BITS)
> +			return -EINVAL;
> +
> +		its->idr2.event_id_bits = FIELD_GET(GICV5_ITS_IDR2_EVENTID_BITS,
> +							 val);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static void vgic_v5_write_its_dt_reg(struct vgic_v5_its *its, size_t offset,
>  				     unsigned long val)
>  {

[...]
