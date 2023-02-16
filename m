Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8EC79C8
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 16:01:42 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 432C5113E;
	Thu, 16 Feb 2023 08:02:25 -0800 (PST)
Received: from e126864.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D02B3F881;
	Thu, 16 Feb 2023 08:01:39 -0800 (PST)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] arm64: mops: document boot requirements for MOPS
Date: Thu, 16 Feb 2023 16:00:06 +0000
Message-Id: <20230216160012.272345-5-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216160012.272345-1-kristina.martsenko@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_MOPS introduces new instructions, we require that these
instructions not execute as UNDEFINED when we identify that the feature
is supported. Additionally, the instructions may generate a Memory Copy
or Memory Set exception, we require that the exception be taken to EL1
in case EL2 is not able to correctly handle it.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 Documentation/arm64/booting.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index ffeccdd6bdac..f3913ee94c42 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -379,6 +379,14 @@ Before jumping into the kernel, the following conditions must be met:
 
     - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
 
+  For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HCRX_EL2.MSCEn (bit 11) must be initialised to 0b1.
+
+    - HCRX_EL2.MCE2 (bit 10) must be initialised to 0b0.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
-- 
2.25.1

