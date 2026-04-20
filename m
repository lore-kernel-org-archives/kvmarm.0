Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B464382372
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 09:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776677137; cv=none; b=BkFD+FZNvIYlRZCL4ENa5f9PVLgvi/GKYs6kRWAkgaUy4nmGiiIJq1AYhLTrfThWAv8GAyiLjnTgAu6ida03YTqInQSHhMo+yNwmg+tiYzPhUD4SGw3EuHFyEHX7xnZpvMYIXeXLxI/+vw1aYZMPpphByyR20HH4yanJ3xKESe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776677137; c=relaxed/simple;
	bh=5ZWOZ1Awo1Bodvdr+l3B4AZiQ8qH26M35oYmXaAHUv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npuT0b6Mw54kNdbFTIk+MEdtlqA8rHQ94GaA3q4gvLLJOM+ugjhxxmghTuG6v0s+wDrXRu1HiwdovVDCw22xtsjwKQUB++Yg0vuZYyuzpKGkebBYDprWMIMtryYTpH0kApHY2Lr3FlOJiwUpx+jq8y3sqjWVVlW8u18QqcmAACQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ALpasPjh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ALpasPjh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 379641516;
	Mon, 20 Apr 2026 02:25:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E7313F99C;
	Mon, 20 Apr 2026 02:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776677134; bh=5ZWOZ1Awo1Bodvdr+l3B4AZiQ8qH26M35oYmXaAHUv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ALpasPjhjV0gqvchFfs1EAe5rRLULKlsXeKfj1ATfwQzp6WzWZBQ2aDCGEfGSUc/S
	 gfOkngkAPTDcdZXjxUJ+xg2Mkt9V6Mr9y4V/XHG8VDq1z2SX3vxMXhrE/ivNyQ/Xje
	 TfHXgMa5noXysyjM7r2CEjXb2pGzRzI4e0MVq8CQ=
Date: Mon, 20 Apr 2026 10:25:29 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeXxCe4hdizdQbFD@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aeS4rAeVQ0yJIPYw@e129823.arm.com>
 <aeXp7WSqpXNytNPG@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeXp7WSqpXNytNPG@willie-the-truck>

Hi Will,

> On Sun, Apr 19, 2026 at 12:12:44PM +0100, Yeoreum Yun wrote:
> > Hi Marc,
> >
> > > On Sat, 18 Apr 2026 11:34:30 +0100,
> > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > >
> > > > > > @@ -2035,6 +2037,16 @@ static int __init ffa_init(void)
> > > > > >  	u32 buf_sz;
> > > > > >  	size_t rxtx_bufsz = SZ_4K;
> > > > > >
> > > > > > +	/*
> > > > > > +	 * When pKVM is enabled, the FF-A driver must be initialized
> > > > > > +	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
> > > > > > +	 * the FF-A version or obtain RX/TX buffer information,
> > > > > > +	 * which leads to failures in FF-A calls.
> > > > > > +	 */
> > > > > > +	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
> > > > > > +	    !is_kvm_arm_initialised())
> > > > > > +		return -EPROBE_DEFER;
> > > > > > +
> > > > >
> > > > > That's still fundamentally wrong: pkvm is not ready until
> > > > > finalize_pkvm() has finished, and that's not indicated by
> > > > > is_kvm_arm_initialised().
> > > >
> > > > Thanks. I miss the TSC bit set in here.
> > >
> > > That's the least of the problems. None of the infrastructure is in
> > > place at this stage...
> > >
> > > > IMHO, I'd like to make an new state check function --
> > > > is_pkvm_arm_initialised() so that ff-a driver to know whether
> > > > pkvm is initialised.
> > >
> > > Doesn't sound great, TBH.
> > >
> > > > or any other suggestion?
> > >
> > > Instead of adding more esoteric predicates, I'd rather you build on an
> > > existing infrastructure. You have a dependency on KVM, use something
> > > that is designed to enforce dependencies. Device links spring to mind
> > > as something designed for that.
> > >
> > > Can you look into enabling this for KVM? If that's possible, then it
> > > should be easy enough to delay the actual KVM registration after pKVM
> > > is finalised.
> >
> > or what about some event notifier? Just like:
>
> This seems a bit over-engineered to me. Why don't you just split the
> FF-A initialisation into two steps: an early part which does the version
> negotiation and then a later part which can fit in with whatever
> dependencies you have on the TPM?

Sorry, I may have misunderstood your suggestion and
I might be in missing your point.

But, The issue here is that FFA_VERSION, FFA_RXTX_MAP, and
FFA_PARTITION_INFO_GET, which are invoked from ffa_init()
as part of early initialisation, must be trapped by pKVM.

In other words, even the early part of the initialization,
including version negotiation, needs to happen after pKVM
is initialized.

Because of this dependency, simply splitting the FF-A
initialization into two phases within the driver does not
seem sufficient, as it still requires knowing when pKVM
has been initialized.

Am I missing something?

--
Sincerely,
Yeoreum Yun
