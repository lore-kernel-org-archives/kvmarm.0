Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA52DC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:03:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 403276115B
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 403276115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DC84B12C;
	Wed,  8 Sep 2021 17:03:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCgXJU3HAKEH; Wed,  8 Sep 2021 17:03:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3154B0F2;
	Wed,  8 Sep 2021 17:03:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E3E4B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:03:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpEMIDpDyBsD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 17:03:26 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 948CC4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:03:26 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 i8-20020a0cf388000000b00377cd31a04bso6578958qvk.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mdwlcJAV0GStJsITLNL3ZqNZME4agwBiOXArc7PbMag=;
 b=kARn5cBx61tJryJHFvH86n9eBN3rIZHcjfFArqGVKf+BaFhVd2k9Tm595wtt61FSox
 jj8wQUHlKUu4wT2BVRkWaeWpvIv+6YAB6Lv5feC+yKISuAb+dficClmK5DbAJlYgCE7p
 M3ZPeLNw8O1yae2EU/+9FxhyrfxFObDT9AQC16+fS473/rVQu6hgFV2UmuoVTBH/vTln
 d29ncLcAdgoGeCf++fySf2IJjLEo1KVCDiDZKJqgAe6UMJxE0rRrA8plDewHFi/DiR3h
 qjvhewyGkaMUT0zhKENRcG/uDsCY5+C7tPalDj1EcEhOYMXObTyShukIjLAQIoPZ7fC7
 B8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mdwlcJAV0GStJsITLNL3ZqNZME4agwBiOXArc7PbMag=;
 b=ruO/r9P55KgWh/WTN3/n9INTyhHlOOwUrOHc7tPCfcNjr9MXkYfljQMAfQq9CyYelN
 ghRwQtBvO3ZeIFjD04k6phZgIiEcwb/UjPklcO4LATIv5dHpkuA4ghgPmvCDDuG/rDTP
 zmBIKkKQ6mLa2hMCdDxMDs0Kwb8i0OJ9R6oJCwAji3N26zTaVJoO/12pocICx+H1qdlX
 tTCuWswT5xvN5WJiWrL0/LDHIfuwgeC2mYjRmndyuw5Ip5X+gV9VklaAG41y0uATSyQP
 HEQcfpFF1Ble7wz1PlnBiZmfW3Fauok3ZonyiysjoAO7PoQDrTjfYzEMFYVYUw5jI59Q
 xsfw==
X-Gm-Message-State: AOAM531KnKrrejctetsrwLCNMRUhhWLTzpWzY0bZFHC3uCvL/oa5bR/F
 PzO+AK8ol1rMZQ1NBsO/TC63NZ8CbmPtiA==
X-Google-Smtp-Source: ABdhPJzzdVOk4rvgoJk+dMuIIaVXLnnnjlRHrF4C3jZ6VX7trB2IyB3whLb/y9r6YyBdSetyplYF7XQKp58/rA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:132a:: with SMTP id
 c10mr232058qvv.35.1631135006184; Wed, 08 Sep 2021 14:03:26 -0700 (PDT)
Date: Wed,  8 Sep 2021 14:03:20 -0700
In-Reply-To: <20210908210320.1182303-1-ricarkol@google.com>
Message-Id: <20210908210320.1182303-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210908210320.1182303-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/2] KVM: arm64: selftests: test for vgic redist above the VM
 IPA size
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

This test attempts (and fails) to set a redistributor region using the
legacy KVM_VGIC_V3_ADDR_TYPE_REDIST that's partially above the
VM-specified IPA size.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..6dd7b5e91421 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -285,6 +285,49 @@ static void test_vcpus_then_vgic(void)
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
+	/* Set space for half a redist, we have 1 vcpu, so this fails. */
+	addr = psize - 0x10000;
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL, "not enough space for one redist");
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
+	/* Add three vcpus (2, 3, 4). */
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
@@ -542,6 +585,7 @@ int main(int ac, char **av)
 	test_kvm_device();
 	test_vcpus_then_vgic();
 	test_vgic_then_vcpus();
+	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
 	test_new_redist_regions();
 	test_typer_accesses();
 	test_last_bit_redist_regions();
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
