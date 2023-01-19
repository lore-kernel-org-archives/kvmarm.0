Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA27A93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F860C433F1;
	Thu, 19 Jan 2023 17:09:04 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] KVM: arm64: Pass the actual page address to mte_clear_page_tags()
Date: Thu, 19 Jan 2023 17:09:02 +0000
Message-Id: <20230119170902.1574756-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
initialisation") added a call to mte_clear_page_tags() in case a
prior mte_copy_tags_from_user() failed in order to avoid stale tags in
the guest page (it should have really been a separate commit).
Unfortunately, the argument passed to this function was the address of
the struct page rather than the actual page address. Fix this function
call.

Fixes: d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5626ddb540ce..cf4c495a4321 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1079,7 +1079,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 
 			/* uaccess failed, don't leave stale tags */
 			if (num_tags != MTE_GRANULES_PER_PAGE)
-				mte_clear_page_tags(page);
+				mte_clear_page_tags(maddr);
 			set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
