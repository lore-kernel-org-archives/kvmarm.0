Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6695521C167
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754568101; cv=none; b=k3+3ZWSvuqZyPODad9UeUWlIUtsvaeFml3Cmzag21OLMUbYQU87oNCQnc6PDAdqLlTkxPDJPkMHOCIHgCDydt9nGPvPygm6pCeiMCYj1c7ehjyl8u9ZjDb8tbhV70LwCdBIS1+PN54ziESE/6m+f0+asmSP2UBLCyMhNaG4OMBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754568101; c=relaxed/simple;
	bh=6XMQ7jowSf9nyZFETAKPVs9jE86WG6Ln06I7ic+HX4E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cMorZlBvvgYYdKKCBbXcFUncrYlU7MmdM1JlUGcNDc2hxeI6jiXbMia6XBF3tE14+xJTiYH/KAMy9xmJYLpO9Isd1M62OOxxtn4XSQqeaxl9s1tQyaslD3G+86eyEVu9ezEevCoafmI8rzalwWp4MSM2NAcMv8gtFkwMnQLKt6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhCU40yX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhCU40yX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b79c28f8ceso785241f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 07 Aug 2025 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754568097; x=1755172897; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXCB5COPxS98+AOtJTPe0xqgTof7/tudFifEFiWyRmE=;
        b=dhCU40yXub/dILRBQMK/3R8NcOWS7GZyxYyaQjOFBnvz59hmTAAGsYUmp0LwoctJee
         I6fiMFIiU/WAW8sWOx+LPBlVjWNMhC75Bb47l0dPr4SYnuGB/Agv075l7TqChLWrpxAi
         l7Preihw34JC+nmPqAdprJPRJJlTnbQnxeNfKgrnU20EtVZdgzFsGFl3I3k99RFVZaWX
         oABiNPEXHJmpSPpeoV5hNqr9j2FDm3FDyZ10k2alGBcyP6RupUjynCY1VlHNHrOIcnZs
         sZ7BnSMnRXQyLPCcGOs0gTNAu+ouRSe2phyHAPO93NoLpVNr8xI/rKFimy0+y8F0BiQH
         R6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754568097; x=1755172897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXCB5COPxS98+AOtJTPe0xqgTof7/tudFifEFiWyRmE=;
        b=em9BMmHVDr0XZTb4Cfr6flyjte/l6iRRLFSNqp6nOXtEgcZbIt8K0OTRIB+UVL5wuz
         Oej+SZpHfoYx2X8F6mELEZhIFgFZGrsN5808bNxxycf8JoDd+68HVdgKfAnGovEV9w6/
         RknDbnYdpmklUbPCQePmQjgPjrWYG2UBkHNPzKoryveCmUvVYJKU6saUP4aZf8oUgMBy
         MYYJSoUdaKggRursgEzmpwH/pSgRcxlhj1YNMa+SWGAJoBTjilJz/MCtFFKWDQ9/FRAa
         iJdm5AMN/GnAUrV3Gdx8a0Bx0v9g5Gp6RTIx+k3rmKKvRQxSNOlpA0S//XFlLDg8/tAI
         f47w==
X-Gm-Message-State: AOJu0Yz98podiQycs0L0TIlXTkMLxCzGPtmf6lL5pDBKKOi0Ktmymg9M
	iDgg7IbnRfA3xUJ430Stj9XQp44KmPuYMdoaLZAMfv2T5YK8HNA1YAjwgiIgQm7vCIhDKt8EyLH
	tA3/BvoPqzHwqF0AxdXt38z+BqXY6IZwJpO1jPAz32symgzvq9Kqa8HWrMJMWScaiI+2u7UvGVB
	XrfInh4/2oYoOvpN1uNVTygvTiNFxIix0=
X-Google-Smtp-Source: AGHT+IFbqlgpUCeIKiVmVb5DLHkhJlFqnQA1O8BwRkG5e8YjpC281M7Joqt7Ovdou2jw6C/+AI/z0mKmcQ==
X-Received: from wmqa10.prod.google.com ([2002:a05:600c:348a:b0:459:d67d:cbd1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1a85:b0:3b7:78c8:9392
 with SMTP id ffacd0b85a97d-3b8f4166f4emr5302575f8f.19.1754568097308; Thu, 07
 Aug 2025 05:01:37 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:01:33 +0100
In-Reply-To: <20250807120133.871892-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250807120133.871892-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250807120133.871892-4-tabba@google.com>
Subject: [PATCH v2 3/3] arm64: vgic-v2: Fix guest endianness check in hVHE mode
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

Reported-by: Will Deacon <will@kernel.org>
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

