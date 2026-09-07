Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD31151E447
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801581; cv=none; b=PEpGtgdfm4661yEetjc6gwiV/3WUYwNzACMYQfVLDSH78PvY0PRYEzqT/e8lEe0yu+Dp0lZoFCLYE3RnNNHtODKKht2hccuk1ofL9OANnxGdfVA1EHTpff1cId6xdZyUqJC5KGryl7zO4ibzMDxGiKjCUw3BCguzNxo8mGn1/00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801581; c=relaxed/simple;
	bh=3aB790zGiVOG/HfZGHcb/tIqTnzy3lfiYNqJ4SlcI7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YdHc9jCggaxiU0FD7spnsLM1OWVZKz2vXJ7Iqdr4QfvKbnRwoiQmn7ME0JzPb/Ou1puqRbTLC7JtLJ6dj510z9HugnSiaGTz2oxuzAc6EfAqAKV+K5LfXZX2q1XEtBHFevqwxrgeWl8pGqw7ZCOUDD8QJoysp5x+T2RDgDBnnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZVC60WdR; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZVC60WdR"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-499b99a8a10so34502595e9.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801578; x=1789406378; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nteL4njDpbIytNAvu2VP8USt+sQ1w/IhgUr/WfH7fOI=;
        b=ZVC60WdR4MGNe9lscwdW9X04avCwLhGfZGgVSDyY4xz3YrXzFf/Rb+kcxduFXe2UQk
         DG4R8A5icf/WRHycmtc9Ye+hBtN+xKvfmdSVpRKU00pZctN25Kuw4IMbZ3kYiD60Xc8+
         7QqmF2XpwX0vAWkkpnMR5CGZ+EBUo8BtT5i/s4PMb5wVydfsrR8ccH3yO0eA/LTZBWON
         1ku9XTJwDZqWvm0Eq/r5J8xdE92MgUkMwi0585lfflSIozyBnlSte3jbaLs9LNdPLh0a
         Xl/SVjadvl/E+8W8K8lVEKwe8ciVmnFB/yG802cIg6Ce3NagCnw1Vmd53+jJm5VPMzED
         ma8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801578; x=1789406378;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nteL4njDpbIytNAvu2VP8USt+sQ1w/IhgUr/WfH7fOI=;
        b=iGvQZwmaFOY5zNJItM7tRAsEO6s78DMOiNshqYpjF999PO9FFeat9Z+R0asNwIMopY
         v1VEoc8fo7A6WUmGQoSCiJFifqMwpqvJ0RPoF/kmrSVTqI838puhzwQx7AijnDwRmZQG
         xOsgeSL5ohx09+gS7yckv1cytzXLa7FywgLwc/FAf7myy07hKxP4maCaasAfnExb4ll8
         /h39akdyqODbzF9UQoxtLBwlNCyCrhoIx70rwqwH4y0gmZii+Yx/AS3srnjfSz3uVE/P
         P4LmAEW3jCieREM5pCcred7DCyOGHYDtpdw2UhkxUlAjXY6MEu9LqlYZYQPnMg+WnCka
         67wg==
X-Forwarded-Encrypted: i=1; AKwUvBzFY6YXtRZQRKTH7zCCWMYEevqZZAeca3OfUe6FuXNeIT9noMODw8FAXQ29IAC7TZl5tm9smwo=@lists.linux.dev
X-Gm-Message-State: AFuF++mxe4opOcXnfy2gEQCkEfmIM587ZU+tWvy9GF+t4Gyc9drexWxS
	KJ4lYLFuQyadgDv9+NL0lXpr45b7FuiW/SdtJyv9CPczCA2Uz7omMZ9r0Eveom1u2Y/dQ9I0UWV
	pow2eQLpXxtt20DWQZIs5ugm5H3wDyA==
X-Received: from wmpw23.prod.google.com ([2002:a05:600c:997:b0:49d:74b:4e06])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd6:b0:49b:4eb6:6ffd with SMTP id 5b1f17b1804b1-49d1754ecbfmr25030805e9.5.1788801577617;
 Mon, 07 Sep 2026 10:19:37 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:23 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-2-sebastianene@google.com>
Subject: [PATCH v9 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver and enforce the host vmid
check.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a327c2bbb6b6..aa82c58380a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -692,8 +692,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -878,6 +876,21 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
 	struct arm_smccc_1_2_regs res = {0};
@@ -936,6 +949,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
2.55.0.979.g7e5102b832-goog

