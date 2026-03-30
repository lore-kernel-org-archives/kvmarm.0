Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7592C3DA5B8
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880659; cv=none; b=mjWpVhyoYgijymlpVCbqAvwR+wnWTl4zGQGA84X6QecQawBm3r63+BAn9k4csGbbdWf4xZN3JXjrlauFTcbrQlbjSN7dwMkO5YHNqkNNxBOkZe+XbEDx7h0z/t/PItmuLQFJsDlTbZBWYF8bth3iJmm5fNw6gf2oFVdviHAJM1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880659; c=relaxed/simple;
	bh=fwjLbSUCVBKp2+5ehukf18tkFtjg9ytsRTv5sZMnrL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCHSiesCAbaEWEMsIY9xEPlTO1CVf1N1Im7Wp8eg+B7XYd4FkH1aZo3amrBwLUhwbhBkQE243BVMW2/T5Iw31MPNL5e7C96QNm+jEXt4RUJSPVMBp8g+JPVacoPcy+KimUC9PUfBtFWxZqMzyjdPeXLHgzJOCykWr1nNLRdpuj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VBbvGlrn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VBbvGlrn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 163C61D15;
	Mon, 30 Mar 2026 07:24:11 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 66B753F915;
	Mon, 30 Mar 2026 07:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880656; bh=fwjLbSUCVBKp2+5ehukf18tkFtjg9ytsRTv5sZMnrL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBbvGlrnK4+zQf2F6UvXQIBUv1L8yMQwGP9hgn9sgIWC1XQ/yJ6KCXqXVtiZG/m+s
	 kK4EdtOTcZR2O3mULTeFCccHKGI9yYgfgDgSoebJ2D2xLnwQg/p5s9Fku9kKDqYG4z
	 MnytV7AdUWLGQTJg+JC6qepDYdOeYeDknALtrspg=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 03/17] util/update_headers: Warn about missing header files
Date: Mon, 30 Mar 2026 15:23:20 +0100
Message-ID: <20260330142334.3309961-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Warn about missing header files, rather than silently ignoring.

Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/all/aYoCiXg8pSC_bwIv@willie-the-truck/
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 7902dddb..2f981ca3 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -40,11 +40,14 @@ done
 unset KVMTOOL_PATH
 
 copy_uapi_asm_header () {
-	local src="$LINUX_ROOT/arch/$arch/include/uapi/asm/$1"
+	local file="arch/$arch/include/uapi/asm/$1"
+	local src="$LINUX_ROOT/$file"
 
 	if [ -r "$src" ]
 	then
 		cp -- "$src" "$KVMTOOL_PATH/include/asm/"
+	else
+		echo "Warning: Unable to find $file, skipping..."
 	fi
 }
 
-- 
2.43.0

