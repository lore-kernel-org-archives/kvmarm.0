Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B4E548;
	Mon, 11 Dec 2023 18:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA18C433C7;
	Mon, 11 Dec 2023 18:57:14 +0000 (UTC)
Date: Mon, 11 Dec 2023 18:57:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@linux.ibm.com, broonie@kernel.org,
	dave.hansen@linux.intel.com, maz@kernel.org, oliver.upton@linux.dev,
	shuah@kernel.org, will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 17/25] arm64: enable POE and PIE to coexist
Message-ID: <ZXdbiEXUUXXX7n8Q@arm.com>
References: <20231124163510.1835740-1-joey.gouly@arm.com>
 <20231124163510.1835740-18-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124163510.1835740-18-joey.gouly@arm.com>

On Fri, Nov 24, 2023 at 04:35:02PM +0000, Joey Gouly wrote:
> Set the EL0/userspace indirection encodings to be the overlay enabled
> variants of the permissions.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index e9624f6326dd..3007208e04aa 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -137,10 +137,10 @@ extern bool arm64_use_ng_mappings;
>  
>  #define PIE_E0	( \
>  	PIRx_ELx_PERM(pte_pi_index(_PAGE_EXECONLY),      PIE_X_O) | \
> -	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY_EXEC), PIE_RX)  | \
> -	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RWX) | \
> -	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY),      PIE_R)   | \
> -	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED),        PIE_RW))
> +	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY_EXEC), PIE_RX_O)  | \
> +	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RWX_O) | \
> +	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY),      PIE_R_O)   | \
> +	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED),        PIE_RW_O))
>  
>  #define PIE_E1	( \
>  	PIRx_ELx_PERM(pte_pi_index(_PAGE_EXECONLY),      PIE_NONE_O) | \

Don't we need to do this for PIE_E1? Or we consider the futex
(LDXR/STXR) accesses not checked by POE? That's fine by me if we go this
route but we should document it. The alternative is to enable overlay
variants in PIE_E1 but we need to reserve a POE key for the kernel to
use.

-- 
Catalin
