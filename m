Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE80085643
	for <kvmarm@lists.linux.dev>; Wed, 17 Apr 2024 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396460; cv=none; b=qD6l/NPCY9daeDLy1dqiVSB32OKanLd+mtAvLzlQ87JIt/ecQc8WNgVeLh7idOHXsZVLUV5dw12PwXnCFv9DI9oAG2eVm4U4peoZEECAI8v8nqpMCuxFV0QlcHh+7d8DWgsDq79wz03n4eKxOz3HutL33yFvEgEEZevfHFCQBOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396460; c=relaxed/simple;
	bh=sm5qWoL4TEVBvLhxN3SGp78DDIogApq/R3F3I+iYIyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cq6T7Nh88llbypeugavr4pMa1ma9h5+TAh+nuo/VexD2p4Qg3zYw5WUiPUQdQmeg9A9b5bxUt9dyoQvK1Cnz21vJSHwWuppd7iewkrcDZKquoSkKsN0uRKF/pAdNsftPD4q8fpWFkXX2+x6BX1rtV1fEzzwoiQCxg5HIjqpFP6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Geb0Ayt+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Geb0Ayt+"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed2e00aa22so388316b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Apr 2024 16:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396459; x=1714001259; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E6/yv8l0tAnEX2YrJeZG4x+G9i8KZY08S/JjSb9nTEM=;
        b=Geb0Ayt+fOAbC5G1T/n7y7GEL9rG/Qly5ADBlV3tYR7A2eM/C6Q8TIyTA9FWjNXGMC
         uIn0gWRApm2NesmlpjpBA6sMu5vazUZJAxmux8Ae2N11DUr7Z6Sz6IIHy2kvQuv9TBAF
         YiDrhok8sGepPqf64qPpYHB705HxgDtKoao7uhNKuVDNeuHj5Ol7x1k/lRmqdg+GRB27
         t1YoOrSuAmzj6sJiVMMQy6ShenyIl4SaRwvrp50qt9jrfMqd0ToQ6MiyaO45yCMSRSgm
         al64XzeU8uUEFFOnrMWIHJ4R1CamXzWBW9AJxIUHIkhWSCOZDxf5/Rg0CarUVfVcWD5i
         PoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396459; x=1714001259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6/yv8l0tAnEX2YrJeZG4x+G9i8KZY08S/JjSb9nTEM=;
        b=XFMtkjeLTyXlCsLsvUH5ZSaIpewwkSPH3PaxYJ+Um1ZRQx379pk5VZHW+NNru3RgHP
         h9U8uerbAVgi76jCtWaDYFxQUwMcuqm9ipJEg8hBf3CG+UOUkjhUU5Q5xfg92FVvXask
         tQLgz3XmwEyj3IV9b597gnUJAWSz9ZOeDrJxgyiR46wTLHyra5ylagMyOA49cRGUJYaF
         ZEtcSHAJ789e6r1JtiCZA581o8knnLIIN4Jes6ZtMcsClrAHWmo30gTV6lK5DJXmiISM
         HYnGe7rahWsNIVaPWp5PSY/9VwGH9KM7CQNkrG3goWIlIYTPKLTgemKLZEkk0PzR2qY9
         ajQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQTytc8oE14u4t+LLzhqgA8cFFI1zLflQpx4Na5CfupCzWT1F8ME5FVwGfQU+gBjmyEiEBPJm4nebbX5lH+9/fxpz/2yLx
X-Gm-Message-State: AOJu0YwwEF8pW1e2xC0PsIyphQB9VYkcJwtX4jHrs5yVTHlXfwRCPceu
	8WeRQeVpYC8uCc7JXeKHi0Ck8B3UAZ2poMK6NH5cvnUhOoS4+YPm8jF1TN+pGMILsOj4kgQEXo3
	pRQ==
X-Google-Smtp-Source: AGHT+IHRmT8hE59YdeqOABN9tJyRZX+WT2IsjNfAQcQ0lhinhviSJraFpoR1lplfXvbmmqqfGWbU0WcTco0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4616:b0:6ea:afcb:1b41 with SMTP id
 ko22-20020a056a00461600b006eaafcb1b41mr94251pfb.2.1713396458918; Wed, 17 Apr
 2024 16:27:38 -0700 (PDT)
Date: Wed, 17 Apr 2024 16:27:37 -0700
In-Reply-To: <20240222161047.402609-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222161047.402609-5-tabba@google.com>
Message-ID: <ZiBa6dUWwp8_341k@google.com>
Subject: Re: [RFC PATCH v1 04/26] KVM: Don't allow private attribute to be set
 if mapped by host
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 22, 2024, Fuad Tabba wrote:
> +#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
> +bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), gfn_start, gfn_end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t start, end, i;
> +
> +		start = max(gfn_start, memslot->base_gfn);
> +		end = min(gfn_end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(start >= end))
> +			continue;
> +
> +		for (i = start; i < end; i++) {
> +			struct page *page;
> +			bool is_mapped;
> +			kvm_pfn_t pfn;
> +			int ret;
> +
> +			/*
> +			 * Check the page_mapcount with the page lock held to
> +			 * avoid racing with kvm_gmem_fault().
> +			 */

I don't see how this avoids a TOCTOU race.   kvm_gmem_fault() presumably runs with
mmap_lock, but it definitely doesn't take slots_lock.  And this has slots_lock,
but definitely doesn't have mmap_lock.  If the fault is blocked on the page lock,
this will see page_mapcount() = 0, and the fault will map the page as soon as
unlock_page() runs.   Am I missing something?

I haven't thought deeply about this, but I'm pretty sure that "can this be
mapped" needs to tracked against the guest_memfd() inode, not in KVM.  While
each guest_memfd() *file* has a 1:1 binding with a KVM instance, the plan is to
allow multiple files per inode, e.g. to allow intra-host migration to a new KVM
instance, without destroying guest_memfd().
