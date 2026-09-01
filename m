Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744B2D1913
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300373; cv=none; b=FOvhTmxlFMixBzFtd175T82IDJussfoywaWxt2Lbj2wpptxkm8+/oSfFjcaZHXHoUqjoxCy1MEUCTwYuHIE6F6+2VeJCvmKU6TF7JcCFSozOvKMN/wqmagl332mOjB/Ze+Xs/POaZGXqk03V+MY5kof4XZu3v8bf8JrFfgXc2aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300373; c=relaxed/simple;
	bh=roMBVC4YENB9O5kEzF9ORaY0D47d9um3Q2QQmGjwoD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z1e6egBnzRBxP0sUGUAruoqQAYYpdcgQixVLTD99lxqqkCL54GQOVY/KRQOcucGPKR4Azpb/auo1fgH7T5U+D49gYcswdEcLBRtXZ3zMxmWzUoWex1pBf0pD1wy7YdFIm/ZXgCDiMlu9e934prTaEF0IkZPEv8FShYkMcMZ0Fp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGSCBeqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGSCBeqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372C91F000E9;
	Tue,  1 Sep 2026 22:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300371;
	bh=m8Z4jh6yhFJdrULaK6SWOWjfud1YThIq70D8lGSPNU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eGSCBeqFyfjg8sORAoPrmCtD3+GXam7Z5djwI6LS2ljXx/31qZvjp5yQvrAtqh9rF
	 HbImRNj9AKAA3G1AHy2cvAHESGiNrpeT3Yi2MCp1BLtSmLy35YjhPTPTcNosS+mDsF
	 f3NqFJzTshWFoNo5dDjqa637xmXuPZT/FoTNqqnfIt4NlSe89dByDo8u+8yyFG1QwK
	 6xhCg0sV7a1QdbcjXJyL4L/WE0FLC/udBaUdBnnpA24GXNeUt5ZwemjoJE0fT3mz1d
	 f0nxbF6Ns4NG3nctKY/v9fqlB3fC69ef00w1IOMH+viSWgy/0nrjfq3gdaAPFqPLPQ
	 KwCp1KFrzgpig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:06:10 +0000
Message-Id: <20260901220611.372C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing explicit GCS barriers on the vCPU load/entry paths, failin=
g to order host acquires against incoming guest GCS memory effects.
--

commit 171e0d39ad041f789da5126a2b828fc123587e80
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Ensure GCS memory effects are visible

This patch adds explicit GCS barriers to vCPU context switch operations.
Since the hypervisor and host kernel do not use GCS themselves, they cannot
rely on implicit barriers and must manually insert them to ensure GCS memory
effects are visible.

>     In order to allow efficient implementation of GCS implementations are
>     permitted to do GCS specific caching, with barriers implicit in stack
>     switch operations and GCSB DSYNC as an explicit barrier.  Since we do
>     not use GCS in the hypervisor or host kernel the hypervisor cannot re=
ly
>     on any barriers being present in vCPU context switches other than tho=
se
>     it explicitly inserts.  Add explicit barriers when loading and saving
>     vCPU state.

[Severity: High]
The commit message states that explicit barriers are added when "loading and
saving vCPU state", but the barriers appear to be missing from the load pat=
hs.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..52f53f682e6af 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -755,6 +755,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>  	}
> =20
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (kvm_has_gcs(vcpu->kvm))
> +		gcsb_dsync();
> +

[Severity: High]
While gcsb_dsync() is added here in the saving/outgoing path
(kvm_arch_vcpu_put), does the corresponding loading/incoming path in
kvm_arch_vcpu_load() also require this barrier?

Without an incoming barrier on the load/entry paths, could a guest's
subsequent GCS memory stores be speculatively reordered before the host's l=
ock
acquisitions are complete?

Could this regression potentially violate memory ordering guarantees if ano=
ther
CPU observes the guest's execution before the host's context switch locks a=
re
fully resolved?

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 9a3b92e626adb..534db037c5f69 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -261,6 +261,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere even if the host skips syncing.
> +	 */
> +	if (kvm_has_gcs(hyp_vcpu->vcpu.kvm))
> +		gcsb_dsync();
> +

[Severity: High]
Similarly, a barrier is added here to sync_hyp_vcpu(), but the entry seam
flush_hyp_vcpu() does not receive one. Should flush_hyp_vcpu() also include
an incoming barrier to ensure prior lock acquires are properly ordered agai=
nst
the incoming thread's GCS effects?

>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>  	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D4
