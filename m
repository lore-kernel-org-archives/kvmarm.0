Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267E3AAF42
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 08:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844591; cv=none; b=I1944WfmHdJRyyDutg8QZa9FzAQcFsI8uV6dEpll5sQVQXIG4UdMiP9j1LR18nhHecyg2JOrNcH6lrlBsuYZYDXsNKSp0KEnN9cqDwVPD052dpN3Zqcx7CTZvsIppVA6ANeV+FhcYQ9KGZnK+UTMPnwfPHT3E9XmAR1lkNeqqjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844591; c=relaxed/simple;
	bh=MyIGsFUJHSSN020/lGZDzxBhTSfBffcGg2TRTOb35kA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GDBYzCZ9dqmXeM69y7EoD43h4PRViK21GJPYgorn/PzTrFWlMBjSA3kcguCNzco5aSuHqwFz4jh3m2ZcrZVZ/K/XiRgxs7jcoge9TLNspZLb6F7TyuJOozMOx4kYSipuqVZNIAMvaabGws5u3xDEH3l+BBVgbRqKQbZZn8/lXSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVOgmGWm; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVOgmGWm"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a9caf60126so6728987a12.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 01:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790844588; x=1791449388; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=vVOgmGWmOCFmYzDVC1KYijPSX5mFQos0wmOqkr8Xe2gB3URpoBs9pjIAtsCbvpOUqi
         uILXUjn4MwfvCbR20nsJveTF9jaSCXdCZmLRq/GZddI8Lj+/nptOUcXg557YVg/yRpNq
         Uc43ac84wjHoV+2WU54I8KwZReY3LJaFNXJM63DVrY66GxZL0XL9Cq7arGPxsBYIxvMm
         ngFTWTOTlV3GUo9a7vJhnRQNR7MDfNYvMXmaD3Ht+pewnH/UpZBdGM1SJULCR/31NP4W
         pzJOFcCESEm0kzda1fknQhQ4ZiNApEOm6mloAqCFOFlFwxpALwaLoZ4pwon3lgABjahG
         EVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790844588; x=1791449388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=pKFRIkHANhifYQkkTuH4p9Kbh5uaK+Al6/VJ1E9UvFJOsb3keXyaQUoT3xqj7e/hqH
         q4I7EUlEMiZCLsX6K/TFQgLsHy6w+M48tvjFw+R3ScvdkSHzlEBmkfoChEcgfpQJuDNa
         nls5RuCZiUQrgLeiG26pseVZPqA3NvmLfsch2IYcgSzm4ny2bOGkohb7F5QY5IpPPOM2
         5g8A/xgHzvI8grNcnGMRV5oDewpJq0aTbUPMrU18F3IKdrfr3MScSHcCtJp/7NqjWbJu
         VtYi4rjfIHOot+nGAOjoPo20vWwf/BdlZbzL19uBxbaIjO/1I+MB9ri8WI4kc4Pe/svq
         mDDg==
X-Forwarded-Encrypted: i=1; AKwUvBxw3ab0Zg+mzbXMa0xQuZxzW+FTp+a+8Ez4AXhuM+tashFUsf5J5sVZnu4NZExWA8+9jNh7xVY=@lists.linux.dev
X-Gm-Message-State: AFq9FYIbiIuo1Avi9ZPQFq6qUnll9X9VULQLefncRIsEh5HciyIuLndN
	y3+b2BFT+w6bb8jzKKAVbbQT80en5yBqPw+DMYfRRjEQnQS2As2k9b4nDbnQg+JvQ61gvZjDyef
	2diMOQSmg9QPUxT1EHTFg8A==
X-Received: from edya22.prod.google.com ([2002:aa7:cf16:0:b0:6aa:1383:f342])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:21d6:b0:6aa:fc60:60d0 with SMTP id 4fb4d7f45d1cf-6ae19931c6emr3076583a12.33.1790844587884;
 Thu, 01 Oct 2026 01:49:47 -0700 (PDT)
Date: Thu,  1 Oct 2026 09:49:05 +0100
In-Reply-To: <20261001084909.2937943-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001084909.2937943-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001084909.2937943-2-vdonnefort@google.com>
Subject: [PATCH v4 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
__pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
possible, allow those two HVCs before the host is deprivileged.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..da8b6e3c01e3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
 	/* Hypercalls that are available only when pKVM has finalised. */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626ad..4f824b01465a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -934,9 +934,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
-
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+
 	HANDLE_FUNC(__pkvm_host_donate_guest),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

