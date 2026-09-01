Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2DA377A9E
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271427; cv=none; b=CX9O2B0tG3+TxxaDyThVY2cqgsNZsknuuER03elu04Y/mmtYyBAnkSv7Poui6U5dZY4uMvTU395zT9KTxvwveYNCRXmWGsaXqwQjMzetulA4UNyz2r4+WdrIj6iDBzWIuroX2L0wKKO+EaKEarKQWN0Y+LtDPkHPFrIM2MDQAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271427; c=relaxed/simple;
	bh=OVNe98vubbbTaN+IclJcwO0viGj4aPmde+BOllis7HY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i5rTtBRuIImWXM790NXw1hG7a7KtzcoH28GtEdmvQkeTm82rPghgL73hmuTjZiKsg5DcCGVbynmLBPoy2PLwdnUYikg3JgBJU0Ygf/FDt6XvJwYUOVdLUPYw+A++vfMiaptHcJ9M41xXipPBoOVG04vrrgyes19Gfj4DIEs6184=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SPREFmMz; arc=none smtp.client-ip=95.215.58.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SPREFmMz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OVNe98vubbbTaN+IclJcwO0viGj4aPmde+BOllis7HY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271423; v=1; x=1788876223;
 b=SPREFmMz9ERsVI/0Osbk6FbC9l11v9e5eetogDze18l67FCMOEy70FmaDl76+Z7pvHS5TuY0
 bwYJ1X9sZVRo3DpGfJdXRlKqjTMjpmeipXsygGok2F1rU9kVb+GOV0In/PbO//XDilmYHS5eNZD
 fqnkuQWFH5tEg7WS/HQvezLE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 230a545285999ef8;
	Tue, 01 Sep 2026 14:03:43 +0000
X-Mizu-Trace-ID: 230a545285999ef8
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
Subject: [PATCH v4 03/11] KVM: arm64: nVHE: Declare the hyp event IDs before defining them
Date: Tue,  1 Sep 2026 15:03:18 +0100
Message-Id: <20260901140326.3812068-4-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The defining expansion of HYP_EVENT() in events.c is the first time
its translation unit meets hyp_event_id_<name>, so sparse suggests
making the symbols static. Include kvm_hypevents.h ahead of
define_events.h so the extern declarations come first, as with the
tracepoint headers.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
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

