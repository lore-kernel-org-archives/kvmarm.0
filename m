Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBA82C9B
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706810387; cv=none; b=jklzQm8IZbgaDEkFuPP1s8E/i2JZXm5vkvNfZYzRRYN4wW1Uhmm0CI7tPH662VLuAJhiBzryMCviHlIavzTPGzMwmOyC/qsBfnrtUB4LFRMUgb9R0QUWt6tTzPj5jNM6oLRTgmdLYPInYkK6Frae+VwLVs0IlZEW8AbFDLY8jYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706810387; c=relaxed/simple;
	bh=/PO24TQk4cI40ArFvyE5MhsMIUXMZYXmH6IhB1Wc63o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzvlDY7lQtNzhtvx1mrtpLHQlNOwjTjZrx3BG+mWJr+Eml8JdmC+VBxXCl7fb6AfMqtIu2pNvC3UQGFhKKLq8Hfxpx0/5b7rHanDFFRx+aCp2Sa7olQd+uA02ZKDIz4V19Uj4dDwvmEcP9F9XNIiXInnzWDKM2Q44hqKCZ7EDDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o+vsOE67; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o+vsOE67"
Date: Thu, 1 Feb 2024 17:59:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706810383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UiRn0OAJKn5YhuhyJNbq40oER1mFxzuC0QuszMeithE=;
	b=o+vsOE67cX1xR1q2cun6gc/SxqNMLX3rfdAE9bwYDFTb/1IZlfNKvs4B0ySR8Yn9lAKVL/
	dttNn6M5Fk/5SplYdOfsdMevYJf6C3sUoSPANaBW8YzYVgN7FXtX5Yinfwl8fPN7yvaCOP
	HKNpFhqGDq2AHf4zInKSWQcV/n4fKaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kvmarm@lists.linux.dev
Subject: Re: [bug report] KVM: arm64: Always invalidate TLB for stage-2
 permission faults
Message-ID: <ZbvcDMPTWQIf5Vj8@linux.dev>
References: <1479cd6b-a10c-4459-8b34-318865cb807a@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479cd6b-a10c-4459-8b34-318865cb807a@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 01:17:15PM +0300, Dan Carpenter wrote:
> Hello Oliver Upton,
> 
> The patch be097997a273: "KVM: arm64: Always invalidate TLB for
> stage-2 permission faults" from Sep 22, 2023 (linux-next), leads to
> the following Smatch static checker warning:
> 
> 	arch/arm64/kvm/hyp/nvhe/../pgtable.c:1342 kvm_pgtable_stage2_relax_perms()
> 	error: uninitialized symbol 'level'.
> 
> arch/arm64/kvm/hyp/nvhe/../pgtable.c
>     1319 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>     1320                                    enum kvm_pgtable_prot prot)
>     1321 {
>     1322         int ret;
>     1323         s8 level;
>     1324         kvm_pte_t set = 0, clr = 0;
>     1325 
>     1326         if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
>     1327                 return -EINVAL;
>     1328 
>     1329         if (prot & KVM_PGTABLE_PROT_R)
>     1330                 set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>     1331 
>     1332         if (prot & KVM_PGTABLE_PROT_W)
>     1333                 set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>     1334 
>     1335         if (prot & KVM_PGTABLE_PROT_X)
>     1336                 clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>     1337 
>     1338         ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
>     1339                                        KVM_PGTABLE_WALK_HANDLE_FAULT |
>     1340                                        KVM_PGTABLE_WALK_SHARED);
>     1341         if (!ret || ret == -EAGAIN)
> --> 1342                 kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
>                                                                                     ^^^^^
> level is uninitialized if ret is -EAGAIN

Hmm, race detection can happen at any level in the walk and that may not
be a leaf level. We can initialize level to -1 which would provide no
TTL hint for this case.

-- 
Thanks,
Oliver
