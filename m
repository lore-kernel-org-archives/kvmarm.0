Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013019.outbound.protection.outlook.com [52.101.72.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04724409272;
	Wed,  8 Jul 2026 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522915; cv=fail; b=g+F3SzgJHfZZ1RV8Z+o5XWNRc43UO+O4ZPIshXW/CztBEtG+yZhQpYyFmbHmj6SiGWDLsMofnw6Mds93jjqE9bulYwEKSO/Z9nm63c7q7sNdeoIJyEcC/DM2fG/iNbkKzixVqaUMhSojhpxFkzSi7PR9aA1PnMjFbQwUIv1xnUg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522915; c=relaxed/simple;
	bh=67hI0EXqEUdOrFhf1zXid1mw5u9yICvN/GTiKcT+K+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bkp3gqDQ47ILwELj517skGOn8heRBHYJxpObqZn3fRgAusBa34yQCl6GTvIeseMY6BAul7xWzdBFQQCL+0oDFbhpRD7FPCEM3im6secsnpX0TdIGLIw9cwuPHFlTthyCPo/N+1/8IlkdxgMleXgYH6fHhl1QeAhqpNnP755rWO4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CIPSHSQe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CIPSHSQe; arc=fail smtp.client-ip=52.101.72.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CIPSHSQe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CIPSHSQe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qDp7NK+tggFM/EZx3S1qAoPb4T0JDXAHGBdO8f9jj6q5Iia4azPgddqHLU8iPvKEWvyS10S/ysRcplcdvV77taI8oBqvGPSTbdMsLQfECRdvqbUpjIEi3ZMCdJe77cPqkWg6K5LulVCZW6y1heukwxy33jqQR5HU+2/kHbsf1+WqeQJXpsJgSd7gaQGvSLqg0hAzKT2hQKRlRpGttQ6j95SqxF7GdiBQjmXnQXBYJwMe/eRhQ7e156CfQtcUwGpbjV6VISFbsB+cj+7gg5IJTpNSwXq8i6tE+dtCcpol3P8UK9ElcuSMXJJWbDkbJgbdUQmW1twyR7HczGbYbJz+mg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67hI0EXqEUdOrFhf1zXid1mw5u9yICvN/GTiKcT+K+w=;
 b=RRrxckAHbhZVmZoUdhH3ckpri0/Fzkb/9h3zwgBcpKCSykeAOWmWesuEyvdwZLvclarQXyycS8VjP8QtmCZM25lAyg36p5vj2dKyCcloEMyqPzFc/U3l06pJKEsRIkyu220ValUhW8XZJFVxjUKSFAJLNnoUnaSntSG5OOSTwgB3KOWXy4dQsRm6oZg9wjYT5Qwy5x+g6lQvkott7QrIbSpuxVOQIX42WfOhgj6rltu0UoQhDINu1+r8W4YKaXtfNR4mgeEBviZQRwsbfQ2bbEKTB29vudyNNBSxHqIveW7T9WEgI58j9dmr0NJDkwj1/ai/mGw64PcB62TMK0aYjw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67hI0EXqEUdOrFhf1zXid1mw5u9yICvN/GTiKcT+K+w=;
 b=CIPSHSQeJP0u9AWh0n5v4tPF9T1hNumt8da5iJ5jIiM/L3g9W4Iv8O4iWb/4g+JQjwz5+rbWMdhXMOZQif8C8px/CvKkbhhbUA+UtsyaHI2z5a5ARPvXM9TKysOyh0y8uTBAvGEmLyzLpVHeoNVLuZPNt/toCE5XidieoaQ5PSM=
Received: from DU2PR04CA0207.eurprd04.prod.outlook.com (2603:10a6:10:28d::32)
 by AM9PR08MB5908.eurprd08.prod.outlook.com (2603:10a6:20b:283::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Wed, 8 Jul
 2026 15:01:47 +0000
Received: from DU6PEPF00009525.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::3c) by DU2PR04CA0207.outlook.office365.com
 (2603:10a6:10:28d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 15:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009525.mail.protection.outlook.com (10.167.8.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6 via
 Frontend Transport; Wed, 8 Jul 2026 15:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QisGWYh21OWgVeH/JqfGc4cNHrOB9hhYHOqG2e6sigcMKyVivwpL5z0eU6C6Sh7a5K388Ls5ANYxv45ZT1lT1xbwNg94ZqTFVwVXdoC9hP+/bZ8YbX0gqlbpkCqZ1Sq4XbL71tfqQ9AzNqw4a3IZpBLilIer8R1nV8pvpyt6BhtrdRZ4/5Y83LekkjrsyLmwc+xIBnO4RPJux2MyfcpoPhDOZx7oLg+PGVGm3JQeLP9SkCdXi+2EbAOxU0G89jbxeEPMrQ+RHXa/KzkBVtlAWZBJipv+/rn1QwsAD0I1sMbVBjuvDBhSmjq4CaMJzHDNyy16WpkKJ98RhPXMvBgzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67hI0EXqEUdOrFhf1zXid1mw5u9yICvN/GTiKcT+K+w=;
 b=T9BMOcoBPESMomwa6I5BLaNCfuOQsqeTWIpSGMVn90oC+Fg1mEUB3xoH6D8eWofvcS3HzjNYvLIwZ3AwuN9mIk3Uacs1zhTQWTtA358htKYWhXioIH90UVv0DZ7wJIE6i3m+7q0TESobcmquFxAfPDUuoo7FDOMoBJvSs889Fjd5QZrn52/Tr3DW861Lf/hpWWRbABYy6SCQ6OPqSAr40XjMns1GIYEHEA7bb8borrTI10uWKyxQhDfLbBdH8KKOp3s4CmKit0yFKs0Qfcakw3NJgaTMWSUmbWQcYseEiiIQmsNvf6yOnnV/hjnrHgrTO7CTI/y8sOmfAvHArguu7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67hI0EXqEUdOrFhf1zXid1mw5u9yICvN/GTiKcT+K+w=;
 b=CIPSHSQeJP0u9AWh0n5v4tPF9T1hNumt8da5iJ5jIiM/L3g9W4Iv8O4iWb/4g+JQjwz5+rbWMdhXMOZQif8C8px/CvKkbhhbUA+UtsyaHI2z5a5ARPvXM9TKysOyh0y8uTBAvGEmLyzLpVHeoNVLuZPNt/toCE5XidieoaQ5PSM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by FRZPR08MB10926.eurprd08.prod.outlook.com (2603:10a6:d10:13d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 8 Jul 2026
 15:00:43 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 15:00:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 15/40] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Topic: [PATCH v3 15/40] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdCwS/aZ9ROluC50yBBGsizpyEhLZb+mWAgAfEp4A=
Date: Wed, 8 Jul 2026 15:00:43 +0000
Message-ID: <846d402b2feac52f8c99a4bab566122e30b40eb9.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-16-sascha.bischoff@arm.com>
	 <20260703162302.6A1311F000E9@smtp.kernel.org>
In-Reply-To: <20260703162302.6A1311F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|FRZPR08MB10926:EE_|DU6PEPF00009525:EE_|AM9PR08MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: 611fb306-d84a-419f-d377-08dedd01d4ec
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|11063799006|38070700021|22082099003|6133799003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 pmVIn5zH0RsUBG6j6OvMMsFrH9gwhujsYOQ3URhmhBAtc2AufFhWfNm6iPcB3oovzpt7F7n0QNswvCEvuuggcRL7v0N8TTlZpAGHwEoCaPqWr6nICIPLqgerr0P1F0oI2iig6pdHSE8Nav5CaXv1wBGYCrNrRyW6YZGfS6bRElvuC+WedpFmU70DVPylxZDhZ4DwvGuqmzD9jWcAR7r6F5X2djlE2frgRjQBetqd62vYHCOXrlTCq6VDpMcCorW4P9MZ4xvLJ/tJEz1AHHQLgu5OaYzFAMY+HWlIPFo0GIEUbaFM4pWmv8I4eHVmHkCLH63x9P07JoQtojW/Vec4hI6kmchJWuRpOqPzfpo2rS3T0CKhpDhtswXUALvfp3gk23Iarqil8AYs3pVuiK4gZFLOWB8FMDe4M4veLu9AcrUIihOAFNEAEa3xPe+/9KHEUe6bPp0MjRHHzB8whK1AFkV0nfFPAPnjX78F/lmMEyrH2U689L/6me6UuaNfkcxQ3YiL8Wn+h2QIX4DnQmFL0kxUf9aQ0K+OCgG2V1okZ6JQ4aN05KNf685xgu/Jn7zyiRUxO6yTo9jc/K9mq/E81bqNRituDPjH0WMFmI71G8vHqhCd6nqPa47G/4QDCJVRDlHlKjwr4Lf7MEY+quouPd+W8sVkI5nztXJ4h3Q1qQQWlvXfPg9LOUuTwNStLQEeptNZoTA8VKLY2AQ6aXNBLDkbbfRF890Q83dmHIARarw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(11063799006)(38070700021)(22082099003)(6133799003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F605B4B9C40D64D9D229BE2C61EF8B7@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WzK/hiwDpNow7csLyTn+4IaGnHbuKccw0aP/gsaSJmW/oV7GM6uPpJwbaKpPAt0b+0ES0FIISAbSLspo0Fmq0lUHCzXr6CV+FOzC3+F8bg/nre5AGWMVIp4TMnHDtykS6gGA1SRIpGY88LE+JKOy7YMXSHd24ixbfjlWR1Ap1ldjoM6Wg5tSkYPBJe5pD7vkKoq7ZgrmYkA7rbTipow6/l9wvuZRtxLtL1NJ7gvXK6+1JAg0pd7Nqe+mFHULtunYjtq0pFngeMkMMa88/s1fp+pULSbgI0GJcQbv/rhZfaMWSNv3XPwrQt17Cd0+hkIWqysoE5+KopsCZObCSHHPnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10926
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cb4f1aba-4ac7-4332-e082-08dedd01af1e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|35042699022|82310400026|14060799003|18002099003|11063799006|4143699003|22082099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Du+LVQCFAcoG5j2imBFg/noMHFbs326wSeDo3Rd7+K6O4IwF0QVPtddiiqurno4RKD4Dz5B3VFUYENXhXktMr0O9kEZNyJs7weTSSF6wFV7+fv9j2CMIcQ9zA/k5FX8TA80nctvTBW7X3vUFZhu1IS0qXZxPOVlvFjgXZs79F2lYEDmPOGD6UfOogEvUF4FmneFr+q0E2mZX8Nx73dVO9ZE5JUrrlCrB2xJYBzK56VJFDilN2d76SKPIrF0YCILGICsV7y7nvmZMol2NoJToYMS9F9W3vqRKxZU1iYEwPgVFs3PQ02+KOxKzLNn/DEkdzzsehem4wssb+c2QGFTWtvVZtIaM7zDh9JvH4qks3kmfLV27g6xVrmcHp9ZjszdlGMu6GuFyHD5v9xHiO/O0DWRt//ldY49bSKDF3QTD0fbnXCMVDpeQhA/S4kTD+1wc0y/wd4ehUEs6wfXq7WkyMblehJfvxQL4LoBEQJl33cDjIJLs/G6ko699cL2jmbuOwhSKb3IjVXoweJJk8Nab4f56sHa673td3784FipJ0ULI7P6VIqeFHqLhoUYNqzkpWCzt/vBhDKqTqOHbwVLprm4viJMRPryoa9S7vyF9mCpU+jJUYKg/FBe3WWQHi9Fj3kvMTbCF4Z3cxNTvMgvlONXoiKnbFRz7N0v6Fyy2OyazcmP4/xNUsItvKAJqJWVGbp/zh1EPhsd+giFJ654vPA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(35042699022)(82310400026)(14060799003)(18002099003)(11063799006)(4143699003)(22082099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g3WNETAhNsyjCmZasfR1QXGYK7y+jlJsjKZNBvQqA+U51Y54Uu3M8wyKkOdVIlg9rB53i8/uXlJORQ/ktaN1fpfHahvG2Zat3xZ7JvjxB/plvifsUqpI9gJhFv43wgWdLGA6D1hbtd5gJXcI5ifHjzaYaet6kLw/28KODilPAW7XTPsYh2GrjT3LCiy8d0atgARLoBi4oENhEbQgWGYnGJVZJdmYc/dXsP2uPuWVeq4LfN7yww6LYvd3Ga7+Rrq8H8avWHOMxDJoXfvKWku9ZWuxpWagaOiiq4XEKYWgZqBpA7UeeBIbL+CNsbycW4h+HGTrGASKS+nJVwrK1lWocSAHvfaiCCCI9qT9xqvj779mk+ldfBz4AGYZMgMBXnQl1I1DIsDgbucJpBaq+WYs2wmJJPs66FL4TfRuLGVEjsMEii3EOxEZ10N4adk62NNM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 15:01:46.9023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 611fb306-d84a-419f-d377-08dedd01d4ec
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5908

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjIzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIEVMMiBkaXJlY3RseSB3cml0ZXMgdW52YWxpZGF0ZWQsIGhvc3QtY29udHJvbGxlZCBt
ZW1vcnkNCj4gdG8gYFNZU19JQ0hfQ09OVEVYVFJfRUwyYCwgdmlvbGF0aW5nIHRoZSBwS1ZNIHRy
dXN0IGJvdW5kYXJ5IGFuZA0KPiBhbGxvd2luZyBhIGNvbXByb21pc2VkIGhvc3QgdG8gaGlqYWNr
IHByb3RlY3RlZCBWTXMnIGludGVycnVwdHMuDQo+IC0gW0hpZ2hdIFRpbWUtb2YtQ2hlY2sgdG8g
VGltZS1vZi1Vc2UgKFRPQ1RPVSkgdnVsbmVyYWJpbGl0eSBkdWUgdG8gYQ0KPiBkb3VibGUtZmV0
Y2ggb2YgdGhlIGhvc3Qtc2hhcmVkIGB2Z2ljX2NvbnRleHRyYCBmaWVsZCB3aGVuIGV2YWx1YXRp
bmcNCj4gdGhlIGhhcmR3YXJlIGZhdWx0IHN0YXR1cy4NCj4gLS0NCj4gDQo+IGNvbW1pdCA3Y2Qx
MjBkM2VkMGU4YjM5MWY0MjJjMWQ3NWM1M2QzNGQxM2QwYjZjDQo+IEF1dGhvcjogU2FzY2hhIEJp
c2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBB
ZGQgcmVzaWRlbnQvbm9uLXJlc2lkZW50IGh5cCBjYWxscw0KPiANCj4gVGhpcyBjb21taXQgaW50
cm9kdWNlcyBuZXcgaHlwZXJjYWxscyB0byBtYWtlIGEgR0lDdjUgVlBFIHJlc2lkZW50IG9yDQo+
IG5vbi1yZXNpZGVudCBieSB3cml0aW5nIHRvIElDSF9DT05URVhUUl9FTDIuIEl0IGV4dGVuZHMg
dGhlIGxvYWQgYW5kDQo+IHB1dA0KPiBmdW5jdGlvbnMgdG8gaGFuZGxlIHRoaXMgcmVzaWRlbmN5
IGludGVydmFsIGFuZCBjaGVja3MgZm9yIHJlc2lkZW5jeQ0KPiBmYXVsdHMuDQo+IA0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jDQo+ID4gYi9hcmNo
L2FybTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jDQo+ID4gaW5kZXggMWQwMWM2ZTU0N2Y1ZC4u
OGQwODk2ZjUwZjg3OSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9o
eXAtbWFpbi5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvaHlwLW1haW4uYw0K
PiBbIC4uLiBdDQo+ID4gQEAgLTY4OSw2ICs2ODksMjAgQEAgc3RhdGljIHZvaWQNCj4gPiBoYW5k
bGVfX190cmFjaW5nX3dyaXRlX2V2ZW50KHN0cnVjdCBrdm1fY3B1X2NvbnRleHQgKmhvc3RfY3R4
dCkNCj4gPiDCoAl0cmFjZV9zZWxmdGVzdChpZCk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArc3Rh
dGljIHZvaWQgaGFuZGxlX19fdmdpY192NV9tYWtlX3Jlc2lkZW50KHN0cnVjdCBrdm1fY3B1X2Nv
bnRleHQNCj4gPiAqaG9zdF9jdHh0KQ0KPiA+ICt7DQo+ID4gKwlERUNMQVJFX1JFRyhzdHJ1Y3Qg
dmdpY192NV9jcHVfaWYgKiwgY3B1X2lmLCBob3N0X2N0eHQsDQo+ID4gMSk7DQo+ID4gKw0KPiA+
ICsJX192Z2ljX3Y1X21ha2VfcmVzaWRlbnQoa2Vybl9oeXBfdmEoY3B1X2lmKSk7DQo+ID4gK30N
Cj4gWyAuLi4gXQ0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAvdmdpYy12NS1z
ci5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS9oeXAvdmdpYy12NS1zci5jDQo+ID4gaW5kZXggNmQ2
OWRmZTg5YTk2Yy4uZjA2NDA0NWEzMWFlZSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2
bS9oeXAvdmdpYy12NS1zci5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUt
c3IuYw0KPiA+IEBAIC03LDYgKzcsMzIgQEANCj4gPiDCoA0KPiA+IMKgI2luY2x1ZGUgPGFzbS9r
dm1faHlwLmg+DQo+ID4gwqANCj4gPiArdm9pZCBfX3ZnaWNfdjVfbWFrZV9yZXNpZGVudChzdHJ1
Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZikNCj4gPiArew0KPiA+ICsJd3JpdGVfc3lzcmVnX3Mo
Y3B1X2lmLT52Z2ljX2NvbnRleHRyLA0KPiA+IFNZU19JQ0hfQ09OVEVYVFJfRUwyKTsNCj4gDQo+
IFtTZXZlcml0eTogQ3JpdGljYWxdDQo+IENhbiB0aGlzIHJlZ3Jlc3Npb24gYWxsb3cgdGhlIGhv
c3QgdG8gZm9yY2UgdGhlIEdJQ3Y1IGhhcmR3YXJlIHRvDQo+IG1ha2UgYQ0KPiBwcm90ZWN0ZWQg
Vk0ncyBWUEUgcmVzaWRlbnQ/DQo+IA0KPiBUaGUgaGFuZGxlX19fdmdpY192NV9tYWtlX3Jlc2lk
ZW50IGh5cGVyY2FsbCBpcyBleHBvc2VkIHRvIHRoZQ0KPiB1bnRydXN0ZWQNCj4gaG9zdC4gSGVy
ZSwgRUwyIGRpcmVjdGx5IHdyaXRlcyB0aGUgaG9zdC1jb250cm9sbGVkIGNwdV9pZi0NCj4gPnZn
aWNfY29udGV4dHINCj4gbWVtb3J5IHRvIHRoZSBTWVNfSUNIX0NPTlRFWFRSX0VMMiByZWdpc3Rl
ciB3aXRob3V0IHZhbGlkYXRpbmcgaWYNCj4gdGhlIHJlcXVlc3RlZCBWTS9WUEUgYmVsb25ncyB0
byBhIHByb3RlY3RlZCBWTS4gVGhpcyBjb3VsZCBicmVhaw0KPiBndWVzdA0KPiBpc29sYXRpb24g
YnkgYWxsb3dpbmcgdGhlIGhvc3QgdG8gbW9kaWZ5IGEgcHJvdGVjdGVkIFZNJ3MgaW50ZXJydXB0
cy4NCg0KR0lDdjUgaXMgbm90IHN1cHBvcnRlZCB3aXRoIHBLVk0gaW4gdGhpcyBzZXJpZXMuIHZn
aWNfdjVfcHJvYmUoKSBza2lwcw0KR0lDdjUgcmVnaXN0cmF0aW9uIHdoZW4gaXNfcHJvdGVjdGVk
X2t2bV9lbmFibGVkKCkgaXMgdHJ1ZSwgc28NCnVzZXJzcGFjZSBjYW5ub3QgY3JlYXRlIGEgR0lD
djUgaXJxY2hpcCBmb3IgYSBwcm90ZWN0ZWQgVk0gYW5kIHRoZXJlIGlzDQpubyBwcm90ZWN0ZWQg
Vk0vVlBFIHN0YXRlIGZvciB0aGlzIGh5cGVyY2FsbCB0byBvcGVyYXRlIG9uLiBQcm90ZWN0ZWQN
CkdJQ3Y1IHN1cHBvcnQgd291bGQgbmVlZCBhIGRpZmZlcmVudCBkZXNpZ24gd2hlcmUgRUwyIG93
bnMgYW5kDQp2YWxpZGF0ZXMgdGhlIFZNL1ZQRSBzZWxlY3Rpb24gc3RhdGUsIGJ1dCB0aGF0IGlz
IGludGVudGlvbmFsbHkgb3V0IG9mDQpzY29wZSBoZXJlLg0KDQo+IA0KPiA+ICsJaXNiKCk7DQo+
ID4gKw0KPiA+ICsJLyogQ2F0Y2ggYW55IGZhdWx0cyAqLw0KPiA+ICsJY3B1X2lmLT52Z2ljX2Nv
bnRleHRyID0NCj4gPiByZWFkX3N5c3JlZ19zKFNZU19JQ0hfQ09OVEVYVFJfRUwyKTsNCj4gPiAr
CWlmICghIUZJRUxEX0dFVChJQ0hfQ09OVEVYVFJfRUwyX0YsIGNwdV9pZi0NCj4gPiA+dmdpY19j
b250ZXh0cikpDQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBpbnRyb2R1Y2Ug
YSBUaW1lLW9mLUNoZWNrIHRvIFRpbWUtb2YtVXNlIChUT0NUT1UpDQo+IHJlZ3Jlc3Npb24/DQo+
IA0KPiBUaGUgY29kZSB3cml0ZXMgdGhlIFNZU19JQ0hfQ09OVEVYVFJfRUwyIHZhbHVlIGludG8g
Y3B1X2lmLQ0KPiA+dmdpY19jb250ZXh0ciwNCj4gd2hpY2ggcmVzaWRlcyBpbiBob3N0IG1lbW9y
eS4gSXQgdGhlbiBpbW1lZGlhdGVseSBmZXRjaGVzIGl0IGJhY2sNCj4gdG8gY2hlY2sgdGhlIElD
SF9DT05URVhUUl9FTDJfRiBiaXQuIEEgY29uY3VycmVudCBob3N0IENQVSBjb3VsZA0KPiBvdmVy
d3JpdGUNCj4gdGhpcyB2YWx1ZSBpbiB0aGUgc21hbGwgd2luZG93IGJldHdlZW4gdGhlIHN0b3Jl
IGFuZCB0aGUgbG9hZCwNCj4gY2xlYXJpbmcgdGhlDQo+IGZhdWx0IGJpdCBhbmQgaGlkaW5nIGEg
aGFyZHdhcmUgcmVzaWRlbmN5IGZhdWx0IGZyb20gdGhlIGh5cGVydmlzb3IuDQoNCldoYXQ/IE5v
LiBKdXN0IG5vLg0KDQpJZiBhIGRpZmZlcmVudCBob3N0IENQVSBpcyBtYW5pcHVsYXRpbmcgdGhl
IGRhdGEgdGhlbiB3ZSdyZSBhbHJlYWR5IGluDQphIGJyb2tlbiBzdGF0ZS4gV2Ugc2hvdWxkIG5l
dmVyIGJlIGluIHRoZSBzaXR1YXRpb24gd2hlcmUgd2UgYXJlIG1ha2luZw0KYSBWUEUgcmVzaWRl
bnQgb24gb25lIGhvc3QgQ1BVIHdoaWxlIGFub3RoZXIgaXMgdXBkYXRpbmcgdGhlIHN0YXRlDQpz
dG9yZWQgaW4gdGhlIENQVSBJRiBzdHJ1Y3QuDQoNCj4gDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsN
Cj4gPiArCWNwdV9pZi0+Z2ljdjVfdnBlLnJlc2lkZW50ID0gdHJ1ZTsNCj4gPiArfQ0KPiA+ICsN
Cj4gPiArdm9pZCBfX3ZnaWNfdjVfbWFrZV9ub25fcmVzaWRlbnQoc3RydWN0IHZnaWNfdjVfY3B1
X2lmICpjcHVfaWYpDQo+ID4gK3sNCj4gPiArCS8qDQo+ID4gKwkgKiBNYWtlIGFzIG5vbi1yZXNp
ZGVudCBiZWZvcmUgYWN0dWFsbHkgbWFraW5nIG5vbi0NCj4gPiByZXNpZGVudC4gQXZvaWRzIHJh
Y2UNCj4gPiArCSAqIHdpdGggZG9vcmJlbGwgYXJyaXZpbmcuDQo+ID4gKwkgKi8NCj4gPiArCWNw
dV9pZi0+Z2ljdjVfdnBlLnJlc2lkZW50ID0gZmFsc2U7DQo+ID4gKwlkc2Ioc3QpOw0KPiA+ICsN
Cj4gPiArCXdyaXRlX3N5c3JlZ19zKGNwdV9pZi0+dmdpY19jb250ZXh0ciwNCj4gPiBTWVNfSUNI
X0NPTlRFWFRSX0VMMik7DQo+IA0KPiBbU2V2ZXJpdHk6IENyaXRpY2FsXQ0KPiBTaW1pbGFyIHRv
IHRoZSByZXNpZGVudCBwYXRoLCBkb2VzIHRoaXMgd3JpdGUgaW50cm9kdWNlIHRoZSBzYW1lDQo+
IHJlZ3Jlc3Npb24/DQo+IA0KPiBUaGUgbm9uLXJlc2lkZW50IHBhdGggYWxzbyBkaXJlY3RseSB3
cml0ZXMgdGhlIGhvc3QtY29udHJvbGxlZA0KPiB2Z2ljX2NvbnRleHRyDQo+IHZhbHVlIHRvIHRo
ZSBoYXJkd2FyZSByZWdpc3RlciB3aXRob3V0IHZhbGlkYXRpb24uDQo+IA0KDQpBcyBhYm92ZSwg
dGhlIGN1cnJlbnQgR0lDdjUgaW1wbGVtZW50YXRpb24gaW4gS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBw
S1ZNDQphbmQgZG9lc24ndCBldmVuIHJlZ2lzdGVyIGEgR0lDdjUgZGV2aWNlIGluIEtWTSBpZiBw
S1ZNIGlzIGVuYWJsZWQuDQpIZW5jZSwgdGhpcyBzaXR1YXRpb24gY2Fubm90IGhhcHBlbiBhcyB3
ZSdsbCBuZXZlciBiZSBydW5uaW5nIHdpdGggcEtWTQ0Kb3IgaGF2ZSBhbiBwVk1zLg0KDQo+ID4g
Kwlpc2IoKTsNCj4gPiArfQ0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQo=
