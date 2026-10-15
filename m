Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE578348445;
	Thu, 15 Oct 2026 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075227; cv=none; b=YLDRpLzEF0cg5qUpqJ2u6WeXFdpdfkIihdCzf3Ump+RfruFVJc8NSv17U1N+Unnl3zqdmOOktP3Qmywv8/TwcI0XzkL8SxTy0JHnuH2V4q2VUiz8q26hF9HlEHQGWyOt46DJ4aZP8BV9F8ZzpdxjZCN8JwpohS9hhsr7Cwu/4UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075227; c=relaxed/simple;
	bh=IXnNB2y9KF/YLm9Pu4mdpUrwx7a3BUbhHG67ouJ3S+c=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HxaCB5eq8i46lVKWAqGPQBtSTuiNczCHIgx/HxAAEK0V5ixHWzQSPFmIXptNSm893L82Knk2fSQrTBSOe+EaFm1tVlm/Zq6cciJQlPIpIUelQMGlK+/t9SiwcYbE5r/eIJOOnyGWWmAVxnWjzLYpRekHPDSALrEwaszYtWAnHCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwBDerW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwBDerW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D041F000C4;
	Thu, 15 Oct 2026 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075226;
	bh=X+//KzDIidIUzfc5n59pBr5CNd07A7Z+jhwGLIpbXag=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AwBDerW32w3zzsaF/0H2Uq8vyuJ9q3f+tzwIgTIaQ7TJh2WH4EOO6Dpcesm+fT/Pw
	 K2pR3DTBaSnKZVybneflfqEJj4kTYF3kN24BsLuUYOFHHsd5CM21s2gn4Hf+rnPr42
	 r9qTFqTvgyuPfgYmfcTCCqlNfZrpScKaUpqn9eMdkUbTxv+NsDtnZJmq6t0cbt1pij
	 7H4hkClgQZboSonsYgridO2g8ZQYHxl/1SgpOulsDhdOiZlIkfXLDIM9p46Lh3DTtP
	 FNzvwyminXOd7rx1xNyd72ggeHWmu8oJkvAehdI9iMiauOnWKubZ4cc+G63nH6Mmpt
	 CzTo4Q6fcvtxw==
Message-ID: <sashiko-outbox-172969@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 13/15] misc/arm-cla: Add stage-2 MTC and VM
 context switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-14-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-14-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:40:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kvm: use-after-free and refcount underflow in cla_ctx_create()
- [Medium] arm-cla: late validation of VHE mode breaks device domain
--

commit fd14d79171a8956e71dc07a1dfa6797aaef533a8
Author: Jean-Philippe Brucker <jpb@kernel.org>

misc/arm-cla: Add stage-2 MTC and VM context switch

Add functions to switch the guest MTC. Reset the accelerators and CLA
registers on switch. No save/restore of accelerators at the moment, we
only restore the kernel's PL0CTL.

> diff --git a/drivers/misc/arm-cla/cla-ctx.c b/drivers/misc/arm-cla/cla-ct=
x.c
> --- a/drivers/misc/arm-cla/cla-ctx.c
> +++ b/drivers/misc/arm-cla/cla-ctx.c
[ ... ]
> @@ -48,8 +79,12 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *doma=
in,
>  	INIT_LIST_HEAD(&ctx->queue_node);
>  	init_waitqueue_head(&ctx->waitq);
> =20
> -	mmgrab(key->mm);
> -	get_file(key->file);
> +	if (cla_ctx_is_pl0(ctx)) {
> +		mmgrab(key->mm);
> +		get_file(key->file);
> +	} else {
> +		WARN_ON(!cla_ctx_get_pl1(ctx));
> +	}

[Severity: High]
If cla_ctx_get_pl1() fails and returns false (for example, if the KVM=20
instance is dying and its refcount is zero), does execution continue here
with an unreferenced and potentially freed kvm pointer?

If so, this unreferenced pointer is later passed to cla_mtc_get_ctx() and
then cla_mtc_get_s2_ctx(), which calls kvm_arch_get_guest_mmu(). That
function dereferences the invalid pointer when acquiring the config_lock:

arch/arm64/kvm/mmu.c:kvm_arch_get_guest_mmu() {
        ...
        guard(mutex)(&kvm->arch.config_lock);
        ...
}

Could this lead to a use-after-free? Furthermore, if execution reaches the
err_free error path, cla_ctx_put_pl1() is called unconditionally, which
calls kvm_put_kvm() and could cause a refcount underflow. Should this path
return an error immediately if the KVM reference cannot be acquired?

> diff --git a/drivers/misc/arm-cla/cla-mtc.c b/drivers/misc/arm-cla/cla-mt=
c.c
> --- a/drivers/misc/arm-cla/cla-mtc.c
> +++ b/drivers/misc/arm-cla/cla-mtc.c
[ ... ]
> @@ -137,6 +205,49 @@ static int cla_mtc_uninstall_s1(struct cla_dev *dev)
>  	return cla_op_setctx(dev, cla_kernel_mtc + CLA_MTC_TTBR0, 1, &ttbr0);
>  }
> =20
> +static int cla_mtc_install_s2(struct cla_dev *dev, struct cla_ctx *ctx)
> +{
> +	struct cla_mtc_s2 s2 =3D {};
> +	const size_t num_regs =3D sizeof(s2) / sizeof(u64);
> +
> +	if (WARN_ON(cla_kernel_pl !=3D 2))
> +		return -EINVAL;

[Severity: Medium]
Because this validation occurs during the context switch path (called by
the scheduler), is it too late to gracefully reject an unsupported VM
configuration?

If this WARN_ON is hit after the PL1 context has already been created and
queued, returning an error during the context switch might cause the
hardware domain to be permanently marked as broken and leak resources.
Would it be safer to perform this capability check upfront during context
creation, for example in cla_mtc_get_s2_ctx()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D13
