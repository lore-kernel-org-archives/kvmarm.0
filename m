Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F472C4708D
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:41:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D90EF4B9E4;
	Fri,  9 Dec 2022 12:41:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4etEiIpNpebW; Fri,  9 Dec 2022 12:41:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 979F34B994;
	Fri,  9 Dec 2022 12:41:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7CD4B983
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2OERAigNNoNt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:41:15 -0500 (EST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 351B44B97E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:41:15 -0500 (EST)
Received: by mail-yb1-f182.google.com with SMTP id f139so6109945yba.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 09:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Ae7igBpi6aOVu172YIUgxS7qKV+pzUf0AUP0I5I75q8=;
 b=N+7B9/rCWK5Sp2/p4Ir8f6MIvbqCGaqwi8Po2oncdcAwLhGA2JbFygWWQUv6V6CPMa
 5qEu3kJoWRw2vCClh6Nppk6pcE8Gs4F+bRtzVoiff0JJsexRmVNGr2a680WUghXF5FfZ
 hJT8t5JkmvW4LhfLt9VxecKUoVAgOFMQFaEgzYrErkPW87ek/r4P8aluMVRPjzuoCpmc
 s8hnbdPk8IjCsgDtQ2r43eSt/10ErW7paYLAy3fVr+Nls1PaCuUT+RlvNLCKRaMhvrdb
 84/0ge7Jjg4S3PzFHcaNOXRMWYnTQH+nKv2Q4uZnvxishqyp8n2lzRaNXljaSz/ExQZQ
 ySPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Ae7igBpi6aOVu172YIUgxS7qKV+pzUf0AUP0I5I75q8=;
 b=hkOoPdHx6kcli0TaVSnZ4Lwwbk4Z8Lwb2HNTdpJF7KLshZXM4rEgTcWtg0s3tzJkxT
 2owLs0NsaOwxIfj1/QE6VVDBQgDVl+nsqnwfAWfs55K1DPVKaSYoZmZBl8P/EsKZF6qo
 KnmAKBeArsptglwvnPgC+lnTnI2t1QKM0wnW7zYozlE9E5e8cei626160RmwKXf7oW6L
 eLtVnZ6ze979CH6jmUoiNsAs0P5TrCDFAlKjMui/EOy6jVq5jBYMPziMXASMNpRjkF4q
 fVqSvUM/ac5uIj8QhuFCpFElL6f/6qQxIS1x3R0XYyA9myegnYPhLDbQqdNvawVxdhAe
 ZudA==
X-Gm-Message-State: ANoB5pmI+yaS9rUbbM+anpBMAxJzJc8EwL3b+1c0zNyf4Pu9UrbLCFXA
 gepOg7S/rnupaZKI75Y4/6KIYou3JFfOic0OQ+Qigg==
X-Google-Smtp-Source: AA0mqf5h6EJUa8o1mU6n0d18d5R9db+bCd1t++iK380my63/Q1gFej7B2AoWgEI4of2L90azWCjh0YyRl3fL7yBolSs=
X-Received: by 2002:a25:742:0:b0:6fd:6aa4:82a5 with SMTP id
 63-20020a250742000000b006fd6aa482a5mr25244378ybh.305.1670607674506; Fri, 09
 Dec 2022 09:41:14 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com> <Y5NvYmxpy6BPkmpW@google.com>
In-Reply-To: <Y5NvYmxpy6BPkmpW@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 9 Dec 2022 09:40:48 -0800
Message-ID: <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 Colin Cross <ccross@google.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Fri, Dec 9, 2022 at 9:25 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Fri, Dec 09, 2022 at 10:37:47AM +0800, Yang, Weijiang wrote:
> >
> > On 12/9/2022 3:38 AM, David Matlack wrote:
> > > Rename kvm_mmu_page_role.smm with kvm_mmu_page_role.as_id and use it
> > > directly as the address space ID throughout the KVM MMU code. This
> > > eliminates a needless level of indirection, kvm_mmu_role_as_id(), and
> > > prepares for making kvm_mmu_page_role architecture-neutral.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >   arch/x86/include/asm/kvm_host.h |  4 ++--
> > >   arch/x86/kvm/mmu/mmu.c          |  6 +++---
> > >   arch/x86/kvm/mmu/mmu_internal.h | 10 ----------
> > >   arch/x86/kvm/mmu/tdp_iter.c     |  2 +-
> > >   arch/x86/kvm/mmu/tdp_mmu.c      | 12 ++++++------
> > >   5 files changed, 12 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index aa4eb8cfcd7e..0a819d40131a 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -348,7 +348,7 @@ union kvm_mmu_page_role {
> > >              * simple shift.  While there is room, give it a whole
> > >              * byte so it is also faster to load it from memory.
> > >              */
> > > -           unsigned smm:8;
> > > +           unsigned as_id:8;
> > >     };
> > >   };
> > > @@ -2056,7 +2056,7 @@ enum {
> > >   # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> > >   # define KVM_ADDRESS_SPACE_NUM 2
> > >   # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> > > -# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> > > +# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).as_id)
> > >   #else
> > >   # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
> > >   #endif
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 4d188f056933..f375b719f565 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> > >     union kvm_cpu_role role = {0};
> > >     role.base.access = ACC_ALL;
> > > -   role.base.smm = is_smm(vcpu);
> > > +   role.base.as_id = is_smm(vcpu);
> >
> > I'm not familiar with other architectures, is there similar conception as
> > x86 smm mode?

The notion of address spaces is already existing architecture-neutral
concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
Architectures that do not use multiple address spaces will just leave
as_id is as always 0.

>
> For KVM/arm64:
>
> No, we don't do anything like SMM emulation on x86. Architecturally
> speaking, though, we do have a higher level of privilege typically
> used by firmware on arm64, called EL3.
>
> I'll need to read David's series a bit more closely, but I'm inclined to
> think that the page role is going to be rather arch-specific.

Yes most of the fields are in the arch-specific sub-role. The TDP MMU
only needs to know about the as_id, level, and invalid bits. (See next
patch.)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
