Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF673939AA
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772021402; cv=none; b=Yd2+kf6yJWgdOOkneo67cKNUoJI+JzzNtxiNo3/F1qS+51H4ugXiBKfpM140CGIeA1CUfMIm3LU3Yl0VjbAByWkATcF/7+KOJuOXkipGRAEVmtitYzJST+u8F+RB0k0TVgnhVSv17oaQO+o2V3rxgqKfzvLopYhuFhvBFtQl14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772021402; c=relaxed/simple;
	bh=i3S4GPxEqvoY8TugT4nMw57r0iaU+/TYcuddZD/ZDco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBhiTrWLmHq+bjXGDtRN5XfQYjnSnezNIafCkbYkV68cBzYD6SG5swoqkctiwvajiK9e4aaqzri1qu04dMeYZclqJDlWH//R0lWpFLLMoPlVk1Vwde2gf3xaNchXoey1MDbgxeMiNcUDt2TMp7Ql/3DTIYCzVvjAz25XmG+c8BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDDEF165C;
	Wed, 25 Feb 2026 04:09:52 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7ACC3F59E;
	Wed, 25 Feb 2026 04:09:58 -0800 (PST)
Date: Wed, 25 Feb 2026 12:09:56 +0000
From: Leo Yan <leo.yan@arm.com>
To: Will Deacon <will@kernel.org>, yabinc@google.com
Cc: James Clark <james.clark@linaro.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <20260225120956.GD4184494@e132581.arm.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
 <20260217190121.GB136967@e132581.arm.com>
 <aZcWC25GE2iUKsNt@willie-the-truck>
 <20260219185800.GD136967@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219185800.GD136967@e132581.arm.com>

Hi Will,

[ + Yabin ]

Thanks for Suzuki's reminding, I should mention that Yabin reported
another lockup issue caused by missing CPU PM support in TRBE driver.

We have a patch series to fix the issue:
https://lore.kernel.org/linux-arm-kernel/20251119-arm_coresight_path_power_management_improvement-v5-16-f615a301ad0b@arm.com/

Besides your fix the translation regime issue, I'd also suggest applying
the CoreSight PM patch series to fix lockup caused by CPU idle.

I have a supplement for the context switch, please see the comment below.

On Thu, Feb 19, 2026 at 06:58:03PM +0000, Leo Yan wrote:

[...]

> Based on these conclusions, let me summarize the flow:
> 
>   // Prohibit trace
>   TRFCR_EL1 = 0;
> 
>   // No new program-flow trace
>   isb();
> 
>   // Trace operation and trace unit are flushed
>   tsb_csync();   // Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> 
>   // Disable trace unit
>   TRCPRGCTLR.EN = 0b0

We conclude that no need to disable and re-enable the trace unit
(TRCPRGCTLR.EN) during a KVM context switch.

Here are the details:

I initially proposed controlling the TRCPRGCTLR.EN bit during switch.
This would allow the trace unit to generate ASYNC packets, which I
assumed would be convenient for decoding, since the decoder can
recognize ASYNC packets rather than decoder is to be reset if any
discontinuity occurs.

After review, during a VM context switch, the trace unit can guarantee
a single continuous stream when switching back to the host. There is no
discontinuity in trace stream.  Therefore, we don't need to touch
TRCPRGCTLR.EN bit to generate ASYNC packets.

I hope this is reasonable to you.

Thanks,
Leo
