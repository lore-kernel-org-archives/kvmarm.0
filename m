Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6D143F8B4;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020613; cv=none; b=pDMGKSCugFpB+Y73R4l42vUAYOYFHF2nmlQ1Xe3NSe6J3vYehcL5yc/L+T3pdNaKhq5PJiei5EHLJZlKlxQSjv62oSEc2HZkr8s9RAEXXEF1U2yf0vhRhrFAOnF0ZwBp6WyF1OsWIkG2To/af46kqLzTE7veyPhQSIEXXdpZrgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020613; c=relaxed/simple;
	bh=rUcyN6uAGe1vOQ9GUqQn+mE1kPx8Ir0yEVvo3/IzGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USrrUKW+eEScRk7kjWiMiZFl6mkigST2FCUF/UhxgUwAEDHaGVsXI75athoQlw3C6za8AOjBhADHOxfgfTBDimGcQ9TRhq6w40TqHjgaAFNwRcoUTjcMjcHVP98mjnEn7T5tb8ECqezQMe45gXypDnMquSU0r2zbidgv28BKLlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5X5Gyy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5X5Gyy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D469F1F0155C;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020611;
	bh=xoiK/RNeZLIkLzyKO8ly8OA0RZ+EXunPBVOADEEok6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5X5Gyy7WQJOWp4rCnsnnDsBP6sG/qRDb5qbJJsSPoK1fruyi2PX6dOWfe8XnIDcX
	 rQry0/sfsebagdicEuuvML/Aliwa+rvm6MsvpSAuV7+PKFpGSarzxCXF7NwyRxabdk
	 zsDo/0QOHhkU6X+tNzvI75bc3KVKEg4ZSs2R6MEJCo6QvGC+8EKH5bUefd77LR3CSX
	 jTJEIksaCWKpW88SWWTSuu2KhUI7q/mmgembmvZ8WAuI36r0TkzNXx68ncx11jIjJG
	 nYHtlT6u7jJP6pBAyqZowC9v2rhD1X5iTp3gZYC8tvTSnU/B+qnN5TkXqtl8Vznln9
	 6tCKQ2Yh/+MVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFy-00000004ny1-0dcu;
	Tue, 14 Jul 2026 09:16:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 15/28] arm64: Add ARM64_HAS_NV3 capability
Date: Tue, 14 Jul 2026 10:16:28 +0100
Message-ID: <20260714091641.1970822-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As a bunch of KVM code is going to depend on FEAT_NV3 being detected
on the host, add a new capability that will describe it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/cpucaps | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 242dc211d8efa..7e0414509e89a 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_NV2P1
+HAS_NV3
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
-- 
2.47.3

