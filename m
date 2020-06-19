Return-Path: <SRS0=kKHV=AA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF33C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 875D721527
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xt84BPf3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 875D721527
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417774B1C4;
	Fri, 19 Jun 2020 14:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UGBe3lYkIcXc; Fri, 19 Jun 2020 14:46:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E6124B1D2;
	Fri, 19 Jun 2020 14:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0E934B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9etDiUe9PiAZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2020 14:46:44 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FEA4B1C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592592404;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zt6Anjj0Yd0Vhhr8BqGCZDNMc9cFRPQZ9/9/Ct6l9YM=;
 b=Xt84BPf3Rimzf0k7ZVYHmSZiCTH2+pL2NvDGwjcthsqCL87sF44Oo8tP3bL5Bj261tPBLU
 XGJUmbHiG/qleR+qKNPF0yJ7BIu651b/up1AO1OxxqDscMSDXci6320ruQFfV7wh1R8tYL
 WHsKLO1H/E50vH6KchNhgR7Q5xs5UxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-HPkS2LdGPOWwugwanhNd6w-1; Fri, 19 Jun 2020 14:46:42 -0400
X-MC-Unique: HPkS2LdGPOWwugwanhNd6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C12811052502;
 Fri, 19 Jun 2020 18:46:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2DB1160C81;
 Fri, 19 Jun 2020 18:46:38 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/4] KVM: selftests: Use KVM_CAP_STEAL_TIME
Date: Fri, 19 Jun 2020 20:46:29 +0200
Message-Id: <20200619184629.58653-5-drjones@redhat.com>
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: pbonzini@redhat.com, steven.price@arm.com, maz@kernel.org
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

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/steal_time.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fcc840088c91..704bd3ee799a 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -70,6 +70,10 @@ static void steal_time_init(struct kvm_vm *vm)
 		exit(KSFT_SKIP);
 	}
 
+#ifdef KVM_CAP_STEAL_TIME
+	TEST_ASSERT(kvm_check_cap(KVM_CAP_STEAL_TIME), "CAP doesn't match CPUID feature");
+#endif
+
 	for (i = 0; i < NR_VCPUS; ++i) {
 		int ret;
 
@@ -177,8 +181,12 @@ static void steal_time_init(struct kvm_vm *vm)
 	};
 	int i, ret;
 
+#ifndef KVM_CAP_STEAL_TIME
 	ret = _vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
 	if (ret != 0 && errno == ENXIO) {
+#else
+	if (!kvm_check_cap(KVM_CAP_STEAL_TIME)) {
+#endif
 		print_skip("steal-time not supported");
 		exit(KSFT_SKIP);
 	}
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
