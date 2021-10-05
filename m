Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8BEC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8B17615A3
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8B17615A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFE84B29C;
	Mon,  4 Oct 2021 21:19:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qhe3z6aQly+R; Mon,  4 Oct 2021 21:19:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7684B2B8;
	Mon,  4 Oct 2021 21:19:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDD84B277
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tS5hehFAkjog for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:26 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51CBB4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:26 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 t4-20020a62ea04000000b0044b333f5d1bso10063150pfh.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IV4bAX7aZbOWgsyTP/uC/+QKOTMTTiF20MdPsNzdqGo=;
 b=idVd0svEOjdLh2xDcyN/pE+oF0Uh0qm8kXmVQyvpwu/Zr1F+aV0G4HLahuFubXDPvK
 YBNJWaov5wPWZV0MG3S0i8lK2eA+uDo0Z2ljfSXfE4LsRsWPMp9QP1IVL4V59L1u7JaN
 8lTLknOPSU5MeCVpZgGTBAxPTaz0c2d3dwbp060SiOxUCciMPzLiJ+PaYI+eCG22h9oy
 O6mQz8u8Cak9qIhseNWK4w86SSvKUUyUMMljKEMj/m76CG4emOwaBopYu+90Gq5uKbqO
 dvl7PyDrL7le6ZQm99+j9PU3OrIVvx/PRo3wcTlGc7IYkD5fWhFYy1lBr8hpSR58C6Km
 TPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IV4bAX7aZbOWgsyTP/uC/+QKOTMTTiF20MdPsNzdqGo=;
 b=kBznO2rSvN/QBFJA30t/qiw08tjRvgENGJebIhrEpPImMsQWFcsTou33DXqIQkXl6E
 nNQhjzJLu7CUeRvA9HHXPFx7iqeSnsSxKui1lRvcoRBlVq14bAS4KG49eKdrNYH/kROs
 nipWQ7s9ys/DpRgC171VIaTwTDaPIt4YKynm7OIoky/MmCSzR7NAKPxsOyKNd3zBpaGK
 BSSrl9OojAkCcPtfIuVoSQKIrKUIOzTQce47EsgVf7RxZmHop0qpRF2OJ9CA1mPN3lDY
 erdb7OwyEZYzVSp6tjbjIpR0OGu3FN5c7BMQfFYxRPsmYEs/HrVQ1+Gd49lPVLbaINvo
 Y++g==
X-Gm-Message-State: AOAM531UZSJ/iOTSGPX6Gsn/Rxy20+ROZKUEa0w8zvrVuIYUonNaAH8w
 NFcW+NLxc1PJbjJgpZOq1vlRY0Son+MvXg==
X-Google-Smtp-Source: ABdhPJyB26ALWNynLvgWkZeYBngyxImps90TdSrxE5EA7kXmAsk/88jmmKB1FlcqJkxP0cDf2LNG5WFeQIoMDg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:7a8b:: with SMTP id
 q11mr369754pjf.35.1633396765327; Mon, 04 Oct 2021 18:19:25 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:11 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 01/11] kvm: arm64: vgic: Introduce vgic_check_iorange
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..cc0ad227b380 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size)
+{
+	int ret;
+
+	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
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
index 14a9218641f5..4be01c38e8f1 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size);
+
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
