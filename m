Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13243934D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564075; cv=none; b=rfkTazzU7z06T6H3RrPgw6iBlzBlknuA/M5aBSsWZEk6ngNvPFqZ3s7Olhr/GZUdIjMqeWzh0BqZAo1E0dnLcILPpDQWRq13sgKtxnfB3TTRu2SLKKyZ8hEcYQAAiyJuG53cqN3763ofmiCuVV/cwarjEjNyp8XjkWVJju+cxOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564075; c=relaxed/simple;
	bh=J3eHgjr3oIErd99iqocQD0noX5/NXN32iudi4Tvb7Bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fzv6afO1Ze6J2c0YizoQj/bI6HdkIu8rbIYiADHm9/JyqaGNfMI/yEQl0ROCm78tP55xE0yAJqLYHjfB2rOAyG+qOqKTaIHPZmZZlnY2UXr0fspGpOeFlRd6zhswQEVk5lFxjMIJJjdAlS0XzS4pTIt/8ek0MolEzqsnSVwVS4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ks2jPVMU; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ks2jPVMU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784564051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=378xAE+4aH1txtkdcNpw/anaKeFJcvZA1JJKASZFS5M=;
	b=ks2jPVMUWYy2D/5dja8oH5LTo4p4xZ+B13bbKKBlox1oRlQRji5dHzkkuiRp1qUo9t5/cs
	pJVDpMF487yBbrTu921NNBsvKR/2pnWfgJAGkjAE1+ZEv41cwWhEcF2Oy0J29T7hiQ2Soi
	CoqEEsqXCzI/glrdi5fRwRkqnQLEcQg=
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
Subject: [PATCH v1 05/11] KVM: arm64: nVHE: Run the source checker under C=2
Date: Mon, 20 Jul 2026 17:13:37 +0100
Message-Id: <20260720161343.1367007-6-fuad.tabba@linux.dev>
In-Reply-To: <20260720161343.1367007-1-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
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

