Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B39C46B7
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 16:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628CAC4339C;
	Mon, 16 Jan 2023 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673885124;
	bh=IwlP1zTtdDEXP13nca0TcxuYokqwXTKVt5zvoPFvoIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lwcn2jHzgNL0/r4m83r0COpclgwtGlvCKLVJuHfYT/tuoeJyfSMv/1rnw9vUXtwuv
	 0xW17WqjCEeOzv6UqLKnx7EhCqscCQ4dKUNgc8523ysGTtLaifX52bqM5RqRxz/u7b
	 iRDp4ftvb63f/aL4lb1KBS19B/h2cr1LyF5KGdkYywevNziMLaywbzm7L10lRo1MAi
	 T/myfLMB1qWexG6WVwYQGXA0ldNlYFGkGnzNpySLWP/eXuHPvNsXXI4CYhvaaQd0Xc
	 UkWLzGq0BgDwjvtbnSQQrfkilift+w7Nk9ROCBJrPLp6uch/oWLcSZ2tL4Ge89j5mi
	 w50KjSvJ9R+fg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 16 Jan 2023 16:04:37 +0000
Subject: [PATCH v4 02/21] arm64: Document boot requirements for SME 2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221208-arm64-sme2-v4-2-f2fa0aef982f@kernel.org>
References: <20221208-arm64-sme2-v4-0-f2fa0aef982f@kernel.org>
In-Reply-To: <20221208-arm64-sme2-v4-0-f2fa0aef982f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Alan Hayward <alan.hayward@arm.com>, 
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-77e06
X-Developer-Signature: v=1; a=openpgp-sha256; l=1168; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IwlP1zTtdDEXP13nca0TcxuYokqwXTKVt5zvoPFvoIE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjxXWjhCRnkVL1FiHVSNT2JrW2P727WtfisQJsrvsx
 wmHTCi6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY8V1owAKCRAk1otyXVSH0HgKB/
 9BIM601dAgC7dKMiDgZyoQEGBDqxcPOLCcre8NszUJ5sMgRessyzdfezjGlHrjUTGJvziU5J39n+a/
 ARxYOYrPWJPlKxusEBj6RYTxZhPXKoCkatSMJr19oLmFmHUcUGh+ChlUqLORLQe8BSEbx+KNqNvug3
 Q0gfD3HUEj7VLKWY5WwzHhisemYovrMi984J+aVqDYN1XBznaE4fqx1kYmbogzWCM3LX9vKEaMGffd
 d42He29MGLC8oaFF4AVTtwOS8LS4Ez6ediUl2PKLe9wwWOm4ajuGOc7V2ofgkgJfnM8tnReDl6oTri
 K89HutEtc0I4Q/xKTg4CNCKVQQcnIk
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME 2 introduces the new ZT0 register, we require that access to this
reigster is not trapped when we identify that the feature is supported.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/arm64/booting.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index 96fe10ec6c24..f8d0a7288c73 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -369,6 +369,16 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HCR_EL2.ATA (bit 56) must be initialised to 0b1.
 
+  For CPUs with the Scalable Matrix Extension version 2 (FEAT_SME2):
+
+  - If EL3 is present:
+
+    - SMCR_EL3.EZT0 (bit 30) must be initialised to 0b1.
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+    - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented

-- 
2.34.1

