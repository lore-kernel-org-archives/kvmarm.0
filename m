Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC6E283FEE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939257; cv=none; b=iagtrvWJq43qxh80iaYSipbu5YfM6abbQAl74OFekIukktoqEGGeyyS1RNiK05kId1ZEueMqgO0cTuyzJMlNyP8JEOCMhIH/s+LSdlQgVY16fcTdQWzT/ymxL+4KYH+qEbOzIeF7A/OSK8RRHFpz4v2ydaQgcJAikYVw4xswTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939257; c=relaxed/simple;
	bh=K6DQitLxBRpwlpj7f8fJ0uLFWIa4XB5w2rT+x3cat9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dv4BULG4SBA5o0Bkqg/UhEDDz9SOjgP9WP+Vx3yBtyLCGFr6A8omVXJopgXW23S9kxqiKXp+sBZEc6/vMqk9Ylsx1MxXAJVNF0yZLu/qgRr2PgN6ja7ULet8ZyxWxzxj2m6FwGRU8jJgkjlCBSP49EJjATLPWvqP8+UpCwcUgFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Nk12Rs8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Nk12Rs8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4710d174c31so5254775e9.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939255; x=1763544055; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7h9UV3nYWC6hYsHPBAX2lZPJFbMaZGkJN8sutubEAEQ=;
        b=4Nk12Rs8QwDOLsm+Zsl3+REmsUHRitmlA/d4GTML8Aufjj438EiD5gRVaa4iS8F9sU
         VKHLWTVtUEU/tRdkPad0xq627iTZdje/pEzuiIE9pZwbqPm79blShbkV1bgnrC5/z6nh
         RoHFDvD3hvMh8LcJY9kE87tpW5zxAE9poHYpuzcqihF9VrISXRwHUa88oWTFgqX+FL38
         tMLy8+v8FjfG4L3jJciq0R7AQMo/x/1o+QHxi+dskdwQf+AI4QbkBScEukIwZ/ZiJiYq
         MyDcA718nyQGGNlr21ilX01AfbWqG+dPqtuGpqmPWtAZul4LElzNFnJXg53Z7EcVPpub
         Rd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939255; x=1763544055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7h9UV3nYWC6hYsHPBAX2lZPJFbMaZGkJN8sutubEAEQ=;
        b=BCNFi6M3EC7U0TKRXTgaobzu/xAHAXm3bCqmY6xbv5KyFz0MLSVziy6BjBPsfTku4d
         G4sErTJjmyCvi9Do9+JYmn8e1yxj0Abw53ILPeLbXwvjPoyr41UsBdtISIjQoHxhFHg8
         cteOPmNCBGLsABir9H/GZ7tGtEsugryzGrzpXhcbETJayBTipkjidt2rbNKUtTnQNvMq
         sSqPYEb1EXa6eP/UgsThdBiWWJx3/hEUqTE0ysh12zhFSXsOa2uW235aF0ciAkGSCvcc
         RUzYvsVzuyfanXcWHbNkZs1L9rpYnSQETfSIcGzVeQ7Xe+4Thm+NbUtW4EYV1h30ii2e
         iKDw==
X-Gm-Message-State: AOJu0YyOcrWo5BJfDoX3ckcToGa9iefjlQMzwmLHIm3XSgDO/RR/Jpj7
	Enz3eJ3lrLn+cX/8W5bEE24YgQlFjnD3YinqUWlu66JOHwSslqwuMDtk9mKrbLR9Klz1HSYky97
	9cdVLi24UnZNkGHAbsWyXXq3NvRoZU1K7tTkS0+MJsv4TccdWMlFmW/9vIqu1iyQfOFOG14z82F
	EWpJnn8fVOyNpyiGm3I0Fkj14unMAl9k0=
X-Google-Smtp-Source: AGHT+IF+dsx1c4LF0aiVAUBfRYuGGbYQKD+wAzOKX8ydw/hwxgLYI8Qn1guhrPUGrrVE73xmb603B6Usqg==
X-Received: from wmhf7.prod.google.com ([2002:a7b:cc07:0:b0:475:dc01:3dbb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3145:b0:477:76c2:49c9
 with SMTP id 5b1f17b1804b1-477870718cdmr21988195e9.2.1762939254762; Wed, 12
 Nov 2025 01:20:54 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:46 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-4-tabba@google.com>
Subject: [PATCH v4 3/8] KVM: arm64: Fix MTE flag initialization for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function pkvm_init_features_from_host() initializes guest
features, propagating them from the host. The logic to propagate
KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
has a couple of issues.

First, the check was in the common path, before the divergence for
protected and non-protected VMs. For non-protected VMs, this was
unnecessary, as 'kvm->arch.flags' is completely overwritten by
host_arch_flags immediately after, which already contains the MTE flag.
For protected VMs, this was setting the flag even if the feature is not
allowed.

Second, the check was reading 'host_kvm->arch.flags' instead of using
the local 'host_arch_flags', which is read once from the host flags.

Fix these by moving the MTE flag check inside the protected-VM-only
path, checking if the feature is allowed, and changing it to use the
correct host_arch_flags local variable. This ensures non-protected VMs
get the flag via the bulk copy, and protected VMs get it via an explicit
check.

Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index f6f8996c4f97..16d7bf493c18 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -337,9 +337,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
-	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
-		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
-
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
@@ -354,6 +351,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		return;
 	}
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
+
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
-- 
2.51.2.1041.gc1ab5b90ca-goog

