Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D1135202C
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781853950; cv=none; b=SDwVaJfRQWYEDWghTrbT/GUYQKvNGsbwtgwq0OCyktzHFZYIoBRJJFaGPEqsKgU1HQHjOrY1TCWybub1Btk8F3J/l4w8ZEDQrXPK3P1i0Blmo+yE4uo81jATho2YlAs/PT8hL36Y/zLL48FjsPv9zp8DCAKQyDRCdR2XmrsaeA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781853950; c=relaxed/simple;
	bh=3PafbYno+QsZPYKCdQp1hvKG6I484W+PyfM6Fuw23RA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QK7wxIgi1ImVxVx216RV9oy2SUcV/OQH6hBBwwj6erUCO7FF0ISWQ3VOLqTC7dyGk/fPJAwoMhQ/eve9tcwHokpRk4VRwJ8jtkZQmw4U/Y44k14quBde2OFz/ON6bLWlRZv0VL22Pv2CpXL9hZQMRIjbKHHRtjcI/P+9mYm/toc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGObB9PK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGObB9PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759B01F000E9;
	Fri, 19 Jun 2026 07:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781853948;
	bh=QAygS4T9c8fwlBmpsqMW2C5UMjgPWQuxUlq3zYGC2WQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HGObB9PK9AibpucgLsn+RBLww0qUwhuPhHUA7CtdFq0UM/XMH7Oq1px3SN/852Pht
	 swqpGKpDpK/qgpY5ZVl2SIQH6Ex4RyyKTL/VfzQnlfnSBrsCiDClAjS4qGmrS84fIp
	 rhZxmHzxvG+l4Y2K8uQT6rHXZ8WczgDtYH+/dDx0cnv5uskMwHZhq/9O7QHNZ3oe39
	 43TR19LIcjAJXrb9MfdLxKTe7GZR9NwmTcbeXQzvCQqH9d/yEo/FEIM4xylHxdcCnv
	 MYhK65lMLYIVOUA9RFq4m4FD/Kdo46wIWkk3CBheFxLrNKNWiyIYJeMI5hPAn16HVn
	 aBYvY8ncQo4TQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260619070719.812227-7-tabba@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-7-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:25:48 +0000
Message-Id: <20260619072548.759B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] handle___vgic_v3_save_aprs incorrectly clobbers the host's vgic_vm=
cr with a stale value.

Pre-existing issues:
- [Critical] The patch fixes arbitrary host-pointer dereferences in the VGI=
Cv3 save/restore hypercalls but leaves the exact same isolation bypass vuln=
erability open for GICv5 equivalents and handle___kvm_adjust_pc.
--

commit a6f1c910e601736a7f5d9f267e781560d10966dc
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences wholesale.
This patch recovers the host vCPU from the supplied cpu_if via
container_of() and copies only vgic_vmcr and the active priority registers
between EL2's hyp-side state and the host vCPU.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 45d717889f6ea..f3233ee343a39 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm_c=
pu_context *host_ctxt)
>  {

[ ... ]

> +		host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +		host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;

[Severity: High]
Does this overwrite the host's updated vgic_vmcr with a stale hyp copy?

Since __vgic_v3_save_aprs() does not read the hardware ICH_VMCR_EL2 registe=
r,
hyp_cpu_if->vgic_vmcr retains the value it held at the last guest exit.

If the host kernel emulated a write to the guest's VMCR (for example, via
vgic_v3_set_vmcr() during a trapped sysreg access) before the vCPU thread
is preempted, this explicit copy back to host_cpu_if will discard the host's
emulated state changes.

[ ... ]

> +	} else {
> +		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }

[Severity: Critical]
This is a pre-existing issue, but since this patch secures the VGICv3
save/restore hypercalls against arbitrary host-pointer dereferences,
should the same protections be extended to handle___kvm_adjust_pc and
the v5 equivalents?

Currently, handlers like handle___kvm_adjust_pc() still pass unvalidated
host registers directly into kern_hyp_va():

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
    DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
    __kvm_adjust_pc(kern_hyp_va(vcpu));
}

Because kern_hyp_va() is idempotent for addresses that already carry the
hyp linear-map tag, an untrusted host could supply an EL2 linear-map
pointer that is returned unchanged.

Passing an arbitrary EL2 memory pointer here will cause __kvm_adjust_pc()
to read and write flags directly at that address, giving the host an
arbitrary EL2 memory corruption primitive.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070719.8122=
27-1-tabba@google.com?part=3D6
