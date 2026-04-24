Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB6B3264FF
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020552; cv=none; b=KYGx3nm6zVe5f0xDb2Eq3wsU+il8+a5RFSQIIkCBnnFu3lYqYYK6jtlD3NclXCCxClYNgKFEG/gc3WUWnUvfaUZN5hXw03VEbD4fGDzu6GvXlv46JGlPrBVLTh51B18lauqf925NFyieYMtznUvjeP8g+YvodV77Mx/3vzk1HNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020552; c=relaxed/simple;
	bh=mRLjagBdARb/RSTyBslw+tT7PGeiGRSx+fVrQ7vBgkY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N4gWOVnWV7jCdjaKCL1l+dmkyLRiy0a/1isvijbjHYdhB2RAere5J9zBLsjEnRJnlSkRBs72Wc+milr7USw7dDm6L+yBrRbUPTwA1O7RQQQrwATJW4wcx6W8R6uciYTOSm/vt5LUUywRNSo7UqJVuv4Op3jq7sFwcKyN1vx06aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q5MVeUTG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q5MVeUTG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488c0120047so43981405e9.0
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020550; x=1777625350; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aH/14ddBCo2kTCzx4ceCZMALAM1Tsur26jX4fxnDfAE=;
        b=q5MVeUTGfAFDnW7xRIcMy0jLaqqiJpzcIJiOMd/x/AJ6k1wrPHTgIkz8B3VM0k4jaQ
         qBi7ZXUIhCkRdSk54pRDJGTceSLxKsY27VZbyS1Q7Qy3gRqIJASv9y8rGoBA5BgweYAV
         5RcvN2Zvvxg9Lln5SaXIT+u2QqNs6XCqH9hlBAwOU1Z9xYSS8XMZy9vMRJZ+wgDdU+pq
         mBAs6tTOSHff4VGlCOaFEDgnEjom2PHz6bJCucks7Aw3kjexrD1q49bb4EGoCPh2eYCA
         AOlfDuUqrLaURFjUAkvx0DmLatfyHj+0oAWmJc4hURhNXMgaeTDYPKvImJRGgNSDyd+Z
         Fiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020550; x=1777625350;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aH/14ddBCo2kTCzx4ceCZMALAM1Tsur26jX4fxnDfAE=;
        b=aQROjw7KslE3m9x3YALfYja9Bi5zYE/tPZagp7SxZMqXdV+reyn2JrS9HpjPHqE688
         jwXI858UzQ1pL1HhGk+sk9xxHjNx0h5e5FQeX4TA5EsCMtN0pJfZf2ORPeVBF8BO9mxw
         790RHQYSejeNKDKLq5/SrgkhrWP0DWgCfTzXG6h+i2BEeX0FBQcC62VyJK14dOtFYqrh
         ZfTXcLLP5AMNbgIoeCLgJy22iDNEXHi6O7g8OH/l7xfkhui6Srf4/TPM3/XAtqE/Liov
         +3789YDYl0oiSqN2OJzCeXaKw1E/42RvsYmZgNr9oos1ezWMz7FbtKmDrv3Eeg/5Ddwz
         LFzQ==
X-Gm-Message-State: AOJu0YzAttMwSB5lcStb1SOIzyMS3D+Kx46Fgwrsc2UaOnJS0npeuJLu
	gVs5cSAhYbgVtsPDnat22rEiJ+Heyg7tnCGIi3owuLRobfUa/L++CjBNcCZInl/9pemxI5H3BQI
	cJezmFVSCGma2f1O5p5YR4HRe9QG7UD3hE5nsUOwTI5JZ60NDAq2a1ZqCP2aRt1peP6QqbTX04g
	IgLxI2p04JaxAO2eINxd/FZtiJ4cJAPKE=
X-Received: from wrtj10.prod.google.com ([2002:a5d:604a:0:b0:43d:77d4:5f06])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fc6:b0:48a:53ea:1408
 with SMTP id 5b1f17b1804b1-48a53ea15a4mr231487385e9.8.1777020549668; Fri, 24
 Apr 2026 01:49:09 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-1-tabba@google.com>
Subject: [PATCH 0/6] KVM: arm64: pKVM init and feature detection fixes
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi folks,

These six patches are standalone correctness fixes I'd like to land
before posting a follow-up to Will's pKVM infrastructure series [1]
that moves vCPU state management to EL2. Sending them separately keeps
the bigger series focused, but they are all valid fixes to have
regardless.

The first patch fixes feature detection for FEAT_Debugv8p9: it was
checking the wrong field in ID_AA64DFR0_EL1, causing KVM to treat
certain EL2 control bits as RES0 on hardware that implements the
feature.

The second patch is a trivial typo fix in comments.

The third patch fixes feature detection for FEAT_SPE_FnE, which was
also checking the wrong field.

The last three fix bugs in the pKVM vCPU and hypervisor initialisation
paths: a latent macro parameter bug, a pin-reference leak with a
publication ordering issue in __pkvm_init_vcpu(), and a call-ordering
hazard in __pkvm_init_finalise() that is benign today but becomes a
crash once fix_host_ownership() is extended to operate on a non-empty
page-table.

[1] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/

Cheers,
/fuad

Fuad Tabba (5):
  KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer
  KVM: arm64: Fix typo in feature check comments
  KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer
  KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
  KVM: arm64: Fix pin leak and publication ordering in
    __pkvm_init_vcpu()

Quentin Perret (1):
  KVM: arm64: Fix initialisation order in __pkvm_init_finalise()

 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/config.c           | 23 +++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 38 ++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/setup.c   |  8 +++----
 4 files changed, 46 insertions(+), 25 deletions(-)

-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

