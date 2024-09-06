Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2881C7B95
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725614884; cv=none; b=AjFpUkR+dctU5xy2dxZ3z/tcfaUJc//N3GgTYzwGcxk08f3nFzuLZoVQZ/+zDMwmVm2MCFrxqdQK7I0AVh1J3FcsSREVBmtLcFgPJbybc9kP0UWPBIabh8XpjMSp1DgJK4EoT+CkpyKnps8vofUQOSxdi66tfleSDB9QP89G/5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725614884; c=relaxed/simple;
	bh=luTtkRSdHP9G0pXhIP3ysKRyBfMKHTLmhzeh3Hgyprs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pUu8HBf/GjGnVrMxmDeHWvocZ/wQuz/wB1Hgucdz6mA+UKrZRLyESh1kSzELOKy1sdGLIAiiyvrv6im+JgiJOr64gUaNNTHV93EFbhGFJ6hcL5kon+s/BI2ztCIRpPnqhRjvdtND+/58UJH9Y4RRxcQFJrBC+HxoEt82G7qNetY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndndVRZp; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndndVRZp"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1cf5a262a1so7010358276.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Sep 2024 02:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725614882; x=1726219682; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NL51OiKKXYrcwrjtHOrpmmV+PQMlb7GKuARQtOGoLlU=;
        b=ndndVRZpgvJV5JpcP/XseyyrTxasIhIi7mTaSysgDjoLh5KOJLXykpUX7k6Rh8jq5U
         oBVF5AQYPVODCbfaTNfAjaZJF+pSN1qlajgOBz1LDuWgeDWUFcTBMvnYQQaEQ+l1ffGC
         m516cTjZ1/elucstf0wnGMtQpy8HSrG7endi3dXzoHDB3WnMbd6Ja54y/Qa1YqSWAaz/
         bDnnmXZcgPvDp/qM03YVWw8SjKQgBQgkQI5V2cSNn72X4+4Bf6UbRh3ffRvRfkyYax52
         820RGEFjo6ZnxCXAwko0DRoPaF4bnfg0DW2iBekF1/ln+eKr62IHPG+W0uLC65NuVQb2
         H7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725614882; x=1726219682;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NL51OiKKXYrcwrjtHOrpmmV+PQMlb7GKuARQtOGoLlU=;
        b=Po/uy5ixvrHR7KrLYYoyE8LleuAUHKwHE7fhRdRuDyKhfeMsXuLth2tvKEXs5QTl9K
         Bpv8gECL+0DlKy4Srg4wUbjISVoXIHIi0Ekdek4rQB1pLlnRG7UMxW0uc1byENDzfM8H
         p9rgS5deG+9lCLZQjlx6DofCf1QhPekZx0QYBkf1aQr2aoaMipr7DRzm5sPDtfA3a5MU
         GHQAS86SLuBYG1igSPuN0saQ/GRGnzVLfVpaSc5vtM5MkNvQiJJvFvBmfxGym12fo4N/
         OUpdNaigkGVm36EngYyVE9LRnEsKo7e3ZnfjwuMkobVFb923aOY6DlZquzvpJY5qaOpZ
         vGUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBfLTao9if27xFouVdb1Krro/Hpt/ogx7ghGNZa3qBsx635CtvhTTZxQm5eo6e6H12e181EMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnGfustE5x97TY2LwDk5nR0YcYomUWlOYILLsegdORYJ9IuhAG
	+ZWlnSUb33z0V7HgYcLxCOSBXYjaMfgHCnDicqS5ziVPSEyC6SOZQNQt/aVm1xUNMiisSxIFUz0
	bralWnLXjnmvOzSkM5XQjdA==
X-Google-Smtp-Source: AGHT+IETQ552AARnKz58C7KCw8wpKdRMaB3Kp2FZFfwlE+pb0fqKNxnYrW28FK9E2Bv9ErnO1UiOPc6M5jWgsKuFYQ==
X-Received: from snehalreddy-1.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:c1f])
 (user=snehalreddy job=sendgmr) by 2002:a05:6902:2d43:b0:e11:593b:b8e7 with
 SMTP id 3f1490d57ef6-e1d3463e2d7mr11298276.3.1725614882036; Fri, 06 Sep 2024
 02:28:02 -0700 (PDT)
Date: Fri,  6 Sep 2024 09:27:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906092732.113152-1-snehalreddy@google.com>
Subject: [PATCH] KVM: arm64: Add memory length checks before it is xfered
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Snehal <snehalreddy@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Snehal <snehalreddy@google.com>

Check size during allocation to fix discrepancy in memory reclaim path.
Currently only happens during memory reclaim, inconsistent with mem_xfer

Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e715c157c2c4..e9223cc4f913 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 		goto out_unlock;
 	}
 
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-- 
2.46.0.469.g59c65b2a67-goog

