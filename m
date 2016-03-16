From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 03/12] arm64: kvm: Cleanup VTCR_EL2/VTTBR computation
Date: Wed, 16 Mar 2016 15:45:07 +0000
Message-ID: <20160316154507.1281dc25@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-4-git-send-email-suzuki.poulose@arm.com>
 <56E9755C.9090701@arm.com> <56E97DAE.2030704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 472B749B61
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2016 11:44:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5FMFmlKSED5p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2016 11:44:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72A8549B56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2016 11:44:48 -0400 (EDT)
In-Reply-To: <56E97DAE.2030704@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 16 Mar 2016 15:37:18 +0000
"Suzuki K. Poulose" <Suzuki.Poulose@arm.com> wrote:

> On 16/03/16 15:01, Marc Zyngier wrote:
> > On 14/03/16 16:53, Suzuki K Poulose wrote:
> >> No functional changes. Group the common bits for VCTR_EL2
> >> initialisation for better readability. The granule size
> >> and the entry level are controlled by the page size.
> 
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> >> index b7d61e4..d49dd50 100644
> >> --- a/arch/arm64/include/asm/kvm_arm.h
> >> +++ b/arch/arm64/include/asm/kvm_arm.h
> >> @@ -139,32 +139,30 @@
> >>    * The magic numbers used for VTTBR_X in this patch can be found in Tables
> >>    * D4-23 and D4-25 in ARM DDI 0487A.b.
> >>    */
> 
> ...
> 
> >>
> >> +#define VTCR_EL2_FLAGS		(VTCR_EL2_TGRAN_FLAGS | VTCR_EL2_COMMON_BITS)
> >> +#define VTTBR_X			((VTTBR_X_TGRAN_MAGIC) - VTCR_EL2_T0SZ_40B)
> >
> > Nit: spurious brackets.
>   
> Will remove them.
> 
> > It would be nice to add an ARMv8 ARM reference to where the "magic"
> > value is coming from.
> 
> That reference already exists in the code, see above.

Ah, good point!

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
