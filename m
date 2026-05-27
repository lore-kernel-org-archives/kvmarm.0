Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA583672A5
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892606; cv=none; b=OIilAIYvcFK5zr9OBBA4ungjoKDb/MgRHgzoMyFCLv8HR137qIUhdtFaWpo6Bz2SOXerCUs7tK3Kd2nTt9vSDV1QfPLc/NLUdWZS5YGafzSZEfkp1MTf3gK7k0CAQR/F0wqX5HweNfqGPtZnmbOVbP0KobLiBpG9xpINMFTOFWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892606; c=relaxed/simple;
	bh=466K/b5DUhcAJKa4vrewJKb84AYDfOUbgkD0GJ2qx5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9A7/LyoXl66ShndaQJ76d+I+TCRTlp7p21yu5Nillfo0UIFIrPbl876x1i7rcj5kYwTTwCxlNOGWaRRh7GO3z2WaAnrDnum9zh+7L+vQwpJAiWmcptQ0B9OpoVkdeFNoCkybe2d3zO/TAx+1AZ5k1zF4djWh118YkRG/hbdTmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzavnswY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzavnswY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0311F000E9;
	Wed, 27 May 2026 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779892605;
	bh=f+a1v3PoCPWgX96Gtuy8dS290FHYVmJD02LKqOIO6Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mzavnswYCA2zVrBfb0QV1Jn7Hj3q1/dgvzNQMbYcUaYjnrS/fMUeVROs2KRU7umE6
	 lj4fvWB+FJcePrAKYwoxrbWGesM7pRlar050C+m2Ek6SNjC4N+ZHLnIf3ZLEGXdkEq
	 BPyYeRjl+UialdWm+9+pC7hQXPhxDG9jg3y5sWPKapo74GPP1YJX+BNnQXXETn9uxY
	 qGQJ8kPqh2LtM2i3baWgk4CT81sOHcQEQNHEy10tm50iTap5E8lCCSUzi75Su1l42j
	 75eUOlFDZC4bQFpYgA/YAUn+CUUS35Rs3AobZ+UY6brXNqTrFsvA3iDiN30zHyoqCV
	 6JSVYC+hpENZg==
Date: Wed, 27 May 2026 15:36:40 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, james.morse@arm.com, oupton@kernel.org,
	tabba@google.com
Subject: Re: [PATCH 00/18] arm64+KVM: FPSIMD/SVE/SME cleanups
Message-ID: <ahcBeMSQXNQ4DcWI@willie-the-truck>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <86se7duvgc.wl-maz@kernel.org>
 <ahbIRe0jR95elM2L@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahbIRe0jR95elM2L@J2N7QTR9R3>

On Wed, May 27, 2026 at 11:32:37AM +0100, Mark Rutland wrote:
> On Wed, May 27, 2026 at 09:07:31AM +0100, Marc Zyngier wrote:
> > On Thu, 21 May 2026 14:25:38 +0100,
> > Mark Rutland <mark.rutland@arm.com> wrote:
> > > This series cleans up low-level FPSIMD/SVE/SME state management code,
> > > making it easier to maintain and extend (e.g. adding SME support to
> > > KVM), and enabling better debugging (e.g. by making SVE/SME save/restore
> > > visible to KASAN and KCSAN).
> > > 
> > > This is purely cleanup, there are NO bugs addressed by this series.
> > 
> > I had a look throughout, and couldn't see anything untoward other than
> > the couple of nits that were already pointed out. Killing the horrible
> > asm macros definitely brings a bit of fresh air to this code base.
> > 
> > Given the sensitivity of the change, I'd like this to simmer in -next
> > for a bit. How do you want this to be merged? I'm happy to take the
> > whole thing in kvmarm, and share the branch with arm64.
> 
> That works for me.
> 
> Catalin, Will, any preference?

I was hoping the first four could go via kvm/arm on a shared branch, but
I notice that some of the later patches also have their fingers in kvm
code. Chatting with Marc offline, I'll take the whole lot onto its own
shared branch in the arm64 tree when you post a v2.

Will
