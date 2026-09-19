Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94D3655ED;
	Sat, 19 Sep 2026 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789841788; cv=none; b=CLVJ1+FCK28H4CWWbZUat0thDjW+fn1IaBFsTBwLcZIIWJCFm8ai6WAOYjOXDjUlpFHxq5wsppiSQxDiabiIdRtmjONBqdiKCDoooj5sIXpEXufnehM0l1xkfmtlFLMYJdvTnYBJ9cjFFRYJtUUxX6C6Nbe2VbXqo5RoQhpgcVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789841788; c=relaxed/simple;
	bh=1WKORpw1j+na2uFRuaHzOZ3HamX2x2ZK00DhqXRzgUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OX5lXl879zSwTVodiXbH2Y1tSk9F1OPYt5j0RiKQco7sR54JKtLlSdL0pKp/vX3aC78lp21SEy4t28ym2EI9cudDatRvBhPwmRtRM7zZ+4zs+86dl+86olp6bqnj35CmwvSpLW5gKSJFDBv2f63EGsFsaNUYYR1q0pWqsPhIt4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENHB77X3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENHB77X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280241F000FF;
	Sat, 19 Sep 2026 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789841783;
	bh=8uqyZbYFjivdSJP0aMKKIEPMrtOqIr8aCoIxoeOYNsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ENHB77X3aUbsDqyvI1CoPjMBuwQZMSMFu1h+acmovvPzxMXxPe+dNgXbATWtMjBeh
	 KiICsrUSkrsAFRHzcfZ10WBgEhU2KM+sDkooqe34615pc9g1lboPNpBxdM7Qe4pKM6
	 NbHrRlX+WCJ8wgu8vvxpOh33Pi8BBA5sypjSSRGhJCzFntygX05h22SjTJn0pNSxX3
	 is1kqpjuLNXIU/z74djRdfY6ZrB96EW9UiLPHT4gv/3SrynG6rqIZwKjQVEQDLsMNl
	 qotje6z2g6NAGTrnmBWukovQuJgXrmwMYrQPfHRraCDb+7EYfqk/grtrXRpPxHDdgl
	 rGDAusNVQm0iQ==
Date: Sat, 19 Sep 2026 11:16:21 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
Message-ID: <aq7RdZqJNNtqmaQ7@kernel.org>
References: <20260810005616.13227-1-kmehltretter@gmail.com>
 <178984145401.38162.12449211285441501967.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178984145401.38162.12449211285441501967.b4-ty@kernel.org>

On Sat, Sep 19, 2026 at 11:11:14AM -0700, Oliver Upton wrote:
> On Mon, 10 Aug 2026 02:56:16 +0200, Karl Mehltretter wrote:
> > The consolidation of the breakpoint and watchpoint register accessors
> > switched DBGBXVR<n> from trap_bvr() to trap_dbg_wb_reg(). The latter
> > selects backing storage with demux_wb_reg(), which only handles Op2 values
> > 4 through 7. Since DBGBXVR<n> uses Op2 1, an AArch32 guest access hits
> > KVM_BUG_ON() and marks the VM dead.
> > 
> > DBGBXVR<n> aliases DBGBVR<n>_EL1[63:32], and its AA32(HI) descriptor
> > already selects the upper half. Map Op2 1 to dbg_bvr[] alongside Op2 4,
> > restoring the pre-regression behavior.
> > 
> > [...]
> 
> Thanks for pinging, this slipped between the cracks.
> 
> Applied to fixes, thanks!
> 
> [1/1] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
>       https://git.kernel.org/kvmarm/kvmarm/c/239763bda716

This is now 6b1bca1b1ab7, didn't grab the Cc: stable in the first pass.

Thanks,
Oliver
