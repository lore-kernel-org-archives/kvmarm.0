From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Fri, 2 Oct 2015 17:31:32 +0100
Message-ID: <20151002163131.GO6963@e104818-lin.cambridge.arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
 <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: Mark.Rutland@arm.com, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 04:49:01PM +0100, Catalin Marinas wrote:
> On Tue, Sep 15, 2015 at 04:41:18PM +0100, Suzuki K. Poulose wrote:
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > This patch adds the page size to the arm64 kernel image header
> > so that one can infer the PAGESIZE used by the kernel. This will
> > be helpful to diagnose failures to boot the kernel with page size
> > not supported by the CPU.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> This patch needs you signed-off-by as well since you are posting it. And
> IIRC I acked it as well, I'll check.
> 
> If you are fine with adding your signed-of-by, I can add it to the patch
> when applying (unless I see other issues with the series).

Actually, I just realised that the kvm patches don't have any acks, so
I'm not taking this series yet. You may want to repost once you have all
the acks in place.

-- 
Catalin
