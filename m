Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC2A18C33B
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 04:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739766163; cv=none; b=rOlR4DxcRCw6fd3tq6IPmhgf71xPbwP0AVkBUddqnCQWMBojYz6iCl33HjlFDFLOFArJH5DsyRdc6MRCklMjsGikyJ3VncBkW8/cNAuKGakFujxzpdqCMnLor1wQNTirxtLytjkNEArGb0/aOh6VtSkdnQ07DHgbVqdTYji9tcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739766163; c=relaxed/simple;
	bh=oh130ZfN7W4wku04HmoxfgsWtF4oVy+oljkEG0XQAD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kkQ3kvHWx8b7a3qm7rZUpgt2RowkQzcfp84zgo4D/hFPPh+RGaOC5dLhLCMUeKJRilOmJeuKW2jW0UegrRTSLRdHLiOyyEzkWyQgea3cfpk0dRD64jAmmMJzvdPsF1Ovd+iMQUt6KrRcUvMnjxUiHH9cjEWeED6iwRiu67/4OwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F32D4169E;
	Sun, 16 Feb 2025 20:22:52 -0800 (PST)
Received: from a077893.blr.arm.com (unknown [10.162.16.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A3D693F59E;
	Sun, 16 Feb 2025 20:22:29 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: steven.price@arm.com,
	christophe.leroy@csgroup.eu,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH V2 1/5] configs: Drop GENERIC_PTDUMP from debug.config
Date: Mon, 17 Feb 2025 09:52:16 +0530
Message-Id: <20250217042220.32920-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250217042220.32920-1-anshuman.khandual@arm.com>
References: <20250217042220.32920-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The platforms that support GENERIC_PTDUMP select the config explicitly. But
enabling this feature on platforms that don't really support - does nothing
or might cause a build failure. Hence just drop GENERIC_PTDUMP from generic
debug.config

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 kernel/configs/debug.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/configs/debug.config b/kernel/configs/debug.config
index 20552f163930..8aafd050b754 100644
--- a/kernel/configs/debug.config
+++ b/kernel/configs/debug.config
@@ -73,7 +73,6 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_VM_PGFLAGS=y
 CONFIG_DEBUG_VM_RB=y
 CONFIG_DEBUG_VM_VMACACHE=y
-CONFIG_GENERIC_PTDUMP=y
 CONFIG_KASAN=y
 CONFIG_KASAN_GENERIC=y
 CONFIG_KASAN_INLINE=y
-- 
2.25.1

