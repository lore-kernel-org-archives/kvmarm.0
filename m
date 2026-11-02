Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629349;
	b=Ikoi1qLu9APYBssTcf3wvgXmsibKUlLV7Xj9/JqIH2lxhA9b73g7Zn/WNZo8UGalo5iu
	 cw789Q1/6VpXRveglARNu5/mz/ZAeTMTpjGqM1v97aV9szyTpsedrggVorpP+L6Cuu07t
	 LZZvw1RnnxmuVRfzndTXW1EXuphGMdzWIlg1ilorC0aXHi1UHJY2BT6p+seJerETV4uBK
	 /lALosbnBIBpxGGDyKDzEGaJfq2x+te2lBFSDjcxvj8ThXX5cPc1gotoh0lImFyeAOLyo
	 1JeLrfRc9vVkGf4VvstNJOFQrDAvNdaXwa6MD24CUT/vuq/0666DbY24wdeAGNKbSkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6CgjKg/3/psOIxUuK5q285w2IQi6C1pf40CdYrOsTT8=;
	b=Je+fGZgZD2M35lhmsaTpYd7uCQnmqZzD9oBdAgFzHCmWagDOEJXSkv7o9SBjeOZxvhxs
	 PyY3tslI8vuMy0wo/ZhahMDSke/5VC6zGAwfvr7BxeIBAnLik7p8/KEgOjuOljILlED3e
	 Fj6xfS12uwid8fCE1jWVlu9DraektSphP8+vcLIkgz+I0kv57aakPpDbLCjs4EpF3zLqz
	 qZux+vRApJGGmQeDFK7jGzy74xevFhYZbRmx0w2KP/mMwvAKItIoWmRSDJidhahlbQA6v
	 Teodur4HJt+LvsuJLKH8YZ6HaLWRPng5kI0I7l5YFB8Uo6RKpO0KfoNAT1nTMvTgPiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Njn8ahYw;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0750560A3810
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0750560A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Njn8ahYw
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso35599915e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 06:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793629347; x=1794234147; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6CgjKg/3/psOIxUuK5q285w2IQi6C1pf40CdYrOsTT8=;
        b=Njn8ahYwFOmavdnepeJ8zaDCLuJLA96KzVT3zp1BoCDWqNhQQo3DKXeSkgdc1JFnE4
         wsW4C9izIp983KMfpXHTeBFnGsJIn5oxNg1QbdAdun0kt01HptDsy1hekCfsZ4G0fmKs
         jDow/wKlBGp7cjThK5Y1dIhidMCrDoLsYHQm+xPbvqheBpzVf8ckgyJn8poC4q8f0moa
         th2rR24KfL4B1j1OJkr5iPrtPLJYWU1n534XB30VDjbHbb1yTw4Lj5GJ3X5W35dN2LkY
         n87auvZc+Ah/4vU/RBokXTzd8Wqmx2YRsI7vgUtxtSjKdEN+zzh27xxTC9C+bYSsLeI6
         WPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793629347; x=1794234147;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6CgjKg/3/psOIxUuK5q285w2IQi6C1pf40CdYrOsTT8=;
        b=WJsgAMcUV4atAFJStm6ICszrL9anW97BH+cCowrFmSnPeamk0XHp1NQOXC6oi/IRPN
         3gUR25r65uGvbB1xxYxENpZJIJ6gSGcOiLsQN9CytHmggZDkXkpMLd/8OiJdPqzIRCBr
         ZK5dX9N72Ldr4qOlzZxbIXZgqEk8TXwX9VZ5caPiZNXwIyV5/SsST9IltebMPTjWySxr
         veL1khvWRaOyXQt+C7YwHjm6gohnWPX3iwHGuhtBMCWvfaNTiB4hSh90tFooaxb5S4F1
         3rT7WrMefdGceuvr2YIscdKqZ1sH7NjA/MKly45cGuJEP7vFs5Ton00ZtH1pWNCzA6Ls
         Bkmw==
X-Forwarded-Encrypted: i=1; AKwUvBzpuOG+LTrMf9pP2a/lytxYgB6+qQvuDjUigEhaDYkyQKvE3sP/muKQ9Pz6Gp9BxbPJIq4kNXM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJox/wN7Fr1cgVuaHf8Wv9jdhQA0fkkqA627v8l7QLR3xjSR3S1
	e0ao1G8tpXFUtL0ibsN89sgjWAHtGhM6j8xUwlFvbVBeONV1fBVBaD+paSRocFqMSg==
X-Gm-Gg: AYBFou3UePsNiV1c03GCIyge/xoXQ01XcyeKta0VhSfyTRxtuPS9iMsG5pGppef4vXW
	LECHID+ByeoT1xbdmXhKzzFPORho6GwQaSj0xVx8xDWhbdIHT50AHvqZKmI0dTm7v0DaIe1sm84
	Xdr65qJccOPDtdmCnQNZz4TudWL/imc73+OzN10uVMFV4ynhZQ6cJrCAgTEZqLNjE8cYxVShyi8
	56SWKJEDHwFWOlVboyn6zWagbysYJ+loWc30+tJvnOYH/GU35aAuhviLMHY4FIRWurh07vTpMvG
	fmVmIpDy2tsCma9fLWpVdzxgsutIxlW5rML/kAt4jfUGdcj8vbNFH7cDMLEAvUEZfDFVml9ZyWW
	htHTLJc7eKJUBmR2/VlD82+HlIM00obtF9rQlAgl4iIeXGr1cLXsJ5k3lzcBuA0zkcXIJYATZi8
	RbwWzZg7IrmTmpFj5ZYIkpLxvozmSl2knbxq9TZAnkc09pDEXk36HItqBPAEwar8bam+fQ19JRB
	7f5jIxK0BzQmbHtY4EQvh50dCJ+YBavoTMHg0KTW+RfmMmeLWlnUYb1tnQhvZ2rZ8HHJ7jbX7p8
	xVhAuB68mp+IUrN2UjvwVuLrFr7E4Ot1XWCunOp9guKEguJTyvMWxi2mmdoGiOTw
X-Received: by 2002:a05:600c:a4c:b0:4a1:fba8:b13d with SMTP id 5b1f17b1804b1-4ac17d16ba4mr230939115e9.9.1793629346820;
        Mon, 02 Nov 2026 06:22:26 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa820492cesm377375025e9.13.2026.11.02.06.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 06:22:26 -0800 (PST)
Date: Mon, 2 Nov 2026 14:22:23 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com, tabba@google.com
Subject: Re: [PATCH v2 22/22] KVM: arm64: Stage-2 huge mappings for protected
 VMs
Message-ID: <auicn7PMiw-gezy0@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-23-vdonnefort@google.com>
 <20261029152959.3552746-1-fuad.tabba@linux.dev>
 <auNw0iXzwKkOSJAa@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auNw0iXzwKkOSJAa@google.com>

On Thu, Oct 29, 2026 at 04:14:10PM +0000, Vincent Donnefort wrote:
> On Thu, Oct 29, 2026 at 03:29:59PM +0000, Fuad Tabba wrote:
> > Hi Vincent,
> > 
> > On Fri, 11 Sep 2026 14:50:53 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> > [...]
> > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > [...]
> > > @@ -513,17 +512,23 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > [...]
> > > +                /*
> > > +                 * If a huge mapping overlaps an existing PAGE_SIZE one,
> > > +                 * then the VMM has played games with the stage-1. Abort.
> > > +                 */
> > > +                if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
> > > +                        return -EFAULT;
> > 
> > A guest can hit this on its own, without the VMM touching its stage-1.
> > I ran into it while porting your unposted v3 to android18-7.3, and v3
> > has the same race. A pVM shares one page of a 2M block, and another
> > vCPU touches the block during the split's break-before-make. The host
> > sizes that fault at 2M from the THP, but under the mmu_lock it finds
> > the split's PAGE_SIZE mappings.
> 
> Nice catch!
> 
> > 
> > I made the following change in the android18-7.3 port. It maps just
> > the faulting page, since retrying alone re-faults forever if the VMM
> > puts a fresh THP behind a partly mapped block. If you're happy with it,
> > can you fold it into v3?
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 70b002eb17e05..72fc2577f51cd 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1921,6 +1921,7 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  	struct mm_struct *mm = current->mm;
> >  	struct kvm *kvm = vcpu->kvm;
> >  	void *hyp_memcache;
> > +	u64 size;
> >  	int ret;
> >  
> >  	hyp_memcache = get_mmu_memcache(vcpu);
> > @@ -1936,13 +1937,21 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  	if (ret)
> >  		goto unpin;
> >  
> > +	size = s2vi.vma_pagesize;
> >  	kvm_fault_lock(kvm);
> >  	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
> >  		ret = -EAGAIN;
> >  	} else {
> > -		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), s2vi.vma_pagesize,
> > +		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), size,
> >  					      __pfn_to_phys(s2vi.pfn), KVM_PGTABLE_PROT_RWX,
> >  					      hyp_memcache, 0);
> > +		/* The block may hold PAGE_SIZE mappings from a split: map the page alone. */
> > +		if (ret == -EAGAIN && size > PAGE_SIZE) {
> > +			size = PAGE_SIZE;
> > +			ret = pkvm_pgtable_stage2_map(pgt, ALIGN_DOWN(s2fd->fault_ipa, size), size,
> > +						      page_to_phys(s2vi.page), KVM_PGTABLE_PROT_RWX,
> > +						      hyp_memcache, 0);
> > +		}
> 
> I do not believe the retry does anything, this would just hit the "if (mapping)"
> path in pkvm_pgtable_stage2_map().
> 
> And in any case, the split will remap the entire range at PTE-level. This is
> just transient and it is safe to return EAGAIN.
> 
> To keep the return -EFAULT, I could eventually mark the mapping as "split in
> progress". 

I convinced myself the retry is actually interesting for the case where the VMM
is playing with the stage-1 mappings. The non-protected case supports it, so
there's no reason for the protected one to not. And actually it does support
directly into pkvm_pgtable_stage2_map(). So I believe that's where any sort of
retry should happen.

So I will try to refactor this path to avoid discrepancy between protected and
non-protected.

-- 
Vincent

> 
> -- 
> Vincent
> 
> >  	}
> >  	kvm_fault_unlock(kvm);
> >  	if (ret) {
> > @@ -1953,6 +1962,9 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  		goto unpin;
> >  	}
> >  
> > +	if (size != s2vi.vma_pagesize)
> > +		account_locked_vm(mm, (s2vi.vma_pagesize - size) / PAGE_SIZE, false);
> > +
> >  	return 0;
> >  unpin:
> >  	unpin_user_page(s2vi.page);
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 8a74df9f9fec3..6b5df4595f6a6 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -650,14 +650,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			return -EINVAL;
> >  
> >  		/*
> > -		 * If a huge mapping overlaps an existing PAGE_SIZE one,
> > -		 * then the VMM has played games with the stage-1. Abort.
> > -		 */
> > -		if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
> > -			return -EFAULT;
> > -
> > -		/*
> > -		 * We either raced with another vCPU or the guest PTE
> > +		 * We either raced with another vCPU, a block overlaps the
> > +		 * PAGE_SIZE mappings of a guest-driven split, or the guest PTE
> >  		 * has been poisoned by an erroneous host access.
> >  		 */
> >  		if (mapping) {
> > 
> > Cheers,
> > /fuad
> 
