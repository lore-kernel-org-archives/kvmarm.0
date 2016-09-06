From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC v2 PATCH 4/7] arm64: tlbflush.h: add __tlbi() macro
Date: Tue, 6 Sep 2016 19:17:10 +0100
Message-ID: <20160906181710.GF29382@arm.com>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-5-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9776B409A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 14:08:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZV7wclxgAnCN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 14:08:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF974011D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 14:08:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1473093097-30932-5-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 05, 2016 at 05:31:34PM +0100, Punit Agrawal wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> As with dsb() and isb(), add a __tlbi() helper so that we can avoid
> distracting asm boilerplate every time we want a TLBI. As some TLBI
> operations take an argument while others do not, some pre-processor is
> used to handle these two cases with different assembly blocks.
> 
> The existing tlbflush.h code is moved over to use the helper.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> [ rename helper to __tlbi, update commit log ]
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index b460ae2..e9e42a7 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -25,6 +25,21 @@
>  #include <asm/cputype.h>
>  
>  /*
> + * Raw TLBI operations. Drivers and most kernel code should use the TLB
> + * management routines below in preference to these. Where necessary, these can
> + * be used to avoid asm() boilerplate.
> + *
> + * Can be used as __tlbi(op) or __tlbi(op, arg), depending on whether a
> + * particular TLBI op takes an argument or not. The macros below handle invoking
> + * the asm with or without the register argument as appropriate.
> + */
> +#define __TLBI_0(op, arg)		asm ("tlbi " #op)
> +#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
> +#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
> +
> +#define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)

This looks ok to me now. With Christoffer's comments address:

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
