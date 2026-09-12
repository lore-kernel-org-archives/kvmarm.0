Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F75241F5D8;
	Sat, 12 Sep 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202820; cv=none; b=XTFIPKHo944iBiCAnrThtsaXD9qmsk3iBG37I8ie59S5YIRvAA9FksMoRUN9D0gJT7RA34ijo9KnNDNeWnVn4F0ClB5XgCwz1dNAQ65Zgw1xtWj3EQCg/2Nr+1gpEDX8qGp0HhgARDCk8/RN7CR2p4XywBlrUtbS4aCheqkc0Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202820; c=relaxed/simple;
	bh=sTq8Rc2QROig7M25ZlHfiK01v/jqoBUaNk0ckk5tBpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pe2OCkbitTGIGjbjxsYmynAlux+O+kJA+zYqQ8uN3Lo8r+9FJUEuVtumNwg9Vcaa8GLtAlPcJZXKsEDpHF2QiavyBzoz5sszt0dhGh2HjXvK3yBnjhi15lGftuCJqj4UuKlRHceb/48wHLB4BJ8UmtbjObOsTmE9qQksPJAtYrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMsBHYfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMsBHYfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655CF1F000FF;
	Sat, 12 Sep 2026 08:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789202814;
	bh=3n4MGuKhD5DagvGPwhrL7U/37xTyFYHRFfhgKG0O/0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MMsBHYfXlZDslF0fdZNhr6tGi1gJyYxP1qdJskShaYsdLcYe2bMbknpkY1VE38SNT
	 hwAV5uqHmtUBh5SxkvvFofRDlv2A2uN3EpAk2bCV/fBihn/kzWF46b/WznillWQNEt
	 0NK1PeVemh7/gW0gl/4SrviURfGFH80tNDl9LH6cpsAhXYiHXuOb5GVK2K6b3EIu6O
	 tL1arsmcBxg55IhZm0zhGim87H66/sncGiR3GYwo5/vTJ03aSFAbMTUwaTUUJTK0Fc
	 2w0bsnvaf6qsBWitacNBf/C7p8LxJVx3w5G7Y+lmydkWLFBUIFkuIC+I8JYKTaRNoz
	 S65XLU/8qjKmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260912083611.2513845-7-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 08:46:54 +0000
Message-Id: <20260912084654.655CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing forward-progress check on firmware-provided boundaries (`n=
ext`) can cause an infinite loop during boot or memory hotplug.
- [High] Sub-page or inverted memblock regions are incorrectly expanded to =
1GB blocks, resulting in out-of-bounds firmware queries that can falsely fa=
il RMI initialization.
--

commit 9d5a0191d0b2d820e7529339f354ee6f7cd2d469
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Ensure the RMM has GPT entries for memory

This patch adds checks during initialization and hotplug to ensure that the
firmware correctly tracks memory at fine granularity and manages L1 GPTs. If
the firmware expects the host to manage tracking or GPT memory, the RMM is
deactivated.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index ecc89e91d264d..583e1aca9b15a 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

[ ... ]

> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> +{
> +	while (start < end) {
> +		unsigned long ret, category, state, next;
> +
> +		ret =3D rmi_granule_tracking_get(start, end, &category, &state, &next);
> +		if (ret !=3D RMI_SUCCESS)
> +			return -ENOMEM;
> +
> +		if (state !=3D RMI_TRACKING_FINE ||
> +		    category !=3D RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx=
\n",
> +			       start, next);
> +			return -ENODEV;
> +		}
> +		start =3D next;
                ^^^^^^^^^^^^

[Severity: High]
Are we missing a forward-progress check here?

If a buggy or malicious firmware returns a next boundary where next <=3D st=
art,
this loop will never terminate, resulting in a permanent kernel hang during
boot or memory hotplug.

The pre-existing rmi_undelegate_range() handles this exact scenario with:

    if (WARN_ON(out_top <=3D phys))
        return -ENXIO;

Could we add a similar validation check here to verify next > start?

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * We do not support creating L1 GPTs yet. So, make sure that
> + * all the regions are managed by the firmware.
> + */
> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_=
t end)
> +{
> +	unsigned long l0gpt_sz;
> +	unsigned long next, par_state;
> +
> +	l0gpt_sz =3D 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +					  rmi_feat_reg(1)));
> +	start =3D ALIGN_DOWN(start, l0gpt_sz);
> +	end =3D ALIGN(end, l0gpt_sz);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this alignment expansion cause issues if the incoming range is inverte=
d?

As noted below in rmi_init_metadata(), if an inverted range (where
start > end) is passed in, this alignment expands it into a massive block.

For example, if start=3D0x2000 and end=3D0x1000, and l0gpt_sz is 1GB, this =
expands
to start=3D0 and end=3D1GB. The start < end loop condition then evaluates t=
o true,
and we end up querying the firmware for a 1GB block that might not be manag=
ed
by firmware, falsely failing initialization.

> +
> +	while (start < end) {
> +		long ret =3D rmi_gpt_info(start, end, &next, &par_state);
> +
> +		if (ret !=3D RMI_SUCCESS)
> +			return -ENOMEM;
> +
> +		if (par_state !=3D RMI_GPT_PAR_PLAT) {
> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> +				start, next);
> +			return -ENOMEM;
> +		}
> +		start =3D next;
                ^^^^^^^^^^^^

[Severity: High]
Similar to rmi_verify_memory_tracking(), is a forward-progress check
needed here to prevent an infinite loop if the firmware returns a boundary
where next <=3D start?

> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_prepare_memory(phys_addr_t start, phys_addr_t end)
> +{
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Should there be an if (start >=3D end) return 0; check here?

This would protect downstream logic and prevent empty or inverted regions f=
rom
reaching the alignment expansion in rmi_verify_gpt_firmware_managed().

> +	int ret;
> +
> +	ret =3D rmi_verify_memory_tracking(start, end);
> +	if (ret)
> +		return ret;
> +
> +	return rmi_verify_gpt_firmware_managed(start, end);
> +}
> +
> +static int rmi_init_metadata(void)
> +{
> +	phys_addr_t start, end;
> +	struct memblock_region *r;
> +
> +	for_each_mem_region(r) {
> +		int ret;
> +
> +		/* Firmware-reserved NOMAP regions are not usable system RAM */
> +		if (memblock_is_nomap(r))
> +			continue;
> +
> +		start =3D memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
> +		end =3D memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this calculate an inverted range (start > end) for unaligned memblock
regions smaller than a page?

memblock_region_memory_base_pfn() rounds up, while
memblock_region_memory_end_pfn() rounds down. For small, unaligned memory
regions, this yields start > end.

This inverted range then flows into rmi_prepare_memory() and gets
incorrectly expanded to a full 1GB block in
rmi_verify_gpt_firmware_managed(), leading to a fatal initialization failur=
e.

> +
> +		ret =3D rmi_prepare_memory(start, end);
> +		if (ret)
> +			return ret;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912083611.2513=
845-1-suzuki.poulose@arm.com?part=3D6
