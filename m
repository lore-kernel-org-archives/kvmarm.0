Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFF8544D73
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084297; cv=none; b=VfQchd6qL3/2wbDKaimMMCoq54aT89Mg9eecb3zD3t3awqXDm9bM/xDfgKzZ4SUZS0pznZprA209mRGpW+uGS84uRT/M/Ckc0E/toNvm6j96SG28f1SgKemZ+9PBHq1srydoscf9f0nogj6DUZcrQVosL4xICICPxRIrctUf+iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084297; c=relaxed/simple;
	bh=XJMwCrhKdI2OE2gCrCUozLldRa3InFzWdAv1r/YwVz8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bx9lGX40MwsyiDcLNNhL5gtnG2S8pDAYNgEsgbw/8I8Tbjl3sBiVkajE28muGxEUY5TkamFyh2xKSIJk0/ylC2zf9UFFT+ar4JGa0ePXyem+F+kj9mgubzERnk0W9PyM14C4ynthYAB6CRBacz1R+056lgLsY4umX3meLKcibfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPoCfMme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPoCfMme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C415D1F000FF;
	Tue, 22 Sep 2026 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084296;
	bh=Y/2ihmSMrHA9gD8biN7rdshYMphDwrowgO6qN8/sD+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lPoCfMmeYOYCABrp/J1LXk5a3ul0Lq11zz1gjk0QyvZRmz7fzyeCfUG1V16eEplTj
	 OfUgD95BoHLkzNmwl/Ynva3gUp8r8TwF2DO/aIuf1l4AgEviKjoq29ZGVR0J8TtzN2
	 UHeIQwj3Vj+X5W56H5SeBorJHSxQUXTCY1UV/Fh7SHWoqreP8PRyUlvQlq3Ns99T6O
	 FA6FxlKJ68WpxVd4Kf5//pvfvANXONk3Ny0FjIA1f98ypbGcL7D5i9B+V9rxHFuSIh
	 ui/0rhFhwv0fdq/k8XbwfhBHXEkEyrWeEOVYgp3eand42Mpx6QOp6tcLcqBGsdLbf/
	 G8r1lMLuxxX5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2
 page table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-23-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-23-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:38:15 +0000
Message-Id: <20260922133815.C415D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm-smmu-v3-kvm: panic on EL2 allocation failure during STE reshad=
ow
--

commit 866d2f52e473ce62e2402494a1198d807826d481
Author: Mostafa Saleh <smostafa@google.com>
Subject: iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table

The hypervisor calls back into the driver on every change to the host
stage-2 page table.
Mirror those changes into an identity mapped stage-2 for the SMMUv3,
That would be attached to all active SIDs.

[ ... ]

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 6e023e968ed3a..6f0ea3a4e48df 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c

[ ... ]

[Severity: High]
Can a routine allocation failure lead to a hypervisor panic here?

Looking at smmu_reshadow_ste() in drivers/iommu/arm/arm-smmu-v3/pkvm/arm-sm=
mu-v3.c,
the dynamic allocation can legitimately fail with -ENOMEM when the pool is
exhausted:

drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_reshadow_ste() {
	...
			l2table =3D pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
			if (!l2table)
				return -ENOMEM;
	...
}

This -ENOMEM error is mapped to a true return value in smmu_filter_command(=
):

drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_filter_command() {
	...
		ret =3D smmu_reshadow_ste(smmu, sid, leaf);
		hyp_spin_lock(&smmu->hw_lock);
		if (ret)
			return true;
	...
}

Which is then wrapped in a WARN_ON() in smmu_emulate_cmdq_insert():

drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_emulate_cmdq_insert()=
 {
	...
		skip =3D smmu_filter_command(smmu, cmd);
		if (WARN_ON(skip))
			continue;
	...
}

Does this WARN_ON() turn the -ENOMEM condition into a fatal hypervisor
panic?

At EL2, WARN_ON() expands to a fatal BRK instruction, crashing the hypervis=
or.
Host userspace processes can trigger this path (e.g., via VFIO device
assignment) by configuring multiple devices to exhaust the L2 table pool,
leading to a host-userspace-reachable panic.

Could this be updated to handle hyp_alloc_pages() failures without
triggering a fatal assertion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D22
