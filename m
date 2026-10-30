Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343382;
	b=M/pTue6b/zAS52zQleYtfK8nbilVekaA4qT0cXYxlnyEp55mZXlAfPCe7JbmyMBX+GxP
	 x5h6Bv00Yt4yit8waq9Xon6IGV+994yRdEbuD2y7hRRuz7NoIXu/4d/IUqaJffkvsNHnL
	 NTtIsSZnm8Q7/xXZoh081l5IvQJvcYarF8bg2OEsFtj888JhDOW17yKvFLQ4EOsZPmPrg
	 D6xLidbH/lKDsP5O2+vYSrSQjMlfxK1wCSFYU+cpRKZmv1eB322HDcsackeRn8y3pG4T/
	 cjrKMi/q0X4xdIxaNdpJcoMqyF+oth6tYvq2Dnh2H69njZIRrFuujTDunLNnvEVN1Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343382;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=DDTZCgeXRZrOdO0H7W205aFqDmAAtb4mFnHHlLSHJyg=;
	b=nnIwFEFsNRms6f7yfs7jnrdd7/4G4ixVXns2TGMaxVi3AO1Tw6eutt8a+JSdFQLPLR55
	 asBRFNGzPMYVMjG4YA69CMMopFSaCn/7KbFBo10rIRJAhUqxy2s+4TrrZHiT0lchKxiwp
	 BSjTwo7EwsDoumO//FkBJ21V0/Km/JygKBO1HjLdoE3Yw4w0Gx7PSh/2DFRiqIRbCep+A
	 4xthnpqvoSw/VxzdiiG/y45Ihdj2Vsmh2802iLop5ARuYdiVtibDHWQ1nkSo4rLDHlSJB
	 aZrODvB33QY78PwaplWzUExNE5/MKth5I9/eBrAkDqI9zGP6EmPLvc9KlXzmZ0nwwSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="rd3Uzf/l";
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE7606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBE7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=rd3Uzf/l
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DDTZCgeXRZrOdO0H7W205aFqDmAAtb4mFnHHlLSHJyg=;
	b=rd3Uzf/lVd3dYMhpJWMGIofKdjoCrwY0qYGiyfdrjCFCu0d68gxIe6bHFtsBIdj3n7QOIwXya
	yMfpNKsjgLK0hdIgIr0ykKAimNSJXtsYKZ1a126BmhvxAuXvmEY+aDLxfrm0vVGxfWU6J+de9ku
	mB1+lEy6T8RyLkbphvL+MdM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jGBhV3sZhzLlt6;
	Fri, 30 Oct 2026 14:56:10 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 31A144055B;
	Fri, 30 Oct 2026 14:56:18 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 30 Oct
 2026 14:56:17 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-doc@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<kristina.martsenko@arm.com>, <pbonzini@redhat.com>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <prime.zeng@hisilicon.com>
Subject: [RFC 0/6] KVM: arm64: Add support for virt TLBID
Date: Fri, 30 Oct 2026 14:56:11 +0800
Message-ID: <20261030065617.4090073-1-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

This series adds virtual TLBID (vTLBID) support for KVM guests, built
on top of Kristina's TLBID domains RFC [1]. It lets a guest use TLBI
domains of its own, translated by KVM into physical domains via the
VTLBIDn_EL2 registers, so guest TLBIs only reach the physical CPUs
where the guest's vCPUs actually run.

The series adds:

 - KVM_CAP_ARM_TLBIDOMAIN plus two ioctls to configure each vCPU's
   vDomain membership;
 - programming of VTLBIDn_EL2 at vCPU load/put, mapping vDomains to
   the smallest physical domain covering the vCPUs in them;
 - a guest-visible TLBIDIDR_EL1 with virtual domain counts, and
   conditional exposure of ID_AA64MMFR4_EL1.TLBID once userspace
   configures vDomains;
 - tracepoints for the vDomain load path.

Known limitations:

 - VHE only: VTLBIDn_EL2 cannot be written from EL1, so vTLBID is
   disabled on nVHE hosts.
 - No interaction with nested virtualization is modelled yet.
 - The guest is told about OS domains (NOS), but VTLBIDOSn_EL2 is
   never programmed, so outer-shareable domain TLBIs are broadcast.

[1] https://lore.kernel.org/all/20261001110655.461473-1-kristina.martsenko@arm.com/

Jinqian Yang (6):
  KVM: arm64: Introduce TLBID virtualization infrastructure
  KVM: arm64: Add VTLBID sysregs and update VTLBID(n) on vCPU load
  KVM: arm64: Wire up TLBID vDomain configuration ioctls
  KVM: arm64: Emulate TLBIDIDR_EL1 with virtual domain counts
  KVM: arm64: Conditionally expose ID_AA64MMFR4_EL1.TLBID to guest
  KVM: arm64: Add tracepoints for TLBID vDomain load events
