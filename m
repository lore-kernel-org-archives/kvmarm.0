Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B919412EBEF
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561023; cv=none; b=Y6o03aP6PE97RcoS7PGNNDjYWLjApRIpa/4jc86sDNsf+b9PDRjbc35m8CkJV3MAbfMzzNaIxL+caU5l7n8/arwEoTPmJsOEMiyZUKoAcoqqaYYII063rsxJ/PQLfIF2jSGGsFz+JZPjdHpu/9Jf/IwV8462JQOt/+Hdryh8Jes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561023; c=relaxed/simple;
	bh=yZn+JzUtOpTSKCBqqjB5B2jhsFeo1kLnJ3rq+DWzswM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPvaDkE+PPnyhqUX5J5JVGQg6eNajsX5wBlLEUvxc/njq/kAC2xBASwUw80trHY26fs0S5BhyYX1W6QatMNSzFdeTmViP8yzaVowTjKEtoy6Rn/Z9FcfqRa1kNm/NegI7qcHX/+KAtVevNIQfEJjIfzXsg16YiM1pDfSAkM8Qhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wsu9Uuv7; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wsu9Uuv7"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33eca7270ccso48014f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561020; x=1712165820; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVPr9cQePZmH2SkEEeq1JTpqs7eE2HXTFYB6kLlaha8=;
        b=Wsu9Uuv7t3Tp3pOq1ca4RrqeYVPZH77bZX9Zlf89wXFWDP53FtXsJH7b3VcsmG5lSv
         VjTkisEnseT12kt5qfePCacEhFsWrrDQRdNOGxe633y29iIeYdKePwOQUousUE3hpHSv
         fg7TnGI5uEWauccAR9dN2dY2nYIF8OPRS5OpM8lvdwqP64HBKXgsLbc5OC0eu/sLLPQi
         mnSn9y0TwBmcfnWPinBZtCd6Gg88/ySSrovaL/nADYe7izQaFSHZ1CAKdrGlwRMaRzs0
         TENYdDk2j4pPe7CWpyIe5KAZeJJIJ6VLAWDh5pfwAnMj4P/GkSmeCLlymZxfF2WmfB8u
         TV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561020; x=1712165820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVPr9cQePZmH2SkEEeq1JTpqs7eE2HXTFYB6kLlaha8=;
        b=hgTDIQg5Q2J5+hTOFSaHxiHIGo+OmFJVsU1auAzQl7C6YZUASS0rK+JJ2siV+jrSkb
         SwGYUnX4anUE17iOhZB8iiC/vSvK40bCI7/syYHeatBXoU3HqyJ/OtL4T63JvZ0BWEi/
         7rvqVAd1JyQrSe6W4CJewZywwYI1f1KrWf7ye8ddEmoXdqwuwCB0/0AIa9fhu8bL19Wx
         5Mb55Red91rGLKZktd6SStwNmfR1TdbdFmZ1G93ejMCKsjDmHfA9+L90so222MRLHK0w
         kH2fvEJLZTa+uVFMa1VHYdQWddNLMenG+j1WwJrYzEfI7a9r21iR+iQUKAw2+DBYiyRg
         YoBQ==
X-Gm-Message-State: AOJu0Ywh5UoMLxjwQVK+5nDTY6GQg3J/vMP3+p+Zv4NGZmYEmRI7v4Jh
	LYYIpY1g5aLlvgo5P9fZyodMXLkS1qFXEtaupo/fSYTD++czlX3FWkR1hRLrlChpmqzxamc/BdY
	OF5aEZXU4gd7+Fj76oz4Gt5aiMC/ce28qbauJ6vDq+I0UWMFt8MrIpRJ15t35SqsENXvH8svaY5
	V6Ns4wgmjJOyLjpXnggkXV0Z4OiLM=
X-Google-Smtp-Source: AGHT+IGwC1ZECRGMhS8QcoMGtU68OQiZljeVyVmKj8wmmx/1GNWWsnphFLHULT5+UWQniq5bN7ShDw0akA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:9d82:0:b0:341:dcc4:6a5d with SMTP id
 p2-20020adf9d82000000b00341dcc46a5dmr787wre.0.1711561020124; Wed, 27 Mar 2024
 10:37:00 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:22 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-36-tabba@google.com>
Subject: [PATCH v1 35/44] KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Fix the comment to clarify that __pkvm_vcpu_init_traps()
initializes traps for all VMs in protected mode, and not only
for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fb4801865db1..1167c2296b65 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -199,7 +199,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values for protected VMs.
+ * Initialize trap register values in protected mode.
  */
 void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0.478.gd926399ef9-goog

