Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E394EDCD6
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165229; cv=none; b=mOWZ2zHcaRYh2KVkQj6ye9Jv+ccMtqz/9Rqv1Y+3tmGFK1JVO+fBlQtye9OpvrHmkQfPBJtpqBJy/e2DKunHV0c9JomwcMQ9k7bvgnUqedadN8TH7PFxlHhMqiW7gjA/JU7LuBqu2B8eHRn6U4pWr/ASr9xkl1+kfY3b8xeEUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165229; c=relaxed/simple;
	bh=lgIeBP7zYTUbSdT4/9hLmhO1Ik++O6dJecCJUmAmFEU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HdDygtyz2FQZuO6YZip9DsoC5TheZR9GfJxjEv3COyXxjCEdFkEEswD77QJYzh8WyVW/KHMXY8s1CNwIf0Trw25116W0VUafm2DxZBbaBQy9ulKZm5PQoKSfN/fKmfe6zPrgB/gHlbT5fbD4bEYeJbVPeA76LZzNGUSJxDT/S8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G5IICMnX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G5IICMnX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D92251516;
	Fri, 16 Oct 2026 08:40:24 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAD6B3F673;
	Fri, 16 Oct 2026 08:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165228; bh=lgIeBP7zYTUbSdT4/9hLmhO1Ik++O6dJecCJUmAmFEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5IICMnXMkrfMFTtae8ZS/2wJ3xDzVTm2YHPHF6vMIcgyyeMpyK6+iON9xAw8bFlY
	 wA+2+uE1FLOK73JQgf0qSyRnYhM4Bf9US9stUfluRFP9QnQPcPwmV5b4llaoKYLRsh
	 2+WcTeqd0zUObRye4rp4Sm1HEyknkw/pby39pPXI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 05/21] arm64: Track whether the VM uses GICv5
Date: Fri, 16 Oct 2026 16:39:23 +0100
Message-Id: <20261016153939.913764-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the selected GIC generation to interrupt and DT setup code that
does not receive the irqchip type directly. Set the state only after
the GIC device has been configured successfully.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 7 +++++++
 arm64/include/kvm/gic.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 5c8a33b5..c1bd0771 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -21,6 +21,12 @@ static u64 gic_redists_size;
 static u64 gic_msi_base;
 static u64 gic_msi_size = 0;
 static bool vgic_is_init = false;
+static bool vgic_is_v5;
+
+bool gic__is_v5(void)
+{
+	return vgic_is_v5;
+}
 
 struct kvm_irqfd_line {
 	unsigned int		gsi;
@@ -230,6 +236,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	vgic_is_v5 = type == IRQCHIP_GICV5;
 	return 0;
 
 out_err:
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 630f0bbd..991aa912 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -34,6 +34,7 @@ enum irqchip_type {
 
 struct kvm;
 
+bool gic__is_v5(void);
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-- 
2.34.1

