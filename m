Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015807;
	b=kElJg1/si5YuubFBDrRgJ1B/lFBn9BBXW7SOvQSnu47zOnHktceipA6mv0L7sC7CgvvK
	 X4bGzRtrl3MrVwdzWpMSdKFzDd52mBhTQWppiZ5h8RAXI+TnXGV3K19bOwyLaziCCBtGs
	 pQTEGq1M30GCXgQYaRP74DejP7TuvPFmyi7NyljSBc+tS45h82IijobBKDV1m5LeHLO9b
	 io8geRO4n+cBV7tljh4J1/mtMeukasn3hzVKGilrK9U0ITvIkMhKdgzwDjf2vHQL1shOO
	 mb4IMokwl82BePbig6BU3p6VwCZBXOCu6Jd2LyvM82oL4Vt4hfHJxh5iXxLI5WXyEVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015807;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=EYl3x4KFTe1dpc4bktfuekDHeh02aSOmfJOAZ9DaLew=;
	b=mfd4hJdNW2xt4QyF3XZKKqndXmV8vwM2ejLsaNScNVSPJVsHyvXyVFBhM8WieJ1qT81T
	 i7y1low4kW8/Bcl+y+TEuXpy2nvxKS7S/QSmtnQV4d+Y5ch8F0Ckj7vXXAri576Qh/HE/
	 WepZEJFBRCEQ0yUESFofKRjbs8oc1PtyuGdBoy4RpAgl0ltcCbnFkX6wzXDZT1K+InkE3
	 RXoEQDmPfF4ol1Yxxf+ETIgfMSR0hZ/82st5E9mrSIpydsWz2Q9Dbmj/5pBEa9RzuSFn+
	 t3v2018DE+VJz2xizjYIsSrCYxhKhzgeznf0Yjq8epC8WuXDL/jRYYxTXvJ6IwplYRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ekRo7W8A;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1AD60A2600
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B1AD60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ekRo7W8A
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so8566885e9.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 07:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795015806; x=1795620606; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EYl3x4KFTe1dpc4bktfuekDHeh02aSOmfJOAZ9DaLew=;
        b=ekRo7W8Al2867ityEIUU30BesEuEoaNJnM+WkcmcKXtBUJhEHNnjPSDExnJgEpnmhr
         iky0yf+OH47WreFO0oC+9e7UbgzQIXQDyOEcJydqWSpovY737EHukQ09bNmFgxiw/ID3
         ypILCGey5VcHZMf0TcXeExjeCPteXVKGONcUjKfvKXG7YwL+NxvWH+TIcWhTFbO5tQNL
         H3ZWZJ99uBjQPZGpF3PSh6qx7ZZcvdMTtIRngrzlZPXbjP7HMGKvXRdW7mXS3jXaJcFG
         3FKiVuhxNwq1d7LGLfySqm9wQiekqfrTYWG+KNuwIpFtZ8GpBIXX2NRmB62wiVRU1WuC
         +XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015806; x=1795620606;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYl3x4KFTe1dpc4bktfuekDHeh02aSOmfJOAZ9DaLew=;
        b=MmF7GZer9pLBPPnHwMCAeLtuptQiFTfX7vIX6QqberCWKt9ef+hXVqsDDEvYKQ6tG7
         d5jd6FDghuy+xxzMLD9l/tNiwvDSbVDaY8Ey/lgpAjuho7X8Z/qzk/tth/N8z8aE0b1M
         lieh64CnjDT4ecyVLlsD3Isl1YxegqxNz3B9k1fuAC9RKfE0aZWBcFXlbmL/kDL1BZRn
         ihejFEpFbY4Lhqur2qHnVK3eeHdta4q5cldIPcgVGjjyXYQ6tHrpjktJMMGwVZrZxn8a
         4wlRRRzs7EwRoHAx1Jp/qk5GXoAnnXfWu5gcZimykgPG1bEMhmH8QdnOixwA0YtiW/5w
         8MYQ==
X-Forwarded-Encrypted: i=1; AL+hErHMc2ns88Nmi7UCFtmneDu4RELrlJoTWNV0VLd/oAPmLmwtMH6owXKk7L3NQY8Mzft/8sVy+RY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/yEq5MSwAUTSduzP7vDIth2T9CK+x8WaFKSNSzHp/pl2loa5Kh
	1mB5N3vohtd0OKEWLcAsIShD7uufbaerIPq2NYlFcgMq4RXFcLd7jCZOyiUnUxlmaJc=
X-Gm-Gg: AYBFou2EPfyZHam46OONIfgPsAxdvpmoELmcLJgflQvMYk2OEx9/vn5fLRfLNAgq7LO
	MFpIBCf4+c7PwSWpRN8OyD4OpOOA6iHwOHykvI4LGFqVnW2daAeMavvjMzbCpnslZKt4/42Aplp
	VyaLVBqZw/gBI2wgiv2nPOBLiPJJn7/07tVzaAX87ehmk+JCb8Vz7gn24tKehaUmdXbPMEGG1Jx
	tclfUuRTtE43JGm/DETpBjEdPlbmah9PZnsfCmbxsL/Wemy+po+t/YuJB17sbHf3W2EbcrwaHjr
	jqJdQJudZNT2o3GZliRF+5PTwDy4geOsgTKB3IQVsLHs+hqG2G7QzFL9FcL3spe1TeNNLqJFnMo
	y5sDtIWPYJj/kJPqJsXZ3GhM77PMShUfXxqE9lOG8JVb0LLuXOyBJsFIckjXOoh8lwXs4mlH/Lg
	M3CQTPcMC1uLLps38B6yjg0S8iU4iIeFShpdppozqY12q58m/o2MOwbwXIC3RSx1A16XvdxELU0
	0HaX44qVLp4Vy9S/6FxIpOyM7A1K4NHiO/fmyTrd0TyLGqteRfkweZwgWN2FfC4Z1flhZ+kfYgT
	RAt2XY8fVsojyv8MVEkN
X-Received: by 2002:a05:600c:3556:b0:4bb:6519:477e with SMTP id 5b1f17b1804b1-4bb7da24a4dmr59631565e9.17.1795015805629;
        Wed, 18 Nov 2026 07:30:05 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783f7eecsm275894275e9.3.2026.11.18.07.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:30:05 -0800 (PST)
Date: Wed, 18 Nov 2026 18:30:02 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 2/3] KVM: arm64: nv: Forward CNTP_TVAL_EL02 and
 CNTV_TVAL_EL02 traps
Message-ID: <80eb37d600ee6fa51f4c5fb478a31e8f0be180ef.1795014776.git.dan@pereq.eu>
References: <cover.1795014776.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795014776.git.dan@pereq.eu>

There are a couple timer related entries messing in the nested
virtualization traps.

With nested virtualization you can run a hypervisor in L1 and then you
can run another hypervisor under that one in L2 and a guest under that
in L3.  Without these then if L2 tries to read or write L3's timers it
instead reads and writes to its own timers.

Fixes: c271269e3570 ("KVM: arm64: nv: Add trap routing for CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/emulate-nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index bf4b8a44b9c4..9e0c15e6be47 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -942,8 +942,10 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 		      sys_reg(3, 5, 14, 1, 0), CGT_HCR_NV),
 	SR_TRAP(SYS_CNTP_CTL_EL02,	CGT_CNTHCTL_EL1NVPCT),
 	SR_TRAP(SYS_CNTP_CVAL_EL02,	CGT_CNTHCTL_EL1NVPCT),
+	SR_TRAP(SYS_CNTP_TVAL_EL02,	CGT_HCR_NV),
 	SR_TRAP(SYS_CNTV_CTL_EL02,	CGT_CNTHCTL_EL1NVVCT),
 	SR_TRAP(SYS_CNTV_CVAL_EL02,	CGT_CNTHCTL_EL1NVVCT),
+	SR_TRAP(SYS_CNTV_TVAL_EL02,	CGT_HCR_NV),
 	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),
-- 
2.53.0

