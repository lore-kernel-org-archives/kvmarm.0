Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED816AB3
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 13:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0CAC433B5;
	Tue,  6 Dec 2022 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670332344;
	bh=AVe3iiTcAbKWYIlJRS5PBz2jo1fL/vp6GINYGTQfy/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/n9oRjWp3hVoZkKoFtw44s+n8U05UfdmNuN8tUuZLtm+k/hQ6X/0Idt8++DeeMZD
	 I3RrBj4s37ig9GtHOL9kXN8o0DW4D7wp3QztNVivIBj37uzJOLmGzqir0Ha8MzWWdm
	 NFvf0xTgH90IRKTXXfz8oAa8F6PM2hGaadYQGs+XpJsfex5CGEccCICLOB9GobjFjq
	 rt8IOWH1Q8IYp873GolOeDVXRMBqTPrtQbtm2RdcEsM4d/F+pE+dulmXL9TLJGIRzd
	 1MtW1KTVkFy4tycNeVRLQv5FimvVELezUWr/1N3U6WU81Txgwcz0xW3w7sUHEUIToi
	 6HISLorjSCvng==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 3/3] KVM: arm64: Use symbolic definition for ISR_EL1.A
Date: Tue,  6 Dec 2022 13:11:44 +0000
Message-Id: <20221206131144.115774-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221206131144.115774-1-broonie@kernel.org>
References: <20221206131144.115774-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=785; i=broonie@kernel.org; h=from:subject; bh=AVe3iiTcAbKWYIlJRS5PBz2jo1fL/vp6GINYGTQfy/0=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjjz+PEDbA0FWCwhiG58UgillOZPpPuoxIY+XVoNlP Zkzt/hmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY48/jwAKCRAk1otyXVSH0J+LB/ 995JdhCfzbXIRne8vdTjY8reBTt6cnMe01V8k2YY3RYVnq3pAzL9X1kSGRujf5kvO7r1FabBUitZrT 04z8IsKj2dL1TkpPgycE15+qp2lRfHV6k6f9cMQgsBqJeA1FFaNCUIJXyH7erhvItDrc8TbIZUDkaI Ju5W71KUJiZ+8ipTvnBEvJVYWJZb8pF4JUSY+GQXr3QlaBPKWN6M3njAt7Kl5SOpqG49nusHv5bxX+ YtNO+wj59crPS2V8Dphgx5DWnzGj3vm70lu/bDQPQTwZxH502Y5lv2U9ZLcgziYM2PSO6zA7NFDMUm 1v1eWxApmk+ISBiftXyb2s4MWYHMQN
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Now that we are generating ISR_EL1 we have acquired a constant for
ISR_EL1.A, use it rather than the magic number we had been using in the KVM
entry code.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 435346ea1504..f3aa7738b477 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -171,7 +171,7 @@ alternative_else
 	dsb	sy		// Synchronize against in-flight ld/st
 	isb			// Prevent an early read of side-effect free ISR
 	mrs	x2, isr_el1
-	tbnz	x2, #8, 2f	// ISR_EL1.A
+	tbnz	x2, #ISR_EL1_A_SHIFT, 2f
 	ret
 	nop
 2:
-- 
2.30.2

