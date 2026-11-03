Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793738244;
	b=aJ7ZYQTjUQ2leuMaZyQKwFdWrb99SjtVVS7O6Tz/CaMsGVGYYQDJCMj+t8LuW5lcaZu+
	 2TVxj+ve6/JyAeMQ+fKqWiCyOwGr402Ylg4xoAAmVJwKa7VHFcc5KSYb4+VMEYet37lt3
	 nYQe3PO9CRkInpJ3RNyfgXquarbE7kSn4ycMYfV+v7nHsiN5dlQBu3rSXLI6bGeUhkqls
	 qNsJn+cVQiR5q+n9Aly2x4NsLjL3q7Q42hj2DkbEfCXxK7XNITffJCdkkeCUL02d6ze1T
	 Y/eGKUpvuy3HCYpCMBIoOrRievqjf/7NwdDha7QubA3MNNtkjEym9jCnFYz9JH/2q5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793738244;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=vWPeCnUz1sDUCuvHzgsNmQLP6HqKKH7oPoJSrsTWm8A=;
	b=z3d3pdOmAGs64XbIe4IxhZVldykGAz+YwQrbCXqWZD56Lc46OJYTdjpJ9MgJ1M/kEM58
	 8tQppJ+sT/uX7hheyr7J2T/lBP8Y2Oj63nX0BUALwX9pxE1xmomHwm4mK9oMgDJ36GF3+
	 FYI5ggpsNtRo07DmRBPKTwiqfADY9xl8WgdAPyjKWDb53CzsmRkSaxy98anzhBlcmyrqW
	 R/MmqBsgCjbaZ33P1cLN0aRZwTFvUrBpQis2Fc71PQ4CRLM1K3zJM9tpSwERmWJHcASs9
	 10p6wo/YEGWun9W1RC/Vi2X6HbzpbG/oucTWAiG/SK2+lfNQosyefEVd/2GCnian7pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WIwAUoRY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4214606A324
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 20:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F4214606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WIwAUoRY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 277021595;
	Tue,  3 Nov 2026 12:37:19 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900353F628;
	Tue,  3 Nov 2026 12:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793738242; bh=XNxs1q7RvEvtnhfmFbzH+UCtgdjM+7kwwuvH4wf38QM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WIwAUoRYbdxoJrZAO4JhML2zcaHQrSFnQStEcdCxEEz3QsJYEAS3Xx5mxpTwxHrq8
	 H/qwyh5aWqxrCkV+u4L9w3gADSoY9lDcJYkgeA4mwUXTEUcF38b216uxNICrkSVxH2
	 6STMjkgsZkkQlNJ2J+tLf5WMqhwcZMK+FlhL4hCM=
Date: Tue, 3 Nov 2026 20:37:07 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, 
	lpieralisi@kernel.org, timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 03/16] KVM: arm64: gic-v5: Share CoreSight ID register
 emulation
Message-ID: <4lhdtngikzekvcvhkd4zknnnqdh7a3mih7i72smfzwsnnjcmfh@ri2clwyj4nqm>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-4-sascha.bischoff@arm.com>
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
In-Reply-To: <20261102194454.4086911-4-sascha.bischoff@arm.com>

On Mon, Nov 02, 2026 at 07:44:41PM +0000, Sascha Bischoff wrote:
> The GICv5 IRS and ITS expose the same CoreSight identification register
> block. Move the register-value switch into a shared helper and describe
> the contiguous ID register range with one register-region descriptor.
> 
> This keeps the IRS behaviour unchanged while giving the ITS MMIO
> emulation a helper it can reuse when it is added in the following commit.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-irs-v5.c  | 75 +++---------------------------
>  arch/arm64/kvm/vgic/vgic-v5.c      | 34 ++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h         |  1 +
>  include/linux/irqchip/arm-gic-v5.h |  2 +
>  4 files changed, 44 insertions(+), 68 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-irs-v5.c
> index 8d0ad74ebc64a..d0ebed2e1663b 100644
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
> @@ -520,38 +520,9 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
>  static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
>  					    gpa_t addr, unsigned int len)
>  {
> -	const size_t offset = addr & (SZ_64K - 1);
> +	u32 offset = addr & (SZ_64K - 1);

nit: I think we can keep the const here?

>  
> -	switch (offset) {
> -	case GICV5_CORESIGHT_DEVARCH:
> -		return GICV5_CORESIGHT_DEVARCH_VAL;
> -	case GICV5_CORESIGHT_PIDR4:
> -		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
> -	case GICV5_CORESIGHT_PIDR5:
> -		return GICV5_CORESIGHT_PIDR5_RES0;
> -	case GICV5_CORESIGHT_PIDR6:
> -		return GICV5_CORESIGHT_PIDR6_RES0;
> -	case GICV5_CORESIGHT_PIDR7:
> -		return GICV5_CORESIGHT_PIDR7_RES0;
> -	case GICV5_CORESIGHT_PIDR0:
> -		return GICV5_CORESIGHT_PIDR0_PART_0;
> -	case GICV5_CORESIGHT_PIDR1:
> -		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
> -	case GICV5_CORESIGHT_PIDR2:
> -		return GICV5_CORESIGHT_PIDR2_DES_1;
> -	case GICV5_CORESIGHT_PIDR3:
> -		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
> -	case GICV5_CORESIGHT_CIDR0:
> -		return GICV5_CORESIGHT_CIDR0_VAL;
> -	case GICV5_CORESIGHT_CIDR1:
> -		return GICV5_CORESIGHT_CIDR1_VAL;
> -	case GICV5_CORESIGHT_CIDR2:
> -		return GICV5_CORESIGHT_CIDR2_VAL;
> -	case GICV5_CORESIGHT_CIDR3:
> -		return GICV5_CORESIGHT_CIDR3_VAL;
> -	default:
> -		return 0;
> -	}
> +	return vgic_v5_handle_guest_coresight_idreg_read(offset);
>  }
>  
>  static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu *vcpu,
> @@ -903,45 +874,13 @@ static const struct vgic_register_region vgic_v5_irs_registers[] = {
>  				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
>  				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  
> -	/* CoreSight identification registers */
> +	/* Split the ranges so KVM_HAS_DEVICE_ATTR only reports actual registers. */

Would "Split the CoreSight range into two to account for the gap
between DEVARCH and PIDR/CIDR registers." be clearer?

Thanks,
Wei-Lin Chang

>  	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> +				  vgic_v5_coresight_read, vgic_mmio_write_wi,
> +				  4, VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
> -				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> +				  vgic_v5_coresight_read, vgic_mmio_write_wi,
> +				  GICV5_CORESIGHT_PIDR_CIDR_SIZE,
>  				  VGIC_ACCESS_32bit),
>  };
>  

[...]
