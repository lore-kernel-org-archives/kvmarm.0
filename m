Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D26CC4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DC15206A4
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="N2oJBCvh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DC15206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C13A4B78B;
	Mon,  9 Nov 2020 06:33:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ACxC6Sd38g3a; Mon,  9 Nov 2020 06:33:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DECAB4B759;
	Mon,  9 Nov 2020 06:33:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 339114B6CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8Hrtvl4BfR-0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:11 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F026A4B759
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:09 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id s13so7608708wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=JvpizBPB+yAcRM4Glrg0Xz/WI/kNrOgIVHNM6YK4qt4=;
 b=N2oJBCvh3937hgiPHLvZgGr+8MSRUE7jzDGHq0E50z6OYpJoviAI+Xy+tr2bS0Syvc
 +ZA+cH3vl48CQyezHZWrr0hsUW0+r2EZ6OeZLjXssBKk/pSDriWqjxTyqQ7ST3tmHyqF
 ojXap54Rd+mTWUbYv7iy/HnlawErOxKQDgXnpzxTo3VUBxFhv71nPdfHde+dLFrJVUZn
 hqQIXwZBBwj5kox6c0qfhMKvyfpmvktLIKzuR+LqAdiec/hRcTOb7Yr0X94B7NSUR7M6
 hPvmnLDkj0OL3qcnlSBtNY6UN5nzgTQIz10dNHEg26o/m74ZmfeC0qHwRX77LEdResiu
 Yccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=JvpizBPB+yAcRM4Glrg0Xz/WI/kNrOgIVHNM6YK4qt4=;
 b=mgxBBbk2M7SztxD2XZvgL/U1feLSVEAdqtG+5r3Dpt3DWiTMZmK2Q7QafUoiAPb2MN
 1okg1Tyzy91g76pPTMiGey+mQK8hO4DJQoh/sGffc/muboz1OfrEjeh8R2h2+VK4lzpI
 zsJkTELUmkhl0LJZKFE8eNSj3jQks5JKKprfB1SCTqW1M4U1QphRDNaYTXmlqs/BLygs
 VwoBfikNCcG+sPkA1x4slsZA3Bq4qjxrZPbEmhH5QesJ5GBH5wpntzCAdJsveWxc50wo
 +V50uRm22Yk9rTKcQ/35uvdPOgBgq03m/83LIovdpHPdECFK7bHSsOVw36+6uhxPu+/9
 VIjw==
X-Gm-Message-State: AOAM533vCxbZZ+uwndB3kNCMhM8UuCQkLXhuoxYAeB3XK7qUqmobflhZ
 UgOVJQFrV1/oDRtdozz2SghUkmGYVO63/RsD
X-Google-Smtp-Source: ABdhPJwNkMDI36maGIPoQF9cj4OihOCg6Qd2vk9HMNRujo30A1ZVB6rxqcsQTVcMVxkwuxyP6czVZw==
X-Received: by 2002:a1c:56c4:: with SMTP id k187mr13931516wmb.92.1604921588714; 
 Mon, 09 Nov 2020 03:33:08 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id r1sm655701wrt.6.2020.11.09.03.33.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:07 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 14/24] kvm: arm64: Add function to enter host from KVM nVHE
 hyp code
Date: Mon,  9 Nov 2020 11:32:23 +0000
Message-Id: <20201109113233.9012-15-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
