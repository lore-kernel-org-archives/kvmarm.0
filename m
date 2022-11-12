Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F45184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB833C43140;
	Sat, 12 Nov 2022 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266265;
	bh=9uH1u6Lsa0+mQmDD5I8n2S2ulCJS9FJ7qCby/v7w4DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVbkA5mLJ4gQHsGadEKzYbth5tb+2F6lV+zAONfvR1TzuLLraHLE9Ld2I+n0m48yA
	 7lBXuy55nUb1VaVj0CU+V8OiSNwNNYU+sHq8b9Vk0hfdob3bnzfyg9Dtq2ZzDEZmHD
	 zdmzjo+Ibo+0cWMXQ9N4hlVIPVn9yLpFmT+X2ftMe/ZoB1+DTrEaZF0bQiypXIZYop
	 xmt6CvsQQosgFp3cdqVia2dySKdVH34/lHBJCN8w/QyfjSksB2hx8PmCyEGV4OPXoH
	 Y8NGPv5GCgqF+iomCtwhEcyOMl+Sa8Ygjoo/032Bjtjl3xnUZgVNP3QFxBrrbFZP7j
	 O/GJgTHtus2ag==
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
Subject: [PATCH v2 01/14] arm64/booting: Document boot requirements for FEAT_NMI
Date: Sat, 12 Nov 2022 15:16:55 +0000
Message-Id: <20221112151708.175147-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1024; i=broonie@kernel.org; h=from:subject; bh=9uH1u6Lsa0+mQmDD5I8n2S2ulCJS9FJ7qCby/v7w4DA=; b=owGbwMvMwMWocq27KDak/QLjabUkhuT8Hc/OXJQLZ0tf0aZ266m9i82dvcH39G7rFswt6VB49vbJ BBG5TkZjFgZGLgZZMUWWtc8yVqWHS2yd/2j+K5hBrEwgUxi4OAVgImtr2f+Zy6XKRNt8WW+YkH4/71 2Vif7BmR5lkuuFHDqlRSc5OE1anMDFUrvf8cvsYy8u7OgTkRdgz2Tx6ZDis+VOZb1VukDqjE2cMeOj FoHC0oeZOtcv5rHfK26ef7ffL7JR+25PTmuI6YPNfq8/2VQer3kepnNj6aRZj5MurWbZeYlFLzPigY 0h67eztc4l2luMdLoO9x/MPcG60KXz59uCtReuy7JoaO9oWFit+/SK+MPpGucYendzrFkif3/OG/Fk ruXr7P12vn6UtnfPCXb2oLqFN8M+SdjKTPSw2xvDtW6eLEOlgoyrQlVlV8ncTE6fnR/NvmgHPepvPL aoxGPW4vjE5FCjhrLAtNboNZeUAQ==
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

In order to use FEAT_NMI we must be able to use ALLINT, require that it
behave as though not trapped when it is present.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/arm64/booting.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index 8aefa1001ae5..77d037bc7bf3 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -360,6 +360,12 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HCR_EL2.ATA (bit 56) must be initialised to 0b1.
 
+ For CPUs with Non-maskable Interrupts (FEAT_NMI):
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+   - HCRX_EL2.TALLINT must be initialised to 0b0.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
-- 
2.30.2

