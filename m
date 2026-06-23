Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664022E7F39
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241271; cv=none; b=BlhnR42cg7OOKPUintUPeoXxG6BcQmkihDRe7D+oYR/QYPbNEuedZfipqK52lt7oyEev64l08T6RSZA1wcdWxFQ8Hyv0Wz07qKYK11PI0Y5RQRbx70PE+QaeJ4BTgymQepgXBP3s6I2rk7pUgrpB4PDs4+61oYdU8CANb5Z8BOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241271; c=relaxed/simple;
	bh=uk7wAs/8CO/YxhC00M1HnqBu6htaJoJPy97u27iUUrI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D2BoFA4aV7BdvZBSz7mNCepOEFaucgCYLg1Shd3w41Y0X3RVZjuPoqxT/48ozBEOQkmFljHVilVFhnJes36uJmd1r8B7nndTv0ck3ewkadUDAabvA0+kDjOBV+1yMoplcGmvWki2bKMi4YpyEFgVUwR+yc1x6bYUMQD3kfkaZBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9viUhSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9viUhSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8981F00A3A;
	Tue, 23 Jun 2026 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241270;
	bh=FrA3CijLRyy9VdkSr1IgegKxEv6AdxjKZMLDSlwouGQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9viUhSy8Tk4rGXnVcy1wJrDa1IJd/PyLCsq9UdVxie90ZXWQCoAuZAeRH685Wu/6
	 3qu2tr5PL36sHngqJaZMrE3tlO/U7JD+0XLq2wi5qsyuMdjVCh38QctiPSfufl7N3I
	 jXkfNxnFtHbHM79VG5rfffudJZ1o0Kgt2VFlEq1QFMvbA1xQ6j/C3ZbJlR5pmCv0Wo
	 WUKM/zLZ4si5ZRf5sVtzDBjTWc0OzPIuDC0IZyfhyjYj/oSeAnYvEbg3jVDvRxMqB4
	 a7s6/sMzKQ2qaH2OmSnspZ5jDt04s4HiE5S/T8Zk+Oj5EKgOB0M4wAXnNW/krcdz6T
	 4dGW2t3kgyGjg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/22] KVM: arm64: nv: Expose FEAT_HAFDBS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-17-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-17-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:01:09 +0000
Message-Id: <20260623190109.CC8981F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] KVM will double-fault on the first write to any DBM-enabled page i=
n a nested guest due to stale dirty state evaluation.
--

commit 559268b60f71702530e79a26ecefcf5b5cf06620
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Expose FEAT_HAFDBS
   =20
This commit enables FEAT_HAFDBS (Hardware Access Flag and Dirty Bit Managem=
ent)
for nested virtual machines by advertising DBM support to the guest.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4d128003ae7a5..2408d604a1e18 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1790,7 +1790,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
>  			val &=3D ~ID_AA64MMFR1_EL1_VH;
> =20
> -		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
> +		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);

[Severity: High]
This is a pre-existing issue, but exposing DBM here appears to cause a
performance regression where a nested guest will double-fault on the first
write to any DBM-enabled page.

In walk_nested_s2_pgd(), the code evaluates the stale descriptor before
atomic-swapping the dirty bit into memory:

arch/arm64/kvm/nested.c:walk_nested_s2_pgd() {
    ...
    compute_s2_permissions(vcpu, wi, &ws, out);
    out->level =3D ws.level;
    out->desc =3D ws.desc;

    ret =3D handle_desc_update(vcpu, wi, &ws, out, access);
    if (ret)
        return ret;
    ...
}

If handle_desc_update() successfully updates the descriptor, it returns 0
without updating out->dirty or out->desc:

arch/arm64/kvm/nested.c:handle_desc_update() {
    ...
    ret =3D __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
    if (!ret || ret =3D=3D -EAGAIN)
        return ret;

    out->esr =3D ESR_ELx_FSC_SEA_TTW(ws->level);
    out->desc =3D ws->desc;
    return 1;
}

Because out->dirty remains false after the successful update, does
adjust_nested_fault_perms() strip the writable permission, forcing a second
VM exit when the guest resumes?=20

Should walk_nested_s2_pgd() or handle_desc_update() be modified to re-evalu=
ate
the permissions upon success before enabling DBM?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D16
