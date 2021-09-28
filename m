Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27D1C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 20:12:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CA71611C0
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 20:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1CA71611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFC44B0AC;
	Tue, 28 Sep 2021 16:12:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TzBFtO9BbX1J; Tue, 28 Sep 2021 16:12:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 782A64B0C3;
	Tue, 28 Sep 2021 16:12:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 843714B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 16:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IO5lFdTVLVqP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 16:12:02 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3052F4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 16:12:02 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 d81-20020a251d54000000b005b55772ca97so143476ybd.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 13:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
 b=Nc9t1pLswT3y0G3mxJl8UdpIzcua8x8wgYPHnJt4U4C7m+A+xdDKv+yPTgKb6X4pPB
 tGeFDlt4eHfjy/+pg5ztGzMK0UPRlLSpv4/qQs7GYsu1cirMcqcPDs3aCS9B2XMaHwuh
 jlaSseJfAO+NGWoERn46AEsCt2zIVJpAIch40je1xmUy5Gj0pybObZyMGNai0Z/tCaLG
 Cju53o5orzJvYMyRaisaS0ZgR80mcDaYjuxuAoOeO2Q5VfFRuBYWf8sG8rR2HY/72qgO
 smjiXPVlaMu/ZHmTujWM1OfRrO7aEeGjrz70ueFNHnUywNSxl32aKfpw+vmi1rHnqYup
 PkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
 b=nK9gCw+T3kFFzyUeG4BUN6jJx2xim7HmpOWFt8XcuW67aE2e8OWWPulht/vFbDB5gw
 S2VR5rQcl5DuKxEje4d9z3W9krtE47p9sV7CBP+o1JPnzzG7WozCHFoMq7fH0rCGu2xU
 7bMuNECr9m3Q4ET/3jrLvPmMVuLOzGn/HtIKLAZ8wqCUHzFXtVAjIZDb8Tz5FnO/Z2gV
 dnGavus+I9yHhTSvsm/cOr9EnzAmyOOWlmezlxXUuS4I/ch/BK5gu4806VliiiVj4txS
 1lUhHa7ibmakKtA+UrYV7RAPqEoVQSYPU9IQCqVOIFCUNTjdtKLoNzSMRWLhuVUsxvIJ
 b0Vw==
X-Gm-Message-State: AOAM532lfbaEJmNyJ8ggEQEw/hsTGk7KOZuYiQxgK1HTm9bm8Ob/BQdv
 RsBKN1Ot40+/PqT1SurRpd26pDzpyhmndg==
X-Google-Smtp-Source: ABdhPJw8MrJiLzblo6lnWZ5IAC2p8lhfkKmhypzz27FkHzMv1y+sZHucn0xw+0jnRkZwdZQ6VxVlyt03jGas1Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:d1cc:: with SMTP id
 i195mr8710836ybg.195.1632859921712; Tue, 28 Sep 2021 13:12:01 -0700 (PDT)
Date: Tue, 28 Sep 2021 13:11:57 -0700
Message-Id: <20210928201157.2510143-1-ricarkol@google.com>
Mime-Version: 1.0
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
