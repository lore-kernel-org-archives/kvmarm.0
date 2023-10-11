Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E66199D6
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 08:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rifPWBRt"
Date: Wed, 11 Oct 2023 08:24:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697012702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/S0JgFqg4H1IYpuqJTqVbgL24y5HPTPBE2KO5N0Er7Y=;
	b=rifPWBRtD8D2d+dvqwjSDF/T7fYlgNVBaxxBWCzIc7b8xZZeknRWnFujZMp7ojIzLlyad1
	+PynOxmlCk/KIRAmcn30AFb4ug9YsYDBl2LWoRMeOALhY20J+GwckhXDhAFxu5oQDg86WU
	0/oU2Ft0wW4+dNOwW/VSd/RxfMpGo6A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
	suzuki.poulose@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Zaid Al-Bassam <zalbassam@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/3] arm: perf: Include threshold control fields valid
 in PMEVTYPER mask
Message-ID: <ZSZb2H8O5fuU3UrA@linux.dev>
References: <20231010141551.2262059-1-james.clark@arm.com>
 <20231010141551.2262059-2-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010141551.2262059-2-james.clark@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi James,

On Tue, Oct 10, 2023 at 03:15:41PM +0100, James Clark wrote:
> FEAT_PMUv3_TH (Armv8.8) adds two new fields to PMEVTYPER, so include
> them in the mask. These aren't writable on 32 bit kernels as they are in
> the high part of the register, so split the mask definition to the asm
> files for each platform.
> 
> Now where the value is used in some parts of KVM, include the asm file.
> There is no impact on guest PMUs emulated with KVM because the new
> fields are ignored when constructing the attributes for opening the
> event. But if threshold support is added to KVM at a later time no
> change to the mask will be needed.

KVM should treat TH and TC as RES0 if the feature isn't virtualized. I'd
rather move KVM away from using ARMV8_PMU_EVTYPE_MASK in the first
place. Looks like we already have an issue with the NSH bit, so I've
sent the below patch to fix it.

https://lore.kernel.org/kvmarm/20231011081649.3226792-3-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
