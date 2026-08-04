Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D377432BF4
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842682; cv=none; b=HF2tPXy1jRQe8xjV01qtqBUTO8GrVHzqpivsA0T1jwqF30D8/mv28zpYd8gMLkRhLbby74Mx2OuIX7aM36apzU86kZiM2nVe5MstHr1DZNtnsv6ZPEji7y6gn8+dz/W3DwCXLmTrNeYIGDTnNFondreHrm4i61rZHA3KkJnFRUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842682; c=relaxed/simple;
	bh=BwXfUSI8RZ5WlNlvsW4Dg8xPJP7duOd+6j4GH2NB7KQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o5r0uCM/HIcIlCvNxyxqIj710BGItt2wPpfdYuLEhrdj7b7Yv03SEkW9sPqHR/S8sb92NelHNmo3JtRou+mHpFPIZMTBarSrUNHoM1bzrf8aYEhyMjJTsN3OvzHkZotdSQx4QhNQY5h7U4CmVNbPRDai3voAf7i/shsoJ1nGYGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PwhdSacw; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PwhdSacw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/0h+UWlinGdaNRWQ3ePtD6vflPt+g0iOPa3K/aYZ+gU=;
	b=PwhdSacwEzCVjTWcbfzwkeIWM3lcgwtaHNu7bEjkh74w49DgAE276SCQ64FC6xJTMOZtB4
	y2RQ00Zb9UuGd8cwgF35tELy4pYQwjzW2p+tAjoEuFdPHFi2utx3VbVBBxe9TFHZV2FT7u
	UHo2o27d+en1XEGIA5D3Z40uWOrljio=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v3 05/11] KVM: arm64: nVHE: Run the source checker under C=2
Date: Tue,  4 Aug 2026 12:23:11 +0100
Message-Id: <20260804112317.1937387-6-fuad.tabba@linux.dev>
In-Reply-To: <20260804112317.1937387-1-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The custom %.nvhe.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule that
nVHE objects do not use, so "make C=2" silently skips every nVHE
source file. Call cmd_force_checksrc after the compile rule, as the
standard rule does.

Fixes: 7621712918ad4 ("KVM: arm64: Add build rules for separate VHE/nVHE object files")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f57450ebcb498..ccc1fe8394094 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -49,6 +49,7 @@ targets += $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-relo
 #    avoids file name clashes for files shared with VHE.
 $(obj)/%.nvhe.o: $(src)/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 $(obj)/%.nvhe.o: $(src)/%.S FORCE
 	$(call if_changed_rule,as_o_S)
 
-- 
2.39.5

