Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34A5C4708D
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 00:18:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 490784B88D;
	Wed,  7 Dec 2022 19:18:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9MNPKzJ295pH; Wed,  7 Dec 2022 19:18:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A56204B871;
	Wed,  7 Dec 2022 19:18:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AFD94B863
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:18:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XLpzq08qOgkL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 19:17:59 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE8464B83B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:17:58 -0500 (EST)
Date: Thu, 8 Dec 2022 00:17:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670458677;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mM+RUREs8XNQIXR9OLpX5FpMS6Cj+6d+9P8d8/tGhYQ=;
 b=ku/5sjzdHABEj1t0G+fh8i2C1G7TPlKULEuuL0AsGRUb9Ux6kV59QeDru18AX6//yF0gQQ
 qi9glC8ovSUnX0pEdAH+zSKl6LwdATrWKndnT9rxxTgYbq5nvQ5YxEWiKGiwHKt1PKXK4y
 q+b7skuzGcfVu+l+lCWV2z9h/98c+6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5EtMWuTaJk9I3Bd@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5EoZ5uwrTF3eSKw@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Dec 07, 2022 at 11:57:27PM +0000, Sean Christopherson wrote:
> On Wed, Dec 07, 2022, Oliver Upton wrote:
> > The new ucall infrastructure needs to update a couple of guest globals
> > to pass through the ucall MMIO addr and pool of ucall structs. A
> > precondition of this actually working is to have the program image
> > already loaded into guest memory.
> 
> Ouch.  Might be worth explicitly stating what goes wrong.  Even though it's super
> obvious in hindsight, it still took me a few seconds to understand what
> precondition you were referring to, e.g. I was trying to figure out how selecting
> the MMIO address depended on the guest code being loaded...
> 
> > 
> > Call ucall_init() after kvm_vm_elf_load(). Continue to park the ucall
> > MMIO addr after MEM_REGION_TEST_DATA.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/aarch64/page_fault_test.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > index 92d3a91153b6..95d22cfb7b41 100644
> > --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > @@ -609,8 +609,13 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
> >  				    data_size / guest_page_size,
> >  				    p->test_desc->data_memslot_flags);
> >  	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
> > +}
> > +
> > +static void setup_ucall(struct kvm_vm *vm)
> > +{
> > +	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
> >  
> > -	ucall_init(vm, data_gpa + data_size);
> > +	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);
> 
> Isn't there a hole after CODE_AND_DATA_MEMSLOT?  I.e. after memslot 0?

Sure, but that's only guaranteed in the PA space.

> The reason
> I ask is because if so, then we can do the temporarily heinous, but hopefully forward
> looking thing of adding a helper to wrap kvm_vm_elf_load() + ucall_init().
> 
> E.g. I think we can do this immediately, and then at some point in the 6.2 cycle
> add a dedicated region+memslot for the ucall MMIO page.

Even still, that's just a kludge to make ucalls work. We have other
MMIO devices (GIC distributor, for example) that work by chance since
nothing conflicts with the constant GPAs we've selected in the tests.

I'd rather we go down the route of having an address allocator for the
for both the VA and PA spaces to provide carveouts at runtime. There's
another issue with the new ucall implementation where identity mapping
could stomp on a program segment that I'm fighting with right now which
only further highlights the problems with our (mis)management of address
spaces in selftests.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
