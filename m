Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2E91F956
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286808; cv=none; b=rmuHTFw4Bv1Ii43eNynM78krZTsrSC/zRYWT6ta0zFdSo3GWpVHPvZYAbRHgAVEEi3IJYfdz/TKktItpOwbnpkj+KCKAZ5oRVjVrPgp1zC5m5zmwvPQcdZ/s3TCaZS6Ef5qyE8k29lotGAM9IEKx2mVlH70pQ350KJnYOfXx658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286808; c=relaxed/simple;
	bh=4pzmH266rS1JJgFeaBahNt4UGkn/YyPevfBX4eS+3ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=su5F5PrG5l0d6r8lcfnkHKkCLJxzMspS3mYjmPCvFzu35tSSY5FQuq9gQ9JLy+A4vQtJylur1It+OTP8vZa5ccI8t5bFLUY0QmiCiFDhAl8cq4S2M1FnCa2QR5UTr+98evV8iO5zp4BoRX2RHNzDfFnYIFe3q/mH9WLeXiOEtOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lCsKfEfA; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lCsKfEfA"
Date: Tue, 16 Apr 2024 16:59:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713286803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qn8cRlUMCicw93ynEAJwIKbH1L5+1GKM88JXFRdFjZM=;
	b=lCsKfEfAt5Rmi8NYA6dIR2sdvVilspuU6qgJ+v6iZMy+7WshEf89nxBUBlGCPLkcPpUOBW
	UbDBbUBwBS+GJInqIS9FFuX7t+pQ8Xtpzt6ZY65vKNZMoX2NsbIN7LN0myLBDJiknE3B97
	9KFHPxctClidVC+rgRmE2LsgXoTR0/k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v2 09/47] KVM: arm64: Avoid BBM when changing only s/w
 bits in Stage-2 PTE
Message-ID: <Zh6ujO8qbVviKlEk@linux.dev>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-10-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Tue, Apr 16, 2024 at 10:56:00AM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> Break-before-make (BBM) can be expensive, as transitioning via an
> invalid mapping (i.e. the "break" step) requires the completion of TLB
> invalidation and can also cause other agents to fault concurrently on
> the invalid mapping.
> 
> Since BBM is not required when changing only the software bits of a PTE,
> avoid the sequence in this case and just update the PTE directly.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 67647b853c9b..30a9a503c477 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -979,6 +979,21 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!stage2_pte_needs_update(ctx->old, new))
>  		return -EAGAIN;
>  
> +	/* If we're only changing software bits, then store them and go! */
> +	if (!kvm_pgtable_walk_shared(ctx) &&
> +	    !((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)) {
> +		bool old_is_counted = stage2_pte_is_counted(ctx->old);
> +
> +		if (old_is_counted != stage2_pte_is_counted(new)) {
> +			if (old_is_counted)
> +				mm_ops->put_page(ctx->ptep);
> +			else
> +				mm_ops->get_page(ctx->ptep);
> +		}
> +		WRITE_ONCE(*ctx->ptep, new);

IIUC, you're using a naked WRITE_ONCE() to avoid a error path that
cleans up the reference count. That's fine, but can you change this to a
WARN_ON_ONCE(stage2_try_set_pte())? Should this ever be changed to
become a shared walk w/o gracefully handling a cleanup here I'd hope the
warning would catch someone's attention.

-- 
Thanks,
Oliver
