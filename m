Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688581;
	b=GwnYLqCK7BuST9GJ3ke4zNthOh5i+hvwSbD19M4l1YOrtw+Zinvz7JAM91a42M9rgpZR
	 ELXPPD3cozV37Rg/DiBWfuivWJ1NRZRIgsc39YPPQtNhuUse1+eaq0kWJJ65W3itGL3W0
	 umnfIhZ84gQeJ+zx7lUJwswyLFWs/gg3NZGjsfeaYin2aI5K4lphlkLIqwjv73gwW7ESH
	 Bl1qwV6QSiEKin3lsLLp3oAz7oQ/T9ae5K3Sk3eEc+VhhToQm+cAYUxhvU5IioFRmvKyG
	 opTuhJ0+1IcQbJ7737DCkn8jBbafX36WUuMauloy9nnO42TkdEiA2XxczUcVJqQZ7YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688581;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=uB3C+pADt5y7DXYibQdrFVwV0bqyXjupJcd+3kg28Mc=;
	b=WO3EXDkVCyw7FLSwetp99XbSvJviaBFDP86yLYfxAIUuMJDkEiPIJ61rd7nQa27Evkoh
	 6KKb3GPdsHYh7wi9nVcMzPup3PmDqtwjwvqehS9ZsCKdB8fTbSy8d/isgkN4kr2vYQOeA
	 LWsAajPdH28tHVR7COxt3udb+sFFXTBpQLo/Z1zvzLFOYkpEJ5LLLSOEh+a2/H2pb5kbM
	 6FgSn5GkWeYXAsCilTrQGVxmpo5H8UXrpGcPhQhat9IIqEQDqCiWr7nlO9vmsLN5HXclF
	 HAtV8+P9WshN4ZwUpH8/TZOyJiLbTRy+LJaVCaMzclwXa7j/NSl8CWk4VKwsnElRZ4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OMpl24bJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418D9606A321
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 10:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 418D9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OMpl24bJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD5DB1BB0;
	Thu, 26 Nov 2026 02:22:57 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA45F3F86C;
	Thu, 26 Nov 2026 02:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795688580; bh=Og7OY2Wl3TAZIRfqBhtc5D3nGWYt7fkPibRN0/XHiq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OMpl24bJcsmwQE/K47xl7Rn/fAFQStrTjZR0wM8iwfpD4tgyMhdAE63K/qpZo1Qcx
	 TuzWyPrYgFSXwSEl+xjkbtsGwbbTGNEPFJW2PJCk39EBbYSWGyF39ENAdoeH0DXOMM
	 M1VGQ0gthLZ+Tfq3qx/jQ7g3abvOAycPsjHzQrVg=
Message-ID: <1aa97f61-b740-4044-9065-f3ccfcb709fd@arm.com>
Date: Thu, 26 Nov 2026 10:22:56 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v6 00/23] arm64: Support GICv5-based guests
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Will, Julien,

I reviewed and tested the patches for GICv5 IRS support (01-18). They
do what they promise - allow booting a GICv5-enabled guest. In my
opinion, patches are in good shape, so could you please have a look and
consider merging GICv5 IRS support (patches 01-18)?

Thanks
Vladimir

On 11/25/26 15:13, Sascha Bischoff wrote:
> This series adds support for GICv5-based VMs to kvmtool. These are
> exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
> creates a vGICv5 device and the latter adds a GICv5 ITS. The GICv5
> specification can be found at [1].
> 
> The GICv5 support in KVM needed by --irqchip=gicv5 is available as of
> Linux v7.4-rc1. The GICv5 ITS support is described in [2]; using
> --irqchip=gicv5-its requires a KVM build with those changes.
> 
> The series teaches kvmtool to create the GICv5 irqchip and ITS KVM
> devices. It describes the GICv5 CPU interface, IRS and ITS in the
> guest DT, updates the timer and PMU interrupt descriptions, and
> generates GICv5 interrupt specifiers for platform devices and PCI. It
> also maps PCI MSI requester IDs to the ITS. The IRS support is built
> and exposed before the ITS support, so the GICv5 irqchip support can
> be merged separately from the ITS changes.
> 
> Compared with v5 [3]:
> 
> * Dropped the SETLPI frame from the IRS DT description because KVM
>   reserves but does not emulate it. Updated patch 15's commit message
>   accordingly.
> 
> * Added Vladimir's Reviewed-by trailers to patches 9 and 15.
> 
> The v7.4-rc1 header sync includes GICv5 IRS UAPI, but not GICv5 ITS
> UAPI. Patch 19 mirrors the ITS definitions from [2]. Once that UAPI
> lands upstream, the headers should be resynced against the latest
> Linux headers before merging the ITS support.
> 
> Thanks,
> Sascha
> 
> [1] https://developer.arm.com/documentation/aes0070/latest
> [2] https://lore.kernel.org/all/20261102194454.4086911-1-sascha.bischoff@arm.com/
> [3] https://lore.kernel.org/all/20261118175755.1946977-1-sascha.bischoff@arm.com/
> 
> Sascha Bischoff (23):
>   arm64: Propagate IRQ routing initialisation errors
>   arm64: Close the ITS descriptor when setup fails
>   arm64: Split GIC device setup
>   Sync kernel UAPI headers with v7.4-rc1
>   arm64: Add GICv5 irqchip device support
>   arm64: Configure GIC interrupt bases
>   irq: Allow the initial interrupt line number to be set
>   arm64: Start GICv5 SPI line allocation at zero
>   arm64: Configure the GICv5 IRS
>   arm64: Define GICv5 interrupt types
>   arm64: Describe the PMU interrupt for GICv5
>   arm64: Describe timer PPIs for GICv5
>   arm64: Assign CPU DT phandles
>   arm64: Describe the GICv5 CPU interface in the DT
>   arm64: Describe the GICv5 IRS in the DT
>   arm64: Generate GICv5 SPI specifiers for platform devices
>   arm64: Generate GICv5 PCI INTx specifiers
>   arm64: Expose the GICv5 irqchip option
>   arm64: Add proposed GICv5 ITS UAPI definitions
>   arm64: Add GICv5 ITS device support
>   arm64: Describe the GICv5 ITS in the DT
>   arm64: Map PCI MSI requester IDs to the GICv5 ITS
>   arm64: Expose the GICv5 ITS irqchip option
> 
>  arm64/fdt.c                         |  13 +-
>  arm64/gic.c                         | 359 ++++++++++++++++++++++++----
>  arm64/include/asm/kvm.h             |  18 ++
>  arm64/include/kvm/fdt-arch.h        |   1 +
>  arm64/include/kvm/gic.h             |  15 ++
>  arm64/include/kvm/kvm-arch.h        |  16 ++
>  arm64/include/kvm/kvm-config-arch.h |   2 +-
>  arm64/pci.c                         |  24 +-
>  arm64/pmu.c                         |  13 +-
>  arm64/timer.c                       |   8 +-
>  include/kvm/irq.h                   |   1 +
>  include/linux/kvm.h                 |  23 ++
>  include/linux/virtio_console.h      |   2 +-
>  include/linux/virtio_ids.h          |   1 +
>  irq.c                               |  15 +-
>  powerpc/include/asm/kvm.h           |  18 ++
>  riscv/include/asm/kvm.h             |  17 ++
>  x86/include/asm/kvm.h               |   4 +-
>  18 files changed, 481 insertions(+), 69 deletions(-)
> 
> -- 2.34.1
> 

