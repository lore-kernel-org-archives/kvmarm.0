From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH V2 3/10] KVM/MMU: Add last_level in the struct
 mmu_spte_page
Date: Fri, 15 Feb 2019 23:05:21 +0800
Message-ID: <CAOLK0pzXnvk=FsfjH07jUyRJGpeiNG7-9vR9Vo0mLJtdPnt_7Q@mail.gmail.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
 <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
 <572a6ce3-23f6-7b16-a070-4d4a81ee4335@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A154A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 10:05:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WeH0+o-kfDM0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Feb 2019 10:05:33 -0500 (EST)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61D7A40493
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 10:05:33 -0500 (EST)
Received: by mail-pg1-f194.google.com with SMTP id v28so4922313pgk.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 07:05:33 -0800 (PST)
In-Reply-To: <572a6ce3-23f6-7b16-a070-4d4a81ee4335@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, ralf@linux-mips.org, paul.burton@mips.com, Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 15, 2019 at 12:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/02/19 02:38, lantianyu1986@gmail.com wrote:
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index ce770b446238..70cafd3f95ab 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -2918,6 +2918,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >
> >       if (level > PT_PAGE_TABLE_LEVEL)
> >               spte |= PT_PAGE_SIZE_MASK;
> > +
> > +     sp->last_level = is_last_spte(spte, level);
>
> Wait, I wasn't thinking straight.  If a struct kvm_mmu_page exists, it
> is never the last level.  Page table entries for the last level do not
> have a struct kvm_mmu_page.
>
> Therefore you don't need the flag after all.  I suspect your
> calculations in patch 2 are off by one, and you actually need
>
>         hlist_for_each_entry(sp, range->flush_list, flush_link) {
>                 int pages = KVM_PAGES_PER_HPAGE(sp->role.level + 1);
>                 ...
>         }
>
> For example, if sp->role.level is 1 then the struct kvm_mmu_page is for
> a page containing PTEs and covers an area of 2 MiB.

Yes, you are right. Thanks to point out and will fix. The last_level
flag is to avoid adding middle page node(e.g, PGD, PMD)
into flush list. The address range will be duplicated if adding both
leaf, node and middle node into flush list.

>
> Thanks,
>
> Paolo
>
> >       if (tdp_enabled)
> >               spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
> >                       kvm_is_mmio_pfn(pfn));
>


-- 
Best regards
Tianyu Lan
