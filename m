Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97EE39A809
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682629; cv=none; b=EQybMJudmgI6lFPBtE0vwhroeESfqKnMPmqfcOlbcjujVDHKg1b+n5ShM5WfTH7WSCKj2qd6+4nlNSt2joPew1Et+9dGwldbg9n8N4EGXeLPeVtUIl2615YfRZrOxMsmDAh3/Ta+aIFr2XjSZ8BX5NjnPjfoPUjVVlS7L+BKMdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682629; c=relaxed/simple;
	bh=6spWy4cZ5LIkgxrKvT0wpryraTDPauWyjcaqW8EhKV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGJQ7mkfU7VOclW9r/+W1UTpLDcpRRuLdVUGkFXt5koIkTz3L2Jjbnd1iF1T2y1ICDLzvxItuwL5368oHo7PkxEkVZ+4vrvVV7E2Ludmj05ElIIm1OTezrRo4v6R6n6OpRNqNnaHrW30Zgh7P/vZgZXOwqDFLe0QieUgcWNDBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hda34m4S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hda34m4S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D49C1516;
	Mon, 20 Apr 2026 03:57:00 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B02B23F915;
	Mon, 20 Apr 2026 03:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776682625; bh=6spWy4cZ5LIkgxrKvT0wpryraTDPauWyjcaqW8EhKV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hda34m4SzJsVSkEKltIcJWEGLr3S4qW+w/s0SgWkRrut9wsjHniF2zX731bi9s0Vs
	 rp2cYWorUS56cC+GYeEdb1C2omfhkFNujgWPCEcRBGIwusPT37nqQ+0vGsbQH7Aask
	 5+/rs+cyn2Dpi07AFu0N62nv58+LBUIEVnVSeWJc=
Date: Mon, 20 Apr 2026 11:56:58 +0100
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
	catalin.marinas@arm.com, sebastianene@google.com
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeYGeojpqcYAN5++@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aeS4rAeVQ0yJIPYw@e129823.arm.com>
 <aeXp7WSqpXNytNPG@willie-the-truck>
 <aeXxCe4hdizdQbFD@e129823.arm.com>
 <aeYDMEgWdt8F9jWb@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeYDMEgWdt8F9jWb@willie-the-truck>

Hi Will,

> [+Seb for the pKVM FFA bits]
>
> On Mon, Apr 20, 2026 at 10:25:29AM +0100, Yeoreum Yun wrote:
> > > On Sun, Apr 19, 2026 at 12:12:44PM +0100, Yeoreum Yun wrote:
> > > > > On Sat, 18 Apr 2026 11:34:30 +0100,
> > > > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > > > >
> > > > > > > > @@ -2035,6 +2037,16 @@ static int __init ffa_init(void)
> > > > > > > >  	u32 buf_sz;
> > > > > > > >  	size_t rxtx_bufsz = SZ_4K;
> > > > > > > >
> > > > > > > > +	/*
> > > > > > > > +	 * When pKVM is enabled, the FF-A driver must be initialized
> > > > > > > > +	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
> > > > > > > > +	 * the FF-A version or obtain RX/TX buffer information,
> > > > > > > > +	 * which leads to failures in FF-A calls.
> > > > > > > > +	 */
> > > > > > > > +	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
> > > > > > > > +	    !is_kvm_arm_initialised())
> > > > > > > > +		return -EPROBE_DEFER;
> > > > > > > > +
> > > > > > >
> > > > > > > That's still fundamentally wrong: pkvm is not ready until
> > > > > > > finalize_pkvm() has finished, and that's not indicated by
> > > > > > > is_kvm_arm_initialised().
> > > > > >
> > > > > > Thanks. I miss the TSC bit set in here.
> > > > >
> > > > > That's the least of the problems. None of the infrastructure is in
> > > > > place at this stage...
> > > > >
> > > > > > IMHO, I'd like to make an new state check function --
> > > > > > is_pkvm_arm_initialised() so that ff-a driver to know whether
> > > > > > pkvm is initialised.
> > > > >
> > > > > Doesn't sound great, TBH.
> > > > >
> > > > > > or any other suggestion?
> > > > >
> > > > > Instead of adding more esoteric predicates, I'd rather you build on an
> > > > > existing infrastructure. You have a dependency on KVM, use something
> > > > > that is designed to enforce dependencies. Device links spring to mind
> > > > > as something designed for that.
> > > > >
> > > > > Can you look into enabling this for KVM? If that's possible, then it
> > > > > should be easy enough to delay the actual KVM registration after pKVM
> > > > > is finalised.
> > > >
> > > > or what about some event notifier? Just like:
> > >
> > > This seems a bit over-engineered to me. Why don't you just split the
> > > FF-A initialisation into two steps: an early part which does the version
> > > negotiation and then a later part which can fit in with whatever
> > > dependencies you have on the TPM?
> >
> > Sorry, I may have misunderstood your suggestion and
> > I might be in missing your point.
> >
> > But, The issue here is that FFA_VERSION, FFA_RXTX_MAP, and
> > FFA_PARTITION_INFO_GET, which are invoked from ffa_init()
> > as part of early initialisation, must be trapped by pKVM.
> >
> > In other words, even the early part of the initialization,
> > including version negotiation, needs to happen after pKVM
> > is initialized.
> >
> > Because of this dependency, simply splitting the FF-A
> > initialization into two phases within the driver does not
> > seem sufficient, as it still requires knowing when pKVM
> > has been initialized.
> >
> > Am I missing something?
>
> Ah sorry, I mixed up the ordering of 'module_init' vs 'rootfs_initcall'
> and thought you wanted to probe the version earlier. But then I'm still
> confused because, prior to 0e0546eabcd6 ("firmware: arm_ffa: Change
> initcall level of ffa_init() to rootfs_initcall"), ffa_init() was a
> 'device_initcall' which is still called earlier than finalize_pkvm().

Right, and this is what I missed when writing patch
0e0546eabcd6 ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall").
and it still exists even if it's device call.

However, rather than changing ffa_init to rootfs_initcall, moving ima_init
to late_initcall_sync is a better approach, as it also addresses similar
issues for TPM devices that do not use FF-A. For this reason,
the FF-A-related changes were reverted.

As a result, patch 4/4 addresses an issue that existed independently of
0e0546eabcd6, as you pointed out.

--
Sincerely,
Yeoreum Yun
