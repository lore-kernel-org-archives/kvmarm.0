Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050E8C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 06:30:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AADD43479;
	Thu, 13 Oct 2022 02:30:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1HMxhTllh6c; Thu, 13 Oct 2022 02:30:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A93BF4B20D;
	Thu, 13 Oct 2022 02:30:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3C849F55
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 02:30:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ClUe4M4q5d4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 02:30:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F5B43479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 02:30:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665642640;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=I39cZ3LRJVOkJAwJsydduYsdnQpl71cDmGrmMmwlFkQ=;
 b=XLg7iIzIKvANKIgPw4nXpBEmJLEdO1eu6KbCfFOTg5quTmtNCbL5K47C6UmvmPFDFMx1YS
 MPuR5w3D6482pdYI+b4zExCWVGb4EpCSdszG6Z6W/GmPnH7RZiEH2e8ENnG5u5ORW8sbdC
 HmDZJJ0+RwJznVtNqplwct58EmVA34A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-hwQ87wOKN_eioJhbGOgOBw-1; Thu, 13 Oct 2022 02:30:34 -0400
X-MC-Unique: hwQ87wOKN_eioJhbGOgOBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EDD83C0D84A;
 Thu, 13 Oct 2022 06:30:34 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FF87C15BB5;
 Thu, 13 Oct 2022 06:30:29 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH] KVM: selftests: Fix number of pages for memory slot in
 memslot_modification_stress_test
Date: Thu, 13 Oct 2022 14:30:20 +0800
Message-Id: <20221013063020.201856-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: venkateshs@chromium.org, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, shan.gavin@gmail.com, dmatlack@google.com,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

It's required by vm_userspace_mem_region_add() that memory size
should be aligned to host page size. However, one guest page is
provided by memslot_modification_stress_test. It triggers failure
in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
as the following messages indicate.

 # ./memslot_modification_stress_test
 Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
 guest physical test memory: [0xffbfff0000, 0xffffff0000)
 Finished creating vCPUs
 Started all vCPUs
 ==== Test Assertion Failure ====
   lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
   pid=5712 tid=5712 errno=0 - Success
      1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
      2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
      3	 (inlined by) run_test at memslot_modification_stress_test.c:110
      4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
      5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
      6	0x0000ffffb8cd4383: ?? ??:0
      7	0x0000000000401827: _start at :?
   Number of guest pages is not compatible with the host. Try npages=16

Fix the issue by providing 16 guest pages to the memory slot for this
particular combination of 64KB-page-size-host and 4KB-page-size-guest
on aarch64.

Fixes: ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde404..bb1d17a1171b 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -67,7 +67,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	const uint64_t pages = 1;
+	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
 	uint64_t gpa;
 	int i;
 
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
