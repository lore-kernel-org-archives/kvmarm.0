Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A742DE709
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094481; cv=fail; b=iUtAuQm83weIlRWhOriS3562MZZanfLTzpABw1kmTkdERbbOMLXLeFOqm0WfqBbnzIiFxDt2Jrd7lXK89hxFuhrxB+OhQuH5XlVdt81RZED/TbuReJQXQtLsjssuxPn9qni0/kNGFrMz2PCMaj7/hTnjLtgRUDKwwoyBE2Twq7o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094481; c=relaxed/simple;
	bh=cgLTExn/0dTE2MV3XP573SDzRp1xA9leFLgiPJ05S6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fY/hGg0LqPkN1UpSPyj3rYZ5SSKQ3vNGbjDTBrHnYSKLR0ZULpsZoe/H14X9jmF4wzh8yUDVUfl1WUkGOeqwjw52vojgvTTXHRusecuZ3ojO8oE3f6FQvd3GWCjzIm2bozEg39J4cXE4bSt3Rgt4ZmQetfW6QCjtCZvNf++d86U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RbgZsWr9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RbgZsWr9; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RbgZsWr9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RbgZsWr9"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=urdvB7zZJFuh4oxXv2P86ueGvShCprcOHxFbkrH1muL/OXwuvc8S5qcAqWZnHCmhSvL2I7aDXJH6lp/rW/Cs4uee+iiDpU4n98sh1bFW1+IL1jHtRK+xHyv9guRqNO3f69KRqW7Kk4asTzHLyCMOoz1UoAiFJ8KPqJ0Fcm9ikWpfRaIjDDEGfyB7T7EsUxriJL5r1UshHJTBR8Y+IEmD0IaXnTpryblhFd8NwAppaJdBTvIOVVLXMCA+piUgvacYtZJWkV8cL6RmkmxJ71/cy0a7ao2i5zjB4B6dALBfL3LTZINlqEaD3xBTZDk8Sx2eyUy4HHG/FmuehnAr2AHFXg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=j5/hsXIA99iqFBdN5fbhUm+t9epQn/FaZLnjjM0DgycGaxWoeaDGCChVFVcRJc5fbT2uTOAUXm0GF7rjstmjDna5NkGyIPWNAHVKjUJEbnxEESM2IGoU0eJf0Y+M0odtX8sir47xWbyiC53dEZOJlPg9Ec7v035q34NtZagZSI68U61gCHqXghomkHk48lfx6vq+h4N25TUW5kzIYvHKxc2DSX9jOZLFxryg1WXI6Jax5c692CPU/UVO9guMtMHRHcOl1lU3yABq9b+gY5UiOEA6CvXBW9SC046884O7LZeOhG4EeVWGNab73kxIL/fio2MEQ2bjUs92/8MhpGMGrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=RbgZsWr9wWyQ5RJjM1WTiCPePu1+CcPasMxI/rX7t0/aV8+Sda3Bu/fFoimvp/tuoLOmu+EbsERpNL5xfbxePcpIpVGyO0OG73h/ofCN3MDydKfk7w7JLEwD/rHVa6WzkwoT53t8Jv4RmalNMQMG6Kwet714tH+WfXGuaHwqeSY=
Received: from AM9P195CA0023.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::28)
 by DU0PR08MB10367.eurprd08.prod.outlook.com (2603:10a6:10:409::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:01:15 +0000
Received: from AM3PEPF0000A795.eurprd04.prod.outlook.com
 (2603:10a6:20b:21f:cafe::8) by AM9P195CA0023.outlook.office365.com
 (2603:10a6:20b:21f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Fri, 3
 Jul 2026 16:01:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A795.mail.protection.outlook.com (10.167.16.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:01:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xcfaPF+VIdBO7sSUFswyVGqdepOwZ3e4FkqnF8rqMIlu8wIj7OJl86gpvdu4RgVFKWSbM3kUkysOwO4fGQpGw1AmL5yBnk4XEVOwwjBA6PF4gjQu8ztjP22ppPECTX1CANUbc55WEadLvZuhwNB7mrmEZIlr75bBWIYgd0lME0tSzsqXBwWncTshoiqn+OKRkuj2vOyEYyuBMZhi56N7unIt/cWxedWF5muh/J05HlDI65V3cjOU5x+gZRxBhsotT7lchzs3FU54khnztjADSq7S2XQnXhcQlnUMQxUQEREg6+KGUDO8LESDr4Ojpl84DLX44Iy9mwYQjHOeNF5S5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=Q/zSdz70XWPx+aJGyi7Xt9Cp+kLaqZ4Qe4QLOEnx2XPM4DwP8YelIFMTQKMAeIUcuYd2/Lt9KoXjKfE6q+lsQ6O7ef6pnf+rlcyTvBBHZC/CMc4FEOtUsWsaa3gAg8P7DXcaSDRIMirFUhWJMkYdOCT4OdIJfTLlXXB/tCWvxlmW3C2uHUBq4HaEoK6jeP5H8GE1PRor2D3eG1CRsMP9R9QfttJu6yDtL08zbH73RbEclANHPM70zCPPFp6mGZ/By4L6J5J/WPcjWJO4o3c6G2pXnsm0xP+8mWQaKBnlKjWLFiOkTB0vkb4pKxBfRfw7L00Jy2PIhg6gYY1p8KFQRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=RbgZsWr9wWyQ5RJjM1WTiCPePu1+CcPasMxI/rX7t0/aV8+Sda3Bu/fFoimvp/tuoLOmu+EbsERpNL5xfbxePcpIpVGyO0OG73h/ofCN3MDydKfk7w7JLEwD/rHVa6WzkwoT53t8Jv4RmalNMQMG6Kwet714tH+WfXGuaHwqeSY=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:00:13 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:00:12 +0000
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
Subject: [PATCH v3 19/40] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH v3 19/40] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdCwUI1v8t3siFykWkIgzXtjHxSw==
Date: Fri, 3 Jul 2026 16:00:12 +0000
Message-ID: <20260703154811.3355680-20-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AM3PEPF0000A795:EE_|DU0PR08MB10367:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e6f2e6-6bd2-42e5-794e-08ded91c5008
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 kKj6TmjRDwjerzJROMhl30tRjC/KtGfM5c5+ILEQnYmcexlzzB9axXO4cIpEXWBioL8oJlAG7y7EpidQwXAunxbGQ8DeGtdbHyLF8UqHe9iKMdXrb6qR03+N9tGm9lKpEsYAYer7NnI0lMMIxadCRy2LMQ1nB1Y2RXVrEksz7knIctAKQWAgSiiUutriwcNKVLHzuDQFECMMmoCX6P+3G4ciNs73sZ+J9c85utbw1YBkm1bnOGw5RYSJXusF3AAscL0QRtqfpIaG2PRpB795xtuD/F+Yw8gw6wJq8AyUduIRIsxFnMgJ9k1xAge2I1/qUg9XzsvMSzztVI09+ssbUH3OJPg+wTRgL9hBy0gN0kqEfxqaKP9TRJRucjCiMBjqqVTMbD65/aZKBt1l3YeXNW1pErGUj02jEqLukCrB8onS9npD8HaA19pHh+m+LXD+g0kWWmlv2sukYK9aaYrMHJcdtxF2PVjZlsgS8404KHwXWl7tXyL9FV5hnzDGvIJ3/iGKZlGY5aDTl123P46tMCnj+VwTlc7FSFUhBfcpNQRLpCVGyISzx5PVRZMNLM1EOiiMUwl2x7kALpz0A2lIBMh149GAGt2Fc0n9FYJtdQXSYUvobdtpsIqPiAlwwMZ1idXm2Ilg+9BnB5lVM1WYCBF+oclNxtXYdPTxK2m1zrlURhFI3Im0+ooGNwu8iGnLquf6+f4MPr664t2JhoZe4Q77xlPck0vZXJyn0CSxYmQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 K49hNxVjE6qO02Gf2oK20r4vPH/qEccK0oHlk47nHbo3PYAaEtSTqZzbdYDNnZRKhNLYb1OiMrMgRxLeqNLmU8HUmUNoVsmKScISnlzZud2GOT03bxsf8PVAH3oMOkZXNPeaRtHDuV55RaXXo/lHCGZZJG02dmol3/tVOtVkmgCgarFMjwVEo5tTMiA9/SvLSyEoJ5eoQ8DIk9YT/estPCkx4qesqyxz4TX9lvJS2LiWk2pykXnhOU9BkXp/QpfqDSkP2Yxe6cnXbVmQuXSPRdHyE6zOgkKpW0hw9Lf/pZ+XEV6oFLV9jsqVIFOw7V1O+DHETuKEh9RgYcHA4uLOdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6e66685b-79af-4d85-71e6-08ded91c2a88
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|14060799003|376014|35042699022|22082099003|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	6Rqq953b2J8qR7HIX811M0L5R1dQfLOj2VgeresBv+PBp0+XW4ArcxhE2/Gr+71XmXfuzPQuRb8jA/qCKOi64I+83Dsn2v5gUZDFtmC91lw+Vggq5q6EJgZzlVKHyVm6VaDMQT/R9Qvrlc1o1GX8btHVsHVtU4NgQzJDE04cVaJZ+dp6qW9XNc5rY8MlytfjV7pV1OzN4Msf2wb2thyJCnErkVvDyIYII55G5ULzBEzxkPChBAyN2SLTFSYVesO5sdpWfKhIR3RYqUBzinlemrxdp5uc9rQsRacpNzxE8KtwWs9PLk9uSgEeeZQLYzk/vKxVNSmopgjINxzFYDIYExrZKDeCziL/kEXZkdkVxvZF4SpTIt4hBZd/5dQU5Zc5uzT3b1N6k030G0SsvIj4TwzUJmySxB9YDfwPNAvDR/92JlOipoWyczvpql4hY4oVnrVVGUa0ySZrvUGQnaEb+YpRFZnRRhdYSyI9RQlxDM4X2BcgFQp0p7en1YeZy+xji1WEaZqMf6/KiTO3tte+MQUdM9YdJ+g4LaaX8/k3OcCjkNXedazTX/Kkin+gqpwtp5w0Z4rUejhj5MuK+maLEaStnOb8cy2pvBXM21aORVRYsbh33A/NovtGZGZ2XPgoSCyFRJ/ZAzCZ1QoaB4OXfprqqCKtV6YQmjyP1FJcS9irjj7AoFnktPcmUpmN15D9oCiGs3f5NdTet6RXs/nhSg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(14060799003)(376014)(35042699022)(22082099003)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mp8/7blGjX+g1kvuaFkY8VHQjsl+/3/0CM1lHMNEaesWhuqKwJVqV+rSkfT5Ltrph9VC8UrDlAwPvkuXUr5ly7737aaNTWc75mjY5N/vHH3u8idxRQ52CcfQKiobIH8zszt+5zowVuZbjW+BVHrI7wsV02R/79rseLPhM3UTbwZIkCrDZ1sqT+dT+eq5p7NZssLTjRaUFOf6+3W8Zjsqrbx5abr7I1Kv13cjC5CKryeq1k8ExWiL1rcBjGqasNus/iQvw5q8QXoCuIqjh1T0rJrXQsSopIFrcPLhHWisob05bKL15N02m+0A/Nw4/endB7lnquLkgkC9cHflbDw1ULpNjc8T4samxM3WGpLlt2o/wbX4GgE79Ie5KVS0a7RobV8M6KXZTVhEySUDTzRFocZHm1qARTsn2TmyAa9Ba+iS5wUm0BVe8z4B+2N1qAhg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:01:15.7366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e6f2e6-6bd2-42e5-794e-08ded91c5008
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB10367

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 5 +++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
