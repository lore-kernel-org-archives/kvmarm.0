Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652447;
	b=t3ZgoHF2rHSroqVu4xtTrjeSdMghcOCktN1ujffgmjtsYD4ER/IsWdoKGXZQE8pEqA40
	 MlhRmQxlkhwOsV6Z5ScEAJt6XC2mR7QYBCX3D/icwAjDKYexBXoSFN2+WZt/qkt4oRIKd
	 D0B7F1eHxq66uuRxd6LZCU3L0mweU9VAGSj3AIDAR2FEhx/Npy5GsGo9WtlnD3JB6suT9
	 Tl8VVUcGfA2L9cng041zAi0WaxwbVRoAUI6F3hxv7RkwPIRYgYz59iwILKSQOoYw5TN+2
	 DYgCj0H+4GYb51QykuhlcL3Hqgz78MU4s83WNO+LEUbBSE0EZU6R2ZFui33RPniGX9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652447;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vvL2Ie8/QPWYQD4V2guIi0wkBoonvwzrKKwfja3Hjq8=;
	b=1eDcJHJjatUOtOjglEwrhZFouxiQA40dNNphCCXcIjZGEdW4+K+heIwd5DQq7uav0RrV
	 1OHLojqH/ytZqQEbCF8S9Ml30qCx9stZHQZ00eumSca2JgIwHJhqYgS9GYtNjK1Nn6QOl
	 qb6sQH8H6NW0cLFw+bm5Cop6BnBf19HG/ZxR1XBR19UZBEJULzArx11qVaBZTGRnhTuWj
	 CNzxNvqFgt/di8dNlPugjPOqrCxw7SjPheE2rUf7pGvAJ+uDLQaeeO0j+7fz22a8lVD3a
	 p5zA/Pi0htIYcMGLB4Bbd7eyAlsY0EH+/s2NRdwd6xKSiRTMJJmijlDHg72wl/2fhVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m7PDxpqk;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C956606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C956606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m7PDxpqk
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a318cd95e8so304455e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652445; x=1794257245; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vvL2Ie8/QPWYQD4V2guIi0wkBoonvwzrKKwfja3Hjq8=;
        b=m7PDxpqkvooZEZH8UUT7pYMqYM/9lvLI992GsOOq/uv57dlezcxoyREJNayMTmy1u5
         aEF1wSlOSudYr0v0vm8DAnedZak1yzD8Tj2iRv5QtbmsAIAjLb+oBPOZYtS1ggGDcwXd
         o6MotLUcUcSLmiF+V8dVRt37h8pIUIMhVI2/FZcqK0om7pv07WqFnkCCbzAn8P+z3DZx
         n4TnzJlpFs7gCpjL5hKI9LQcoZ2cEmw6zJCfAs1Pu0i+YQSY9w2w8iqLr+bCQCEZPTDQ
         sOsI0vVQ3TC8fIhG1VgBZ9pOkM5341OsMuLJ8S6xmAvSsetPYt0MtzGiV3v+bJjfs53l
         S3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652445; x=1794257245;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vvL2Ie8/QPWYQD4V2guIi0wkBoonvwzrKKwfja3Hjq8=;
        b=Cb4pDHv/ByXBajZyOFVNIA48JdjxNf9DKmf9ix8EEsDuRbZRd0XlMSKmBY2PLdOVCJ
         iD3+2D8R5CNik5hhKKtZdseWvFhLyEXvsj1ZYhwm2DdZRBE7V2IAl60th/ZHncvNS3/f
         9TlKH1Mi7PT15/PwGJuWxiYVVxRTkaReMCokEcU4M4DxLDabrRAAxYriGw1b5noeERd5
         IXC/BuDEX33CtbYyjVMYR0/OtTN1pL3/LnvOZNkYV44B6e2ehVJ8B5Z5BZw+wx5hQNdb
         g7tTblE7Vn/3VB+eoPlYacVbocrhmdF6LpIghC/19+/FyZgbexn0L8vPxP2k665rNP0w
         VhIA==
X-Forwarded-Encrypted: i=1; AKwUvByLKEkWOHWaQvJpSBJ8TkklJBCeKYQHW43vVaSwFHPk/xbqjf9aAodOnyYZTqhOYp+hT0oeb+Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYIdg9IrESgoQY39L38ZLTVpejWKEcn7rncabLQzn4WjDdtfkjr0
	vreKn7rO8Hm4+KsuKvCpsjfzXcv9FJeyZT3G0YbcllnWn0GVDYmzYLp2gfZNRV+zPcQAZmWwDPK
	kmsLdry/ir/1fOle+xHowGw==
X-Received: from wrpb10.prod.google.com ([2002:adf:f24a:0:b0:48c:41d4:a0ef])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6285:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4ac180f07d1mr278924195e9.17.1793652445029;
 Mon, 02 Nov 2026 12:47:25 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:27 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-23-vdonnefort@google.com>
Subject: [PATCH v3 22/23] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to
 host sharing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Pages shared by the guest with the host are annotated into the guest
stage-2. If the shared page is backed by a huge mapping, we need to
split it first.

Raise a PKVM_HYP_REQ_SPLIT for the host on the guest HVC MEM_SHARE, if a
block exists (-E2BIG) and replay the HVC (by rewinding the ELR).

At the moment, the guest HVC MEM_SHARE is single-page only. This means
unsharing is ensured to find a PTE-level mapping. However, as this will
most likely be extended later, raise the same PKVM_HYP_REQ_SPLIT on the
guest HVC MEM_UNSHARE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 43 ++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index d92f4da1c180..6c126fcc3831 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1169,16 +1169,34 @@ static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
 	return ARM_EXCEPTION_TRAP;
 }
 
+static u64 pkvm_request_split(struct pkvm_hyp_vcpu *hyp_vcpu, u64 gfn, u64 nr_pages)
+{
+	struct pkvm_hyp_req *req = &hyp_vcpu->host_vcpu->arch.pkvm_hyp_req;
+	u64 elr;
+
+	req->type = PKVM_HYP_REQ_SPLIT;
+	req->split.gfn = gfn;
+	req->split.nr_pages = nr_pages;
+
+	/* Rewind the ELR so we return to the HVC once the block is split */
+	elr = read_sysreg(elr_el2);
+	elr -= 4;
+	write_sysreg(elr, elr_el2);
+
+	return ARM_EXCEPTION_PKVM_HYP_REQ;
+}
+
 static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	u64 ipa = smccc_get_arg1(vcpu);
+	u64 gfn = hyp_phys_to_pfn(ipa);
 
 	if (!PAGE_ALIGNED(ipa))
 		goto out_guest;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1)) {
+	switch (__pkvm_guest_share_host(hyp_vcpu, gfn, 1)) {
 	case 0:
 		ret[0] = SMCCC_RET_SUCCESS;
 		goto out_guest;
@@ -1189,6 +1207,9 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 		 */
 		*exit_code = __pkvm_memshare_page_req(vcpu, ipa);
 		goto out_host;
+	case -E2BIG:
+		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
+		goto out_host;
 	}
 
 out_guest:
@@ -1197,17 +1218,29 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
+static bool pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	u64 ipa = smccc_get_arg1(vcpu);
+	u64 gfn = hyp_phys_to_pfn(ipa);
 
 	if (!PAGE_ALIGNED(ipa))
-		return;
+		goto out_guest;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
+	switch (__pkvm_guest_unshare_host(hyp_vcpu, gfn, 1)) {
+	case 0:
 		ret[0] = SMCCC_RET_SUCCESS;
+		goto out_guest;
+	case -E2BIG:
+		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
+		goto out_host;
+	}
+
+out_guest:
+	return true;
+out_host:
+	return false;
 }
 
 /*
@@ -1547,7 +1580,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 			break;
 		}
 
-		pkvm_memunshare_call(val, vcpu);
+		handled = pkvm_memunshare_call(val, vcpu, exit_code);
 		break;
 	default:
 		return pkvm_handle_psci(hyp_vcpu);
-- 
2.56.0.385.gac671c819a-goog

