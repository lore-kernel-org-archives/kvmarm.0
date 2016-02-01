From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 06/21] arm64: KVM: VHE: Patch out use of HVC
Date: Mon, 1 Feb 2016 15:36:35 +0000
Message-ID: <20160201153635.GH15514@e104818-lin.cambridge.arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
 <20160201131634.GI1478@cbox> <56AF5ED8.7010303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD1240BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:31:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sGwGs1p9npFK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 10:31:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A2340F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:31:21 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <56AF5ED8.7010303@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 01, 2016 at 01:34:16PM +0000, Marc Zyngier wrote:
> On 01/02/16 13:16, Christoffer Dall wrote:
> > On Mon, Jan 25, 2016 at 03:53:40PM +0000, Marc Zyngier wrote:
> >> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >> index 93e8d983..9e0683f 100644
> >> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >> @@ -38,6 +38,32 @@
> >>  	ldp	x0, x1, [sp], #16
> >>  .endm
> >>  
> >> +.macro do_el2_call
> >> +	/*
> >> +	 * Shuffle the parameters before calling the function
> >> +	 * pointed to in x0. Assumes parameters in x[1,2,3].
> >> +	 */
> >> +	stp	lr, xzr, [sp, #-16]!
> > 
> > remind me why this pair isn't just doing "str" instead of "stp" with the
> > xzr ?
> 
> Because SP has to be aligned on a 16 bytes boundary at all times.

You could do something like:

	sub	sp, sp, #16
	str	lr, [sp]

-- 
Catalin
