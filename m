Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A14819644B
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 11:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723806166; cv=none; b=pT6dyiUNWnh34ZpvQZ02F+M1R4YzlFduJTRReNK7IOR/yAPbwk5xOQRjuiRXgUjT147eIv/oRk1PfYR3fMmax68XStZ+KNAkwFsw2ZqkhwCLc33T9VM32kxy34wX658KUFS0tXuynHVpXwkdk928Um+m/JVzQuTRQJKIAQdzsfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723806166; c=relaxed/simple;
	bh=0uqMswupFDSpFIN7cjTdDuPtL/gYgIf6NZP3JsxGsBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3pLRWVS9Zzajzc4vu0wL0EpR1MT695dGuYk6TmPcfBrs6m20+SxKGjbub8cpSvJ1sXGJQ+iYzQo0YmYRwJhtGJxpv5fejO9yBOGb5fDx7eLcUeqc6FLEWrCBm5kKvBPqt+XkHQuMEeDWTw/h9TEqob7POetBFBeGfatXqCwZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89846143D;
	Fri, 16 Aug 2024 04:03:09 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23F1F3F73B;
	Fri, 16 Aug 2024 04:02:40 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:02:37 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v3 14/18] KVM: arm64: nv: Add SW walker for AT S1
 emulation
Message-ID: <Zr8xzdmMELK07YUo@raptor>
References: <20240813100540.1955263-1-maz@kernel.org>
 <20240813100540.1955263-15-maz@kernel.org>
 <Zr4wUj5mpKkwMyCq@raptor>
 <86msldzlly.wl-maz@kernel.org>
 <Zr8aYymB_2xSqIQp@raptor>
 <86le0wzrbv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86le0wzrbv.wl-maz@kernel.org>

Hi Marc,

On Fri, Aug 16, 2024 at 11:37:24AM +0100, Marc Zyngier wrote:
> Hi Alex,
> 
> On Fri, 16 Aug 2024 10:22:43 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Thu, Aug 15, 2024 at 07:28:41PM +0100, Marc Zyngier wrote:
> > > 
> > > Hi Alex,
> > > 
> > > On Thu, 15 Aug 2024 17:44:02 +0100,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> [...]
> 
> > > > > +static bool par_check_s1_perm_fault(u64 par)
> > > > > +{
> > > > > +	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> > > > > +
> > > > > +	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM &&
> > > > > +		 !(par & SYS_PAR_EL1_S));
> > > > 
> > > > ESR_ELx_FSC_PERM = 0x0c is a permission fault, level 0, which Arm ARM says can
> > > > only happen when FEAT_LPA2. I think the code should check that the value for
> > > > PAR_EL1.FST is in the interval (ESR_ELx_FSC_PERM_L(0), ESR_ELx_FSC_PERM_L(3)].
> > > 
> > > I honestly don't want to second-guess the HW. If it reports something
> > > that is the wrong level, why should we trust the FSC at all?
> > 
> > Sorry, I should have been clearer.
> > 
> > It's not about the hardware reporting a fault on level 0 of the translation
> > tables, it's about the function returning false if the hardware reports a
> > permission fault on levels 1, 2 or 3 of the translation tables.
> > 
> > For example, on a permssion fault on level 3, PAR_EL1. FST = 0b001111 = 0x0F,
> > which means that the condition:
> > 
> > (fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM (which is 0x0C) is false and KVM
> > will fall back to the software walker.
> > 
> > Does that make sense to you?
> 
> I'm afraid I still don't get it.
> 
> From the kernel source:
> 
> #define ESR_ELx_FSC_TYPE	(0x3C)
> 
> This is a mask covering all fault types.
> 
> #define ESR_ELx_FSC_PERM	(0x0C)
> 
> This is the value for a permission fault, not encoding a level.
> 
> Taking your example:
> 
> (fst & ESR_ELx_FSC_TYPE) == (0x0F & 0x3C) == 0x0C == ESR_ELx_FSC_PERM
> 
> As I read it, the condition is true, as it catches a permission fault
> on any level between 0 and 3.
> 
> You're obviously seeing something I don't, and I'm starting to
> question my own sanity...

No, no, sorry for leading you on a wild goose chase, I read 0x3F for
ESR_ELx_FSC_TYPE, which the value for the variable directly above it, instead of
0x3C :(

My bad, the code is correct!

Thanks,
Alex
