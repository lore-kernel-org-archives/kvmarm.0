Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02363B14AA
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179381; cv=none; b=FLaGtMGetD2lDunlGK+1/vjrcAWuHWtb/sq7dWF1Dy0MKlUJNmDL3W0ke7ALwTzEXgLEWFz0/2yLSttVvVBLyZEaey3xIXVYixIaNqPiaa81pnTAqVHDOkkgbnotMTK6WD0BS/6dMDJMCELqRL7hRnJsB+wNgJ0D9IinxRjETVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179381; c=relaxed/simple;
	bh=TBv4jWE24nFMwbwZRdR3u9uJWahJa5hxuvryb+jc+e8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dSBGCGkzdx5G90SkwFtK+NalByBJCaS1oiuNTbrimyeOqTHKPIO+9JwZyB8z8p5eXi2xd/bX5nsYvAeriYrP/zCQoluYuYbFgZxV0tBaA9D8PGh2QSfQ+MAGFCGAiWA9nYxT3NNAgdCF+kz4KbMSYWbQ3ApyObXSVyzv5TWMWf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RtoM/p/6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RtoM/p/6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4815b8781c7so769027f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179377; x=1787784177; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vhLrSGY9svoYEa5H9hIeWUA3Z0wbe2vysdY+foWNbO8=;
        b=RtoM/p/6N4562vsA5XCSX5t1I/IT0Br+YQSOdNIicPMDx2ycFAbLWmpsCEMepWvfme
         IzQ9gOGvwuycFh/u1JRbkQEbLLlLaLS2/Orq2iJbMrBqDeTtYZFnOSxpAFBaCfQLsbEL
         y4Zi9rPXdTEhAwbKsrMXlMFy/Ir1o4NORc04gk7cVYRFIWUEXGWI4pGczEvldO7AFmcl
         ZGLl32oNC00yJRdl+Nbbt22rGLMZfkchPVMxFjQK0D3SUnXeUV8aj+H5X4JnCKjJ26Wj
         bOxuvzscX1UCvftVjaab/Be+7HU3c/YH99E5PhMLoRT0PssVlpprA67bPfLov0s4CzhO
         m7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179377; x=1787784177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vhLrSGY9svoYEa5H9hIeWUA3Z0wbe2vysdY+foWNbO8=;
        b=m0WCqcbVujY+1q2R92CLtV5/GzXowLIO6b4dAEyotGoHyX44o1fTSorMYMNAO2oX7D
         swOJ4vT8ZOOnFM8gfkv8pRNCK/N1zofUc5Vyas57ey3l24aA/uAdr2Feh/CzsjP8h4cv
         2tHO/bbAdXosH+vSFoCowi4Uu75xeUOytwAnbyF+DzZlyRMWIZqb5fPsK2dd0Z6zX6kN
         fQCo7rBY/kPf/CpfyOpiry9vvTQ6Xe0uucMwG91fArYvSsUz8qhtDPXTXBq/Q6WK87wO
         F9Nttck39f7F/+rLYXWkGYjKikXL5rVi9wOL5brwIxHR0Prb+bKYqpv+G1H5j1cCNWfI
         RtBA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9V8DdD7f0xw/0+kPLb2RbYdVFd3iLjRA5yQvaGSbgem9lo93Uj0GFpbpRM1s+sEX9nFe8gEI=@lists.linux.dev
X-Gm-Message-State: AFuF++kcqV1+dLCfrF3ecITsfe98fF3tBiN8dCKHywMRUlZdFg3iDpV2
	R8xNhPO/6jJHvFbzcn0/WtVriRWtzuc5SCWyDxcw5qIfmmX3vJQsCVvZ
X-Gm-Gg: AR+sD108mz1p9rnqFzlIv9IDbxPk8KRhZ1WdrRjnmJgPLDoCsBCNDukYEQ6eYvAOogX
	L27iSKxwzVaBbY0AMZgxkYJy4ci59Kz58JrLLKzru5IGYecZJBA+Wn21/VRPEh1w0U2ZRkeW3E6
	av8ZCeHCIS82Anw9VRooWl029Ot4lACxpg+4uy5JQQkUB/bH9+65mWPDKXMjFiUaHBGuEnfhiJq
	6BK1SVjkSm/JbxxFvARuxa8sQP0TxeSyetsJo/xdJ2UXCU2dK+PUB3AqGd3hCU17IwP4SymbBvx
	nzlM7Qk3F/srNVv9rAHbdj//whlS5KabBFXQj5i9PHT1jdZqvaagAymd+0zKD2AJ/a7UvMpS1Wk
	asDBrjVc/s361ErBKlo78kInGDetCYK1bvul8JTRnJHwtgecZf+meK5EuI2UPhQFrFn84bm5Og+
	Yak32jb5CtdRgn9gLl15WUdgw/MNIsnSzpnuO1cKdGHnu/K6zd2xkA/sHWPkXk1mkLpBhE4oCwh
	u+zNEJPaqR25BgIPdc3wHwoBJs15hCPVvPNXeFb23181wegFL+KM3UnBCoXV3aQGMqVBcIl4QmL
	Ehk4DY47elYchDyfYxQtUXKPgiNIhpJBoqSHAzAuqAmPmHGjXjMPTvlcnsGAE/GA5jfZ
X-Received: by 2002:a05:6000:41de:b0:482:a36c:a5e1 with SMTP id ffacd0b85a97d-482b1e875b8mr15751227f8f.1.1787179376510;
        Wed, 19 Aug 2026 15:42:56 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.42.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:42:55 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
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
Subject: [PATCH v2 0/5] KVM: arm64: fix VGICv3 redistributor rollback
Date: Thu, 20 Aug 2026 00:42:24 +0200
Message-Id: <20260819224229.82948-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed REDIST_REGION write can unregister redistributor iodevs while
leaving their cached vCPU assignments and free_index values intact. A retry
then skips those assignments and succeeds with redistributors missing from
the MMIO bus.

Patches 1 and 2 fix VGICv3 redistributor failure handling. Patch 3 cleans
up redistributor teardown. Patches 4 and 5 extend the KVM selftest
infrastructure and add regression coverage.

Patch 1 reserves the current vCPU's region slot before registering its
iodev and releases the assignment if registration fails. This keeps
free_index consistent with the cached assignments.

Patch 2 uses the same cleanup during redistributor unregistration, allowing
the existing rollback to reset the vCPUs processed before the failure.

Patch 3 unregisters redistributors before freeing their regions and removes
the region destructor's now-redundant vCPU scan. It is not required by the
first two patches.

Patch 4 lets the common VGIC setup helper select the guest entry point.

Patch 5 adds a regression test that rejects an overlapping region, retries
at a valid address, and then accesses all four redistributors. It exercises
the failed region update fixed by patch 2. The MMIO bus registration
failure handled by patch 1 is not fault-injected.

Testing: built the patched kernel and selftest in an arm64 Linux Docker
container with GCC 13.3.0. The selftest passed under QEMU 11.0.2 TCG with
-machine virt,virtualization=on,gic-version=3 and -cpu max. The same
selftest against the exact unpatched base failed with:

  Unexpected MMIO exit at 0x8030008

---
Changes since RFC:
- Reset all redistributor assignments after a failed region update.
- Split MMIO bus registration failure, region rollback, and teardown
  cleanup into separate patches.
- Split the selftest infrastructure change from the regression test and
  check all four redistributors after retry.
- Rebase onto the current kvmarm/next.

Previous version:
RFC: https://lore.kernel.org/r/cover.1786344511.git.kmehltretter@gmail.com

Karl Mehltretter (5):
  KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
  KVM: arm64: vgic-v3: Reset assignments after failed region setup
  KVM: arm64: vgic-v3: Unregister redistributors before freeing regions
  KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
  KVM: arm64: selftests: Test VGICv3 redistributor region retry

 arch/arm64/kvm/vgic/vgic-init.c               |  11 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  33 ++---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 117 ++++++++++++++++--
 3 files changed, 134 insertions(+), 27 deletions(-)


base-commit: 57e7cf13ac26bf1a3dba6cfa601f7b2481811575
-- 
2.39.5 (Apple Git-154)
