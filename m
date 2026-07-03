Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010055.outbound.protection.outlook.com [52.101.69.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896425DB0D
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094087; cv=fail; b=CrGLQ6vZRgZWtjCzb7avrtaph6pD5Y67sUtwglOstb+a14WIZR8JbX2qKRBvsqXd/FIhMY0o/byjqmb/ETvG3PEYptNlyl8xbnhXonR9aweDpu+j5YO1C9zbTVQj4eBYbl1UOylXfoHgmf0ierUzyZr7lpFNE745Je1vVuA4JBA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094087; c=relaxed/simple;
	bh=LIsSOWV1Foui1tWkXBEp+73tic2gMbNHlub628NI0Mk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eCuPGE1kOC6FgzJY9zCgOSB8mg4PgWjwWpLitn1DZPjJ86jt5XiuClXCDc9RYZwYho/eBwJUr0DYRBJL16fNlLpY8PWWrO033M/VmMdbPWMMr8T4RA6hsDNloyFwDTgYsuRsUOdeTV8hgHW9YaPImJ6FxP98Wd4DEhp9Q5Bxce4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SZNyRTU2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SZNyRTU2; arc=fail smtp.client-ip=52.101.69.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SZNyRTU2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SZNyRTU2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QvWE2Dhc7qkxZK1OUPrIqmenP5h/X7ygu6Yj5t7mYFjCZ0BPiqdeQ2m4zgcMzRpSePYAjz7PtmouZfLsRCgGq7OhVZLN3pFeBtQ7bNhc0/bZVB6bBz4RhaHwhaIyCd4UfBxO1qWUJrel5Mc7xynf1R96Kd+2BCKutiOoZztIKzxtswSsgHQoW6tCHKrKMnmgaC2CPoOzy9eUjQJnO4SQGL1Ee6ITPkNHWry9+98dsTQvwYChIO0rxotZHoqB4U6NvhFcU5CVuOa6zwt7pCexlKxNKhW6wILVpd2Ym5sKj3uptoNFws/fCc0PV8dSFywe3i5KxsyMmZywUjkVqgkfng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff70CSCNehqQ90YSAHZbTAX8MQlYweTiDR6R65kN090=;
 b=M7qE9B7gY/FzEYzHDSjNqwULLrTqhw9IQPlN1d+QtKp347L9QO16XQXZqAL0OSD09sqJC2oo9ZmrboRtbe0W+Uru5AOl9nSRgG32+C+dYOFSEAgd7/hzSl/RYxPGaIkRNP+q3J0wpwpWJ8ML4VEjkkL/XP95VcvFUv+9UZ2XGzFM06Vo8Oi8G68nkVL1H2KI85GSLta+zVoh6ogCw7VKlHz9FC0wT1VMtOhdvZa3Va3FoWxuNKzckEjfGEoGMBqZl/o1/3B9GrpTU8cSAqo8CYt74W/Rjfx2fRDef3XZ3w4zXuySE7KdGALIPISSKbXMU9BJ2J1gi5Tyi8p82g4+ig==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff70CSCNehqQ90YSAHZbTAX8MQlYweTiDR6R65kN090=;
 b=SZNyRTU2R3f8TbDwvaExOyWZQUE0kWQQp65uTg1+TvX+HC/yvlib9sHviC4c17T8nWwmRS+xlGykw8ZPKC23KE7bXFFU/R48UoCW4Hvl4IJngIjUcbLAn65U28bcxcHTfkfWNBD7ccifP/tw0Leu5iHrJPJa5vgUpCNTP7+tLes=
Received: from AM9P250CA0017.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::22)
 by AM9PR08MB6081.eurprd08.prod.outlook.com (2603:10a6:20b:2dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:54:41 +0000
Received: from AM2PEPF0001C712.eurprd05.prod.outlook.com
 (2603:10a6:20b:21c:cafe::26) by AM9P250CA0017.outlook.office365.com
 (2603:10a6:20b:21c::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Fri, 3
 Jul 2026 15:54:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C712.mail.protection.outlook.com (10.167.16.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0bEY9to4qvJXyM/Ka4RE3WbGEzG5R3HbdSTIU7vaNeOBzlm7dRVyOfxQC9k5S9/Uw9bEmVNIG5i0JlI9gFqMip4OZqdAOXXjEPiMrt90GG3n5MkyBmYtJ3UWZEQPDc0PN5V4BpW3cGhB7Gfr37ONUte+Ihvj86n4aFxyJXZ2m/3zAtfuVriy412P18zf9db10tOl+jTxT+JD25bbZGvS+Ia9oh20LnG8le8risI1A1UM6an0v9izWoMssnmpgI5rBcJpvvmSkuOR2Ylwwwt4ZMTiWRuc4gh6dyPNe00En5sgAxdEiZnYIPoBflOb5XY2oG6sXyMbjeVjjb2ozTb/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff70CSCNehqQ90YSAHZbTAX8MQlYweTiDR6R65kN090=;
 b=pKlCNTzMY6UZM6Gz0Re/mdCl4NCmtpNGIPnG+vx2uwfPQhdy9zM8TpsAthsqRzLerJpAwcw3CaEQon1fiDMOC06NZjv9Qq9vMPt+9YZ4wpzIdxUyWxvH+qSQtFRhUVnOhEgKgBOczsgkv6glHYlGpUvh4unwzSy5ShspO4xxWelOyElUMSs5ypa7O24Y9D9kMCYrpBIKW825kqiccNyS6CCDA7xyn/pjoR8OTtJEA89DNnfpzNWQn4CsxyeYLsztBN2kJwiFS2CtjTiOyK9WRwZK0sjNLC7bdMD8n8jdmDQHyOCvv8cWLReRhLEwUf7q7OXOvuCu/5EReWMkw4QJCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff70CSCNehqQ90YSAHZbTAX8MQlYweTiDR6R65kN090=;
 b=SZNyRTU2R3f8TbDwvaExOyWZQUE0kWQQp65uTg1+TvX+HC/yvlib9sHviC4c17T8nWwmRS+xlGykw8ZPKC23KE7bXFFU/R48UoCW4Hvl4IJngIjUcbLAn65U28bcxcHTfkfWNBD7ccifP/tw0Leu5iHrJPJa5vgUpCNTP7+tLes=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:53:38 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:53:37 +0000
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
Subject: [PATCH v3 06/40] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v3 06/40] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdCwQc5Nm/2v6DSkuvWwqmfo36BA==
Date: Fri, 3 Jul 2026 15:53:37 +0000
Message-ID: <20260703154811.3355680-7-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AM2PEPF0001C712:EE_|AM9PR08MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eeccd05-732b-4ed5-2049-08ded91b6494
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 qhEruDFPBf7gxEm7pV+PnKBpCa2Z9uhmLLbiwEd+FPNxeoh+54rxzAk05xtr00Mv8xzqgGYX8Zto5ecaozKb6L/Yggw3In2MjrypEkdiSwagVEmgFp90OEr3HqrBaD80im/0Eo3yfUdYlZaDwsihY2bt9tZDIvggseZSmR5F+VtYW0nPhDaVu2Mx7M7w161KpYs2uqHLlSXV70Up/xxDGr8D+X48uUfU7E5nGOXPzCPbd4uZMUKWU8Qetmm8peUlE5irjk+Yj35zgBk0wiahvoPaJtMGBfv1dG9V8gBUmD3LiIO9Q4LT5nhbkMpE7Ww6vTRSii4Vzlnip1kk3fE5eVFsrdyV6XNczhIn69smZ41f7t7vLz6lA7p7ik7WkeQvUeh2n7pVGDEynjDUdxiwCJ17oeuu3j+0SaZKnUX7Lxys96VbtdzxKrdtw/pSZxVnTJwXh56ngP+7JDAeH2xov2VHUoW7aA+xmng5+P6AmP+LjwvDst2fLTXkLdBHWh7AWNXRFJWBRG9c+n0VzPYWiABGUikfZeNRE31m9q9NWDrS5d5ngHrRkRlr3V52oSfr8SwnmKDn9P2S5FYGwnlYAjXQt21xLpID9rdIH54+0x/quZoruJdL1kdtlOZPvP7mC8vRvCMul+88aqqYlPXOBTzSwELUFxFjZ9ptDzxlFbhfGKaRtf37DQN976A8YURiPb/1UfWYhIqJ2g+yPISZ4/qVXB0BPh0PmBhCf1mqUXA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 a5J1sa1cO3bST4OXh/tDyFyKKIWinNhmvwiFA7o5IwHlJQo0bJ4N6894Hq7j74s8TtsZ00U3JGKaUtUC2TVBcJMcb30jAzBKJhbu7mSyH0iv+LLlqun49YjsfXToPv7BavZu7x4YLDzCVE4zH+se3IZIEbsmJTk3yGvDlmIv274yCYZQhf54C80pkzkcZoYnsp5FNlgYo3ptt+xWR4tuND7/Mbv8NewFxNYVYu04ThP0H7GBcoRnz0qm+p/NC2mean3JemGxiK9FLXbUWwp4S2LZTkT2C2gQVZ8/SurKJYj/dzE6w6x+CCIAC/G3wQSuLdKYXCIvpk60abpAfif8zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d2c8876f-10b7-45b6-0206-08ded91b3ea9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700016|35042699022|82310400026|14060799003|23010399003|11063799006|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	T4U0/G9t3EFl36qEmfSKKy11ZP4oH0oTqGYxX4vRS9U2XhEQXzEfZ+J6MV7kkMU3Cm649Ld2Ea2xLl6sUqDbcZzk3u2qlsD85ApR/NO1bdXp/sP32Hb3PA46ZoPrbyo360svSpzDcfdwbkF92SQuC+BkBhbBkc9YYEG8jTlJVeTKWIQTcVoJmn+gHRwV3QjxIi2CqbQOv+474vAWWjaSwKT+6wtikTq2nRdAlBYamH1WLHPkCSh5kZ5LGXWMJeVkYj0TdjSCIF/CzNEWbZfnSmE/+0BffOAFdQjQ3SUHB9ewLTx1voHLkqa1QKrAIb4FUgZe5GXG4bHuSm3/ZwOXDMsNAsYE+XTyndJkd+EEqVSJPZy9yjkMny5uW1iUQcEKUGgzJlk5vLumFRxAoByuKyBeXo+dGxDf0N9YS75B3lYmOcfN5qlWxxBS9iQi2HAOk17ZPO8TFeq7zmAEMcLuEJf0QpUC1KaXQKda7K6GFH3A5E3JOHbq+vUwB8pwzYa//5oz++kPlY4EWUPLormWl+oimxNRRgXaznar6BCna5DmCdZKr85r4jxgNfyc/lPVKqgYNb+NKUob/BuGgDQiD7TP91OHa1b6WIH/PmC+YwnQPU5R0abM4hsHHqxVmUAIDhRzDlCQQzp2Zi9c2DKpTxc2T1AkGVMg2Qc08jFiIrX5dm4A9t6i0Gu5TApMPJy0WZIQn+KVMYoZFxBBlp+6Vg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700016)(35042699022)(82310400026)(14060799003)(23010399003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VR4wn3Doq5hNrKfvwnmn6lbFiKJ8nElmaxpYqHbcFwGdJ1v+96b1H7Q/elCNyMDDhaUwAjmpr7xJM0g+mmDjyDR0g3I2A4xdbC95w3UF8D2uK6y3hRqOcCwhsr+wcTmIYAnGBhgDcc8Q1jEnV58SbelZHN28nSW4ArscyHP2AhVHYpCztYBspJyTmVpK8+g1QYMTWJeyzad8jI9e5xy6XHLdw9XKBzpUMElRS6jrF5MuklCoAaFZTsab9kObOGbvdzQZNTjxIVWrfNKFFQBYeVyefpSV941Rog/E0tgbvssYy1Fe/W1M/WXwAI2YYL1PXS6h0xZQ2NdgDcJV6XTFG30H/qF59UngexzGGY6GdHWuRPXl3ZXGGs6hhTcY/+X0NwoG3K3dnig21/SQJg45Xpr20xwda5D4GLKN12K1IxAfwNBJJ6epf1w+HRaJsO8h
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:54:40.7069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eeccd05-732b-4ed5-2049-08ded91b6494
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6081

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bc1788b1662b7..855812bd0971c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
=20
--=20
2.34.1
