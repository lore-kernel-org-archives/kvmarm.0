From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/2] arm64: Add hypervisor safe helper for checking
 constant capabilities
Date: Tue, 8 Nov 2016 18:11:03 +0000
Message-ID: <20161108181103.GM20591@arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
 <1478613381-5718-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3EF402AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 13:10:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xc2X-9bQP3dM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 13:10:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55EFB401F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 13:10:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1478613381-5718-2-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Robert Ritcher <rritcher@cavium.com>, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, Tirumalesh Chalamarla <tchalamarla@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 08, 2016 at 01:56:20PM +0000, Suzuki K Poulose wrote:
> The hypervisor may not have full access to the kernel data structures
> and hence cannot safely use cpus_have_cap() helper for checking the
> system capability. Add a safe helper for hypervisors to check a constant
> system capability, which *doesn't* fall back to checking the bitmap
> maintained by the kernel. With this, make the cpus_have_cap() only
> check the bitmask and force constant cap checks to use the new API
> for quicker checks.
> 
> Cc: Robert Ritcher <rritcher@cavium.com>
> Cc: Tirumalesh Chalamarla <tchalamarla@cavium.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 19 ++++++++++++-------
>  arch/arm64/kernel/cpufeature.c      |  2 +-
>  arch/arm64/kernel/process.c         |  2 +-
>  drivers/irqchip/irq-gic-v3.c        | 13 +------------

It might be worth having the GIC changes as a separate patch, but either
way:

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
