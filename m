Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3768EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 19:43:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2BA54B2F8;
	Wed, 25 May 2022 15:43:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QmcTZ8FPmuS6; Wed, 25 May 2022 15:43:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8CE4B2EF;
	Wed, 25 May 2022 15:43:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8B3D4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 15:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OC1UL6opy7px for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 15:43:16 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9727B4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 15:43:16 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id s23so22408715iog.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=z0lWFS4RsOAMu5NvP2sJzZSKmQWbrRzXyQ2tDvM4c80=;
 b=oLfXvI+ru0PyJcz/8dUyYrR1Vs9h5L7qb4goGPpFYErzdxCfrgmxsUup859/1ttnDv
 9RsxVNnz+svdM61+K62WpzMlHwFBiQNbxPtOAxrwqAcCF1bgTu9yZ1eMXNNg04ncjTuM
 Pq37kkS7x2Uongemr6+bJUkdWZmEENsXZAbj7/NiQ2PhR0kBdKkKEihwleM8rs7vUpoP
 GvtBfiNYUsZKUqXDs1JBIT2yiJyEGQAwzLZLkkT5fUwn0qyIsmLW1ZX8w9RN2gJvWrAc
 gIhzbN1SesqlyC9kJKVCve+PLZPYHa53HDT1wK3c4H4PhM7X2O+jYSfCh24aqVVTQB6f
 415w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=z0lWFS4RsOAMu5NvP2sJzZSKmQWbrRzXyQ2tDvM4c80=;
 b=x1K0ysK7cGmtTivE1ySU5x/zI8uXppWpy/ix3x43MGFXLMi2gEdVkAHicepuLQOTYj
 fBMdfOTH/erQsTBDLIHzJTCX09x52+LP3Hd4KZH59oZ3yiLOYgLOj3ClCKTHdEQrGQjo
 LDfdOMW7CCZX2W2UGY7NKQDWTUj/ChsRRNmmrNTOTUniMWU60NaCnWu/bYjCaDTqSBcW
 CqjTHdNemRbqg/7R8wnfWK1leGaxdg88TqbWVKHmbu9qL9OubApDkLy16dOZGyHWixlV
 TSFV0DvSC1FJowgs14pBvtbBHJqgY6XczCbfUeVZCYrJVhvMy027NvCTTGs9Bm1zSGjm
 aX4A==
X-Gm-Message-State: AOAM533Cp+kez2GheqQNJLVF69OepHd2Sz/QwgfQGLzjQUC1NArhBEv5
 4mzrIDngQGoj0ExHd6pd292/Sw==
X-Google-Smtp-Source: ABdhPJwb9oqHSahGvYvC/9/gLijqv7jIBdtNORfHT5pI6Y7smDAD3xMAGFXE247Pyu1dtJUcqZZ1uQ==
X-Received: by 2002:a6b:8b8c:0:b0:65e:486c:15ad with SMTP id
 n134-20020a6b8b8c000000b0065e486c15admr14384529iod.145.1653507795610; 
 Wed, 25 May 2022 12:43:15 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 b7-20020a021907000000b0032e8480d706sm4377308jab.57.2022.05.25.12.43.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 May 2022 12:43:14 -0700 (PDT)
Date: Wed, 25 May 2022 19:43:11 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Yo6Gz6o1csFCqN9x@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-10-ricarkol@google.com>
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

On Thu, Apr 07, 2022 at 05:41:16PM -0700, Ricardo Koller wrote:
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> new file mode 100644
> index 000000000000..04fc6007f630
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c

[...]

> +/* Guest virtual addresses that point to the test page and its PTE. */
> +#define TEST_GVA				0xc0000000
> +#define TEST_EXEC_GVA				0xc0000008
> +#define TEST_PTE_GVA				0xd0000000
> +#define TEST_DATA				0x0123456789ABCDEF
> +
> +#define CMD_NONE				(0)
> +#define CMD_SKIP_TEST				(1ULL << 1)
> +#define CMD_HOLE_PT				(1ULL << 2)
> +#define CMD_HOLE_TEST				(1ULL << 3)
> +
> +#define PREPARE_FN_NR				10
> +#define CHECK_FN_NR				10
> +
> +uint64_t pte_gpa;
> +
> +enum { PT, TEST, NR_MEMSLOTS};

nit: fix formatting (just use newlines for each value).

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

nit: initialize fields in the order they appear in the struct.

[...]

> +static void guest_write64(void)
> +{
> +	uint64_t val;
> +
> +	WRITE_ONCE(*((uint64_t *)TEST_GVA), TEST_DATA);
> +	val = READ_ONCE(*(uint64_t *)TEST_GVA);

nit: you could proabably avoid casting with a global pointer.

  static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;

[...]

> +static void guest_test_check(struct test_desc *test)
> +{
> +	void (*check_fn)(void);
> +	int i;
> +
> +	for (i = 0; i < CHECK_FN_NR; i++) {
> +		check_fn = test->guest_test_check[i];
> +		if (!check_fn)
> +			continue;
> +		check_fn();

nit:

  if (check_fn)
          check_fn();

One less line :)

> +	}
> +}
> +
> +static void guest_code(struct test_desc *test)
> +{
> +	if (!test->guest_test)
> +		test->guest_test = guest_nop;

In other cases you've chosen to skip function calls if NULL. Is there a
need to call something here that I've missed or could you just do:

  if (test->guest_test)
          test->guest_test();

below?

> +	if (!guest_prepare(test))
> +		GUEST_SYNC(CMD_SKIP_TEST);
> +
> +	GUEST_SYNC(test->mem_mark_cmd);
> +	test->guest_test();
> +
> +	guest_test_check(test);
> +	GUEST_DONE();
> +}

[...]

> +
> +#define SNAME(s)			#s
> +#define SCAT2(a, b)			SNAME(a ## _ ## b)
> +#define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
> +
> +#define _CHECK(_test)			_CHECK_##_test
> +#define _PREPARE(_test)			_PREPARE_##_test
> +#define _PREPARE_guest_read64		guest_prepare_nop
> +#define _PREPARE_guest_ld_preidx	guest_prepare_nop
> +#define _PREPARE_guest_write64		guest_prepare_nop
> +#define _PREPARE_guest_st_preidx	guest_prepare_nop
> +#define _PREPARE_guest_exec		guest_prepare_nop
> +#define _PREPARE_guest_at		guest_prepare_nop

Since you check for NULL in guest_prepare(), could you just use NULL for
these and drop guest_prepare_nop()?

> +#define _PREPARE_guest_dc_zva		guest_check_dc_zva
> +#define _PREPARE_guest_cas		guest_check_lse
> +
> +/* With or without access flag checks */
> +#define _PREPARE_with_af		guest_set_ha, guest_clear_pte_af
> +#define _PREPARE_no_af			guest_prepare_nop
> +#define _CHECK_with_af			guest_check_pte_af
> +#define _CHECK_no_af			guest_check_nop
> +
> +/* Performs an access and checks that no faults (no events) were triggered. */
> +#define TEST_ACCESS(_access, _with_af, _mark_cmd)				\
> +{										\
> +	.name			= SCAT3(_access, _with_af, #_mark_cmd),		\
> +	.guest_prepare		= { _PREPARE(_with_af),				\
> +				    _PREPARE(_access) },			\
> +	.mem_mark_cmd		= _mark_cmd,					\
> +	.guest_test		= _access,					\
> +	.guest_test_check	= { _CHECK(_with_af) },				\
> +	.expected_events	= { 0 },					\
> +}
> +
> +static struct test_desc tests[] = {
> +	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
> +	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_ld_preidx, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_cas, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_write64, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_st_preidx, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_dc_zva, with_af, CMD_NONE),
> +	TEST_ACCESS(guest_exec, with_af, CMD_NONE),
> +
> +	/*
> +	 * Accessing a hole in the test memslot (punched with fallocate or
> +	 * madvise) shouldn't fault (more sanity checks).
> +	 */
> +	TEST_ACCESS(guest_read64, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_cas, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_ld_preidx, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_write64, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_st_preidx, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_at, no_af, CMD_HOLE_TEST),
> +	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_TEST),
> +
> +	{ 0 },

nit: no comma, we don't want to ever add anything after the sentinel I
presume.

> +};
> +
> +static void for_each_test_and_guest_mode(
> +		void (*func)(enum vm_guest_mode m, void *a),
> +		enum vm_mem_backing_src_type src_type)
> +{

Could you avoid the forward declaration and instead move definitions
around to satisfy the compiler?

> +	struct test_desc *t;
> +
> +	for (t = &tests[0]; t->name; t++) {
> +		if (t->skip)
> +			continue;
> +
> +		struct test_params p = {
> +			.src_type = src_type,
> +			.test_desc = t,
> +		};
> +
> +		for_each_guest_mode(run_test, &p);
> +	}
> +}
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 16753a1f28e3..cb5849fd8fd1 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -125,6 +125,12 @@ enum {
>  #define ESR_EC_WP_CURRENT	0x35
>  #define ESR_EC_BRK_INS		0x3c
>  
> +/* Access flag */
> +#define PTE_AF			(1ULL << 10)
> +
> +/* Acces flag update enable/disable */

typo: Access

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
