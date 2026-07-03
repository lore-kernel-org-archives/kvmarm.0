Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA7357CE5
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073940; cv=none; b=pet4Ap4cbHjdY/C0lMNsxZOzaX6qDYfP1mezMko4JU3V6kQI9JWDpM0JrCua2u5GyXHqwyUAkgoI04P37f3LEVBmUcQV9MlMV8+ddYOMCrVDmtHIelYbqF5DlQrqU9KOPVpeCwQKL/eMyN9bSasulv/cRVbiklwHJQKxLWNn0bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073940; c=relaxed/simple;
	bh=DWukcGjrjeqQhAoiiO5A4ZyAVkId69llbWR8IylHa/g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QyK9m79aZ58VqJrbJFw/9QYE5Kbo5654Xv+J9Pw9NIxNk3Y5dRmzcaDbPVbdslUBRrcitV4WKkTbdUq79vhjz9lj94PR6/VF9/6f+5V43aWJAY1643bPSPGDuxsKykG/r4QPbsBU8M2frYmYplzJJri4rhdi07ydViTOvrA5ZA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VABvP+0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VABvP+0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D451F000E9;
	Fri,  3 Jul 2026 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073939;
	bh=I75o/74iarFoPITXxdQ+mosqxUNNMMo3r8shLTwsuoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VABvP+0J7P9qkRdVbbc3X4jztIyiX5iicleqpG9ToezPy5eklijw+38zQjIf7Rjj0
	 k8ZlmLnZuhhJESRFYJwBGSJ+4j13F9rEW8bBJh9308T0KvtkSz9oPe+nbF8k2baLnJ
	 fat7HErsuYPBLbYv+7dHcmJaysQLIvzglFMSiD6zbA/s2S/eP0mfk2LZ404y2kvGq3
	 rb9aJViMVdWcxp2cnoasFXnKPGujjX9UeHH1D8C4xV1m4V1vLIK+6rt1ggYvIYk8U/
	 2C+nC6l9iuzpkIJiSIkFqnzUgxM693pkzFzxUrK/oyIhwmvQpM9KQxzUPSvpzmAbUq
	 o+K160y4PQA6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/17] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703100135.2512312-8-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:18:57 +0000
Message-Id: <20260703101858.F3D451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The `_allint_clear()` and `_allint_set()` functions lack compiler =
memory barriers, allowing dangerous compiler reordering across NMI boundari=
es.
- [Low] The new `arch/arm64/include/asm/nmi.h` header uses macros from `<as=
m/sysreg.h>` but fails to include it, breaking self-containment.
--

commit f45a4a26dfbea0878dc6e4ccc4dcf5b6a158b356
Author: Mark Brown <broonie@kernel.org>

arm64/sysreg: Add definitions for immediate versions of MSR ALLINT

This commit adds system register definitions for immediate versions of
MSR ALLINT (SYS_ALLINT_CLR, SYS_ALLINT_SET). It also introduces a new
header, asm/nmi.h, with wrappers _allint_clear() and _allint_set() that
write to these registers using xzr.

Link: https://lore.kernel.org/r/20221112151708.175147-5-broonie@kernel.org

> diff --git a/arch/arm64/include/asm/nmi.h b/arch/arm64/include/asm/nmi.h
> new file mode 100644
> index 0000000000000..eb2c9a8350cc8
> --- /dev/null
> +++ b/arch/arm64/include/asm/nmi.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2022 ARM Ltd.
> + */
> +#ifndef __ASM_NMI_H
> +#define __ASM_NMI_H
> +
> +#ifdef CONFIG_ARM64_NMI

[Severity: Low]
Is a #include <asm/sysreg.h> directive missing in this new header?

It uses the __msr_s macro and SYS_ALLINT_CLR/SET definitions from sysreg.h.
Without the include, it might break self-containment if another file includ=
es
asm/nmi.h first.

> +static __always_inline void _allint_clear(void)
> +{
> +	asm volatile(__msr_s(SYS_ALLINT_CLR, "xzr"));

[Severity: High]
Does this inline assembly need a "memory" clobber?

Without a compiler memory barrier, the compiler might hoist or sink memory
accesses across the NMI masking/unmasking boundary. This could lead to data
corruption or kernel panics when protected data structures are accessed
concurrently.

> +}
> +
> +static __always_inline void _allint_set(void)
> +{
> +	asm volatile(__msr_s(SYS_ALLINT_SET, "xzr"));

[Severity: High]
Should this masking function also use a "memory" clobber to prevent compiler
reordering across the boundary?

> +}
> +#else
> +static __always_inline void _allint_clear(void) { }
> +static __always_inline void _allint_set(void) { }

[Severity: High]
Would it be safer for these fallback implementations to include a barrier()
call?

If they are used outside of strict architectural checks, an empty function
allows the compiler to reorder memory operations across where the NMI criti=
cal
section was intended.

> +#endif /* CONFIG_ARM64_NMI */
> +
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D7
