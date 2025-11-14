Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D52126E6F5
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136459; cv=none; b=lAz4pU2riFdHr6zGAG5o7LdEz6SgQnvsyxJp8zwJCeWNWmYJlXW754+haBxMLzyp2ScQkXc5Awb9OzImMVO3bYPxb6Aq8li0dr9ynJeyHCwtHXR0BqPHuZVPH2IyfXI334IpMFnUcktFPCxadBDmDq/IoVzZYsjQDg08AxysZq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136459; c=relaxed/simple;
	bh=ooU4JA9RBX7VdS8K0+7UAAWbktiCFHeYXVekh79PtqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7ZojbsBQYwpKSfSdhdAib4suRuapxmRRTqgIc0sCtqldlS9XPqs1icQ5qMW+3XSkh+twE6KFzIMkVhDWvpumNBv6l2VbsmuGwW57IxW7c9JfLy6TEsNoj+kFoYLXZXI8klzEb+sjoZ63n/13oLTp21RowMnRWJXC/WBT/yX/58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4487F106F;
	Fri, 14 Nov 2025 08:07:29 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCE1C3F5A1;
	Fri, 14 Nov 2025 08:07:34 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 01/35] arm64/sysreg: Add new SPE fields
Date: Fri, 14 Nov 2025 16:06:42 +0000
Message-ID: <20251114160717.163230-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the PMBSR_EL1.MSS2, PMBISR_EL1.MaxBuffSize, PMBLIMITR_EL1.nVM and
PMBIDR_EL1.AddrMode fields, which will be used by KVM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/tools/sysreg | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bb..1e7b69594f04 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3070,7 +3070,9 @@ EndSysreg
 
 Sysreg	PMBLIMITR_EL1	3	0	9	10	0
 Field	63:12	LIMIT
-Res0	11:6
+Res0	11:8
+Field	7	nVM
+Res0	6
 Field	5	PMFZ
 Res0	4:3
 Enum	2:1	FM
@@ -3085,7 +3087,8 @@ Field	63:0	PTR
 EndSysreg
 
 Sysreg	PMBSR_EL1	3	0	9	10	3
-Res0	63:32
+Res0	63:56
+Field	55:32	MSS2
 Enum	31:26	EC
 	0b000000	BUF
 	0b100100	FAULT_S1
@@ -3112,13 +3115,20 @@ Field	7:0	Attr
 EndSysreg
 
 Sysreg	PMBIDR_EL1	3	0	9	10	7
-Res0	63:12
+Res0	63:48
+Field	47:32	MaxBuffSize
+Res0	31:12
 Enum	11:8	EA
 	0b0000	NotDescribed
 	0b0001	Ignored
 	0b0010	SError
 EndEnum
-Res0	7:6
+Enum	7:6	AddrMode
+	0b00	VM_ONLY
+	0b01	BOTH
+	0b10	RESERVED
+	0b11	nVM_ONLY
+EndEnum
 Field	5	F
 Field	4	P
 Field	3:0	ALIGN
-- 
2.51.2

