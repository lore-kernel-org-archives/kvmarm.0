Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2D9C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739EC4141A;
	Thu,  3 Nov 2022 21:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W3okhVofTSqN; Thu,  3 Nov 2022 21:11:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 380A44291D;
	Thu,  3 Nov 2022 21:11:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4E3413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiaGcg641Fza for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:15 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9487049EFA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:14 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3691846091fso33273127b3.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=rRZNXnAdmysY3G3Cnao0EYe4NJ/aofq02IxKvLoVlH8=;
 b=TAcPtBFW9pu2h04dOJP3ktSg/vWQP253G1X1Mp4rOUqMYppLxgwjzRSAU2BEPxrBuk
 D79mj3W8lxGP+YQF0QWhctr5CRqqVY/jWBFNL8M8Q2F0S5joY/Upr0pYFRzgCp5c0fCq
 6zS9kPogeqSemrBgnSVyGQ/LvDNYHqaqXUC6w/hFbcgo1GgqT6J/ItAKbEN0OV8T5AG6
 kD6Pijo34xCrWzCSI55GvKl7V03XxC4j8dDpqFXv8Doc81ApggRPbcolAirWEmENC1KF
 rwI5TdfslMbJDhiRERIa3DbqamzXk1McZwEGIi6poQKuJXyL46MtWR88xgYeEhD6ryAf
 WwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rRZNXnAdmysY3G3Cnao0EYe4NJ/aofq02IxKvLoVlH8=;
 b=OrxPb3ArdLcAHmqyelP7uRRykpw7GETurfVQp5mxseB0blt2d/+6GI/eLBVxyczRtE
 soBXERxDx5qqqZMtJMHzXNK7+eGtVoWzXRWOuQMRGDoWbuGQR3IMLXHMsLfsn0yk44oT
 uknC6bEDos1NqHFjeieX6EPvBPOprF7GIEGqAMhU15y8ez83nVhh6bXs2ERa6GcWd+qk
 AyUa6u4OuqqgywgEUDMP4rDlGoeVov4Sbo3yuyGWHpazTGDZeywU8DqzirdqdePgryyI
 nLY2PomH4jEQI/y+/L+GbgsbS0Tx+ZO95AwWr7jpVC6DcI1EwUCccB/ap9snif66yZlS
 W9uA==
X-Gm-Message-State: ACrzQf2RGh26TicKeTiQOJfJ6GHrgANnXQs5uOeIiTwUG+5gAlIkXqed
 SUTkAlUM8/kBYrMso5JNr1iWMMo=
X-Google-Smtp-Source: AMsMyM7AEG/PHRE/PAJfIvirZi/8MBo+6gmKUXgAfN1z2bLvV4rA8HnctJ86FJNToEWiHsMK90jh8VM=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a05:6902:202:b0:6b5:2297:58f2 with SMTP id
 j2-20020a056902020200b006b5229758f2mr32536668ybs.205.1667524274233; Thu, 03
 Nov 2022 18:11:14 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:39 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-7-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 6/8] KVM: arm64: unify the tests for VMAs in memslots when
 MTE is enabled
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Previously we allowed creating a memslot containing a private mapping that
was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
we reject the memory region at memslot creation time.

Since this is a minor tweak to the ABI (a VMM that created one of
these memslots would fail later anyway), no VMM to my knowledge has
MTE support yet, and the hardware with the necessary features is not
generally available, we can probably make this ABI change at this point.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fa2c85b93149..9ff9a271cf01 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1108,6 +1108,19 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	}
 }
 
+static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
+{
+	/*
+	 * VM_SHARED mappings are not allowed with MTE to avoid races
+	 * when updating the PG_mte_tagged page flag, see
+	 * sanitise_mte_tags for more details.
+	 */
+	if (vma->vm_flags & VM_SHARED)
+		return false;
+
+	return vma->vm_flags & VM_MTE_ALLOWED;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1284,9 +1297,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
-		    !(vma->vm_flags & VM_SHARED)) {
+		/* Check the VMM hasn't introduced a new disallowed VMA */
+		if (kvm_vma_mte_allowed(vma)) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;
@@ -1730,12 +1742,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		/*
-		 * VM_SHARED mappings are not allowed with MTE to avoid races
-		 * when updating the PG_mte_tagged page flag, see
-		 * sanitise_mte_tags for more details.
-		 */
-		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
+		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
