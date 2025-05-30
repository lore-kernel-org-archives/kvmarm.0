Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F221D5B3
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748596619; cv=none; b=uJ/8GbXGIr+F8lZjXTIVxSyBOPmwTox1Itf4hxdArJEAXIHpC4tRC+tKXOz9WS67/mCRgUl0it5QGLiMaRu0fEwLDbiwswUfL827RHMJLkY2EdRgSJOKCeAyxBiVz2n0zNabqTUGg5uV9Z9DJBvpO8kVG0UpgAztN3kHQv8res8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748596619; c=relaxed/simple;
	bh=HcxD8NTz3N/DzXNiqUMva/w8nb456E8HfOoEaE1SAos=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ermE5/bvs1Yr39DTGkWaJ1j6sG5SrWz6D51VUws3X1T1z4VFAsqe+60yR9h38mobXzz+1GbSU6xTQ0v1nqtl4Gkf4iuN6SJ32+JcCAgrLHKhEsGa3jL7gzyujvsoUhISASA5k9sE2URDOowXYOZIzEQ4O7+QBwRjsFvl/yekKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISYAZEbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISYAZEbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBC3C4CEEE;
	Fri, 30 May 2025 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748596619;
	bh=HcxD8NTz3N/DzXNiqUMva/w8nb456E8HfOoEaE1SAos=;
	h=From:To:Cc:Subject:Date:From;
	b=ISYAZEbd9hSM5aT9ZALJd8ovz7fd4icYNneaqQlU4/HVoJV4XM2ts8Nm/iNKmb7dC
	 4mJAxksyPTECYVfFvdCNzqqPQ40SMGYjxfuOznQXWgn9VOPVTOEBQOlKB1xBpUq6cL
	 naqLBrZpAACyPlsOwbniHaimOv3yZlMiUDIoy6Ss2YDZp7U+LR2NBXVXuVXVNh2ODZ
	 zBSTJzi7vntSKcGrD/hbaNbYlgR2YH76WazQ2F0NTEGXjEfDzM3tdZhEKeU/XDQ48o
	 voawxo4jx+BzpnHtVYn/H67Rk877InzOQuoemPRp4UGFJz8Nw5rbldPiuimrNKbsLM
	 /MI5WwNJSoSAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uKvrE-001o5V-RZ;
	Fri, 30 May 2025 10:16:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jing Zhang <jingzhangos@google.com>
Subject: [PATCH] KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer
Date: Fri, 30 May 2025 10:16:47 +0100
Message-Id: <20250530091647.1152489-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, dan.carpenter@linaro.org, jingzhangos@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Dan reports that iterating over a device ITEs can legitimately lead
to a NULL pointer, and that the NULL check is placed *after* the
pointer has already been dereferenced.

Hoist the pointer check as early as possible and be done with it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 30deb51a677b ("KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables")
Link: https://lore.kernel.org/r/aDBylI1YnjPatAbr@stanley.mountain
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f8425f381de97..2684f273d9e17 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -490,6 +490,9 @@ static int vgic_its_debug_show(struct seq_file *s, void *v)
 	struct its_device *dev = iter->dev;
 	struct its_ite *ite = iter->ite;
 
+	if (!ite)
+		return 0;
+
 	if (list_is_first(&ite->ite_list, &dev->itt_head)) {
 		seq_printf(s, "\n");
 		seq_printf(s, "Device ID: 0x%x, Event ID Range: [0 - %llu]\n",
@@ -498,7 +501,7 @@ static int vgic_its_debug_show(struct seq_file *s, void *v)
 		seq_printf(s, "-----------------------------------------------\n");
 	}
 
-	if (ite && ite->irq && ite->collection) {
+	if (ite->irq && ite->collection) {
 		seq_printf(s, "%8u %8u %8u %8u %8u %2d\n",
 			   ite->event_id, ite->irq->intid, ite->irq->hwintid,
 			   ite->collection->target_addr,
-- 
2.39.2

