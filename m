Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C018B39D6FA;
	Thu, 15 Oct 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075336; cv=none; b=TjNd/xufhWQMuCjszLibyichxlV7U40BXt9mjQ5jqdm4y8QjhOq6XVvVgAwtiG/8WHqXsSniPNTMwUmyh5IqnPt6eLcRjSIn9tq4jKHaisFGY3LCGebIBqVDUcCyK/QUBWy3LULpxd7YPkRohBYr6S7OhaSqSgFe8Y+cLj/A/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075336; c=relaxed/simple;
	bh=9yPhT3nBNiXI62aiNZzajJCF3iBq4FqwltbEoPkfwH4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VwEcj4ininUoxDdlU9q8DlD/wsFhCogRO5A2DpF8tCciXv/MvN/GuFTAZJkQajSv4WeGYKvbWbbCyUy2dFbYHfdEKaHYP2zTPc5MUWw0QQXFkkLKln+qrANsvcUrunEIBBMbh4BffohKg0MCOX3sIsHV7JtnSLX1lBpAnb/I1G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amx0TyRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amx0TyRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A200D1F000C4;
	Thu, 15 Oct 2026 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075335;
	bh=1XfkwT+ZV0VIETFBhqQoIsh+jM+1mmZCyZY3kXlA31E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=amx0TyRsDXvPpzEgbMyksdzKwLUKX2R3Vxt8lJGxRneT6ScOrP1shWKeS2r+U0AOs
	 dZ/xD41GJhRV4EZxTiE+/FHctpJr9YsfCwCSxtfW0Ph7NDggM+LN9u8q7jz1L3PzbA
	 07jjS8rMVrhWh9q5vu7xTfTbm3HzoRQkMkrwuguJ1U1wnL/n3LRrDlXXo1QFKhgrDm
	 XoF8ReqeXrzKDhS2EDNYx9mUgpC5lGA+COezYlyh0UqiuxIU6a8jCtdaJuzWo8IHIh
	 zoS1/ECuwOZp0EnMT0HhO9KII6dbkG278xoAkjMLeCoUjl4B3JmywqMujrrr5Nv3n6
	 nUWQO124OaD/w==
Message-ID: <sashiko-outbox-172973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 02/15] misc/arm-cla: Add launch operation helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-3-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-3-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:42:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] misc/arm-cla: 1-second busy loop in atomic poll function stalls CPU
- [High] misc/arm-cla: 32-bit truncation of max_regidx breaks register acce=
ss unconditionally
--

commit 3a9a1e5f334e803060b4eaff6708691a049dc197
Author: Jean-Philippe Brucker <jpb@kernel.org>

misc/arm-cla: Add launch operation helpers

This commit introduces helpers for CLA commands that execute sequences on t=
he=20
local CPU, wait for hardware responses, and translate response codes into L=
inux=20
errors. It also implements accelerator reset and register read/write operat=
ions=20
built upon these helpers.

> diff --git a/drivers/misc/arm-cla/cla-ops.c b/drivers/misc/arm-cla/cla-op=
s.c
> new file mode 100644
> index 0000000000000..46026304a057a
> --- /dev/null
> +++ b/drivers/misc/arm-cla/cla-ops.c

[ ... ]

> +/**
> + * cla_op_wait_lresp - Wait for any LAUNCH op to complete.
> + * @dev: CLA device.
> + * @lresp: last LRESP value read.
> + *
> + * Return: 0 on success, -ETIMEDOUT in case of timeout.
> + */
> +int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp)
> +{
> +	return readq_relaxed_poll_timeout_atomic(dev->regs + CLA_REG_LRESP,
> +			*lresp, FIELD_GET(CLA_LRESP_PENDING, *lresp) =3D=3D 0,
> +			CLA_LRESP_DELAY_US, CLA_LRESP_TIMEOUT_US);
> +}

[Severity: High]
Does this atomic polling loop stall the CPU for up to 1 second?

The timeout here is CLA_LRESP_TIMEOUT_US (1,000,000 microseconds). Using the
_atomic variant of the poll macro will busy-wait without yielding the CPU.

Since the surrounding code in cla_wait_status_dmb() uses the sleepable
poll_timeout_us(), does this context permit sleeping? If so, using the
non-atomic readq_relaxed_poll_timeout() macro might prevent long scheduler
delays.

[ ... ]

> +/* regidx is unsigned long here to avoid overflow during calculations */
> +static int cla_op_access_reg(struct cla_dev *dev, u8 op,
> +			     enum cla_launch_data_mode data_mode,
> +			     unsigned int accid, unsigned long regidx,
> +			     size_t nregs, u64 *regs)
> +{
> +	int ret =3D -EINVAL;
> +	unsigned long max_regidx;
> +	struct cla_launch launch =3D {
> +		.op =3D op,
> +		.accid =3D accid,
> +		.data_mode =3D data_mode,
> +	};
> +
> +	switch (op) {
> +	case CLA_LAUNCH_OP_REGREAD:
> +	case CLA_LAUNCH_OP_REGWRITE:
> +		max_regidx =3D 0x100000000;

[Severity: High]
Will this unconditionally fail register accesses on 32-bit architectures?

The constant 0x100000000 requires 33 bits. When assigned to an unsigned long
on 32-bit platforms, it is implicitly truncated to 0.

> +		break;
> +	default:
> +		WARN_ON(1);
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(regidx + nregs > max_regidx))

Since max_regidx becomes 0 on 32-bit platforms, this bounds check evaluates
to regidx + nregs > 0, which is always true when nregs is greater than zero.

Should max_regidx and regidx both be explicitly typed as u64 to prevent this
truncation and correctly handle overflow calculations?

> +		return -EINVAL;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D2
