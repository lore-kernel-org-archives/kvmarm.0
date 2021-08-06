Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44C6C4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 12:49:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 277D5611C5
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 12:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 277D5611C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC01D4A319;
	Fri,  6 Aug 2021 08:49:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uzVvAWQhYpi9; Fri,  6 Aug 2021 08:49:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D01ED4B0DE;
	Fri,  6 Aug 2021 08:49:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CBEF4B0DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 08:49:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4l12qEmoWHkF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 08:49:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 258A24A319
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 08:49:55 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF4661181;
 Fri,  6 Aug 2021 12:49:52 +0000 (UTC)
Date: Fri, 6 Aug 2021 13:49:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/4] arm64: mm: Fix TLBI vs ASID rollover
Message-ID: <20210806124944.GK6719@arm.com>
References: <20210806113109.2475-1-will@kernel.org>
 <20210806113109.2475-2-will@kernel.org>
 <20210806115927.GJ6719@arm.com>
 <20210806124241.GA2814@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806124241.GA2814@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 stable@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jade Alglave <jade.alglave@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Aug 06, 2021 at 01:42:42PM +0100, Will Deacon wrote:
> On Fri, Aug 06, 2021 at 12:59:28PM +0100, Catalin Marinas wrote:
> > On Fri, Aug 06, 2021 at 12:31:04PM +0100, Will Deacon wrote:
> > > diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> > > index 75beffe2ee8a..e9c30859f80c 100644
> > > --- a/arch/arm64/include/asm/mmu.h
> > > +++ b/arch/arm64/include/asm/mmu.h
> > > @@ -27,11 +27,32 @@ typedef struct {
> > >  } mm_context_t;
> > >  
> > >  /*
> > > - * This macro is only used by the TLBI and low-level switch_mm() code,
> > > - * neither of which can race with an ASID change. We therefore don't
> > > - * need to reload the counter using atomic64_read().
> > > + * We use atomic64_read() here because the ASID for an 'mm_struct' can
> > > + * be reallocated when scheduling one of its threads following a
> > > + * rollover event (see new_context() and flush_context()). In this case,
> > > + * a concurrent TLBI (e.g. via try_to_unmap_one() and ptep_clear_flush())
> > > + * may use a stale ASID. This is fine in principle as the new ASID is
> > > + * guaranteed to be clean in the TLB, but the TLBI routines have to take
> > > + * care to handle the following race:
> > > + *
> > > + *    CPU 0                    CPU 1                          CPU 2
> > > + *
> > > + *    // ptep_clear_flush(mm)
> > > + *    xchg_relaxed(pte, 0)
> > > + *    DSB ISHST
> > > + *    old = ASID(mm)
> > 
> > We'd need specs clarified (ARM ARM, cat model) that the DSB ISHST is
> > sufficient to order the pte write with the subsequent ASID read.
> 
> Although I agree that the cat model needs updating and also that the Arm
> ARM isn't helpful by trying to define DMB and DSB at the same time, it
> does clearly state the following:
> 
>   // B2-149
>   | A DSB instruction executed by a PE, PEe, completes when all of the
>   | following apply:
>   |
>   | * All explicit memory accesses of the required access types appearing
>   |   in program order before the DSB are complete for the set of observers
>   |   in the required shareability domain.
> 
>   [...]
> 
>   // B2-150
>   | In addition, no instruction that appears in program order after the
>   | DSB instruction can alter any state of the system or perform any part
>   | of its functionality until the DSB completes other than:
>   |
>   | * Being fetched from memory and decoded.
>   | * Reading the general-purpose, SIMD and floating-point, Special-purpose,
>   |   or System registers that are directly or indirectly read without
>   |   causing side-effects.
> 
> Which means that the ASID read cannot return its data before the DSB ISHST
> has completed and the DSB ISHST cannot complete until the PTE write has
> completed.

Thanks for the explanation.

> > Otherwise the patch looks fine to me:
> > 
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Thanks! Do you want to queue it for 5.15? I don't think there's a need to
> rush it into 5.14 given that we don't have any evidence of it happening
> in practice.

Happy to queue it for 5.15.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
