Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4921DE2A2
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126695; cv=none; b=noJbAhTaX0/DNgYRVHxQBOyMHsm0iiRLCppNqVl/SwXChOR4lViTNedGbbNDu8IHylDapWil9mBwSl/dc1G2/MKpLsvBSC1AMywKruz/QIfoe7PMAeYWlVdwTS/9HzittEsBDf5jKrVxY7FyLjvxZ4J4zKgSQWvtq4qeg+JLyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126695; c=relaxed/simple;
	bh=TokjYQH8kitD8Y36X7+EU0WzCzQ55HbXZ1jajE86zD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYcv2bG6lUQotHnLPHFR7ijMVcWUe/lpUscABNjsBs0H/oOmhZfF/qaIlt9LNEHaTsitvarB+aVE/Xnt+ctxnFSZntCw7GA0vEqH2MJHPCh91u53iDjeKRENH4r0aWNGmkYwqF+kOeZEkvGY2nBcGsrRs+oxzK7nRyMunlK1pLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GvrT6mt2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GvrT6mt2"
Date: Mon, 28 Oct 2024 14:44:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730126689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WrEXEA4endWKL67QJLeMRmZVfFpl2fT0EjCN3vzhm+o=;
	b=GvrT6mt2Oq66jA6SCmxxtfQp0hhFXZ1rAWfFgIJoObPh5TfPfrtgrHzh/+KVbL2U1BnVlu
	ioq9c0T+vFDjJfhUM50rwMG5b3X0J3lWaN7dxcZun2+8GXfBN5+F744hOKpKJwEyeTk3y5
	cIJl6NvKd1xAlMxheWNNXYV2fV0Fz78=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory attribute
 if supported
Message-ID: <Zx-jWyF7xvFS-Vs6@linux.dev>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-5-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028094014.2596619-5-aneesh.kumar@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 28, 2024 at 03:10:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc055145..a8268a164c4d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_ARM_NOTAG_ACCESS 40
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -446,6 +447,12 @@ struct kvm_run {
>  			__u64 gpa;
>  			__u64 size;
>  		} memory_fault;
> +		/* KVM_EXIT_ARM_NOTAG_ACCESS */
> +		struct {
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 size;
> +		} notag_access;

Can you please look into reusing the memory fault exit infrastructure?

The entire point of that is for KVM to tell the VMM it cannot make
forward progress because of ${SOMETHING} unexpected at the specified
GPA. You can add a new flag that describes tag access.

-- 
Thanks,
Oliver
