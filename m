Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609620;
	b=Cj74+r8PkjkQQxUARS+mUX6t465zkFUVgtGyOeYhu5vNYfSFOGzh4gytAAvhhSn8laKX
	 2LBOFVL69BPc6jue9aKx9eE5LaMa6sZRp2HevJsoAIL8day4w8Vg+jvMyVMeJJ1Wj5IgH
	 q+mzkpxs+DsAbJTUk/z5VnGLW96wAYM+0mZmOSwm/MeNN+oUnYiaIqon+EooQc9330d79
	 RHczT6Y9uO5VsEIEKOea1rreWtP6bvTm/znqN259YEVEIdpLHCGIYsGZad5GlwOpVP1aF
	 AsStq9fDtOlm3zJqJZHKcBX960xSkEsLzGJ97mMsmjUOls5cAfphdp0YfRoXQLD3Akg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=MFSOXianfxaj57yMPDU1y2qVIXC/Ket1cVe0mZA7fvM=;
	b=FkPlzGXayVXeUnMgQ8gePK1x0iHqHSZCSnUv5ZOAk4KPDfE009tGRQciys4FhdxVIX4j
	 acms7ul2nBAthF1U+ul0jBo6bLJCD2emNl6pW/rrg0jFFrVMtdWAMqlTNCHwaN0yJgmPQ
	 zi4BeQkhY/eE0KPltKsFrD9Wu1KJQvDmMFc2RDbHFq0vrDNZimES5Im48mWs4DCHtgZe+
	 dLzQy1Jqez4m1xxzMcw+zcVSRoFYtVzHV9L70m7riSyvhdX6DjY9JXejpBIisvXbFsWQB
	 0fr/5kJFEiBFLUg6LBdLCXSm2tH3Ql1cewN4DEwNa1N5H9ZeZTbSZ23/ya2BKTRr76w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=H9rbcrVh;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A7E606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 12:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79A7E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=H9rbcrVh
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-490d59c3edaso3883309f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 04:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795609618; x=1796214418; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MFSOXianfxaj57yMPDU1y2qVIXC/Ket1cVe0mZA7fvM=;
        b=H9rbcrVhQ0J8dzZVk2TXflcOeVCu4YE8apew2ZeuEOIy3gU899zjw3ITq0EoH6gI7z
         FedItxi3ISh9jZNs9W226S7FhioXuMOaueLnIpOCX9WtgMbFsRzFL+rTL7efzjJC+xO5
         2mWOBEdThcDSwuyggXWCaT0nVSaVDQaqO4c1nBmyCy3d5SL0hIiw//Q4NzY1q2OE0sU0
         eKYJNKEaZMNIqpiEXfSF7+hols5KsNEa7KyyyT6k7QrUC/kNIHMSeK9f4yleFprFEeVq
         dp4KXu98xHlckJx4v5p42LzuaG+bEdbSh7Q61CyZ9B54H2+ZRH3NVmIUnqw703v4QrVb
         P3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795609618; x=1796214418;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=MFSOXianfxaj57yMPDU1y2qVIXC/Ket1cVe0mZA7fvM=;
        b=e4410D3JHJ9gfQQczT8e9gL5aC5rkXXf7dz6eXSJrqSVsdn4OMpQJmXlugwmwvC1hG
         ylwSpSBtAskNFYmL1zfZK3y4BFXQIukdut4VsrtpEsypsPs2P4BK6UPaaZrtlDQpUM7W
         G10Qfzwqw7TP1O+ipmJY4AxgiLWBVyw2gwmL/TPG3s7RCHacLyr88aqWyihJ4b/aoOSp
         b3ppNQi/ZbXcd4ZlRLv52Nk8lj8k9AhGVxx+9r/lDWapGr1Zj1RgYTELDCQgq4w5a4ry
         T3+VMsmaNUV6RUlv2Hn4A3hROnccUYmwVKjVk4Wv/jy6zF2yyh9vAyFY4m9RkLg2aBN/
         rCuw==
X-Forwarded-Encrypted: i=1; AL+hErHpFSyC76SjN0H9/+6qRlU3WKiICOzqbSCp5ZM+MfOZOs3sxYhulzfT5289QuJSaLM9PGBl+0I=@lists.linux.dev
X-Gm-Message-State: APuU4Z+ej5cEr6rohv77VGzfeITS++/ONZ3okunEi3cZimfKAmuEt6Xt
	pZ8PjIVqIUvkYhCIoAdYLYNSk8TZBZoathyFvzDlIi3OnMt1jyrlxX69ZsW8fAGybSc=
X-Gm-Gg: AZFdTZfC/VX5Alu8UviEuxyJI8BGLB4nZKcQKbzsrTiV6e11N/oCU/l3AuaROlbcXgv
	4hujJB69p5AUJQ8XFjbcMPcPgzHLxDY6MigeufAyWqp5HyVIK0nB4cF5TPF1r8uBfJqYBd9sLjX
	CHtsPIK0KVLbG1idu+1rWplyYyfEBvV0AdXHRE1VwaqOZ1SI1BVGjtgQPzXDOlcmSzQZV3cwXUp
	/fD4ACfxjnaIRvjIo6unymSgas8Og49Eog8a84NCeNE5UkfaS+OtJjyUae3OPukdNtcezSgaPPg
	iWD1jBPIJ20rg4nOPOorf9qNNViQpNjXQHkNRJalxyGSpI3aBxJBaZeCb+5trB94C8NZwOywD7F
	xjSxQelEkPtmS0rbKkd24ArBTcNeisjeTT7qTZzayd3u+89jhjQlmVFmJPzEatYECooIotaC0xD
	Ic4aAWA7aIoslKZ5jg451d8n8j+05Ens1IOmMYd5O7pToErhYHYiybfkLWwKpJvTO3iwMNd1xfY
	vfT8DuQCPVrHADK2jq4+ZAl7+F6txarKV+Hda5K1iln3bDXIVZTZkvEzYzycyMYShmNLetfeuxD
	Ot3/DevTSu5bSeDF0Fk=
X-Received: by 2002:a05:6000:455c:b0:4b2:1d92:211b with SMTP id ffacd0b85a97d-4b21d922811mr12250324f8f.17.1795609617689;
        Wed, 25 Nov 2026 04:26:57 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb4341sm34272184f8f.4.2026.11.25.04.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:26:57 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 15:26:47 +0300
Subject: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WMywrCQAxFf6VkbcAMVYq/Ii7mkdoInSmJFaH03
 53RpctzH2cDYxU2uHQbKL/EpOQKdOggTj7fGSVVBnd0ZyJ3wrrXopi0LDjPUpDC2LuUhqGnCPW
 2KI/y/iqvtx/bGh4cn83TFsEbY1Cf49SiP2PrYd8/9QctN5wAAAA=
X-Change-ID: 20261125-serror-drop-mmio-1bf42dd8841c
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>
X-Mailer: b4 0.16.0

Oliver's commit bfb7a30b1986 ("KVM: arm64: Don't retire MMIO instruction
w/ pending (emulated) SError") established the rule that when userspace
injects an SError that we drop the MMIO.  An MMIO access dropped this way
runs again when the guest returns from the SError.

However, since commit 3bd107ed6b23 ("KVM: arm64: Only emulate an SError's
entry for vCPUs with NV"), a vcpu without EL2 pends the SError through
HCR_EL2.VSE instead.  The next KVM_RUN completes the access, and then
the guest takes the SError.  So the behavior is not consistent depending
on whether the vcpu has EL2 (MMIO dropped) or not (MMIO completes).

To make things consistent, drop the pending MMIO access in the non-EL2
case as well.

This change only affects unmasked SErrors, if they are masked the MMIO
always completes.  Protected vcpus are left alone, because the host's
copy of their PSTATE can't be trusted.

I discovered this inconsistency while writing a selftest and I don't
believe real life users have noticed it.

Fixes: 3bd107ed6b23 ("KVM: arm64: Only emulate an SError's entry for vCPUs with NV")
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
I think this patch is correct but it's also easy enough to modify my
selftest to accept the current behavior.
---
 arch/arm64/kvm/inject_fault.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 1d5dfd4b9e00..91b835bc939b 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -396,6 +396,14 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 		return 1;
 	}
 
+	/*
+	 * Like the emulated entry above, an unmasked SError cancels the MMIO
+	 * access the vcpu exited on.  The host's copy of a protected vcpu's
+	 * PSTATE is stale so checking serror_is_masked() doesn't make sense.
+	 */
+	if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu))
+		vcpu->mmio_needed = false;
+
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
 	*vcpu_hcr(vcpu) |= HCR_EL2_VSE;
 	return 1;

---
base-commit: 4a1b7259e337e8a2ea999436b47151a75c7572dc
change-id: 20261125-serror-drop-mmio-1bf42dd8841c

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

