Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B121E3815EF
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769107071; cv=pass; b=OtX68u4otv1PdV0MF92Uoi8bldMdLI2g3O2UouZzZvtVDyAwZJ4JRkBhfHCwdayutqgR0ufpSReKW+jKZpkxxXJi0e8Zl3kWKSSvwUbGLTyYs2IxlnVGV7MGtyOAcPwuV8VHt45RB3+DLR8RaLqwQlLKYENcz2Z3XuFmizF3KlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769107071; c=relaxed/simple;
	bh=Rur9bSt0hgAR6phZOgAdh5Lfm4ayEbdbSjuSfNntYfo=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ED0wa/BVPgPpGy+j7Yig4XPVYH4BX0MQ5v0gdv/57bF55npnFeKc4nYxYGjpcmKCUPRSHOtvx4nt6B84Cqai0kJjiWFVjBHlm/1Sw+xv8T5m+sGGVJ0bHz8DR7ylsIRyhyFv0eYcYY6PElxW8+v75mf062JRrgX2hqvVLz0iT+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pYy8a6pu; arc=pass smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pYy8a6pu"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5663601fe8bso638823e0c.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 10:37:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769107060; cv=none;
        d=google.com; s=arc-20240605;
        b=SJKFTVInrjo1Gq9xGXGJ0XPdZfRAz6abDIY1ZKHfLDKvsRfD5xOo540prWClCG79W4
         H9U/CV3VjIe/36T0iPnMO30AvWHv4SorFoILkp/Vi+pBw9uiaFUWhdA7wKnVt9DmI7eZ
         u5TkSOoBfghnHzbzGMEtllm88WRfwjjvn1u1qjGRqv14dV0iK0NZfxvRoYJaaVNIeM35
         ybIWIgWDikiHEdEo8SoO2ISzVx0HoMUAEEY2FNtvXBGe0L2RkTMT5cHpyi7fEjUYKBxw
         0KLJuok8VW70ib5mUHTCkx0aRW7Noq+1kpESXlvITszm9O5+eXffwrsvEnMxPHdl3pUA
         0tTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        fh=UMVjJwdUzy7mPLVZ7ApcvPNGa/b4mhqUQz7mNVnoI4Q=;
        b=U253i8PfIE5HVXxtNuOQYZlkSX+UOpukrpQ1EsO6aNKM65R9iqMLW62/y3XbogYVAw
         JdvGIpSbs59fTCVzZon4HI1kGHEnAIbO2lEK3rKAmOFnntXwU1RwPybNxy+/V2rPSG+e
         O5bXTcrBgQpmqk+Sc6JcnD4A3OiuOhGJlWhWccU/PqvlrdleTz48fP3wI1GlbDAnQ5c4
         CBvL+jCyjPElNgUnOrYrhLK6jeqtNO25Sx1I3hozNJm/D7kBeNAViaCYcvaVK23aUcqu
         cjDUTQV9Gm5hqEdutjWWiV6wtPgv8NyAGEHrx0zI7bsaKDutDQaDH4MNs3K0DsE44+z1
         TjRg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769107060; x=1769711860; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        b=pYy8a6puoQY6zkCCdWi7zMQrBHpfQLUznGh9QVMdw4X+h52lqDTwa2qBw+WhLzSKb4
         q3Dtf+iiGtBv/S3rLeXtFMZSXe3tWHUzV5ljy9UlkDKm6SfV36zjMdDhOI3P6uKMO7Vj
         iE+U8Q3OPU53XM8HlsENHP4Ysi6bM9Gh5OQxL4ZsDU135+bWmXXcqRKBvDseZxPrnx8M
         VkxhWR+NLm0nDVTk5ewbZy55BHni3x18/4pBAmIuTiSl9+T2kRiY/wcwm7Yyrhfvkwyo
         H5XIW1Ir1WyL5TnRfJG6efWL6/8QFlP68SBiZ+qlPmbC6anbMePz5pKRhD/cv5Y2ydHD
         qxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769107060; x=1769711860;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        b=usdYfPkGPYo80TDx+lcn3nh3FLG2jN0MUqRsXti9xv/mySxUMHgyM8LzosPce0LIqd
         cdDRRbszlEJ/1T+OYiTy35T8K5/im7ie8eeYNvO859cmNW2aJDJKjwNykLa7PTzyetB6
         DNBz/vLjeXZPMrP7kOO+XQWh/wdmovrJHjUUgcQBKOxxZHqPZZ12cjMbjmvFBPuqoGQv
         6OTqIGx09DVfefR4MEUQSk22hiuKf/py6OXaEJ2HkSBe45FES0Lh4GmJI5+0k/hNZxNz
         YGKyWLJdq7l2mOS4cQmIDM1G57JWwSvPXhTUBNdRCYEOPlByletmI2xrYXnJigJUeULl
         UhFA==
X-Forwarded-Encrypted: i=1; AJvYcCWQMD7ZS9X8PkkS0IC5ULahpFSGY2LP+9FA1Y+sRooEYRuKC6wNUXrDRnEXo1EOugurQbhnSmE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPPkW3Ke5mq+EnRHepHBJD5BAx/8VQ/oKYTJjAezXJ/FGXiZyl
	i2yfsE2IEcVVZHW9NH/yqgm4H6yQdpDoEG9FrrbTwAlFQiyhGFPw+NI38WYcS2JrB3EnqRF08Kv
	rBycNv+ElKbqXX4uLgOiWZ4Wexz0iPS58GCleUI1S
X-Gm-Gg: AZuq6aJ5o13LqWWVngPuL3R2nc5LRXgNMBcEOApxYa5O0dYKWAbK3I+alQ+1uTfcFkm
	0QrRQOPbU9e0w/yCMn40BnfwPsHtYcL+7M7foKQH8ndlECkt97pagIu1oYp09pRu/Ham5QiticD
	ZiLHp8MXsovbZ8RFakxfBlTbSPJ3Cf4hmzVmSaSzXEjZtF+K56h/qvtbJ7VAr5maQ5nOhCUVXtW
	m5NmM8AyE3Rf9UgUS4CUMsCkB8iA577TsbuaUaWH36UAsQ5fI3xGQLZfZVSDDr28+HMLebskNjD
	yUAkzaxA6dP+UPMnISAt/TVH
X-Received: by 2002:a05:6122:1799:b0:54a:992c:815e with SMTP id
 71dfb90a1353d-5663eaa47acmr191602e0c.8.1769107059228; Thu, 22 Jan 2026
 10:37:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 10:37:38 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 10:37:37 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com> <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 10:37:37 -0800
X-Gm-Features: AZwV_QhFeXvGMv5345sr6hAOQL-xKTYrLyTeQaptQlhk8j2vfvA1j50rf6t-uyU
Message-ID: <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "surenb@google.com" <surenb@google.com>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 16/01/2026 00:00, Edgecombe, Rick P wrote:
>> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>> +{
>>> +     /*
>>> +      * Direct map restoration cannot fail, as the only error condition
>>> +      * for direct map manipulation is failure to allocate page tables
>>> +      * when splitting huge pages, but this split would have already
>>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().

Do you know if folio_restore_direct_map() will also end up merging page
table entries to a higher level?

>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>> +      */
>>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>> +     }
>>> +}
>>> +
>>
>> Does this assume the folio would not have been split after it was zapped? As in,
>> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
>> restored at 4KB (split required)? Or it gets merged somehow before this?

I agree with the rest of the discussion that this will probably land
before huge page support, so I will have to figure out the intersection
of the two later.

>
> AFAIK it can't be zapped at 2MB granularity as the zapping code will
> inevitably cause splitting because guest_memfd faults occur at the base
> page granularity as of now.

Here's what I'm thinking for now:

[HugeTLB, no conversions]
With initial HugeTLB support (no conversions), host userspace
guest_memfd faults will be:

+ For guest_memfd with PUD-sized pages
    + At PUD level or PTE level
+ For guest_memfd with PMD-sized pages
    + At PMD level or PTE level

Since this guest_memfd doesn't support conversions, the folio is never
split/merged, so the direct map is restored at whatever level it was
zapped. I think this works out well.

[HugeTLB + conversions]
For a guest_memfd with HugeTLB support and conversions, host userspace
guest_memfd faults will always be at PTE level, so the direct map will
be split and the faulted pages have the direct map zapped in 4K chunks
as they are faulted.

On conversion back to private, put those back into the direct map
(putting aside whether to merge the direct map PTEs for now).


Unfortunately there's no unmapping callback for guest_memfd to use, so
perhaps the principle should be to put the folios back into the direct
map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
at freeing time?
