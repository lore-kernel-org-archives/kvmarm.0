Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3571C2ED17B
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776787333; cv=none; b=YvrHvHrTZB8OPz9/b7xijBkf3qbQ/aIIeELOPIiTmUGWU0mc8SqC/V4rwsMXmmVIwmr659osmJzedcZittjW+5VkGxOAC7CWWkWTSGNiIpeorjn/D9KcgI1UaE8vE07e4RWEBE4wYc+B5qXOvAtHuhb3YgLs8pHG5SGIrkp68do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776787333; c=relaxed/simple;
	bh=Pg2Y2R3dJ5pv9N735vZc4+rPfmTMTkbBWHFgyQTkLPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMxCNG74Kwv5l+Y17xppaK/HIzj4oBPKSR0QBXtUPHb+Ka3bSxh+Ghjq/As8HgBGmVwUwW/wK7tS/NThiQicjRxUQFi6pcCQXLJG28s1nJNdIk26faDanxf4zoTE1Hf/CwKooUNLYVaI9f/u1C5IVfqy43c1cNIyJ3QO4VfdbYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tN3ViIKR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tN3ViIKR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDB6F25DE;
	Tue, 21 Apr 2026 09:02:05 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 297AC3FBD2;
	Tue, 21 Apr 2026 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776787331; bh=Pg2Y2R3dJ5pv9N735vZc4+rPfmTMTkbBWHFgyQTkLPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tN3ViIKRFv45siGrW8eN0HA/EJUvCGUkv941kRhDYq7PAJ5xaotuWYZ3WwQKCfOuI
	 jD8Sav5zF9x7kFSq8GppUweChWsbBrgog4Y1Qe/MZmZ4dlillcSnzl0fFviygeXAdy
	 WKpyhTDYcqaER63gKip0z31n0hcQTInm+k3xzXHM=
Date: Tue, 21 Apr 2026 17:02:07 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 12/18] KVM: arm64: selftests: Add missing GIC CDEN to
 no-vgic-v5 selftest
Message-ID: <20260421160207.GC3862683@e124191.cambridge.arm.com>
References: <20260415115559.2227718-1-maz@kernel.org>
 <20260415115559.2227718-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415115559.2227718-13-maz@kernel.org>

On Wed, Apr 15, 2026 at 12:55:53PM +0100, Marc Zyngier wrote:
> From: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> The selftest mistakenly omitted the GIC CDEN instruction from the
> testing. Add it in.

Compared against the list of instructions in the spec.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> Fixes: ce29261ec648 ("KVM: arm64: selftests: Add no-vgic-v5 selftest")
> Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/no-vgic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/selftests/kvm/arm64/no-vgic.c
> index b14686ef17d12..e09e3fac904f4 100644
> --- a/tools/testing/selftests/kvm/arm64/no-vgic.c
> +++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
> @@ -159,6 +159,7 @@ static void guest_code_gicv5(void)
>  	check_gicv5_gic_op(CDAFF);
>  	check_gicv5_gic_op(CDDI);
>  	check_gicv5_gic_op(CDDIS);
> +	check_gicv5_gic_op(CDEN);
>  	check_gicv5_gic_op(CDEOI);
>  	check_gicv5_gic_op(CDHM);
>  	check_gicv5_gic_op(CDPEND);
> -- 
> 2.47.3
> 
