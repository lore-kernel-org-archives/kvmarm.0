Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83209C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 23:00:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112B94BA22;
	Wed,  9 Nov 2022 18:00:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iRypYpT1uI40; Wed,  9 Nov 2022 18:00:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9411D4BA2B;
	Wed,  9 Nov 2022 18:00:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB314BA22
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:00:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5llxUeyfg7yc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 18:00:50 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65B5F4BA1C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 18:00:50 -0500 (EST)
Date: Wed, 9 Nov 2022 23:00:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668034845;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OAL3R3TEKZCss1R/iPyj1G2fURtMnDVaBxLRl/VPrsA=;
 b=vhUPHWUBXtfmpqLpsM84/OLlBTCq9M8Uf/LpS1LM+w+HDLUEHKKf+Cgmc8whr/XLEJ77qV
 OWYRu6RjKo1hKaOnTiT9M5Jj+L412Cz5b0pi1zQSzL2BC85JmGgitQo9fXiyjEoJ1EYAV0
 M45hAyalGoHztvrdpdPiMXbwvkA6N9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 10/14] KVM: arm64: Split init and set for table PTE
Message-ID: <Y2wxGS+Y9EquPVQY@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-11-oliver.upton@linux.dev>
 <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Nov 09, 2022 at 02:26:26PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Create a helper to initialize a table and directly call
> > smp_store_release() to install it (for now). Prepare for a subsequent
> > change that generalizes PTE writes with a helper.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index a34e2050f931..f4dd77c6c97d 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
> >         WRITE_ONCE(*ptep, 0);
> >  }
> >
> > -static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> > -                             struct kvm_pgtable_mm_ops *mm_ops)
> > +static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > -       kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> > +       kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> >
> >         pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
> >         pte |= KVM_PTE_VALID;
> > -
> > -       WARN_ON(kvm_pte_valid(old));
> 
> Is there any reason to drop this warning?

It is (eventually) superseded by a WARN() when a PTE isn't locked in
stage2_make_pte(), but that isn't obvious in this patch alone.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
