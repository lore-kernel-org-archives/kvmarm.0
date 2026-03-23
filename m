Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B315A2D2488
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288425; cv=none; b=PX1lfQDCu3W0bA/KcmrkRSq42RriMPI2ARKu6tWaqZ4RZFGnv0aEoZQ7o/Prhuc9tTXTNy2RAtD6tnZsGQbDNPwIXDQHsrUhhhLhfJmBVJUfUlJRIltblv/gGcqaY6AfyCfWEicnQPS0ZcGe+BpKMqxYQmRg57y1+YAuFQ9SSPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288425; c=relaxed/simple;
	bh=oSvLfUzLfETX30CSMQDoM4b7JT2fv1fx+UqUWfAYEbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C88houRqIaFhfBA2wCUup8CNZG/sQQ3A1GuESH29lDGuT6xBOvBBqzgLIwpjetWNiMfQynNNrYOBAq5pucDIT+6GCHkj4TQNOOqWC9gTijHfFQ34OGsxgGQlMjW13dctIkR18acpnAlCkRWjndnoL9xknFuVpwlyjC6BWCZvNaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CEC51476;
	Mon, 23 Mar 2026 10:53:37 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 569533F694;
	Mon, 23 Mar 2026 10:53:41 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 0/5] arm64: Work around C1-Pro erratum 4193714
 (CVE-2026-0995)
Message-ID: <acF-I7zTF-daRlZa@J2N7QTR9R3.cambridge.arm.com>
References: <20260323162408.4163113-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323162408.4163113-1-catalin.marinas@arm.com>

On Mon, Mar 23, 2026 at 04:24:00PM +0000, Catalin Marinas wrote:
> Here's version 3 of the workaround for C1-Pro erratum 4193714. Version 2 was
> posted here:
> 
> https://lore.kernel.org/r/20260318191918.2653160-1-catalin.marinas@arm.com
> 
> Catalin Marinas (4):
>   arm64: tlb: Introduce __tlbi_sync_s1ish_{kernel,batch}() for TLB
>     maintenance
>   arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
>   arm64: cputype: Add C1-Pro definitions
>   arm64: errata: Work around early CME DVMSync acknowledgement
> 
> James Morse (1):
>   KVM: arm64: Add SMC hook for SME dvmsync erratum

These all looks good to me.

FWIW, for the series:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.
