Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DF643C05C
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607277; cv=none; b=I9g1yxc3Fi/ig7f8K+ldU9rZXbuU26UErUPnGcIoQ3JmtqO5ItHgNkAEhgWJ1SPiDtlVGtdlPN9EkKEI/N5eCYdDlOb6Vt3JsRZL8dQWKr+ri0uQN+oZOZ0Caq2MGTzXmo/ATqZ2qo+r6o26j5NINJGPAKWrRLDYk1X/+NNDCVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607277; c=relaxed/simple;
	bh=pGIm6ajCFKdAmh02tN2y3M1/MFCCXAAzmaRbbmmWEa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TO686VBIbBTCHT4ziXFPSgI1n1OX6ojsahrLcOkQvz5OwaAGS374xQ3ccYmvqWtNFENozLdWipA0zTzSSmlrxocgsEFVcGxanZOeZD/vRv17//bEWHmA7EyUD8bgQTVt1MZoiVnLDvsbTU4BnyUDjoPf/2SXPzCsVGxsreAhDt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qk9zm2c2; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qk9zm2c2"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bf5ea9d13f9so508180766b.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607273; x=1782212073; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2TDzPlo+obG7Khugzgn+eWzESFaACPnZFWLiw8gSSDQ=;
        b=qk9zm2c2U5cQXeW5F5KYhYXX+wpztjyHOvNCSjCSh+BM+6szVl1UD2JV50JCneOm2j
         dInMJYLuqvBsidTu+bAa6SbZEptVf9XT53ttV7QejKfSC/qihUvZtQ9OMmo1mZLcE4NX
         Mhg9xQ8YBWcTnZgvKLm5YR40X9xngjYssZK9wP5sxfyr6ajteTWATbmsjjF2HrbRaxMe
         WURHES4+wE0AxbW/PCuVeDyB0JS50tUT75NaylE7l3KvcXU2dOO220LdamnyYTqtAOKW
         3LGWkNfsX5CrlAT0tIMNhAuq2Lyh5hbFh+lP5qlVi+o2vqIquk8kLE0Zw00Y16X02Qxr
         ioUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607273; x=1782212073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TDzPlo+obG7Khugzgn+eWzESFaACPnZFWLiw8gSSDQ=;
        b=OV/90q5qzW+tQZZL4TW4NRVxyQc76CmCRT1XhkTxGO6N8DxWhi+19y/PrmFMRdIXXk
         0aBJjJX2WrZmXNqf757b+axmdWRdPw0K+vyRORowFG8VXc8TV3n8hJcBJfvz9uQBwcL7
         pZnjcFH5INwWDBJZzPqGTE56uOPdsV4gJCRfF4DLPt3BGGZmNpRnXSuT9sAD2m9EOic9
         NER/EsJud12bAGGUz+NBl1MfUSfeVgLpM2aKhQWJJS6stlzmVcJistjbLCwdLt/X+4Zc
         5WlRNzmlGlmU799/riN4ayVJaD9suAa/KOJxJXsd+e1+GnN6kdWHr1uVsXQ7ISvL4KgM
         fyCQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vveVGs/R3peuZUocV7CZ8xxXZIWjyNW16RYYO0D4Ed1s8CZEbs3EeM0ohrrohBMpzhI56vjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfstcoH+QPiWK4iz0PONxgZJygfquhrvUz2NHnw9Kxce2cj2id
	jkuO0PjvuNagClwXzcQyqmZFpupXIzddL/QzkcWPWfvqLSqwPuLEyLVfXJL8GAVZ3q7XD+Hy9wJ
	Bp8id+6FrPXdFgjsS971zeF8iT0Ki3A==
X-Received: from ejcjl3.prod.google.com ([2002:a17:907:75c3:b0:c04:5e68:2b37])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:8a72:b0:c00:f408:c8b7 with SMTP id a640c23a62f3a-c043ee23d0emr122018466b.28.1781607272779;
 Tue, 16 Jun 2026 03:54:32 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:15 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-9-sebastianene@google.com>
Subject: [PATCH v3 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification GET messages to be proxied from the pKVM
hypervisor to Trustzone and enforce MBZ/SBZ fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index fcfaa441770d..549250ff8f82 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -715,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -1001,6 +1000,26 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
+			     struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 3)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags & GENMASK(31, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1072,6 +1091,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

