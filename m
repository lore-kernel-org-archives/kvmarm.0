Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8EFC46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 10:13:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71DA44BBA3;
	Tue,  3 Jan 2023 05:13:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QqmnXu4hbgC; Tue,  3 Jan 2023 05:13:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D2F4BB8D;
	Tue,  3 Jan 2023 05:13:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B5D4BB50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 05:13:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7reQvwSMYKdB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 05:13:13 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C20B40E25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 05:13:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 27923B80E63;
 Tue,  3 Jan 2023 10:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D27C433F2;
 Tue,  3 Jan 2023 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672740790;
 bh=/36RZNkiPAxwtJXfCBhVvkMEDyUrBPHpASIPH0DBj1M=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=pjT73yj6JSjz9uV37Vt7kNnqDBn5vDcYZPWPHHY8okMHqMl58/pj+yEoowL2ZnUnp
 IyreHta2bDrXSA7fjsnD9hJ9q5KEtTQ+MICXlxjye81rVv3VQF6tGzHlarwUgvaMC/
 EU7nVXWVA74sWsrYTvq39WCAKJ4jUdXdgkv34AhbaiZJVq4G2MZnMrj684yJ5bMthC
 +qusl0brQvqmTfRtFWxLiPWpt5KG4IKRve/bcGoZFRU6NMcVCyCppxnNDjlNvI6PlX
 A5R2NUOLP3kpTifk/hwBmutO7zCGewpOrEKv1MwMF1bw8ILRk+RQLMGSoOj2nCUI94
 FjUTi680ybQAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pCeI8-00GTpw-Sk;
 Tue, 03 Jan 2023 10:13:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/3] KVM: arm64: Document the behaviour of S1PTW faults on
 RO memslots
Date: Tue,  3 Jan 2023 10:09:03 +0000
Message-Id: <20230103100904.3232426-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103100904.3232426-1-maz@kernel.org>
References: <20230103100904.3232426-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 ardb@kernel.org, will@kernel.org, qperret@google.com, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

Although the KVM API says that a write to a RO memslot must result
in a KVM_EXIT_MMIO describing the write, the arm64 architecture
doesn't provide the *data* written by a Stage-1 page table walk
(we only get the address).

Since there isn't much userspace can do with so little information
anyway, document the fact that such an access results in a guest
exception, not an exit. This is consistent with the guest being
terminally broken anyway.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0dd5d8733dd5..42db72a0cbe6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1354,6 +1354,14 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
+Note: On arm64, a write generated by the page-table walker (to update
+the Access and Dirty flags, for example) never results in a
+KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
+is because KVM cannot provide the data that would be written by the
+page-table walker, making it impossible to emulate the access.
+Instead, an abort (data abort if the cause of the page-table update
+was a load or a store, instruction abort if it was an instruction
+fetch) is injected in the guest.
 
 4.36 KVM_SET_TSS_ADDR
 ---------------------
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
