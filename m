Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1661EC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:43:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4EAA4B393;
	Thu, 19 May 2022 09:43:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2VEnjs7fxIh2; Thu, 19 May 2022 09:43:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 900644B343;
	Thu, 19 May 2022 09:43:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808624B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fTQyBoIJgYfZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:37 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B26424B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 47AB4617A0;
 Thu, 19 May 2022 13:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E9EC34117;
 Thu, 19 May 2022 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967816;
 bh=85shQP61BCSRjbXAkRjEzDdqJZbFWFzFv7BZf/OaUmU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TgnhwW8HZyvKsH5oQyPqeOqAEt7QEwzyfAEDHLdPSe3emDrRl2fCYuS0Dldl2ItKa
 FWCA3edEkx7BVHqHb8PI81qO4XPXgJFtFKSFK3LqXV0aBpSguRmJ9xT69Pgw/N40P7
 vD7sa/6qrCRvinCefLpUO8F0PxUqhzGq8+OEuZ2AXgIuAoOM+/7j7CtPU+SeFAoypv
 wc5ZzTlEI/vOnowknkF6zPAUqrocTuJk79n272SUWCvDDfFA2B4g91lYg7e/CCm04G
 NqHnMAVmvWvUSrrWip4vAtPpiC/5wmxWTONRAIBtMaQoKK2v9fr7GKcdC894hMWaya
 J1EOqwsWnPPbQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 18/89] KVM: arm64: Factor out private range VA allocation
Date: Thu, 19 May 2022 14:40:53 +0100
Message-Id: <20220519134204.5379-19-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

__pkvm_create_private_mapping() is currently responsible for allocating
VA space in the hypervisor's "private" range and creating stage-1
mappings. In order to allow reusing the VA space allocation logic from
other places, let's factor it out in a standalone function.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mm.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 168e7fbe9a3c..4377b067dc0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,6 +37,22 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
+static unsigned long hyp_alloc_private_va_range(size_t size)
+{
+	unsigned long addr = __io_map_base;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+	__io_map_base += PAGE_ALIGN(size);
+
+	/* Are we overflowing on the vmemmap ? */
+	if (__io_map_base > __hyp_vmemmap) {
+		__io_map_base = addr;
+		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	}
+
+	return addr;
+}
+
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot)
 {
@@ -45,16 +61,10 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
-
-	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
-		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	size = size + offset_in_page(phys);
+	addr = hyp_alloc_private_va_range(size);
+	if (IS_ERR((void *)addr))
 		goto out;
-	}
 
 	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
 	if (err) {
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
