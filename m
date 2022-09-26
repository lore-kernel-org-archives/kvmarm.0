Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734C5C6FA83
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 14:51:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9514B7F0;
	Mon, 26 Sep 2022 10:51:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zx-m4z938OZl; Mon, 26 Sep 2022 10:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 763C74B7FD;
	Mon, 26 Sep 2022 10:51:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F01D4B785
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rjOA7+m1V9ks for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 10:51:30 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7F904B798
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E8ECCB80ACA;
 Mon, 26 Sep 2022 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA13C43149;
 Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664203886;
 bh=Vt4MpZxy9cA0Z6Nr6FBms3xW3YZkMmAFr0nagHkKwcI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BxAN9o7XxK4utX1Z+e0RX5EzhITH8A5s6KNcQ/H7bj7JX1XcW9Q6MkKu773La9wyx
 5wNDl6ZuSxiT0rw5ywYPVYYHcIMWOnQIj4Mh+sfdBM+nza+kw0q+ShvQCOUJe9BLPc
 IYxGuR3+lB2GTHsJ3wFllegALAo8w9mjDJ3YfWxrPbSyW6sQQnYf3OJKnP3b7XOOAz
 YtHB4eGwSj8QOc7a83R6fBsy0zM6pOYap1smfvue9LYqB+d9kRdaNUe882UwvguqEQ
 oV7s7sh3vldHKqR2CIKhLeuB7cSvxQME5WG6KNF/RFNrCo7xyV/tKICMk+Rx9w7w8q
 arutSGFimmgKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocpS8-00Cips-Ps;
 Mon, 26 Sep 2022 15:51:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH v2 6/6] KVM: selftests: dirty-log: Use
 KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
Date: Mon, 26 Sep 2022 15:51:20 +0100
Message-Id: <20220926145120.27974-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
 peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
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

Pick KVM_CAP_DIRTY_LOG_RING_ACQ_REL if exposed by the kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c   | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 53627add8a7c..b5234d6efbe1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -265,7 +265,8 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 
 static bool dirty_ring_supported(void)
 {
-	return kvm_has_cap(KVM_CAP_DIRTY_LOG_RING);
+	return (kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) ||
+		kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ACQ_REL));
 }
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..411a4c0bc81c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,7 +82,10 @@ unsigned int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
-	vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
+	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL, ring_size);
+	else
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
 	vm->dirty_ring_size = ring_size;
 }
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
