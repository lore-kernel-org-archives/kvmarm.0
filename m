Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AE1C2AF
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279052; cv=none; b=M+FTEELoANnQ+ejwrDt+KQVh34xtA7WFLn7wyXKq0uj3NWcnZ5ZhosO/t7kMO68Q2A+XgtsZlS4VMpW1qddDATFpIp8G9YmBQ0rrDGJqEw3+fR5OmGELxhLAUBrKhelyERi4EWHnCsb09EG1jYPfXOlht32ihe//52PqJAOtrMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279052; c=relaxed/simple;
	bh=Ue8d76Sr5mgyLpo4dy+RyPAAUxH5/SLTJFKtFwR9rsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=LFyFzqfS8VIbZkZU98KTi+9FAk3LyuStemqN0+QwRh9hUGpTtUpAmSJ93vLaGu3WaOEFuC14ab1N3krPqDBvOArUr8JAyNrnXF7Fabdb66VSk/C0jmHRPKxiVIdXhDlasNY6xyTnISPCGwn5pK4GvYY/jl3ZE0Y3UdLwM4qK3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dcU9gXGS; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dcU9gXGS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OcnHKT/j6zHB2BZpzAqIoxyI5CLjfiYoL1Wr3Kcxe6E=;
	b=dcU9gXGSsqkgI/GRDOP+ME2SFWRRRBg0bjnu06wdvx/TFqA7iq997Q0VQUW7FAUOUUXbry
	2MvmQlo+RW5kUg+q971a5V9s+iq78bczplFAJQUAd08tosLA5mKku1jtkUgFua3WF4gfwC
	1Mu2umMBPyVBi0wBFiDwGA29XwiQdi4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 14/24] riscv: Compile with march
Date: Fri, 26 Jan 2024 15:23:39 +0100
Message-ID: <20240126142324.66674-40-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tell the compiler to provide mnemonics for instructions we depend on,
such as 'pause'. Specifying march also allows extensions which affect
compilation to be individually [un]selected. For example, building
without compressed (2 byte) instructions may be desirable, so 'c' may
be removed from the march isa string.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 riscv/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/riscv/Makefile b/riscv/Makefile
index 4a83f27f7df2..697a3beb2703 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -55,8 +55,13 @@ define arch_elf_check =
 		$(error $(1) has unsupported reloc types))
 endef
 
+ISA_COMMON = mafdc_zicsr_zifencei_zihintpause
+
 ifeq ($(ARCH),riscv64)
+CFLAGS += -march=rv64i$(ISA_COMMON)
 CFLAGS += -DCONFIG_64BIT
+else ifeq ($(ARCH),riscv32)
+CFLAGS += -march=rv32i$(ISA_COMMON)
 endif
 CFLAGS += -DCONFIG_RELOC
 CFLAGS += -mcmodel=medany
-- 
2.43.0

