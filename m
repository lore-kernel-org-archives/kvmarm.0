Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CB1C2D0E2
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3FC92376F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nT1ODEGN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3FC92376F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43CC64B226;
	Tue, 22 Sep 2020 16:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5FGgryjROwO4; Tue, 22 Sep 2020 16:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071014B2F8;
	Tue, 22 Sep 2020 16:49:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E5C4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W29Z69kCusx7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:20 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B85C4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:19 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id k18so4725835wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=3kHjplFMRxcRQ7QJ8k8iF7bm3FiTydZh5jGCVZmHf+c=;
 b=nT1ODEGNx0aGczQakjhgc8PzyG2vj1szHXyuRNb6ebsGWxr4clvxUsmYNXN/XqNHHD
 5kRQN1xZ/+iHBIVOj22PxJt8FTjR5ZzZDwVA2jFoMAZ7t3DX2ewxPJATn3T3ushgecn8
 K0qK+NZAlqwPRs3XtsO0sl8rVXebdlNh+uQft/DMAqmaxoiLCrO1mT3/vG2cEMGxkY8Y
 3i3kwYoCjCsX/jkbrZ7OP9OBvrgR402Fv/hN2DKE02quuTq9c7z628XiGYC9lBkjawDx
 S7t4FQu4fHewd3qe+5IRnYL7KrtjrMvxrbcLo8elkqKwdz3zkm8skXGUJgRY8QMziN+l
 wYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=3kHjplFMRxcRQ7QJ8k8iF7bm3FiTydZh5jGCVZmHf+c=;
 b=nsx3F5GfH9TqLKM+bp9LH/jHu8HU+jM6k4h0X2bH7pthzZzV0QDPjgvgfU2/uitanB
 tcg8uDiRDZdN4Vk6jmN+kWv/db8m999fmk2enR13fv3529w3m5tMpkbOsW6ZlmW68f3O
 sqOAUhWXTpdoiRd0IYuHy6zA5vmhhvHKHpdq60r3mnZobIEniNjJiyfmEBgISr4sRCrS
 xDYFV88+aNXOsX34kdOxoPgAsEpq0Oom6aBKXiVVfn3MqX1kd1Bwb1RVjkenWalmOvfm
 fH6U8YzkL5VPYXZeaf+UqY6XOBBhXDckZQ/yqsWXf8cTBdQcoPjTbkMwyMZiTuR74gBD
 XTZg==
X-Gm-Message-State: AOAM532mmkfBEMA3vWR2t1vWUlmXYR1cG8i4JGCA12chCyhCLhST0UIF
 t6A9C2YdXq/XeGuGIym/0iAHppOfoDxMSOxT
X-Google-Smtp-Source: ABdhPJwzq0jqg1SzcNK3sGKx+Fh4ubVp4OV/CRlzx+rQnQQIvi7aVnvBq7whpEsUGD7nfXhj/zUbTQ==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr2791094wmc.47.1600807757941; 
 Tue, 22 Sep 2020 13:49:17 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id k8sm6538012wma.16.2020.09.22.13.49.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:17 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 03/10] kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
Date: Tue, 22 Sep 2020 21:49:03 +0100
Message-Id: <20200922204910.7265-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Minor cleanup that only creates __kvm_ex_table ELF section and
related symbols if CONFIG_KVM is enabled. Also useful as more
hyp-specific sections will be added.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index fbb13f38d0c5..d14166012e51 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -22,11 +22,15 @@ ENTRY(_text)
 jiffies = jiffies_64;
 
 
+#ifdef CONFIG_KVM
 #define HYPERVISOR_EXTABLE					\
 	. = ALIGN(SZ_8);					\
 	__start___kvm_ex_table = .;				\
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
+#else /* CONFIG_KVM */
+#define HYPERVISOR_EXTABLE
+#endif
 
 #define HYPERVISOR_TEXT					\
 	/*						\
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
