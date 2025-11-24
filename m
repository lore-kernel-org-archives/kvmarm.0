Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C4272E42
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028451; cv=none; b=M1LwLcxELO4O1Q/Gym/5B0j7okfpTqwqUkyt5QJfUchXmJmRXzUO45qGQFKK5gxXY+XUqrLvMJ4oI7hTW4drBd5+CTro8RsWHYvSspgHL4IG7w/f16hZf2qMevR6qRemBnS72XZlr5yLTKkI+hHDOlChDAeK4r/9ohrN0rv1thI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028451; c=relaxed/simple;
	bh=U8e28kdI2TmHs1Dz2m21+xYxx32Y4FL5MXyqrbasRN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MmNZBoO2tXRxdquaJQ8jbWvYC8GMnDZIw/z3ltNMGvJsvRhnfhhNDZglpGjrOS/bobsSY/xZpdC+tILTPOoj2XWHq9unTAHr9QZVu243i/3t0oSBWXwxGssL0KLlkx5eCJmKxG2b4F0AOTmVc8NWESV2mjsA6Wu9nn20wJLxJJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBAeoFym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBAeoFym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FFDC4CEF1;
	Mon, 24 Nov 2025 23:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764028450;
	bh=U8e28kdI2TmHs1Dz2m21+xYxx32Y4FL5MXyqrbasRN4=;
	h=From:To:Cc:Subject:Date:From;
	b=UBAeoFymUXc3fBUNqXf0UeE5q+8K4h18wTqN9u4DXADD7Ta6xV6JekrPs0TPBngUk
	 Mss81+UI2j9RkTWUW+BGOGlg5dGU4M70H8EX4s+hcqYNCMI6/HzjyTarZ7AG39GlMA
	 gdW5Ve4cAxP8g3pEOio0LzVDQJl6JYG/X+Vni32MgbCwj8mLsQwecbH6By9T59YsEM
	 aZ9NVtmSzfX2CNh1AlpnYDa6xGvAxjnnLzC72QxAfV3eK4/CyrwsZtQCcUP8v7oIRr
	 tWC1troCw0MyAWDGmlQg0r2kg8rpo5GR/xfv1zfeDdu+ypWOqXaaVPU+aQ2m9D2Hwh
	 PyOJ6wxbHllsA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=n
Date: Mon, 24 Nov 2025 15:54:09 -0800
Message-ID: <20251124235409.1731253-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__lse_swap_desc() is compiled unconditionally, even if LSE is disabled
using the config option. Align with the spirit of the config option and
fix some build errors due to __LSE_PREAMBLE being undefined with the
application of some ifdeffery.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511250700.kAutzJFm-lkp@intel.com/
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index e39f814d247f..f774a02d9393 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1697,6 +1697,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 }
 
+#ifdef CONFIG_ARM64_LSE_ATOMICS
 static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
 {
 	u64 tmp = old;
@@ -1721,6 +1722,12 @@ static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
 
 	return ret;
 }
+#else
+static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	return -EINVAL;
+}
+#endif
 
 static int __llsc_swap_desc(u64 __user *ptep, u64 old, u64 new)
 {
-- 
2.47.3

