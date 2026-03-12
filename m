Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F9F319858;
	Thu, 12 Mar 2026 12:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773318969; cv=none; b=jE+AMmP1DN0HSTSbDqbmfCr5wOj2syFMFJJwaBAVmX+HXIxf3dHDz4PQUl2HE0nwgrOEhLgsKnG8Fe7sveHVYsTFnVDStD652YWtkyV+YdCnLnIh+/98hv0RJLNpdcyvSRXI+H8DuO0t73JJJZZEtBFb580Vp7OpmgJ0Wm1Jjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773318969; c=relaxed/simple;
	bh=X83G1zyfy7cCirzYpJUDZb4XiY3Tr2OOZB5qt2lkQcw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=acNubcax9ZniO7hQ+x/9XLuABHGL7HefabkaRp8yBfhTb2P7GmA3bfjt+90crbD+RTUrxKwGW6PWT6lQ0IvujHOla/4I6IvQ3TDXOiGEW1dTe8jJLcOIOpJCSi3ye67ugg/neFsoTtQxoB+Qs59x0nCNCohankH4HA2Nllsgqjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/tPI1nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/tPI1nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69C1C4AF0B;
	Thu, 12 Mar 2026 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773318968;
	bh=X83G1zyfy7cCirzYpJUDZb4XiY3Tr2OOZB5qt2lkQcw=;
	h=From:To:Cc:Subject:Date:From;
	b=M/tPI1nqzSIdTEGcEnQl+bRkII7/fPTgtXqWHhtBdSEj2/BAXMr6mTTqUYHEKkgzQ
	 /JPYboBSFs7yn2XYewKQQKaUmmisMmRKo0StMypYjsZzAIYhcK1HKx4BNw3TTGVZiS
	 GaT63BCnmHa6CepfmE/AxgU53csICkZ5MEv4qRjz1DzsDdDh9ghCRfUFKVfIAJGmkl
	 06a4eps2HGzqzQpfglGH5HUECN2A88xWHZMDPgcMqJYJOqStSI8DeCAJjdFvTCsWcZ
	 CDmgPPv5pacMD678JdR4CYmwr4egXDDtX/s6ThPtj+79CUOslzVZHZ/Rk+bMvUP7ma
	 716EUl0l2mKcA==
From: Arnd Bergmann <arnd@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: fix include path for ring buffer implementation
Date: Thu, 12 Mar 2026 13:35:42 +0100
Message-Id: <20260312123601.625063-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The simple_ring_buffer.c file is in the source tree rather than
generated at build time, so the include path is wrong when using
separate object trees:

arch/arm64/kvm/hyp/nvhe/trace.c:16:10: fatal error: simple_ring_buffer.c: No such file or directory
   16 | #include "simple_ring_buffer.c"

Include it from the source tree instead.

Fixes: 680a04c333fa ("KVM: arm64: Add tracing capability for the nVHE/pKVM hyp")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 143d55ec7298..3d33fbefdfc1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -33,7 +33,7 @@ hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
 hyp-obj-y += $(lib-objs)
 
 # Path to simple_ring_buffer.c
-CFLAGS_trace.nvhe.o += -I$(objtree)/kernel/trace/
+CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
 
 ##
 ## Build rules for compiling nVHE hyp code
-- 
2.39.5

