Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839AE33B473
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114462; cv=none; b=NUwm/INQ3LV/D2fsjZAfG0zqb2KYRkZdf5D6zwVWVyNDyeR9+3pN35XejS1c91VTuT9U0ltD/EWemgtf1bg00zMoljgxmR2t1NA9L3xo8W6QBRf+i91xuQdONqsdMBQ2q45LIL/VlXNkvvCL5TH1iTG4JUIfI/Y+hHpmGNiOdvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114462; c=relaxed/simple;
	bh=cFGMhYvRfY9VbCIJKIkuugXdHrAdn/krgr3zOGwE2B8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=unPahykaNhaVaihgKykLSwrTSI4DKifky7vtwm8mPDtdorEiae+J0X/rQAUnI3LQ+R/tO192EwqAlrs4eXZDn3ORjwvZCi2f1iujiANIGXvDJz9tjiKiEob2X1CKX8YQ+u1ESCuPuf3Qi8VYTNOOXFybcZtGFlUAnuJdIH+a8hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sgk1VmjS; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sgk1VmjS"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45e037fd142so55432345e9.3
        for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 06:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758114459; x=1758719259; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8nMbtF83ZYtz2l9mfpcIZhhnstM4fj0En2ikZPXdwXw=;
        b=sgk1VmjSiy0wXHH7nyjISdJzmitevk4MkKMCXx6ouetGFXfV7ZQBp6IHFlyvLUIohj
         Yt3KHQhKLVeZts9ZjtSNDsrLUZoHoII2jXkeOfMBawlTDEO0ZPg8Y4YdJ545MzGzSaeN
         3aVR560/+IAQUbY70ODJppp6beBDU5c8iB8yOu4PMRy+jUuE/KJkMJnnFo2Ez9eU12po
         YHyoz/fFjnAMwvBY0dQyIf83Rl2afdtSYRu3aLROj8GnkemAqS+E2TgosyVmyKfKXDcu
         XiYAJzDiwSPQYsuvkMWk9fiiFalzWT9pveoKerf+HVBVHHMk7gtmbGgyOgEBXoQEZKbc
         ZXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758114459; x=1758719259;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8nMbtF83ZYtz2l9mfpcIZhhnstM4fj0En2ikZPXdwXw=;
        b=aBzRN9Rwr/saVpjdPKf2m5HEQrueJZdu+q/KXDyuL5I1YRe8KgxmqLRySFbFbOh884
         f0RZeE2iNDLXN325p7SSQn8d64JNB7cchKc1cNPtVSFSgNGr6MPBEx+mLV8KEza0Akil
         YMLYXKc0iO2T3haHGc6/QhnYn+26N/6PsfhFyvvILo0OmoQXuUzCFa2P3r1DDeaYkQCf
         hKk6iY8CMQaE2szKT2zgAdHE5lSV36yF/RITK/EhWNP5aiIte/LZ8vbh7lpiMeM46Qg8
         Aj3Sbqm0C4kj11mHjBKq93lC+EnKFPsXwLTSTxLs1G9iCPOTnxa2BBfDq7btntOI9bme
         Gbgw==
X-Gm-Message-State: AOJu0Ywtu9asOsXBF/oxliUv5f55/dqL2oYwumWfJ3U3qx26QdHXUUDJ
	qXSaOerDlRv3rJeJ5+gcGhLpL2+8bySOiGm4OflUJnBonisVRbLlSy3yy9mAe8RgXoDfzXYqohg
	Vu1UsoeHz9C9PZmM9Pd0/sBBtShqvgPTTZVT8u2BaKp3kucuqKQZHw5j9XNW8KEhI2x93Kg+So3
	pp45sVKf8uLbiggG49z/Kd7DdB8w6z7P8=
X-Google-Smtp-Source: AGHT+IHWGmjnQP9pG3qanj1Q5J98tdnrDnaB3XFkq7Nm5Anu//i+9DZtynKA62hFBPQHVSIzroNa5bSyaA==
X-Received: from wmpl42.prod.google.com ([2002:a05:600c:8aa:b0:45d:e45e:96aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b8a:b0:45d:d50d:c0db
 with SMTP id 5b1f17b1804b1-46202de09d9mr21103345e9.15.1758114458792; Wed, 17
 Sep 2025 06:07:38 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:07:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917130737.2139403-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: Fix page leak in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, ankita@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

The user_mem_abort() function acquires a page reference via
__kvm_faultin_pfn() early in its execution. However, the subsequent
checks for mismatched attributes between stage 1 and stage 2 mappings
would return an error code directly, bypassing the corresponding page
release.

Fix this by storing the error and releasing the unused page before
returning the error.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Fixes: 2a8dfab26677 ("KVM: arm64: Block cacheable PFNMAP mapping")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on Linux 6.17-rc6
---
 arch/arm64/kvm/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 86f3d80daf37..d57afca8afb4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1706,7 +1706,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			 * cache maintenance.
 			 */
 			if (!kvm_supports_cacheable_pfnmap())
-				return -EFAULT;
+				ret = -EFAULT;
 		} else {
 			/*
 			 * If the page was identified as device early by looking at
@@ -1729,7 +1729,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (exec_fault && s2_force_noncacheable)
-		return -ENOEXEC;
+		ret = -ENOEXEC;
+
+	if (ret) {
+		kvm_release_page_unused(page);
+		return ret;
+	}
 
 	/*
 	 * Potentially reduce shadow S2 permissions to match the guest's own

base-commit: f83ec76bf285bea5727f478a68b894f5543ca76e
-- 
2.51.0.384.g4c02a37b29-goog

