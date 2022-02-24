Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7720C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF834BD9D;
	Thu, 24 Feb 2022 12:26:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZtHVwnqSiEhj; Thu, 24 Feb 2022 12:26:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B32F4BE1B;
	Thu, 24 Feb 2022 12:26:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58CE74BD8D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vq0nw05tpRWt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:38 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5CD4BD68
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:38 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 t18-20020a63dd12000000b00342725203b5so1399969pgg.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qK1DQfY/agZG+Ude+bPzbHAaaA6lFwTTxSo+9IjwCXY=;
 b=TPsbqKhxmc0T+PxetBwAhdG6CCG7ROWrKmUGN3BsssTeSIgoXUOQnngTK58e76sGaV
 3u/siqCCo3eM5DO0OYSsT4wYCrRT+O8kY+a4+AnYqBHGb0Rj5B7cI0Hp7dOYnMvbxAD8
 RoAw7AYWgYK31cWIx7Yp8Ht4bfU+zuvlAoRR0OqLqR3iivh7tqnsNUSy8KpcavPHrnPn
 cHFxdJp1nmX7PTiWQDXtuL0nBeCqePhweoxs03ebVOn+oECM3dk8KZwiP6X63bDShGe/
 UcGW8KmUCjDJRi9tzyMH1ow70Y2j+cGCEuvyTbgcVe9mx5/NjKgrxZVEBbSazCAcGvGj
 1GHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qK1DQfY/agZG+Ude+bPzbHAaaA6lFwTTxSo+9IjwCXY=;
 b=4PcmcEOSKEGmYtfHvPwDyewTRmSz3OO0Oem0/+tfnr7bTg5+cwM8CggpAslsc/oEoB
 tVpVE92ggd1a34YNbjmYeHVc/CuDhyT9wHC72ntP5ghmhd/FNAyLGcS3yXzoyfYLuRd+
 ez9XSNhJ22sTQ12jY9fvRoqA8QS0HbSK0J/jYdY7cXaL7lZKoHvgCyyVDNOEpeqMSqQ4
 U3+UoPuTDH/TM4yRal9kSSCT2vZOmI1cA2cywojtGzFGsy5T0ukOIW6WvurY7CRcjPp+
 U0NlqoKmHu0d2h4KTrH3TJz3koSj8nB5MgSmXVczjtYqZQXi3cwt1rFqdKI1BHN4AKzv
 5InA==
X-Gm-Message-State: AOAM533f280aoZtLduyoDjJ0p3Kg4s5AghV7FP6eQT5h6uwbjHhwcooA
 xuWwt77Rrj3KdKdAGNh1nLti9NBB7+9U
X-Google-Smtp-Source: ABdhPJwU+prJ7BpJEtXxJA5crkhbYqb6Kqs4m4pINVmy8BqVqC8ntCResa6F6puuaRPR78ifpJ3Lzgoe5HTq
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:248c:b0:4ce:1932:80dd with SMTP
 id c12-20020a056a00248c00b004ce193280ddmr3851504pfv.48.1645723597604; Thu, 24
 Feb 2022 09:26:37 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:59 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-14-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 13/13] selftests: KVM: aarch64: Add the bitmap firmware
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

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index f769fc6cd927..42e613a7bb6a 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -686,6 +686,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
