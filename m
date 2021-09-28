Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5AFC43219
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F0A461359
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F0A461359
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E8F4B0CB;
	Tue, 28 Sep 2021 14:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BjNnzODu7mhN; Tue, 28 Sep 2021 14:48:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2EF4B0DD;
	Tue, 28 Sep 2021 14:48:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E6444B0CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mjbdngSHxL3J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:09 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FD214B0B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:09 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 s18-20020a05620a255200b00433885d4fa7so99429375qko.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=O4Pf1pw7IvGHNe4ix1iHuqBRwQM1rzQrtDbARj3VD7U=;
 b=mMMdCpyyOz9jvXo89g2rQ6b6Nh948to1i5C3FcPkKL21khzd0SJnqxQR4pkyDMx9wa
 s0O07AEGyGZovHoZMQWntxZ96N3sLH8ged8VBIMRL3FOXckb8dsewQN2qvTmew6Mg8p0
 Oolh9VInTIJlL5VZaT2EXghb9fy5iK+ewpnw//GSA/9/OPPM46+sSBbZ8QpqsfcCDI0L
 hnzvrBsCQu6n04TqU7WBQFmmglwGBFckLdXNTpAVz4Yjxd4GOGyU9lwF+ghdGzg0WUiz
 iB4cEZyX1mFt8GkSsJB84Cquma2SBzV8D+IDLTJmPek45HdWNKnpiemLZlZf80Badjv/
 6dBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=O4Pf1pw7IvGHNe4ix1iHuqBRwQM1rzQrtDbARj3VD7U=;
 b=bFuwX30pC/yEjISa/WYMjQqluvymL+v91Lj68MbhwCQ+/SZUmu7KAeCMtPWs38QhjC
 TEM4nR3IGh8kbunYezgjKsjiVCAt4a5xRa0mSt3fTp4uq/YW1pBlZNQLBviVXnbVZCmB
 O/5eajzV8c9K29Z573LPBsx0kmE0SU3FzOJgC9u4HZ4cE6KM1MtGaaAAx9kIV7PSmRla
 KPeE0nIJU4Y0NJ6SP37dRId4YF22h8uA2HCDlQdz4aO5sklYSecF0R4WlFvQHVcaZwj6
 jEFmtoQFFSq7KCos9Yl4WBplS2Zot59XU9Umqjyo+80YuT9LKzZpqQaHKlu2QkJneAyF
 3Tnw==
X-Gm-Message-State: AOAM533SLNlhT3aSrODmFkt7AfmBGw7jJA3s/Tqg6jJoy2IidcQkLI5p
 HYfcyenISL0C1LIGRtQefS6IdxEyLT2arA==
X-Google-Smtp-Source: ABdhPJx5jNcltOLTjTdhqpjP1Bl4mvZcRKZjKlWdl3zBsvmwrNHy7AtNptUT7fjtgYO1crNJzy1+li0z/78wjg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:4a02:: with SMTP id
 m2mr164765qvz.8.1632854888735; Tue, 28 Sep 2021 11:48:08 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:47:55 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add the new vgic_check_iorange helper that checks that an iorange is
sane: the start address and size have valid alignments, the range is
within the addressable PA range, start+size doesn't overflow, and the
start wasn't already defined.

No functional change.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..f714aded67b2 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size)
+{
+	int ret;
+
+	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(size, alignment))
+		return -EINVAL;
+
+	if (addr + size < addr)
+		return -EINVAL;
+
+	if (addr + size > kvm_phys_size(kvm))
+		return -E2BIG;
+
+	return 0;
+}
+
 static int vgic_check_type(struct kvm *kvm, int type_needed)
 {
 	if (kvm->arch.vgic.vgic_model != type_needed)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 14a9218641f5..c4df4dcef31f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size);
+
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
