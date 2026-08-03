Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385E1376A01
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751882; cv=none; b=Z8tUPFZ4n20Ho4r/kNDHJQ3IhmNhoyHiOjiiVbS4hgOw9mADBx+xcJQXANfFAmjvBaHhYsqfRghSIr1T+zJk5BWOGaJPSAJTeUUI5YVwN72F+vYKmIbvHkxF+bojDrfiO8wRP0YLMYfxel+f+E7homG07dl8ekH3LMPS/B65+6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751882; c=relaxed/simple;
	bh=SHXzBcIfhQ9ltYOTV+8Sf7lMhSHFn05Bheww+z+3uBg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JVU39AKdLpWCmt7IiW7AUUkx2UIDhdvZoNogxTQZckbHV+QonG6wbKyTcfyAy+/NQPjaeslhRh0TfcauKLaXDs9fJ4xqK+CaLkGNJJTfQtvn2FgVA0e88dXUarhmqxCLMF5jbxhQBQ2zSUoXR20EvXu8Wv+0z+3xAhcad3bg174=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2IHBnTx; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2IHBnTx"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso14086405e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751879; x=1786356679; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dPrt0jAjZ/dWa7e7v608CZcpRR+OkkaS0UKA/zQy3yM=;
        b=A2IHBnTxDcXmL3FBwCJHX7oyoIf8htByQPFSRWFc8DFLIyOjVetWpRsnDZ9fWNdgEW
         4uPgYFHhUSP9Nn2ujdaXoUkv9tP+OzM88wRQokMv9iqwgjWwRk+NIPZlGoOf2YocK6Id
         StRr1nqj4zMna9JlSKj2HXdwE6ZBMihb1tpmiAcVTZjUePpqbKfG3dvBPz1j+FcZyAcn
         pXOZX/zbZLeWBm5lsauRp4PKB1fNfrOJdJbqIcjJ6eLvPNFqoy8QOwFdl+1XuXTilsI6
         GjGXCPeU26htWzR1kQVS7W+/1Dr+34e4mlilqBugAm+oVdrMnsuBGdlrkDmhBzQYNa14
         m4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751879; x=1786356679;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dPrt0jAjZ/dWa7e7v608CZcpRR+OkkaS0UKA/zQy3yM=;
        b=P2zUABdcOSflSVUOSvTdCFxH5A+jtChPfn7TLe1J9RW/KBLuf6FU6mR8E1awuQwr4s
         VHdhFWjiiBydEQmYoZ3j1xmBYptxk1WS0Y37EhfP0QRnRbGjtqpNnFK0/m8NGQFZsTOr
         t5fUDeJZgpf2Kw1kUubQZ38WriGbxNzbF53p4DcjHyFBw3nbsFfH+pXisdt/Cx9Y49H/
         dTJulNvawzBqjsJYooeTIHzGqPE1AXu08mv04K6L1mX3/Xspl9irdhE2rFBOoKvPCgHP
         z29OoHa6H4sSFquEtoZv6RcKjdvJdonZlnEPxa93VHlYpLhlPixTlkEJpWKpHg5Jwubv
         Uqog==
X-Forwarded-Encrypted: i=1; AHgh+Ro5Kq5nN63j0ME83+o4IfXhuAUjZgwXMsPyDQa9Vv8kSTh4eHymQlQxoFTdahwleNX1f384+iM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+L2OyC4d4w3/flW94Nun0lR9H8sBbRxygPo8gV4kgV25o6BGA
	zoLQ7kXnIwlOFGVdKcrhJiSrCTbS2E3K07e7hMfo0UL8+Xgq9BaGWGNPFbJcueNYUJ9HhfkkaXZ
	U8fmedqDy2POvkITgnrQcyg==
X-Received: from wmej9.prod.google.com ([2002:a05:600c:42c9:b0:493:ae35:2761])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310f:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-4994892d033mr7745345e9.8.1785751878006;
 Mon, 03 Aug 2026 03:11:18 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:09:03 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-20-vdonnefort@google.com>
Subject: [PATCH 19/20] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Pages shared by the guest with the host are annotated into the guest
stage-2. If the shared page is backed by a huge mapping, we need to
split it first.

Raise a PKVM_HYP_REQ_SPLIT for the host on the guest HVC MEM_SHARE, if a
block exists (-E2BIG) and replay the HVC (by rewinding the ELR).

At the moment, the guest HVC MEM_SHARE is single-page only. This means
unsharing is ensured to find a PTE-level mapping. However as this is
most likely be extended later, raise the same PKVM_HYP_REQ_SPLIT on the
guest HVC MEM_UNSHARE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3b8e95b83bf4..57f4303aede1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1082,16 +1082,34 @@ static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
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
@@ -1102,6 +1120,9 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 		 */
 		*exit_code = __pkvm_memshare_page_req(vcpu, ipa);
 		goto out_host;
+	case -E2BIG:
+		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
+		goto out_host;
 	}
 
 out_guest:
@@ -1110,17 +1131,29 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -1165,7 +1198,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 			break;
 		}
 
-		pkvm_memunshare_call(val, vcpu);
+		handled = pkvm_memunshare_call(val, vcpu, exit_code);
 		break;
 	default:
 		/* Punt everything else back to the host, for now. */
-- 
2.55.0.508.g3f0d502094-goog

