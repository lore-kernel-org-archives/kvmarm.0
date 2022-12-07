Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02002C4708D
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 23:57:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BE64B875;
	Wed,  7 Dec 2022 18:57:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MdscMBntBLPR; Wed,  7 Dec 2022 18:57:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 090EE4B876;
	Wed,  7 Dec 2022 18:57:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A871E4B876
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:57:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ty3DeYxCuaZa for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 18:57:32 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39E324B875
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:57:32 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so2950967pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Dec 2022 15:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=8N+qRyZs8A27b8zmYgDM6eub81HjOuPQkVp/rNJYGkE=;
 b=IRsW6qXJv0KUe102GWJJut/QQHU0mz9aD1TFz6fiazXSDxbF+Gd/wkLLz2/C0wsf0F
 +t/OoqOzm5cQSHjFHhV6axB8F/e9e1CwhwdX97gPVtL0rj6MTlVXZK2id6Qvi3r4J5EJ
 ddoONGLzeK+V9Ng+OcQhSTeHzpl60kbdAfZMMCl/r3Remse1yVYDFm0iqtNHtYVx6F+6
 2Bba4iU4hb0jyUX7QyJIcxnS2jMfWGwk0y8aq9RWpofR7Ux+8NuhHRB9+XrYVWNKJODK
 yFfsj1+N6wWN3WW9vanUgh3KesJrHzxa7+TadwvTtTksGdx33UfPyPrPfZzyKZV0fUxW
 p4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=8N+qRyZs8A27b8zmYgDM6eub81HjOuPQkVp/rNJYGkE=;
 b=g9lhokA1pN1HsKntgrBMyOWiu1T//ZjO5enUSP7aKrP+s5kD3HMIOg0k/R45U/yicl
 RX0cC/gEu2BOMfi886AM96FC/1ouFijpc27iNxN5pfMTT3tB4MKRpYIx+7FzNz2+FqEv
 u+PKTIaElWKy5jhw2xtGjAsqwrMikI3W5BNQj7XQU8VfkpqmdjVdGyY4syCDihAFj6eW
 etLaHH7xCF7PlCftG/TPiLnxsTrJ7mb9LkCJNrPspmLjZKbAqH50eJvHDGt2qcAhGllo
 D5MIo2Nhr2cQW97rNK/4/usQ53mO9OTQcMLBMmW3ZiLwS0cADJhbrQ1UWBERByfxR20d
 Zt5w==
X-Gm-Message-State: ANoB5pm0HdXA8mjslMzaR8bf8B7mWzzSZ5W7H+OB+yd/lgDPBxK37+/I
 CABTswe54Txl2WSzD/C9PiBzpA==
X-Google-Smtp-Source: AA0mqf4xUxcp01fniXds5LHIuakCOlpuIA6eXLYuF3Gpk7boSvE2HJxOvnOChzKT9bm6rRyZL+rwVA==
X-Received: by 2002:a17:902:be01:b0:189:6624:58c0 with SMTP id
 r1-20020a170902be0100b00189662458c0mr1270487pls.3.1670457451132; 
 Wed, 07 Dec 2022 15:57:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 i14-20020a17090332ce00b001892af9472esm8957369plr.261.2022.12.07.15.57.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 15:57:30 -0800 (PST)
Date: Wed, 7 Dec 2022 23:57:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5EoZ5uwrTF3eSKw@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221207214809.489070-3-oliver.upton@linux.dev>
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

On Wed, Dec 07, 2022, Oliver Upton wrote:
> The new ucall infrastructure needs to update a couple of guest globals
> to pass through the ucall MMIO addr and pool of ucall structs. A
> precondition of this actually working is to have the program image
> already loaded into guest memory.

Ouch.  Might be worth explicitly stating what goes wrong.  Even though it's super
obvious in hindsight, it still took me a few seconds to understand what
precondition you were referring to, e.g. I was trying to figure out how selecting
the MMIO address depended on the guest code being loaded...

> 
> Call ucall_init() after kvm_vm_elf_load(). Continue to park the ucall
> MMIO addr after MEM_REGION_TEST_DATA.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/aarch64/page_fault_test.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index 92d3a91153b6..95d22cfb7b41 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -609,8 +609,13 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
>  				    data_size / guest_page_size,
>  				    p->test_desc->data_memslot_flags);
>  	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
> +}
> +
> +static void setup_ucall(struct kvm_vm *vm)
> +{
> +	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
>  
> -	ucall_init(vm, data_gpa + data_size);
> +	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);

Isn't there a hole after CODE_AND_DATA_MEMSLOT?  I.e. after memslot 0?  The reason
I ask is because if so, then we can do the temporarily heinous, but hopefully forward
looking thing of adding a helper to wrap kvm_vm_elf_load() + ucall_init().

E.g. I think we can do this immediately, and then at some point in the 6.2 cycle
add a dedicated region+memslot for the ucall MMIO page.

---
 .../selftests/kvm/aarch64/page_fault_test.c   | 10 +------
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 28 +++++++++++--------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 95d22cfb7b41..68c47db2eb2e 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -611,13 +611,6 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
 }
 
-static void setup_ucall(struct kvm_vm *vm)
-{
-	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
-
-	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);
-}
-
 static void setup_default_handlers(struct test_desc *test)
 {
 	if (!test->mmio_handler)
@@ -706,8 +699,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	vm = ____vm_create(mode);
 	setup_memslots(vm, p);
-	kvm_vm_elf_load(vm, program_invocation_name);
-	setup_ucall(vm);
+	vm_init_guest_code_and_data(vm);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
 
 	setup_gva_maps(vm);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8..175b5ca0c061 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -682,6 +682,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+void vm_init_guest_code_and_data(struct kvm_vm *vm);
 
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c88c3ace16d2..0eab6b11a6e9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -329,12 +329,27 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
+void vm_init_guest_code_and_data(struct kvm_vm *vm)
+{
+	struct userspace_mem_region *slot;
+
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	/*
+	 * TODO: Add a dedicated memory region to carve out MMIO.  KVM treats
+	 * writes to read-only memslots as MMIO, and creating a read-only
+	 * memslot for the MMIO region would prevent silently clobbering the
+	 * MMIO region.
+	 */
+	slot = vm_get_mem_region(vm, MEM_REGION_DATA);
+	ucall_init(vm, slot->region.guest_phys_addr + slot->region.memory_size);
+}
+
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages)
 {
 	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
 						 nr_extra_pages);
-	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
 	int i;
 
@@ -347,16 +362,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 	for (i = 0; i < NR_MEM_REGIONS; i++)
 		vm->memslots[i] = 0;
 
-	kvm_vm_elf_load(vm, program_invocation_name);
-
-	/*
-	 * TODO: Add proper defines to protect the library's memslots, and then
-	 * carve out memslot1 for the ucall MMIO address.  KVM treats writes to
-	 * read-only memslots as MMIO, and creating a read-only memslot for the
-	 * MMIO region would prevent silently clobbering the MMIO region.
-	 */
-	slot0 = memslot2region(vm, 0);
-	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
+	vm_init_guest_code_and_data(vm);
 
 	kvm_arch_vm_post_create(vm);
 

base-commit: 1cf369f929d607760bf721f3eb9e965ed9c703e3
-- 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
