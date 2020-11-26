Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3F1C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4AFD221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="RIxckPoe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4AFD221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618804BEC4;
	Thu, 26 Nov 2020 10:54:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bcE9BjBm+cqL; Thu, 26 Nov 2020 10:54:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 668D74BF8B;
	Thu, 26 Nov 2020 10:54:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B31B4B914
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZdS72RDHs60Z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:33 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BF434BEC6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:32 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id x22so2551274wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=GRbbAoAyT+twJ6DWAMnVPh0yMfbGrEWPbKn8Cs93LQs=;
 b=RIxckPoe2SCexeONFtE4DSkvr9AstiWpnehcv0VL5bhqQYEg6F/oOLEITVaQ1YoEfP
 hGk3BAB/mFs/TVGkOysWFzWL2o2OJ63MAD9vHn6ziIvpoT6iU7Kp+f3yRtPmRLGrK3uL
 0deZiq22+yVHN3uu+0OcZirO1XVk48C0r0exGjyDri75/b+No5iT5S4xp4Jb/F2siD20
 9mbZCjgyOtXgQaVY+Md/r07NG7gzIABxytKiAfgC6hHFqf47OWj1AJA/CygIdN1Nz3RG
 QjClGrsnaR32TvHvOZhfrzbfM8Kl2yeEXRKWMhh3KYMG0WT+diIy8djka0sD24s2czFl
 LSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=GRbbAoAyT+twJ6DWAMnVPh0yMfbGrEWPbKn8Cs93LQs=;
 b=koRpqhr4VAXU6cCCE51hU/TTfBmS+jgudpGmOMEURFksbsI1WHSsrjKGNY0lSBlVMI
 R6kxfsMqDeOtMC3tXtQdUBRqVisxqeZ3+EKuJvbN398MPE+91innU/eIgrj6Njie9AxO
 N7FbBDf/oDJxbMFcwsky+RppRND1vMbD0I1Tl2Xm2lX+XnVoUTIyD+yhGI1FmsCzfyIJ
 11ZfCORNofirxCR066mjZ3VsHVTQihJ1bJHgW8qfeKuHWJvuvI8grqr9uglZfROdf0E8
 QjuaYe+8peK0ZoRFC9PSJcQ8SrSXCtb09vE8wLSPPgjmh+SqmKzTYKYysZsmZXnJbMUu
 jzJg==
X-Gm-Message-State: AOAM530AQwsInXQloHviuj3BuoKX1NGKp8x7+E8mTTr53DBvDtnBv39e
 VBydcq4KncD2ztwXU+UQU660gvh9iUnLZimC
X-Google-Smtp-Source: ABdhPJwT9SLDB2L8OAgTeM8M2ZPVm2Y3TUfSJCQdJPrpoyLr/4gGDkZXGYwQZBc52TdBQc78XLbyjQ==
X-Received: by 2002:a1c:31c6:: with SMTP id x189mr4071224wmx.50.1606406070792; 
 Thu, 26 Nov 2020 07:54:30 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id q1sm9612864wrj.8.2020.11.26.07.54.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:29 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 02/23] psci: Accessor for configured PSCI function IDs
Date: Thu, 26 Nov 2020 15:54:00 +0000
Message-Id: <20201126155421.14901-3-dbrazdil@google.com>
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

Function IDs used by PSCI are configurable for v0.1 via DT/APCI. If the
host is using PSCI v0.1, KVM's host PSCI proxy needs to use the same IDs.
Expose the array holding the information with a read-only accessor.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 16 ++++++++--------
 include/linux/psci.h         | 10 ++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 213c68418a65..40609564595e 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -58,16 +58,16 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
 
-enum psci_function {
-	PSCI_FN_CPU_SUSPEND,
-	PSCI_FN_CPU_ON,
-	PSCI_FN_CPU_OFF,
-	PSCI_FN_MIGRATE,
-	PSCI_FN_MAX,
-};
-
 static u32 psci_function_id[PSCI_FN_MAX];
 
+u32 psci_get_function_id(enum psci_function fn)
+{
+	if (WARN_ON_ONCE(fn < 0 || fn >= PSCI_FN_MAX))
+		return 0;
+
+	return psci_function_id[fn];
+}
+
 #define PSCI_0_2_POWER_STATE_MASK		\
 				(PSCI_0_2_POWER_STATE_ID_MASK | \
 				PSCI_0_2_POWER_STATE_TYPE_MASK | \
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 2a1bfb890e58..5b49a5c82d6f 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -21,6 +21,16 @@ bool psci_power_state_is_valid(u32 state);
 int psci_set_osi_mode(bool enable);
 bool psci_has_osi_support(void);
 
+enum psci_function {
+	PSCI_FN_CPU_SUSPEND,
+	PSCI_FN_CPU_ON,
+	PSCI_FN_CPU_OFF,
+	PSCI_FN_MIGRATE,
+	PSCI_FN_MAX,
+};
+
+u32 psci_get_function_id(enum psci_function fn);
+
 struct psci_operations {
 	u32 (*get_version)(void);
 	int (*cpu_suspend)(u32 state, unsigned long entry_point);
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
