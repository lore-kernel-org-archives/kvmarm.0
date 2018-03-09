From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v7] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Fri, 9 Mar 2018 13:48:13 +0000
Message-ID: <20180309134813.GD15537@arm.com>
References: <1520434808-29703-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520434808-29703-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Philip Elcan <pelcan@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 07, 2018 at 09:00:08AM -0600, Shanker Donthineni wrote:
> The DCache clean & ICache invalidation requirements for instructions
> to be data coherence are discoverable through new fields in CTR_EL0.
> The following two control bits DIC and IDC were defined for this
> purpose. No need to perform point of unification cache maintenance
> operations from software on systems where CPU caches are transparent.
> 
> This patch optimize the three functions __flush_cache_user_range(),
> clean_dcache_area_pou() and invalidate_icache_range() if the hardware
> reports CTR_EL0.IDC and/or CTR_EL0.IDC. Basically it skips the two
> instructions 'DC CVAU' and 'IC IVAU', and the associated loop logic
> in order to avoid the unnecessary overhead.

Cheers, I've queued this for 4.17.

Will
