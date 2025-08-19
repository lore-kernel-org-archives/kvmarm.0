Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5775D26B2CE
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613777; cv=none; b=sMa6M/xqjPJ0NHtji3hNSzEdrFCJd0TPwkcYXWqaldBInp611jBD746PvnCd42QhjHgQw323eF79O/OpPnl5h3NFOWyi/gvqIolo6E1lmsLUaszIAGqGT9zo8p3NwWzErvQcyIx1VeZQa8agfx4HKBMy/bZXRbcqmeD6NjA8rHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613777; c=relaxed/simple;
	bh=qBMb4mQN8q/J9DIYg/zpsQG6isLCLwRCVBaxBd2POLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OfHxbXdLrVpf+Mq/NdMfTVfDYj+JrvechnbTtpyU5+rMWCAreP20at4qCNRUK3eUwq1c/ptBFWsX4TwhkF7g5P2mCY9fUofqrwO9N6FhXo6c2tv3BlSgwqcp4nYQmfrdzP7MTHk8FGKotSDdC0K01Pi6XqGNo28KM2Y5NRi0M7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63384106F;
	Tue, 19 Aug 2025 07:29:27 -0700 (PDT)
Received: from arm.com (unknown [10.1.31.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CF413F63F;
	Tue, 19 Aug 2025 07:29:33 -0700 (PDT)
Date: Tue, 19 Aug 2025 15:29:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aKSKS2__HEZDfyoi@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
 <aKNyj_6dZVp9O4BA@arm.com>
 <aKOE1aqe6EljRkuB@e129823.arm.com>
 <aKQ4HvqZa_7Q7oDu@arm.com>
 <aKQ/pglPWZMprL5e@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKQ/pglPWZMprL5e@e129823.arm.com>

On Tue, Aug 19, 2025 at 10:11:02AM +0100, Yeoreum Yun wrote:
> On Tue, Aug 19, 2025 at 09:38:54AM +0100, Catalin Marinas wrote:
> > On Mon, Aug 18, 2025 at 08:53:57PM +0100, Yeoreum Yun wrote:
> > > > On Sat, Aug 16, 2025 at 03:57:49PM +0100, Yeoreum Yun wrote:
> > > > > why we need to care about the different settings for tag checking when
> > > > > we use uaccess_disable_privileged()?
> > [...]
> > > > > But, although tag check fault happens in kernel side,
> > > > > It seems to be handled by fixup code if user address is wrong.
> > > >
> > > > The user may know it is wrong and not care (e.g. one wants to keep using
> > > > a buggy application).
> > >
> > > Then Does this example -- ignoring wrong and keep using a buggy
> > > application shows us that we need to enable TCO when
> > > we runs the LSUI instruction?
> > >
> > > AFAIK, LSUI instruction also check memory tag -- i.e) ldtadd.
> > > if passed user address which has unmatched tag and if user isn't
> > > interested in tah check, It can meet the unexpected report from KASAN.
> >
> > That's a valid point w.r.t. PSTATE.TCO that applies to copy_to/from_user
> > as well. I don't think we documented it but we don't expect the user
> > PSTATE.TCO state to be taken into account while doing uaccess from the
> > kernel. We do, however, expect SCTLR_EL1.TCF0 to be honoured and that's
> > what the user normally tweaks via a prctl(). The TCO is meant to
> > disable tag checking briefly when TCF enabled the tag check faults.
> 
> So, IMHO, as copy_to/from_user (ldt/sttr) enable tco before it operates,

They don't enable TCO.

-- 
Catalin
