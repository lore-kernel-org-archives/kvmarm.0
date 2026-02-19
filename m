Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E9815C14F
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771528003; cv=none; b=l1ue9qXVgwaEdTcg90nXQI5oy9Tw2xgYREvgMnCnX2Ioq2MDyBNLqVofAx3uKQBVYdR1iworauAuWS/FokmGu32a+aj+Lx/w6XOYh7HlqOKlLBuIarFCve1FZKQ4x/4/fPbryouOHHriPTXuzZyxtKt3Gd0hTPKWLU7HiUKv/tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771528003; c=relaxed/simple;
	bh=x13yHeeUrdj5F3pEhb+Z8Gdbkt/5oT6qJc3ySecld8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roVN6b9NMAsqvuK0BqE7UlNXX60dNvZnhwky9PUAkvE9mIHU4Gogph0kfp9Yj+ntlZoaXy0hoV97muLqlRGQGeL4xUNJ/ocrwcim/gFAZUi3VLZB7FOWmwf8v94TLCjf6VfAEDJI7LADV1PZihjCTeuyHKke0BpsBme+UTjH8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F154D339;
	Thu, 19 Feb 2026 11:06:33 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B866A3F7D8;
	Thu, 19 Feb 2026 11:06:39 -0800 (PST)
Date: Thu, 19 Feb 2026 19:06:38 +0000
From: Leo Yan <leo.yan@arm.com>
To: Will Deacon <will@kernel.org>
Cc: James Clark <james.clark@linaro.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <20260219190638.GE136967@e132581.arm.com>
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

On Thu, Feb 19, 2026 at 06:58:03PM +0000, Leo Yan wrote:

[...]

> The flow for guest->host might be easy one, anyway, I try to summary for
> review:
> 
>   Restore TRFCR_EL1;
> 
>   // Ensure restored sysreg is visible
>   isb();
> 
>   // Enable trace buffer
>   TRBLIMITR_EL1.E = 0b1
> 
>   // Enable trace unit
>   TRCPRGCTLR.EN = 0b1
> 
>   if (2038923)
>      isb();

To strictly follow the SDEN, this ISB should be moved to immediately
after enabling the TRBLIMITR_EL1.E bit and before enabling the
TRCPRGCTLR.EN bit.

Sorry for spamming.
