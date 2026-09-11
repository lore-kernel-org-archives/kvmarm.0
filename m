Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30FA40E8D6
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134692; cv=none; b=N8FL+SLniELRs7Vy30fUO/XBlnueaQSdB6ezyBpHt+7RF9kxtDNoiXNVL5ARj8Th2bU+wfvDgvvMkcx7VgI2EAq0cmy2sTDI7rdCmPQ+qjn3+s0yEzBczLBFKihUtQjeMlJt8AsxLIPmR1twstBeKbN2+emHlEGZN59fnZXl+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134692; c=relaxed/simple;
	bh=M3LYjbt5I9goLMI1MABFcikoAo19WUJnYd+dCP5Ez00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dCNSRrmo1BTGQkD6DjOtGNAh6d779OfB7BJUUBMrvhWIeXlrojs1gSL69wuUZLa/DIqvMqSASIejjewjKX62wCSSSlmtExlbyooYWAQbpVF+5yQSRJ+OL6G/AmkRwq8W5o5PxmhA1zX6xcVvJ+6mmEz6IHO0aErfySSETcq7ex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kE3wEdUl; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kE3wEdUl"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49554715277so9042605e9.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134687; x=1789739487; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X1SHt6f3Y8x+OinsnAYT+PECaOjWB7+9TgxMssXHyA4=;
        b=kE3wEdUlVEcqBubZKOf+Mcm4/zBP1B+Q2Qw1rcVmnMrTy2oSPYABfEPZfGm5XjIltw
         veX/J8LJcAWJZV8ZXUcd5/y14ngSsq9CpYgHfb8MLz49/mhBozY2KShHpks9RNHw8Afx
         MaBUGetfDdCvTMG3rti1I1ILtjq1oHm1yT/vbvLevAx/dPjJd9nE5/JITCIoxgKLohSv
         VS5CQn05yEWnlnDDQAXxYxJ6TPz1sp/2FMApQEeKwk3FOzHjHnG8TZEv6yndOTP4AmLT
         zO0Rkm7P5zjVtUYepfKTmUNdYhmvaR2TunYS0tTeqDsRiOZ/UHxTfaWv8fS4F5X+qZIN
         HTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134687; x=1789739487;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X1SHt6f3Y8x+OinsnAYT+PECaOjWB7+9TgxMssXHyA4=;
        b=XXEMLljO7iv7rQB9vgVyXTjeJ7MxblJY+i0s6lNNXjqZu7W9pAprnkTgZT0xTnKmkB
         m6a5z/qtT+nZ/fUMraNW+zcqnefiNE1cCpTHkDlgYfBO8d0pfY07qqlxXomMel9TK2Ac
         p6WunBuCEkz50GF49zVTcf5PPCJErLf0MKr2PUNMgr8ouSeTQUpVxOth+6nHoIRIRREq
         4fFKBxxNXabwr+FogRakXtQLzUiRQE9X8+G/KihvvTPrLeuuZTayC414Aw54EBdTy4ez
         fLLRN+NZpdmIQmPpTdeF0ZzU1VrZ53JDeUc1VRr7DyKtVKVgcbKGPaKXZYlgrTn0i5UC
         9ukQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQH8YBFf3ySV2AU5o4VWh/HkRgfAPeIh3On9bta0ZGKQBQOBDWsupUDwuj/l7NJnAh6bfZOlU=@lists.linux.dev
X-Gm-Message-State: AFuF++m/rGbn7GEEgvhzneVaL+oHImdjD2lYySJ+F9jcXjkWe7Pf77WW
	AajtljyJ8t9KWMuKpjZwo8KXxV2B+KRc3H43Hes9Fk4OADbrdTrOz+LLb+9B5MMzMVYTJRt6nqw
	1eijl/zjkubaQbWVABmMzLA==
X-Received: from wmtk6.prod.google.com ([2002:a05:600c:c4a6:b0:49e:65c1:6109])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a107:b0:49e:663c:c69f with SMTP id 5b1f17b1804b1-49e663cc929mr48137635e9.15.1789134686931;
 Fri, 11 Sep 2026 06:51:26 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:52 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-22-vdonnefort@google.com>
Subject: [PATCH v2 21/22] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to
 host sharing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
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
index 2b0b0bc3064c..9b24c2233490 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1095,16 +1095,34 @@ static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
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
@@ -1115,6 +1133,9 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 		 */
 		*exit_code = __pkvm_memshare_page_req(vcpu, ipa);
 		goto out_host;
+	case -E2BIG:
+		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
+		goto out_host;
 	}
 
 out_guest:
@@ -1123,17 +1144,29 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -1178,7 +1211,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 			break;
 		}
 
-		pkvm_memunshare_call(val, vcpu);
+		handled = pkvm_memunshare_call(val, vcpu, exit_code);
 		break;
 	default:
 		/* Punt everything else back to the host, for now. */
-- 
2.55.0.1007.g17ff1f9808-goog

