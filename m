Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBF16121
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 16:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465B2C433EF;
	Wed, 12 Apr 2023 16:27:18 +0000 (UTC)
Date: Wed, 12 Apr 2023 17:27:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 02/12] arm64/mm: Add FEAT_LPA2 specific
 ID_AA64MMFR0.TGRAN[2]
Message-ID: <ZDbb4xLsoks+lZZT@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-3-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306195438.1557851-3-ryan.roberts@arm.com>

On Mon, Mar 06, 2023 at 07:54:28PM +0000, Ryan Roberts wrote:
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e3ecba3c4e6..7f708eecc3ad 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -609,10 +609,12 @@
>  
>  /* id_aa64mmfr0 */
>  #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN	0x0
> +#define ID_AA64MMFR0_EL1_TGRAN4_LPA2		ID_AA64MMFR0_EL1_TGRAN4_52_BIT
>  #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX	0x7
>  #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MIN	0x0
>  #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MAX	0x7
>  #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN	0x1
> +#define ID_AA64MMFR0_EL1_TGRAN16_LPA2		ID_AA64MMFR0_EL1_TGRAN16_52_BIT
>  #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX	0xf

This patch evolved a bit since I first acked it in Anshuman's series. I
can't find any trace of ID_AA64MMFR0_EL1_TGRAN4_52_BIT in the kernel. Is
it introduced in a later patch?

-- 
Catalin
