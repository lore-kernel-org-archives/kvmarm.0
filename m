Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013043.outbound.protection.outlook.com [52.101.83.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC7A35B65D
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306524; cv=fail; b=ZjH4R3LkvlWgdyo8Yic7SarMGpRl3p26qK79piAdA9Zw06LNjov/uKyw3kRS2fewXNJpiMvem631UMi5Hp5q3GZJ4KYxz3oNPkvO01+IJ0jU6hnL/mDkttp20UPUnZFNhNY+SqBJGLGfF5CA3vR2YaRfj8P1NsEdnwr5xLXxnm8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306524; c=relaxed/simple;
	bh=jfRltuD4BbQHdL0+ou6+EucLMdBkiOJI1oiS5qq+a0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EdQP/fpHEQxh1q0yP32qKUHU2DjBJOyalctjj2fuM+dbDW7pV4oIa2s6iAuMWqBB5wbF4yjfoPTipw9c0rHOAJprzMedavprMZtjJ0uQTvUIHHFuchKxAyuczA84Q1h5fIRolPlEYBvquSZjrLAYbDF+DKp0GalJR170F4gjmC4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DBPl78JP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DBPl78JP; arc=fail smtp.client-ip=52.101.83.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DBPl78JP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DBPl78JP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ga9I9AP+WwaTHgedgPejSfOaAENqZDTue2SLCVztRlxbIOWgLyXWk6Q4NKQhJSlazEi1dlOT7AhsfZ2lTzTAo1iy14CC9UvcEex6UgvI5hUkXQmX3Bo+e4LSkrZX4wxcRkhee7edBCIcV6E7Kui7MAe8GJppCmK69yXzHORQAPFCha1v9M9LZimVmY+0WAOFPTSvVfkpB0P4+qswARDQlcCTFTjL/wMzFNsv0lqDDt6O47iGkS9zd3OoDAQixSZraVJOKjaWitmFRuqg0HxGoFk6mF09z1dDIFdZMkAk5uxx5OVydCC9nlZtDdM5cWz4ebF7Pdcw34yq/mq55EKEfg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5VFi2maa70kE+04cu7sHNQzBrE8DKBbIHmeCzWE3N4=;
 b=thDZE6epmqYgxwuR6FLPiYtNPE4pPTXQcMdyuRAJvSlAa90mFzgEHlnoYzclHQaYXv65MLy2GTCDc3FiISCMy5I8RFXnzMblHeZpwT0YbjIvtLX1S8elp4Ogi8aOmW5wvXyVcw42C1ZQJyHRv2ifJEoP3pGMXkiXJmeg6rsjz0ee5AorTM5LSIQSd3wnrRyqep682u5YTMgv0tmje4NIxy58gbVe+2PMwWLuTzwQhCpV62Fn/cEHbIa0sW/8yhTpY2bTyX/qz/EF0vcoaZVfaYKei/migWevMjgpAVVL2hNSGZSZbtlY+rJ1na9za/vq3NHP6ZHTRtY9FzyM39XWCg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5VFi2maa70kE+04cu7sHNQzBrE8DKBbIHmeCzWE3N4=;
 b=DBPl78JPGaQhpEiA1qAHrV7hNkV5lcW2kJ+tk+HS/Hrbl1j3YAljIDcre9uidXZalqHfaeFLjermpYvJJlOAMxfay/u+26LwS7UQSZo+7TZ9Par8fLVzjIUKeqseP4kWZUHUgpV31rG4GV5kxaRjGLyE7rmbJV1J3LhGs9XRtgw=
Received: from DUZPR01CA0086.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::13) by PA6PR08MB11582.eurprd08.prod.outlook.com
 (2603:10a6:102:522::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:15:17 +0000
Received: from DU6PEPF0000952A.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::31) by DUZPR01CA0086.outlook.office365.com
 (2603:10a6:10:46a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:15:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000952A.mail.protection.outlook.com (10.167.8.11) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18 via
 Frontend Transport; Mon, 27 Apr 2026 16:15:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lOO7ia2bJTY+oyKq6VN4f3yF38VA9AM16/7vpqnmzHxq7A7SNZzEahe9j7O0gzg0NDdWDik+zc2TSM+q5n81q4crW220K0bOXuwHOYoMCFgVXzG+HSwBGUBu6oN5YQm3Xmzcw4qkKdB2ctrIlqgYEn30ytg4vi5wngH21GdPWX3MDOJ332xkukA+eAvz0ENMy195aVabW7oaRnv7pRDNKqYQCQJMLWj7D6Io2bsKMN4m4tpUfr7FqhwGfGNXHUUKigKHFkvXe+Vwqpru3rhOg0ZIn/N0w/bpb0khRg/+HF3ZGwiD2MKmF4We26isv1ZwKRvqp5Jz95VwrmnLggg08A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5VFi2maa70kE+04cu7sHNQzBrE8DKBbIHmeCzWE3N4=;
 b=YOX+B22oXfK5PHahmfsBss0Oy7VdBsZO5rzZVnBDGKCONfvMN68zwRNYnnxQAIQuHutDDkwb0PrecXGTVKn14GlsoPJAr3QskIdC1/HmLi1Qb2dZ1nwOCqo8HSqufgjnz5ZJbExSkPb5ctbOHQ0pw3jOXgkGKDDEezjOE5ICyPvJzgB55sn7pIX6BcvJ8icgh0sRQS/I9k28hqhSImE4ZhuTL2ID+TJNQL99NRomxeTchH+x0jfQF5WquOrHhRv9fELCGhaTP+der8n1J4tSq/m+NP6XlyLlqXgA+d0Z6kwqfTC+yhs9woYYJARH5cvQwD6IzMKP8BsFAoaBhvzRMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5VFi2maa70kE+04cu7sHNQzBrE8DKBbIHmeCzWE3N4=;
 b=DBPl78JPGaQhpEiA1qAHrV7hNkV5lcW2kJ+tk+HS/Hrbl1j3YAljIDcre9uidXZalqHfaeFLjermpYvJJlOAMxfay/u+26LwS7UQSZo+7TZ9Par8fLVzjIUKeqseP4kWZUHUgpV31rG4GV5kxaRjGLyE7rmbJV1J3LhGs9XRtgw=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:14 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:14:14 +0000
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
Subject: [PATCH 24/43] KVM: arm64: gic-v5: Call IRS init/teardown from vgic_v5
 init/teardown
Thread-Topic: [PATCH 24/43] KVM: arm64: gic-v5: Call IRS init/teardown from
 vgic_v5 init/teardown
Thread-Index: AQHc1mDjOnRt1arRX0CkSwkmhkilkw==
Date: Mon, 27 Apr 2026 16:14:14 +0000
Message-ID: <20260427160547.3129448-25-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DU6PEPF0000952A:EE_|PA6PR08MB11582:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e3172c-28dd-40a3-7223-08dea4782ba7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 Azp2xt8DCEpa1Z4qleeAKYbDW8dR3H21s8Qnf2VSymAPtqLhKg4Uq/O+WQZhQfbZGhfhLKtDrBhNKQyYEfHUQjTBSVxF1/Q3hvYScDf4CCQcZ/sBtgKTpoX0/+77bo0IVZDGop6+gU0ZxxtucwRiONe2iP+rgGob4oPJTwgYTyg4IT7iKgx5zjMbD1P/tRZbtkfBGX/rO8irj2g1i14uVQAOg7/VThRioj0dsp91G85sxqTVwCox7kfnWEOPLsxYNoYxvx9WFRuX9jm5Zabsg2/Blp5FkOkRQ1GVycYnc+TOpF31K1yppIBTfVXJhoSP3r28CHnrUC9+fyE7i+culwAKvH9nP+22HmJwgg4q7euQX7D7KlxAsW4JPblpD/Abu7YvnAR/EdGpKqa7EKd4bwTjfJTGuQ1+YkttfbIDXZWkFdG9lBm0vETkf11Cif0P6CVUpxca6PZEtT3cLTJRwvqFac5XVbLA8CQA/1WIb46dRj0FucdEwPc8phq15npbQFBTp2YlSZuFwVOfvFnrB9wlf38HlLpgtqGE2G36hi+uaUSDRAe7hf+zmzfeWvoJ6K3vAZwdPCbg2R/uehAwq4m4jrCGHPW+ksp2abcAESpvJ7TbllmDps8FEFiw72CGz798hBXKnirI9o6cMfvRQBZOZfoxJg67yDJiCRcBQMv/C1DyUWG8vLoxnLVWkqXKNDusFnoKH5HWXuto1SpXwv3kpbRTzyhMRxEtXoJ8PsjHR4FESu/zyarY6473Q3nHmTZCW2+GSlNow13CR0wP+fB4ApEVhoEXDPA/CO7hf9Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MTQK+vVIIbNKLKMBJgDdDheeC76FbHQht3S4UO4NyMOoL4jWj2ef8LXXlWjAG4L/r1ODeRXWARZztduZHZh01yl70WrFl4eMALVsP4PrhUGqYGE8dnHQckg68fo45Lbm+Y6LMgZ32aakoO/6W8EbOFVnUFXFQjIhwG0GPLmGw9tzZ7OC3LEIe43xgCNgxxTO8L28goNxcEt5LLa7FLxruU2py6toZSKLf2jyJGExcrIYQLaD8PH3JS4uR2k9/7NeA81thF0jL9vAlA9ydRaV0X0lrad/Gr8krrNPLMDPm/TKmOzm/FBOOz3OJ6o+x/RrNJR233RE1LohwpxaqAAaYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000952A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e2ee24a8-c5b3-4259-b73f-08dea4780658
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|14060799003|35042699022|376014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Eky9NIW0D9+JKqtS1H1k5Ph2ZEu2mUByg4r95d91XMzZCz9kZgkhFDHkWrTEIOOBvylPALvaXgMgqmPx5mWRhnUUX2G5t3PLlBLl9uo0ConYqMXjAbrk3uYn4WKWjEsYMcZrRlKp4hTwQFYQRD9S6G5jfk67lJ6fkq7wARHUXz2H92ECQNRZz3LqSInBs20qDm06hToK6QzPj8HOS7qQteY5SDw4H4MeHSvYEKwz0TQlyNCFN8KYP84z8tp5V19+WVic2UNK99QsLM4LyKEXQ7KYMywsr4nOTWb2fnLrrFg3W/N/A/mYnCLcuEOa61SvsElr3HVq47Uc0xU79/KqV+79oJLJ1WXyPpLxTI5IbPCnPsNiRM03of96O5QFmKoRGsCFMfmDUlD18cM8VOyFj5I0WqJI2EvUXLht5Hf7zEuahXynlCUa0uBIhBpZneKiTAdscb5/MT/X23ewR/WdAK3NnhsRQGBQmZ7fSVQ6ff51riYZ9ps+VXSp08kAgE3JHg9XAPCTPEY4UaC4KCjyPxAEfbbxDQsrHaeGmOwuSkkAwZ3aiNKgTwCDJF56Nul1tjhb9Aul7SEbtNEbxMDTHY7k5jFZHnj3oVT4nXqAJw8gEWbosk/ZJYanMPcZqIweiM/bMIBFcB+ekhw1cDw6DJQgyJS2VqesjlClyDpNR/FDLsYCpMa4NkOYjSymkwhXGuiFlRx8oiUkvU73YXZaGkxR+RhstbwZwVpMhfLQrD17GJ+zL+95e4VGSpDOhjVTTAbUDhpeVScgSsR4BecvrA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(14060799003)(35042699022)(376014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IJ8CDkrzhIVuG5P2bWGS0FbLOUVRaCTYJWxRFG3AvUhKZwmCMqcDmc2V3PrFtvLP7iFXyWrRvOUuD7+WsYrTpeJ3E52A4aKmACWR+o8aadCUcrseNtqao6M+XAGu3GNw6g+jlLYlmV7kZQj+FJ3FVw6iqpyUcj2nFiI88A9XjMmMGQPGp++sE5qNHlJkSL5GtyNz4JAmtqr1mcjUgeCmtVOMuNXXv2sHiY4uv/VBLGsK09zeqETM/D4SCZL83N9RfdCja4NWY60e4jbq3ZD93oua3D2NxjBxB+D140Ado1mh9lJks4hLxIZj8ykSzU2R7iu88khizjga6JEhgLFQjCFMcCkQr0ZuQjfiNNIyg6k0rt9GHMpWshTkZP+X4pbD0h48tBNKSLOf9iOhY2D7WCAxOzyB/Lzxd+FiL3B/PuiP1FpI//C5CvG5rnwJ3/Ue
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:15:16.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e3172c-28dd-40a3-7223-08dea4782ba7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000952A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB11582

As has been the case thus far with the GICv5 KVM implementation, it is
only possible to support PPIs without both interaction with the host
IRS and providing an emulated IRS for the guest to interact with. Once
an emulated IRS is added, it becomes possible to support both SPIs and
LPIs in the guest, and hence it becomes possible to run something
real.

It makes little sense to allow VM creation with only PPI
support. Hence, as part of initialising or tearing down the GIC, also
do the same for the emulated IRS.

As of this change, GICv5 VMs support all three GICv5 interrupt types;
PPIs, SPIs, and LPIs.

Note that further work is required to properly support SPIs and LPIs,
but this change represents a bit step towards supporting a full guest
OS such as Linux, rather than just supporting simple PPI-based unit
tests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 29 ++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-v5.c   |  6 ++++++
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 984908a271c8d..cea8e963ade66 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -182,14 +182,26 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			kvm->arch.vgic.vgic_model =3D 0;
+			ret =3D -ENOMEM;
+			goto out_unlock;
+		}
+
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -461,6 +473,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f12e96bc5fa21..86cfc08c557ba 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -867,6 +867,9 @@ int vgic_v5_init(struct kvm *kvm)
 			return ret;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+
 	return ret;
 }
=20
@@ -877,6 +880,9 @@ void vgic_v5_teardown(struct kvm *kvm)
 	unsigned long i;
 	int rc;
=20
+	kfree(dist->vgic_v5_irs_data);
+	dist->vgic_v5_irs_data =3D NULL;
+
 	/*
 	 * If the VM's ID isn't valid, then we failed init very early. Nothing
 	 * to do here.
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f8ecd19acc06d..3a2dfbd5210f2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -25,6 +25,7 @@
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
+#define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_NR_SGIS		16
 #define VGIC_NR_PPIS		16
 #define VGIC_NR_PRIVATE_IRQS	(VGIC_NR_SGIS + VGIC_NR_PPIS)
--=20
2.34.1
