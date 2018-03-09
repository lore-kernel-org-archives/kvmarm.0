From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP
 hardening
Date: Fri, 9 Mar 2018 13:48:09 +0000
Message-ID: <20180309134809.GC15537@arm.com>
References: <1520269603-2900-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520269603-2900-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <cdall@kernel.org>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Thomas Speier <tspeier@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi SHanker,

On Mon, Mar 05, 2018 at 11:06:43AM -0600, Shanker Donthineni wrote:
> The function SMCCC_ARCH_WORKAROUND_1 was introduced as part of SMC
> V1.1 Calling Convention to mitigate CVE-2017-5715. This patch uses
> the standard call SMCCC_ARCH_WORKAROUND_1 for Falkor chips instead
> of Silicon provider service ID 0xC2001700.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
> Chnages since v1:
>   - Trivial change in cpucaps.h (refresh after removing ARM64_HARDEN_BP_POST_GUEST_EXIT)
> 
>  arch/arm64/include/asm/cpucaps.h |  5 ++--
>  arch/arm64/include/asm/kvm_asm.h |  2 --
>  arch/arm64/kernel/bpi.S          |  8 ------
>  arch/arm64/kernel/cpu_errata.c   | 55 ++++++++++++++--------------------------
>  arch/arm64/kvm/hyp/entry.S       | 12 ---------
>  arch/arm64/kvm/hyp/switch.c      | 10 --------
>  6 files changed, 21 insertions(+), 71 deletions(-)

Could you reply to my outstanding question on the last version of this patch
please?

http://lists.infradead.org/pipermail/linux-arm-kernel/2018-March/564194.html

Will
