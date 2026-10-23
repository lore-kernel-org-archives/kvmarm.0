Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789043;
	b=UEJPL6xbHJ4gL6dwkoHcsviX+s4rc6dGs0TO/9yE+Iv22ZgwhiUOfwNxM91oOd5rzfQz
	 lgwfHwkyz7BM9U5J9OPVr45CNrRfjWOosg4RlYBXjUnXvLm3lu2tqHRPDrMJsGQMKGrtc
	 PlHOQozX47G7XBLUo//3aNnAJPYVAkY71Z5Xf4vf+7/9uDIsFfPkJBV5ZekOnqIjQMzrS
	 nPO/6uXRH/UHpga/E/+tZv7Rn+pDzhKM+7tuQo91XV1pxP9rUjxs+kj9+YFDzWEHJJHmo
	 Fw20itGJB/up49xP7WOOPPU6k432/hc6guMuqB0FQkXBplC6/25YJ/3UDnza5xchGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Wbt3RQwolocWiEyQTabrNyibppr60/2Y7aKOGFqSOHw=;
	b=XpJWVBLs9QVd9BdQhFQdM6d9pp9JGNN8C8gtPXgqa0lN7vt+jyD1KlVEhYei5UCkjGRB
	 WgCl88tOc1nkXZquQmZWRqtA2ury2FwRjK3qaAMPeHOQqdhlRDAwOtZ97DO0W5GwORWmv
	 oCO0IfsuD1gH1o/geFETTe+cWwkXqrPCpst5XggR24e0mR0sNaf6nexaqywL1ATJgqJo+
	 GZ6/xkbLbOq8BsR2GYShO9o0zPjLp1Jcq8T4NJqN86WHBOLlLXUawGEul1fZAxXSzoZDr
	 1BiLOxBvYUzmlFl6yjLO+uiNp/kKOqzW9Cg90aiclH8upkmoY3Gqu5SNiFwXrHjyfxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQ6ibyDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A407606A324
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQ6ibyDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0198E1F031E2;
	Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789043;
	bh=Wbt3RQwolocWiEyQTabrNyibppr60/2Y7aKOGFqSOHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ6ibyDKVSn+q5pgaQ1ps88deqqtr/SQkKJpCvQJ//qPVy0/ZyJGTxOstdKE53/Aj
	 CeW/Z5wRfCM4pmTHpaQMgGLHwAVMZNAmvGiuz8TNzVlAXERmpjdzjhHLkG1yOcTIc9
	 7gPcBypansgDV6t4Pu/6o6HdBBQXcWT7S9K/xF8pV32Lw/hKig6fzqKDfD2D/3sbTx
	 2wpJArN/04O6pqIywgP2Gqpf+V7Ad+TLVlv2Jqd3++ijDw9Ob2c94Jfe/MdDKht6tJ
	 jA/+9F14NIZ8PYp4btkNvWiUs1mVXtZsUnSjiPE7Z+r//ikZbsG3joRxzdFNAeRBvS
	 R4/OtPY4vykew==
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
Subject: [PATCH v2 28/28] KVM: arm64: Add tracepoints for S2 page table walk
Date: Fri, 23 Oct 2026 13:56:10 -0700
Message-ID: <20261023205610.1044532-29-oupton@kernel.org>
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
 arch/arm64/include/asm/kvm_nested.h |  6 ++++
 arch/arm64/kvm/nested.c             | 14 ++++-----
 arch/arm64/kvm/trace_arm.h          | 47 +++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 341604b619cc..65dc411188cb 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -128,6 +128,12 @@ struct kvm_walk_access {
 	bool	write;
 };
 
+struct s2_walk_step {
+	u64		desc_pa;
+	u64		desc;
+	int		level;
+};
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
 			      struct kvm_s2_trans *result);
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0c468235f123..a04ab2200d36 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -17,6 +17,7 @@
 #include <asm/sysreg.h>
 
 #include "sys_regs.h"
+#include "trace.h"
 #include "vgic/vgic.h"
 
 struct vncr_tlb {
@@ -155,12 +156,6 @@ struct s2_walk_info {
 	bool		haft;
 };
 
-struct s2_walk_step {
-	u64		desc_pa;
-	u64		desc;
-	int		level;
-};
-
 static u32 compute_fsc(int level, u32 fsc)
 {
 	return fsc | (level & 0x3);
@@ -279,10 +274,10 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
 			      struct kvm_walk_access *access)
 {
-	u64 old, new;
+	u64 old, old_cpu, new;
 	int ret;
 
-	old = new = ws->desc;
+	old = old_cpu = new = ws->desc;
 
 	if (should_set_access_flag(wi, ws, access))
 		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
@@ -307,6 +302,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 	if (ret == -EAGAIN)
 		return ret;
 	if (!ret) {
+		trace_kvm_s2_desc_update(ws, access->ia, old_cpu);
 		out->desc = ws->desc;
 		out->dirty = out->desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 		return 0;
@@ -425,6 +421,8 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 			return ret;
 		}
 
+		trace_kvm_s2_walk_step(&ws, access->ia);
+
 		/* Check for valid descriptor at this point */
 		if (!(ws.desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 9fe9b57f6fa8..0bf1a0be2636 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -467,6 +467,53 @@ TRACE_EVENT(kvm_s1_desc_update,
 		      __entry->pa, __entry->level)
 );
 
+TRACE_EVENT(kvm_s2_walk_step,
+	    TP_PROTO(struct s2_walk_step *ws, u64 ia),
+	    TP_ARGS(ws, ia),
+
+	    TP_STRUCT__entry(
+		__field(u64,	ia)
+		__field(u64,	desc)
+		__field(u64,	pa)
+		__field(int,	level)
+	    ),
+
+	    TP_fast_assign(
+		__entry->ia	= ia;
+		__entry->desc	= ws->desc;
+		__entry->pa	= ws->desc_pa;
+		__entry->level	= ws->level;
+	    ),
+
+	    TP_printk("ia: 0x%llx desc: 0x%llx pa: 0x%llx level: %d",
+		      __entry->ia, __entry->desc, __entry->pa, __entry->level)
+);
+
+TRACE_EVENT(kvm_s2_desc_update,
+	    TP_PROTO(struct s2_walk_step *ws, u64 ia, u64 old),
+	    TP_ARGS(ws, ia, old),
+
+	    TP_STRUCT__entry(
+		__field(u64,	ia)
+		__field(u64,	new)
+		__field(u64,	old)
+		__field(u64,	pa)
+		__field(int,	level)
+	    ),
+
+	    TP_fast_assign(
+		__entry->ia	= ia;
+		__entry->new	= ws->desc;
+		__entry->old	= old;
+		__entry->pa	= ws->desc_pa;
+		__entry->level	= ws->level;
+	    ),
+
+	    TP_printk("ia: 0x%llx new: 0x%llx old: 0x%llx pa: 0x%llx level: %d",
+		      __entry->ia, __entry->new, __entry->old, __entry->pa,
+		      __entry->level)
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.47.3

