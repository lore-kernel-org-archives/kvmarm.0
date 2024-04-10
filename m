Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FEF15EFBF
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712762709; cv=none; b=kC0SVamTfUQZrcLdZnHrz2+oezT/rWaZkgvwRnJM1YyivclHakk/9f9zFomGjEzrGZDRc4wF4q/vHQgraYXqA/D+peWhkK07ttL4tBewQX7qtYEbKh7MBvoEeSujpQm9KERkMNfNzgyeMEleTsqrGRsMCpOW/i9t05IvrGjHBE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712762709; c=relaxed/simple;
	bh=Hht44JLFsiMQUkvhytN6Eyj8nL8xWpQuS1dv81Yser4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rPReOU5izicdblWViU6POQJHQ0z+dyoqbZg8MxLXikaAx6xu7I/kNIH+BInhMtQhW8/5Onx3K5+7FLShReoDFcHwBwJFE6A6aUrJRHfUrkoi2gGhVHR2+bSB61TENgzTmO55ekBEDYRYOjFgjXh8bIxlNT89rPYCJCjJdxQFEYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ex8KdBrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ex8KdBrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDA2C433F1;
	Wed, 10 Apr 2024 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712762708;
	bh=Hht44JLFsiMQUkvhytN6Eyj8nL8xWpQuS1dv81Yser4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ex8KdBrWWR+0k4l/fi0Ad+Hft9ECV8sGHKXJquKjPbDeGB9+1DIJkU3WlCHY8rLyx
	 blNSCddw0xY96kPzAKFRXiqlTGeH/v22Me7bqcwpCrANcEXtJgsGvBQkFO94UMSikN
	 KLlyumuuLG/zmEn+JI9iX7KNniDJHyJ8/7dfc4/xPp6ncJVDfYwy7QtYPneof0dR+n
	 jMgbumFlGRyLNtJZ16MpwBWbFJlXLa04CUEtXNfewTddZ/njC2rcuocM8GKksCNlC0
	 NMZ+hGcXvi4rTuLii6qjhFsds8WWo8HB5XMXIWNL0nBS3qJfsrwnxjnqGCgFDoukAh
	 t1Q0tVtCyF8Ew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruZow-003CCn-LN;
	Wed, 10 Apr 2024 16:25:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Improve out-of-order sysreg table diagnostics
Date: Wed, 10 Apr 2024 16:25:03 +0100
Message-Id: <20240410152503.3593890-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Adding new entries to our system register tables is a painful exercise,
as we require them to be ordered by Op0,Op1,CRn,CRm,Op2.

If an entry is misordered, we output an error that indicates the
pointer to the entry and the number *of the last valid one*.

That's not very helpful, and would be much better if we printed the
number of the *offending* entry as well as its name (which is present
in the vast majority of the cases).

This makes debugging new additions to the tables much easier.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a23f4e935a2e..60f548d8572e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3920,12 +3920,14 @@ static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 
 	for (i = 0; i < n; i++) {
 		if (!is_32 && table[i].reg && !table[i].reset) {
-			kvm_err("sys_reg table %pS entry %d lacks reset\n", &table[i], i);
+			kvm_err("sys_reg table %pS entry %d (%s) lacks reset\n",
+				&table[i], i, table[i].name);
 			return false;
 		}
 
 		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
-			kvm_err("sys_reg table %pS entry %d out of order\n", &table[i - 1], i - 1);
+			kvm_err("sys_reg table %pS entry %d (%s -> %s) out of order\n",
+				&table[i], i, table[i - 1].name, table[i].name);
 			return false;
 		}
 	}
-- 
2.39.2

