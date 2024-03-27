Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01344F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560938; cv=none; b=S4pqFdrDPx9Jv2sKxPGTwjyd+7rWBES1LFgGVAZqAqjruWfSX7vpI9CRKCVGxWVA+6kbQJA0sO7tHIHRJquPyLhRQphz0l2xDlaVtp5CwbUJnK/skWHPugWsN9jgQBJKtWs9LGigDkM+n0vTO4m7UFygxM34zzX90oic95CWTyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560938; c=relaxed/simple;
	bh=3Ze2dh2Q3LhBnSu0FJy8N0KSnNwXekuBjpqcZjTM6cI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uqavLOpLinTlqGJiHK4nCDSht1WDo9zFDcr1hzaPoJH/fOsdD57IjxsohVqwlR8DhUWBswYhB6l4SOv6xh64rNGR7s7soSLF/MNvzbtD4dlStq49rHlQeI7GW1VeWuCFU4NtuOoSRJ9joLsj7lbZ9y4y2LHs6LGiL5FcOxCvq6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jKg/3+iS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKg/3+iS"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so57175276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560936; x=1712165736; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcCUfCHjg8qq7hQCzlQuSEVLa2Bvc3FhV/pDaQ2wLzw=;
        b=jKg/3+iSwgwK5xwCRsM94dRSW8demhEVY7zClsrsYRTF1vCwPfb45HF6HjE61Go5jG
         9UXpVoAZ9PmHMoLpvOv34s0hIiIRl6BUJ1E0hRGT5J6aFJ7poe4yTqGir5I4QJWuFnJA
         gx6N5skRtXByexIdeyouuXhwj+UNhyBhN0AVVTpn2qBqNDyT/hqd+f/6InYwrPuqiJNN
         tVHGZhrQfAdGhrDK27BDdBoNKczvDc7o1TDh0PBqj+rcWRiHyDZSsVw2Ya48pNNBNnlG
         bAAwML240T3Rq9O4xfQBN0Z0sqfKk5X0iSEPt7I77SY3EVXFt4zc5MD3mz3OTenHfHg8
         1GeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560936; x=1712165736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcCUfCHjg8qq7hQCzlQuSEVLa2Bvc3FhV/pDaQ2wLzw=;
        b=aigVXRGdQjF4izUVUuY5zH6pHyucWmphesEvZzc+w27lCoDxEu+0W2n1EEsSkKBSf4
         +JWK35Q2F3DjVc3hmI9S315QKcsmviEshAx2qPgR+VcuDJ/fanG5Zcf7tlYh/zgD1rtc
         Y+TOEqEiOrdXXkWfj6RVlK2TQt5sQoQ79SqRAokCKzg6X+CCGponAnsY5TKarSC2tGqI
         Cqr0u2hrrt5EiBuTRx1OZ4BqyOTeLFwWIj2jHtCBRo3CqGpvJneK1SVUxlPkyBWUoxLu
         75aBiN+P3fRsPBoQbTM+k0238BhYVD9YcC8LAjEjV/dyuKgIL1qR7o9ZL2DihqQ4PrOq
         UZtA==
X-Gm-Message-State: AOJu0Yya28MAtVy63lbmZ6j4MkTo+KwzB8SgJvY/WvhB+D0izOuhMW2y
	w4C+L1+G4GkX7MB6ezKUAWyiY5WyoST3bjAvpFnrnVF3iBk75SQr5YF6JEzY3QN6sRDmXe1d3BO
	1sDuYJGWMd/I8QMEGy7tpyWl+FYZVQrRN1AqDTyabIsf+kgMNvRDXOGjdZiUgUmeX7Bnppz13V8
	fZ/aaL+JNqanQZfSOANXwftfOqwyQ=
X-Google-Smtp-Source: AGHT+IHdNBvTsJs++HX8LLEb7m+jLZ2UgZBjmm7G8dTwvMgnsu3/sW0/Wp8F6s4GIv+OU2/B+ouu1VjOag==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1502:b0:dd9:1dc0:b6c5 with SMTP id
 q2-20020a056902150200b00dd91dc0b6c5mr156328ybu.6.1711560935893; Wed, 27 Mar
 2024 10:35:35 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:48 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-2-tabba@google.com>
Subject: [PATCH v1 01/44] KVM: arm64: Change kvm_handle_mmio_return() return polarity
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Most exit handlers return <= 0 to indicate that the host needs to
handle the exit. Make kvm_handle_mmio_return() consistent with
the exit handlers in handle_exit(). This makes the code easier to
reason about, and makes it easier to add other handlers in future
patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c  | 2 +-
 arch/arm64/kvm/mmio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3dee5490eea9..a38943cda7cf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -980,7 +980,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret)
+		if (ret <= 0)
 			return ret;
 	}
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 200c8019a82a..5e1ffb0d5363 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -86,7 +86,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
-		return 0;
+		return 1;
 
 	vcpu->mmio_needed = 0;
 
@@ -117,7 +117,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 */
 	kvm_incr_pc(vcpu);
 
-	return 0;
+	return 1;
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
-- 
2.44.0.478.gd926399ef9-goog

