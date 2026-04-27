Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013046.outbound.protection.outlook.com [40.107.162.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E8F34A3DB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306156; cv=fail; b=rz6Yl/VeUKMCHnEDmgQv9DHBLrOHgyv1Ip1OjCa62rr8yfmUzw2AO1YJjOuC5YeQ4IGsplnJuOrOHC7sCiaCfeo8ek93je4iscaltOUI9AqAPouHUQl7w5MM9iFXQG4NWFmBRBOrp5+Sx1aeU0YOYzlt9cN3iiwfL2oluc17PcM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306156; c=relaxed/simple;
	bh=GBQ+W5Hx9M5WW9RMzrPApPOyp+37JFsWTLFHoVt3IlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d1aauNYFImVW7z7BCt11v6Zw/0uM2GneEFe5actiJguqOWmneNY2lHv4EHy0f3d35WxFuWCp57e50wqB/TWvP/v3UbUwgDDWFPv539oBrmb1GqHcVwPYB5JOlYhmM4nEfZ/ICsxqqZHf+vSa/1ETAOopMm/sAue3DOwlBPf4G2M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FFPKgxfl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FFPKgxfl; arc=fail smtp.client-ip=40.107.162.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FFPKgxfl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FFPKgxfl"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bjqS2N/shd9mREoGJ5LBc9K37pnIqoIG9tnyyiLRFZQ0gT+EVKoLr9SqplSE+F/zVq8vAVaZDU07dYVaHpXIo/EHplzgUcOmB8hrPCtIlF9Bojj3YCUicUQCvNlzkEfvPUnHG3Szl+MqPP7bxsQ843xwVNokBd6ouQXPHf0nYZaZ0U/juGccm5IcWwCvA7yMO8cc060NYXbfG3C4XWOqjEENz0X71LUGqmo1Y9F/cpveqARxA8imkQUVK3gIqMtyoL+SEHYFCy1g95ymRTWXMv0UImf/362jbmfOAXo8AjxyAhWeK6QRo80kDuJrlKAnetNUHGBA1Mdtltg4vd6jmA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/FhHHzmfEv1i9vLdhFGpAHLYI28/LEL2AidwlXSB+A=;
 b=lpekSlygOYKpmzpOv6NLa+c0hABZ31tnz+synC7u5YlW9O3mzsFWH9QNP8E3T7QuAc/g7MXYkohmdLQRRNWb9WGrJ3sE6o/f6SC9UA/FkL2oGomv2eJ4JSLbCtL+X4j37ULhAqbKtDj7XW871JoHsFxpWbzgcXMAxt/AiRmmMNuBppofNa5C0KVZQttP+dMf8CWn1DO0stNrwr09bsVi7szU14QgOUIGPpEgvaEJVCTuxLOuIWnnZMxfPr0RzUQl2zlaX1lwySfBhHqQ5wXI1AChONNaH382aXWNdNOVhxOk3PxOQ7UzaRC/0MxoG2I/amZhiUVcctr9O0+nVwdAvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/FhHHzmfEv1i9vLdhFGpAHLYI28/LEL2AidwlXSB+A=;
 b=FFPKgxflxXPcQAxqOehxfcK2aLQUG55JKrb20kAkFJrT4mUIR5Y52iYXsrtgPr/XYZKS1QLEqa+KlqcWIwrnSA2WXLnEfutjLxVNx5W1gd2i3yljK70gR6nmg5/fRBPi5ht5baHcjgK2x32XialOi53OMyDcR1eMXjEBqZ8T8hI=
Received: from CWLP265CA0454.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b7::8)
 by AM7PR08MB5463.eurprd08.prod.outlook.com (2603:10a6:20b:106::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:09:08 +0000
Received: from AM3PEPF00009BA1.eurprd04.prod.outlook.com
 (2603:10a6:400:1b7:cafe::c6) by CWLP265CA0454.outlook.office365.com
 (2603:10a6:400:1b7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:09:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA1.mail.protection.outlook.com (10.167.16.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:09:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZwSw/1djSUn405i2sXOCNC9YqEftom7SDjC+Bx17NZ5uy/C/66SqpLx8kSQeqoFSRN8bvW+Y1ILKhsoQ2Axr7NvCq99P9z/qc3BEc8AXu6BE7NIz5CztvDDQyApLMAqVCSZQYfrZ3g6QM/lvU6ZcDEubAkm+FzBf989isuMpvq5jCnLITphVF0VzWi2tw0IVPSxrrN03nbmd3g1didg6N/THpGxa4SGq6X6tPziDXUq6ILXe3rCgApCdfjA/6i7Jx2SYoYlARrZFJhmklH2jcmSgzBc05aDxcxPLAZoj+BZVGcaUS5NCwNEem14sEVV6U/F+a7cCG89NgwB2My20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/FhHHzmfEv1i9vLdhFGpAHLYI28/LEL2AidwlXSB+A=;
 b=vYLt0c5+CuqD3weXG5O64z7viaLhVHU4MzetSC9pcCrsL0Gbwv1VBEx12IebEQDLKXKr82ey2G6Ly3UhL9669RAZzy3jU7v9lBk9G694wICpf7tPOsRZkBCPym3wQ0rGUTROhSxEgmQONiAlxt6eCxFDDqALoBq5+FMOsxo3pG3bIyvwRutyCqJ0drWpNYoaQ+diwJ/1kSa0sEDoFdjWYyOHvFG1pzpnyCmBRbBMr6PclK0ed94Td2k0zupiGwe4JuwMnqkoriq1PlYa7kDQ3Y3J8vWEhPHoWwZCXC/Pr1Eh4z0kX9O2qY6fM8s3idtsgZ1XL+EDlNRhDWCckgYlkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/FhHHzmfEv1i9vLdhFGpAHLYI28/LEL2AidwlXSB+A=;
 b=FFPKgxflxXPcQAxqOehxfcK2aLQUG55JKrb20kAkFJrT4mUIR5Y52iYXsrtgPr/XYZKS1QLEqa+KlqcWIwrnSA2WXLnEfutjLxVNx5W1gd2i3yljK70gR6nmg5/fRBPi5ht5baHcjgK2x32XialOi53OMyDcR1eMXjEBqZ8T8hI=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:08:05 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:08:05 +0000
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
Subject: [PATCH 06/43] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH 06/43] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHc1mAHvLGt4diYL0WUbJCxjAtCTA==
Date: Mon, 27 Apr 2026 16:08:05 +0000
Message-ID: <20260427160547.3129448-7-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|AM3PEPF00009BA1:EE_|AM7PR08MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: 89119e05-2525-4445-932e-08dea4775016
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 HyL7X0uxS9l3zSSZGmb4VgkllV0d6l5KlOh1yO10ULRwMSUZVtCKSSqhRP0TRHtXrqeLJSvBPwKgS1Bl8QxHT15w6N7SlbfE4DwkhavEBsDZNLKWXPq3wZC3YFSyDrFfysm/NypDEwLsN3vmI2JLjAZLhgBGnluwqShkZ3OlFZ9lGTbDcjcvmfwjINzRRyuHNptLonikaxABNx053eKRKKku6XdAP4Yc+F1mL3C/SVymy9jhAebwV/7XVP/u3qgnSan3SFw+oort31FsyyAjHusFKLKwMYFyUs6qV2ylEFR+I1xkw4ArGE4YIwzaAMBWHYuxvnzN9QLBjoskDw2zdh1GGHrfMjiGKL+ZXReor3QzkLhlPybczhNYSVmYqTfhfBtLkZ6LlBGtDpGHQnMumiTi2Y6MdRcdbCySe6K2QCr0DV72MeWobqRfO/hJMxZKHBfoRy4TmTYVNBA7iFvM20cSbEh/QnGhJwczkGSrfWrzBY8rJzr8TKiVV6MAb8jot0OtW947Lnp/gAu5qFHOW3IrjE3J5S9/qQjxMnqfxzTA7d3bjwgFU+fhmDV3CLr+pZsx456s10a67+1TmCjm9WONXW1d/tQxvrQLxlyud2S4eUgQEsek2jnIoQ++dC9NRN+Yu5hM9KhxPOlNP4ITl2ovIi7Q6a6LNpV0m4+r6Vl2oeShp6lh1uTu6M75XsWhRO+efL9yJxDZ1pDC0Zkhym6O+oAO1zGHb0gMERWryemWtSTEr87tiEzP+tBdYBF1CG1dvkwdMquFiWkz4qa/K/hYK1rugbWXFEHIBJfvfI8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FRLAKvLblQZX4eCg/Be8xqrGXWSHD0BpJPvgODwF0MhNpSddpM2cDV9LTw42Kdj3TRBLn2W8SlDijrkRCDP1yc35WMxCQB9L4kOpQ9vL69o1WNJOU1VGHVQcir66rHVkxv1jGRvqvFAVRXhXP8U7kgX+U1X+QKZmkL+Cqkr1wHP9lpMd0/vkCjgOEB+sGaTCyZi2nolm473vu0K5ShN0SgYKRsu4JRRfaaGAC0liznM9Xwa4Dw3d82ePKUJ4OmU5THd+41hUE7PhuEF52cz7GWNCCRoEH5FtrvhCg9eCudzRRo+78WWjebCTtgjQ8aadK30p2E0fdWGI8A1IdJRBnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	18c80803-87d4-483c-f27b-08dea4772a58
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	j0PR4uSdaMapMJTZhCjixxoONH/E3P0ZqAalQhP4BkRLXz2a8ZZjCSGSGkrVARVy+dnGVvgv/J5BfVFkHHBj9CMz0DQcd6F3W94I53hXTCIXsMe9hkdgxG7IPfAxJ8OF3mJSDGYK1MVydDEwDnRSy9NpOWv+d7T2xwMywafUa8QGpBX4yjPWgSWnzKt54Mk2s2LrhjhhRDDuToUn5daGvC5uD3u5bcs1ltYiXgVfCDh6a7lj0oU/CPLznBiO07pfBE7GplKI/+s84HCiowoNMOMYsE0HPkpT6eIbsWuTx2gHbu+v8jIYypKa5BmL0o4ZA8lWUfeYfW7fOZzjP8iErg36H8+MHS0wIOxe2593RbUUO8DKIQjVbyD5Gu6nkNwWX51sjnWZ7x4OzLHweiKD3xYHg61Sb85vijE/yMwYYbghARlbaw4GBui6OQHiKGgGkkPQ5RJbt5I0X2EyXVMJFhr6YvBPKq43SyQbtDKrELalxLDKxKnpPTCJbY5JnUSRv9FwHy0/FbpNef1lgmwPxIsxe+Mo4BzrnsoSDhi7eIwGLtdFw/fuObnGCPrYdxOhv/3pLN3wUdV9y3EfOBozlfvShlj2ChTbEZ2g5SKYnHmub+bKgRAaFTC3fJaV+XHej0u66FTJJVAeC1mLUjOi3lzBPoHAm2zBNZvkqn311jzisZjZexImISDGbATKFIaAK7kvL3pOadN23fUTsEE/JzfctB1EleW+7O2BZMt3XwbkOW1LqTLQkIBb7ow2CI+tHOavC4txg4Y7ZbH0uexvWw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PA9hsYqmXVKchyp+hZKPPCn0bnBwGHMNEmReKHAwkpm1/+zn0Ir1sAtYjNsswJ/Lk8ocmc8MTHUIaXn5Hvua/EP/V49RsLHVsVTAYMXCll293Tg1Fj96DdKdMtujen00yv14lXNVNfdf3M1q2SWMJxL4w9wzXrpB1zXZr371sJr0k3VIcYCULDnlJfcR13c+BRgcPMQiKjWrvreWdvAHmvn1lYNiJLvUgPt62D8yNLOLTMbjqMnHF7m1sxSDm1yY+r3HMO/IsyAdnX08hNDAyvV8IkjIxyrGvpd+hYhZBjDearu3l0g7aJH/49/R2J+oIR8Ds2k4vSgCb0PFsyoFUqVp2/nr6nTHoH2oqWqevYvyuMTOwSoQsKj5aiPZ+EJHSirrTo/YJWw7BIkE7jjxqCud/kpQjhbkrmZ0z2jHrJoQyr9+WDgdBQQSg7ShcCTs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:09:08.3643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89119e05-2525-4445-932e-08dea4775016
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5463

GICv5 supports two types of doorbell - VPE doorbells and VM
doorbells. In KVM we only support Targeted interrupts, and do not
support 1ofN target selection. This means that we only implement VPE
doorbells. These doorbells are implemented as host LPIs which are
generated when a non-resident VPE has a pending interrupt of
sufficient priority and the doorbell has been requested as part of
making the VPE non-resident.

VPE doorbells allow KVM to wake VPEs (so, vcpus) as soon as the
hardware determines that sufficient conditions for the interrupt to be
signalled have been met. This simplifies the wake-up path for vcpus
with GICv5 for LPIs and SPIs. NOTE: PPI pending state must still be
checked explicitly as the IRS never sees them.

This change introduces support for the vgic_v5 doorbell domain. One
doorbell domain is created per GICv5 VM, and all VPEs have their own
doorbell within this domain. When the doorbell fires, this is tracked
(in gicv5_vpe.db_fired) and the corresponding vcpu is kicked.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |   5 +-
 arch/arm64/kvm/vgic/vgic-v5.c      | 143 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |   1 +
 include/kvm/arm_vgic.h             |   6 ++
 include/linux/irqchip/arm-gic-v5.h |   2 +
 5 files changed, 156 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 907057881b26a..984908a271c8d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -500,8 +500,11 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
 	}
=20
-	if (vgic_supports_direct_irqs(kvm))
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	    vgic_supports_direct_irqs(kvm))
 		vgic_v4_teardown(kvm);
+	else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_teardown(kvm);
=20
 	xa_destroy(&dist->lpi_xa);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index fd3d6299a2baa..4e0d52b309628 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -7,6 +7,7 @@
=20
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
+#include <linux/irqdomain.h>
=20
 #include "vgic.h"
 #include "vgic-v5-tables.h"
@@ -162,6 +163,138 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * This set of irq_chip functions is specific for doorbells.
+ */
+static struct irq_chip vgic_v5_db_irq_chip =3D {
+	.name =3D "GICv5-DB",
+	.irq_mask =3D irq_chip_mask_parent,
+	.irq_unmask =3D irq_chip_unmask_parent,
+	.irq_eoi =3D irq_chip_eoi_parent,
+	.irq_set_affinity =3D irq_chip_set_affinity_parent,
+	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
+	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
+		 IRQCHIP_MASK_ON_SUSPEND,
+};
+
+static int vgic_v5_irq_db_domain_map(struct irq_domain *d, unsigned int vi=
rq,
+				     u16 vpe_id)
+{
+	int ret;
+	u32 lpi;
+	irq_hw_number_t hwirq;
+	struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
+	struct irq_data *irqd =3D irq_desc_get_irq_data(irq_to_desc(virq));
+
+	/*
+	 * For the DB domain, we don't use the same hwirq as for LPIs.
+	 */
+	hwirq =3D vpe_id;
+
+	ret =3D gicv5_alloc_lpi();
+	if (ret < 0)
+		return ret;
+	lpi =3D ret;
+
+	ret =3D irq_domain_alloc_irqs_parent(d, virq, 1, &lpi);
+	if (ret) {
+		gicv5_free_lpi(lpi);
+		return ret;
+	}
+
+	irq_domain_set_hwirq_and_chip(d, virq, hwirq, chip, d->host_data);
+	irqd_set_single_target(irqd);
+
+	return 0;
+}
+
+
+static void vgic_v5_irq_db_domain_free(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+
+	for (i =3D 0; i < nr_irqs; i++) {
+		struct irq_data *d =3D irq_domain_get_irq_data(domain, virq + i);
+
+		gicv5_free_lpi(d->parent_data->hwirq);
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int vgic_v5_irq_db_domain_alloc(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs,
+				       void *arg)
+{
+	struct vgic_v5_vm *vm =3D arg;
+	int ret;
+
+	if (vm =3D=3D NULL) {
+		pr_err("invalid parameter for doorbell irq allocation");
+		return -EINVAL;
+	}
+
+	if (vm->nr_vpes !=3D nr_irqs)
+		return -EINVAL;
+
+	for (int i =3D 0; i < nr_irqs; i++) {
+		ret =3D vgic_v5_irq_db_domain_map(domain, virq + i, i);
+		if (ret) {
+			/* Free what we've allocated so far before returning */
+			while (--i >=3D 0)
+				vgic_v5_irq_db_domain_free(domain, virq + i, 1);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct irq_domain_ops vgic_v5_irq_db_domain_ops =3D {
+	.alloc =3D vgic_v5_irq_db_domain_alloc,
+	.free =3D vgic_v5_irq_db_domain_free,
+};
+
+static int vgic_v5_create_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!gicv5_global_data.lpi_domain) {
+		pr_err("LPI domain uninitialized, can't set up KVM Doorbells");
+		return -ENODEV;
+	}
+
+	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db",
+						  task_pid_nr(current));
+
+	/*
+	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
+	 * doorbells. We know how many doorbells we have, and therefore we
+	 * create a linear domain.
+	 */
+	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
+						 0, vm->nr_vpes, vm->fwnode,
+						 &vgic_v5_irq_db_domain_ops, vm);
+
+	if (WARN_ON(!vm->domain))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!vm->domain)
+		return;
+
+	irq_domain_remove(vm->domain);
+	irq_domain_free_fwnode(vm->fwnode);
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+}
+
 void vgic_v5_reset(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -181,10 +314,15 @@ int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long idx;
+	int ret;
=20
 	if (vgic_initialized(kvm))
 		return 0;
=20
+	ret =3D vgic_v5_create_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+	if (ret)
+		return ret;
+
 	kvm_for_each_vcpu(idx, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
@@ -203,6 +341,11 @@ int vgic_v5_init(struct kvm *kvm)
 	return 0;
 }
=20
+void vgic_v5_teardown(struct kvm *kvm)
+{
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+}
+
 int vgic_v5_map_resources(struct kvm *kvm)
 {
 	if (!vgic_initialized(kvm))
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f45f7e3ec4d6e..f2f5fdc3211d7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d14cf4771d606..05dbd01f6fd21 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -366,6 +366,12 @@ struct vgic_v5_vm {
 	 * convenient way to do that).
 	 */
 	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+	int			vpe_db_base;
+	int			nr_vpes;
+	u16			vm_id;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 76dcf414ffb20..087d94f739672 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -401,6 +401,8 @@ void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
 struct gicv5_vpe {
+	int			db;
+	bool			db_fired;
 	bool			resident;
 };
=20
--=20
2.34.1
