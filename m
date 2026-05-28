Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600CA2E7396
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987298; cv=none; b=fZUeA2oq29UhkVKMjexr/M5ILGZBZzZD6ZAyBg6tVLgoh0HQzSAN7BJZaOXgg4wL4/kPVb9v/+C+o9ph6TY0dT3Mc8fvBtT49PMILjSMUP8boKZukGpuWWNfPi7XMnULPGe3ecW0xEN5CnEpDPeBCDvySAwKUOZynJswBZRDz+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987298; c=relaxed/simple;
	bh=IabF/qhrKADpVfYSXfZTKIbKpsiQcARly16NJbg+a/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jUdNyzC00VB61MrTDHtblvpFw9Gh5xSQEIiG2bG5YoWGAy7+ULuBp0ctdNc/YV5Y0LBi2uP9T+VpgvmKoUSLL+pBOU1ToqqkrSqxHR7xy2TvAm+zXBFIys1YaYG5our+fwEqtZkM++jv35hDoPUys6l/vYsd5a5hsisXLWBb9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VYfownjW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VYfownjW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFEA945DD;
	Thu, 28 May 2026 09:54:51 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7556C3F905;
	Thu, 28 May 2026 09:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987296; bh=IabF/qhrKADpVfYSXfZTKIbKpsiQcARly16NJbg+a/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYfownjWKGtTxPMhS9oUNgJFFBmuiWr3xRtC54kjop+aplZ0MjKxAwI46cMul6OBS
	 1BFjiJcpLBSAclk63NdeoosP6HMVIS1V09JDbja32fwooyNzHsRLEgHHNUo9SVxds0
	 +5+XTLgOWbd7Uj0c4kNF0Ru0mHWoDy8bPX+GpOn4=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v2 01/18] KVM: arm64: Don't include <asm/fpsimdmacros.h>
Date: Thu, 28 May 2026 17:54:29 +0100
Message-Id: <20260528165446.701944-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528165446.701944-1-mark.rutland@arm.com>
References: <20260528165446.701944-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need for hyp/entry.S to include <asm/fpsimdmacros.h>.

The fpsimd macros have never been used by code in hyp/entry.S, and were
instead used by code in hyp/fpsimd.S.

Remove the unnecessary include.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 11a10d8f5beb2..308100ed25de9 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -8,7 +8,6 @@
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
-#include <asm/fpsimdmacros.h>
 #include <asm/kvm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-- 
2.30.2

