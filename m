Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B765351FD7
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819777; cv=none; b=cPMRoSpLOCYtSkW+3bfVdM4n/By2nWTIFTCnTXMLOxD76d1guc+MuPGQlFR+B7WqNb79WQSaUw1FwAwRS1hFFDa1uvOvcR/Dwq6UF/1WFaaO/xbj+hdAx1t/8qVMdrK02Gh49h0YCEhRv3vBs95CbsrxU+wm6S4ECejQnhudmtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819777; c=relaxed/simple;
	bh=DcnX957JuOPks+rDX8maDPbDJIJHIws9n5FXx0tfNS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fo3rhF24ELMHA1+1OnXb/8pLoU4YvHHZ0FmM28Jfx71QaGDvlJrqp8r4micuSftGviqu6v2puGu4oOQzJ2Oz/qduB4MAUybJ8mJLfTG2VMd5sgQkFdN5WnxfqMQiKeh3UrsSLFVc3McHcYJMO+xpwuC0S7kGBBajTam9WnvxqmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A50F2C42;
	Thu, 30 Oct 2025 03:22:47 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 01BEE3F66E;
	Thu, 30 Oct 2025 03:22:52 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	perlarsen@google.com,
	ayrton@google.com,
	ben.horgan@arm.com,
	sudeep.holla@arm.com,
	stuart.yoder@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 2/2] KVM: arm64: support some optional calls of FF-A v1.2
Date: Thu, 30 Oct 2025 10:22:45 +0000
Message-Id: <20251030102245.2313898-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251030102245.2313898-1-yeoreum.yun@arm.com>
References: <20251030102245.2313898-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support drivers or components that implement their services using
FFA_DIRECT_REQ2/FFA_DIRECT_RESP2 (e.g., the TPM driver using CRB over FF-A)
and obtain related partition information via FFA_PARTITION_INFO_GET_REG,
enable pKVM to support both FFA_DIRECT_REQ2/FFA_DIRECT_RESP2
and FFA_PARTITION_INFO_GET_REG.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 0ae87ff61758..81e8b33bbdd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -679,10 +679,7 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
-	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
-	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
 	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
-	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
 		return false;
 	}
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

