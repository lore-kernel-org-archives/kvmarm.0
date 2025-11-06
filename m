Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509732E62A9
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440265; cv=none; b=PHsOstjMSKggHXvjaXVK9EUGRUUdN5QOtLdi4UBNxZBWHJuU9sUO5ZzLUfKbFOcNqUgqx+uvXOHeBCVPKlpW9OpJqC93edxHmDsFY1oPFA8joZ28LQcu25J/XIIL4UJpkkboaK3uDi67KMrmKNHbvm8VWdjeFWRdrOpbKGH0mRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440265; c=relaxed/simple;
	bh=Wafn4DMQB7uY8t0NfX49k5VvljoTeLZhydhCGoOaXf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FPs4HjewxBxzNyAGSs8dyfMyC8Q3trjs+G9fK3FzoTim1ZWqTZoPLEVyCbk/1oBdUIFnMukJQ4Cr9bDxenSktz7vDKSxTCofgrj8GLpEXaqxVaLQo3IjbPcz04AJsQf2Hp82JNDZP00/PCgrmJMZNk1uFUJBI/G9QpEE35ldJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XYr2NqQ9; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XYr2NqQ9"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-640a03bb8afso2263930a12.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440261; x=1763045061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B6V0v3j8Mz2X1AHdZWLdDkByJ6raAe2lJ4W82Bregkg=;
        b=XYr2NqQ9DyM8j94VH8oUYkNJsBkUwQXZAN0fRIFDpPJ5WgxQCRCbzZ16I95GJabbky
         YY0Xlb+UiTM0T7AIb57A2PY5PrGs0Z8cS43lrRdorFc1tiRMmRjTK6pyaDBE76KSHWzI
         Jlu9IuOn638JqPWDU9VkIFycBTVd0pT0CVszGGZIcXo69HxOD+DLtfw+6dgUILPg2IN6
         Y3ZeFTTjKvNVvG9tJiAReGjro1LrZAn3RaPPLaKIUtowgTi35Z4Waz+VG72BI9VlvIBb
         NruzoI49OdlfS2euU9S/OhEorvOEoK1+Lt4c4NGW9ENLvdOnRe2RZNA5xCEuBfSeyIXf
         bDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440261; x=1763045061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6V0v3j8Mz2X1AHdZWLdDkByJ6raAe2lJ4W82Bregkg=;
        b=HLL9m0hkt1ZSF0rO4A3Bhxn2Nkd/HLy9TOeNXjZ862fDeip/2H5Qe2+LWhiumKettv
         CAyYfSrJkM9xiUSK77Nsx7tMTkt0wdn4aEEKdJ97IbrSnTpXYlCwo9t0/Jdnow6EHyay
         loq2Jf5znUXnN6jDaWIJqGUM6Web750qcDw28nEhXKCrWGx4ILqXznMDgbVIeafF3BX/
         idADCtQ5tFy+5u51IoTxKLbvUtITgXj0SuwYvGBRLKmqYAO3XrxfG+sfdSkXSHvlIunB
         yC/HuaowyFcN+rr24iEeeece0LFRW5fZIPJVF04lCKTwsG1deN7S9r2Q0J/L0kDPJy5F
         Kj8w==
X-Gm-Message-State: AOJu0YyPZgbCsdqrbYYxW1fPy1nY84L6opeuCa0uU3XgSXPovLZIuCsv
	ZPNcSJvXDv4j5rTWctzdTOX17xqg/61qxullsz1hpPQtsMhl3d7Lk4IhLCGYi5lXY9XrycI3nvR
	sDz69etyBcX8aHNb90OpadhegF8QXrYfzEWTBXMs+HKew0XP88jreLvjruIdwoV8fhi/6kCsm9y
	pUfvfWrle9xOrurq+zvczTXqiMeIMIHVE=
X-Google-Smtp-Source: AGHT+IHvoHQ7Go2/sf4QjRXMlPxZiNl756S8QdLN7jBThmOA368JNIG1jhs5or169fXZHCaxFBZEiInFQQ==
X-Received: from eddp24.prod.google.com ([2002:a05:6402:46d8:b0:63e:1c6d:cc6e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3489:b0:640:cea9:6752
 with SMTP id 4fb4d7f45d1cf-64105a578e9mr6621279a12.25.1762440261436; Thu, 06
 Nov 2025 06:44:21 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:15 +0000
In-Reply-To: <20251106144418.2847443-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-4-tabba@google.com>
Subject: [PATCH v2 3/5] KVM: arm64: Fix MTE flag initialization for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function pkvm_init_features_from_host() initializes guest
features, propagating them from the host. The logic to propagate
KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
has a couple of issues.

First, the check was in the common path, before the divergence for
protected and non-protected VMs. For non-protected VMs, this was
unnecessary, as 'kvm->arch.flags' is completely overwritten by
host_arch_flags immediately after, which already contains the MTE flag.
For protected VMs, this was setting the flag even if the feature is not
allowed.

Second, the check was reading 'host_kvm->arch.flags' instead of using
the local 'host_arch_flags', which is read once from the host flags.

This patch fixes these issues by moving the MTE flag check to be inside
the protected-VM-only path, checking if the feature is allowed, and
changing it to use the correct host_arch_flags local variable. This
ensures non-protected VMs get the flag via the bulk copy, and protected
VMs get it via an explicit check.

Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index f6f8996c4f97..7e370e31260d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -337,9 +337,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
-	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
-		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
-
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
@@ -372,6 +369,11 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
 	}
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE)) {
+		set_bit(KVM_CAP_ARM_MTE, allowed_features);
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
+	}
+
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
-- 
2.51.2.1041.gc1ab5b90ca-goog

