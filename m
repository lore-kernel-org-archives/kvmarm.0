Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4D437B022;
	Thu, 15 Oct 2026 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075304; cv=none; b=QB40Fowh4kbiegwP9tLrxAlWS9sTb1rPBtlSQnpC1CQdtSiDaINdHCy4iT1UkRGbFRrpSzCS1N6fVEcV0QOkpiERswKB/8z41Qyu9yKFhBOgQkCuSw3l3tocwL0NCvXYf8oA71cdkxbf5lFwUr1p4hqZY8pqBZW4OMWJNOSlLh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075304; c=relaxed/simple;
	bh=f8AzQmrWprzBPHAgl0yk30SUI5vnSOewo9zJ2W7uyg8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=S6n3/yLgs+Dnpp38cAwYT2cxhXSFtfJJY0+VCD9uAEaHTzUdAwr8cCw7QEogf+DXprOL3vDfOwyDH90LYkHMYCT5UxsFZ6G+TdyzYRgWq4DC94RCNPG0IKdulIPb/a7vfLerTjDOdu2JTztwO3jMxy5d7MsNca0Zj2Altxkxtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5IyUW0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5IyUW0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D761F000C4;
	Thu, 15 Oct 2026 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075303;
	bh=+kqI9L/9ctD2NK6q2Ru9phtpBLvNfgJg6s/BMhF22XY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d5IyUW0jJ6PjZnI6j0LpyGQxn33QfKiLP6rIMxnnpEvl/BSKc/TgY8c/0M0WVibrW
	 WxX5O9aHcGH0/RumIowBi5muvdXkEsKp79a6c1Twacea40HcPmM3u5g3BYPv4LAb9K
	 c/bITBMAEL2KehAsz8fKO1m4tcwDQ1Keku2CGJFmRsX4UPDS1lay1xJC0ZCDUz1vBf
	 KQz1TEzlU/J+YYyCcArrXDv5yzS2rS9e1GQQCwh91p47sgIQRy6COQA8fsSfpsWLnM
	 49BhZ27EYI+S7lURgZcaGSKOd0l6fazraRr/55pOxWEpoCubB/tHrq1DAA10cocCf8
	 Bb1Kc4llFH7VQ==
Message-ID: <sashiko-outbox-172972@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/15] misc/arm-cla: Accelerator context save and
 restore
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-7-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-7-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:41:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] misc: arm-cla: max_regidx truncated to 0 on 32-bit architectures
- [High] misc: arm-cla: partially overwritten context state left valid on e=
rror
- [High] misc: arm-cla: NULL pointer dereference in cla_ctx_free_regs()
- [High] misc: arm-cla: ctx->regs indexed by ctx_id instead of device index
--

commit 3663e5cba865127a89c5cdad88c78f8b24a13ae0
Author: Jean-Philippe Brucker <jpb@kernel.org>

misc/arm-cla: Accelerator context save and restore

Add helpers to save and restore CLA context for later domain switching.
The saved state includes DATA registers, LRESP, per-accelerator SRSTATE
and any implementation-defined internal accelerator state exposed
through the IAS register window.

> diff --git a/drivers/misc/arm-cla/cla-regs.c b/drivers/misc/arm-cla/cla-r=
egs.c
> new file mode 100644
> index 0000000000000..2452a7601990f
> --- /dev/null
> +++ b/drivers/misc/arm-cla/cla-regs.c

[ ... ]

> +static int cla_regs_save_accel(struct cla_dev *dev, unsigned int accid,
> +			       struct cla_regs_pl0 *regs, size_t *regstate_off)
> +{

[ ... ]

> +	if (regstate_size) {
> +		ret =3D cla_op_regread(dev, accid, CLA_REG_IASn, regstate_size,
> +				     regs->regstate + *regstate_off);

[Severity: High]
Does this code unconditionally fail on 32-bit architectures?

cla_op_regread() calls cla_op_access_reg(). In that function:

drivers/misc/arm-cla/cla-ops.c:cla_op_access_reg() {
	...
	unsigned long max_regidx;
	...
	case CLA_LAUNCH_OP_REGREAD:
	case CLA_LAUNCH_OP_REGWRITE:
		max_regidx =3D 0x100000000;
		break;
	...
	if (WARN_ON(regidx + nregs > max_regidx))
		return -EINVAL;
}

max_regidx is declared as an unsigned long and assigned the 33-bit constant
0x100000000. On 32-bit platforms, unsigned long is 32 bits wide, so the
assignment silently truncates the value to 0.

With max_regidx being 0, the bounds check regidx + nregs > 0 is
unconditionally true since nregs must be greater than zero. This causes
cla_op_access_reg() to unconditionally fail with -EINVAL, completely breaki=
ng
the newly added context save and restore features here.

> +		if (ret) {
> +			cla_err(dev, "failed to save regstate: %d\n", ret);
> +			return ret;
> +		}
> +	}

[ ... ]

> +static int cla_regs_uninstall_pl0(struct cla_dev *dev, struct cla_ctx *c=
tx,
> +				  unsigned int ctx_id)
> +{
> +	int i;
> +	int ret;
> +	unsigned int accid;
> +	size_t regstate_off =3D 0;
> +	struct cla_regs_pl0 *regs =3D ctx->regs[ctx_id];

[Severity: High]
Does this code index the ctx->regs array with the wrong identifier?

cla_ctx_alloc_regs() allocates ctx->regs as an array of size domain->nr_dev=
s,
where each element index corresponds directly to a specific device in the
domain (domain->devs[i]).

However, this uses ctx_id to index the array. ctx_id represents the logical
context number within the domain, not the hardware device index.

If a user allocates more contexts than the number of hardware devices
(ctx_id >=3D domain->nr_devs), this causes an immediate out-of-bounds array
access. Even if ctx_id is within bounds, using it instead of the device ind=
ex
results in reading and writing state to the wrong device's register array.

> +
> +	/*
> +	 * When we interrupt the user process in the middle of launching a
> +	 * command, we have to wait for LRESP_PENDING to clear before we can
> +	 * launch a new command or save the DATA registers.
> +	 */
> +	ret =3D cla_op_wait_lresp(dev, &regs->lresp);
> +	if (ret)
> +		return ret;
> +
> +	for (i =3D 0; i < CLA_NUM_DATA_REGS; i++)
> +		regs->data[i] =3D cla_reg_read(dev, CLA_REG_DATA(i));
> +
> +	cla_for_each_accid(dev, accid) {
> +		ret =3D cla_regs_save_accel(dev, accid, regs, &regstate_off);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	regs->accel_valid =3D true;

[Severity: High]
Does this leave a partially overwritten context state marked as valid on er=
ror?

If cla_regs_save_accel() fails for an accelerator (e.g., due to a hardware
timeout), the function returns the error immediately. Because
regs->accel_valid is not cleared to false at the start of the function, it
retains its prior value.

If the context was previously successfully saved (regs->accel_valid =3D=3D =
true),
it remains marked as valid, despite the buffer now holding a torn,
inconsistent mix of old state and newly overwritten partial data.

On the next context switch, cla_regs_install_pl0() will see
accel_valid =3D=3D true and silently restore this corrupted partial state i=
nto the
hardware, leading to unpredictable hardware behavior and data corruption.

> +
> +	/*
> +	 * "If the accelerator is non idle when ENTERSR is launched, then a

[ ... ]

> +static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
> +				unsigned int ctx_id)
> +{
> +	int i;
> +	int ret;
> +	unsigned int accid;
> +	size_t regstate_off =3D 0;
> +	struct cla_regs_pl0 *regs =3D ctx->regs[ctx_id];

[Severity: High]
As with cla_regs_uninstall_pl0() above, does this code also index the
ctx->regs array with the wrong identifier?

Using ctx_id instead of the device index will cause an out-of-bounds array
access or access the wrong device's register array.

> +
> +	cla_for_each_accid(dev, accid) {

[ ... ]

> +void cla_ctx_free_regs(struct cla_domain *domain, struct cla_ctx *ctx)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < domain->nr_devs; i++)
> +		kvfree(ctx->regs[i]);

[Severity: High]
Can this code cause a NULL pointer dereference?

In cla_ctx_alloc_regs(), if the initial memory allocation for regs_ptrs fai=
ls,
the function returns -ENOMEM without assigning a value to ctx->regs. Assumi=
ng
ctx was zero-initialized by the caller, ctx->regs remains NULL.

When the caller handles this failure by invoking this common teardown path,=
 it
iterates and unconditionally executes kvfree(ctx->regs[i]). Since ctx->regs=
 is
NULL, array indexing results in a NULL pointer dereference.

> +	kfree(ctx->regs);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D6
