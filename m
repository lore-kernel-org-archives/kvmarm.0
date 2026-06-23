Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477C3B6347
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 07:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782200851; cv=none; b=uKPUAMUrgMjftcdWY7wZnep5H44v/0+De2AWcl82mBxuUQ7LEh8GNiMgqgtRpWEfQQzx769xgB/N3KkStd+DSgcjkMNitiNZ9Z/UU9nEyIlF0XssK41fpv/WADajWxKr2drKhViqn/9n1R52z/ycW/NnFeX3hs9X6KGFw2/xTck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782200851; c=relaxed/simple;
	bh=pb/y3OHpId8gRg21e98iHl/w2OyFbj6DK2ruwWVF5ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paQRZ008Oj72M3xMYz+ah6LrzdmWRm4IAG8GVN28Bz7Exzc/m+9z+OmMHvSExs9o0GXWLYVc8MCoHEaC8D9vKWrL20tqjiJNjtX607/3jKLR313FouTY2svKsXFylWFYpvhghZlcJdu5OjIOu7EIkDekMVNnsB4+tD4TaK+xUcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=MUpYTiBr; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="MUpYTiBr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1782200848; x=1813736848;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pb/y3OHpId8gRg21e98iHl/w2OyFbj6DK2ruwWVF5ws=;
  b=MUpYTiBrCMF2pfKyhOcE+1rHVNoHMjmTOMvvRyBghVT9W9CoaBVLaxLW
   02oC9XNFCVEpUg5Dx+vch9D8bYJ1MV9eNVImSkcbxSje2/nWlSVg1m5lD
   EhXwglMIT12Z2VrsX8LGCYJ2uwphWvS6UNzxXySnilHWyw5r+3hTLAF8j
   OaqyjUq95njIQIZKtWBWlZg5sVldWQDoJyP29UgSgcmyEAwElWnumU6Az
   olsWDJF6d43KwnV9W+V32h+A1I6d9y6uRbHDthGnd8u2yIBS8u/Ez3ATR
   DoN7AIgFPbqr5eNmr6ycmia4Ad/KslaFCFQPD1POxlBNPHiiajbaNbSI7
   g==;
X-CSE-ConnectionGUID: omf9mwa5QNW8AzDzjOt1Zg==
X-CSE-MsgGUID: RzLmkXydSjaebRYBR9Pe9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="245040386"
X-IronPort-AV: E=Sophos;i="6.24,220,1774278000"; 
   d="scan'208";a="245040386"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 16:46:17 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 0A605C00224
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 07:46:17 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id B1A4A829CC3
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 07:46:16 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom4.fujitsu.com (Postfix) with ESMTPS id 7455F20000F4;
	Tue, 23 Jun 2026 07:46:12 +0000 (UTC)
Date: Tue, 23 Jun 2026 16:46:09 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <ajo5wUzh0usQTXMk@sm-arm-grace07>
References: <20260510145338.322962-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510145338.322962-1-weilin.chang@arm.com>

Hi Wei-Lin,

On Sun, May 10, 2026 at 03:53:33PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v3 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.
> 
> Two new preparatory patches are added, one reduces a hole in kvm_s2_mmu
> and another refactors the code a bit during s2 faults. Other changes are
> listed below.
> 
> * Changes from v2 [1]:
> 
>   - Removed "polluted" teminology.
> 
>   - Use xa_{mk, to}_value() when storing and retriving values from maple
>     trees.
> 
>   - Avoid using the 63rd bit in maple tree values so that xa_{mk, to}_value()
>     does not lose us a bit.
> 
>   - Added reverse map removal during TLBI handling.
> 
>   - Other suggested refactorings.
> 
> Thanks!
> 
> [1]: https://lore.kernel.org/kvmarm/20260411125024.3735989-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (5):
>   KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
>   KVM: arm64: Move shadow_pt_debugfs_dentry to reduce holes in
>     kvm_s2_mmu
>   KVM: arm64: nv: Avoid full shadow s2 unmap
>   KVM: arm64: nv: Remove reverse map entries during TLBI handling
>   KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
>     removal
> 
>  arch/arm64/include/asm/kvm_host.h   |  17 +-
>  arch/arm64/include/asm/kvm_nested.h |   6 +
>  arch/arm64/kvm/mmu.c                |  43 +++--
>  arch/arm64/kvm/nested.c             | 238 +++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.c           |   3 +
>  5 files changed, 290 insertions(+), 17 deletions(-)

While investigating the long VM teardown time on QEMU in the nested shadow 
stage 2 selftest, I instrumented a few functions with bpftrace.

The same kselftest workload produced the following counts:

Without this series (today's kvmarm/fixes):

kvm_nested_s2_unmap: 12
kvm_pgtable_stage2_unmap: 8,388,623
kvm_tlb_flush_vmid_range: 8,388,623
exit_vmid_context: 8,388,639

With this series:

kvm_nested_s2_unmap: 12
kvm_pgtable_stage2_unmap: 18
kvm_tlb_flush_vmid_range: 18
exit_vmid_context: 34

The bpftrace script used was:

#!/usr/bin/env bpftrace

fentry:kvm_nested_s2_unmap
{
    @nested = count();
}

fentry:kvm_pgtable_stage2_unmap
{
    @pgunmap = count();
}

fentry:kvm_tlb_flush_vmid_range
{
    @flush = count();
}

fentry:exit_vmid_context
{
    @exit = count();
}

END
{
    print(@nested);
    print(@pgunmap);
    print(@flush);
    print(@exit);
}

Is this consistent with what you evaluated during the development?
I wonder if this is good for nested guest boot paths too.

Thanks,
Itaru.

> 
> -- 
> 2.43.0
> 
