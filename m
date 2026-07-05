Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287CE1DB95E
	for <kvmarm@lists.linux.dev>; Sun,  5 Jul 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783272540; cv=none; b=E3q+Oh4N0nmX4mH7IcdEvamxSdlPNVGFir/thUhLFgF3LrxjOA8hV3HW4J0AXTxzX+zAe7KfvX4/Zxx1zjLR7U/WdmpLZhSg3AuHq39GQmeElN36jVVeFV1L0v81wPHgkn2YHuV8ie7dLzepmTJKEIBPX/JifrJ/ECllXlSZn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783272540; c=relaxed/simple;
	bh=Nn0UY7IDrPjzK/lXT6hguEQXCE8OQUIxdHe1hkL3bKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxxgaZKJ6aOxaeTwB6Tki7gtgmuv+glj4/v9pPyIzy0+2cEHpNqvHXAZVBeqUsqaTGDiEuv4Mz8ee5FregWsvSvnNqrjP5O5NMMu/C/TbBh/Iz+tVUrBH8+icVwV866+wdakiXcsJHl29oQlS13JlDesU3FktefYKjeEjYqXAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UhAXijQp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UhAXijQp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 211DC1D31;
	Sun,  5 Jul 2026 10:28:53 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7F823F85F;
	Sun,  5 Jul 2026 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783272537; bh=Nn0UY7IDrPjzK/lXT6hguEQXCE8OQUIxdHe1hkL3bKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UhAXijQpiBPuV/526F+dgHXeewqd+rhE/0ewe7SMKY2NdsUbGa3MDQarqJqwajpoW
	 gob92GGdy8vh446kYIK1GNLd0ujz4aqmZLrINbKA8uyKC3puWkFsJwRkoFaH2MC9+6
	 MMD4uYgBBwDIkCkphsL5mdaZopYvLGNU6eaDljFU=
Date: Sun, 5 Jul 2026 18:28:36 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Tangnianyao <tangnianyao@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: "guoyang (C)" <guoyang2@huawei.com>, 
	"huanglingyan (A)" <huanglingyan2@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
Message-ID: <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>

Hi,

Let me try to answer this:

On Sat, Jul 04, 2026 at 03:45:56PM +0800, Tangnianyao wrote:
> Hi, all
> 
> I'm trying to understand the TLB and I-cache invalidation in
> `kvm_arch_vcpu_load()` that is intended to "guarantee that both TLBs and
> I-cache are private to each vCPU".
> 
> As I understand it, when `VTTBR_EL2.CnP == 1`, `__kvm_flush_cpu_context()`
> only performs a local TLB and I-cache invalidation, which does not seem
> sufficient to guarantee that property.
> 
> In fact, even if the invalidation were extended to the Inner Shareable
> domain, it still seems difficult to guarantee “TLBs and I-cache are
> private to each vCPU”, when `VTTBR_EL2.CnP == 1`, as long as multiple
> vCPUs from the same VM may be running concurrently on different PEs.

I think you have missed that when 2 stages are involved, both stages
have to set CnP == 1 in order to share TLB entries (Arm ARM R_ZVRZW).
So if TLB entry sharing happens, the guest kernel must have allowed it
in the first place (by setting TTBR0/1_EL1.CnP == 1), hence accidental
sharing that you are worried about won't happen.

__kvm_flush_cpu_context() is solving problems that occur when multiple
vCPUs of a VM are multiplexed on a single physical CPU.

> 
> So I have two questions:
> 
> 1. What is the rationale behind the comment that "guarantee that both TLBs
> and I-cache are private to each vCPU"?

I assume you are asking why keeping both TLBs and I-cache private per
each vCPU is required. The fundamental answer is that each physical CPU
is expected to have its own TLB and I-cache, so we must uphold that
property for vCPUs as well. vCPUs can be scheduled on the same physical
CPU, and use the same physical TLB/I-cache, obviously, so extra
invalidations need to be done.

As for how this can go wrong without __kvm_flush_cpu_context(), you can
look at commit 94d0e5980d67 ("arm/arm64: KVM: Perform local TLB
invalidation when multiplexing vcpus on a single CPU") and commit
01dc9262ff57 ("VM: arm64: Ensure I-cache isolation between vcpus of a
same VM"). The commit messages and the linked thread explained the
problems pretty well for me.

> 2. Should the effect of `VTTBR_EL2.CnP` be taken into account when
> reasoning about this guarantee?

Please see the first part of the answer.

Hope this helps!

Thanks,
Wei-Lin Chang

> 
> Thanks
> Nianyao Tang
> 
