Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08202C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D6C3206D5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D6C3206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 152F24B3FE;
	Wed,  2 Dec 2020 13:42:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TWaLTB9f2Rt7; Wed,  2 Dec 2020 13:42:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F8894B406;
	Wed,  2 Dec 2020 13:42:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 930244B3CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6CyMFgxlpn6W for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:14 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89C074B420
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:13 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id p8so5163410wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=yTPqxuNIHyHcxIGVDRFuzMb//a26J9RNoM2ThcyKbSM=;
 b=aCv+2fOzVacnmojuOT7cqdovfGr22fjEzJv+MRvW19pxd/At/2+SeBvsnBovv23E0a
 4ejG9x3wrILwl7LMVEeZNAy3Oz04NMiHm2Fj4hdnEr9LAkH0YCPP1X0lywRi3nVmOGD7
 nkwvoIwyzCN0kTWt4W3zAUBl+ihGtvBa9iAj7T1vlVaWad8lbsjZhFTC3rh2nTTEeoVN
 /Lvdr5l6vK5yD3B1B66RYBHWXz9OiYZYIBnuFg7gVGUh0Sw1Q8cGh4Im1B7YS4gfugr6
 oyO6bJiThSBLLb5BdbTjsa1DmmAbRvnlt4Ys1b6GgaoLrc+4THiITVFGUu94qhXAsFdT
 AhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yTPqxuNIHyHcxIGVDRFuzMb//a26J9RNoM2ThcyKbSM=;
 b=nEOjYbQAFNKbthw/C9FUkcAGwxQAiM5wuf9lNRpasrAf3xLfVYDw/qrAldvLmpXrX6
 4fvoFDok169FAvs8qAs8BBl3lxIR1J5/OgFk3kfYoSkH0Saq40i4WNndLT1kU6gJ3tcx
 mSqrFgYvHR0IhP/2N1DVb4rLtMkuKw6y+bg/oTDx75Hv1Z4o2YXjQ48LGD40dzGPyu5k
 pxd3eAcjKQgGvMODjc1MSAmxJdiWlHNrE1bOFvbAr6FZFydnfAgoDNXp+/Qw++TyMc3J
 +KxfYn1X+1T4KtXz29NqCkJ1XOk4XGdxE2fFC6TQlzYbt8hZHr1uov+T9Y4LqImtwWNL
 4qLQ==
X-Gm-Message-State: AOAM532wJvnmNCN0ZBcpIDj9qybCkTupPj6/4qtHYLwQierqa4bPJ8td
 4GvTZkt5bdKmiCV5Smr+Xaa4XhzF9Q3aZA==
X-Google-Smtp-Source: ABdhPJylrxzOOF0czEtZ7fv5Klvs9l0NUYOehr4kbC+Jl1sFVyJ7nzp854Drk3FK4NwPazSOzLk5iA==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr5035439wrt.402.1606934532259; 
 Wed, 02 Dec 2020 10:42:12 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id b200sm3008640wmb.10.2020.12.02.10.42.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:11 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 20/26] kvm: arm64: Add function to enter host from KVM nVHE
 hyp code
Date: Wed,  2 Dec 2020 18:41:16 +0000
Message-Id: <20201202184122.26046-21-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
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
index 2b56f0bdf874..a820dfdc9c25 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -39,6 +39,7 @@ SYM_FUNC_START(__host_exit)
 	bl	handle_trap
 
 	/* Restore host regs x0-x17 */
+__host_enter_restore_full:
 	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
 	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
 	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
@@ -61,6 +62,14 @@ __host_enter_without_restoring:
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
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
