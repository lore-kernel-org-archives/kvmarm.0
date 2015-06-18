From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/2] arm64: KVM: Optimize arm64 fp/simd save/restore
Date: Thu, 18 Jun 2015 18:04:14 +0100
Message-ID: <5582FA0E.6030409@arm.com>
References: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com> <1434491452-19177-2-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434491452-19177-2-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/06/15 22:50, Mario Smarduch wrote:
> This patch only saves and restores FP/SIMD registers on Guest access. To do
> this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
> lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
> context is not saved/restored
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>

Looks nice and clean.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
