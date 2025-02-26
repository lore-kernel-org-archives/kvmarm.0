Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819FF25B66D
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606543; cv=none; b=Fig2XJUDFt/iLHaO58EXJYBGQXjPmZNr+tzYu9nhGvVmmvEC3h84mxsCiocyQgUbIvSuaTKfJWRfRgXU6S8g4SpzDpmW2hh0s+Qw6XL8ubByycAXH0ZA9yatlhn9RlguqjrCxGhDxeYkB6URfIMw0Ann4w/8Oe+W8aDOW+cntMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606543; c=relaxed/simple;
	bh=susFi+HTLhMiXge6xuA23CvYjFDj7xjmElPFv39hxTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RShsqSqj7sQutDqDkE2Qxol1Wyrx86aRWtxblKsdrV+plw2XRj/2+jyR4ShOhi+pf7NqBLCNKORbIZBYtMfz+qTJFDrGbXC/PQcCIa1StwntAlGLveLeGavXFaavS/oI79n3O/PO6APa/K+ZeNenCN2etQ7NCmMFJY+otGmYu/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kzA5c12f; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kzA5c12f"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-439a5c4dfb2so1303645e9.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606540; x=1741211340; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xEVZ05L77YjD9i0FV4RPZx+ynfSX0ZTLa/fS8nUdHrQ=;
        b=kzA5c12fOtnPPCt1v6oFLJ0px1M39pzhzCkloqsfBvYqAT5J8JbcqRvB6RfT4tc+jA
         Bszg7GYnvkKlMEu9gHnDgV8TQW4xuCLHXTL/8i6OPtu3JvcHXVIm2RWdtcrknsiczCSD
         ozaEtM8Jz43NoQ7XYL7/WoJJnq3hFBCMPp3vi4lOedt+DA4yWvbS9IQcpqfiGfA8mSwG
         C4GGmS6YexFtfuK0l8MuVj+pfnPHEKXamMARUkteHtBZJNMpfs349KXz38fp/46P59e2
         /CBTlglGRfZCQcE46I9ERThfLP/ytJjpMdIF69zl394a0LaZstjNjsdkB0Dr/4ZB+9D2
         GWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606540; x=1741211340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEVZ05L77YjD9i0FV4RPZx+ynfSX0ZTLa/fS8nUdHrQ=;
        b=abqPK51F8Ol7RpZFdeba+sljUVvqvxtZsC6hbWa+gQ39kbyPdBDHpvvo2yLXcTua9v
         dM8rme7mlTMCvKIs2C65L3/7YHPZIPKDtE+k7u/CZd5XhYAIwYvvdKaxv/CBROhzUiSE
         9hIGk2hwp1+2+kkBxnSTg882uEgiJxbuGQeB6mhI4yTFbmn29pKuW0LNwQf1FGTRNo/0
         ySHfMkhD93HKf9trTFA3nz4LOF88qNnFYbRGCB5anJjifFI/EUWexyWbpWpfqLPQ6hbr
         hEShOMlyNKr26jaDEixzuaw51nyJejR4rlwyhA2CduB3rwDHplNCfKnhYCVNRpRms3mZ
         jlOw==
X-Gm-Message-State: AOJu0YwqulbKwSHGeELMSs6dpm5/BJ2/DjL3PEHgPLafL3+0tX5brh4T
	T+ruYQwbql7n/wYOayjH4QtQ1mqWHLu8Ic3U+0DswXFQryPISTvQI/2xa8GmsuyoWdxnXhwn7Gb
	M8MYvN2+C57q3PLeivazaRBNAUA==
X-Google-Smtp-Source: AGHT+IHPl9CpNA4ye6HGWodohtg7w7nq3kIEmHB83VCNwiFw4/jBDdSe7IDZ/dv5OLUf4FF1pq99Aao3VGjq0FuCrDU=
X-Received: from wmbfl9.prod.google.com ([2002:a05:600c:b89:b0:439:9985:3882])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19d1:b0:439:9225:2f50 with SMTP id 5b1f17b1804b1-43ab8fe957dmr50990375e9.16.1740606540005;
 Wed, 26 Feb 2025 13:49:00 -0800 (PST)
Date: Wed, 26 Feb 2025 21:48:51 +0000
In-Reply-To: <20250226214853.3267057-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226214853.3267057-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250226214853.3267057-2-sebastianene@google.com>
Subject: [PATCH 1/3] KVM: arm64: Use the static initializer for the vesion lock
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Replace the definition of the hypervisor version lock
with a static initializer.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
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
2.48.1.658.g4767266eb4-goog

