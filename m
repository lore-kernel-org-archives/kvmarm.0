From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm64: Fix comment for KVM_PHYS_SHIFT
Date: Mon, 18 Feb 2019 08:47:36 +0000
Message-ID: <20190218084736.651291a9@why.wild-wind.fr.eu.org>
References: <1550108746-14704-1-git-send-email-yuzenghui@huawei.com>
 <f14b90b1-ca81-e57e-9c42-6c8a4608cf72@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC124A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 03:47:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id urcTw7qjxomg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 03:47:41 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBE2740493
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 03:47:41 -0500 (EST)
In-Reply-To: <f14b90b1-ca81-e57e-9c42-6c8a4608cf72@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 14 Feb 2019 10:11:38 +0000
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Hi
> 
> On 14/02/2019 01:45, Zenghui Yu wrote:
> > Since Suzuki K Poulose's work on Dynamic IPA support, KVM_PHYS_SHIFT will
> > be used only when machine_type's bits[7:0] equal to 0 (by default). Thus
> > the outdated comment should be fixed.  
> > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>  
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > ---
> >   arch/arm64/include/asm/kvm_mmu.h | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)  
> > > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h  
> > index 8af4b1b..a12bf48 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -138,7 +138,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
> >   	})  
> >   >   /*  
> > - * We currently only support a 40bit IPA.
> > + * We currently support using a VM-specified IPA size. For backward
> > + * compatibility, the default IPA size is fixed to 40bits.
> >    */
> >   #define KVM_PHYS_SHIFT	(40)  
> 
> Thanks for the fix.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Applied, thanks.

	M.

-- 
Without deviation from the norm, progress is not possible.
