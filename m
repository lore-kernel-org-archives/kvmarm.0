Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC31BBBCB
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087350; cv=none; b=XShL/BUflZGWusWif8aKvy/E5wTWEdNjBAD4KnSqnMccSaEa/sXTh0sOlDO0ZzJgYioZi0BKpKlmlqjr6V9wR1KH5wcQ1wlPMXEJ+43cZNaVZ7z7lC6AF/v31/HWjQBO6BHY8tV1dF8Yr1qtE136BIDRHw/V+dMsXd9SV9dR770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087350; c=relaxed/simple;
	bh=p49LU2Zhb7gbb5LKY/h5ptEGGa6l2hQP4h0k8idJ1n8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D6GtvEYPJmPI6wZ2tKlGff06dRRFqbqMz4L6YzppmdTDA5m8wuiThpxOKoWD28XeR36c5LK6pRUZzr2rQQ4s8tPDu9Jhl+RMUyNQ9ee44hf1ouPY6a8mccB1RCi+/5FeDMZZQSkfbJ7/CR0+ixt1JLP6dnB9E5gqiHREFtdHcj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bybZezAX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bybZezAX"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7db1762d70fso349927a12.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087349; x=1726692149; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSI8dsTyNYYmZluhAXeYyfAeB1n1NlxlB5JW+pr40RY=;
        b=bybZezAXW97YPF3hLl9WYTdYNLY2+FUXW1hXbnM8TMUlJ38G70nR9BNgcm91lQfl16
         LA9QQLINfu7bb23Mg64dLdQK3dTh4IzzU9Qx9odWB6qvHfy9dgQZEoWdaF6yWAmhNDWm
         DxntLQ+8miuXD8i3MNjm4jkxXFtM6e8j5SEuAwxGAJZ/fUYnxmRBr8YZa+fvOTGVW98s
         MnPYb4EFQmSVOskWvzEt0MT/kyATOEgK3d1Epj736rGDBCLt4sWtxDZtYPBG+ErY8JK8
         R0h9Q38EQauAslqJHj3Lnm4FanK7DcdL0Ioex/VspV6KWMH0FrCAOXJ7BT0lz8o/aECZ
         zh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087349; x=1726692149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSI8dsTyNYYmZluhAXeYyfAeB1n1NlxlB5JW+pr40RY=;
        b=tT2DcckYIvnyok5lgy9Etly4G5Hc5bZFgLIqncox5yQczRvRs3wO83OKhQIJWrE10c
         MHgQExEDngnHJBsFBIhsDDVHIongrNZyxsiSvw+DorfO76EHrnWp5V754rFE7F1p6czT
         d4VTLu/KdLMZXSdb6BFdaLNZ3tNFWHIdQr1jqQ1NTauOYB0MTntPPTYxtrOeWPSBgDSd
         pf/L4WBZPHWc5rT4whGdWbzsM5A8J3H5DCOJVkGEgO2eeTcXjxV2jHzy4rISiHCR9fwi
         hmeeb4KNPLfHik2TvADW8r+FUQgsXQYrbqSaQsmYV22pZuKScRjNAdk0FOBJtryCO95J
         gZQA==
X-Forwarded-Encrypted: i=1; AJvYcCXYxr/AxUQ1zLQdfwE64qaST/qjWl898jYz7UFJiOgu9VjmyPiZjxwi/C6RDJpNVgQJK/dpyWU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTsRh3yd+1TmXiP7gYBwF1mc6hrRYKS5BTGVd5+e/5vgZkSpfK
	eFDShDfjjP/YfTRQOYIL79wmUcju2KLdBZyRPRnqJCBxxtAQiixEoNxK+6MHQqKnikUY2Tyd5pq
	/Pg==
X-Google-Smtp-Source: AGHT+IFVhcOXMpYuiCLKMEBjF0GLRF0droi6YIr05t4juUD0iWZSecyCNUnHqr+/fAL8PrR1+nheHNVoid8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41d1:b0:206:99b3:52de with SMTP id
 d9443c01a7336-2076e47cc2dmr175945ad.10.1726087348954; Wed, 11 Sep 2024
 13:42:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:49 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-5-seanjc@google.com>
Subject: [PATCH v2 04/13] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Assert that the the register being read/written by vcpu_{g,s}et_reg() is
no larger than a uint64_t, i.e. that a selftest isn't unintentionally
truncating the value being read/written.

Ideally, the assert would be done at compile-time, but that would limit
the checks to hardcoded accesses and/or require fancier compile-time
assertion infrastructure to filter out dynamic usage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 429a7f003fe3..80230e49e35f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -683,6 +683,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
 	uint64_t val;
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 	return val;
 }
@@ -690,6 +692,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
 {
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
 
-- 
2.46.0.598.g6f2099f65c-goog

