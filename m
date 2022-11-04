Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282CCC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 23:41:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43F04079D;
	Fri,  4 Nov 2022 19:41:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NeMZB8Vbi14c; Fri,  4 Nov 2022 19:41:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D7340B8F;
	Fri,  4 Nov 2022 19:41:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3840340B8F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xs4jWvHCRdp4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 19:41:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 035C04079D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667605311;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cNQilMgvXDneE1h9HbtAPKvGFLnkNGwhukg91aqJDGY=;
 b=h1nLKW1zvP+HjxVzlPxm9edvcO6KMS6LyH6800/+Jn7BsrnV6AHpoCfU1yvoQA6N98OdAf
 RHJ+OtwX1w9f05ZwwIkkSbwm/9chBEaPc+Sb5wC//qjBYROaV2+IiUgC6BxEFLtrXWRsKN
 pWRv31r9Iy+RULGuUyauh/t38HN8Jlk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-4hANfAyYMWKRAHZ-_JCp8w-1; Fri, 04 Nov 2022 19:41:47 -0400
X-MC-Unique: 4hANfAyYMWKRAHZ-_JCp8w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB1CE3C02185;
 Fri,  4 Nov 2022 23:41:46 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A4D4A9254;
 Fri,  4 Nov 2022 23:41:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v8 6/7] KVM: selftests: Clear dirty ring states between two
 modes in dirty_log_test
Date: Sat,  5 Nov 2022 07:40:48 +0800
Message-Id: <20221104234049.25103-7-gshan@redhat.com>
In-Reply-To: <20221104234049.25103-1-gshan@redhat.com>
References: <20221104234049.25103-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
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

There are two states, which need to be cleared before next mode
is executed. Otherwise, we will hit failure as the following messages
indicate.

- The variable 'dirty_ring_vcpu_ring_full' shared by main and vcpu
  thread. It's indicating if the vcpu exit due to full ring buffer.
  The value can be carried from previous mode (VM_MODE_P40V48_4K) to
  current one (VM_MODE_P40V48_64K) when VM_MODE_P40V48_16K isn't
  supported.

- The current ring buffer index needs to be reset before next mode
  (VM_MODE_P40V48_64K) is executed. Otherwise, the stale value is
  carried from previous mode (VM_MODE_P40V48_4K).

  # ./dirty_log_test -M dirty-ring
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
  guest physical test memory offset: 0xffbfffc000
    :
  Dirtied 995328 pages
  Total bits checked: dirty (1012434), clear (7114123), track_next (966700)
  Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
  guest physical test memory offset: 0xffbffc0000
  vcpu stops because vcpu is kicked out...
  vcpu continues now.
  Notifying vcpu to continue
  Iteration 1 collected 0 pages
  vcpu stops because dirty ring is full...
  vcpu continues now.
  vcpu stops because dirty ring is full...
  vcpu continues now.
  vcpu stops because dirty ring is full...
  ==== Test Assertion Failure ====
  dirty_log_test.c:369: cleared == count
  pid=10541 tid=10541 errno=22 - Invalid argument
     1	0x0000000000403087: dirty_ring_collect_dirty_pages at dirty_log_test.c:369
     2	0x0000000000402a0b: log_mode_collect_dirty_pages at dirty_log_test.c:492
     3	 (inlined by) run_test at dirty_log_test.c:795
     4	 (inlined by) run_test at dirty_log_test.c:705
     5	0x0000000000403a37: for_each_guest_mode at guest_modes.c:100
     6	0x0000000000401ccf: main at dirty_log_test.c:938
     7	0x0000ffff9ecd279b: ?? ??:0
     8	0x0000ffff9ecd286b: ?? ??:0
     9	0x0000000000401def: _start at ??:?
  Reset dirty pages (0) mismatch with collected (35566)

Fix the issues by clearing 'dirty_ring_vcpu_ring_full' and the ring
buffer index before next new mode is to be executed.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 27 ++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b5234d6efbe1..8758c10ec850 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -226,13 +226,15 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 }
 
 static void dirty_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages)
+					  void *bitmap, uint32_t num_pages,
+					  uint32_t *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 }
 
 static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages)
+					  void *bitmap, uint32_t num_pages,
+					  uint32_t *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 	kvm_vm_clear_dirty_log(vcpu->vm, slot, bitmap, 0, num_pages);
@@ -329,10 +331,9 @@ static void dirty_ring_continue_vcpu(void)
 }
 
 static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					   void *bitmap, uint32_t num_pages)
+					   void *bitmap, uint32_t num_pages,
+					   uint32_t *ring_buf_idx)
 {
-	/* We only have one vcpu */
-	static uint32_t fetch_index = 0;
 	uint32_t count = 0, cleared;
 	bool continued_vcpu = false;
 
@@ -349,7 +350,8 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
-				       slot, bitmap, num_pages, &fetch_index);
+				       slot, bitmap, num_pages,
+				       ring_buf_idx);
 
 	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
 
@@ -406,7 +408,8 @@ struct log_mode {
 	void (*create_vm_done)(struct kvm_vm *vm);
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vcpu *vcpu, int slot,
-				     void *bitmap, uint32_t num_pages);
+				     void *bitmap, uint32_t num_pages,
+				     uint32_t *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
 	void (*before_vcpu_join) (void);
@@ -471,13 +474,14 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
 }
 
 static void log_mode_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					 void *bitmap, uint32_t num_pages)
+					 void *bitmap, uint32_t num_pages,
+					 uint32_t *ring_buf_idx)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
 	TEST_ASSERT(mode->collect_dirty_pages != NULL,
 		    "collect_dirty_pages() is required for any log mode!");
-	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages);
+	mode->collect_dirty_pages(vcpu, slot, bitmap, num_pages, ring_buf_idx);
 }
 
 static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
@@ -696,6 +700,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	unsigned long *bmap;
+	uint32_t ring_buf_idx = 0;
 
 	if (!log_mode_supported()) {
 		print_skip("Log mode '%s' not supported",
@@ -771,6 +776,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_dirty_count = 0;
 	host_clear_count = 0;
 	host_track_next_count = 0;
+	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
@@ -778,7 +784,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(p->interval * 1000);
 		log_mode_collect_dirty_pages(vcpu, TEST_MEM_SLOT_INDEX,
-					     bmap, host_num_pages);
+					     bmap, host_num_pages,
+					     &ring_buf_idx);
 
 		/*
 		 * See vcpu_sync_stop_requested definition for details on why
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
