Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DB3115BC
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 07:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295640; cv=none; b=gzq7GKjDLCuCJvjBvKa1I5fqfa9w2a+/XbXeP/b21OBGwGmzmnLshmjjTlOiVDKT6nloDETX4GTQZW74nDcmsFVzIyKrfsMcnoqXr1KiC+J7O1CdyjS5XG83BR/Ra7UGjk/Su7b9woKKF9cxckxI4geV6ZdK9Jm0EVi47AhaNko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295640; c=relaxed/simple;
	bh=viyBVnMufxlYh50Ib5lpI9NaBAKKagmLcVCt/NaeZ9c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j/tMiIH2GnhVH8wMrbYTIhgQXwbGEa39f//h4S0id0+NTKGmqI2UN2U254Dui1CySCj16kc+98M11H6mTed7h+vOFzsGitVxxzpHVK026/zGH//gJLGPiWHBsN7t6SxpzksHNwlqqFhOv+8skmWrFR5kSrMQFt8L1ngLUZRlnB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fawx3bri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fawx3bri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120B51F000E9;
	Fri, 21 Aug 2026 07:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787295639;
	bh=ArUMHYPEIA+xKEY0RaaruZqjwxNGl1gK68JM+gpnIrg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fawx3briueOyPvKedI0ioRvEjLguGA/lFarJOF1FJAWIfVvDUQSDioMXHeEEt1trB
	 2tECL+0oOvJy6l9MdgeqjKyxpvc/pV1Xh9LehHDUflABI2KweXCUNnvMt+ZzH24zbk
	 RZLiFu/JJIaN911GT2NTbFoIA9PuXlWruPchl5gjEu4WUAhiRlTxhF7Wb2Iwx0Uwc5
	 kW7cHjuDlUSuYI3S8w8X6dgBMZVLbg7lXxvNa0AEqhjDQsX7pc9nXmLkt35yPxgr0N
	 bjiemogR5YZOCAv1m7fZca37LUAgIBhfk7u3fzqwkf/ocbysrgB9vDJ5+gnmf+6E9Y
	 T4BYGlNxNBQ6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Add ITS table save tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260821064445.615838-5-fuad.tabba@linux.dev>
References: <20260821064445.615838-1-fuad.tabba@linux.dev>
 <20260821064445.615838-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 07:00:38 +0000
Message-Id: <20260821070039.120B51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Unsafe DMA Buffer Configuration (ITT Size Miscalculation)
- [Medium] Incorrect Endianness Conversion for L1 Device Table
--

--- Patch [4]: [PATCH v2 4/4] KVM: arm64: selftests: Add ITS table save tes=
ts ---
commit 00c3ff8ee303e906c6d0f346f17949dbb0abf5fc
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: selftests: Add ITS table save tests

This commit adds selftests for KVM_DEV_ARM_ITS_SAVE_TABLES to cover cases
where a guest alters tables. It tests handling of a GITS_BASER<coll> write
that changes the table, and a device whose L2 block the guest invalidated.
Each case is then reset and restored to verify the save functionality.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_save.c b/tools/te=
sting/selftests/kvm/arm64/vgic_its_save.c
> new file mode 100644
> index 0000000000000..864da01539f3f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
> @@ -0,0 +1,441 @@
[ ... ]
> +/*
> + * its_send_mapd_cmd() encodes ilog2(itt_size) - 1 as num_eventid_bits, =
and
> + * vgic_its_restore_itt() scans BIT_ULL(num_eventid_bits) * ESZ, so the =
size
> + * handed to MAPD has to match the ITT allocated for it.
> + */
> +#define ITT_EVENTID_BITS	13
> +#define ITT_MAPD_SIZE		BIT_ULL(ITT_EVENTID_BITS + 1)

[Severity: Medium]
Does this calculation configure the hardware with an ITT size of 128KB inst=
ead
of the intended 64KB?

The test calculates ITT_MAPD_SIZE as BIT_ULL(ITT_EVENTID_BITS + 1) (evaluat=
ing
to 16,384) to compensate for its_send_mapd_cmd() subtracting 1. However, KV=
M's
its_cmd_get_size() adds 1 back, resulting in 14 bits of event IDs.

During restore, KVM computes the scan size as BIT_ULL(14) * 8 =3D 128KB, ca=
using
it to read 64KB past the end of the allocated ITT memory.

> +#define ITT_SZ			(BIT_ULL(ITT_EVENTID_BITS) * ESZ)
[ ... ]
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
Will this fail on big-endian hosts? The L1 entries are being populated using
native CPU endianness.

Since the ARM GICv3 ITS architecture and KVM emulator require these tables =
to
be little-endian (using le64_to_cpu on read), shouldn't these use htole64()
when writing them?

> +
> +	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_A_ID,
> +			  test_data.itt_tables, ITT_MAPD_SIZE, true);
> +	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_B_ID,
> +			  test_data.itt_tables + ITT_SZ, ITT_MAPD_SIZE, true);

[Severity: Medium]
This isn't a separate bug, but as a result of the ITT_MAPD_SIZE miscalculat=
ion
above, doesn't this send MAPD commands configuring overlapping, out-of-boun=
ds
ITT tables for the two devices?

> +
> +	/*
> +	 * Drop the block holding device B. No ITS command and no GITS_BASER
> +	 * write is involved, so nothing tells KVM the device is now
> +	 * unreachable.
> +	 */
> +	l1[1] =3D 0;
> +
> +	GUEST_DONE();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821064445.6158=
38-1-fuad.tabba@linux.dev?part=3D4
