Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CD481A97;
	Fri,  4 Sep 2026 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525588; cv=none; b=ORww3kqi3LS5XTEEXcYw2lKNHV4SNejb5nHruiB4HndPrfqGCYiqGpFV3Srq1Flm/Kt5TDm9wBu2YVcC3GFjFAln0ZUyoXLD9x2BdtxtWJXC2nWQgeCkbFcepI9YPqPxOAb+6cPrb9+NTijCqmE7VcBT1Igvf3nond10A1Dks8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525588; c=relaxed/simple;
	bh=klg18sdP74LdCAoSKwbCYIWnYTM0bd92HcipT1ygl7Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TKSWGtn+dVd6JvtfDBL250go8e7oj9FO/blyQBHwEVb8pPVYcfLSlHBXjduRk/EFk6NZnaP19POqBm99luy+GtmmSJPC3cmkejdQ0qawulj/OBOqt1jvUlBKFvYXdcXA1PMc7Ng8zQRDUcJKoZAKq9IdiZnam18eqmQyQuB/lPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhnFjbPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhnFjbPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA99E1F00A3D;
	Fri,  4 Sep 2026 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788525587;
	bh=OBp30fHsH5xaCV/8B+OU+Nh7XSFpEjQrepsPIl9sKbY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhnFjbPfyRMrg/OIS6Ewh7eAjdWGiXGVzoB5jlhUPdvQaym1Tx+0Ue9IcD19oLyyR
	 KXfYUFojgeUc9ymE10WmsJL/Vi/oe3lN176gycFB78/MUqVtYYwQUAwAa9wNGnZcru
	 r8E+pQjnrx+qzGxibaTw6s480VVYr5gNmboi5QaQK9TcvWvCV76bqsGXqJxv7CZ08C
	 mmlT+9KBdFar3t4nG/qdczPxLt0wRpRK3c62m4pFIAqhcPkz6uzY7xVQdg8goN1GkE
	 8mOesrrYLaFafwKfjZZwUXrQGfse8x3vNtPGqxIG7PCcqeXjkmn6ODzPOFtVphE+0h
	 2Z02kbcbEiP3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS
 MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-12-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:39:46 +0000
Message-Id: <20260904123946.BA99E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware use-after-free due to freeing L2 VMT table on IRS command=
 timeout.
--

commit 23122c0955d56e620d2ddd8d2f3565105e20e23a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops

This commit implements the IRS MMIO interface to make GICv5 VM tables (VMT)
and interrupt sequence tables (IST) valid. It also plumbs in the related
vCPU affinity commands, and ensures memory is not freed if an IRS command
timeout leaves the hardware in an indeterminate state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index c65355483f64b..3d8f17301567a 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -128,20 +187,145 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
[ ... ]
>  static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcp=
u_info)
>  {
> +	struct vgic_v5_vm *vm =3D data->domain->host_data;
>  	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
> =20
>  	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
> =20
>  	switch (*cmd) {
>  	case VMT_L2_MAP:
> +		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);

[Severity: High]
Since VMT_L2_MAP is now fully wired up to the hardware IRS interface, does
this expose a hardware use-after-free bug in vgic_v5_alloc_l2_vmt()?

Looking at arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_alloc_l2_vmt():

	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

	/* We've failed to make the L2 VMT valid - things are very broken! */
	if (ret) {
		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
			/* Remove the pointer from L1 table */
			WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);

			vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
					    sizeof(vmtl1_entry));
		}

		kfree(l2_table);
		return ret;
	}

If the IRS command times out (-ETIMEDOUT), the code immediately zeroes the
pointer and frees l2_table. As noted in the commit message for VIST
assignments, a timeout doesn't guarantee the hardware hasn't cached the
pointer.

Should a similar mitigation (retaining the allocation and marking the VM
dead) be applied to the L2 VMT allocation path to prevent the hardware from
potentially accessing memory that has been returned to the slab allocator?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D11
