Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1603E16B7
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607268; cv=none; b=nezBDz1aXg555bLbaw2P3kuwg5IX0AfKB/GK2oupugZwdGsMbK+f9e0+S++D3vbjtgyUCBMLiWRtDl6VaTAGrNjMmkB1UXVeT8q/xTYD9XuJehsCogs+9lNkB+YQpp/ugNA1a1KbnmGumPrFvdtE64Dy38tESluTJu/oWG2qIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607268; c=relaxed/simple;
	bh=AxhbvR2ZfFA+ZWiVMfIM4YJmysIERQasn9hcEH7J3YI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AMYg/KRULwNkwu2K2+bsz59D5y2v1joOmOrJfCSu+ltoQ5XSecV17E7EO5QOS3cP2K0BuZ5FWvze+kd5M2xUW06VWpKPd7PgXZyqpuH7MgBOR/WACOMzD5BSSdOAkNooS4e8AE6yJH1VC7RKrGcQ7L/1kSWLQQ30sy3rAkVURUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ACsGH0Ud; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ACsGH0Ud"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b2f22ea2so38195665e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607265; x=1782212065; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1MtrJN4EcerjeE6DHF17eBGjvGBuj7lWJfYdNgKlqOo=;
        b=ACsGH0UdT2wq+wOnMyeObyM0m47/UNO7VSSnRJhXqU/bGwynG9oYge9nVGxC2WqqMX
         twqt7sZjh+PWDwgiXPUeu8iRcIHahwWgFfLIHjIzQ9MCgD/N7/CkPNi72wleNXiqB0yP
         kdxBxE1HsszuIuH1pChNS9ovI5h1RWbe0D8GVKQxLWwZpuuJBTVljgZXGcvDKuTXwgs/
         R735f624UCF45sSW/oRifYJex5yewLa7bl2xo64IoRGKMN7r66kn36BFvJQevOTTnK6N
         gxUlg2RaOC9J/cIWvQWj/gj1aI71O6u6JCtk7uDJwOpoxZ0nDoNq9d7S1CaviaGCWUI7
         hXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607265; x=1782212065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MtrJN4EcerjeE6DHF17eBGjvGBuj7lWJfYdNgKlqOo=;
        b=G2eWiS6xzHxfALccii4YdKN3Y6uXVkhFFMG15ekrEonQVcB6GQlRfgvwkABEBNN54v
         wbP/vfOxgkNxaOq9hCdhCqCk/fKZuo1gEmcskrkkrBNRvMXrX9ZKcZrfI0sEufotIoiJ
         R4kPFMggSe1k2cTXGF79kmPL1pBfz7F/Dmz7tobF72fq9IOeN85Axm+Cst7GAxCoFUCS
         2bIhjUHJTpPzm0zkCPtBYOiDODE6XT7kjTUjN/KnnUVaDLfeDBbkrus8+j5P7H3oFHt0
         rodpJfqegXvHC7xPnNaEpnUs7SFV5GIbJAeVFQM7DsQsHvlPhnFsBOnpZsujVgx9CP6f
         ROjA==
X-Forwarded-Encrypted: i=1; AFNElJ8C1w0775OvSDogk4eInWz2hxRrylj6XTdHM0Zzly6t0jfGxNULW4uUn5d0y1/KE8UK3l2zQu8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8ak6qChz7O494+BfYMLEXQ7M/nIr13T5Gjjvq8KV/T6G9XXX+
	V+DJMtkUHnndlzFxrBY0lG2L0ptZY09Jg5oVQ0kdF558XoKBa/ArTZyshUK7kwA/X/UBJsS5YSA
	wUZ2LG5pZZrinHMzMyhoVru1YM+948A==
X-Received: from wmjv24.prod.google.com ([2002:a7b:cb58:0:b0:490:aeab:32d1])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e48:b0:490:e60b:6860 with SMTP id 5b1f17b1804b1-4922005e235mr182587895e9.7.1781607265338;
 Tue, 16 Jun 2026 03:54:25 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:09 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-3-sebastianene@google.com>
Subject: [PATCH v3 1/7] KVM: arm64: Support FFA_NOTIFICATION_BITMAP_CREATE in
 host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap creation messages to be forwarded to
Trustzone from the host and introduce a helper to check for SBZ
register fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..b1e5f9ee86ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
 static bool has_version_negotiated;
 static hyp_spinlock_t version_lock;
 
+static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
+{
+	int reg;
+
+	for (reg = first_reg; reg < 17; reg++) {
+		if (cpu_reg(ctxt, reg))
+			return true;
+	}
+
+	return false;
+}
+
 static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_1_2_regs) {
@@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
@@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 3)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (vmid != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+		do_ffa_notif_bitmap(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1099.g489fc7bff1-goog

