Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECA13914FD
	for <kvmarm@lists.linux.dev>; Sun, 31 May 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780242353; cv=none; b=Fo+ptUxXMxhFM/50uINgw6DLyw+xfJZfx8WhKlunvKFNg/ve7arDl1mBcAQ4URBZ0LqbHRNtw2Wrsf+vaShiuYLP3PzwyHiq2+kYKErzptaptEz1qK7keod4t4RnzZoGUWGGhzv49F5fOaj5jywt1h5WbRDLh7lofsEk4ONvo88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780242353; c=relaxed/simple;
	bh=4W1NFT8egfIsuOpwHtsrvwG4F7ILQ3DCUTBazhiSZQ8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q/+FWC8a1OVP2QcTmHKNt2eyOj8ZHOvdwYWHq/ODhj9aptxyagLozOZK9Rxqkhqc4g7GaRIhph3bNCAiWPBW4LqNSKPRQ03nTn6GxzmaRsmPqtWOAJA9n3HMi0jIPppcG2YtJTTVbD8z1k5upOjoFLq2SAjYUgldRjWN3Frk6/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g0EBcBMj; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g0EBcBMj"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-beb86e54b79so71943966b.1
        for <kvmarm@lists.linux.dev>; Sun, 31 May 2026 08:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780242349; x=1780847149; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4HGHSV+ymwGZVts9xs57iGtb0PHiB6C1QG35wARFiWM=;
        b=g0EBcBMjy0PuVyfS7FoQLloRXavhA7rKdKO/EXcwm6gQKfZw0OBoIcICYItWguRumr
         YKGGsBXWDxX2sq9pY/vB95jpATDCsWHwVPJufIUq+YzDR2s5JrjHSJ+lMJx8cL8PJH/0
         5nxK29s4rX8llMYxdgVO2Q1B7lBLUl/46MvPc0F72S+2iJBz2J8bb+sFKhri4o0zutGh
         Sugyh2c3Fi9/+4GzC25PAdRjf6hHlD1qelqu9wnjjfIDUxDxxkbiq0Gm1kmDM2AKsSH8
         tDtRzJ+AR/CH0ob8yz2gOeYN3BM5PGCDxT4mjCUF/oxjPoBRFMs5/LZtYXlEwdfLPXIp
         iwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780242349; x=1780847149;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4HGHSV+ymwGZVts9xs57iGtb0PHiB6C1QG35wARFiWM=;
        b=naQrLABw51Y1Dd5mzS9T1eg2ADP7R4PYfP9W5A4KqmBqqbD/gpnP+YHaiZdz2nl9xo
         3XPuqWtSUo7kwUDFHPEESZEFf5EPOnM+nMRanuNM1Pywh1tOKo+Za1ER78XH4jn5gWDK
         6zXMN1d0Rn+mZ/xcuKYHjpAQ/7FYpSMEAU5d70jEKRzNg7JWckrWZDsMNygC+LEQbAgp
         6VCPiMqCmDtN9F0F5bDkSTls2nxpXHWWEM4iPSTwI3aWAYqyJHU8qqpuywxuUuCAYS+y
         364Zh3w4xTbL5hXyvTPoHH0y+NmKTS0tuT/QyZ/C2cdkYRoJxVLkvk+EDlUpyS2nt+M5
         utrw==
X-Forwarded-Encrypted: i=1; AFNElJ+1V0wcBKFs8huu3L8KsT3B+iTUG9GhVHQw/eu38cbNMlxkGnoZ4BAwdd7+mb81gRPbQ/HP6OE=@lists.linux.dev
X-Gm-Message-State: AOJu0YytGO96RAziKKADrSRQYaODLHcrgppLvYOzLmc903WIfrbzC46v
	GJhIqu11A9a/JH82vgOpkEyuFKWfeYdHWHL4SROwMQj5+t1HDC46EdEryqgwiNbWWh4QUYlVxSu
	rgQ==
X-Received: from edqm24.prod.google.com ([2002:aa7:c498:0:b0:68b:eff7:97f1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c10:b0:be2:6e41:ba8f
 with SMTP id a640c23a62f3a-beab5bebadfmr383941866b.44.1780242348882; Sun, 31
 May 2026 08:45:48 -0700 (PDT)
Date: Sun, 31 May 2026 16:45:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260531154548.1505799-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM guests
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

With pKVM enabled, the host injects a virtual SError by setting
HCR_EL2.VSE on its vCPU copy, but flush_hyp_vcpu() only flows TWI/TWE
into the hyp vCPU that runs, so VSE never reaches it and a deferred
(masked) SError is never delivered. VSE is a host-owned injection
control, not a trap-configuration bit, so restricting the host's
trap-register values should not have dropped it. Flow it on entry;
sync_hyp_vcpu() already copies hcr_el2 back, so delivery is reflected
to the host.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Reported-by: Sashiko (local):gemini-3.1-pro
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Not an urgent fix. I should stop running Sashiko...
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..9e4a20df6409 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -129,9 +129,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
+	/*
+	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
+	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
+	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
+	 */
+	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
-						 (HCR_TWI | HCR_TWE);
+						 (HCR_TWI | HCR_TWE | HCR_VSE);
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
-- 
2.54.0.929.g9b7fa37559-goog

