Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2B13D525D
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022403; cv=none; b=KrdD9kEsHKolKkH6roK4KSmsoQ5nr0mCxWD5KMICPRXSUd0yS0PrH2DhpevS6imnnsYepjPMAeJ/RX5eLo6TGUroUQMiDR3ctPd1b+qzVRMbi/KJmtzyjciJ1blOaeBTTXbluQR5Zdamlhsnk2P5yaX+gr4dnSSiPml2dnkjeys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022403; c=relaxed/simple;
	bh=6Su2ju/+w/yEEKHlGg0/wcLWb+gqmIQJG1WmKMqzHHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lBbVmNkoEjoskt4G/GLbE7rF4uF8zDODTaZgIDbVTswEidztnEC7jh4/3RvMncFwOcklqIEz+oR/1Vjj7rc/FlylEwBkK1mSiCOJ4y46865FWw0vNV+zqDqZ5iHcKTxQqUHWTdQoi31srhjckaz42fnY6qDvs1A8t569QvzhD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA9E21596;
	Wed, 21 Jan 2026 11:06:34 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 214B13F632;
	Wed, 21 Jan 2026 11:06:38 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	scott@os.amperecomputing.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	mark.rutland@arm.com,
	arnd@arndb.de,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v12 4/7] KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
Date: Wed, 21 Jan 2026 19:06:19 +0000
Message-Id: <20260121190622.2218669-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260121190622.2218669-1-yeoreum.yun@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add test coverage for FEAT_LSUI.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index c4815d365816..0b1714aa127c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -125,6 +125,7 @@ static const struct reg_ftr_bits ftr_id_aa64isar2_el1[] = {
 
 static const struct reg_ftr_bits ftr_id_aa64isar3_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FPRCVT, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, LSUI, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, LSFE, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FAMINMAX, 0),
 	REG_FTR_END,
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

