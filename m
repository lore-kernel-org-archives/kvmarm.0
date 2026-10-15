Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE84849E139;
	Thu, 15 Oct 2026 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074921; cv=none; b=byowsYxpwY6E4pLrp3QbPjkGtipv/Fw0wH8UIIteJN+HhzxWhgBlB8wo+2/bbnhHkekwquPTJUAO+l6Jhv2xSR4M4EnhLqqCEk+5M7VoC26OjXSQGjXRwthBlAe1nJbdnek3kHF8Q6+iAaE9IRS86H5Fw9XhW+toeL2u4pVDdWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074921; c=relaxed/simple;
	bh=zFbkRObKH/fCMm8g7ueKx/Uc4eaRxeM5HU/FTy/Fysk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SaU8eEvrzown3nerMheeAw/oH6OlSG+sQsdp3Xn/7VVhUDXptltUHfSt/nnBg6uRtxrwC3YHc1ultkS3q0s8azdocy7EaTlfcNJBN1EhASMpyafc384ZLUwiqox2I3Avp25zIGS7HTHsk7Vo/5/sxUTVS4jWx3K4YUoSRmrh01w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjzGSMbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjzGSMbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114351F000C4;
	Thu, 15 Oct 2026 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792074920;
	bh=jK78+sdXkAYkVIFvDJ166BEtBLJyB5I14yIVxhQVhEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hjzGSMbffRqHGzc6eA+RBY48b7aYLLm0QoBL9rMZhyFGE+9pAexNtGaXvL5tXYVPL
	 sRLSOQoWWj3FMHDOC5SixoXciBTrCfURThF6GsP6zbmU6HQ1fHDhbp5cC1fNeAlBWt
	 tQGeneAGmUcd8KNEwGEvY7S1CxQsfQWxqX1SIQrkQz/oEyrP8dTNS2+MM/GLF9guQo
	 D7JAN2Raw/in5VgGdYKU3Y2cg/47woQu2B3zcFSssdzYmxMmJ4FOdNqi6wXPdgnhv6
	 Ykvk/XgWnY+xBN4lZoZPHKDTHHv3NRfyI8F7WR93EYoNsfgiJ0zXhpu96IqCKiU/qb
	 s5hx/EU3gXk2g==
Message-ID: <sashiko-outbox-172965@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 01/15] misc/arm-cla: Add driver skeleton and
 documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-2-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-2-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:35:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] macro: multiple evaluation of macro argument _dev
--

commit eeea2acb1fe471c02eee65ef8f991f70efeb7b69
Author: Jean-Philippe Brucker <jpb@kernel.org>

misc/arm-cla: Add driver skeleton and documentation

This commit introduces the initial driver skeleton and documentation for
the Arm Core Local Accelerator (CLA). It adds the required Kconfig, Makefil=
e,
register definitions, and a common driver header.

> diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cl=
a.h
> new file mode 100644
> index 0000000000000..1e8ffca28bc6e
> --- /dev/null
> +++ b/drivers/misc/arm-cla/arm-cla.h
[ ... ]
> +struct cla_dev {
> +	unsigned int cpu;
> +	struct device *dev;
> +};
> +
> +#define cla_dbg(_dev, fmt, ...) \
> +	dev_dbg((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
> +#define cla_info(_dev, fmt, ...) \
> +	dev_info((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
> +#define cla_err(_dev, fmt, ...) \
> +	dev_err((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)

[Severity: Low]
The _dev macro parameter is evaluated twice here. Could this lead to
unintended duplicate execution if a caller passes an expression with
side-effects, such as get_device(dev++)?

Would it be safer to rewrite these as static inline functions, or use a
statement expression with a local variable to evaluate _dev only once?

> +
> +#endif /* _ARM_CLA_H_ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D1
