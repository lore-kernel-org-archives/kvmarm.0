From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 0/3] arm/arm64: KVM: Add support for page aging
Date: Thu, 12 Mar 2015 22:40:34 +0100
Message-ID: <20150312214034.GA3067@cbox>
References: <1426184212-29333-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426184212-29333-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Steve Capper <steve.capper@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 12, 2015 at 06:16:49PM +0000, Marc Zyngier wrote:
> So far, KVM/arm doesn't implement any support for page aging, leading
> to rather bad performance when the system is swapping. This short
> series implements the required hooks and fault handling to deal with
> pages being marked old/young.
> 
> The three patches are fairly straightforward:
> 
> - First patch changes the range iterator to be able to return a value
> 
> - Second patch implements the actual page aging (clearing the AF bit
>   in the page tables, and relying on the normal faulting code to set
>   the bit again).
> 
> - Last patch optimizes the access fault path by only doing the minimum
>   to satisfy the fault.
> 
> The end result is a system that behaves visibly better under load, as
> VM pages don't get evicted that easily.
> 
> Based on 4.0-rc3, tested on Seattle and X-Gene.
> 
> Also at git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/page-aging
> 
> * From v1 [1]:
> - Removed all TLBIs from kvm_age_hva_handler, as the core KVM code
>   already does use quite a large hammer to nuke the TLBs on its own
> - Don't mark old a page that is already old
> - Rebased on top of 4.0-rc3
> 

Thanks, applied to queue!

-Christoffer
