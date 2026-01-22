Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A794038E13C
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122059; cv=pass; b=Ri0O8IuafzTvtYR/VfWI6eG8SO1gd2sH4YA3p8+J/RVBwbXHXFgZvzODMVB/mEbVzJ8EVJOsrSYDxQmt9Dvmq2H7SJvoXw9o5wIvU09DhOe8SGht5KIcEmzBUlmxfNOvyiNZjPdLKPqGi82hhfH3IqKkWCsUgxJaFVIOONkXx7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122059; c=relaxed/simple;
	bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+3S55TDMzNM5qa1IvXJUKcHBhq1nIQp3v4meUZAjIcv24s4gA8NHiwPwy99bvk8KJvZMPntlFn8ULBZO3MsQdmZD4wMCE7t0v8bdq7bhBUdjR+tBtKJ0a8xz9edGS2nw6Q6gZxfYEBfBmcOmSpDvmGGwU39vqDN8eeUdNrWHDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A0QUY7up; arc=pass smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0QUY7up"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-9413e5ee53eso1125227241.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 14:47:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769122051; cv=none;
        d=google.com; s=arc-20240605;
        b=UfLbkMxdoHuBDHG2hyaPT8kFYCKupZldgruS4mH5rt00//JfBFsGLR2VoINTfud2mC
         8pWWK/LX/GtiolWV+J8Y8hAelHvaWRMxcLxvcoHw3eT19Sc7KrdgVppAeb0MnPpddUfX
         IOSBNoVFBtNLI0f9Dz6C2QwSKCv37NJ+RESKiT23gY0cnTpUH4WTbeZbt66Rklq7ytpz
         qfV8KSC1bJ/YHaaUqfZs2Q/dutG38DLCmpZSA/LKZe6IHGvZlrdOaltrJ7gMDAOeqyyM
         lVbKUOkLNOHZj9/pvFuh8mETyKOf3YlZPnruGyzWMI5sfF9itBS+S+oFz9Gp+vZDP/Ys
         W3dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        fh=gBDUtDx6mAhc03z+rlCFcnYd9X+S6IGHCzDXRm9sbcE=;
        b=MdrH/yWKaCVgFH7OV1la9KoYrI9cPMP69xYV38aCe6gECVEqN/93ZEYXucRbsO+MpT
         qje/eVqnGYhHm3XWHKbKDik2SG98sxyyioVl0+L0jJty8XbM5Uvx1IkGTyH+MgBJA69Y
         qMi3aOrU3Ii6rPFEHD67cnWSftOc9DzCYLo7rkWkiNFJqj4dsrobR7aa0sxbi9HMY5aI
         WHo5tkjxSwk/pihKyE8evwOz/8ljzPNrLRKSgmlKb6DfGG91p3O0/eqkgDRjXdZGNXQI
         GQHq8lf6VhI8DDH6IJrF7gRMPR6UNsydyiTpTElz1J2WsTZNlFFXb3fQtLxtQjEZwvGO
         0Ztg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769122051; x=1769726851; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        b=A0QUY7upWddX7M6YZCXzQzkYL9PkH+LjKp9XWRpCdrDz6I8kxijZ7e1uNWKaMdJSuD
         acVKSQBJIpTSC1v9cCKSH+vgJDO9ELefvS1NyE50onJM5zRWnVaSgvzLj2Vqn2c4POEZ
         ZfDC5/RBDhEL//pPK1djaZojmu/gVCrt98XALcNM3J6d15XEupOGSyQOSBQFy2H4SSrr
         zsjG0SWvTiSPSi8SSJfjX7oHIqOMH4d4QzCnNIBO3Vt/Whax4zCsdqZG0xP2G5VLhAVu
         2JKd+zoop0F/rB5i6bxQU8UnXqlmhWtFJvKzUYQkmqKlgeSSBHWj+SsQfAVhqML6muTq
         IHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122051; x=1769726851;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        b=dk8hvRGIllykgPMB/GbH7Prpm/OXZ8K+FGAC5FFgna4w8qJPtcQeCctHF7Bsj0c7lb
         YKab1WmjAROgb1baR9hpAn8tHq2lrOBTs4WNpSTwq6FpTnvJDiVIDrd25NWx6u3ax212
         gzPgqvNK8nVLzwY95T6SwoD13p8KZNsuvXei44JvV2cd9bPfbclBNCim/+LOJ/ebe0Tj
         EQ9WAlC2zbXCyriskV5aWHO/igeK8PzL/vIzFsCWP4PJY166HYnE9j7zbs/nNkvRFSBq
         4N1m1ulCCyFn9mRAYJt3XmAJjahHPtZE2SPEeuvkrqiWH6Cqy2Hnar1q0BbYsjnYPpcx
         PlWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW4EBMjcwkEZVxevmE4PxkMm36YSieMQIYG/SzzSdXhtMpEzX9LZ+z56POxFadA5uRA7AcB2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YysZMHet+epBmc8TeEXioOIpf6zfjRAlmEeiyevOxvMflgsZGr5
	D67PSz4WPO8GKM6osf0fgisnFPRDFpok5CfKDesaBT7hdYGeCzLkBKprkL4V9LsS94w7KXSOPQI
	USXY/eqrfN4Xn6OH73WiZWbb+QUqzYkRC5fEK80uV
X-Gm-Gg: AZuq6aKs4y5fVQa3OZ2hPiZCvgIkijrSqVaxDmcvm92FOD4ZV5cBwmVj60KHC+aSm2V
	IPAQwFnEE56RptamJwqrCzVw25Q3CRWvgkpxetVOK83ukb4hOBXMR8SEw41QVxObI8Ap2dcHtgm
	9dsOyFXxjVHSulNfWf2k+XEmKFTYrgbo8MRLQYa6RvYVqRPsy5NTrtAJkt5jvfRO9UJaQru48yc
	T/EREw2bupEIK8LGz/IhrMDbB0F03Th9Nl3Ti7wN5k6+kG80orL5T2tKjWftpyKOLTOD+swTV+t
	q7dhHgGSlZkOcfwwppuVY2s6A2rkwjXmrck=
X-Received: by 2002:a05:6102:3a12:b0:5ef:7220:bcb2 with SMTP id
 ada2fe7eead31-5f54bc8224dmr480092137.28.1769122050230; Thu, 22 Jan 2026
 14:47:30 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 14:47:29 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 14:47:28 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ee9c649eed3893d852c3d20fb96bdc4904b7c295.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com>
 <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
 <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com> <ee9c649eed3893d852c3d20fb96bdc4904b7c295.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 14:47:28 -0800
X-Gm-Features: AZwV_QhacTtf2zgQk3uMxNHfKwdT09Bqx79KDOGE5Z3VW9UujMTrgN_9VI-QiKU
Message-ID: <CAEvNRgEz0+ic9uvcsWYqWgR5EV=TfY0SAGC39zAL+n19SoBXmw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "ast@kernel.org" <ast@kernel.org>, "pjw@kernel.org" <pjw@kernel.org>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"willy@infradead.org" <willy@infradead.org>, "wyihan@google.com" <wyihan@google.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "peterx@redhat.com" <peterx@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"jthoughton@google.com" <jthoughton@google.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Thu, 2026-01-22 at 08:44 -0800, Ackerley Tng wrote:
>>
>> Can we disable direct map removal for errata systems using TDX only,
>> instead of all TDX?
>>
>> If it's complicated to figure that out, we can disable direct map
>> removal for TDX for now and figure that out later.
>
> In theory, but it still would require changes to TDX code since it does
> the clflush unconditionally today. To know whether clflush is needed
> (it's a different thing to the errata), you need to check a TDX module
> flag. (CLFLUSH_BEFORE_ALLOC)
>
> Gosh, you know what, I should double check that we don't need the
> clflush from the vm shutdown optimization. It should be a different
> thing, but for we gave scrutiny to the whole Linux flow when we did
> that. So I'd have to double check nothing relied on it. We can follow
> up here.
>
>>
>> > Then there is the clfush. It is not actually required for the most
>> > part. There is a TDX flag to check to see if you need to do it, so
>> > we could probably remove the direct map accesses for some systems
>> > and avoid temporary mappings.
>> >
>> > So long term, I don't see a problem. For the old systems it would
>> > have extra cost of temporary mappings at shutdown, but I would have
>> > imagined direct map removal would have been costly too.
>>
>> Is there a way to check if the code is running on the errata system
>> and set up the temporary mappings only for those?
>
> The TDX code today doesn't do any remapping because the direct map is
> reliably present. There isn't a flag or anything to just do the
> remapping automatically. We would have to do some vmalloc mapping or
> temporary_mm or something.
>
> Can you explain what the use case is for unmapping encrypted TDX
> private memory from the host direct map?

There's no use case I can think of for unmapping TDX private memory from
the host direct map, but Sean's suggestion
https://lore.kernel.org/all/aWpcDrGVLrZOqdcg@google.com/ won't even let
shared guest_memfd memory be unmapped from the direct map for TDX VMs.

Actually, does TDX's clflush that assumes presence in the direct map
apply only for private pages, or all pages?

If TDX's clflush only happens for private pages, then we could restore
private pages to the direct map, and then we'd be safe even for TDX?
