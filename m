Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798965;
	b=rheH4c6u3MH+pfwZ89NzK2m0z9KDAz+6HdLH4cfTVCpF8Q7NdI/kO8C1CO8NhxXZpZg9
	 YjcwlZYrUop4E+Q9srvfs93BircDynYKfXx+C0iyRqNZyb4WIsiDKpV0/Q3/iYfc8gjj4
	 NFBnDxvc66OeIiewAEmUiAvdDsihKMPmkjqz/4Wk5uiXsjVhWhzW8hgCdaLFefGLGxAHz
	 ePqjVOJ99IvqZJ/h6NcHnzwa3/IxdjCaJlK5FEqDm8N2cwWC3EUY2XEMpwCuVrB64xn3E
	 2oZFUss+i1K6U8r7EUJNd99tTV1lkCc9mk7N8nDuiYtBhBN8QSfEUsU6jFSdIl1LDRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798965;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qc2KqW9iBLhjyM7vsF2/P5cIj9EMFAU2SocRtrDBvJQ=;
	b=fJdgiajrA547auMLJEu4lW9r/6pf2FSOnoV96HYBEKx51y+CSw4KLiSR/WmSpYf55JiU
	 ttNsSyNyytP6jaVoEqo2FptG9qF96MNuTII9+7i/+N++ogoDiFPYY1nVCzW7PQMZuRcui
	 NzX3OhYxGYhiVyXeu3EidpcdH9abUIGDD58OkL8Y2+CE+IMqHD+5pTriyDjQZUZ3j9G2t
	 QmzNiHF8rX1zltrNBBXcnWyJjLyBVLS9wshbkoN4kN96+AL/omcMWju9xGWsrnXuRD+HV
	 wyFZFRbGcQTh3J3c7I//8VRwUVVHMafURTf71kHsuhi/xDWEr7xE4kWYemSr2iCg1ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jcqeKygS;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD3B606A686
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BD3B606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jcqeKygS
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD2DE169E;
	Fri, 27 Nov 2026 09:02:41 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 562A23F86F;
	Fri, 27 Nov 2026 09:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798964; bh=5FlDVD9NnLn10ENci5267qcAjjP7cku5WmE5C6fVETE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcqeKygSLPN+wAJpq+Vkz0Q708JK4imJAE8suy5Gimzu0Q5KKpaE66qMRUJQdzW3k
	 O/09mBLnXAx37yR2bujpUY+emh1YhPLSr2+JGPgugcQFpvEJXMspDvrdd/++WPKIV0
	 v3i+C03zwoPLI077QtxwIWPzGa2SCtkue338tkao=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 13/23] arm64: Assign CPU DT phandles
Date: Fri, 27 Nov 2026 17:01:35 +0000
Message-Id: <20261127170145.4138182-14-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assign stable phandles to all arm64 CPU nodes. The GICv5 IRS DT node
uses them to map IAFFIDs to CPUs; they remain unreferenced for earlier
GIC models.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                  | 1 +
 arm64/include/kvm/fdt-arch.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index b7324848..363b3ace 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -54,6 +54,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
 
 		_FDT(fdt_property_cell(fdt, "reg", mpidr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
 		_FDT(fdt_end_node(fdt));
 	}
 
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 8a0a460e..2b667c53 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -11,4 +11,5 @@ enum phandles {
 
 void generate_dma_region_prop(void *fdt);
 
+#define PHANDLE_CPU_BASE PHANDLES_MAX
 #endif /* ARM__FDT_H */
-- 
2.34.1

