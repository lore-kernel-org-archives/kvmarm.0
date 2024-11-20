Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF615B135
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100009; cv=none; b=RygK4Vz8MUz3Swesum+cgjwOnQoyo5tjJAbl6AAr5s1aDAPezrTQsSdKtYydLsIIROBsvcgjj1S3ocXmUE3gMkjiZJOkrDqBob6Z04iS6sY55kL8ZQGULvSj8a3Nb3pjzTaTFdNkaQB1JLucXKvfpMimJvtAG13/dySBozZEbPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100009; c=relaxed/simple;
	bh=9sz6YH/zilodWhOY8qTpE2Gjj7fQpoTypR6OYek1uVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GDUlgrXfKqCy+c2flpNyaEYfGQ+VMkUZUMyTqbHYAXD/XHTL/H8Uaj3cO5QTaWSZO9Lk/J98oiioqKFSQR4D7qzSPwhRwFdtCuOBD2J5c9dBIwqBzllu4hYdu3MlS6n0wCqHoWo6mwJYKK0xBISdV/Z4DKWlRNfd8SIUjz/aWQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j/4qRSVH; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j/4qRSVH"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38235e99a53so359502f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732100006; x=1732704806; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=otK6F93Vu1cX9TaP11m2Y2QryXuFz9NU0aIFOkiC1D8=;
        b=j/4qRSVH+dd2SSA8SGDHBprXRQ7pTVzusepoRQSq2E4NrlpmtapcK3zMW7tXFcR4iz
         f7DyeIcmjWvrNRg+UEmEFWEi7mzwstDwskNyVe+HCz/BLR/NeI2MpgvfXMev4zdm7zQP
         K//HzZZh8PZxCyF2yGwFDqzJxUehbya+XbFW1HNtNetymc030d6XjBqKC+kq8lM1T334
         1jcXlNzUKQZUoXbStDVTFwD05h7B10dDQKa68NLS2qs0smjvSw5lapUZ/PEvHy4BM0Cs
         GWI4/Vxh15XiuV3XPZAmvzEFJ0Qz5meky6bnAl5eH6j0XJy5JQnT5oBtGH+cyvG27B15
         f9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732100006; x=1732704806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otK6F93Vu1cX9TaP11m2Y2QryXuFz9NU0aIFOkiC1D8=;
        b=cT/vPIICHk6FOeYH3MNcvA2erCc96CKNFrKdyhzM9K4hiTnNcMgUAxQj9L9H38fx6X
         UY8L36M78EhEoUu5ymNzG7noH2NKKoKyaUJNWOGCGSA10wO8aQI4OKgDS/g6NHt2ZXCd
         qYUb5QH+BkDLu0keLFA4Xr7l0fl35qCNMUcperseeaC3rAOVvV1katpm3EuFKX+OXu56
         FiQmmV/2/LsH/IYFgYH+ROh6QRYi+PipVqrD98lyIG6/BSsMJp7ya6V9TmzCivn0WUvF
         10k9Y0PSLahcGsfOqdeAhKa//fjl4SukNdVkBkcbOquC9+M1oPOEFw+SlyzrrGOP5t2r
         dNUQ==
X-Gm-Message-State: AOJu0YwbTB7W8Vh9tF8Y2R49fqmpgHqRyiXhfSVXKJm8UZetb5TNWDKf
	8iRLtleAcjrOjRIjSbt5/Dot1jCTx7WYmcRWc1QSluPRIbCgq4dTCBZgKZDq3CohYpSWyuthJke
	uJ46LVrvcqSdAd41uRNiMdS7MDkpUulSbqF7gnUABpsYCuhwpskTsKjcEU5luEfy8lch+IuB+wI
	DZyuPPjeDpGO2JxIWhvm2jaQTJ8LI=
X-Google-Smtp-Source: AGHT+IFLMAX/63k03WDt22YQHM6Q6kyUAtxR/WjHVGa/qbz6yho54YcU61tg0uhcrJaQaYFKwiLbQBDAfw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f748:0:b0:382:49c2:fb12 with SMTP id
 ffacd0b85a97d-3824cd4e421mr2898f8f.4.1732100004722; Wed, 20 Nov 2024 02:53:24
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:54 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-13-tabba@google.com>
Subject: [PATCH v1 12/12] fixup! KVM: arm64: Initialize feature id registers
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 54f23d9fea18..62d06d5f5bca 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -477,7 +477,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
  */
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
 {
-	/* List of feature registers to reset for protected VMs. */
 	const u32 pvm_feat_id_regs[] = {
 		SYS_ID_AA64PFR0_EL1,
 		SYS_ID_AA64PFR1_EL1,
-- 
2.47.0.338.g60cca15819-goog

