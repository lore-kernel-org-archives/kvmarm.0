Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BC9C433FE
	for <kvmarm@archiver.kernel.org>; Sun,  5 Dec 2021 19:10:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4F149E5F;
	Sun,  5 Dec 2021 14:10:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xm2BRkLO8A4M; Sun,  5 Dec 2021 14:10:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2281149FE6;
	Sun,  5 Dec 2021 14:10:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A384048B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 16:35:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aDPI8RUDvdp5 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Dec 2021 16:35:26 -0500 (EST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA2D440413
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 16:35:25 -0500 (EST)
Received: by mail-lf1-f51.google.com with SMTP id bu18so15533974lfb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 04 Dec 2021 13:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=msUpArhRy8wdm0cKy+shcB9fiwW0FQ4TneJPMUYT/ss=;
 b=YqvFBc4mcIl6uAotVZR2uxM+tlsrr1RraJjIa6qupLo2aXuHdYxbW9tfV7bbuqcn8m
 RnvgN15bRivsuVpZqu/Wm7HBrvV9AJs4+b7iEh1XNQCh2aIxKcP3S7YRo3ixof+u+iK5
 mZYk5jJZpl3MP2RWvc11I8UtShJ/oB6tPpHEstv13FC4dMACTCfhcAXsTFDV77kHV5k2
 Mgt3ss4f/BQ/E2IdCQo83Aordps/YM6fAMWiVoCYXYW2eWYzgJOR5EwZxlitcdY3s1e7
 msrVl9LyEsHAs6jzt9hoxEV827K72b0p+p991rXS3zVeygOlNq/nfSNgl3nvgRBAcxHl
 BlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=msUpArhRy8wdm0cKy+shcB9fiwW0FQ4TneJPMUYT/ss=;
 b=61Zi8mVVVauOLTrL5UNLBa6Cv+t0eYPHxAnaYBfm5ytJMCU8CFZuwVDhRui2O49eY2
 dQbXsKOgse4xhgNxBtpDstTuauq0BTAeFSINsIvQpbm5XLKDXEVa6EA7c1pbQbavCaP5
 l0Up3aHzNrkaHCnChMm8HexCeMasc4TveVIkbm4y5E4l/EkzmLM3Q2qs6EwrnG89NU26
 XYAvvgExhE+j1tjWW1SmZc8//vFnKL/ZKFtWOu6iSILPFV82oWubkY6Q2E1i+2GItm6+
 oD6C4E+B5ucMohsjrCYphY+EojfYwba1TzltThXq3F17AsHRhi1fcHvvucb03AdKcgQ1
 /Ciw==
X-Gm-Message-State: AOAM533GzLTkecFGjYLMN4f/zLlJawDhBxtBiVcUxwC2YoftXfRFB0vh
 X/ScDEpYkIP2MtuGABzKGis=
X-Google-Smtp-Source: ABdhPJy1foNQC1fgBE39jI5YX063JtAdtVHP0Vv+8WDaFnUy2KJ/0i1ix7+RrnYn6SjeA/Tb6hx43Q==
X-Received: by 2002:a19:e046:: with SMTP id g6mr25638279lfj.176.1638653724763; 
 Sat, 04 Dec 2021 13:35:24 -0800 (PST)
Received: from localhost.localdomain (h-155-4-221-129.NA.cust.bahnhof.se.
 [155.4.221.129])
 by smtp.gmail.com with ESMTPSA id q24sm873218lfp.103.2021.12.04.13.35.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 04 Dec 2021 13:35:24 -0800 (PST)
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] KVM: arm64: Constify kvm_io_gic_ops
Date: Sat,  4 Dec 2021 22:35:18 +0100
Message-Id: <20211204213518.83642-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sun, 05 Dec 2021 14:10:55 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Rikard Falkeborn <rikard.falkeborn@gmail.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The only usage of kvm_io_gic_ops is to make a comparison with its
address and to pass its address to kvm_iodevice_init() which takes a
pointer to const kvm_io_device_ops as input. Make it const to allow the
compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ec..7068da080799 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1050,7 +1050,7 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	return 0;
 }
 
-struct kvm_io_device_ops kvm_io_gic_ops = {
+const struct kvm_io_device_ops kvm_io_gic_ops = {
 	.read = dispatch_mmio_read,
 	.write = dispatch_mmio_write,
 };
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index fefcca2b14dc..3fa696f198a3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -34,7 +34,7 @@ struct vgic_register_region {
 	};
 };
 
-extern struct kvm_io_device_ops kvm_io_gic_ops;
+extern const struct kvm_io_device_ops kvm_io_gic_ops;
 
 #define VGIC_ACCESS_8bit	1
 #define VGIC_ACCESS_32bit	2
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
