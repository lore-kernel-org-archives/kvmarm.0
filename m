Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F03E1DDC12
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742989150; cv=none; b=tpKZK+XtSBvEjc8NxctcLY/oTdI3Zv6KkYR5Ajf4j/CIYjQ/SxH0US1qgBOvr9tZd4TlVOQEu2a+qwHRINoBEeX8ldI9SplkF3OH5HQnNpGRr2yXddLq/vRLAumYa/ynu3HC1UAyJHpG3/Jmt+vGQoqVxUcYhY+g+d/cgpqRQro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742989150; c=relaxed/simple;
	bh=suNMKt6I15eicpIrRigEwbTXV0qPPOxVmXKEqjZInKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mkP4jopD+Cj900pjURtou4jqsfe7wd6y0JlIWDToNvqeDuF0WjIAoVOkwfNkizGwTS+xeigEvwQ+1f74ecE7zCVHCrewRDS8TAPgp3M32G18Kr0H+BK080IZr5ymIiWCN9S6fmsYeplMMc5gbDvDBCWfpKtfw166UBOXm7OWSJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5dYRAgi; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5dYRAgi"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-391315098b2so2715781f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 04:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742989147; x=1743593947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GXpneY+J8yPscOLP7jhAaiNlTKvyhknsIBSzw8J5v1o=;
        b=D5dYRAgih1gH0f966QKgbmYs+iOUW4dPhKYy5xNKxsrppkhgowK7R83xW5V/CIyWBx
         rnmCfIhG3jNM1iGj3mFjhZ9mTeSZ9rRXF3RQQSWZ51nDqc8boAeCOua2PmEw38V8kv7z
         RyCNfYOk/+YCHhA2HZX/A78RMMpBUb+l1taXte68lP6xrGJB9IGvAA/8qZ8jFLgIXL4C
         cnUZbx3S/VePenrMYBjieWnbVA+zH8jmk49GZFvRgtKdH/VLondpGTc4WEMDflEEj0Aw
         XlZi9D55K41010m/urZ4Gs+GS7XfvmICaknfNyrvR2XYMPilkHXVR5xlD4NmTnYULKzi
         5P0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742989147; x=1743593947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GXpneY+J8yPscOLP7jhAaiNlTKvyhknsIBSzw8J5v1o=;
        b=L7aSjnCyyIjRcAPIrHYLjfNCLpYRoPjp13eBtwxVIcdrUCm7YyL/k5dllvcV14E0J7
         4csJVegUOxwi8jGBfn3pb8I3vGke8WVy+BAyXpV3ypPzUpQZFkgTPwWs69iqdcNnq+rv
         t2L3JddJtljQqtkSwnzVfrjVeiPQUQdM9XZn6thu7w0sie0kKTot4XXsoOE4fODk2LT1
         JiFoN948CozxBFtzB/+kzo5Q2zIp6S9BLaEa1Z2ZRKxWJRSV7aYI2gLJvbKe3BZ4Cwzg
         Wc5IGN5abXkskFYppTAlvhiLpdGvosjZhYrxtoCTwJkcM8OAhdh8gRyiwyl06FIsLSFW
         i+WA==
X-Gm-Message-State: AOJu0YwLN3FE3u7vYoGXl1id8eI3Ia26rBDfUsKQtOUT24wSWs7Pfdw2
	cNNeIM62taiYFzLPFnURxEw/CuaxCiNE11hXx3FgOafOjRVoGHSt57SVVIwjGVqsJg75Tvz5RLF
	A4hk7yZG16scjmR/i7s2klb2hYA==
X-Google-Smtp-Source: AGHT+IGmIIwQP0bm2M7IlxhsZXhvvis8SEyv8YAEqMxAp7vxQ4ixz0CF6DGy8JLA3pEu/5AAb31WyHaG1CNXPPwbNdA=
X-Received: from wrxt15.prod.google.com ([2002:a05:6000:1cf:b0:39a:bf28:66d8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:59a6:0:b0:390:f6aa:4e72 with SMTP id ffacd0b85a97d-3997f8fabdbmr17862518f8f.18.1742989146887;
 Wed, 26 Mar 2025 04:39:06 -0700 (PDT)
Date: Wed, 26 Mar 2025 11:38:59 +0000
In-Reply-To: <20250326113901.3308804-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250326113901.3308804-1-sebastianene@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250326113901.3308804-2-sebastianene@google.com>
Subject: [PATCH v4 1/3] KVM: arm64: Use the static initializer for the version lock
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, qperret@google.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Replace the definition of the hypervisor version lock
with a static initializer.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e433dfab882a..6df6131f1107 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -69,7 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
 static u32 hyp_ffa_version;
 static bool has_version_negotiated;
-static hyp_spinlock_t version_lock;
+static DEFINE_HYP_SPINLOCK(version_lock);
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -911,6 +911,5 @@ int hyp_ffa_init(void *pages)
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
-	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
 	return 0;
 }
-- 
2.49.0.395.g12beb8f557-goog

