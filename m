Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7E7C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 23:39:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB204B1C9;
	Mon,  2 May 2022 19:39:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ppSCjjeHLd7p; Mon,  2 May 2022 19:39:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 175CD4B2B1;
	Mon,  2 May 2022 19:39:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A96374B1D3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kR6mWH8zeRs0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 19:39:15 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AE284B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:14 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 67-20020a621846000000b0050d22f49732so8700683pfy.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 16:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QkUuCyfxz0yjq0ch3OSwAfGOrfLGsj9nivNwXJkBK5g=;
 b=Tz4B+eH5HuR8q9n50g2/acZQ1++xVDSFvRimXeQDdZpwwV6NnFK5XDO0sFqEWVjyBN
 bc+Oht/ftGLWzoJ4M5oryTr8Xu7CvNGxEKik36VmIsd3h671BNKOGBFuexD8q0RUYnZI
 XKoyGdtg/FqUw6tTq7GEWV4EPY7Ci5CJ1MPNWYw+cwrGq4cnvsHswlPZJKhT9hmGGPPU
 ePgInDo8PXPQzXvRb5poWc4C5ubPcjNe/lQkDyN6uQ6fABWwwOUxeHQGLbp0cmb6yuSG
 sP/ySXKvvzS1aKN5b0npOOLzWp8ORKF6p8dUY9q5p++ixxfMUyueouQSFUzyB/KOscx/
 olyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QkUuCyfxz0yjq0ch3OSwAfGOrfLGsj9nivNwXJkBK5g=;
 b=hvUYVL4UqAByalfVzUruEXpMnSgA+thP9UsQZNZNwe5pJUUdO+KHXV5Gvu37COyq3N
 9fDfwXMoyntyRWpwLqbFQtocjF1rHln579Gh6w9D454GQhQcTXD+NCFmtjs6l1mPz4X7
 5LVyzYLLA3VcL9MRebUvaazbnmpcXgpjF8HCNmSs2DUZBB3MEVfcy6kCq86UT4MDrFRX
 X4VuQiC8Qhgn0LNCRtV1wDbGCu+Fb+1qgBpjGuji5zNjPuTYHQRlF/UqOBnHv8w1BtRe
 b7bY6lxBNLfL8CH709uEdsdhQ1fIKM2k999Usm7URFocyda0uH0jGiDb6ShXtkuLF2p9
 DMDg==
X-Gm-Message-State: AOAM532/gB0+W77OFape8otlOzsUvUnD0Bkodc4d64XZFNJtVMp8+DNg
 EA7qYD2WKTHM5tAsQ6ixYfum3oc7kWmp
X-Google-Smtp-Source: ABdhPJzf0JCsw7wdZ8d5r0A8d1ZjwtpbuoUxsZk5ewrDKwzveAk79a48gDNabIdMRY+bMtBINrfyzwNPw8xq
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:816:b0:50d:6b3d:c86f with SMTP id
 m22-20020a056a00081600b0050d6b3dc86fmr13482457pfk.76.1651534753259; Mon, 02
 May 2022 16:39:13 -0700 (PDT)
Date: Mon,  2 May 2022 23:38:53 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-10-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 9/9] selftests: KVM: aarch64: Add the bitmap firmware
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
