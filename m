Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DB7C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 16:24:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E95D49E08;
	Fri,  1 Apr 2022 12:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L8lRQRw9HbUs; Fri,  1 Apr 2022 12:24:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F7F49EC3;
	Fri,  1 Apr 2022 12:24:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5585B4B22A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 17:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yh5Gqv7WS7Uj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 17:41:04 -0400 (EDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
 [209.85.208.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D49E94B1D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 17:41:03 -0400 (EDT)
Received: by mail-lj1-f182.google.com with SMTP id g24so1501747lja.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 14:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Rw60a4C/1buvlADobHgeyPYE1W+JkvNYCFomhSX9C/o=;
 b=e8LF8Ze6zOwPt6FFnClACWV3Jo+f6do+thni5aGwt3k2enqe+nuyyjgZR38Yppr/YT
 chMY6K4HfZZogZnG0SNby5Xd3KPWJtaiKDME29/XISJdc/xM37L/LXINl0tOn8ftgf0a
 8p/G0yOxS/uqQaue2tGvoYPNzXGg0Xg1vsAiM+Y7V7qZTqVwgwqU8DmaceQfIIKHE6ZK
 XYaw6qF/PswMla7HX7+k6mhIQkzuEyopPjxaCTxrXYbHadlmh4RXPZlq7Wpup4y3IDy+
 CO46Pqn2+l1c379SxtQtpcvUEVWa1Z3A2K7K8dwzPnLwb8ZOCYuN3uQXgEe7k+hvbm0J
 C1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Rw60a4C/1buvlADobHgeyPYE1W+JkvNYCFomhSX9C/o=;
 b=cik9ua8f1TWyLUf7gSOzDCYLDIaQZm2+g9SKG3dilL2rR3SNpxw6u+nkSaNrrxpZLS
 3sWa01ZDj2Jj8JqaqVSZr2GOXIuJ6V+cPaOwiU8Z/kRvd35jXMhgP/aFRvpSo55o+pNI
 qE81N7G2ZCEw5Un/j1e1aB+qMzELtCaH9lfi3TFrPTWIWlP+GKBrHlzHM/wyoitSJzm4
 XEI8x0hu50HeevKl5yv87+8pqAUWgmnAphPQPVXcwaf1uwk/Cke9yNZ9LyByNMz1stDb
 aeF/OhIKhdIDypE2L10/M1ygx4VzIV8qeaTfFAMx69Cu8N3dyc1/r3PjLU3GkxRmUVre
 fKVg==
X-Gm-Message-State: AOAM531G85L5QbCBW0xnXTfhGhLi/CkrnAgOzfOvHWjqepjAZgQz0L6t
 t5J/2EndgOnzmM3fHtSghQUnIFlvOpHPlkiEdi5ovg==
X-Google-Smtp-Source: ABdhPJy1FVLnw5Ep7uY/xe1k2URbIcy58oenF966+ZOMopXj2kVs4i0JqYBjG3cke0TiYjLEYAK4qaG8FpyHQsm1lvQ=
X-Received: by 2002:a2e:8913:0:b0:24a:fe47:36b with SMTP id
 d19-20020a2e8913000000b0024afe47036bmr1531024lji.361.1648762862151; Thu, 31
 Mar 2022 14:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local>
 <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
 <YkShwFaRqlQpyL87@xz-m1.local>
In-Reply-To: <YkShwFaRqlQpyL87@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Thu, 31 Mar 2022 14:40:35 -0700
Message-ID: <CALzav=cxm=A31PJOMes3eWpCV8s0zQGgaGZhYiQFJyxY2dNDXg@mail.gmail.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 12:24:11 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Wed, Mar 30, 2022 at 11:30 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Mar 22, 2022 at 03:51:54PM -0700, David Matlack wrote:
> > On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > > > In order to split a huge page we need to know what access bits to assign
> > > > to the role of the new child page table. This can't be easily derived
> > > > from the huge page SPTE itself since KVM applies its own access policies
> > > > on top, such as for HugePage NX.
> > > >
> > > > We could walk the guest page tables to determine the correct access
> > > > bits, but that is difficult to plumb outside of a vCPU fault context.
> > > > Instead, we can store the original access bits for each leaf SPTE
> > > > alongside the GFN in the gfns array. The access bits only take up 3
> > > > bits, which leaves 61 bits left over for gfns, which is more than
> > > > enough. So this change does not require any additional memory.
> > >
> > > I have a pure question on why eager page split needs to worry on hugepage
> > > nx..
> > >
> > > IIUC that was about forbidden huge page being mapped as executable.  So
> > > afaiu the only missing bit that could happen if we copy over the huge page
> > > ptes is the executable bit.
> > >
> > > But then?  I think we could get a page fault on fault->exec==true on the
> > > split small page (because when we copy over it's cleared, even though the
> > > page can actually be executable), but it should be well resolved right
> > > after that small page fault.
> > >
> > > The thing is IIUC this is a very rare case, IOW, it should mostly not
> > > happen in 99% of the use case?  And there's a slight penalty when it
> > > happens, but only perf-wise.
> > >
> > > As I'm not really fluent with the code base, perhaps I missed something?
> >
> > You're right that we could get away with not knowing the shadowed
> > access permissions to assign to the child SPTEs when splitting a huge
> > SPTE. We could just copy the huge SPTE access permissions and then let
> > the execute bit be repaired on fault (although those faults would be a
> > performance cost).
> >
> > But the access permissions are also needed to lookup an existing
> > shadow page (or create a new shadow page) to use to split the huge
> > page. For example, let's say we are going to split a huge page that
> > does not have execute permissions enabled. That could be because NX
> > HugePages are enabled or because we are shadowing a guest translation
> > that does not allow execution (or both). We wouldn't want to propagate
> > the no-execute permission into the child SP role.access if the
> > shadowed translation really does allow execution (and vice versa).
>
> Then the follow up (pure) question is what will happen if we simply
> propagate the no-exec permission into the child SP?
>
> I think that only happens with direct sptes where guest used huge pages
> because that's where the shadow page will be huge, so IIUC that's checked
> here when the small page fault triggers:
>
> static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>                                    unsigned direct_access)
> {
>         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
>                 struct kvm_mmu_page *child;
>
>                 /*
>                  * For the direct sp, if the guest pte's dirty bit
>                  * changed form clean to dirty, it will corrupt the
>                  * sp's access: allow writable in the read-only sp,
>                  * so we should update the spte at this point to get
>                  * a new sp with the correct access.
>                  */
>                 child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
>                 if (child->role.access == direct_access)
>                         return;
>
>                 drop_parent_pte(child, sptep);
>                 kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
>         }
> }
>
> Due to missing EXEC the role.access check will not match with direct
> access, which is the guest pgtable value which has EXEC set.  Then IIUC
> we'll simply drop the no-exec SP and replace it with a new one with exec
> perm.  The question is, would that untimately work too?
>
> Even if that works, I agree this sounds tricky because we're potentially
> caching fake sp.role conditionally and it seems we never do that before.
> It's just that the other option that you proposed here seems to add other
> way of complexity on caching spte permission information while kvm doesn't
> do either before.  IMHO we need to see which is the best trade off.

Clever! I think you're right that it would work correctly.

This approach avoids the need for caching access bits, but comes with downsides:
 - Performance impact from the extra faults needed to drop the SP and
repair the execute permission bit.
 - Some amount of memory overhead from KVM allocating new SPs when it
could re-use existing SPs.

Given the relative simplicity of access caching (and the fact that it
requires no additional memory), I'm inclined to stick with it rather
than taking the access permissions from the huge page.

>
> I could have missed something else, though.
>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
