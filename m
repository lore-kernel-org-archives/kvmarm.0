Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A90DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE1BD6124A
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE1BD6124A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A7A4B10E;
	Tue, 28 Sep 2021 14:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZYYTV+Weo8Jk; Tue, 28 Sep 2021 14:48:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 649EB4B133;
	Tue, 28 Sep 2021 14:48:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8814B11B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZXbtvYskZsd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:18 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C80C4B108
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:17 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 hg6-20020a17090b300600b0019eec013c12so5669785pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fUDvleBJkSGe8lOh3dkmzfGX4tHDQ1QKX/RO2ptqrSo=;
 b=Z/RQfgzZk+32gteH7i4kLw8gjtuBJ7t3NViFbhZXp8sry6tFNAHRXo5U4RgNhBY3d0
 sj4AhyFVQiC83kUxXxgTV4jowAJUgQLeqdvdpMwCRQWyD1Njj6x1AQHULah81+vgUPrD
 Oo1VDq4SYKoXMvcKMSrM6I3kft28OzdEO9TVb3l0SX9m4evY8RzIUff7mJwbS6Tf+g1v
 bC14awJMU2nNgl45jjhNqJXXw0ePyq4scvCHXKWWlcJzmKfLZfr3jzNWX3QSx8Prrvko
 i89+gvWWvWO9bWbMa/feewXtcNDfiy5Hb49ytXAwA3incJRdyHYCbl+k3+Dk0MHPa9Ua
 EsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fUDvleBJkSGe8lOh3dkmzfGX4tHDQ1QKX/RO2ptqrSo=;
 b=RwLvD/E9oQ4jluhJi1lS69b45/l5fbwlvkkeh1aTyNIMF8Uyha+N/auv7EqmfhKt4M
 hNNo7bPzh0XTkJvQhhQAbNH/CBjP/oSEzNCLFuDIb57zUmyqVnJjCFSYLm4yql29L3OF
 zVxiK1iMHEWCoKifu9nD8Cn2pTa/2HBiDyIOaGe1gPeKqcc47sdxHA5HZahsDjJAd4NM
 KkV9hg2/eKuXaxRKwy4TxyjMF59eQuOy/CchxSqWo8AL8kioBaLkINioLRpOfkv/7OYx
 p+q/cuNrmjM935NQCIWA4iWhQDsVNllHeQvgQgAZWQ0cUqJzdl58m8JqIGfb4eCVELax
 c/Qw==
X-Gm-Message-State: AOAM531irKoWi8AzoH2lSD6Fj3zuQaW9bdSGrCV9qSxlZii52jn+5z2A
 i1y0nxhPxC6MLY2J2lNPpfduMpmTBb3OLA==
X-Google-Smtp-Source: ABdhPJxaPCod77YHjCMJtVQ4TqKDfVDSlfTU/H6e5uSeMsoXLnWnEuutJ+cCD0WdDIinQKs7VL8KioR3BtNsZg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1481:b0:43d:275b:7ba4 with SMTP
 id v1-20020a056a00148100b0043d275b7ba4mr7148929pfu.63.1632854896636; Tue, 28
 Sep 2021 11:48:16 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:48:00 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 06/10] KVM: arm64: selftests: Make vgic_init/vm_gic_create
 version agnostic
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

Make vm_gic_create GIC version agnostic in the vgic_init test. Also
add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.

No functional change.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 896a29f2503d..b24067dbdac0 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -28,6 +28,7 @@
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
+	uint32_t gic_dev_type;
 };
 
 static int max_ipa_bits;
@@ -61,12 +62,13 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 	return 0;
 }
 
-static struct vm_gic vm_gic_v3_create(void)
+static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
 {
 	struct vm_gic v;
 
-	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_dev_type = gic_dev_type;
+	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
 
 	return v;
 }
@@ -153,6 +155,8 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	uint64_t addr, expected_addr;
 	int ret;
 
+	TEST_ASSERT(VGIC_DEV_IS_V3(v->gic_dev_type), "Only applies to v3");
+
 	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
 	TEST_ASSERT(!ret, "Multiple redist regions advertised");
@@ -257,8 +261,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v.vm = vm_create_default(0, 0, guest_code);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -278,7 +281,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -295,7 +298,7 @@ static void test_v3_new_redist_regions(void)
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -306,7 +309,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -320,7 +323,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
