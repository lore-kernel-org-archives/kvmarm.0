Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534143E4AB;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020612; cv=none; b=jtlrXEoMFnOpLGQeKp5nr6d2lSkYe0jNtsv3qO+Qoa39tA8lRa2Em6AwZ1Z//VkocfEIGqwJ5irrIHDi+oeG1vc/PJwyopr9otFmQcaUYq41jIYxQssMkstNPUJzf0FJ99b3/ojOza5wQJ9b0ZckUkxRHbGEEKsVrOP0fD0VpGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020612; c=relaxed/simple;
	bh=SEvD3URA+Glwh5OyaIiOOIT8bjqwmBtVkDQKkVbONYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcuyPZmQEeGg/fRQ9JwMc/eldvcio+OkJZDUsrvE+CopV0gQ6d7dC8oi2BBXtHshfi1algseQCWdmGlZRJ+vUhNfLMe1wjKP/P+xj7Flw3+ewTQXeBYLAQrjWvj3jfSLOsNsMSTD7XD/wV2W06xTBwj1xH4rV5PCbsprW7EW9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yx3Ejh8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yx3Ejh8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C311F00ADB;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020610;
	bh=QDe8YvYJlu1JYh0yp9syTuhzrxaVjIvimEEjOf5rRHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yx3Ejh8YKk2/aQcptPAruCH3xU/zv6JkMjJjHJoEeGwigvf5bAcYbqua4n4nh7khq
	 V52K1qQzWyHZ8yaWuWfSjQHs5nwBWdyTPS1c2FeuQ657jZJPw6neuAId6XORuDHQr+
	 YagwhwCELfZajmnRjUEzf6fgas74MdUdZTta9+sUwCiWO8Q2qoT84zDbKqxjIM/u/u
	 CAg6xeFyKb5uaGiZrp7fpXasStmyqO7Q6mcJdPeT3ppBc1KXcfvMM1AeZkC44tMDzv
	 WLYbQ/2xjqVT7hYJMUuVg14THsDkhraqHlCB4K26LOulbEY2m1DJxAog7I66f5y83D
	 x1G9L/x0/qX1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFw-00000004ny1-2opx;
	Tue, 14 Jul 2026 09:16:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 08/28] arm64: Add ARM64_HAS_NV2P1 capability
Date: Tue, 14 Jul 2026 10:16:21 +0100
Message-ID: <20260714091641.1970822-9-maz@kernel.org>
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

As we're about to deal with FEAT_NV2P1, add a new capability that
will be used to key any support for it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/cpucaps | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd49..242dc211d8efa 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -51,6 +51,7 @@ HAS_LS64_V
 HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
+HAS_NV2P1
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
-- 
2.47.3

