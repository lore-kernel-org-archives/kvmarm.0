Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423A3C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D077821D7E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mX8bYR+x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D077821D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855164BCEF;
	Thu, 26 Nov 2020 10:55:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XqLWPOYbodVG; Thu, 26 Nov 2020 10:55:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AF24C0C0;
	Thu, 26 Nov 2020 10:55:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCDEA4BC69
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKW2UFBTunOP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:06 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B67294BA29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:06 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id p8so2640894wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=yTPqxuNIHyHcxIGVDRFuzMb//a26J9RNoM2ThcyKbSM=;
 b=mX8bYR+xBsOyOIWEN8DX7gK/3reSGxDblgkVy4BFuCXdMl/4FvAYp/nmuGo1JoWP9P
 t6aYDDfb/OykyYNtU+YjrQpGHnafiTiCP67R+SMGTyaiF8vjgYt0Fvys9qkoErbLGFR9
 we1WLjGlgUNDIDPEBeUD4Alzz5Om/fnxds/Oxp5CzjqLXbiXrL9tA5FQ1fQEZMm617TK
 IdSpNFJ2H05e+uXFDCHwheCyX3oSyvQ7+b/+18Q/kDteenUlTRRV+WrhBV712PuxD+Kx
 wmzbfiP7gvyDFfsWCOAGPdMnOJDwhL/l00+ToHh9zpX87qwlANYNEterelAS3s8rUwBU
 5CJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yTPqxuNIHyHcxIGVDRFuzMb//a26J9RNoM2ThcyKbSM=;
 b=ZzD8fiJW9iIC4/LFUqPW/PPfv9CVHYRNnCUuh/YrEk/trWbUXQUIS5PVuImcV/bFIg
 UImo2uehTxf6i8HKqB4zPV1ckJI0mEHTmhRgxhhWkYChtJ0EbH6zxhSzSNaCFpdHBJeu
 /6YY6UPOIO8oZIj0He/813yr9PrI1ntuUubcarvRc9IhZ6ldHvyTZQVP3T0me6qXMGrs
 BvrG3NXkfP4N/4Hi7OSmxiJd5TLwJyMwnkj07Sagu6PunmwuaXsFcZSSkh7JSmdE3VYa
 GRZD5tiSOI/2Ffd7slRGRcai3ibMF30OQgjUyaaOnyrZC4XIZdeib9ufbvXLtCH1duh/
 cAwA==
X-Gm-Message-State: AOAM531O8QJJm34yH13twuZp+srPT9Fa+rYK4psjp7dl4JfMXkv7z94d
 +OjTkH2bcrTujotZdHApoqJpRJnSacfc+73n
X-Google-Smtp-Source: ABdhPJwX4rEG3aPSmYGdOs6RN45Cetge/Lz5Y7cdyVn5fxjNFMXKsImO/VR5cgpiiWFbabfK0CSr1g==
X-Received: by 2002:adf:f888:: with SMTP id u8mr4544222wrp.381.1606406105448; 
 Thu, 26 Nov 2020 07:55:05 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id s25sm8628255wmh.16.2020.11.26.07.55.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:04 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 18/23] kvm: arm64: Add function to enter host from KVM nVHE
 hyp code
Date: Thu, 26 Nov 2020 15:54:16 +0000
Message-Id: <20201126155421.14901-19-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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
