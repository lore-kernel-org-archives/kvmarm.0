Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012841A682C
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 08:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139027; cv=none; b=VS/4AH4N8zIWnG614wcdP+nEUasGUc7/lWT/0kh+3LPeX/3F4if6jgIy0ocvGNTU8qEof17KzwxjikJgTh2GrInQXsrvALubUTumQZJLCl+uFe2/ZBpPTnBFhSpMtYAMPf2kETeZtsu18FqGDyr34eS10a39rputYjeFaTq5VeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139027; c=relaxed/simple;
	bh=DPuJiQDIaf5SF8ZF6lSYjBVWmbCcO7IipEOzcZxX1/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iFHcrE8jNG95e+A1fT6Ci93YygU2zO3BfYphJkoDvxMWdDxYatinloUMYBQqeSArd53zOUbyr4IEv4EzcXJ3Z+fEcxGS9Jcyp+r3LGuVQxbwXOehxPopMwuhKM3U5YDDByOk7zqT0KMu9oXZsTsuv2zb3XOjScxrVlHMPr1HyGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R/4qhWgs; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R/4qhWgs"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1ac6663e1so35139855e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 01:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792139024; x=1792743824; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=707YQ5WOW5OhLWsgc1Mn0RWZVRHccpuv4G8HLhK/9eU=;
        b=R/4qhWgscI+ZHYhie/DT4SFfwK23fGD5jkYRIgECSHYJYOfxVwGd0hzsTHf5CyRwjf
         jqCqW4cnrjJhlsqPN5ID9ZyZR8QBPDZgezMzZEazf7g7z8OsFPKdgBS96+a1CsQ2gLzo
         Wa2XZxZQA0Kp2+5m1NNP/4oGcZMwVdNMdOSrTKJMYatf2QOgR11p7JwrY+glZIZMB4xn
         PN5txiJScCFgSZ4piIrBixJ/P9p8xtj1uIP1BJ58uUqpXEcTNIN6tR8tXLRldFNS7SAe
         EyLb2BxpMM3yU8JzFDl+oHq6D5N4ZsKgx8HfFnfI5ZzqJ9oNYe8jquEDcBovenEPOL/T
         VDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139024; x=1792743824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=707YQ5WOW5OhLWsgc1Mn0RWZVRHccpuv4G8HLhK/9eU=;
        b=uDonZV1l3uOGMHvpFkSWP5TNgf6MeEGsm0D/Z/nGtrEO9hn3WFA9b1AvsvKjhPjvb7
         /315upZROq7/k+h4n6/lqsO2qRjpkZBSHMcP83VqoU2kTe9GKxoWNtUB7QeoJK7XRPOA
         G0kOQg6d1Aua2sob6zMDdT6FFPprS0mfM7f/XsN7hizUAX+YHx2o6Xh8TLPTqjxtS2b/
         fNA9NfcUqWmAjFWM7XNV2YVX2d2AsxXYWNdefrdI8kldax0e9Fq1HYv3ZT0kggwYyNnp
         OmZ5oImlYJI9IxHgN1dmx8WK7DK66K9CWuPRH1Cxxik23BRGwowFZcrOAGAVM0oOM9Af
         DQsg==
X-Forwarded-Encrypted: i=1; AKwUvBxSN+LGTuaqwzlpxN4JaJJ4gaaNMRnKplJwe6iYrBxvCzAPpmG3jvZvellCuKcnMRRUswfezRw=@lists.linux.dev
X-Gm-Message-State: AFq9FYK6qjlagtbi7B34Ykpg9fvJY1PpRsAWOT3CpC+GepZmAPe2QrdC
	L9E0HmJ9Xs2pKiCmvFmXqAmveAi/NJIThc/j/UwRsGLE1DndjVHhBvX2mvtkr2xzaDWXxfNIccL
	3SHBoh/MTh5OIJ6jKueD0O/7+Rg==
X-Received: from wmbhc20.prod.google.com ([2002:a05:600c:8714:b0:4a1:93c0:d3c2])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e86:b0:4a1:ad49:7b3 with SMTP id 5b1f17b1804b1-4a1ad4909c6mr230452255e9.22.1792139023899;
 Fri, 16 Oct 2026 01:23:43 -0700 (PDT)
Date: Fri, 16 Oct 2026 08:23:40 +0000
In-Reply-To: <20261016082341.4030770-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261016082341.4030770-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016082341.4030770-2-snehalreddy@google.com>
Subject: [RFC PATCH v2 1/2] firmware: arm_ffa: Add FFA_MEM_RECLAIM2 function ID
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

FF-A v1.3 ALP5 (DEN0140 rev J) introduces the optional FFA_MEM_RECLAIM2
(0xC4000091) ABI, which enables an Owner to reclaim exclusive access to
a subset of pages of a memory region without requiring the Relayer to
maintain intermediate transaction state.

Add the FFA_MEM_RECLAIM2 function ID definition to arm_ffa.h.

Link: https://support.arm.com/documentation/den0140/j
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
Changes in v2:
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2, following the
  existing convention for 64-bit-only ABIs (sashiko)

 include/linux/arm_ffa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e71d83ee0aef..85c2e490a387 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -78,6 +78,7 @@
 #define FFA_EL3_INTR_HANDLE		FFA_SMC_32(0x8C)
 #define FFA_MSG_SEND_DIRECT_REQ2	FFA_SMC_64(0x8D)
 #define FFA_MSG_SEND_DIRECT_RESP2	FFA_SMC_64(0x8E)
+#define FFA_MEM_RECLAIM2		FFA_SMC_64(0x91)
 
 /*
  * For some calls it is necessary to use SMC64 to pass or return 64-bit values.
-- 
2.56.0.176.g3575e65682-goog

