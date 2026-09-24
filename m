Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7593437B01F;
	Thu, 24 Sep 2026 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258423; cv=none; b=bZlrKLIlzV4/4q5LqDlEFV9N/fKQ/aOu4xFD2TkFneQ0gKSnM1yRA2SS48rBfpuuqP2vIhzmLazzSLDWc+aB4lZZLcQ0sar+rpCJnONiPfA4oThh5GpvDktkGTd0Tmp3YsHkFkuU4xHrOOAxscJOii84T0BxLCEz7AyK3SguLUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258423; c=relaxed/simple;
	bh=N0CgHWvT4CqQPTe1I7MycN0e+Vt9fWvmF43IiK8ENrE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dir3KIQzO2fbdDRrbMobsK23n3dmD3za1I+CKzHBujlN7k6KVlkT2kJLd9Ma25tYAzOsckF3ashec7VpqbPuwxx/PfRAtjIWZHjXCcjPJOn29FQxK+Miv+Nd/xxq6ktwC5rneyntlkHl2VG73wjJKmMQTucOgKcTnq1BaF1B4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0lgVTDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0lgVTDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92941F000FF;
	Thu, 24 Sep 2026 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790258422;
	bh=UH2eDW/zv6+OGh6316gRX/ezBMuyptHoi+ba7gVS1+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S0lgVTDelu7OjhYFNUBBsutPDgtyRFC4FazuAO1SIPiSXD28togPOg3VIrZdDau/5
	 nCatuHDR7n1KbRbOBzd2MayAHAknNewia4w7VFhpX4gVeL55MBEvcvmSEYpAuR013W
	 Kt/v/4HkIXBSloJnd9qSXZUlrtt40j1znsw/HNRK7Popvy+IiGytQDd6H0Bka53zpa
	 Cjwm5DKnDIuV9LjpNOrbVzaHQi82Th/inCbtG57lCoBeuCdQoYAm8L675+7fDZ/YBI
	 YDkSsN+bF97AbNEyB2BQS2j2P9HsCNe8PO9XvO+SzpLFrj2S26kcSrIarkouVgotZD
	 C6E4zRya2qKvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at
 init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260924135201.850038-3-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-3-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 14:00:21 +0000
Message-Id: <20260924140021.C92941F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm_rmm: Infinite loop on RMI_BUSY in rmi_smccc_invoke()
- [Low] arm_rmm: Mismatch between RmiFeatureRegister comment and cache arra=
y size
--

commit 60040821cdd521215265aeca5b99bd6299a20114
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Check for RMI support at init

This commit introduces basic RMI support detection and initialization.
It queries the RMI version and reads the initial feature registers
to expose them for later use.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> new file mode 100644
> index 0000000000000..3baba931f92e4
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + */
> +
> +#include <linux/cpufeature.h>
> +#include <linux/memblock.h>
> +#include <linux/arm-rmi-cmds.h>
> +#include <linux/slab.h>
> +
> +#include <asm/memory.h>
> +#include <asm/pgtable-hwdef.h>
> +
> +/* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
> +static unsigned long rmi_feat_reg_cache[5] __ro_after_init;

[Severity: Low]
Is the size of this array correct? The comment mentions registers 0 to 5,
which would require 6 elements.

When arm64_init_rmi() calls rmi_read_features(), it iterates up to
ARRAY_SIZE(rmi_feat_reg_cache) which is 5, silently ignoring the 6th
register during initialization. Any attempt to read index 5 via
rmi_feat_reg() will hit a WARN_ON and return 0.

[ ... ]

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> new file mode 100644
> index 0000000000000..5c6c563c81555
> --- /dev/null
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -0,0 +1,48 @@

[ ... ]

> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args =3D *regs;
> +	long status;
> +	int i =3D 0;
> +
> +	while (i < RMM_BLOCKED_RETRY_COUNT) {
> +		arm_smccc_1_2_invoke(&args, regs);
> +
> +		status =3D RMI_RESULT_STATUS(regs->a0);
> +		if (status !=3D RMI_BUSY && status !=3D RMI_BLOCKED)
> +			break;
> +		if (status =3D=3D RMI_BLOCKED)
> +			i++;
> +		cpu_relax();
> +	}

[Severity: High]
Can this loop run infinitely if the firmware continuously returns RMI_BUSY?

If RMM returns RMI_BUSY, the loop continues without incrementing the counter
i. While the retry count bounds RMI_BLOCKED, RMI_BUSY appears completely
unbounded. This could lead to a soft lockup and freeze the host CPU.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924135201.8500=
38-1-suzuki.poulose@arm.com?part=3D2
