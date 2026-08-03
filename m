Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2497411693
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 12:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760960; cv=none; b=nMzleNsgEJ/KSPjTmwAbJtRscP81x0m9xrq0wIYBxfJx7HfS8AAl6JZi0UsLKRAjL29Wwk2XY9ogwqI58TaD6zXvOcxlmhY7mnJhxobgfygN1kgaNDDafqbmEqPnwMcbwjTJyl6zrAabGCYMuFRwlImg5VTBJmAxKN+EQvfaTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760960; c=relaxed/simple;
	bh=964nyES0bpmlC1jVFJFVmRXV0epLfd7qUJ0SK0/0qeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iCV2pTE0O2HJ4ADpErzd6WXFEjHcDv+bcEsAEKSj/yvVgj99q5E0kgzjq11kOjWF3eZpkA9yOGxvWAOnzb3JeTNYLfx8JCYqywxQ4FpDqvlKmAcGAZP4QZy2r9e2FS9TxtHMrCob8eDtNrY1QAnzQWAJVOB9m/rcZL7LVshBkpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xhTJaeM1; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xhTJaeM1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785760956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ClYTj8QzgBnO7N7CWSz26CsAj405Dm7DCBLVlh0azJ4=;
	b=xhTJaeM1jik5dmoy0svqefAsSjE0Q9FL+W+l+FLUK14nyvekFwB9ivciH/MxcMM4A98SJu
	L2YXNA1MfU/SmNabpQQvCDbz24P8sSKw1b82Tngdql+NNZKLtkKyb6Dk0ZqLn4djsYg+Uh
	VtVaC+vIDTSXjNT3kdD6kujQk9YzzKI=
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
Subject: [PATCH v2 03/11] KVM: arm64: nVHE: Declare the hyp event IDs before defining them
Date: Mon,  3 Aug 2026 13:42:12 +0100
Message-Id: <20260803124220.332248-4-fuad.tabba@linux.dev>
In-Reply-To: <20260803124220.332248-1-fuad.tabba@linux.dev>
References: <20260803124220.332248-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The defining expansion of HYP_EVENT() in events.c is the first time
its translation unit meets hyp_event_id_<name>, so sparse suggests
making the symbols static. Include kvm_hypevents.h ahead of
define_events.h so the extern declarations come first, as with the
tracepoint headers.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/events.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
index add9383aadb5a..b845be0acd117 100644
--- a/arch/arm64/kvm/hyp/nvhe/events.c
+++ b/arch/arm64/kvm/hyp/nvhe/events.c
@@ -7,6 +7,8 @@
 #include <nvhe/mm.h>
 #include <nvhe/trace.h>
 
+#include <asm/kvm_hypevents.h>
+
 #include <nvhe/define_events.h>
 
 int __tracing_enable_event(unsigned short id, bool enable)
-- 
2.39.5

