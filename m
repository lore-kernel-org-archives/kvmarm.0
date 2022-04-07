Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67C5C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 01:16:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 936804B1B6;
	Wed,  6 Apr 2022 21:16:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bqvq5jSKPZ1m; Wed,  6 Apr 2022 21:16:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092994B1D4;
	Wed,  6 Apr 2022 21:16:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EFD149F4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIjRYNp4YDyy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 21:16:30 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C21254A534
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:28 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b16-20020a253410000000b00633b9e71eecso3088934yba.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=801d9Et6vVPhDQnC0iYG+wLGLuQ795kMLNdzkGD2gNg=;
 b=h5szE2fzWy8unckrJRjuzttjaMFlCcU+82BRrO8olCmurNzU8jZvoJFOn1xDWBrXmK
 NwnWbROflIEd0ETxmbJkDrnEIb2AcZmo6IHmvnH8nMi9WyvKNXBoPq+EoD1iZcw0xgLn
 0uO5C/9xBMWbMKuie7m6Y5TUyEZbXDSONoteBhLYRtbBJZYUQ05gVsAUB+Q+ESOK7KB4
 v7bpw+vehDTDo8JhEINYrVM4TwLupBEQYVM7VTc3IPOhevr+Sg+PbzNc62T0GylEh1om
 gaT29p/EN5kZc6LTyZf0WNTOT58HpPj/iK/nVyIzooYy2LW0J9jXMOGsGZmFP2JpGdSV
 WMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=801d9Et6vVPhDQnC0iYG+wLGLuQ795kMLNdzkGD2gNg=;
 b=CEvEipgNaVXRVi2V4E7YoG9pRryywtRjYj6HG+9vu5WqlyFEJzP0QRhpmLlVlKqzbK
 AnWPGbL3pvM9kQT5TpJqhr0fnMRfC2LN3K2S7nJgYbJwIqVjLEr1ACOVsfooaU99Laou
 Os9m2mtD3R5w2Sxfw3u97a1VkIeaz7NfDL8k/oMmpBrJ8fgBAwrQFO7feKbXUeFUd63r
 shqKlUSC7FBgOta1nD6JTVunCnKeHg3BNuhkORAB3aXUfBqoauWsRI1AEUbrRPCGBqzq
 4tYTKUull8LKgc7RR5oMbbsPYiir5ebw78N1OYEIdhItmO9QO16jboudte5S3qG8W9CC
 6APg==
X-Gm-Message-State: AOAM530GNDsYTSxK/hVz42c1+GpN/YyuFudqopH1HwalhuokhkLUkF5I
 Ou6FV73zV8pvep5cPIgK5I/w805x8D1h
X-Google-Smtp-Source: ABdhPJzjmMSJmWuJc1STPElHufTrLVqugzxrngDHZOmiyGe1kL+j1BHxiYF7RjNUv3CxhEBEV/1e3qncU928
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0d:d404:0:b0:2e6:be16:e0ae with SMTP id
 w4-20020a0dd404000000b002e6be16e0aemr9753775ywd.517.1649294188279; Wed, 06
 Apr 2022 18:16:28 -0700 (PDT)
Date: Thu,  7 Apr 2022 01:16:04 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-10-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 09/10] selftests: KVM: aarch64: Add the bitmap firmware
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
index f12147c43464..281c08b3fdd2 100644
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
@@ -686,6 +691,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
