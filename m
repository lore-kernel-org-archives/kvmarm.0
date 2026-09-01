Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE9383992
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271447; cv=none; b=eZ+41kVswBPAy45b5AuJ9Y+gzOrgl4BAb/exrRzUvrgshV2icvYtwwgZLkOOjK1eEMLODoNCY+dcuoFo4BosExmIkDkdlSadxT9nsyvSrX27kpusE2cZ+vH1Q9raFuleQqgRmBaVpyGOZisiQtCfr9wk8ZZE9Ldxr+pFRmIBIHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271447; c=relaxed/simple;
	bh=nf9m83+hrKqgn8YWup9R6VRwseln6uhzrpOiLyHdB7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=knSsCjw3xQSwC6qMFPFVXSxR7HTppLjAOfPzY6LAU2hwZlJiyxLlpddFst+XIYXlGL9HOMvXbBw2Dr3I7mKv6n1CrBd4FPss9X5VIJyh8spJt3P2n6F5yNhRlJIaxs20CzpOR7DbYP1O58PzwBsUYr3qqVUNOeYxTFL0VbNS8jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zncaz+Aq; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zncaz+Aq"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nf9m83+hrKqgn8YWup9R6VRwseln6uhzrpOiLyHdB7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271443; v=1; x=1788876243;
 b=Zncaz+Aq55l6zKrKuKdZ9uKk58puDA7hTL/UKDk6P7pYoBnaEJ0YSWVtMA5fjysMXq4ZWmPq
 awgIUS0qeD5/xME7YU8zd4pjevZQ4nTHsk6FzMjjOkvH4tUFWaflpN16Ihl6Qk+Y2YdioeExYoI
 ofGonMD0is4hR1k2Id2rKmD4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 652305927580f4db;
	Tue, 01 Sep 2026 14:04:03 +0000
X-Mizu-Trace-ID: 652305927580f4db
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v4 05/11] KVM: arm64: nVHE: Run the source checker under C=2
Date: Tue,  1 Sep 2026 15:03:20 +0100
Message-Id: <20260901140326.3812068-6-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom %.nvhe.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule that
nVHE objects do not use, so "make C=2" silently skips every nVHE
source file. Call cmd_force_checksrc after the compile rule, as the
standard rule does.

Fixes: 7621712918ad4 ("KVM: arm64: Add build rules for separate VHE/nVHE object files")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
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

