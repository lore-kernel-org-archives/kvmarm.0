Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011001.outbound.protection.outlook.com [52.101.65.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9E372B2E
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748074; cv=fail; b=fzw6MByskR3MKndWvZ0Cq1r0kyOg1LE8oNEjcJ7UqoAnPuO6znb4SJG/SbM/+FMppJe80EaEXbb+wh3OCuuMrVrvMeuGPaSprq6pLBL3J9ZIq4/E2wz8KzcYnJCp3ebxdVhxnAs5GHGz8tEYwEupYsJw5VLWIux5pnMBCBEoGiw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748074; c=relaxed/simple;
	bh=n7vKdW52UZOnOlG1vyFs8+7VDvapkDdeRk4PpYkkJ+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kQRcOLNrnC/jIUEIOSE7WBOtLxbEANHLDdwsWx9rmfK6E6BUNCAKbHSglChbKpb0xlVSLRzOgwZexYuUEWDFg3wV3km9j4088xF2CRvJSR5F9Jqk+eSi2UWK6V9HZCG3A9yYJ86o83oHzdjI2vptvTIlJ8U0EtvKfiJzs8IzLAs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M6is6GXL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M6is6GXL; arc=fail smtp.client-ip=52.101.65.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M6is6GXL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M6is6GXL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vEuJogUJZTyibyqoD97OecfTNS/ibIH2s6yAFqI7el5Z3RUIaenM6XstZxph52u8PzEExUJYlqWGH2Po64nSsvDqZHuutuB7EwCDEEpFTcB0tZimCUEL63+FuLmBdGbjVwugQl3wXHUHSYcV08MAtawcHrp3ryHeIpOcTPN5ZL8DBub4yVIp7w3mXFXjMrM89JQ2Yp9Gek6sPiv/YkjIlNJup0uG6/Dyt1d7i7pUeQ6GUCwrcM6A4zf7Qofbp3BDGkXf6viyS7BXtKXp1ySuCPCLNRtD1l4XTm23PeJ+nPWQaio4pabxCyGR+SpRNBnAI63mS20WQ3X23jPXp3dQ0w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgML/aoTYAg6GEnOVsV7PGepVVbZqkOsdAv8+/J+tX8=;
 b=jtsrJ5cv5VzaDybPoqnnz6tCoLnhahweDRr3jVpDQ2LWSHVmZQbCJrBoLfKcp15klAK7z07olB+I7Rtczk6q985wN5rdz3WA4pm3bANAU+Ch0nzZutYiUaitp4DL8ZuP3GVfZ6WX3XWybgMkcGH0IYAbplWzfvn8Gna7hGxnVa1tAKFs1DxoQz/phT0K9qMnYxjYlxCQKQ08atn0prjMQwtPw7UdjRmqOt2lTmscmw2aoLx41Sz4jwsb5b3Ma+DkeP1Rccj+QLl/inkPzKD7j4onSJA9ORg/EKvYTPspjHvnrVpy+HFv+oJvFjKk0r+skFBI8zMohtXJvhmKAXht2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgML/aoTYAg6GEnOVsV7PGepVVbZqkOsdAv8+/J+tX8=;
 b=M6is6GXLAHM8UT4sYx3duSltXUeAwtuHYYrea+Rsj64r18H2CYKsX0JtIeelSjaD9ozh1QQ6zbL2A7N/U3vb0uAEh06+2xubA1tUs9wBOrY8hVHhuZ53uyOIIhfJTSsY9fswA85PIU4EfA5HOazJXZXLNlqM7E9xtXChA3iTEDA=
Received: from AS4PR09CA0026.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::9)
 by AS4PR08MB7577.eurprd08.prod.outlook.com (2603:10a6:20b:4fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:47:47 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::3d) by AS4PR09CA0026.outlook.office365.com
 (2603:10a6:20b:5d4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:47:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:47:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3p3FYr1vX3/RswVO4tnZ5wk8r3dtiNisLZuoKXiyVmDzfnLDLjjgjF66AbybVw/RiWXJaF+MAMqwIro0GIteN5XLBOC4L3YYoaAgUVgOqUAYAjCXRrNOAwSxkKAdx5qiM9bc+WqY7iqTFcose8PUGh2evpVH6N8Tg8x7t7Imqkuj8x2fEkXyds6MTYLAbPkEPbFwM/T++j4cBACW5Kxgia5o6AMZndXK/8J04ZE8riuaUSh2q+8h52Hr1CXLDMH9w+lkx4iimiTv3NGjysAEkxFwnzjWSWmvvjhGrqN3AocEN1nzf5t3ty7nCv5RGrKDGcpz7jahUJfe44fkVwMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgML/aoTYAg6GEnOVsV7PGepVVbZqkOsdAv8+/J+tX8=;
 b=DGmZYgLv5NMcjXd8sFcE94cIQsyuqTVsOOb7/xfPBoDF9wx2g3cvHMYhgN4gGolvNVNWvciwGtjpvJhqw2FRcO4ZF+NEMME7m/a3V0McDlB2KEbJFCMqa5O9LM2OpWVy+61N64fnoxZI2AsPsNs8Ye80SKAo1AeizgBxKhFueP4Kp0MrnePb3gZH5rnvN+v/gaSnrmQTDshclHdU3AIk5p82jVMbGz8P01hvnJnw8npvvAuJdsV24w4bRR5Var5K5eibjQ6DirSYIq/NGITO3kMAAEzfWsbXiVj2felVCLueXwjsRPvP9kE5GFV1pSNp90COMnsA4s1azszxsutXZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgML/aoTYAg6GEnOVsV7PGepVVbZqkOsdAv8+/J+tX8=;
 b=M6is6GXLAHM8UT4sYx3duSltXUeAwtuHYYrea+Rsj64r18H2CYKsX0JtIeelSjaD9ozh1QQ6zbL2A7N/U3vb0uAEh06+2xubA1tUs9wBOrY8hVHhuZ53uyOIIhfJTSsY9fswA85PIU4EfA5HOazJXZXLNlqM7E9xtXChA3iTEDA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:43 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:46:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 26/39] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH v6 26/39] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHctgO5F/BZJvN7T02r4YLzGg4IIg==
Date: Tue, 17 Mar 2026 11:46:43 +0000
Message-ID: <20260317113949.2548118-27-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AM3PEPF0000A78F:EE_|AS4PR08MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: d65b5031-0e3a-44b0-db00-08de841b0208
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 yim1cth92LgrfCCM1EaVHcC+0JNGcIHRBZueNNrOHwMgD5AeuRVnofuc25U5oMCv1wcGctOIC+Sk6QRlNOVFegF1r0NWgU1efgjRuXbJMOLHqlV1UnDKnfqp5OuD+oP4aogxHnt8s3IFT16BAPmpuI0QyA2k8YiGI/6Ei3mPQof19ZYJ3EenJ3P38R06mIRFP4WiF5UUH69XvXN9q5dLyWtxHbbNYhz01iEJ19JH8RkmpJN+qnOHdQsS7Vw+e74aOO5hwi6lpvIS0/o+BXCQwqkuSrzxb4dGtv6e/4wesf9VqM7Z5Y40cIGQw6KAYVG4QqWksaCwzRUKcUYyZcQd404L4U6naApvhrn4l2jrCRNGjgcYk+GwoaHYW7UoClJ1DFOKgHE7bf1vHKIraaReTC53+3h2V+Q3BWXi6yHjZW74OBDnzU3zTcYh6DdT6anyGBxaX5uB7EQWZgEemSII1PFc4VMZaqJ8HLtwYdU7a1KRwGmdIHVIgHse5Jg/h+WdM1c3p0qul1kg4PJIh4GgfoZuX7DWWi/CV0AJT2hdtbGKYsiAFER0kAtxV4ril13gGJIqbTqNwEG9khF3Bl5enqXiZn0Ey8O6RFH+Ih3LXde7wYYOpPbXaD5nCVIowlg94bj8AVrBnTjxX0C/UQLayYKkl+7wChfEimtDXLSTIeDrN/PzZAFAMnYfY47hB4tY4Cg8gFUbuW2e9q0Ao10jnEjtKmROUJw72RV6dxXKFBOIZk44n3ad8kMD4eLcX/dTaSu6MUCYAwkcy77sQKohHo8xM9l17EaGl10UfFmw8zs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YSszcvNokVsSOUPv09w+Uz6OlZy76TSccoJMjhIveslDvHdDxNJnO2T8bmNd1O4LqTLdnEfnKYOB+/VqBNkRzE+os7dbfrv16WRC5lXCA8fNbdBcsPpk/9Gmu0thpxOwMhTfEKj/9Lek/PLEPE+QdfSK3bsq2YvY5Ny3LPkH3W0d4+zW8qo8wEPiSQ24ApYxl6ez5Utrj4G8DhUbpiCL0a+39bhelu0K+/+bwy0joTksuxN+6g7DyKL9MVoC9XVDIM1hMMcJvY9cUnGDQq388KJx5VxS8rwZbpjeRv3U1rLSZMG+PQtUQyGkl+U2gglQkKdsv500HTo8a+jXSZqxyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f368f09b-b442-43b4-8247-08de841adc50
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|35042699022|82310400026|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DTAFLr+HLhiTfr+pqC3cnxYygNwriEKHpN5Sb4YSnvme/Bpqp8vH2TPbgyCYJiK60NQxXDfyREQh5d5DtWTWaf/ZyQKCWFhF0I/s87YG/U5IJrU5rGDEh5d5fMe72mgT0eTyNFIuwq7kPS2kD0n/Gr7d8N2yvN8D5y4wnsC2eS5rLAop7ytbfJ2Md+3bMqweiMHxFNYGanugfl4Dcw1NkJ7guXr24UG7/MnhbwlhAG1svCQn+9acJVr/tEK1eVO363nWupf2CcznNGOSK0kPqvHYsboaNiAWQroXksLLGquIEIPBTy8PesIpX5V7IiCSIGJFLneX7K7EZxGnYDH3Eb1dIEwjtj0Mxs9Ct1w1EZOhjWQdjfNz9mg8y03S03aTNVyyPUt3Rls+olf4qJGleDb5VaNKYL7lbXMoIL90I05ADBOa6BjNDsOM1aPCSv15LVWQIQJbH8qPJ9ZyQ27KIyTMGTyuBtyeFRxBZhgBLy8wASVJoYIoUE27keZS8NyYwUGrBTrxlYB//gMUebTMchNP6SRRBV30Er+WwXrYoCRVGbtQ0XWdpUd6F0wYxtJKOmH/VDk9i7cLwEnJvYDKJlxY0KB7TEl9YSaBJP55DbAxKbToYw8eOvz/1afZU8GP4hPgCGfMIJuiG2y6hFntFRWrTsH7nMB2/Zo9z7rIrI4OmIQSBDPJPC+HmB/SXi9L5y0MgoOKB9OdRB/cNB1wc8jvzXe7jtaDVVe7LmyhnG0jKP4md4GDONI2gKqpcm02cUIao5LRSq1uWF3omiOjKA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(35042699022)(82310400026)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	htNUjihyDRwC0bm/vtrBHqbu4lp/XODvUW6wzcHyMju1LFgQqCXjfnW98/f1izDN12kJV42q3LxUBIPWgGcSP1I3kROLwiEwJmbipHvnIIAZ0mldpLCsmW8Soll5TNpp82Npj7SyDxMWQYEuMKkvo61qDMdElf/8waeqWSfWaK9OYwBUVVU7lRsQtG9A3VzJnOHPyxVMKGx1C1bqqTIGb1l2CvvJUqW2iy3G7CkpZCRJo6rKdPcZ+sKp1rxaOWOC+9h2ST1XUz5aIEDeltNfoD+sO5bGs0QwR7jEzjvsKLptXdFDcATgXu72Tr6jvwmcUIMnLqh34J9334mi6u5Ti+S7IP3kPzLMpYG4dARnXtmYgWbWramwEz53GoDB0tDIL81D9kN5XpIOk2R/fmVqkOR1kaKD75xcwqKOUaWBeM7dkLSemdUVBng+bpR2G5cn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:47:46.5362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d65b5031-0e3a-44b0-db00-08de841b0208
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7577

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

In order to use vgic_is_v5(), the kvm/arm_vgic.h header is added to
kvm/arm.c.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restriction will by
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 22 +++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 032516783e962..03d87d9b97d94 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f68c4036afebd..8577d7dd4d1ef 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,9 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_vgic.h>
+
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #include "sys_regs.h"
=20
@@ -1479,16 +1482,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (vgic_is_v5(kvm)) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num =3D vgic_v5_make_ppi(irq_num);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (vgic_is_v5(kvm)) {
+			/* Build a GICv5-style IntID here */
+			irq_num =3D vgic_v5_make_spi(irq_num);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d7407337f9d26..ab1c92902b41b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1
