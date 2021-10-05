Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E83C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D3FA61507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D3FA61507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F2F64B299;
	Mon,  4 Oct 2021 21:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xR45USROlMkx; Mon,  4 Oct 2021 21:19:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 901C14B2D7;
	Mon,  4 Oct 2021 21:19:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9427E4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TxDtl-zkUhya for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:38 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 418284B2C8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:38 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j193-20020a2523ca000000b005b789d71d9aso15573965ybj.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=S76O3ETAe3yQxXAd2JJTjNgxqbnnjrbVIsMmqpzrAMM=;
 b=Yc3iAwJ1KU0xk6PUvDOO1DgsqmjfDLUcct/Cp5cplfLvtPICb0rCsFcEtIZJ9bDna8
 sHiNe5RXDfTtL+rUhKyj+lG76BwPPVCrwx+UtBvtwuE6fXeahv+aXLtwaWZJ5PBHu57X
 Nx9xldr7H4lvuoW4dVJBA5Isg4HZBYdy1v6SMtTUYSyq18GDlrpJ7aLRpD10wT8xPuAB
 a8CCrcDx2rNjjS+MZqWj9pDWVA8zsMR/GVMiIHk04n3ot2qLt+9UIH/41ihcMMym5Azx
 +jfxBWE4kq2KdkjtjIun9W/bXWcx5xp0zbkXPdCum3IT+RqqUXDU8Ny0fVk59eWHjWSn
 +v9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=S76O3ETAe3yQxXAd2JJTjNgxqbnnjrbVIsMmqpzrAMM=;
 b=olOKbqBwC2nVgNc0qD2XkZutYgiMZYcV/23UNXUYdb7y+IDtdwwYe6BPMt4EeHeJ5T
 kGFGQqnJc66q9FgXbb7D9URkQs+RUWxBouc/BTqdosfpM90nErLi6PgrWb4zwA7I2Ea7
 h1sW1dkVjOnA5xOk3SO7Y6K8S8aWHdSKilOQW4MRA/Yf+bERVA8JzF7HghPAiwBinnJq
 445IYQjzTAchpAvvT+cpxUHysFIufoDJH7jsvjmfto33HdCLh45DFWMY6X35YE+Siksz
 6clQl+gCYrW0ZprdQvbrWSG19rJJefVcjm8HGarqoaWg1MiQr6hvaf6WDRhj8o6WykCy
 utaQ==
X-Gm-Message-State: AOAM5300Z7BJL2p2rNpdUmgyy71anKFD8TOwYYhoWsAGfPOziSalj+l0
 fo+QDgJm0tnYHVioVYudPxjl7w9Jb9/VhA==
X-Google-Smtp-Source: ABdhPJzLLpKp+6FIvPQvjCg8Ehu7YXxwucVWSZhjf1W55UmsjljX4QCwDd3o5as7VVh3HZvvAVWVG523KA8lWA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:c183:: with SMTP id
 r125mr17844375ybf.37.1633396777861; Mon, 04 Oct 2021 18:19:37 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:19 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
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
 .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index cb69e195ad1d..eadd448b3a96 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -31,7 +31,7 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static int max_ipa_bits;
+static uint64_t max_phys_size;
 
 /* helper to access a redistributor register */
 static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
@@ -152,16 +152,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
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
@@ -250,12 +255,19 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 	TEST_ASSERT(ret && errno == E2BIG,
 		    "register redist region with base address beyond IPA range");
 
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with top address beyond IPA range");
+
 	addr = 0x260000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
@@ -610,8 +622,10 @@ void run_tests(uint32_t gic_dev_type)
 int main(int ac, char **av)
 {
 	int ret;
+	int pa_bits;
 
-	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size = 1ULL << pa_bits;
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (!ret) {
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
