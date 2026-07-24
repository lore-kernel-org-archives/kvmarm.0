Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011047.outbound.protection.outlook.com [40.107.130.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C5426692
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890230; cv=fail; b=nFP6KxnOWDlkqOLVJiQU2OKq6ILEOU/JPpJCpmGr8oveYutIgbdM/96GxDTz2OVv0T+AE64h2nl0onIUKfjN5enM+fC3CFAI/+ZUXeXbUnCWIH5chgv6sjfjIOqLjdy5tRYRJsiNOirEjh1HDv5a/b2ZoFCmZ4kV9GlHB+ycGDg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890230; c=relaxed/simple;
	bh=9yIjGQ346hbrDyI4HC81vnC72QMLrjpy3krcB0NkgMs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Evm8S+9p5YWxXbzPxy7GhcGndCs00Vn3SHQghbl5NoNLj1uBOTOxqnL4ih+ghveQCbaTWmioidVaU22U6r1oV7MVsX3J2E+6AlqxNfG4XyA0IzEzxzwwMK7DfTQkTTjD2+098nFHToOkCprDymbYJp2WGMNdnMDFz/awxWEHErk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AXpuGx9S; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AXpuGx9S; arc=fail smtp.client-ip=40.107.130.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AXpuGx9S";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AXpuGx9S"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BFgYF54oX3zVpykzQ9Se+WcdeCOOD92N6DY5NFQVUq56E2sN0NgG13htthlLPwYb8gU5iDmQEbTBqKJb7u1zts8/74gKvXv6WoUbUsYc1PZcehnu8NhJvnD9qKH12PfEHlWIwWv70e0Ntlp0rDRhY4dUkxvYKOu76QvsbnwvW4P6baEnjqc6HOH2MFk/Sk4Pk7YmUpTxan9o+9ULyTpLshUTo34Yt1SMyQdAEJpRoN4bQ0aUncyE7auE7cdMQcVQ/l254v+9v7ThkOMcloPfkxF8QtHrICFgz6ZykcmUP9mEkK9oAsjXu0qxyPOW/HmGQWgPlt5/7rTuoKS8CS76kA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=Nn8Foh9OFVzkviglsgt0ju6fKyFGtBaf6Xn0JYEmgm9e+fxmWnDgyYN+fw+LPMdC5hBKwUZwNvXOv1ELiC9NpZ3RrEkM87V2/uz2nugEeaUUaG3+GslOawXUJpcYGduB3RpfP8RQI2DWfJzRY1Agb/wTt0tDpJPWjGC2UT85MkxwBehdUnN0bHJt5D5ezb2kD1SJLSO+/5ilpONi78UNSnfMFIyRUZKS/CfbnJlzeNE57bMIqCOYYRqXfCOdwcgcB2582co03FZcQAXrSVxmfqMiY5KsQossJT40HsLTehzIptmJ5y3WOEIR6c17zXDLDHKLSm9LIWIvNEwrFMIOqg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=AXpuGx9S7jYvDz9CfLxDFMafKyQzW5WAhS5+gg8aTfHDEkaxDCoRUkkCyLbYNS+6OaG+n6HRFpcK9m92J5EBSSk6lCgzVnm7sVOmLoP2f8GKTjoFHWtvmIFUf+ZlwqKMtnBtgpElWJAp+hSvBqzT5tS8wOHENZt0N2rqcR+EpVE=
Received: from DU7P251CA0007.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::19)
 by PAVPR08MB9745.eurprd08.prod.outlook.com (2603:10a6:102:31c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:50:14 +0000
Received: from DU2PEPF00028CFE.eurprd03.prod.outlook.com
 (2603:10a6:10:551:cafe::51) by DU7P251CA0007.outlook.office365.com
 (2603:10a6:10:551::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:50:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFE.mail.protection.outlook.com (10.167.242.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kP7aSYhcDg3sAPPC8GsLPB7CDmKkA89bMHGQMhMBHCRKcg0O1FOCpUJ/3z7mGEwJ59cQfjx7+mkEoPMLxW0HaJe9EQbkwW5xdibRujec8V6RG+V/dmK/DkeaTuJIt6KocR1CBR4/aqPKsBiOjWLdvkxVoM1PNftHBRcJglfnGbCQ7PbJN297hakTAqerV6g4EbyH2hqQk5zm8oAyl4jd2VMNafsOhVuPVvlkxgI5TVOOWyUPadbEyXz/0pUQq8Sb65o4SAcpXhluXR8xlmyhMkdAWyJ7+0UXJxYwQyDyzAgzW71NSUilzeBA48Q6bvKR/75Z0Y1OdtJWy8Lha94jog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=PrpC4q8sS6qx9ZogKrDIy/X6g0Di1aagBllgr6xP6gylwV2ppax+wx+OA7Jf6jxhaXgb5r/QhHUqrZLA1uNYbPfm4e/CjVYZgOJIm+fzEq/4Zjjk7F24F2h9j7dlGn/sNuZ04XuSGxGOj2o8bzfAzpWtzRVFD9dTdqxq8LhnhRalyvq21G3PafZTtlBTKvXItfFb8yNWD51piQ3z5G6mtQhHghByolIdrg6QymNWe2UHrnP5Cvmitct5mWe+UIE+oB0ETAA9vvfP8/butEPlaIyYj7GECVhN6opRer+/oz2WlWzetmH99Y/RQ+T1Hu6mHisZKZgXSLUJWvOjzQJZAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=AXpuGx9S7jYvDz9CfLxDFMafKyQzW5WAhS5+gg8aTfHDEkaxDCoRUkkCyLbYNS+6OaG+n6HRFpcK9m92J5EBSSk6lCgzVnm7sVOmLoP2f8GKTjoFHWtvmIFUf+ZlwqKMtnBtgpElWJAp+hSvBqzT5tS8wOHENZt0N2rqcR+EpVE=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:11 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:49:11 +0000
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
Subject: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdG1oPG3RMJAfolkyg5EHOLdLQgQ==
Date: Fri, 24 Jul 2026 10:49:11 +0000
Message-ID: <20260724104819.1296803-4-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|DU2PEPF00028CFE:EE_|PAVPR08MB9745:EE_
X-MS-Office365-Filtering-Correlation-Id: 24b93ba5-c00b-4bcf-fc41-08dee9715762
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|56012099006|5023799004|11063799006|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Ixa5XRwEKQbnABGm+Qqyi7Rb/JeyHadvQgylJ3NLXhuOBw9XNzQFRBtmUc/wwTS1ncNRnr858uYRnR/gSNLzkTojVppHoi89QeDi8qGPWouO/3Y6elngwMsuFUPNw6JBsUa3IHp3FpWLEtyikEhcyXcJO3brJ734zFlL9UGAiKerCjntVARS9NLv50WTALov0rce99xKZe2hp2CivB8ReA5Td39PS6MyJr0EycAt3nDJWy0VfG8Es1FPNCVaaQz4yw4PsXn7yIqH7KXgbO0dKkK8NtzR8rhZ2LII30Qkffzdc4XeBEckQ6Vfwu8euFTAoLQXOcCbbn59rdiTVgWxxoEmT0Mf5ET9SHzY6/pKHt24Y0Rp39bQvZpxihxSrhj0d3xXLrOFjCBnzfOxvJgS8oEcbil2lb1BmQ8JPkaVy5FIzycyKDurbuUTTErdIwz+VbNRMTguwFZF+PMooKo05QjVBUgnX5RZb0nQnw+mLicFp5wKwnRmM0O/btuFQVW6kFc2DJjiiNLIe3ml0tJN4Yp5eoYjZhutR+P0PYI6VZvGstH1Sr0m2l2f3RwohOUZRGhq2not7vkhOOzzEkAbhW0HJ1HS4BpofuFCPDaSaJWSAdP23sTQmTw7Xd/R2pHh1H5P8rTOphOFaXsYOdQVFXh3Z6Ccc05faSPJ3iDgA6FeKH4p1qTMskWDzqW7kxpMPaBgMnp7s64fFIhjALpERVLztaLzIgwFuRqf0ewKCQM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 RLG0JNRr11njnmDj+PT9+2r4Ach9FdU5dP9Qw4RUQlR1/tmPNJqyxRZef54DWopfYnFu7QzmHfDMyFY120FjQ74a5/1BO1Fav59xNCk1Jnr69cijtOJEtos9PZ/Ey0V291T1rBsTV88CbdG6eaxhIuLODgoycUffZIXcepobCPwzghPUyQmrvD1soM5I50mO0sotUkrtgCM2eXp2fCG12O3ZNbAO6J/KQx6cH1JZIEYDieI2MlKOQ33V9bMGU8svzHBnVqUlzdDD3Kp4y1WJwcrwtneMpBhr7vmmePFBYoqjwakyrSmq8S7Ys9VD7T5bwTZvKieE3j/5dXb/DqOyTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	128add3f-fb60-45b6-a9a4-08dee9713237
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|376014|36860700016|23010399003|10067099003|5023799004|11063799006|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	S0Avjco79RTR2bK4c8lpaXKCx0kK5h/My7PD87t+VcOtgHVv2lBCyf7PmqWb2HXFpdA/yqGytt4hC29WRGLWigiBCi+UcVhTneKZa+l/GFoRlS7LjEvO6CjWRfxPx9KRsaeBRNO+hyHDOlFzqrTQSmscoWNcnnTn+3mibm35uLAYMhsc/9+JywxozVgefin7dHYWj7jPUlWn3YK04Hxs808w1Oj3BKlJgSCXymbq982GoZxPDU8y+SYMO4Iy0g+gV/vbZsM+FylXMtNq4UeGqxn4XmjFCZw+yDUVUDwFQpqUNSqd68SmWxFsP/VXkBATPgns7q6u862rSZquty/YGniJivo029tG6fm+Ln2kO3Ix3iietfS60xUMgxQvdlw/u/Sv3ovL/gSxkdgbZQHRX4q4tBjMYTZ+3HCNYm7EEbWbwyswpYvqsk4QBW9DIoVy84zVgjHQRaiJdFAYO1hhXmJbk8AdQOwLBJx+r7QU/qq73nsgCBd5e/ZgB9e3Rwk2i5X4HxKGDuzvhFUXxGuwQdIbcPyaxIqZpYD853BcxmyLOxkbM0+4HmcVXi7R0h+HjqWF4+hoEvBd0Dg+6PN4z2eRNhRdHm6CsVCYbFvuNFlljtNlKIryvkmrmoa6pcCYxRoKGaMw8Dw3NBUBxpI+3euOu5e6Qk+dIZzpjJEEpmF0TPOFhkSIiKMuE84iZoEROHz9KSOrmUdx/RX6Ce6e6A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(36860700016)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Qt6S5Ra4OEtum7KHsitDaDoxV1+Zn9KPmrwvmTLJRL9X5sloBjJOcNNaQUye/LzTPfDjKxMT99PNdAH1PXnZQ3IL4OMudwbgtE8B/Ix1iyZNeR4h7D1MQK6hjTktYjxZRCXv35+HT8oi2KTBA3WUossM2nJ4rqEQ0hUPDFAMroVnt6FyZvS1XmOrsln2/JwbQes8OM5V+3arywt6E0OVgB7JQlUqTs9A2P0yhohrwzgf9rwk/7uxkNSYlCCrWze4wYKqZ6sdS34hfCRVhLOVexu7UgO7W71AGk0O0Dd4RmBMy3WoGpYXUDugNO/OBR/0iiWftIkLnoEo+fL9UlBlCWdKhp3RZ3WjTr/kSmEUS8asg1UYZpe6TvuR0t6XXKBX2N7vPn31V1dmVJc60ghu0TidoAaMqWlsSh1t9YhR0iIIAIZFB6scEvmK4dyjN1yY
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:50:13.8806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b93ba5-c00b-4bcf-fc41-08dee9715762
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9745

Device-tree based GICv5 probing already passes the IRS details and
maintenance interrupt to KVM, but the ACPI path only initialises the
irqchip and installs the ACPI IRQ model. As a result, KVM never sees
the GICv5 host information required to probe the vGIC on ACPI systems.

Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
entries for the maintenance interrupt, require all relevant entries to
agree, register the interrupt as a GICv5 PPI-encoded GSI, and pass the
resulting IRQ together with the IRS base and coherency information to
KVM. Native GICv5 does not require a maintenance interrupt unless the
legacy GICv3-compatible CPU interface is present, so preserve the
existing no-maintenance-IRQ handling for that case.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 100 +++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e7a7aedcfaf78..0d90675fb319b 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1126,7 +1126,7 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static void __init gic_setup_kvm_info(unsigned int maint_irq)
 {
 	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
=20
@@ -1137,17 +1137,19 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	 */
 	if (!gicv5_global_data.virt_capable) {
 		pr_info("GIC implementation is not virtualization capable\n");
-		return;
+		goto out_dispose_maint_irq;
 	}
=20
-	gic_v5_kvm_info.type =3D GIC_V5;
+	if (WARN_ON(!irs_data))
+		goto out_dispose_maint_irq;
=20
+	gic_v5_kvm_info.type =3D GIC_V5;
 	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
 	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
-	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	gic_v5_kvm_info.maint_irq =3D maint_irq;
=20
 	/*
 	 * We require an MI if we have legacy support, but don't, otherwise.
@@ -1162,11 +1164,100 @@ static void __init gic_of_setup_kvm_info(struct de=
vice_node *node)
 		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
+	return;
+
+out_dispose_maint_irq:
+	irq_dispose_mapping(maint_irq);
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_setup_kvm_info(irq_of_parse_and_map(node, 0));
+}
+
+#ifdef CONFIG_ACPI
+struct gicv5_acpi_kvm_info {
+	u32 maint_irq;
+	int maint_irq_mode;
+};
+
+static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
+
+static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_header=
s *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =3D
+		(struct acpi_madt_generic_interrupt *)header;
+	static int first_madt =3D true;
+	int maint_irq_mode;
+
+	if (!(gicc->flags &
+	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
+		return 0;
+
+	maint_irq_mode =3D (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+			 ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+
+	if (first_madt) {
+		first_madt =3D false;
+
+		acpi_v5_kvm_info.maint_irq =3D gicc->vgic_interrupt;
+		acpi_v5_kvm_info.maint_irq_mode =3D maint_irq_mode;
+		return 0;
+	}
+
+	/* The maintenance interrupt must be the same for every GICC entry. */
+	if (acpi_v5_kvm_info.maint_irq !=3D gicc->vgic_interrupt ||
+	    acpi_v5_kvm_info.maint_irq_mode !=3D maint_irq_mode)
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	int count;
+
+	count =3D acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return count > 0;
+}
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	unsigned int maint_irq =3D 0;
+	int irq;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq) {
+		irq =3D acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
+					acpi_v5_kvm_info.maint_irq_mode,
+					ACPI_ACTIVE_HIGH);
+		if (irq > 0)
+			maint_irq =3D irq;
+		else
+			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");
+	}
+
+	gic_setup_kvm_info(maint_irq);
 }
+#endif
 #else
 static inline void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 }
+
+#ifdef CONFIG_ACPI
+static inline void __init gic_acpi_setup_kvm_info(void)
+{
+}
+#endif
 #endif // CONFIG_KVM
=20
 static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
@@ -1265,6 +1356,7 @@ static int __init gic_acpi_init(union acpi_subtable_h=
eaders *header, const unsig
 		goto out_irs;
=20
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
+	gic_acpi_setup_kvm_info();
=20
 	return 0;
=20
--=20
2.34.1
