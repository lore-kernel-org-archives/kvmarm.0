Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82D5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71AF44B3FE;
	Thu, 19 May 2022 09:44:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hTVGCrGUAkiC; Thu, 19 May 2022 09:44:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2254B401;
	Thu, 19 May 2022 09:44:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83DE54B3BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dTV2l8t4YMQG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:25 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79CD64B3F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:25 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DCDEC61798;
 Thu, 19 May 2022 13:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA773C36AE5;
 Thu, 19 May 2022 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967864;
 bh=p7gI1CdAvMGFDucFGozIsSRUoT2cXsZgzqAgI+aWRJI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=O7W4ZFQznwTwavYOMNgqoZkaJVWQsO9jN5kCKT1XWf5AaAmeKy3VxnW9sjsHkTLrG
 TfY6Z1cv3xDm6oV5E3McihQcd+gS4Vyn0F611oNXQlegU9gA0keNPi0EzvSHc2haHl
 NDdjUkPfBZFxp2ELKBx3uel0J7617Iv1ErnVXybdPJrzSMpd3Bif4Cg8eyF6eST2sk
 jWX9PujhExD/LYygdXm3cXPKf98gQR2loIkkuIl4K4arnxGzaUUBCG9Da4gWbMAc3V
 dsR4JViAgvGJnJWKzm5iSCzC6dwD1JRI63LsONf+4c9LakPeXQgPuvw+zYfW5JDy0O
 Ef8kzB05GrtWA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 30/89] KVM: arm64: Do not allow memslot changes after first VM
 run under pKVM
Date: Thu, 19 May 2022 14:41:05 +0100
Message-Id: <20220519134204.5379-31-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

As the guest stage-2 page-tables will soon be managed entirely by EL2
when pKVM is enabled, guest memory will be pinned and the MMU notifiers
in the host will be unable to reconfigure mappings at EL2 other than
destrroying the guest and reclaiming all of the memory.

Forbid memslot move/delete operations for VMs that have run under pKVM,
returning -EPERM to userspace if such an operation is requested.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0071f035dde8..67cac3340d49 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1679,6 +1679,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
+	/* In protected mode, cannot modify memslots once a VM has run. */
+	if (is_protected_kvm_enabled() &&
+	    (change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
+	    kvm->arch.pkvm.shadow_handle) {
+		return -EPERM;
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
@@ -1755,6 +1762,10 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
+	/* Stage-2 is managed by hyp in protected mode. */
+	if (is_protected_kvm_enabled())
+		return;
+
 	write_lock(&kvm->mmu_lock);
 	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	write_unlock(&kvm->mmu_lock);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
