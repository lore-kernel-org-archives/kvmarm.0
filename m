Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFD6C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 00:03:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542A04B102;
	Fri, 22 Apr 2022 20:03:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n1RZAfFwM88p; Fri, 22 Apr 2022 20:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A344F4B1FE;
	Fri, 22 Apr 2022 20:03:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37EE04B106
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 20:03:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wkJrFNo6UB4y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 20:03:53 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B68644B231
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 20:03:51 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 t5-20020a17090340c500b0015a791cdf10so4136654pld.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=s8j9kj4vlgoBbVsMqTWGwW74KTbhvSIyPcu9kjmk3mg=;
 b=Kf/obMymV4dKTLaHQ9vU4iXvPrE4oPgT1V7IU2nfscX8IQV7XePv3hocOPRD9WGWS5
 qbqdVHGKg+NzqNIxosRgBK0ZoTUP+V1zuEf6JCVhnsdtSIorKYV1lMswst4f7/aOwsXN
 TeEL29nm1GDndxDwEEU3sPxLD9aehBKPDUQZpO0M6iqu8+C67ydwXnTP6ypLb2nzUYNl
 3bAkmcX7/05uXq7IYcs+GDKCo15Jr0qbLoY55JX2cug1q4nIlf+sfHk3sMv2J68Dro9K
 XIimltu0kNIfB1I9N9SHiI9/77weHhz3n+dpmKV1HpVytDTq+/WIiA8uWayp2iVwGfBz
 D/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=s8j9kj4vlgoBbVsMqTWGwW74KTbhvSIyPcu9kjmk3mg=;
 b=dN2jx6VJN5XhIMJ0SRWTZemu2/xpaXd/jFhf5ZLk4SJ1o7p8Wel2M8F1o75IA/Q7OB
 nAWQQSg8CaXC93vIYeb7wtorLoaCGJCCKPavdQIeMVWx6giSSN/cKbIdY5jL13OB0T8C
 liYPpQFTYQkNOCTKRouuP0r4wWnQOpxTHDD/9fJ3mXZAI9fx43yTju15vbAp+1OCZ/fY
 ZdIgi+D3+N+bEabJOOrGGmSTby11134IxIHXeLQZOBA0hzkZ1VymnuQX/qxACAY8Lu7n
 6dEzv15oo3uB47ts9ZWW5jxPYZWnK1/BG2iGBKhU2ad4nMZyL4hwg4Uhlp/CRJPQxTPg
 wh8w==
X-Gm-Message-State: AOAM5322MHvNRHBnESIy8p9TDTP3z6fyrH+6FeEME1g0w1IDbDAA/iK/
 YHt00PUBmXZvl1sLwz7BPsWu4am5/aZc
X-Google-Smtp-Source: ABdhPJxLdnqeaExMLlAnDRAdqhlgHYhal0Uv3YiRM0Qpe3ApegAEaDu5LxZo18Qe+X+tJK/Krg4ftUZZ1Hoe
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9522:0:b0:4e1:d277:ce8 with SMTP id
 c2-20020aa79522000000b004e1d2770ce8mr7486812pfp.16.1650672230928; Fri, 22 Apr
 2022 17:03:50 -0700 (PDT)
Date: Sat, 23 Apr 2022 00:03:28 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-10-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 9/9] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
the base_regs[] list.

Also, add the COPROC support for KVM_REG_ARM_FW_FEAT_BMAP.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 0b571f3fe64c..d3a7dbfcbb3d 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -294,6 +294,11 @@ static void print_reg(struct vcpu_config *c, __u64 id)
 			    "%s: Unexpected bits set in FW reg id: 0x%llx", config_name(c), id);
 		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
 		break;
+	case KVM_REG_ARM_FW_FEAT_BMAP:
+		TEST_ASSERT(id == KVM_REG_ARM_FW_FEAT_BMAP_REG(id & 0xffff),
+			    "%s: Unexpected bits set in the bitmap feature FW reg id: 0x%llx", config_name(c), id);
+		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%lld),\n", id & 0xffff);
+		break;
 	case KVM_REG_ARM64_SVE:
 		if (has_cap(c, KVM_CAP_ARM_SVE))
 			printf("\t%s,\n", sve_id_to_str(c, id));
@@ -692,6 +697,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(1),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1 */
 	KVM_REG_ARM_FW_REG(2),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2 */
 	KVM_REG_ARM_FW_REG(3),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3 */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
