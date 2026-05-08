Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3B421F0B;
	Fri,  8 May 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778262895; cv=none; b=B3yV4ddwwZVviChvE4KHmWKi3Tx6plAqh+P7DQU1hIwNmbhTtqZvXJHF5n45SMbASst+MRgCj2rfPnSISzjw//Ujgk1H8xDoMRwvzcFCyS9aMdQqaiAmTZBWAQUL7NljGghMv/jzTpImjUGKih5OaMGtsNfUVy9wBDWdg0TlXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778262895; c=relaxed/simple;
	bh=/aEr/2bl24rcHpe9c/rW9BGCQVs8Vg6IaLcMsIwTuCQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PErSkRdHM1P8UQqP7JEkAVwL3mwX+xzfdi4IXzyVT+8ZpMefvwZAmEHBfFUuLL98I8t3j1f1JGdfTTn5WsvRv5kSdGn9M6wBrbKEYIXaMUmsR86QLTHDeCZj8KfFvKN00ifcKBOCQSP/BwPslGTwq9gkkTLl42aGLa3TezaequU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndN56qyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndN56qyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A06C2BCF5;
	Fri,  8 May 2026 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778262895;
	bh=/aEr/2bl24rcHpe9c/rW9BGCQVs8Vg6IaLcMsIwTuCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ndN56qyUqTs+ESpRsl3NSQPAcyFXCT94hgHpwL7EIhSbzah5StjeDU8Ll58UtHaBP
	 ma3w2CiGVaFY0Q0zKvvBJCDgbzTAzR8pHAHQWMMGkYqIGUUnGRE7nYiTN13E+E8BaP
	 u4hRvuTDUSHLbemPqVGlGqYYOXCZBHCVDkhsuy5VCoBk1L++sbHclUXnuW8KC3zSfU
	 QT8rSe/GCfm7+M6yX+QckmUCENMJCQffoPQi6xJdxO16CaKfKJKXpdQsOLWGbuC50y
	 EuUxL3jKhuEzg4Mb0O5ZXJqUpzyYR4zRbO4cZF2CaAVKCYOY7AaGIjho7zehSkoHR7
	 IkRIV3aVGllSg==
From: Sudeep Holla <sudeep.holla@kernel.org>
Date: Fri, 08 May 2026 18:54:18 +0100
Subject: [PATCH 4/4] firmware: arm_ffa: Defer probe until pKVM is
 initialized
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260508-b4-ffa_plat_dev-v1-4-c5a30f8cf7b8@kernel.org>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
In-Reply-To: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev
Cc: Sudeep Holla <sudeep.holla@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.15.2

When protected KVM is enabled, the kernel includes a pKVM FF-A proxy
that sits in front of the normal FF-A driver. The proxy has to perform
its own FF-A version negotiation and setup first, so that it can mediate
subsequent FF-A traffic correctly.

Defer FF-A core probing until pKVM has completed initialization. This
keeps the normal driver from negotiating the FF-A version or performing
other transport setup before the pKVM proxy is ready, and lets the
driver model retry probing once the protected KVM state required by the
FF-A transport is available.

Suggested-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index e9d7dc71c06d..1fba064c2aba 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -43,6 +43,8 @@
 #include <linux/uuid.h>
 #include <linux/xarray.h>
 
+#include <asm/virt.h>
+
 #include "common.h"
 
 #define FFA_DRIVER_VERSION	FFA_VERSION_1_2
@@ -2039,6 +2041,10 @@ static int ffa_probe(struct platform_device *pdev)
 	u32 buf_sz;
 	size_t rxtx_bufsz = SZ_4K;
 
+	if (IS_BUILTIN(CONFIG_ARM_FFA_TRANSPORT) &&
+	    is_protected_kvm_enabled() && !is_pkvm_initialized())
+		return -EPROBE_DEFER;
+
 	ret = ffa_transport_init(&invoke_ffa_fn);
 	if (ret)
 		return ret;

-- 
2.43.0

