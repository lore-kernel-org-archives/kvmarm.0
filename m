From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Mon, 5 Oct 2015 17:43:30 +0200
Message-ID: <20151005154330.GI9011@cbox>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
 <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
 <20151002163131.GO6963@e104818-lin.cambridge.arm.com>
 <560EB5DE.7080007@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560EB5DE.7080007@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 05:50:38PM +0100, Marc Zyngier wrote:
> On 02/10/15 17:31, Catalin Marinas wrote:
> > On Fri, Oct 02, 2015 at 04:49:01PM +0100, Catalin Marinas wrote:
> >> On Tue, Sep 15, 2015 at 04:41:18PM +0100, Suzuki K. Poulose wrote:
> >>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>>
> >>> This patch adds the page size to the arm64 kernel image header
> >>> so that one can infer the PAGESIZE used by the kernel. This will
> >>> be helpful to diagnose failures to boot the kernel with page size
> >>> not supported by the CPU.
> >>>
> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>
> >> This patch needs you signed-off-by as well since you are posting it. And
> >> IIRC I acked it as well, I'll check.
> >>
> >> If you are fine with adding your signed-of-by, I can add it to the patch
> >> when applying (unless I see other issues with the series).
> > 
> > Actually, I just realised that the kvm patches don't have any acks, so
> > I'm not taking this series yet. You may want to repost once you have all
> > the acks in place.
> > 
> 
> I'm in the middle of it. I should be done next week (I may have said the
> same thing two weeks ago...).
> 
Very near the top of my to-review list as well, will try to get it done
this week.

-Christoffer
