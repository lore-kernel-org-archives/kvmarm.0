From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v1 1/3] arm64: add a macro for SError synchronization
Date: Wed, 1 Nov 2017 14:16:33 +0000
Message-ID: <20171101141603.4ppgwup4grnmcswe@lakrids.cambridge.arm.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
 <1509563697-6359-2-git-send-email-gengdongjiu@huawei.com>
 <6dc82768-8564-a54e-041b-3b9965fa038b@arm.com>
 <d7b8b779-9e00-8e8f-b44e-48e3d7e37058@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76DA849D24
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 10:15:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bL5u3stQztEE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Nov 2017 10:15:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68BEE41185
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 10:15:44 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <d7b8b779-9e00-8e8f-b44e-48e3d7e37058@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cov@codeaurora.org, Robin Murphy <robin.murphy@arm.com>, Dave.Martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 01, 2017 at 08:54:44PM +0800, gengdongjiu wrote:
> On 2017/11/1 19:24, Robin Murphy wrote:
> >> +	esb
> >> +alternative_else_nop_endif
> >> +1:
> >> +	.endm
> > Having a branch in here is pretty horrible, and furthermore using label
> > number 1 has a pretty high chance of subtly breaking code where this
> > macro is inserted.
> > 
> > Can we not somehow nest or combine the alternative conditions here?
> 
> I found it will report error if combine the alternative conditions here.
> 
> For example:
> 
> +	.macro	error_synchronize
> +alternative_if ARM64_HAS_IESB
> +alternative_if ARM64_HAS_RAS_EXTN
> +	esb
> +alternative_else_nop_endif
> +alternative_else_nop_endif
> +	.endm
> 
> And even using b.eq/cbz instruction in the alternative instruction in arch/arm64/kernel/entry.S,
> it will report Error.

Alternatives cannot be nested. You need to define a cap like:

  ARM64_HAS_RAS_NOT_IESB

... which is set when ARM64_HAS_RAS_EXTN && !ARM64_HAS_IESB.

Then you can do:

alternative_if ARM64_HAS_RAS_NOT_IESB
	esb
alternative_else_nop_endif

See ARM64_ALT_PAN_NOT_UAO for an example.

That said, as Robin points out we may not even need the alternative.

Thanks,
Mark.
