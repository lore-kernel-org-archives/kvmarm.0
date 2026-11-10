Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287249;
	b=gAInkI43ibMJnXpIDG4Ul45VH2VobsgPbyMGjqyrHTZwbarX/vdhGstvv6SUX/cQmNWF
	 kIJfGLXUU3PgnMYjAFDR17mhHEbSpYNaqomhlMypTYIKZiqZ9uG7O4SNu0P3S/s3IKxyP
	 z9ioOu1hCXqMuJosurMfv50jHofJFcxKAKT5RKnJZzYGewTeAQ2gIvO79DsY0H1E7bc4x
	 h5kwtQYBD2Z/2R2NEIkHOQmby4NcIppO9IVsLXVrCWNcWBFjsCOSTGR+dUiDA+CILv0iz
	 mnRf/K9y86898uZVyr78KV9hRM5lhbxNQ7K2kLkO2gQkeWTvxWaCcc3jyX2deELjV8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287249;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=BC5Q69ueJVBYfSsdQ2qZHA2Rh61G6UD4sUcf6Ljc8BU=;
	b=4xlpvlYpF8puTZr5a6BkBjc2+ynjDvA+GGxOkgKaHAe4POJIcy4kblrRaBn/f2oPrLAq
	 eujHfv/rARm014Rgiv/SNcFA1w7ERWwu7y6RQ9Lwbl9xWW3exxDCYmnlzGq7XQ2i2OCkW
	 kOcGpan9lznFOaqz5sUek10hc597MkzIw0wNv/gcWopsoHP+hCaMfv8Sejr7AggWfKBaA
	 HWj/aFqvif8Ok+h7i6AUAVwv1y8nS43rmE5YIbRpdRLDVrP1uCTIem2Ld6gZvkeC4e9fT
	 mtJmTxM+P0ZHuY+1kwsvo7L2i8xgZDN979DoAipyG4yI9tdgK8V6WbZ5of145M5VbZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98796606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:07:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98796606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b4571ff080so19036805e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:07:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794287247; x=1794892047;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BC5Q69ueJVBYfSsdQ2qZHA2Rh61G6UD4sUcf6Ljc8BU=;
        b=wvLOphjCSNv0x4tqeqd7LFShBuSyAEaMVfbFtHgzN1cQPEefVApXBRHlqX4/DpDeev
         /og2zuNlkSp7+28TNy8i+EUs2gnFFsko6wzpmwI0bPXah7X3UsmOUzDb7VJA3pY4s7YG
         pX0r8ep406b93tIzFoy2wgkX6mO8EwG4qlFnlt/y0uhX3whXtHC3T+dpOXyAbC6bH1qM
         vGz4cvTJRtY77N9CGw3YNIQkUxhC8gDRqVAE3gTbFU3rrl7K7LpG5IMZvfVMO/jPG4ox
         AX62PkzXc9luMGeEpqhCLP725vI/E0ZYGnQcNDeGG1vgYFmSpXIWlyzCC0K0mc1WjKTB
         lvrQ==
X-Forwarded-Encrypted: i=1; AL+hErHyjeftPx8oKjW2u56ONYbXsbSKmpuZ6ThtQhXMm1jb68D36E+yjbvgSsQ0cER0y+t3wVbbwOo=@lists.linux.dev
X-Gm-Message-State: APuU4Z/IyDQKjvndaSAQnvKfgHiSxpMc3zynkaYJBUqkGUw4YYTqsU/9
	jD4+QZJLbc3yAmsYR0Ea1d6YY/hVkwA0dgg+8vCdeGebSF9ClBWbUNgs
X-Gm-Gg: AYBFou25Qp0SKQo8aKRkoMTWsnEn6Sm4Xj5vKl/dYUXEjpgx3A2EYOyWmv+Cg5gLJpJ
	/KTNYdvf4oSJabXoY4AIuZxqYSIzkNUdzIRxhQ/x3Q1G52wYzdHeq1qmfD/w5JCClKu3qrcYBvC
	EZpEFKboL+VIKkU4f7VvWh2n6+9hO68N6UmjCPmO/cB+1D/polyDqoTPZeE04HPv/1ANHgdT6sY
	CP8qGWJuhYCqxlBtx+3S+stkphCGhD76WaotoWfaQZnKqs1lelgBmnq7RWz0EeqfeChBU84hl8q
	+tHqsKycGm8uj/ia7hT9SYoXwxe2UwSqn5Pvg10+pEIW93pRcVfcpAjwXTKqyihtC0imugjpXTm
	o5tQXqfGxFphPsF1LJasbRIud1OKL0kyQZsy3Z+sc4UPcm/49SvDzCkMOHi7+PHjhtWRqmGumFa
	VGiDTgG8B+f0JJk9HUX5adrwWYkUT9RiqlgbzZzFYRwYz31Wg3tjuix1LeC8Z+p/hJ1ygYobzRl
	to5q1n/AOelmt5WwNnb8xSY0aM6Vwv1VLfazuWfxK+XR3a4Vw9+zQZWgAkFaXRQwIqdmFYIPcl+
	DuXHSXyCmyPQSYywWtTgGrZnukGvP+XJceS1WjzER08opeKjJLYKXJPB+SSRc5CYrB1HWcQcPPY
	wj7FZQxYwYIakiDRsmqxnX0n4TiIV9SE2v7cbQEFKjO7q+GPemZbWFpX1kVzyXQIC
X-Received: by 2002:a05:600c:1914:b0:4a3:2f35:38b4 with SMTP id 5b1f17b1804b1-4ba0233797dmr18691015e9.10.1794287246749;
        Mon, 09 Nov 2026 21:07:26 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba022fe1absm26105625e9.0.2026.11.09.21.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:07:26 -0800 (PST)
Date: Tue, 10 Nov 2026 08:07:22 +0300
From: Dan Carpenter <dan@cryspen.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Christoffer Dall <cdall@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH] KVM: arm64: vgic-its: Reject ITS_REGS offsets above U32_MAX
Message-ID: <f4b5c3247f88b9c469758f8e14a386364332f9f4.1794251681.git.dan@cryspen.com>
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

The "offset" variable is a u64 that the user controls through the
KVM_SET_DEVICE_ATTR, KVM_GET_DEVICE_ATTR and KVM_HAS_DEVICE_ATTR
ioctls.  The problem is vgic_find_mmio_region() truncates the u64 to a
u32, so it could return a valid region instead of failing.  Then we
use the original incorrect value of "offset" to calculate "addr".

	addr = its->vgic_its_base + offset;

The impact of this bug is relatively minor.  A user in the kvm group
could potentially crash the VMM which they can already do without using
a bug.

Fixes: 8331c23c28e8 ("KVM: arm64: vgic-its: Implement vgic_its_has_attr_regs and attr_regs_access")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@cryspen.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5ce485485a11..532a82bed24c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2018,6 +2018,9 @@ static int vgic_its_has_attr_regs(struct kvm_device *dev,
 	gpa_t offset = attr->attr;
 	int align;
 
+	if (offset > U32_MAX)
+		return -ENXIO;
+
 	align = (offset < GITS_TYPER) || (offset >= GITS_PIDR4) ? 0x3 : 0x7;
 
 	if (offset & align)
@@ -2045,6 +2048,9 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	its = dev->private;
 	offset = attr->attr;
 
+	if (offset > U32_MAX)
+		return -ENXIO;
+
 	/*
 	 * Although the spec supports upper/lower 32-bit accesses to
 	 * 64-bit ITS registers, the userspace ABI requires 64-bit
-- 
2.53.0

