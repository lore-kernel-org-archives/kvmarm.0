From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 03/23] arm/arm64: Add new is_kernel_in_hyp_mode
 predicate
Date: Mon, 8 Feb 2016 14:41:47 +0000
Message-ID: <20160208144146.GM6076@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454522416-6874-4-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 05:59:56PM +0000, Marc Zyngier wrote:
> With ARMv8.1 VHE extension, it will be possible to run the kernel
> at EL2 (aka HYP mode). In order for the kernel to easily find out
> where it is running, add a new predicate that returns whether or
> not the kernel is in HYP mode.
> 
> For completeness, the 32bit code also get such a predicate (always
> returning false) so that code common to both architecture (timers,
> KVM) can use it transparently.
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
