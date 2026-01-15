Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A092312807
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505993; cv=pass; b=H2LrwKDFxnlnwyucllhXfpPW9/SNlosvxtEb3+JdxjA74GQ8Cx13//CGO4rx4YWBFlzr1K7Ce5dVs+8JhS3ckbZPeK6uvPa3nvNaqbrU+WTeudsCsf0ivn0xbOa0JCSu8moUXwCDqy6jgutyclh2uSrrrkWCTNuzuTEq4UAlFOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505993; c=relaxed/simple;
	bh=8lDpvZLaR4z8lIctcEKx9lDd0Hg9OXd26QzQJA3m9FE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwidKIrjsQnNf5wjVM6sunzl7n72O4lVb7R+zKoTefpEwUJdlZb5hzXuqShJRQRyLe5EkNwpm7FK7L4Zt3gWcTyvEdVr/yaDhuqqVQQxc2MI1h5ZgT0woUCExV9EuLKEWWcB0OTTUaYQZ/Kf1ZoF8mG2ZRKqNVFzGUvic20Q8Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2QBL1ESN; arc=pass smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QBL1ESN"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5ef3482907aso947873137.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 11:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768505989; cv=none;
        d=google.com; s=arc-20240605;
        b=lBhLkm6MH4O9E2/SvI4Yc4kmwdQm4mxnSg+ONrODBQgkcRgx8R9k/6WIJDwW5y0nud
         /LkmMyyb5lA3Yyymh/uSW1Rate/h4/eiLY17vgMYuxyXEsjDBaq8R+OTTwYLsNLWnSEb
         r1LNKEsm7bbV2ziEZq8fsWFa63PWxQe/stmoLQEl3WSIMcFpYrMzbKD8k5aeVaVS3ZA2
         sWTOCMzoc7ghN3XQWDavu+ipsOIlRbAXih0HR4d+lozv3T7GO/ZOoMayIU2rIAd/rXTN
         9RT5XpP8KD9FS0Fjxe2CP+mViWqOPx0E7S6KfH8nOU/2CBRmaA8ePslwkqZL8pf9UjZP
         c8/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        fh=s3nakyW3xwFc/BX64zTF/yTBLTnlfBbxEfxDOTjKVhY=;
        b=EBvNHHilAYC8oYeeEzeMaInHX4yiQgLLiimx4Q9trhhS1llmj1rdbDs/viqoRhzvWh
         gC0Z4VEYWuOcEE+/dWwPSw1gQgDl4kJe32tyoZucEoIfTSBghX3BFNsORAOaGkLvATTx
         Mlq0oqLUl84+nDCHcud8v/iLMubyZR8bT1D/QvZS8hVHTiov8fYnXlFlkzOqDN7b4xq2
         r+7P9mV2L88F6tvW3nKNMHSfcSe6hy2fazcJoz+WHsIJfM1fUHwB09qUGHFIIIm1yv+9
         IK/2+8p0M3erEiZ/4S4rHpEb6PFp/e+sw93p38obsBrrHYh8PxvnFaphJ4HHszi7BzAD
         OmQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768505989; x=1769110789; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        b=2QBL1ESNO5T031MbY3P+VYXcFPmCVxqa1WLc9M+ilraIjU0VL6gQUEhCrwI6KIfuGH
         8keK8mM/U2NZGZ2UxE5SxPaRKmXxK7fbtqTRwXVTa5PO+EZ1UL/52RMmfbkJS4tCBfoe
         5XF36oy2Y75VTHeC84ZFfiC4DARA6Spk3eF4atQBRCjnMhxJcr7lILBtB9GFoCMJsHZT
         QlFodkwaPlCInZGTTxn4iVflzS94E+3CGkEqiDRTuybn2TbF+9wIlRboAqggl9/pccIv
         hLbr7C1dGhDuv9jJ5B8zEmPBz/TRiU/GIG/snWoofpxjxqAENKGRl0IgkITAfQsKWDsm
         MmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505989; x=1769110789;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        b=mj0XwYwZVE/IdGFc0bzc/07wA/QDRHyzV0IzpOGSpCEd25y+7VD/ugINJ9dvYrTzVq
         3/Rne6YrtqcktaVJVVgmMLtgfG8f5c5ZTzls/cxuu1N1/1MqEuseXbpMaPaWsvmgxHSm
         CaNBorFjJpuPKQmpsJbzI4eERgjRRc/g5QI6ZHHWc9v2233vY3K4h0+tvGEHZD7Za5lC
         q5g1XN9YQeH08qPX4S+q1EVHeXDkvtZUlCt8j8LVf94BKo5p3k9CRhHLvQW4jrnsmZvs
         0xxLqqCz6EN51jIYId5iLN6Gij5kNjDw4IP8wo5qqF2h1dcWJoMbz9BNKO/zIb9h/8U6
         YmdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWH/MB3FLVdKFjjUpoL6c7eRnuPJrPZSUx431KS0kGJJbT/OtVe1lE//iINa0VXU1NiJZvd2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZyLO/7uablUXMmtbr7Swe2Oxy9dVzXRYLOGxURG8BCh3Kr/DN
	69oRW9vtE8gqL4Tf4a2YquqQzRjd5n1YhIibDF4a6FJ8lCONTtlzF3z9vsCIixRNFANHAXRh62V
	SkaQQ8q6ze8QLGnjYPrsWTeA24ESVOXriHtPqUbzt
X-Gm-Gg: AY/fxX6TSubjSbsxXzyUw2oBogQDBpxPRpUdcKcIOFOSXmlnkhvgu4TM5EAlCM0UNVx
	hBPMKJNqodRkWsl5UPY+StMIQ/RGR4cSATKE80RVHuKLTZnxtJ15qeN5u/Z8/VOQcy2iY5ub2Fn
	Oorug55rpYlbXm9RwDFUy8LAWdjlV1IcX6CMuP6OuXVHGwjyc6SMXMMuaHVsSc2tScwAVbKQGzD
	+fLymthbTU18wS3E2FcnUMZk5ylnQKu4PrVOhOejAw2K9RSy1HRTAkVo9C773DD7wwxDiaTiJCX
	i99Y0vYQGsO9ZavIP6k5QVQoSR6fmcliKaVG
X-Received: by 2002:a05:6102:3708:b0:5ef:ab71:cbcd with SMTP id
 ada2fe7eead31-5f1a4d8ce85mr377168137.7.1768505988665; Thu, 15 Jan 2026
 11:39:48 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 11:39:47 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 11:39:47 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-10-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-10-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 11:39:47 -0800
X-Gm-Features: AZwV_Qiu_D8foB8Z5ZjGyCrmwdkqsKcMaz5fdNTkl-JawXW8yxxzsPZp7V4tbiI
Message-ID: <CAEvNRgGz2gRu2i+OSxasuyZudqsRGXijbDES8uXVe_hH6QCK4g@mail.gmail.com>
Subject: Re: [PATCH v9 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if
> a guest_memfd is passed in as an argument. This eliminates the
> possibility where a guest_memfd instance is passed to vm_mem_add(), but
> it ends up being ignored because the flags argument does not specify
> KVM_MEM_GUEST_MEMFD at the same time.
>
> This makes it easy to support more scenarios in which no vm_mem_add() is
> not passed a guest_memfd instance, but is expected to allocate one.
> Currently, this only happens if guest_memfd == -1 but flags &
> KVM_MEM_GUEST_MEMFD != 0, but later vm_mem_add() will gain support for
> loading the test code itself into guest_memfd (via
> GUEST_MEMFD_FLAG_MMAP) if requested via a special
> vm_mem_backing_src_type, at which point having to make sure the src_type
> and flags are in-sync becomes cumbersome.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 24 +++++++++++++---------
>  1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8279b6ced8d2..56ddbca91850 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1057,21 +1057,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>
>  	region->backing_src_type = src_type;
>
> -	if (flags & KVM_MEM_GUEST_MEMFD) {
> -		if (guest_memfd < 0) {
> +	if (guest_memfd < 0) {
> +		if (flags & KVM_MEM_GUEST_MEMFD) {
>  			uint32_t guest_memfd_flags = 0;
>  			TEST_ASSERT(!guest_memfd_offset,
>  				    "Offset must be zero when creating new guest_memfd");
>  			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
> -		} else {
> -			/*
> -			 * Install a unique fd for each memslot so that the fd
> -			 * can be closed when the region is deleted without
> -			 * needing to track if the fd is owned by the framework
> -			 * or by the caller.
> -			 */
> -			guest_memfd = kvm_dup(guest_memfd);
>  		}
> +	} else {
> +		/*
> +		 * Install a unique fd for each memslot so that the fd
> +		 * can be closed when the region is deleted without
> +		 * needing to track if the fd is owned by the framework
> +		 * or by the caller.
> +		 */
> +		guest_memfd = kvm_dup(guest_memfd);
> +	}
> +
> +	if (guest_memfd > 0) {

Might 0 turn out to be a valid return from dup() for a guest_memfd?

> +		flags |= KVM_MEM_GUEST_MEMFD;
>
>  		region->region.guest_memfd = guest_memfd;
>  		region->region.guest_memfd_offset = guest_memfd_offset;

Refactoring vm_mem_add() (/* FIXME: This thing needs to be ripped apart
and rewritten. */) should probably be a separate patch series, but I'd
like to take this opportunity to ask: Sean, what do you have in mind for
the rewritten version?

Would it be something like struct vm_shape, where there are default
mem_shapes, and the shapes get validated and then passed to
vm_mem_add()?

> --
> 2.50.1
