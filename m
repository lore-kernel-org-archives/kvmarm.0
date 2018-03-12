From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 03/23] arm64: insn: Add encoder for bitwise operations
 using literals
Date: Mon, 12 Mar 2018 14:44:43 +0000
Message-ID: <20aed108-d44e-89b9-0532-cad5fbb27f46@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180301155538.26860-4-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <James.Morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/18 15:55, Marc Zyngier wrote:
> We lack a way to encode operations such as AND, ORR, EOR that take
> an immediate value. Doing so is quite involved, and is all about
> reverse engineering the decoding algorithm described in the
> pseudocode function DecodeBitMasks().
> 
> This has been tested by feeding it all the possible literal values
> and comparing the output with that of GAS.

This is getting quite funny. Although the test harness was 100% matching
the GAS encoding...

[...]

> +	/*
> +	 * Inverse of Replicate(). Try to spot a repeating pattern
> +	 * with a pow2 stride.
> +	 */
> +	for (tmp = esz / 2; tmp >= 2; tmp /= 2) {
> +		u64 emask = BIT(tmp) - 1;
> +
> +		if ((imm & emask) != ((imm >> (tmp / 2)) & emask))

... I failed to move a fix from the test harness to the kernel code.
Total fail. Here, "(tmp / 2)" should really read "tmp".

Thanks to James for noticing the breakage.

	M. (annoyed)
-- 
Jazz is not dead. It just smells funny...
