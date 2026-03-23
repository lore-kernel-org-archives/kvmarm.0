Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011013.outbound.protection.outlook.com [40.107.130.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E1B399359;
	Mon, 23 Mar 2026 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774267089; cv=fail; b=T3z1hXABlP5NyCo8jgS7YDOmthag0VmPdCy40hoKrwKytnlJrmZCd9u/MHxwYW13xervXs63rpKlg1SOaaa9HP7m56zyMDHooqtA8P3ghWR77VEr5A9I5TObwP4haSILsw82KsIbWybRb0KziWGQrGjHB9CuF/VxrlNBpDg2PyE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774267089; c=relaxed/simple;
	bh=EFqA2lRUN5tma2U/d1g57qdCkBE7RB6hxW9z33vPCuA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G/uiU8sAd6ll5DCipusppjRXk2InuqtQ2ioueyQHMG4HQu3AhDRb1B030yh/Vt7ARsfmz9Mo8+ol16f4Tlqq6RZZbBpH7bYplPnHezkze8vCqQRY+lOp1tfQQmguB1C8Lrd1PKonN1pyQ+WriO+VP9kXxmFuTVxWzpDvoeJgps4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I3rvDY6H; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I3rvDY6H; arc=fail smtp.client-ip=40.107.130.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I3rvDY6H";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I3rvDY6H"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wz6WJZ5dty4DEFeG7JM/cwpilpMmHnNYsm5bogoFV7uy7WK/25g+vI8QarRtOAPLjzvvaMkNfIgd7NkwTUieimAMusEm6dK9XG74ZEJ5TMq4QSgyp63mHjxayjlLBYN79Q9/JlR4+RhIwPCpYpGESYcTXMqo6jk4aTWCwMq815czkdyRyztCZ4pCqqfKxF6bKl+OoX3QRVuhFcGSf51b4U2+ky2sVT87OeNENKdXtNni6FKhVt2Cf8b3pArJ9aJRCYstooUZ3jAVK0vyI7efQaRJxcLe0ZqNBFMiU7dUq0OOUADvIPGg7O5GqSxR+EIzWHsA4PUxdSy/AhlttxADow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLDohBEinYpX5m0/m7PVDrTeAwbT5Vj2BiEWaOfbYq0=;
 b=Gcxutsz4/tGCBF9+Lty2BLKakJZ6rVHU1qurwDmMo9ugz/oWhZnpYW/o2JfrHDsTemxbzeA+FrF+kA9UydDXiYH9i0Na9K64oDoXrlo9XyBtBYoCr1MFvIfnkQlm4rjY7FbnL/5nsYqr1N2o/ZXEgZSjjZxkA3WOkfE2svuDRG7SxY86ljYYkIdnKjoL0PouHBBIRFA9mWtafYsGtiKz1qQMpi//SvhFWRFST+uP/iZgx0VWABR4cP9j7G9u59w2L8wRSb6I9fu4OPOM2oCXoKAn890DbABuGKji7DcHjvFhRAaNkWsv8o/9RQtFZfA6vXZpR3aj+/SxCQcm6xaUZA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLDohBEinYpX5m0/m7PVDrTeAwbT5Vj2BiEWaOfbYq0=;
 b=I3rvDY6Hy6hFCE2ZxnJ2M1oe0C56Dn+3CVFMYJP5GryBYoXju5LQOj4/HEEyCTvRgmxPLWOwKGkI6I2ch29CBhRdVtTG7i2GyL/ozv7VEieahb2ARLbv634CyzQUNmYZOqS3Vfif3wo24SfRrzNIRiD1rnGk8EgRQ6vEmYYft30=
Received: from AM8P190CA0003.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::8)
 by DB3PR08MB9900.eurprd08.prod.outlook.com (2603:10a6:10:43e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 11:57:57 +0000
Received: from AM4PEPF00025F98.EURPRD83.prod.outlook.com
 (2603:10a6:20b:219:cafe::21) by AM8P190CA0003.outlook.office365.com
 (2603:10a6:20b:219::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 11:57:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F98.mail.protection.outlook.com (10.167.16.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.0 via
 Frontend Transport; Mon, 23 Mar 2026 11:57:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RpRO4tzsgCBDUoGDOWk3qZIM5QM757QN7TQSKJsT9yHQp9NiSg5UKV2KlMvCpcbMzN80X320q579MsKcNwFODb2J07LNQjyfBzparcuASu/ocIL5kS8pbSB1YI42HNQZ8T5wQseMmP07j2js5h/HatLg5xRlvdXHZly9ZcZzPcCbATUl+dSSZQR3b+PPkdQX2DLA2CjFq6xKnKCdnnp+32Aru8DwBgC+oi6MyZZDvJGg9qQTWj2SFwIWg61hkCkVDE1nLi9ZVvgBaDGaMxV4TbB8ZF64Ww8KGNRpKSJkcPvhyYp32LkbWxJQ7JKTGgLxnSQLoaM4dVJ0nNY6m7n85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLDohBEinYpX5m0/m7PVDrTeAwbT5Vj2BiEWaOfbYq0=;
 b=M/7JajxNIi3YIbOtE4t58la9JAcczIu1Aa3uI6t4L6uWkHElGzAM/MmGJ9aSQo+6LfqKPZ9XjGZofMaIYteECvD+Gu1StvxQm8el80GXeadS4wsEw18V58TGZCXdzP7DDgSM6iMENKTj8skMTpT7IOy0A1orXPqhoZnUCV052KcJbgIUaBQ3V1xJ6Yx/apS+SzHIQRpmhenqoHfV/ZDZy44fh9t+m+rbKiZHGUrQYxGVnrkV2rkVhiuStUwryG8nHa93smSiwMYxG5byYh2rkELVv74Se/l8TQqf8sIwjYhqVfLez1cRkynYneV6YEF+7Ke2RsgztaSB+HOD0YTFiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLDohBEinYpX5m0/m7PVDrTeAwbT5Vj2BiEWaOfbYq0=;
 b=I3rvDY6Hy6hFCE2ZxnJ2M1oe0C56Dn+3CVFMYJP5GryBYoXju5LQOj4/HEEyCTvRgmxPLWOwKGkI6I2ch29CBhRdVtTG7i2GyL/ozv7VEieahb2ARLbv634CyzQUNmYZOqS3Vfif3wo24SfRrzNIRiD1rnGk8EgRQ6vEmYYft30=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PA6PR08MB10420.eurprd08.prod.outlook.com (2603:10a6:102:3d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 11:56:53 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.022; Mon, 23 Mar 2026
 11:56:53 +0000
Message-ID: <bf4ad5b2-7bbe-49b2-86be-cbbead1a3d29@arm.com>
Date: Mon, 23 Mar 2026 11:56:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 17/48] arm64: RMI: Allocate/free RECs to match vCPUs
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-18-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0210.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::17) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PA6PR08MB10420:EE_|AM4PEPF00025F98:EE_|DB3PR08MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: e0e948b5-cd1c-4c28-8506-08de88d36c66
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 IfzW3ueN9YfORzAklE0kKul5wrq3FF/61ckRgcmponNHCvyF5S2ezmxIO3lQdqIVRA11NaZRxvaeB0Cz645Q5KWIffzhFCyUxJ3f7ttYxhcOMZkuT/OMKP2+agQoa5W+WQ+vT33rCOaGpjUvEQ4yW898giPng5KgzjQOIBdaX0TyEBFmtCRGh2uAiGU+fA0sXVkoTUhREsCud09zwKdkg4Qyl12qUu9YujkmYdPOPfrsMkiHnNTUcYNWDJe7P0LQSuvO7erEviS/kdr2zZnxRWRRd3EQ7u6mDdassXvOx4+IyimXsCulx4w28j1z2A4NBvT7nVbidYXOJLvjy+q/VwwdKYvMnXn57iOuvVW4EsnY5zZ6+1gNLrphqm1YgNyB9A4Z3czkGqd7AFo3et/s5exu78+whOBY+YkQNRTihj7mBdEZUZagxtYYtjFyHi18INL/545mozveU+GmWSgBF8OAHA+HNCy41WWdr/AMVYslkP84iLxzckQiVZ+TGJZHBqMZSveTRnNJ2DvULfYs69aaqDXYysfi9qed2XudoYnwre2NVr2jWUpDfS7FCjbQ8IcLmMsSyGGaeX00k/U6IIZnwl/sHvLgnLm6NJ5YEJqB+C06ZwoxP3Z8GsLMmDqlPpY2G69u0goRvM+PnTpipNbgDXcF90Da0EplNKJx954uvbuaYEBIPKqGp5IJB0CdsVTBY/is5QaAu71RRa7oKRj4d9io2LaGuPAEDKukrPQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 DtkeF6l67icx+3P8tTs16mYjmgnc8o/9xJYlRztgFJYRntVHnKrNKOCCzNWxXVu2omPc18trw+c/98j3qr2HZqynJf4NtH++Qk307qewGPHHaRXUWZ48Ih3x09MIXDBMRn8oZck9hyj9nhfMhr238OwL4/PDwZBl9aruNr4Rrh0FwtBKlJ7BnRI4siWX7YszvGZnzaDzC1Bnp2YxLKjBJApGvJHyqK3C2nqMcQQgg5JWnr+7XRn5kW9oW/GwLWTlYFEShbFy9+zVtsVBl1y+vFCURHVR31wjaeFQcp0j49PMJ2Ye5Fx5upxr2EhAzI9EEF284wixDPXib8P+VmmIKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10420
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6fc192a5-5070-4c84-53ca-08de88d34662
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|7416014|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RmMZwRzCWyO+cI3zXhRMUl4E4gV9cW4ufXktnsdqNcfJj3V5MEXLPGLGj1hWzr7GIUudknTti4NDfzdHyGHVmtLYhzjHH1FM6c5uCfLHOu6SqCpr5BxOfAP7V2pFtm2KUI3HthB1FicOFQHI1XZwo9R+ffhiMlGlvQIVEmtluUGLQJjNcl2iYAZ/mHSOWKwW6JbA+GiCpCaFDcOT9GRlr31QaUQUJZs/9id5nsAUVTONy5iIW/lnyvIaSufTHmP17ovtOQfP7ZUs/LAusFPIyubBGTOK1ArsqQDtXWDEdmPrs+YptuVKAOwTJWdxQQKAYD0Go0W4RcWisRkFB/CB/RX/W3rauH6WkYyr8Wr0z2Z9FP2kzYLOoV8VFf3lItqM6Xb3x0YWzyeriZqfddCewBwcrp+0aroYDsXOHf7Uez9FuOXX21t0cT/oE9kI7A8xrQUpUx6cqeuSSmQtT44rKEX365Ub61t9xWxGMNGyZDMqfeiZQWABHRstb6BcPPOTmn4DllCMC9AxdAfNdYrg6oRSIyCVckhUnggmgzHOVwSiYufLvCcbvO6yIPYIvqrPJ1NuGFQtIR0h0osWbryRdIdN37IsSCiPSbsw5RWgSLCeTD0T5DtujWTmm1CCtP+Idc7pYeQvcd3Y8oEwm9M6+HgI2fblEC+yyhSxfWAGs+YqL+cnyxTzjYlpIKd7bKfIQFD5qtus5JEMqfAVF28siSmEkT6UjKxRon7L6Ik/GGrQdyRBtH81syyquFyd8myrpoGPWbCOO7AknLv45GICcQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(7416014)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6xb9hu6CArTc68PBg+BxOhBFCoXP9ateLwEuZLXVrQtojNkZk3xn2TM8SXkq023Fe+6gV0cYOeKFzGJLamo47sVS7BKBML6fSiNJT8BaSFvuFkAS4ccspOX/ofUBOsKMSaizPrL/B7FrDU8ET/VGf/cptuHOZr1oc0v8RmgeioUjMxh9362s2tznL6ej3fUr91TfejSrh9QvV5OGodOroBRcTt67vPdM4VhrLHsneufv0E/4vxNhMnwTswuSvPrvOHWy9hsKx+dknMHIZ4RGBqRCvfpcxqsZmbgqsTCeibPhspyTcSVRm6aP3Vozd1Waa68dUbQAopMfARY+2GWZoZEDGoAT03WiswhI6iWZLFH9TSGJ6zmIJipdN1Tp/tBxr558+aHIU3WIMLQc8BGDG+tSo7bsNuokG5ew+5nL/qtyHjzXVcpzMlZMv7OROKGt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 11:57:57.0113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e948b5-cd1c-4c28-8506-08de88d36c66
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9900


Hi,

This is a NOTE for the fellow reviewers. This patch will undergo some
changes to handle how the AUX granules (metadata storage for RMM) for
the REC (aka vCPU) will be donated/reclaimed with RMM-v2.0.


Please see PATCH 48/48 for the changes with the new Stateful RMI
Operations (SRO), for REC create and destory.

I have tried to mark the areas affected below.


On 18/03/2026 15:53, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * Use the new range-based delegation RMI.
> Changes since v11:
>   * Remove the KVM_ARM_VCPU_REC feature. User space no longer needs to
>     configure each VCPU separately, RECs are created on the first VCPU
>     run of the guest.
> Changes since v9:
>   * Size the aux_pages array according to the PAGE_SIZE of the host.
> Changes since v7:
>   * Add comment explaining the aux_pages array.
>   * Rename "undeleted_failed" variable to "should_free" to avoid a
>     confusing double negative.
> Changes since v6:
>   * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>     realm guest.
>   * Support host page size being larger than RMM's granule size when
>     allocating/freeing aux granules.
> Changes since v5:
>   * Separate the concept of vcpu_is_rec() and
>     kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>     the indication that the VCPU is a REC.
> Changes since v2:
>   * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   2 +-
>   arch/arm64/include/asm/kvm_host.h    |   3 +
>   arch/arm64/include/asm/kvm_rmi.h     |  21 +++
>   arch/arm64/kvm/arm.c                 |  10 +-
>   arch/arm64/kvm/reset.c               |   1 +
>   arch/arm64/kvm/rmi.c                 | 196 +++++++++++++++++++++++++++
>   6 files changed, 230 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 39310d9b4e16..d194d91fbc2a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -708,7 +708,7 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
> -	return false;
> +	return kvm_is_realm(vcpu->kvm);
>   }
>   
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9267a2f2d65b..64304848aad4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -924,6 +924,9 @@ struct kvm_vcpu_arch {
>   
>   	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>   	struct vncr_tlb	*vncr_tlb;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>   };
>   
>   /*
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 6c13847480f7..4e2c61e71a38 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -63,6 +63,26 @@ struct realm {
>   	unsigned int ia_bits;
>   };
>   
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	/*
> +	 * REC_PARAMS_AUX_GRANULES is the maximum number of 4K granules that
> +	 * the RMM can require. The array is sized to be large enough for the
> +	 * maximum number of host sized pages that could be required.
> +	 */
> +	struct page *aux_pages[(REC_PARAMS_AUX_GRANULES * SZ_4K) >> PAGE_SHIFT];
> +	struct rec_run *run;
> +};
> +
>   void kvm_init_rmi(void);
>   u32 kvm_realm_ipa_limit(void);
>   
> @@ -70,6 +90,7 @@ int kvm_init_realm_vm(struct kvm *kvm);
>   int kvm_activate_realm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c8e51ed009c0..8c50ebd9fba0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -575,6 +575,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	/* Force users to call KVM_ARM_VCPU_INIT */
>   	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>   	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	/* Set up the timer */
> @@ -1549,7 +1551,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>   	return -EINVAL;
>   }
>   
> -static unsigned long system_supported_vcpu_features(void)
> +static unsigned long system_supported_vcpu_features(struct kvm *kvm)
>   {
>   	unsigned long features = KVM_VCPU_VALID_FEATURES;
>   
> @@ -1587,7 +1589,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>   			return -ENOENT;
>   	}
>   
> -	if (features & ~system_supported_vcpu_features())
> +	if (features & ~system_supported_vcpu_features(vcpu->kvm))
>   		return -EINVAL;
>   
>   	/*
> @@ -1609,6 +1611,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>   	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
>   		return -EINVAL;
>   
> +	/* Realms are incompatible with AArch32 */
> +	if (vcpu_is_rec(vcpu))
> +		return -EINVAL;
> +
>   	return 0;
>   }
>   
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..4bbf58892928 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -161,6 +161,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>   	kfree(vcpu->arch.vncr_tlb);
>   	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>   }
>   
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 937fababf960..6daf14c4b413 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -207,6 +207,28 @@ static int get_start_level(struct realm *realm)
>   	return 4 - stage2_pgtable_levels(realm->ia_bits);
>   }
>   
> +static int delegate_range(phys_addr_t phys, unsigned long size)
> +{
> +	unsigned long ret;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
> +		if (ret == RMI_SUCCESS)
> +			phys = out_top;
> +		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int delegate_page(phys_addr_t phys)
> +{
> +	return delegate_range(phys, PAGE_SIZE);
> +}
> +
>   static int undelegate_range(phys_addr_t phys, unsigned long size)
>   {
>   	unsigned long ret;
> @@ -372,9 +394,177 @@ static int realm_ensure_created(struct kvm *kvm)
>   	return -ENXIO;
>   }
>   

--->8--- Cut here

> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i;
> +	unsigned int page_count = 0;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page = aux_pages[page_count++];
> +		phys_addr_t aux_page_phys = page_to_phys(aux_page);
> +
> +		if (!WARN_ON(undelegate_page(aux_page_phys)))
> +			__free_page(aux_page);
> +		aux_page_phys += PAGE_SIZE;
> +	}
> +}
> +
> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	struct page *aux_page;
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (delegate_page(aux_page_phys)) {
> +			ret = -ENXIO;
> +			goto err_undelegate;
> +		}
> +		aux_phys_pages[i] = aux_page_phys;
> +		aux_pages[i] = aux_page;
> +	}
> +
> +	return 0;
> +err_undelegate:
> +	while (i > 0) {
> +		i--;
> +		if (WARN_ON(undelegate_page(aux_phys_pages[i]))) {
> +			/* Leak the page if the undelegate fails */
> +			goto out_err;
> +		}
> +	}
> +	__free_page(aux_page);
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +

---8<---




> +static int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{

...

---8>--- CUT here

> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;

---8<---

> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}


> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(undelegate_page(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	rec->run = NULL;
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (!rec->run) {
> +		/* Nothing to do if the VCPU hasn't been finalized */
> +		return;
> +	}
> +
> +	free_page((unsigned long)rec->run);
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +

--8>-- Cut here

> +	/*
> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
> +	 * pages will be leaked.
> +	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);

---8<---


Suzuki



> +
> +	free_delegated_page(rec_page_phys);
> +}
> +
>   int kvm_activate_realm(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
>   	int ret;
>   
>   	if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)
> @@ -397,6 +587,12 @@ int kvm_activate_realm(struct kvm *kvm)
>   	/* Mark state as dead in case we fail */
>   	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
>   
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		ret = kvm_create_rec(vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>   	if (ret)
>   		return -ENXIO;

