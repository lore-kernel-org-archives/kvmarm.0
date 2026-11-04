Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759279;
	b=nKoknaztcJN/XFJrqc2BpfU36GgsH61b2wBH2nzXfejTv9frrb2Dw0f0dHVNZqqsZSUH
	 YGtQVuhF9SfYl831SIVsVFqn5qB9fU4nVW0Xk+i+4RRi7j0qevCZk0Q8DU+3rZjvDjy1k
	 2Jc5eyUlJVKwJ/4cknQwqLsF1qBk6+W39rrunyP71J7cDcFj93zqoUi0xDuLfJvP7jiue
	 T7OX8YcPBls5qn1McHjLwKTl6O4bfzjT8rMU+Eg5h/0da2KdVXYoSQvJwZJRhqb8hwZDb
	 wghWljEBRm7gSu/MSO9JiTMWe7MnBAptJcc7asEUXuoxsT2TDmATd3YUE7B8hgU0s2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759279;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=r4jCs72EuhtOBTKvGiR0+q5learbp+wZHBZt+KVXQMk=;
	b=JxeASRK1eDSq9C+C2FzXEJ/QuzcLPUsq06T/ySXI58C0zcJsfQ1vNAK1+bv10ymkZkGF
	 oZRamArU4el+iRQlgzTf9UHE3XlIMsAEf1uEz9FxkZz5Y7U/+eyy+6X3radLZf8jiyR2t
	 cMQ58ybUFLJP3ctt7OERbMQCMt79Nxwy6Hmpb5b+LD2CxnAJlTQVuZhEoPDMZkSbdR7up
	 ntlVYCmQmOYsEAmGzWfh69EF9D+xxgHXdJqpBKzT2QPlgam5HZbonvzC+ZHZq3XlIXv/C
	 Lpm1w6oP38IJ/Kw+CJnYmD583EnVhSxJ8AXa62ufSEN5Ji6a2ovUonnXFi4d6fh7m4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="r/2/hGlZ";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B29606A326
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 02:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71B29606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=r/2/hGlZ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DB311595;
	Tue,  3 Nov 2026 18:27:47 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D03F3F632;
	Tue,  3 Nov 2026 18:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793759270; bh=uPS8PXWZrhiAbB8M6M7/D3ItbI2lV1sC9YDKdYIAV4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/2/hGlZGZPIceFJDaC63LXIj2sTcSmwr3B96efGXXwDfcXtRkeHNaU5jaNhWLx/C
	 u9yV8/juuF3ET9+fS7JT5tEI95jMsTrBaOpdJlbE1Dp+8sefGoHc2x2N17+MyGdujG
	 7/TjXjtQsK0ZH3Fc1+zG6SO71B3stct/6QaDtxCg=
Date: Wed, 4 Nov 2026 02:27:39 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, 
	lpieralisi@kernel.org, timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 06/16] KVM: arm64: gic-v5: Add ITS MMIO state emulation
Message-ID: <avrdx6thdaqq3p52qra3obx6w3q5p7j7nxikep7lr6bzhu32dn@vzpnfdv53l67>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-7-sascha.bischoff@arm.com>
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
In-Reply-To: <20261102194454.4086911-7-sascha.bischoff@arm.com>

Hi Sascha,

On Mon, Nov 02, 2026 at 07:44:44PM +0000, Sascha Bischoff wrote:
> In order to expose a virtual GICv5 ITS to the guest, KVM needs to
> emulate the ITS CONFIG_FRAME and its translation-control registers.
> Replace the placeholder ITS IODEV region with the GICv5 ITS register
> layout and handlers for the architected MMIO state.
> 
> Provide read/write emulation for the ITS ID registers, IIDR, AIDR,
> CR0, CR1, DT_BASER, DT_CFGR, DIDR, EIDR, invalidation registers,
> READ_EVENT, GEN_EVENT, status registers, and the RAZ/WI MMIO
> registers that KVM does not implement. Reuse the shared CoreSight
> identification-register helper so the ITS reports the same component
> identification values as the IRS.
> 
> At this stage the translation-triggering registers only record state.
> Walking the guest's DT/ITT, generating READ_EVENT results, and
> injecting GEN_EVENT LPIs are added by later commits.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its-v5.c | 415 +++++++++++++++++++++++++++++-
>  include/kvm/arm_vgic.h            |  77 ++++++
>  2 files changed, 490 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
> index 5790b029f09b6..f04161c315b78 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -6,19 +6,286 @@
> +

[...]

> +static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
> +					unsigned int len, unsigned long val)
> +{
> +	struct vgic_v5_its *its = dev;
> +	size_t offset = addr & (SZ_64K - 1);
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	switch (offset) {
> +	case GICV5_ITS_CR0:
> +		its->enabled = FIELD_GET(GICV5_ITS_CR0_ITSEN, val);
> +		return;
> +	case GICV5_ITS_CR1:
> +		its->cr1.sh = FIELD_GET(GICV5_ITS_CR1_SH, val);
> +		its->cr1.oc = FIELD_GET(GICV5_ITS_CR1_OC, val);
> +		its->cr1.ic = FIELD_GET(GICV5_ITS_CR1_IC, val);
> +		its->cr1.dt_ra = FIELD_GET(GICV5_ITS_CR1_DT_RA, val);
> +		its->cr1.itt_ra = FIELD_GET(GICV5_ITS_CR1_ITT_RA, val);
> +		return;

Should this change be ignored if its->enabled == 1?

> +	default:
> +		return;
> +	}
> +}
> +

[...]

> +
> +static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
> +					  gpa_t addr, unsigned int len,
> +					  unsigned long val)
> +{
> +	struct vgic_v5_its *its = dev;
> +	size_t offset = addr & (SZ_64K - 1);
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	switch (offset) {
> +	case GICV5_ITS_DT_CFGR:
> +		if (!its->enabled)
> +			vgic_v5_write_its_dt_reg(its, offset, val);
> +		return;
> +	case GICV5_ITS_DT_BASER:
> +	case GICV5_ITS_DT_BASER + 4:
> +		if (!its->enabled) {
> +			u64 baser = vgic_v5_read_its_dt_baser(its);
> +
> +			baser = update_64bit_reg(baser, offset & 4, len, val);
> +			vgic_v5_write_its_dt_reg(its, GICV5_ITS_DT_BASER,
> +						 baser);
> +		}
> +		return;
> +	case GICV5_ITS_INV_DEVICER:
> +		its->inv_devicer.l1 =
> +			FIELD_GET(GICV5_ITS_INV_DEVICER_L1, val);
> +		its->inv_devicer.event_id_bits =
> +			FIELD_GET(GICV5_ITS_INV_DEVICER_EVENTID_BITS, val);
> +		its->inv_devicer.i =
> +			FIELD_GET(GICV5_ITS_INV_DEVICER_I, val);
> +		return;
> +	case GICV5_ITS_DIDR:
> +	case GICV5_ITS_DIDR + 4:
> +		if (offset & 4)
> +			return;
> +		its->didr.device_id = FIELD_GET(GICV5_ITS_DIDR_DEVICEID, val);
> +		return;
> +	case GICV5_ITS_EIDR:
> +		its->eidr.event_id = FIELD_GET(GICV5_ITS_EIDR_EVENTID, val);
> +		return;
> +	case GICV5_ITS_INV_EVENTR:
> +		its->inv_eventr.l1 =
> +			FIELD_GET(GICV5_ITS_INV_EVENTR_L1, val);
> +		its->inv_eventr.itt_l2sz =
> +			FIELD_GET(GICV5_ITS_INV_EVENTR_ITT_L2SZ, val);
> +		its->inv_eventr.i = FIELD_GET(GICV5_ITS_INV_EVENTR_I, val);
> +		return;
> +	case GICV5_ITS_SYNCR:
> +	case GICV5_ITS_READ_EVENTR:
> +		return;
> +	case GICV5_ITS_GEN_EVENT_EIDR:
> +		its->gen_event_eidr.event_id =
> +			FIELD_GET(GICV5_ITS_GEN_EVENT_EIDR_EVENTID, val);
> +		return;
> +	case GICV5_ITS_GEN_EVENT_DIDR:
> +	case GICV5_ITS_GEN_EVENT_DIDR + 4:
> +		if (offset & 4)
> +			return;
> +		its->gen_event_didr.device_id =
> +			FIELD_GET(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, val);
> +		return;
> +	case GICV5_ITS_GEN_EVENTR:
> +		return;
> +	default:
> +		return;
> +	}

Aside from DT_CFGR and DT_BASER, shouldn't we also check its->enabled
for all these registers before emulating the write?

> +}
> +
>  static unsigned long vgic_v5_mmio_read_its_raz(struct kvm *kvm, void *dev,
>  					       gpa_t addr, unsigned int len)
>  {
>  	return 0;
>  }
>  
> +static unsigned long vgic_v5_its_coresight_read(struct kvm *kvm, void *dev,
> +						gpa_t addr, unsigned int len)
> +{
> +	u32 offset = addr & (SZ_64K - 1);
> +
> +	return vgic_v5_handle_guest_coresight_idreg_read(offset);
> +}
> +
>  static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
>  				      unsigned int len, unsigned long val)
>  {
> @@ -31,11 +298,153 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
>  	}
>  
>  static const struct vgic_register_region vgic_v5_its_registers[] = {
> -	REGISTER_ITS_V5_DESC(0, vgic_v5_mmio_read_its_raz,
> -			     vgic_v5_mmio_write_its_wi, KVM_VGIC_V5_ITS_SIZE,
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR1, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR2, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IIDR, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_AIDR, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_CR0, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_CR1, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_BASER,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 8,
> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_CFGR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_DIDR, vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 8,
> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_EIDR, vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_INV_EVENTR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_INV_DEVICER, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENTR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 8,
> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_STATUSR, vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNCR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),

ITS_SYNCR is an 8-byte register. (Sashiko also flagged this)

> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNC_STATUSR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_DIDR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 8,
> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_EIDR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENTR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_STATUSR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_MEC_IDR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_MEC_MECID_R, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_IDR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_PARTID_R,
> +			     vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_STATUSR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_SYNDROMER0,
> +			     vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_SYNDROMER1,
> +			     vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 8,
> +			     VGIC_ACCESS_64bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_PMGR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),

ITS_MPAM_PMGR is a 4-byte register.

Thanks,
Wei-Lin Chang

> +	/* Split the ranges so KVM_HAS_DEVICE_ATTR only reports actual registers. */
> +	REGISTER_ITS_V5_DESC(GICV5_CORESIGHT_DEVARCH,
> +			     vgic_v5_its_coresight_read,
> +			     vgic_v5_mmio_write_its_wi, 4,
> +			     VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_CORESIGHT_PIDR4,
> +			     vgic_v5_its_coresight_read,
> +			     vgic_v5_mmio_write_its_wi,
> +			     GICV5_CORESIGHT_PIDR_CIDR_SIZE,
>  			     VGIC_ACCESS_32bit),
>  };
>  

[...]
