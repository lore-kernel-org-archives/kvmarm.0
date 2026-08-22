Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF833DEAEB;
	Sat, 22 Aug 2026 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787408847; cv=none; b=Ltcst0JRBrkYBl3/Gp9oBj55rtZMbMTroX2+ncSPZvc9rKYSwO3fvJ8k6EAKeh0dk4H5usabQbRjUw4XksE4Rf8rwPQ466DsybTOMZBsb6uhXK67zLLQKmBOKRROeRoqjP/CYZQfPB/TiREDhTsCYhnovp3tCuR2U17Cux1DY7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787408847; c=relaxed/simple;
	bh=2ydkdNofgQCCtc/Nq2QEBwXKevMYOSSTaBOiuea2GvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2lHjBs8dm9Wara6kbFZItolsTV+zAb+CpmwTo0rV12CflMvPGhrGBmQZ7HV3nniFJeDEevFnyApR7lAYafuvEQQOUEuU06SKsDRQD8WZsDW6bJRf8+n29rpI0MsEmRcDV47Ajy5EJ9b/I2/BANqR4K4shO4izVpepgz++kSjzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIQucIHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIQucIHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63161F000E9;
	Sat, 22 Aug 2026 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787408840;
	bh=hEdOcjb5KvfCdqAeLh5e49SYfWQQrjtahAYn7eUveJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nIQucIHaOxKUklad2T6kUYPzMuOTGcuraQiC3SOhg9cv1jGFh/3IQHPntDB5Sklud
	 F0/Vs6GxHTRksaAZq4pIlBNvTeDvbaXT2CPxpphsdnSZ0o+2IPLlJSjakjKla/NaRG
	 e781Wg6x3lyO3dCSGiGF60/VbTEDXw3W5OuBu/aX9Eip1gJ0pZBro1FQgy5VC+7V5/
	 YWGBgOxKoKqc2jBCE+O7PNwbLdJhoCOoJrzjTXDsbhbxE9VmHuL0CgEu6lxsoTnA+O
	 0z4NVRwuSq6PAkfZ8C0Eyc63pKSRuyUNLyE8c2o/FZ2HIRH9jBbmm+78tt+7L7rOiJ
	 GDfFuYFpVHvSQ==
Date: Sat, 22 Aug 2026 15:27:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: nv: Fix null ptr deref in
 kvm_nested_s2_unmap() on S2 teardown
Message-ID: <aomxsuiSpUmHyqu_@gremlin>
References: <20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org>
 <20260812-kvm-arm-nested-virt-fix-v1-2-4ad883f1b6a5@kernel.org>
 <20260812140101.D77AC1F000E9@smtp.kernel.org>
 <an3lHhgmwS0RnCgI@lucifer>
 <86zeye4nsd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zeye4nsd.wl-maz@kernel.org>

On Sat, Aug 22, 2026 at 08:28:18AM +0100, Marc Zyngier wrote:
> On Thu, 13 Aug 2026 16:56:02 +0100,
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > On Wed, Aug 12, 2026 at 02:01:01PM +0000, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> > >
> > > Pre-existing issues:
> > > - [Critical] Use-After-Free on `kvm->arch.nested_mmus` array due to concurrent teardown.
> >
> > Addressed by Marc's changes + discussed over there.
> >
> > > - [Critical] Incomplete Fix: `kvm_nested_s2_wp()` is vulnerable to the same NULL pointer dereference and UAF.
> >
> > OK interesting!
>
> Will you respin this series with kvm_nested_s2_wp() fixed in a similar
> way? Something like below.

Ack yeah, will do!

>
> Thanks,
>
> 	M.
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 00580ba6e8ba0..ebc4f4dc47836 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1262,6 +1262,14 @@ void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val)
>  	invalidate_vncr_va(vcpu->kvm, &scope);
>  }
>
> +static void kvm_invalidate_vncr_ipa_all(struct kvm *kvm)
> +{
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	if (kvm->arch.mmu.pgt)
> +		kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +}
> +
>  void kvm_nested_s2_wp(struct kvm *kvm)
>  {
>  	int i;
> @@ -1278,7 +1286,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>  			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
>  	}
>
> -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	kvm_invalidate_vncr_ipa_all(kvm);
>  }
>
>  void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
> @@ -1297,7 +1305,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>  			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
>  	}
>
> -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	kvm_invalidate_vncr_ipa_all(kvm);
>  }
>
>  void kvm_nested_s2_flush(struct kvm *kvm)
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo
