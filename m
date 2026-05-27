Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C613930E82B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 10:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779877967; cv=none; b=j2OuBIkwBM0HJ77O7z0oW6E8gBSZGVq2H3yTm+tQda3pQvFXb8Ra5xtqub8POyyPglFrMMDbdOgpMaCVwWN/a7dbuyZf+Y9ox63OOZIg4w/hUXOyjVhLH94R73NkyglmTc5Secmr2dtetDeni33iefOiHgDtkboDzV8zkk9JtlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779877967; c=relaxed/simple;
	bh=0st74ItZiJDJHY//YKi9k3j5LAz4Sxki0o7s6Hb9c5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjRkAWxDziWi5tkerGG/N029vKT53iqCVe8fYnm1nbZkdimMpeCeW5d1S1YJx7oSym2QYr5PdNhpsLW17TChUdR9i/kwcEnH5kwg3y6PFliu5X4VnBTh+wBzKCvHekq+Dh3zgNt1Hc/cYUINCboiz6EZcfg/MIkxnWhRsxInDfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JLiGXkxk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JLiGXkxk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27B751595;
	Wed, 27 May 2026 03:32:40 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98CEB3F7D8;
	Wed, 27 May 2026 03:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779877965; bh=0st74ItZiJDJHY//YKi9k3j5LAz4Sxki0o7s6Hb9c5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLiGXkxk0Fgkp4N/V0D32PUPj34yCyi7teBulpO88R+mFWUqu6IeJUKwO8I6RMgg4
	 olOb0D10ygJCmOyRBDlt+6nGQU+prgNtRjpdkLDBhFs6V8bLFC9fCYZgLfnMB+9i9m
	 2NLTXZ/Cy1rh7UFF1i8yww+vOhjVDTJYgVz5b/kA=
Date: Wed, 27 May 2026 11:32:37 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>, will@kernel.org, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, james.morse@arm.com, oupton@kernel.org,
	tabba@google.com
Subject: Re: [PATCH 00/18] arm64+KVM: FPSIMD/SVE/SME cleanups
Message-ID: <ahbIRe0jR95elM2L@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <86se7duvgc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86se7duvgc.wl-maz@kernel.org>

On Wed, May 27, 2026 at 09:07:31AM +0100, Marc Zyngier wrote:
> On Thu, 21 May 2026 14:25:38 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > This series cleans up low-level FPSIMD/SVE/SME state management code,
> > making it easier to maintain and extend (e.g. adding SME support to
> > KVM), and enabling better debugging (e.g. by making SVE/SME save/restore
> > visible to KASAN and KCSAN).
> > 
> > This is purely cleanup, there are NO bugs addressed by this series.
> 
> I had a look throughout, and couldn't see anything untoward other than
> the couple of nits that were already pointed out. Killing the horrible
> asm macros definitely brings a bit of fresh air to this code base.
> 
> Given the sensitivity of the change, I'd like this to simmer in -next
> for a bit. How do you want this to be merged? I'm happy to take the
> whole thing in kvmarm, and share the branch with arm64.

That works for me.

Catalin, Will, any preference?

> I assume you'll post a v2 anyway?

Yep; given the bits that need fixups, I'll send a v2 by the end of this
week unless something explodes.

Mark.
