Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07438184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B701CC43140;
	Sat, 12 Nov 2022 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266301;
	bh=5LAFSlhVVSHgoiuI1PFLdgHFp3aEnwArEDfa+ZFd/yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw/BnIhOKmDE9ibNHke1kYTd1TqVZ2qqd7HJBbgAXnLPZJJHDXEkBb6vXq2dkAq9J
	 HoxECn7ZPpGWngA7GFvf2fT4YJtQ+S1uj59KDp63qHYWN9BixGyCnUmQizWrbNz7zK
	 aSsnxxjPFSfqszwA2i6Gp4VqK0xaC10vCqaPQfzZd4H0cHsnCsDe1WvnkOhDACiV61
	 ToycdEQrCUKfiRY6wuK0KF7kxD8PAHh6KslV4NSBc7gF7z4pGGN19u07zTkcwrbaPh
	 lbea3QyD0zYn9mAq/Ce1eT1w3/0m5vEJseIEI4c9xDDocelIeZWQFzlN6WCLF2gHRN
	 AREqgWDkuenww==
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
Subject: [PATCH v2 13/14] arm64/nmi: Add Kconfig for NMI
Date: Sat, 12 Nov 2022 15:17:07 +0000
Message-Id: <20221112151708.175147-14-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1291; i=broonie@kernel.org; h=from:subject; bh=5LAFSlhVVSHgoiuI1PFLdgHFp3aEnwArEDfa+ZFd/yY=; b=owGbwMvMwMWocq27KDak/QLjabUkhuT8HZ/0+G7+UhL687mi7XThdsGmsCMCy9w2Sz5kqzB5oZF9 h3dyJ6MxCwMjF4OsmCLL2mcZq9LDJbbOfzT/FcwgViaQKQxcnAIwkQ4xDobWvffqRUSnG24Pa829M/ 9fvFjAY5PlZoW/jy7Y711Waxv0yZvjLVtT6ZQwe4f1kjxTrjy7O1XmI+NebsPgoDt7v7Mw7Z9vc9es 55xEfxFvBEvTDxvGRbo/dTlrjY6uuW20fbuvwfTySIlp7L/mTPi/aWr1I/7fxlracaFxBsVaBQeO37 i+TGK1G3vKDbn/BhYCu/sl5a2Uovi1suZMWH04cY56e/ZLJnm7RlX3KOvbfpNlOa2zWqpyvK5kJZl9 Ydv/nq0k72Ke7UrjBU7t9/jq+BfqV7Nw/lh2rXR+dJq0pfhME83uVwJ8q6axs4azLTvo8o1/+q6lF4 1SxOycb0XmJv4uW30zfVqSj/MyAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Since NMI handling is in some fairly hot paths we provide a Kconfig option
which allows support to be compiled out when not needed.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 505c8a1ccbe0..dd987a9a4f81 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2001,6 +2001,23 @@ config ARM64_EPAN
 	  if the cpu does not implement the feature.
 endmenu # "ARMv8.7 architectural features"
 
+menu "ARMv8.8 architectural features"
+
+config ARM64_NMI
+	bool "Enable support for Non-maskable Interrupts (NMI)"
+	default y
+	help
+	  Non-maskable interrupts are an architecture and GIC feature
+	  which allow the system to configure some interrupts to be
+	  configured to have superpriority, allowing them to be handled
+	  before other interrupts and masked for shorter periods of time.
+
+	  The feature is detected at runtime, and will remain disabled
+	  if the cpu does not implement the feature. It will also be
+	  disabled if pseudo NMIs are enabled at runtime.
+
+endmenu # "ARMv8.8 architectural features"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
2.30.2

