Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013011.outbound.protection.outlook.com [40.107.159.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708DB471CFC
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102422; cv=fail; b=FbLWgyVRob3mxlMPzyPwN432DQcyETYkP+6j8zv1I5/QEUyGggqwrXW1TXs2asKOx3Ev9RR66fIPK5eqh9ng/H53hZbMaW7dwXINeKD7XoQPYyFVeusyaRj1ue7P4aYo3LW28ZFjuwKKrwM7evjcufS6Hufe2+ROzZ25UPFNNKs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102422; c=relaxed/simple;
	bh=/+e/AkaWRpTPwjW23BgYy4Cq7NK+gW6+V/aNpVnxgVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UnXiOQdm5+FJ5ilRqNlKlr+btwd60v4tcqBfVhx9M3b46fSFvP7wzTSOR9SFDRTjCIYc0TENEId4zcTOdPkAl7v1UfGgkMKhYo0rLeyJO1VeZP1TJ7hJUn07kIk//C0eVcip1PfPV1XeXO/yWrWpvEQLRH8rfMM/Z1gjIvi+9Zc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oz1It/Xk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oz1It/Xk; arc=fail smtp.client-ip=40.107.159.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oz1It/Xk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oz1It/Xk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rQ2uAmmqOg1eMsRFhWG5crBvQ1AwNk+PLUC9uBAHxNumY9Qq+4nLJy8csG3/a76AbSapwjOT9t+t5bDiHeYWFprUcT9urr+cC3Wxg3aoKMCe7+DQEYwfTJ9t+kmTSy0AvBZ1fU6uEAsr4/yZX3FMLh2tm7EaX9juJZmQ5mNMkGEdbjtZ1nBUPrKn1nxbm65DJQUw5YYgv0dJWH0EIUV3CcEGFJ2YOqKo0NCRFlrSVXl10Y5zcYHAG6Gly6xBvBIIaxlCNXiUxhGVfwhBisWGL+dg2ru1TE7HRC6HOZe7nMbHugkW8f/kB6Pvj4gVKj60eO2fFWEU4cCD034ofJmGPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=JGop3MKFTsn49RMmGY/JzGjwphqUBXq3gaBep4JkqAcTlUDXWd3IIWtZccTyhhP5XOexqU06F0iZNF4vP+754MVrMGB41yt5dGtU0HFjoGKKYlx21AAjikd0yn/viuc62zALljt2lelcj0hDxaFMYxeeq86txrE74ofxNz0cErAd5PrF7LRSulBLzQTaCNniwuTgM0dO5EBiMfxCfvZQYgsJfqHMks49OsXo8TEzBv2EirO7aQPYwM0+2ru+/PloehpF5IvluoBjFYgEQcknFH1KMDbWn6WA3axgYFWVdu1g6StCb04X1CX2EzAJFvp6a6tDoILyd3na4gIJEDBa/g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=Oz1It/Xkie8J1V4T2co4xgAO6iM6fhDlBzCemtshiTh7wrvnM656yXFWqPZ5GbFEwr4vPK1kstuaPULqYwntm9cnp69FFzDAg8oZealFwUEAIyXHT3hlw676hDlpeatpdc9hmJDfrMy4ljfiDoAGHJdGWtH94Yzq/2rw5EgcFFQ=
Received: from AS4P191CA0038.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::7)
 by DB8PR08MB5418.eurprd08.prod.outlook.com (2603:10a6:10:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:33:33 +0000
Received: from AMS1EPF00000090.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::3e) by AS4P191CA0038.outlook.office365.com
 (2603:10a6:20b:657::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:33:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000090.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:33:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGABpTmsmTdhebMgYIRpdAl2u+Bs2r/4khgqHQijXmx6jtt7YcKAcS9+gnF/oRGy7s0ilVZIg0YSZjfJcOOV/zZOH7qxg2CRCKf9tuDHNOsTIgWQ4wx1EuISxeE1xKgUbHjwqAZzhnHgyDI8+0+IxPbGd4Episr6ZSdQelYJrbVYv6OFa5uhkyDVort8SgJ75psQozdk8dFjX7D/xWUd4k8J9e5N6U+vBVtiT8e/m8iCE210KQBXpJOh/AJqaISr8reSbEhu07actzi9U4GeHYtd7C/x6A5ucwfX6PMsQiB9QVFsH0JuZXkpch2RXrrDw8JQKvZ+5yPoKZFzekzSXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=t3/YTgnOONV4Bw5ILzKRo9cm0qm9GRUaUmxzXtT5JrKqmKIiiYosjm6Y0dWs+Rnoc3pT7tOz796XrjBQWvw9fd0J5APOHaoaD0DeB4HdIAFRFZ6Yv3yseUZckhVM1AucvxJZQ1IVNtFcPRlWkc3wwu5T6JAXMM7+eaD9miYSEEJjDns0Zc0fLs6C06rsF+m4feVtlmBVwMbg5u6Ly9M2OU9FEhH2wo9Pi3PCj5al9zbukmcGvqNJmKne5ABG/jVxi6seNThiLIaMNbP7kiQjLQPRFdChEFStprJu0YfeoRPSj2eOFfCRUesH2ifnNHTNIuqZ45gN2C/5njEIQP5UHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=Oz1It/Xkie8J1V4T2co4xgAO6iM6fhDlBzCemtshiTh7wrvnM656yXFWqPZ5GbFEwr4vPK1kstuaPULqYwntm9cnp69FFzDAg8oZealFwUEAIyXHT3hlw676hDlpeatpdc9hmJDfrMy4ljfiDoAGHJdGWtH94Yzq/2rw5EgcFFQ=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DU0PR08MB7565.eurprd08.prod.outlook.com (2603:10a6:10:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:33:00 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:32:58 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 40/49] KVM: selftests: Add VGICv5 IRS address attribute
 tests
Thread-Topic: [PATCH v5 40/49] KVM: selftests: Add VGICv5 IRS address
 attribute tests
Thread-Index: AQHdJmB/zX7ppRTbu06uEsr75WY3Sw==
Date: Fri, 7 Aug 2026 11:32:58 +0000
Message-ID: <20260807111159.429128-41-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DU0PR08MB7565:EE_|AMS1EPF00000090:EE_|DB8PR08MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b1398e-cf95-4185-1a72-08def477b6a0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|11063799006|6133799003|3023799007|38070700021|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 VaVQrHT5vcMlUrkRLflshCYXGuvBwKeeXlw/eVeTXPDq9n66pusBGAB2c3Pc6rbGp8tM5B5ittGLK5FV+c5GF2iJDDl+/6UnMGauKQIAvvVBA3TNEOpEuzTZ0CoHIySXKSVxT/1Fh3LAm2PLlN16HtxVTx0UwP+k4Af6B/YxDUmoUGsF5bYLQ1FJK4BANNKTAftGCeDqtmwPJAXCKl5xugK1XLS1NPLacqGIX12oa9JV3eoOOf5nmqSnYZOsQeD5NjTCInnYJLbqoxlQ5o7tULnQDlSvPsQDpK3phXcNJRhBG14Ub9DtLd6Jlr/a7fH4HL0S7Kf2br5NdAIHoRnOOeJOApYyEd3xxA3AbeuMDJP7eLb7mhYBe+P/jqOo+BK12d/wvhet2zBIA5cKmj4p3t9gay8cHFTnKI2W2hvNc5pEDXHWPlks4VrmQn1K7yyznIBGzbIoOsYE8k9c3AbZl1+Xq8Xry/yL0/1y/VIxVdHa8xxfDDt+YKD8xalwGXPrvOLIlz3oaMeIXYIVeSBvaReLLG1Abp61NBHQJ9Kd65N8CzXrqchQK6xkidU5QIYsmYGR3JZ5iphu13MbWCsohHDqFv/AXuJv/T9EFeUwWIVD2ETqqFZyGl+D0Km9W+Cz5jqZRTwnZLyzz4SNI7dhqCibe4rLsB9itZqd09MPqxj97FLz13f1k3xFZ5UIoLstQA458rv0pRw10A0ChgkRgCxqHvuoqfwdPVVgB1DK1jc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Cv9/B5vGFmNa/xI6NF+y0A3cVCPX54hJWso6cvQi/Igy8BVYavHciM8j6HEYRT2dAc1RHqrd0U3rD1mwudZ4/7Wb5baajbUiS+WJuF4onDuEpwKstldPiSjzH8DzwqQq2DFpMhEaI29eRlDnMBjpe1AEcge3uuyOd+smbHPKMx/CamawlIOjZ6NMe04r0hw8BwPom4ZOimVDoa17EV610hhPYdBvXNxqKK+AQ2+ZkH+xzAFV9bGYItXDrn9WLIrCP+Bl7UXbE/0nVrt+YR4solP2BOCv+9E/Khmn40ygbIW5z6WUyGJLN7n5+TmHlQQa5zner0AMbGefS55WZimm7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bc20bed5-7f3f-4feb-7a0b-08def477a1e0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700016|376014|23010399003|14060799003|82310400026|56012099006|18002099003|22082099003|3023799007|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	5kvMCsPfwjAjUX1J1hqlzO0NMPBIcTAbhNnKBGgYXqVxtYiXHILYVp6bgXR+G8H1kEqsj9aMqpXDYvgSgpMGs89XmKB2dipLAS+5RSiKJps/2HJ9glQxYb+gedKTSm5xZA5g3bgKXCGXa420S/ketSltQ+JvVH62BIPXtnLUI0ColmqpVd7q8D/DbMAxzTu0/CJZemP6zz37Od8qVDy3ojXFZviXMGeojnkL5VNosSX7nf2arPvu4i5zVI4z5qHr74aEuJo7L0O8yEzPd4eG95asfEYjTLH0sOLDIsAyR98I1ZMw4xqHxbWa+UHU1uPVKZn92W5W4QDDKEiKHcnA3TRQgKp5Zd+4SizL5+hNzFNSsb0E4vOUcALJ2LT+8FoWEBF0cwmfYYV2VA4mxAOkw/u6lUifcP+ABjw5Pk/Ukq104iBtJqIzEquCAxQLBOiax2ERb8+00XRDhucVho1gynZEeKTci+E8myvAh3M/+jaDnBJFmsI+nFi1IssWCWAjOFs8SbDmqrGjfgHSCfzwm5ABoEW2cUIOcBqIv0ipoulHIvFBkIjNUSZ6+DHsDkqUVwQ3c70t0U7h79ejnVXwsfbeW/n6p4emeFsqi1kzD3aX2fW+wDDB1lcBrk/Aq0VMOySYHeVCIzGQXr2M+H7s2y7GCuMgITt1IVeXpsfJJvydPSkHek7mwGhftOlCWxDrO9vVSUpFDiUTKOFQJujW/g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700016)(376014)(23010399003)(14060799003)(82310400026)(56012099006)(18002099003)(22082099003)(3023799007)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WmMwEFP/ivxceZmOhsRsILoaxKMLyL/2a6JiLDDwjmk0CgRIsxVAxV77UVUlbwaImjfVbrjiaqf+Su9Wyt7mbthZYIDOmkNwMqSWabx0UU9tfVEpZbLdfen6VShOKtn0xysz+Ncky5BsvJ/6Veg8BnO7t9TJLdporb3leknK/8U5U54strDVZDL54l2gupGys27OdogRYf8rww2whj7Dym0TrIqwsiD39wYkYkfQZfIeukYT4hd5OGtCusV/ywHx+4kKyBXEgrzy0sET9mMFC2QmpytOXIzpQ2pM3fxcGOz9ceGPaUpicq0lqafqtb8/y/c1TBK6rGfLy1c/qMcEx0QAjCqWkHlXw8tAL1PTU/XPASKOFQu1pyjEgRxSJcVfflXevCZkDKLwG1Wxq6/ha53IPj10K8plUtjCYA+w4jJNsiDU7uhs/Mv6ZEoRoI8B
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:33:33.4392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b1398e-cf95-4185-1a72-08def477b6a0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5418

Add coverage for the VGICv5 IRS address attribute. The address is the
base of the guest-visible MMIO region used to configure the virtual
IRS, so userspace must provide a valid base address before the VM can
run.

Verify that KVM reports the attribute, returns VGIC_ADDR_UNDEF before
it is configured, rejects misaligned and out-of-IPA-range addresses,
accepts a valid base, rejects a second base, and fails vCPU entry if
the VGIC is initialized without an IRS address.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 121 ++++++++++++++++--
 .../selftests/kvm/include/arm64/gic_v5.h      |   3 +
 2 files changed, 110 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 19039a8940568..51ea2fe7141ad 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -14,6 +14,8 @@
=20
 #define NR_VCPUS		1
=20
+static u64 max_phys_size;
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -25,6 +27,104 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+struct vgic_region_attr {
+	u64 attr;
+	u64 size;
+	u64 alignment;
+};
+
+static const struct vgic_region_attr gic_v5_irs_region =3D {
+	.attr =3D KVM_VGIC_V5_ADDR_TYPE_IRS,
+	.size =3D GICV5_IRS_SIZE,
+	.alignment =3D GICV5_IRS_ALIGN,
+};
+
+static void test_vgic_v5_create(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 addr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+
+	/* Check existing group/attributes */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, gic_v5_irs_regio=
n.attr);
+
+	/* check non existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "attribute not supported");
+
+	/* get IRS base address before setting*/
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D (-1ULL), "GICv5 IRS returns VGIC_ADDR_UND=
EF");
+
+	/* misaligned IRS address settings */
+	addr =3D gic_v5_irs_region.alignment / 0x10;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC IRS base not aligned");
+
+	/* out of range address */
+	addr =3D max_phys_size;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG, "IRS address beyond IPA limit");
+
+	/* Space for half an IRS (an IRS is: 2 * irs.alignment). */
+	addr =3D max_phys_size - gic_v5_irs_region.alignment;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG,
+			"half of the IRS is beyond IPA limit");
+
+	/* set IRS base address @0x0*/
+	addr =3D 0x00000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret, "GICv5 IRS base correctly set");
+
+	/* get IRS base address */
+	addr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D 0, "GICv5 IRS base correctly set");
+
+	/* Attempt to create a second IRS region */
+	addr =3D 0xE0000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EEXIST, "GICv5 IRS base set again");
+
+	vm_gic_destroy(&v);
+
+	/* Try running a VM without ever setting the IRS base addr */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS base not set");
+
+	vm_gic_destroy(&v);
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -81,19 +181,6 @@ static void guest_code(void)
 	while (1);
 }
=20
-
-/* we don't want to assert on run execution, hence that helper */
-static int run_vcpu(struct kvm_vcpu *vcpu)
-{
-	return __vcpu_run(vcpu) ? -errno : 0;
-}
-
-static void vm_gic_destroy(struct vm_gic *v)
-{
-	close(v->gic_fd);
-	kvm_vm_free(v->vm);
-}
-
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -207,13 +294,19 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
+	pr_info("Test VGICv5 Creation & Setup\n");
+	test_vgic_v5_create();
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
=20
 int main(int ac, char **av)
 {
-	int ret;
+	int pa_bits, ret;
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
=20
 	test_disable_default_vgic();
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index c388df8f2a2b4..41b698b3952f3 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -13,6 +13,9 @@
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
=20
+#define GICV5_IRS_SIZE			0x20000
+#define GICV5_IRS_ALIGN			0x10000
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
