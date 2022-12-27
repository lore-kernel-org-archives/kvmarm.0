Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274133EC
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 17:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A406BC433EF;
	Tue, 27 Dec 2022 17:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672160734;
	bh=59MW3jDG6SzKt76zf7ae45LVgTLIIT1AOdGRTFHApSE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VeCRZBXOkUaIZb1urVcBiExcM9timMIjCGTUzl0m8Kw3xCoHW+OyYTLhMRKkhLozR
	 Brcu2pWJZB00k/r+5tO6IkoKSqtmw4y6FM2VAFZFJxFwJsfwssLsL7SuGlztL1LPFV
	 5HmmlF3IDGyWoFqqvYOXhz76iHReyYSXEOxGcCMqRdu3oLrJ5x5IoUNLKPGR5iPc1b
	 jfmPbRWo+VKK2zqQFRz8gB43tt7h0WNvwrVKtA01GBefdD1ubnea8wugpzgRe5pV9e
	 G/cg+uZxLJYUh1Ne+EDQHUpVmCdI7OyFrxLFQNw9oU8iWFqxRF2MOW5EkB5E593P1Q
	 pWeO2PjpqfnUg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 17:05:04 +0000
Subject: [PATCH v2 2/3] arm64/sysreg: Add definition of ISR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221208-arm64-isr-el1-v2-2-89f7073a1ca9@kernel.org>
References: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
In-Reply-To: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=744; i=broonie@kernel.org;
 h=from:subject:message-id; bh=59MW3jDG6SzKt76zf7ae45LVgTLIIT1AOdGRTFHApSE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqyXYyuMNkZ1RenGgwVNwkPiWqKbMjn4qd+R+pg7K
 lz/WW1yJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sl2AAKCRAk1otyXVSH0PcuB/
 9MC+YDnf5cbqHoEQ/Po6W9g+Ax64N28l+ui1e/wJvo5kqqKYo5/LQ6L23SdzPNEemcUseLO3s041ZH
 86WF7Yksb/sUGjsgb4eC4GM+P735t7lDnRynpMxb+/J+s357kzDG7RhU44l+D/rakuuQmmadcNkMPy
 9DrVOwSmvgDbDs9MHsQH1fLqHsjF4STlY7w2nef6FumMH1x8xUq3EZn7LQ8NFMEYJLMumck2Nit6FM
 W8PDvQWaopM5S5jwhcYWJJS85pQOBlWSzfAGa/DocfUgrxTNJ/iVtQDi37FuMkgTaKfZ1tRVtFh7Zs
 UQhPl3yXCKm9E4KdQKok8Z+ssIodm9
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Add a definition of ISR_EL1 as per DDI0487I.a. This register was not
previously defined in sysreg.h, no functional changes.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 50ef5e5bff02..fa7b76124dce 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1843,6 +1843,16 @@ Res0	15:8
 Field	7:0	LR
 EndSysreg
 
+Sysreg	ISR_EL1	3	0	12	1	0
+Res0	63:11
+Field	10	IS
+Field	9	FS
+Field	8	A
+Field	7	I
+Field	6	F
+Res0	5:0
+EndSysreg
+
 Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
 Res0	63:24
 Field	23:0	INTID

-- 
2.30.2
