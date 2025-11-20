Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA612E92D0
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763647540; cv=none; b=o9x/W9U2dT5vXVHDE+kKXc9eWECdcDxJjI3fe1upkZrhGROYDTbOHA0D9tpeW3Ta3/gCJNfIlpnR4e/HNwG4rEY9lnPm0fDRoQWD0ifXL2rQWFpepTNgie6VzIpji52/KR0LYkJvHKMceY8tlp9XYXXlkDArdoE45Icw5+JLRZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763647540; c=relaxed/simple;
	bh=36xiGiWAOVpodE00E4HNkW3d2rmSGVbeOyCrrBHTHXM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6FerfCp4/du6UKcS8GJN0TCDgS9weEWR3Plbpr4nevfY6kwwqtoVQFjcTFQhNxhy5IqaqJ5DTVQ2Pdql5AHWmlY+OL5tcQQ2uexbdMLwrcApKh0H9jmZxClr3zzJ4y0KNNb52hbYIoFfdcngkNqwNU9X0eF26DHF4Ex9IvpYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=ErDAnY7P; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="ErDAnY7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1763647539; x=1795183539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aFAQ5G6SeRazRA6pE/mTpK/FWyyGCqzO+A2GJFIOtY4=;
  b=ErDAnY7PBTDNnfBEb8qlTue1Tw2tIdvM/X6CeMReKRUoGSgUjbftWEls
   pSgk3/VGD+gaUOPg+1TCH7O+oaD+NkYKFw34QiYsij0j6qv69dvVXwL/S
   asJcn+cXAycFbisrSEhPTalNcdqSGenqNbn2/3OitOVnAfZHf7Jkx//MC
   A584IuInxzMnTt/fMJCP96mxZqndUe6AHjY54eyzLsEABeVnjx3MBgB2U
   +6XPcNxzAdQb663A7YnqdmceHiJDPkz/LiSHbXjovXGww0r47FytJ2fZr
   Zzz5u8UE6ZircJ2+u7jJe5rroXnhrrI9LoMOCgf/PGZiZrM4UrnzRFrf+
   g==;
X-CSE-ConnectionGUID: J/mEdwrhQXSmlG+bry7r6Q==
X-CSE-MsgGUID: +jVNHvYwTUK+fdgeYuajuQ==
X-IronPort-AV: E=Sophos;i="6.20,213,1758585600"; 
   d="scan'208";a="7244749"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 14:05:36 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:20739]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.156:2525] with esmtp (Farcaster)
 id 7a28a8a5-e14f-4fbe-bfe7-92e87adf30d6; Thu, 20 Nov 2025 14:05:35 +0000 (UTC)
X-Farcaster-Flow-ID: 7a28a8a5-e14f-4fbe-bfe7-92e87adf30d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 20 Nov 2025 14:05:35 +0000
Received: from amazon.com (10.1.213.15) by EX19D001UWA001.ant.amazon.com
 (10.13.138.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Thu, 20 Nov 2025
 14:05:33 +0000
From: Maximilian Dittgen <mdittgen@amazon.de>
To: <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <pbonzini@redhat.com>, <shuah@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <kvm@vger.kernel.org>,
	<mdittgen@amazon.de>, <lilitj@amazon.de>, <sauravsc@amazon.de>,
	<nh-open-source@amazon.com>
Subject: [RFC PATCH 09/13] KVM: arm64: Couple vSGI enablement with per-vCPU vPE allocation
Date: Thu, 20 Nov 2025 15:02:58 +0100
Message-ID: <20251120140305.63515-10-mdittgen@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251120140305.63515-1-mdittgen@amazon.de>
References: <20251120140305.63515-1-mdittgen@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When KVM_ENABLE_VCPU_VLPI is enabled, vCPU vPEs are
dynamically allocated and dislocated ad-hoc. vSGI
direct injection requires receiving vCPUs to have
vPEs, meaning we must couple vSGI enablement with
vPE allocation to avoid injecting vSGIs to nonexistent
vPEs.

Modify vgic_v4_configure_sgis() to validate whether
a target vCPU has an assigned vPE before calling
vgic_v4_enable_vsgis() on boot. Call vgic_v4_enable_vsgis()
and vgic_v4_disable_vsgis() during vCPU vPE alloc and free
within vLPI enablement and disablement functions.

Signed-off-by: Maximilian Dittgen <mdittgen@amazon.de>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index b7dbc1789c90..5d6694d366b5 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -198,7 +198,7 @@ void vgic_v4_configure_vsgis(struct kvm *kvm)
 	kvm_arm_halt_guest(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (dist->nassgireq)
+		if (dist->nassgireq && kvm_vgic_query_vcpu_vlpi(vcpu) > 0)
 			vgic_v4_enable_vsgis(vcpu);
 		else
 			vgic_v4_disable_vsgis(vcpu);
@@ -838,6 +838,13 @@ int kvm_vgic_enable_vcpu_vlpi(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	/* Enable direct vSGIs */
+	if (kvm_vgic_global_state.has_gicv4_1 && vcpu->kvm->arch.vgic.nassgireq) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		vgic_v4_enable_vsgis(vcpu);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	}
+
 	/*
 	 * Upgrade existing LPIs to vLPIs. We
 	 * do not need to error check since
@@ -859,6 +866,8 @@ int kvm_vgic_disable_vcpu_vlpi(struct kvm_vcpu *vcpu)
 
 	downgrade_existing_vlpis_to_lpis(vcpu);
 
+	vgic_v4_disable_vsgis(vcpu);
+
 	return vgic_v4_vcpu_teardown(vcpu);
 }
 
-- 
2.50.1 (Apple Git-155)




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Christof Hellmis
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

