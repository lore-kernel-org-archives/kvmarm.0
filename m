From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCHv4 18/24] arm64/kvm: Make use of the system wide safe
 values
Date: Mon, 19 Oct 2015 16:26:54 +0100
Message-ID: <20151019152654.GD11226@e104818-lin.cambridge.arm.com>
References: <1445261101-22344-1-git-send-email-suzuki.poulose@arm.com>
 <1445261101-22344-19-git-send-email-suzuki.poulose@arm.com>
 <20151019133936.GF24104@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151019133936.GF24104@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "Suzuki K. Poulose" <suzuki.poulose@arm.com>, mark.rutland@arm.com, Vladimir.Murzin@arm.com, steve.capper@linaro.org, ryan.arnold@linaro.org, ard.biesheuvel@linaro.org, aph@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, edward.nevill@linaro.org, james.morse@arm.com, andre.przywara@arm.com, marc.zyngier@arm.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 03:39:36PM +0200, Christoffer Dall wrote:
> On Mon, Oct 19, 2015 at 02:24:55PM +0100, Suzuki K. Poulose wrote:
> > Use the system wide safe value from the new API for safer
> > decisions
> > 
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/reset.c    |    2 +-
> >  arch/arm64/kvm/sys_regs.c |   12 ++++++------
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> I assume Catalin or Will can take this with the rest of the series
> through the arm64 tree, right?

Yes.

-- 
Catalin
