Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E269BA44
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 17:44:49 +0000 (UTC)
Date: Tue, 7 Mar 2023 17:44:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678211086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S2hDKtgc8xQEKcZC3ewXi+onn5uSvq4aHhszAkbx3vI=;
	b=Nv3/hfdRGfVllu1DG/FR5DvxXADRg3zs6SlO5micCqA0+TDkOOi5wCi0qZHSljN9jwbCVZ
	L8qdW8bEIjRq+Xt0DfGHgfMCymL0pKHQZtQsKzbYFMSHogWIt2KXoXb2CBeIGoUHOWBlUL
	SgKRn4ITEJCvYwFyz2CLylwwguNFVCA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 2/2] KVM: selftests: arm64: Fix pte encode/decode for
 PA bits > 48
Message-ID: <ZAd4CyBM79JzqkEu@linux.dev>
References: <20230228170756.769461-1-ryan.roberts@arm.com>
 <20230228170756.769461-3-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228170756.769461-3-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Ryan,

Thanks for fixing this. Couple of nits:

On Tue, Feb 28, 2023 at 05:07:56PM +0000, Ryan Roberts wrote:
> The high bits [51:48] of a physical address should appear at [15:12] in
> a 64K pte, not at [51:48] as was previously being programmed. Fix this
> with new helper functions that do the conversion correctly. This also
> sets us up nicely for adding LPA2 encodings in future.
> 
> Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

nit: no whitespace between footers.

> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 32 ++++++++++++++-----
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 5972a23b2765..13f28d96521c 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -58,10 +58,27 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
>  	return (gva >> vm->page_shift) & mask;
>  }
>  
> -static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
> +static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
>  {
> -	uint64_t mask = ((1UL << (vm->va_bits - vm->page_shift)) - 1) << vm->page_shift;
> -	return entry & mask;
> +	uint64_t pte;
> +
> +	pte = pa & GENMASK(47, vm->page_shift);
> +	if (vm->page_shift == 16)
> +		pte |= (pa & GENMASK(51, 48)) >> (48 - 12);

nit: this is a bit of an odd transformation, of course courtesy of the
architecture. FIELD_GET() might make it a bit more readable:

		pte |= FIELD_GET(GENMASK(51, 48), pa) << 12;

-- 
Thanks,
Oliver
