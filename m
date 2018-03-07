From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Wed, 7 Mar 2018 10:04:20 +0000
Message-ID: <20180307100419.GA9111@arm.com>
References: <1519877640-11944-1-git-send-email-shankerd@codeaurora.org>
 <20180306134405.GB18080@arm.com>
 <d6182273-c23a-c4fa-ce40-c87055bfb338@codeaurora.org>
 <20180306152318.GE17454@arm.com>
 <cbdce6fd-a1db-4f12-ccea-adfe9fe7c057@codeaurora.org>
 <dbc6e162-d245-a685-8bfe-f506d18e19e3@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dbc6e162-d245-a685-8bfe-f506d18e19e3@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 06, 2018 at 01:33:00PM -0600, Shanker Donthineni wrote:
> > I also confirmed with Thomas Speier, we can skip __flush_icache_all() if DIC=1.

Thanks,

> Planning to patch __flush_icache_all() itself instead of changing the callers. This
> way we can avoid "ic ialluis" completely. Is this okay for you? 
> 
> static inline void __flush_icache_all(void)
> {
>        /* Instruction cache invalidation is not required for I/D coherence? */
>       if (!cpus_have_const_cap(ARM64_HAS_CACHE_DIC)) {
>                asm("ic ialluis");
>                dsb(ish);
>        }
> }

Yup, that's what I meant, cheers.

Will
