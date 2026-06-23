Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25718375AAD
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215653; cv=none; b=DtOTFIqkci/8X/WqErpcyOicPFEIqYf5CyzILhVesu3eC6qpXNUiKI5FSXWqU/ltydHMyX0BCOTx+YUzM7W7mwrysc8ph5i73ovV0imd6816THRnoh1qdSD27i3YE0+K4pf3W/14yFznSfDgzkmZKQbKB5pc9Z2dwWT0yUBOHl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215653; c=relaxed/simple;
	bh=8v4h4upt/DlWEAwVkLzvUb1pYxEdS/Zgh2jISDAPSt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G4jleywoGhGiVc7fi2IedErxkWDcNUu25WHAl7860NoW6vhhIC1pzixkkTG3NbR0osDMwgu/A4YQp+jtsQkzOFEs3Kb7jq6ST16L6Zig/RZgaTlMr5mkzO97BLiVPT0XPpDFaD0KNolIu81YR4SZeZu9ciaUizH5qeHO6diertg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HbIdyQ8L; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HbIdyQ8L"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4623bdcad2fso3466303f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215650; x=1782820450; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QS4Tc9DEF1sakhdO+oEzT9jcpMtmCqHU665RCgQbU7E=;
        b=HbIdyQ8LwV2URYx4OJwCHOZ0VVYS21to+6frrUV2w3G+rLzl0wZGayeqLM5edYtAi+
         jX0anOQ2YuQCtOuRbAxWTj8ug2Y9eWAgaKoG5iIuOdSZG9RRgzDCgIQ7fMduq7a3BQ65
         P8ZPnbiexJmg7CqzYRJ73mRSSJPy6nMzGxxWD1rqFieV5ncL7/iIngDs/iSRmgVr7gnT
         jTfdd5TD/iz4TzDGviUKYbj9T1ifcjx+j1PTHmsV2enl7mPQs5MaOd8qOYIbepZp9GIk
         Suob3gM1eq3nEf8ywJlaqOFNOsxiRRJECIti0cAcYUj69TmysCQ/J1m0kFAXd04amVO5
         cqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215651; x=1782820451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QS4Tc9DEF1sakhdO+oEzT9jcpMtmCqHU665RCgQbU7E=;
        b=DGPVyE/HBVSjUIrfrxGdpb+yn/LJdTULojgw20XguFY3KJbS+WMoV75SAPHdrL53Hr
         VFEXGqZM8rORmUuI3TvWCEIGiU6/01sZpO+tFjUYyLkaFyfP73bIyFl8id5f9IFiTKkI
         oEns3nrzm0Zbl48KH/GeOCGK3+6i71Px3aSw3dOZcTKL/ovSyD+AoeAPu/uDiKu2bJgY
         buIOA8Ew3sZTQzpkV4Fo//uCay7mCNXnf3QPhjj3KDWXPMd8U5O7264yEdzCFPZbLH83
         3IhXa3PSnplq9uprxv1pdY3oaHp/qT78PdSk5XeQUhLkEAX/Q5l2Ysk3MyVLJRGEcXbn
         TQbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/iDdM/LZdE7JNuITTxuZomHRinhw96B6VtS+v1KlT2dO4B1KHSPY/z5uaUItqlnu4oskbloGQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBzxSBnd01eKafXgHuehM/p/c5fB4JZgc2DTRcu2T68aA7P1xT
	zLTZFETGVFv5JYzp3ZsYAnXP66REB1McPt5jc/TKpccjVdpSnjVpiBkx3xHSzARIUCUv7IN8hBJ
	xzNwD06s80ltPZdY8dJNqFwDcbYPs2A==
X-Received: from wmpo6.prod.google.com ([2002:a05:600c:3386:b0:490:9d65:494e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6309:b0:490:b645:3213 with SMTP id 5b1f17b1804b1-4925b3ac32fmr36891085e9.19.1782215650250;
 Tue, 23 Jun 2026 04:54:10 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:49 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-3-sebastianene@google.com>
Subject: [PATCH v5 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
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
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 78bb043b33ee..cc10f48915fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -715,8 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -911,6 +909,27 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2)) {
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
@@ -974,6 +993,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
2.55.0.rc0.786.g65d90a0328-goog

