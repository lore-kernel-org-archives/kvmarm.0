Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4523DD851;
	Tue, 26 May 2026 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779791818; cv=none; b=KCYDZtfWfWxNzBM8mk4KA5YAb5TiVXFbACDH3OE5wRVd6hX6jdiULJ6BxizM0F6bY3z8nnIShhPmy8FpKL4RYH1az6RvFI/iQ7PMA/s3AuTCsO7/BB5yiSou+vUZ5k+HbZWJV6yVZhszeTLDZm9LfnYAZEP8CJUOtxsp7S5E97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779791818; c=relaxed/simple;
	bh=iLYxHGoL9muR/yNrgELFXRs76PtdndHLpVN0ekYuB6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nDnCUxQL/mLE5rw8UfCGwPIGNSjY4+c1sF55wTRj8TdOs+hOvCajvuAGNSbOA9R6GfMvjTfCYeQwkm6v54TdJeZ+bg5ZT3jq0c9nWker7i4d38ANfny8kADqxRvVMviJwv6jtVvI1m2J8gq5HeIIAMXWOhX5XJNz3GGYeD4ESIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUBjDPw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUBjDPw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3ED1F000E9;
	Tue, 26 May 2026 10:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779791816;
	bh=tLvcVcVxJiONQZDgxDbkVAM4VnMTie9/jbe9M/yDzTM=;
	h=From:To:Cc:Subject:Date;
	b=MUBjDPw5TOxBUqpUnCixRmAF1U/HFE4mTEUZc9PGnYUG4t4cv+f4kBO4mo37Zuz5b
	 GlboD6KeBhq7WhpyvyT+lVZL13TO+SW1bCkbAB/uzs9GabJIL02LjZ+xac6+JEiKyZ
	 RVnMdNO+EXzWoq/xV2AgRL4exG933i5JmdN0Fg6XPFkIJX2eVDDbDWFpaAsR1UqstY
	 egoFTqjqX9DDT3UtoF5R0OkoDDVDPfyhqUNjyIC+GYqxFBkVlI4gfz5gj0WtI0fa3a
	 N891nq38gcl7N6odS/4DLUx3Y1+kqHNIpDxBbpMBjYpWKhS5YJRsnK8cc6I/W6cMuE
	 F/njRe1QBV1cA==
From: Sudeep Holla <sudeep.holla@kernel.org>
To: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Sudeep Holla <sudeep.holla@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] firmware: arm_ffa: Treat missing FF-A feature on a platform as a probe miss
Date: Tue, 26 May 2026 11:36:49 +0100
Message-ID: <20260526103649.5684-1-sudeep.holla@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When FF-A initialisation is driven from a platform device probe, systems
that do not implement FF-A can return -EOPNOTSUPP from the early transport
or version discovery paths. Driver core treats that as a matched probe
failure and prints:

  |  arm-ffa arm-ffa: probe with driver arm-ffa failed with error -95

That is noisy for a firmware interface that can be absent on otherwise
valid systems. Driver core already treats -ENODEV and -ENXIO as quiet
rejected matches, so translate only the early unsupported discovery cases
to -ENODEV. Keep later setup failures unchanged so real FF-A
initialisation problems are still reported as probe failures.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20260523001148.GA1319283@ax162
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 54984e1b9741..0f468362c288 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2109,7 +2109,7 @@ static int ffa_probe(struct platform_device *pdev)
 
 	ret = ffa_transport_init(&invoke_ffa_fn);
 	if (ret)
-		return ret;
+		return ret == -EOPNOTSUPP ? -ENODEV : ret;
 
 	drv_info = kzalloc_obj(*drv_info);
 	if (!drv_info)
@@ -2117,8 +2117,11 @@ static int ffa_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, drv_info);
 
 	ret = ffa_version_check(&drv_info->version);
-	if (ret)
+	if (ret) {
+		if (ret == -EOPNOTSUPP)
+			ret = -ENODEV;
 		goto free_drv_info;
+	}
 
 	if (ffa_id_get(&drv_info->vm_id)) {
 		pr_err("failed to obtain VM id for self\n");
-- 
2.43.0

