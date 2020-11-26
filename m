Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74814C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3684221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="q0DXHENI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3684221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2471A4C042;
	Thu, 26 Nov 2020 10:54:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLkH8eKSmV+h; Thu, 26 Nov 2020 10:54:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2199F4BCDF;
	Thu, 26 Nov 2020 10:54:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E38EF4B914
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jKiTeC9oWS8P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:30 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6B094B747
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:29 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id g14so2604027wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=9eBkN6lmfdOZ6y3T4AeVQ2xEMCxfbxxoIUc76Qx59Gw=;
 b=q0DXHENIOaqhJFnVso9J1kN3Eb61iVK8nd3AricHajirGlfnSXv+NmgwWHCMVIELoM
 /xkucGICwySq83LXla7dhpUSyhhrYAX2WyLB2M0GSO+2LUD2XI2l+m2AypGqvHH1oZWj
 ar44f6d4mUGekt4sM2d7YlccV/6w5dO+75q5vS8ABmkgJxt4nsK1E5YYxMSRXHZwtqRw
 CgRzDUSpetP2+yE0F4UC58Vh56PRAdl/j8zQgvJ3gdi0B97IexPJS8ZDk2Z0gcqlwvRq
 +6NN5jRL2/yL9KuYo3aGBfcKHp1j9xVMqkzoFKdL7JrD/vM8UlDrwr99kKCpPxKPalu6
 8LXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=9eBkN6lmfdOZ6y3T4AeVQ2xEMCxfbxxoIUc76Qx59Gw=;
 b=C4yUlBo6Tx5/G/EAmB9Q4BwLtZys9xnXgIQwyCQumZf2556lUaganNGrMRV1dCo8RG
 XifDi5gwU7N/5A5TUXXFzqM4rvzYymHrcCTCNc0IZfUpVaL+K3GrWAuk2mhaoMu5bY7T
 In7j76pZJnCVKYdxh/+T19Kg9NRjSGf9aNYTzVJuDLuQdaWIfgyI1k/c27DkpjhEAoD+
 +omfiyT/yHKuayphtpV90HSLeuKQglZV+H+bFVvoMNXQhJUnvyZleIDdwbl5d0kzt44U
 GxweSZ46xf13k6bnLMpbipqDuNlc0u1XSBlVLtc10XQba9gJpgrysChqmvO7gZ2xJRhv
 9xig==
X-Gm-Message-State: AOAM531FnRhCIJnOqxRoFxjFMmsNiTBW0gXmgUyMbjSTsNLB8QQZp9Ae
 DdPEsxJIoOm0QgdKPgByXklHS+w0bUwGO/Am
X-Google-Smtp-Source: ABdhPJw/lRW3PEMxi02nhLES66F/ltyrof/LoT+FjVRp6ybB+E4igrjSX8c/nxUUNknF9HL5GfidZA==
X-Received: by 2002:a5d:5482:: with SMTP id h2mr4667449wrv.18.1606406068612;
 Thu, 26 Nov 2020 07:54:28 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id v7sm2637615wma.26.2020.11.26.07.54.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:27 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/23] psci: Support psci_ops.get_version for v0.1
Date: Thu, 26 Nov 2020 15:53:59 +0000
Message-Id: <20201126155421.14901-2-dbrazdil@google.com>
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

KVM's host PSCI SMC filter needs to be aware of the PSCI version of the
system but currently it is impossible to distinguish between v0.1 and
PSCI disabled because both have get_version == NULL.

Populate get_version for v0.1 with a function that returns a constant.

psci_opt.get_version is currently unused so this has no effect on
existing functionality.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 drivers/firmware/psci/psci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 00af99b6f97c..213c68418a65 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -146,6 +146,11 @@ static int psci_to_linux_errno(int errno)
 	return -EINVAL;
 }
 
+static u32 psci_get_version_0_1(void)
+{
+	return PSCI_VERSION(0, 1);
+}
+
 static u32 psci_get_version(void)
 {
 	return invoke_psci_fn(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
@@ -514,6 +519,8 @@ static int __init psci_0_1_init(struct device_node *np)
 
 	pr_info("Using PSCI v0.1 Function IDs from DT\n");
 
+	psci_ops.get_version = psci_get_version_0_1;
+
 	if (!of_property_read_u32(np, "cpu_suspend", &id)) {
 		psci_function_id[PSCI_FN_CPU_SUSPEND] = id;
 		psci_ops.cpu_suspend = psci_cpu_suspend;
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
