Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522D1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 087B961262
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 087B961262
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08074B125;
	Tue, 28 Sep 2021 14:48:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0q2NzRf4Qk62; Tue, 28 Sep 2021 14:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DD1A4B135;
	Tue, 28 Sep 2021 14:48:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DFB4B126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GnC4QmRdRYMy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:22 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC44B4B10D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:21 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 81-20020a251254000000b005b6220d81efso24070327ybs.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZhEmB78EvpVTOsANLrCosu8pC98ZcmeaZO8tz0FwGlI=;
 b=YNSS8yS/z8jbHApl7mmywh0W1TLkLd6JZW49ibxi38G0CqByei3gUhtbVVxcFCqznL
 +eSsAuKpRCII6ctpAJcMLK326hVO9wf6Qjvb1e9jXGnbGH/7gyzCelwLv33aSk7XkPyY
 WIuuK9d2jFhVnU6d9niPepKKA3DMV2pipGQ7dclPi7UGDZIu+GrbJt8UKsgcUF26H9b6
 o3vAZSIUZAcmLp2DDQk0w3bzO+VAD1+87XkH6BnUlPEXFWJCVeYmz60YJEBqrfk7/1qm
 AhEpJU+tSBBYGt+qBlpBNkVNzMtzmgVuViMRfT69EWX3K5xUUyVAZr6wQz0mUQVP5O5b
 3lDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZhEmB78EvpVTOsANLrCosu8pC98ZcmeaZO8tz0FwGlI=;
 b=eY2b2uB+laqJ3tGqmvl02yHCqoDqz3/RfvdS/S72QY8K8IuL2zCNh9dl8ITGlUUpju
 6rWp55KX/Z1D1FVN6M7Mzcol6tNzt2iaodxOxF6Ck3Ce6x31IsRLDqwRxincFr602UuV
 OFFYgvvjBfegM/OkOfQM98o+D1xAtMrirenRMO60RA4foik4m/c8Dq9wbHx/Bl6N3boK
 WN/7WQ9+GYxDF9rpeVYr/fLfTp4Re5uCxL6dZwoNV9Yu9I361xqq8b4a28Ycg/QbAqFi
 uZh3bp8CwnjoKnF6fxq7v9JCaymh264M3I47LZjCaHyDitl4GQN/AtWL3vhvJm2JoTrs
 pmYw==
X-Gm-Message-State: AOAM531S7XnYm7Ts/rmxd2ELo6Xkf8RLk/S/JELn7XmJsbi4UTUlG27o
 ACuddMQmSmZDUKd/Almw5Lx/WjXW6seZLw==
X-Google-Smtp-Source: ABdhPJzDRwtz5/PIS4rEfzA7iNdd+2JLcH0fuSM5FcZ6MjFSl3lzeEEHGCn8BGM6vv2p+Afxprn6T8QiiqVT3w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:22d7:: with SMTP id
 i206mr9011325ybi.355.1632854901316; Tue, 28 Sep 2021 11:48:21 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:48:03 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 09/10] KVM: arm64: selftests: Add test for legacy GICv3
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 77a1941e61fa..417a9a515cad 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -570,6 +570,39 @@ static void test_v3_last_bit_single_rdist(void)
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
@@ -621,6 +654,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
+		test_v3_redist_ipa_range_check_at_vcpu_run();
 	}
 }
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
