Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5683E5A27
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379353; cv=none; b=Xt0qj+U4lsniEOOBVJ//+sZ103Z1PdPwFJ0McXBHSynuOK5e8VgBKWFtX6fKxO8wWZi4GyPkXWfxz4Wug9mPbOntYQYTYu3UQSEH+ibn1/2IxEvqn+89lO+rqVU18Pz6JXXyBq961MMy9CjCWJfsw2rjVFtbV2WyBf+U0P1LKFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379353; c=relaxed/simple;
	bh=SW1o9/3vzefq6CY9xoPnNHfpwHwzSagMpBe7uibVwaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bPHiyoH3iSDGuBPDBN73Y+D5454i2DVRVCSzV6UPJnKICER9PjMh+UEOE9NtbptBMjOK0XySXOH8mpaTR7QDu7yhyltu75h5E+YUNpyKL7NntQe9lNSCtUdd1nZe/eqNmd+Et1d9iTmEsgWp24BDuze9DWinWRvy2y2m5hXcepc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmjEbiXx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmjEbiXx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c9ed5caa3bso841365ad.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 16:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783379351; x=1783984151; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4K4FuEjxEWaUa515sAfxAFrCDsQIRfbKKlPSDfWtK1Q=;
        b=fmjEbiXx6CTA3USDIS0Y02F3re10WocIyIoxl+yhRyWTBmJL2WerVN9BE/JQV3qBgE
         nyg7o00ZAOfZgF93B6VlOtL7OW2VDYVRAWQMioCKHxvndqsCi/Cp1VDzxjlx1x3naGd9
         lVN7fOmiFZcMiELUsq6/8zvQl/v7i0tQzm50BOzn3V81wmbbhwuJlZeSPK22OggrAA58
         R35oevHS301Brik7VHWfFjiRF89xCaaNGGg6IhHqQ9+2lV717wcij21ug/ft2/tuB8zG
         XaEhYP1iSYsBPjooeK90v6bVbGV9vivdqJ5ngFV5T9xkQS8UNCScR7rx6ptFlEvPVwJP
         xcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783379351; x=1783984151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4K4FuEjxEWaUa515sAfxAFrCDsQIRfbKKlPSDfWtK1Q=;
        b=HtSQVhEdVpyfA6HxRTaAOhCB9kHQMZ7pSdyR4L040YPmM4w7PdiFo3O+fA5Dmv2yx4
         52oDwLuD7oCQFyL6gxL5TiQ/q1g26g6GvR5vE/FeqNNeE9SQCkEk0FWNfdt0NyQhRTGh
         K5RpEF6ztJIDOQKmm5doNYi0cIpBPKYHnCRvgawUoVCN2PK8Td71ZjVElENv/NF69O4X
         qXmaJ+u1aRn2jOfpOgBqVvNTdBkcYySVlDpMtSmYprSTDe31LPT/HMeX9xpxyxjDEqVE
         HblrOeRnMoHDaW2iRsp7e3zOuuuCliIy1FjQX4Q49EVUvzxJwMy1frD8tBxcQotspMu+
         u6Iw==
X-Forwarded-Encrypted: i=1; AHgh+RpP1eVa9G+c/WbPAnfniuiKm3g/QG0X8+VYNhhoIhcJz3GTKNbC1tTeoJh5UCkjqsov4njgGsI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfzhuJ0OjJZ/f67fmNZaSe/qf/RqM7gggQlSRDsmISjjZqL+li
	wfl+OVheSewlAbTyYapb1SFkxTMQPlt0xXaX8F621NaofGsf4IwbovoqPv9V/nlwNPHhtXHDeZX
	8bc8t5w==
X-Received: from plbma12.prod.google.com ([2002:a17:903:94c:b0:2cc:9503:aa95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0d:b0:2c9:97a7:3283
 with SMTP id d9443c01a7336-2cccadc7713mr2988045ad.23.1783379350495; Mon, 06
 Jul 2026 16:09:10 -0700 (PDT)
Date: Mon, 6 Jul 2026 16:09:09 -0700
In-Reply-To: <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com> <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
 <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
Message-ID: <akw1lZDEv8_Ub1zQ@google.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, agordeev@linux.ibm.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, alex@ghiti.fr, 
	andrii@kernel.org, aou@eecs.berkeley.edu, ast@kernel.org, 
	baolu.lu@linux.intel.com, bp@alien8.de, chenhuacai@kernel.org, corbet@lwn.net, 
	coxu@redhat.com, daniel@iogearbox.net, dave.hansen@linux.intel.com, 
	david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, eddyz87@gmail.com, 
	gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, haoluo@google.com, 
	hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, jackabt@amazon.co.uk, 
	jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, jgross@suse.com, 
	jhubbard@nvidia.com, jiayuan.chen@shopee.com, jmattson@google.com, 
	joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kpsingh@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, lenb@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	maobibo@loongson.cn, martin.lau@linux.dev, maz@kernel.org, mhocko@suse.com, 
	mingo@redhat.com, mlevitsk@redhat.com, nikita.kalyazin@linux.dev, 
	oupton@kernel.org, palmer@dabbelt.com, patrick.roy@linux.dev, 
	pavel@kernel.org, pbonzini@redhat.com, peterx@redhat.com, 
	peterz@infradead.org, pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, 
	rafael@kernel.org, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, 
	sdf@fomichev.me, shijie@os.amperecomputing.com, skhan@linuxfoundation.org, 
	song@kernel.org, surenb@google.com, suzuki.poulose@arm.com, 
	svens@linux.ibm.com, tabba@google.com, tglx@kernel.org, thuth@redhat.com, 
	urezki@gmail.com, vannapurve@google.com, vbabka@kernel.org, will@kernel.org, 
	willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, 
	yonghong.song@linux.dev, yosry@kernel.org, yu-cheng.yu@intel.com, 
	yuzenghui@huawei.com, zhengqi.arch@bytedance.com, zulinx86@gmai.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 03, 2026, Brendan Jackman wrote:
> There are also the fault paths though; if the pages are nonpresent in
> the direct map for the duration of their life in the page cache (and I
> think they should be) then by the time we get to
> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
> ability to zero them.
> 
> My original answer for this was "that's fine, we'll use __GFP_ZERO
> (which will probably use the mermap under the hood)", but now I've
> realised there's a good reason we don't set __GFP_ZERO at the moment,
> namely that it's wasted if we end up doing kvm_gmem_populate()

Eh, don't worry about the wasted cycles for populate().  The overhead of zeroing
a page is dwarfed by the overhead of adding (and in most cases, measuring) the
page.

We (KVM folks) discussed this in the context of in-place conversions, and long
story short, the consensus is that shaving cycles by eliding the zeroing in the
host isn't worth the complexity.

> (Continued below...)
> 
> > I'm a little bit uncomfortable this statement since it seems to say TDX
> > and SNP aren't taken care of. Would just like to discuss (for
> > a line of sight to SNP and TDX support):
> 
> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
> would be doable but what's the value?

Hardening against consumption of shared memory?  Yes, the guest has explicitly
shared the memory so there are (very) reduced expectations around confidentiality
and integrity, but defense in depth and all that.

For me, the main thing is that I don't want to completely punt on the interaction
of the two things, and end up with an unworkable mess if there's ever a strong
reason for CoCo VMs to support NO_DIRECT_MAP.

> So that we can get a #PF instead of #MCE if we screw up?

Note, SNP gets a #PF either way.

> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
> the parts we need, with dependencies indented:
> 
> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
>   1. AS_NO_DIRECT_MAP
>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
>       3. alloc_flags arg to the page allocator (I'm sneakily introducing this
>          in [1])
>       4. freetype_t 
>   5. The mermap
>     6. The mm-local region
> 
> I originally posted all of those in [0], except part 3. Doing all of
> that together in one series would be a bit too much though. Approaches I
> can see to avoid that:
> 
> Approach X:
> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
>   AS_NO_DIRECT_MAP would be secretmem. 
> - Then another series that fills in 0, 5 and 6.
> 
> Approach Y:
> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
>   implemented by having filemap.c itself call folio_zap_direct_map(),
>   then guest_memfd.c zeroes it via the mermap. It works but it's really
>   slow.
> - Then another series that fills in parts 2 and 4, switches filemap.c
>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
>   things fast.
> 
> Approach X seems natural from a code progression perspective but leaves
> us with an interim phase where we have a bunch of complexity just to
> "optimise secretmem" which nobody cares about.
> 
> Approach Y seems natural from a feature progression perspective but
> leaves us with an interim phase where we expensively zap a page, only to
> then immediately do this complex mermap dance to access it right
> afterwards.
> 
> Any thoughts / other ideas? Personally I think I prefer X.

I don't have preference between those options, mostly because I don't appreciate
the difference.  My overarching preference is to separate the mm/ work from the
guest_memfd as much as possible.  Beyond that, I probably don't care all that much?
