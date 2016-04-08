From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 13/17] kvm-arm: Add stage2 page table modifiers
Date: Fri, 8 Apr 2016 19:25:10 +0200
Message-ID: <20160408172510.GD13247@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-14-git-send-email-suzuki.poulose@arm.com>
 <20160408134257.GW8961@cbox> <5707D01E.1050309@arm.com>
 <20160408170302.GA13247@cbox> <5707E541.5040205@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CDB540B40
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 13:23:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2xND2blTdAPw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 13:23:30 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 790284053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 13:23:30 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id 191so24905793wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 10:24:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5707E541.5040205@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 08, 2016 at 06:07:13PM +0100, Suzuki K Poulose wrote:
> On 08/04/16 18:03, Christoffer Dall wrote:
> >On Fri, Apr 08, 2016 at 04:37:02PM +0100, Suzuki K Poulose wrote:
> >>On 08/04/16 14:42, Christoffer Dall wrote:
> >>>On Mon, Apr 04, 2016 at 05:26:13PM +0100, Suzuki K Poulose wrote:
> >>
> >>>>
> >>>>-static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
> >>>>+static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
> >>>>  {
> >>>>-	pmd_t *pmd_table = pmd_offset(pud, 0);
> >>>>-	VM_BUG_ON(pud_huge(*pud));
> >>>>-	pud_clear(pud);
> >>>>+	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(pud, 0);
> >>>
> >>>The __maybe_unused are slightly ugly, so it may be nicer to create the
> >>>stage2_pmd_free() as static inline's if they're defined to do nothing
> >>>instead.
> >>>
> >>
> >>Sure, we could do that for stage2. However, we will need to fix the host helpers
> >>as well for making such a change in the _hyp version (for 16K + 36bit VA).
> >>
> >
> >I thought the host helpers were already done like that, since we don't
> >need the __maybe_unused currently.  If it involves changing core code
> >etc. then don't bother.
> 
> Unfortunately no, e.g,
> 
> include/asm-generic/pgtable-nopud.h defines:
> 
> #define pud_free(mm, x)                         do { } while (0)
> 

Leave it then :)

Thanks,
-Christoffer
