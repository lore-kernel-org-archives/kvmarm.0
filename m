Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EE751E445
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865019; cv=none; b=IRJIT3/DKFDViRyRtPmYCiTyjnCPn9Qn34kywPfSkAW+RsEfoWxYzRa+J1CGrjv0IpLVGWsCz0FeknF6auhISdo8ByajRpsbUrU2fjGF1r1Pjy/FsOiX1nX9SmMmJZH3R1PLdci9TQoqdHkF8sgC4XD0QKnBunsgrbmUTiMaI8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865019; c=relaxed/simple;
	bh=MyIGsFUJHSSN020/lGZDzxBhTSfBffcGg2TRTOb35kA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m+u38sVGSysICtTH1tsdeMupW69ODZvNtFM113LuD8WwfTf/sw3qn+xvpnTLYKG6dRK43CE8deF9BO9Z3e4X+PYFtOqPSH/SkFe82+Caj7+VFe9Ot91iPLFi0bpcHe8nz5cthdJ0oLdrQSgEolLEZ8FYVtRpig/1O07Py2HAzXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fAwrR9Dt; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fAwrR9Dt"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48af4046a3bso3205788f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790865010; x=1791469810; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=fAwrR9DtE+v/pBZLM/O/hGOo9H8U5M9otI+JDIwKB4pFHBbMVbZJPzAokh1rfEN36i
         JPGfvwLQuwJOV+PBgHMg8y8W5hYPXvu97ZdXz2/muYYEiYAQhcprIpktTg65BubUq8Xg
         qU5x86KK35eIIIRvJ6LbawbqtzkDEZLreiOGHdNNjPMLxcam2dyEcgs8lFmJ3i/Mo81C
         s7N4Z+g0/uzrl5sapPGVh+aGdmL/R19fkO8FTIinfiXKSQeTVFbFg+PsT9/TNxTNl0G/
         TkeTeCw3F+w1JSViVn/3ebK6xU2fjhjvIRIklI1RrVTdYj7qpNHHzHk9k1L2zdxZDkye
         XZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790865010; x=1791469810;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYDIHbzRs/Gm97BYr5mSO7AAPaWkZ7oe9AO8sumxX2Q=;
        b=RsIAlqcgyon3OATPFCnnrm2gA6YUL7cZAFwFql1/9JN3ScCz2SxZLo6kzieK8h0ROF
         TJYbsrAQ99E5hDbo404lMgZ2tds/p+ZKtzlEr5SsCHY1xb6s8xQ2yl+4pEf6EgfQ4ttN
         iM/d4b6e7QMgtPJN/ux3Q6ulZrRriv8+omuM+LSPc3LTOcTJAWQ8/Sfm0SG4TzTTfRcd
         buMqdWELGzWS6eY9DGB7PXCydKcJ2NZNdkp8leyT88FEe60bR+YaQ6CVyvmlj+s2ETtc
         n14f4HETsgO7bmpjsatXmVAIQbQGauhzNvkpqu88mBNAWNfU/Jxa7j0w5cP54Pcu2lwH
         FH/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzODRYlQDfnr0M3vkqmPtZnDRGW5gk8LQnS54t32SzqjOJbMhZn0TLMScg7nqVwKxWpdda5n70=@lists.linux.dev
X-Gm-Message-State: AFq9FYJUyZBWRp8g0BQikyVte4QSeIbgEGP6HAKPnetSVXSZ0lkVbiFK
	cHCTrL6CZtThNQCik1NxEpXIvLoxWwAth//aGIHMn7GWh+Ggki80GEDixb4CuKlTKvsHBTN4skh
	0O58ySZ2geIVjRnYd1jZPqg==
X-Received: from wrbhe12.prod.google.com ([2002:a05:6000:15cc:b0:48b:d23:21bf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4811:b0:487:27f9:82c with SMTP id ffacd0b85a97d-48b02538b74mr9807609f8f.33.1790865009509;
 Thu, 01 Oct 2026 07:30:09 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:29:57 +0100
In-Reply-To: <20261001143000.3371786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001143000.3371786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001143000.3371786-2-vdonnefort@google.com>
Subject: [PATCH v5 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
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

