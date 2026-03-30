Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6159F3DA7F8
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880661; cv=none; b=IbXZHhB8wPFZRX4nm2H6HrQVDTJKfFXbVvgnfw5+Um+j0o5uZiSRK89CLz7ldR2kK3m0J+2xqqi7HEfgKTTCibkwjpuWUKWpy9VDsGGlwrpdM4/295iKmLkWZqFyk+IpWLYNP2rp5+CLIKZ2NjdB1zz9+Vs1Q871NNXHey/mfqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880661; c=relaxed/simple;
	bh=bOky3nvsc6ldPQ7fAYvJH6clsPbllPsLi+u9F3fXEC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCg5Gy1x/6BA1CVkYKGUIB4QSagDlVfG2+oaJJA++gtaAYpWqamrLKV81x2MF+lyzOg5m4GvE+PflWXgu1H83RW/xEmadrOukwMOEfqPQzqaJHiGwGDjfnOfmcgMEh8psRQPoN/oA/l7LfjkaOkGbvsXVueQHFCKb7PERwiQuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hocopP9W; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hocopP9W"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E465F1A2D;
	Mon, 30 Mar 2026 07:24:12 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 41B103F915;
	Mon, 30 Mar 2026 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880658; bh=bOky3nvsc6ldPQ7fAYvJH6clsPbllPsLi+u9F3fXEC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hocopP9W1LJuVkba2ZaZ+71Ix5Rwuh2u/sHWwntgeihC5o3wzb7AffIDdClGrqX+q
	 1JFV0RWRwOBVY159XZv90VveGh7F/UWFfxp06fwFqiUrVDlRw+Me2m9nYfhncyP9U3
	 I787LyAyes7FtOHGs6V81GStEJjPiKQHMtS+ANPA=
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
Subject: [PATCH v7 04/17] update_headers: arm64: Track uapi/linux/psci.h for PSCI definitions
Date: Mon, 30 Mar 2026 15:23:21 +0100
Message-ID: <20260330142334.3309961-5-suzuki.poulose@arm.com>
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

In preparation for adding PSCI support in userspace, fetch the headers
from the kernel.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 2f981ca3..054397bf 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -58,6 +58,7 @@ do
 	case $arch in
 		arm64)
 			copy_uapi_asm_header sve_context.h
+			copy_uapi_linux_header psci.h
 			;;
 	esac
 	copy_uapi_asm_header kvm.h
-- 
2.43.0

