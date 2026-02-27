Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C963570C1
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211585; cv=none; b=dUkzx/efOZTcNRdESfl0ncVXeAK/EmVvLMjtv0nV7DCKD7uS0Mzo7AplkB6N94vqGmDl9ji1897BMI1NyrUUeeKLd/4ZiaaMw3j9tDGupGaEOm8Ycz0djrwRi3s2HXAylCMpT7pxD2jWkYyv1z+YyDAuuYpbw7i3Xvu3+aijTrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211585; c=relaxed/simple;
	bh=WRKs3OuI9W8qsl9Ml6GTYQTN/+TWrVfiC8zulch/l/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyXKcEChv0jWZdyLp3n8gHhfqShkUhRBjkg6RPdTS0suGBG3MMAklzPxNzs6iTGjNUZOQG4qvqz5yJGWYL2HF7n034ORAygRrO+eq/ZsFsRpwIX9odok4c8yBGZXJV9ryYwo/zMJYvbBo2wN6AdyPzSErH5/XNVMMdpviczByM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB8C81516;
	Fri, 27 Feb 2026 08:59:37 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0172B3F73B;
	Fri, 27 Feb 2026 08:59:42 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 04/17] update_headers: arm64: Track uapi/linux/psci.h for PSCI definitions
Date: Fri, 27 Feb 2026 16:56:11 +0000
Message-ID: <20260227165624.1519865-5-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
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
index f270a574..84d3d5ca 100755
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

