From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/17] kvm-arm: Replace kvm_pmd_huge with
 pmd_thp_or_huge
Date: Thu, 14 Apr 2016 15:15:05 +0100
Message-ID: <570FA5E9.4040800@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <1460640065-27658-6-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460640065-27658-6-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, christoffer.dall@linaro.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 14/04/16 14:20, Suzuki K Poulose wrote:
> Both arm and arm64 now provides a helper, pmd_thp_or_huge()
> to check if the given pmd represents a huge page. Use that
> instead of our own custom check.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
