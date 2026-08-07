Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DAF349CEE
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123704; cv=none; b=p5rbaLnkhOlj7kCVljIJthT/9R+vWIGkhf3iCHEfwaogAYLnZt4P6Of4C+RzNF4C8jF5tpGeXP7KRFG3MyFQYx+TRKrjUIUdXYfi7EqiRIuOyd+ZQXQJDg5TBKDR10gf88oLD8esg/BhuEANkAbuDQZ6ewjeLkJV4Qvvh7WHdv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123704; c=relaxed/simple;
	bh=5bPAfM3ZR8e7wil7OXD2ne+uR5E6qM386GZff/+5nsA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kOWa5G5SPgFex8EQ0OZn+z0M+W3K4WNzSJzolUjx4SYeheWHmryz2K6zy4sTiIJ7oCO+EUDoRTTQPTIq3oCDZf/QXd5MVMzWEEeF0h6qAHviaMu0Jx8R8k3aEkMf97ZwcGYF90+EhFkigH9H64J/RRcmJhCSpH3KBjQDZ1IYLhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZDuCpqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZDuCpqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789711F000E9;
	Fri,  7 Aug 2026 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123702;
	bh=D4hvicPM/xge9W5KsNLgniRDsIf+imBGtq+hYhyKL1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DZDuCpqXZPkST+scv/vwiPl2v6Myvj/kLvwHE8nsgeRZq6oiD5Q3sCUFCxjLgX9hT
	 TbDTKzPp8fHFmfI94/51gqGiPATbSECUsNtGv3TrW9z3VDi99xIvF2GqccsyV/UtmR
	 IVcbuvAxHyXjVdB9CxFhZsDgtxkQ0fj+c0vferiSA+b9elVEMRZ1IV5dXswWCru8nn
	 Mn3ZiQ/iV8/npTmDn9QbujCKrzk/eIt2HO58MpP9P7U+AftJ6GRw2v09ywphQdGngI
	 kBYErVXgZk/RzSh+OArKM48IjQfGf4h5yWFTlNDDPJvWHfat9f4mUQIMphNTBfbQSE
	 luTUwjsURIvXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/13] KVM: arm64: Prevent the host from specifying a
 different command queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260807164322.2970811-13-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-13-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:28:21 +0000
Message-Id: <20260807172822.789711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Malicious host can bypass ITS command sanitization by setting =
Page_Size to 64KB in GITS_CBASER, forcing the hardware to read unsanitized =
commands from host memory.
- [Critical] A malicious host can bypass ITS command sanitization by progra=
mming GITS_CBASER with Non-cacheable attributes, exploiting a flawed `needs=
_flush` calculation.

Pre-existing issues:
- [Critical] Missing interception of GITS_BASER registers allows a maliciou=
s host to direct hardware ITS tables to arbitrary physical memory, breaking=
 isolation.
- [High] Infinite loop and out-of-bounds memory unsharing in the error hand=
ling path of `pkvm_setup_its_shadow_cmdq` due to an unsigned integer underf=
low.
--

--- Patch [11]: [PATCH v2 11/13] KVM: arm64: Prevent the host from specifyi=
ng a different command queue ---
commit 3cac1c2e6af2a0edec0047b75fa76ac659338bc2
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Prevent the host from specifying a different command queue

This patch secures the command queue register (GITS_CBASER) from being
re-programmed by a malicious host to bypass command sanitization. It
restricts updates to the GITS_CBASER register while the ITS is enabled
or not in a quiescent state.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index b9b71aa18d48b..97cfa31d90d11 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -429,9 +429,41 @@ static void ctlr_write(struct pkvm_protected_reg *re=
gion, u64 offset, u64 value)
>  	writel_relaxed(value, its->base + GITS_CTLR);
>  }
> =20
> +static void cbaser_write(struct pkvm_protected_reg *region, u64 offset, =
u64 value)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	int num_pages;
> +	u64 ctlr;
> +
> +	ctlr =3D readl_relaxed(its->base + GITS_CTLR);
> +	if ((ctlr & GITS_CTLR_ENABLE) || !(ctlr & GITS_CTLR_QUIESCENT))
> +		return;
> +
> +	num_pages =3D its->host_state->cmdq_len / SZ_4K;
> +
> +	/* Don't let the host program a different command queue */
> +	value &=3D ~(GENMASK(7, 0) | GENMASK_ULL(51, 12));
> +	value |=3D (num_pages - 1) & GENMASK(7, 0);
> +	value |=3D __hyp_pa(its->cmd_original) & GENMASK_ULL(51, 12);

[Severity: Critical]
Does this masking logic allow the host to modify the Page_Size field?

By not clearing bits 9:8 (Page_Size) from the host's GITS_CBASER value,
could a malicious host pass a Page_Size of 64KB (0b10)?

According to the GICv3 architecture, when a 64KB page size is used, the
hardware treats bits 15:12 of the physical address as RES0, effectively
rounding down the base address to a 64KB boundary.

If the host donates a command queue buffer (cmd_original) that is 4KB-align=
ed
but not 64KB-aligned, the address truncation by the hardware would cause it
to fetch commands from an adjacent memory region still under host control,
bypassing the hypervisor's command sanitization entirely.

> +	its->needs_flush =3D (value & GITS_CBASER_SHAREABILITY_MASK) !=3D GITS_=
CBASER_InnerShareable;

[Severity: Critical]
Does this calculation safely account for cacheability attributes?

Since this only checks the Shareability mask (bits 11:10) of the raw host
value, could a malicious host request an Inner Cacheability of Non-cacheable
(0b000 in bits 61:59) while maintaining an InnerShareable state?

This would cause needs_flush to evaluate to false. If the hardware ITS
operates in Non-cacheable mode, it reads physical memory directly without
waiting for the hypervisor to flush the data cache.

A host could pre-seed the physical memory with malicious commands before
donating the page, forcing the hardware to execute those instead of the
sanitized commands.

> +
> +	writeq_relaxed(value, its->base + GITS_CBASER);
> +
> +	/* Restart the CMDQ to read from 0 */
> +	its->cmd_offset =3D 0;
> +	writeq_relaxed(0, its->base + GITS_CWRITER);
> +}

[ ... ]

>  static struct its_handler its_handlers[] =3D {
>  	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
>  	ITS_HANDLER(GITS_CTLR, sizeof(u32), ctlr_write, ctlr_read),
> +	ITS_HANDLER(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
>  	{},
>  };

[Severity: Critical]
This is a pre-existing issue, but does the omission of GITS_BASER from the
its_handlers array allow the host to bypass isolation?

Because GITS_BASER is missing here, any host writes to these registers fall
through to its_emulate_forward_req() and are directly written to the hardwa=
re
ITS.

Could a malicious host write an arbitrary physical address (such as hypervi=
sor
private memory or guest memory) into GITS_BASER?

When the host subsequently issues a MAPD command, the hardware ITS would
execute it using the maliciously programmed address, allowing the host to
overwrite arbitrary physical memory.


[Severity: High]
This isn't a bug introduced by this patch, but is there an unsigned integer
underflow in the error handling path of pkvm_setup_its_shadow_cmdq()?

Looking at unshare_cmd_host:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:pkvm_setup_its_shadow_cmdq() {
    ...
    unshare_cmd_host:
        if (i =3D=3D 0)
            return ret;

        for (i =3D i - 1; i >=3D 0; i--)
            __pkvm_host_unshare_hyp(start_pfn + i);
        return ret;
    ...
}

Since the loop variable i is declared as an unsigned 64-bit integer (u64 i),
the condition i >=3D 0 is always true.

When i reaches 0, the i-- decrement underflows it to 0xFFFFFFFFFFFFFFFF,
which would cause an infinite loop sequentially calling
__pkvm_host_unshare_hyp() with invalid out-of-bounds page frame numbers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D11
