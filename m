Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89330D3FA
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481350; cv=none; b=d1l6bNYOkZws4e54kfBKLm6NDXq0lWSSHABDFnt+BsclqgN4rulTSjaIyJfCi5wT14M4VdVfEIhz4ewXLx930RGhm6qoCyEMNWXA2ueYvOB/CPii/bagVKP9kF/kIksacQXz+cuC3iLIdpKFNlBnPvqukCQCewKnJUdXySFDUHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481350; c=relaxed/simple;
	bh=NCklkokdvmbYOYomiBZQpm3ulDs/oMA5t4gf7jJtFIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UviEt/K4sRM04qnEyK9qKLWc+8ubYMQ57e5erOYZ7BJJqrtKmJZhBjWzL5jQngL62b8AhhBwGPt2gT3riQvF2YzfM8q5w8kUBd6jhyHYRcCBnCBUpAgMmQ6hVBbmqbel5LG+eu5ibGQryIrQuKtvj2ZXBhdAUrHvd2RMzA8VW9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReXAkXRD; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReXAkXRD"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa624ff3cbso895126e87.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 06:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782481347; x=1783086147; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M7qA3QCgngkwupOanC4fj5zvyRgNy6GXvi+NFYgoU0Q=;
        b=ReXAkXRDykaDpvgAYWbCYoEVONzJe7Uwxdu/EmPCj9WRoNkKWphZG/v7hNNBlhL6RL
         J5t9cFD332b5WdjFY4KJPi4l+jzPfl+RdJicCmg3OlNHq5GYoNcMIiuhd8FBsn5LDI4T
         tMC6zKgKVIpJrmUIrHYBRVHumYDH3jIqqb2MVuunDLrXMupvMn0QpEx9+y58yFy3TJqa
         5lyngcahka+8s/HtPPxaq5yqK0/1fvUSUNoBppQkrpRfI1oA4dBrQ8OJEV0oorb76hjO
         nZROtUR6FEuUbzzHm4fF/+ep4+xOPcg3AabDX93XjjqU52QFiySx/n59gLpmpejMtH/T
         N9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782481347; x=1783086147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7qA3QCgngkwupOanC4fj5zvyRgNy6GXvi+NFYgoU0Q=;
        b=DpWBf+wwxBxKl0Hf5jZ8otRtl4M44OZlLmpiRizQ/dPiTV/84tWEkjdIzBbqQeGMFT
         wmuO/rrFV1X4+6xJXGMMdGbCwbpD1q95PWZjc//Q88mJ+bSN00YSLM0O9SZgqmtylAK5
         u8vtcv2k3qkd3Amxmp89h/z1m7qNJ/R7MFUET8uz2x++8jtTEmiI+zMk4oQdQbakUKdf
         1pqzZzn/MK7lkO66q3A+gRCCnDq3uzuqP62nHiAwoJ4CBvgYiN/vmpJV7ovigObiUyy4
         xI6KfEQiRJFKrF/7d/iBDAhP0IsI1WbY69fYhuYsh0oMdjW1iw6B6WLYiPqk9hk8lE92
         0bsA==
X-Forwarded-Encrypted: i=1; AHgh+Ror6cicg5GXw41U11Y6yC5Y5+aIrUdylxKWBkIYEJ+qWY3YziYZZimEARdCXCi99oREpmGaGKU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLKadgwTgg/Sa0fY+JetXNWebx3t48kHgBMsU+ZVclmk+6bFd6
	1DsiWPIGnB+Hxl2oSVdg/AvwpgmGsRMRqJq7YRsMDg1sJm+j6/bjQj0q
X-Gm-Gg: AfdE7cnV1OEw7WsajmCbDdHaTIQUYC8rFJeiIhFEaLpmYq9Q4O85KgF7VnJzgIlObbS
	zgFrtu/WDPWGzgly2XqjAdv6T9yzFCgKlO2Cs+iwUWRLfyfWfh4Vugvag+HXUa1Hc/KLOP9y8Uf
	DCo3mv3sEfr4poKtJo3VEaSaMwK0JOHdZpUC7HN0tndAIgHGTbVLG8t26PowmqPaHtO7rTkvdqT
	eZywRWMhuqnOyMYaAj3cgGbjPT4RgdPMm6h5RqJRRpb76OvL1HaCfmJn7AyXtyrHiBsooIaAGJs
	JhS5eXzHPf7m9W43eT0OMEqVie1raj1NxSDrhgk1ZMyudV9dQeavsBeXdio+W1jyovSzUODLd27
	puLIBTBw+PsyeEo8MVaW2N21fSfcLoFWM/lpbaFButvTEi4+SEfMg02DFj+7Ac+rRSRRAIKD5nl
	zRbPTK5xCq2PhHa9ba4JOqtZTC6jaX
X-Received: by 2002:a05:6512:2521:b0:5aa:68cd:8367 with SMTP id 2adb3069b0e04-5aea1f51f08mr1686486e87.37.1782481347149;
        Fri, 26 Jun 2026 06:42:27 -0700 (PDT)
Received: from grower.astra-academy.ru ([185.32.135.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69580fcbsm3476839e87.67.2026.06.26.06.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 06:42:26 -0700 (PDT)
From: Alexander Martyniuk <alexevgmart@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Martyniuk <alexevgmart@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: [PATCH 6.12] KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation
Date: Fri, 26 Jun 2026 16:42:07 +0300
Message-ID: <20260626134210.228892-1-alexevgmart@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

commit f2ca45b50d4216c9cc7ffabf50d9ad1932209251 upstream.

walk_s1() and kvm_walk_nested_s2() expect to be called while holding
kvm->srcu to guard against memslot changes. While this is generally
the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
respective walkers without taking kvm->srcu.

Fix by acquiring kvm->srcu prior to the table walk in both instances.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/aiAZfdeyanIvP8SD@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Alexander: __kvm_find_s1_desc_level() not present, patching only __kvm_at_s12()]
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
---
 arch/arm64/kvm/at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 39f0e87a340e..8192bc0bbc87 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1087,7 +1087,8 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
-	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return;
 
-- 
2.43.0

