Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A4D3375A0
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462297; cv=none; b=m8tibEVWC7htTmirt6FVi9ph5dY8LkGxcbiO3s/Ka/pDdahyPHGPol6U+/oweXGfakFUhP8QbPXe3x8Frqh+8G+xCgHFLCnvU3hzAWOFhEyJA0MgKOA1xLFgGhkGJBB4HvEcY06S5SmbJS4sAQKxNHTIDHqC6ZTK9CSjdYKN4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462297; c=relaxed/simple;
	bh=pulIDWqiXHYjQDiGlOdXtuPS9CFLFgq/X3KjNAoctdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFLBKhgtnaq1hpTHhCwf2PIpRnTcwQ+kosh8eoICt1qxocO8mwQ1COzo5rA+aN9yFxrAhw1jAEQhP5w7AEka2ndx73iBVOOFDIT/5zGDIXYmwDPPmfp1ufymY/8g1h3slGXqPOaDMD1jCRM1PMTY4jZZSTtEwN/yB3IAtJ8uUDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVnXYtOL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVnXYtOL"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47754e6bddbso37327615e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462294; x=1764067094; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mj956uUwRdou8vOWljZAEBe5NlAWrhR02NPjOj/d+6Q=;
        b=vVnXYtOLIksHmie4V4zaIGiTa581slhN4XqFbV1huXvI1oLk9uh9NR8jPH94jlBib0
         GWpl2qPu5yWP9JGVtQQNuesam+xlfEKYW4L/JWCJTaWSTsRi6YjTqqqRvWRP4OM4HP3w
         cYakmCSD+bLBHpNsNCcv5f90GqcyndhmvGeJW/UAJ7FAGKhhaAEx7106zmazTK33NPmG
         rpi89aefAuNz4APp/Hx2DsIVkxX3omJPslXSlPpvD0MGHiY97D9Lm2VrG7HUmYMtg9mi
         b7NtfXnlFJPVzKezdEM+/FA0wqkFavyBctKQV+Ur465rVkNm90cMnMZAXTpadLSiOiWj
         BQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462294; x=1764067094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mj956uUwRdou8vOWljZAEBe5NlAWrhR02NPjOj/d+6Q=;
        b=LARt6UD1xDLQFuMNFWIVEUEVyxyymgFOykqdoS1SamC8lCIY+faAV5Po8m3dLEi55N
         ztx1zn02uZo6tWpCgCtxWFchxuVGCiy0jrcadccrIS/RVER8uTRljbXig0aYw8VNX9SZ
         dy94mfJYbIXTFMdM/xS6MzMhaYXB0CkNItK0axdF7XTEVbez3zGOrRZmbOqpRw1+lZJl
         p65aGNN/ZSCTmaYkD10i8afYNkfFlm9F3A2fO1kpYdu8FRi8xRz38ZXB3qYqI+oIdkc3
         6IF4Sb8h9OZi4hsxpRRIox2Int9RtZB8iwwJXrXf+m4Kl2dKteIFe5Op2u5qEA/PglU2
         /D+g==
X-Gm-Message-State: AOJu0YzC+AD5UMBZL6hTvkNcZWvT35vtyMqUrqC9x9m2urMSHOiGxDFi
	/csbHzPHoCd/YC3HW5KODFxf0rrURZal4mCSRNCPrC7lPYlUAtZ8jDS2IIJBJ1wPqYC7me1YbND
	8IdbU482Ed+IPhx0BuNUSnZtTq/jiJIls9YDcm96YiwPIe/ntMBOPAEUujopGbjwKKHSnq1/rA7
	816sAkfnWF+29oiepJz+zYZQ+uG2DNxHc=
X-Google-Smtp-Source: AGHT+IFG1XaKywSAsO/PSI1vfE4j6/GJZ3MI2DEP6+YN51mOznt/CdrZZYQeVn3xIm60XagshhrHQklSQw==
X-Received: from wrqm12.prod.google.com ([2002:a5d:4a0c:0:b0:429:de3f:828a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2901:b0:42b:2ac7:7942
 with SMTP id ffacd0b85a97d-42b593459ccmr14897179f8f.5.1763462293703; Tue, 18
 Nov 2025 02:38:13 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:03 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-7-tabba@google.com>
Subject: [PATCH v5 6/9] KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Supporting MTE in pKVM introduces significant complexity to the
hypervisor at EL2, even for non-protected VMs, since it would require
EL2 to handle tag management.

For now, do not allow KVM_CAP_ARM_MTE for all VM types in protected
mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 7195be508d99..5b564576160d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -44,6 +44,8 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
+	case KVM_CAP_ARM_MTE:
+		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog

