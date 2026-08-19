Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F5A3438B7
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 10:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135975; cv=none; b=hJEE9FzX2POu+yZe7rxw0FtCCT+mopS6TTK5aeaIsHTEHc/JUntdOIJd2cNzOiTo+SPf/eNnMdHCzzLoo1CEgeTg5zvASeXzZqlAriIAIzqUIS3e5CNVVQUee0qPLlDKFftEw3IpzKzewoREH4XPJ3piw2U8AeTu1Q9M2oFKsS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135975; c=relaxed/simple;
	bh=Oy+npDEG61OpT1Dk10aKP6iV7mIBqwJEf2Xpvd00MHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dg+7TtdGCHsU7E6tdHI7uRmAvWj7QyBwwxCFHOBzfF5j4r/jo7d2uj87dUKeUs0nCquh2wruWLKdkhAbaEDg7epDmnKwnnl9B4FF9mjZAh0sigNBI6/H7iNXmW3Oxr4rH2c75HGwb3N3vjOuYsDXfQ/emI8aYhYIlYTimfw/33A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeoPW1nX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeoPW1nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86671F00A3A;
	Wed, 19 Aug 2026 10:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787135974;
	bh=o0g376RMHoxEbu7eWSUDeEa9aO+bhuArQ/ErlZ5LT3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eeoPW1nX3EDA+olxlE+LJZVFq4VWUN7Up5mECD7UN0WK2Joi49Y6j6J19D9ZB+TsH
	 0jUQNiKa8PLMkY3stuZ1DtoxipsqF8pFKAI7LizdRbJZMwRVeaxgFJHUF8Pw0Ah9+q
	 qkSVCwYEnjQXVn+h0jPCaD69dhsLWCGcr2mNmOPV65/qreHGUqy0AC5wMtXqcgcGfG
	 eu3Uby57yY0zonWXhjw96mB437YhlNdb9sIsFumyQMYnPXlhRbLMUYGoqwcIvbJ9AN
	 WiW/IAOE5pVNDcjk7WS2xSxjdrCxyZ4uCAZfO0CTOPgyDqBSXQ3JHwLwImXix4IDV2
	 h0CzrqWAz7spQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] KVM: arm64: selftests: Add ITS table save tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260819102809.310708-5-fuad.tabba@linux.dev>
References: <20260819102809.310708-1-fuad.tabba@linux.dev>
 <20260819102809.310708-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 10:39:33 +0000
Message-Id: <20260819103933.C86671F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The guest code writes L1 device table entries using native endia=
nness instead of little-endian, which will cause corrupted data on big-endi=
an guests.
- [Medium] The guest code modifies GITS_BASER immediately after clearing GI=
TS_CTLR.Enable without polling for the GITS_CTLR.Quiescent bit.
--

--- Patch [4]: [PATCH 4/4] KVM: arm64: selftests: Add ITS table save tests =
---
commit 277abfaff8f849d670b2c74f45ab3607f657788b
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: selftests: Add ITS table save tests

This commit adds selftests for KVM_DEV_ARM_ITS_SAVE_TABLES to handle two
cases where a guest leaves a table in a modified state. It covers a
GITS_BASER write that drops described collections, and an invalidated L2
block that causes a device to be skipped.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_save.c b/tools/te=
sting/selftests/kvm/arm64/vgic_its_save.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/vgic_its_save.c

[ ... ]

> +static void guest_shrink_coll_table(void)
> +{
> +	unsigned long offset =3D its_baser_offset(GITS_BASER_TYPE_COLLECTION);
> +	u64 baser;
> +
> +	its_set_enable(false);
> +
> +	baser =3D readq_relaxed(GITS_BASE_GVA + offset);

[Severity: Medium]
Is it architecturally valid to read and modify GITS_BASER immediately after
clearing GITS_CTLR_ENABLE without first polling for the GITS_CTLR.Quiescent
bit?

While KVM's synchronous implementation might tolerate this sequence today,
could this missing poll cause unpredictability on asynchronous hardware or
future emulators?

> +	baser &=3D ~GITS_BASER_PAGES_MASK;
> +	writeq_relaxed(baser, GITS_BASE_GVA + offset);
> +}

[ ... ]

> +/* Turn the already installed device table into an indirect one. */
> +static void guest_make_device_table_indirect(void)
> +{
> +	unsigned long offset =3D its_baser_offset(GITS_BASER_TYPE_DEVICE);
> +	u64 baser;
> +
> +	its_set_enable(false);
> +
> +	baser =3D readq_relaxed(GITS_BASE_GVA + offset);

[Severity: Medium]
Similarly here in guest_make_device_table_indirect(), does this need a
poll for the Quiescent bit after disabling the ITS and before accessing
GITS_BASER?

> +	writeq_relaxed(baser | GITS_BASER_INDIRECT, GITS_BASE_GVA + offset);
> +
> +	its_set_enable(true);
> +}
> +
> +static void guest_unreachable_device(void)
> +{
> +	u64 *l1;

[ ... ]

> +	guest_make_device_table_indirect();
> +
> +	/* Both L2 blocks present, so both MAPDs are in range. */
> +	l1 =3D test_data.device_l1_va;
> +	l1[0] =3D L1E_VALID_MASK | (test_data.device_l2[0] & L1E_ADDR_MASK);
> +	l1[1] =3D L1E_VALID_MASK | (test_data.device_l2[1] & L1E_ADDR_MASK);

[Severity: Medium]
Since the host code later reads this memory using le64toh(), will writing
these L1 device table entries in native endianness cause data corruption
when running the selftest on big-endian guests?

Should these entries be converted using cpu_to_le64() before assignment?

> +
> +	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_A_ID,
> +			  test_data.itt_tables, ITT_MAPD_SIZE, true);
> +	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_B_ID,
> +			  test_data.itt_tables + ITT_SZ, ITT_MAPD_SIZE, true);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819102809.3107=
08-1-fuad.tabba@linux.dev?part=3D4
