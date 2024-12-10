Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5C619E965
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733831478; cv=none; b=XD0pljw5y73dn3aJUEwkq/YaDplukjUDfkpVSYJ3TPd9XGkcx/vtZ1J2cqCVk50R1kpH6UzJ/491ToDkpERHFri5LQv2quRYLb4lHoIH2+UKVdS+Y2vHPeh83yr1T1a+Y2liQEPuyvj2UiiAS7clTtE8+0bbW/hTQAzgfkb8Sb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733831478; c=relaxed/simple;
	bh=anduOTmIBxlbtRSVrR9rw6ZEF3HxvogLPKl+dBOI080=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLbEcOgeF04TjtLcKK/VyazJCu3GIO5dJwkINt6n66xzCo8q4ZL5zCz8quqB4bld1TVPsirgMYUAzFp8xDSz82IuFSwLKm7P29cUFWycrsf/i0tAnD3rcDCOF7MH3dne8DW+/entW6HRVQcsqZ6Ion1Y/2iMAXrOnjLpFwg8xDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 983C0113E;
	Tue, 10 Dec 2024 03:51:42 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E09B23F5A1;
	Tue, 10 Dec 2024 03:51:13 -0800 (PST)
Date: Tue, 10 Dec 2024 11:51:10 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Add basic MTE test
Message-ID: <Z1grLp9SHbr0W6Mm@raptor>
References: <20241126095513.129737-1-vladimir.murzin@arm.com>
 <Z1G3QKefOxKtkfDj@raptor>
 <feed385c-22d0-4a32-b90f-1b63aa4487a1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feed385c-22d0-4a32-b90f-1b63aa4487a1@arm.com>

Hi Vladimir,

On Fri, Dec 06, 2024 at 10:50:38AM +0000, Vladimir Murzin wrote:
> Hi Alexandru,
> 
> On 12/5/24 14:26, Alexandru Elisei wrote:
> > Hi Vladimir,
> > 
> > This is very useful, thank you for writing the test.
> 
> Thanks for taking time reviewing it ;) 
> 
> > 
> > On Tue, Nov 26, 2024 at 09:55:13AM +0000, Vladimir Murzin wrote:
> >> Test tag storage access and tag mismatch for different MTE modes.
> >>
> >> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
[..]
> >> diff --git a/arm/mte.c b/arm/mte.c
> >> new file mode 100644
> >> index 00000000..ae8d8b75
> >> --- /dev/null
> >> +++ b/arm/mte.c
[..]
> >> +#define MTE_TCF_SYNC		0b01
> >> +#define MTE_TCF_ASYNC		0b10
> >> +#define MTE_TCF_ASYMM		0b11
> > Matches the definition for the SCTLR_EL1 TCF and TCF0 fields.
> > 
> > Do you think renaming MTE_TCF_ASYNC->MTE_TCF_ASYNC_ALL and
> > MTE_TCF_ASYMM -> MTE_TCF_ASYNC_WRITES makes it easier to understand?
> 
> I can add comment as remider about these settings:
> 
> /* Tag Check Faults cause a synchronous exception */
> #define MTE_TCF_SYNC	0b01
> /* Tag Check Faults are asynchronously accumulated */
> #define MTE_TCF_ASYNC	0b10
> /*
>  * Tag Check Faults cause a synchronous exception on reads,
>  * and are asynchronously accumulated on writes
>  */
> #define MTE_TCF_ASYMM	0b11
> 
> WDYT?

Looks good to me.

It was just that the _ASYMM define name doesn't provide any clue as to what
is asymmetrical. But I guess that for people who know the MTE architecture
reasonably well it's very obvious what operation is different and how. The
comments make it easier to understand even for people who aren't too
familiar with the MTE architecture.

[..]
> >> +static inline void mem_read(unsigned int *addr, unsigned int tag, unsigned int *res)
> >> +{
> >> +	unsigned int r;
> > Space between the variable declaration and the rest of the function?
> > 
> 
> I see that you have questions related to this function so I better explain it here
> 
> >> +	asm volatile ("ldr %0,[%1]\n"
> 
> Here load value from tagged memory.
> 
> >> +		      "str %0,[%2]\n"
> 
> Here we copy loaded value in untagged memory "res".
> 
> If there was an expection due to access to tagged memory we step over the copy so
> content of "res" won't change, otherwise we update the contnet. We use "res" to
> check value we loaded (if any)

That matches my understanding, thank you for the explanation.

> 
> >> +		      : "=r" (r)
> >> +		      : "r" (tagged(addr, tag)), "r" (res));
> >> +}
> >> +
> >> +static inline void mem_write(unsigned int *addr, unsigned int tag, unsigned int val)
> >> +{

Can you add a comment here explaining the NOP, something along the lines
as:

	/* The NOP allows the same exception handler as mem_read() to be used. */
> >> +	asm volatile ("str %0,[%1]\n"
> >> +		      "nop\n"
> >> +		      :
> >> +		      : "r" (val), "r" (tagged(addr, tag))
> >> +		      : "memory");
> >> +}
> > I don't understand why these functions are needed.
> 
> These are needed for precise control how we access to the memory. We advance
> the pc in exeption handler so we better not to rely on what compiler can 
> generate...

I think I understand now.

If we use a normal (non hand coded inline assembly) load or store to access
a tagged address, the compiler will reasonably assume that the access
succeeded, and the next instruction may do something based on that
assumption.

But a test might want the tagged access to fail on purpose, and if we
advance the PC to the next instruction, the one added by the compiler, we
might leave the program in an unexpected state.

Can you add the above as a comment for the mem_read() function? I think
that will make it clear why hand coding the accesses is needed.

[..]
> >> +static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
> >> +{
[..]
> >> +        regs->pc += 8;
> > I think two instructions are skipped here because the test assumes that
> > the first instruction from the mem_{read,write} macros will cause the
> > fault.  But what happens if the first succeeds and the second instruction
> > causes a tag check fault?
> 
> Only first instruction acccesses tagged memory the second instruction either
> "nop" or copy ("str") value read from tagged memory to untagged memory 

Yeah, my bad here, I was under the impression that the store to 'res' in
mem_read() was to a tagged address, but 'res' is clearly untagged.

> 
> > 
> > IMO, I see two options here:
> > 
> > 1. Increment PC by one instruction, which means the second instruction gets
> > executed, which is harmless as far as I can tell.
> 
> No it will copy whatevere garbadge left in the regiter to untagged memory which
> we use late to check if value got loaded or not
> 
> > 
> > 2. Remove the macros, assign a random tag to the addresses and use a single
> > instruction to access the address, then increment the PC by one instruction
> > in the exception handler.

Please ignore that, I made that suggestion under the impression that the
mem_{read,write} macros weren't needed, but they clearly are.

Can you a comment above the instruction incrementing the PC by two
instructions, maybe something like this:

	/*
	 * mem_read() reads the value from the tagged pointer, then stores this
	 * value in the untagged 'res' pointer. The function that called
	 * mem_read() will want to check that the initial value of 'res' hasn't
	 * changed if a tag check fault is reported. Skip over two instructions
	 * so 'res' isn't overwritten.
	 */
	 regs->pc += 8;

[..]
> >> +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
> >> +{
> >> +#ifdef CC_HAS_MTE
> >> +	unsigned long in = (unsigned long)untagged(addr);
> >> +	unsigned long start = ALIGN_DOWN(in, 16);
> >> +	unsigned long end = ALIGN(in + size , 16);
> > Space between local variable declaration and the body of the function?
> 
> Ack
> 
> > 
> >> +	for (unsigned long ptr = start; ptr < end; ptr += 16)
> >> +            asm volatile(".arch   armv8.5-a+memtag\n"
> >> +			 "stg %0, [%1]"
> >> +                         :
> >> +                         : "r"(tagged(ptr, tag)), "r"(ptr)
> >> +                         : "memory");
> > STG generates an untagged access, so the destination address can be also be
> > tagged, i.e:
> > 
> > 		ptr = tagged(ptr, tag);
> > 		asm volatile("stg %0, [%0]" : : "r"(ptr) : "memory");
> 
> Works fo me.
> 
> > 
> > I dropped the assembler directive because you can invoke the compiler with
> > -march=armv8.5-a+memtag (the top level Makefile already checks if that
> > options is supported).
> > 
> > Up to you what you prefer.
> 
> I prefere user won't bother messing with specific "-march" :)

I was actually thinking that the build infrastructure could set the flag
automatically instead of the user having to specify it. But I don't see an
easy way to set CFLAGS for a specific test, so I guess the assembler
directive will have to do.

[..]
> >> +static void mte_asymm_test(void)
> >> +{
> >> +	unsigned int *mem = alloc_page();
> >> +	unsigned int val = 0;
> >> +
> >> +	memset(mem, 0xff, PAGE_SIZE);
> >> +	mte_init();
> >> +	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> >> +	mte_set_tag(mem, PAGE_SIZE, 0);
> >> +	mte_set_tcf(MTE_TCF_ASYMM);
> >> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> >> +
> >> +	mem_read(mem, 3, &val);
> >> +	report((val == 0) && mte_exception, "read");
> >> +
> >> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
> > I would have left the exception handler, and checked that mte_exception is
> > false. Just to make sure that the access doesn't set the TF field and also
> > generate an exception.
> > 
> > Same for the fully asynchronous test below.
> > 
> 
> I think we do not expect any exception here so we can rely on defaut exception
> handler to stop the world and produce output with all handy information for debug.

That's a good point.

[..]
> >> +static unsigned int mte_version(void)
> > Why unsigned int? Sorry, but this seems arbitrary - r is 64 bits, the field
> > is 4 bits, and the function returns 32 bits.
> 
> Because at the end we are interested in non-negative number, unsigned int fits
> this purpose, no?

Of course, I was not disputing correctness. It's just that the
inconsistency cought my eye.

[..]
> >> diff --git a/arm/run b/arm/run
> >> index efdd44ce..b129e4e0 100755
> >> --- a/arm/run
> >> +++ b/arm/run
> >> @@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
> >>  	exit 2
> >>  fi
> >>  
> >> -M='-machine virt'
> >> +MACHINE="virt"
> >> +M="-machine $MACHINE$MACHINE_PROPS"
> > I did this
> > 
> > $ grep -r MACHINE_PROPS
> > 
> > and there were no other matches beside of the line above.

Any clues to the use of the MACHINE_PROPS variable?

Thanks,
Alex
