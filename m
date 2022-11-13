Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8216FDF
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 22:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC86EC433D6;
	Sun, 13 Nov 2022 22:12:15 +0000 (UTC)
Date: Sun, 13 Nov 2022 22:12:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/8] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <Y3FrvJQzvW4YFfEF@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-3-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-3-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:15AM +0100, Mark Brown wrote:
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 445aa3af3b76..3cce0a4c4e8d 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -122,6 +122,11 @@ enum vec_type {
>  	ARM64_VEC_MAX,
>  };
>  
> +enum fp_type {
> +	FP_STATE_FPSIMD,
> +	FP_STATE_SVE,
> +};

More of a nitpick, I still find the type/state naming confusing but I
don't have a better suggestion. Maybe call them FP_TYPE_* or rename the
enum to fp_state_type (up to you really, feel free to leave them as they
are).

Either way, I think having an explicit type of what state is about is a
significant improvement in clarity.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
