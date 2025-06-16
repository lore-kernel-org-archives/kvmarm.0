Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF88277C98;
	Mon, 16 Jun 2025 10:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750070478; cv=none; b=N3o6jGiaN9eQa5udAVcg4rRoBogjuAv4zvYJF/Kg3GeDSIdBrzjdSmDa8QHpagqgFccjtbr6163W0K1xxCBM/LMdbnra8Yf+nXdG3u1xYnrfDC25lzHUBNwSnt3777MveS6ynnhJAj5+P5fCv1Vu+in1RDJQSZqXy5KrMOxKpBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750070478; c=relaxed/simple;
	bh=pg18VEj3ZOXpTjNRyCe0pJvFJwwasJGT6wPYPZGNhSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWuLPdJZnO6vme+vLIbBPQE9rv8KFq+M5Z/GUcPeOqHUoxF0EFwmyctn7mio3o2e+odo6WuKCpt/68DuRgi87TLtvjfe/qpoJsOQ02K/hFTyMknxJnOWgzBSJiO11oeqe3jEeIq41nDtgorSqBX+s4huh1fhxFpHSm/iDYfalNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8PzwpYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8PzwpYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB6BC4CEEA;
	Mon, 16 Jun 2025 10:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750070476;
	bh=pg18VEj3ZOXpTjNRyCe0pJvFJwwasJGT6wPYPZGNhSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U8PzwpYAvDvaIa7H1kNw9v61ca9f8UyaoWqOiWCr14p/pj0VRYYDKk/NL7ypvwgWF
	 Hdjp9nIqIgTS1GDoKSo4mLh9wr/IncyFNGWVkBnnVmWsInaTdPwISrakcvJtlxQW8Z
	 FBHrt2KNsPgl9LM75hIMTnsXvakjUusHfNfrthp68AsBUOtNPJC4NXX+og9QpN8kC2
	 HAm//f+0EZ0ggJ6xKQEC+Q2j27G3ghCOGxLKay0gVPOG8Rvpvw756AwQZ0TWlL3MFw
	 vkUnzXCf+HHnYY/KjmtHGIrikcbbtkm888u/qAOMalZTORXYBBymwfPjlSthf9ovr+
	 wwnzsS1ShO3eA==
Date: Mon, 16 Jun 2025 11:41:09 +0100
From: Will Deacon <will@kernel.org>
To: Luo Jie <quic_luoj@quicinc.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, cocci@inria.fr,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Kiran Kumar C.S.K" <quic_kkumarcs@quicinc.com>,
	Lei Wei <quic_leiwei@quicinc.com>, Marc Zyngier <maz@kernel.org>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Oliver Upton <oliver.upton@linux.dev>,
	Pavithra R <quic_pavir@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Suruchi Agarwal <quic_suruchia@quicinc.com>,
	Suzuki Poulose <suzuki.poulose@arm.com>,
	Yury Norov <yury.norov@gmail.com>,
	Zenghui Yu <yuzenghui@huawei.com>, quic_linchen@quicinc.com
Subject: Re: [cocci] [PATCH v4 2/5] arm64: tlb: Convert the opencoded field
 modify
Message-ID: <20250616104109.GA17500@willie-the-truck>
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
 <3537a4ce-b5e8-44d5-a884-70a81562068d@web.de>
 <94b40ff2-9e9e-4eea-8a66-87d8976aeb70@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b40ff2-9e9e-4eea-8a66-87d8976aeb70@quicinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 16, 2025 at 06:37:41PM +0800, Luo Jie wrote:
> 
> 
> On 6/13/2025 4:15 AM, Markus Elfring wrote:
> > I see further refinement possibilities for such a change description.
> > 
> > 
> > > Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> > > - reg &= ~MASK;
> > > - reg |= FIELD_PREP(MASK, val);
> > 
> > * How do you think about to omit leading minus characters?
> > 
> > * Subsequent blank line?
> > 
> > 
> > > More information about semantic patching is available at
> > > http://coccinelle.lip6.fr/
> > 
> > I suggest to omit this information here (and in similar patches).
> > 
> > Regards,
> > Markus
> 
> Thank you for your suggestions. The current commit message was generated
> by the following patch mode command:
> ```
> make coccicheck MODE=patch COCCI=scripts/coccinelle/misc/field_modify.cocci
> V=1
> ```
> However, as I understand, the discussion on the ARM patches (between
> Russel/Marc/Yury) has concluded that the ARM arch changes may not be
> adding value over the current code, so I will drop the ARM patches
> in the next version.

Well, hang on a second. From what I can tell, the objections haven't
been specific to arch/arm{,64}/. You haven't really explained why this
new helper is needed and what value it brings over the existing set of
functionality.

So maybe start there, rather than dropping the parts that attracted the
comments to start with?

Will
