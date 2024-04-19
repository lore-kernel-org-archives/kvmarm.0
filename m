Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506943A1A8
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513617; cv=none; b=g7TZFq5uS6ukWhF6vbJprUczwY/bV6/ov54NWdT0kUGLB4QtUjZ/6hVXY02pwALuQ3gmS4W9fUokwN70PebnXYD8FC7itFHcKKjU5uVKr3JxayV8iq1pVI5jdbOv/ZY7DUryPVL1TKq9Jc2fiXDjPu+S7w5Egjg18umEPTJzrVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513617; c=relaxed/simple;
	bh=rOb3jWg0Rd+ONlafYNN0FWQY71lD1nhg6HfBF2sMUCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=liEv/aiLo83bqou7WfDhjp2tt4g3UEIxA+B/tlkytXhtyXVx8MqjIAx8K1SmJa1la0U7QdTg+IiIz9A6QFPm8qBmNyHlXWRe7xfV7A47Tlfu/fr9XPOO1/8YbJCBi7BkSClbEjfVAgOBpALxQ5mF3arQdLSWMQPJ0+vOj1KDZ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4XT8WJe; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4XT8WJe"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-617bd0cf61fso36238297b3.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513615; x=1714118415; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2yYJoV/BBfLNehPuMkwuYXLHx9TbdaOjIvpbqv0JeMM=;
        b=X4XT8WJet1vE1iNRgQYrcTZH27SR4P94VDP8qpuL90s9ojFPSpylnimq0t7I2SeGSq
         nr1MQwyG2TX7Dl2RooyRZpCuU4ozNvK2hj82DtTDTMykdh1g1pP72m/3sRCJ9w0LhhN5
         bFJIcgunOZkatxbqzmKkkW3T/OyHnzplV60RMRxvSo6tC3va1L5zt5d7JLaeRiU7rer9
         U2bock/tsxiIceQjP4BvZz+1s0v/Q2+zG+gG1rseP57pmeL0Rw6ndEXi1bcPhNHwWA6N
         /8C6/FMfxY7HwFlsAkJg47JMY7KwRkGUhoXFT++cuZnqhL5MvEVvhvQlbwXRwv3Vf6Gh
         NKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513615; x=1714118415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2yYJoV/BBfLNehPuMkwuYXLHx9TbdaOjIvpbqv0JeMM=;
        b=UvCE0Q16xsZU2+LKpPIROQ4J8DesDfyfd2vSD0hO65L2eQjhdZWR5+yOOjHt/qiib4
         SJqOBY+1oyuBTcch4gBV21MJlc+Kk1XCcEkrbOU6J81ijx+kPFOZ2oBG9bw+i6xuLh4A
         wbISLF7xNN3skCBo4NsYiJRrG/pqZMZNQYlrYkWe/oX8PvdzrdkxdJ7sdt8FOZXXCkDO
         iYQyfool2i2kCCKSTTLakKVWKrxWlTtPJSs7Ke4bBqtOtCktiS+EXGTMuYYyeooKxfM0
         z2A66PaeIG5mlPgS0b5xlrj4WySj6eX87++YWMxQ2QM+jaqt2uWbdQynnL6Q/s/EF8t7
         Awxg==
X-Gm-Message-State: AOJu0YxdXQCUxt7fg/Am4GLh3CDdudhQVPcY7HLPn+EtwLPqD9b9lpyQ
	cnXYxJjmit+grZwJbbGqrCOlopVpV93sBR/POjfS+kNgswLgnFXsAEXaSmICKUjaLWghKLmDdOl
	AygEOHZgdKzYDeTIEcCvaSzRfv96UPnfD1GUhfNEQpYY8Y0jh7MBO5rLc3kW9LLJJyGO6y0sJc7
	uXSdsgc0c2EOlk2f0kyQweH5qAcX8=
X-Google-Smtp-Source: AGHT+IHe2ybU3UOCo/hE7/oD5yATBQs4YYSY0NMtZIquSYP5oy+eH+WerJgPeFPrJiOcawjPVtx42s2aHg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:4c7:b0:dc7:53a0:83ad with SMTP id
 v7-20020a05690204c700b00dc753a083admr338141ybs.5.1713513614732; Fri, 19 Apr
 2024 01:00:14 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:24 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-15-tabba@google.com>
Subject: [PATCH v3 14/31] KVM: arm64: Change kvm_handle_mmio_return() return polarity
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Most exit handlers return <= 0 to indicate that the host needs to
handle the exit. Make kvm_handle_mmio_return() consistent with
the exit handlers in handle_exit(). This makes the code easier to
reason about, and makes it easier to add other handlers in future
patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c  | 2 +-
 arch/arm64/kvm/mmio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e57aa3502e13..0b5473fbbd08 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -974,7 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret)
+		if (ret <= 0)
 			return ret;
 	}
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 200c8019a82a..5e1ffb0d5363 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -86,7 +86,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
-		return 0;
+		return 1;
 
 	vcpu->mmio_needed = 0;
 
@@ -117,7 +117,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 */
 	kvm_incr_pc(vcpu);
 
-	return 0;
+	return 1;
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
-- 
2.44.0.769.g3c40516874-goog

