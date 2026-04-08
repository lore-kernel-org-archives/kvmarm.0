Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504991F4631
	for <kvmarm@lists.linux.dev>; Wed,  8 Apr 2026 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775648484; cv=none; b=fEVIenz31MLGIzLJPWykpCdMBdDPXhyAFBNLs3DKm61ut/ywY0YT+BT3gXSsvKUx8sIhsBgimb00b7lrEn1+hEp84bmt51qujJGNBYUPXruJmeLPzkYJhkZP9WGbLoTLUG65ESw3oih4l4iPTPZkHtAwV+gwBvnNlS7kGMsnpjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775648484; c=relaxed/simple;
	bh=wDN0o6SnYLRFaxiDTPa8nOZbqq7GIdl3+BY3KzI+85c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A2OUpPCPofMm4U2IWe9+47vaS0Bdz4q4X9JfwH3pqNG7xViSAGTsvR3X7Q68AtQw75oEcqANFYW0i/xxyITrDInY8HgjzhwRoaT87Ce8yryaOPVrTAd+vaScifYQ7H2Af7+Y8paL486fVsY8gSWwXFJD9konJJlG0oN0Te3jeFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lO93YpYO; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lO93YpYO"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b9a86b9b0so7559058f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Apr 2026 04:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775648482; x=1776253282; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cFVZM51ujgYl6062hVS6iRzVSZQWxsJgdzphCGIB/gw=;
        b=lO93YpYOrx1E9hQvCQxkCilvFipM28FtjyicVa8KTB3+jMGUvcUXyujz5jEtxAhyO+
         F03hBuT00FO0fOuwd8FulBuk2I4cuPAsrN5aLqSYOwy9NEljWP/MUDeB+fRNGEBEb2xy
         /Zvv2ELde/I03RKsmCly08oxKUv2K8haGtut/oBsaDUFHSzTD9wzAAVAwJpvs6NLASU8
         zF1zPWaGp0Cuh/eabR5nNgBq101ok1k1qi/tSx85D43pGZo+cRJ0TnBdqKI/NAPQSWXg
         88J0hNIMyatxZD5Dq82zRt5MG8vpUeitk3sGfJUp7hDg8HRmHV+r0nOEPwBFwTQdXR/U
         ixqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775648482; x=1776253282;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cFVZM51ujgYl6062hVS6iRzVSZQWxsJgdzphCGIB/gw=;
        b=hXKn7wZOvdbdbFDTFMKzb3i7m2VpfxiTf1rE9Fzt93vRZKqCnG3GtGqLinm3Uow96m
         wteyFf4WTpTS5Ue0SeLQ0LkOqRzrb1QqbUOZ1OIXarWS6hCRiuOEt9RymGkcHCEclcTm
         FnXdOdqgJvy0EK1hzz10dS0+e3eVJiHUgXsLLej08usMmyMMdW0cOMl2nP6T5Uk+jWYF
         HtO5XEZfV4+5SPBhpAK5WZMwNmfqlMA/SlSxjdtoHIlPF0Rou8mANx9ZtlcOaLXsSn1K
         o7nK0QzZCDSWM/vNce45KpHqJba0V42KHsE2MPTvbxL1HWQpLj+pP0t8xWLJbq9I/hMp
         P+9A==
X-Forwarded-Encrypted: i=1; AJvYcCUyk/Gxu+H5p+mYtIVwxtzSOoXQfAy5QXT47JS5cFKIUkVEeqE49Xa/fXXFmdMo/M817ZNBEnY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGgxt7xzToAxru0XAwBC+kOnT6K0puQ+X2mgHBRwwrC+SgWnYo
	vTi76sUsHa/4XucSzoxqs3V6RlJ/M3g2sagLSyFl6zcA31uq2SJ6KBeE1Z5fA+rQ6cHjB9Jy+Ju
	vLpjaX+bRHNLBJfqFyBCYZsJD/pjt6w==
X-Received: from wrbdf4.prod.google.com ([2002:a5d:5b84:0:b0:43b:4e28:2766])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ec7:b0:488:9439:880d with SMTP id 5b1f17b1804b1-488997eb933mr275574805e9.29.1775648481567;
 Wed, 08 Apr 2026 04:41:21 -0700 (PDT)
Date: Wed,  8 Apr 2026 11:41:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260408114118.422604-1-sebastianene@google.com>
Subject: [PATCH v2] KVM: arm64: Reject non compliant SMCCC function calls in pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: joey.gouly@arm.com, korneld@google.com, maz@kernel.org, 
	mrigendra.chaubey@gmail.com, oupton@kernel.org, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the propagation of a function-id that has the top bits set since
this is not compliant with the SMCCC spec and can overlap with the
already known function-id decoders. (eg. if we invoke an smc with
0xffffffffc4000012 it will be decoded as a PSCI reset call). Instead,
make it clear that we don't support it and return an error.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
NOTE: This is based on linux-next, next-20260407 to avoid a minor
conflict with a previously submitted patch (commit cf6348af645b).  

Changelog:

v1 -> v2:
* dropped the changes to the function signature that were accepting
  64-bit function-ids.
* applied Mark's suggestion to make it clear that we don't accept non
  standard SMCCC calls.
* revised commit message & updated the title.

Link to v1: 
https://lore.kernel.org/all/20260401123201.389906-1-sebastianene@google.com/

---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 73f2e0221e70..cca4b07c8d61 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -805,6 +805,10 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	}
 
 	func_id &= ~ARM_SMCCC_CALL_HINTS;
+	if (upper_32_bits(func_id)) {
+		cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
+		goto exit_skip_instr;
+	}
 
 	handled = kvm_host_psci_handler(host_ctxt, func_id);
 	if (!handled)
-- 
2.53.0.1213.gd9a14994de-goog

