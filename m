Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F64C43217
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 03:09:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D6149EC0;
	Wed, 26 Jan 2022 22:09:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZN5RZ8vNyUSt; Wed, 26 Jan 2022 22:09:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30A0149EFD;
	Wed, 26 Jan 2022 22:09:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31EFC49ED8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XiHQ+yPOMbFL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 22:09:09 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2BB49EC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 22:09:08 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 p6-20020a63ab06000000b0033fcc84d4f6so712399pgf.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 19:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QPrlx7WHIAMxZ0O9Mmyf5U2YjXNGMzfcwUvdJYaS1zI=;
 b=fhA0NR/VPVJDiuNh+ZXtLY1vNHbmDxiynQqQuaOu7UYvHGuxaZd6jVZjI/ea+aGRwZ
 61lOCTcrzAyX43PsleAzNi9Xm9/YZtw/GpaAXIgFVgcGIGNCu5/JR7VV5J8GwaxKJu+f
 tjuMBjRXn16zC+uIme146UtoZbzn29+gDFVdCKuwOyzetDQsnVZXi4CWqHT10qBY/XvG
 Aw/G8lcK+2nWPRlOHithMqFBQMVNb32esoa8sXHdak3D4GfeGH68iUSCgQgGxg9HDlgT
 J2CFep8xfZ9/YMi6gK60jdN4//1bfio32WkuqvdXpJUE4d9tP8FpDEJn4VTyeKBjRpFw
 INLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QPrlx7WHIAMxZ0O9Mmyf5U2YjXNGMzfcwUvdJYaS1zI=;
 b=Wrvt8RJ1ziMdUSyXc26vZLgg6q/mfQnnH30n9a0rgoTMUP4dNK8JIQ6Un93ahA7Pd6
 4TiMU3B0O4U7nebe6CNA/8XkzlO6MLp3XlWmsQiVV+/xgtsi/057S5wrA8cTeLCU8d0o
 GsaClwN56N8z9Fo2wBEaJF9KnBuW+asVqEsw1mK4hhN9BrfD1ckG8mpFK6DY2waLcfTK
 EdcCgIPvYSLnS2VYzE/iReEoPPzBm9uGKHDrbpBQQWBncQLJX6rGITvu2XOijMdsCNQ7
 cpjoe3GBMqcFzsfJOPrU96TxhDcTP+t/H7yVx1ZQNKFZAVhRkLraRBiVUFnTd3GxWRVN
 oh7A==
X-Gm-Message-State: AOAM532b5idPxL4aYz1+NRG6vRVKeSCwdgkfOZKZqogLGKvs8RoXCfK2
 2wOHuqfv0WntekfE+l2ryPHnLLMLZ039lg==
X-Google-Smtp-Source: ABdhPJwfM10RSJpC/YJ0gxNH0zBPwJaj1dw5B5vZEVnAFjcJjtuWKaQNHlWvaJebRY8Yo3QV6+aXBzoV+0HnRQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:74c2:: with SMTP id
 p2mr2043435pjl.155.1643252947940; Wed, 26 Jan 2022 19:09:07 -0800 (PST)
Date: Wed, 26 Jan 2022 19:08:56 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 3/5] kvm: selftests: aarch64: fix the failure check in
 kvm_set_gsi_routing_irqchip_check
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

kvm_set_gsi_routing_irqchip_check(expect_failure=true) is used to check
the error code returned by the kernel when trying to setup an invalid
gsi routing table. The ioctl fails if "pin >= KVM_IRQCHIP_NUM_PINS", so
kvm_set_gsi_routing_irqchip_check() should test the error only when
"intid >= KVM_IRQCHIP_NUM_PINS+32". The issue is that the test check is
"intid >= KVM_IRQCHIP_NUM_PINS", so for a case like "intid =
KVM_IRQCHIP_NUM_PINS" the test wrongly assumes that the kernel will
return an error.  Fix this by using the right check.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index b701eb80128d..0106fc464afe 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -573,8 +573,8 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 		kvm_gsi_routing_write(vm, routing);
 	} else {
 		ret = _kvm_gsi_routing_write(vm, routing);
-		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
-		if (intid >= KVM_IRQCHIP_NUM_PINS)
+		/* The kernel only checks e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS */
+		if (((uint64_t)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
 				"error: rc: %i errno: %i", intid, ret, errno);
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
