Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F429398902
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785008; cv=none; b=cS9BN6IvAbIEsoGBF3QH9V/F8CqKabx+qFZ9GZozLCplvOtWp+yNWVByjXBGvp2sm4rVHGXjdlXkZnTE9ZsFp9VsmaWN5/DZxm8j8zjBSRzz81h2nZ/IayRolywU6wAYjmJmD5Sz7w1iKoaF1BtMmlg7Ml59uuxn6Yp1Iy+tWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785008; c=relaxed/simple;
	bh=k2tUUrjaEOJSqLnYiH4trRmQE35YgYWiuUcxe3jHqqE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RknIC+zDEmutABQj09XCdgBWtc5zBacOLA76cWk/WJpuaLox92YsG3c0JYkLhZ45CYZoF0tUOD7SpspkmdyJxIue0RiSd6PKNWqI592Mca2sctThvgSaK5XXHjnSN3mnWqza4BaZC28BioFQ1luH+98xb31EwgIkVPRc8jgAziI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WHBCMo+n; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WHBCMo+n"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-beb6d964066so60415066b.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785006; x=1782389806; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MmD9Cr1xCcQkaKp0J7hG0PAULLmxV4B2BqTlvVuIlHU=;
        b=WHBCMo+nExYAGUSLf+blQyVL5KXiVz/VbfKmPXD3psJpxnG/k2UIJn9OFo0yODT6gv
         FQIlS7J0fjQFnCw9j3Z6EQs/ozoKbrBH7qPl0BqxTXhdPEXOtsM8dc3IlyN5+eW3hIw0
         yZy6UY4AZIPYKDdqZFuSQlar6W5Kwf4kldy0+dqTLJhkwFCXfeRbK9rfLo7Kkin8SDac
         cI6hHhHRjeEveLc1ELWQgsQQxiLetIgafu0KOzPaQCPsV3gRvJHg7Zz/b2iDq1VNE7ee
         7+sGhjDG1VbexMc98CjXen1I3MnXRKCfJqefsR8oL7RsHIJJEVsJ2z8W3Is/eCqXkKuR
         pSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785006; x=1782389806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmD9Cr1xCcQkaKp0J7hG0PAULLmxV4B2BqTlvVuIlHU=;
        b=JPtSmr7yxk1+jrIf1cprQf787OPE9MTzO0J1c52XPIsvjIPBZ1i2pOm8heB4sY/oK2
         VjwncL0bs5VUddElEOmVTG1a8018zWdBlx6b7dqajAx087bzh/HT3OlGWzORGG6VV/w5
         H9KSyoEuti+5N8mDXV2U8KSfkvd6IloGOGzLeHMs5Bt4MAOU98mrnf3IkJIyJ1DwTTxW
         qJRTPTg8LNWVxYfOxq48jH3TJLWdjn3NMYH/TyAG9FPigRk0jVe2ORp/GqAZtbafxGI4
         D0OontihbbCJnQtE/K65fgX+DJoNyKVDY4K2z/FNtLahxrLXc+5/efX6x9cntFgeS4i0
         BWpQ==
X-Forwarded-Encrypted: i=1; AFNElJ8w/5NUYZ38mcws5GYSDAW45UpsRQ2/AaspaoegZVT+w8Z5BgxVcylxB16KBuB1rf3Du2vr8Fg=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy0oZOENoRjq0TbENryHIBrAang7foACPVfZ1cTqpwOAY5jCZ1
	4fw2uGm31grbqlJU0h3+T0b6TjpzHfGHF1ZLvy/x388Kmyq+9WKiBsUvteyL9whCKbqEaILG86l
	m4g==
X-Received: from wrs10.prod.google.com ([2002:a05:6000:64a:b0:462:b6f9:c0d7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9305:b0:beb:b53d:4841
 with SMTP id a640c23a62f3a-c05a73a7992mr547603266b.35.1781785005667; Thu, 18
 Jun 2026 05:16:45 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:37 +0100
In-Reply-To: <20260618121643.4105064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-2-tabba@google.com>
Subject: [PATCH v2 1/7] KVM: arm64: Set ESR_ELx.IL for injected undefined
 exceptions at EL2
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

inject_undef64() constructs an ESR with EC=0 (Unknown) but does not set
IL. The architecture mandates IL=1 for EC=0 unconditionally (ARM DDI
0487, ESR_ELx.IL description), so the injected syndrome is one that
conforming hardware cannot produce.

Set ESR_ELx_IL in the constructed syndrome.

Fixes: e5d40a5a97c1 ("KVM: arm64: pkvm: Add a generic synchronous exception injection primitive")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8c3fbb413a06..9767adf1f73e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -278,7 +278,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
  */
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT));
+	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL);
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-- 
2.54.0.1189.g8c84645362-goog

