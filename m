From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 04/18] arm64: Add a helper for PARange to physical
 shift conversion
Date: Mon, 1 Oct 2018 13:05:21 +0100
Message-ID: <20181001120520.GA25071@arrakis.emea.arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
 <20180926163258.20218-5-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926163258.20218-5-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org, cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, eric.auger@redhat.com, julien.grall@arm.com, James Morse <james.morse@arm.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 26, 2018 at 05:32:40PM +0100, Suzuki K. Poulose wrote:
> On arm64, ID_AA64MMFR0_EL1.PARange encodes the maximum Physical
> Address range supported by the CPU. Add a helper to decode this
> to actual physical shift. If we hit an unallocated value, return
> the maximum range supported by the kernel.
> This will be used by KVM to set the VTCR_EL2.T0SZ, as it
> is about to move its place. Having this helper keeps the code
> movement cleaner.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
