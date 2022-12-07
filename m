Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED183C63708
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 21:48:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 821214B84C;
	Wed,  7 Dec 2022 16:48:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WPGqXywxOW5b; Wed,  7 Dec 2022 16:48:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B6E4B835;
	Wed,  7 Dec 2022 16:48:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CBE4B811
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQXl3RIDmteE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 16:48:29 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 126594B837
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:29 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670449708;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MEqt5cwx0S15sf2YghjqjZFjTELYz7+UvtRN6GGMw7I=;
 b=cQONTD5LZyqBsrtyfAIp6nhc/p6dWCYdUqkUQwQscaRAqQtFUeKmqYCwMi5pNhGkO185OJ
 z7W0qhvRCaBG3DpfD+7TImes/kV6AH/VeDa0FniNFFhBY1IllL9mFb4rei5w+klHTmRdH+
 OxJ5Rrx1dJtNznZVukhm+TFkPPxdLFw=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH 2/4] KVM: selftests: Setup ucall after loading program into
 guest memory
Date: Wed,  7 Dec 2022 21:48:06 +0000
Message-Id: <20221207214809.489070-3-oliver.upton@linux.dev>
In-Reply-To: <20221207214809.489070-1-oliver.upton@linux.dev>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The new ucall infrastructure needs to update a couple of guest globals
to pass through the ucall MMIO addr and pool of ucall structs. A
precondition of this actually working is to have the program image
already loaded into guest memory.

Call ucall_init() after kvm_vm_elf_load(). Continue to park the ucall
MMIO addr after MEM_REGION_TEST_DATA.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 92d3a91153b6..95d22cfb7b41 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -609,8 +609,13 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 				    data_size / guest_page_size,
 				    p->test_desc->data_memslot_flags);
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
+}
+
+static void setup_ucall(struct kvm_vm *vm)
+{
+	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 
-	ucall_init(vm, data_gpa + data_size);
+	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);
 }
 
 static void setup_default_handlers(struct test_desc *test)
@@ -702,6 +707,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = ____vm_create(mode);
 	setup_memslots(vm, p);
 	kvm_vm_elf_load(vm, program_invocation_name);
+	setup_ucall(vm);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
 
 	setup_gva_maps(vm);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
