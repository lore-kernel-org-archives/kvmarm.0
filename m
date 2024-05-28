Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372BC16E88D
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901178; cv=none; b=Uw5r4UCtJ091C6lgZgOB0FSEKMZqlgX2aEMJep1iiPWhXqvX4OMCKaLrQG986zyW5jOtA+3yzzpcAxT7GL6kYg32NF6WE71EQxLzuTZRF8QAZZ4B1VcmwGxy6M9N8ZJ73sjHevenzel7xWRvV4i/SHShOSxP54d4/ZUjKDZ+eZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901178; c=relaxed/simple;
	bh=AXnfPyojVd0LXx4n2mNLZV6LnFuQ4iH1pCG1oKwNbKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KdUthzbJkCVGwaby53kpDlo+FgMuE1BBR9Hd8KwYgCUa5uqLpCdLlQQw6B+Ga4ZXQjz0FY9xM5x4T7nELmOxnZ+MU/4pTbbJkXbekfPF9pZs3C2YYNaYXhybP0IhM5CBcLVrEMduYxeUn3w9zvrwOKP+QTpOkY8UPKvB2A100Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HwYwUOSR; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HwYwUOSR"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42117a61bccso5543095e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901175; x=1717505975; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AHCgscT25r72lBHvIUhDv2rDYXIjwXeJi6EAecey4XI=;
        b=HwYwUOSRvg2sKe3sIwsBo6W/2+ROcBitFGwdUTor71OldwztUKSpm78iwyWvvaTEaT
         wSrrzhS6rpAgsjHfD2qVbeyvOXjdioS2kvsH8vcpsNKrOg3+KUjPzsB1NZS4IvkjuJdD
         4Ly2Ry9bIxiowJyFg5fAXaZJ0X9TfnsKAmQVfg98hU0hqkoNG4Pk51fUcZNd8F3c7jMG
         R8H+IqyW/I6PXaOFgvfU37qvlVUXO5OCr4oD5SZm18PjRxHao/dwIovKhIPOSOlOw0W+
         8n9Pubuci6gz2Sf2+2zIYhuwoJocuaxAUwgXigeWfL+tWEhql5w38L/5Bggsy5QsbB7N
         Sz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901175; x=1717505975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AHCgscT25r72lBHvIUhDv2rDYXIjwXeJi6EAecey4XI=;
        b=uDXZWb3YIw3VM/OvWiuzALmuIqRmqjmtivKZMSxtidXhIia4Zy+3V8O6jm+KExDR/4
         nJbYqv4AI9X2ciFJfVU5QEmwkTWD+O9UfyaNu8jP5oUgWOL3WMQvqJwgiFBsBynxjFg1
         Ble0C74+VhAjzmb6oMo3e8W8hwz2wzFc1lLOBdBF2Q7PYKWzLQ0yiQnE072SaTH8O8ye
         gADNdY/NBcRBDTOlbYq+LmUqGA1lyhvFZyygD744YXMEVat+h5e4g+lh/SP/OtFKy6nA
         iVe7nXJEF795Zsp6/m9Vo7jG2bhh1mUL1BDmxk8mOiD4wbdYwf3KXT3+1CuycoLbzKXL
         SHIA==
X-Gm-Message-State: AOJu0YwwjxuJRYAcPO875uMUWIT6ZNfMxdpqvzWpRRRbLPzdsqW9vyNf
	5e1TMk87f92S0Cl5fTa9qMqjcyBNoS3Tu+yY0St5g74g5oKiBk6WABMeRodjiJAbE9KMH52M8y9
	m3xcVoo4aOev+MHrBso23qfV3mBOxR0NYbb74kM6BZDdhzlC8lio7W9AiP5Rxh9JqNfJJ5nnAkt
	cD9xquEnUeKOUTJakBDVZdlNIlpyA=
X-Google-Smtp-Source: AGHT+IEVLf5W2YtlWLKomu4WvIxlo+GjgGaOZ6VhCSMteXSRKXf9jKmmqW+OVHadl5iDdCaidYY+mXUUhQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b96:b0:41a:42b2:98ac with SMTP id
 5b1f17b1804b1-421089de7f7mr2447045e9.1.1716901175271; Tue, 28 May 2024
 05:59:35 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:11 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-9-tabba@google.com>
Subject: [PATCH v3 08/11] KVM: arm64: Add an isb before restoring guest sve state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Since sve_cond_update_zcr_vq() does not have a barrier, add an
instruction synchronization barrier after updating ZCR before
restoring the guest sve state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 89c52b59d2a9..24b43f1f3d51 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -315,6 +315,7 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	isb();
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
-- 
2.45.1.288.g0e0cd299f1-goog

