Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D9E3E44ED
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 23:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782947799; cv=none; b=VZ4EM3rF5IKikIfB1iZWc2xBiPJyTMZJvG+6ALJWBhprL8Affl0oo4lRxsbXjgL+9bZTLKQ4ApRwJ9Bfasd+8T5HfklvjhH77pEH3A01RByX64gwdYUls4LTFRRjB+yc62Y61RNvUzaS3sr+4Yv9wFEUq1cwsGniG+whhJn146w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782947799; c=relaxed/simple;
	bh=CmkWelfnzG1AA6rc+T7hUaRKxmwzOmMAk49l6aTEQF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upwYvVkngL1u7CdGh+Cp5653EkeleU1MXvKPLxqKRLiNg3uWjzbZmItR9677BTLum6jDeIFavPnOuXfy6x9ySZ8deXMKrs7Q7/kjd7HoYo1Ed1Tr06KLheBE/wJpszQl/afaQeUXXPOPYiOGrG1j7+WuQfHE6CsSzOwDBCs1O3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgbyBN8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgbyBN8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664C61F00A3D;
	Wed,  1 Jul 2026 23:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782947796;
	bh=AFH+x2flhbnXdVQF0rFnSXRQ5GUU/c7c27VA9WfDa4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgbyBN8var8qBveLdnLkCtgE92mbkKCwKQ/qL8sJGnNrYftcA4+ylVXQdembV/9ir
	 DAiyZB9ikrTrzeWUnqUy8Yb86mUGDJRQMrxmnhijibGq0VaCxQValooux43VLarEz/
	 w9wNuRY7IYO9BmtoZzCB465mq9/CHjYgkQovlZ12UnLEvQK+u5T8BNCUAhuSOCbEz9
	 TmmhU5zt2X7xLnfsFlLg9iEcYVmuGBAtWyiAxMyNCz8Uu5czhUmrMKRgP1jwzuNbgx
	 7yVqdG5VCqMrZHgV9As9uRhHlHniYyo0WbqeJZmiu61hVFTi0+/KNH5lvqtMNxY+7q
	 v4rcSQCpJNw+w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 2/2] KVM: arm64: Only update XN attr when requested during S2 relaxation
Date: Wed,  1 Jul 2026 16:16:20 -0700
Message-ID: <20260701231620.3300204-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701231620.3300204-1-oupton@kernel.org>
References: <20260701231620.3300204-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On systems without DIC, KVM lazily grants execute permission to stage-2
translations after taking an instruction abort due to a permission
fault, allowing it to defer I-cache invalidations to the point they're
absolutely required.

If a data abort happens later down the line to such a translation, KVM
will not request execute permissions as part of the S2 relaxation on the
assumption that kvm_pgtable_stage2_relax_perms() does exactly what the
name implies and adds the requested permissions to the pre-existing
ones.

Avoid taking unintended execute permission faults by only preparing the
XN attribute if KVM_PGTABLE_PROT_X is set.

Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 31aaca35693a..0b6d32d03efe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1370,12 +1370,14 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
-	ret = stage2_set_xn_attr(prot, &xn);
-	if (ret)
-		return ret;
+	if (prot & KVM_PGTABLE_PROT_X) {
+		ret = stage2_set_xn_attr(prot, &xn);
+		if (ret)
+			return ret;
 
-	set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
-	clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
+		set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
+		clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	}
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
-- 
2.47.3

