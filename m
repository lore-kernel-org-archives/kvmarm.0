Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DF413A3F7
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 05:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738559345; cv=none; b=TYQGOT05vrUSN7HsdHdSJE05w0BHP0Tm04Fdi7j2pyEBw7i/7k8+TH8fRelgGD3bEBrlQnmbfghRFqEMRoWDuiqBkW82KqkiWKBJ5dniUJN2raZQYpeNaCRkx3Oxtmt2ikFIxB7Aw5wb4fqskpYy7JvSkn5oxd1B7eP01tNt8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738559345; c=relaxed/simple;
	bh=/znT8QcSNFaU6D45Rblq8j92/ABliCuQOw9A/91axB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SLoud+7F8KWVx5j+TgiZWhprTQJQrXZJekSi1us2mA+EOzRD3lIDaTrdeD/ilWk2I5rFhjlFOhjzoSqb+MTPgXnIdBHJTN+xDNWT/69nLa3kyb27xaHR4OWesMcFSbyOLSOiiwRsize1qAtf03ZDVPESrmK89Dfudssp7+JeNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95FC41476;
	Sun,  2 Feb 2025 21:09:27 -0800 (PST)
Received: from a077893.blr.arm.com (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB8623F5A1;
	Sun,  2 Feb 2025 21:08:58 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH V2 4/7] arm64/sysreg: Add register fields for HFGITR2_EL2
Date: Mon,  3 Feb 2025 10:38:25 +0530
Message-Id: <20250203050828.1049370-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250203050828.1049370-1-anshuman.khandual@arm.com>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for HFGITR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f1c366866c93..0008ff35a655 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2872,6 +2872,12 @@ Field	1	AMEVCNTR00_EL0
 Field	0	AMCNTEN0
 EndSysreg
 
+Sysreg	HFGITR2_EL2	3	4	3	1	7
+Res0	63:2
+Field	1	nDCCIVAPS
+Field	0	TSBCSYNC
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg
-- 
2.25.1

