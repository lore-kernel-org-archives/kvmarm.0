Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD033B2FC6
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 03:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788666120; cv=none; b=AdPnPk6fK0KvMMpSZrVlO1EcSDENE0LC/+oa7eJawx57wA0g02roMI5A6ZIw011uFT1lGZfqYQakBSsIKhKVM4fWux0pGDOxeMzs9SrTbFOIHmCdcx8ikyS+T2xqVJFo7nDiH0se0LIT++/fklT/UqEp+uvWlVSIxTdAzbod0i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788666120; c=relaxed/simple;
	bh=1eg7xfXvqB+X7Z1e0Md87PErbs70YQUknxBBKub28qs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ebgnLQ+89kM4adlSYPZOY4Uardoj4yAOuSo7g2p7wt7EzMqcgPW7tXKsFS3U/WkTeGYNAHDrmAuEdgJCXW1DfiPNTcQbcTJDjGhIx0r05/SpOAb+zsC7iPx7DYu1NtMGesfmUKzKBzVT8cHoBP6DI+r1/hlkrW4gndh5qXvP7SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTJ7MSqg; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTJ7MSqg"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d9201076b3so27568635ad.0
        for <kvmarm@lists.linux.dev>; Sat, 05 Sep 2026 20:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788666119; x=1789270919; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=48OUlgZ8oJkokpD3G8IEqvdlANt4AE/H+y5S+7nUN5c=;
        b=nTJ7MSqgFwQH4GsBNyY30KDBtYYxWPB/mxeEeW3zgdCvanik+/RPugVa9KxIa/0CRv
         H3or1Bp7CkCY97rmyM+aYIMIcZa7c9CO2TDsPpy+tiNlbY7TVPRV/3vmTi2B1CeyrFKx
         ktGcxdV0z0FwidRNdAh04lOjSYHYTI7liApX5vXX5NMFEg/0fc0nVESm0TMWZP6mfClT
         aLcidevEWDKxN8z6nBGbUTRI5+rfGB8oAUVmOVHqoO1megxwBkfLJfvX8XjW7BnR4O3R
         kJV+NfQNu+qW8aZK5l8IX3yRIdHMuqlY7KnlBZh1dyVFQ8NkGBzFFL9OKs7ZoEDvEwoO
         2A5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788666119; x=1789270919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=48OUlgZ8oJkokpD3G8IEqvdlANt4AE/H+y5S+7nUN5c=;
        b=Q/snMeTMQp4ehXPsF+lyCKrwLj9iifnxbArIhc8yFzHvPIen1eTfONtVY6FVkDcenV
         BTBD5qU8Cl7GtHoQsuIwCIKs30Nu/gKQam+rR7iFwYmG+EkmNLZkL5RG3kFtclOVWjgm
         9FNNqmlooVuxb91SH4CgCiniPeRU7QGLky5l9ORpCL2NoTPJXyJ2WnuTcm8R2U8sEpFN
         0FrDoTqBIPxLS1qG3es9nIAtbD4i6Cm8L+kvH3oGMVZaUhHR+H45+pYct1BIQ2h3DuHN
         GVVJTuZzIYYEb/CgAQ2Jc/zpfTVo6rRknCKq1olDN37TSd519VQ187/x38mAcSo5gdJa
         xBaQ==
X-Forwarded-Encrypted: i=1; AKwUvBylhB57WOjtymOc9hji6Wuc041JnSfnVSL3yi7XVa9+ZRoKsBa9TFd3cjT5m8MgDpFkVMQssZ4=@lists.linux.dev
X-Gm-Message-State: AFuF++m5wdT1DfvKXlbAG0a6YTqjrKt34ygxIxNne89D46vPqHE5agCD
	0Kv8T7tAAJuB0yjMMlEs5JI/jnehfjuMwS7JzLYFiFS2+zgwmgWR3LC+
X-Gm-Gg: AYBFou0LrgsveehvD0NmarJfldtPrhZNmTGmHyRXODJp2YIXE/dfYXM6zHEgpKbhvLv
	EQRPkjOl50/xa9UMhEHZb312M+xxAZXCeTON3A39D9TEn/bQ8klF8eoxHH19PV3JyeqrXFsKsRx
	7XWpReLYOp0h3Ieg4fwXWtpbccUo1pSPaYXciKnsqPyEQtwlrz6eg+bxjWx1WIPZCXdvsjZZOBv
	ydiNcH/2/GDWjEFV17gByaPUmz3QFi6S09uzH2R9rcnYzLrQhPP7eJAcMWt2yQvEL5fJO5VqinO
	4gQvkkyRb7P9Og8BKelbYbxA46SAp40csGRnMwXe0NX0mHZMd0S8w0c8z8jflZt2nWx0FCxQqdx
	bCrgUw2JxShTIAUU5NcofUDUFc4dfrhGBYzRiC93ZkTD/ecTUcPWmXmCcY+MeHZdTFipudeT5iW
	2UhzijZ50y0eO1lhYfrejbz0JY7IdVxBuiTTipLZsXjWGHWmAJEfL5MJAp63r+3uL0TJIcYudVP
	VPuLeu+Hz0p9Hlp0qQHopDeUR2VAEPRMvJi3wcxCAQ0
X-Received: by 2002:a17:90a:da8f:b0:398:b71e:60c1 with SMTP id 98e67ed59e1d1-39b26208e7amr22343140a91.12.1788666118495;
        Sat, 05 Sep 2026 20:41:58 -0700 (PDT)
Received: from debian-rockchip-rock5b-rk3588.. ([27.130.10.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ce4221sm22761765a91.14.2026.09.05.20.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 20:41:58 -0700 (PDT)
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Gokul K <gokul02k@gmail.com>
Subject: [PATCH] KVM: selftests: Fix VM leak in early return
Date: Sun,  6 Sep 2026 03:41:43 +0000
Message-ID: <20260906034144.14059-1-tharitt97@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_mmio_ease() returns early and skips the call to kvm_vm_free() when
ID_AA64PFR1_EL1 is not available.

Use a goto so that the early return joins the common exit path.

Reported-by: Gokul K <gokul02k@gmail.com>
Link: https://lore.kernel.org/all/20260808081050.408657-1-gokul02k@gmail.com/
Fixes: a90aac553249 ("KVM: arm64: selftests: Test SEAs are taken to SError vector when EASE=1")
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
---
Tested on a Rock 5B (RK3588). ID_AA64PFR1_EL1.DF2 is not implemented,
so test_mmio_ease() takes the skip path exercised by this fix.
---
 tools/testing/selftests/kvm/arm64/external_aborts.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index d8fe17a6cc59..7836756a38a6 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -339,7 +339,7 @@ static void test_mmio_ease(void)
 	pfr1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
 	if (!SYS_FIELD_GET(ID_AA64PFR1_EL1, DF2, pfr1)) {
 		pr_debug("Skipping %s\n", __func__);
-		return;
+		goto done;
 	}
 
 	/*
@@ -356,6 +356,7 @@ static void test_mmio_ease(void)
 
 	vcpu_inject_sea(vcpu);
 	vcpu_run_expect_done(vcpu);
+done:
 	kvm_vm_free(vm);
 }
 
-- 
2.47.3

