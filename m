Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801192;
	b=sJ5lyRG4Vrj7cW1okw8ogAIZ1jM+/wyHKbXFBCoQTHpuStSrtdX+YBCRNKVtg3tpD7/f
	 +Ml2x2BZYJ8V6ia5rJIyLNvyw6yM9aqefBwWWOWSuAxpIs/BoaYqGjxokc78IDN1Ggt8Q
	 YNApuT9gcrpjROg6JF54HEd5soYubclhTJqrF8Bx8jCjNePUvQB44B3vhEmPN/4yUyd/N
	 2S482zUV1K1C1dKBLLmj8uU8I4+00p89QcvpAuJhayFszCYGGEXHe+JKMqP/yFjEKxc1p
	 BA2WCgq+MbzzkaIEv1i7/xZGrhyiw8oySY9lS0X1YDVJVchNQ3vGAfoX82Sg7vJ+rrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=MWbafvzSXIS+FuKJGheLyccmpIuKpJRwMov0QQ6M3pU=;
	b=qCSRgoSYva7xKT0k5NVfM5y3bD5Z2N6GPsG3Ax2w0qb+eDoBiks1oh2rcSPTMTwl1rFD
	 EiCkJM9dILK1XAy1+E/03j5CElCn/6qwwoqY3rD6X8WLcFVZk/jL41+0Eu5zpXarP2Qxn
	 bPkmtfhMTEPrOQVmjjlCANc1j9chivar8zZrBkK1/y4mjkqn8mH2NphhP7tqXJykizwcj
	 5ujk+BwSEquEnqfY7b9iMDRY6yf1YbNxVi/LnZdF8FlPWZJbAxhhPZcEzEphJWesIlKm9
	 VDBJP13YzKvUKpoCTv+Yymr0RAJVny2NMGVTR5cgs0v5mOyZJ2go2CXtyN+CzEvCJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MV1VqCOM;
	arc=none smtp.remote-ip=209.85.208.72
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB991606A336
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB991606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MV1VqCOM
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1d43907c2so948870a12.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801190; x=1794405990; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MWbafvzSXIS+FuKJGheLyccmpIuKpJRwMov0QQ6M3pU=;
        b=MV1VqCOMSm0Zm0Ki5ieOiufXqI2k0dDw4FqfTkshxo1FddQPyavImEKzzxyAeWTAoa
         VU76CL2reErAS+GEgdf/xq2bzNAHNgoNT6SCc+z3cjVugxG8hDjsxfZ9dpKOuSvhrU9T
         gZHGemMcHTZ+Me39riWMm4do3VR+W+SxLMCjMdNruv+i2GKk9v9XYs2kyNe83+8g9MLZ
         dKgCTR/Y7Hw2CPFScPAwK7puEt3ZAPfk6T5rht3DrpIDDaHD74z7Q6ydtU7VR76edbFu
         vbJr02JRnhwW3ekZdfrGjNHe3VzD/34KIx9PqyWI4I7JOnRAoRL//08wtls+0BT+hoFg
         hYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801190; x=1794405990;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MWbafvzSXIS+FuKJGheLyccmpIuKpJRwMov0QQ6M3pU=;
        b=nebkirBPp454KM1zx7klJ8uTRdjFsLn5GdkHA0LxPyaBxw2mNjuO9AnCapYUitVM8f
         BwBFY9NT6cXWICiZkTOCNCRiidjgLfXFSKHjG+HTmYI9bZ4SOlxHmXkp6bxVWzhXnQik
         a3e1Qq8u+QlCqvJqGuENLfNOEHguhRsKfeJBwLRMr61qHL7VpHz1JEsCeuj6pbm3sw4T
         KnCPM0t0wESY7FGpjWPH1HAd9Wjwqk2ez2MYSq7VvkbFiMcCmLhGiAcZK+2O+pLsH3KU
         q1h39TOA32t6IMUSRQxE0CGLCnCRDaF/k5+3hZhUF/g5zikruJGW+qnVrFoBaUCwXZXw
         yUAQ==
X-Forwarded-Encrypted: i=1; AKwUvBxoW/xlBTaQF650FIPCtv7WTm4CW3YfGQ3tNB6112h6mNGCh+AsGg7ml+BG/X8sOtMULCbHgc8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9FCcsdj87Ys5tQgtX4eOHYGsQGENNnBbg5LOBASzquP+9/nTjZ
	LHm1u2VWsf+lECnp/FLLvlOS9BfKM6+XbFKISmXZTmcu/hTEWrvA4wjlHCYWHJTMyfWQ8GEpMH+
	CqteWHlwBuKspzlAAUGLD7Q==
X-Received: from edbin4.prod.google.com ([2002:a05:6402:2084:b0:6b4:5df5:42f3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2346:b0:6ac:686f:91db with SMTP id 4fb4d7f45d1cf-6b4f7d3cdfdmr9122001a12.11.1793801189924;
 Wed, 04 Nov 2026 06:06:29 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:12 +0000
In-Reply-To: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104140612.137869-6-vdonnefort@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: Add host_hvc hyp event
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In a similar fashion to the guest_hvc hypervisor event, log hypervisor
handled host HVCs with their return values, stored in x1.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 63d98dd92cb0..9a240fa410ca 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -66,6 +66,19 @@ HYP_EVENT(selftest,
 	RE_PRINTK("id=%llu", __entry->id)
 );
 
+HYP_EVENT(host_hvc,
+	HE_PROTO(u32 id, u64 x1),
+	HE_STRUCT(
+		he_field(u32, id)
+		he_field(u64, x1)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+		__entry->x1 = x1;
+	),
+	HE_PRINTK("id=0x%x x1=0x%llx", __entry->id, __entry->x1)
+);
+
 HYP_EVENT(guest_hvc,
 	HE_PROTO(u32 id, u64 x0),
 	HE_STRUCT(
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 28e0191e443f..1113cd828bd5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1642,6 +1642,8 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
 	hfn(host_ctxt);
 
+	trace_host_hvc(KVM_HOST_SMCCC_ID(id), cpu_reg(host_ctxt, 1));
+
 	return;
 inval:
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
-- 
2.56.0.455.g6c5a503b38-goog

