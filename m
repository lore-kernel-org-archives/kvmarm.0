Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B9F246762
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772675873; cv=none; b=AO1l7O3k8uF+1toylp24ocYpw57Iwa/SLkRmZF6I3BS2GGfRZteTU0R3vITnNbZCoIEcUDJO0Cdjl9fHHadebHkSgFlqjaY8yogL3fdFUtmUJlqo/x0k3qK1GH0XwArPgwFDqFuSyXbbXvRuDzj6rGuBQGUizp/O24FkdKiKy7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772675873; c=relaxed/simple;
	bh=rqNLfrl6uIKp7fTnPr0b50B06vxw6llmzHFDnZDBymU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHkybYOpSiR6ekGUt6w4uju5nFV/5gh/FVxz6kJLuUTZbpz5GEcNlr4e6wwLqeKUsTVC/XsUlV3nfD06bwKO4P2oOhr+EPKKE42syvfwj0i+YM/meq3dqdCt7ek8wpdTU/o+4DarcxkzdCXc8R/wi+HAqki6IgifDSmYG3+40Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oJ3V+Q3f; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oJ3V+Q3f"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772675863; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=29Bd77wZ7ySfXMFtzHtrifcW2gocYnKQEBKeYTFG2zI=;
	b=oJ3V+Q3fZlCf0Hr7UKk6f3TJ5ciOup4pmNG72wfKwouZbQ5cw3HAKu4dt/OH1mIk54b4pjb8hM5tmrPyQZa7u4dTOGhvTpQFClHDZjwddd98mMkTPuuUuHF0PIwAq4d6NeYimvLAjxjoXxlU0f5wtFDLFNir7oNt6PM2uBkAc54=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X-Gjl9h_1772675862 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Mar 2026 09:57:42 +0800
Date: Thu, 5 Mar 2026 09:57:40 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	yangyicong@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v1 1/2] KVM: arm64: Fix page leak in user_mem_abort() on
 atomic fault
Message-ID: <yjqinaji6r6na4weqy2ne52xfcgr4bp4acm2btrv6ri7bpy53r@mk4fnagzgwig>
References: <20260304162222.836152-1-tabba@google.com>
 <20260304162222.836152-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304162222.836152-2-tabba@google.com>

On Wed, Mar 04, 2026 at 04:22:21PM +0800, Fuad Tabba wrote:
> When a guest performs an atomic/exclusive operation on memory lacking
> the required attributes, user_mem_abort() injects a data abort and
> returns early. However, it fails to release the reference to the
> host page acquired via __kvm_faultin_pfn().
>
> A malicious guest could repeatedly trigger this fault, leaking host
> page references and eventually causing host memory exhaustion (OOM).
>
> Fix this by consolidating the early error returns to a new out_put_page
> label that correctly calls kvm_release_page_unused().
>
> Fixes: 2937aeec9dc5 ("KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ec2eee857208..e1d6a4f591a9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1837,10 +1837,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault && s2_force_noncacheable)
>  		ret = -ENOEXEC;
>
> -	if (ret) {
> -		kvm_release_page_unused(page);
> -		return ret;
> -	}
> +	if (ret)
> +		goto out_put_page;
>
>  	/*
>  	 * Guest performs atomic/exclusive operations on memory with unsupported
> @@ -1850,7 +1848,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 */

Hi Fuda

>  	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
>  		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
> -		return 1;
> +		ret = 1;
> +		goto out_put_page;

I thought the way about do this w/o introduce new label,
but it doesn't work due to the lock asseration inside
kvm_release_faultin_page() w/ if just small changes...

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	}
>
>  	if (nested)
> @@ -1936,6 +1935,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty_in_slot(kvm, memslot, gfn);
>
>  	return ret != -EAGAIN ? ret : 0;
> +
> +out_put_page:
> +	kvm_release_page_unused(page);
> +	return ret;
>  }
>
>  /* Resolve the access fault by making the page young again. */
> --
> 2.53.0.473.g4a7958ca14-goog
>
