Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184FE362135
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769113864; cv=pass; b=LFm5EgB695dZgkgOEdSWbieiN5IMtAuRJfqBvUwNeMKaY1EJhhQFG/1a62j7oi0qMjlFInPA5w3Wl9RwvQC7IdDAAwi0G2HMJeL0YZFlBuVaNeHo1WqJv7/XEIinDiOrv7WhRBIIsdf+lvVWcBOJTJ986ZfbzxTOyvRkY7wTtio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769113864; c=relaxed/simple;
	bh=ASZplhRqMNnIuXI0Gmdw3pwrAxGsQ+x5dICWN1yZY84=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ePuVmi+2Gnei7bndUc45wLAq6Z9LKFo9BqYqkwGTzq8hPEoAQTSDt2rl1wM3fZy2MoOxE2Pvq7W4OVV3kLASIzzpQTc4t7BjqaBZl5XgL96grLNsUU1tQrYUipw2gSPUAqt3ydw/HugyG57VRbSalVzsd9OqvrVDqzlkX0EvV6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wErIT7zi; arc=pass smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wErIT7zi"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-94124140e02so971628241.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 12:30:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769113855; cv=none;
        d=google.com; s=arc-20240605;
        b=l0o2xB0rJ7XXlEg4knAOReNm+G4m2y82tsvF47Ijyb4/HAR+gZ0V26Y2GioLGCEtpK
         t0mHQ74kupxxDLpWhX50BXfVP9jOiL/G95dCDVVroTsHVJUjFFI/Gz3D3bnwrIY8ZA0V
         F1iRXDqwUdr8Z2g6Cupqa8IyYCO14tD/yun6j0zcoZF2I7rSqBpcVl8QFP6gPrb9soB3
         kFMZu5bfXFD/5YwJ08CqJHSIsc+W2QqlSBIyVn+7DnEuSFRuYpXna9v38CI9pGQHWpBd
         KYYaZE/AO65n9xVLDGZmGPIBrLlL31k9VDI0xQyQc+yQr9uPSho7BfCTly+Zr9Ly+21S
         IlOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        fh=BXcpeEvxU1vGUQr+D5z/23wN9+Z02Sdsx5D9Menkftc=;
        b=DfR4YF5xK9JmFwkFW+5I2eMBsoOrJk9DofI8i4VwiO8aP6UvN4CFeSioTn0pgs5Klf
         Q2GME81I+fpEH4r9nomIHk/YS8MaLo/8q2hgS/fv63Hd1MteSU33aUMdwa3j3NsxB021
         v2SaoDJrDhIviPA4jJjFR+3rLhNiavjS6a+RTC6hBgbVlBh9oyWiBO2EjeLc7L0Qgjlp
         DnYqrXNurPO6vMjsqP78q5/qw7gAz00hpEvv5ogxIo40Ky4C4mfVnt/EMRRNYDN2FVhm
         b6JlaUyLQ6fN243dBrtYB6kv6hjvb/Z7nuIsuyZc4a1HX3agZByGzq/rmGjkE3h94drE
         CBFA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769113855; x=1769718655; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        b=wErIT7ziMv2P4U5sBQCdqyYmclTmeSb7vHh1X56c3z2wB5TRd8DGauc4vC53jw82Ti
         Ib8jaLnPiomiMoiIcsw5VIyBIGd2L/AeuxHsxS90y3oonJ9FXSn+YjVfpb0BQQH7fwBV
         M6l43Qok9GwDZWSCbTdmpKLa18Chpgyp6YpWgLTbEIzFw0c2AcrNLcG24a1WeBdOBVow
         7xG+5NX/SzAV2i/YYij0o47y3TLbFUwYq7e38vYt48+tFzUODTEnJsSspxruPri3RTBu
         VHJvKDaxscJF+PLeOsX7cRMcrkRs+luLsSIxkfMATL9+qqbMKtY1WgSBEaxG0le0KcuC
         0jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769113855; x=1769718655;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        b=AZ15FGjkVxA16cX578QN9Bz4XDcTIfFJnLs2YYjlBW+IHiRr7cpjdvbFGWsXnKYm6y
         mti0kOKAAr7WOfRAeTuqpQln5UCAG4FoMd055ahsa8aEJLGLiFdcVG+T49PI9Bpb4Z5q
         DwMJKPI+Vhp8+C/Re6jY5fZhcbBewix3pyRubSbW1uvNUaCn+nTLdE+6rNk7op2u5qbw
         MwTm/C10KHvOtR4B6VkjZQpU8CJ2pkF1hvgW3LgWBVnRTfVkiD1kJDJ7o/czkqzcMVH6
         nsYmkKilV/zBosutpRNzMT4JbaPpSeA6bQJ9Mu4Mm94TJ9/emVGLUf/R3wfLR3IfKsIF
         DEiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3OEBjA7uKuHb7g1tszp8b/AB7AeIDezth8nsqu4cdL/v9RhgLaFV+cHxpYgEx2R60xMxmyFg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZmTsgR8lgUVCdB3kD8VU6VG2gYKgfG/dfoPuRJLEs/iUgQ201
	pQuLQUAWrwVj+1T/OZhwb21PSGZV4EeUwUW/L3ivLXb/aqs2M21y14RORpJ+K5CRNVv20hXaC4v
	g5Y3cpOWYOCjfeArqvUbE12gIJgWgYWRunmMl0ep9
X-Gm-Gg: AZuq6aInv5TKVBrJEU/4YnDwpxcmcu9Ba2JIjJDdN+ZpSls+sbo5mxT4H9PIdKDyjCF
	Nnr8VsY2z0iIxkyXsPXcPOeDfrRTzAhWhHIrFauIVCaC5dNnQ/HgbnAKoRdzHMoIxUtEsn556Fn
	2t7KxwfMPwEs5OZwjJzhG+aWudIvTeaoiDcAtF96vrHFXKnrhp5icYBK4eHWRH0xvj6D2htTLpm
	rr1BV3XQDESEK84hNRYj7rneUl2ujXN5HVU9YLZYF34GHS2O96Z8pSlL+Gv752i9VJoTg7MwSJa
	LNU5efsBYXkTHVSx2xnhFWC+
X-Received: by 2002:a05:6102:d89:b0:5ee:a8c4:18d4 with SMTP id
 ada2fe7eead31-5f54bd0c3f6mr359613137.35.1769113854610; Thu, 22 Jan 2026
 12:30:54 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 12:30:53 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 12:30:53 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com>
 <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com> <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
 <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 12:30:53 -0800
X-Gm-Features: AZwV_QhoTAbsDcZFNCQXVZ12J6m5MEBpBa-k8I2xwSPIY6AXvlNDgQnkgPrJ79I
Message-ID: <CAEvNRgEd=Uh09dU_P7_vvzRpOyMYd=OKazpkxzr=VLe5HcQhGw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Nikita Kalyazin <kalyazin@amazon.com> writes:

>
> [...snip...]
>
>>>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>>>         kvm_pfn_t pfn = page_to_pfn(page);
>>>>>         int order = folio_order(folio);
>>>>>
>>>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>>>> +
>>>>
>>>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>>>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>>>> time it's a folio-specific property being checked.
>>>
>>> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
>>> case.  How does the fact it's a folio-speicific property change your
>>> reasoning?
>>>
>>
>> This is good too:
>>
>>    if (kvm_gmem_folio_no_direct_map(folio))
>>            kvm_gmem_folio_restore_direct_map(folio)
>
> It turns out we can't do that because folio->mapping is gone by the time
> filemap_free_folio() is called so we can't inspect the flags.  Are you
> ok with only having this check when zapping (but not when restoring)?
> Do you think we should add a comment saying it's conditional here?
>

I thought kvm_gmem_folio_no_direct_map() only reads folio->private,
which I think should still be there at the point of
filemap_free_folio().

>>
>> [...snip...]
>>
