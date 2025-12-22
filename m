Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912592D2490
	for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766426831; cv=none; b=UbxE2WICca6HkrfDHUDd/tso8UXVlz0DU/C0cR3ticVs1hPyKQgILY+Cuqc8qFYCRpcGibbODP4xfvBQuZX/4J6qc8eoW7wwRmolxh60F5L0Iff8sv11NjgguFoiAo6JVNoDQM1jseKy+jN0/LxlgtF+Npx9IPgsJnfBBewxgX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766426831; c=relaxed/simple;
	bh=gjTAYFZyDCoJLasQD4R21bbSCdGuC63Co2UkaUOAxME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qky1os9wrNTZjAsgWwnstCATvOL5mQkCvYJMKnLElsapOFqKWld0HjUZTFqS42l6ZjRWxB42O6mQMLO+EyFInYd/b9tHmw1Xw5eZinaj1atE4Ojv5zEcqBViVDkctdgceue/vRymmW2Yi/gfhLu6MLqw3f/j4OBHtX/WDL5G0Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1H1biND; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1H1biND"
Date: Mon, 22 Dec 2025 12:06:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766426825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIJ8qnnIn2fAU6lPdevesO7Rmp1csv0a8O5Oc90bx5Y=;
	b=v1H1biNDta8dBMhI6O/Lwni5MPUVNHO+eWiAh/FLiesVXT5NfJuW+moKjnH5LB+Hjcq1Ke
	cw/u755wlQsSv3+bRbviueiK6b1nj5+bJPE7d5sYKofjrS39wMquqoe4lteCj85/QGJJlB
	qs3oNq8NtL/n60dE5F2pqYCaJw0Phow=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org
Subject: Re: [PATCH v2 3/5] KVM: riscv: selftests: Fix incorrect rounding in
 page_align()
Message-ID: <20251222-67bdefbbd6f1687ffbcabf81@orel>
References: <20251215165155.3451819-1-tabba@google.com>
 <20251215165155.3451819-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215165155.3451819-4-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 04:51:53PM +0000, Fuad Tabba wrote:
> The implementation of `page_align()` in `processor.c` calculates
> alignment incorrectly for values that are already aligned. Specifically,
> `(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
> boundary even if `v` is already page-aligned, potentially wasting a page
> of memory.
> 
> Fix the calculation to use standard alignment logic: `(v + vm->page_size
> - 1) & ~(vm->page_size - 1)`.
> 
> Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index 2eac7d4b59e9..d5e8747b5e69 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -28,7 +28,7 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
>  
>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
> -	return (v + vm->page_size) & ~(vm->page_size - 1);
> +	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
>  }
>  
>  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
> -- 
> 2.52.0.239.gd5f0c6e74e-goog

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
