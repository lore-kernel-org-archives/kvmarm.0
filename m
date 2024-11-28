Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C679195385
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797350; cv=none; b=jUNHCXRBkRszbqmsku+yJgne/RICH+NCfQKTDn25a3FMnNU3cl/JsiklccrC8kvmLWeHlId2IUuEzrkixPP6L0oBoK4hiQ9LhkEAE4+Eds81rjptlvaw9QnKEfKykPyQVdb1osbQiBJIzsDuBd7aRWguTR3OsV1FU6DjELELfug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797350; c=relaxed/simple;
	bh=/lzy0U4F7XjlWzN4QPFJnQvTI8NpGDbJSAZd+y1nVJU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UjA0K7G2jtBNIfmcNvhfdUTK1P+tB/ERIVoZkhLc2bCQLbRUkoTFse/lEw/auWHzd6otm12mTyLd4e6XXEMM1bgP4TnpyIgyzjflPSsvEC6yzvsbtlgi8L8+HVGhCv3n814n20nXQKAeRACU0zNZeuVlLUpBGxqQ9Gx3UfizhBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r0mCLTLG; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r0mCLTLG"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a6483514so5927375e9.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797348; x=1733402148; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSUc+JlbUkcJTV3hddKcfnf/DVsTc1Y11IkJDKUo+M4=;
        b=r0mCLTLG8oqOp2uXmXR/aKyirgnSqhMNcvbsWEbzMXoM0bRoZHPTx06UqCuQZa12WO
         i04SfawP+qq+/qNZiZpmBggI5LbkNY8x3gfPj63dq911qb6E6Ry8s8e5RxnQmUd6CTEk
         +4Sy3aUH9bXv4reKCTz6dLpxshi4juj8ezRgFh6/cOb/+eLsV4eQ4SevFYWxTYOqAyEG
         eij1JzWFw/efE8JkRJ54fw800ptLo7BKpDtfD3/oVGYB96W8TT4nN8yU2TBRXYLfWLP8
         zJOg13wtTnYtKH5r9eT1eol530QFJERl0nI1gFKzE0OLikdut9swxNLLj8DaKZef8MjW
         I4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797348; x=1733402148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSUc+JlbUkcJTV3hddKcfnf/DVsTc1Y11IkJDKUo+M4=;
        b=sUx5DSHKYFp5xQ++ruyu4n+0zrmFjlIHBoUmBC2Y7t8klqG8gQjIB4CpHISnHyjG8E
         IcLDv4qmEtNxhnV41zcYEgMmH5w0aoNYw6LSyDyp8KGjkHPi1KcKnI3A3zFTEacd7bgH
         RCw6wUFlVGJYECxjOBjvMfP8fwOgYVPRvqeGMgDKk1lk/DBM6n3eR0Ql7w0ze2dC4xvn
         mjQ1Usa12US/5GOlhhlcc2ZPdTbwcDyEeul11jUo7kIDd9lG78KgyC5mVFTFgT1xz/Yc
         exMApdzPRD3DvcQe677tXRz4AQ6/IJGIWHooXyC5w5k4tEYXssESMooVeLoWNjQRhGSo
         bdmg==
X-Gm-Message-State: AOJu0Yy4Nxxxj0TpJQmTGLBF+T6Bss7PaXhKrmg88dM4EMgJdyE19IDP
	lYFNzw/3gbdJkcYodyaRRjndUbxnJmIXOg8m7BKAuKXBBs2+N93ZBkeVyiETR5OCi81AP884SqW
	rzoJ5XO/YfvlKmUF09WtanK9RQhhZrmuWfkco/dox/zFxEOBZ7z0BUSwu07XFWSB4j0uNlarEfr
	KoxFT90GaCk3B4DP6b2SsCieKeekQ=
X-Google-Smtp-Source: AGHT+IHPGUBbpJOX261VZ8WL15DveE3B5R1Hl7n4v9aOK6eYzyyv6fZdkCX1pbszmw51LoEme5rJDfOL2A==
X-Received: from wmlz4.prod.google.com ([2002:a05:600c:2204:b0:434:a0f9:be9e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3546:b0:434:a83c:6a39
 with SMTP id 5b1f17b1804b1-434a9db7b5bmr72740785e9.3.1732797347848; Thu, 28
 Nov 2024 04:35:47 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:15 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-16-tabba@google.com>
Subject: [PATCH v3 15/15] KVM: arm64: Renumber remaining vcpu guest
 configuration flags
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

With the vcpu's SVE and PtrAuth configuration flags removed,
there are gaps in the numbering of the cflag bits. Renumber
VCPU_INITIALIZED to bit 0 to remove the gaps.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c5c80c789ad0..2e4afec09728 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -864,10 +864,10 @@ struct kvm_vcpu_arch {
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
 
+/* KVM_ARM_VCPU_INIT completed */
+#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
-/* KVM_ARM_VCPU_INIT completed */
-#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(3))
 
 /* Exception pending */
 #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
-- 
2.47.0.338.g60cca15819-goog

