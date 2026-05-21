Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011035.outbound.protection.outlook.com [52.101.70.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784C53438A2
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375596; cv=fail; b=VYbGPtJNxBr0Nx201GF9uEqvgYNApLMpOt+ByVYFhpOrbB+bbbap6Kqlx/aP4ffJbJscGV9+HIILnD2AOOjXt3MuoSTFwNaDd4JU4aB/Sjcp/46tRKnpw7Wos7AZBEi3N6uUJzIPn0+xaHxwmuSfFBNlqhPLVZmqAlITw3XZuUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375596; c=relaxed/simple;
	bh=wIuv+98CV5mIydh86g5tTWxUq9yoOE0meUySaIm3uAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R7MDTr+ZK7U9qGk8cZjVFZRPjmp425jGDrxn7NT1YPe316OefOydHYNGspgXqe4zQPQt+Nm/ONFhOHVInRT2l671mXkmn8NBfud8uLKMaiuykOXO0Jit6r3y9FeXQonXUWtmyvIs9BZ8c6vO5Lnn0oscHjeOpMbW8AtUDJ604x4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RHZkUCCr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RHZkUCCr; arc=fail smtp.client-ip=52.101.70.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RHZkUCCr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RHZkUCCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkfGbNDvURgJ9bng9KkliEv2GyMHPEYP3Ais+hfRy0k=;
 b=RHZkUCCrCN/SObMK/VWD5mcwZBBnvWqS8RbdzcZmhc+V93Ymv/xJ1h4QWcQe4UkcdMxO+UGZqv7NmtouuBnl3etsFXhrAnlMtbkdc3LWAdUMzbhIbSnjTAslW88NMEZwkM8rxxj/Wena5rbZ21ozegFQLQg+WMX4C73vCWrdXV4=
Received: from CWLP265CA0273.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5c::21)
 by DB9PR08MB6684.eurprd08.prod.outlook.com (2603:10a6:10:26d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:59:51 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:401:5c:cafe::55) by CWLP265CA0273.outlook.office365.com
 (2603:10a6:401:5c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:59:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbqVZFaFjOtYdA/isg5AfqoyA4Itz7kKfEZZR7ORkaKJ4A2ZlAbMEqa9pV2Q8gjdey3TIIOY4knUZABPHJIMhnAd5w6zkSMPUnms65PB2fExuI6UU3YReYgJREnDg81DMUTCiHVNH7iigVnH7cJqY7UgyZ/wyvFZJvLiFnVo9sYoF+eLZ7nvB+R+rV3LuMwXlEtGgiDJLvcqtUrfAc919rFSNVD2Wvoqki+lPq2Z+JMP687Z80sc5KnaFnvmyBgHmrp7DJGHimQDdATZJwNMUPc2n4r4PnrIkyhCfTr76gkBkJsBdBzchv6xCubZth/RYH/CockP39tiVYfkIpkF9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkfGbNDvURgJ9bng9KkliEv2GyMHPEYP3Ais+hfRy0k=;
 b=Juq8mZ/i6xoxIDy61/Xp3tP9Oc3DYQ44cAW9jadttXxvKT4RTSRcAExBUdVwEKjhw5QnTCZF7POlj+4tgN71WiQ29U3mZmUGelYd29HFJNBNQrNBJi/qTj0tHCLyyHV7rIfhWENx50u2Gzj/48IHTPnvT5gCc4yQOqrO/yZOsZRYxXvblONM1Y5yJbGD1VLS/uPyCJwYfFH6+hyc3HHYXQLxSlT5sc6Mv28qfjYkswXaUAS+uoE0zG2PrJlpSaz7TaG1/a43mcP9yyCUYNnpoOUe919Bp43y0xrBnegL+Eg0XRjUMu3tIS6gJFsj0nxb88wVzQSPI/xPjYg2vYnGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkfGbNDvURgJ9bng9KkliEv2GyMHPEYP3Ais+hfRy0k=;
 b=RHZkUCCrCN/SObMK/VWD5mcwZBBnvWqS8RbdzcZmhc+V93Ymv/xJ1h4QWcQe4UkcdMxO+UGZqv7NmtouuBnl3etsFXhrAnlMtbkdc3LWAdUMzbhIbSnjTAslW88NMEZwkM8rxxj/Wena5rbZ21ozegFQLQg+WMX4C73vCWrdXV4=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DU0PR08MB9608.eurprd08.prod.outlook.com (2603:10a6:10:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:58:47 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:58:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 28/39] KVM: arm64: gic: Introduce set_pending_state() to
 irq_op
Thread-Topic: [PATCH v2 28/39] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Index: AQHc6TJTwBC0ppWIIkyxqzdGXo+yyw==
Date: Thu, 21 May 2026 14:58:46 +0000
Message-ID: <20260521144846.1899475-29-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DU0PR08MB9608:EE_|AMS0EPF00000197:EE_|DB9PR08MB6684:EE_
X-MS-Office365-Filtering-Correlation-Id: 24adecc9-9579-48c8-d23f-08deb7499bf3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|38070700021|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 bBjG8kQiFyZeuiBAIADDOmCwDayrX/Qw3X4EMqbGhvLJuB12DkrtoECIM7XgJInMBQcOsvM+AicBY+RHP8OUAHRpfqn6pe+mCErluDRB8z20Sht9kBtz9XqWVXRbYrxMggrolrfSesD2s0aysrHNsHcMZF4yFnaNzZ/eEvIIWNUtcPossJwgDaWgVGhwyBNoTyYMbZ6w9smCjuLv4ugiXb9AOsWmi028aen/hOYufxZiu+diWq2liaHyBalUy/4cCgbTie+MUaiPJcYWSiY5TOHQ/7pf1DYRQ/zFtSdrxSfBl4H4dHsEv+0U1etTzN10jAO/zSDDVxvsQXVKsMJPjBFEZjh8eALyKdP2OC/f2dTxejd0vTVLtbP29MVG0Bx5qcWVm98YjHV0Hu6BmWsrlR2g7dWBwl9UTTZkN7mHJrSxsXsdL7xx1FMpVm2zLsekvkYiW3+6R4Yoe9Eyk2LJViznw62YmhK2D15b52JwQj0glRfZ5v+n4Fp4OGufFW3QEJuV/CzIbVoufuaJtsyiTPDPUqG5HgK6Fgp74ekaXW1g8vCianE2K6pAD85R6AG9QJj8w7cs3AdvI6mzkIrgj/OPxm9+9NMTi8lkql24eIREru8YE0OL/LT15jypGjn8WUn0yn2kLZToa8vD0QBQoPO8BLpwIF/3fLo34V//iDYV2VbcL4DTMlgJy22HunidiZCjMnWk5ugh6vs0cLGjJ5lRoF5BI9IcvDEnYWbzpN5MdIrYEJS2guj2AWiw0o7G
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(38070700021)(3023799007)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 N+ozMqXuJ7mhxudVuRJFcq+F1Y9qubL6/sQg79/4SQjCOcBG/1zvAUTm5FjlF73n9esg+L8+XcoCRO4hFjnt8Mc8aADUyOnaX5NuYKCgBU+c9NQ3d66SN1g8+ryhpNCq+t8A+QOaoeCG2ZY3wmU5RYSRTQQ1gZ/cQYeaGEyYxuad1IBQyH24uEzYFuCqH8RfTWIPJHVCMVGfCsNp3stTb5IxcFdnpKlv35avoCriqmCB5XqyTj+DTQj/Ej5pB7sey6BBxYX4JqM4YAOJxb0IfAG+BIfnmRmMecHS68nt/mtBDIcY4/8dbgKvxk9JZPva6kY32W40jsaeqmClwN6CvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9608
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7cf99018-3892-4e09-36bf-08deb74975c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|1800799024|36860700016|82310400026|35042699022|18002099003|56012099003|22082099003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	JkwHRJas/IWebE3nDxb3N7Y9WpE0CElQyPfp7b5Ug+xWit8vWcGxJFkUqjR7F5rnVxWWnebc51bHLDS6pOV2l+jWFsjiNU3GX/7EhHjg8UG3KgU4CjrxNe6QSmUGBtk/+zmgrDjfSxbfSzAHuZL4UVeTJ60XIZ0v7xzGpUB46j9qE4jUvj+r0ffM+86s4H5ZOTFNJivEVJAFxl4G2N3YPbm8YNjMgh7rIqz16G7uBRFj1Ih9FKPmT1viJ53HsEE1SCrfmO31lE4BNx2vt9hnQqM7wYDzcM4ofBdER8UdQCACtQjKkm+T24xVlkCN6iirXP4hS+zGM4VDqR3knS9FTk9Ky506Nn1M8zG+9HUCPTbcDFSr1zrIfkNUF+Fm85UZVYP9R+HFbLvFmFq/W4Ze3cl07i56fpvzExHm7xqBNnyIHBadVqea94YEEWEP8m/qt3cpshnh03zp+Waf4Hfiiu8HJE0kfhp8RKX2DH9fIhfEHmwq3qnYzXl6hpqgmt8NFPfCuwGEn9nUPNZeDrIMLkflnwcJlm6I533sgq9dOYuaNpgP9U66qcW1ff+nTkQ7VoW7KdE0Jg9rkIuJvM4dqpQ4Nj0OP0jxXaqOqSwbjClgJqCdB25q7HhTljEpyMSJZBxHglCmk/PI8L46rN80cqJsafUn9CTl6iuUx2YuQGR41LpQ5g/20CldMfeDMXmTEas10j7/N6z/mGCQgt9u1QxkP9iq7ldMeLGJurFvvqA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(1800799024)(36860700016)(82310400026)(35042699022)(18002099003)(56012099003)(22082099003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GARropfLdCnGAoFJlTeCX47830V9FTGF+NEF15G+iyNtyJxynh7S+xI5t5M4OeHUR4/KaljBCkt9zF36vST8Fh1zEUBd3+dMaSaFMLgctmZuadvxUcbEimUgkKDpy7qJ5nlRUliSSTbGjAGqz0/yNuCSkng3sz4J5KmG4J8lBqDHBB6hp0HWmS3F1cHf4JO7ZYnG6rww3pnjZYgCNgOgQGXJDaTS2OtT9mkSi+4SjIYs9Tv2Q8ExTZFrp15EDcBJmBG2pWH5nwSER6GaLHeg/ks0IvtLLW6g4k9BhVK7Jt+EYf2MPZtXg1pNaWXdiXJ7SqdFxi8sQ7VFQ3UVyNkGle3hwr25nDjhkiiitBcuGVSqSj2YDhgGWXyhbuC6O5Ju/xfOjrOQYLwYfRgAvmftFnTy4P26OZr8xSmLU8eMyyZ8AVtXM/61PyN341mR5AMv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:59:50.9201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24adecc9-9579-48c8-d23f-08deb7499bf3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6684

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself manages parts of the interrupt lifecycle. This means that
pending state can be directly communicated to the hardware instead of
being represented only in the VGIC shadow state.

In order to accommodate cases where the hardware handles pending state
directly, add a new set_pending_state() function pointer to
irq_ops. The intent is for this to be used after the VGIC shadow
pending state has changed, allowing the backend to mirror the updated
state into hardware.

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d628eea4cfa4e..b35833a4e2bf9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -565,6 +565,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d4b0e7e3edf26..f9f58ca793707 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -250,6 +250,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly update hardware pending state after the
+	 * VGIC shadow pending state has changed.
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
