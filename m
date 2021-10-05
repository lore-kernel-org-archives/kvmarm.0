Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86549C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C9BA61507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C9BA61507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D52924B2B7;
	Mon,  4 Oct 2021 21:19:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EgbwFrMi1Q3U; Mon,  4 Oct 2021 21:19:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE83D4B2D0;
	Mon,  4 Oct 2021 21:19:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA01C4B2B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hZbASJSffuNc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:28 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE38F4B2A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:27 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 w5-20020a654105000000b002692534afceso11566297pgp.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=s3xltIzsYJNvc5KBWR9SiqSnE8fIX4FxYbfqcY5QUX0=;
 b=I6/r3MzMU5CFY876x0aTrbmKMG/j/+Or+zP8y0iMwj6fg+wx7+vRtBMR4dw1KGMecs
 z35IocNtSKNOsk1oS3cmsjDvUWYcg8e8onvzb8nA4LX9HNLuWBjwAV/q8EVjYsNvnR5l
 YTUrHF0r07TOWN3T0iobAIGMCA/PN8RUXhLRxQW3XczLErvUxgawV/tKuze1yAqIWR1k
 PXSc7igTVU/Eu4bs3AOMjO4OcR3ErJCzTt25DFyvNqAYPul/PkqZKuqPuqwGZWEBobux
 8gCdhhbVjl6+YzQzHKntOkni8Msvq2vYwItGq6ks6IOeRvhyo2MH6sZWqtuR4/eyuG+2
 pOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=s3xltIzsYJNvc5KBWR9SiqSnE8fIX4FxYbfqcY5QUX0=;
 b=HMr3DAq5JtUbelWtSoQge+Ra63Rpggn1Hiv9mvhI85aObM3ef8KPXE86MZ0FufoJ4b
 DoQnxFwQqzHj/MLy6JzdIZCkt//vJkGqMWt9QEsWVDqYVXQOqgyVfA25wOFGjcLEL6BY
 spMeHb2qNf8AOeI9gyCP8DOQRyWTu2iEHf3uQ2+AFFpH9UJ4UEU/fg67zZJtD3vIM994
 EUZM13GYGCnp+xTfPiU3+HizI/Y42iPL1X1TbgFgu9fsI+Dx/gUCdpDRNRQ4jN7Ubq6l
 Ex10LdUW51qAap4CHo8xyMkPoV8ANv+eCflruZYT2iqrsAQ6UpS+xf79bwIQ2aD+tGLm
 L/Jg==
X-Gm-Message-State: AOAM533KyxS5ZONGTUjIX0LZJa1WlVdrOMWqMGsrzL6IV4e8yER+BCD/
 yMB96zdZXmdG2rAuKTi1Abvla4lwDcCp2g==
X-Google-Smtp-Source: ABdhPJx0XFoNulJXBdAqxqOjZ6ph+wHgisGlOL9U1ysYd2LTNOvevol0FO9yBpx4Sppw6M5H7GCXXsB2v0HUHQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bd45:b0:13d:b4d1:eb39 with SMTP
 id b5-20020a170902bd4500b0013db4d1eb39mr2550140plx.53.1633396766782; Mon, 04
 Oct 2021 18:19:26 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:12 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 02/11] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
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

Verify that the redistributor regions do not extend beyond the
VM-specified IPA range (phys_size). This can happen when using
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with:

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_v3_alloc_redist_region() which is called
when setting the regions, and into vgic_v3_check_base() which is called
when attempting the first vcpu-run. The vcpu-run check does not apply to
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
before the first vcpu-run. Note that using the REDIST_REGIONS API
results in a different check, which already exists, at first vcpu run:
that the number of redist regions is enough for all vcpus.

Finally, this patch also enables some extra tests in
vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
redist api: like checking that the REDIST region can fit all the already
created vcpus.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..a9642fc71fdf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
 	struct list_head *rd_regions = &d->rd_regions;
-	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
+			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
 	/* cross the end of memory ? */
@@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 
 	rdreg->base = VGIC_ADDR_UNDEF;
 
-	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
+	ret = vgic_check_iorange(kvm, rdreg->base, base, SZ_64K, size);
 	if (ret)
 		goto free;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..960f51a8691f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -483,8 +483,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		return false;
 
 	list_for_each_entry(rdreg, &d->rd_regions, list) {
-		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
-			rdreg->base)
+		size_t sz = vgic_v3_rd_region_size(kvm, rdreg);
+
+		if (vgic_check_iorange(kvm, VGIC_ADDR_UNDEF,
+				       rdreg->base, SZ_64K, sz))
 			return false;
 	}
 
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
