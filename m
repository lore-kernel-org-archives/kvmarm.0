Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637236EAB9;
	Mon, 18 May 2026 15:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119608; cv=none; b=jG+CyhqXDSzKR+ayCiF5HEEQXp27mwys1olEI3RVFo2g1x1MpmaNY/i5GpECsHxVS+ICkN6zGys01R7K8zxwv156ToqwdE7XjGzlF9zhYITtdmyd5xKDfFhFzrW3iH5VeygQHGKa9itlxhRSzG/us6yI0jNIqMtel9TmiTJDI8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119608; c=relaxed/simple;
	bh=p0DF+qEvuD5y1yPwFRfJEGsH1ocDFXtPcWXGL8v+pd0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YlV8dmdfEOtPL9CGiQG22FVXrOBEbFh0vwQv4GmhQFvmLr4xo9rYSMxyXQCZzOkZUA4KBldGYVjKIes9CZkhPVUIn+uw7/X41CU1ofUgWGSyyUiLpY2Fgzw5pXq1klSPEBm84JiwaqZPxahmqJ84Qq/pc6wKj3bMa+3unbdrSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ulj5R3E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ulj5R3E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E22C2BCB7;
	Mon, 18 May 2026 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779119607;
	bh=p0DF+qEvuD5y1yPwFRfJEGsH1ocDFXtPcWXGL8v+pd0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ulj5R3E8Rv8y6EmWoyV1jR6yWCoMpkqpHQszi1rcK2/qlwRJHt0u6MroEEnHNLBUR
	 pN/m0AaSkXN7mkCgr+5Et2WQkND/EzH5MAoCBk4uXKkHU+B2NS6pR/80OeAdaxb0MJ
	 /GlaoOyND3f1Uc6tscxCBhqnQherydXZsWnMwZSFDdfGCHf/hIivhAmarwP5i6MPVV
	 CKRQr6WiXlw0fJx4hOuZSuaYTRLRLbB8Fbqbj29OGBebTY6cWF+Gt/+pbcirTnGvqn
	 sd66jOcafF6fg8ww6lpeZcZN9yelMf7sgSqGTZL3UE7/J87+tERAy9oooSyzODdQuN
	 APe2kmfaYLDVQ==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 00/14] coco/TSM: Host-side Arm CCA IDE setup via
 connect/disconnect callbacks
In-Reply-To: <agsNO9cc7H-b0H8L@willie-the-truck>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
 <agsNO9cc7H-b0H8L@willie-the-truck>
Date: Mon, 18 May 2026 21:23:18 +0530
Message-ID: <yq5aecj8yas1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> On Mon, Apr 27, 2026 at 12:21:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>  arch/arm64/include/asm/rmi_cmds.h         |  85 +++
>>  arch/arm64/include/asm/rmi_smc.h          | 168 +++++
>
> Curious, but why does this stuff have to live in the arch code? Wouldn't
> it be better off somewhere like drivers/firmware/ or
> include/linux/arm-rmi.h?
>

Those headers are used to collect all RMI-related helpers and #defines.
They were introduced by the Realm KVM/host support patch series, and I
am continuing to use the same headers to add more helpers.

We can consider moving the RMI helpers used by virt/coco/arm-caa-guest/,
virt/coco/arm-cca-host/, and
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c into a more generic
header such as include/linux/arm-rmi.h. However, that would either
require moving all the helpers currently used by KVM there as well,
otherwise we would end up with two separate headers carrying RMI
helpers.

Additionally, there are also arch/arm64/include/asm/rsi_cmds.h and
arch/arm64/include/asm/rsi_smc.h to consider.

-aneesh
