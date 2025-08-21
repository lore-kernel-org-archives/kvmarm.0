Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ED62BEFE8
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810050; cv=none; b=QZBtUN+FGMPEe4WEchATvBM4p1QKicGa4l98W0O9hLwoy0yOO+aM5ULBVQahcXIUXh1JAvhb2y1ydkgwJEbJl4NvAw2EmxquCmSDnmPdDNh0eNufHI8I0bymMi+kkYJ54l5LOQX83G0n50tiTE02szb+Y3AyE/dLYmnxQomSqqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810050; c=relaxed/simple;
	bh=XIPH6D7OK9e9Nk/anEV/qb0UKnQEM3J9OnJTOv3j/hE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dyBEDkyyGWhZYcd2D78pmLzPwThrRyHwi/x+nEg+Nm1Qftzgk50bcB3IMHqpYhyzl0enHXvEpmindtToH9pdYzMEQlk2RNmvUJPyUokkEL65A4jnhuUBd2+9INRf+gxU/Wv6SCiSBURhGgFq8UQ+B6p9soIXen8J2yV2ywFJeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iRo9VxGQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iRo9VxGQ"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4731a95babso1013763a12.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810047; x=1756414847; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=etQsx3Bjkyo2W+FnvyouolCpcLbOwVVqYYIcKcKxQxw=;
        b=iRo9VxGQyNNZJtsyw3azmq2HtYNcsI7hdFpD2GdynkRaYYscIbM+euG34GH+KDnXUB
         98jOrd1DWhxptjvPbaWqwPfQEPTn+2u44VwytgFMWIybmbreyRMAunKaqee1taFISpa2
         zJ2kNFvcTYcLwmqtwsQgceiot435/Rz3g74utFFKM0vl1pH+C4wlGim8BX+ChN3rVSZ1
         qWE7ouDt1qb7siNiJoDpE0aziySlAzA0SCMSQajfb/nEbVUdGhtCCsjSpXREgFm44gul
         TkLYpMr1eNcZykviGgFgNXMKwSlX1Ha28bN4kw6BMzl+KgEULHfYDZuIsPTGJJfM99jz
         c6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810047; x=1756414847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etQsx3Bjkyo2W+FnvyouolCpcLbOwVVqYYIcKcKxQxw=;
        b=n4IUSXIsrXXN5wA9TFxZWsdyHt0nIMv0+tBMZAGZ7ZAvaYCVlAFPyCSBgWHdQ12H5o
         NidaqFaHFCxb72/HFgSCA/bHhqKwyRsxRasEph8XB0kRIYrXhcIaR1tZ6ehpsS+DBMzL
         2mdzS5WoukSAXQAQJwBiEkvsYU9D/fVeg+He4rq8a0IaNK1G+4z729qzJks9UNv9/WOw
         OxtCL7AiFIObRrWjYRlbf7QmJ7hUYOcJ8qjyf7eMoUgAEVcfjqkj4OVxqPpkPGklbfgq
         R5rJrL2NUOdS07jtpCPLa3DdCBP8Lzk/Kgub63yB+23P6+RDpCQsdoawcl4DrOicWS9I
         QYtg==
X-Forwarded-Encrypted: i=1; AJvYcCVarz5ITi+BwoV3atCoPFz4M2o4c0rTUnGnwpp6UzD+4bHSckBtdGCuHuJ9qVdUXKu9WWKbUOs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy43wrqg3G+5vNtsHwFZvf7wVaUoATUrWP+DUOxw+46wrGlnalb
	yzXUYiIYd+WDX/+h485sFGXwsrTcaMTYNt1JfdfPiRjMPQ4sIwiuXx1zQkuBtn/QfhCQO+K25g1
	KVUd4ag==
X-Google-Smtp-Source: AGHT+IG+AbHEFENih72v8s75m7PziM02RS9Hkp0sUk/+ACGLaOQo6n0X4YmQa5UYgK3E6VY5WcrGDki7bAU=
X-Received: from pfqn26.prod.google.com ([2002:aa7:985a:0:b0:76b:b0c5:347c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2446:b0:243:755:58b8
 with SMTP id adf61e73a8af0-24340d9268cmr736072637.57.1755810047367; Thu, 21
 Aug 2025 14:00:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:27 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-2-seanjc@google.com>
Subject: [RFC PATCH 01/16] KVM: arm64: Drop nested "esr" to eliminate variable shadowing
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop a local "esr" variable in kvm_handle_guest_abort() that's used as a
very temporary scratch variable when injecting nested stage-2 faults, to
avoid creating a shadow of the function's overall "esr", which holds the
original state provided by hardware.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5..dc3aa58e2ea5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1904,19 +1904,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
 	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
-		u32 esr;
-
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
 		if (ret) {
-			esr = kvm_s2_trans_esr(&nested_trans);
-			kvm_inject_s2_fault(vcpu, esr);
+			kvm_inject_s2_fault(vcpu, kvm_s2_trans_esr(&nested_trans));
 			goto out_unlock;
 		}
 
 		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
 		if (ret) {
-			esr = kvm_s2_trans_esr(&nested_trans);
-			kvm_inject_s2_fault(vcpu, esr);
+			kvm_inject_s2_fault(vcpu, kvm_s2_trans_esr(&nested_trans));
 			goto out_unlock;
 		}
 
-- 
2.51.0.261.g7ce5a0a67e-goog

