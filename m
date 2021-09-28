Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1830DC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9C1361209
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9C1361209
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2694B0DB;
	Tue, 28 Sep 2021 14:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id brKw6aKaykd3; Tue, 28 Sep 2021 14:48:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA944B0F4;
	Tue, 28 Sep 2021 14:48:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4804B0EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id otZxSEj8VgUI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:11 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDAE34B0DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:10 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 l11-20020a056902072b00b005a776eefb28so25651708ybt.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=WAqYgSZANBQPGrSP2/3EiNP0xOOtjEK+EoXAoDp+T4U=;
 b=FVBMJgpfmWUBj6QARIX+xdJjaaGUEQoe0zbBl69lT+k3AhTFlydw5VN6+1xN23pk2B
 mpStAxsUAY6FhRP29Lt3oKt0dKV9Y3xgQCLgO9ab9thvP0LBOLneJj7nb0WWS7nClmA2
 gjFN2Y2snAfAK2vmPr8evtrvk3DOjhqZPAsvBamXsQ7SGV54WR9PEJy5V+SP4+02Vlmm
 klOuVWVQnFFCF/RC6DuhomYxb9MB7LC21L7KM+5sKZ6VNkbgqHjkzap//uE2sZldvL5y
 /CZJJVjI+NhPmEYCyL6VbCgjzukC84SPGlGfRD8MqTOpIGNQIMw22pZur/+k2P04S5Y3
 4otA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WAqYgSZANBQPGrSP2/3EiNP0xOOtjEK+EoXAoDp+T4U=;
 b=3cG6Hhe/THnd/E0rwzEfEXR0PoQh2T7Tprakplatq5b5USKhJyfUrv083bqBn9MJaD
 71aAe9a1maK+KMb1V/IJk9xQcuAuNspl6taHoOR//EMnjQBpwAJHPt5Ph6iRhrklh9Yf
 8nc7/P33OBjIcZHWtq/FDUBt/TnQE2NWSFzWqDCc5WUlseuA+EPefEgp+Glyoai/MRXE
 9kaxExp+tGpbhmvvJUY2hZqK9ViKXbchFI01PEvcQhgJx77Mo8J/MSRvP+R2UPlVeZwz
 BMwC0pmqn/9tAlhJLd26W5VNoB7MZzd5sVEeB7TKuUUCpFcf8o/87aD3BDquZVl8CWA3
 kXiA==
X-Gm-Message-State: AOAM532qDjD8Qsy/gXzPWOmRcUL8J7Zz/8FwKiDcfKbtp+MqyroVrijZ
 QTGDUVAkuuP1KYetRRK8tByCOd8nXF8wyQ==
X-Google-Smtp-Source: ABdhPJxNlbd9xaIVWBlb06ZLVfi9me310h22AXk1NuCxq0eUX+iIm+qoIj+aT5WJbHCnDzueUzbGxNWaI4HRKg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:76c9:: with SMTP id
 r192mr7253464ybc.481.1632854890485; Tue, 28 Sep 2021 11:48:10 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:47:56 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..9be02bf7865e 100644
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
+	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
 	if (ret)
 		goto free;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..27ee674631b3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
 			rdreg->base)
 			return false;
+
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
+			kvm_phys_size(kvm))
+			return false;
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
