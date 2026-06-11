Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C833E7BBC
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781188857; cv=none; b=EuCk8a4K4a+FyWZlrwh0FkOi1neG4k2joVbZV2DFHajNrsUS9QMQsKW7imvjoPWzWbO7DHjy2w9QEF8vP7hgW6LpKdMIlWKkg7CO81lJUYyo0pAIphtg4MQdBOr/zfz7kUtUPAoipmyESh/zjtj9a+giGoz3FKDWAtLTwZdTAOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781188857; c=relaxed/simple;
	bh=BDNWeqPNKmBYIFGQanXhaXSEzAkOF+AXd0XlcUwDPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WR2yetMecvF0Kf1fBbjfZLchs62BpxH3akN7F3KAUAre1dQvR/mpg4Acvcxs1CPmO1Bt0UaUhLGFm0ekruUhw0Ty5T6FaMi8MvwNDqPNJofJ50Bha9anr95s02GothPJ8sVTQrM7HyfU1jq01zvhUBlBmd/2IWdkZo/hWdoKP5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnxAgiXu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnxAgiXu"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c31212104cso3161755ad.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 07:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188849; x=1781793649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jWMSanWzJRCsWHlDAnYeE5yp9VLQwxt2P77lroQT7Wg=;
        b=EnxAgiXud3FbAHnofnuW+tIxxOeEg9dcplyuy5oObnDu+wVekwz3C13o7AE5E3vv9a
         7uluely9AUVQ7E3MxsjyWDjFPBYzopWE3Y36j9/7aU2prsRiJY3mFUrfp0JePl/Do5Hh
         J7rIV6Q0h/6a7loCfX3sy9YqcH60oL8Qy5rr3EW73/h9RCkcH11Z3x4io2ZllT2AiV9M
         t5btMCaKl3D5C93aUBRHcta8vNuwEgBSblMgT1MVIl4oIi+Vv3/Yjk5LcjVrl2mETCrF
         j84YHYDV6B5b0SkCzmTMyM6E2uj37aDkaWqKjcTaEfUvN55JLN7LDGiC4sEXFP0rz56i
         8Huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188849; x=1781793649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWMSanWzJRCsWHlDAnYeE5yp9VLQwxt2P77lroQT7Wg=;
        b=KoURZ7m7Mu1CxmdToJxL4QeqEOgM1A/L5SRu1ffiAEffYMxEEgk4HpqsZ0KBAFF9Mv
         UgVAmCYziXlVkMVXIrJ7lNsRdMZDjmraMSCvk9mvpTuZ4mrtPvwnUUgKkjHq0tBEbiBY
         C4pDtr2yiJHFl7hKMbNcgB4Z4y8+uQKADeiXUqp95fhaTuqt/nN/5Xp/993j59vpBZOj
         hPbnHqYv4/viFF6vfofVJGCfzg8BFsDH4MQp3gw5wNtMzB08EYNO2nWDw3V5YqunxAt5
         3VJi4DDUi222Xk6czspKAurUBRhKRJq31jBOxlbjzXzUhcFax+xPe46ke8KTlXwjdLgl
         yqRw==
X-Forwarded-Encrypted: i=1; AFNElJ8WTG7nabAqoowh8kyh25BHsHLwrcQK0VG/zdMPqUZxxNTE7C02VM69I07XFFhW6BUrLqOx4H0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLPtpwX7bla3azCG3xhyHgOLZvB2eOAQxxs0xX5QHA1Nyhx1r+
	FTDE/rnS/5VRGtyQqfzW57i9jw74bjSh3zG0AmTw8QVVITkThg9bEYuV
X-Gm-Gg: Acq92OHcJvVrT63i46N2Nh/3tStPkIpCwsfOo5EHSSAqDr0UXJWqwmlZsqjQhWnqfz6
	rhAX/1MVTUdzCZwRrSfVj8HKVEMovzEF3pcbYXqkp2w5LmQpejZ9yzQJj+pNegB5L3xtqxOiI6t
	Yx/lp5OcMV80acDQ40dXFuGtH8CXQxC+CZx42jBus7HhhHSs9TDntPw9F/WcQF4FRxXgdpMHwc0
	uNMNUbzQZ25KDqyvg4//Vg1JKIvWCZAuWTyYdajoSptphu+Iz4x9zsVS/mzD2vgJ0jYHq+5Sg3M
	ta3QW3sclHBSo+Km3xanFsOOSbnF+xyn+rWPOzu5vzxABcI2RGZwjezGbs8z+yArzZa7JQf/mdF
	hhutUIDS0H++ydDrfFqlmDs+XjEGHAv2M18OHfsDbUH5kGckB2luTmXj8vgGS1I/8iXWtrer2Zy
	KgXInRq/jn0GiP4yYTlVmCTYjAVjPJhLyuI0TGPCUocyZ7XMKzTtWmTCc/JRXdgpfMlA==
X-Received: by 2002:a17:902:d4c8:b0:2c1:150d:6db5 with SMTP id d9443c01a7336-2c2f0440887mr32717895ad.6.1781188849358;
        Thu, 11 Jun 2026 07:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c249aeb62csm161097355ad.68.2026.06.11.07.40.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 07:40:48 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>
Subject: [PATCH v2 0/2] KVM: arm64: Fix MPIDR lookup for unreset vCPUs
Date: Thu, 11 Jun 2026 22:40:40 +0800
Message-ID: <20260611144042.97981-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: wangfuqiang49 <wangfuqiang49@jd.com>

Hi,

This series fixes an MPIDR lookup issue when a VM is created with CPU
hotplug support.

kvm_init_mpidr_data() builds a compressed MPIDR-to-vCPU lookup table by
walking all possible vCPUs. However, vCPUs that have not been reset yet
still have a zero MPIDR_EL1 state, which aliases vCPU0. This can cause
cmpidr_to_idx[0] to be overwritten with the index of an unreset vCPU.

As a result, MPIDR 0 lookups can return the wrong vCPU, preventing
interrupts targeting vCPU0 from being delivered correctly and making
guest boot extremely slow in configurations using CPU hotplug.

Patch 1 adds named definitions for the MPIDR_EL1 RES1 bit used to detect
whether a vCPU's MPIDR_EL1 state has been reset.
Patch 2 skips unreset vCPUs when populating the compressed MPIDR lookup
table.

Thanks,
Fuqiang

SELF-TEST result:

1. use crash debug cmpidr_to_idx[]

(qemu args: -smp maxcpus=512,cpus=4,sockets=2,cores=128,threads=2)

crash> struct kvm_mpidr_data.mpidr_mask 0xffff2020acda15e0
  mpidr_mask = 3,
crash> x/8xh 0xffff2020acda15e8
0xffff2020acda15e8:     0x0000  0x0001  0x0002  0x0003  0x642f  0x7665  0x6e2f  0x6d76

2. use link [1] to test IPI latency(Before the patch was merged, it often took
   seconds for a kernel thread to be scheduled after being woken up.)

IPI Latency Matrix - avg (ns) [100000 samples]

          CPU0     CPU1     CPU2     CPU3
CPU0           -    1355    2242    2238
CPU1        2730       -    2391    1852
CPU2        2149    3015       -    2033
CPU3        2005    1651    1801       -


Changes in v2:
- Fix macro naming/placement/type and pass vcpu instead of pre-masked
  affinity to correctly check MPIDR_EL1 bit[31] (sashiko bot)

v1: https://lore.kernel.org/all/20260611090934.84469-1-fuqiang.wng@gmail.com/

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/ipi_latency

fuqiang wang (2):
  arm64: Add MPIDR_EL1 RES1 definitions
  KVM: arm64: Skip unreset vCPUs in MPIDR lookup table

 arch/arm64/include/asm/cputype.h     |  1 +
 arch/arm64/include/asm/kvm_emulate.h |  9 +++++++++
 arch/arm64/kvm/arm.c                 | 14 ++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

-- 
2.47.0

