Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4082C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 513A1221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="DW6HRBvH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 513A1221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D164C0FF;
	Thu, 26 Nov 2020 10:55:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E3iNcWRMJPEm; Thu, 26 Nov 2020 10:55:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C31534C0BB;
	Thu, 26 Nov 2020 10:55:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609464C05A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6qzu628-B1Wz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:13 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 689D24C0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:13 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id 10so2566524wml.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=yy/LdNdSlEKXNA1O0CJPP3BR+TLcin0LNTWW2mqA/Ws=;
 b=DW6HRBvH1dMRy9410u25SEcLsIp2cGZuNo6NNar9dsMBlj7Q7JHURHQ2ZWwJ4jXPRq
 FACFV5c1R7NwwKB0Oib/MpTay9RuvI6yCYOXmhbV+Pr3HgDlXdyvlg4UItg4lhdUNGHa
 Ld69QoFi9l+cU2d7Jj3v+urROaKpzMnCR+uXap1CF7z5vcz37pqfkvZgvs19n+L89vHB
 EEJiRfonQQHkdGI2wagoH7mhFUxDpAHkdjQtb7l1WLX+s81JCnUu/JCu2sK0TldwqLJv
 vWKQT0qJDuODF6PdMxt4duYZuW8RI90XbH/vsvYAybJHI2J7TmqDikGk5/EKWk9vYwAn
 9ECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yy/LdNdSlEKXNA1O0CJPP3BR+TLcin0LNTWW2mqA/Ws=;
 b=Ykztz3nxjZJE21IVmiK0H+/hzhaouWeJoUpgswvJrCFt184t3z9wDoCN5cwepc7gf6
 01SvDsgXQCz8/8DmMkLCd/UptjNr7yBhU32IAn5YYh/TnmmklPUq11tPkwY7SJQq61uv
 TwHmsDt5RUUODTMMarGYLBJNXBf2sfpc/YNj1Y616TDiGqxsgq/pnRiuSeoLaVBBmys0
 SdfRD1L7EVFJWMXGfZSfqpcMEhwrb+95a0B3KRQ1okbnoCagVeQZtXusAw7AENe3Sx6Z
 TUhuAyqIPay5AraBrCf1VlKiXcWDzHN8oGWxZCZUaNFuAqJqB4mYXEIoqzwIQqf6bxX4
 9t0A==
X-Gm-Message-State: AOAM531FoZUTC9bHI9AEEONMc/Yzzla1Q3b4roslG3XZxAHQIK71sXWw
 G6vq2JQbrQ3IFwf1xXvy6v+A74AGV9gdQ8LR
X-Google-Smtp-Source: ABdhPJzVolDDwaIJ6HnyKtT7uOspSO1I6DuI7m5CXOsy4xcwwUFP5ghKEPUc3bw4ZpFlZEJaa1lvVQ==
X-Received: by 2002:a1c:61c2:: with SMTP id v185mr4165642wmb.152.1606406111903; 
 Thu, 26 Nov 2020 07:55:11 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id q25sm10978629wmq.37.2020.11.26.07.55.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:10 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 21/23] kvm: arm64: Keep nVHE EL2 vector installed
Date: Thu, 26 Nov 2020 15:54:19 +0000
Message-Id: <20201126155421.14901-22-dbrazdil@google.com>
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

KVM by default keeps the stub vector installed and installs the nVHE
vector only briefly for init and later on demand. Change this policy
to install the vector at init and then never uninstall it if the kernel
was given the protected KVM command line parameter.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7a17b5048454..6ec8ddf74643 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1478,7 +1478,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	_kvm_arch_hardware_disable(NULL);
+	if (!is_protected_kvm_enabled())
+		_kvm_arch_hardware_disable(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1521,11 +1522,13 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
 static void __init hyp_cpu_pm_init(void)
 {
-	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_protected_kvm_enabled())
+		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
 static void __init hyp_cpu_pm_exit(void)
 {
-	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_protected_kvm_enabled())
+		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
 }
 #else
 static inline void hyp_cpu_pm_init(void)
@@ -1617,7 +1620,8 @@ static int init_subsystems(void)
 	kvm_sys_reg_table_init();
 
 out:
-	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+	if (err || !is_protected_kvm_enabled())
+		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
