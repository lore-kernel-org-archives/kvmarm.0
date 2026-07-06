Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ADD3BB9F5
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360474; cv=none; b=sDSmq2nPu0jwYuDqE24Itt99V90e7gB7kRYtCuFXY6k0MZn5QraWXRU16HR9qqvh8RocCXdJJF0KRt24rTVP5n1dweM+GiqrN0/IkkPtlmGsKQq0mQdxcVv/NgDGohp2NrPNv2Td5V7IfnskP6XdvOoGfBPhSXM59boD1k23Rds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360474; c=relaxed/simple;
	bh=B9sze0BqH+7UhIvjGraHOW3cRqz2bP3ZAIfsDaqxhvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vrs37uu83tBE4OogJ4eg4qnlXKhQjkeuhR7imW0o8w0ff6OIPYScwe4kQTyMBA2FS66OGyXem9JKGsLLnOH7wnaxz27OT6ZqIlD85jUATMqVlEOEN8Zw2WQKIQK2r5P9HjrMr0nYOZ7SD6acsVdSvb1FlOyZtkqcvBv2mHRSWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ub+Ko/Rb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ub+Ko/Rb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b0fe95b6so18642015e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360471; x=1783965271; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HwWa9xikmrWk6BiuNr1ehvo1nd7/hCW6RShSp6OTx38=;
        b=Ub+Ko/RbnYmtK2Hd78zX7YrXbvEqf2a6VW+fZ09xNZIdgVkYB+sOtQ0uaQj6FiwffH
         CHGfrJ0nxGvuilMJFWPY7FrOJxsDE4XS6qFTlJM+q96Pb0nzkY8PMrGILR7uq17ClUiv
         rOzL4QO6Xn6FTSCQZobFy5pH+zJsZzU+aX/mifsc5cMYN65wKoMR0JdaCxg8aNmHo8wF
         riVpZP5luIg9VpdJ6qUGN1bEfrw6QVNcuwIeR8NfYSwHQJxtbBdNAVgs6poOqpVELNje
         1o6U3B5C7gfl5tln2UVeWfXi38lHab3GgO1jPzssI91nKuCAoWFORghd0ER7YOUIE4Jl
         gZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360471; x=1783965271;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HwWa9xikmrWk6BiuNr1ehvo1nd7/hCW6RShSp6OTx38=;
        b=VS3UhvJi0u3P+VpBIqv55PCu5WlAgabxDC248DL8Xs0QBEqWN0JytojlSJXpn+Kpuo
         DyC0mveg6p+U6HmNisVXn+W50giK/COq41WJ9OUJxpGrxKeW6kVpP6eck0XsfthWBsSp
         DMRlxEsEF7UgBP3TcvCoCSDgKz/WSKvbJADi6vU+QN3cMHhg8XCH1Dn5zvCHZ2LYvh5b
         oKCFvH4+RYrgw5wUvLqtQKkrFeCHYiTzbBbGwtCy31MIQQvVLttaW+CmDpy1SyW8La0P
         8RVCDoiVHJSXnwOU4GorFjRu3tCaACf6B86LbNwgf7u8t6SdSDtXSX5oBb9ybCfBxlDx
         FckA==
X-Forwarded-Encrypted: i=1; AHgh+Ro5J+oGnxmRDv71yXT+KbPjE9fUJZSt9gR9XLd0mJqiXtmvEkfDnM4CkcbKThjSGg6LUkDjX0Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyhan85W/J1OigS3SKe8uFGyS5lKR9mCsEsSG0FQTh/RxEcbRfO
	gyXoAdqYoUDnBDPx0ouGdsj4lZsTMYJdaoxLCkIgh8+LQ9AwZE721juyVB/avE5F5/W0MM6Nwz8
	MQF7PdzIhCrYTj5ZEy/yW6w==
X-Received: from wmsm35.prod.google.com ([2002:a05:600c:3b23:b0:493:b12d:1375])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3153:b0:493:bc4a:fb56 with SMTP id 5b1f17b1804b1-493df09fd08mr19227555e9.39.1783360470456;
 Mon, 06 Jul 2026 10:54:30 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:05 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-9-vdonnefort@google.com>
Subject: [PATCH v2 08/18] KVM: arm64: Handle PKVM_HYP_REQ_HYP_ALLOC request
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
index 0be1469e7874..99daa985856f 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -205,6 +205,7 @@ struct pkvm_mapping {
 
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_HYP_ALLOC,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -226,9 +227,13 @@ struct pkvm_hyp_req {
 
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
index 5ba8b81b8c6c..adc418076cb0 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -626,6 +626,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 	int ret = -EINVAL;
 
 	switch (req->type) {
+	case PKVM_HYP_REQ_HYP_ALLOC:
+		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

