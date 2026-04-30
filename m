Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A0C407560;
	Thu, 30 Apr 2026 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547739; cv=none; b=WVynXd0jRE62/0LH+3otK7b3583eHGZX36JM9XwBaiklria6ZwdEsJRAbpJfQas8cOs1+PfGrC6KOF+CuM/+qpT5gk9cUWtAcaeZbfcbVxkdUWthmz1NElwEeWC9Y4tQSRuO27lBi3QvCxJnFhcAoPysrMPV4IA50Pf+sHFrD2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547739; c=relaxed/simple;
	bh=gfrKgtXGA9jbSPGpNbN2YuT5jDSPo32v7BItwOrMJ6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeihLc7LQP/521FpXvmKIJ+7axO1DPcelrows1mPJXD6TGwTrXuP7Pg0Mnu5DnWb16sfDduA/tCrzcmhOCgK/9vEe7gR1vZMRkZbl7tDqBcugenRxVlI0dxWudAPfogrZzbLGSy7OAyLfwH5JpSl5f2tMYJxbCCFEkDnZD/ltVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WzcC5e8a; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WzcC5e8a"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66D743547;
	Thu, 30 Apr 2026 04:15:32 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D7723F763;
	Thu, 30 Apr 2026 04:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547737; bh=gfrKgtXGA9jbSPGpNbN2YuT5jDSPo32v7BItwOrMJ6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzcC5e8aL5JvmjSDzEtK6LU52kY92jTkYQUdQus06jIGlfM2QzMb1ZF50zwPdtHdL
	 txKodUqFM+OA+K3tdIslPl74Yrqp/NKOHH7S93Z40+fND3y8Bh4n3qFD5GMF/+yccX
	 eXXg/NptcueB0TnV/K3ziiwsW/6AGDXQtzK4+KYw=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 04/12] arm64/sysreg: Add HACDBS consumer and base registers
Date: Thu, 30 Apr 2026 12:14:08 +0100
Message-ID: <20260430111424.3479613-6-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They will be used on a later commit to make use of the FEAT_HACDBS
mechanism if available.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/tools/sysreg | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6c3ff14e561e..7ad392a5c436 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4582,20 +4582,50 @@ EndEnum
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
 
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
-- 
2.54.0

