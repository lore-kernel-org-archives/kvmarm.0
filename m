Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2038.outbound.protection.outlook.com [40.92.52.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DAD1799D
	for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.52.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721878091; cv=fail; b=AB0jlsEr7Tq3v1woKsfxFXZ/mBd13jTqoSO9uEQtYNjrNPtp4tthCdIY9lK6/PvimrnDdEy06m5QXbkJrrvfWTjWeCCSrFXR9zSOCWCri++IkabNJumdFSaedMLICUbh9GkUgnKj/sb/2Cths8qR6X53QoRCP+Bw+vNdjlGDrds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721878091; c=relaxed/simple;
	bh=hnd7Z1jvHr5cWHL4/xrVjBbV1XdQvH1p8GJtur1Oxus=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kTgq9L09YT6RjuvrVpjY2N8rRXnJ0luQyolQPVuTm3dWtKO1XddBYvv55f1PDx4D1+WSyOWG9/uh4Cg3+SBKGsAd9w7P2SHR9s0SScCWD+sLEgxVsNqUJpNbQ+quuoecmVzE3pGJ/fIEbfKP7aPlXs7RsJh6LDEtliaRCQ+06w0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=NG816zmz; arc=fail smtp.client-ip=40.92.52.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="NG816zmz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZ2TyA9lczk+mJ+eWYav0uM6fhUnQEntvDvXZBJklZzb4ylHDKX+Gx//QqPQIxd2oKWa1G4BTepu7X9zI6Ito6tAFCJjHIAg9IL9cPVCTrQt5h89s3tBTFK4xFGyDjVfe0Z36M1vC9qidivAVysdFSq+wlfaRMY9svY/Xf830qS8st4nRSbnwQhb5rgG8aIfuNav1+c1QMhp9L+p2LwhyF39ity/jc6+QdusuVZhxXAttooJw1xscmdgAodSwUW/fOufjj684TnGtKVP0Nrbi9+ObbrxZQbMA0vCv8eNgxv+6MZOiwCVv5ZTbhTTJT78qsS3gMGLP3KsrHWDr5Y7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK6ql6RUeiHAjpXwaDuKCmVQev1+txBX3fZ4/pffEoE=;
 b=r9e+e6mbzi7EshtFDwu+96OpTVQ1bcu9DV8FT01pOHeQyQzB5RDkQIqvh4n5xdEFZHNGqBjOTPDbK1rAoEvzh95hxmPCx4luhqRSV0Z4hlNQmpdBgM1GDxs9WWo4gi+nqjAhTvnr8dHi572UjWwhk2N/wozM3utPhQ/QwapnINLNQtXWu6ViJZXFnkzgh9a8AQZjh/ZtRaKGDnBqfIN6/f1DE/G6JKSu7z22Q5+2Yq5dkhxXG+LmOLwr1Wpe+5r/BPSVekjtZucCYBq08w3lD4SG2uOZR62Wme7XH9FHgcZjX6HiLO4ZRnq/I6T6frTPt19f/0bb3tw6Sgku/Ww14Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK6ql6RUeiHAjpXwaDuKCmVQev1+txBX3fZ4/pffEoE=;
 b=NG816zmzLwprvbTxMEgt3/VICFMsf2pP1CzuwkM7xabrh6zQ8Vok+qixXA+yQsghjB6gIsI14pTixhB3wKhdJwRKKERGr9yC4wgcG+hKkGFt+HomMywFxXXyL9mPQW2Txw7mndFz1hxwrW7hn/AkMRyVVMgakgdGEEddKtRge0iNn3mawHQU205EEKvRDWds68qqeeCtRHyH21jlqiAp2B/g5dfKzrAmkR1/pPMPxAXIww6es2qR6G7VGJqSgT1YqgjIS7BfDKzlGW2ZBAdbGWQjEivPZHoHdtMKI9c1I4NHLHeKy/axRBxa8z+B0Ya7KklemCIdWOsnIgIyPOh/kA==
Received: from SI2PR04MB4931.apcprd04.prod.outlook.com (2603:1096:4:149::12)
 by SEZPR04MB7339.apcprd04.prod.outlook.com (2603:1096:101:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 25 Jul
 2024 03:28:04 +0000
Received: from SI2PR04MB4931.apcprd04.prod.outlook.com
 ([fe80::a6ac:c945:13f6:e963]) by SI2PR04MB4931.apcprd04.prod.outlook.com
 ([fe80::a6ac:c945:13f6:e963%6]) with mapi id 15.20.7807.006; Thu, 25 Jul 2024
 03:28:04 +0000
From: jianyong.wu@outlook.com
To: maz@kernel.org,
	oliver.upton@linux.dev,
	jianyong.wu@outlook.com
Cc: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Add some statistics under kvm debugfs
Date: Thu, 25 Jul 2024 11:27:38 +0800
Message-ID:
 <SI2PR04MB4931916BB35936E00B2AD262E3AB2@SI2PR04MB4931.apcprd04.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN: [3uDDBjxRc9ULXREfj9a0Dt+nB33Dbith]
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To SI2PR04MB4931.apcprd04.prod.outlook.com
 (2603:1096:4:149::12)
X-Microsoft-Original-Message-ID:
 <1721878058-114521-1-git-send-email-jianyong.wu@outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR04MB4931:EE_|SEZPR04MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 369480f2-a62d-4e1d-4575-08dcac59cb6d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799006|19110799003|5072599006|461199028|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	w3TUph9v6K7YfZPa3lM/h3bCJZ2W0aUTiyUDjKqWBxCjGEh5hSzI5SE58eMng3kkRe/EJ9YszFQ51DEKzFl1utCLys+I7rWPHdi3glyZzlBmXARlWVvh5OFcvEGO90XyqUWLfhRxo1dEu0EyEv4dy36KGygWV8/5xVMmbDBvMEmuVvHREOBGMdrYQvPH+uqixqTnDM8pglhQmxBsluivvY1IykfgPrlIY56KNUNYy5SQBGL99CiocM92GNhrpue//3NIrtUFnEqNIkZsoODVWdx0Ga4alKXMwBB62GslZADQKbtBIisKoxG+K9cnJSZT2RldQTG20F5Bkc0pabHFvf4m++u/cdAz9G5mbb1A7gjNVsRGpD5R+FKRrxO+BcGkmrAS/0aHmZnWjq6zTgAN8PnZfwxVKMWVK+GwwBbzX98mcA+YowGcEWPjtR8HzFS17t/WhOqFUM/j+T03KzrzfB6XxX/xgAeJerjxdCQbJNMAJz2ZSD/4+fx95AbbUqLrva4lduPpn59IOVI96HuxCXwbPcs7AzF7bH6HAjtJTyAf245z0FSHwnFRKqoTxpGYQ9kUb8ipOBs3yJnQViewSZIqT1w9G6c4O09q38DfVYXJMMkfSbvfErQqY963o5pMK/bQa00NVlGlJ6hEBypjMMFSZub0GpcGl9dtMThJSE/1MAAJv7vchDwmcqvgnOpBnJomvfxjM4aWBwdlQRRlyw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KJhLcyAX8GfJ8eQIiXfPG/+XWUjCEWbtOuKIWJTLYCyuvhdu9JcT9+WSBs2m?=
 =?us-ascii?Q?U4mXpMh86ybsbHktt+vdHv6C6NaS8VItjn+ZDtOJsUA5OdkATkcA0BIBNZgq?=
 =?us-ascii?Q?tmdRrDm8Cx0I5SRbGzj1A4GoXqxjRv+hLHP5H86fuQN1Q+eiMAcCkKZGX9b1?=
 =?us-ascii?Q?IeJ2gc5uDvwGd1ycSRBHaE+qiXIATFxP6RYsTGB8NIXamnC297P5TSbmLZ97?=
 =?us-ascii?Q?woI7nacfa7YpqGwqBrSicfLr/exJ7zkz6eslyqKuA4TsiIeyR1lBhunUaAze?=
 =?us-ascii?Q?L2LlmIeV0zh+4js2avZn1/exRgUMni9MZWzvUSQ3PFNcZupOGAQY/BJuTKn0?=
 =?us-ascii?Q?BIzw8s5SiG2Wj+tXyrLEx3M52zdOZrg3oGVmMKlUtz/KBxILFBB9yi1Yk1yp?=
 =?us-ascii?Q?SzzGfPw/luO9KEibRq3JgkTBFInWqvv7/NaJJiTp6qmYkuQlM+7/tv+N29dm?=
 =?us-ascii?Q?oCRFRaIKh9PwcEYLvg8lLgku3Wcts6tAQs8guUzTX4JrL5r/3dcvySPel8tf?=
 =?us-ascii?Q?j+AwsmfjHp0XX+5Q+RDwpvfJigb0jxNvuIF/ISSNV1NXAEUdEcrjgLBm5qKT?=
 =?us-ascii?Q?v3hC4wX8kbqnQRe+NR4vL1barHbdAwBwWv3DX6F3YaWXC6g3yHGTl41CDFQo?=
 =?us-ascii?Q?XhiPvHLbLvN3fU7AvA1poQsx7ArYN4Amgtub80ym1/9b+hqg7C08/PBFuKFY?=
 =?us-ascii?Q?mDKg5gPJXQx1cwd/lm2PJNCdCVDrbJVV7luMnSo9K1tgZkqRy2H8iUIov8++?=
 =?us-ascii?Q?QWUcEpfTQUmK6lEXabqCdFmU/1vuBfeDTZOqtLOi2AHMFp4dxCrKiNWIaAMD?=
 =?us-ascii?Q?d9YS22FeyGJPS7FP8NcC/ls3R1mYZhVHCzCe/NUYzjIBj99BM1Eq4DnNGJ83?=
 =?us-ascii?Q?cRH/EkiENzcFXwJk11PaTn2g7aWKlJ+NuJ57/glfsR2Okeg3kYIIZpKha+jR?=
 =?us-ascii?Q?9XcX2q+8od4kHWKbE92livpp7Bix2ES8jAswDa2tVKiySbUjvuRMp0ul57Rs?=
 =?us-ascii?Q?dPTJCjHYlTx/T9YU6AiG60jTIDf7ibiIp97aMZI4GPXsp1zSCKaK0tS3dhwZ?=
 =?us-ascii?Q?mIkwxH8NFZI98W70RyzvzLEOX2NbPy9sjOTHnXQiWvUkYsbuXGvDvtohD0w1?=
 =?us-ascii?Q?4S0gJSqSWCDHnAMu9Qiqtxef/HjLmvGugAK6nLrlX4lY7FUO5kbbaNGNc1kh?=
 =?us-ascii?Q?h0T7JvmyccGm3lv76YqcVWbBt23lbGaBUD8AXBxw3gVB14qeapXXYkQyM+y8?=
 =?us-ascii?Q?HTpgRLWigmusS9L+qO4p?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 369480f2-a62d-4e1d-4575-08dcac59cb6d
X-MS-Exchange-CrossTenant-AuthSource: SI2PR04MB4931.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 03:28:04.6813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR04MB7339

From: Jianyong Wu <jianyong.wu@outlook.com>

There are some statistics missing from kvm debugfs on arm64. For
example: irq_exits number, irq_injection number and so on. But it's
useful to monitoring kvm performance, so, add them here.

Signed-off-by: Jianyong Wu <jianyong.wu@outlook.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/guest.c            | 3 +++
 arch/arm64/kvm/handle_exit.c      | 1 +
 arch/arm64/kvm/sys_regs.c         | 1 +
 arch/arm64/kvm/vgic/vgic.c        | 1 +
 5 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..1e20319977b3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1024,6 +1024,9 @@ struct kvm_vcpu_stat {
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
 	u64 signal_exits;
+	u64 irq_exits;
+	u64 irq_injections;
+	u64 handle_sys_reg_exits;
 	u64 exits;
 };
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e2f762d959bb..a3783388a802 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -50,6 +50,9 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, irq_exits),
+	STATS_DESC_COUNTER(VCPU, irq_injections),
+	STATS_DESC_COUNTER(VCPU, handle_sys_reg_exits),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..d69ab1207da4 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -335,6 +335,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
+		++vcpu->stat.irq_exits;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
 		return 1;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..2a6bfc673636 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3568,6 +3568,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
 	int sr_idx;
 
+	++vcpu->stat.handle_sys_reg_exits;
 	trace_kvm_handle_sys_reg(esr);
 
 	if (triage_sysreg_trap(vcpu, &sr_idx))
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 4ec93587c8cd..9f7371e01f35 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -454,6 +454,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
+	++vcpu->stat.irq_injections;
 
 	return 0;
 }
-- 
2.36.6

