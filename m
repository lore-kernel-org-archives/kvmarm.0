Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE7A33D9
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 17:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58521C433F0;
	Tue, 27 Dec 2022 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672160736;
	bh=qsXdvuxsIsQ0RJ6r2ryN12iEQ7awbL7XBJ6twbWpy0M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RTzNt5SubQ47XEdE5i7Db6/ySJ1yGTUKnJiCtI8gw3GvvEkKJSSBuzPeC2D/SFbPk
	 UGyYP71hECx1vR5R/NHUHwQmOJXWsDvYczcFHmjiKS0Rc21S5hRwaYCPfw10bwF8YT
	 KY6qE+yOSev5u8C+mmur8XZpRn3StznZ4jwqq85hVrid/5vfbvhr1CxUcKjM6vhL76
	 WHfTVrLgCQNSVX0SYmbfirTLic6d9GFC3CfIt1TEnxasNXqepcuTB8TVjBSC2g30Cw
	 VpVoEZIAEHILQYsF3jHH29qi8aOc7YGzb7e2abpkqGVpJZDXcKzkUBF0C6LPjDop8i
	 IsRP3+9eEAuHg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 17:05:05 +0000
Subject: [PATCH v2 3/3] KVM: arm64: Use symbolic definition for ISR_EL1.A
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221208-arm64-isr-el1-v2-3-89f7073a1ca9@kernel.org>
References: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
In-Reply-To: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qsXdvuxsIsQ0RJ6r2ryN12iEQ7awbL7XBJ6twbWpy0M=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqyXZUsFPCghBp31WO9f0pNOe2wRT/ucx6EDQktXG
 T6JCrbWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sl2QAKCRAk1otyXVSH0EdqB/
 9EaUv/a5mcIA/DKN3fXJ7Ys2HkyT9PsDW4sMLQlXG2KVRjxdZl0z1iDNJaIt5bdbQRAfMIEgmUCpHh
 2mfXlWzQ4ApSGJko43miI2obvGop0OVpQWAg6JsvUr/nKcEkVHT2GhhPeeEzDGE3Br6qi1AbXnbpQ2
 6cbd0gOTLhRE6Fz7DO2O5TWR7Z5L7uyh+jX6JPY6eX4QcOfC3AAklZ6wm2yQhJrob9vy3WEw4uA0XZ
 ScCZzH4LwJrHLHpwfnFUqo28rHt0/eL/3HkEEJ7VXIy3At1V9Dla6TOZusrN7PdecWafh6epJY2kNz
 SDd+19xEflwN+lK2ean5XRt8W7dt7N
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that we are generating ISR_EL1 we have acquired a constant for
ISR_EL1.A, use it rather than the magic number we had been using in the KVM
entry code.

Suggested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
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
