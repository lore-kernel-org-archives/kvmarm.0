Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE7F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560945; cv=none; b=QibkMRj2RyDMjVd5w1ffK6bw+0I+46iTcH8qb+JKjaGMaih8lzaTIA5hwMTWRvIjHUZs42AYnUda3jSPu4rW6hp08TeIZX7XaghFvO8qxFY5MWpNyHTCrb1xHebyroCfPH1657ken1FZNbm577R87dud2KivXzmhvopjEAxo18w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560945; c=relaxed/simple;
	bh=RgkrcfBkGQUYsVITtmI4nfM1bEff01EMiYb6X3YDszs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CbTRMsgP/2wu06St7JK/NQkzS9mQ7iO4u4byxp1UN6vUmsEJoSFKWRQZjOeVWCyQTUgjfGN8uV2ttM6VrGaM3/xmj+dVzlu6yBHfljpLK4HgeW1J/sRmatRUoQtcyrNVXUK/1P1C1IvxGV4zA/obkzqGaiX6MQvafTL24iAKJ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uhro+A2H; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uhro+A2H"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cbba6f571so1615877b3.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560943; x=1712165743; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfmzHwFrF9PGDcN2IzbbXyabq+sXwBoakpDWS7Q1/HQ=;
        b=Uhro+A2HTGYoDRL5iqjttkGosxMgckMRymlT6uexyEoTrkyAs6e2iNFYgKY2QbTZd0
         MlIFRZYB7tsFj+CnR6FVkQDqaY9JJhykdTD75/UR2Oehg7ij4dVQbEy2pTMN24Dn8OGY
         H4GmCOE4WfK4z0XDQZIQcCM6gp/gzp8qSugmRj94Tq21/Soo1pKfDnDuRGI8rgZzJqg4
         25zYtzgNVCWaJqJ3pQVmDS8itNpROhKYwm62ifHViZfCuyWDJEcVxq6nBUXIk6pGBLSM
         rSnY9bXYcpZMkEAVVB5XE54HVdlO9abd44CGl8ZeVv45oLCWt9yruG1d9mzdLXLOroi9
         VEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560943; x=1712165743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfmzHwFrF9PGDcN2IzbbXyabq+sXwBoakpDWS7Q1/HQ=;
        b=Ngfx+mfYc8WqSicJGGsQZWc3HIJw9JNBxjWEtOJx7nCg3ztugO803jEoxN8krSfznl
         otTACLuvYOjWUFlFz3WWcSm6bNkJAbMVIymYteg6sVTTT+vEkXtGD/PhFpsqp9VJU0cX
         6F5GnuldsPhEJFXtrqUgLfp3uPhYN1NiDGueGIx8VzImoclEe1mj/sUcJQeGA1bSr9yv
         SV64lXPalpCL7YAqjr3WchKFvPfZPiADHnSC46xPh/LTAbD7ajBkVcdE4tIqiahj0Bs4
         /rAUF92QQHqNp9TFukrZ2opviFLazVun/Y9oDtddYkczbXyBcxqbVXzHZy7MFkFF0Siu
         W4Gw==
X-Gm-Message-State: AOJu0YzVJx3lLaY8PO1CyOGG1YXM/MBx52eFtzNNUowOAyV5aiagUhEu
	ZncGynG/vqjvO9m1f1pe5QNSiCicTbHNYt0SBrBpwHBjyqWKbJoMsw9p6M5RT3tgR7TvsA7teG+
	aGqZvJxzw/8LIEnj7A5MuqJ6QYld6eWZnOVsM2W0CmvEMf/OQhdOhFlXPRDwtiVGtPC8QtL9vHl
	zilDi37Gi8TG8e57fKU9Ia4kO+8V8=
X-Google-Smtp-Source: AGHT+IEcz0hlq9CuBAw1qW0mfgD7A/TYMOS4JER53h2X0tY6b9F+Rt/KegizemZaz3dJ3fXqEzdmY1tHkg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:9841:0:b0:610:e243:580b with SMTP id
 p62-20020a819841000000b00610e243580bmr62809ywg.10.1711560942692; Wed, 27 Mar
 2024 10:35:42 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:51 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-5-tabba@google.com>
Subject: [PATCH v1 04/44] KVM: arm64: Avoid BUG-ing from the host abort path
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Under certain circumstances __get_fault_info() may resolve the faulting
address using the AT instruction. Given that this is being done outside
of the host lock critical section, it is racy and the resolution via AT
may fail. We currently BUG() in this situation, which is obviously less
than ideal. Moving the address resolution to the critical section may
have a performance impact, so let's keep it where it is, but bail out
and return to the host to try a second time.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 861c76021a25..d48990eae1ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -533,7 +533,15 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	int ret = 0;
 
 	esr = read_sysreg_el2(SYS_ESR);
-	BUG_ON(!__get_fault_info(esr, &fault));
+	if (!__get_fault_info(esr, &fault)) {
+		/* Setting the address to an invalid value for use in tracing. */
+		addr = (u64)-1;
+		/*
+		 * We've presumably raced with a page-table change which caused
+		 * AT to fail, try again.
+		 */
+		return;
+	}
 
 	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
 	ret = host_stage2_idmap(addr);
-- 
2.44.0.478.gd926399ef9-goog

