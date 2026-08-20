Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954904399CE
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 11:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226221; cv=none; b=RC7GoH/6SX6dB95ssVvKQVw+d9UbdFmv3w1nNUFv0nL/pgCdgAQZm1o85daE1GS2SWl3QV56cWSl7F5pUSQpt88xshyQLeqFZKEeS8XzpLedDwmb2avM7wzLSUaiuojwvjUdPoiDHhZ+SYp2LrO0P73E5Qsv+FjwLhuJjbITM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226221; c=relaxed/simple;
	bh=lvZYAJXXKS9ME9YUmcZXLGRDZwZWc0ZoPKd6SW1fF8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oe2QkoRz6hEZGDIoZmFkBt8CUj74BhYHK84f03tPfVqwWLHGG4x/vA0I3dVI0Zwx1ARSXR//qIUcFEceSFYX0JHmW/DY2g0uqcwLDpbhTErwdOMet6cWK5Hgy/pG4gtTAvHLXKG1RsMPYcyO4dPXX1ffPDaW6dwMOG6PFkz/giI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHaUJH5Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHaUJH5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787226218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8J8pUe73FcjpALZHtnA0DHlxGQaT0qvtBA/sqVN6KQ=;
	b=aHaUJH5Yq3Ux2hBYS66ykSE4eIkeKZ+OvpIaNdCfl2Wf86Xgu/SrWU5TaqZPYYoQzNnKPC
	MYflf0m7y5pE1xz7MdVB4QpOS309pfGCwLkr4x2zVLWeeukMucuBWoDgM6HLvMLupVOjXH
	xkT44BIKNjSSQDrmDzhLGY/HgrG/NXo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-piVxVcigNjCPxIYNgIfVHA-1; Thu, 20 Aug 2026 07:43:36 -0400
X-MC-Unique: piVxVcigNjCPxIYNgIfVHA-1
X-Mimecast-MFC-AGG-ID: piVxVcigNjCPxIYNgIfVHA_1787226214
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6e658363so1366499f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 04:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787226214; x=1787831014;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E8J8pUe73FcjpALZHtnA0DHlxGQaT0qvtBA/sqVN6KQ=;
        b=JFz9ZZFBrgqsCfyPsRk1YTLIftXxavbOqyh0WDi+FynA+R0RpkVydztHG/LJqTsfOy
         OTmbEnmIz1UxOVeolGWxdhShSQGtXOl4j8RZswEUjY8jo5tfuRz6V2fsrUoAuSpuPg1p
         jKMBbftZ/V3NwXGGJ4bTpajDKGJyAb80vsu4x26pysmGUDHakJR4/YiUO3jdVcgkA5NB
         u8TbUjx4thYSb5FIe6twjeoNRLKkIONKeIgxqai7k3LOEvRDRNBIlMTWhnLQ6ZVnUZAz
         7ttRbhgDF0ToYpqO7vUUkjPJg72wXDT0e/FRV0RGQt3jiY0xeR9YrIhgbdLghUVxoFGF
         Ow+w==
X-Forwarded-Encrypted: i=1; AHgh+RqpRvTBoBrgFBsq3AL4it78O3hd2WYs8Rxtnr4mU0xG1FdDbUarMsjQ/zpSGw5zy360NOGdkhc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwysGnqe6Cz/FDXMQZN6hruO08NL6E06KesiobEE89wa3L33jb2
	xGZdlD2A6tEA4YzQWZauD3mLpFI7fIaasu2hkU2mMGPEplEuLATHSmoSb7CahhNRC9muA7LJxtJ
	FrMw6hovtBPgmHdhfqRcQYJRYpvJpmlrikqzw49Y1vpU7ERBrtoeCR2W6Wg==
X-Gm-Gg: AR+sD13dO5n54F4gloqtWYRw3QeHtGLN3Ipr4qt6eiJPZ+97chSJmlaqaruWGXNjGZ8
	8Vx1x2Le1uHpJSufrUPUbc8P2DvdhX9QuI8gpNZnYHwXWrRhwQEvfT0D4KUNs4NYnYPIWeBjrcw
	DTebpG6MC9mNAPqUXfM9CBCmUQZty0N3JckA+EFOL9R9tV86dqW/HsNUW8Tw+rb0JjlqDY12vmc
	gNpAGAwev4O7aDJ1oSFVIljBCWrIapvUAvyF9uxGIdyGIDaN3eKP+tKZsbtlrUGzQ7eXcIuu111
	ecdA1oiaqq2ni97iRQ4HZGn8wwv2azyO+0+sP5Eg7JK3UCa1D7QDjOkmS4rl2/STV+r2/ZKxBmB
	NuaaoIrMkLRMD3jQH4xTAELODMHYCkc8RA+Jtq+txkRI=
X-Received: by 2002:a05:600c:34d1:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-499aa14a6a6mr209174145e9.3.1787226213643;
        Thu, 20 Aug 2026 04:43:33 -0700 (PDT)
X-Received: by 2002:a05:600c:34d1:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-499aa14a6a6mr209173095e9.3.1787226213242;
        Thu, 20 Aug 2026 04:43:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa1111b2sm186902385e9.5.2026.08.20.04.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 04:43:32 -0700 (PDT)
Message-ID: <2a65b85b-8aaf-4ee8-b797-732cb33fa139@redhat.com>
Date: Thu, 20 Aug 2026 13:43:31 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER
 changes
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sebastian Ene <sebastianene@google.com>, Fuad Tabba <tabba@google.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260819102809.310708-1-fuad.tabba@linux.dev>
 <20260819102809.310708-2-fuad.tabba@linux.dev>
 <78d60d96-d0c7-4eaa-b425-ca4f75263b12@redhat.com>
 <871pbtoz7m.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <871pbtoz7m.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BZfUDuwH4BNk-upFz0Dko3JW1GPU-fpd-KlHZ_tfbzw_1787226214
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 12:36 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Thu, 20 Aug 2026 11:09:06 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Fuad,
>>
>> On 8/19/26 12:28 PM, Fuad Tabba wrote:
>>> A guest that disables the ITS and re-points or shrinks GITS_BASER<n>
>>> with VALID still set keeps the devices and collections it mapped
>>> against the old table, as KVM frees them only when VALID is cleared.
>>> The table format is not architected, so a write with a different value
>>> is allowed to lose what it describes. Free the list whenever the
>> I don't really get "a write with a different value is allowed to lose
>> what it describes". A write at which place, in the collection table?
> 
> A write to the GITS_BASERn register describing the pointer to the
> collection table.
> 
> The additional clarification is that because the *content* of the
> table is IMPDEF, if you point the ITS to a different location or size
> in memory, then there is no guarantee that the caches (the KVM
> internal data structures) are up to date. In this case, the proposed
> course of action is to invalidate the caches and start afresh.

OK thanks, this definitively clarifies the above sentence.
> 
>>> stored value changes.
>>>
>>> Test for a change rather than a write: its_restore_enable() rewrites
>>> GITS_BASER<n> from its probe-time cache on resume, and KVM reports
>>> GITS_TYPER.HCC as 0, so nothing re-maps the boot CPU's collection
>>> afterwards.
>>>
>>> Fixes: 36d6961c2b481 ("KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared")
>>> Suggested-by: Marc Zyngier <maz@kernel.org>
>>> Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
>>> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-its.c | 9 ++++++---
>>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>>> index f6538b1976f9b..3339d9977af27 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>>> @@ -1649,7 +1649,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>  				      unsigned long val)
>>>  {
>>>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>> -	u64 entry_size, table_type;
>>> +	u64 old, entry_size, table_type;
>>>  	u64 reg, *regptr, clearbits = 0;
>>>  
>>>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
>>> @@ -1672,7 +1672,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>  		return;
>>>  	}
>>>  
>>> -	reg = update_64bit_reg(*regptr, addr & 7, len, val);
>>> +	old = *regptr;
>>> +
>>> +	reg = update_64bit_reg(old, addr & 7, len, val);
>>>  	reg &= ~GITS_BASER_RO_MASK;
>>>  	reg &= ~clearbits;
>>>  
>>> @@ -1682,7 +1684,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>  
>>>  	*regptr = reg;
>>>  
>>> -	if (!(reg & GITS_BASER_VALID)) {
>>> +	/* The ITS driver rewrites an unchanged GITS_BASER<n> on resume. */
>>> +	if (reg != old) {
>>>  		/* Take the its_lock to prevent a race with a save/restore */
>>>  		mutex_lock(&its->its_lock);
>>>  		switch (table_type) {
>> One question: There is no vgic_its_invalidate_cache() in the function.
>> Is it OK?
> 
> Probably not. We should make sure that the translation cache is gone
> as well so that we retranslate and avoid signalling LPIs that have
> undergone such invalidation. Thanks for spotting this.
> 
>> Besides out of curiosity, why don't we go further and remove ite entries
>> that refer to removed collections in vgic_its_free_collection()?
> 
> The current policy is to keep the LPI alive as long as it is
> mapped. The only thing is that we can't signal it, obviously. But it
> would be legal to drop them altogether, only more work.
OK
> 
> An additional question is whether we should consider doing a reload of
> the collection table or not. I'm not keen on it, but I can also see
> how a guest could want to do this. Feels a bit over the top though.
Agreed.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

