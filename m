Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCDAC6FA91
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0744B827;
	Tue, 20 Sep 2022 23:53:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jOp8QRw6lCS5; Tue, 20 Sep 2022 23:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D564B7FA;
	Tue, 20 Sep 2022 23:53:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD59C4B7C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6J0zDKHJJ4sb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:06 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BD8E4B7DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:06 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3451e7b0234so41404437b3.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=gA2O8oSq7e+d9nyvptw2rqsk9DDWzgsNC9HG6nZ9ojk=;
 b=XIO6ctUJSy+0azvt2pjBnryBUWNbF6hif5gqbPYYTgs6hWqcNPUhpEe9lgmOAUb5lK
 FIEztD6adqYqFeEvBypKlXChVdd8QisgiiSfY+985vqxZPImM0ex7t6ynV1Q5O6tezgt
 NDwiBirb38U/1dEirAo7Y3vns06/c4B8HudINdNTwx88KQNxgx1TmYWG0eQQg8lejZAZ
 /bU52MCOnyPXF6tZePuOkxwp5FG/90ihIjaJ57kWjHQ5T3L7z6Q1dLQcob1PqehxKNrc
 0m9GKeaaZ/knEEBovy0cI9BPTzeBrDuufHMEvKZD7vIi8VDKzbEhuAnwKtKy8Vj4b9pN
 sirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=gA2O8oSq7e+d9nyvptw2rqsk9DDWzgsNC9HG6nZ9ojk=;
 b=UOGyTLaOPcIKO0qNPVqMF8gvCkwxDaXldkMeLYF7c4+bNPbBC7lcioQRUiRH+EinBY
 8c/lkx0pijzJUAeoRkfgsYqBg7OYRopWcUyKVSWrpgi2wRrmwpnhRNoSIZX3w77ZjWaO
 m69g7q6Z2Z0h9e+OmYIBPzmhuKGvdr6NHrf3g5yB5xwSqFFQ7Ls52hPyIHPwsEDcV1Og
 aL9/M4gYx9+hZJNZKiqeFVfJ/pcyYq2bZq5D3PYJacn+sUUZ7kgW8uDlyoB6IM0oaJcD
 lXZO0y+HbAyfVTZu8pPCWcoDIzHyOVsX5nJaVTCLXfngEjvByJM1ic3eHYjXp+OCuNvy
 TwMA==
X-Gm-Message-State: ACrzQf3IejlCxbAZuRQI0ayZXFirhDxSFXpA++XbCOpmU01VFV+WlEg8
 t+db1A0s0pJ+FtvNI9662PdHN1k=
X-Google-Smtp-Source: AMsMyM70KZGF5iTWN4vyFkxGmYL4qy9cjP2UuKMDiQgL9O5HmyDhF0srIJOhVM93rWn1O+AMl83PUqU=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a05:690c:823:b0:349:bc6c:630c with SMTP id
 by3-20020a05690c082300b00349bc6c630cmr21877503ywb.223.1663732386243; Tue, 20
 Sep 2022 20:53:06 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:38 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-7-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 6/8] KVM: arm64: unify the tests for VMAs in memslots when
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
index bebfd1e0bbf0..e34fbabd8b93 100644
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
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
