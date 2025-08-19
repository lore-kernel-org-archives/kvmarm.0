Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCEE26E6E4;
	Tue, 19 Aug 2025 08:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755592740; cv=none; b=DwTlKzpqnu2bJDI/dw4tI27JTU4xYpbpYQ88fpKDTZ09vJ6fn++WDdcnSyx9v9fASTkjsD0SZYcVj+WU+m9I1YKocIwxSzDlvyQ+UwJ/+dun/EHWD/IRBjaTURHxuG9pCNOtbnHp6gF0UOVFQDGHWl5HklESppqgOE7r00+RHo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755592740; c=relaxed/simple;
	bh=PU3YNexJTCgesX6f7cpBCRWSlGprO2iB+9oIGzKXA3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJqchoH7YXLoFto7h4LW97+8MY/8lZkJP1YmrvlL4+zw6vv01k7vSbu5kZKUpO0jdE61KfE8s4VTIM6Wa5TstslktJUcqvonsIwXonRn33WcL2jHoQTsW0Jtnf+/m4S9dZKcgBGejQU/eWLNbirm3UhUjkPK9g79qj+mSTJ/WBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E14C4CEF1;
	Tue, 19 Aug 2025 08:38:56 +0000 (UTC)
Date: Tue, 19 Aug 2025 09:38:54 +0100
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
Message-ID: <aKQ4HvqZa_7Q7oDu@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
 <aKNyj_6dZVp9O4BA@arm.com>
 <aKOE1aqe6EljRkuB@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKOE1aqe6EljRkuB@e129823.arm.com>

On Mon, Aug 18, 2025 at 08:53:57PM +0100, Yeoreum Yun wrote:
> > On Sat, Aug 16, 2025 at 03:57:49PM +0100, Yeoreum Yun wrote:
> > > why we need to care about the different settings for tag checking when
> > > we use uaccess_disable_privileged()?
[...]
> > > But, although tag check fault happens in kernel side,
> > > It seems to be handled by fixup code if user address is wrong.
> >
> > The user may know it is wrong and not care (e.g. one wants to keep using
> > a buggy application).
> 
> Then Does this example -- ignoring wrong and keep using a buggy
> application shows us that we need to enable TCO when
> we runs the LSUI instruction?
> 
> AFAIK, LSUI instruction also check memory tag -- i.e) ldtadd.
> if passed user address which has unmatched tag and if user isn't
> interested in tah check, It can meet the unexpected report from KASAN.

That's a valid point w.r.t. PSTATE.TCO that applies to copy_to/from_user
as well. I don't think we documented it but we don't expect the user
PSTATE.TCO state to be taken into account while doing uaccess from the
kernel. We do, however, expect SCTLR_EL1.TCF0 to be honoured and that's
what the user normally tweaks via a prctl(). The TCO is meant to
disable tag checking briefly when TCF enabled the tag check faults.

-- 
Catalin
