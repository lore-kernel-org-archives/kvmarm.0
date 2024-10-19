Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001D16A92E
	for <kvmarm@lists.linux.dev>; Sat, 19 Oct 2024 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729361619; cv=none; b=L1X5bm40rkxOZOuzh017qc6ITNXqhK0r2hUohMVTkSvxq9bv/UMabaoLMOO2bfwAAsOsfY94OZRcMbX52YZzQN7diHbx7oyZzGpaHFGs0DjBL+4tPCUWE3MngDyAue+VguIu6nFtMwBrxCqztX3v44dpeKCJya+kVIlD7GOhBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729361619; c=relaxed/simple;
	bh=gv/Fc3K2etqb3T5ihWl4mkBfiR4mgcXvoDPJyHXkzoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIhZlYLH5A+kAd5fv++2bmyJbMJawu7lk36nfiMD3hq8SFfj2yxJ0xf1JXzYHtg+TDfsxZNKlZFZljrh0bp5WlzVdOot0agHFlC/03zQDql914F0hM3HWihDbR3lc5xa26sBrgxuBEwDPQv5v80q68DSZNghQNA5qazmR/jpw/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2NTHUPH; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2NTHUPH"
Date: Sat, 19 Oct 2024 11:13:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729361615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6VuaQrZ4FuiIb3nOlt5Tbznvi9XZK+qQbtHOMZTcWQ8=;
	b=f2NTHUPHtkSFmeeT/vX/tBppGgpbZ75HxYjVHe5SN2iKBRTfegrPDN3ohGWaBWsClImb9b
	0AJMnXMRQgr+tlAx86a8B68XWLX2Ko4vsTly1wjT4J36IdxqtgqgbtaRf54zAN/8CZzrgn
	cmBfnIjs0UJ9xM99kg+Fh5WEX6lC1qo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Don't retire aborted MMIO instruction
Message-ID: <ZxP2yCs5IkFznpER@linux.dev>
References: <20241018194757.3685856-1-oliver.upton@linux.dev>
 <20241018194757.3685856-2-oliver.upton@linux.dev>
 <87zfn0tq4z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfn0tq4z.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 19, 2024 at 10:10:04AM +0100, Marc Zyngier wrote:
> On Fri, 18 Oct 2024 20:47:56 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Returning an abort to the guest for an unsupported MMIO access is a
> > documented feature of the KVM UAPI. Nevertheless, it's clear that this
> > plumbing has seen limited testing, since userspace can trivially cause a
> > WARN in the MMIO return:
> > 
> >   WARNING: CPU: 0 PID: 30558 at arch/arm64/include/asm/kvm_emulate.h:536 kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
> >   Call trace:
> >    kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
> >    kvm_arch_vcpu_ioctl_run+0x98/0x15b4 arch/arm64/kvm/arm.c:1133
> >    kvm_vcpu_ioctl+0x75c/0xa78 virt/kvm/kvm_main.c:4487
> >    __do_sys_ioctl fs/ioctl.c:51 [inline]
> >    __se_sys_ioctl fs/ioctl.c:893 [inline]
> >    __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
> >    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> >    invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
> >    el0_svc_common+0x1e0/0x23c arch/arm64/kernel/syscall.c:132
> >    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
> >    el0_svc+0x38/0x68 arch/arm64/kernel/entry-common.c:712
> >    el0t_64_sync_handler+0x90/0xfc arch/arm64/kernel/entry-common.c:730
> >    el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> > 
> > The splat is complaining that KVM is advancing PC while an exception is
> > pending, i.e. that KVM is retiring the MMIO instruction despite a
> > pending external abort. Womp womp.
> 
> nit: *synchronous* external abort.

Doh!

> > +static inline bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
> > +{
> > +	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
> > +		return false;
> > +
> > +	if (vcpu_el1_is_32bit(vcpu)) {
> > +		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
> > +		case unpack_vcpu_flag(EXCEPT_AA32_UND):
> > +		case unpack_vcpu_flag(EXCEPT_AA32_IABT):
> > +		case unpack_vcpu_flag(EXCEPT_AA32_DABT):
> > +			return true;
> > +		default:
> > +			return false;
> > +		}
> > +	} else {
> > +		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
> > +		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
> > +		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
> > +			return true;
> > +		default:
> > +			return false;
> > +		}
> > +	}
> > +}
> > +
> 
> Is there any advantage in adding this to an otherwise unsuspecting
> include file, given that this is only used in a single spot?

v0 of this was a bit more involved, which is why I had this in a header.
I'll move it.

> Otherwise looks good to me!

Thanks!

-- 
Best,
Oliver
