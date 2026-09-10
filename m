Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535EC419318;
	Thu, 10 Sep 2026 10:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037899; cv=none; b=dMr3+7vOdckF48vrUJ/6wGRAPeyn/Km/fRp7qzw52atrjecZ1A5D7Qf3aedJglp1J8NN/iPP4furlJrUcRrVGwqRtI599qq9I3L4rIIvalA6vq728sCyTZ2b/eNXblhvCz04sYlx2BFUVk6yKK4iS5W39vvF2VffMR8wDhiErSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037899; c=relaxed/simple;
	bh=91rDR9zsO+SuOgJBwk89aAsDm4E6GmQ4MSXkzU+1u9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5QQLmIPSqc7dfYLpJK2RuuGnQQJjds3gZHuiuSIrKQfaGlLhMZox78RfFMlmchjl5QfHaXP9BL1aKaka0GkiW7PnETSAUVRg0jvKnopO8LAu33eUQkJT03Wdx9IZEroMyjjF5wiAkFLQgSiXQNZIR2toedPKmE66AashkhCBfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s3xof/3l; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s3xof/3l"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE88E1570;
	Thu, 10 Sep 2026 03:58:12 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05E0A3F7B4;
	Thu, 10 Sep 2026 03:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789037896; bh=91rDR9zsO+SuOgJBwk89aAsDm4E6GmQ4MSXkzU+1u9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3xof/3lO0clFlEtwO/+KTIdaO/9WRnLtjeBbF9b7k5vqNhccMM0kkRxJ7SkoyjCf
	 5YCQLTNyhIcLcdhIJ8xhowitXkCY3YVczcZ9Awd1iMenEEvVdu4RxlAhIGj2fQtsws
	 3BBttAdf/dJWz4600XOlSIrbWPGMHZ0T+R4Uf7rc=
Date: Thu, 10 Sep 2026 11:58:07 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1 2/3] arm64: sysreg: Add TCR_EL2 to sysreg
 infrastructure
Message-ID: <qzold5p6qgyawt4manlare7cuewlqik4i3vc5lrdidtzc6ac4v@ejf67iqd3nrj>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
 <20260909222015.3046432-3-weilin.chang@arm.com>
 <20260909223811.386071F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260909223811.386071F00893@smtp.kernel.org>

On Wed, Sep 09, 2026 at 10:38:10PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Declarative update to TCR_EL2 regenerates the TCR_EL2_RES1 aggregate mask which is consumed by C initialization, requiring confirmation of robustness to future value changes.
> --
> 
> commit 522a184d95be9c0f88cc6fb418668546ef83e3e4
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
>     arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
>     
>     Convert TCR_EL2 to the sysreg infrastructure with data extracted from
>     Registers.json of the BSD licenced AARCHMRS
>     (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).
> 
> > diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> > index 94bf065c8ac71..8d89f34580bac 100644
> > --- a/arch/arm64/tools/sysreg
> > +++ b/arch/arm64/tools/sysreg
> [ ... ]
> > +Sysreg	TCR_EL2		3	4	2	0	2
> [ ... ]
> > +Field	33	MTX
> > +Field	32	DS
> > +Res1	31
> > +Field	30	TCMA
> > +Field	29	TBID
> > +Field	28	HWU62
> > +Field	27	HWU61
> > +Field	26	HWU60
> > +Field	25	HWU59
> > +Field	24	HPD
> > +Res1	23
> > +Field	22	HD
> 
> [Severity: Medium]
> This isn't a bug, but this declarative update regenerates the TCR_EL2_RES1
> aggregate mask. Are the C initialization consumers of this mask robust to its
> value silently changing if a future .sysreg patch adds or removes a Res1 bit?
> 
> For example, the generated mask is OR'd into the initial EL2 register value:
> 
> arch/arm64/kvm/arm.c:cpu_prepare_hyp_mode() {
>     ...
>     tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
>     ...
> }
> 
> It is also used to initialize the guest emulation reset state in:
> 
> arch/arm64/kvm/sys_regs.c:sys_reg_descs[] = {
>     ...
>     EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
>     ...
> }
> 
> Because the generator's contract is to reflect global architectural truth, a
> future edit that reclassifies a bit as Res1 will silently change the value of
> TCR_EL2_RES1 without triggering a compiler or CI warning. Could you confirm
> that these consumers do not rely on the previous static semantic value of the
> mask?

I don't fully understand but doesn't this mean the architecture
introduced a change that breaks existing software?

Thanks,
Wei-Lin Chang

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260909222015.3046432-1-weilin.chang@arm.com?part=2
