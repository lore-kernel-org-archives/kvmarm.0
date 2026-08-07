Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FCF3A6F05
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122695; cv=none; b=LXv6cp+dU8UQG0RkgrTbbZL/UpsKWFHIreTCIzRGFfIdbHxvGOuR8o5q01wpwnSJtbz4UJQx0sROrWkCh+rGXhxGvyPTLSEgrlVx+mlAKY2APQ8QjvbOxniXSrDPgCKq+J7lb4ciaVU0C9NxUGFupLaknXSrdGNUZdVSgkKGjS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122695; c=relaxed/simple;
	bh=lwFA32oMuza/tu9hFDZFS7sbm5Lt8Sd2BLDVSji8r8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=acIRIFgSSBoiGPvnRRpk/w2eWJg58vww08H+dztVWyGzjQ7Ick2AAwW4TeD3Oe8oY9eUg+mNDS+AB3+42kqbekgAlK+w5BMEB8AlhbkvY2Bg1gudHxSlnTSj3aCa1Q93k6Ix9plAZ+Hcf4wUsL0K+Dd6aW/wCjQsMTyxJsozDF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQcOo5wp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQcOo5wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364CC1F00A3A;
	Fri,  7 Aug 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122693;
	bh=Svq42rDYi9/7g4bm4zrwBrzYToRFtiYY237avxVOgGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gQcOo5wpxXeiqqogKd6LOxgKGbQNBww+JUDgnOAJlkSTptxLYfz0Ozvnpo5MLu1WM
	 zeS041tcOcnV63o7oLqFHDCC3H3I90DSayX0zgmWhkpG6f+p1ofL9jsGzFtCvaA3e4
	 0MECcqTWO86sEJn4hdjUR+emJWcnrW5yvFoqnMXpySL7honXnGKEmspjoLJSOvu3Sq
	 6US4jc3DqzoDnUcE9iQowx0b5aNngfbT3hNzvPeDQGCkERbKcPHf6dNdprNxlF1TjN
	 xynAUddjfc9DWLuHdwaZf90TyDJRGgL42C3rJW+ym8oS7YeBDk1W10pkSc9Y9Foyrk
	 iehQE0+Bm0Hyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/13] KVM: arm64: Prevent the host from programming
 new GITS_BASER tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260807164322.2970811-14-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-14-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:11:32 +0000
Message-Id: <20260807171133.364CC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Sub-word (32-bit) MMIO writes to 64-bit ITS registers cause hy=
pervisor crashes (Alignment Fault) and silent state corruption.
- [Critical] Incomplete attribute masking in baser_write and cbaser_write a=
llows the host to alter ITS table Cacheability and Shareability.
- [Critical] The host can activate unvalidated ITS tables by toggling the G=
ITS_BASER Valid bit (bit 63).
- [High] Incomplete physical address masking in baser_write on 52-bit PA sy=
stems (FEAT_LPA) allows physical address hijacking.
--

--- Patch [12]: [PATCH v2 12/13] KVM: arm64: Prevent the host from programm=
ing new GITS_BASER tables ---
commit ceb5f9bba1bc25bf01683842fe6461183f94c200
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Prevent the host from programming new GITS_BASER tables

Don't allow the host to change the layout of the tables or to modify the
address programmed in the GITS_BASER registers to point to new tables
and bypass the sanitization.
Prevent the host from updating the ITS tables while the ITS is enabled
and the tables are set to prevent undefined behavior.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c

[ ... ]

> @@ -460,10 +465,42 @@ static void cbaser_read(struct pkvm_protected_reg *=
region, u64 offset, u64 *read
>  	*read =3D readq_relaxed(its->base + GITS_CBASER);
>  }
> =20
> +static void baser_write(struct pkvm_protected_reg *region, u64 offset, u=
64 value)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	u32 ctlr =3D readl_relaxed(its->base + GITS_CTLR);
> +	int baser_idx;
> +	u64 baser;
> +
> +	if ((ctlr & GITS_CTLR_ENABLE) || !(ctlr & GITS_CTLR_QUIESCENT))
> +		return;
> +
> +	baser_idx =3D (offset - GITS_BASER) >> 3;
> +	baser =3D its->host_state->tables[baser_idx].val;
> +
> +	/* Prevent if it tries to change from direct layout to indirect layout =
*/
> +	if ((value & GITS_BASER_INDIRECT) !=3D (baser & GITS_BASER_INDIRECT))
> +		return;
> +
> +	/* Don't allow the host to point to new tables or new attributes */
> +	value &=3D ~(GENMASK_ULL(47, 12) | GENMASK_ULL(9, 0));
> +	value |=3D (baser & GENMASK_ULL(47, 12)) | (baser & GENMASK_ULL(9, 0));

[Severity: Critical]
Does this mask correctly restrict the cacheability and shareability attribu=
tes?

The mask only clears bits 47:12 and 9:0, which leaves Cacheability
(bits 61:53) and Shareability (bits 11:10) unmasked. This allows the host
to force the ITS hardware to bypass caches while EL2 accesses the same
memory via Cacheable mappings, potentially compromising memory coherency
and EL2 isolation.

The cbaser_write() function similarly fails to mask Cacheability and
Shareability attributes for the command queue base register.

[Severity: High]
Can this mask allow the host to hijack the physical address on 52-bit PA
systems?

For systems with FEAT_LPA, PA[51:48] are stored in bits 51:48 of GITS_BASER.
Since the mask only covers up to bit 47, the host can supply arbitrary
values in bits 51:48. This would redirect the ITS table physical address
by multiples of 256TB to untracked memory, bypassing pKVM stage-2 tracking.

[Severity: Critical]
Could this allow the host to activate unvalidated ITS tables by toggling the
Valid bit (bit 63)?

Because bit 63 is unmasked, a malicious host could boot with a fabricated PA
and VALID =3D 0, skipping KVM's validation and memory donation. If the host
subsequently writes to GITS_BASER with VALID =3D 1, this mask restores the
fabricated PA and writes VALID =3D 1 to the hardware, granting the ITS
hardware DMA access to arbitrary physical addresses.

> +
> +	writeq_relaxed(value, its->base + offset);

[Severity: Critical]
Could a 32-bit MMIO write to a 64-bit ITS register cause a hypervisor crash
or state corruption here?

Looking at pkvm_its_emulate_handler() in this file, it permits sub-word
accesses to 64-bit registers:

    if (reg_handler->access_size < reg_size)
            return;

If a host issues a 32-bit write to an unaligned offset (e.g.,
GITS_BASER + 4), this writeq_relaxed() will perform a 64-bit device memory
access at an unaligned address, triggering an Alignment Fault at EL2. Even
if aligned, writing a 32-bit payload via a 64-bit writeq_relaxed() will
overwrite the upper 32 bits of the hardware register with zeros, wiping
critical fields.

Should the payload be adapted for a read-modify-write, or alignment
enforced? The cbaser_write() function appears to share this same behavior.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D12
