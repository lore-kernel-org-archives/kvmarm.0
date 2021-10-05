Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602F6C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DA4E61507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0DA4E61507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A144B2A7;
	Mon,  4 Oct 2021 21:19:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hHzoDBBe9bd3; Mon,  4 Oct 2021 21:19:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 621FA4B277;
	Mon,  4 Oct 2021 21:19:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB0B94B2D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9itVogL0Wysb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1095E4B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 v17-20020ae9e311000000b0045ecf8d62fdso1551921qkf.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rCtk0QZvGtJNNX968ZJI39G337e0fJGVp+XxoDUDdkE=;
 b=SXQnZ9JXeCK/1KvyKnaXPDby0VXKeDZEHG83sFNEnLHoS6OcJX0esOtEx5UMCaWA3J
 zem2hpT8tL7nMrmUE/AHs/Ca7QgecZZMCnQQM14JF8pvPu/A2gzcZpEUYXp1KTIFnFrB
 +KSWoCZHwa1ncWJ4jU9hGJFAXRg+hrXPJmAh5F9TwV2YCJiGgtFfqYpLav8FQQvNjgOW
 v4GkOJ2G48Iz8fIQHrzjM6TGFdZtUMX2bTzWzZih+UfpYlxcZDPKE5o7cyu/Z2gOfVnV
 /JvM8dLQzXMoCoqCg38MR2rOTpe+3CWa4yc7GCKWtTYQ5himxyksTSdxZnaGFjkjtgla
 oWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rCtk0QZvGtJNNX968ZJI39G337e0fJGVp+XxoDUDdkE=;
 b=6x+Bs2luNDGemSyPAytaydKUItx8jYJ8jfJa9Z87V8aGZyPEndTyMTMUq4mpXRAOG2
 G25xq/7y0h/in1l/mjc0A3WG1kIxEFyiDeBD8GGm/1bD8ALO+fooObr66nBdPKsTAaGX
 9lSJfkwHhZBx0N/BMHJWkQRuW7GsIMsWzqTTH2NLxiZFEuaTU9Oio9QKE0VC5kVosXw3
 mfTDIHd1gJauVa/Ah/gDWc+2aC3DoVxJYLnhb0x2bfhUMSQVxb1MBXiq9bLMOaQNvWh4
 QJB2TTbFV3A0rPWee9cFWVxrVkjvzRTirGAsu4rvJiqT8vz3fNWJ3wYct4SEiXgSL4tj
 o5/w==
X-Gm-Message-State: AOAM5319Naz5fFMjdt59rGZoYOf2bhTesv/utPA0F2P7P2rQsPCrisEX
 4dAe9LXccB5P2CEMj+0Uqgletg+ITfhxzA==
X-Google-Smtp-Source: ABdhPJyCZCbvLGaSOMLBNe3BbAg0ASeNDo4wRQXjlyaPDuVIvUAXFBLjEBfIfBt3sWnzogbCLGnR6iAx5B0baQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:528:: with SMTP id
 x8mr24810755qvw.30.1633396774726; Mon, 04 Oct 2021 18:19:34 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:17 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 07/11] KVM: arm64: selftests: Make vgic_init/vm_gic_create
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 896a29f2503d..7521dc80cf23 100644
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
@@ -257,8 +259,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v.vm = vm_create_default(0, 0, guest_code);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -278,7 +279,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -295,7 +296,7 @@ static void test_v3_new_redist_regions(void)
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -306,7 +307,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -320,7 +321,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
