Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29850C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D602361262
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D602361262
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B2074B105;
	Tue, 28 Sep 2021 14:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tmazzUF86-dT; Tue, 28 Sep 2021 14:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B34074B13D;
	Tue, 28 Sep 2021 14:48:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826914B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dg045My62GsO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:22 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3D264B125
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:20 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 m6-20020a17090a7f8600b0019f0e6d9b81so3078642pjl.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DAIt+H09/55OKEtE9w5bih5JH14ibKqMeAyogQTb7NA=;
 b=V9boUQARyAIacnbUDUeErmiotuKDAaOjvI+Zyh7Jk5DyJcOgLKNUNUcZAK9+AtDYsM
 5DrGTDpuf4+k7NM4GiefH0KhqJrY7VWQc6Pb/QB0EEAZvTSML9AHMANHOhl6QqjiRhr1
 zf/PRkGQBSLNNkUlOyUPQV8A3F7BjQDw73jU8AHk5ZHkGb0d99YhkvmpA+QsIv0q78vj
 3+S5u08Tz7CpqyUSQpecNBbb8g7V9IqJolvOU7ZXpnAnSBzpm36x37L+IDuWJahhxM0i
 /xJI65YMZfH9Ds+OWKK5idobadvujKpxvgt7RJZpWCVuYCZmum/9AAXyEH/EXuBzphYB
 6BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DAIt+H09/55OKEtE9w5bih5JH14ibKqMeAyogQTb7NA=;
 b=Ss/eOSiuvNMhm+f8nWDbizjI6Rv3MvqeWf5r75rt/0AitFYXLBN7/2mImvTqxrcTe1
 hTR3W3XkkRDWwTm/rFOA+pq6SC2FjaD4R2vZypi2TyKVnQqWG6hviB8vtT4iCXNZ6Wv3
 eCpuv5VKVgdguAjkkc6pTRByosevXP0T+CbwEak1ZMTZhXFvgEnz07QUWD26rrjNRspG
 cgXSgNUX3yUrl0i6ftfAq5LnI1dMLneH8WE30HORCACFngjYNV0ruyenlQrbBnuXoxkW
 0WHt8xdCplTejnyBBNujjRGATm9UoroS1CkYin9FXXNltMdhiqtR68+WwDGy7ilMfTVO
 rJOA==
X-Gm-Message-State: AOAM530kLHc9fFTMhl+fLoQy2ipFKCHM30YxjtsTPIzS+kv+AuKcgxPZ
 ueWR3wvfCHlXwKg8/+kJL7SAklDIgWFJrA==
X-Google-Smtp-Source: ABdhPJzBsTVis9j8OArZICNpPTg91je2dRVms+08Gd+Zw0+o9ENIltafYzAWzsGkahkSD6Zbrj6mYRkqyxOFEg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8f11:0:b0:44b:21bf:b76 with SMTP id
 x17-20020aa78f11000000b0044b21bf0b76mr6991440pfr.43.1632854899868; Tue, 28
 Sep 2021 11:48:19 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:48:02 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
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

Add tests for checking that KVM returns the right error when trying to
set GICv2 CPU interfaces or GICv3 Redistributors partially above the
addressable IPA range. Also tighten the IPA range by replacing
KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
guest (i.e., the default).

The check for the GICv3 redistributor created using the REDIST legacy
API is not sufficient as this new test only checks the check done using
vcpus already created when setting the base. The next commit will add
the missing test which verifies that the KVM check is done at first vcpu
run.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 46 ++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 92f5c6ca6b8b..77a1941e61fa 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -31,7 +31,7 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static int max_ipa_bits;
+static uint64_t max_phys_size;
 
 /* helper to access a redistributor register */
 static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
@@ -150,16 +150,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
 	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
 
 	/* out of range address */
-	if (max_ipa_bits) {
-		addr = 1ULL << max_ipa_bits;
-		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 dist.attr, &addr, true);
-		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
+	addr = max_phys_size;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 dist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
 
-		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 rdist.attr, &addr, true);
-		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
-	}
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
+
+	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
+	addr = max_phys_size - dist.alignment;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+			"half of the redist is beyond IPA limit");
 
 	/* set REDIST base address @0x0*/
 	addr = 0x00000;
@@ -248,7 +253,21 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with base address beyond IPA range");
+
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size - 0x10000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with base address beyond IPA range");
+
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 	TEST_ASSERT(ret && errno == E2BIG,
@@ -608,8 +627,13 @@ void run_tests(uint32_t gic_dev_type)
 int main(int ac, char **av)
 {
 	int ret;
+	int max_ipa_bits, pa_bits;
 
 	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	TEST_ASSERT(max_ipa_bits && pa_bits <= max_ipa_bits,
+		"The default PA range should not be larger than the max.");
+	max_phys_size = 1ULL << pa_bits;
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (!ret) {
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
