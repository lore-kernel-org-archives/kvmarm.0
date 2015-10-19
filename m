From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCHv4 18/24] arm64/kvm: Make use of the system wide safe
 values
Date: Mon, 19 Oct 2015 15:39:36 +0200
Message-ID: <20151019133936.GF24104@cbox>
References: <1445261101-22344-1-git-send-email-suzuki.poulose@arm.com>
 <1445261101-22344-19-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445261101-22344-19-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, steve.capper@linaro.org, Vladimir.Murzin@arm.com, james.morse@arm.com, andre.przywara@arm.com, ryan.arnold@linaro.org, aph@redhat.com, edward.nevill@linaro.org, dave.martin@arm.com, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 02:24:55PM +0100, Suzuki K. Poulose wrote:
> Use the system wide safe value from the new API for safer
> decisions
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/reset.c    |    2 +-
>  arch/arm64/kvm/sys_regs.c |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)

I assume Catalin or Will can take this with the rest of the series
through the arm64 tree, right?

-Christoffer
