Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121926A08B
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 21:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938806; cv=none; b=Fge+n7MhIvg1tqvRp4CSXG2fC/4lm1hK4rTnxXiHDraSHiT3YOYXzOyiSFDseL1kZtceUmd9a+fnz9G2Qj6o8U0i0ctNlcEKGldwwY/8MgzJPoJw5Tf2I5eu56mNlFUqdbDAcC+ezPTNAHC3WkraAs2zWv4Ik0Q2gieDUEpGGJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938806; c=relaxed/simple;
	bh=iQgGYAz+QPP5HbflwSDAvegeWKIlJ4QeMpJW4l9lAGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hOPkVp2MD8kmU65Mn8pP4S9JeVl3lw+L2LNP6zFgepVYw67elUizNTzbWyFot4QkBQEFf7g/dDcBVGMzRL2KwKe23v+h1ZRGb7llR3qPQybQMUwQ+hW+uWniofXNnTn8xbP6C5W2pYbS/WOCfs75D1UIhDTE9DTdBFolZJaWOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TOz65J7e; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TOz65J7e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnVnLC+BrbTLwQ/rBq8l+CNs17j9rpKS2l4jwwS5bH4=;
	b=TOz65J7eMMK/K34No8HlsBClhdnf0vJTlCQ9+5UATrr9TSnmptGuFQNHjhJYGuZdWUZ3I3
	TGkAQ27J0yuVNjMCcVhkwreMfWAnCHf6TnDaAR7cieoWaj681JKnFTHToQTZGY7ElvsS/1
	0UqSgIrOV6I49dRniEsjh0S2IEGfgkg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 6/9] arm64: Move remaining kvm/* headers
Date: Tue, 25 Mar 2025 14:39:36 -0700
Message-Id: <20250325213939.2414498-7-oliver.upton@linux.dev>
In-Reply-To: <20250325213939.2414498-1-oliver.upton@linux.dev>
References: <20250325213939.2414498-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the remaining kvm/* headers into the top-level ARM include path.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/fdt-arch.h         | 6 ------
 arm/{aarch64 => }/include/kvm/barrier.h    | 0
 arm/include/{arm-common => kvm}/fdt-arch.h | 0
 3 files changed, 6 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 rename arm/{aarch64 => }/include/kvm/barrier.h (100%)
 rename arm/include/{arm-common => kvm}/fdt-arch.h (100%)

diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
--- a/arm/aarch64/include/kvm/fdt-arch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef KVM__KVM_FDT_H
-#define KVM__KVM_FDT_H
-
-#include "arm-common/fdt-arch.h"
-
-#endif /* KVM__KVM_FDT_H */
diff --git a/arm/aarch64/include/kvm/barrier.h b/arm/include/kvm/barrier.h
similarity index 100%
rename from arm/aarch64/include/kvm/barrier.h
rename to arm/include/kvm/barrier.h
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/arm-common/fdt-arch.h
rename to arm/include/kvm/fdt-arch.h
-- 
2.39.5

