Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBDB1FB54
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:34:18 +0000 (UTC)
Date: Wed, 19 Jul 2023 17:34:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689788056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3VGQPXUCSx9/Xzn3VNJVxrDCJJWDuY72QiXXv/PHITk=;
	b=NrfT3m5PZHI8Lc81UN8uQ16nRlU3lH2dgGbBwiTQ9RNSvARLOj/9Rq23hZ5be/ZdRs1J8i
	UNecOuzBijw3x3wc0R1I6gE+SPnDt8NTtHwA4zfV+dC3p/WC+qQQMCI7WWIH4FtEeTaugh
	H+2ZH7qzsFCB+Xfi/MSf+1P3KF4rTwI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 2/5] KVM: arm64: Disable SME Traps for (h)VHE at setup
Message-ID: <ZLgelCk3+W3YOpVx@linux.dev>
References: <20230719150639.1968034-1-tabba@google.com>
 <20230719150639.1968034-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719150639.1968034-3-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 19, 2023 at 04:06:36PM +0100, Fuad Tabba wrote:
> Ensure that SME traps are disabled for (h)VHE when setting up
> EL2, as they are for nVHE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/el2_setup.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index c106b31d776c..7001b6db3ccc 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -292,9 +292,21 @@
>  	check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme_\@, .Lskip_sme_\@, x1, x2
>  
>  .Linit_sme_\@:	/* SME register access and priority mapping */
> +	mrs	x1, hcr_el2
> +	and	x1, x1, #HCR_E2H
> +	cbz	x1, .Lcptr_nvhe_sme_\@

Hmm.. Our test for hVHE is repeated enough times, it might make sense
for readability to wrap it up in a macro:

.macro check_hvhe pass, fail, tmp
	mrs	\tmp, hcr_el2
	and	\tmp, \tmp, #HCR_E2H
	cbnz	\tmp, \pass
	b	\fail
.endm

So long as we tolerate the additional word of bloat for the extra branch
:)

> +	// (h)VHE case
> +	mrs	x0, cpacr_el1			// Disable SME traps
> +	orr	x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
> +	msr	cpacr_el1, x0
> +	b	.Lskip_set_cptr_sme_\@
> +
> +.Lcptr_nvhe_sme_\@: // nVHE case
>  	mrs	x0, cptr_el2			// Disable SME traps
>  	bic	x0, x0, #CPTR_EL2_TSM
>  	msr	cptr_el2, x0
> +.Lskip_set_cptr_sme_\@:
>  	isb
>  
>  	mrs	x1, sctlr_el2
> -- 
> 2.41.0.255.g8b1d071c50-goog
> 

-- 
Thanks,
Oliver
