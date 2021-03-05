Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A282AC433E9
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E824650A4
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E824650A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FA364B22B;
	Fri,  5 Mar 2021 13:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oOzACmTm0AUx; Fri,  5 Mar 2021 13:58:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E97E4B437;
	Fri,  5 Mar 2021 13:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74654B64F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 05:34:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fhTNOW7EgaKH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 05:34:35 -0500 (EST)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D27E74B54E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 05:34:35 -0500 (EST)
Received: by mail-pl1-f173.google.com with SMTP id z5so1209431plg.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 02:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Agp6V5fskOmV3SgtzOBMqE1Yp83AGfJTjOCO5K//BWc=;
 b=G1gshWZRGz3kizh8dLaYQBWeT1Fu2/1RpD/S1UCrAFg2ezkz6nKcBNHKwaTTjNls0J
 yN4GwWqs9JIzUIwjZ/8/BKeuyVYnXTYoMYbZYKZqUMQGsMLs3G97PcSWbF365D7xm1gD
 /eRUpRC2wT3kYgk/LAEf5MCUSdVXov2QP4kXnVgGWLoBWk8Lq/xDsClEKzBgnhNcv7vZ
 GgjUVLWwF9S6/cInj6uYXPfPo0PhQvooVIP2AWzI5BoLQgy9Io9kaeTZru1nO6+F80eZ
 WrhhdmjDUzwi/2JODd/TRujsJnBfLbJS2ZNgHsZQEgsI5Jz8IYhhZ1v1nHKc/4ASJw5N
 DFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Agp6V5fskOmV3SgtzOBMqE1Yp83AGfJTjOCO5K//BWc=;
 b=PIXWnGsYRoVNgYpfMU5MgK5GkyN1IulAE3mlBvdGeyPPss5ofqYqnViBR2HpjYRDqW
 qRT34cJODlzy0mSWB2PeXsvtzn3YSgWHZ7QSxWncD4MLCrFA1/z8h27OMMiC1o6v+PMO
 g6iAstCCAFCDnTBvFWd4Ch5aCMA/lvgrKPZahnKMgMQOaj8MiqNgLo5SzXuxgY7z6his
 ZsQCYchtbqjVccqyAv801tJUW+/mr+J7fteJJyeMy5zzpf7OTllNB6VeelFLMPG5oIh6
 EttFjH9WFIj2WZgn4oIfA4fsV1QqU8LTaA/vzGjKOShsxyN8ousfDeKg58iMWy4ku3ZU
 jziQ==
X-Gm-Message-State: AOAM5302xrY5IT6/XyAN8ANIECa3iiQ+iHT9CSBNLUvgGU9yVL4pTPwf
 FloLEcY9a+zVg//DOXegWTI=
X-Google-Smtp-Source: ABdhPJyMqm349OV0JBDmKI2VTt+LSi2BJuMaO76qGV1TYetu0bWPuiEGfD3j7TCLjNy+gErVmDkb2Q==
X-Received: by 2002:a17:902:ecc3:b029:e5:d7cc:2a20 with SMTP id
 a3-20020a170902ecc3b02900e5d7cc2a20mr8217644plh.11.1614940474934; 
 Fri, 05 Mar 2021 02:34:34 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
 by smtp.gmail.com with ESMTPSA id h27sm2193761pfq.32.2021.03.05.02.34.32
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 05 Mar 2021 02:34:34 -0800 (PST)
From: Yejune Deng <yejune.deng@gmail.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Subject: [PATCH] KVM: arm64: Add big.LITTLE architecture support for vcpu
Date: Fri,  5 Mar 2021 18:34:25 +0800
Message-Id: <20210305103425.73380-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 05 Mar 2021 13:58:33 -0500
Cc: yejune.deng@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In big.LITTLE architecture,the application layer calls KVM_ARM_VCPU_INIT
several times.Sometimes the thread will run on the big core, sometimes
will run on the little core.The big core and the little core has always
different cpuid, but the init target is fixed. and that leads to
init->target != phys_target. So modify phys target from the current core
to all cpu online.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 arch/arm64/kvm/arm.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..f7fe09a5b23e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -983,20 +983,37 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
+static void check_kvm_target_cpu(void *ret)
+{
+	*(int *)ret = kvm_target_cpu();
+}
+
+static int kvm_cpu_online_target(int init_target)
+{
+	int cpu, ret = -1;
+
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
+		if (ret == init_target)
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
 	unsigned int i, ret;
-	int phys_target = kvm_target_cpu();
 
-	if (init->target != phys_target)
+	if (kvm_cpu_online_target(init->target))
 		return -EINVAL;
 
 	/*
 	 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
 	 * use the same target.
 	 */
-	if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
+	if (vcpu->arch.target != -1 && kvm_cpu_online_target(init->target))
 		return -EINVAL;
 
 	/* -ENOENT for unknown features, -EINVAL for invalid combinations. */
@@ -1018,7 +1035,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			set_bit(i, vcpu->arch.features);
 	}
 
-	vcpu->arch.target = phys_target;
+	vcpu->arch.target = init->target;
 
 	/* Now we know what it is, we can reset it. */
 	ret = kvm_reset_vcpu(vcpu);
@@ -1815,11 +1832,6 @@ static int init_hyp_mode(void)
 	return err;
 }
 
-static void check_kvm_target_cpu(void *ret)
-{
-	*(int *)ret = kvm_target_cpu();
-}
-
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 {
 	struct kvm_vcpu *vcpu;
-- 
2.29.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
