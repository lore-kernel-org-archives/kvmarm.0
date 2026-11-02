Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639130;
	b=oEAZSKbVKM0BABXuOlkZCZUFJefw0IoAZKBvAWsZYwsQQX8nLGN278uZyrm3alFgsuUS
	 WMrfksrSmKlcNUUWPBVhfiy4SPbSaUqPinor1hrVi9r7yhYw4jqFQvrv7WQuaf7aG7yzJ
	 j+cPhjZdTIeGmdyObaQtEV652Jgj5JeVKGSJDBVvG50/gpbVTfHKxlFDuqiPTR+SpmeHy
	 ckIlJtw3cTUVr+JBOKoohzo9DNWKWWCuH77u4dYIn9UfDchZ9OWoh5mXmWbwVp6Il2Wq9
	 RfU4wspfc0wBLbw39Ag8Im2J+dEY1SAgnYq0LMEsVMutkUYoj84rx1eUDF/Z8qn+DyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639130;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0WR3wgBoLSsU3LdDbLxerP8Rr1mOnoG76XYi13OBxoY=;
	b=eamEJaZ8rW1hkK3y+kHM5soZ/bf3VyPNSwl0nBRB36pyo65YqlEPZ1EnsPUlkHpigBEx
	 r6A80wLFA68W/amyYMKQqyiyCcNE24s0LzZ4/7CdEtURqk2P7FShsj+F4uvV0FLdZN6ZF
	 hEyc2BcyJW0Y/PD+QYlyrxvFUznnUoj9Ga1Eu7h5LomsStxfDYzMYb3rY80HYyQ8Jlp5J
	 ttfCtKD9Ei6js9kAFXROKQMa/9vQFox4NtCI7bTG0mDvrCwMMz23ymDa3d0TDPfAk0mDp
	 kJ9tpnkuqnWvbRJ9+dsR1UExi9/Lh2dEAWNWhigAuWujdbH3ISs9lCjS5hqBQDJltJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UIuKhHPT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4906070C8E;
	Mon,  2 Nov 2026 17:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A4906070C8E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UIuKhHPT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F88D16F3;
	Mon,  2 Nov 2026 09:05:26 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97AE33F59E;
	Mon,  2 Nov 2026 09:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793639129; bh=wevMGlGeoghglbqRuT5AWlkmCXH8/4YqYli9VjBrqdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UIuKhHPTet4SnMS0sNQCwuXz8xRB+kmhOBB2l6vGYrPJDZVCGEtGLuSLh1IjrHpMk
	 ANGFWHj+qXNN1zG4EJloiG1tfTHL3OMDnSn4fSyBY8hC+sANFw2oKJUlBfg1jzBAij
	 +GGM6Sr2j4fXG1ei9RxdpJ5tXjA2vVPRRfEDvJOQ=
Message-ID: <5409c8e0-4590-4735-b06d-5074f3286dad@arm.com>
Date: Mon, 2 Nov 2026 17:05:26 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] KVM: arm64: gic-v5: Add ITS guest table translation
 emulation
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-8-sascha.bischoff@arm.com>
 <sashiko-outbox-174621@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174621@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/10/2026 17:17, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] kvm: typed INTID used directly as XArray index in vgic_add_lpi()
> - [Medium] kvm: arm64: gic-v5: Guest can bypass VITS_V5_DEVICE_ID_BITS policy cap
> - [Low] kvm: compilation failure due to mismatched types in min() macro
> --
> 
> commit c4304c740198b40a23d386e3b547cd38e75a6238
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: gic-v5: Add ITS guest table translation emulation
> 
> The GICv5 ITS consumes guest-owned translation tables. Unlike the
> GICv3 ITS, KVM does not maintain a separate software device/table
> model for GICv5 translations; the guest's DT and ITTs are the
> authoritative source of DeviceID/EventID to LPI mappings.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> [ ... ]
>> +static int get_itt(struct kvm *kvm, struct vgic_v5_its *its, u32 device_id,
>> +		   gpa_t *itt_base, bool *two_level_itt,
>> +		   unsigned int *event_id_bits, unsigned int *itt_l2sz)
>> +{
>> +	unsigned int dt_l2sz, device_id_bits;
>> +	bool two_level_dt;
>> +	gpa_t dt_base;
>> +
>> +	dt_base = its->dt_baser.addr;
>> +	two_level_dt = its->dt_cfgr.structure;
>> +	dt_l2sz = its->dt_cfgr.l2sz;
>> +	device_id_bits = its->dt_cfgr.device_id_bits;
>> +
>> +	if (device_id >= 1UL << device_id_bits) {
> 
> [Severity: Medium]
> Does this check allow the guest to bypass the VITS_V5_DEVICE_ID_BITS policy
> cap?
> 
> KVM advertises a maximum of 16 device ID bits (VITS_V5_DEVICE_ID_BITS) and a
> single-level DT in IDR1. However, when the guest writes to GICV5_ITS_DT_CFGR,
> the fields are stored directly in its->dt_cfgr without being clamped to
> these policy limits.
> 
> Since this out-of-bounds check compares against the un-clamped guest value
> instead of the VITS_V5_DEVICE_ID_BITS cap, the guest could configure a
> 2-level DT and process Device IDs up to 31 bits, bypassing the advertised
> policy cap.

Ah, oops. Yes, this was a real issue!

I've changed the lookup to use the smaller of the two Device ID bit 
values - we cap at KVM's limit, and otherwise use what is set in the 
register. Additionally, we clear any cached translations if userspace 
changes the IDR1 limit.

> 
>> +		kvm_debug("Device ID out of range\n");
>> +		return -E2BIG;
>> +	}
> [ ... ]
>> +static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
>> +			       unsigned int itt_l2sz, __le64 *itt_l2_entry)
>> +{
> [ ... ]
>> +	itt_l2_base = FIELD_GET(GICV5_ITTL1E_L2_ADDR_MASK, val) << 3;
>> +	l2_event_id_bits =
>> +		min(FIELD_GET(GICV5_ITTL1E_SPAN, val), itt_split_bits);
> 
> [Severity: Low]
> Will this min() macro invocation cause a compilation failure due to mismatched
> types?
> 
> The arguments to min() are FIELD_GET(GICV5_ITTL1E_SPAN, val) and
> itt_split_bits. val is a 64-bit u64, making the FIELD_GET evaluation an
> unsigned long long, while itt_split_bits is a 32-bit unsigned int.
> 
> The Linux kernel's min() macro enforces strict type equality and will cause
> a build failure when comparing a 64-bit and 32-bit type. Could we use min_t()
> here instead to resolve the mismatch?

Both arguments to min() are unsigned, so the kernel’s min() type check 
accepts them even though they have different widths. IMO, there’s no 
need to use min_t() here, so I’ve left the code unchanged.

> 
>> +	l2_event_id = event_id % (1UL << l2_event_id_bits);
> [ ... ]
>> +static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
>> +				     u32 device_id, u16 event_id,
>> +				     struct vgic_irq **irq)
>> +{
> [ ... ]
>> +	val = le64_to_cpu(itt_l2_entry);
>> +	if (!FIELD_GET(GICV5_ITTL2E_VALID, val)) {
>> +		kvm_debug("ITTE is not valid\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	lpi = FIELD_GET(GICV5_ITTL2E_LPI_ID, val);
>> +
>> +	*irq = vgic_add_lpi(kvm, vgic_v5_make_lpi(lpi), NULL);
> 
> [Severity: High]
> Does this pass a fully typed INTID directly to vgic_add_lpi()?
> 
> Here, the hardware LPI ID is extracted and converted to a full typed INTID
> using vgic_v5_make_lpi(), which sets the GICv5 type bits in the upper nibble.
> This typed INTID is passed to vgic_add_lpi(), which then uses it directly
> as the array index for the lpi_xa XArray:
> 
> arch/arm64/kvm/vgic/vgic.c:vgic_add_lpi() {
>      ...
> 	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
>      ...
> }
> 
> Using a typed INTID as an array index violates the GICv5 architectural rule
> to strip type bits before indexing. It forces the XArray to allocate
> unnecessary depth to reach indices over 1 billion, leading to memory waste
> and incorrect type dispatch separation.

"GICv5 architectural rule to strip type bits before indexing" Uh, what rule?

We use the *typed* INTID as the key, including lookup and removal. GICv5 
is not the same as GICv2/3, so we need this type identifier to know that 
an LPI is an LPI. The LPI XArray is sparse, so the high index does not 
allocate all preceding entries, but it will allocate a little more to 
facilitate the lookup.

To quote the ZArray docs:

"The XArray implementation is efficient when the indices used are 
densely clustered"

This is exactly what we end up with here. All LPIs share the same top 
Type bits, and hence are densely clustered (unless the guest does 
strange things, and then we can't win anyhow!).

I've not changed anything here.

> 
>> +	if (IS_ERR(*irq))
>> +		return PTR_ERR(*irq);
>> +
>> +	return 0;
>> +}
> 

Thanks,
Sascha
