Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17326FD3
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79449C433EF;
	Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557309;
	bh=w6QiTn7zYTau9bRp+OKtbhsItISXHdo0WaNc6bCcnf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1CtKK9ZORBatPTqyAySnYt/FkU2jYAocDBk7dbyAGHelxkoZYShqWUoj/kzLoL9W
	 qp+BVqGEUOzW0LSjGho9DMKPa4I2gqCvT0t214R0bUYJJV7+qXtS/EW5tvIqAzbUFw
	 wksuV7mwYttoSpxIDUbT6KMP0kmFoSChRButT8coHBsAwOaYxZIypiuoMVH8jSPkeW
	 fFHY9g1l9yT3WL8chPQaswBBEChFxeWwsw1oKNqU55lHdTJqrjwR9dSb1e3aHJ2KZV
	 NiizEqBsWTVSX2BeKrCFA2E2jx4y2944kVV6Zv/GWYQtLGzn5LHkrlWihWslP3qkI/
	 V1/+3s1KGcO5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8t-00AuwB-Dj;
	Thu, 16 Feb 2023 14:21:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	dwmw2@infradead.org
Subject: [PATCH 01/16] arm64: Add CNTPOFF_EL2 register definition
Date: Thu, 16 Feb 2023 14:21:08 +0000
Message-Id: <20230216142123.2638675-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the definition for CNTPOFF_EL2 in the description file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 330569fb2336..e930820cface 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1812,6 +1812,10 @@ Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
 
+Sysreg	CNTPOFF_EL2	3	4	14	0	6
+Field	63:0	PhysicalOffset
+EndSysreg
+
 Sysreg	CPACR_EL12	3	5	1	0	2
 Fields	CPACR_ELx
 EndSysreg
-- 
2.34.1

