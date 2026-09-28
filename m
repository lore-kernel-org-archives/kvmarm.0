Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D7D49E5F3;
	Mon, 28 Sep 2026 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616518; cv=none; b=krhiwZCWwhi8dRDS0+2AR+T4eeE7kA4z6N5WE2lKGU5PWzeB8ILxM+dHxPer42ZsixUf/FK1Nu328TORoi5hX3J81ZTax262uwIKCyNWC0+I7/sbmjoa/GVwMFVyHDSQoMMzrP1+uTxYLqiCVQq5SQVFSc8KP7CTNVWPVZ8fRXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616518; c=relaxed/simple;
	bh=NOwlg1fLIhsJpwRRWJEx28YKpYmKtZ7WGDsI1WtfweU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJCnP9lWKVGEAg5TiEWRj4/9PGIzcaqc7lUvzTjAvL6x//QWM87ueAiICAsZVsiGghmLbWyXU5/rNfPmN/RpDXbIloeyB6AjZplHSk/3hC8KJyexAXwsDCeSU5sDXx7X6+8wNHM7vn274bbQs4ZPdBxF2AXLw9jC/Xy/dVH/3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JYxAo8jR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JYxAo8jR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4497D1655;
	Mon, 28 Sep 2026 10:28:32 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B4EC3F763;
	Mon, 28 Sep 2026 10:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790616515; bh=NOwlg1fLIhsJpwRRWJEx28YKpYmKtZ7WGDsI1WtfweU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JYxAo8jR8/FlcEOgF0lfNeAhVBe1YM6gGqbAJOGgGoAcD5TwzeszFXE3Luz4YDa0X
	 Ii/FE5eavzr3+dGKMrbQA2TWWA6/IxxcwbgeXhtUiWM9WbdL+yBH7ESoJ6RA3MNwWo
	 qBK3Y8YEHYJu6sms16eIB8qUYi/47RJEbNZY0ywA=
Date: Mon, 28 Sep 2026 18:28:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
	Gareth Stockwell <Gareth.Stockwell@arm.com>
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Message-ID: <arqjteW-Y5u2XX2r@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
 <arozNIQ-fQ0XQViI@arm.com>
 <4fabad44-280f-40e6-95bb-49011cd2f185@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fabad44-280f-40e6-95bb-49011cd2f185@arm.com>

On Mon, Sep 28, 2026 at 11:13:39AM +0100, Suzuki K Poulose wrote:
> On 28/09/2026 10:28, Catalin Marinas wrote:
> > On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
> > > +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> > > +{
> > > +	struct arm_smccc_1_2_regs *regs = &sro->regs;
> > > +	bool cancelled = false;
> > > +	unsigned long sro_handle;
> > > +
> > > +	rmi_smccc_invoke(regs);
> > > +
> > > +	sro_handle = regs->a1;
> > > +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
> > > +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> > > +		int ret = 0;
> > > +
> > > +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> > > +		case RMI_OP_MEM_REQ_NONE:
> > > +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> > > +					regs);
> > > +			break;
> > > +		case RMI_OP_MEM_REQ_DONATE:
> > > +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> > > +					     gfp);
> > > +			break;
> > > +		case RMI_OP_MEM_REQ_RECLAIM:
> > > +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
> > > +			break;
> > > +		default:
> > > +			WARN_ON_ONCE(1);
> > > +			ret = -ENXIO;
> > > +			break;
> > > +		}
> > 
> > Another thing I came across while looking whether we can defer the
> > activation. It seems that the spec (I_JVYCH) lists some SROs as
> > PE-bound. Nothing here or in rmi_sro_execute() disables migration and
> > the memory allocation paths can even sleep with GFP_KERNEL.
> 
> No, this is not required. I agree this is confusing. I will get it
> clarified.
> 
> So, there are two different sources for the SRO contexts. One is a global
> pool and the other an Object.
> 
> e.g., For an RMI operation on an Object, SRO context can be the object
> itself (e.g., REC_CREATE, REALM_ACTIVATE etc.)
> 
> However, when there is no reliable object for the command (e.g.,
> RMI_GRANULE_RANGE_DELEGATE), the RMM must allocate a context from
> the global pool. Now, the "PE" in there comes from a recommendation
> to the RMM implementations, that the global pool size must depend on
> the number of PEs on the system. This doesn't mean that the SRO
> handles are only bound to those PEs. I will get this clarified
> in the RMM spec.

This part of the spec needs rewriting, not clarifying. No matter how
hard you try, there's no way you can read it as a "global pool". For
example:

D_GZLMRA	SRO context is bound to one of the following:
		  - A PE
		  - An RMM object

And take a random command:

B4.5.2 RMI_DPT_L0_CREATE command
	Create a Level 0 DPT.
	The RMI_DPT_L0_CREATE command may initiate a Stateful RMI
	Operation whose context is bound to the current PE.

"bound to the current PE" pretty clearly shows the intention was to
disable preemption. It also doesn't say what happens when this pool is
exhausted (presumably it returns RMI_BLOCKED).

TBH, that's a pretty significant change for a bet3/4 release, though
arguably it can be seen as a relaxation. Code that relies on disabling
preemption should still work (somewhat, assuming the global pool is at
least the number of PEs and the host plays nicely to complete or cancel
all SROs).

That said, such pool is a limited resource and we need some way to probe
its size if we want to do something smarter in the kernel, like a
semaphore to ensure we don't randomly fail because of an RMM limitation.
I don't really see how the number of PEs is relevant to this global
pool sizing, it's not that we limit the realms we can start to the
online CPUs.

-- 
Catalin
