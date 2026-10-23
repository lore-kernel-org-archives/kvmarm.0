Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789043;
	b=pBUHVQqDnn98ED7TKD9fWluD6xjnfdea7Uh2xGL4slPxSkX4+HI+8wYqXvn0hAnNOEVx
	 o/qGmwoySBCvdVpSA4ttPrdO02jyamsWt5tKoIOnV0RQG5n18qGETZXiuRfoEIxNIazgs
	 L8PDW91bpigZj/ma5SMstbrKrTz/uDj90beijM/PjMMAe6ibSmwUDAKJZclo1bVmTArS8
	 lcX7GqPqyn838t/kPZ1UqYphL4GuIBzZ3lTeQu4MJPUBBBcY9E6Y2PTWdbyQRuB8Ot/xl
	 ZTFPr0tIe0ab6VAhLcN+xRddeEhdk8MgOEpMRnGtDeJdpFrCrYqy6HgIylrZj40ydKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JLqgmXnujiSxnp7UgJaC30DdEE9z548tSjXSFR2BlK8=;
	b=yiGKlJg9lUJR5Gs7GtGknC7eC6cMLy1LuxgBRPHlT1pT5K4ZykQ0UJ7d6R6KYpd7emVg
	 jWV3iDflkS182d9kj8QrBYmv8XVD2wJOAf3g/8qqCi431ltyDcdpV9akCurlfkmJgHB4Z
	 Dakc1esQv89/MX+HbeJa1a0b9n3OWmCqI4jsmCiqIkQjLpYkW/oo4/bKmlku+J+AcINri
	 0nVNGhyHnDQTxGljYa7w/OklLSBZz1/WPSo/r+zEYJQrdi2oyOnFt6vDdPZYjPBDl1lGF
	 tjF41ns3gg7LBZqgN9WiwSmz+mkkudmjjAoT1ntoiy8II8hCec4R+Xlli24DOzwJScg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ksQkWox0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE57606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ksQkWox0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B600A1F031ED;
	Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789042;
	bh=JLqgmXnujiSxnp7UgJaC30DdEE9z548tSjXSFR2BlK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksQkWox0x0pgE8EJqy2JDtdOvKK9wnih3NX7kRU0+9wlC8eKAomTDsSjhztcfj8id
	 miwHsclmkoG8TXS5O/STcFgBR8JnSd+Bjx/r5HTDMex37TBbSjejeDcbdD7MiVZCLF
	 kSfh3iDYGE01oPe1gqkmd21llmCj+b3/owg47gSQd7AY3tBq2W6L4Rl1S+scFoZcLt
	 3Dj8win6yforURnzlkCtOkgA5rBKPRKj4xwv4umOC2GTO6ZZfHrpHoj5MopoXQIK1A
	 O5mGnac+vohdvNLE2O4kKIpbCoGP5EpWer865+x/YWYkKMYdzWOnmA5lAiFgzeC6FR
	 FkKMASzHfSC0w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 27/28] KVM: arm64: Add tracepoints for S1 page table walk
Date: Fri, 23 Oct 2026 13:56:09 -0700
Message-ID: <20261023205610.1044532-28-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MMU walk steps are a useful tidbit of information for KVM hackers. As
these events are far closer to modelling CPU architecture than exposing
KVM internals it clears the bar for adding tracepoints.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  8 +++++
 arch/arm64/kvm/at.c                 | 18 +++++-----
 arch/arm64/kvm/trace_arm.h          | 52 +++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 81d8b1676fe4..341604b619cc 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -343,6 +343,14 @@ struct s1_walk_info {
 	bool			haft;
 };
 
+struct s1_walk_step {
+	u64			desc;
+	u64			desc_ipa;
+	u64			desc_pa;
+	struct kvm_s2_trans	s2_trans;
+	int			level;
+};
+
 struct s1_walk_result {
 	union {
 		struct {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8f1be3af64e8..1a49eb3c288a 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -11,6 +11,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/lsui.h>
 
+#include "trace.h"
+
 static int get_ia_size(struct s1_walk_info *wi)
 {
 	return 64 - wi->txsz;
@@ -433,14 +435,6 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	return -EFAULT;
 }
 
-struct s1_walk_step {
-	u64			desc;
-	u64			desc_ipa;
-	u64			desc_pa;
-	struct kvm_s2_trans	s2_trans;
-	int			level;
-};
-
 static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 			    struct s1_walk_info *wi)
 {
@@ -492,10 +486,10 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			      struct s1_walk_step *ws, struct s1_walk_result *wr,
 			      struct kvm_walk_access *access)
 {
-	u64 old, new;
+	u64 old, old_cpu, new;
 	int ret;
 
-	old = new = ws->desc;
+	old = old_cpu = new = ws->desc;
 
 	if (should_set_access_flag(wi, ws, access))
 		new |= PTE_AF;
@@ -529,6 +523,8 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		return ret;
 	}
 
+	trace_kvm_s1_desc_update(ws, access->ia, old_cpu);
+
 	wr->desc = ws->desc;
 	wr->dirty = !(wr->desc & PTE_RDONLY);
 	return 0;
@@ -614,6 +610,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			return ret;
 		}
 
+		trace_kvm_s1_walk_step(&ws, access->ia);
+
 		/* Invalid descriptor */
 		if (!(ws.desc & BIT(0)))
 			goto transfault;
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 9c60f6465c78..9fe9b57f6fa8 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -415,6 +415,58 @@ TRACE_EVENT(kvm_forward_sysreg_trap,
 		      sys_reg_Op2(__entry->sysreg))
 );
 
+TRACE_EVENT(kvm_s1_walk_step,
+	    TP_PROTO(struct s1_walk_step *ws, u64 ia),
+	    TP_ARGS(ws, ia),
+
+	    TP_STRUCT__entry(
+		__field(u64,	ia)
+		__field(u64,	desc)
+		__field(u64,	ipa)
+		__field(u64,	pa)
+		__field(int,	level)
+	    ),
+
+	    TP_fast_assign(
+		__entry->ia	= ia;
+		__entry->desc	= ws->desc;
+		__entry->ipa	= ws->desc_ipa;
+		__entry->pa	= ws->desc_pa;
+		__entry->level	= ws->level;
+	    ),
+
+	    TP_printk("ia: 0x%llx desc: 0x%llx ipa: 0x%llx pa: 0x%llx level: %d",
+		      __entry->ia, __entry->desc, __entry->ipa, __entry->pa,
+		      __entry->level)
+);
+
+TRACE_EVENT(kvm_s1_desc_update,
+	    TP_PROTO(struct s1_walk_step *ws, u64 ia, u64 old),
+	    TP_ARGS(ws, ia, old),
+
+	    TP_STRUCT__entry(
+		__field(u64,	ia)
+		__field(u64,	new)
+		__field(u64,	old)
+		__field(u64,	ipa)
+		__field(u64,	pa)
+		__field(int,	level)
+	    ),
+
+	    TP_fast_assign(
+		__entry->ia	= ia;
+		__entry->new	= ws->desc;
+		__entry->old	= old;
+		__entry->ipa	= ws->desc_ipa;
+		__entry->pa	= ws->desc_pa;
+		__entry->level	= ws->level;
+	    ),
+
+	    TP_printk("ia: 0x%llx new: 0x%llx old: 0x%llx ipa: 0x%llx pa: 0x%llx level: %d",
+		      __entry->ia, __entry->new, __entry->old, __entry->ipa,
+		      __entry->pa, __entry->level)
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.47.3

