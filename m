Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4031ED81
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779314916; cv=none; b=ncHMgybsqryjRn3onwHxD5IT75XcB0TlppELMa5zkXbkKzc9Z5aQpuOVxZQbHbRgew4Q4GTTMyASooWU3MsGnP/c4Wguu4AelziXuKfe4EqJ2LRPWTcjo3s0iIIxBXibyX4ht3+6T6SehHpmmUMuKXQ9KZWf2PatCJ1rF76xeyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779314916; c=relaxed/simple;
	bh=inAxiDr0iVUeoF86ciIxnDhiyerxdVq4Fad10RIuArI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=E9JhunV+pREVejwPfQL0NDzakUzyHF/w8iw3FhYfy55Krw9B+xvL3C5dDochZa8ikAO3fmoEw5JwVDWu+gSHsPXzsWNlAAokJkCmqz99ePnGH5SfpWJvT4K0NL41TfGL2nP0SzJH2f9xHZ0MX4Ld+HqLO3a1czDZOfL/d0TVHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gDdbMPPW; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gDdbMPPW"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48919890a95so28175965e9.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779314914; x=1779919714; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7NC/pwDsi12NprNlnn8EP1++3buNk7W62sBVMqd9ZEo=;
        b=gDdbMPPWQL5/y7d4Yn1LqlEEeQfasOeiZKy3d2GLVrZ8E6ToDre/AozEd8Cw3OS2+6
         x9MjCaCEDwPFlEIZqMYT2WPFCGBlM8shq8gMxmKbsrSBXZ2kLkE+cCYOerFRfg3szemJ
         elxlAE7bkoLlTgMBA/4jdMsrb5e+sIFfXRbRzutR7tk1XnYX2M0eFSxkIy+q420Ht+Nw
         X2XMyCVuAJkVgeYqjRvQaofi/oJTK/F+nlpRNfOVrvEjvHxfxNqtj5ap7qlkM1r+vnlG
         qoAq04T2CkS/WAa6DEavnA+MLp7DtrM2u7+eYtDatxHwHJS4JCjceuZQibbe4EfOMAOK
         WItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779314914; x=1779919714;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7NC/pwDsi12NprNlnn8EP1++3buNk7W62sBVMqd9ZEo=;
        b=W25/jCPZ4Jmp8XL7qGklczd9yTSiZDsKQ0ZrLwT/Xu9dQ8oxAUQXyDj1sZX8YoKVyv
         Regk83pVVV78YO7uAY14RPh8DX0LC4iHiSK38cFzXneR7765UimQA6Ic6k+eOCNM+Moc
         rABfR67YsSgGOO+JegD3MDser6tVLB3vFtn6tt6RzAnlZjx7klNoWBEhtTzwBqW2AVpH
         RbMvABf/jMFdi8/iloIJQTQ9ImZJmGO3Z8KfAkW6sLUfQmOpIc/5EqwJa/nZ1TZ5ZD6P
         GX26Balb/ABYXoWqiZfszgDB+jD5pCP0VN8o3FfK1ij4J2BUSJom73IdH8ODXN9BBbQp
         2e2g==
X-Forwarded-Encrypted: i=1; AFNElJ+zDNW9l1aDzqOIHkmw5NjnF9luGrZYdjT9+9TPp1qWhQXDtD2ucKZm3KyuPr+cor3eLmF8wzI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyys87Xt5vp4LsECKCnSCJpeB/H4wawQ6wW34e0OlR1zExhicNH
	6O0m9rtEFWoRc2LNqOYtG7mWe3uXnRWuYMRkdL4o81o0XLWThnzmBXx69ca9hA7aHn4L+kaueSw
	pcgr94BiIj8YAg8f8Bgn3bQ==
X-Received: from wmsk23-n1.prod.google.com ([2002:a05:600d:8497:10b0:48f:dc9f:6f14])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:848a:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-4903609d60amr2113425e9.19.1779314913611;
 Wed, 20 May 2026 15:08:33 -0700 (PDT)
Date: Wed, 20 May 2026 23:08:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260520220830.273289-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A typo in the config guard in __hyp_do_panic broke the stage-2 disabling
and made backtraces for pKVM quite unreliable.

Fix that typo.

Fixes: 9019e82c7e46 ("KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index f337770ec459..9393fe3ea6a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -120,7 +120,7 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	mov	x29, x0
 
-#ifdef PKVM_DISABLE_STAGE2_ON_PANIC
+#ifdef CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
 	/* Ensure host stage-2 is disabled */
 	mrs	x0, hcr_el2
 	bic	x0, x0, #HCR_VM

base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

