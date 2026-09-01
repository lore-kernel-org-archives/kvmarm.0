Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C18A3C5855
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271450; cv=none; b=e8U1aOZz6Yi5CsPnKxaXNUKNWO5+uclao3UUTEsidx8bTv8zYuKAUiQK6lsl593SJ6xaDfwzeBlmV89JjDGjG5R30pYYUC8ltK5U4kpjDJWx/A1NMD40UyLLBr7bykTERncjxoNEi8S7zQCaq7LAw8OtYgsvJ4rWfq3IXtPcEhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271450; c=relaxed/simple;
	bh=aVU75XT42/hoFARBw3KCuAe4snE6JpMOO83ThRddGtE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f2UEtZDpMA0kVArUYXlwf8061vlffWLT7+c2FoE7F0q/n96Judz9YWgk2/nyHM6Xu2SXo+U1+0U7WAYWZLbxuVMihNIuqmXLhTPINh6R4ugK+9Fzin5xE/0SANyiknUf/gm4beVJt0Rg1VdpQ3tChafV7ivi+Yc4/kCuqvyObqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TEJK32QA; arc=none smtp.client-ip=95.215.58.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TEJK32QA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aVU75XT42/hoFARBw3KCuAe4snE6JpMOO83ThRddGtE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271444; v=1; x=1788876244;
 b=TEJK32QAnVRKxxgM2CoHvbaPH9Kc+9fhgwbcM+HlvyMfIXeMtZJYxWLc/caeCyl+lCtAo0ob
 TILOD7ee4F0/yyi37wfHx6F/xoht47y2RTgEAk/SL4Zg6cEwrUyd2Mxa5kYPHybM61BcUvJie8v
 7pRLsCfp84LHxf5qG8/khgFc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 64e57d984ad2e962;
	Tue, 01 Sep 2026 14:04:04 +0000
X-Mizu-Trace-ID: 64e57d984ad2e962
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
Subject: [PATCH v4 06/11] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Tue,  1 Sep 2026 15:03:21 +0100
Message-Id: <20260901140326.3812068-7-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b21..96243c291e39d 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -34,6 +34,7 @@ $(obj)/lib-%.pi.o: OBJCOPYFLAGS += --prefix-alloc-sections=.init
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y					:= idreg-override.pi.o \
 					   map_kernel.pi.o map_range.pi.o \
-- 
2.39.5

