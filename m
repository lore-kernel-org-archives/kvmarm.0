Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E873E44F6
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459961; cv=none; b=q5n50PDlRPYg5YUgTWfhAKBTaACKDFIOiHNNHp7skzMduR+ZYXUqXYFYvNKWDgtfJFDMae01lriQsSeaQQ1EbbM1usuEq7XeDLvAE/sJ8Bhov7oxZ40fL03lISR7SEN4qJhfZ1c/NIlCyqsnI0CRzD0+yCXJQy/R4lgi0AUkkl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459961; c=relaxed/simple;
	bh=oNRpShBxgkbXhsXuYvh148o1iOD2h7+fq50CawMhWZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pgKtzbswRsZfzMrFwAThpppzs8vnttLZqZNVrglXqO6+Wvir78uE/9b6v04bINRVxdgXaWiJL0sOiGAZ1BBbiOrHCqaRitPpw4rKYuWTZC6XdAjUBMsgo7o7Whl5rQKDUVQyczUjeDB28Ghgb4MJyKPViVAcBTvZnQ01ggv7Vmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ctTF57ps; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ctTF57ps"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4625e71d3ccso1323557f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459958; x=1783064758; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jo7XiKMHdspymNDo6dR1D3/Gy/nMI+SU7DuWBG2vcCM=;
        b=ctTF57ps/WNN+rCV0fz6+lNpxF+Bh5KF9HO2Kphkk8Ov0/AeMU/F6y8JixoJYbbTBO
         Wyl1KtCNYK3xE7Ie6GeWCPf4RaE5F24o9U81W+5ekcJ+h1jgwaKr4SSM7MzqIs1wBfL1
         Y7x+xPOwqJDq+FKXQTB1lIPxvuFCeGDh34g5fVU8K8zKKhpZryd0cMoQWpm7L7QLekpd
         4aS7FZgplnEuDSxz/kA2ZZQaHT/Zu0mXVbAHOPPggbyN4IzmGQ8dIfd5Kt+/h01PaTHi
         KAM0jotRrkaMcjkiKz985UgpkonJvNHUcMlSPINd59yP4zOtwDwnOiKFFNvwBUJfEIb4
         s3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459958; x=1783064758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jo7XiKMHdspymNDo6dR1D3/Gy/nMI+SU7DuWBG2vcCM=;
        b=dVypkVnlIidfGGds5phW+KqHxRkHch0mDDrFPxsrQIzKVPZvihedpzd+mBTom/eO2X
         322EVM82i331qQOCvgp4EdPwBKtiLNXuszGXbbqDJgvnK+85yXBq0LrPL8+aSquSrgEr
         Z7i+XF12S3g3FKO16ZGUSHC7bMBkqvTfAHqeMhRDZS5Dt2eEnJdPvtfF09VVqDxOF2SO
         lKNWpu9fl5xdQmSFM75//6NzF5WJYcXbfoha9PQPMsiZ4RBzXT0QLzxf/jIHEBAziKaN
         gAzF5p1Kl8kRwvtfYsFWgk+UzuCVOKBVpBSN5YgnBAtjgbBtxPVEmyK0x6EmAeW29SHK
         ksQg==
X-Forwarded-Encrypted: i=1; AHgh+Rqp+ZoZVrKAP3OIIH/A5frOsTQKNT7K8Dwpe22bTnma9ooIg6rbeCkYLnV6MSWOp/28HvJ2Svs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7raa3AzWoDvi2ZkODjPGnmRrbyPmNZ9i5P2GwpjW8IH6Ag/eX
	qW2+iGUsG4eetWa/4G6MjIqEiu2lbWZ5xcGe+B364ac1kfwHigDnTAdyhbpKbi90BxWWEDiQuhn
	YWx0CJw2mC4QuRWdveSuynOqfg888gg==
X-Received: from wraz16.prod.google.com ([2002:a05:6000:4690:b0:46d:a402:82a8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f4d:0:b0:460:395c:7404 with SMTP id ffacd0b85a97d-46da9aceb40mr8969961f8f.20.1782459957735;
 Fri, 26 Jun 2026 00:45:57 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:39 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-2-sebastianene@google.com>
Subject: [PATCH v6 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
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

