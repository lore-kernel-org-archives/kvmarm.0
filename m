Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B51D3FC5BB
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725774; cv=none; b=Gg1MZZVQDfGLBCaoXOcYH4w/BJF3ptoP8XG0+R/IonPTnUdQiw55d2fEv8OBZvEytF4iINel/d1bk4UAwk3EUmsOI/lDUrp0mO4RiFp1JQDDLj5TDY2dXJ1I5wDgUecnqYxIhmjjp1jQycG1cjXbyH7Nk7kufgP2j5GoLPudPlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725774; c=relaxed/simple;
	bh=oNRpShBxgkbXhsXuYvh148o1iOD2h7+fq50CawMhWZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mEChbpeIippt1TYH1HyZV/RYSSpNw5nAtcEnHvdTv8jTGtPHfTQSVIujOo6/5IrDq/atBisC8wEGfg1F5eR6PK5JrU7ZpYb0wRCmin7NBUQ8czyv0quzIAapX7ByHyphQdiLiYuDxm8b64ZkIQDH7CWyezsJduFF4RiAI4jiLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmB/jtnB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmB/jtnB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-46315372c3eso2371786f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725768; x=1783330568; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jo7XiKMHdspymNDo6dR1D3/Gy/nMI+SU7DuWBG2vcCM=;
        b=lmB/jtnBmg8qzmtlpm3XmMg6VavHinSgaHqtIoi+0gciB4ZQ4YzjMO5aXMZ9ZlZQ+m
         Y5Q2BNR19+YQjmIjle4sw6h8hujlckF2dWBkveDPIl9OOCx8jOItoHf2pTtRwqwP9/hF
         4zNThz/eTQHir3kL50795LlVWtyrCZ2fYpi8zucmF53QscaZs2jrPprJf2D9JTDniiXL
         ++sMWUQUJnrkPVq8epEmM/OGhHqX2jAN8LQDWXutA3O8tgMeZyO3cquW/9Pbls3s35kD
         hmPiwpIwOmLFyQgv3qAFAx0FK3sLk6EVvFzE1gFsKKULc8FaH7TYZkMAAfbWxMencD0v
         TiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725768; x=1783330568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jo7XiKMHdspymNDo6dR1D3/Gy/nMI+SU7DuWBG2vcCM=;
        b=SLcMBiKLc7TDBI481sR/nbl65q44BvThdv2CsRFWU8i6DgAzTiImH8KEVlY4t5+6WA
         nBL90X+xKiXVAF0Bh28fPBVGt2Hz2EwrauIRU4HRPF2GEDMSJ9MfeFuPkB2dx3J0OnZh
         vevwZCvLXQtLqtlsAlzM81t8Hd6WuVIcuhQZeRXT2S03HY/nod+LLZeiW3et7S3Dtuhx
         gDev4JWVWHDFDORgPZCImxMD7G7weFD4BpZJutO1yhON1fyyg4MADqGwDqfsa9nu+S87
         Et5ocjMvxfcEdQyoUSqNn8cGmWZg9EWBBwLyi+R+5+5ppc4qi/DU6YgylOwc94/VBCjD
         hB2w==
X-Forwarded-Encrypted: i=1; AFNElJ96mKvlaoEIzkJpBPmmDrAwJfcI43KB+3Ax2DDWgDEJ6jUKv55jLbmf24/bC/eAK+lFlURhSHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVp62K8FLm9Ap/r9idpMxdKI8+icHu9fFyz2QDKCp5NmGsc04c
	9KuEXI3v8P3y3KpAWtF3ZyZ4+6iOklAbPmySRs2+J2aRiKDSc3XA+JGvSy4hGvnnYi3PfcF+dZQ
	o+GvUdFjId0QTQrvqq+98Ub/Sd3YFxw==
X-Received: from wmbes26.prod.google.com ([2002:a05:600c:811a:b0:492:61fa:f2ce])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154a:b0:493:a535:5527 with SMTP id 5b1f17b1804b1-493a5355530mr93865845e9.21.1782725768465;
 Mon, 29 Jun 2026 02:36:08 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:52 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-2-sebastianene@google.com>
Subject: [PATCH v7 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver and enforce the host vmid
check.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..ecc13b795f2c 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -676,8 +676,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -862,6 +860,21 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
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
@@ -920,6 +933,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+		do_ffa_notif_bitmap(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

