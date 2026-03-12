Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6D3090DE;
	Thu, 12 Mar 2026 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773318998; cv=none; b=rjhu1KKlX3SzkxM/wV3tSvzxpu9VvqlRjz6TIsbAdM5bIXXTOL5BtKdfSZzD92CAvcT7CfBV+PvTfB6dRV0UXNMl9ossdBYWrOXLlz9FZDOzMsEANF8qpvz6xRt/yYN1i0qMyoavKVVI1Q6vMtf3Lki7/ODVGe6cjQZfYhch6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773318998; c=relaxed/simple;
	bh=+K0U+39fI6wepOOuuwvoFFE12C+9HDXiqtjIeKJef6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bYB+Aj91iAMN5RDoPcAVSj6fy+rYmXWOJy2uMdVI1oR/bbRk7nF2f83ppeZ6DiyJvXmx52T05PUuO9AxxwXvQWZfD+r7SWg5cJNScb2fMf5KYQmMTJsWEXecKWs8vC0t2lt3KeWGR3t6WmrlMwWRRyFejlAGer+TKEPWAkqIAjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mm7RTqcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mm7RTqcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37831C4CEF7;
	Thu, 12 Mar 2026 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773318997;
	bh=+K0U+39fI6wepOOuuwvoFFE12C+9HDXiqtjIeKJef6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm7RTqcw1KSrwUNMR0dCj+/GC69aa573HNd2XeT90H5+nPXEcDbtZc7IH2Cdkavbd
	 1OPjRffOohUaPZoL3b9pWsXAJL1dpkSHzBa5WeUNh8dZWdhd/XSl/BcEYsk6oFv3iF
	 Y88BQDoAdlJWczl60f5IRplcLYkJDwXNg/rOR8XAExLvFt8Ir0q3A2KbKk1+xZNhh8
	 KYhGQnDYZJZOD+m3FzR0yNi36m7aVvpHItRLGMxGaemBvBe2/Ad7zHNYgiOxq3f06j
	 175YOv8ovz54havhpEi1aMV7NoCDwsMvnHRdehy48S9K4qwRzRjNvM1VFKe8P+UCqp
	 DxaT9+ZkOcrFg==
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
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: tracing: add ftrace dependency
Date: Thu, 12 Mar 2026 13:35:44 +0100
Message-Id: <20260312123601.625063-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260312123601.625063-1-arnd@kernel.org>
References: <20260312123601.625063-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Selecting CONFIG_TRACE_REMOTE causes a build time warning when FTRACE
is disabled:

WARNING: unmet direct dependencies detected for TRACE_REMOTE
  Depends on [n]: FTRACE [=n]
  Selected by [y]:
  - NVHE_EL2_TRACING [=y] && VIRTUALIZATION [=y] && KVM [=y] && NVHE_EL2_DEBUG [=y] && TRACING [=y]

Add this as another dependency to ensure a clean build.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 32c7a4f85e75..bcc87f9dad33 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -78,7 +78,7 @@ if NVHE_EL2_DEBUG
 
 config NVHE_EL2_TRACING
 	bool
-	depends on TRACING
+	depends on TRACING && FTRACE
 	select TRACE_REMOTE
 	default y
 
-- 
2.39.5

