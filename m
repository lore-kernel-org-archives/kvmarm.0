Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEC435F5ED
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 02:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490587; cv=none; b=Kq6rTgDT99gt2wdil3JxsGvrk5bYclOUDOUZ28VPaSjw5snJWCq+4mTliCzLTjEYVKFx/77tZR2pg3cTUFLJ4bx+cZraspVbLoOgbDHqDSrx3T0hNvYwsKRsmyeho/Ugp99MS1dhXmg5r/ee3jzbvB+ZyQ2ugf38krbrlMdEQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490587; c=relaxed/simple;
	bh=M50a07QYaknMt62mPLnYdnzYtmToSOSevFA9tewdmGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CW5W63HA8BxpBKyPpLFcGCQM/e/YjEg7BuHmalQv1TsSHVgS6f8DpVlgK8u3l6Ctsm2/QBKgAAhWT4CNWwyHGOFm2zeV1BZ7AP6Vxkle4SiHzE3VyrqmuPxb8wl3FUuGWVabqTtXqfvbhfUdzRrvYeHzwJx9AdaNGL6ADbmQQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=l/v2w5cS; arc=none smtp.client-ip=139.138.61.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="l/v2w5cS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788490589; x=1820026589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M50a07QYaknMt62mPLnYdnzYtmToSOSevFA9tewdmGg=;
  b=l/v2w5cSr+3zdXno188Q4e1NqVhECpLCZ2GbRgoVG/9lQEszmGzIb3zA
   PI3C4qmyPuIF5Na/wHrr6JwGr3t/vsbufKUsDDMOtNXYS90eVKP5RFlYs
   mqJ9xoS9ix4sW54CyEX3AhULjBDsZm9cCUr2zuiXNjKzWfP2UjortMxQv
   4DdsasUxvzpIjRIn7FFUdlwGjdpcVqfkLvSYnRbs3MR6gvquwn1sLz+nk
   ocMPx21oRoXYhkVPqSvQVhYeWk5+tMjTexcbD9IqhEUa8yvxh6T+fAzGh
   VrW771B18/AfTWQL80+F6Tykg0xXmSe8XcBbH3dLxICBE7W/pB86XPqw9
   w==;
X-CSE-ConnectionGUID: M2b9vsLsSfOAGHLUi8iLMg==
X-CSE-MsgGUID: H0egcAt3S7mO1iROPFImvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="241798122"
X-IronPort-AV: E=Sophos;i="6.25,260,1779116400"; 
   d="scan'208";a="241798122"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 11:55:18 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id E46F71C00640
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 02:55:13 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 923371802ACF
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 02:55:13 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 5532740D1B9;
	Fri,  4 Sep 2026 02:55:08 +0000 (UTC)
Date: Fri, 4 Sep 2026 11:55:05 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Takayuki Okamoto <tokamoto@fujitsu.com>
Subject: Re: [PATCH 0/2] 52-bit VA guest mode ID support
Message-ID: <apozCZSi00UZhqLJ@sm-arm-grace07>
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>

On Wed, Aug 26, 2026 at 06:18:33AM +0900, Itaru Kitayama wrote:
> This patch series extends the arm64 KVM selftest framework
> to support 52-bit guest virtual address (VA) modes in addition to
> the existing 52-bit physical address (PA) configurations.
> The motivation is to enable validation of LPA2 guest memory-management
> behaviour in configurations that use a 52-bit VA space.
> While the selftest framework already supports testing 52-bit PA
> configurations, it lacks the ability to exercise guests running with
> 52-bit virtual addresses, leaving part of the LPA2 functionality untested.
> To address this, the series introduces new guest modes for 52-bit VA
> operation, adds five-level page table support where required, and
> performs runtime detection of host 52-bit VA capability so that
> LPA2-enabled guest VA tests are executed only on supported systems.
> 
> Testing:
> 
> Built and tested on arm64.
> Verified on QEMU with a V52-capable guest configuration.
> Confirmed correct operation of high virtual address mappings by
> exercising guest memory accesses in the 52-bit VA range.
> 
> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>

I'd appreciate any comments on this series.

Thanks,
Itaru.

> ---
> Itaru Kitayama (2):
>       KVM: selftest: arm64: Support 5-level paging in stage 1 translation table
>       KVM: selftests: arm64: Add 52-bit VA guest modes
> 
>  .../selftests/kvm/include/arm64/processor.h        |  2 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |  3 +
>  tools/testing/selftests/kvm/lib/arm64/processor.c  | 87 ++++++++++++++++++++--
>  tools/testing/selftests/kvm/lib/guest_modes.c      |  5 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 11 +++
>  5 files changed, 103 insertions(+), 5 deletions(-)
> ---
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> change-id: 20260825-arm64-52bit-va-32f1f4cd050d
> 
> Best regards,
> --  
> Itaru Kitayama <itaru.kitayama@fujitsu.com>
> 
