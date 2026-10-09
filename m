Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31640472062;
	Fri,  9 Oct 2026 07:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791530583; cv=none; b=g245kac2DQaEApdop2YVVxJ2wwb6QCWkhQCSYShzOrD1zpW1sQQwHtb0lKkNZCkIL+qoIecCj3alPxF1D5oGXyhkadvdrLUnH/ukmd4UBpLav/2dF34q1UbMDCwws30lrgEP4rzjHK5Obl28D4y3JED7jmYf/kqSD65ma8VLor0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791530583; c=relaxed/simple;
	bh=WsYk4mwXHGtEeA9/sqqtPLloNXN/PsNfk1fSu7KICtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g68uoj909WMdWvczgiSIYLJmNVKEue0e4TLQHjW4nNivy2tYnegGEt6JzblK3/gFf+WIIwB5I/tQ3rqrvEhsmzExSOfNoV8W3L8cUn/4UhO/V1T7s3/Sqkl0Pf0hNPiPYYrFoCNKbheJxEHqSStn8a2N73WrhsSulGS4ENW13kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=t8CehVv4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="t8CehVv4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE6991692;
	Fri,  9 Oct 2026 00:22:57 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29DE03F8C6;
	Fri,  9 Oct 2026 00:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791530581; bh=WsYk4mwXHGtEeA9/sqqtPLloNXN/PsNfk1fSu7KICtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t8CehVv4+Lz8Ugsv96BmQeZ1twjOPHaeTSryLFZ8XK8XZigz5W+IYmOHxXvNgxCos
	 N7BdEXolPVcgXabranRPAkc3TgIpNDG7vL7on5JnWLSDBD8O+6Xi8OgL/yfdqoaAGW
	 FrYeFAl55KJTNtuwLj3854pSMLI1wyh9ufDn1hq0=
Date: Fri, 9 Oct 2026 08:22:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peng Fan <peng.fan@oss.nxp.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <asiWTxgGxJ5JIFcl@arm.com>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
 <asTZEhzMDs869r_n@arm.com>
 <aseZUwi0CYTXuE/I@shlinux89>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseZUwi0CYTXuE/I@shlinux89>

On Thu, Oct 08, 2026 at 09:23:31PM +0800, Peng Fan wrote:
> On Tue, Oct 06, 2026 at 12:18:42PM +0100, Catalin Marinas wrote:
> >On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
> >>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
> >>     for guests.
> >
> >Do you need virtualisation on such platform? An alternative would be for
> 
> We not have KVM support in our software release for i.MX8QM.
> 
> >the guests to be aware of the erratum as well and use the right TLBI/IC
> >ops. But you'd also need to upgrade the VMID-aware ops in KVM (unless
> >the hardware can't work around stage 2 TLBI at all).
> 
> We not have test cases for this since KVM is not in our release scope. 
> Could we take this as a future enablement to avoid uneccessary churn

Yes, you can leave it out if you don't care about the KVM use-cases.

> >There's a precedent with 4311569 to wire up a SoC erratum into the CPU
> >errata framework. That one is a system wide feature, so only probed once
> >for the CPUs coming up at boot (though still probed for each late CPUs).
> >For iMX, you need this turned on early, hence the boot probing. But
> >calling it a strict boot CPU feature is a bit of a stretch. It also gets
> >probed on every CPU, unnecessarily.
> >
> >I think we could do with something like below (maybe as a preparatory
> >patch). We could also add it to 4311569 even if it changes its scope
> >from system to boot CPU (the early param is available).
> >
> >Only compile-tested and haven't tried wiring up your workaround:
> 
> With type set to ARM64_CPUCAP_SOC_ERRATUM for i.MX8QM and your patch
> applied, I not see issues in my test.
> 
> Would you post it as a formal patch or need me to include your patch
> with i.MX8QM errata patch in a patchset?

Please post it with your patchset. Feel free to add a co-developed-by or
suggested-by me on the new cpucap proposal.

-- 
Catalin
