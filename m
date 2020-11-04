Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E058C4742C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 167832075E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="K5lok9pX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 167832075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F614B6E6;
	Wed,  4 Nov 2020 13:37:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fJuhvGomviuf; Wed,  4 Nov 2020 13:37:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7EDC4B7DE;
	Wed,  4 Nov 2020 13:37:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 881014B7F0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q4UFN3fBy2gY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:25 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9280B4B7CB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:24 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id 23so2449368wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=D2iY/f0Emp/4ip0BhAwKDaO2Rz6fYg/GzmDoqFEl2bY=;
 b=K5lok9pXB0Y/9UmYflOIZMDSkGGd3u23Q2HOsAtpB2GQgdWbczb37MrT+zOkXv17wT
 XLC9vOedqgdzZukxYXUCfWK/KmpoLoHZtcqTjOfbzpJCWVRhTNn0OILGLegfnc3HNByb
 EiNdcjUUM9WM0ul/8L3ypEWnLJH522G2M/Whv3nq2waX0fzH+tavrd5hfyBwCWZ47rIH
 M/e50E9Agk8EUpEMjPxiQU7m7K6l6KIaF84T3dfGn48L0baNZQrBvimX4U882V+fCi24
 OWGZhINKWlBuvULKaAafjWdNi+d8GRiezt45uezGFm5E9OxwAXUa2w/uxQNhsQbs+D1U
 3Czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=D2iY/f0Emp/4ip0BhAwKDaO2Rz6fYg/GzmDoqFEl2bY=;
 b=S/IhZT/uALxHYMzOiFLa8YQZP+UsCqvrkdRgEmbvQwoClY6fGO+Jv2pdqksUo4PKlV
 NPRfeA3VulrMMXpOYh98bXRP9DPWy6BB00sUQQ+C+nnXWMlGjfol7nZJ/dU/H6GQrzKw
 O3jvJyxYLXImOQGCI9Gq5olt9f2WNJPt1iZXjYNPe4XBfgMU8laciVyBtbDQHpCEFeOr
 J3dr8cUqoKQpGLxt+cyJYDHZ8yAIqfEBRf5S+8Ae/Ob8nVWXcTH8s4I17IbFJ/6O3DUo
 Pc79Ih4uUlEJQ+Eq/mAbJNEGPpdKIqoTQU2risZ0UnhO9KGC/2oFOwehk7oatUW546XR
 hG/w==
X-Gm-Message-State: AOAM531PdDqqwQfSdW7p4v99Bi4kKNM29gom2HKLlj1B6yStGfQdX/zM
 MgkMaAfGlyajuJyL4juHRVpwca94Jnk2tr0M
X-Google-Smtp-Source: ABdhPJxUC4D2whchkuH0BO+rZJkzPCz7MjPZCo5o94FSQjlFtlPHCIT/1kpZb8MvemUgYYaqMdixvg==
X-Received: by 2002:a1c:b487:: with SMTP id d129mr6273792wmf.38.1604515043233; 
 Wed, 04 Nov 2020 10:37:23 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id d3sm1049184wrg.16.2020.11.04.10.37.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:22 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 21/26] kvm: arm64: Add function to enter host from KVM
 nVHE hyp code
Date: Wed,  4 Nov 2020 18:36:25 +0000
Message-Id: <20201104183630.27513-22-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
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

All nVHE hyp code is currently executed as handlers of host's HVCs. This
will change as nVHE starts intercepting host's PSCI CPU_ON SMCs. The
newly booted CPU will need to initialize EL2 state and then enter the
host. Add __host_enter function that branches into the existing
host state-restoring code after the trap handler would have returned.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ed27f06a31ba..ff04d7115eab 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -41,6 +41,7 @@ SYM_FUNC_START(__host_exit)
 	bl	handle_trap
 
 	/* Restore host regs x0-x17 */
+__host_enter_restore_full:
 	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
 	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
 	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
@@ -63,6 +64,14 @@ __host_enter_without_restoring:
 	sb
 SYM_FUNC_END(__host_exit)
 
+/*
+ * void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+ */
+SYM_FUNC_START(__host_enter)
+	mov	x29, x0
+	b	__host_enter_restore_full
+SYM_FUNC_END(__host_enter)
+
 /*
  * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
  */
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
