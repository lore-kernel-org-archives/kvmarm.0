From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Thu, 03 Dec 2015 10:05:59 +0000
Message-ID: <56601407.7020407@arm.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <cover.1449136209.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 09:58, Pavel Fedin wrote:
> ARM64 CPU has zero register which is read-only, with a value of 0.
> However, KVM currently incorrectly recognizes it being SP (because
> Rt == 31, and in struct user_pt_regs 'regs' array is followed by SP),
> resulting in invalid value being read, or even SP corruption on write.

No really. XZR and SP do share the same encoding.

> The problem has been discovered by performing an operation
> 
>  *((volatile int *)reg) = 0;
> 
> which compiles as "str xzr, [xx]", and resulted in strange values being
> written.

Interesting find. Which compiler is that?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
