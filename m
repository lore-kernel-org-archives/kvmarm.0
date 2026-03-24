Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF313EB7E1
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774352602; cv=none; b=dHy0P0o8EjXQDIDJudMKyVkcny1p+rzrmw++HvmFuIXhF+W1/PrFi1tVylHvOecJoeir8vHnYd2S5EHSqOiUee9c6jf7uVxJodFcXg3fm11dYsuiPvjjE1lF+gIyCpq6+zZkTGVCzcXDq3e9WKZh9Rl1QDW/wwk3BsGUyDm1D7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774352602; c=relaxed/simple;
	bh=gboJ/ULn02l/SfyoE/6ODhxmSwadVnznhCRHYVNoYpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgWM/s0BedT3YFvug9FcaqZ7lg2XDyqjqk0aqAD+BOvBpl/HiFQbvTe1NBhtjToiiVPbMQajFu3DkyQFIyHFf2hZGKQjol+MXeIA1eUEuKnOp7s5pjBRDD84xLbaViVqPhSo3JmtWsmZHkfC7fs7CtNUPwaxMcTZ3VMdBbaox+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tOXReSpT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tOXReSpT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81B92153B;
	Tue, 24 Mar 2026 04:43:12 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F6463FE14;
	Tue, 24 Mar 2026 04:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774352598; bh=gboJ/ULn02l/SfyoE/6ODhxmSwadVnznhCRHYVNoYpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tOXReSpT51KmgYjEwPCKsRJds+lP4oDao88vqO37XhIePbJNw8gptEp15mczGIAbH
	 78VkL/1AYPaFf7bGzdMLG1VQ9YsDrKt6bZezkihB4IQhnzdyWDB00NRZEGMDLlkO0B
	 9SKXFBtqIqtwb0cxX344bXDJ7XNsNy4UK+r0MNZI=
Date: Tue, 24 Mar 2026 11:43:12 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] arm64: Add Stage-2 MMU and Nested
 Guest Framework
Message-ID: <20260324114312.GA438107@e124191.cambridge.arm.com>
References: <20260316224349.2360482-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316224349.2360482-1-jingzhangos@google.com>

On Mon, Mar 16, 2026 at 03:43:46PM -0700, Jing Zhang wrote:
> This patch series introduces a lightweight infrastructure for managing ARM64
> Stage-2 translation tables and executing nested guests. These components are
> essential for testing advanced virtualization features such as nested
> virtualization (NV) and GICv4 direct interrupt injection.
> 
> The series provides a generic Stage-2 MMU library supporting multiple
> translation granules (4K, 16K, 64K) and dynamic page table management.
> Building on this, it adds a guest execution framework that handles guest
> lifecycle management, context switching and guest exit routing. A new test
> case for Stage-2 MMU demand paging to verify fault handling.
> 
> Please note that this is a very preliminary implementation intended as a
> startup baseline for future work in virtualization testing. Users should be
> aware that because this is an early-stage baseline, some portions of the code
> may just happen to work in its current state. There might be critical
> architectural elements or edge-case handling missing that will need to be
> addressed as the framework matures.
> 

Hi,

I'm interested in this, I had a much more barebones (aka no stage2) guest
framework thing that I sent out [1], but it seems more useful to try get this
series merged.

I will try get my tests working with this new framework, one thing missing for
me is support for executing at EL0.

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.gouly@arm.com/#t

> ---
> 
> Jing Zhang (3):
>   lib: arm64: Add stage2 page table management library
>   lib: arm64: Add bare-metal guest execution framework
>   arm64: Add Stage-2 MMU demand paging test
> 
>  arm/Makefile.arm64         |   4 +
>  arm/stage2-mmu-test.c      | 100 +++++++++
>  lib/arm64/asm/guest.h      | 156 ++++++++++++++
>  lib/arm64/asm/stage2_mmu.h |  74 +++++++
>  lib/arm64/guest.c          | 197 ++++++++++++++++++
>  lib/arm64/guest_arch.S     | 263 ++++++++++++++++++++++++
>  lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 1196 insertions(+)
>  create mode 100644 arm/stage2-mmu-test.c
>  create mode 100644 lib/arm64/asm/guest.h
>  create mode 100644 lib/arm64/asm/stage2_mmu.h
>  create mode 100644 lib/arm64/guest.c
>  create mode 100644 lib/arm64/guest_arch.S
>  create mode 100644 lib/arm64/stage2_mmu.c
> 
> 
> base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 
