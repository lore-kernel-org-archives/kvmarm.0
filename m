Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491276;
	b=uwU7x0zCSclB2gc/gHzteQDoBPfaU+p/93rydjCuFjWtCnNPIMKY2lWVF6sNNOTjxQ9A
	 R18II+Fx6T10vuH6r4kSs5qxkbvfZa01PKfHeG2E/ZE2bTcaj7J4sR/UOtbSobCYTbu2o
	 +hPok1gk9NgBifNVjAOIpcZPOdFqHz1dLl4iL5OlopFAiTqM+O9Z4AK7P7Mk+18rDryDX
	 DGJdFeKwWUvdJThG2fmL90ddPphi/SwhlhscPOZMj1qpbQZuxlc+ZDryrsomzVikNzQrp
	 J2QH6eKW/xt2baIZIoJMbdOnAEeDX/+7TJSZA/qZzdvBPnsbRRzfE3Ri5g53QMAGuJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491276;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LnK819qJp0xv5xUqZiia/owkuvJXj5/I8hwEXIAmGIk=;
	b=FqhxO171BtKleC7EZy6OO5TO7pt6IScY3Q21aGqaZ/TE3PfABDxbBE9TORSDl5dGuiO8
	 eZcSNTFWUrloHGao4tIq5ZtUhld3CyD8uoyuSnThfwHgPElvn9gK2rkiQlRMYxHqtsofE
	 /iiHE6AYvLdTREQzq607Fh7dh+i2RWbt9NK5GriXVuf2gGdiK6No8VrgQIOX8Z/ZrC4fK
	 C1AXsGNhzDBXZRJVfgteN3zyepRW3AcFTiOgC8BZreh5k2+hb+fyz0u8WbwcavEWMsSNR
	 CkADsc6jeM0VbXxJCTfU0cYyb5Pf/K3+B+KYj322MiCll6U+japWbmhImuABil3HHiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OkUpyUCC;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39563606A31C;
	Thu, 12 Nov 2026 13:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39563606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OkUpyUCC
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 748C51477;
	Thu, 12 Nov 2026 05:47:51 -0800 (PST)
Received: from [10.0.129.47] (e122027.cambridge.arm.com [10.0.129.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A003F3F632;
	Thu, 12 Nov 2026 05:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794491274; bh=cNgEVgFO1jT1N6Afjj4PzPTHSvSJn3tCiGLPCSFHHT0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OkUpyUCC0KjC/AJtGXL+QZ6TSgsGbjuPOblgRkJ9zP2rfH2y1Yt38iMNFDdSj4cNh
	 zmdGB1nlX9BkWO+Y7Gp/j3KhfxH5jFaUpgGpsx8yrcDtlTXfloMdf1j6kKJYg1ToX7
	 qjIAFhzlrAQrd970PFTOeZ3Iusl8Aj2X7Tli3B8s=
Message-ID: <045b0a66-55d1-4939-95aa-65dde0cb08a1@arm.com>
Date: Thu, 12 Nov 2026 13:47:51 +0000
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
Subject: Re: [PATCH v2 07/12] KVM: arm64: CCA: Tear down RTTs
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-8-steven.price@arm.com>
 <sashiko-outbox-209425@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-209425@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/11/2026 17:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Low] KVM: arm64: possible skipped parent retry in
>   realm_tear_down_rtt_level()
> - [Low] KVM: arm64: cca: leak of realm->sro on error returns in
>   kvm_destroy_realm()
> --
> 
> commit 9b5e6ebefa08ce4aff4f7ddec8f9b62647e79039
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Tear down RTTs
> 
> This commit adds stage-2 unmapping and RTT destruction for CCA Realms,
> walking and undelegating non-root RTTs before destroying the Realm
> Descriptor.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 69c628cfb6c74..b904e6541fb07 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> 
> [ ... ]
> 
>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>> +				     unsigned long start, unsigned long end)
>> +{
>> +	ssize_t map_size;
>> +	unsigned long addr, next_addr;
>> +
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return -EINVAL;
>> +
>> +	map_size = rmi_rtt_level_mapsize(level - 1);
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		long ret;
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		if (next_addr > end || align_addr != addr) {
>> +			/*
>> +			 * The target range is smaller than what this level
>> +			 * covers, recurse deeper.
>> +			 */
>> +			ret = realm_tear_down_rtt_level(realm,
>> +							level + 1,
>> +							addr,
>> +							min(next_addr, end));
>> +			if (ret)
>> +				return ret;
>> +			continue;
>> +		}
>> +
>> +		ret = realm_rtt_destroy(realm, addr, level,
>> +					&rtt_granule, &next_addr);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			free_rtt(rtt_granule);
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (next_addr > addr) {
>> +				/* Missing RTT, skip */
>> +				break;
>> +			}
>> +			/*
>> +			 * We tear down the RTT range for the full IPA
>> +			 * space, after everything is unmapped. Also we
>> +			 * descend down only if we cannot tear down a
>> +			 * top level RTT. Thus RMM must be able to walk
>> +			 * to the requested level. e.g., a block mapping
>> +			 * exists at L1 or L2.
>> +			 */
>> +			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
>> +				return -EBUSY;
> 
> [Severity: Low]
> Can SMC_RMI_RTT_DESTROY return RMI_ERROR_RTT with next_addr > addr (and
> next_addr < addr + map_size) when the target RTT at level has non-live
> initial entries followed by a live child table entry, or does the walk
> terminate at level - 1?  This rests on an RMM specification detail for
> SMC_RMI_RTT_DESTROY that could not be confirmed from the kernel source.

This is ruled out by the spec. The only situation for RMI_ERROR_RTT with
top > ipa is the "Missing RTT" case.

[Note I have noticed the rendering in the PDF spec is broken with ">"
not appearing - I've raised this internally]

> If RMM returns RMI_RESULT_DATA_LEVEL(ret) == level with addr < next_addr <
> addr + map_size, the next_addr > addr check treats the live RTT as missing
> and advances addr to the unaligned next_addr.  The next iteration sees
> align_addr != addr, tears down the remaining child RTTs at level + 1, and
> executes continue, advancing to the next map_size boundary without retrying
> realm_rtt_destroy() on the parent RTT at level.  Alternatively, if the walk
> terminates at the parent entry and returns RMI_RESULT_DATA_LEVEL(ret) ==
> level - 1 with next_addr == addr, WARN_ON(RMI_RESULT_DATA_LEVEL(ret) !=
> level) triggers and aborts teardown with -EBUSY, leaving the RD and RTTs
> leaked.
> 
> [ ... ]
> 
>> @@ -29,12 +206,24 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  
>>  	kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>  
>> +	/*
>> +	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
>> +	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
>> +	 * and destroy any non-root RTTs before tearing down the RD. The root
>> +	 * RTT pages are still owned by the RMM at this point, so keep the KVM
>> +	 * pgtable alive until after REALM_DESTROY and undelegation.
>> +	 */
>> +	realm_unmap_stage2(kvm);
>> +
>>  	if (realm->rd) {
>>  		phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>  
>>  		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>>  			return;
>>  
>> +		if (WARN_ON(realm_destroy_rtts(kvm)))
>> +			return;
>> +
>>  		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>>  			return;
>>  		rmi_free_delegated_page(rd_phys);
> 
> [Severity: Low]
> Does returning early on failure in realm_destroy_rtts() (or the surrounding
> RMI teardown calls) leak realm->sro?  Unlike realm->rd and the stage-2 PGD
> pages, realm->sro is host-owned heap memory that is never delegated to the
> RMM, and kfree(realm->sro) at the end of kvm_destroy_realm() is skipped on
> these early returns.

Technically correct. Although all these early returns are WARN_ON()
cases so Should Never Happen™. Still I guess I can handle this by a
"goto out_free_sro" case rather than a straight return.

Steve

