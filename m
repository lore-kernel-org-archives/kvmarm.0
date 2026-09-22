Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F42545DB5
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082510; cv=none; b=Pml3kcdogAuDehQoZ4grKOaj7Nv/ktu07ZTbxoZuT2jvwhUQefAH/D8jYkppImresMMvh+FVxib1fj+eJggDtdnuH0kCwt//MPoNGweNDks1v30s8IjXJq89E9ceITn/tDbeM06wrd5Nhmzt+j2GFXGYdkSysfrVF0UjEib4I5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082510; c=relaxed/simple;
	bh=gyFcfA3BAnUPvUC1FPAUz0vHOmP5DeOvRiYu0lgxDRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eILRcBn5njT488BTAAuQWvHwJS+cm8Xdf1FBs6kLN6SgibBuYVLLPR7VA5osiakcYbWdMtx8RYA6nwYqCZggnsJL/wdz8a47oa6wvpTTePnrvTFqbMifwdzpXcOWJOOAAlFVKH9dGulOCiSmpeW3NJkt0A1oGXJfRIEffjno7Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dx8L3IE+; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dx8L3IE+"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so5294705a12.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082507; x=1790687307; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCKItQycxeia+cenpj/sZXV0+k+TPgXAs4fFmR/cfVE=;
        b=Dx8L3IE+hgM8nRAn5tcd58K0nCLnire0wr8pl4lp+GkRjdzMhZPmvt+qoTrdYik8Hw
         DmWT1P4WMeD8U/WSS5AQrftXDrQZvMlj+JYrxWLJAuQ2wohpxIJ5yeIB5ESPsaXywwDi
         7QGPkVA7YCM9qXUQ4GfUYQg/vFaigi1ilAwG970vccBwmf9cdKn+KOz6e5++jPXqzbwr
         vGDgoCx4NWEgHhYhz5nwm477/YjF3C3iazvgG/7bF3nGPXnM2zfYIBl1LUTKuPd0cXKh
         jITD2rsmRcnTU7oWUucnupZuVc7up/ZPpNUBhlv0iDAE1wiL3+o45X0jWfXlrLqAbSug
         UAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082507; x=1790687307;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UCKItQycxeia+cenpj/sZXV0+k+TPgXAs4fFmR/cfVE=;
        b=Z7uTmD5HnAHmdF3cIKmFaa7/RuYtnSB68ovQcaDOav7wcIZZUz3vqZU9bLcVAochrn
         baGOw8X9NU24ojQtJLyhpuWLj1+nnzfF31s7HXk/CSb4zjyJTO2vcSzYcFdfbceL7SEX
         J411GOU9jy+I4yxkCrwZPWGQAafceaqTQYZ4ZQT7UXNPuhfgMjn8zNc7UdTjs28eggH5
         LT/E8BZA411+zZCr4HouWM2hPfQmmhE+rPDtFQz37Wqnn17OgoMi8ng5xY0fIgWlI1gj
         wIQ23Y1F2sQFzJGdiYSZDtctWir5hVrPkzzud+CvuM7nuS4lVDjPqu20p0m+6O5TRuGr
         g13w==
X-Forwarded-Encrypted: i=1; AKwUvBzd9ftTgkNQVNwcHqm0qrSCn4pELdm9WmqGcSSbMwtTwzX19vYb0Wt9Kb33Y19e0e0mUsXidAQ=@lists.linux.dev
X-Gm-Message-State: AFuF++moaaPpzK77BMp7wx3JK6wJIvFXIcayoAumUspwBiEtkdvQ+m5F
	aYmsSfJMQLNs/vm3lXRHRqjrLtYP5FikscXwoh45ZPRgDu2hHFeYq8OcloAHYHlwueVuHM0dWcq
	rVHx10YTpN4D1DpYHJtgh9Q==
X-Received: from edef27.prod.google.com ([2002:a05:6402:a31b:b0:6a6:53de:2717])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2790:b0:6a6:757d:6311 with SMTP id 4fb4d7f45d1cf-6aa5783b5c2mr12915738a12.9.1790082506857;
 Tue, 22 Sep 2026 06:08:26 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:16 +0100
In-Reply-To: <20260922130821.1666713-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-2-vdonnefort@google.com>
Subject: [PATCH v1 1/6] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Cc: stable@vger.kernel.org
Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
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
 
-- 
2.55.0.1082.g2b9226bbc0-goog

