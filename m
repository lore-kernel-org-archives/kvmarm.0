Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC356024E
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708681509; cv=none; b=n7/aDG0sdY1dKh2N7EjdG3BwwP52yyFVNPARp88iZ3B+LIYDpMyJFbZkLXm7/Hd4aP6tToE928seXtBoZeCrcB+K5j1GngyTnLu+JNC4RB84eGqjkhKInHkSqTkm2yRdx1cfZVFw58C1X3YZ1aqAq3KvF3gn3eumeOgCR2iIY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708681509; c=relaxed/simple;
	bh=nlADwHXiU4N2bYbFdKbmDq3H7h/qowAgPBvAt1TmE0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftLp0LDwFbZEz/DrzrFk2otkDAuym0oRLyAkoJZ9IXCV7vuBrCLVPdP+fZMlCFCXeYNoxhG/B7M65RsEwgpA7FPG8f9Lq1OGEqh1VeEFMDHM793JJR6ChGIuMmKe3oURUShVC6Qotbw6zppCyxsgJ+hvEZlfpOlyvy6yrl8YCQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0FijeHc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0FijeHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708681506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRfdfPpvcbsTygicFCTkhEAznNGxCZy95wBHIu3kazU=;
	b=X0FijeHcZgSZ+pcTn98MZoLJANKO/URXJJNtZXO7aKsP/nK3hn4tz4pj0N4htIS3FKc049
	hkj3Hp85VK1t5KfgcBd+mAoRGWbuKsjlVTYb9SPIXj5uerdL+UC5ZN9vvmCUn7Fg8A6UfF
	5xSyKC88JamqNtIcUrJBWOF+O8PHYBE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602--kLTHK-vNISPbKm2yc9Pjg-1; Fri, 23 Feb 2024 04:45:03 -0500
X-MC-Unique: -kLTHK-vNISPbKm2yc9Pjg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-55fee28d93dso337857a12.2
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 01:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708681502; x=1709286302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRfdfPpvcbsTygicFCTkhEAznNGxCZy95wBHIu3kazU=;
        b=px/g6JjJo0f25yRM2XUb+B9rJkW2t1++8FgRptFyVsYA7Zv6DHQpIKKsQhyLOBjqlI
         Wz75SZQ4I8fyBbBcLPx1k58uaBvO4C5FQCrP5xdnaKgVLRLdGsw4fYvf+diECI/4gtDT
         W/2pnEHLSOyLJLPcgnfBv1/9aEJvtcxnbARR5WZ7gQr7OksHs3evRfS6qUimaazxZyQr
         dmlNQUH1qaps0z2SYH1RlJWti9Osk8mxg5JHUN9ZNB1XpQl1FmyBSQSY3pfqEot6+V2u
         g0kpXjS8cCakoEJ7UujG/kCq1SMSsWxDZEpigwAgO+EcPNhXPzEvyQLlaIz/sp9pt6yh
         6C3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1ZiAb1OdO6kvVOiewXYogd5yyTZYZqhAVRAKqcsrPbdWUa8ZrH7rNQADYWYuzZv3PzFHVx/iIg8vshtzSFdlwenPgY+vr
X-Gm-Message-State: AOJu0Yz0wcvklNLA4cfgOl065nVt/cxPj8S2kr3IHUv6sN+ehbsgFECa
	QwTsKFRggfNTa7bulhZ6uMc/4J5waUEVsxsKFjTOjopHV0FGJeo9EEo8AoFGlNXgVuAF7xJuc89
	obm+o8b8Syt80E6jOF2H1vINT2WmFlXF+X7QXJVDm0ccSE2ivlIVUOA==
X-Received: by 2002:aa7:d61a:0:b0:565:66df:8911 with SMTP id c26-20020aa7d61a000000b0056566df8911mr829564edr.23.1708681502347;
        Fri, 23 Feb 2024 01:45:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuMH8683DYRbpq6LcJc7yYpMd16t4+gnDIDbjWin5j56q72c6x9PsXt0q/N0ive6BiuPfdQQ==
X-Received: by 2002:aa7:d61a:0:b0:565:66df:8911 with SMTP id c26-20020aa7d61a000000b0056566df8911mr829552edr.23.1708681501967;
        Fri, 23 Feb 2024 01:45:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r10-20020a056402034a00b0056524c91e18sm1601708edw.2.2024.02.23.01.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 01:45:01 -0800 (PST)
Message-ID: <92a21507-b179-49ca-b0e0-d0aea69ab3a3@redhat.com>
Date: Fri, 23 Feb 2024 10:44:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/8] KVM: allow mapping non-refcounted pages
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240221072528.2702048-1-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 08:25, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.
> 
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page().
> 
> First, this series replaces the gfn_to_pfn_memslot() API with a more
> extensible kvm_follow_pfn() API. The updated API rearranges
> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> bool arguments into a FOLL_ flags argument. The refactoring changes do
> not change any behavior.
> 
>  From there, this series extends the kvm_follow_pfn() API so that
> non-refconuted pages can be safely handled. This invloves adding an
> input parameter to indicate whether the caller can safely use
> non-refcounted pfns and an output parameter to tell the caller whether
> or not the returned page is refcounted. This change includes a breaking
> change, by disallowing non-refcounted pfn mappings by default, as such
> mappings are unsafe. To allow such systems to continue to function, an
> opt-in module parameter is added to allow the unsafe behavior.
> 
> This series only adds support for non-refcounted pages to x86. Other
> MMUs can likely be updated without too much difficulty, but it is not
> needed at this point. Updating other parts of KVM (e.g. pfncache) is not
> straightforward [2].

Looks good to me, apart that two patches were sent twice.  I only have a 
small comment on patch 4, to which I'll reply separately.

Paolo

> [1]
> https://patchwork.kernel.org/project/dri-devel/cover/20200814024000.2485-1-gurchetansingh@chromium.org/
> [2] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/
> 
> v9 -> v10:
>   - Re-add FOLL_GET changes.
>   - Split x86/mmu spte+non-refcount-page patch into two patches.
>   - Rename 'foll' variables to 'kfp'.
>   - Properly gate usage of refcount spte bit when it's not available.
>   - Replace kfm_follow_pfn's is_refcounted_page output parameter with
>     a struct page *refcounted_page pointing to the page in question.
>   - Add patch downgrading BUG_ON to WARN_ON_ONCE.
> v8 -> v9:
>   - Make paying attention to is_refcounted_page mandatory. This means
>     that FOLL_GET is no longer necessary. For compatibility with
>     un-migrated callers, add a temporary parameter to sidestep
>     ref-counting issues.
>   - Add allow_unsafe_mappings, which is a breaking change.
>   - Migrate kvm_vcpu_map and other callsites used by x86 to the new API.
>   - Drop arm and ppc changes.
> v7 -> v8:
>   - Set access bits before releasing mmu_lock.
>   - Pass FOLL_GET on 32-bit x86 or !tdp_enabled.
>   - Refactor FOLL_GET handling, add kvm_follow_refcounted_pfn helper.
>   - Set refcounted bit on >4k pages.
>   - Add comments and apply formatting suggestions.
>   - rebase on kvm next branch.
> v6 -> v7:
>   - Replace __gfn_to_pfn_memslot with a more flexible __kvm_faultin_pfn,
>     and extend that API to support non-refcounted pages (complete
>     rewrite).
> 
> David Stevens (7):
>    KVM: Relax BUG_ON argument validation
>    KVM: mmu: Introduce kvm_follow_pfn()
>    KVM: mmu: Improve handling of non-refcounted pfns
>    KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
>    KVM: x86: Migrate to kvm_follow_pfn()
>    KVM: x86/mmu: Track if sptes refer to refcounted pages
>    KVM: x86/mmu: Handle non-refcounted pages
> 
> Sean Christopherson (1):
>    KVM: Assert that a page's refcount is elevated when marking
>      accessed/dirty
> 
>   arch/x86/kvm/mmu/mmu.c          | 104 +++++++---
>   arch/x86/kvm/mmu/mmu_internal.h |   2 +
>   arch/x86/kvm/mmu/paging_tmpl.h  |   7 +-
>   arch/x86/kvm/mmu/spte.c         |   4 +-
>   arch/x86/kvm/mmu/spte.h         |  22 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |  22 +-
>   arch/x86/kvm/x86.c              |  11 +-
>   include/linux/kvm_host.h        |  53 ++++-
>   virt/kvm/guest_memfd.c          |   8 +-
>   virt/kvm/kvm_main.c             | 349 +++++++++++++++++++-------------
>   virt/kvm/kvm_mm.h               |   3 +-
>   virt/kvm/pfncache.c             |  11 +-
>   12 files changed, 399 insertions(+), 197 deletions(-)
> 
> 
> base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478

