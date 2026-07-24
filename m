Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0773C4562;
	Fri, 24 Jul 2026 11:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892473; cv=none; b=h8loc9IRN+3vH+JSc/IM4itWFYLsdEia6Ago/27ODF2hJAJw1CIWB3I8HJSvlUgc8myXfs8D4tPiXHRU50Xzc8b6AyElfR6rnzW/l1l3BsbZtJ67h/yw4BOIVAt6HcskG3+l129tmiJAW28paAgT7hrnpU56SInKqjlZ0i2MO8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892473; c=relaxed/simple;
	bh=ea4zlVoiCagxf09fm456rJeS3DfpBaCSu+334VpBMmw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lazmo77T5hQ2bKpkmcJQURLGYLuEpdt9HXjdFnzCiGhI7m8wBUto9Aqh5UWmw8vPZ+EDBaUtOle1MVr4V49AuWDt4sKXl3BCHotXChAG/C1g0NT0iZPlu/UAvHTLXzTquOKFVdaq23EDglR6ZbZy/oDQKgt77dy8+0fCuB1Nfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zwde0RGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zwde0RGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7BC1F00A3A;
	Fri, 24 Jul 2026 11:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892471;
	bh=Pg6bs1ySV/pA+vVdNFOQ/g7CqZuA2ZEgJ+Ngv9+oPSU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zwde0RGZd8bdWhY8eNOnP5c/7YpTUOA0cdczO89aJ2lqnnaGIv/Hs7f4v3A66nz0g
	 9d5gYTVCRDb6xf+fwZgHBOYkutcZUJw4gCMBDz5/tbX+UDPpb3O+LS5q38SE7H2brw
	 7Tkz+qLRMVA99FM31AKmnl7lQ8u0b5pFOzf3yPUgZLslCBK7rUdTxryGBRKGWCwtoM
	 jQwTbNKl0ChqyR8zC+XFV/DQn8cd4CiByza2Btdts9J0ZsOGci3BNdKAhpu8hQIxen
	 zD1A12l18ntrOFXfyLiToik0o9O7/PyUKLj71FJpK/7LCfUGDN7DLOIsKPQ8J9Gy0K
	 RyJup0+cQOIJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-15-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-15-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:27:50 +0000
Message-Id: <20260724112751.0D7BC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] vgic_v5_send_command() unsafely passes 0 to irq_set_vcpu_affinity(=
) if the doorbell IRQ is not allocated.
--

--- Patch [14]: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE d=
oorbells ---
commit 3fe87417ec724cc6e6581baab62b9b85ad04ae50
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells

This patch introduces the setup and teardown paths for GICv5 VM Table Entri=
es
and VPE doorbells. It allocates a VM ID, creates a per-VM VPE doorbell IRQ
domain, and assigns doorbells to vCPUs for communication with the host IRS.
Initialization and teardown workflows are implemented, including unwind pat=
hs
for partial failures.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 826c2284a1453..4a62aa7d6505a 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -406,6 +406,23 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe=
_id,
>  	return 0;
>  }
> =20
> +static irqreturn_t db_handler(int irq, void *data)
> +{
> +	struct kvm_vcpu *vcpu =3D data;
> +
> +	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
> +
> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +	kvm_vcpu_kick(vcpu);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_c=
md cmd)
> +{
> +	return irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
> +}

[Severity: High]
Does this code handle the case where the doorbell IRQ is not allocated yet =
or
has already been freed, returning 0 from vgic_v5_vpe_db(vcpu)?

Passing 0 to irq_set_vcpu_affinity() can cause unexpected behavior, includi=
ng
potential memory corruption if IRQ 0 happens to be a valid interrupt on the
platform.

There appear to be two paths where this happens. First, vgic_v5_reset() can=
 be
invoked before the VGIC is initialized, meaning the doorbell IRQ is still 0:

arch/arm64/kvm/vgic/vgic-v5.c:vgic_v5_reset()
	/* Make the VPE valid in the VPET */
	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
		return;

Second, a secondary teardown retry can trigger this in vgic_v5_teardown(). =
If
an initial teardown failed to invalidate the VMTE, it leaves
vmte_allocated =3D true but still frees the doorbells. A subsequent teardown
will execute this with a 0 doorbell IRQ:

arch/arm64/kvm/vgic/vgic-v5.c:vgic_v5_teardown()
	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
		/* Make the VM invalid  */
		vcpu0 =3D kvm_get_vcpu(kvm, 0);
		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);

Could vgic_v5_send_command() verify the IRQ is non-zero before passing it
to the IRQ core?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D14
