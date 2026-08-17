Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F453CBE6F
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786957218; cv=none; b=S5gUTUmLWyNcg2aj4/INLsqzwII3iqZ9XMNf4p6U/JWfcZSg5Cq4GA7lpmWkbL7Sn7dyxoikWRTSOxlKf0rPpe2M8G3EfhX8E3ecoAK34eN0bGJaUgxSqtFvQ/Hns64muiL7cWpD7YgoM849IH1JqnfNahnnrOMeDe0E8s9d0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786957218; c=relaxed/simple;
	bh=e+IPplwFXzoFzsk0DFknbE3Fku2750DCqHORU9LUwdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akWA9ndYYnHfY+eKJcMH7UPZcDIzvMyjN/PFLW0FmosRzuKsRgPsppXrfHK/hlz7+/sKzPUyMW+fMdE63q/ahcu+LMYJD3lOvIIGLDpF2pXCIlC9BOKyygDzu2DJ93BVtBjAruOyB3so4f2roZhCaGtNPJ7YKcmgaqd17t7eOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hlx/93Q0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hlx/93Q0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786957215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3OSbmtJaxuAXKm9wxovJJHMJ29/ztwYERcUJ/tlgLm4=;
	b=Hlx/93Q00qHYQyDH+hPdG2E/bn4qaCnIymVFw3HZ+rieSuZxcRFf9hbZPYUQ/K8lJHWkyB
	T5mf2ZbEWojOHGJ3J0HaiCyN61BQJvshzpRaxyrWkGtbvQRuoPOoaYTV3kBiW2RJV5URBH
	ap2LCROeRDntTboUZqWwNw+aoJSV6bs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-hN93XyrQOPOrjfR2VnVpQw-1; Mon, 17 Aug 2026 05:00:09 -0400
X-MC-Unique: hN93XyrQOPOrjfR2VnVpQw-1
X-Mimecast-MFC-AGG-ID: hN93XyrQOPOrjfR2VnVpQw_1786957208
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f726186c4so1768250f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 02:00:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786957208; x=1787562008;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OSbmtJaxuAXKm9wxovJJHMJ29/ztwYERcUJ/tlgLm4=;
        b=BMiinpXP8pX7SWR0CCfe2PL6QbMCdoTlVjuOSm45aInqTkld3W1a1z06lnR+inLBu+
         W25cwjSoCWC8Ds546KRfsllZUCG6tZX/nuRIZ5i1r6H2Ft7YaCCJn5FZjDzEZPlDWHux
         VTgusDVYu8ehAb15NN29WyWvSTzl/g6jN/zwPisScmxgyw4FCznq6Rk+ecazTQUCSi57
         jZXCBqTeDFMhw2lGucl6nZBQkqoPDQScVRBg2/xSK0Ns52m5OhSH6JueOsTQn6P+t/0A
         R+PGh8+tvNV0O2P+LmqSerqnadda27+jIKB1pVTlsuyIA53DKR6Z0tmVnsrF+sVAvoG/
         hxPw==
X-Forwarded-Encrypted: i=1; AHgh+RqaRtZopA0Yd59EBNi2fGgpC681D9vQsmspMGlOasxgo5AzyL2wtJjlyMX+G52JPcFsvgvoY2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHkesklAM8dABWLrqYheG5AyeRE5+cJlueqimY2rL+/NWKzixb
	EJuZO/x8gIoJnyAkvy0uOuCsr4TfmqClmVkQe8jVnJrYsvYH8Oeo6kMTCWEpibejk9MCTFZojjA
	FBG38eMex7xVQ/oCPmsUCfY4n0XddIBLbY+4gbVQ3K9nVI25ugHPWvShZXw==
X-Gm-Gg: AR+sD11j6oiG9iXp2PXWP+ymUU3DBdCA3xjcbG9ard/KFy5k3xwxlTQT6EP8nZrGxQD
	mWjLD3g2bc9Nmd5Dan84rA3PqQdqvH3AAhTF9U/h9sXZ1gFVaRSqNhx9JWLt+O+d940kqSO+Pb/
	GwXVLkh5YZliuCO9xaMma9rvIReM1NBuRb8cQaytNSSvQjisdP9zS40RP2kG5oTQDPqFIYhyhlK
	8GERVmvLkY47d3MCyr8QcC/A4SPbNStxcy1c3acwZLuOQaMk1QvJuTXbzeuG1RPqKKpUriJLM8a
	+ObXUR5FpQmLyvy5WuXbEttTyl3sramYgrSTPBtO+RzfzsBc4ZgK872hBxoPT3eMBTuC5tlYgv0
	lXuoHYzghlcy7J0OOgk6iKJXKMX8kLU4FBue0oZO4F6U=
X-Received: by 2002:a05:600c:564a:b0:498:ff3:71ed with SMTP id 5b1f17b1804b1-49987993affmr279071095e9.17.1786957207607;
        Mon, 17 Aug 2026 02:00:07 -0700 (PDT)
X-Received: by 2002:a05:600c:564a:b0:498:ff3:71ed with SMTP id 5b1f17b1804b1-49987993affmr279069755e9.17.1786957206839;
        Mon, 17 Aug 2026 02:00:06 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a31572sm2267922f8f.5.2026.08.17.02.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 02:00:05 -0700 (PDT)
Message-ID: <cccb848c-a1d7-4c6e-bc79-ce699f92d09a@redhat.com>
Date: Mon, 17 Aug 2026 11:00:03 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Don't dereference a NULL
 collection on ITT save
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sebastian Ene <sebastianene@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-2-fuad.tabba@linux.dev>
 <0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com>
 <CA+EHjTzsCgBbaJQpv1ne-0Xo_3wdwv-R1RWMabdLxiMjMh4peA@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <CA+EHjTzsCgBbaJQpv1ne-0Xo_3wdwv-R1RWMabdLxiMjMh4peA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x8CdvtC0WETlFq2Zc5nbynVKqw7XNILPhF68ms9uZSU_1786957208
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 8/15/26 2:18 AM, Fuad Tabba wrote:
> Hi Eric,
> 
> On Fri, 14 Aug 2026 at 14:36, Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Fuad,
>>
>> On 8/7/26 12:40 PM, Fuad Tabba wrote:
>>> MAPC with V=0 drops ite->collection but leaves the ITE on the device's
>>> ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
>>> guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
>>> host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
>> Thank you for fixing this bug!
>>> That sequence is UNPREDICTABLE per the architecture, but KVM already
>>> handles the resulting state in the translate, MOVI and DISCARD paths.
>> Maybe: "its_is_collection_mapped() already checks the collection is non
>> null in translate, movi and discard"
> 
> Agreed, that's more accurate. This went into kvmarm/next on the 8th
> [1], so it's the comment rather than the commit message I can still
> fix.
sorry I did not notice. That's not a big deal either.
> 
> ...
> 
>>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>>> index 36ab3e4929154..ed281fbf008b9 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>>> @@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>>>       u32 next_offset;
>>>       u64 val;
>>>
>>> +     /*
>>> +      * MAPC with V=0 keeps the ITEs mapped but drops their collection,
>>> +      * and with it the ICID. Save a zeroed entry, which the restore path
>>> +      * reads back as invalid.
>> in
>>
>> https://lore.kernel.org/all/CA+EHjTymdanCKoQO3ATmUZ=7Ph2wv4ES8SfkSsTgmOYAYBWayQ@mail.gmail.com/
>>
>> you also mentionned this can also happen on clearing
>> GITS_BASER<coll>.Valid clear. So maybe don't specifically focus on MAPC
>> in in the comment.
> 
> Yes, and the BASER case is the one that justifies the check: MAPC(V=0)
> is UNPREDICTABLE, so it could be answered by dropping the ITEs, while
> clearing GITS_BASER<coll>.Valid on a disabled ITS cannot. The comment
> names only the case that doesn't. I'll send a patch on top to reword
> it.
OK
> 
>>
>>
>>> +      */
>>> +     if (!ite->collection)
>>> +             return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
>> I would rather squash 4/4 here to emphasize we are unlinking that entry
>> from the scan chain.
> 
> 1/4 has Cc: stable and 4/4 isn't a fix, so I kept them apart. 4/4
ok makes sense
> doesn't make the write unnecessary either: an orphaned ITE with no
> valid predecessor is read directly, regardless of the offsets.
indeed

> 
>> Besides I also wonder if we should directly remove those entries from
>> the &device->itt_head on MAPC and GITS_BASER<coll>.Valid reset.
> 
> For MAPC(V=0) I think it works, and it would stop the event slot being
> wedged: an orphaned ITE today can't be DISCARD-ed or remapped with
> MAPTI. But the ITT entry has to be zeroed with it, the way DISCARD
> does, or an earlier save's entry stays in the slot and restore fails
> find_collection() on the destination. Oliver suggested the same on v1
> [2].
> 
> That pairing is what makes me doubt the BASER reset. There we would be
> zeroing every ITE of every mapped device from the GITS_BASER write
> handler, which is an unbounded number of guest memory writes on a
> register access, and unlike MAPC(V=0) that write isn't UNPREDICTABLE
> to begin with.

Yes effectively this would imply to null the associated ITEs... On the
other end, overwriting GITS_BASER<n>  while V already set looks rather
far fetched but well ...

Thanks

Eric
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/178621413198.380376.1272590130654213471.b4-ty@kernel.org/
> [2] https://lore.kernel.org/all/anQQ3dcbk72N1g1a@kernel.org/
> 
>> Thanks
>>
>> Eric>   next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
>>>       val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
>>>              ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>>
> 

