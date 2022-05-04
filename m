Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55565C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 18:44:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A64E449F29;
	Wed,  4 May 2022 14:44:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AfCcwVS5kcIe; Wed,  4 May 2022 14:44:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FDAA40C52;
	Wed,  4 May 2022 14:44:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08D740B8D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 14:44:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FUFZG9F68Y4p for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 14:44:21 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9C5C40AEA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 14:44:21 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t15-20020a17090a3b4f00b001d67e27715dso3326331pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 11:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=VCyTBnecYpNJdRLQCPsrzRcQbyCBtqwFjPmA2xqKa88=;
 b=YNx+vJHh5la1cqk7J51+Ly9mRTpv5jSKyWf75UCfc3ZOzIf9YBKLf7iKP1caXry4f2
 Qr0R9DNxiq560S3gHUdf4bSx/YjMrtnurM+IPCP1p/+8edfGwRboRhxREYbP56zp18Mn
 WzF3fBxbsYfmkBjcmDOGWD3gfgs+OVzowspbyrFoZcePIvyywBwRWkH5gahjMjcAFFny
 H3OSivgwBzQFGXneVm5nXwj5smH3Rd03MY2z9yHT7LYDIKv3WkgVsWms/VH2wKlZS7/d
 ACQ/ZzMZwM/BPd8U5F6qUMXU6EmwN8G32e0z2WtIUOYK2ZvzNd6M0LHaHWwFSxBB9pm0
 MJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=VCyTBnecYpNJdRLQCPsrzRcQbyCBtqwFjPmA2xqKa88=;
 b=MVuv1gAAMEvi6ZI4qog2eA7+QSxyEBnGzNU7mhdrX2HyVMyVCuormJz3moQz/MxhEq
 Gmfjr1pkeFtF8zH2LbG91WEq9pvDxYWL0g/j3FK+uPqppXk5FTqga3eVAmGHmlD0PdQ5
 CqMN9hTwPcRsgbAq92Vs+FEjQJ849CFeI9VrCCfaPX/tkpzdiUODz30YCfTOlz4un1PF
 Heuh9Kh//VnPDLyvFfUqoTzCbMv4WmwWqd1OjoxBhYMftj89nLkD680e01tPDWcMKejI
 nfVgcLuf4zJAi5JXX+ZdP4puzPpjbVV9WvM/rvC3sflPcjYKt23G64fIjly9bwyD25bn
 rA3A==
X-Gm-Message-State: AOAM531N+P3lsnOHUkH9L9Btr2ihDEQ+cwKIavFUXxeVFwiwY9A517Eq
 2DGKDrx+PPSf5b/pzRq1M6a11yAYB+SE
X-Google-Smtp-Source: ABdhPJxcxmOQZgwG7ijdgiiboeoF9R0zWhsHRFBvRXOGMQ63dEaW3j2rbPdrIFcHlR+d3fNJwVhWG1ZOtPrm
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1a4d:b0:50d:5921:1a8f with SMTP
 id h13-20020a056a001a4d00b0050d59211a8fmr21991848pfv.64.1651689860717; Wed,
 04 May 2022 11:44:20 -0700 (PDT)
Date: Wed,  4 May 2022 18:44:15 +0000
Message-Id: <20220504184415.1905224-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH] selftests: KVM: aarch64: Let hypercalls use UAPI *_BIT_COUNT
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The hypercalls test currently defines its own *_BMAP_BIT_MAX macros to
define the last valid feature bit for each bitmap firmware register.
However, since these definitions are already present in the uapi header,
kvm.h, as *_BMAP_BIT_COUNT, and would help to keep the test updated as
features grow, use these instead.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index 41e0210b7a5e..dea019ec4dd9 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -18,20 +18,15 @@
 
 #define FW_REG_ULIMIT_VAL(max_feat_bit) (GENMASK(max_feat_bit, 0))
 
-/* Last valid bits of the bitmapped firmware registers */
-#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
-#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
-#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
-
 struct kvm_fw_reg_info {
 	uint64_t reg;		/* Register definition */
 	uint64_t max_feat_bit;	/* Bit that represents the upper limit of the feature-map */
 };
 
-#define FW_REG_INFO(r)			\
-	{					\
-		.reg = r,			\
-		.max_feat_bit = r##_BIT_MAX,	\
+#define FW_REG_INFO(r)					\
+	{						\
+		.reg = r,				\
+		.max_feat_bit = r##_BIT_COUNT - 1,	\
 	}
 
 static const struct kvm_fw_reg_info fw_reg_info[] = {
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
