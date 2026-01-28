Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AE22EB847
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769596218; cv=pass; b=f0ttBJ3btqLGXVay6mrKgDerM35EpwdcxR2FULTm4kayXqOHYt8CQr23Ej4OFE5sOl+BJ8OMp6UxsrXQDXMbcy841tXt3fLlk3+FcLZHm8pKG/MTHfax4Hm9vipbwrZZgjb3spuWL7kFihTvONQwSo3CrHygeOU6J20FcJbwg+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769596218; c=relaxed/simple;
	bh=tijnUTTN4/fqGuI0XfeEmrhZ7Ckd7/fVi3Bx7KM1qws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eKcYzhoe9MQDaEhmD5kk1VV838tYY0EnDmVpFnhuhxtVXTkoXvaKtny/R2IW8TqgJzHuJSO8B3YC1paTTzJhH7QDI+cVtbdLyUdziD0kdsxl/5ftTba8XfwhohQVP9V9odQcUP/qrCvThAytcU8TMA/zTyZZqkoSO8qmYhvmj0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzIRmWOn; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzIRmWOn"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5033b64256dso155311cf.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 02:30:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769596215; cv=none;
        d=google.com; s=arc-20240605;
        b=OgaOC4HCj+Vu+w5DtEBH3camklJ4PtDOfzl6OE7B+VRSA9la3AU+UNrrOiczsFTgNT
         1cfuyFUp0Pry+V2sBRr9FvVXlQ4rSAUgJWjq94QrVHqk7SwyvktxKar6iIdJW3sh7Jq5
         4t/FLKKZV5T/Fz2TLmNfAxjct+MNAoh7FQocZvFUe2qPB/cu5XzuvdLEQ8N7KKmMsItz
         bwYZ2z3AbziW6UMIg0ON2GHH6/tUGyvbWHFaSpLlHxii8WOn7AEjLuLTSbvxeZRu0J53
         cS1HOGUTvno8qGG0H2HWk8htEHjUjY1XK+nF8z1QtoSF8CjmfGGlVTjpzAvkFDnpbpYC
         f+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Y9Z1Zsbn42wkb2YuIVtSHH6QhaEUlzMyYP/oeZKV5XE=;
        fh=OsVEnhpHfDtKQejlv1Bgs/tZPAfr3IJ2Ck5WUUi92Sc=;
        b=aifhLWXiFl6do/X/cE5Rp//RPsxzW5tAsfa+jeaJxOSSsMt0kcD0eV+RRGR2kSdSEm
         hflgRnRk4E5LsyHDplnfOJY1Gq1MrnMKpRpEpiyjie03QFadj0jZEFh+hyH2+dBlmEs/
         E+k7usMpW8LE5bmWH1syqtxJTpatL795LAn2FreUkhtfb6md9HFgUO03jL4DjP9D+WaV
         KnELLhepBydvjybtPEuRTlUF6j2gg8na/2T4i6SjYZ17dDTblog4hj/mCLcuaU9cXEbQ
         4t4qQyfNBzKpWBFMoIxIDHgjw2pSC0zf8TL3tqzKnCY1zkJYlnvyJ35BT1LZh8yE5Ixe
         jQZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769596215; x=1770201015; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9Z1Zsbn42wkb2YuIVtSHH6QhaEUlzMyYP/oeZKV5XE=;
        b=DzIRmWOnmUDv4QH0F9/fUktkkAsGOEyiB9qUiGI/5a6BlSVv+hxHtrRApgCzxxmv4i
         PJnbt/LiY43ymk/Lyva6jJtlb6fyP9StMpqdrNJXwbjVXD8QgRiZUpqXAbD8ltpllCf4
         yevz+OhsgveRZ2oAwl8AyCm1+NqJ3m81qsjT9ABkLHfLgEPzp2fZUiRLV3NfsmQaGJTq
         yeR8GyOfqrf34QAX3Q0BbXi27BDpVpX7WJXnKpm+QYSlGL2jqJ+9rWQ+OPhaYorjR9rT
         97VOAnaYXCwpFgSa7eZA2k/VEHt/mN2P8NaLzmPyducuD7wixaVg5iN/OAYc/BJ0CQyB
         Ieag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769596215; x=1770201015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9Z1Zsbn42wkb2YuIVtSHH6QhaEUlzMyYP/oeZKV5XE=;
        b=HBILYstAM7slguNiK873QYEOfGnQNIWJdBxizS7ygENkfJbZF7A1zgqZuay1hJjPnJ
         sYygNdYTQESVvrILZ20zoDT+DMzY8wY0nVIFLkHUNlvFunNeMUv/DzmmLV2fTxYJwUHZ
         6e2VJK1qXlNksCOVAdW2SUp3NBkwLFGi7EvXR3AN5RMmGkj1IImEuFFjJEGV6jj/GL+x
         pTShj2L2hKZgTaQ+GXLrDp5wpEaSA7ICOuA9F3nB14XZ3FXc+NAwcAPYklFmIEn8B05Y
         ptnUkMZzLBnt50xXnezOOEATd4j4huRj9Sv1/bgdhT+mFhUxxqaO9Co013NTE7KDLNHE
         xnmw==
X-Gm-Message-State: AOJu0YzeYELdVflZOwHl8Lc1WZRccJiFzKyLCkT0WoD5/WcTuZ3aCp9d
	RgrdZcPWKftUQF9wUccgUrI6Db5IXKyhZIOMVMqyJus1QsIk7yOcjBBIQpqlxYJGPStg1YsSRXF
	e/2cov3kBcFoXe9GsX4Y8jZc72ZpY9D5TL2s6QbB7
X-Gm-Gg: AZuq6aKTMhstSJYTj45OEVncg3upI2Lbo0Xh81WkUEuBvYG7I885ZBSIBFxhcxE9hz2
	LbaF65RV9ngCAVTxEkmRXnTQRffwMiCW6ou8Jvb7Nix/xYmBfQ4kVPj8kcAOU2Osu69FaYaKaaR
	xIqbf3rQzx0QKln/EetiAUqIy/XnA6RX1bCH0QU0rNOzQXk6jzuAQ/BOhUyHVTduDNz5jnEKNNJ
	9WmjPmZVW493lB7iiIAUNYd/TPoIYwvJN9eR5XNPbjnXF/KvNRo4JkCKw34UIuvqvcPenNY97+/
	oB8FfBSOxlqapAci6L7Z6ddyHg==
X-Received: by 2002:ac8:5ac7:0:b0:501:4539:c81 with SMTP id
 d75a77b69052e-5032f43dbf4mr21936141cf.2.1769596215303; Wed, 28 Jan 2026
 02:30:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119124629.2563-1-will@kernel.org> <20260119124629.2563-24-will@kernel.org>
In-Reply-To: <20260119124629.2563-24-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 28 Jan 2026 10:29:39 +0000
X-Gm-Features: AZwV_Qi7pHTo3Y8M1aEg6LuWOi1ah8-zNFvqwMSaz6TXSwn2G1ct6rX-MRXzzTw
Message-ID: <CA+EHjTyAkwN0yk_qJJoXC-p+M4Dje7oKZbhrS0RL2U9gVadWFQ@mail.gmail.com>
Subject: Re: [PATCH v2 23/35] KVM: arm64: Annotate guest donations with handle
 and gfn in host stage-2
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 12:48, Will Deacon <will@kernel.org> wrote:
>
> Handling host kernel faults arising from accesses to donated guest
> memory will require an rmap-like mechanism to identify the guest mapping
> of the faulting page.
>
> Extend the page donation logic to encode the guest handle and gfn
> alongside the owner information in the host stage-2 pte.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index e090252d38a8..f4638fe9d77a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -590,7 +590,6 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>                 if (!ret)
>                         __host_update_page_state(addr, size, PKVM_PAGE_OWNED);
>                 break;
> -       case PKVM_ID_GUEST:
>         case PKVM_ID_HYP:
>                 ret = host_stage2_set_owner_metadata_locked(addr, size,
>                                                             owner_id, 0);
> @@ -600,6 +599,20 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>         return ret;
>  }
>
> +#define KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK   GENMASK(15, 0)
> +/* We need 40 bits for the GFN to cover a 52-bit IPA with 4k pages and LPA2 */
> +#define KVM_HOST_PTE_OWNER_GUEST_GFN_MASK      GENMASK(55, 16)
> +static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
> +{
> +       pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
> +
> +       BUILD_BUG_ON((pkvm_handle_t)-1 > KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK);
> +       WARN_ON(!FIELD_FIT(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn));
> +
> +       return FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, handle) |
> +              FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
> +}
> +
>  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
>  {
>         /*
> @@ -1133,6 +1146,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>         struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>         u64 phys = hyp_pfn_to_phys(pfn);
>         u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 meta;
>         int ret;
>
>         host_lock_component();
> @@ -1146,7 +1160,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>         if (ret)
>                 goto unlock;
>
> -       WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
> +       meta = host_stage2_encode_gfn_meta(vm, gfn);
> +       WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
> +                                                     PKVM_ID_GUEST, meta));
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
>                                        &vcpu->vcpu.arch.pkvm_memcache, 0));
> --
> 2.52.0.457.g6b5491de43-goog
>
