Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EED3C65FD
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163822; cv=none; b=uUUn2mp3sDrzZY3dPvU5jI5hPLQ0v448TXcWDL+prQElSPTEniYIOqwXabsSqx6A7xumRys5a3rApS7h1BLaxnkW9BF2Aaet8DfeQx7vFx3JsE71XhW1JG8ct56sEEsRvmHG08D8BggY1G755tWV745NPGDY/snXFPLUsJgjx58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163822; c=relaxed/simple;
	bh=3oRLO2+O+nNQlRC3Hve6ZkusqNFXpr/KFZLae5kr4HY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EQE9ZyMkXv87037gsRolmTnGiXctiLO7/jPPWJFrxitME9ZQEl1sQCyhxfcJD/ioIkYESU/mOD3RKV+t3O8bUn/EXhVe56FeYj/1CjxCD4fhZkZi6KXOwBCkJWfYC99kKTbkS1rHjbrQXl+GpCwS/9wql3RxBNL4CQjsCKdknSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kG4GrNCc; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kG4GrNCc"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso15022655e9.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 01:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788163819; x=1788768619; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=seMt61JR8WO02xp6SOLRxCCG0tr+MAwwqiFyhbMBI5g=;
        b=kG4GrNCclkjo48A4Au225+TmoxqD631hqr7K9SV385fFvHU9UjY9Xqbvio/v2h6PQ9
         b9W061/N02GPOGjhE5znypFga6uKgj2M3gRPTfGMef1M52bGtH1rJdvOProl5h5UJNLg
         blzQTr5jfEqcR1LFs4D3YfizePSBGKLGuNcwuWFGc8gIB+25UQMqo5LdtACWM1rFUCIn
         lZXE+a1PX72f4chin3RGI2lCf+HQdaDC1iFoaYDaowqTtLUXs/Uj+M8bEHYzSDzhEZwV
         y84Jn12MZ1dYanQwgeBLMNfQMH9FYTye7IPqMM2Wg3ybcCKQJQ9jV6Ax3qReRgDPy3gc
         o4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788163819; x=1788768619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=seMt61JR8WO02xp6SOLRxCCG0tr+MAwwqiFyhbMBI5g=;
        b=JtR3FvZVykw7uoCqfLsR/NaIzGHJh9hEj85951zPVMMhYeStaqZJq90QfwA/CwmiKs
         mNk4tQftAyptqBw9ygt8rYjiv61vPKzrR7ubDaZUB3qsDKuvRysN7TlH/ZX+h9No18db
         dyesdA06C70RjmX/BFGWeDjnGJEEDf4ZMcucvEl+SE7OEufu0gGXtDoka8Ps1XTxG6qu
         iXg/p4udidF3xNicGCg5yf7DO3iFGzC2d+r0Gkm51D8I1h365FKD44pyIe86UWF33B/3
         5ezYRZwkWkuVwyaDU07y/ctMFCbXhS+z9yuNJ990ScirS0jLPcgnfSLp/TdVY4YXkMn9
         xYZA==
X-Forwarded-Encrypted: i=1; AHgh+RpbWlfIz1f85fE5/LK3wtyFfiempo8QWFCaFiMIAADpkxyqD9o4FHLjwcfcH122Vi2c6ZyBM7g=@lists.linux.dev
X-Gm-Message-State: AFuF++mft6jr2QcUXAMZUrfc1EipwMfvuqQv49L1k7RcPVA93WfHabs1
	SrdYlyehqFAFciSJ10gQrcXIZVEy1seRIDIuwoe85vW+AbIRKHLjRQSr
X-Gm-Gg: AR+sD13OtAs6QG+/kXfyqEI28QqFAwZkULZYiMcNCHRZMd2zoM2flnsLucQOG4KUp+y
	VZM/cg15z6TxjcCPKxRq1PtNwxa+XnRyMYbj8J8exbkiiIwi8eKF4unBJYij5SH/yYbpldaL5zc
	uF7tq2lGsksJftR48V8p921OSiVLL0F4pGLSociKoJoxJh7YieRArhsZKeW4RJSNlaRm4EaflRj
	yDRdnxBvJ1h6W8zD+TJ91M8taKk6MKNqTk890Wmi9MGhpdnxi9daiJO98AsK2D6hDHjodKTAdei
	Zrq1GH62z4zQNEw8FEPv+LzLfaMCp/7pDcgP52z2XDxW/LcVIxIqSa1OOQNNQ9YxmP6VXLzo9VN
	EfxLKdQ63Ra82uKIjrThNENitiFP4VXccKyXB2x9zKE3wgzvdj6ScGMU+FkO36zcUBzbs+Swno/
	AcxHa7pfOER87n7xegMWios0m5z9X1rmFhdjo8IEbMkLpCgDcMIdIVGjEMk5eTppBwJ12uptNpp
	iYoJz2+vQIKqoeM+DnT18P6PxLif2AkRB38wbVC2rnKg6xgMAqUgY0VEBSLZpuBIASW5qhd5BKG
	LM7da74HDBLcGCfSK+wkEnP8h+549eRdrBefkRxvs7vV4BnRtLoK9ogx17vx1zKmo4pHQzCJplE
	U83YT4g==
X-Received: by 2002:a05:600c:5288:b0:499:84fe:5f3e with SMTP id 5b1f17b1804b1-49b91c41014mr396116665e9.9.1788163818374;
        Mon, 31 Aug 2026 01:10:18 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013d06sm370393515e9.12.2026.08.31.01.10.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 01:10:17 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 0/4] KVM: arm64: fix VGICv3 redistributor rollback
Date: Mon, 31 Aug 2026 10:10:00 +0200
Message-Id: <20260831081005.41346-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed REDIST_REGION write can unregister redistributor iodevs while
leaving their assignments cached. A retry then skips those vCPUs and leaves
their iodevs missing.

Patch 1 fixes the accounting when an individual MMIO-bus registration
fails. It reserves the selected region slot before registration and undoes
that assignment on failure.

Patch 2 limits rollback to assignments from the new region. Resetting
assignments from an older region can miss one held by a vCPU that is not
yet visible to kvm_for_each_vcpu() and move free_index behind that live
assignment.
slots_lock prevents a concurrent vCPU from acquiring an assignment from the
new region before a failed write removes it.

Patches 3 and 4 add regression coverage for an overlapping region, retry,
and final GICR_TYPER accesses to all four redistributors.

Testing:
- Built the modified arm64 KVM objects with W=1 and the arm64 vgic_init
  selftest using GCC 13.3.0.
- On an Arm Base RevC AEMvA FVP with GICv3, vgic_init passed with nVHE,
  VHE and protected hVHE. A VHE kernel with PROVE_LOCKING and KASAN also
  passed without lockdep or KASAN reports. A control kernel containing
  only patches 3 and 4 failed at the first GICR_TYPER access, 0x8030008.
- Under QEMU 11.0.2 TCG, test-only instrumentation paused vCPU creation
  after assigning a redistributor but before kvm_for_each_vcpu() could see
  it. An MMIO-bus registration failure was injected after one vCPU was
  assigned to the new region.
  Rollback preserved the old assignment before and after the vCPU became
  visible. A valid retry succeeded and guest GICR_TYPER accesses found all
  four redistributors.
- An adapted Linux 5.10.268 backport of patches 1 and 2, on top of
  8542a8f95a67 ("KVM: arm64: vgic-v3: Fix error handling in
  vgic_v3_set_redist_base()"), passed the isolated retry test. The
  prerequisite-only control failed at the same GICR_TYPER access.

---
Changes since v3:
- Dropped the REDIST/REDIST_REGION serialization and VGIC init/destroy
  rework, keeping the fix close to v2. (Marc)
- Limited rollback to assignments from the new region so an older-region
  assignment cannot be missed during concurrent vCPU creation.
- Added Fuad's Reviewed-by tags to patches 1, 3 and 4. These are otherwise
  unchanged from v3 (formerly patches 1, 4 and 5).

Previous version:
v3: https://lore.kernel.org/r/20260822095346.53882-1-kmehltretter@gmail.com

Karl Mehltretter (4):
  KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
  KVM: arm64: vgic-v3: Roll back assignments from the new region
  KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
  KVM: arm64: selftests: Test VGICv3 redistributor region retry

 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  54 ++++++--
 tools/testing/selftests/kvm/arm64/vgic_init.c | 116 ++++++++++++++++--
 2 files changed, 151 insertions(+), 19 deletions(-)

base-commit: cf72cbb39da84b6f02f90c07f33b102fc10b16f0
-- 
2.39.5 (Apple Git-154)
