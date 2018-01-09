From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: mm: Add additional parameter to
 uaccess_ttbr0_enable
Date: Tue, 9 Jan 2018 20:26:55 +0100
Message-ID: <20180109192655.GF15307@cbox>
References: <20180109134326.17479-1-christoffer.dall@linaro.org>
 <3e459188-f759-6f13-7ab4-1597c6da00a7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e459188-f759-6f13-7ab4-1597c6da00a7@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 01:53:56PM +0000, Marc Zyngier wrote:
> On 09/01/18 13:43, Christoffer Dall wrote:
> > Add an extra temporary register parameter to uaccess_ttbr0_enable which
> > is about to be required for arm64 PAN support.
> > 
> > This patch doesn't introduce any functional change but ensures that the
> > kernel compiles once the KVM/ARM tree is merged with the arm64 tree by
> > ensuring a trivially mergable conflict.
> > 
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Maybe worth adding that this matches
> 27a921e75711d924617269e0ba4adb8bae9fd0d1 ("arm64: mm: Fix and re-enable
> ARM64_SW_TTBR0_PAN")?

Yes, definitely.

> 
> Otherwise:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks.

I've pushed this to next.  If anyone finds that objectionable, we can
always drop that patch again and pursue another resolution.

Thanks,
-Christoffer
