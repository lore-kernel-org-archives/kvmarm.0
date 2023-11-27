Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B091381B6;
	Mon, 27 Nov 2023 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghhtlGG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45E6C433CD;
	Mon, 27 Nov 2023 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701106004;
	bh=OZ0xz+tPj+uVKbyd3dsutFxXMsEOmGmF5yG9QPT/iuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghhtlGG5uG6BbHP2sK/ehis73IrLaRKD2dzk2d12KYVHsZCROJ8NQp01+LlIhQKuy
	 /z1P+RSK1+heyobfFumzvt5rAiF0WEsRqf7QBOcSogmVbmMLfUrmFEZNWkt2bwbv1n
	 CD3ULi2n80hRm5lFcVJ+sRf7ls28BqzSjcn+tNyi6Bcc2CPD19B5d5qX6zzdxU3s7S
	 6jX9oF9Hd0olC4+tCgBedFw4a0iyDP0B1LXBMYDJVWnO4HitZTUig1NXm7vZZEHSAl
	 6CV9h3TJKCYXzR4fV2JIu2z+Ddg+73hHa2Wk4Ss4Kz1fsPjN3t50qc9BSgIlXtjkeo
	 JEneLXDgY0Huw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7fNZ-00GsGj-UN;
	Mon, 27 Nov 2023 17:26:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
Date: Mon, 27 Nov 2023 17:26:13 +0000
Message-Id: <20231127172613.1490283-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127172613.1490283-1-maz@kernel.org>
References: <20231127172613.1490283-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We now have *two* values for CTR_EL0.L1Ip that are reserved.
Which makes things a bit awkward. In order to lift the ambiguity,
rename RESERVED (0b01) to RESERVED_AIVIVT, and VPIPT (0b00) to
RESERVED_VPIPT.

This makes it clear which of these meant what, and I'm sure
archeologists will find it useful...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 96cbeeab4eec..5a217e0fce45 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2004,9 +2004,10 @@ Field	27:24	CWG
 Field	23:20	ERG
 Field	19:16	DminLine
 Enum	15:14	L1Ip
-	0b00	VPIPT
+	# This was named as VPIPT in the ARM but now documented as reserved
+	0b00	RESERVED_VPIPT
 	# This is named as AIVIVT in the ARM but documented as reserved
-	0b01	RESERVED
+	0b01	RESERVED_AVIVT
 	0b10	VIPT
 	0b11	PIPT
 EndEnum
-- 
2.39.2

