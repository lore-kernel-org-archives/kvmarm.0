Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6905240
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F31C433EF;
	Mon, 12 Jun 2023 19:12:23 +0000 (UTC)
Date: Mon, 12 Jun 2023 20:12:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 05/17] arm64: Don't enable VHE for the kernel if
 OVERRIDE_HVHE is set
Message-ID: <ZIduFSAPFumGotwV@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-6-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:48PM +0100, Marc Zyngier wrote:
> If the OVERRIDE_HVHE SW override is set (as a precursor of
> the KVM_HVHE capability), do not enable VHE for the kernel
> and drop to EL1 as if VHE was either disabled or unavailable.
> 
> Further changes will enable VHE at EL2 only, with the kernel
> still running at EL1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 9439240c3fcf..5c71e1019545 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
>  	tbnz	x1, #0, 1f
>  
>  	// Needs to be VHE capable, obviously
> -	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
> +	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
> +
> +0:	// Check whether we only want the hypervisor to run VHE, not the kernel
> +	adr_l	x1, arm64_sw_feature_override
> +	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
> +	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
> +	and	x2, x2, x1
> +	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
> +	cbz	x2, 2f

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

(I think we are trying too hard to make this look like a hardware
features when a tbz would do ;)).

-- 
Catalin
