Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9722907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261499; cv=none; b=rIOrY3AB1Elj7yN02FMrBFnyzs2GqujLgHd+EA6+6Oew8cxgK/8fTZAPi3MfylsDN30MlFIgIdfKedm8t61tLeuu2jLW67gTPI9yuT7MtOojn6Tddg/zZY6q1Cm/CNKTAbU5GHSzrgBHL9Ma9KMLM41KEFofriH17d9zLkhO/TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261499; c=relaxed/simple;
	bh=8phGIMdOytbodd286n9T6pGbuflDrtGAgmUivoTbEDQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pS6GbynglK17W41knAYYUEoqyxUHNSJ7AYCXS68HAyxuBA3lrtE1kMx3GHySaGsSgXPznLC5HZkzv6OKiySEbu4iCqntPY+q81xb78Oxxl2YxclMTV+WlR8QDeWsQvk0JRc5yDxd5PxX10qeG9PHgA25BUt2/y5PHUpmhVfjnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o/BvkDrl; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/BvkDrl"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-346b8ef7e10so2206919f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261497; x=1713866297; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=huViY8AkKB/4gw+1e+nzO4wdgNN1i1j2ZDnbQeyb99o=;
        b=o/BvkDrlB45zdcVf+kWpVbCoZ11oucCeND4NNoWfdsT5iMv58ZwOgkCl+fKDBT3GZ0
         9zI+5FHjP5qSERhQOmzjtX19h+Jv0jQAc3Fm4sR1PR8yDEbOQLFiMHKkuS1ik1Fur6u8
         4tIAK8HhmfUqGqbYxH20OeNC5UVxyNshuuYpiBC/kpNnL26wUR+caiJC8PZE+j6XhVbr
         argsBdCXXGyk5P8xk9XDuwyFZNlf5j1jLdEUZWJfnW00JAkmt7zhnbJTa7LmIT8QiYoD
         A9v2JnYC9XUKHdl1mpWh/C4X4ks16edXi4yAMNeoiLr3KNGlDJqbnYNe4Bl+wS7o+xvx
         Ltlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261497; x=1713866297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=huViY8AkKB/4gw+1e+nzO4wdgNN1i1j2ZDnbQeyb99o=;
        b=w8y73eE85J9JKic6agty52xLCPnPYnqhZcFCSQTXcWumI5qzmKlaw9y2dl65Es+2Fs
         y2oljSQVlhjDpgbeIyb7DQkthRJUwVG6umjULc120wlEmhpKKbcSB2AW8DUASiPHUH6l
         RTo6PppNwskI6sHZIYExTSPL1gdmAHa9lhNksZGHDQ9Mx8RqgTs46bmKOvL1GvpOh5r4
         NqcPqviHZzg9IvuDwdaWwNHXAwWGMkGIPeEg6GpaRW84FjaM3aZaUVrVnnC6UHW0FXIg
         wlZ8N3rMuxyxngWQjbWmLgiTCptriSF7EL90OVLK3EQx3h44lasXgjatq7xv2Kz4Qqqr
         7k/Q==
X-Gm-Message-State: AOJu0YxZpDeU/jvEoE9YlBOoe4uS6WnT6n08MKViMiKSAcLqjqg8Y6Yk
	/nhm7akTz5rNFwT4qq+vbaNdecVNwrENGlRhvNyM/3+8te7M91gv8MLQz7Z6eZYGTkrrM6H3nVB
	9nXU1/MS+zgmenVL2qE+pAqa9vQ4/rsl9fChBWMDq/Z/J9wJWCHV45FW5+iRPSb7pcM2+e+zRyu
	zm++j1kG72vjxEowNIaKPSGO2cBp0=
X-Google-Smtp-Source: AGHT+IE4lSFQk373yRzWUFd7LZf8DbPSkdAoLwSx/Wpjyvdgp81jtY28RRSC1244AqqrWA4FEi9CZvaWqg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e38a:0:b0:346:35ad:3d0f with SMTP id
 e10-20020adfe38a000000b0034635ad3d0fmr23790wrm.4.1713261496587; Tue, 16 Apr
 2024 02:58:16 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:33 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-43-tabba@google.com>
Subject: [PATCH v2 42/47] KVM: arm64: Advertise GICv3 sysreg interface to
 protected guests
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Advertise the system register GICv3 CPU interface to protected guests
as that is the only supported configuration under pKVM.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 970b0cf72f7d..40bebcffc9d0 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -45,11 +45,13 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 /*
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
+ * - GICv3(+) system register interface
  * - Data Independent Timing
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
 	)
 
-- 
2.44.0.683.g7961c838ac-goog

