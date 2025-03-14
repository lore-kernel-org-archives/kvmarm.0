Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F312204F99
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991682; cv=none; b=FWx1tm57oZybVQvMQrX8PmPCPiXgKuvGDoK2y9iBQtyvSIXukQXJgZUIqmiohUGgVjvm4fjnBjCKQ8EI35TcIoSPyfuJhtYM6wU8vceTemjYsYSCCfW9AX6MWbnbK9+wSxFujZG1Kt1JA1ie6BaQMiVWd3KJAXaC6rR0ibT1cWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991682; c=relaxed/simple;
	bh=2Pbd+iBgLt8A0/FD4aGok3fNr8aJQIAaDsC5FWNPazE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fAHEwQuhkcz5mQv2jzwFTW9jIzFH2rCOuIDU3xjtVKfs+8d2vtvRdlcBj4Ah/W7K5BnTRZICIQSEix0kAXwHhGcgUnuaXJUfw4No/7oTo/D5NXyX7qZqE/9vp6tvL5m4J03lAF9BjsWHcrjXqGNOoMcva07o51sK29dxVL3dyAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q95cy3sq; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q95cy3sq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJir3LtLO9hm6l4NNlQH2wFwoWgwEwtk7XE/avmP+jA=;
	b=q95cy3sqcfcwHOPC8GLaPSb8acBAZwnjx5xC0kzY3P8XagssBxXwKFuKjWS3miduBFWUwP
	V96Pb34R9sLeUb5IwiqXVRs9tZM2i2mm1zTmLInr8R1gmKqg9Nj6c4dFO64ECNJqpLzpfV
	Vuu4m0uUZBWyn6ZLaenwOiJmd4CGf7U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 7/9] arm64: Move asm headers
Date: Fri, 14 Mar 2025 15:25:14 -0700
Message-Id: <20250314222516.1302429-8-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                                    | 1 -
 arm/{aarch64 => }/include/asm/image.h       | 0
 arm/{aarch64 => }/include/asm/kernel.h      | 0
 arm/{aarch64 => }/include/asm/kvm.h         | 0
 arm/{aarch64 => }/include/asm/pmu.h         | 0
 arm/{aarch64 => }/include/asm/sve_context.h | 0
 6 files changed, 1 deletion(-)
 rename arm/{aarch64 => }/include/asm/image.h (100%)
 rename arm/{aarch64 => }/include/asm/kernel.h (100%)
 rename arm/{aarch64 => }/include/asm/kvm.h (100%)
 rename arm/{aarch64 => }/include/asm/pmu.h (100%)
 rename arm/{aarch64 => }/include/asm/sve_context.h (100%)

diff --git a/Makefile b/Makefile
index 25ee9b0..3085609 100644
--- a/Makefile
+++ b/Makefile
@@ -182,7 +182,6 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/pvtime.o
 	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
-	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
 	ARCH_HAS_FLASH_MEM := y
diff --git a/arm/aarch64/include/asm/image.h b/arm/include/asm/image.h
similarity index 100%
rename from arm/aarch64/include/asm/image.h
rename to arm/include/asm/image.h
diff --git a/arm/aarch64/include/asm/kernel.h b/arm/include/asm/kernel.h
similarity index 100%
rename from arm/aarch64/include/asm/kernel.h
rename to arm/include/asm/kernel.h
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/include/asm/kvm.h
similarity index 100%
rename from arm/aarch64/include/asm/kvm.h
rename to arm/include/asm/kvm.h
diff --git a/arm/aarch64/include/asm/pmu.h b/arm/include/asm/pmu.h
similarity index 100%
rename from arm/aarch64/include/asm/pmu.h
rename to arm/include/asm/pmu.h
diff --git a/arm/aarch64/include/asm/sve_context.h b/arm/include/asm/sve_context.h
similarity index 100%
rename from arm/aarch64/include/asm/sve_context.h
rename to arm/include/asm/sve_context.h
-- 
2.39.5

