Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0DF20CCF1
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315133; cv=none; b=reWDkrPqsy4D9BtQN8IuGSf9Q6qi5WmSqd6CsFcxHTr3BzyVjysqja6a/Wf3Fj2HDTCqH+HFOgKavoOFv+n3pXouC+DojYMdgORtTlUV3MIrxmBWZOpGG+Mw3cw6ZqPOShqhwGUYgkb6ip+qqwmFS9KTkGTDZv8K8WNXXOk2v/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315133; c=relaxed/simple;
	bh=jA9/pAbxqptglOxtKo0sDE1a1PEPVIV4GYrCMWoNmhE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oak0J91j1ls1fAQV6z7fpNQAzFs0Epz8MKIQPcEo0zsJGVaGX4EmIBP0Gm/J0IiGbZNPw1G4PNnFfEoWCN25NSf8Z4X9LYK6E8cUBa/Oy/p+8QCEFBFrkhEzyYbDKSEZEtdTPeipTs0acy4Vy6JPJsMd2L2Xg4pcGUnTBpUhc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mc3kWcPx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mc3kWcPx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4394c747c72so18028965e9.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742315130; x=1742919930; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nkv4hTOrWEP1mAK28D1kEzJd6tzvvXvQPHgbpNeN9YY=;
        b=mc3kWcPxzejdmropZP8Rvs9IoOGJKZ+1k9RdO6w6PuMrsIfPhcNs64319Tgjx2MAZp
         mPhzBqBMI/WzEEF0m8HX1ha+ouZ7k+UNjCS/g+yWrP2GdvmroJaE72vc2DD47soJWfgF
         D5rcLe2+Q44YT+vY32CbOhA3SmPMiaoHa0G5FpTVhj6emA0Kq3laHhDKum/lrbK8HYn3
         dSzo8t/Cb174jkcojgJhZ2/Y0wReXYBs/5HlL/hXl0m/ra8ojmRnVPM3XNsPhqdwZ/Fa
         aOaXvAiWstMTqyp3GtavJLFqo1dYeP2trKjvm1/k/D+yp7JouSVOCkbzAbSQIEKpj3LH
         KxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742315130; x=1742919930;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nkv4hTOrWEP1mAK28D1kEzJd6tzvvXvQPHgbpNeN9YY=;
        b=mgL84XloBAQGt+y5x/b/ScUlaAVia+j/C9dWztVYlVbUmDfmu8r4Suu4YiqrGZRr39
         yWiAvSBtFiK0WbRpBTJ8zTUKQAtuDMINN+nDfTgkcgEOVNZoBoQKGOtO+pPhPjS99PsN
         Q0L9lfhcNRVhyx27xdBLUBakEfEk80nesZ9uFTLqORrciUUjfRRBXcKOURihbkowphtL
         hNRDx3IOEqqmZdM6SZ7hWyuU7SEM1hNAE8zQId6sOek2SP+UxJHjp1yp8MCHCqJiTruH
         3ZkM93Q6p7oN38HHAIXwEEJAq3Q83qlCvA2LZq/wnfUSrfidtV2hwb51tZhgTXjUJkd1
         NLSQ==
X-Gm-Message-State: AOJu0Yw+Mgwt680MB0FTTrzpD8gBR2rKTia0PmoZYeDl9Do+4ZKJaLSA
	X+Ou1W5nNGHjzLprWIJR0QRsijigvoEb5U5V+ShndkYtvfmHnOddpiB8UJWGy68ZWqdLdWbMjag
	fJvhKoiMophE/Tg//YalR6a18Uw==
X-Google-Smtp-Source: AGHT+IENQSIN9p8sk8M/fR1ObxL5U7dDuJO08/B2zEw9mK4FB92c5Di/ycqjo4nkJ+gmvyvHR+E0wirYkTH4pVs9RFQ=
X-Received: from wmbbe15.prod.google.com ([2002:a05:600c:1e8f:b0:43d:1d5:26e6])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ca0:b0:43b:c95f:fd9 with SMTP id 5b1f17b1804b1-43d3b94ff9fmr30314205e9.5.1742315129825;
 Tue, 18 Mar 2025 09:25:29 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:25:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162510.3280359-1-sebastianene@google.com>
Subject: [PATCH v3 0/3] KVM: arm64: Separate the hyp FF-A buffers init from
 the host
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hello,

This moves the initialization of the hypervisor FF-A buffers
away from the host FF-A map calling path. If the hypervisor
cannot map the buffers with Trustzone, it rejects any FF-A call
when it runs under protected mode. 
Other than that it moves the definitions of the ffa_to_linux_err
map from the arm_ffa driver to the ffa header so that the hyp code
can make use of it.

*** Changelog ***

v2 -> this version:

- dropped the "Map the hypervisor FF-A buffers on ffa init" patch
- added ack & reviewed-by tags
- don't release the ownership of the RX buffer if the flag from
 FFA_GET_PARTITION is (1)

v1 -> v2:

Split the patch that maps the ff-a buffers of ffa init and introduce
"Move the ffa_to_linux definition to the ffa header".

Thanks,


Sebastian Ene (3):
  KVM: arm64: Use the static initializer for the version lock
  firmware: arm_ffa: Move the ffa_to_linux definition to the ffa header
  KVM: arm64: Release the ownership of the hyp rx buffer to Trustzone

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 12 +++++++-----
 drivers/firmware/arm_ffa/driver.c | 24 ------------------------
 include/linux/arm_ffa.h           | 27 +++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 29 deletions(-)

-- 
2.49.0.rc1.451.g8f38331e32-goog

