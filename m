Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4493BF679
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268816; cv=none; b=LKZYXbX+X+FTja9DlUYVHiIPHotw54nj48ejaRDpRs7SEAoQB6seI2KScjacqjHpANDWkqa/bIxEj2dSsOi9bHzWVeqxOtQIYmC7pidYDFHbva9b44mypDyG5Momzn789mCU2SK/iaHI+5rArJbnpCZOTJ0OxBwwm2IyqwbCcuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268816; c=relaxed/simple;
	bh=U0eWKEa4cjU4udQbu1goz+j8RnQyKR3jtcZ83vvYV+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMFco3p7BoQHb4zgrUjS8DvUu5FSQbt3moa7RLm6cD5LrNkBxNzmGe3u3k+aNfw+afB4qJHzghJ+6E7LBb48IYG3xmfgKcCbhMvpx11FpsqH67rdBmrfu2UvAiyDKWvC0L7/aVo/gNFCbWlXWo0d7ZtHzMS8gsY3rmYgAIe9biE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DD+e1+L6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DD+e1+L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659011F00894;
	Wed, 20 May 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268814;
	bh=+Aaw5mD9iL8recbssNlmMEcgLUSzQXou6BmaYITDAlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DD+e1+L6qpqNXQcVgtena1YUtrPaRkpEyjE4dnQ9oBdZDR6f+31IHX4s33+VJyyeB
	 +M4R6tbXJpr3ceaRagBfocQqO8ajN1FhdWuCHwdVyiKISCsmwAszkRctDbQzWOoMjH
	 COzCtkVhAKODsI9WPZVw7GK0BpjRDbJjj/GcjWdwKuKBjIiJNMzO1SHCKWhsmL6o8l
	 252fm8Lzm96sYfFkHFDZKprdaEAk2xXlY4gL29QwyG1YFo0D9kXiHpIUu6VIKxjXL+
	 KC2uE9NrcSd9kX3BoTHsGe0d91AipP7rCz/G6u+X9iUmMqXYKfFMShbJA1iQxYZS5t
	 qufKOX5rgvi2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd64-00000004IaV-31KH;
	Wed, 20 May 2026 09:20:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 12/18] KVM: arm64: selftests: Add missing GIC CDEN to no-vgic-v5 selftest
Date: Wed, 20 May 2026 10:19:43 +0100
Message-ID: <20260520091949.542365-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

The selftest mistakenly omitted the GIC CDEN instruction from the
testing. Add it in.

Fixes: ce29261ec648 ("KVM: arm64: selftests: Add no-vgic-v5 selftest")
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/no-vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/selftests/kvm/arm64/no-vgic.c
index 25b2e3222f685..ab57902ce4293 100644
--- a/tools/testing/selftests/kvm/arm64/no-vgic.c
+++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
@@ -159,6 +159,7 @@ static void guest_code_gicv5(void)
 	check_gicv5_gic_op(CDAFF);
 	check_gicv5_gic_op(CDDI);
 	check_gicv5_gic_op(CDDIS);
+	check_gicv5_gic_op(CDEN);
 	check_gicv5_gic_op(CDEOI);
 	check_gicv5_gic_op(CDHM);
 	check_gicv5_gic_op(CDPEND);
-- 
2.47.3

