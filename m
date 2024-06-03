Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A7212BF3E
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417757; cv=none; b=bKc38H2Lw1droJs9y8RRT0l/e/bIrndh8YyETvgLsBWkhHVNAyUYw0OfsTQnLxR1uKPO8evz8kK/XHvFSEPpXJQ0QAMKkX+nVGsY4Wnj9NxmOVUaDUskldH5v+xJqbQ8p/gR04XHhDn85MvCgFTLQpxUXLdCnPKyCUCivGZXn+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417757; c=relaxed/simple;
	bh=pkZe/dBEeD9cr2hSeqfchSSK/LMhTJa0qCxPXrSwAls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q0JPfpKUZxx1q4wovm5JHom4xoa526Hxb3Pu2o5wFvp/hY6rmo+oMFLmdhE/5wdgqpyVAj5diP8cVPDO0GZhDOYXjbNlH+dxwlVMvVijugnkbLQLoghCEli/ppJYwJ2thcp4qZX4lmJlcthZv7gbKLTlpzLNqlAILoZfTFT9ynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0f2dBiFt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0f2dBiFt"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a088faef7so53929117b3.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417755; x=1718022555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XEXSQwwweXxLdCBcQNv2cOs/GwOHKY5IsjtcWCo7rME=;
        b=0f2dBiFtFzTuf1hJkbHVDdlfYka705JAeraDMXHCKm7JRdIIdc20iRJiiChrF3OHV0
         NiL2x7kRliYNbQrSslShZ6DO58lCRaADHxw2KJnO0jKc8lEPXTUYWuK9eT/8Eiv5l3jt
         ptN40iL/D66vt/wBK9ZbQbOt5Ri+MRL2MHBigkSx8KsAraDTqP/Ae8bRUeZm9swLVSNt
         IQamTqvyZNHkmhY8fBld6thpMSIYM5q5q/gqHpe6/VhNKS2S3B5HQYaGIMVSlxSZEK5H
         lumyCjhj9gBR6d+NGSa4lU+3lem5mYtHkKDvUEYwjLTT9PW+1YNFS6DDASII/bSNdvDM
         Euxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417755; x=1718022555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEXSQwwweXxLdCBcQNv2cOs/GwOHKY5IsjtcWCo7rME=;
        b=NDWJjuFPPxTDN3yHyvLA8WsmRN38K2ACTH8T+scK3rG6ks7yVP1BASfPSpOj29l9m4
         xUH/VE64lmbTwW8smKZfd3HJcjOqK0JWVLXPlxXhzSs8e1bNEWNQlzoExqmhRcVEA4pn
         d15cWlqzBE/EG0UoHoydAh7/ZiQ0axKysGgpxNemzp7bubOrIEAIQ+xdrg8aGMAF3ERI
         b8DfTsYZgpF/4Wj/uvBMJhlRTvNohJsiBekdTlByDj3Xz2HHNHfBQ5L4pvrbzy2Q6mvg
         cjT/3g7+PmxFeh9W/sN03UuCwrmZHPmUEhK3Mfz1uX5LD0mYrt4o/ZFzLVwBDbB+W70R
         Nxag==
X-Gm-Message-State: AOJu0Ywv4XqWFpLcb3HjvNPMRW01IoRUIMbNOf2Hukeyle7aHnAJE4J9
	yOJNcsduAez84WBRAZaUsGACXOj17Qq2yl9rH+UJXeDpAgkP0AAHAMXKEWHYvnAMVjQV8PxLzSI
	ESHKepNTeVNl61shLKa9Y9C3Tc2kDII5PjBxfFsLVBOdBqex+sxgZK+hbFzyZIbwOBNFyyBwYQG
	zXtB2ECt78dFhUE9VbfNqdc5/e5Oo=
X-Google-Smtp-Source: AGHT+IFAx9023tmv+pYbfbnXnAZglHsbxs/xEXjYQyjdijOAUgR73xgEHRZ4KLD2OC9BZc3VAmALllD2lg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:f:b0:611:6f24:62b1 with SMTP id
 00721157ae682-62c7863ae84mr33711717b3.1.1717417754901; Mon, 03 Jun 2024
 05:29:14 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:51 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-10-tabba@google.com>
Subject: [PATCH v4 9/9] KVM: arm64: Ensure that SME controls are disabled in
 protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

KVM (and pKVM) do not support SME guests. Therefore KVM ensures
that the host's SME state is flushed and that SME controls for
enabling access to ZA storage and for streaming are disabled.

pKVM needs to protect against a buggy/malicious host. Ensure that
it wouldn't run a guest when protected mode is enabled should any
of the SME controls be enabled.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/fpsimd.c            |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index eb21f29d91fc..521b32868d0d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -90,6 +90,13 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 			fpsimd_save_and_flush_cpu_state();
 		}
 	}
+
+	/*
+	 * If normal guests gain SME support, maintain this behavior for pKVM
+	 * guests, which don't support SME.
+	 */
+	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
+		read_sysreg_s(SYS_SVCR));
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bd93b8a9e172..f43d845f3c4e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -140,6 +140,17 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		struct pkvm_hyp_vcpu *hyp_vcpu;
 		struct kvm *host_kvm;
 
+		/*
+		 * KVM (and pKVM) doesn't support SME guests for now, and
+		 * ensures that SME features aren't enabled in pstate when
+		 * loading a vcpu. Therefore, if SME features enabled the host
+		 * is misbehaving.
+		 */
+		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		host_kvm = kern_hyp_va(host_vcpu->kvm);
 		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
 					      host_vcpu->vcpu_idx);
-- 
2.45.1.288.g0e0cd299f1-goog

