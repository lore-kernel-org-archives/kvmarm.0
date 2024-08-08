Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C7880C13
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723141895; cv=none; b=H3aa9O8b/5gdmbURCC8gDIJqY5It/6Jh1yQpqWK0ZLK4B1DyaSYB07dytl0+E6/RC2LEBlrRDkBP/b8nEtl1Mxt989rNwSYK1jSKRCOYS2pHnFB/QWsOc7HnWEUepXm5NW60atILakD5wQ65h8DPWxtQT65+WdroafVEyP/WLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723141895; c=relaxed/simple;
	bh=hAd5wPQ+HEnNgjAlvK80xNJSgDb+C4pUScPMcooggzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGOdtimVDb5kaQZYgbDN1EcAZpah5cmAhO3dzf9lSYNJJnpAgyM8MseF091tpa0t6PdSJd/Gw2cMzg6uC7VFVGHZmMRdbZyrWAVIgmsFp77k39MbKCwl7X/E+3CBRZg0R/MuujERCqXWR/m1zDq3SOwjxl27HEtV9dXCKjPWFxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P35qKX3j; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P35qKX3j"
Date: Thu, 8 Aug 2024 18:31:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723141890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MCEvSa1rci8lOZvwzCzc6u9Pm8Tp4sCjT5NtOCzDNF0=;
	b=P35qKX3jpcNrEiDjJ3mJ+K9wSyV6ibp3BE01cQLuPeHycT2wFJnnUtA+olTGhaHhLD2HR8
	PzCBUBbmj1+FZn68ZBJHSkg5Waj9XWqj9eMVh7pqoemZ5fwbGxmK5ptAF20yQ2LxCFO3L5
	Z9GcCxjDnHpDebH+qgA3uocWlvwJ3aQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Disable OS double lock visibility by default
 and ignore VMM writes
Message-ID: <ZrUO_RG6a9We7neT@linux.dev>
References: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
 <ZrUC5O8XUuvlLJcc@linux.dev>
 <f81365c28d1b4ae1a5e9c2345d24b2c7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81365c28d1b4ae1a5e9c2345d24b2c7@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 08, 2024 at 06:10:33PM +0000, Shameerali Kolothum Thodi wrote:
> > I find myself asking *why* we need this, could you share some details
> > on the issue you're encountering?
> 
> Sorry, I missed the why part. Mainly for VM migration purposes as we have systems
> with DoubleLock implemented and not implemented(with DebugVer 8.2).

Ah, got it, thanks for the context.

> > 
> > Indeed, RAZ/WI is not a faithful implementation of FEAT_DoubleLock, but
> > I wouldn't expect it to be used in a VM in the first place.
> > 
> > On Thu, Aug 08, 2024 at 01:57:11PM +0100, Shameer Kolothum wrote:
> > > KVM exposes the OS double lock feature bit to Guests but returns
> > > RAZ/WI on Guest OSDLR_EL1 access. Make sure we are hiding OS double
> > > lock from Guests now. However we can't hide DoubleLock if the reported
> > > DebugVer is < 8.2. So report a minimum DebugVer of 8.2 to Guests.
> > 
> > What if a user wanted to virtualize an exact CPU model that only
> > implemented v8.0?
> 
> Yeah. I was a bit concerned as mentioned below of bumping up DebugVer to 8.2.
> But then I found a similar attempt you made a while back,
> https://lore.kernel.org/linux-arm-kernel/20211029003202.158161-1-oupton@google.com/T/#meee94d87db3f8042156557dbf9743bb03cf0aaa9

Using my own crap patches against me, drat! :-)

In all seriousness, this has since been resolved with the 'writable' ID
register infrastructure and corresponding changes raising the max
possible debug arch to v8.8. DebugVer will match the HW value up to
v8.8, but userspace can 'downgrade' the feature by writing a lesser
value.

So in the case of cross-system migration, the old value is still
accepted by KVM + advertised to the VM.

> > 
> > > All this may break migration from the older kernels. Take care of
> > > that by ignoring VMM writes for these values.
> > 
> > Ignoring userspace writes is a pretty big hammer. In situations where
> > KVM had advertised a feature that was outright not supported (e.g. IMP DEF
> > PMUs) it _might_ make sense. But with this change we're messing with a
> > CPU feature we *do* support.
> 
> The concern here is for the DebugVer I guess.

Indeed.

> But if VMs are not making use of any 8.0 specific features(as I understand it,
> only external debugger support is the difference), then is that an issue?

You're absolutely right to point out that v8.0 -> v8.2 doesn't change
anything from the VM's POV.

My concern is that the guest does not anticipate ID registers changing
values at runtime, and we should only reach for that big hammer if we
(KVM) have done something truly stupid.

Which never happens, of course :)

> > Would allowing userspace to downgrade ID_AA664DFR0_EL1.DoubleLock to
> > 0b1111 be enough?
> 
> Yeah. Could I guess. But then we need to check the DebugVer matches to 8.2 or not
> as well.

Eh, I don't think that KVM needs to be policing the VMM for total
compliance with the architecture. What's far more important is
guaranteeing the selected CPU feature set is a subset of what KVM
virtualizes.

So even though the architecture says

  !FEAT_DoubleLock && !FEAT_Debugv8p2

is not allowed, it isn't a problematic configuration for KVM. Still,
the defaults from KVM should still comply with the architecture as
closely as possible.

> Idea was, is there any point in exposing  features that are not supported or used
> by VMs in the first place.

And I generally agree, but the need to churn other fields to get to a
sane starting point gave me a bit of pause.

Would you be willing to cook up a patch that just opens up the
DoubleLock field to downgrades?

-- 
Thanks,
Oliver
