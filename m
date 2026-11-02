Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653333;
	b=qDda6UatQB1mQIJ1aDp3Wyf0l5rxoc07onB0Kc+Ncp9Pfpa1Pi4mo3MxSh3qnRYwEiIn
	 dGwvrktAvPQyCLKtYDcIM47+yvZ9Ygh2FfeRMEWYd5SMv9dGwr7eo1uhuW4ylOlIIgOY2
	 z2FzmpQzjSaFURSWafVojksB4ji3P0c5fdia1H2fx7xSFjHmlsSuqlqIP5CbI6BKg2MZt
	 qOAsSPeuEhNOWUQT4w1E9iAoseCNhsHNVpGAjiiH6YnjoMnJtTb6WiFBTFT17yViR4Ak5
	 skclUS2vtI/E4Rsqs4Q9EPEEQfTDZuS5TDHRGPenWISFObGHiYtJPAyVNqgRqUJtSUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653333;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wjWu7VvkLGEqTrRPFY+Zv7k0bSSZtSEPQACQbhPOJtQ=;
	b=v8E/uSObKcP1X9s6eAMTeJuz/oCBdrj0RYEGmXe5mwJcZcIjbAMm6ts6vwo53755DL9i
	 JcxJoAStFbWT4N6d4I/9OsQkj/gTXItLOMryqxlmm3OxgGUNzQ/y6Hkm2vrNr1aERQ9DX
	 RWO6NJsoP3G7PN4G5bpA7Y0PBIh3wxZEXVRHVhRsRYsRA0LrOwgVQOWfMolAu3QEesuoh
	 pNlJl6Bsbg/Fc3DjIvtTGB9VnLS23PGffl8pss48RK+Jjyekbujd7b1uSXO9Ld8ne01bv
	 VJyVHzlc0xFkFkrQ/u4sTsCCuwhuKdUzBGUJcyDND8IlFOt4GFSgWn4eEl3Mtejy/pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wuudxzj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CEB606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wuudxzj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615521F00A16;
	Mon,  2 Nov 2026 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653332;
	bh=wjWu7VvkLGEqTrRPFY+Zv7k0bSSZtSEPQACQbhPOJtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wuudxzj3iU9mIpPNvGrS6lU6bjokDyz9rogMDkqcJ47gTl/zbFOTzWUZhvvXVwxYG
	 2LcNdPuzsEmhrM9mHsnW3KbqEAzlOvPyeBcO5tZLUlBRBFOM6ps4WHjOUGom3zBEX4
	 cGhl9zovWrmKXNEW2di1q+8YzwuUfADxjQNP08ZxgCNeN4LXeDE7In2oREetA8KyUa
	 hN6/uOmJUBBouhwLOVGB4DvzY3RAlKGNlEuByPPby8Emf1Pewi1J5lT+CdezAt+GNd
	 5oka7EdR+/C9FAt4mKwluqZj1WcFKyj8aT5O4l77emVIJ6HvCJ/gXCJTGhzS3Wb1Ky
	 bssyE3cy+Vavw==
Message-ID: <sashiko-outbox-194174@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/23] KVM: arm64: Introduce
 kvm_pgtable_stage2_table_install()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102204628.401871-19-vdonnefort@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-19-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:02:11 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] KVM: arm64: missing block alignment check in stage2_table_instal=
l_walker()
- [Low] KVM: arm64: kernel-doc mismatch for kvm_pgtable_stage2_table_instal=
l()
--

commit 2ec53eff489eca020eb2705b64a21720b1def67f
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Introduce kvm_pgtable_stage2_table_install()

This commit introduces kvm_pgtable_stage2_table_install() to replace a
stage-2 leaf entry with a pre-allocated table, enabling pKVM to handle block
splitting in mem_protect.c without relying on kvm_mmu_memory_cache.

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/as=
m/kvm_pgtable.h
> index 1c9c57cd6ae40..587874c3a5259 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -835,6 +835,18 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt=
, u64 addr, u64 size);
>  int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  			     struct kvm_mmu_memory_cache *mc);
> =20
> +/**
> + * kvm_pgtable_stage2_table_install() - Replace a stage-2 leaf entry wit=
h a table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_create_u=
nlinked().
> + * @addr:	Address identifying the leaf entry to replace.
> + * @size:	Size of the block to replace.
> + * @tab:	Pointer to the pre-allocated table to install.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, u64 addr, =
u64 size,
> +				     kvm_pte_t *table);

[Severity: Low]
In the kernel-doc comment for kvm_pgtable_stage2_table_install(), @tab does
not match the parameter name table in the prototype (and definition in
arch/arm64/kvm/hyp/pgtable.c), which triggers a scripts/kernel-doc warning.

Also, @pgt is described as initialised by
kvm_pgtable_stage2_create_unlinked(). Should @pgt be documented as
initialised by kvm_pgtable_stage2_init*(), with @table being the table that
may be created by kvm_pgtable_stage2_create_unlinked()?

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index abd32e94f6ff0..19634e5ec5557 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -1620,6 +1634,55 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *p=
gt, u64 addr, u64 size,
>  	return ret;
>  }
> =20
> +struct stage2_table_install_data {
> +	struct kvm_s2_mmu	*mmu;
> +	kvm_pte_t		*table;
> +};
> +
> +static int stage2_table_install_walker(const struct kvm_pgtable_visit_ct=
x *ctx,
> +				       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct stage2_table_install_data *data =3D ctx->arg;
> +	struct kvm_s2_mmu *mmu =3D data->mmu;
> +	kvm_pte_t *childp =3D data->table;
> +
> +	if (ctx->level =3D=3D KVM_PGTABLE_LAST_LEVEL)
> +		return -EINVAL;
> +
> +	if (ctx->addr !=3D ctx->start ||
> +	    ctx->end !=3D ctx->addr + kvm_granule_size(ctx->level))
> +		return -EINVAL;

[Severity: Medium]
Does this check verify that ctx->addr is aligned to the block granule size
kvm_granule_size(ctx->level)?

In kvm_pgtable_walk(), both walk_data.start and walk_data.addr are
initialised to ALIGN_DOWN(addr, PAGE_SIZE):

	struct kvm_pgtable_walk_data walk_data =3D {
		.start	=3D ALIGN_DOWN(addr, PAGE_SIZE),
		.addr	=3D ALIGN_DOWN(addr, PAGE_SIZE),
		.end	=3D PAGE_ALIGN(walk_data.addr + size),
		.walker	=3D walker,
	};

In __kvm_pgtable_visit(), data->addr is only aligned down to
kvm_granule_size(level) and advanced after the leaf callback returns 0:

	if (!table) {
		data->addr =3D ALIGN_DOWN(data->addr, kvm_granule_size(level));
		data->addr +=3D kvm_granule_size(level);
		goto out;
	}

Because stage2_table_install_walker() is only invoked for
KVM_PGTABLE_WALK_LEAF and always returns a non-zero value, ctx->addr is
always equal to ctx->start on the first visited leaf entry, making
ctx->addr !=3D ctx->start always false.

If kvm_pgtable_stage2_table_install() is called with an addr that is
page-aligned but not aligned to kvm_granule_size(ctx->level) and with size
equal to kvm_granule_size(ctx->level), this check will pass, replacing the
enclosing block PTE and passing an unaligned IPA to stage2_try_break_pte().
Although the callers added later in the series (__pkvm_host_split_guest()
and host_stage2_split_gfn_meta()) check PMD_SIZE alignment beforehand,
should stage2_table_install_walker() check
!IS_ALIGNED(ctx->addr, kvm_granule_size(ctx->level))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102204628.4018=
71-1-vdonnefort@google.com?part=3D18
