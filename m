From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: mm: Add additional parameter to
 uaccess_ttbr0_enable
Date: Tue, 9 Jan 2018 13:53:56 +0000
Message-ID: <3e459188-f759-6f13-7ab4-1597c6da00a7@arm.com>
References: <20180109134326.17479-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180109134326.17479-1-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/01/18 13:43, Christoffer Dall wrote:
> Add an extra temporary register parameter to uaccess_ttbr0_enable which
> is about to be required for arm64 PAN support.
> 
> This patch doesn't introduce any functional change but ensures that the
> kernel compiles once the KVM/ARM tree is merged with the arm64 tree by
> ensuring a trivially mergable conflict.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Maybe worth adding that this matches
27a921e75711d924617269e0ba4adb8bae9fd0d1 ("arm64: mm: Fix and re-enable
ARM64_SW_TTBR0_PAN")?

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks for taking care of this.

	M.
-- 
Jazz is not dead. It just smells funny...
