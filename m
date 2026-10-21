Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792570941;
	b=yaycjQ8zFJOwnQepiMe/6FFba6D1FAamy6NEeccceosTm40sS5Xn3WkuZhGiVg+x+1qq
	 NZwv0FodMSElGxSORbTFmxpWWvwOHYGboI+bNKd94OjXXWxNYCdX4PG0R4EIuMeecWMhb
	 aRkgQVJX2RWlxozKK6raOGP/8rpzKMcyoITeruKHfqcV7G4xLWDBX5ctrSfhGEPwg3NDD
	 OgTrICFCewrIq2gzILdAd2yfmX4wMGV7bFxf/zJEt2NyFOLUHLMrmyOXktmz+V9rL7yYk
	 Owuf9UoVRRHKqPItOqERUc4wGUaWf6h7Z/MkyVGsOuUyAXmfXTIOc6hgkcnwOzPPkjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792570941;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zRu4spBthg7fz/wTpeQjsyF6+hRLpSrvVHTyZtMUl3w=;
	b=jW/2uVbIInTLYkBfuPo4prUJBSdRK+GPeal0g77VVO80/9tH/O+D7p/Din+0leUDaA0V
	 gsHhLiCcpbBIHeTVGRrj5KtRmRTkqVGzXQDTMbdNW8CmbBxjn91GzXHl4W8IWwJVLy/oO
	 O7+9jfZ2J98128sgadeh6Vz9XVBkFIW3RcFf9Krkm0DK6YDrb9+kYA/k+TiVfJEVOQFqT
	 JD0R/yu/k0z41EFLmciCXZDT91aqvvdphRO8J03RWkoCwZtwt5p/QjyDd3ngsBwY6VvRk
	 iK3bz6GUvGgLEMyf2jU7Ar3vbSrnrBwc4suWg6Rgh/Qlxk+kQBWS74h6JpLO75pqq0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a8A2Q5uE;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4241A606A31A
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 08:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4241A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a8A2Q5uE
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AD871596;
	Wed, 21 Oct 2026 01:22:16 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82C533F7B4;
	Wed, 21 Oct 2026 01:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792570939; bh=AMqPkWKzj1+68mhTDS/Hj4pDsMMWxqm4w8Yx3mtFTGA=;
	h=From:To:Cc:Subject:Date:From;
	b=a8A2Q5uEeYc3MBqt9ou/y584mD9rIEgzEi9SUGxVz7OxdpAVf94wmadF9JGKgAUtY
	 WAOqkTXCjzzQ+Ef4jhnP1HcYCvxD7BoQ8VXkwahlOKtuVDKPKM4qjunk9QlIlwAqGw
	 HgUjxBi5rgF/vGCGX0p5Se8PP6ua7DkVJJvgVmLs=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: arm64: gic-v5: Drop unused addr variable
Date: Wed, 21 Oct 2026 09:22:04 +0100
Message-Id: <20261021082204.1494581-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
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

vgic_v5_has_attr_regs() assigns reg_attr.addr to addr, but never uses
addr. Drop the unused local and assignment to avoid a W=1 warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610210232.uzFGXnjw-lkp@intel.com/
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-irs-v5.c
index 1874c3c289a6e..8d0ad74ebc64a 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -1134,7 +1134,7 @@ int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 	const struct vgic_register_region *region;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
-	gpa_t addr, offset;
+	gpa_t offset;
 	int ret, align;
 
 	ret = vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -1142,7 +1142,6 @@ int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		return ret;
 
 	vcpu = reg_attr.vcpu;
-	addr = reg_attr.addr;
 
 	if (attr->group == KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
 		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);

base-commit: 678f16b6e4767096aa3e3e6eef60e981b3f61e12
-- 
2.34.1

