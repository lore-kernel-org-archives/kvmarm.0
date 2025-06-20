Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344EE28DB4A
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750427005; cv=none; b=bUAZkep6F8P1b2Fusb7H/gErGboQe5b0hNGawPYIVlhC3xXLTD5BRslZkbnpgtz1cn5JcgoDka7NGPyvvaT1fdZvhj7OniTKl924vxpZK743C4gSgr8Rfs1sBLfeARdz/yBwcZu3d0D3q6b+162FJKST3FXdXLIIElSoQt6bNlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750427005; c=relaxed/simple;
	bh=lrcNUHtlReWoZSxDZS/NaNmUP4pH6w+Aw1Kv5g7uJcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffW2bnQ3B3bOrkqLy4I65thHntnLj1nARNFR43R4B8xsy6aHrnRy+VnCof057EyI9dA3Th2xHuy5l4qm9RdbaCQDbfwxse7hgJXa1sioMENMMxWq8wKUZEISuaSJ6ebBnrJ4o5816MUfOK0Zq5/395CacKV+CbBIpkMvjrs7SxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECABE16F2;
	Fri, 20 Jun 2025 06:43:02 -0700 (PDT)
Received: from arm.com (unknown [10.57.84.252])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E18063F673;
	Fri, 20 Jun 2025 06:43:20 -0700 (PDT)
Date: Fri, 20 Jun 2025 14:43:16 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool 2/3] arm64: Initial nested virt support
Message-ID: <aFVldEvilsGrM34y@arm.com>
References: <20250620104454.1384132-1-andre.przywara@arm.com>
 <20250620104454.1384132-3-andre.przywara@arm.com>
 <aFVBckcGYQgF+UXO@arm.com>
 <86h60ad40n.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h60ad40n.wl-maz@kernel.org>

Hi Marc,

On Fri, Jun 20, 2025 at 12:52:08PM +0100, Marc Zyngier wrote:
> On Fri, 20 Jun 2025 12:09:38 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Andre,
> > 
> > Thanks for doing this, it was needed. Haven't given this a proper look (I'm
> > planning to do that though!), but something jumped at me, below.
> > 
> > On Fri, Jun 20, 2025 at 11:44:53AM +0100, Andre Przywara wrote:
> > > The ARMv8.3 architecture update includes support for nested
> > > virtualization. Allow the user to specify "--nested" to start a guest in
> > 
> > './vm help run' shows:
> > 
> > --pmu             Create PMUv3 device
> > --disable-mte     Disable Memory Tagging Extension
> > --no-pvtime       Disable stolen time
> > 
> > Where:
> > 
> > --pmu checks for KVM_CAP_ARM_PMU_V3.
> > --disable-mte is there because MTE is enabled automatically for a guest when
> > KVM_CAP_ARM_MTE is present.
> > --no-pvtime is there because pvtime is enabled automatically; no capability
> > check is needed, but the control group for pvtime is called
> > KVM_ARM_VCPU_PVTIME_CTRL.
> > 
> > What I'm trying to get at is that the name for the kvmtool command line option
> > matches KVM's name for the capability. What do you think about naming the
> > parameter --el2 to match KVM_CAP_ARM_EL2 instead of --nested?
> > 
> >  Also, I seem to remember that the command line option for enabling
> >  KVM_CAP_ARM_EL2_E2H0 in Marc's repo is --e2h0, so having --el2 instead of
> >  --nested looks somewhat more consistent to me.
> > 
> >  Thoughts?
> 
> I think --el2 describes the wrong thing. We don't only expose EL2 to a
> guest, but we also expose FEAT_NV2 by default. So "nested" is IMO
> closer to the effects of the capability. If anything, it is
> KVM_CAP_ARM_EL2 that is badly named (yes, there is some history here,
> but I'm not going to entertain changing the #define after 8 years).
> 
> Similarly, QEMU has "virtualization=on" as an indication that it
> should engage NV, and not "el2=on".
> 
> If you wanted a pure --el2 flag, then it should engage NV just like
                                                         ^^
							 EL2?
> --nested does, but disable FEAT_NV2 in the idregs. This would give you
> EL2 without recursive NV and HCR_EL2.E2H RES1.

That's a very interesting perspective. My comment was from the point of view of
what kvmtool does when the option is present - it sets the *_EL2 VCPU flag, not
what effect the flag has on a virtual machine.

I can see what you're saying, --nested looks fine.

Thanks,
Alex
