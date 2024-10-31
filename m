Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DF819AA6B
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 11:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375383; cv=none; b=URGQ0KAW3u4WQzgyJ/hgcKvGCySZwj1t1x0Fo2I1dAyK2yQRfhw0fMMoIsKnhGiPtBlSIX4goMXDr8h8le/wg8LpHzU6Cg5QbCLqoH3g6eMmq4XEOE0o7rsqo3wKgbvTDIdMDokZKeZn3qD8wYTISnxJsw3k1LfDTzuzAvTcpos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375383; c=relaxed/simple;
	bh=Vh7nN+cfL3LcFYypz5inb/d18T2H4Sz2zNznkXN5zbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7sZyMLy7vuKQUyKYzj1Mz3mO//N3Hfx2Q04XkGkqy86HdPv7Evt5n/1I0v/+cRubbwKFVWpd2o7dq51OXBER2xvCVRcqsiFGm2MI13hb9VTvrGjXNfdEazHuokrTKGM7LXQqzXQULqyVJNKifppfaPORmboGM71qlz31ZojCLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13940C4CEE0;
	Thu, 31 Oct 2024 11:49:40 +0000 (UTC)
Date: Thu, 31 Oct 2024 11:49:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, gshan@redhat.com, james.morse@arm.com,
	shameerali.kolothum.thodi@huawei.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 2/7] arm64: head.S: Initialise MPAM EL2 registers and
 disable traps
Message-ID: <ZyNu0mDR0aicfPrS@arm.com>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
 <20241030160317.2528209-3-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030160317.2528209-3-joey.gouly@arm.com>

On Wed, Oct 30, 2024 at 04:03:12PM +0000, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
> This register resets to an unknown value, setting it to the default
> parititons/pmg before we enable the MMU is the best thing to do.
> 
> Kexec/kdump will depend on this if the previous kernel left the CPU
> configured with a restrictive configuration.
> 
> If linux is booted at the highest implemented exception level el2_setup
> will clear the enable bit, disabling MPAM.
> 
> This code can't be enabled until a subsequent patch adds the Kconfig
> and cpufeature boiler plate.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
