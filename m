Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610B35BDDB
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 23:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783984328; cv=none; b=YshQuljTjaxEDJihufp5VRhwhuFdJ4Wb1yh83sbdQzrm+AH9ez+sNo760MBdBMZZGB3mdZ3rsMngf2KCk6wmyJfHVQLtaYVfzGIvi2VB8ygh2EGiBhrphUB0+aOHJ0ki37k66L5ZMHf/NrCTtSX7pjUPMwNY789Fi/+eb56hOAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783984328; c=relaxed/simple;
	bh=X/x4D83R5gsU8E1CkKaiYFFPJM0xUUgh7oB69MucA88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPKi5i5oeTmkhY2XggqfDteAjVKY5vassttRAzMfkzClp1P3VhuT1+I2uwR0QBoGadW/03X/16YavM1vWIA6yAYDYjUo76UXa3zW01T15oHpM1Vsut1FPj/XEbqmRUARvWcP8k66uBeVpNu+ZPapanjY9rJwlrAwnwkair7ZIHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=L36Eg/EM; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="L36Eg/EM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783984328; x=1815520328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X/x4D83R5gsU8E1CkKaiYFFPJM0xUUgh7oB69MucA88=;
  b=L36Eg/EMlvPxFSQJge5ob6mzwNEwzWFsaUkQtxpS0keXhKZMX5qki1rK
   TgsnBeiLdu0yg3QdmkQ1ZoWt/oR2qIUTm7RudYYnVR1EHMbXebvotFsx9
   PiMiS1AFCYQJXZVKiYEp2ewg4R3NGVDosxto8QiR2hDksxg5mdaL1Wada
   12mbFtI8vQ8xu4KgxutlDXleD2OXSBdM4oLwkGATcEEk255Gv5v6j2CsR
   JAJsv8FaazxKf19itRlgHAAi9giFzUWk67Xo7MqE5l2bfgtyDN1Yezqqb
   3oFuBB1Lk4ESpSOgbwj0a9fcSKE4AkuV8PpGyCa85bD7/vRZuqbcZGVzy
   A==;
X-CSE-ConnectionGUID: 3aC0tUXCRrSNFC5r8DnoTw==
X-CSE-MsgGUID: nmCBFCoCRF6+/EKZGHgkZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="247198773"
X-IronPort-AV: E=Sophos;i="6.25,154,1779116400"; 
   d="scan'208";a="247198773"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:10:57 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id EB5731002BB2
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 23:10:55 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id A339D831C75
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 23:10:55 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTPS id B88A718004EA;
	Mon, 13 Jul 2026 23:10:51 +0000 (UTC)
Date: Tue, 14 Jul 2026 08:10:48 +0900
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
Message-ID: <alVweBtKt_4jH1q3@sm-arm-grace07>
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

Hi Wei-Lin
As this series is no longer cleanly applied on top of the recent kvmarm/fixes,
I wonder if you could update the series; I can wait if you're in the
works of preparing v4. I am planning to test this series on HW with your
proposed nested virtualization KVM selftests.

Thanks,
Itaru.

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
> 
> -- 
> 2.43.0
> 
