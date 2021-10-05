Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769EFC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AFCF6140B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2AFCF6140B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D23CA4B2EC;
	Mon,  4 Oct 2021 21:19:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y1ot56ayNRag; Mon,  4 Oct 2021 21:19:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A936E4B2DE;
	Mon,  4 Oct 2021 21:19:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 640E64B2D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1bi95Ic+L78f for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:40 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1411A4B2CE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:40 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 w4-20020a1709029a8400b00138e222b06aso833398plp.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LALo9JihRPRBkG1fYYMRtr74GhwkziudPmPUGtI9Fw4=;
 b=hLp0tj96F1OWP6HZwu3DGIrMazfL6bcOfnvTYKxYCIBaSh7ob8veeFJ1cVziBgXiNu
 bqDrG6sf6VCe/KsbjSR1p681zdh/F+klgPr6dB1bTJk/a4PtAI6cijGq+E9agkE4aFia
 Cz7Eh7XfwNv1k3E3mcPqWnhYUmyBjKyzPC1NH5IRoVCNFnkLS09HpMcftjRF+Yi8698c
 YrHRxITfEQOixXsbTKe7pNCA/4goHDQf2kL5LCTSXPQKvj61JXw5DWKR+L4y0qXYfaoL
 qk6JF+TDk4oO40MLI0Zjx2Ls1zHqiuP21PrRPIgk/+99jerLdZ4m2+nKG/47fiu8X3t3
 C0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LALo9JihRPRBkG1fYYMRtr74GhwkziudPmPUGtI9Fw4=;
 b=V+h9/djc2Es3pkfwJfaWpAy2QVLzNDP5KMzhG8Fmmf6Mg0oMK9fobEQrk4HeA0CqpN
 mynLTMquC99zAzoCyJP7QMAJU8Gd0BeRXOhF9CiEZ6NRMxodcTyYy7HfYOpMQvTOnqu4
 lhNMsqfOYHFqYgMXarrY2fLb84aWueJsPydiO8eIJISePCq07X5Uzfb4Aux7EypE6V42
 D+s3q/AG8rP4pbsrzcWZckSYFKVgbGsF63Gvr6CsyC1HIT3MF8GjrgNhN4D/MZ6W0gXt
 fZW62hbRErYDfhQnGeQtHNl1shphacpgzpSU0Wr7BuG59ojhcXxSUPj6FqNfw07Xowc0
 QyJA==
X-Gm-Message-State: AOAM530CpLAhdD3Ju4QqE0LZ5+r/Ku0EPJH5Vh+QSky0h6K8+n3lvZjP
 rGuslHzKYeSlXrhWvgAjuUOaDJy4MOek7Q==
X-Google-Smtp-Source: ABdhPJzUUkZEXh0YtKOvuw4kldQta6Fk0jXOVYU6rXgMHyhp34IKvaz+CMANxBajmBBPTWnz+esVVsUyc0CDoQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1804:: with SMTP id
 lw4mr383225pjb.174.1633396779303; Mon, 04 Oct 2021 18:19:39 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:20 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 10/11] KVM: arm64: selftests: Add test for legacy GICv3
 REDIST base partially above IPA range
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

Add a new test into vgic_init which checks that the first vcpu fails to
run if there is not sufficient REDIST space below the addressable IPA
range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
as the required REDIST space is not know when setting the DIST region.

Note that using the REDIST_REGION API results in a different check at
first vcpu run: that the number of redist regions is enough for all
vcpus. And there is already a test for that case in, the first step of
test_v3_new_redist_regions.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index eadd448b3a96..80be1940d2ad 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -565,6 +565,39 @@ static void test_v3_last_bit_single_rdist(void)
 	vm_gic_destroy(&v);
 }
 
+/* Uses the legacy REDIST region API. */
+static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
+{
+	struct vm_gic v;
+	int ret, i;
+	uint64_t addr;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
+
+	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
+	addr = max_phys_size - (3 * 2 * 0x10000);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	addr = 0x00000;
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(v.vm, i, guest_code);
+
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	/* Attempt to run a vcpu without enough redist space. */
+	ret = run_vcpu(v.vm, 2);
+	TEST_ASSERT(ret && errno == EINVAL,
+		"redist base+size above PA range detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -616,6 +649,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
+		test_v3_redist_ipa_range_check_at_vcpu_run();
 	}
 }
 
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
