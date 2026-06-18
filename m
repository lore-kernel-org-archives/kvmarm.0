Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A83546C7
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773299; cv=none; b=UbSGdoBsQKpXqfA69h/zlSqoNvjBxk275f/CmPrlD23YYTyrkL6kdcceJBCVN8ki7qvif8L1PvG6eJdlBYNDUH5tx9RC3PVoSiwfj+6s7KQRwB46pqagEsV2Outy7RDSQIuVdzJ+mKbdiUC1h5JtOo8HzhBMVuBaKRcOXYiXrSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773299; c=relaxed/simple;
	bh=YCUIMNpaFUzUAEyV0dBpCjC+oTFCOiPvsCFjJzX+osw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MfLS9xYkDYDpdPytZWtuClEoHzLtB+afq0e4oZmT1IvoShOfULQ0qLmxchz+42wNJRvLJ0xlnoV4m0QlpI7O9bb5cf0bVIDMMkGVm60fqev8f9rYQoaONIC4se6X/b4XGKnCCoN4LyoXPU2Tj5ax90XWP/5dF/SZjh0CtmpGeHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i1B7nq9k; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i1B7nq9k"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0793772071so58497166b.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781773293; x=1782378093; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qac8FDS3yeT2+4VM8TKuhIc6uI5EZlyUNr1jGR9SzEs=;
        b=i1B7nq9kCQZY08GczIEQXQdOs6GFh3wCmvsatiE/gLzcv4VXTUZb/6VN9J7MAltT23
         fwzP0mNcNtl66zlL3ehc5gSsmaupHwuzk1HiWIo3N6GPjvFqWK3VbPhVamqwOr6dkSgg
         53OWG16AQbk7TYtKKMvJhYy9v3ppKbfzlWyMR1i4nHKQhuxR6IbUGEX92YeJyrqYYtnP
         4+h9cbBCHfrbRtmD618A5YXBIJqIt9QtUKlFLEd3xBQfXlnMhviZyNUVGOWPLWwVix8+
         b9VgEg/SWYHZZM5o7DtpvoqK24cbMNhNWRUXuVoUNOpLlrGtOAXBnTeHj21YWbDENKQk
         oJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781773293; x=1782378093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qac8FDS3yeT2+4VM8TKuhIc6uI5EZlyUNr1jGR9SzEs=;
        b=r5wkivCmnaYVdJDxVWOgMhHAgTXNAN7mWosiX6RRvOmSamLleEOO6LQWWWg8Oyzrc5
         x13KOzOoFV5Uu8VLS/SUb9fZIQo8raT+wEt2iADzlRIn7EPxjWSV6uT6Odd41DDVvZr0
         oX8rGVMFDj7kk5Kj0N1PDb+6BUOOC9GpmnjPTk+f4X6+EApyWkldGI4YN0iOaQl8OZjW
         aRMFDoFEVPv2uMSDlC2SL07+Hyl2gb7eh32Eqmfgk05xUcvuiXDf0x0Gt20hUyV9+C/z
         yjUEhKUoUlp2Abqjkm10LmvWv0NhsQ4vMoeGhmTXrmySwV/iOrhi672jno2DAaZjuBeB
         3Udg==
X-Forwarded-Encrypted: i=1; AFNElJ+mYMd0IQESIDUZo+T0UJ7JFHB6feyhgt6Ydtep84WDfQEZOJnnkGRulmbotscTFgsMQdW/Yoc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHPh6k3RNfKUSuFi4Yfa5pEOWBoYfWiZE9NNNLnzYbqegQi1wP
	sjTyjzQLzVaO2Kg6vtgfTiu1bIOcm9m8WBsY6BBiLZgsarCY21Ew8tp4MAE6Uo8O0HUF9d02aAU
	LyQ==
X-Received: from wrbfu2.prod.google.com ([2002:a05:6000:25e2:b0:461:e741:9a7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:26cb:b0:bd0:df77:98bb
 with SMTP id a640c23a62f3a-c05a1f461femr458002566b.9.1781773292698; Thu, 18
 Jun 2026 02:01:32 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:01:27 +0100
In-Reply-To: <20260618090128.3913688-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618090128.3913688-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618090128.3913688-3-tabba@google.com>
Subject: [PATCH 2/3] KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Keir Fraser <keirf@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

pkvm_init_host_vm() runs once from kvm_arch_init_vm(), while the VM is
still being allocated and is not yet reachable by another thread. Both
early checks therefore test impossible state: is_created is still false
(it is only set on first vCPU run) and the handle is still zero (this
function is what reserves it). Neither branch can be taken.

Remove them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..67b90a58fbea 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -230,13 +230,6 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
 	int ret;
 	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
 
-	if (pkvm_hyp_vm_is_created(kvm))
-		return -EINVAL;
-
-	/* VM is already reserved, no need to proceed. */
-	if (kvm->arch.pkvm.handle)
-		return 0;
-
 	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
 	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
 	if (ret < 0)
-- 
2.54.0.1189.g8c84645362-goog

