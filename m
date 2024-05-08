Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCE212BF34
	for <kvmarm@lists.linux.dev>; Wed,  8 May 2024 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715188464; cv=none; b=LxT/4hslfJ6fEoiQkL9BnPYzTNmSDn45O0Q/99oIBxfRI3DQ9lLjDy2xYta0huvgAaLcP6TpN6ml8QItf9OJOW75Yu3Ouu5d5VswCbZkb2bysdynNXOSr0Ze4ASJ6KTCpEKARrNiUMOHC6/oLjI40KtnFlZQohyMJO/91YtxItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715188464; c=relaxed/simple;
	bh=fuRuf/6hpCcW9619bjGX7+B4WNmLW4fCN4SeY8vzDaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHpZ1RIQ4gUNHf8qathaL+f9Gx35raJv9BpQIHw3Vb4agmDpDhTy16KzY4AqmPO6Epwgn1P6H/04/RugzyX/o87/pEe7EDkGOLeEEN3Vattkc5Z5Hil69043j25bZ9zkEhc9kolYCgP6ZqopGhdO4Zti7LG9ftjY4Tp5T4AnCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w07lPKs5; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w07lPKs5"
Date: Wed, 8 May 2024 12:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715188457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IxZhOPdDadbq2l7FGvhIKBCyvx+IxN2FVRGwktrREQ=;
	b=w07lPKs5zbpy7abTfb8Q0yigvYQbi2GYgcG1djv/eJ+3WV3bdZ5YLw4Ftbf2hNLvM1rEz1
	JcbgsIQ5+Ksfn4eT5O7OG+TvwpFmtPCzsVCxGBv4k22+EKjsG+OxK4prJFgflXvV9BpGLY
	71jfnpqFlqC4F/PepdW6fJhFyilGJI8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <Zjuy40shK5a-yp95@linux.dev>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
 <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
 <ZjPDQSeQPE2wgVup@linux.dev>
 <87jzk4h5ir.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzk4h5ir.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Cornelia,

On Wed, May 08, 2024 at 02:06:36PM +0200, Cornelia Huck wrote:
> On Thu, May 02 2024, Oliver Upton <oliver.upton@linux.dev> wrote:
> > I think (1) should only be expected of VMMs that want rollback safety,
> > i.e. the ability to migrate state back to an older kernel. Our userspace
> > initializes vCPUs from a fixed set of feature ID register values that
> > prevents VMs on new kernels from picking up new CPU features.
> >
> > It is quite tedious, but necessary as rollback safety is very much a
> > non-goal of the KVM UAPI.
> 
> Depending on your use case, rollback safety might be quite
> important... have we ever stated exactly which guarantees the KVM UAPI
> is giving? IOW, can someone implementing a VMM look at a doc and see
> "oh, if I want to be able to go backwards, I need to be able to deal
> with x, y, and z coming up on the new kernel"?

The behavior of KVM/arm64 has always been that new VMs get the maximum
set of vCPU features supported by KVM / hardware modulo the ones we
require explicit opt-in from userspace (e.g. SVE, vPMU). This behavior
is described in the arm64 vCPU feature documentation [1].

The biggest benefit of this approach is that new vCPU features can be
added without a VMM change, as userspace can just treat the registers in
KVM_GET_REG_LIST as an opaque blob of data that needs to be migrated.

I'm willing to wager that the set of users who want to migrate state
from kernel N -> (N - 1) know the exact CPU definition they want to
expose to the guest, and in that case should be using a static set of
feature register values matching their intent.

Beyond the CPU architecture, KVM presents hypercall features to the VM
which userspace can _opt-out_ of on a per-feature basis using the
feature bitmap registers described in [2]. Like the feature ID
registers, we've preallocated a range of indices to be used for
hypercall bitmaps. So if an unexpected bitmap register appears on a new
kernel, userspace should write 0 to it to prevent new features from
silently creeping in.

Prescribing the exact combination of these UAPIs to achieve a
rollback-safe feature set is beyond the scope of the KVM documentation
and should be determined based on the minimum kernel version that needs
to work.

[1]: https://docs.kernel.org/virt/kvm/arm/vcpu-features.html#the-id-registers
[2]: https://docs.kernel.org/virt/kvm/arm/hypercalls.html

> >> I've been bitten before with KVM differences between kernel versions
> >> in the past - where the number of registers that userspace sees has
> >> changed despite being on the same hardware.
> >
> > This is intended behavior, as VMs are initialized to the maximum feature
> > set KVM is able to support. Forward-compatibility for the set of exposed
> > registers is tested, see the get-reg-list selftest.
> 
> I've seen this problem come up as well; if it is clear that this is
> something that KVM expects the VMM to handle if needed, that is fine;
> should we consider "it's tested in a selftest" as a canonical indicator
> of "this is what KVM supports compatibility wise"?

It certainly is the level of compatibility that gets actively tested :)

The canonical reason for this behavior, though, is that KVM/arm64
defaults to the maximum-possible feature set as discussed above.

-- 
Thanks,
Oliver
