Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5763CC338
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793109; cv=none; b=ODVRNGePPqKPqnSkC/z0JS6nRvhG9s8gm9urNtL6zc+jHwJgtj8kTkPMSc16x6dslKHkhMyyV7C83GbfiBCyoElwjrreDTfgHNvQ6i0UsU1A+Zt/IofA3xYJOiIMt91NHXWTJGCVXYJXMApvA6Sm2i7orXC9yK1+otzI4j4h4Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793109; c=relaxed/simple;
	bh=S52BFuMLtdk3fEiTm/WlGd0vl/me+yACyOJVPNoNoS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0NmoYgqF0vzqI/cR9VKc0XUFPCa9trRlWcXFDItwKzJDZs8+ONvRQxBcWPxNiRYn3lcBE4nXkMvbpnAkgaUM5cNECzvX34tJN30swtI1LgcjuQimV9N0KOI2HbBR/J4uVgZ/zrAsyIdxqvN7smqDww4iFE2yjA/1+xger9h0v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J8SHXGfa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J8SHXGfa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 192C31476;
	Mon,  7 Sep 2026 07:58:20 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900113F528;
	Mon,  7 Sep 2026 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788793103; bh=S52BFuMLtdk3fEiTm/WlGd0vl/me+yACyOJVPNoNoS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J8SHXGfaeHVa9VYnf6yA/0sXtUmyrbF3tikyCBJgpU0a0XMfen/jsosSbYcbeOS1c
	 vRFNy90bw1FQFrNmcYnO7XKsEN/ADVw76dG8l5BjKzRjFDUp42Ux+DZkiY9jMPcp5t
	 Ysy9Bg+Kc6HhsGf7DyyydYV0PsqX6xgBkJhXTKMI=
Date: Mon, 7 Sep 2026 15:58:13 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership selftest
Message-ID: <ravrecwvcy2okwdi3h5buzneyfilfjgx76c374r7l7jtx62lqc@rom2sxozz5is>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-12-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-12-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:55AM +0100, Vincent Donnefort wrote:

[...]

>  void __init pkvm_ownership_selftest(void)
>  {
>  	unsigned long pgtable_order = 5;
>  	unsigned long pgtable = 0;
> -	unsigned long page = 0;
> -	long ret = -ENOMEM;
>  
>  	/* Memory for the VM page-table */
>  	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
>  	if (!pgtable)
> -		goto out;
> +		return;

nit: previously this allocation failure will print a message, but not
after the change. Is this the intention?

Thanks,
Wei-Lin Chang

>  
> -	/* Page whose ownership will be tested */
> -	page = __get_free_page(GFP_KERNEL);
> -	if (!page)
> -		goto out;
> -
> -	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
> -				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
> -out:
> -	if (ret)
> -		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
> +	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
> +	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
>  
>  	free_pages(pgtable, pgtable_order);
> -	free_page(page);
>  }
>  #endif
>  
> -- 
> 2.55.0.508.g3f0d502094-goog
> 
