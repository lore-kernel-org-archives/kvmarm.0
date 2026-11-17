Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937482;
	b=PAr2MVACFvej3kVeZ8daEoPxC4w4Y0RTfDNN7x4wt8VjqchUATJUaQfC4yJz25JmTX4u
	 9hD+RaWsMbVIMt5nH2uN8hVo7lJy1T4MJ/DHqIFYgZScda/QOTVFwMVck/6VtL1LYFnTO
	 TsBu/0qV/mb5pug6KzRKiYgr/+V5qonxGY1ZTZQ6dhhZYh8ZSAI/hO14OwlCwsPrf23nj
	 kM/CHxPDfjM18tirB5IGspIzL7uVL48Zg30nBCeuU5h21DE1it7NBdGMaSCoiVqjFhZFa
	 L2BPyf8uAsI1M7+TDTi7IR/lpBZKNlYuAPi2PUh5aPo2q5wHE2bK9K743KlDy9oOZrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937482;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=8KeZeMT8SHMlsK8Z+7IOrB32VJdaUSkm0FqyQNP5AM4=;
	b=nSZ5vWwNNFQKG5kyIePU7FnyK8wZ0QYjomkVyGt4jzKo+qtyFEWcx1RtyNbQp0dQVuT0
	 VEY7IYytnbHlKZdmY66emgYwpbuDpykY5Lj/Cw8gh+RD+9Hc+u+bGowZkXKbipsdRNr8m
	 /iBzXkwYnlsJNrGHVcOCRA2bUYmcrh0DxKDyGAJq4JrYgD6pR/pTyIcv474fNTKLwe4l1
	 8t9DCGpv9ABk4SSXLmzg0TPxopRIbn5kEnmBtQLLmEzNP2m0x0hBY0RVuWcm5byrRnGsb
	 vWhZ1unqBOLoSgvGivd1ymnQnsuW9fBjBGiOFSrYtlGshpzKmff26q0hW8N8l9+k6fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kQHFnfyg;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5129B606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5129B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kQHFnfyg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso900155e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937481; x=1795542281; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8KeZeMT8SHMlsK8Z+7IOrB32VJdaUSkm0FqyQNP5AM4=;
        b=kQHFnfygGt1lMHmErSpXCojkdJ6ZTeMjYOuEyexeO7eT1NvfMszrVOA3pxm7PLfpoN
         SNgOfTjnuGCpUIHN9NWQHjedxhTh96IjvrFlcAG1rZkUJmNqUchOnnETZSCu/zmXOBDQ
         vE9kWSF+s0RSCQyf8B11ruz/QP5Qd2odS67PoWlrRvdCWSD2JfKGvpgYD3+hV4TfKr+q
         b3rXhLTL7ZxqLuB6asGIVI8UoODllOGDFbEJ7T9t/6NPEuB8xPq/naRDJRA7JcAxJQLx
         MwuL/rIdIe2xn9aqHE57wDspHCEqeDsKQ7YLPj1+ZpERKD00FGPyHM7G2mkDxEy/tBVr
         yB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937481; x=1795542281;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8KeZeMT8SHMlsK8Z+7IOrB32VJdaUSkm0FqyQNP5AM4=;
        b=fug9OPTMGfsV3rBsHpmVX+0laJBGvnHDsRmvKHg8iiB4YJgt8E4xlPICvguydu+MCC
         eRSc180sUKWw0W+aMQ5O8U8q51Estx6b0EfpYkNv89pVT5ADj7dbmIebj6LY59Qqu0ge
         xGeTlHAZZgHoVTjHTr2m/1Yri95cdNPPOGpLHJYM8hmhlrfnatyTcpBdxSzy7lG5NRSG
         j58uGFpRO1VmPz7WY5EEF4s1K5eieF5qOfTRUHTmfwWq5iYWqRL6vNuXQDKFDycl41Qh
         H6lukbPZVLgdLvmOR68I8QPHVARS8UjIR+21KDR1717UM7NsFnfiuOuSl8aKP+y0PMnY
         qxPw==
X-Forwarded-Encrypted: i=1; AL+hErHwLPQbPriTxQnW6p+H2dHALk/8Pg6n/5kEsrO/6YSEMc0PE+IoSwUHErEz05thpFE24ZBk7uo=@lists.linux.dev
X-Gm-Message-State: APuU4Z98NLt6P3yECL0pPJWN85d3yumekRfsVqohzCOeQuXyLFQWgGRz
	Zd5VY70EZvrGayKTefoCrSvnTNqNqC9CWX2E38Q6+RToiSkDFzraENYSfvBI9DVRkJiG/lDF4Je
	/uUAXN7eT0ndkeUWEeo5wRw==
X-Received: from wrws8.prod.google.com ([2002:a5d:69c8:0:b0:495:fb6d:33f2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f96:b0:4a1:777b:8a12 with SMTP id 5b1f17b1804b1-4bb55a4ea81mr309539975e9.14.1794937480619;
 Tue, 17 Nov 2026 09:44:40 -0800 (PST)
Date: Tue, 17 Nov 2026 17:44:01 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-23-vdonnefort@google.com>
Subject: [PATCH v4 22/23] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to
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

As the guest HVC MEM_SHARE is single-page only, MEM_UNSHARE is ensured
to find a PTE-level mapping and does not need to request a split.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index d92f4da1c180..25d2f69db261 100644
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
-- 
2.56.1.708.g77570a6a1d-goog

