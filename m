Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011007.outbound.protection.outlook.com [52.101.70.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD58483815
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523044; cv=fail; b=nuNxRuLvmelftBbq8fvN3/+33j+ye56tcX5lM+O+Uj8YnURpRiTZbffpaigzhW4hO+hLDPct87YpQXM1xk2dYTo0ODKtFmjiLGOBl82nYwtuCdfc168pRm3S+ai/riXj/gb08ryOmCQRSKyzt06Ltw1qdAycgNsIwlW1jbVssRM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523044; c=relaxed/simple;
	bh=/w3bRUDFhfO2vzhg/sGvA7JnHJn1iUE4HZjyR57PP60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZliKE5073d1jhnxDpIr+M6/0a0xeJQZlGxOy389AiQskCAo18Qm9famI8/tty0ecyy6/ufRB2OnXqM2xEbJKD19tsRfVTvyITsxu0/aSex4uMWBNx7rv7WrWwSiPa9KjALfc5vFqv4evedA+/ebrPimlRRd79r3ax8kh19QnCZU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CgfH9gL+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CgfH9gL+; arc=fail smtp.client-ip=52.101.70.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CgfH9gL+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CgfH9gL+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E5zacb76CQXBV+b78IWf/+ImHjGO2D6pWeSTuxRkBNV8QGWcxp+5RCsuNxlFxDW6l09OYJlio1hSDej+Doqupgu1Au43KYG0YhxZLEJmhca+yhIAeohkeUxyRjTj4LcpUuXZbdAtzKXLHkafbX6KqBO6lkZefhW2ZG7CTVpqOFiJ5L4Hz9qoko20p+ZJ/rMdSHa2w27L4PT6xh6yE9UaB2ymCojtOGpjeQ1zPC3SMpdle62lo6Ryn+NVA0qfm5D3Z6oYa+Pf2g3lp/bNpcuKr9Ed6k1H4GBg3WZ7mcHXfWbsghRii/A4QvzRY6jXy4dCB+c6Mrp4Ai3M6sQ+gPIp/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9/gsrpKnZcX2Oy/H4/aOiGsmCVLEYO3hfanpCh5NjE=;
 b=BmDrYBTFFw1HzWjDaFNMurRnJ7flZvlhwqimJ918qc4eIl1WF+m+Y4qIeOXXtwSAviGDTJiEajVS3uOjslkgGGvR6x+V7ebuECn2lx1Wxi4CJ8FbkvsWY5LjKCQQVpFmdk704wYOEC/92OtHOI8E0WbhoTPPx0Qo0X19ZD07zOeHWFztApnk4JsV6WvILfMxIfU0crsO9XGkie1HL8FWYtjUgeuSQqR3R5fnIrb4wwnNf8oodOq1GrO/brWPJHXjW1eeQY/1RABMMTsfiJq/fZANv3RSM2duKpFY8xj55CGSOrhd+2cVVpJAHs5i5DWjoGNTi9pHKQlSwtuxC/6nWA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9/gsrpKnZcX2Oy/H4/aOiGsmCVLEYO3hfanpCh5NjE=;
 b=CgfH9gL+pkb7G3fxgxOvwibnBngIFRW6M1aKRnC/4e7hHa2zo8MfFcqYagYA76Id8eupV9p1AVuTGkT4G3VvLiTotREwyt3sh8aRlHs3okqZZeQm4w1cmZ+NfOe5ZDqjyqg8HcokcJWycAxEjhlSbDiV1F6Oqt9u/3Z/RpKo+SU=
Received: from PR1P264CA0052.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2ca::9)
 by PAWPR08MB11040.eurprd08.prod.outlook.com (2603:10a6:102:46f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:57:11 +0000
Received: from MAD0EPF000008BB.eurprd04.prod.outlook.com
 (2603:10a6:102:2ca:cafe::4e) by PR1P264CA0052.outlook.office365.com
 (2603:10a6:102:2ca::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.12 via Frontend Transport; Fri, 4
 Sep 2026 11:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008BB.mail.protection.outlook.com (10.167.241.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:57:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eackKHe0RBMfFsV2ZtoNZXhPm+QrLc344DcgzCKkKylF+YgB6UO4rImEY0p6ED+rMdlYJ6o36ohlNtXqiuNt1PEHGlKw2/T5+4+y9UfoJNk0z1GjkzPwhNvto71mmgD7DjwL/hqObkXMZxgCdB2O2p4NEp9GT6JKTs50XopMP02Qq11gu9Hf2Q1nBQeWy6RwDVZExcHvzkAqqcJiDYvKAMFVtP0q0vXmueW2gXX8ZQrlY2VDKmaPFkDs418Y50NvNEQ5j8hgDMWdlENkKw7Z/R/nDKJGqlsnaPpY31W7ECGpa1+OUIz/E5PcrepX61/aohoYWV7lnD8IrPSJDxaLrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9/gsrpKnZcX2Oy/H4/aOiGsmCVLEYO3hfanpCh5NjE=;
 b=DQnYSPHVyKbZl6EoDvsrwDeUeoruytfDyjhJo4dR2Y12RjPHZx2HmDrvQF7+9mcI8hepU6r9eo8wAAnAlGRGzpK1LdVqclRwyRpk2WsN/erHVnYjHmSGCYPx7+pC8/vOLWDQbQyEJb1hJ0FrJtGUXiLA7e5YP50LPXwAwUnrOoIOBoq3R/DxiXMxKXV3VqNqrO4utQ5zBxO2QkHJ50W3oIcdESsfGdwOBnChcgFib2K6Q7PzSetRsap0Fgt9W/gkK4ZX4olAeMkCiRfQgFfXzWAAQjkyZrOcg/MMbpdytCRiEVFn5iSWPPjVyh/5FRj6en2bkkyfHQF7HsmQtUeTmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9/gsrpKnZcX2Oy/H4/aOiGsmCVLEYO3hfanpCh5NjE=;
 b=CgfH9gL+pkb7G3fxgxOvwibnBngIFRW6M1aKRnC/4e7hHa2zo8MfFcqYagYA76Id8eupV9p1AVuTGkT4G3VvLiTotREwyt3sh8aRlHs3okqZZeQm4w1cmZ+NfOe5ZDqjyqg8HcokcJWycAxEjhlSbDiV1F6Oqt9u/3Z/RpKo+SU=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:56:38 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:56:38 +0000
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
Subject: [PATCH v6 44/49] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Topic: [PATCH v6 44/49] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Index: AQHdPGRxYcD0XDhkv0ypuxnOqSqXjg==
Date: Fri, 4 Sep 2026 11:56:38 +0000
Message-ID: <20260904113404.4051341-45-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|MAD0EPF000008BB:EE_|PAWPR08MB11040:EE_
X-MS-Office365-Filtering-Correlation-Id: 023b40ef-ca78-4d65-ad29-08df0a7ba767
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 mfOOm1T22yt/0uhU/K6+6sbSWI88PzqhbujEaqwRRW1LuBrr/9Bk93pa6wA1fhOL2c6JrvAU8Gm0y+BgWwXuipeFJgFBwIGWqZLobxu+37xEbHfUPmWcvptpWU5l6o7WDXTVZInX1glre80+ZmGJnCT2E97dcSeAXS/wRd2QC16drWxX66bq/3ujNePiXXtzkJHIDhWUk/sApYdMxLDTYy5FCi8lSaqbO+Me8LOKmY1lmy18b5UpgkfykCd3SqyoPnAWQthESm9PHw6q453qWz/krrm8Lf6xk5uZBogM8fZcU/JOzi12j8snNs+l0pz6g1zLVLyKJntsWoOJ0gZTDneFS2IF85gJCMZD53PxvZEfn0vT+nvkXDAWPcIYrV7Bgp6Ws4Xp7HaSEp7PYf4ipnKYNcw1WdNSQpB1aciuPa5xFakRQmnA5livsdv8KRDrpXpzOCSC7zpoYIzCbeLWDyl4C6I1Idk6wo+8WK3p219l/SUr9MO34SqSzPluUatqlgMnDFs5S01jiR2qTCp5eIUnzTF6Os77/1PChuKek2KoSk0QlY3z328XjvdZJBB3lWcHIFLNReTzSp5PXFUyI7xbSm77Rzf/8ZrZjdEoSQK5sMzCJ6Narnif2+AKNQA/PDe0BDYq2zW3jMMprYEmM7aHGbhFfA6+XK88M9Azp7W5Hbuopac33sPguUBAVJUsPCzhlp6iRjy98p5NVzMTZ5kp++Mw1azOsftV9+5brLQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Y3uetMsHV244DLlfUBzqdPadpPtO3eTWhi7aWOLqOu141+qzHOgbkohNbipZzTnFWCdNDRSiAHyWzpP3H/JE+7fH/AJMYf9ENE40MrPQeL0kcdyqCgsdShcl2+kc3vtcB7/6ixQsC8miqLfNLjSjsFUtQvSZBikG8LgiOcWHHK/BRaJVuYdZazbB4ngrh3iBZIWCVGrnijJGmPqR9q3+pmTFFYKJ140Hxvlk81F9RRsAlQFwYrMg8BFdd8nDj4JZprlP5ZzNAc9xP8RYvW+KaDs9wORhXBmC1FY2w7QXfJY78jWDZNco3o0+ftJTNdk47ToiSv7flSdT6mRZmgUy4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008BB.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3a0f3fa-020a-438f-0117-08df0a7b93c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|82310400026|36860700016|22082099003|10067099003|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9G0b+XVsMK9W2efQANi/GImkwMpoyDJWnmPDFzs91O9yQ2NS7bNqOOd+rX8o9Zs6FkjTjDou5+ywhF8JdFtgCvnLvRypynlgr7wDKtR4K9Z4jxCrU9er318tLa0YO6pv8P2m4ezup3qlCogtns/GmeEhUd4Ri6u1WdioSo3Q+H3FCeRRON9qvKmNreZofsZ/ZyOHGjCagBM+3TIoJuGiQ9FimgiKpf+kOvy3wehrtBp/9fk3hLez17ZQRqJzHWJy8CZxw0cu/y25c6QQkHjSL6ycrup6QVKUlCtxecUu6Q4MWFMRPqCxL/gNlF12gqv3dqJARCQyPhaS899XTdrDAfxDtVw6TKmRtRSAJCY28rWJe/Ci2jKeWxcRsJRmb7yfdhEjGdEShSS9iXb2pcS005qlsNI31JL3RL7Bat1mQIPIR/JaPVYskV7ngtl8fo0XaXZ54eZexEXxnZyn9/8qUbV+sFVKEu39X+LAPM4MMdAolbTUeosT/lGB10KqrKQu8sOl3mKYrDtlFB8A6tDsZfXsqIAyV9a1VUhf4zmhx6h+ZO/pAqbG1h/jC4913/bJy15PBx6UxOVEzN9+wCzSNXBp1GlBUR0vUTIas2nIlQbDgb41PfOqjLqLCn89bVBMyvKp/fU1GEPjnArlVXZ25nzJPbzFlbV2SHoEOu0NMUU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(82310400026)(36860700016)(22082099003)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NcYxrtXPKPUuT5zwP/F1gi3ra1kkuq3TisjRqj9Ln9PG4IloNBFGNMjevwLS3ueJFjzS/EpFiPxVj4ePkizf+1KgG5vWF+x1z78KeS/jKrJkhZdXAXBddVyEFijJDIzHa2t4I1ugZHmrRhbz1iYdR/J7GhvfZptGFp1V9RQmkpH144ikiOqZGAeOdzaOBGK3T0OyS342xRuS6KrVBLu299yGQpIODR84h5iEzqNHyY7S2Y0c2+fWDV4ej9nPn+etesIR7a/eKCO5cnM//dcy51OEjGTSfHQsHhK9yRtP4BovkVYDmbWQkN9mfKpgYRKP/2l9meqM3RPbyQ4IaGqApDZx32noSWl/w6vMMkkEjzc1mxMdogUUBVRNliRqJ2eSH9qJfuwxMnf0IklEFAjNoA3wLJyHA2e8Jory4lk+HXpFtp0WAc8suquHXwwvV3Vl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:57:11.4134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 023b40ef-ca78-4d65-ad29-08df0a7ba767
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008BB.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11040

Add coverage for the VGICv5 USERSPACE_PPIS control attribute. VGICv5
only allows userspace to drive PPIs that KVM explicitly advertises, so
the selftest should verify the discovery path and the corresponding
KVM_IRQ_LINE rejection cases.

Verify that KVM reports the control attribute and that the returned
bitmap contains SW_PPI. Also check that the upper 64 bits are zero, as
KVM only exposes architected PPIs (the lower 64 entries). Finally,
verify that writes, bad userspace pointers, PPIs outside the
advertised bitmap, and the first out-of-range PPI number are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index a50775da43457..ca574bd45ff0d 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,7 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(10)
=20
@@ -111,6 +112,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
+{
+	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
+	       FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, num);
+}
+
+static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 type, u32 num, int le=
vel)
+{
+	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -655,6 +667,47 @@ static void test_vgic_v5_ist_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_userspace_ppis_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 user_ppis[2];
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_USERSPACE_PPIS);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	user_ppis[0] =3D 0;
+	user_ppis[1] =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(!ret, "GICv5 USERSPACE_PPIS get failed");
+	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
+		    "GICv5 USERSPACE_PPIS does not expose SW_PPI");
+	TEST_ASSERT(!user_ppis[1], "GICv5 USERSPACE_PPIS upper word is not zero")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 USERSPACE_PPIS set accepted=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 USERSPACE_PPIS get with ba=
d pointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -694,6 +747,20 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
 		"SW_PPI is not drivable by userspace");
=20
+	/* PPIs not explicitly exposed to userspace must be rejected. */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		if (user_ppis[i / 64] & BIT_ULL(i % 64))
+			continue;
+
+		ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI, i, 1);
+		TEST_ASSERT(ret && errno =3D=3D EINVAL,
+			    "GICv5 accepted non-userspace PPI %d", i);
+	}
+
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI,
+				 VGIC_V5_NR_PRIVATE_IRQS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted out-of-range PPI"=
);
+
 	while (1) {
 		ret =3D run_vcpu(vcpus[0]);
 		if (ret)
@@ -780,6 +847,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IST attrs\n");
 	test_vgic_v5_ist_attrs();
=20
+	pr_info("Test VGICv5 userspace PPI attrs\n");
+	test_vgic_v5_userspace_ppis_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
