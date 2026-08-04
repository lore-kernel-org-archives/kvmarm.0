Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DDC463B6E
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842645; cv=none; b=cnGC+1IS52tryRkyzJk78SYWQH0mhIGuSLMvO5aOBO8AlBZ4DdPeQgGQDh3vHC/SprD3YEiP8F7MkxwCPx4duIYF1l79M3sF1rcWyUcVR/N1UYYd45OqA0QyJWN3cjw12NmbFkRzseP3G+1vqw6JJvo7lYFNXOLRYIlkESDXWUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842645; c=relaxed/simple;
	bh=964nyES0bpmlC1jVFJFVmRXV0epLfd7qUJ0SK0/0qeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rXil0GEaYPf3Co5w09Ao7asIDpsBUTOBAjlo7qGj8fws2WoHYrBO/SI/RUyanxprtZU0E0jKKL/huK5oHrlzau/ymbvK7lQOaHHFimkt6ir488OHn5U4ljTusIzf20Fiy9S96mJrrOoDy8ZPu1gpL4OKehQ0TwBxeYR0FCVPcRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YqZGqwPd; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YqZGqwPd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ClYTj8QzgBnO7N7CWSz26CsAj405Dm7DCBLVlh0azJ4=;
	b=YqZGqwPdUakNx3Kj0pYdE42UUrWCKvM7oVflZ9d6L2HfNSyl//ExpcH1U8n1BYMNOc2pqA
	vJFpy3x3oDZlj9TVQTjj3HLyDsLt2WNPq1nkg4Sr9u14c/0845naqk3GKFvCAgGUlvm9SD
	/CI9bZLu3uc/CfPOrC1f45cyPiI/ZkA=
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
Subject: [PATCH v3 03/11] KVM: arm64: nVHE: Declare the hyp event IDs before defining them
Date: Tue,  4 Aug 2026 12:23:09 +0100
Message-Id: <20260804112317.1937387-4-fuad.tabba@linux.dev>
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

