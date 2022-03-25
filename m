Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DB8C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 21:39:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2724B11E;
	Fri, 25 Mar 2022 17:39:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eb73uy3cfKqt; Fri, 25 Mar 2022 17:39:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88AB14B131;
	Fri, 25 Mar 2022 17:39:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835014B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 17:39:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AP17Ad2ln6so for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 17:39:51 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE0A04B0FB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 17:39:50 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id c23so10409857ioi.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fo/nsWbFP8Wdc7Hq5I4r6SzYhNx9x3CF2jBIR95J9U0=;
 b=U+tGDAeQ8mf8mhVx6MlG5HuiymM3H+8PP7AUwfcMQT1NB6cS1oP8xFW/aMda0RahRM
 8ZpxJAS6jC1qyvpmLGZ9cbxQA9YqvSWVpvznnIsyMHf0z81ipjxJELXmDrEkiCQYLFhg
 xUgLtl8XE096CzjCrjGgbUQHp4kTvh7FzJwnfdq7knRyge8XXcsOgJaDkmx17WPjmOJU
 TTHPEFrdWp2AA0tpgMcdhTr0S29ug9SGpbqX/eknUR1vsB5jq53Jn7PeL5n2izoP+rqS
 mIRlIkm1NlL6Z6rYoyRkKInsf0bgDar5e6iMxHFDPF8ZE4DTEr1s8mGL8KsbiJfq3xUD
 uczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fo/nsWbFP8Wdc7Hq5I4r6SzYhNx9x3CF2jBIR95J9U0=;
 b=KHLJrv8DDL4pMnTGOiK8A9gCa3s35a1WQtl3VsukHrseqHKjUgkFP/bKF0oOmOVlrO
 MFUpM5oPvEiyuxb3Umd+CzCA6vUnwetTbmkfdjtx1y8RSPqDz17g76P9HUUcyHYVGGX/
 khDNXbXDp7M1kg1iYLhGi1gVQ2bsB3OQGqG0MDBToizw9sjwXfEoYBi81BXo86qcT8cY
 NsD7TQy5JqtcJrS1QFN5xd7Y12F/Qaw/5Sq7u8wx0Cvk0/0K+Qk4Fhc93LtEb6vyiPoe
 SgavdvS5p5YedE9f0nfCPRHr4hIjyLIy3eQaYY31ZzKLYbHgKD8z11psUtANwNNTfmhW
 lt8g==
X-Gm-Message-State: AOAM533q25VWu+Sypn0FdEMO8tZg/sTggw8KcLe9K6P6E6kPlfXZN6Fu
 UUtDOnZb4gvTDE7lULwbBer8LA==
X-Google-Smtp-Source: ABdhPJxLTZv/V2j3nVFpTQi+0FM/HeeMjRmkDl7xG4gZ3p2Pr1N7NycGyCxMjXDnyM9K91oQOcbEpg==
X-Received: by 2002:a05:6638:16d4:b0:31a:210e:223 with SMTP id
 g20-20020a05663816d400b0031a210e0223mr6665532jat.196.1648244389855; 
 Fri, 25 Mar 2022 14:39:49 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 c6-20020a056e020bc600b002c6731e7cb8sm3535969ilu.31.2022.03.25.14.39.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Mar 2022 14:39:49 -0700 (PDT)
Date: Fri, 25 Mar 2022 21:39:45 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 07/11] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Yj42oTLirffxgiTL@google.com>
References: <20220323225405.267155-1-ricarkol@google.com>
 <20220323225405.267155-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220323225405.267155-8-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Wed, Mar 23, 2022 at 03:54:01PM -0700, Ricardo Koller wrote:
> Add a new test for stage 2 faults when using different combinations of
> guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> and types of faults (e.g., read on hugetlbfs with a hole). The next
> commits will add different handling methods and more faults (e.g., uffd
> and dirty logging). This first commit starts by adding two sanity checks
> for all types of accesses: AF setting by the hw, and accessing memslots
> with holes.
> 
> Note that this commit borrows some code from kvm-unit-tests: RET,
> MOV_X0, and flush_tlb_page.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/page_fault_test.c   | 667 ++++++++++++++++++
>  2 files changed, 668 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index bc5f89b3700e..6a192798b217 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -103,6 +103,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> +TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> new file mode 100644
> index 000000000000..00477a4f10cb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -0,0 +1,667 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * page_fault_test.c - Test stage 2 faults.
> + *
> + * This test tries different combinations of guest accesses (e.g., write,
> + * S1PTW), backing source type (e.g., anon) and types of faults (e.g., read on
> + * hugetlbfs with a hole). It checks that the expected handling method is
> + * called (e.g., uffd faults with the right address and write/read flag).
> + */
> +
> +#define _GNU_SOURCE

I don't think this is necessary, defining this in tests is mostly
leftover from Google's old internal test implementation :)

http://lore.kernel.org/r/YjgYh89k8s+w34FQ@google.com

[...]

> +/* Access flag */
> +#define PTE_AF					(1ULL << 10)
> +
> +/* Acces flag update enable/disable */
> +#define TCR_EL1_HA				(1ULL << 39)

Should these be lifted into/come from a shared header file?

[...]

> +static const uint64_t test_gva = GUEST_TEST_GVA;
> +static const uint64_t test_exec_gva = GUEST_TEST_EXEC_GVA;
> +static const uint64_t pte_gva = GUEST_TEST_PTE_GVA;

Could you just use the macros directly?

> +uint64_t pte_gpa;
> +
> +enum { PT, TEST, NR_MEMSLOTS};

While it doesn't appear you need to directly use this type by name, I
think it would be best to give it a name still and/or a clarifying
comment.

> +struct memslot_desc {
> +	void *hva;
> +	uint64_t gpa;
> +	uint64_t size;
> +	uint64_t guest_pages;
> +	uint64_t backing_pages;
> +	enum vm_mem_backing_src_type src_type;
> +	uint32_t idx;
> +} memslot[NR_MEMSLOTS] = {
> +	{
> +		.idx = TEST_PT_SLOT_INDEX,
> +		.backing_pages = PT_MEMSLOT_BACKING_SRC_NPAGES,
> +	},
> +	{
> +		.idx = TEST_MEM_SLOT_INDEX,
> +		.backing_pages = TEST_MEMSLOT_BACKING_SRC_NPAGES,
> +	},
> +};
> +
> +static struct event_cnt {
> +	int aborts;
> +	int fail_vcpu_runs;
> +} events;

nit: for static structs I'd recommend keeping the type name and variable
name the same.

[...]

> +/* Check the system for atomic instructions. */
> +static bool guest_check_lse(void)
> +{
> +	uint64_t isar0 = read_sysreg(id_aa64isar0_el1);
> +	uint64_t atomic = (isar0 >> 20) & 7;

Is it possible to do:

  FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS), isar0)

> +	return atomic >= 2;
> +}
> +
> +/* Compare and swap instruction. */
> +static void guest_test_cas(void)
> +{
> +	uint64_t val;
> +	uint64_t addr = test_gva;
> +
> +	GUEST_ASSERT_EQ(guest_check_lse(), 1);
> +	asm volatile(".arch_extension lse\n"
> +		     "casal %0, %1, [%2]\n"
> +			:: "r" (0), "r" (0x0123456789ABCDEF), "r" (addr));

Please put the test data in a macro :)

[...]

> +static void guest_test_dc_zva(void)
> +{
> +	/* The smallest guaranteed block size (bs) is a word. */
> +	uint16_t val;

There's also an assumption that the maximal block size (2 << 9 bytes) is
also safe, since it is within the bounds of the test page. It might be a
good idea to surface that as well.

> +	asm volatile("dc zva, %0\n"

this depends on DCZID_EL1.DZP=0b0, right?

[...]

> +static void guest_test_ld_preidx(void)
> +{
> +	uint64_t val;
> +	uint64_t addr = test_gva - 8;
> +
> +	/*
> +	 * This ends up accessing "test_gva + 8 - 8", where "test_gva - 8"
> +	 * is not backed by a memslot.
> +	 */
> +	asm volatile("ldr %0, [%1, #8]!"
> +			: "=r" (val), "+r" (addr));
> +	GUEST_ASSERT_EQ(val, 0);
> +	GUEST_ASSERT_EQ(addr, test_gva);
> +}
> +
> +static void guest_test_st_preidx(void)
> +{
> +	uint64_t val = 0x0123456789ABCDEF;
> +	uint64_t addr = test_gva - 8;
> +
> +	asm volatile("str %0, [%1, #8]!"
> +			: "+r" (val), "+r" (addr));
> +
> +	GUEST_ASSERT_EQ(addr, test_gva);
> +	val = READ_ONCE(*(uint64_t *)test_gva);
> +}

What is the reason for testing pre-indexing instructions? These
instructions already have a bad rap under virtualization given that we
completely bail if the IPA isn't backed by a memslot. Given that, I
think you should state up front the expecations around these
instructions.

Now, I agree that KVM is on the hook for handling this correctly if the
IPA is backed, but a clarifying comment would be helpful.

It seems to me these tests assert we don't freak out about
ESR_EL2.ISV=0b0 unless we absolutely must.

> +static bool guest_set_ha(void)
> +{
> +	uint64_t mmfr1 = read_sysreg(id_aa64mmfr1_el1);
> +	uint64_t hadbs = mmfr1 & 6;

See suggestion on FIELD_GET(...)

> +static void load_exec_code_for_test(void)
> +{
> +	uint32_t *code;
> +
> +	/* Write this "code" into test_exec_gva */
> +	assert(test_exec_gva - test_gva);
> +	code = memslot[TEST].hva + 8;
> +
> +	code[0] = MOV_X0(0x77);
> +	code[1] = RET;

It might be nicer to use naked 'asm' and memcpy() that into the test
memslot. That way, there is zero question if this hand assembly is
correct or not :)

> +}
> +
> +static void setup_guest_args(struct kvm_vm *vm, struct test_desc *test)
> +{
> +	vm_vaddr_t test_desc_gva;
> +
> +	test_desc_gva = vm_vaddr_alloc_page(vm);
> +	memcpy(addr_gva2hva(vm, test_desc_gva), test,
> +			sizeof(struct test_desc));

Aren't the test descriptors already visible in the guest's address
space? The only caveat with globals is that if userspace tweaks a global
we must explicitly sync it to the guest.

So I think you could just tell the guest the test index or a direct
pointer, right?

[...]

> +static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
> +		struct test_params *p)
> +{
> +	uint64_t large_page_size = get_backing_src_pagesz(p->src_type);

nit: large_page_size seems a bit confusing to me. Theoretically this
could be a 4k page from anon memory, right?

> +	uint64_t guest_page_size = vm_guest_mode_params[mode].page_size;
> +	struct test_desc *test = p->test_desc;
> +	uint64_t hole_gpa;
> +	uint64_t alignment;
> +	int i;
> +
> +	/* Calculate the test and PT memslot sizes */
> +	for (i = 0; i < NR_MEMSLOTS; i++) {
> +		memslot[i].size = large_page_size * memslot[i].backing_pages;
> +		memslot[i].guest_pages = memslot[i].size / guest_page_size;
> +		memslot[i].src_type = p->src_type;
> +	}
> +
> +	TEST_ASSERT(memslot[TEST].size >= guest_page_size,
> +			"The test memslot should have space one guest page.\n");
> +	TEST_ASSERT(memslot[PT].size >= (4 * guest_page_size),
> +			"The PT memslot sould have space for 4 guest pages.\n");
> +
> +	/* Place the memslots GPAs at the end of physical memory */
> +	alignment = max(large_page_size, guest_page_size);
> +	memslot[TEST].gpa = (vm_get_max_gfn(vm) - memslot[TEST].guest_pages) *
> +		guest_page_size;
> +	memslot[TEST].gpa = align_down(memslot[TEST].gpa, alignment);

newline

> +	/* Add a 1-guest_page-hole between the two memslots */
> +	hole_gpa = memslot[TEST].gpa - guest_page_size;
> +	virt_pg_map(vm, test_gva - guest_page_size, hole_gpa);

newline

> +	memslot[PT].gpa = hole_gpa - (memslot[PT].guest_pages *
> +			guest_page_size);
> +	memslot[PT].gpa = align_down(memslot[PT].gpa, alignment);
> +
> +	/* Create memslots for and test data and a PTE. */

nit: for the test data

> +	vm_userspace_mem_region_add(vm, p->src_type, memslot[PT].gpa,
> +			memslot[PT].idx, memslot[PT].guest_pages,
> +			test->pt_memslot_flags);
> +	vm_userspace_mem_region_add(vm, p->src_type, memslot[TEST].gpa,
> +			memslot[TEST].idx, memslot[TEST].guest_pages,
> +			test->test_memslot_flags);
> +
> +	for (i = 0; i < NR_MEMSLOTS; i++)
> +		memslot[i].hva = addr_gpa2hva(vm, memslot[i].gpa);
> +
> +	/* Map the test test_gva using the PT memslot. */
> +	_virt_pg_map(vm, test_gva, memslot[TEST].gpa,
> +			4 /* NORMAL (See DEFAULT_MAIR_EL1) */,

Should we provide an enumeration to give meaningful names to the memory
attribute indices?

> +			TEST_PT_SLOT_INDEX);
> +
> +	/*
> +	 * Find the PTE of the test page and map it in the guest so it can
> +	 * clear the AF.
> +	 */
> +	pte_gpa = vm_get_pte_gpa(vm, test_gva);
> +	TEST_ASSERT(memslot[PT].gpa <= pte_gpa &&
> +			pte_gpa < (memslot[PT].gpa + memslot[PT].size),
> +			"The EPT should be in the PT memslot.");
> +	/* This is an artibrary requirement just to make things simpler. */
> +	TEST_ASSERT(pte_gpa % guest_page_size == 0,
> +			"The pte_gpa (%p) should be aligned to the guest page (%lx).",
> +			(void *)pte_gpa, guest_page_size);
> +	virt_pg_map(vm, pte_gva, pte_gpa);

Curious: if we are going to have more tests that involve guest
inspection of the page tables, should all of the stage-1 paging
structures be made visible to the guest?

[...]

> +
> +static bool vcpu_run_loop(struct kvm_vm *vm, struct test_desc *test)
> +{
> +	bool skip_test = false;
> +	struct ucall uc;
> +	int stage;
> +
> +	for (stage = 0; ; stage++) {
> +		vcpu_run(vm, VCPU_ID);
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			if (uc.args[1] == CMD_SKIP_TEST) {
> +				pr_debug("Skipped.\n");
> +				skip_test = true;
> +				goto done;
> +			}

Is there a way to do this check from handle_cmd()?

[...]

> +	/* Accessing a hole shouldn't fault (more sanity checks). */
> +	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_ld_preidx),
[...]
> +	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_st_preidx),

I think you may be overloading the 'hole' terminology. The guest's IPA
space is set up with a 1-page hole between the TEST and PT memslots.
Additionally, it would appear that you're hole punching with fallocate()
and madvise().

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
