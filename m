Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27333BBFBB;
	Mon, 10 Aug 2026 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359281; cv=none; b=uZkZxo39yknAKhmDRSZXTnV0Ab9xxfo99XxIowZjWfRqyvJjkrJUDQWVK3QSs0miVX78+WQHzgL6XZ1gDac0zMQCDvxOsDQlH85B++NlP/i83GZszkogblyrgr4SdQTMksBq+TW8/aEHH824Sgj7vP4dhw3NlSjgTNe6hx0RBDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359281; c=relaxed/simple;
	bh=HmQEiUWqdb8tE5res2+4v2KxHygT2iwiNHb+G+irwlg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kVAbdIWGJCJlVVqsXUxG5V4HFV97Jvd9MYZ+Fwc224A0KzWE6sCVbfq9vHrRuh6PJxvN7GYWt2g6BixhrMKMV+TUNrqkB1Kv1vZmvUBajsjzNs4etYy2Wbkg0Ptgau9cj00rZECpCxmktWrrAku5TUsT48uAUwGaMUVQaLXOgt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5z6uQpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5z6uQpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CBA1F00A3A;
	Mon, 10 Aug 2026 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786359280;
	bh=ODMuINJTvxLQA0IqXuNhR10q/l9KsOTVInZ5yChRRP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P5z6uQpJnVJwDH7oI6u5RHdQrxBRbibNtkrt7RaVMo/4PRoXcxhaGqV84gppqbCVv
	 D1ENR/ZHsXCTNCyfphGqCN2yVGcjvGEkT4yoFAu+FYC350U6dxCMfTlvOVzWA2Ur4c
	 fba7rGX7fBdyHE6xgVZr3dsuWbjLmWfaLhvL/sg9nIt7HWTEh49WJKIZLYx9KPCbAj
	 qM2rfwOzD9jvx/x8jnamN+mXMQX4MCyJBVsCdshSmpbmyY4k3ldBQqL04Xidi5DK73
	 xN8Z4spBHQFAC/KW2k4FkpJIt9pfdKZYSL6DhOLX3PkLiM8mPUhwQK+F6/lWTMBNvb
	 nsOl5/GL1N/6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] irqchip/gic-v5: Synchronize CPU interface disable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260810102652.758719-4-sascha.bischoff@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
 <20260810102652.758719-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 10:54:39 +0000
Message-Id: <20260810105440.17CBA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it leaves critic=
al architectural violations unaddressed due to a misunderstanding of ARM64 =
requirements (as noted in the commit message). Missing mandatory `isb()` in=
structions immediately after writing to control-plane system registers (`IC=
C_*_EL1`). The ARM64 architecture subsystem guidelines mandate that every w=
rite to a control-plane system register MUST be followed by an `isb()` as t=
he very next instruction. The `isb()` synchronizes the local CPU pipeline; =
it does not wait for external interrupt delivery. The patch author explicit=
ly omitted an `isb()` after writing to `SYS_ICC_CR0_EL1` in `gicv5_cpu_enab=
le_interrupts()`, claiming 'interrupt delivery is asynchronous'. Furthermor=
e, there are preexisting violations across multiple functions (`gicv5_cpu_e=
nable_interrupts()`, `gicv5_ppi_priority_init()`, and `write_ppi_sysreg_s()=
`) where writes to `ICC_*_EL1` registers are batched with intervening instr=
uctions before an eventual `isb()`, or lack one entirely.
--

--- Patch [3]: [PATCH 3/5] irqchip/gic-v5: Synchronize CPU interface disabl=
e ---
commit 55c441d845df8718ca0aac7ff0ab6a4a351c19dc
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
irqchip/gic-v5: Synchronize CPU interface disable

This commit adds a missing ISB instruction after the ICC_CR0_EL1 write in
gicv5_cpu_disable_interrupts() to ensure interrupts are disabled before
the function returns.

Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D6

> Add an ISB after the ICC_CR0_EL1 write to ensure interrupts are
> disabled before the function returns. No corresponding ISB is added
> when enabling the interface, as interrupt delivery is asynchronous and
> there is no obvious benefit to waiting for it.

[Severity: High]
This isn't a bug introduced by this patch, but does omitting the ISB
leave the CPU pipeline in an undefined state?

The ARM64 architecture requires an isb() immediately after writing to
control-plane system registers like ICC_*_EL1 to synchronize the local CPU
pipeline, not just to wait for external interrupt delivery.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index e9d1795235a66..6a99c541b559b 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -983,6 +983,7 @@ static void gicv5_cpu_disable_interrupts(void)
> =20
>  	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
>  	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
> +	isb();
>  }
> =20
>  static void gicv5_cpu_enable_interrupts(void)

[Severity: High]
This is a pre-existing issue, but should gicv5_cpu_enable_interrupts()
and other related functions also be updated to include the mandatory isb()
instructions?

For example, in gicv5_cpu_enable_interrupts(), writes to registers like
SYS_ICC_PPI_ENABLER0_EL1 and SYS_ICC_CR0_EL1 lack an immediate isb()
after each write.

Similarly, are the batched writes in gicv5_ppi_priority_init() and the
state updates in write_ppi_sysreg_s() missing their required isb()
synchronizations before returning?=20

Placing a return instruction or intervening instructions before an isb()
can cause the CPU to observe undefined pipeline state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810102652.7587=
19-1-sascha.bischoff@arm.com?part=3D3
