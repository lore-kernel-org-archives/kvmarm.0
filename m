Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D60439003
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607273; cv=none; b=sAFqnxEOAambvZBmHpu2+Wjwhh4kcowH6PC8+lFLRWwTuZyIjl0vbgb72e4/wpZW3ZmBze6iabWDaLYF7tEe7CZn0odq12Lt+LPrthDAR6a0JKNqCXs037JxcMLs3uFthsuTbM0Ikn80Y+Kldvqtz81OR5ywa4brTna7uAZZO+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607273; c=relaxed/simple;
	bh=/+fFnWAdvvrQwLBGBD1Dc3Dos7JM2b8RMhB7Aw0WOFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WqMBsYz35poo39i3iHDkm2Ls8IxU48JuKgGBpjXq1C0JCoUmudKRXxy9OgFCXQ2NhKgU+qWSpUbG3J2ooXqtrihsh1zb8nhMImF+Dd+HKxi92L5PUhp6RLdqpgt1Vy7B95QS98rZIsXT+aN2sRP/0JYC52g2Fo5WZt7041YmjEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rDquvgw5; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rDquvgw5"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4600cf05f07so4216134f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607267; x=1782212067; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0WGrmRhB1PbQdF9zTXmlnmdrKaIQ3QJcD0M000UG+0=;
        b=rDquvgw5ndgH+DmHbzZu6wN8+gmjv9PFVbnWLYvYJL/1J3rn1vwC1CLG51CrdRj/Ej
         eo+bf6nnRRqc5C1d+RTNL8hLffEZayJzo5Ov//5PKfxPKWlqsqXLxVpbcfHH6zB1ZUju
         XLhrKoKLCiaavJt7AcMCZOyUQQWTMR7C4eXa2RcAb1wHdpBpfXO2DWwpgjE/2u4ymdfh
         xsi4jx8wxhFF1DesTPLnoSysFzRps5001b1lWoWLstrQtS917EnNYTEtQdjkVWEfYleq
         WgoPYe1Zh0sC7KaU7x+CZJs7454B3YOneLyiiiAPUcfBHr3lHxc4Bfm0Fx5mqIcj35/j
         yFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607267; x=1782212067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0WGrmRhB1PbQdF9zTXmlnmdrKaIQ3QJcD0M000UG+0=;
        b=Br7zRc08+mkkquKjSo7xdH5YPQgdVaE/CzoKItKixqQAQAjSpRrNjK5goWeYZMNUwB
         9HD8XPZ6y+Sczpc8XPcGuCesPIUScFFP7W8reJCUBPV58NNzQQIQwXJyy3DAq4DCyJbz
         2GcTnJvJU9LJI0EXoKy/SVITe0BiraEGk2RV2xqixAxgW3tDxKin2axrITVfU6nHPVrq
         eqVWqKGtcznORU2FNb4HiuQNmJHSR7Q4kzrIX3/OVaTqhfY3YO42aJ8VlyM3kLmllY60
         ihihEBRfssG03uWzpUGmR3fHYNbN7qT8mZTUsGnk8I/23GpYHbgp+UFShjdV3U49NYRs
         OvSg==
X-Forwarded-Encrypted: i=1; AFNElJ+bN5tytQ05XgZcTvmQNRcf6ph683fJutGDbmFLTA3eYkSEyoNBKAigJetLaDk5EvzrOlJP49A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoqMXdUQgJJFE36160N86CFdux450wO9+ykEzetcmicwpMGnqZ
	741YWsWXZcgUNWQuJdVNGX9M1osP3tzUiptHuMcmDwBymPXMtPRb7IgIskvet4fNbTzluh3UHw0
	k04Hc2fC2Wz58n8TRqBS/BLR2zLSAaA==
X-Received: from wrqu16.prod.google.com ([2002:a5d:4690:0:b0:45e:ee20:c6d3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:43d4:10b0:460:5a6f:c0df with SMTP id ffacd0b85a97d-4619f3afb82mr4361777f8f.22.1781607266611;
 Tue, 16 Jun 2026 03:54:26 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:10 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-4-sebastianene@google.com>
Subject: [PATCH v3 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
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
Trustzone from the host kernel driver enforce checking for
SBZ fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index c723a21006aa..dc7496ec295f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -713,8 +713,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -909,6 +907,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+	u32 idx_unused_args = func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2;
+
+	if (ffa_check_unused_args_sbz(ctxt, idx_unused_args)) {
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
@@ -967,6 +987,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
2.54.0.1136.gdb2ca164c4-goog

