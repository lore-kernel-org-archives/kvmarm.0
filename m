Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBDFC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 00:10:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71890613C8
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 00:10:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 71890613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E11144B08E;
	Tue, 28 Sep 2021 20:10:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XjrNfDYr3-O5; Tue, 28 Sep 2021 20:10:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C0B4B099;
	Tue, 28 Sep 2021 20:10:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 705CC4B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 20:10:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gv0P3RZPPcqR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 20:10:15 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64B9449FB7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 20:10:15 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 a16-20020a63d410000000b00268ebc7f4faso640671pgh.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
 b=OcduwanS9+zbQtBQIsn7QLDWapwaawQ6JYaomhRYXBHwKP3XxspuKTqdNY7AHjZ8LF
 Mam7c87/hCgEunUPqruWzUs0W0B2vL/lnW0dDhkCDckbXOw81whQkk3s1mqsRZooDgNd
 aa4wWGsEiK5jw4PFOucqC9dvc8Tu7MRjkDenf6dtdNlaXrgKsh5kxuYsn54X9sAM2iY4
 Veszu21OfBFfpXUYQlikUUb/Ksiw6p9HgOtBfCHH5dRihO4A+S3VGBRPld3pkvmYmojB
 hQ0jQzZhtUqUyDzVt5neAxmB5AnVksFqNVWTvTvgGFJOSQig230no6FXWPAggEKIPEiD
 ihow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
 b=dB1c2TJQklbtbanmlzVxgx2khufRdtVS80W5R1Bsa05tYX6kyd03L/s2wddndC7Hmk
 SNCFSNdIaI6lhGc5M/WU0YcN9QZDHdRzy7pt6KJyWhCxb1b1qtcfGvjHgLqK2r6ScKo5
 3q0EsgeE/mY6AjWOpuYqwCk2w70l4DBsCUPq4sYUrtWIKo3nbW9N875AEBUF3t+lVlH+
 e+gDDtBr5BbakyxhQCRKWB9jcxWvnLBRSiSAvMmUNz4CKBbTgV2kA6Vxc8vmFB4/x37u
 gQCTCcy2FGRn35nuR2Zvn6la1GHD9/P6vdCLlshMWZMPm0CsM6jjTqhTyGhbYnk5k0a8
 Ce9A==
X-Gm-Message-State: AOAM5317qX/SX900neLYb+UvL7l1vqhEUWFh3xLvvT1SovEgdqQjD5KP
 enrTaWRGF2L8SIx/pq3NWA1CIVe+Hk/qvg==
X-Google-Smtp-Source: ABdhPJzkzLjl4g92VY7arsAEzBKHD6nwmq0Y1oE1FPFvZWFUloyF1dOqEoVeAe2wWT4qPxV/MTdo5z8oskqrWg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7b85:b0:13d:cdc4:9531 with SMTP
 id w5-20020a1709027b8500b0013dcdc49531mr7715978pll.27.1632874214400; Tue, 28
 Sep 2021 17:10:14 -0700 (PDT)
Date: Tue, 28 Sep 2021 17:10:12 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210929001012.2539461-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
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

Add some ITS device tests: general KVM device tests (address not defined
already, address aligned) and tests for the ITS region being within the
addressable IPA range.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 417a9a515cad..180221ec325d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
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
@@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
+		test_v3_its_region();
 	}
 }
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
