Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502218;
	b=ATIRNPc7tjJ//MJzYMu3X3PO3HpICnHZUsimeNxBKCCdBtRpTFEHNNK5Oj3rOnc2bjZ9
	 y8o0Gd26zpiaPkdsRmCH72obL9wLqGTmP0N0HM9zwAAkvNIowQ1F4UslqXYoUXn9vAj/a
	 CkQwhSCnoi9xZxfjXIizU0EC9+b71QldvOVZhhvUCKTwfl4BhPfCg81FLySlmx36HEUsK
	 u8eVRZEArrcBUm4JX9LZWM6DR+KqTIMw9Nt2g/ybwuagmuM98CptGUrFCvEJibDWghZPo
	 ncXgErZdDw+hjfqwtIAuJGsc/PQn9D4BBX1LbW4lEPceljND/G4ECMq7Oq317a1H5GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502218;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Etd6ucBFRv+2kOi2yYshLpQy3u0L6/x6e/cAweVbOSw=;
	b=na6kiicE6BP+1791Y985clzc3iJtvKPvXSPSr8FxTk/UHnZWEZ7rEMYPVDKN2L1Ahn3b
	 qg0bvnpLk/KmXRSayyih/rmKpGwRf/b+83w7O/5P+tulDu74xS9dYrkthAb39fEHLVA1q
	 ayKyR2rN1FPhOxd4ajEqcglv/eH0Fgca2DhSgMp3fS9zKgSt+ZpHtuGerU0hrRGwRReIO
	 d7k/4ccGvhzrwOMc4uwIcR31XvBvQrwjZAHR/LKjANA4tvNGv7CsOWX1I0yt7bwn/LA6g
	 h2hcfDdeBtv3ip1vxL9zmC1jqJ2CMjpuK46Pa2q4tLJ2/h/KkxsTWg92pqb5UY5futg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lSo3U/Dg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F05606A325;
	Tue, 20 Oct 2026 13:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lSo3U/Dg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3471F000C9;
	Tue, 20 Oct 2026 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502218;
	bh=Etd6ucBFRv+2kOi2yYshLpQy3u0L6/x6e/cAweVbOSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lSo3U/DgvqTSwlraWwSAgPECmRJEUs5KxGqJeCP0RLzL0OcBhj+6q3yvZlAwTeGN9
	 yvt5l0NY62BVsjT7s9GPrNquu4sIswA3VglkICr9Q8tqs0aljuKTEXLj5Z2yK+cBZ/
	 AB9jJv/nmcYJRcAf6fJqDvfozzWW9RGYPfrulUpiTfl8dsaDukSSgDh74pfswNUq6G
	 //4tVbfNHuwgiDlB/JjqZ1oFsZd5mpISMAxB+rOW+mp71Yt+JpxoSappWPjbnm07Jf
	 Xj67C29HMVAuW36W7S1PkCJyU+PECJO5Jpw8OR9idY9MnGNKDFOGpDqRrqCz2L89/R
	 /AQUqDDP550Lg==
Date: Tue, 20 Oct 2026 14:16:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <atdebC62zPS1sQeR@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <86fqyn2che.wl-maz@kernel.org>
 <as-f1JfUy38Xt9QA@gremlin>
 <ae24e80c-1b34-4827-9c93-e80b987e9cd7@sirena.org.uk>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae24e80c-1b34-4827-9c93-e80b987e9cd7@sirena.org.uk>

On Wed, Oct 14, 2026 at 06:48:37PM +0100, Mark Brown wrote:
> On Wed, Oct 14, 2026 at 04:47:22PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Oct 03, 2026 at 01:30:05PM +0100, Marc Zyngier wrote:
>
> > > This *absolutely* needs to be data driven, and we're not going back to
> > > over two years ago. We already have most of what is needed in
> > > config.c, and it is only a matter of making sure that S1PxE is only
> > > enabled for the guest if TCR2 and ATS1A are also present. If that
> > > means additional sanitisation of the idregs when finalised, so be it.
>
> I do agree that's what we should have, I started down that route but as
> I noted in the commit log it felt like I was pulling in disproportionate
> refactoring given the existing gap.
>
> > > If userspace decides to expose crap in the ID registers, that's its
> > > own problem, and we're not in the business of enforcing idiotic
> > > configurations. The only thing that matters is that the state that KVM
> > > deals with is consistent.
>
> > As I understand it: don't return an error for a configuration that doesn't
> > make sense, enforce RES0 instead.
>
> I went with erroring out there to make sure that we didn't make any
> mistakes with the ordering of our checks - I didn't want to accidentally
> end up with a situation where we look at the dependencies for feature A,
> decide that it's OK, then later check feature B which it depends on and
> turn it off due to it missing it's own prerequisite.
>
> We can resolve that like you've done here by having the full dependency
> stack in every check but I worried that this would be error prone due to
> all the duplication, however looking at your code I think we can resolve
> that anyway, see blow.
>
> Userspace really shouldn't be setting up guests where we need to make
> adjustments in the first place, and setting up guests isn't that hot a
> path so like Marc says so long as KVM protects itself we're fine.
>
> >  #define kvm_has_s1pie(k)				\
> > -	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
> > +	(kvm_has_tcr2(k) &&				\
> > +	 kvm_has_feat((k), ID_AA64ISAR2_EL1, ATS1A, IMP) &&	\
> > +	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
>
> This will mean that every time we check for an individual feature
> throughout KVM we check for all the dependencies as well.  A lot of the
> time that's not really going to matter but we have these checks in hot
> paths like context switches.
>
> > +static bool feat_s1pie(struct kvm *kvm)
> > +{
> > +	return kvm_has_s1pie(kvm);
> > +}
>
> We should put the dependencies in here where they're only checked during
> initialisation instead, that way the hot paths only need to look at the
> leaf features.  We could also deal with the duplication concern by
> having the functions call each other rather than duplicating their
> contents:
>
> 	static bool feat_gcs(struct kvm *kvm)
> 	{
> 		if (!feat_s1pie(kvm))
> 			return false;
>
> 		return kvm_has_gcs(kvm);
> 	}
>
> (or whatever stylistic variation of that.)
>
> This approach also needs the code for updating the ID registers since
> config.c doesn't do that at the moment.  Some of the existing visibility
> limiting stuff (like for 32 bit ID registers without AArch32 or
> ID_AA64ZFR0_EL1 without SVE) could be moved over too.

Hopefully Fuad + Marc's efforts [0] make all of this fairly easy :) as we
now have a specific dependency mechanism, and with GCS added on respin
should enforce all this correctly.

>
> TBH when I said in the commit log I was thinking of something more data
> driven I was thinking more of having the dependencies expressed as pure
> data, more like the way the test in set_id_regs is written.  This also
> seems fine to me, the checks are similar.  It's just much more invasive.

Indeed. Perhaps the config.c approach will make it easier to convert JSON
-> code also?

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/r/20261020064306.1542865-1-fuad.tabba@linux.dev
