Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C724A4156C5;
	Fri, 24 Jul 2026 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895000; cv=none; b=SSXP8NcaVRM5bZAZwnn/MgE6liEou3WGRzXqqePimi+fLzlG6wwkYGRoml6/9RFZ/Wti3aSqDBsBmPoEvPKeZmt4jlHERA/C8PHRBQPSX8xHohvaifVcWxfIM+48keapMsm+c5J482LlPIbT6zskp0qZOKbJBTNEOhkjyGw6BbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895000; c=relaxed/simple;
	bh=4hnCv5a7yujRovipHmss5AVHBlGQsHjGP8snxa2wYHA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WEZ0PvrYvOlx/jJeyVUa9QaTMDGQbrnddYC6TJRZUom31sC23z898q3HOv/7/F+lNEwtdE/N1cLkkcEQGSF8KxQAuQXdQ+hHWxtW8Aw5rcK0iUVwXYndidycX+W3cziAqk+qtZqCVGBbNvwuCJMmNZBKAarewqbEJV4hhIrGa0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/1ffrf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/1ffrf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D201F000E9;
	Fri, 24 Jul 2026 12:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784894996;
	bh=7/0moBx+fnKg7wL9fVdoDUbnhOITL+zlUzwdm5/trUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V/1ffrf0+5FgVSL1V99gLe6WdfyyhQrJ6a7xIuDbJKyumvvb/lBMk/bCyL2XyDOFh
	 F0cNE9b9wTRPRjcG6V4eDGeMiZxQls2G4N7w5RZlkk9RfWViXjN8XqMyyGQtjki0Bb
	 swmSUlaYwp7UwoppdH65VCk3nsGvIfAOdB75A6WZIS7zM/eaDNQmbPDnrt1X+lqIZO
	 pBoTb4hlzXK9NeI7WkJNnlW9LDo5N/+M7bmVj3KwzB65PlZ+o9aKh2NwWAz1Ie4kqZ
	 qNUfON1dUbel6axoGHOrIK1MYe4mxW6In/LVlnM+2r8HF3vACQZxI67Gut7mG3U4r7
	 FjRrtyVdgUiEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 31/48] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-32-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-32-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:09:55 +0000
Message-Id: <20260724120955.D9D201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Incorrect priority mask `ICC_PPI_PRIORITYR_PRIORITY_MASK` corrupts=
 GICv5 PPI priorities during save/restore.
- [High] Restoring the pending state of a level-triggered PPI overwrites th=
e hardware wire state (`line_level`) instead of the software latch (`pendin=
g_latch`).
--

--- Patch [31]: [PATCH v4 31/48] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg u=
serspace accessors ---
commit bdb3308b5e4c3913da8b93ef491dc97004fe3ff0
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors

Now that KVM is at the point where it is able to run meaningful VMs
with GICv5, it is important to be able to save/restore the GICv5 state
in order to allow for VM migration.

> diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-r=
eg-v5.c
> new file mode 100644
> index 0000000000000..6b255eacbf60d
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
> @@ -0,0 +1,519 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025, 2026 Arm Ltd.
> + */
> +
> +/*
> + * VGICv5 system registers handling functions for AArch64 mode
> + */
> +
> +#include <linux/irqchip/arm-gic-v5.h>
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/wordpart.h>
> +
> +#include <asm/kvm_emulate.h>
> +
> +#include "vgic/vgic.h"
> +#include "sys_regs.h"
> +
> +#define ICC_PPI_PRIORITYR_PRIORITY_MASK		REPEAT_BYTE(0x1f)

[Severity: High]
Does this mask correctly preserve the priority bits? GIC priority fields are
typically left-aligned in their 8-bit bytes (e.g., using bits [7:3], which
corresponds to a mask of 0xf8).

Applying REPEAT_BYTE(0x1f) later in set_gic_ppi_priorityr() appears to
isolate the bottom 5 bits (including the RAZ/WI bits [2:0]) and clear the
top valid priority bits, which could silently zero out the priorities when =
the
VMM restores the SYS_ICC_PPI_PRIORITYR<n>_EL1 registers during migration.

[ ... ]

> +static int set_gic_ppi_pendr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_desc *r, u64 val)
> +{
> +	int i, start, end, reg =3D r->Op2 % 2;
> +
> +	/* If we only support architected PPIs, return */
> +	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
> +		return 0;
> +
> +	/*
> +	 * Update each struct vgic_irq with the pending state, treating Level
> +	 * and Edge interrupts differently. The exposed PPI mask is applied
> +	 * later, when vgic_v5_finalize_ppi_state() runs on first entry to each
> +	 * vCPU. See comment on set_gic_ppi_enabler() for details.
> +	 */
> +	start =3D reg * 64;
> +	end =3D min(start + 64, VGIC_V5_NR_PRIVATE_IRQS);
> +	for (i =3D start; i < end; i++) {
> +		u32 intid =3D vgic_v5_make_ppi(i);
> +		struct vgic_irq *irq;
> +
> +		irq =3D vgic_get_vcpu_irq(vcpu, intid);
> +
> +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> +			bool level =3D !!(val & BIT_ULL(i - start));
> +
> +			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
> +				irq->line_level =3D level;

[Severity: High]
Could this corrupt the interrupt state during VM migration by writing to
the hardware wire state rather than the software pending latch?

The SYS_ICC_PPI_SPENDR<n>_EL1 restore from userspace represents the software
pending state. If we set irq->line_level here for level-triggered interrupt=
s,
it overwrites the ephemeral physical wire state (which gets re-evaluated by
backing hardware, like the arch timer) and the software-pended state would =
be
lost. Should this set irq->pending_latch for level interrupts as well?

> +			else
> +				irq->pending_latch =3D level;
> +		}
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D31
