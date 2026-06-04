Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92E3A3830;
	Thu,  4 Jun 2026 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780565245; cv=none; b=WKJ8VdrOCiURcUbdXOo6nJX58c1xTwHGaD6Rf0tfkfeUTDcaLvZBVfz/+04PA70ghdBreRn6WqQwwoeu4pV/rvI136PzvIUSlrtMUXG6WzRRLMChkN1oGZ1kiw0JSTbd7YFF9o/xgEwGjzVpNGbmtwkh9BXxzx3f1pOaJWRq9tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780565245; c=relaxed/simple;
	bh=a+EzBhxFLZcl5XaOPYou8uHj+E5MMQ3LPc5OodWrA1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kxiZoIN5DdgXWj/EblgbzEpIzeK9b9IN8Od1CbGRKOXi71L44O5a5OId9yXLvNglrSHevM0uq0nUNFOi9/sy5LiZyVLnZ+m5pQHHq9Ol+ofnBeNsEU7Y+/ytvf4u4yv4/P/Gs/vrfV0YirotkZTzyjAjBuErWzvIunBVNH/9lcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dK7C5t8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dK7C5t8f"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3C3F51F00893;
	Thu,  4 Jun 2026 09:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780565243;
	bh=1lkkQRCTGiBG6Fz5uRh6m6A6GAOwOb7hDHgz+EhABhk=;
	h=From:To:Cc:Subject:Date;
	b=dK7C5t8fUFl1dYz1idA8ezDuF1cexqTuuYvp2e7gpFoUCnDP940YEK8tVFUq1C+MD
	 OhW9nYCzc6lTg00C2jjyUbd4/2XsUTzFAtQ19gt+jG8fS/87YbIkwHJAVDucVHsjX5
	 fZIC4PR52EDt/AQ/tSKzK1leWMJzLvEHS2QrKdRVRtEFELBXv1FXnvzapobHEmhyqM
	 P8/bVHRUqUigrRbbH6LY4YDF/qntO+UU8GFja5fb0IMgoOSkiemQd07B/gw7ZMIeI4
	 q6iOCxqC4GfPt12Bc7UJOZB+pNeggy29riQl/EafxXOeMSc1eVzodrWBFqHaTRBK5d
	 /+DmZ7DloqlSw==
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix order of arguments to ktime_get_snapshot_id()
Date: Thu,  4 Jun 2026 11:27:13 +0200
Message-ID: <20260604092714.1537457-2-ukleinek@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=985; i=ukleinek@kernel.org; h=from:subject; bh=a+EzBhxFLZcl5XaOPYou8uHj+E5MMQ3LPc5OodWrA1s=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqIUTyqWnHG6n29XEa0HB6eHFdz4FNbj3rk0UYC YtukttUeV+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaiFE8gAKCRCPgPtYfRL+ Tv71B/99vHoxi3OVHI5tDCWZUG76J4SS2Hm3CSyuYe9ONmf+ykLG3cP+aja/+KtkAWBDUON7K6O FvRBucRn5Kb7aA/VZJrrg7ATZKWR0DRPEyg9q1binLKm1kGb2HIbNK0AeIdguL0iPyOlc0xgdfd 00jiN5g8u8CVwffZ/Cy4l7TImfmQU4GHNJCLdt+a8AT9WxOsG6iWf57yX7JkFLLIBxfWe4kE4I6 T1u2yhrbKh1Mnl3+qI71xk9yLWRLrDOC1xLlkFWeHwiWoDxwT/jMo/St3qr2dTe0+27/lOEN7Q1 7l/Ux9rJHuycuV3c9Ism0mEg02p6HOEqhFSP47X1/PMIy76b
X-Developer-Key: i=ukleinek@kernel.org; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The first argument to ktime_get_snapshot_id() is the clock ID and the
second output parameter. Fix the caller that reversed the order and thus
fix a compiler error.

Fixes: d09439210441 ("KVM: arm64: Use ktime_get_snapshot_id() to retrieve CLOCK_BOOTTIME")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
---
 arch/arm64/kvm/hyp_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 8574db7491bc..2411b4c32932 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -118,7 +118,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 		hyp_clock->running = false;
 	}
 
-	ktime_get_snapshot_id(&snap, CLOCK_BOOTTIME);
+	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
 
 	hyp_clock->boot = ktime_to_ns(snap.systime);
 	hyp_clock->cycles = snap.cycles;

base-commit: d09439210441efbadd8b0aa32c1ddb1eab2f3abd
-- 
2.47.3

