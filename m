Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394931;
	b=4IwF2tfWj2Y1EeUhFZ/e0n5BZpHJ92c7XNZNkQp5dEhJUj/w6vJw5RaRJzHPiGbKlwBo
	 b/+6pwqRGAx5v4SvaY45rT+7JkviRAeVl6xs3Ka5uR497ltEGxlTqjoywXSvxLus17pOv
	 6jjOGBd7si0r91IKXymYQuMXcq97IBuZirY9I0XmsksqK0JK2ZCETtD7bSkeFpjpBtgUb
	 lJvMRCHE+8KjhJeyewImrxL40612rYVev3zmn5s4Wzi7RqmtKqjsHL7PDEI1zOx8vmSJv
	 njUaCJ7YvW+vZC/jMsOAuMLSu09fk0dc9gGw4vEvXkmPuSvxAshcwjXYb2kqZX/ZiDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394931;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Mailer;
	bh=vx06wP7sOtawrWt780eGmmqhNLqmiCDx1ykk7VKYMck=;
	b=xQd5kBVOfnnxauPg3Hjv/fGuR3V0zx3yk842RlCzQa/U4i8EN3eN2c3Zdsz/TnltW5jO
	 a5NpMqttdypJBlpVOl9ipR54LCnuluS8h5pgkm9kH2DQZ9BnAI1HYYuIv3Nb1D7C/M8RA
	 lT5AYhPAodHMCcp8+sAR/yQKWxXYuhQdp/jVHqTzvu6uRM21Wb4ysogvlSak0Zro1scSW
	 WItg+puEA/hMQfjmixBbcmMreBQOyXGGScUqyO2VVnC0ZWM5pUz603ShK4UjOTFnJnpTd
	 buV9NVqkc66tVl0drET8LTrHWXtbBz+S+Vw8rAumsRmriOWBjCt8AhLRPSEPPoLMmUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3107606A31C
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 11:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3107606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so26556615e9.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 03:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794394929; x=1794999729;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vx06wP7sOtawrWt780eGmmqhNLqmiCDx1ykk7VKYMck=;
        b=BLBgZPVPDxHcRNLkVdx503JEnOQr1TYlglHCGtyEUZaxCNZwl7qs3p4mnjdp07Bjsc
         Qcm+pEM2KYmrScy8SrlamwvY3crOlha3/+yEig/K+/EQdBiTmAveOdWS1dg12j+8/Qap
         qxot6r2eJ371j6z+O3m7qUlHY4nW3dLvbutUhM99EwS3vllSdmTY/Qdd8ApNNUUwbjGr
         RzDW9jiIjiiqvDL3LBMMxYtvikoWrWhaqXu647Oq1qBNSfXPU1qdE817LkahpmuS3lax
         i5fo+EqNCfAH6gyWvf1P4AX3qHLHzo14vegENmWiEoo0jQx7Aukq92R+lDarkBRXMN/Z
         3FvA==
X-Forwarded-Encrypted: i=1; AL+hErFx3PEbOgOcY/0yr6vo5yh0hqhbphpcW6PVp5tnHX7Z82dIBpSYhrwMeHwh/fVOCQQYTQYmeRs=@lists.linux.dev
X-Gm-Message-State: APuU4Z++A52goEU60UqCkS7AoF14WxSQMiononuGX5kGcPCDIxUm2RIu
	6Ku1Ud+ujH2hAw5JqVCp3bRKwowelubDdgTumkADiZbwB5uT5Q4g5lvK
X-Gm-Gg: AYBFou3SSAEKMy29pWh5SrCb1iPeeLgCIM7OsxiZLEflsNdbisRq1HTNONjj4Ooo7uV
	6pmLw72kNOjEQMaFyOVpBB9o8w9oEVKDGVydb1RpCDQKz66jYshp8aaHoX5Ct81hj5d4HO30OW6
	7cypUxktXB6Og6hC9t8+SXrf5HuNb4c0O1Y7vi87BwUivWFcZUnS2/sXTSdEFz03QqwJsTFo559
	hLnnHIniEjQ2pBYIBG8JvSaHYW+h8svyqzpaafLKip2R2FrR5C+SoTw2udK0aYI+xvjmMhooCwh
	gpNbltyJkpk6Ree+9RN6Xw1N26rjVgRsgkI8fTtki/fWtZfZOUhKniCLsvkmwx2UBOb1eJA3wEF
	XR9s+WTCJWClUEmw/HsLQmS9zxO1UT0Kxwj94W34NB+hQpBfHeJHAQE7zENzqqoG5fw21l6PkWJ
	ja0zlczUlZlVtz1OOf5LKaWy7ivhu7naWsi9HR7OPqpZIbu/XFEuhr0eLCGjypKvKZB9ptUliXN
	Tgd4xpMgzUGIrjRgPosKMc21ZX01qXbWlCYCjaoS+/OpPb6QhcyL5voxp8QJLsdL1vAZMd4Uh8Q
	KIqo77Ypad4zfTDnHR2TnaALKNtEn2qK5bgJVhb01waOZCGNmyJoShunIrPOqCf3X09NzoQlrA4
	u77uXpcf4emC2jOIDMhH/NLt3HovlIQmGzhVNsfeB02Xi9MZh9XOUNzu63Vjiog9EFyZ4YR6vIp
	Dv7X7rzN17dg==
X-Received: by 2002:a05:600c:a00d:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4ba093acadfmr38447905e9.34.1794394929145;
        Wed, 11 Nov 2026 03:02:09 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba08ddbe68sm85849165e9.0.2026.11.11.03.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:02:08 -0800 (PST)
Date: Wed, 11 Nov 2026 14:02:04 +0300
From: Dan Carpenter <dan@cryspen.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Christoffer Dall <cdall@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH v2] KVM: arm64: vgic: Don't truncate offsets in
 vgic_find_mmio_region()
Message-ID: <avRLLMOiudnKoSlk@stanley.mountain>
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
X-Mailer: git-send-email haha only kidding

In vgic_its_has_attr_regs() and vgic_its_attr_regs_access() we take a
u64 "offset" from the user and pass it to vgic_find_mmio_region() to
find the correct region.  The problem is that vgic_find_mmio_region()
truncates the "offset" to 32 bits so we might find a region even
though really we shouldn't.

Later the untruncated offset is used to calculate "addr".

	addr = its->vgic_its_base + offset;

For example, an offset of 0x100000084 finds the 64-bit GITS_CBASER
register at 0x80, and the write reaches update_64bit_reg() with an
offset of 4 into the register and a length of 8.  It exhibits as a
UBSAN warning.

[  183.796046] UBSAN: shift-out-of-bounds in arch/arm64/kvm/vgic/vgic-mmio-v3.c:35:10
[  183.796198] shift exponent 18446744073709551584 is too large for 64-bit type 'long long unsigned int'

The GICv5 IRS code has the same problem in vgic_v5_has_attr_regs() and
vgic_v5_irs_attr_regs_access().

Make vgic_find_mmio_region() and match_region() take the offset as a
u64, so an offset of 2^32 or more no longer matches any region.  The
other callers only pass offsets which fit in 32 bits so they are not
affected.

Fortunately the effect of this bug is very minor.  The worst case is that
the VMM accesses an emulated register and sets something nonsensical
and users are already allowed to do that without the bug.

Fixes: 8331c23c28e8 ("KVM: arm64: vgic-its: Implement vgic_its_has_attr_regs and attr_regs_access")
Fixes: 71091136d145 ("KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region")
Signed-off-by: Dan Carpenter <dan@cryspen.com>
---
v2: Change vgic_find_mmio_region() to take a u64 instead of rejecting
    large offsets in the ITS callers, as Marc suggested.  This also
    fixes the GICv5 IRS code which my previous patch didn't.  Drop the
    Cc: stable.

 arch/arm64/kvm/vgic/vgic-mmio.c | 4 ++--
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index fddb9da0403d..59bdec495cd7 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -820,7 +820,7 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 
 static int match_region(const void *key, const void *elt)
 {
-	const unsigned int offset = (unsigned long)key;
+	const u64 offset = (unsigned long)key;
 	const struct vgic_register_region *region = elt;
 
 	if (offset < region->reg_offset)
@@ -834,7 +834,7 @@ static int match_region(const void *key, const void *elt)
 
 const struct vgic_register_region *
 vgic_find_mmio_region(const struct vgic_register_region *regions,
-		      int nr_regions, unsigned int offset)
+		      int nr_regions, u64 offset)
 {
 	return bsearch((void *)(uintptr_t)offset, regions, nr_regions,
 		       sizeof(regions[0]), match_region);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 38ed730d68ac..6c3c4de6883e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -228,6 +228,6 @@ u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 /* Find the proper register handler entry given a certain address offset */
 const struct vgic_register_region *
 vgic_find_mmio_region(const struct vgic_register_region *regions,
-		      int nr_regions, unsigned int offset);
+		      int nr_regions, u64 offset);
 
 #endif
-- 
2.53.0

