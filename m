Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF4BC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 00:49:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3ED2D611BF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 00:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3ED2D611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA63B4B205;
	Thu,  9 Sep 2021 20:49:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I2VvRKJ4CyzJ; Thu,  9 Sep 2021 20:49:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC534B227;
	Thu,  9 Sep 2021 20:49:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A24E44B1DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 20:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lIQI0bMDy4LG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 20:49:25 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F9254B126
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 20:49:25 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 ib9-20020a0562141c8900b003671c3a1243so612479qvb.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 17:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qXTzlQcki5Z1B3LV6gzbhBx4QrZxfh2wOWzu6LDwbLI=;
 b=DvMVWjV3QYWlrellGcgEt+A/tPhUiz5dpu+g0e7xAqEBmW+XVsbtrG9TSYRL/rQbF/
 Vb8PshuGDJefFH7kzGp5MQuYE4qrful3MV7uzGaerCHJkLlyAGRIqp+Fxfc5PC2M8IsI
 aCDSZ9Q4tEw62gWGjSFCY9w09U3jPwLqNBEsvGbDeRlLCi6Wz7AwUU/gRyLcto7iRBVm
 TRmv5hSI6M4wM1n2YZ59xwuxCIyw9GlkBAwvjlSKcoUB5gkBfuZGfObHt+Dxxp97BBRM
 pU3QP1vrVQGZvyf2CH3rmBHrJOMRO73ARJ1C5a+KsAiKEjtpkkxBBD7YAHn7RQBdHGps
 VfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qXTzlQcki5Z1B3LV6gzbhBx4QrZxfh2wOWzu6LDwbLI=;
 b=vTY+cpA5OHYGpVEmC+wibaBoTWq3Jx/wl4s23PdRu5iUuMKrfiVTIYShNfznWeR/rY
 dvxrQNqYJ4mz2Hf4gUn8NgSoP9WN3h4L+tY2a889kdYt4zObAw+u5JbQjrYDPFb3CFw/
 VoUh/3OiaEIwxfgL1uKK5Y+0bcB/2OBTPoTxv3W+ffnZW5zSC7KM8HNAHxqvQFFl/tfZ
 3MT0miycpwMu64M337eZ2pfHkvxhhy+Hd0e3wFwJ6MU8BzVGSCojwHxP59EU0KgfHGN3
 qmRaY0sjXamZYQ9ihiHFAlNM/sGNsZXBGdsXBo2Kf9ly39UDBlYiXx/a1ZwS9dJ5cvU6
 rwXQ==
X-Gm-Message-State: AOAM5322nwRXK04zJfclD9jADkSKtvOaTKG81mpqo+1ybpiqB83BtVNP
 0zeXZ6QtMQ7L7CpbgLaSZmIPyXfm++VQqA==
X-Google-Smtp-Source: ABdhPJziAmZhL+w/+T/9SGzl2L6SkBxRI7kg2xJlY6KsdHMtvzcpxiUebER6o80VRB2Z/qQzuTXCgswqOmGYtg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:522c:: with SMTP id
 r12mr5969701qvq.17.1631234965148; Thu, 09 Sep 2021 17:49:25 -0700 (PDT)
Date: Thu,  9 Sep 2021 17:49:19 -0700
In-Reply-To: <20210910004919.1610709-1-ricarkol@google.com>
Message-Id: <20210910004919.1610709-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210910004919.1610709-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 2/2] KVM: arm64: selftests: tests for vgic redist regions
 above the VM IPA size
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

These new tests attempt (and fail) to set a redist region using the
KVM_VGIC_V3_ADDR_TYPE_REDIST and KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with regions partially above the VM-specified IPA size (phys_size).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..15aa01dc6a4d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -285,6 +285,57 @@ static void test_vcpus_then_vgic(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_redist_above_vm_pa_bits(enum vm_guest_mode mode)
+{
+	struct vm_gic v;
+	int ret, i;
+	uint32_t vcpuids[] = { 1, 2, 3, 4, };
+	int pa_bits = vm_guest_mode_params[mode].pa_bits;
+	uint64_t addr, psize = 1ULL << pa_bits;
+
+	/* Add vcpu 1 */
+	v.vm = vm_create_with_vcpus(mode, 1, DEFAULT_GUEST_PHY_PAGES,
+				    0, 0, guest_code, vcpuids);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+
+	/* The redist end is above the IPA size, so this fails. */
+	addr = REDIST_REGION_ATTR_ADDR(1, psize - 0x10000, 0, 0);
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register redist region with end address beyond IPA range");
+
+	/* Set space for half a redist, we have 1 vcpu, so this fails. */
+	addr = psize - 0x10000;
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register redist (legacy) with end address beyond IPA range");
+
+	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
+	addr = psize - (3 * 2 * 0x10000);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	addr = 0x00000;
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < 4; ++i)
+		vm_vcpu_add_default(v.vm, vcpuids[i], guest_code);
+
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	/* Attempt to run a vcpu without enough redist space. */
+	ret = run_vcpu(v.vm, vcpuids[3]);
+	TEST_ASSERT(ret && errno == EINVAL,
+			"redist base+size above IPA detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_new_redist_regions(void)
 {
 	void *dummy = NULL;
@@ -542,6 +593,7 @@ int main(int ac, char **av)
 	test_kvm_device();
 	test_vcpus_then_vgic();
 	test_vgic_then_vcpus();
+	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
 	test_new_redist_regions();
 	test_typer_accesses();
 	test_last_bit_redist_regions();
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
