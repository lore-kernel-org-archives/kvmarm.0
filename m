Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32FA4316F
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 11:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ms+7y6NE"
Date: Tue, 21 Nov 2023 12:45:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700567135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1vXyuuqR2RifIpsPOUI0tAd3q/Y+NUZ1cOd+TYwAMhc=;
	b=ms+7y6NECPDndmWrExsyh+K/Lat2tLhMW3aQiAS4Xjc+I5qat9O1rBlt9c8V8pYE23U8b6
	JkyJYys8jsx6/o6CeIDZ61HHyO+q0DxkNVlbRl5jFbx7KC3zcqdz20wnH+N6JTu8RTsR1v
	LU225GQQLGlDf6NQwVJcJPzJ1CeP9Ds=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com, 
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm: pmu-overflow-interrupt: Fix
 failures on Amberwing
Message-ID: <20231121-ec0817b79479f12f457937a1@orel>
References: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174316.341630-1-eric.auger@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 06:42:39PM +0100, Eric Auger wrote:
> On Qualcomm Amberwing, some pmu-overflow-interrupt failures can be observed.
> Although the even counter overflows, the interrupt is not seen as
> expected on guest side. This happens in the subtest after "promote to 64-b"
> comment.
> 
> After analysis, the PMU overflow interrupt actually hits, ie.
> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
> as expected. However the PMCR.E is reset by the handle_exit path, at
> kvm_pmu_handle_pmcr() before the next guest entry and
> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
> There, since the enable bit has been reset, kvm_pmu_update_state() does
> not inject the interrupt into the guest.
> 
> This does not seem to be a KVM bug but rather an unfortunate
> scenario where the test disables the PMCR.E too closely to the
> advent of the overflow interrupt.
> 
> Since it looks like a benign and inlikely case, let's resize the number
> of iterations to prevent the PMCR enable bit from being resetted
> immediately at the same time as the actual overflow event.
> 
> Also make pmu_stats volatile to prevent any optimizations.
> 
> Eric Auger (2):
>   arm: pmu: Declare pmu_stats as volatile
>   arm: pmu-overflow-interrupt: Increase count values
> 
>  arm/pmu.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> -- 
> 2.41.0
>

Merged into https://gitlab.com/kvm-unit-tests/kvm-unit-tests master

Thanks,
drew
