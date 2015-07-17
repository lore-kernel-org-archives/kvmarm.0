From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd, saves
 30-50% on exits
Date: Fri, 17 Jul 2015 11:28:09 +0100
Message-ID: <55A8D8B9.2050903@arm.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/15 22:29, Mario Smarduch wrote:
> Currently we save/restore fp/simd on each exit. The first patch optimizes arm64
> save/restore, we only do so on Guest access. hackbench and several lmbench
> tests show anywhere from 30% to 50% of exits don't context switch the vfp/simd
> registers.
> 
> For second patch 32-bit handler is updated to keep exit handling consistent
> with 64-bit code.

This looks pretty good, I'll take these patches in for 4.3.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
