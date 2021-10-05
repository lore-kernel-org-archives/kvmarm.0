Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6159C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60676615A4
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60676615A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 179554B2DA;
	Mon,  4 Oct 2021 21:19:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZpmlmbhtNBtB; Mon,  4 Oct 2021 21:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D11784B2D8;
	Mon,  4 Oct 2021 21:19:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC0D4B2C8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qO8r0CJpc0bf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:41 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 897964B2D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:41 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 f9-20020a1709028609b0290128bcba6be7so820315plo.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ebBYyYb0auVU2YwhpjKMMCWgRzY2PJI9/2w5/quPrGs=;
 b=nnff9YiUi6n1ZXyRJwhfFa6RWAeI0wcpnPssLqmBzAlrRBcjFTQuzDYAjwhxx0tlOq
 e+S5uaB88ivXuMxCX8mLqcIxGLvJF0V0OgaJn+sutt6n3gSl0AMpkFhY5mvQYmX5ew+D
 WI5qVOypc6GBHMoJ6nmlJlq3ZzygfPXlMg/tlTJA1W3D9pghl6JYJB8QCS8actNnmxEH
 gpEXsFZyynm2ozl0zbOPO6kP0yJ+/Dd4eq1ppv3Z4wAoJhWULYv6Ab7hmS6ncnX9p3JE
 ETbTYxijY0mT28Xuh1/n2HOfAvYiMaaq70PB0zVzfsXQ57Q6XK+yfungcx56nOHn9I0/
 XKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ebBYyYb0auVU2YwhpjKMMCWgRzY2PJI9/2w5/quPrGs=;
 b=MObSImCdiatYgyw+v8csAqQDgHBlv+sA2ofoaVUL4lOLk3tV1cZbsZn+2N2IlK5BG9
 A2gjK8P/v6erLpv4WZDWcYmaWfqMdKwIHAT+uCiKAo+qT8KDk7F6nuhpsLGnVjfJmSBS
 XBaRzqYs5/YWmZuH4jqyCSa7QS/sQCLZwDCz1Lpyu08Y+A+90Db+C3N2uP3SBpGA9v7p
 RZ3S8QF89Vr9BCKENjLF5Q8X5ppRgnrSugCFwWXfmQ0ObjpWSIekKYgSs2llMTL1u+Ru
 uIFoNcciJ1Dyza4L1W7nfu4dmpHpXnL/GjWxZnzBa9QMWfH3PLO1mVGQBI+sgHsb5ZT9
 /FEw==
X-Gm-Message-State: AOAM530f6+WQYC3yi+xddg0PY581WQx2n6je7mx0v3jTv0HKA5mqyiBX
 JB74dpMg4u+cqN2rFXzeaTN36Tp+SJigLg==
X-Google-Smtp-Source: ABdhPJxSvUsBKjgUTRIyeKoK/lGVqGBvu8uO5Dr1jcgTFqQndyorWtPI9bFQSzNvrMxfbls15hUJ0mio4/S5Vg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e88:b0:13e:91ec:4114 with SMTP
 id z8-20020a1709027e8800b0013e91ec4114mr2606928pla.30.1633396780779; Mon, 04
 Oct 2021 18:19:40 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:21 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add some ITS device init tests: general KVM device tests (address not
defined already, address aligned) and tests for the ITS region being
within the addressable IPA range.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 80be1940d2ad..c563489ff760 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -598,6 +598,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_its_region(void)
+{
+	struct vm_gic v;
+	uint64_t addr;
+	int its_fd, ret;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
+	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
+
+	addr = 0x401000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL,
+		"ITS region with misaligned address");
+
+	addr = max_phys_size;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register ITS region with base address beyond IPA range");
+
+	addr = max_phys_size - 0x10000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"Half of ITS region is beyond IPA range");
+
+	/* This one succeeds setting the ITS base */
+	addr = 0x400000;
+	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+
+	addr = 0x300000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
+
+	close(its_fd);
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -650,6 +691,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
+		test_v3_its_region();
 	}
 }
 
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
