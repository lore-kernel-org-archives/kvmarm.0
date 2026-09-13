Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973C2931EE
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789331474; cv=none; b=J4yL8vlvT+Za/zBwXHlvfOzwb24b8pW4LrXhgaCZCDFppYiA55xuLf3XxFYF+JHvqwBR9S5IvOr4T5z0GZzp6+xPb6toRth4Q9B28ijGM1O5CKA+60lzuSd7+05ze0rrHjhaxhdZVh1GFyUoaxSP+waQD7wFmi5HuOkWKUcvOhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789331474; c=relaxed/simple;
	bh=VjWvJ6GwBTpH11FilsRB5EGaf7U1JBTe8QfjAPuJcbk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GTE55OkUjBfpFYk+NA23eczDM7S97JGauKA9YKE5m2vFi/1sXlCZGu1TPf/PTmYw/GAwLHENec8BYOgMzBPoEINFxrvpBdyiTUNf+H2Ya00gX2akTBWBzEcc2+/FseVW44J/qN7hwRKmM8nX8oU07ro+HfKdWNnvdiNRKipZaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oZ7BsrrX; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oZ7BsrrX"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e7631c43aso5580915e9.3
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 13:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789331471; x=1789936271; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nkInFxMRft8SM/EsWMHnh5CKtPWKT4sSAWgTUnaMbe4=;
        b=oZ7BsrrXNelDXEWMdDaLAY1Dcm9C4QRe8JZ3E3tcq8IYLT7+Goj8TDU13oY00835wL
         jffZviLkfzks9j/j0QNNspPpwj/XQPA83bHOjyrnzxRAkmhfSxcQJslhO9O5qKo/0K1f
         o2M3ENtvAAs4MwjWPbAWpwnNTVEmc3RjiLN+nG1rdskQW4MrPSTSwFcx7v1fLBuUmtg9
         PvUMpTYJjVU5vex1UfKLtBr+do11G4raBwtEzNbLF0/omKoETii6otnyBFmdJViIqCFG
         XnMseF+ExGChqp2+RHmabRkAQmracEURvqRrdxCMvi0Yti+k1LaiUpBdCZVFWBD1Fjr5
         qS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789331471; x=1789936271;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nkInFxMRft8SM/EsWMHnh5CKtPWKT4sSAWgTUnaMbe4=;
        b=HZbFW+TipwP3Z7QoP7v8wNVYMeceI1F+LV2uTqRAqHhSZ4Rppmr2aO+IXs/CNvWhxd
         ZrZ/wCTjTwxtnUljCssPcspRacEUqsE3q/BAh4FtYjqzCm1Bo6zDmWSQlex/DfwPghj7
         iYUtx9BH3r9NNCDHlscxS5nd58z+3KrgK1dMi7AtqsdAs9unrSksBeUwlMxY33EpNyDw
         caHltumUF/xxsRT8Iir0HOLj7D0i8QV3qBD5cZzpatUNJYk3+75KGE7sR38VpEY5eS3U
         2x4TV03RmmWnhkQdVk/vpSvENG1cNrYcuoOW9sUc963UjaMnB3xEwZLaIge58Dtov2dM
         hypQ==
X-Forwarded-Encrypted: i=1; AKwUvByHIXPGRP7sY7kiPUDrgdsyPLXerYWdW2QE3rZARShCREZU7Q0kZpSRcsBOMMGTHwEIjFkvbi4=@lists.linux.dev
X-Gm-Message-State: AFuF++n2MdaojnFXgl1IpOKKoArpWwlHAB2vnSmogpJshmlxXT6S77s7
	b4YfPxDj4Ka4lP5phvSAFobwDP0P51ooEMJb6147DfIFcdisAX9uu3tIE1y/t3Ui2mf0IhOX2+S
	0M69oGLAHmZOWHBAtIqeYYw==
X-Received: from wmcq22.prod.google.com ([2002:a05:600c:c116:b0:49e:6bc5:85ce])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8411:b0:49d:1e09:694a with SMTP id 5b1f17b1804b1-49e619f5049mr328748215e9.11.1789331471258;
 Sun, 13 Sep 2026 13:31:11 -0700 (PDT)
Date: Sun, 13 Sep 2026 21:31:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913203108.3343404-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Advertise MMFR0 TGRAN for pVMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Protected VMs can support granules bigger than 4K. Advertise TGRAN16 and
TGRAN64. TGRAN4 wasn't advertised as it is enabled by default (supported
when 0). Add it as well for consistence.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8758c6801776..ec469d96516a 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -121,6 +121,9 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT(ID_AA64MMFR0_EL1, SNSMEM, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, BIGENDEL0, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, EXS, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN4, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN16, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN64, IMP),
 	FEAT_END
 };
 

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0.1007.g17ff1f9808-goog

