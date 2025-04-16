Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A72C211A2A
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819753; cv=none; b=g9n23fyKYzbLAEz4t9Z9Slxv/doNCRCkA8g4wzB7s6uSBUzWDzdolbWjba9fZIysAxu5LFtTtuM669P9QwxiDOS2Oz2PRLe9kc+VvnzgLcf7aLOOvGfBVmB/hSVWcsaRowXQ3ElcZHZnUafAquUPeAfiI8WEirxjvEOmNWCRfQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819753; c=relaxed/simple;
	bh=hhevQAoaSXWNMR7psqWfCUWbj4Q7A3+E702C4036N/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=doGvOI2uwo9qb6G9Z4uHJMtkfrU47yj/j65uW0U764Nt3+lSVArr1NCGxdNlUxKZ/s/ske2sb7MoyV5cVVsjjhFd+dr3Odo+TK9XneO6k/MxtqYWsbB1v/tyQHPKO6z6VTlXFvEbqZTcxim1QnQZnFIGCU2Y1gZX40evjxh4Hhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q/m4mJQM; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/m4mJQM"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ac737973c9bso422585666b.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 09:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744819749; x=1745424549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RtCepilI5OBYKPwI8IAZ8i1mwTcn2lnNiKdpddQ34xM=;
        b=q/m4mJQMvseZjovXLKPjN/+yK0/DjefCfSkKXCjEMSZKIQuoLNq8+axASXu917aAa9
         FnasoC4UYkYwtp8LoGOzMu4ScHoyrJ1GjJtaa++XpXyr4PPtjqLUrBx5g+KCIR7ttxxC
         ZI6K3Xe1WRH1rEPsNXtecUI0Bp3pfLIa2ELaL9HN7Au2wG+UhSwClpk48f0Hy84ZqCaj
         P+IramYmzBG5BTbSk6JU6ZS0jjyCU2x4h2WlM34P1Mvn1T7gsuy7oTGxYvr9V5DtGhMq
         0w+FtH9QKdHD1dU4d/6ZxI9jYHLpjgZk2n1DZdFP8T7XVS4SBlfTGET1kAi4VmfgKTkE
         t5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744819749; x=1745424549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RtCepilI5OBYKPwI8IAZ8i1mwTcn2lnNiKdpddQ34xM=;
        b=SB6zglvdlAp5QEahccy4OwUREW63G+WliLf0yMt9/+/Ck1NiJogx059BXM+1l7t+N6
         xG66gLy/XScfZRTqaJjVIRGRS48bPWxGKLNm+EgTLWUaFbzB9OsnGEgTOjzCzXbpnwPM
         ARsthDcFJeAk0fNVSnzNkZsHLUKuHLIiVuBWSpy2ixZHGxzwbHbiQ1BIinDcnPq9NP2E
         FzLLBrQF7Tlt3CEcPbd4+5vsTuNcF189Vqnh6lp3/zCyWI9O1k3qyrUIugBDZLtruPWU
         uGEqtrFeXfBsF/jKVoFeAeF6jzBuzxrkcdl3Ctgc2BbWuyyFFa0X3ghSlXJ15dUuVCVl
         u/qA==
X-Forwarded-Encrypted: i=1; AJvYcCULEDqzzX/3vpQ2JSEYVHkXIVTZbzcQ8fUlTgcp6bx/YWlMxPrtjyac5rETye0RC/n8+LIuDz0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxK5MAem+lveINUgBTOwHgO7hCK5Hc5hvIcRiZOaLVl+IbRcxz5
	Wob6qLvNmRSlnRZj/tvuNCD5zaYSIpBdUBTxa5dGrx3IikcasocwDaLtIM19tHkC9gU0H5sbfHg
	cn/gvag==
X-Google-Smtp-Source: AGHT+IE8dk7jeA22VzWx81hj6NCNcV+aNpnoCWIVeIKMbzFyUD7FL3Q4EHx6osWargcZiCuELO7brSsBTvZK
X-Received: from ejcl9.prod.google.com ([2002:a17:906:789:b0:aca:9c9f:6358])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7203:b0:ac7:82b3:7ad
 with SMTP id a640c23a62f3a-acb42b6bb71mr224251566b.46.1744819747999; Wed, 16
 Apr 2025 09:09:07 -0700 (PDT)
Date: Wed, 16 Apr 2025 16:08:58 +0000
In-Reply-To: <20250416160900.3078417-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416160900.3078417-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416160900.3078417-3-qperret@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Don't WARN from __pkvm_host_share_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We currently WARN() if the host attempts to share a page that is not in
an acceptable state with a guest. This isn't strictly necessary and
makes testing much harder, so drop the WARN and make sure to propage the
error code instead.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 709d286999a1..4a0f98943577 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -921,7 +921,6 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 		if (page->host_share_guest_count)
 			break;
 		/* Only host to np-guest multi-sharing is tolerated */
-		WARN_ON(1);
 		fallthrough;
 	default:
 		ret = -EPERM;
-- 
2.49.0.604.gff1f9ca942-goog

