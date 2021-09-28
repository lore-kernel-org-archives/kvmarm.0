Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6766FC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06EE561209
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 06EE561209
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B38D4B0F5;
	Tue, 28 Sep 2021 14:48:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z1b-w39whPlW; Tue, 28 Sep 2021 14:48:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0855B4B10A;
	Tue, 28 Sep 2021 14:48:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BA04B0F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5kYjugTdwMSp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:12 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49C114B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:12 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 n19-20020ac81e13000000b0029f679691eeso101742469qtl.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SRAJJGG3Meq60fJArI5V58NqIezmfGYq9oG//j0UJy4=;
 b=gz2f1clVsINkVP6NIRdH73tTk/+NC1lndVFY8Ks8c/mZOEVqy7lrdZZMeNIZHOfqsR
 QcU3QjumkuT98r6uzQTnO1MpoK+AMep01FJUZ2WhP0Z7b+n/9k6BglSNBHT3yNJxmQyV
 V57QtyAImWfetwVF8+qmYsLpRQzTbqrPVIKHNbcHpvup/TAHuBFRlhMHiHgZ8T+kVapS
 0P78ZcNTCt0nnTTcCRoD8dINcAfsRc+g7GtnNO5bwNDA9FqQw2KPsfnt47PfGhtKffrE
 wKHw0dOq7DzE1vRFmDPZX66JAxHzIgv1XdPoPiRqNhTQX+uaFCRneTxei85Dypb1QGVm
 AuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SRAJJGG3Meq60fJArI5V58NqIezmfGYq9oG//j0UJy4=;
 b=FNJZB5Cbstm7O6zzX7iMXWybgDVao55gXGTbjHI2PtQTsh6bXv7IAFFX5Idsv0iqIo
 FtvXNtxz4IgAaeAT62UJPtxGwZvShBQKPBiqkmyZlI6XePGprlqHitoa+FtneGR9zARl
 CVA+lxHlVJiyr3kEIpov94JOXnvT1/lwfVFt2MbaM+DhKlunPm4abH+mgaCoZbffx5Vx
 JjUMiZ/w1YYrdFqRSVBQO4IxcVDRDcFnC2rRiQkf/zI2Be4nxm8KH/hDAJ/ZjBSyYmd7
 jePfXTypnJz0EvtEDMUVHhItcvnQs8ullaWWxP3aUZfAGAD2Bj+Glu9MtSt+5huetVuv
 9bDw==
X-Gm-Message-State: AOAM531tPAC+ghrjpsKNt41MYGZxoJgzxuIoIq7rzQBjxx3MSg0GPINW
 94oPSmjbCGYL+ZJMHr8olnP8G9e6l32hqg==
X-Google-Smtp-Source: ABdhPJzP3Fh4vY9K3xp2ukBeuRRfH9cOkSP8HPXbiCcgsIo9+m8jiJA3CBwtrricg5KcU+UwN+TiqVzb93a/Uw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:732:: with SMTP id
 c18mr7310791qvz.9.1632854891937; Tue, 28 Sep 2021 11:48:11 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:47:57 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 03/10] KVM: arm64: vgic-v2: Check cpu interface region is
 not above the VM IPA size
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

Verify that the GICv2 CPU interface does not extend beyond the
VM-specified IPA range (phys_size).

  base + size > phys_size AND base < phys_size

Add the missing check into kvm_vgic_addr() which is called when setting
the region. This patch also enables some superfluous checks for the
distributor (vgic_check_ioaddr was enough as alignment == size for the
distributors).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f714aded67b2..b379eb81fddb 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -79,7 +79,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 {
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
-	phys_addr_t *addr_ptr, alignment;
+	phys_addr_t *addr_ptr, alignment, size;
 	u64 undef_value = VGIC_ADDR_UNDEF;
 
 	mutex_lock(&kvm->lock);
@@ -88,16 +88,19 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_4K;
+		size = KVM_VGIC_V2_DIST_SIZE;
 		break;
 	case KVM_VGIC_V2_ADDR_TYPE_CPU:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_cpu_base;
 		alignment = SZ_4K;
+		size = KVM_VGIC_V2_CPU_SIZE;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_64K;
+		size = KVM_VGIC_V3_DIST_SIZE;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_REDIST: {
 		struct vgic_redist_region *rdreg;
@@ -162,7 +165,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		goto out;
 
 	if (write) {
-		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
+		r = vgic_check_iorange(kvm, addr_ptr, *addr, alignment, size);
 		if (!r)
 			*addr_ptr = *addr;
 	} else {
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
