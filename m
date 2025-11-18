Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762B41C5D6A
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462293; cv=none; b=HuCbzGGd4ei5XeGzEUTUyFw6WAuFWxaGc3aktRY8NMgnn4YMegkm2cTUkIATP6quUgTyL6aUfccH8eFISNOfYOgUbQ0IROLf19Q0Cnyap3Ap0Gw7wB38TDqpuwzrvmtcWUlMy1Uw0gcDdlX7X3yNGj7oCkyfbrxeKC20qhL1s9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462293; c=relaxed/simple;
	bh=IgyuVlLngphuZPPP8UTt9caIS+S3br5Dbni7yRGey1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dWQi2V978U/UMfOXCrt5ciFTamUMu3piLbpeg4ceoOEJy5kecdPwhSfsnconxqEhE0UI4Lt9kl+l/TJ3TkM1UUBlIa8naEPxPNbZ8cg7JOaneFSjQh3oxGG68VDhva7FSYh4CjR+XcpDSvFj72pftFMyKxa3kJ02j8JxCly+Ohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h5nLKOW8; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h5nLKOW8"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6450f3e7e71so226484a12.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462290; x=1764067090; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rWGqG9HBDM5MYbkTEiLSiFJkNqeWZECqlysUIUisiZg=;
        b=h5nLKOW8ZAV3hCke/qZEitp45SjgmveRRdyLmqE388JArzAiAOhNA+uvgKiXrCsLxA
         qIC+Al1ws/qxH1S332AtXpwUCxjp+iL76bzxZUhNOVhwluauHEK413ZJZq4L44DFKYvy
         AHkbVEh9oPPJIafVdx+EozDq/5b8IQx3VhJu3s0wpyvqZKyJ6+Rq6f37I15iQw9wlSsz
         BuP0bRqMseH996TWiSS0o4Fv16fRfxb4O3EfuXq7e38kzKUNdm9gxwersFhQgPlx25sX
         MDrr8dQJ+k+bVtYlqoiy/hHz+LrHsKRQq2HQQBFtTAnjNa4koinw20GhV0Un9Af5Whuc
         yYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462290; x=1764067090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWGqG9HBDM5MYbkTEiLSiFJkNqeWZECqlysUIUisiZg=;
        b=uzzSa7voGs4RZoUQSFW5QPPivvbyindNoD3Jxks60fCDWG335ijGWYvVmr7oUdmqIy
         zcQIZFQd7NGfNkPolyyFQPYHK2MG1OpPs07vHYCip9B2tFyrherf9KRGSqdkCNtHdtJW
         krXi3TE9hJSkLFAUcX/f3P4upTUnyD/mAca00xYv1xrgm18vv9FrjyM3jB+/xjLZSBC4
         6Nsiuv1+wGWuWjcE5QWcSN2jJxzbFho+ITid8GS/twiobW01z0SttqBPeSF+Wu7Bg5FC
         bpgokm9/pykMijO18F2ObXzqhlD/SVltedzYmOuW3kIdI/GcHfMvsy420SgaggHjm4Kf
         PwTQ==
X-Gm-Message-State: AOJu0YwUgpaqZdb/h//dqToOC4F1EKXIOYJ/IsGUcp4MEALrjFoDlmWu
	UqXVRQOIyWJpclXhqfot+mqScWkV1SC5sLnJnG/n4wnKb8iKv1Tt3dnyXbP2N92UvuT9AAIN999
	6oqx0X0sjY4Il0VcnIiaz1vCBnhsklhibihViuqH5omua2LvzpTO1xDQvb+ZW7wEgS8bn7WziTH
	S1RvVtRLHUGT0+bO+33nzFzKpG7o92CWY=
X-Google-Smtp-Source: AGHT+IG6HxNtm++TYyHj1tg8cZi7k6EmVQSculrddaKbzII66k6Fs3R1cbsaPQyajmBlPWJiddeR8efdbg==
X-Received: from edben10.prod.google.com ([2002:a05:6402:528a:b0:641:9d03:a220])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:90b:b0:643:8301:d14e
 with SMTP id 4fb4d7f45d1cf-6438301d518mr8628981a12.28.1763462289501; Tue, 18
 Nov 2025 02:38:09 -0800 (PST)
Date: Tue, 18 Nov 2025 10:37:59 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-3-tabba@google.com>
Subject: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
register accesses. These accesses are trapped to EL2 when the bits are
clear.

The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
had the polarity inverted. When a guest did not support the Trace Buffer
feature, the code was setting E2TB. This incorrectly disabled the trap,
potentially allowing a protected guest to access registers for a feature
it was not given.

Fix this by inverting the operation.

Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8d06a246dfd1..f6f8996c4f97 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 		val |= MDCR_EL2_TTRF;
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
-		val |= MDCR_EL2_E2TB_MASK;
+		val &= ~MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
 	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
-- 
2.52.0.rc1.455.g30608eb744-goog

