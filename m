Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F0C55178
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34D452067C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Q5mK8uSR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34D452067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A154B7B3;
	Wed,  4 Nov 2020 13:36:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hlX0yj1NDSsi; Wed,  4 Nov 2020 13:36:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 369DA4B7B5;
	Wed,  4 Nov 2020 13:36:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FF94B606
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id twTwoBrMb1WE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:45 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA6A14B7A8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:45 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id s9so23139466wro.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=dretx+OcQnNEgjiOHgLf5xuX2mgx6Pn+lAvUlmv1Umw=;
 b=Q5mK8uSRD63nfgGRd0lH16O0TMipT4yLtqy2sQBbkl08CNUezovnETohG9rebszGq8
 0vdx8lJYS4mB9WRlz3W8/KzhCbjQ8OxW2FhSblN9uLFsDI/rbUQ9TTI97z7HhER3cXxs
 rHjtP/050BQ5K769dm085pH6Q/u7t7rMPpUVYc2OcIcJssNsO6XTa/wlRHRx9mZLv+IW
 Gahyfz5hGR7cT2wErqGNFxxxZEuHR04KSISkvpwR65eArEww7TerLaTFSSjHrDSUinvK
 oHAAy7K8iNU1EnePynpucNkY8ISIBbrT45JUUsnhQXdPmmoGe/ykyJmmKrz6zYHpmisf
 tptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=dretx+OcQnNEgjiOHgLf5xuX2mgx6Pn+lAvUlmv1Umw=;
 b=XbmZR1GVzsj4WVOsPsk3peO0hjmb4swccgNCtHT42ytfjmKcXscf+HOf2NbgyglueM
 SCY/im3Gb8cnKBfa0fj2DBhnJwwtn1oGNvbpXHlVgrEShRjw4hDxxsaa+fHsDNGd96q7
 G7iZ5KWYdOE4uh0M2dVCyh09DtT183VATqNIunZ/vEthos4xhLhOsy050569/lZIhqCI
 cdOkpj05cvYNL5y4cSZoK0OX8ugZwcPDfSR4zlAa2BfC0lbn1D53ROtYHtEmagDOZv87
 46sRhTzf9xLowj2c84E+MdIk+AC3xysO0EfiXynGdBmiLXjtyHPSkVYKDBitQLldYgiJ
 OeFA==
X-Gm-Message-State: AOAM5327U1Ox2SVY2kLq7LkMtna/UHY+sMj7JjrGGfBibR0kVldZORCr
 xH51WDkkl07gUHdfxqClb7dFag3Q2131nhKW
X-Google-Smtp-Source: ABdhPJzz9EDjWjSDrVKMul71N2NUVEw1fW+kiKrX84z0zmTkgi3rkWsvlxdP0L2e6xtC+jegDhXbQw==
X-Received: by 2002:a05:6000:118c:: with SMTP id
 g12mr34650447wrx.246.1604515004320; 
 Wed, 04 Nov 2020 10:36:44 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id l16sm3665022wrx.5.2020.11.04.10.36.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:43 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 03/26] psci: Export psci_cpu_suspend_feature
Date: Wed,  4 Nov 2020 18:36:07 +0000
Message-Id: <20201104183630.27513-4-dbrazdil@google.com>
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

KVM's PSCI proxy could probe the firmware to establish features
supported for CPU_SUSPEND, but since the kernel's PSCI driver already
does that, and other information about the driver is already exported,
export the value of psci_cpu_suspend_feature as well for convenience.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 2 +-
 include/linux/psci.h         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index ffcb88f60e21..b6ad237b1518 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -71,7 +71,7 @@ u32 psci_function_id[PSCI_FN_MAX];
 				(PSCI_1_0_EXT_POWER_STATE_ID_MASK | \
 				PSCI_1_0_EXT_POWER_STATE_TYPE_MASK)
 
-static u32 psci_cpu_suspend_feature;
+u32 psci_cpu_suspend_feature;
 static bool psci_system_reset2_supported;
 
 static inline bool psci_has_ext_power_state(void)
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 877d844ee6d9..a5832d91d493 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -29,6 +29,8 @@ bool psci_has_osi_support(void);
  */
 extern int psci_driver_version;
 
+extern u32 psci_cpu_suspend_feature;
+
 enum psci_function {
 	PSCI_FN_CPU_SUSPEND,
 	PSCI_FN_CPU_ON,
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
