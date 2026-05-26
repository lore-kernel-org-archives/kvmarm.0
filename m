Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F202038D6A4
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814320; cv=none; b=HWqArWcHETHo5d68J+KPBvvesd+31CiioCVzUlmlcFdGB3fFWMaxIlelqNSGJpNLZlioEpLrhG6JEjscMOtlRsKv64qtEhSfaYlr6cTK+yuMdg1p8tiD7ntk4ngwyTwu+cyhYHHu2D6SansV9zIjj6wGic7uPs5lEDAziKrsVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814320; c=relaxed/simple;
	bh=PNfzOd0XnNPmZGjcu5LANYH6PkI7wBG9bSQBrmzrp/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bw2OxZRh1udU7ODt3mXVSrTafpTgWF7e1swOA6P6MspdQmcxM/UAfFATcXS2Z7lVLvdFby4dHzVjdB0XWYJZYZqrBLiGsI6OxIJFJO1bYb8/OvmIXs/gfyM3U60s9Y3L0Fg/1rZuoY454e6UDyVsZM+9kSDIXM6Psczc7KHNnHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WpPBVuVL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WpPBVuVL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B080E16F2;
	Tue, 26 May 2026 09:51:52 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3529A3F7B4;
	Tue, 26 May 2026 09:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779814317; bh=PNfzOd0XnNPmZGjcu5LANYH6PkI7wBG9bSQBrmzrp/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WpPBVuVLmVYNLUGiahOLNy0vipR0lpSeI48VX4CZPoXGJgdn4L1DtSWBepINF2IdN
	 6fqmk8Ce2nCHupWifzTBpE7xBPeilTkGkkreVh5PLpvFGeYsx3IWoxUCgMtOaro86u
	 djuXNYZHbiICB7bVxuiOLfzbI/Radtl9uUjGLHns=
Date: Tue, 26 May 2026 17:51:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 10/18] arm64: sysreg: Add FPCR and FPSR
Message-ID: <ahXPqSPB5CEUbRdz@J2N7QTR9R3>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-11-mark.rutland@arm.com>
 <458fcb4c-46a9-49db-a179-9081d7d50dbf@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <458fcb4c-46a9-49db-a179-9081d7d50dbf@sirena.org.uk>

On Tue, May 26, 2026 at 04:55:44PM +0100, Mark Brown wrote:
> On Thu, May 21, 2026 at 02:25:48PM +0100, Mark Rutland wrote:
> > Add sysreg definitions for FPCR and FPSR.
> 
> > +Sysreg	FPCR	3	3	4	4	0
> 
> This looks good.
> 
> > +Sysreg	FPSR	3	3	4	4	1
> > +Res0	63:32
> > +Field	31	N
> > +Field	30	Q
> 
> DDI0487 M.b and DDI0601 2026-03 both call this field Z.

Sorry about that; fixed locally now, and I've double-checked the rest.

Mark.
