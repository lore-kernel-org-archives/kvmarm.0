Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A01C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83F5B20731
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nXf0x2ZQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83F5B20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205DA4B888;
	Mon,  9 Nov 2020 06:33:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id umJRf6LPc2VD; Mon,  9 Nov 2020 06:33:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 115D04B75B;
	Mon,  9 Nov 2020 06:33:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB7D4B75B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bgI4IVqKIyu3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:26 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDA554B56B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:25 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id c17so8291118wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ng0v5HeSJQOeKhcFpXVkzmD2sfhDn/uEl/qiO47ffRU=;
 b=nXf0x2ZQSANVYisqiO9zumbyu9XHWzxdyz1ZSIY8GyuKuYfxct4fnI5pSbGiSTFOKJ
 mveF3t9cZcHU35ZFthj7l3KTs3ZcYkKdoe3VKEu83Sfd5kxl+FtXCFTOixquF4EcYCgw
 EH0rMfup2e0PVd7xLQh+emTzeQ/efWcJu+mp62Fe+olt7hUpIucBmUJATKQb/DAJa7b0
 XskNC0gzRIE8PphGvVPd2oXvFvUt/iF9drRDgP9i7TwTUi1unqdrwycwXbWED+9mzRWy
 kNVDQRYVy53qymYwRdxJpoF98BHEStzuuxGL2CLfGvP7cUiWsVkbQbbzm86kWZ9LMPPT
 4fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ng0v5HeSJQOeKhcFpXVkzmD2sfhDn/uEl/qiO47ffRU=;
 b=h8iswIUzUR0be+7LXA0dpUXkyY7EnrWHy8rM5O/xLZjJ+m9VJwq3+wzFIs0gSHfQiJ
 rbF44ZMFRwpj4mbS9Ar49cg/awviF9ogakVYan5ZG6O8t9ZqCdrGHrhtOLZ1wHQBaHTe
 2r3fcxh0oM4u8WDaYXGuRDLGwIgll2UtAs+w9z4wU0kh/gkLVBERGpEoJnUQQVVRdPIY
 QSyIriK3tyyAUqGH9GkqQeFkryMR+YGlzXWEMQ/sq/a6Mwm+NSxVBFagsTgYMOBLFi2A
 hldveQd29j94qaYlqqv8usMjKfCfhYPpOGigrols1Dz8pGEQ+kz1OCVIa0eghdw8XVfL
 M/Dw==
X-Gm-Message-State: AOAM532jk66nLaAktZhFw7i9C1dJQqnwdvR0HdMSrkjVvhBm8p9yocko
 +5nGh0zthe6Uu0lYCfup3YmlH0hIQTqGMvvf
X-Google-Smtp-Source: ABdhPJwGtO+bLBkGK5zcf5ADJI23gPkHLtLWoYJFJD2sI6sOe+pvFe7IA5c+39hGs9VXzBBrk6IBZQ==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr4853268wrs.331.1604921604594; 
 Mon, 09 Nov 2020 03:33:24 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id d3sm12903725wre.91.2020.11.09.03.33.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:23 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 22/24] kvm: arm64: Keep nVHE EL2 vector installed
Date: Mon,  9 Nov 2020 11:32:31 +0000
Message-Id: <20201109113233.9012-23-dbrazdil@google.com>
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

KVM by default keeps the stub vector installed and installs the nVHE
vector only briefly for init and later on demand. Change this policy
to install the vector at init and then never uninstall it if the kernel
was given the protected KVM command line parameter.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 452a01afaf33..574aa2d026e6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1431,7 +1431,8 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
-	_kvm_arch_hardware_disable(NULL);
+	if (!is_kvm_protected_mode())
+		_kvm_arch_hardware_disable(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1474,11 +1475,13 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
 static void __init hyp_cpu_pm_init(void)
 {
-	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_kvm_protected_mode())
+		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
 static void __init hyp_cpu_pm_exit(void)
 {
-	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+	if (!is_kvm_protected_mode())
+		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
 }
 #else
 static inline void hyp_cpu_pm_init(void)
@@ -1576,7 +1579,8 @@ static int init_subsystems(void)
 	kvm_coproc_table_init();
 
 out:
-	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+	if (err || !is_kvm_protected_mode())
+		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
