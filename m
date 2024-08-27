Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50A119DF5F
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748373; cv=none; b=bJqoci7lleCKv5pL3j9uiP96jojc9dR4MTm8wWiwdZCW9e3YFYkBb0kcYlFeolElVztJ6tzatC692oQc81LkYSNfnCGhdwhchm7HUdyG74luk0qLnOO6fa63cZgly8Fns1P5waE/xzsX8pi78uxmGvwAPBXgMbDOaKOJTYsKBg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748373; c=relaxed/simple;
	bh=W/gned1S2aEgveAzwGHcVts33uHXT+GTG81W6x5AeTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F4zCq//hxY2jJvR56xVXVUzPtKj32xemscU9W/cFYX+e7clzcpEpv005yuuXt0cSY+SA+PnfruQbThEk5w88483TEq6UCnnGaWWJZq2YXo3nRvEPSXsqUp28T96lw8lTrdhVFxaLgKFZlgn8iC2IKKY8tugLM6oSH7iLn1eZB0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0FNNyQJk; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0FNNyQJk"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035949cc4eso10158360276.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 01:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724748371; x=1725353171; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ujfkbxajYNAV9coR+kUVXeI3lwos12vqL1v+iOvXT9g=;
        b=0FNNyQJkwMUIp7iYJm/RQ0vxKt3wZua7gtUaWQ9TgyC9aMVJR6drIhRxvYLsNGuA5f
         i/RGPZEPWvmvfu9ObjpqYgGDvrK4fwTIEas7kzzdVovH0TlOHg9EPWdd5OoXCn6t4FqA
         ir+CDEE8woKRKOKX5RbvxBmbTDR6OVskjyM8kOVSodFyAf5ry+WIZLTlcklv3gAW4sbU
         3WxWVjE4nGt4S1Z4zUl7pM+uzWrMB68dQnnJ2Rr16PzIqEbbdItfrPmv0a/7WRZlNJn8
         zuFBh1aHz6RadpkqCmc7wiSyyRaYmd8Ilq9kOqri4hfb0p2EGWwei1Rz/cXdshXX+GxS
         vEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748371; x=1725353171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ujfkbxajYNAV9coR+kUVXeI3lwos12vqL1v+iOvXT9g=;
        b=gw2yi73+korUdeEOxL4digJvtXIwONpbBsoiRc3nchALbXpv2GZQ2JTQxYRGn0zHUt
         O5JjiHTJgD0thN2vgJF4GMqAdKqkwRw4Xfx+vJx9Bwory/b6LKbZvDjKi5tkYVl0qcGq
         NiicXV+Ydn9TVGEixgLV/n63fP5MnyEwYYKqs4KY/kFhEaY00+gf3W5qk5++XgNeIOjM
         MkLSc8gCv0+p4Z8tJo9EI9Em43+Cgp9n9lqc4X5jAZuLQEyxYrw9dI/phTkSlYMh3De/
         Zq14X6SK4mHnW+1ti+CIKiWHaV3buRHjW5DswDnJa0y22JKRNXvWI2uGQT8t6ogryj9/
         iKSg==
X-Gm-Message-State: AOJu0YxxO8aBsxLO6OjWtm1B63Qq9OxefpRhaPZd7S5HUqM8o0FqY5DT
	nhWeqJzYWaPZs1elNiFcZUNnRb6muTyvhFuBMNDxtZleoR/C7gXjAaVMnIEVfbMavH0w1ziz7kl
	ckBYnPHGtaYTwTqax6XStCWpt3A==
X-Google-Smtp-Source: AGHT+IHOHuHbuOJF/L350TjQeQOZv00E2Fvna1Z8JsFoQh3TFmDrKS4V7q2AmDtj+RMoJ+girhVAzT4/oTPRZmzkCgA=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:a4a2:0:b0:e16:6d88:b8c2 with SMTP
 id 3f1490d57ef6-e1a2a5a6addmr54600276.4.1724748370673; Tue, 27 Aug 2024
 01:46:10 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:45:48 +0000
In-Reply-To: <20240827084549.45731-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240827084549.45731-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240827084549.45731-6-sebastianene@google.com>
Subject: [PATCH v9 5/5] KVM: arm64: Introduce the PTDUMP_STAGE2_DEBUGFS config
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

When this config is enabled, it exposes the stage-2 pagetable layout
through a debugfs file.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/Kconfig | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8304eb342be9..ead632ad01b4 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -66,4 +66,21 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config PTDUMP_STAGE2_DEBUGFS
+	bool "Present the stage-2 pagetables to debugfs"
+	depends on KVM
+	depends on DEBUG_KERNEL
+	depends on DEBUG_FS
+	depends on GENERIC_PTDUMP
+	select PTDUMP_CORE
+	default n
+	help
+	  Say Y here if you want to show the stage-2 kernel pagetables
+	  layout in a debugfs file. This information is only useful for kernel developers
+	  who are working in architecture specific areas of the kernel.
+	  It is probably not a good idea to enable this feature in a production
+	  kernel.
+
+	  If in doubt, say N.
+
 endif # VIRTUALIZATION
-- 
2.46.0.295.g3b9ea8a38a-goog

