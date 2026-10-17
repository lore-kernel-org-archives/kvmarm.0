Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6B8394797
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792234950; cv=none; b=uhSx2Gybon5AkMAUm6Jc2BpoUWC9sJPt8e8DCBfq0qNelrtMpT8oQpn4u5HTNQsIqHewUxcXfKD4/Z6EKBE7Un9Kj+JwrnBsNRZUyR1Zco2GTKpF7eMndebycTJArhR0XBIBQMpdNQ363jAz1iu/ZZjtEMLY6oT3LY3DnMbjQNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792234950; c=relaxed/simple;
	bh=FjGEp2k4FfSPM+tdsngqSEiml++4V5/mJNGAoCdd2oA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oP3AnwJXgd1ihKjffuOXFwfOcmJoIzOTXkWXA8G+fwfg8mzYQGv3MNz6izXKfsPeN23EOg8fwT5IKT7izW7hZ6zSNIPoNdHucEhnumgWo/9xzv4whB8Txea1EWIMXvsT9dn/2OAKgH9+PUklr9ILywRPqmGg6rtFG+SBIGTSVsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFCOO+ss; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFCOO+ss"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e9ae391a05so3781895ad.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 04:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792234949; x=1792839749; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EooerGosbt9uNoLNk2R3r8CmWtmPXhr2JTyWgkAeP44=;
        b=bFCOO+ssL8oDe6DYi0XEhQId3s5Wh6VgfuOOVCCi4s9+spfqtGUUm2pLyaJUQZEWny
         ji6LoDIVkXtfUKKo6C6P8/0alKjwKEFFFfS68aZiTgL+2aiVrLWkX8JjECxcc/y2pced
         /5N92eDyNRq9wPE2jMlhmxvF5/LO+v2vjqzn+umFSTJYGRBbXHbiaxMGYm60PWqoy7cY
         GzXyObCFFCyqozq1PLAcN7oHy/w3y2UsYGeAKl2U5PuUin7bqivae8pzOnUZa1pkrrbB
         hrv+lfbYUcvSCzNWwtR+OP2B0BkhSGwjf90k18mf5y61geqWoChLLvsjdJ0OhZB7C9rC
         d1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792234949; x=1792839749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EooerGosbt9uNoLNk2R3r8CmWtmPXhr2JTyWgkAeP44=;
        b=lgmcAiYRhZeAAW4MUVNw0ap3IQZtNO2/LJplotl4UD/HjS6wXl6pJRvQFfjHkT9B2k
         rdLBl3nYAWRkioBudiBTy04YlS8LzE7QC/dPP65g/C9KX3FUzryCCdAykSAxzpVJnSiO
         /5YMXurBMgYHrwyecIfhCBeg6ieQJ2BtvRJ7ZzsiLXgRW21iSPbeQvo4fjQLgw0oIdHS
         CFpeDv7sde3nKPezu0a3pmBSNk/D07Zn67hKUJaRKHmk1JoUo+Krm9Ug2NcF20L7c4D1
         ldo7FDv1kwC1DaiMMj3Hqgy+gLGHITg+/0L5Am2T2RPd8weXV4Lz2ifvzXK6UFs18UQs
         GwnA==
X-Forwarded-Encrypted: i=1; AKwUvBxMBtO9n57JvXV2e8yfeK+jdfukc2wwP/8csAqG93M4APRhikSF/4gtFS/UUKMPaAHT+BbJ0uI=@lists.linux.dev
X-Gm-Message-State: AFq9FYJbVdJX4xUBFximyJwB4lWCEcRu1Qr9EbRLiPQ6FCb2i2xxkv0S
	4xxVRYySdQL/3yIM/JnSJHLWyQtWM0BaBf5v2kBuLDr6sr9SGmfFoNzM
X-Gm-Gg: AYBFou1G3y/O1lyz9QG6Dxc7BzE+hXuSzNFVLx2XJ3efxU65b2xOIUY7PEZ/rY/Uor+
	5G7TavDGC1lgdG4VjSXK9ayKsAbWkvkkttwOnYutk6s1+d22VKa3cKR+Ug3XzKDT6W0lV1cO2UH
	S162lX9PbpMfhqCC7wE1uEPJQ3C8/v/eKxycogGiFNzG7X36BA4Lm1t95Qspo/Mr66SjTQxpdqt
	IRVX9hODCEaaCThQpaf8mQ6QIz/E1eAErcFNfr+QaIz6rzsYz7bgknfhxhiw0b9eLqCNktUtVIu
	wS253HH7i2jVFiX65zLQ2c9D7VVyi6KjneVURdqDuadtP5hMbm3nvhQAsRSuQxDD/cP5MYiKuK0
	cszjZIaHEBL/EcjedXYmH2rDaqFEmKO68g7BJYAy7UWZr+RRmXUYe85tL531VUoSF7BaPJNQzj2
	CvkF+ksCTJRIOfxS4vSs3aYkkYm3fwxPNHNVNJnhqkmp2AixBv/CqqxMTyLVqCaxVEDQWdyQvcj
	3vBOtiDmZuP/au9ApMchQ==
X-Received: by 2002:a17:903:1a10:b0:2df:a0d4:71de with SMTP id d9443c01a7336-2e9a66ebc71mr15900275ad.0.1792234948529;
        Sat, 17 Oct 2026 04:02:28 -0700 (PDT)
Received: from x1c ([2405:9800:b670:b64b:7c65:ff3e:80ba:b06])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804dd9sm20559955ad.16.2026.10.17.04.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 04:02:28 -0700 (PDT)
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>
Subject: [PATCH 0/5] KVM: selftests: Reserve memslot 1 for ucall MMIO
Date: Sat, 17 Oct 2026 18:02:08 +0700
Message-ID: <20261017110213.46199-1-tharitt97@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series addresses the TODO in __vm_create() to reserve memslot 1
for the ucall MMIO region. It introduces a shared base for test
memslots, migrates existing test users, and adds a read-only region to
prevent overlapping allocations.

A regression test verifies overlap rejection and continued ucall
operation.

Testing:
- Intel Core i5-10210U and Rockchip RK3588 (arm64).

These tests are changed but not tested: 
- arm64/sea_to_user.c: not enough memory allocation.
- x86/nested_vmsave_vmload_test.c: requires X86_FEATURE_SVM.
- riscv/sbi_pmu_test.c: riscv hardware unavailability.

The following test failures reproduce on both the unmodified base
<8edffbc1f6272db167037e1a8c49b99e9cd04803> with host kernel 
7.3.0-rc1-gd4b7fb647204 on RK3588 and with this series applied:
- arm64/vgic_its_save.c
- arm64/hypercalls.c

These failures are unchanged by this series.

Tharit Tangkijwanichakul (5):
  KVM: selftests: Introduce a shared base for test memslots
  KVM: selftests: Use the shared memslot base in memslot_perf_test
  KVM: selftests: Use the shared memslot base in memstress
  KVM: selftests: Reserve memslot 1 for the ucall MMIO address
  KVM: selftests: Test protection of the ucall MMIO region

 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/arm64/hypercalls.c  |  3 +-
 .../testing/selftests/kvm/arm64/sea_to_user.c |  2 +-
 .../kvm/arm64/stage2_block_transitions.c      |  2 +-
 .../selftests/kvm/arm64/vgic_its_save.c       |  2 +-
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  2 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../testing/selftests/kvm/include/memstress.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 19 ++++--
 .../testing/selftests/kvm/memslot_perf_test.c | 62 +++++++++++--------
 tools/testing/selftests/kvm/mmu_stress_test.c |  2 +-
 .../selftests/kvm/reserved_slot_test.c        | 61 ++++++++++++++++++
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  3 +-
 tools/testing/selftests/kvm/steal_time.c      |  3 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c |  2 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |  2 +-
 19 files changed, 128 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/reserved_slot_test.c

-- 
2.53.0

