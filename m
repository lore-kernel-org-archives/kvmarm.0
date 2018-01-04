From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 06/19] arm64: insn: Add N immediate encoding
Date: Thu,  4 Jan 2018 18:43:21 +0000
Message-ID: <20180104184334.16571-7-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B28A49DD0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j3ClzYFGihOB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jan 2018 13:39:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50DEA49DC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:32 -0500 (EST)
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We're missing the a way to generate the encoding of the N immediate,
which is only a single bit used in a number of instruction that take
an immediate.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/insn.h | 1 +
 arch/arm64/kernel/insn.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 4214c38d016b..21fffdd290a3 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -70,6 +70,7 @@ enum aarch64_insn_imm_type {
 	AARCH64_INSN_IMM_6,
 	AARCH64_INSN_IMM_S,
 	AARCH64_INSN_IMM_R,
+	AARCH64_INSN_IMM_N,
 	AARCH64_INSN_IMM_MAX
 };
 
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 2718a77da165..7e432662d454 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -343,6 +343,10 @@ static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
 		mask = BIT(6) - 1;
 		shift = 16;
 		break;
+	case AARCH64_INSN_IMM_N:
+		mask = 1;
+		shift = 22;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.14.2
