Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39277C6FA91
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 17:02:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D758C4B269;
	Thu, 22 Sep 2022 13:02:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h85B4fj+OLjA; Thu, 22 Sep 2022 13:02:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA284B629;
	Thu, 22 Sep 2022 13:01:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AFF4B13D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NffOGZuFALbl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54EEB4B239
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B866A636C4;
 Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511F6C43142;
 Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663866116;
 bh=hA1DDauldDxvz9ZVp/xPBZZDXp3URJZAYdvxZvA5W7c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Adi1/pws/Ni5nCmnLAOWEJ6B+pg1Njh01sHE+fg5fj0HoQiJRHU0xRPKTrNPlZNzp
 pS2voqACKtQXtoVRWDzyIFWhLwPVBLGavhyxcTDij7PL7+eHrqKVk8Qq0FPTanFmmk
 ipA9OwHmoYnCIVI46SCcqO+ks8+hbNG+OS9e3fwyqAV8t+jHHiKvxnqSYgsOSBEEW4
 E4sKls6R1XQ2nXgoWG57fcTybtB88UKeUipIY597KezBKwzmPTtFDQQXXImm1Tm6z2
 Hk80oWuo1JQ6lVQgWUL73SScZa64zZWFUbTytBxHbODmPxQfBi8WURg1Cm4k8WzYI4
 lVb/Lcpxh9n0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1obPaE-00Bxdo-KX;
 Thu, 22 Sep 2022 18:01:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH 6/6] KVM: selftests: dirty-log: Use
 KVM_CAP_DIRTY_LOG_RING_ORDERED of available
Date: Thu, 22 Sep 2022 18:01:33 +0100
Message-Id: <20220922170133.2617189-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
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

Pick KVM_CAP_DIRTY_LOG_RING_ORDERED if exposed by the kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c   | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3d29f4bf4f9c..30cdda41b8ec 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -265,7 +265,8 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 
 static bool dirty_ring_supported(void)
 {
-	return kvm_has_cap(KVM_CAP_DIRTY_LOG_RING);
+	return (kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) ||
+		kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ORDERED));
 }
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..4c031f9fe717 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,7 +82,10 @@ unsigned int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
-	vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
+	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ORDERED))
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ORDERED, ring_size);
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
