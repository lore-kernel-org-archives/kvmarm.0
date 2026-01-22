Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86C738A29C
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100285; cv=pass; b=jaVWgPCOBgKEjAoTV3N28CECb/Dw7l2rPLUKSdTu26rS+beg4/iFegMJx2HyBqKoHxsBW7CqjMcOFSpU5GJuFCvOd9IJiOqr078hqEhnTvdQW8FPkgXwjWin1lIFhwYPibL1ThBIliM1IqnYzkEedsoLJe8hJ1fJe/LVS719NYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100285; c=relaxed/simple;
	bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sya79xkDU4YICCa5tcilXmul9sqSiSURs+Jn6Ww/iPGD2G8HvajwOUp/hWna9a9xgrBDAJkxKVgC4E2dAWKEHYdeXY3fvG6Lf7GnBOYDf8tjm71ZjVRJ2ilWG0FUxQrXFevTFpvA8O9AiMwZ5tsKKXu/zArwrfPM7lsi4JJp4aE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xmin/dkb; arc=pass smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xmin/dkb"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-94121102a54so732630241.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 08:44:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769100280; cv=none;
        d=google.com; s=arc-20240605;
        b=NtXyMOv1GlXVvWv8QZ6X8DyFdZKT1uvRH+uuNnMP8i9MZfhC5gfv9N+VGWGdzo4FCO
         yHxTIFcXek+56n2QvtLPuk0fbG0vD6mDPUpDXhN/9TW5epQu0Fauzgj5oPVHawla6Yi6
         insqP0GwxaTezIBFM/ebYyo5QnEZewtf6AouvnyCPgsK8Fr43+mHwDMngvtavZkiRQFJ
         UdIk0lgXocFJLIvyzsaiXn/E/rwGEuLIbVv0gH72zetFli5TKXNVFXrDRdm2+27blHeD
         jyKxtTC6kpdZkJbsaVoPKi/X+LhQdUShLd+pyd9kIK5upQFnYbCoyzJvJe24Fgyav4lO
         3lWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        fh=APPonD9eIpI9tFYBWpXwJwxsro5P/Ss56ooueWk2PmI=;
        b=iw3JS4JeryFWWs//ImkQrI1l+LONvgUPAQ0vJKsCq7sB6wlV+r3+PdnU7cUdzl0A/o
         qkr0tjx62B12MmvdIe+4h7jeSTQWvRosVHOtOBJTEaNdhuKWpoNRCkWyxQgp1Pgfc5Vn
         vo9gwY7scbFdL9ChjjM4WUcWciYO9f+oyWdieq0caCngMZcU6TdUeDyOPdwcX6lFsx+h
         Gt0elov+SrjBOKCmrrF2FN/FtJfsr4k1BANmqbPTbv8EajGua4segBR5nTHNtBiKciuu
         8MLYESkrXb0E2DL5PvOBSXuDMS6IJtINqcHk+0lTCxhckNoZJ6TcH5JWio4PAKeHO8M6
         FbJQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100280; x=1769705080; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=Xmin/dkbkupsNjHGMGRHQEgBqkAxAsx1nExA8qtIo0exgmb/E74H5eW/k5yAQgPNa0
         jgjXIbR1ZuUzu4UL+lMcals9thfNe+9+QCw3Q+ELRmV+EbazGZhn4xOMdfpbvsa9xvVu
         eqsbY7kcBUDKGvJLUWIY2Y6DSnueoZJG4nkZ90Xugkk4Ts8XPg4b2e8WHZsZyg2C2XEw
         Hn2olBHSnvHN4gT2KM6c8h5MyrH3FJKair2QnivfYD7UcFIESkfQZrqrslmVJkKkTVa8
         H5aFgbL8ylYVSjSTREGBi4ZpNlep6i87IzjDHO87cbHQRXT8J0Qv3Tcwzfy/7BjZ84pC
         2tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100280; x=1769705080;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i278ipBKd9t4eNryNmv1UqNg417NlVEpdzsVGz5SQq0=;
        b=qVkoPK3Dc5bRl4sBROdCn5/z1YyaboVq2ebKDJoJqOiGDzYuKvDw2b9fBN8dGQyQG6
         wwXBcSlPGdzN9nJvuNgefq8Cc3zIhus82QPB04R56Sj8XMjoJaYvWGubKv6A6TW67y2m
         pM9dxk0CmWY+uFYDKmkQXUPJ7zNFjABvG1qRFgiWlJaLilohGGblTFdWf0zLIIw+ASje
         hQxVVOL7/YinH0Td2bBc3JfpoFNtxwYqrQMdMn7w/e69sK75huJCIMq03nvyr9iGG9PK
         JTX97K2Orv83xGuLyScEuMuxb/guYi1ztXbqAQD2zbM9qd1q5ix7TS70tn1Ma0BXBbkB
         dmIA==
X-Forwarded-Encrypted: i=1; AJvYcCWNK1S9+8Zn1G0ABDFKhKuxOwZafiIRWKmXms5OOcg9am9/aH/HvzjVE++9MtzI+W/r7yQ6NWQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYjQKAubrZhVp0stjFmDyRmV6Wt8sAFxwR7vRE2Po06nhvLoOg
	E1jnr7YEHrGEw2ojLmfn2NYbf9wIAfyZsVeMV6ul86QRoK2ymbHrkI2zZ7WrmIrB70ZMyGgZ5ic
	87zr5LuObJIKsyYFNSxQVb3lO5vkmovxbSQ2y4vDl
X-Gm-Gg: AZuq6aIOGmmR5rq4HrmCGupTu3XyQK16A69IQTunULAYscQhvvno7lfqFOyAlZ7LIXC
	k/MpF/c71HpN/kgyn/weotX0dp8h/Tv1DotcMyzdWYwM0bn46LR+RGPkZfdi4zCQT3ndU35Os+/
	9aNz0KO4R/RG59prP7bWXut+Ox0gimc/IH1GBQcQQjrCaC5APDxici8LMAsDfs6UDLIgt3ldtmb
	4+kQEXRvbn1vM8GrVOKrQlX9nKGeI9Yb59UcWVTN1KZq+QceEmOodnuWOXsvfvt0unlmw==
X-Received: by 2002:a05:6102:d89:b0:5ec:c528:4df8 with SMTP id
 ada2fe7eead31-5f54bc628cbmr124387137.28.1769100279450; Thu, 22 Jan 2026
 08:44:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:44:38 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com> <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 08:44:38 -0800
X-Gm-Features: AZwV_QjFiVCL1GgMB61exuGngD3MnDbAOiFUMFZ1rYdJZrzTGdTea8E5DMfoinE
Message-ID: <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "ast@kernel.org" <ast@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"luto@kernel.org" <luto@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"oupton@kernel.org" <oupton@kernel.org>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, "hpa@zytor.com" <hpa@zytor.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"jthoughton@google.com" <jthoughton@google.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
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

> On Fri, 2026-01-16 at 09:30 -0800, Vishal Annapurve wrote:
>> > TDX does some clearing at the direct map mapping for pages that
>> > comes from gmem, using a special instruction. It also does some
>> > clflushing at the direct map address for these pages. So I think we
>> > need to make sure TDs don't pull from gmem fds with this flag.
>>
>> Disabling this feature for TDX VMs for now seems ok. I assume TDX
>> code can establish temporary mappings to the physical memory and
>> therefore doesn't necessarily have to rely on direct map.
>
> Can, as in, can be changed to? It doesn't now, because the direct map
> is reliable today.
>
>>
>> Is it safe to say that we can remove direct map for guest memory for
>> TDX VMs (and ideally other CC VMs as well) in future as needed?
>
> Linux code doesn't need to read the cipher text of course, but it does
> need to help with memory cleaning on the errata systems. Doing a new
> mapping for each page getting reclaimed would add cost to the shutdown
> path.
>

Can we disable direct map removal for errata systems using TDX only,
instead of all TDX?

If it's complicated to figure that out, we can disable direct map
removal for TDX for now and figure that out later.

> Then there is the clfush. It is not actually required for the most
> part. There is a TDX flag to check to see if you need to do it, so we
> could probably remove the direct map accesses for some systems and
> avoid temporary mappings.
>
> So long term, I don't see a problem. For the old systems it would have
> extra cost of temporary mappings at shutdown, but I would have imagined
> direct map removal would have been costly too.

Is there a way to check if the code is running on the errata system and
set up the temporary mappings only for those?
