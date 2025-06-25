Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC45215191
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750888030; cv=none; b=uqAct3CAPRfspH32LNXni2bjEs9npdb291/HmPVpnjYt2fNKH3RvM1GeuS7FfRAayjjbP0saqU5i3u76dPPwRvlUNFRPS0M9FQzliphEmsWr/uI6NkG2pUMWtKXnJbaa9OGUfKOSF6i1wd2ie8vLg3TG6qD1HCv9xHmQ0T5W6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750888030; c=relaxed/simple;
	bh=JAsyW8eZE863eaSb5j9l0uHjRmiL/MJIXmfT/tJtisw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=byH0UXQxFWyhV0zp91VuhlM+wbEC0pUxZyUkMbqT5OzxRKawOm1tO7qHTpgQF8rWfZOhCUBppDJYgWXGn/lrgavHg3YbysxNAKs2U84M7VgGwblQyTxF6qSMq37Pm+AgBXmQzeDFM3lGdqSwyzY2gcy6Ew9LyAOWZcjVrrfSvGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3M2flUCY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3M2flUCY"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311e7337f26so188375a91.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 14:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750888028; x=1751492828; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JaElZIlxs13I2jfOVX0lSC6FgKZKsuNp0z88behp5kM=;
        b=3M2flUCYbxBVlXFXa6CMcZHpTfp15x0xSWyAKC7aWoJfBPns7XRcqL4hvitxBdLrQf
         FxOcG8uzUhD9OqbJBQDFZCsiiS1r8ZAlbqbuJzkiImh4pFngX5/Eehggga5EFaLifaYz
         C1hwMWa4cqHRGhA9WPvIRwp89TuN6HUP1z52eidN84CCUps8HBzQCXt9pP6oNmyyBFmz
         4rsjA/Y4hN2Aw/A9FJdSZlkg6H6Fvj6DXVEpAdTeQe2lHbhPFRoo3adNe1ccGJIdQztL
         6jk4OIaQp9wlTN4BkrMGKK0Px7BUCkrexafEdEVGMh1BeuYGDM5GVL2Vfrh8F6YQxHHZ
         bwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750888028; x=1751492828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaElZIlxs13I2jfOVX0lSC6FgKZKsuNp0z88behp5kM=;
        b=EAJUzW5lkw6800bwnGsp/Ma+ny1fJ7GZp3woIUUDt9D1CRGOPlrRYmZIqj6gNKlnkv
         NlPmqpD+z4Et/taRUWCHxLeS91Kab7XhTLoXIETqQzkjL0aBcBf9MZ3e/uPF2yoyahii
         XqxvUkQ0sIHZ5lqbXbbszP3dL1bwBTteFs+b5eedJHZR/G2GV66RihtYKlqd85v2qg64
         jusSCUWSwbT8mSTrZwhx0Bd+XNUjLqDh2VJ2mCxNeyLfk3Aa2BRivw8uDPFQ+nTiWjN2
         DN5/byxHUMqVQSLDE1qD0FJZ6kvwx5Qoy4eLL20vEwb0mgsbHzS17v8fku2TMx1XrX0r
         qM1A==
X-Forwarded-Encrypted: i=1; AJvYcCWrlbE2E1g1pmkcnvvaEeqPYRRBCaPghQE48okcyfd1jq8qwdbs2ehZkoj8ffPYj/7VwhR8Sk4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxucNp9wBv5+SrvIDrQjvVLffEkMFaLwPufAARPhxM75fn6YXb2
	crMKa2tiUiwjwq+V9vewZHlbrlghUmT+8lsJw3VuaxV+Mi3ls2/j7WHIvvKnfFBWiyHusrbxpuh
	EPaue9db1zp7ijdBzDHF2F19KMQ==
X-Google-Smtp-Source: AGHT+IHaFOtDsXjNCK8tDRGRC6rpZnF1ravk4aYWxE7y5fg1ChEv8b8QXDGShjJ5f1IXZEq0lP4YBKq+9E7DssxT5w==
X-Received: from pjm6.prod.google.com ([2002:a17:90b:2fc6:b0:312:e266:f849])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5388:b0:312:e1ec:de44 with SMTP id 98e67ed59e1d1-315f268f485mr5936687a91.27.1750888028344;
 Wed, 25 Jun 2025 14:47:08 -0700 (PDT)
Date: Wed, 25 Jun 2025 14:47:06 -0700
In-Reply-To: <20250611133330.1514028-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
Message-ID: <diqzv7ojjxyd.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> This patch enables support for shared memory in guest_memfd, including
> mapping that memory from host userspace.
>
> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 13 +++++++
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig         |  4 +++
>  virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 91 insertions(+)
>
> [...]
>

Just want to call out here that I believe HWpoison handling (and
kvm_gmem_error_folio()) remains correct after this patch. Would still
appreciate a review of the following!

> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> [...]

This ->fault() callback does not explicitly check for
folio_test_hwpoison(), but up the call tree, __do_fault() checks for
HWpoison.

If the folio is clean, the folio is removed from the filemap. Fault is
eventually retried and (hopefully) another non-HWpoison folio will be
faulted in.

If the folio is dirty, userspace gets a SIGBUS.

kvm_gmem_error_folio() calls kvm_gmem_invalidate_begin(), which only
unmaps KVM_FILTER_PRIVATE, but IIUC that's okay since after mmap is
introduced,

* non-Coco VMs will always zap KVM_DIRECT_ROOTS anyway so the HWpoison
  folio is still zapped from guest page tables
    * Unmapping from host userspace page tables is handled in
      memory_failure(), so the next access will lead to a fault, which
      is handled using a SIGBUS in __do_fault()
* Coco VMs can only use guest_memfd for private pages, so there's no
  change there since private pages still get zapped.
