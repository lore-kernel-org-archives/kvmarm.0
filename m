Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011068.outbound.protection.outlook.com [52.101.70.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969AD2D97B9
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094577; cv=fail; b=eITzqTzXHyHWS6BJwcf+k9uAoaxSWCAaIesnaK0Cr7WnBo5+0rwSxR/9o4+gZtMyuh3yUWMZs2LTFtavj4kuC7ULg1qymZC05QylZ4Lx1AnDWEYIeNAaOvcBYVVieYUqmuToFAAoOm+UGRb7I2RdRWLE44BzUXPXC+FA2PvgIZQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094577; c=relaxed/simple;
	bh=XevBK0lAiCwNUMMx5bAXPwk27Ej5ua1ll1ysx2WLWdY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZBsuEg0pMZWW2fAoWgq1oYBupzcnU8brqMbf2Jvyv6xo+hZ85TCvJJtMNUcXBDgQYfHjJAZsVks013LAtOZr6hk1vlI4doLkFxiFaxJ9e1MFY3I5PaLdHnG8V0lc6qirxfcgUYklpdUpqy7GFug9V8P9HL/y7zOpiQ5N7vLfh5k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N4YJ1cvO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N4YJ1cvO; arc=fail smtp.client-ip=52.101.70.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N4YJ1cvO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N4YJ1cvO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XTukXPE8Hdg8U6KtpI4m/COLaR5amD1qrI2APZ7Rl44mq1PFGJqd0DcQDFw3s09sQDUOR/y759ZTqYmBC0jM7b4zj9YT6qNhmHdQ4XVI+idChZbvEA+jH7jULokpFJEhfiw8onSq6gH8UErH3LaQUcUjASkpAtoh+bCWiJLAphUcxAuMnnCvgMUt2sVxF+9LCqDsKeO/AzTQloN3BDDicUmDBikDnaf2L8SWQlEVjFFnaVLHKwp6JGeL7v2rcYIG9fiUtEjYbJohuwOBbrIftldkTsWd3Rswx1afTxvhziXmKkF16jViLNYnpqC9urnhfHRqSvneSnej673nAntJ3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhW52ZweskKop9mtlOLNQNMPBm8Ctij0qqxdGUpfM5w=;
 b=imJD9FCcphkR0CLHq31Or6J8TvXn9TaOre+d9498NO2q8JLb/WnVdwB3W6oLOl3ObrhomNQchpvkPc6nWjQk27WjPo/+Wb+Z8QrQ7sArKbMDC78iu+6OcIGyqJTsGUh8MhUxQoPDB+HeQ6NUy4NlSY39XI9e01SIXHqtXvszqzG9OsJNqP1uqt8/DyBXTNMdyD+IjIWg6NYH9+sigUa2H4hCJz+ipa1ap9guuG5qQLeTJf9Y/YEr6PDI74/YK3WJx6NAVm5lIKCiLj6cgQZG9VGPZxTWqx6W2AGBJBvj/7hduJ1TrKhQ2eysoxSLv3NEm32YWVVuRqoSrLeF7XelGQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhW52ZweskKop9mtlOLNQNMPBm8Ctij0qqxdGUpfM5w=;
 b=N4YJ1cvOCuhIKk3N6qaDqxP7Jlz276ichs+WpIeMuUkScxeh51eZtU+rIe8ds+bFK3u8q86fcLt6OriGXE8k3OMkL6X4suVot/C4lo4l8X+kzoMlijFqsCZEvmUn6NfStgCYQ7VzKXm0mTPDixXQUKnzKURRs8JLK+b1jwTK1dM=
Received: from DB9PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:10:1da::28)
 by DU0PR08MB8140.eurprd08.prod.outlook.com (2603:10a6:10:3ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Fri, 3 Jul
 2026 16:02:47 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:10:1da:cafe::38) by DB9PR05CA0023.outlook.office365.com
 (2603:10a6:10:1da::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7u1GMqNiurDT7tCR8mkXOCmvw/77MxPBw8GxJSgw1k3sBlKIYOBcUjcoAkXk+3daKYN2q72WQhHyit24iTQ8GaTCjebbBoTN+VoiYk31kWFUDFxmRVIRhfcFh3kg8Xx0KnglQRVnpnSKCJWhAjirrtAoUI4n/bd1cqyH6OnPzKGAIKjoUZjBsMQ8YM+XRtQHNm2yl865Tbqyez8GAgoJodb8ZlXinfN0nsRhTtyeKeOgWQfJsUzCzyswRjNNc7M3D7E4um3ElwQmZqdXY92pbOCuUKiL4eqHfIrV9vCuGZeFbYDCa8Aebv+rLOPkQd8YhyMmuaprgCSD/5F1S3mCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhW52ZweskKop9mtlOLNQNMPBm8Ctij0qqxdGUpfM5w=;
 b=zRCzz4WaszN0/OYg+uVFdQgYvnTd7F1Pu9N/jvGUM4qEgcYDIRKQaCXxnEFWeHmOywRh16qLNfLzkfVu77vOKq0BpE9nDeN6XZC2QcCM95paeuU537jX105+0uFt0gY/B1Sl2haT9uCLEfxwcDyu1VM1QAfAsYL9JDNoaNYvp7oCDhT1IGVTqs1+3MG3o0R0q3/Jvy9meE92emxIZqSB+xtkInnhAB7bGBNIW+weDz7NF/bcGjGEbDewubyeK7tGegPOKVLIwKP4i+quoX/u7F/myjgQ3QtPTnOB2lJxQFrlgQcEixjErGsAxSgKuzEsSWu13Ih0qeIU3KD/GsJ0vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhW52ZweskKop9mtlOLNQNMPBm8Ctij0qqxdGUpfM5w=;
 b=N4YJ1cvOCuhIKk3N6qaDqxP7Jlz276ichs+WpIeMuUkScxeh51eZtU+rIe8ds+bFK3u8q86fcLt6OriGXE8k3OMkL6X4suVot/C4lo4l8X+kzoMlijFqsCZEvmUn6NfStgCYQ7VzKXm0mTPDixXQUKnzKURRs8JLK+b1jwTK1dM=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:01:44 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:01:44 +0000
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
Subject: [PATCH v3 22/40] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v3 22/40] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdCwU+3k/D9dKICkOOIQY/JbSQBw==
Date: Fri, 3 Jul 2026 16:01:44 +0000
Message-ID: <20260703154811.3355680-23-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|DB5PEPF00014B96:EE_|DU0PR08MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 217655d6-5c56-4553-1aad-08ded91c86c5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 jjTmyXTDvYs+CVL+zr6X12uWUVgjWPl+lPGuu5cqeM6Gz9y3WVY71OFNKoVb1XmoMnrqLQL/SSOtVJsRUsChGIWo0qUqSlumfhdPJVjOjiS37QDJOgSSr7QdSblEGlzy1Ue17/6Lmv/4WHAAMmRxEh+bIprk+NmO+GMdSbA+/WNJBJ/dihSj6scxpMP6u0dIjaVvSrhbbddMvh2djFl3EkBoMBHc/Vw1du9+T7UyHp+WMMPr8/7/LhO5MTgKIzlUPbE26UbiMLTDD7jOfTuID8IVQuSJlWurjaHTMkUumiNluLhgJLVb6Diy/UQkKWzVOzb6h8TrltieNFgMzCw4zjoW1OTHZqjBVA7Qvaudag9S7coUliCpfoo6Z+M+2mBVzDjfp+Ya7zqCwya4Jat30BzZimHXdjnJBAxnIVun3oecH50Qbz6+Ztt+dukDaW26OiPXC8svRmeUrtrRZx2/fQB9MCoIal5kg3/NQ5bPB4ZRhtICWrQZJRIVAHI+qKMHv4UqjmEdQ6cKVC1NW3W5MpvtXTEVjqBL/H+wYxQ34lFKcTA+WMetoIaYAXTFd4wsUH/sTcLDFiDRk1+lBzpcqkEfwb7Vwo+kJs/7+aKPmO8LqortjmLlE6/2DWya7N8ffvrac4mcXkyEnSkhZdFfJb9KUWfUk7iA1nOI+HOwZtgDMaNllZc8jiquvbammkJJ2li6Blqf6Conb8yRRUuwU1OGQvRcFGhxvKbKvXUp5rs=
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
 hwOyLPeh5IcRjCmPJ4sYX6kNNJ/KsLNXFdeh+ELqrmd12ioIQGNNo1KKghYTdvh2gjhjqANKn0uCi0CYlG0TQ5nSH9u3vhlahlToBRkSJTEjt2JbM2nSbXIhKwK4532id9AZvfM5SGi/6RFBVIsU5tpzBxoLKDzPQprQTl7aJFbFPk21KYxpPGmLQYzf2dUxDtex1s1Gda1/tKGQoqKOmsLY+CAud7PYgvSbLQYe9/ugkgZG2grOFmJqE2ljOd7VwfNbkOb8CNgNi5XfY4YZMC1G5b9EDfRccNm+JdwOoGpOfbQx/d9Ph+IjzzNvCvaDD4LM4qvEgkV5+YoKyctyRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3f0b4db-e1a4-46e4-b891-08ded91c6122
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|14060799003|35042699022|36860700016|82310400026|6133799003|22082099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	XvyoQWyRTb351CRTY8sSa/c+resUChsq771J7GUCBeCNgqcf47XNv0egICo8v/oCSFb8pq8mwH05tifHNqrUppQ4ZKKdzUe+6bl3ZyFR3mViIrzgWm4cNDwHIQ/F7FeKBwHsAQuDqQ5d3Cy0KXGdXLPycsw9hq07qKxwJvxqDmda/GuYNSt2Kph8d+TYb5iy2sq9uLiOiBF6AJ8vIIdgjws6kDWPI86bj5pLZXmuO7qcrjOLsYKYZ9rVAKSu9OjsFN7Z7YqqqDhDf6LKWTUaHmYYMrvbYZ2dy1t3X3ha8QMV//k2wFhnDUWfzBOGS2QF4qOaEIcZqoS+d1DXUL4y7H4A7F8zl7yIl1mGinDtyNFKPUDXgGp/HXLO0KYQeIum3aDVN60b7HzkFM2Lqea2Z8Uhi4tseaeVQ+YLVyiXTR91EFperfGjWeC7LwAmp72dVhowqgKw910QDEPXgHDI4q8gyuwQzGUE5QEWrZpdUGMBMsCP0ljQDFCvSqN3OF5q7TfZn9pF+AKkAaMLI0xU5LDIIRE2dSYE+fTP83AADxGhpoJ4rQz9Mp5LUgGU1TIVgx9XU6C/LXMKYAC9BYBbh9gqGylmtVh5FypeSOfCq61ACke68a+rJaC5jQkiatDOp9KG0Tbe0tI96Xuqc9mekp++IOp827DI0lmT3dz0qTi0aZDSfax4tK6/wF3iXHJDzPJ9KxL8CZmwntWLO/5IDg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(14060799003)(35042699022)(36860700016)(82310400026)(6133799003)(22082099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O4lT9HKKlNFNCeG2yjKODk41PdVZMq0yIB3RkVXLAiqO4eeuEV5F3AugFmpZ5Nbjl7HjOgnSR/zEfs6JnneY66tlwQQZ8BzBXlsNF3lfwnDGAOiIXTaQAcdt/YyDAZ+HcWmfhPRT8mms271NRS8aBfZ3e1xqhKkcBfFrxsza3Csh15Lm48HWeQkW+46h76fmzmWOJELWz9uHW+uNk3eko0Q2IGX7eKiKl/e+b+Ku8AtqMkIWbbt0lFGu2PzTghZyanLozN/5JvN8JRiEU1J23BbmgZoMsMTrPSYj7zrQ8Sh13rygDGG/3Q/xzMScoIhpwBOSmzFk2ETlJY+Y44lnrZOIbxxEEonA+ADXes614ZgFn9J/F869U3wyyvd2lDCxRjW9BJHMiu6swTnf7h5mEnqQ+dNQ5xtXmtceT0Xdb/2UPRifdf90J/Gsc+7l9FdX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:02:47.5479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 217655d6-5c56-4553-1aad-08ded91c86c5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8140

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow userspace to set
the number of SPIs handled by the emulated GICv5 implementation, using a
GICv5-specific SPI count rather than the legacy total interrupt count.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  18 ++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 ++++++++++++++++++--------
 2 files changed, 90 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index aa883507d00d1..8a38d91528774 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -657,9 +657,8 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
-	gpa_t dist_base;
+	gpa_t dist_base, irs_base;
 	int ret =3D 0;
=20
 	if (likely(smp_load_acquire(&dist->ready)))
@@ -682,13 +681,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -698,7 +696,19 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 			goto out_slots;
 		}
 	} else {
+		irs_base =3D dist->vgic_v5_irs_data->vgic_v5_irs_base;
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(irs_base)) {
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(kvm, irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..2bf1930902b8e 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			/*
+			 * GICv5 reports a number of SPIs, not a total number of
+			 * interrupts. Require a multiple of 32 SPIs.
+			 */
+			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
+			    val > FIELD_MAX(GICV5_IRS_IDR5_SPI_RANGE) ||
+			    (val & 31))
+				return -EINVAL;
+
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +324,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +804,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +831,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
--=20
2.34.1
