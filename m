Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699B527714
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 16:10:29 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 933731BCB;
	Tue, 30 May 2023 09:11:14 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 497013F663;
	Tue, 30 May 2023 09:10:28 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 30/32] arm64: debug: Make inline assembly symbols global
Date: Tue, 30 May 2023 17:09:22 +0100
Message-Id: <20230530160924.82158-31-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

efi binaries need to be compiled with fPIC. To allow symbols defined in
inline assembly to be correctly resolved, this patch makes them globally
visibile to the linker.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/debug.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arm/debug.c b/arm/debug.c
index b3e9749c..572786a9 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -292,11 +292,14 @@ static noinline void test_hw_bp(bool migrate)
 	hw_bp_idx = 0;
 
 	/* Trap on up to 16 debug exception unmask instructions. */
-	asm volatile("hw_bp0:\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n");
+	asm volatile(
+		".globl hw_bp0\n"
+		"hw_bp0:\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+		);
 
 	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4)
 		report(hw_bp_addr[i] == addr, "hw breakpoint: %d", i);
@@ -367,11 +370,14 @@ static noinline void test_ss(bool migrate)
 
 	asm volatile("msr daifclr, #8");
 
-	asm volatile("ss_start:\n"
+	asm volatile(
+		".globl ss_start\n"
+		"ss_start:\n"
 			"mrs x0, esr_el1\n"
 			"add x0, x0, #1\n"
 			"msr daifset, #8\n"
-			: : : "x0");
+			: : : "x0"
+		);
 
 	report(ss_addr[0] == (uint64_t)&ss_start, "single step");
 }
-- 
2.25.1

