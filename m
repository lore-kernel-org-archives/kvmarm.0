From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] arm64: KVM: Fixes for 4.4-rc2
Date: Tue, 24 Nov 2015 17:59:08 +0100
Message-ID: <20151124165908.GA18855@cbox>
References: <1447669698-15939-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447669698-15939-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 10:28:16AM +0000, Marc Zyngier wrote:
> Here's a couple of fixes for KVM/arm64:
> 
> - The first one addresses a misinterpretation of the architecture
>   spec, leading to the mishandling of I/O accesses generated from an
>   AArch32 guest using banked registers.
> 
> - The second one is a workaround for a Cortex-A57 erratum.
> 
Thanks, applied with cosmetic fixes and cc'ed to stable.

-Christoffer
