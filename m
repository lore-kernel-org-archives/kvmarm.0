Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E1CC43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9254C86F;
	Thu, 21 Jul 2022 21:51:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gz8J07x7ZRT8; Thu, 21 Jul 2022 21:51:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 776894C870;
	Thu, 21 Jul 2022 21:51:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A0944C708
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y+j-abr-WhtU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:51:08 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CFBC4C872
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:08 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m123-20020a253f81000000b0066ff6484995so2614036yba.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GyooXJlVj4syrTh57O3ydwA+ijcUnjC6dc1fY8noLps=;
 b=YexvIvXmjzIiWZCe0Sk5hw56SQOQK5rCE+GIuFsEHy72Q9kS5JT4M+nBTT7s4wZuAm
 f5dgcRlU/elvPbUhNMcjoONhJPNZbqP9Gx+yqVuAkYgt2j7WBfrWdp2nvpa9il5ZAGcY
 uhOTucAWiXLVs4DCEzbfoEsOlh9g8RMGTfBO6KSXT0jKWgr6d5G6OLdAD8JdvWJd/cAT
 MqdldRcm0mVOGz7Jp90nD+TwbpLxHOWkqwPMedVjuKgHX10c/bwtjdG0JAy5utJ3aJVJ
 2732cZqnk/H+d5WXLQ9+UDeSK1u0VXrOzTEJF49vbxTmV8DJAyfAaRzc8qK5XqgH4gyK
 Xjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GyooXJlVj4syrTh57O3ydwA+ijcUnjC6dc1fY8noLps=;
 b=qqA/XVa7Kt4ePsHoEpqETpRjq9XR77gQAtYQ60tpDpd3QR3LxK8Pqeo52mcalShI3Q
 RhadwLOCcowfAluMX77vgFeQ4zSOcfjFreOQEYQm1kkF1ia3+K9ahMYcSwxt6jlzWkva
 f0iMFvm5m5CAQMs/KpatJbj6sckI25nnN6eqdo9aqPGOE8m2xnOs7sJ+3OvVPa8zG2VL
 Nx2EaH2F21h5on2XFZkqC3Uj02UAM3Q1yCdtCWZx0OctQDS/7VaT9Mj66VayQfvFpmo+
 NJfq3Ba9tDGaayF8nc806uMy991umFxRh1VJ1C/IYZ190iaj1i7QipJB0bPi/gJpIYV+
 bSJA==
X-Gm-Message-State: AJIora9nzImHAu0ZlEf0RMu4uSWNETnacrjc6IvjhFBEsnsBHIuia8Nd
 6xDLib3PpsmOaXZkvrpyfHuyUQc=
X-Google-Smtp-Source: AGRyM1us6MLr1PJ/EHpCUXmwTwiBBgpEPArK9WyBoVdM3Qtak3DgE3vimbQIEBEpi09h87XBzW/1l2Y=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:8404:0:b0:66e:fe43:4f93 with SMTP id
 u4-20020a258404000000b0066efe434f93mr1180184ybk.284.1658454667788; Thu, 21
 Jul 2022 18:51:07 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:31 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-6-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 5/7] KVM: arm64: unify the tests for VMAs in memslots when
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
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 750a69a97994..d54be80e31dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1073,6 +1073,19 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
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
@@ -1249,9 +1262,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1695,12 +1707,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
