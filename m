Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82D1E1C0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 17:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F14C433C8;
	Thu, 10 Aug 2023 17:20:28 +0000 (UTC)
Date: Thu, 10 Aug 2023 18:20:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4 11/36] arm64/mm: Map pages for guarded control stack
Message-ID: <ZNUcWdTPKDXvpDbR@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-11-68cfa37f9069@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807-arm64-gcs-v4-11-68cfa37f9069@kernel.org>

On Mon, Aug 07, 2023 at 11:00:16PM +0100, Mark Brown wrote:
> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 8f5b7ce857ed..8f40198cd44e 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -79,8 +79,18 @@ arch_initcall(adjust_protection_map);
>  
>  pgprot_t vm_get_page_prot(unsigned long vm_flags)
>  {
> -	pteval_t prot = pgprot_val(protection_map[vm_flags &
> +	pteval_t prot;
> +
> +	/* If this is a GCS then only interpret VM_WRITE. */
> +	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
> +		if (vm_flags & VM_WRITE)
> +			prot = _PAGE_GCS;
> +		else
> +			prot = _PAGE_GCS_RO;
> +	} else {
> +		prot = pgprot_val(protection_map[vm_flags &
>  				   (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
> +	}
>  
>  	if (vm_flags & VM_ARM64_BTI)
>  		prot |= PTE_GP;

Some combinations here don't make sense like GCS + exec or BTI. I think
the code above (correctly) ignores exec but it still sets PTE_GP if BTI
(the architecture may allow this but you can't execute from the GCS page
anyway).

I haven't checked the x86 patches to see when VM_SHADOW_STACK is set but
if there's no additional check at a higher level, we should add
something to arch_validate_flags(), assuming it's called on those paths.

-- 
Catalin
