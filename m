Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C212E6CCD
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321988; cv=none; b=qWJEagodnr03+jHMlW0h4i552s0q2QCc/QW1I4gJqooQ6nEhQ1+IWQLMe7XwVOcuBy57Vy+r72AQfPFnj5JYJmd0ALXLOUtLoIQVz+waMgLHizOXLEcYGaxBTsM2PKYISk2gWLOrIZMXHk9JxpepxnWIT7idf/cW/ZpL01IlsMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321988; c=relaxed/simple;
	bh=29KJvYtZhLDWSDN98h2HJ49voDEmV5ePH1jVPl+9zog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLcCyoBDFfz1iB21RmczCj0Jcr+HYXKYgL9zPTb9wZjJrvKGriyxgizYAxAq+UWxxREHtD9XfZle/5r/3sNvkUpUp84ML/g6gSldBWh3UZl01LXdzg1ykpQauXmr2dBd1Wug8iqN9pnxXYdZ0uR5iYaAX2X1BmvDgay33w3ZAaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=u8i/Gl88; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="u8i/Gl88"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3A7B1688;
	Wed, 29 Jul 2026 03:46:22 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EED7E3F66F;
	Wed, 29 Jul 2026 03:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785321986; bh=29KJvYtZhLDWSDN98h2HJ49voDEmV5ePH1jVPl+9zog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8i/Gl88D07lb5k4+Cgxsdi0M/R14ubYZK1UxBLc5XTDNRvyCulTwXzwdBsPzh9WO
	 7ZH4JnZC6Ysq/2yUDhZs1cX1HtLhTGA601OLFUb29zcdxUec/kSYiH3dMkBWcNqh8a
	 U6EdzPt7lGEEwYIFlD2OoNNWx71k9YDdo91OVYiA=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 03/11] arm64/sysreg: Add HACDBS consumer and base registers
Date: Wed, 29 Jul 2026 11:45:38 +0100
Message-ID: <20260729104548.3439958-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1258; i=leo.bras@arm.com; h=from:subject; bh=29KJvYtZhLDWSDN98h2HJ49voDEmV5ePH1jVPl+9zog=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb16ds/nkne4E/xide58mbtsRFRztXPs0rnV78f6D3 U/cc55adJSyMIhxMciKKbLIPpq/iuf7lIwjV34sgJnDygQyhIGLUwAmsiaKkWHl1b2y+czBz16f rqoT3TL/UOqDNa0bDf77etk76hxkY1di+F+cHSHeYBz0X40tUqhealZivuAUpS1nzJImiXzN2nU /lRcA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

They will be used on a later commit to make use of the FEAT_HACDBS
mechanism if available.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7cb61aca3797..50ec9751b44d 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4627,20 +4627,50 @@ EndEnum
 Enum	9:8	IRGN0
 	0b00	NC
 	0b01	WBWA
 	0b10	WT
 	0b11	WBnWA
 EndEnum
 Field	7:6	SL0
 Field	5:0	T0SZ
 EndSysreg
 
+Sysreg	HACDBSBR_EL2	3	4	2	3	4
+Res0	63:56
+Field	55:12	BADDR
+Field	11	EN
+Res0	10:4
+UnsignedEnum	3:0	SZ
+	0b0000	4K
+	0b0001	8K
+	0b0010	16K
+	0b0011	32K
+	0b0100	64K
+	0b0101	128K
+	0b0110	256K
+	0b0111	512K
+	0b1000	1M
+	0b1001	2M
+EndEnum
+EndSysreg
+
+Sysreg	HACDBSCONS_EL2	3	4	2	3	5
+UnsignedEnum	63:62	ERR_REASON
+	0b00	NOF
+	0b01	STRUCTF
+	0b10	IPAF
+	0b11	IPAHACF
+EndEnum
+Res0	61:19
+Field	18:0	INDEX
+EndSysreg
+
 Sysreg	GCSCR_EL2	3	4	2	5	0
 Fields	GCSCR_ELx
 EndSysreg
 
 Sysreg	GCSPR_EL2	3	4	2	5	1
 Fields	GCSPR_ELx
 EndSysreg
 
 Sysreg	HDBSSBR_EL2	3	4	2	3	2
 Res0	63:56
-- 
2.55.0

