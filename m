Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C08C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 00:49:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35F8B61186
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 00:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 35F8B61186
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7D794B1F4;
	Thu,  9 Sep 2021 20:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BHgc3pP8UKN0; Thu,  9 Sep 2021 20:49:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8189F4B200;
	Thu,  9 Sep 2021 20:49:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11C124B126
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 20:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8NgIROMboePp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 20:49:24 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2627C4B1A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 20:49:24 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso219822ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PnmYaOqrQjNWrJEqxLGOl8MYEOt5oEWk1M6ZydsFVAE=;
 b=TQM4yg1FQfOHBQ3ZAvGNocrqsOwJKAxncc4mbKyCgHs5sxi89dK2qKe5iyJqq1tvRR
 An/tkJry/YQJFz5NFvLeQWjiGWZV0FNQxX6QlpwEu0YEYlcLf/SL1VEosgZip9wKDt1o
 Qheb62L3ihr6th3Wp84yvD/P8BtLuGFAkktnoXOnaBiIIMQaGKUV/XNawWcPtC3IO1Zm
 0PKmKFlrBx8a1DpltbAaAi8pbfBr3joPqTjnBeN5wsA5zCOQ9NbF8ymQAuzxwkHJE4gc
 R4LfXayln5UN0nhCcF3OFkoL9yv7E/nF1z8EpdhuBipWE0CNvsIFi3c4iq0iRIHRk7ye
 J2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PnmYaOqrQjNWrJEqxLGOl8MYEOt5oEWk1M6ZydsFVAE=;
 b=kWLkkypAP28LJ4mVuUCC1Mvpvvk4N+T6n0ZCNIuNKQmDAlXhDlzGDVhhyS9qS5zKXT
 v/gjiU9CfuPUeUq+CEMVAnpdjweP9/WVVUxR6lM/WJfAtbUndnh4buUkfsNY6dPwFDWn
 G5fUr3j5EhUO8eyWiNBBqZxps7iblSiqSCTv4O4wzllo3tuHBAhzjwV/MthQYXjIeOcC
 Shgl4S3voARCBiS8gLeF4oZPSPZKwqvM094BKVIIbn0IT7AvWhFmyDubt0RbHO6tmGQj
 PJ+dISEp9k3GDNgE5rGapYSPi9t21zZj55kDNZHNH9kbP0gPvuGBpz3NWacrD4VyIgpT
 XTwQ==
X-Gm-Message-State: AOAM530J33mE5iOjX3kxqKALodrePIC7FsRIp3JqidZtu5tlDAHx+SgM
 qb4a+IOiWTALKEHXn6LkpfUTTaSVYM4wlg==
X-Google-Smtp-Source: ABdhPJwltqINxS2/XMXrxLmWX9yF6gQpclVmbDxaDjAl+YaM/CMRTWEuXw0zyveFYzixo9Vkn5FgkDdOFdD6Tg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:7409:: with SMTP id
 p9mr7587625ybc.462.1631234963645; Thu, 09 Sep 2021 17:49:23 -0700 (PDT)
Date: Thu,  9 Sep 2021 17:49:18 -0700
In-Reply-To: <20210910004919.1610709-1-ricarkol@google.com>
Message-Id: <20210910004919.1610709-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210910004919.1610709-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 1/2] KVM: arm64: vgic: check redist region is not above the
 VM IPA size
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
VM-specified IPA size (phys_size). This can happen when using
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with:

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_v3_alloc_redist_region() which is called
when setting the regions, and into vgic_v3_check_base() which is called
when attempting the first vcpu-run. The vcpu-run check does not apply to
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
before the first vcpu-run. Finally, this patch also enables some extra
tests in vgic_v3_alloc_redist_region() by calculating "size" early for
the legacy redist api.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..055671bede85 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
 	struct list_head *rd_regions = &d->rd_regions;
-	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE :
+			nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
 	/* cross the end of memory ? */
@@ -834,6 +836,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	if (vgic_v3_rdist_overlap(kvm, base, size))
 		return -EINVAL;
 
+	if (base + size > kvm_phys_size(kvm))
+		return -E2BIG;
+
 	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
 	if (!rdreg)
 		return -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 66004f61cd83..5afd9f6f68f6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
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
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
