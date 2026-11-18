Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016139;
	b=yTeRdqetag0jz/GMswmssB+9Qc6FdILDqxjeHQ1H/Qibz9Pzbuug71TOwyRcz/vvM9GH
	 /nf7Yt410pAwA57c5YogV06p0KwpN+G5XAVawpk9HKJxF7RGmFcUsbJZibNituG8GbjsN
	 gjSdBJ9roPK16xJuz+ShX/KQzuHyCyjU4uVXfvqWZHkplioLkPnQHalMiPmzNDujM7cc2
	 KaiOwvDkoiX4nJ+OzHO3ggwwSP9I0YZSLJuocIOWyR5t4C6huBuU74kTpvCn46PA2Vwbm
	 QNMHqrwq5X4V46KQC5rctOwqA/N/RDrW/dcrIFsuN3i4Zes6zfwh9+YE6EjYVODAw9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016139;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:X-Mailer;
	bh=I38LaCNb2hWbpAi7aqstQLKMG4G4TLfyKK4eAQEVhf4=;
	b=ZSLWfWTZ6Qf6CM/y/3KedmVdSuYF4T4DKAbJXXRISrD/iGXJmtbOc1l3m1Hde2YfkNXe
	 CJ54iWL1fuCRBTsZnq8q61JeILVWE8CYzRVELPMP/zvghEr3k3aomk/SW/eiLAGaCXZtX
	 fEjGmrwa/OwAri9/XV2yTKA18ldpblwkoW5jquO8oTGMRKHh+GvNf9yd0HDM6m84ZvKta
	 Pc1efNEBzMTxBFwJTOitv4hqVRAG6eLp6n9rAvsSIn0TnorI14zkPPnt+pJXhSiNrUbyN
	 e3S0PutRYwqW/N8IN46SnPlE0YGoqJHoW3P6j4E93v+ijDkTUfGunJTbdbodRXjZ/fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EsUaqfWr;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFDE606A330
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CFDE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EsUaqfWr
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e10a70540so678556f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 07:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795016136; x=1795620936; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I38LaCNb2hWbpAi7aqstQLKMG4G4TLfyKK4eAQEVhf4=;
        b=EsUaqfWrAQlqe1qPm8nPbAvjk5UqfvTjzMXeHPlE06XoczKcBsDpRQNMhKi6aICaHB
         I1eyqe/EAx+nHmYPab0Ws/hZJrKRS5Jj7/1SlG3eO6y+oU2MnsgcbAl4OLmqe+n+AwuJ
         wDytVTj++3L7XqtCmsy4eKKCft9RLPkuhBueQr1P5k69mA8F4t3X0clMNfjxtlpO75RG
         V/WsTW7BonvBOizZ1wZ3PAwY7mFCh1jDlaiKyHE2LhK66pTO0VGPLD4sC4gS2Mt6LdDg
         b0zcY5kNn5FGrr5U685qtmwyEypjzDZocmgbwmGpSsYfPJVsoaQyuynKjQebT6uM+A/8
         ikDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795016136; x=1795620936;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I38LaCNb2hWbpAi7aqstQLKMG4G4TLfyKK4eAQEVhf4=;
        b=mOVwiEqT1v+ii98L/osxmk0DHm+IbbNIDupU8Knh1oPJZkUR6zwyX95xIhs5k1mb+P
         oARYMfwGpzd70YDS06LUVpeGZRqZaf7vkVrX93GMCzZE+I48muLSXlQoHHUaWlrnefXx
         9rBqGeNzg4tDIls8DoA8l6KYDYVd4YnbJEx8uKIhjFwm8MddEuEKjZoSR5doP+Yc90wr
         H1D0flXzOD13QU0x8C6eP1/KgAmDOQ5TvoQkEZ9tgYAf2+23kYwRp4QrC8dZGXGBnWRZ
         QoU9dhtHH0f8Oo58I8zwCDp74mTyXmrNoqi78OQI40DZDfdU2MRuQRiP3YyyUhDydMMX
         6r4g==
X-Forwarded-Encrypted: i=1; AL+hErFvhbdQtOLpa+fePv9uJDpq/EUwYx1uIIoeFcT/zzLWnvEuU7gk/rhZ+f+vcNFjQ6+nOqbY6i4=@lists.linux.dev
X-Gm-Message-State: APuU4Z9x3eIJTj4FTrA4TUDrhf9H/LrGYf39obhKRl0ozw9cCiZElSXM
	hbbOPAsFdRo4Ird4j7Cdot29TmjibsvhltRVbQjtNxjicsTgOZ1Mawbv+WDAJxQ0IcLAaI5Qqfe
	Bher0gJ8sXg==
X-Gm-Gg: AZFdTZcDtHB0nZU7Sej/D4MMmDee7cW0du8kr7/CAxSHLv12w9iqtfO0dbCXjsBx/lS
	1Wjux5UDYwXyDwdWhiDBhkH/5FLIQJOO/DVuJrXz0qE/Cn1kzgPrT+FH+Q0LdVXkWRgjCn2INCz
	vXqDJU4EKsBzF8KKJfAsgcIe9qvIhn0rpCdI0Ez0QECAIiywD15eAQUDqvWKfSbHV8SLmS4mTwW
	6tv0hRf/Bvi1mUCb1Fg5mFqCG5cBmxu1kSLtRlc+PXqsvjCdCP1d/ti4WwE0So2yWyCqQQLO1s/
	EpF5oFW3jA5nzecI4Pv1ZjfRFYz+KcwPRvegzVI35AQiIb06E8++Vj9eV1sbdOYpk1jigwim1/T
	ubDO+lvJ23ijWz+ic/s/uErz/qPZJ5zxBtQsod+8fjD/4PJYosyQxkz5ZEdGWD4nAfvgIpePvUB
	xF1u8d3WEgu5DeLooiLb7mNBEFlCcr0/ZuDkZkuQnqgIS+hETYK5VrdnfyKgN2a/dlK9MKUu/l7
	hGxQ3+H6nn32Qjg8t7QL3zUYrcxAy/pOW0UHjo5SEKyJGCrOE9rmnmynYfHMY5VR3fpSSR+4pwm
	ZADlhqCNWBWjdft7/XE=
X-Received: by 2002:a05:6000:144c:b0:4a6:bc53:246d with SMTP id ffacd0b85a97d-4a6bc6269b6mr5843166f8f.45.1795016136152;
        Wed, 18 Nov 2026 07:35:36 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c11643sm5196571f8f.49.2026.11.18.07.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:35:35 -0800 (PST)
Date: Wed, 18 Nov 2026 18:35:32 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH] KVM: arm64: nv: Ignore TLBI IPAS2E1 above the IPA limit
Message-ID: <av3FxJpUvpb_8qMC@stanley.mountain>
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

In theory, an L1 hypervisor could issue a TLBI IPAS2E1 for an IPA
above the host's IPA limit.  The s2_mmu_unmap_ipa() function would
pass it to kvm_stage2_unmap_range(), the page table walk would fail
with -ERANGE, and that would trigger the WARN_ON() in
kvm_vm_stage2_unmap_range():

	WARN_ON(stage2_apply_range(mmu, start, start + size, fn, may_block));

The TLBI's IPA field goes up to 48 bits, so this needs a host whose IPA
limit (its PARange) is below 48 bits, and it would also need to support
nested virtualization.  There are very few CPUs which meet both these
requirements.

The fix for this is to return early.  Since there is nothing mapped above
the limit, there is nothing to do.  This matches how handle_ripas2e1is()
also ignores TLBIs that start outside the PA_bits range.

Fixes: 70109bcd701e ("KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations")
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
This bug was identified as part of our formal analysis work at Pereq.  I
have not been able to reproduce it on real hardware.  The only CPU Claude
can think of where you might be able to trigger it is possibly the Apple
M2?  Not 100% sure about that.

 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ef4554656ddf..19a914941aff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4236,6 +4236,9 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
+	if (base_addr >= kvm_phys_size(mmu))
+		return;
+
 	/*
 	 * See comment in s2_mmu_unmap_range() for why this is allowed to
 	 * reschedule.
-- 
2.53.0

