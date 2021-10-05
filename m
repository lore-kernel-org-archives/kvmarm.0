Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15E9C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D6496140B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D6496140B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E419F4B2B2;
	Mon,  4 Oct 2021 21:19:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iAAE5TKgTPUJ; Mon,  4 Oct 2021 21:19:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9164B2B3;
	Mon,  4 Oct 2021 21:19:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C0E4B277
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hpC3EgzynrNk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:29 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C34614B2C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:28 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 i16-20020a05620a249000b004558dcb5663so25412469qkn.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=modZ4Z9L3oEO9aqybHoesg/sa8IbbaN9vhBoj4nUzK0=;
 b=bgOdRvGy03wHhuqC9IIWVXjHgLq8ER1bPqdM1eoyXmXxE5CTK7haSaS4mfh/hFn9q4
 FxjgPFxCEJ1rzeLtbTrxE1cTleYeu++bEADbAMjp7zprbkOOnMc9ZvfaCcxQXojsV8y1
 I+aEzmFUySG1t/PpYK4H2Z99PTMG/HHRRUGzmOlIDY7oKn3c5FcGo14NVlAl/tx+kMuW
 1vR3br3ecMYhOd+n2ZAa+EatFnDPUicWKaUBq5eTJGWrRU7vs05BT2Vvi0zCSC5qv29K
 XyHXwpoBbsC8l8mLdjuqfQyju7XswglWVz/fUv08P/x+ouQka4yadX/J/xKLLWZ5MQe1
 RfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=modZ4Z9L3oEO9aqybHoesg/sa8IbbaN9vhBoj4nUzK0=;
 b=MDncEWoBsJDULh8n9sDnAvblVnipxOTk1FKL5CHLAKG6r2VF8EFDUmaEaYNaTgnA/j
 4PjBSkK5YVfisWoCN4KzP4orpNot9fEO9MV+O1D3GKETbCF8tknavuLVsAb1aQKkcriT
 ummTlTFwFNoLyzXqWULvto9vg7J3kdiEyV2zsHK+TMuJTihAYP4RiiLDC/3DNKVTta+1
 cnoXskV38BJhU9MwkuFz0OX7UvBC7Sv2yxbPbCxjCiqYfx5GUbR0nNAqgNZ8yZciX+/g
 pmmkROM3ibx4bMUSNGA+UDGxSH2+0IHpA6Bvezori8djR+BybaiZ0TGDkSt2eYPlVO5z
 D0Qw==
X-Gm-Message-State: AOAM531pVOmDtXCksNQhLVO1UTSI5Pi6udFugfHIX+gTYK3RxwdqchoH
 TAC5PQ4RyP1yInHuEMmnI6GDZ9P0hVMcHw==
X-Google-Smtp-Source: ABdhPJx9MR9eKbMFUs47zy96xYIn215NokaRZrbiaxTy5wQJPpw7gxng1q29efocogl6eAoijKwKJfRIvzZmlA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:476a:: with SMTP id
 d10mr2875568qvx.20.1633396768417; Mon, 04 Oct 2021 18:19:28 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:13 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 03/11] KVM: arm64: vgic-v2: Check cpu interface region is
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index cc0ad227b380..08ae34b1a986 100644
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
+		r = vgic_check_iorange(kvm, *addr_ptr, *addr, alignment, size);
 		if (!r)
 			*addr_ptr = *addr;
 	} else {
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
