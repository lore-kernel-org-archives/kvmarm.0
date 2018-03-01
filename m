From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 02/23] arm64: insn: Add N immediate encoding
Date: Thu,  1 Mar 2018 15:55:17 +0000
Message-ID: <20180301155538.26860-3-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We're missing the a way to generate the encoding of the N immediate,
which is only a single bit used in a number of instruction that take
an immediate.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
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
