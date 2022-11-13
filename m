Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26266FDF
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 22:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B454AC433C1;
	Sun, 13 Nov 2022 22:27:06 +0000 (UTC)
Date: Sun, 13 Nov 2022 22:27:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/8] arm64/fpsimd: Have KVM explicitly say which FP
 registers to save
Message-ID: <Y3FvN85aHXrdEIT5@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-4-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-4-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:16AM +0100, Mark Brown wrote:
> In order to avoid needlessly saving and restoring the guest registers KVM
> relies on the host FPSMID code to save the guest registers when we context
> switch away from the guest. This is done by binding the KVM guest state to
> the CPU on top of the task state that was originally there, then carefully
> managing the TIF_SVE flag for the task to cause the host to save the full
> SVE state when needed regardless of the needs of the host task. This works
> well enough but isn't terribly direct about what is going on and makes it
> much more complicated to try to optimise what we're doing with the SVE
> register state.
> 
> Let's instead have KVM pass in the register state it wants saving when it
> binds to the CPU. We introduce a new FP_STATE_TASK for use during normal
> task binding to indicate that we should base our decisions on the current
> task. This should not ben used when actually saving. Ideally we might

s/ben/be/

> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 3cce0a4c4e8d..1d48398cb6dc 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -123,6 +123,7 @@ enum vec_type {
>  };
>  
>  enum fp_type {
> +	FP_STATE_TASK,		/* Save based on current task state. */

Nitpick: FP_STATE_CURRENT instead?

Reviewed-by: Catalin Marinas
