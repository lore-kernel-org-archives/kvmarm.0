Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923574B2713
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 23:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600614; cv=none; b=plSIWJtM76mGsEwXV3t+iLkX2/jVVsKm9DbUIJjwIQ4VSUz7izxpBJwZ55T6wD2eao4Mwk2sDNI0ufTZnOJk/DFuf5y/wKOuOJOa7qpz4tB/tstSpE2qg5T7sWNGcI08bwm0jf03CmoWydWqWlwtc1JrNNhLvOm5wCOp3ApfL9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600614; c=relaxed/simple;
	bh=jw01Rk1BSpeUAUDE5yQP+WWRPzS6xBkA/HjioPjX8II=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f3tr2dio/uD2ywCA3PR/J6FnxcU/afK1yAebaim7QCro3vDalcbDPAYs3d4tGFGVl+xr7CHTTxkCHhR1ohbOMZovAJAqDuORoG4EAbg7aENPY9G3DsTRXu1djfl+3QDWZxtd3q13apT5n6d4EF4tJNQzC02bgKzVR64HkOL43eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1ooN2GA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1ooN2GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44E51F0089A;
	Wed, 16 Sep 2026 23:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789600613;
	bh=vK3Xp7l0UJAuNSmsAs5fgAVNc47EhKS6du8qeF+Q2q0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M1ooN2GAwFOUpjBBmFOnRg0GT7B20nQv+GN5cLfMAQpHL/hkPNoUkW40ddIPHft51
	 A4/i0ysJKcI1hPeushgW1zCx3XX9gb5IKX5rsTP/DCNpeSezlXqa9OQdWaE1Q8b19H
	 u7s8YR+tlfrfSr4B6uvqVw6HdejBGKBXbAx6cpOT3+m8/cJaN84uiEdG/aHh/ZVPa9
	 JbBalSeRD45GU4arN83Gmfkj9EuJSb6bzuiYRDb6eHhDxxaqEYNtR5cqM716UpLpyQ
	 f3vUW4QHGqemLoPROqrPKt8RDNxVa7ciDYnJmM9VOc1NGFX2uqS5YqPNdoF/GWoctM
	 X9qqVmcQGSN4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: ptdump: Check the page tables aren't
 freed when accessing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260916230337.4162485-2-weilin.chang@arm.com>
References: <20260916230337.4162485-1-weilin.chang@arm.com>
 <20260916230337.4162485-2-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:16:52 +0000
Message-Id: <20260916231652.E44E51F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: ptdump: prolonged write_lock on mmu_lock causes lock=
 contention
--

commit 6e17983aae35d9aa5807fc7910feb63951dae7e2
Author: Wei-Lin Chang <weilin.chang@arm.com>
KVM: arm64: ptdump: Check the page tables aren't freed when accessing

This patch adds checks to ensure that stage-2 page tables are not freed dur=
ing
access when debugfs ptdump files are opened or read. It uses mmu_lock to
protect the existence of the page tables and switches related handlers to
keep a pointer to the mmu instead.

Link: https://lore.kernel.org/kvmarm/20260623144054.B91D21F000E9@smtp.kerne=
l.org/

> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 69899797dbad8..4ead856c181a0 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
[ ... ]
>  static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kv=
m_s2_mmu *mmu)
>  {
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
>  	struct kvm_ptdump_guest_state *st;
> -	struct kvm_pgtable *pgtable =3D mmu->pgt;
> +	s8 start_level;
>  	int ret;
> =20
> +	/*
> +	 * We only need the pgt start level to initialize the ptdump, get it
> +	 * while holding the mmu_lock. It's fine if the pgt gets freed
> +	 * afterwards, we'll check again when doing the actual dump.
> +	 */
> +	scoped_guard(write_lock, &kvm->mmu_lock) {

[Severity: Medium]
Does this code unnecessarily acquire the exclusive write lock just to read =
the
start_level in kvm_ptdump_parser_create()?

Since this is a read-only field check, acquiring the write lock could conte=
nd
with VM page faults. Could read_lock be used here instead?

> +		if (mmu->pgt)
> +			start_level =3D mmu->pgt->start_level;
> +		else
> +			return ERR_PTR(-ENOENT);
> +	}
[ ... ]
> @@ -149,6 +162,9 @@ static int kvm_ptdump_guest_show(struct seq_file *m, =
void *unused)
>  	};
> =20
>  	guard(write_lock)(&kvm->mmu_lock);

[Severity: Medium]
Does this sequence create a denial of service regression by holding the
exclusive write lock for the entire duration of a heavy page table walk?

The full page table walk is performed synchronously while the exclusive lock
is held later in kvm_ptdump_guest_show():

    ret =3D kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);

This prolonged read-only walk blocks all VM page faults, causing severe lock
contention.

Since a user reading the ptdump file from debugfs can trigger this path, it
may allow host userspace to stall all vCPUs. Is it possible to perform this
walk using read_lock instead?

> +	if (!mmu->pgt)
> +		return 0;
> +
>  	st->parser_state =3D (struct ptdump_pg_state) {
[ ... ]
> @@ -211,17 +227,27 @@ static const struct file_operations kvm_ptdump_gues=
t_fops =3D {
> =20
>  static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
>  {
> -	struct kvm_pgtable *pgtable =3D m->private;
> +	struct kvm_s2_mmu *mmu =3D m->private;
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +
> +	guard(write_lock)(&kvm->mmu_lock);

[Severity: Medium]
Does this code unnecessarily acquire the exclusive write lock for a read-on=
ly
field check in kvm_pgtable_range_show()?

> +
> +	if (mmu->pgt)
> +		seq_printf(m, "%2u\n", mmu->pgt->ia_bits);
> =20
> -	seq_printf(m, "%2u\n", pgtable->ia_bits);
>  	return 0;
>  }
> =20
>  static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
>  {
> -	struct kvm_pgtable *pgtable =3D m->private;
> +	struct kvm_s2_mmu *mmu =3D m->private;
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +
> +	guard(write_lock)(&kvm->mmu_lock);

[Severity: Medium]
Similarly, does this code unnecessarily acquire the exclusive write lock fo=
r a
read-only field check in kvm_pgtable_levels_show()?

> +
> +	if (mmu->pgt)
> +		seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - mmu->pgt->start_level);
> =20
> -	seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - pgtable->start_level);
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230337.4162=
485-1-weilin.chang@arm.com?part=3D1
