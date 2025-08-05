Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B2127877B
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402185; cv=none; b=EzmXs5dY22ScHBKwIua+id41ndEdGlHd8H6EPbg9O88RbAJHW4PJwzXBs9V4PLIsu+YGC6SUITuYoaCHQMhKGObsD8aDJQ+IYHqNCCIIh6OAgy8sOgOQVW0OGdgqW0eNNFGYUC+VBqT04OHMZ59JGEVKsQcblg1xBjxGDe9lNVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402185; c=relaxed/simple;
	bh=XI7EBW1SOZjArvCfKaIr0GfwhYLDKNKrsgVJRmrmC+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y4O4Xx13BVTKmWIlO2RSXmJdIP3YEaCW+CFXOaeG52nI2LfKyMqsQG2f68zRjeO9TaXXdMKPnEt9FGj1vvrXkC3mhDXUl/9atjsARGeWHHoa56zSZpxxPvj386JiOADshNzMP8mUpLDkn/XHMs1ppJTfTaU9ENY+mPTMWzBHrJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=voGo73ec; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="voGo73ec"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459dfbece11so7704675e9.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 06:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754402182; x=1755006982; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHsvp+/Bjkz0VzpOPnAgeOspoQjUaCKpxCXn8goA7qE=;
        b=voGo73ecblgIvrjB1ItICqWcvRrkQrduYzeslUPdsqvbpEghTvQiMClSUq0msnWPV0
         i/FMG3NhHCz5S8EhchZbYUQUgR/Uu451Yga3MRT6pPTfwdc1A2HxV8e64+YlN6LtueNU
         4DEt7eMl56fJUrRR0QBCD6o7DEN+3Zh3lNR4wvdfmUjK23VCHnbq8fEf3Sz7nCVo2Who
         MeE/y4QKA93My0ALQTocLILybW3jLKNvdryVRnKMR2jAvovLRKTPwjDfk4qZn+O0XzO8
         g/cUlbXxjO+wUvMinkLUM5MRHD3/E9ydunVTAmp7KwGvXCO4mPQk+hMvXP3DUZ+KUsxi
         OD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402182; x=1755006982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHsvp+/Bjkz0VzpOPnAgeOspoQjUaCKpxCXn8goA7qE=;
        b=b4YvJlZC2p78GOmAyNfoSE7k+hAydE7ALug/A8e0e7buEdFlXjBB1zRirtoimL18yj
         Pj6JUgcLkSGionoaxUSXWGkYWZKukryC6SP1l78dfYzsU4EiMdO9ExqeOST/uJq2+Qx0
         mZ+Vc5yhRk6fvZzmBz9saGpkARgBBig4LO2QYj8/GrnusuLGuAZ1FLXCJNrfveCNPPhS
         KuRr9Hh+nHRZN1bY9tYhCex5cc8Aa7nlSjpFSVwHfy+cVAOwW2ZKX8Ruzduh74MTgIwv
         u5zoMoAtobm0pLkc/RsD/t+KSOPi1ua73PRXHINMlNsL3o1+76VnDDRsP4Gmgb/m9GYn
         s/4w==
X-Gm-Message-State: AOJu0Yw4wiPxpAXYmY0A1BYsNJ0biplLeALI+mBbms2w5vQ0OowgeZlR
	7RflXn8Blg92+lxdAUeqU2uXaLHCwRFqduojMWFoeItJP5aquLMDXDe2t88IIxdaNhoY5u/1eE6
	URq329HCXjRG7k5QXD3L5qf8RC8WMdBroysaQnmWj4/4WHgzzNo3rhz6lxIcvzW8NP6H2Lt7cED
	f5XQZJNUa5JtHmbPfJOhkBg1Uo9sRt5H0=
X-Google-Smtp-Source: AGHT+IFWoGupfBIVH1rgX2yqjUwby0fXRVsDyp5fe2CHGq1F+B7GPhaYB69SziWlO39eO56tzXt31ZlbBA==
X-Received: from wmtg1.prod.google.com ([2002:a05:600c:8b51:b0:459:dcaa:ec9e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c02:b0:459:e35e:a90d
 with SMTP id 5b1f17b1804b1-459e35eab8amr16052345e9.27.1754402182673; Tue, 05
 Aug 2025 06:56:22 -0700 (PDT)
Date: Tue,  5 Aug 2025 14:56:17 +0100
In-Reply-To: <20250805135617.831971-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805135617.831971-5-tabba@google.com>
Subject: [PATCH v1 4/4] arm64: vgic-v2: Fix guest endianness check in hVHE mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In hVHE when running at the hypervisor, SCTLR_EL1 refers to the
hypervisor's System Control Register rather than the guest's. Make sure
to access the guest's register to determine its endianness.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 87a54375bd6e..78579b31a420 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -20,7 +20,7 @@ static bool __is_be(struct kvm_vcpu *vcpu)
 	if (vcpu_mode_is_32bit(vcpu))
 		return !!(read_sysreg_el2(SYS_SPSR) & PSR_AA32_E_BIT);
 
-	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
+	return !!(read_sysreg_el1(SYS_SCTLR) & SCTLR_ELx_EE);
 }
 
 /*
-- 
2.50.1.565.gc32cd1483b-goog

