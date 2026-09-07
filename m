Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5600F503BE1
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788798734; cv=none; b=kcHZLHatoq2U//E9rTU79BAbTDSmreLFWWZIxfM5EK3F8G29KuI3yerXTdRtirsdU2jWFkgSy2z5jwgIiE8mDZL+QrrZBPjkyPkn2xvvUCUDtnFu7eTiYzvtRkQ6kT00CHoDJS0bZiXSoxvedRWKqib3Mxgn0TeLqU6bbP4A5Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788798734; c=relaxed/simple;
	bh=J3cpVqpiyKWs1GQp5auo36NbnnOFiJCMegyvZYC5U7c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pag1sMPEcg4ZJEMybKeLZcHFK8wUNu3k/WAoztG+lwETb+mrjMscPr4h9OtnsOTJW+eLNixHsTc94VBNIEmZJHMMImbUgHyFaq47cxoyXCZAh3ZXZXpvaXZ8KvRlohg/uzERiHavNqGW/6VRtw2S/ceHUkQKlDjiPqV4MSNVuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsCtz7zj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsCtz7zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018E31F00A3A;
	Mon,  7 Sep 2026 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798733;
	bh=F4o3MpSfJFbr3L379+Npu7y1XEXukleK7HbypayAIGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZsCtz7zjsYCSyqiEzxf2TDjdElANE95OU9xE2Tacms0+Du5H8RhA8264zZdNAtIzG
	 Wo3f5Nc4VJCIhq3dhrZQ852c3APnLuiqYuG7mUYdzqGc7gYUb24MDN7vwpxrR169lr
	 69FM6LmycTFl9eIRe11TEN3ZYBm3bXrrOpJ776imQyDBZpuoYI7FiRFNPVU1ZJxZEc
	 Ny8pYsaFRnRT9ZBOyWJiHVW1CjqCENqR8bCwy59hVtYR+F2ypD+pA64asIhYxQWnyz
	 gOlSTXULBhGa7HN/YNQ/bURqZKjmj/gDMDAo+lNu7zAeILdspE3+Ola394TQ9gk8ik
	 avozy5TfQIrTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 1/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260907162204.1479401-2-suzuki.poulose@arm.com>
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
 <20260907162204.1479401-2-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 16:32:12 +0000
Message-Id: <20260907163213.018E31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing untagged_addr() in do_gpf_ptw() causes show_pte() to fai=
l for tagged user addresses.
--

commit 33ff4ae42e692cd124830f34b7d3c5368fce252f
Author: Steven Price <steven.price@arm.com>

arm64: mm: Handle Granule Protection Faults (GPFs)

This commit introduces handlers for Granule Protection Faults (GPFs) which
occur when accessing memory delegated to a realm. It issues a kernel oops
for GPFs on page walks via do_gpf_ptw(), and sends a SIGBUS for non-page
walk faults. It also handles fixups for spurious kernel GPFs.

> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -910,6 +910,22 @@ static int do_tag_check_fault(unsigned long far, uns=
igned long esr,
>  	return 0;
>  }
> =20
> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_re=
gs *regs)
> +{
> +	const struct fault_info *inf =3D esr_to_fault_info(esr);
> +
> +	die_kernel_fault(inf->name, far, esr, regs);

[Severity: Medium]
Does this code miss untagging the address before passing it to the oops
handler?

If a GPF on a page table walk is triggered by a tagged user pointer, passing
the raw, tagged far value to die_kernel_fault() will prevent the page
table dump from showing up in the panic output.

In die_kernel_fault(), the address is passed to show_pte(addr). When
show_pte() checks is_ttbr0_addr(addr), the lingering memory tag in the
upper byte will cause the address to exceed TASK_SIZE. This makes
show_pte() abort with "address between user and kernel address ranges"
and return without dumping the PTE.

> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907162204.1479=
401-2-suzuki.poulose@arm.com?part=3D1
