Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9846450C2B4
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782538; cv=none; b=tR2lhCr+NpIz52DRLT2atClFotOCu540lCtqwzrOfv2bS1ObrF6N+s/d4tMeSvWpSWPAuNLD+cSxh/w+mjOh31NfqLj6bHLkwPmsiqnkkZnDms+QIn5IjN6BU/AXoHk5qTvALJ0rxrpCZ8wtFoF7fT8P5e6joGdzFeiZwaGaM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782538; c=relaxed/simple;
	bh=MyIGsFUJHSSN020/lGZDzxBhTSfBffcGg2TRTOb35kA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qIopynbhTUUcRtsObvWgBw6vB7hyXgrNfkY7ucJZj2Z3Ax1dwrrBUMHbAJscLZ89pQdV/thaxxr8fPN/mYXfa5zV1dXjY6YIhmcAQM0OU9PzkJ92ofmSen6vRA2feA+3jaAng/7iiroNjP9+ER9pz+NTN3meySpA3bO1Spzj4hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FeoMGnRD; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FeoMGnRD"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6aaa3fa0bd5so6989788a12.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790782524; x=1791387324; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=FeoMGnRDKp+8F1wo3wfT5eRdkD3cgo0qYAAqtsCvBdr6IQAkTqN89XiNHqmaKkJroy
         iHwzW/eHVpjuEL3YB41W8XihJ2tCsGEPqiSxKarXI/wXd07K5OQ+pyKnH+ofLOam3Dzb
         wM/2v7g4NIb7c+4CRir9gcc17JtjKiSZX9n8ydKK48NnnHXX6Y6Bdmfid2aMCoDsCAKm
         SPVYBKimUfI43GJ6ZF7zCVZ8vz2VsEuFIDLwCJP0kXiQanDVNcpceGhJZIqZT2p+Y33g
         /OcAEQ+ZqplQ6nIkn4GpHf0BjnTRn06aDkgiKveNFAyyT9ub/isIOwM4i9q+D/9ZuVjK
         ooSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782524; x=1791387324;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=fzbMoUGVKVh7sk+rKRYBTj9R5+EAtLInwNnGPH/EBRGyCj+Xm3QUWh1hx6ZsdXD8oM
         ZDyIgDZGu8jNlHcEAbLEWZJICMyUPmjyTaMPSYaHBPgCOhvybolUjz0Cj2jp7Adzl6g3
         KWbntWILK7ZkN00X9MbM6IWT1+SF0eD13IkJBbRvijxHA49+6cplDHitYQ6VKIdQclYp
         qwgX7RJGxMMVq4I0gQ3jchF+y+JPEllek4q6Lm7HZ+ukIxYPLORj29A98yk6pdSZhuJ3
         V87BVc9xecxTFScgqxRtrx+FzEVH6IDKfGrKsFiGqGOwwtvav9t7Bbwz1ZJmCy1ZWQ4v
         SZLA==
X-Forwarded-Encrypted: i=1; AKwUvBxVb1fhbgSZ45gDkaSosKDA/4eRIQ7ScnMwrlUWThnZxpqqQUnKMB0XCKFUuC7YnWesHU7azlk=@lists.linux.dev
X-Gm-Message-State: AFq9FYI4Xb7cRKeW4ob+Q1qH/Hyj7oNmmdwcz2z7fc8Cjbvdg+7kpA5S
	OaizT4plPeVBvV5jykusvxnEB6uhI+ggXC73cZR9gFTh5/3sZdynSs1csL+9hK2gB17L0NphEJo
	riuL/RPjedm8COA9TzXDr3w==
X-Received: from edqs24.prod.google.com ([2002:aa7:d798:0:b0:6ab:17a:73c7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4018:b0:6ac:afa3:6f72 with SMTP id 4fb4d7f45d1cf-6ae19864ee2mr1595600a12.5.1790782523857;
 Wed, 30 Sep 2026 08:35:23 -0700 (PDT)
Date: Wed, 30 Sep 2026 16:35:02 +0100
In-Reply-To: <20260930153505.2144559-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260930153505.2144559-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930153505.2144559-2-vdonnefort@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
__pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
possible, allow those two HVCs before the host is deprivileged.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..da8b6e3c01e3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
 	/* Hypercalls that are available only when pKVM has finalised. */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626ad..4f824b01465a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -934,9 +934,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
-
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+
 	HANDLE_FUNC(__pkvm_host_donate_guest),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

