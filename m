Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE384A2A53;
	Fri,  4 Sep 2026 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528453; cv=none; b=s1uIZkayU7JhqO3OVSDfCoApcixdUwEggRSb477hK05uH4eKAGMy5+4+eSr+Mw0+U5ToIsw1V/nJmnII94YFbd28JXpMQW7Pnno93l6A5/RhnVMoA3NMtgWf6kiIWXYq7To4K9iTQ3qBiekLf7GceGOH8iCyeIyufsRTh3YJ3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528453; c=relaxed/simple;
	bh=BrKH1slhTJcB7fwRxUk3N8h9tBfv2C8yJycpH/t1uFg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JpglW0UpuY15nB5iOId2tHzB/4bdMk+MeI/8BTmkcFVHmcdPOHlWtBnGoH84olXcwDn1xyrpoeqDH4YFM2W6UuSyP5/RzMIdJgKuOtIoS9mRkDH6IzyYO4EPkCggan/QunpBXwJCL4xAzRzPZ/Y0YESFjeQ7ebPvsDl94iTZaZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDyZIhqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDyZIhqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F7C1F00AC4;
	Fri,  4 Sep 2026 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788528451;
	bh=FZis4c6UEHZrhAYzuW4m8uTE8qNsZQwU/XB2IFp9ZnQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EDyZIhqx9OBmnMylwEdvZsfXkI+D/V+mVLhwMevDV3C6IoYze2ZW1MJmZQmASo/Sw
	 6LlsFQeBcHdCc/Q2/2WSvF0hn5eef3Ti94BNgnOGY+vocEu/ogC/15CrCY7kDum/X5
	 KcqhPRLlmhaLxkI/ENJwBZnjDVboaOds2Ph/lnOXPXhk40sRXpIs8iyYYyzkIuDtns
	 RTpN2cZ2BLs4WJ0bKnw5Gf1E0SbwqAuRW4GwdDSlUxhfBhRzE6T/DXG0SArUeJAJG1
	 tk6wbbrCDYMzbiCVoLiCcpS3v+UZL55kV8O09y4S+x1GyxcTlXfYqWx2m5K1RWUyH4
	 kqaSNbb+F0eSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-32-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-32-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:27:30 +0000
Message-Id: <20260904132731.40F7C1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incorrect priority mask for ICC_PPI_PRIORITYRx_EL1 registers (LSB-=
aligned instead of MSB-aligned).
--

commit 03cc6ad9380aa567c97ad187be2f0c81a5904007
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors

This commit adds functions to handle userspace reads and writes of the GICv5
EL1 system registers. This allows KVM to save and restore the GICv5 CPU
interface state to support VM migration. Userspace writes are translated
back into KVM's corresponding internal representation.

> diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-r=
eg-v5.c
> new file mode 100644
> index 0000000000000..6b255eacbf60d
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
> @@ -0,0 +1,519 @@
[ ... ]
> +#include "vgic/vgic.h"
> +#include "sys_regs.h"
> +
> +#define ICC_PPI_PRIORITYR_PRIORITY_MASK		REPEAT_BYTE(0x1f)
> +
> +static int set_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
[ ... ]
> +static int set_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
> +				 const struct sys_reg_desc *r, u64 val)
> +{
> +	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
> +	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
> +
> +	/* If we only support architected PPIs, return */
> +	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7)
> +		return 0;
> +
> +	val &=3D ICC_PPI_PRIORITYR_PRIORITY_MASK;

[Severity: High]
Does this apply the correct mask for the priority field?

The GIC architecture aligns priority values to the most significant bits
(MSBs) of the 8-bit priority field (for example, bits [7:3] for a 5-bit
priority). The macro ICC_PPI_PRIORITYR_PRIORITY_MASK is defined earlier in
this file as REPEAT_BYTE(0x1f), which preserves bits [4:0] and clears bits
[7:5] for each byte.

Since the actual priority bits are stored in the MSBs, clearing them during
set_gic_ppi_priorityr() would effectively zero out the restored guest
interrupt priorities when userspace restores the state during VM migration.
This could cause interrupt priority inversion and prevent ICC_PMR_EL1 maski=
ng
from working correctly.

> +
> +	/*
> +	 * Although priorities are not regularly synced back to the vgic_irq
> +	 * state, they are explicitly synced back here. This is to ensure that
> +	 * any pending PPIs are evaluated correctly when first running the guest
> +	 * after setting the state.
> +	 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D31
