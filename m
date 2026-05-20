Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D13F0A9F
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290846; cv=none; b=GZCnxcLt2eYoU6GeFU0s+YGkkialo6hWm+A/bo+jZ/WYZjSRctiWbASZeVacDM2iyg8CMbucWnC7IGBxz6PYiuB1OyaBJ5fmNaQR5BOmi+VmCd0LSIyrA30ihcU3Ryu/Gk7vC6pOlBQ0nhQUts9vYGlYEN8CYPttwPPVwc9wtqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290846; c=relaxed/simple;
	bh=6KwAV3V6QuYWwfJKfg2Z7MdAJlvE8mzYb4fd0n9S26o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZSQAL2v69HVsuGaf75apMB7TG7sm5PgZEZjQk5czL47XBGyS9TaOYcEiLGmNWevBDKm4VljQSyrPspvpkI/sKMyur05JHdutOnOIUUCxnzXosj8UinbIQR3n+ySEvP90Ebmlcmk00NvyvewssLbALqrUaqT2+q0dgs8tglIfVY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJZ/cHJ8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJZ/cHJ8"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45e55c44ac1so4073506f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290843; x=1779895643; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKKpQxANCCHogl9aY/9W21lvxk3CTd+3ZnVgKVwZ+ss=;
        b=mJZ/cHJ8KwT9wNUmrcU2NjUxHSbOKfh6E5q3y0WVh7tRbjMMlGT/diK+VggYQllgui
         X/gtwJf2+aMKgy1KoSQ0mxItXcRD6u7D4HW+IHWMihB6feEHSn7XXpYf6LFd1zYBDJip
         pNZcp+3CfWPD2URreNlkzqGTH8uqS564GdgHFQVcMavy8gHDo2iRmjylm8YYFCifubN5
         ea8yhq9eM1dkc1v7eDQCVRQ3XiCj5MBgyNTGsAKsf1ztSnHEPYieYpF51qjERBQWTJM/
         gaeiyAbn8MTHkYw3WS8jZOTv6fqwkgUCxCJM6GlswCGlvPyjwR6jWyAHzeI7MyJmSMsT
         T0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290843; x=1779895643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MKKpQxANCCHogl9aY/9W21lvxk3CTd+3ZnVgKVwZ+ss=;
        b=dIVEoR0+vY2tAijm1Xnzz72G4ft3U0HdimneNAIZeVKQtgSwV3HnpxkqwXhBz8NS4r
         7mfqvLI0xYiGKtjn2iaOJcj6k67suZjFJ9hCCxdOrSUSVEhB/Ixiww3A1GdhwyhG/sor
         85CtDSf5yPk/DheG5q+HulW+mMquol8u/vEywrPunxT3NyeBqdAOxUpeapb5dXFTwIFO
         DNsxXf/sPTL4VtawXv4r4h94V4ZZpB/KYGV4JPn9XCIbFrxHGN66dMkQ5f4OMwrN2Czf
         exiXVstWG/q+0Rd2GqS4dVRDd6P7HSn2v30ubLQDC3sU09Z0azXx7oQw6H66NsW5wZf5
         wZAw==
X-Forwarded-Encrypted: i=1; AFNElJ+VKzg7xJL0Yj2dyUlXnF/+WfQ+jpJJ6ASMZoXgvlIQAicxMkODBFsvxNSsM1lX4EwM6zwxLpU=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywhy8ekHuSZuRXShAuwmGkxmozeGuVUIHy5qTixuf93u2Fd1kTK
	2dqKnp16sFztg5of7kq0BfumEigPDYh6eOUrlbu4NdOdSywjXON6AnS5hXVfbk/eCEEQyAC3vOt
	QY6osqxiB8fWG/kOi1YXi2w==
X-Received: from wmdd19.prod.google.com ([2002:a05:600c:a213:b0:488:c696:8bf2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a11c:b0:48f:e230:8cac with SMTP id 5b1f17b1804b1-48fe662a1cbmr281507845e9.32.1779290842698;
 Wed, 20 May 2026 08:27:22 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:41 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-9-vdonnefort@google.com>
Subject: [PATCH 08/17] KVM: arm64: Handle PKVM_HYP_REQ_HYP_ALLOC request
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fb4d140c99cc..bf43235e62d3 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -206,6 +206,7 @@ struct pkvm_mapping {
 
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_HYP_ALLOC,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -227,9 +228,13 @@ struct pkvm_hyp_req {
 
 static inline size_t pkvm_hyp_req_arg_size(u8 type)
 {
+	struct pkvm_hyp_req *req;
+
 	switch (type) {
 	case PKVM_HYP_NO_REQ:
 		return 0;
+	case PKVM_HYP_REQ_HYP_ALLOC:
+		return sizeof(req->mem);
 	default:
 		WARN_ON(1);
 	}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index ce96a6f90bd0..f5288a350069 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -116,6 +116,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 	int ret = -EINVAL;
 
 	switch (req->type) {
+	case PKVM_HYP_REQ_HYP_ALLOC:
+		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
-- 
2.54.0.631.ge1b05301d1-goog

