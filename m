Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46492107
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718178; cv=none; b=lmOefBLIZbuGnIzHB8FAFfJ+Ci+2iVM6WI1uS2spBybysKWRoB1Fpo+2rT9uba57NXp9t64txZqpywDZA/4kzm5YX93CErOGVs6yB85PNSByKZtQ+fspT0l4kKleAIW3jaS61UrM17IjQEp6loHIXQaaON5G7ek/xinVuUB7J+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718178; c=relaxed/simple;
	bh=XR10wSNyC1t/2P+/DyQ645knq/tHPG/8EfKGgtI/C08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9beDaY0ueG1VnbxdGBoQGJA6OPUhrwTuNdP8tlz99gcsznF8IGC7sSupHfpGP54qfgoM8Oop7ynD8qRzGzw8DCcwdK28h28L5ee2FRpf6q1Iocx3RmahmznKCSZVoOYA03K2NRNZdzPkQ0tFztCEQ9Wj+T7DmkZdNaAPlZGp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ClTH/fnC; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ClTH/fnC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bj1hmw5gOayI+ifZRM3fNMqP/iykzfwC5gkE9XY3Uzg=;
	b=ClTH/fnCe38SKiCaNNpdHQbPO/CsErs/IBTuPzZY2Huthg/K1wVuS7xTJ/2zjvm8EeLnUG
	EmmFn2zTolHTxOrs8s6m8zlFJSCPNv/93Z8xroQQy8PBB8AlsRR6h2irGDVHGc9PUKjKCY
	W2IKSzRrMOhAPkpQDgSBGFIX3UETrUk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 04/12] KVM: arm64: nv: Add support for describing traps that affect Host EL0
Date: Tue, 27 Aug 2024 00:22:27 +0000
Message-ID: <20240827002235.1753237-5-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The EL2 PMU trap controls are rather annoying, because they take effect
for *host* EL0 in addition to the guest. Set up some basic support for
describing EL2 traps that affect host EL0.

Do so by describing trap bits that can take effect in host EL0. Preserve
the early return for most hyp context traps by taking a bit out of the
trap_config value to indicate if the trap might take effect InHost.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 37 ++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 26d32f308dd3..b9f3e19a1b96 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -20,6 +20,9 @@ enum trap_behaviour {
 	BEHAVE_FORWARD_READ	= BIT(0),
 	BEHAVE_FORWARD_WRITE	= BIT(1),
 	BEHAVE_FORWARD_RW	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
+
+	/* Traps that take effect in Host EL0, this is rare! */
+	BEHAVE_IN_HOST_EL0	= BIT(2),
 };
 
 struct trap_bits {
@@ -478,7 +481,8 @@ static const complex_condition_check ccc[] = {
  * [20]		trap polarity (1 bit)
  * [25:21]	FG filter (5 bits)
  * [35:26]	Main SysReg table index (10 bits)
- * [62:36]	Unused (27 bits)
+ * [36]		Trap applies to Host EL0 (1 bit)
+ * [62:37]	Unused (26 bits)
  * [63]		RES0 - Must be zero, as lost on insertion in the xarray
  */
 #define TC_CGT_BITS	10
@@ -495,7 +499,8 @@ union trap_config {
 		unsigned long	pol:1;		 /* Polarity */
 		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
 		unsigned long	sri:TC_SRI_BITS; /* SysReg Index */
-		unsigned long	unused:27;	 /* Unused, should be zero */
+		unsigned long	in_host_el0:1;	 /* Applies to Host EL0 */
+		unsigned long	unused:26;	 /* Unused, should be zero */
 		unsigned long	mbz:1;		 /* Must Be Zero */
 	};
 };
@@ -1875,6 +1880,28 @@ static u32 encoding_next(u32 encoding)
 	return sys_reg(op0 + 1, 0, 0, 0, 0);
 }
 
+static bool trap_effective_in_host_el0(const enum cgt_group_id id)
+{
+	switch (id) {
+	case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
+		return coarse_trap_bits[id].behaviour & BEHAVE_IN_HOST_EL0;
+	case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1: {
+		const enum cgt_group_id *cgids;
+		int i;
+
+		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
+		for (i = 0; cgids[i] != __RESERVED__; i++)
+			if (trap_effective_in_host_el0(cgids[i]))
+				return true;
+
+		return false;
+	}
+	/* Just treat complex traps as InHost for now. */
+	default:
+		return true;
+	}
+}
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -1886,13 +1913,17 @@ int __init populate_nv_trap_config(void)
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
+		union trap_config tc = cgt->tc;
 		void *prev;
 
-		if (cgt->tc.val & BIT(63)) {
+		if (tc.val & BIT(63)) {
 			kvm_err("CGT[%d] has MBZ bit set\n", i);
 			ret = -EINVAL;
 		}
 
+		if (trap_effective_in_host_el0(tc.cgt))
+			tc.in_host_el0 = true;
+
 		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(cgt->tc.val), GFP_KERNEL);
-- 
2.46.0.295.g3b9ea8a38a-goog

