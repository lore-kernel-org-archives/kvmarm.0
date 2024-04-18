Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD3615B99A
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457907; cv=none; b=poiN/oKGo5znyKm7TNS5UCD09EBlLW55DBXibAy8sJGNFQ0KQMz7iETKd3P56xBKZiNkOCjZS+2sEIYR6tjwRp/HAPJAPxpy9BUzLMA98+Wws68TFTXzodbStI4MNGLUpyHBqe82G3qcp9VGrJEU+SKyC9ULc6m5c5RRpVWhBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457907; c=relaxed/simple;
	bh=uv6SeJOZqNMKJXrWuo9i8vh/kcHxg3z8em90y16wOHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XiDLh/6pWYHO8tF4VVXkEy3S2FKP71Sd/bC7LeuW+xN3vvmtBEwjE4aIAdDuJZiKpiTErOOdet7birk2toteVXqQajh+fVO/GK+FSyrtEKBE9g2oOOjs/DGMFxYPNmYqGq3IhfSSE06iLOd+0cLbRXYwQeY5/oGMpg0cLPLrvoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lTEhwzBA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lTEhwzBA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-417de456340so6218845e9.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 09:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713457904; x=1714062704; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d3k3yKff6xJXH10XLK8AgdBXbkXj7KdOIqksXGEh2rs=;
        b=lTEhwzBAnttkrm+slLvOzJnlT8Qsgu/78XVd+CvZ/W9qf5bhJKsei10gSA915w1vH7
         esTi9S1KW8s5fahcO1+/j+D4syICEjhBuxLrAbWFmOZgtK44FRPnXBmFtbNM1NzB6g/4
         mjIM3Fukj/BadRLZmw74E1WVYn9khPkmSYvhnKjbSGHiahn4LlvSYQmUUEeSPZKyl4WZ
         3Nn+BuZH3XF+fqzgY+aCAgiU+sQK7oLbgMEm4cdO6eFQmGdL9WLp8YkLMPOM4K88wRf9
         UKIPyUgcWknMZUjF6/yYCQjfVqLvCgc9/Ml38XNwYk3CM1RzXvUrHFg4EnG5k2i/ZdEK
         k/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457904; x=1714062704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d3k3yKff6xJXH10XLK8AgdBXbkXj7KdOIqksXGEh2rs=;
        b=t0isOXRkl3lTsCPD9TsBilq4pp18R2Adwkj6nrW2XKH4r/JcY/qDTe0kZgsrDhnyTA
         3fOUlXMX0BJUv5aadRqPN1gkYWarKfBpDQMXYGUOn+FLFYj41k7AwTsC7jSpV1HDvUtb
         hDppb+G4yyxWQea9x0yzr69w94Gl2Ajsgx+/7cBH4fScFQMC85TTnH5XkuPrTOmxSQve
         nNI5HlCBxicNw6E1ZDDJWf0yBk+pmFKtpgu0TvFJuQVPp1iN5j1HyxFuOycio7PQCnkN
         qMtSuLYk+lM29px8tHAJaVfZxyt6hMnTWO1UAUA2L29uhR5oYYz1fIM88CNJHLOW/2EJ
         MneQ==
X-Gm-Message-State: AOJu0YzrCQWT7yY5jD+1RNLVu/xJv2dAVoD+YmqzjbXtq+pdfZAJujZi
	QWh08jYZ8CWPKOus4G4d1SZslpiMewaWIYDHP/fjlCtd71Bvzw6Mc1MEO0hCFccW9lHgxeZtO6W
	I1rWbVhNKyDmC0jxOCSx/ZI2c/w==
X-Google-Smtp-Source: AGHT+IGjXKYnowAl0A+gDIzd42aCq8JkZ+PEnaC8UoitJzLnXigFkbCRr4zVMgwW9T/SvrE5pwKJk83JUYctRFJ8200=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:1d1b:b0:418:d6ae:a3fc with
 SMTP id l27-20020a05600c1d1b00b00418d6aea3fcmr17191wms.2.1713457904328; Thu,
 18 Apr 2024 09:31:44 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:30:23 +0000
In-Reply-To: <20240418163025.1193763-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240418163025.1193763-2-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240418163025.1193763-3-sebastianene@google.com>
Subject: [PATCH 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM hypervisor initializes with FF-A version 1.0. Keep the
supported version inside the host structure and prevent the host
drivers from overwriting the FF-A version with an increased version.
Without trapping the call, the host drivers can negotiate a higher
version number with TEE which can result in a different memory layout
described during the memory sharing calls.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 43 ++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 320f2eaa14a9..023712e8beeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -58,6 +58,7 @@ struct kvm_ffa_buffers {
 	hyp_spinlock_t lock;
 	void *tx;
 	void *rx;
+	u32 ffa_version;
 };
 
 /*
@@ -640,6 +641,39 @@ static bool do_ffa_features(struct arm_smccc_res *res,
 	return true;
 }
 
+static void do_ffa_version(struct arm_smccc_res *res,
+			   struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
+	u32 current_version;
+
+	hyp_spin_lock(&host_buffers.lock);
+	current_version = host_buffers.ffa_version;
+	if (FFA_MAJOR_VERSION(ffa_req_version) != FFA_MAJOR_VERSION(current_version)) {
+		res->a0 = FFA_RET_NOT_SUPPORTED;
+		goto unlock;
+	}
+
+	/*
+	 * If the client driver tries to downgrade the version, we need to ask
+	 * first if TEE supports it.
+	 */
+	if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(current_version)) {
+		arm_smccc_1_1_smc(FFA_VERSION, ffa_req_version, 0,
+				  0, 0, 0, 0, 0,
+				  res);
+		if (res->a0 == FFA_RET_NOT_SUPPORTED)
+			goto unlock;
+
+		host_buffers.ffa_version = ffa_req_version;
+		goto unlock;
+	}
+
+	res->a0 = current_version;
+unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_res res;
@@ -686,6 +720,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_FRAG_TX:
 		do_ffa_mem_frag_tx(&res, host_ctxt);
 		goto out_handled;
+	case FFA_VERSION:
+		do_ffa_version(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
@@ -726,6 +763,8 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
+	host_buffers.ffa_version = res.a0;
+
 	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
@@ -772,9 +811,7 @@ int hyp_ffa_init(void *pages)
 		.rx	= rx,
 	};
 
-	host_buffers = (struct kvm_ffa_buffers) {
-		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
-	};
+	host_buffers.lock = __HYP_SPIN_LOCK_UNLOCKED;
 
 	return 0;
 }
-- 
2.44.0.769.g3c40516874-goog

