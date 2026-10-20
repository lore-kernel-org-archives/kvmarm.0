Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792498449;
	b=J0/qN1ul3UndnYS6NgIlsHZRS7qMwDmF6ikl6OtNKjfRFiDxYOOp6WWHSfTawZgZwJR2
	 YZY8GgtBdUm/BSCq65B8vkKOcAQVM9DmGqvKd8ofI7bBV7ic5xep6dmEkpzyx0Z72M3bR
	 BJEcFa0hnBRcsTRWraGJYsg0DMynwdl3fvWl6JBs3Ri0Hm0pa6EptvWTrBmDcxWE4rq68
	 2SEKNiI+f4bif6GhfgEL33M2qvklRGqboz36gSa34cSAvjJ8QXc3QltoR8oKuPHqFSv+8
	 h3xaMttAHIi1H4hJz5fnH/8pyxblt9GT+7AhRIAMSH5zSAcDzrzNNZlaos5i0cBFi5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792498449;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dKWmJgLEWxzvGFYBH7caDkZqJJLLMNe4m0yrs2VTkfw=;
	b=zB0gJQzv+zdHeqgUDLnGVqP1/niZGqg3SovgJv6hwHpYGlIOyxP7FgOH+Ga9qvJfV9MP
	 oSWwaBvoFzxk0aOwSoQ6cSzEPwAh1j38LtcCL6iqxhyvejSAejBVP/SQzH4WRkNrhjTpW
	 /zvetCKNVAvgOSAyVRjyz2CBfyvbx/GlGZY4HJo4JSJ6P5UU3UMumslUZjjrGjXbmkWJq
	 wNICVrsQzhF4Ce5/dEWy18a2qO7v6Uf3ybNmTINgX7E8lTR9UXI7XXbo3v8odqp2W0JeY
	 1IF+9HI52tuHBYh+vv8LgA/bkJmj20P5xocJ5tw1WsBHD/4rGdC9AgVcWgQSn6PUJxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVOMiTJs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AAA606A319;
	Tue, 20 Oct 2026 12:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVOMiTJs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46CD1F000C9;
	Tue, 20 Oct 2026 12:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792498448;
	bh=dKWmJgLEWxzvGFYBH7caDkZqJJLLMNe4m0yrs2VTkfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EVOMiTJsZ+bQ2IrY4bPM+M+hVd2hhFQQ9aVfFMY0JgfnRA2l29X+k+VIf+MGSOuKu
	 27oIPN65A5V42ZMY+dH6zH0ezrpezSTg/l37aPFH9ChezKOmfSnhaFSKj1156XdpbY
	 TyXC8/cYJqvdoYVP/+/QQNWOegZMbPzj/SOIU8fQG5bsNZMMwVQB/0xkPVUno3ZGrT
	 gDUEwXNAZFfmwbq3W+RP3x2b36GOO/2cwJkbwis7WsA9ToGDsIVXfGGxZPVCDjFbEi
	 NlyV+/Ipn9tQLVj/6zT5HUfdC3716FdDdKNvZsQtBjAiWn8z6HiaJ8/aOtoMVxIrnx
	 3xOyC5lQnZmOQ==
Date: Tue, 20 Oct 2026 13:14:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	Fuad Tabba <tabba@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: Sanitise MTE tags when a permission
 fault installs a mapping
Message-ID: <atdXdtXXTH-6DWVt@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-4-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019132103.3836646-4-fuad.tabba@linux.dev>

On Mon, Oct 19, 2026 at 02:21:03PM +0100, Fuad Tabba wrote:
> The stage-2 fault path sanitises MTE tags only on translation faults, as
> a permission fault normally just relaxes an existing leaf. However, when
> the page is backed by a THP, a permission fault at page granule installs
> a block whose other pages may never have been mapped or sanitised. Once
> dirty logging is off, a guest write to a page mapped read-only during
> logging installs the block, and the guest can read the tags those pages'
> previous owners left.
>
> Sanitise whenever the fault path calls kvm_pgtable_stage2_map() rather
> than relaxing permissions. If the VMM replaces the VMA after the guest
> takes a permission fault but before vma_lookup(), that path would map
> and sanitise memory from the new VMA without checking it. Run the
> VM_MTE_ALLOWED check in kvm_s2_fault_compute_prot() on permission
> faults too.
>
> Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")

Yikes! It goes quite far back :)

> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Nits below, but with those addressed LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 48a08b608ea72..208fcae80f67f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2005,7 +2005,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>  	if (s2fd->nested)
>  		*prot = adjust_nested_exec_perms(kvm, s2fd->nested, *prot);
>
> -	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
> +	if (!s2vi->map_non_cacheable && kvm_has_mte(kvm)) {

OK so doing this check on permission faults too.

>  		/* Check the VMM hasn't introduced a new disallowed VMA */
>  		if (!s2vi->mte_allowed)
>  			return -EFAULT;
> @@ -2060,7 +2060,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  		}
>  	}
>
> -	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
> +	if (mapping_size != perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))

So 'translation fault or permission fault if this will install a mapping' rather
than 'translation fault' alone right?

Just after this code you have:

	if (mapping_size == perm_fault_granule) {
		...
	} else {
		...
	}

So you could put

		if (!s2vi->map_non_cacheable && kvm_has_mte(kvm))
			sanitise_mte_tags(kvm, pfn, mapping_size);

In the else branch? Seems neater and clearer.

Also I wonder if the !s2vi->map_non_cacheable && kvm_has_mte(kvm) check could be
abstracted?

E.g.:

static bool is_mte_fault(const struct kvm *kvm,
		         const struct kvm_s2_fault_vma_info *s2vi)
{
	return !s2vi->map_non_cacheable && kvm_has_mte(kvm);
}

Then could be:

	if (is_mte_fault(kvm, s2vi))
		sanitise_mte_tags(kvm, pfn, mapping_size);

>  		sanitise_mte_tags(kvm, pfn, mapping_size);
>
>  	/*
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
