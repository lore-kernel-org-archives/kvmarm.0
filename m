Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6B826B74F
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 10:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755599119; cv=none; b=lDTWLtc45kPKWObJ+GWIeCgvRuM0mnFI1eVqBWT6k1+d1b7iq2sIl9oh7/Qw+JIrTlfx3N2F1DKFKgWFFx2GrqHblgzEE425nGvCgekFGwowzc7G4PrkodLybfrKT4ULcmlb3qbwcfJk/e058cMDoALUAqQVdw8ymNdyVKD46bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755599119; c=relaxed/simple;
	bh=mPIHHNKtAx3hLVCW0P5StnhWD+LRvarGR1wp+gxgprA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LO1Bnpmn12h8Cmd2apdJveFWndq3+NnbXQFN8DBZrcJxJcbtGi+8+PMTVN25gUR2e+f17pvZhsgGEiMZbBMVXyszJq/7CsDRY/7UVu9cmkhGJSY+SsxiVqOca2eBBe7y5nt9AYOhH/6JSxQO4W+M8Uf+DMxse+tPBuc+bvCD/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0CF81BD0;
	Tue, 19 Aug 2025 03:25:08 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C0B33F63F;
	Tue, 19 Aug 2025 03:25:15 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:24:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 3/6] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's
 EL2
Message-ID: <20250819102434.GA3736290@e124191.cambridge.arm.com>
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817202158.395078-4-maz@kernel.org>

On Sun, Aug 17, 2025 at 09:21:55PM +0100, Marc Zyngier wrote:
> An EL2 guest can set HCR_EL2.FIEN, which gives access to the RASv1p1
> fault injection mechanism. This would allow an EL1 guest to inject
> error records into the system, which does sound like a terrible idea.
> 
> Prevent this situation by added FIEN to the list of bits we silently
> exclude from being inserted into the host configuration.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index e482181c66322..0998ad4a25524 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -43,8 +43,11 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>   *
>   * - API/APK: they are already accounted for by vcpu_load(), and can
>   *   only take effect across a load/put cycle (such as ERET)
> + *
> + * - FIEN: no way we let a guest have access to the RAS "Common Fault
> + *   Injection" thing, whatever that does
>   */
> -#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
> +#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK | HCR_FIEN)
>  
>  static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  {
> -- 
> 2.39.2
> 
