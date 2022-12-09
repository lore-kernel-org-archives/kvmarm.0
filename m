Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540ECC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:25:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7E764B936;
	Fri,  9 Dec 2022 12:25:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id blE1nuPSOHBu; Fri,  9 Dec 2022 12:25:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65D534B97B;
	Fri,  9 Dec 2022 12:25:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6654B938
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:25:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KyH+fqe9erw7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:25:01 -0500 (EST)
Received: from out-216.mta0.migadu.com (out-216.mta0.migadu.com
 [91.218.175.216])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E9264B936
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:25:01 -0500 (EST)
Date: Fri, 9 Dec 2022 17:24:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670606700;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sbHd3TvFPLETZHNVBUCcer9R9cb69+aHOJviFvExi4Y=;
 b=myof8e9+vePyEh1XAVMIRcDm8q1jyelUp0oMG47QgTKeMP8Ad9MLe/+7riFT55TVEnMYX8
 7B84ih0UqSmmSzalw4eYcdn7TGzMbR//yFaIlKDe2lSOL8s23+xUh0Njytzg/zI8dV/8zF
 cfDPbjEUYbw41qF2SIUp1mnpdTfjg4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5NvYmxpy6BPkmpW@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
X-Migadu-Flow: FLOW_OUT
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "Amit,
 Nadav" <namit@vmware.com>, Ben Gardon <bgardon@google.com>,
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
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
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

On Fri, Dec 09, 2022 at 10:37:47AM +0800, Yang, Weijiang wrote:
> 
> On 12/9/2022 3:38 AM, David Matlack wrote:
> > Rename kvm_mmu_page_role.smm with kvm_mmu_page_role.as_id and use it
> > directly as the address space ID throughout the KVM MMU code. This
> > eliminates a needless level of indirection, kvm_mmu_role_as_id(), and
> > prepares for making kvm_mmu_page_role architecture-neutral.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  4 ++--
> >   arch/x86/kvm/mmu/mmu.c          |  6 +++---
> >   arch/x86/kvm/mmu/mmu_internal.h | 10 ----------
> >   arch/x86/kvm/mmu/tdp_iter.c     |  2 +-
> >   arch/x86/kvm/mmu/tdp_mmu.c      | 12 ++++++------
> >   5 files changed, 12 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index aa4eb8cfcd7e..0a819d40131a 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -348,7 +348,7 @@ union kvm_mmu_page_role {
> >   		 * simple shift.  While there is room, give it a whole
> >   		 * byte so it is also faster to load it from memory.
> >   		 */
> > -		unsigned smm:8;
> > +		unsigned as_id:8;
> >   	};
> >   };
> > @@ -2056,7 +2056,7 @@ enum {
> >   # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> >   # define KVM_ADDRESS_SPACE_NUM 2
> >   # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> > -# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> > +# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).as_id)
> >   #else
> >   # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
> >   #endif
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 4d188f056933..f375b719f565 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> >   	union kvm_cpu_role role = {0};
> >   	role.base.access = ACC_ALL;
> > -	role.base.smm = is_smm(vcpu);
> > +	role.base.as_id = is_smm(vcpu);
> 
> I'm not familiar with other architectures, is there similar conception as
> x86 smm mode?

For KVM/arm64:

No, we don't do anything like SMM emulation on x86. Architecturally
speaking, though, we do have a higher level of privilege typically
used by firmware on arm64, called EL3.

I'll need to read David's series a bit more closely, but I'm inclined to
think that the page role is going to be rather arch-specific.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
