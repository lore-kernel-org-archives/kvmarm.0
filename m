Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C9E2566D3
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 07:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779262284; cv=none; b=fBBirNbJoSsqoTGTedP7C4FaCezXVKznDoG51oHVR9mwynMF2uJuQkxh1maD/wG44Lf7de2zV2rVj1T2U5eTbuwsp/7IsEb7mCdwvJzwI1vqiSST0mGt/xEbH5JQJ6h/fgE8xbzMZFVvcQL1PGHSobYTGR/19927iFbiYRoCnUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779262284; c=relaxed/simple;
	bh=3E0wRnExgvvSMI/XFpx5dzXw0vlKkYMdNcB4WowrgL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2TU1UXRV+n8eDem3s81kh9yyitD14V4WdaWJlIQ/ZggoDTJVwsW4yuNjdSbUcMDmNt0HOKu1hft2azkvKs4SK0cPnYYV7Vzk/QVRem/yV/PbYF2nhDrjGVxJo1klEEyTgnH4tOlzmoBgILkwGvh28srWtXpy5hp4ez6pMluhZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=RTAMDGZ4; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="RTAMDGZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779262283; x=1810798283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3E0wRnExgvvSMI/XFpx5dzXw0vlKkYMdNcB4WowrgL8=;
  b=RTAMDGZ4KsRddqyx91ZoxUMdXv2EsrVf4iIYIaTs0UMVAoPVZn1E3wYQ
   Ws19ohLIfDXBlmRQz0eHyxbhZBQZb5PQxp2SfdVxSck4g4P0xRNGfl7d1
   kPP8jf+oZC4+9AL/s7yAmm9TRrjtfxA8B+0c2J5ycWc3cdk+NyADIjeH0
   avO8TyYHqMh+sU1+8c4elUqJPUW/cGM6/aLkMUcGI4jky7Adoq+PoiiyK
   79OIzMPTvZ711uLE7cUTnN1KFp6z9QGB5/Q1H64aKethZM/5H2qcuP360
   sjTlvltRw7tDh2IhDa3mfiRckQd1f2Gv3b0SfSWUiHaayfA9ydzwNfcWj
   w==;
X-CSE-ConnectionGUID: lws1q+HvRdCD7GvkO9vhPw==
X-CSE-MsgGUID: kCcQGj+xQQixve8afxel+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="241166313"
X-IronPort-AV: E=Sophos;i="6.23,243,1770562800"; 
   d="scan'208";a="241166313"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 16:31:21 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 72297C01B12
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 07:31:20 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (az2uksmom4.o.css.fujitsu.com [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 2D037C09672
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 07:31:20 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id B953340D518;
	Wed, 20 May 2026 07:31:15 +0000 (UTC)
Date: Wed, 20 May 2026 16:31:12 +0900
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
Message-ID: <ag1jQB3dRX0RSqbR@sm-arm-grace07>
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

Hi Wei Lin,

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

With this series applied on the recent kvmarm/fixes (minor local modification), 
your v3 hello_nested runs fine on all three page granules; without this 16KB 
kernel can't handle stage 2 unmapping paths. I tested using the latest QEMU only 
so wonder how you're testing.  

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
