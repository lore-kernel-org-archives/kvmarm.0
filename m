Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B570C184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1009BC43143;
	Sat, 12 Nov 2022 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266296;
	bh=daABjd+kflWq13DdhQ96e83tBfJRfPZkW2HyNNDnFxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt2rjkEa5T9ruxJIoubvGT5XZL5HMPwH8UuF575UGVLq+hdY2MJZukGYsYBzwK36H
	 Gt6YBXBHNMLM2AZtlPbnd2aGJ0ntCT/wSOSV/Gx+t4cVpXdQlVZihMdXa+eP8z2XtJ
	 Y0P5D8aDLFhK7MgD4RW2UJw1FUI+6YtKNcon57BgkuaJVh+WXlm4pVNCXu38rkf9KK
	 E2xZ3ox0apa+uk89/yPRdLzuzvRleFkBxQgjgaydZEwlooZm+V/o0OSmeIsZ7c1VyR
	 dr0/8X3LjWVIjZTwRj0qRvo+pTEY7A8wCy0c4gswU2N5yKgdK2T7gqCV4zVRal2GVa
	 yyYN/M75cA5eQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 11/14] arm64/irq: Document handling of FEAT_NMI in irqflags.h
Date: Sat, 12 Nov 2022 15:17:05 +0000
Message-Id: <20221112151708.175147-12-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1449; i=broonie@kernel.org; h=from:subject; bh=daABjd+kflWq13DdhQ96e83tBfJRfPZkW2HyNNDnFxc=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jwbD8fovHWsavM993v7ks85Y7Z3REem4bFJ80x bdNhjxuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+48AAKCRAk1otyXVSH0PHSB/ 0RKj4XVIkEC3qRnpiQctZUZwbpO2T98fmzzplPdXRoRRT7c/8PAjnxoSRKgE6yOq4GTK/2hGL44uBi Esrqjv9urN7W1McSaka8q3JI5e6KLlRGNckO4L8vhjmFUJ62mL2sseN5EahajSZLMVsMga2l8MPQTb arRU7JrVvuXaatfyyWXcmODU+EcdOe29NS9oWwv2XQQOaSOi3xiwTT4S/FnHgMp+VYVKk1Odzyd2fC RxY1BEOIP/fj1zDbgv0N02Jn2kFJtsJ1Q1qL/axAXSyXH6czJikrEoBHmpG8TU0D1Xt4AqN9uCMNlD BEqoOto8r1wZ4rTG4nKYJVlpkF6sbM
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

We have documentation at the top of irqflags.h which explains the DAIF
masking. Since the additional masking with NMIs is related and also
covers the IF in DAIF extend the comment to note what's going on with NMIs
though none of the code in irqflags.h is updated to handle NMIs.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/irqflags.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index b57b9b1e4344..e3f68db456e3 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -19,6 +19,16 @@
  * always masked and unmasked together, and have no side effects for other
  * flags. Keeping to this order makes it easier for entry.S to know which
  * exceptions should be unmasked.
+ *
+ * With the addition of the FEAT_NMI extension we gain an additional
+ * class of superpriority IRQ/FIQ which is separately masked with a
+ * choice of modes controlled by SCTLR_ELn.{SPINTMASK,NMI}.  Linux
+ * sets SPINTMASK to 0 and NMI to 1 which results in ALLINT.ALLINT
+ * masking both superpriority interrupts and IRQ/FIQ regardless of the
+ * I and F settings. Since these superpriority interrupts are being
+ * used as NMIs we do not include them in the interrupt masking here,
+ * anything that requires that NMIs be masked needs to explicitly do
+ * so.
  */
 
 /*
-- 
2.30.2

