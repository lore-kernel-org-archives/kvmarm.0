Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA812FC007;
	Mon, 15 Sep 2025 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757935952; cv=none; b=aV8VaKYitUwBfUlu1VU/rdJW6GnxDxXgMtjCXs86/tHZnuNQO2lyLK+iOTdcIFY7vqtb95+kbaKgHVluFrnT7kJhSq1FY6Nj1WKZZnCof/D0I1kHcShbI8uQDCuXHRUi+Mc6aEQCn3XPDQQrMyplFWJBA933BLQJfphhClRXTyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757935952; c=relaxed/simple;
	bh=igQdQMm1aWVPuBBl6+Gz268oZtM9MYyah2qiIamBr0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpSHQ0Lp5KtFoo8FEueK3O3WhV9XIAs0GkMwMwT1HUZpp6gRn/97Df8XLcT4kc0omwb8grVo+zVlzTpUMmW+BP80QNiIQ7W92suVLjCMDkFirtDkJuEKKMhfN/DWznM1a6dpYLXI1kkiMFNFS+kj61f24pLdEv3YEs96r9JKVfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2WRhNj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2WRhNj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C361C4CEF1;
	Mon, 15 Sep 2025 11:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757935951;
	bh=igQdQMm1aWVPuBBl6+Gz268oZtM9MYyah2qiIamBr0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d2WRhNj+XGcJXy3udeuk2ypyEbEhGFwhh29xiQ84MKu1fhbKbEoaIr6iT+VyqqQeH
	 sOyCmO97muj9BhqBmdPLfAcdpjbfrW0MYycIpjrIoIaD22UFtO/jWqgbMlGo+z41Zf
	 SYwovXTGoUyGfHNxg9FYSV8R9NA0OOZSbBnGvnZoBY3oCldnr7mXn1QGc17b24QJB4
	 jBAgFPogtpmshCXRc2hK0I8OvRQQw5WdHcjC5NOo6rM9cQuXHIxpYYXcoEAyoO8g6e
	 kiZTkNeBLKgEDEroleiQvj1EoRlrZ1Q+AsB0JjJgkYJq48L6q4bsNaCAI/nklGukAP
	 dJccvMFtX34tg==
Date: Mon, 15 Sep 2025 12:32:26 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 3/6] arm64: Kconfig: add LSUI Kconfig
Message-ID: <aMf5SlYGhOFLSU1N@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-4-yeoreum.yun@arm.com>
 <aMRJK3x-K0HktAPA@arm.com>
 <aMfthATCr5VZcVAH@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMfthATCr5VZcVAH@e129823.arm.com>

On Mon, Sep 15, 2025 at 11:42:12AM +0100, Yeoreum Yun wrote:
> > On Sat, Aug 16, 2025 at 04:19:26PM +0100, Yeoreum Yun wrote:
> > > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > > previleged level to access to access user memory without clearing
> > > PSTATE.PAN bit.
> > > It's enough to add CONFIG_AS_HAS_LSUI only because the code for LSUI uses
> > > individual `.arch_extension` entries.
> >
> > The subject could be improved slightly: Detect toolchain support for
> > LSUI.
> >
> > >
> > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > ---
> > >  arch/arm64/Kconfig | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > index e9bbfacc35a6..c474de3dce02 100644
> > > --- a/arch/arm64/Kconfig
> > > +++ b/arch/arm64/Kconfig
> > > @@ -2239,6 +2239,11 @@ config ARM64_GCS
> > >
> > >  endmenu # "v9.4 architectural features"
> > >
> > > +config AS_HAS_LSUI
> > > +	def_bool $(as-instr,.arch_extension lsui)
> > > +	help
> > > +	 Supported by LLVM 20 and later, not yet supported by GNU AS.
> >
> > binutils 2.45 added support for LSUI.
> >
> > Nitpick: we tend to add a two-space indentation from "help".
> >
> > Otherwise it looks fine:
> >
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Thanks! I'll change the Nitpick and send again.

Please don't resend until we've concluded on the CAS discussion.

Will
