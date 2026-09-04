Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013049.outbound.protection.outlook.com [40.107.162.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9467D449B0C
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522129; cv=fail; b=LUICqBj0g3Q9MzO9AgffLv283NuVmOkVyQbhIBspAtfnyzrFvos8iYFite0hgUXas2hVIvLBIbWnRnocz5Q8wh62dm/dVLdQBbdRMw85zBWbEqeBnqwOoY3BT619+U8MTHW3qjDLNqpuU3q7eToLIJQBkIvdhVmBRYbjZ/phjeo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522129; c=relaxed/simple;
	bh=R7YmEtju4SHTyuZ0tjVy9bXtGsp8sBcbDlJiON04vXs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jobaU8DKzUq3jPSEn7J+BdTNGodParPodzVbcMzGtS0ezRZPasbNqhMXAX99Ddf4AFiBIQDJNTqxjxnbQsAjEdWr2P/rGnbV9GuNRi4sFL6cQpYn1fnGFNOc981VCHEdDYJpGhT2hmBsbVo/s9NYpzvudzqZKStIz47+INF2jr0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xn0p2C/e; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xn0p2C/e; arc=fail smtp.client-ip=40.107.162.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xn0p2C/e";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xn0p2C/e"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Yl+l9+uXV10jpn/5NixfQ3EHjvvUZVErXxo38XypbxCYdnMCTbtE8EoiovgH1vZMnsdghcT/aPHb+4dYquYSvmZhlOpiJx/x6ycKIXmHUF9EJBuZAUapvQLFj71S40Fyo8L+d1zpsXx9EHXQ0cFmaDGZvDrHUgzbNgEyE2tdTo+qgaCwCwzeF2+HO4z6zMVkvF5p+8XBnXCcKKEWJQr2iR/ePnTyhz04F/tUnOdFojRggwmXCBHgKAQ0ZwyKzoRH9QhJ4ibqCSutALfumZ9D/rVFuzQ3ccjJOdcveh5pwUezyZyP/dVM48QiJYH4x8uOR+Ipf1OtFXpt9ZITJ3OKnA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ5lwU0jcW+nRkADTMFPjsgVmEFz0BrHcM0OLcknZfY=;
 b=njJwpkh6ETI1QR1UZ9xGcK2Sfi4Z4vTmLsXg7YD9WS/CeVSdjKFtZZTuqr7wGzWfC5Vyv/HOu6ljzaofE/ZKm1qQMRNzb4jH+CwQ86WFc6TB3t7Lijy9xgHgeLbYtlPx6OXVWFKKzkziJLKd4zuLSaYzwCiTFLJ6AbaULWkDd/lIbT0FxRN4HT9q56es8lGq9vzUeS2j/jQ6JWf4PlYgL8FpG23nsvRA59j5yvvJ8nZzOY+bbQ1wSY6ycCChbcQ1iQ7XqA5mNGrB4pVpp1wBLGkLkOArGYKo+Yisa597kZkfJYc/cMa/l8ef05QR0BZ4HY9qpxL0F53g8f+CjlQ5Sw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJ5lwU0jcW+nRkADTMFPjsgVmEFz0BrHcM0OLcknZfY=;
 b=Xn0p2C/e0KBVLvmHz6L9kkPuOk+gXQlL1SlZVcqUqIeb2SBZuGOGe6t/ssYc2n3YiFJpjhDUb1WE/H9uXKx0/08RUNp1/mWcfer9umhZmlvZiwURS8AzIDq0+oJIKL6StzhqCY70FF5FQW9rIrH47sJxuFPdag+8XwQaGIWW3Eg=
Received: from ZR0P278CA0196.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::22)
 by VI0PR08MB11044.eurprd08.prod.outlook.com (2603:10a6:800:24f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:41:58 +0000
Received: from MI3PEPF00008483.eurprd02.prod.outlook.com
 (2603:10a6:910:44:cafe::73) by ZR0P278CA0196.outlook.office365.com
 (2603:10a6:910:44::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008483.mail.protection.outlook.com (10.167.240.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuUGdaqrS8SjTFCQEOoHrl/fzkrwa0jAzbkPlk3clXBDIb1S10Okup+UJg2VUKQDVgqLbX3n03d6DLoSmVzswRl2V4ZyK91ItlKkOdFJDOePVSwnML8or77KuYWNOCkwruWSUnMVdJ1/9qOTXszdOR6xO4kL7cpZ+AWbudcIKTc6jUEuO/zaLjNBPxWnQRjk92XkAAXH0obJvTKGt7FEL4bBGlrkiK/QIlDY+SOISBt/NQ7kBBRpdU84OD68JqgWlHlpvjl0EFrYOTnLFPduIi2zDc9+EI8pvfG5K2t98Q9+zsAyp/OLRdgbErQ2PjezB7obrk1KF5FWL8MceNCffA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ5lwU0jcW+nRkADTMFPjsgVmEFz0BrHcM0OLcknZfY=;
 b=QXhT0AeW9l++jDwz9xO3y6mInaCa9jVgq1lxc7rWjKDXaFvI8J5t/PeqBrAvcjWc8FvZXJIj+afwGTPIsUmFX/WMgjifySeOd52DRLA5/Qi0Ww2f4Vk+4UFfDLcu+MJjkEVY6Xtm/oshbkPqxg8PC0DdhwCTZHqU7RvP93hXf82Vf1JJwett/nmBd4n1ucwgdI3Zs6o1CnWR8KUDwewa7Fuj6M04m4E6bMZOPZWD2XC7IrMKHTEPuJxaijPlJKCveTBKLgst9pMB0gE8+wDzIjs12RGMaWfiVIWSCGD6LBPpugCCnW9E5UMwSs3+vfW5wgrbhJHYdxUFbfRW4W29Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJ5lwU0jcW+nRkADTMFPjsgVmEFz0BrHcM0OLcknZfY=;
 b=Xn0p2C/e0KBVLvmHz6L9kkPuOk+gXQlL1SlZVcqUqIeb2SBZuGOGe6t/ssYc2n3YiFJpjhDUb1WE/H9uXKx0/08RUNp1/mWcfer9umhZmlvZiwURS8AzIDq0+oJIKL6StzhqCY70FF5FQW9rIrH47sJxuFPdag+8XwQaGIWW3Eg=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:41:23 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:41:23 +0000
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
Subject: [PATCH v6 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
Thread-Topic: [PATCH v6 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdPGJPSKRvNVU4P0ybkrdp9mAt/g==
Date: Fri, 4 Sep 2026 11:41:23 +0000
Message-ID: <20260904113404.4051341-15-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|MI3PEPF00008483:EE_|VI0PR08MB11044:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0b990f-8d07-4e70-ebd2-08df0a7986ef
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|5023799004|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 QtBurcrCZl2G0crlMgkxlw6JtwbFoX4//V8lQwD7WITdwDXHrmJygR/MvFBCQlTjMUpxhz74Wj3CslanuCDPKK5D5lK+4nGRuLHbN7xa6czXhQitSIQ42n/j6ULf6mqJrHlVX8tuj51S69O1+OuYo7PV1Uj06nzEdWNMBTnXFe4jcT4rvP4CxuyojKn5u2VTqxNdmsC9M1GSU3awBPIA4vA3adAHJkejI43Kte5B11lvCewWxGi279i4O7RLFNi8gYwWLTSSTwZwgaa1rkCskn6I62ytACdqKXVAKYNmmdhZa2l+FiRkkrgiRWfDULA0tup7zd+6Wdz93cm4gwDCOLtox1w3TdGWTzxhPc5XWI6zVvJE+qnV59TZWscQqrd/LqWwrLjK9ABbf5AfSAcTM50tM+6Ll7KXdCXXhAjy6xlsdMPMJRvT8YThZCnv2QDnLvWVdBHyfVWnVOjruTmoJ1si0ONTZEoDUgvgHBK2vqS14lROGAhawprdRfVf8bYGzqV2KIlW3QKHGWN5n7QCVvbe8+UZkr7TCzrwbMELFK5ZE5eA9+7habV/ENKm4kMc/x3mp5gWDicrj3BKqDJnMzI80Y1JqbldQn2+egQM/ip3oBMzxAjeIZDG0tyFGQW3XRFXTEWHc2Gvxekomz1fcoksp7aFRz3ScvM2ODf85cUNUS/+Hg7+wCZ2tI34zcV7uh6TmUikO8h4JrxgPpLIFfmIj5vh4njPkzBTu4NP6Z0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(5023799004)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Ao+fLrNab+UdtByvwOb7UvgO+MAS/nfEg8940sgJgaD+KUcEGU8Xw+iIQYlcsFA2TbTjejjZ2ezISQerleRZXHQsEdmXwoN6PNySZlPFTwSfbkj8XB1pQS3T1/9wGC0goJz8PXTvfBtEPmq36OfhXslcdqVxx+5Uc5Zm0JtRpZcEDVLmrWk3FIHRRNdcUvofwcqSwUf2rNveHh2C2DTl/s8jjag40yuMUKsrpTKGACuGRzOU3yykbiRVCZewbKpvXDgHwxTCGJW7q2kn7uPaw4FVGC5/T4k04knUOpvtUkUhGqqXJZpNvxUUrCpp5V4+N/3TJKD0ZimDOiGWlMISRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008483.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	baa218c6-97de-4157-a121-08df0a79726e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|36860700016|35042699022|23010399003|376014|10067099003|56012099006|11063799006|5023799004|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	z7Rrfc9w4lPmZWX4qPbKZc4McSMzZP5N06VgVM4bqrdswqRTUWGPm7jFn1BTwd0lrLayLYXnXCiiiEecpz9+8qSzraxXGQ3cl8neiv6OwOnP8Mh+VvfkEhD0AmbLsDZuwTeSEk9cHqtEPUPiJyKc7Hj9RuPb5RQAgPsCAXmGXFzcGWTq+bR8gFJMQgKuUgC5PuuYfrJvb7Lk3NVy1yBgplS7MjN31Dt+sTsEqn2BdXJ0n8qR9yTnXfywGFoNH0i8Xa7BQL35W53SF/5KPNbOzzXJaftR5u1KcJjWJS7tpXbWvNI2a7le2NAfJj9Eubsuq/0S9UmX58txf9jj90MKU3LpoT4Spe3zKkTKBARjCNJq7ppmw5BQUVWjiNEuFXuGqgGC7EWXEXuFSMmbl/Sv7cZgS39qIyDCiwh1hAc/PGwcMauiEapI7CRaGvfPuWOAbJRpXPqePSrFYzeCrl/vr5zuZnWmdNUczq+Uk4+J4Bnyi7/gP4ddc39W+2lk6kZW/dDNjcSOWFkUy33gVMRRwydrm9IhW3/lSVKkQKIrXywCwG1Xjm6z59tpXBVULD0dekCzHYk2kBUMUU9yCU7a6JKrwpjX5qD1yR9I2B2sqbZzvHg/umssRBwi57UY5tvly8I3F92vhdFeDvwYWW2NzeKsg5vuRr/Gw7YrZ/RKGmg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(36860700016)(35042699022)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(5023799004)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HJggRYGk+IrWCYyGUBEjcOkxhj3GqDVR0Ki/mkLT7p4arTPKSje7mBDPPLUyI17yJ0FQm6SuQVi8LTOX2ykQkJp/Br/moAGrzp0eYNWqcqQ0KI4DXGURYjSvggcrdK4fa5uEY/WrLP41aWSTHCsc/Np+U5NxzTk80AhHd5CStq6zJjmY+7sBk0shfdhcbyKFEY4/kw42ToNa67z3rQc6GCUTmEqtn7F/r6DsUKzBtoHpvm3KrXpcXO5F00XJCyVIXAFDDChIbV1lnqVtzBHEQfCMpr3vyfa1e2BTWLQMeQYDp2/4Py2fewXVSlTBHHXXSlhGe4yvA5PTgYToahU694sTjjMB6tKoHXPHiYUV0zm1artwY+YnHQAPLjagFF6jYK9guqyVU8245n/bMqNZyLP+Sd9LR1/R45VtSKPCWRRo/ITJOpM1KObrGq4+eX3n
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:41:57.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0b990f-8d07-4e70-ebd2-08df0a7986ef
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008483.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11044

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts.

VPE doorbells are allocated from the host LPI irq domain. Without that
domain, KVM cannot issue IRS commands or receive doorbell wakeups.
Fail the GICv5 KVM probe if the host driver did not create an LPI
domain.

Allocate a VM ID during vgic_v5_init(). The VM ID is also the index
into the VM table, so allocating it selects the VMTE slot that will be
used for the lifetime of the VM.

Create a per-VM VPE doorbell irq domain, allocate one doorbell
interrupt per vCPU, request the interrupts, and keep the doorbell IRQ
number in the vCPU's GICv5 state. The doorbell handler marks the VPE
doorbell as fired, raises KVM_REQ_IRQ_PENDING, and kicks the target
vCPU so that KVM can re-evaluate pending interrupt state.

The doorbell domain indexes its interrupts using the dense vcpu_idx,
while GICv5 uses the userspace-provided vcpu_id as the VPE ID. Store a
backpointer to the VM and use it to resolve the vCPU before issuing
VPE-specific IRS commands. This preserves the userspace VPE ID when
vCPU IDs are sparse.

With the VM ID and doorbells in place, initialise the VMTE backing
state, including the VM descriptor, VPE table, and preallocated VPED
storage. The doorbells have to exist before making the VMTE valid, as
they provide the IRQ-side conduit used by the IRS commands. Make the
VMTE valid via the IRS, then populate the VPETE for each vCPU.

Add vgic_v5_teardown() to unwind the state in the reverse order. Make
the VMTE invalid, clear the per-vCPU VPETEs, release the VMTE backing
state, free the doorbell IRQs and irq domain, and finally release the
VM ID so that the VMTE slot can be reused by a later VM. If
invalidating the VMTE, clearing a VPETE, or releasing the VMTE fails,
still free the software doorbells and domain, but keep the VM ID
allocated so that the VMTE slot is not reused while hardware-visible
state may remain.

On init failure, call the same teardown path so that partially created
state is unwound consistently.

As part of resetting vCPUs, mark them as valid in the VM's VPE table.
This informs the IRS that a specific VPE may be made resident. Without
this, the IRS will treat the VPE as invalid.

Also introduce vgic_v5_send_command(), a wrapper around the VPE
doorbells. It takes a struct kvm_vcpu pointer and the command to run,
and invokes the function bound to that command through the vCPU's
doorbell.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 229 +++++++++++++++++++++++++++++-----
 include/kvm/arm_vgic.h        |   2 +
 2 files changed, 198 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 455161e52f81b..5b599821b2da2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -99,6 +99,11 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("GICv5 LPI domain unavailable\n");
+		return -ENODEV;
+	}
+
 	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
@@ -381,12 +386,35 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_=
id,
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_cmd=
 cmd)
+{
+	int irq =3D vgic_v5_vpe_db(vcpu);
+
+	if (!irq)
+		return -ENXIO;
+
+	return irq_set_vcpu_affinity(irq, &cmd);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
-	/* Our VPE ID is the index within the doorbell domain */
-	u16 vpe_id =3D data->hwirq;
+	unsigned int vcpu_idx =3D data->hwirq;
+	struct kvm_vcpu *vcpu;
+	u16 vpe_id;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
@@ -398,6 +426,17 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case VPE_MAKE_VALID:
+		/*
+		 * The index in the doorbell domain aligns with our flat
+		 * vcpu_idx index. However, we need the actual VPE ID, which
+		 * means we first need to resolve the actual vcpu.
+		 */
+		vcpu =3D kvm_get_vcpu(vm->kvm, vcpu_idx);
+		if (!vcpu)
+			return -EINVAL;
+
+		vpe_id =3D vgic_v5_vpe_id(vcpu);
+
 		/*
 		 * We need the actual LPI ID which lives in the top-most parent
 		 * domain. This hwirq won't include the type (LPI) but that's
@@ -453,15 +492,9 @@ static int vgic_v5_irq_db_domain_alloc(struct irq_doma=
in *domain,
 				       void *arg)
 {
 	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
-	struct vgic_v5_vm *vm =3D arg;
 	struct irq_data *irqd;
 	int ret;
=20
-	if (!vm) {
-		kvm_err("invalid parameter for doorbell irq allocation\n");
-		return -EINVAL;
-	}
-
 	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
 	if (ret)
 		return ret;
@@ -488,20 +521,10 @@ static int vgic_v5_create_per_vm_domain(struct kvm *k=
vm)
 	int id =3D task_pid_nr(current);
 	int ret, db_virq =3D 0;
=20
-	if (!gicv5_global_data.lpi_domain) {
-		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
-		return -ENODEV;
-	}
-
 	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
 	if (!vm->fwnode)
 		return -ENOMEM;
=20
-	/*
-	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
-	 * doorbells. We know how many doorbells we have, and therefore we
-	 * create a linear domain.
-	 */
 	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
 						 0, nr_vcpus, vm->fwnode,
 						 &vgic_v5_irq_db_domain_ops, vm);
@@ -538,11 +561,6 @@ static void vgic_v5_teardown_per_vm_domain(struct vgic=
_v5_vm *vm)
 	if (!vm->domain)
 		return;
=20
-	if (vm->vpe_db_base) {
-		irq_domain_free_irqs(vm->vpe_db_base, vm->domain->revmap_size);
-		vm->vpe_db_base =3D 0;
-	}
-
 	irq_domain_remove(vm->domain);
 	irq_domain_free_fwnode(vm->fwnode);
 	vm->domain =3D NULL;
@@ -562,33 +580,122 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
+		return;
+}
+
+static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int db;
+
+	for (i =3D 0; i < nr_dbs; i++) {
+		vcpu =3D kvm_get_vcpu(kvm, i);
+		db =3D vgic_v5_vpe_db(vcpu);
+		if (!db)
+			continue;
+
+		free_irq(db, vcpu);
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
+	}
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base,
+				     atomic_read(&kvm->online_vcpus));
+		vm->vpe_db_base =3D 0;
+	}
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	bool release_vm_id =3D true;
+	unsigned long i;
+	int rc;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * If the VM's ID isn't valid, then we either failed init very early or
+	 * we've been called a second time. Nothing to do here in either case.
+	 */
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc) {
+			kvm_err("could not make VMTE invalid\n");
+			release_vm_id =3D false;
+			goto out_free_doorbells;
+		}
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu)) {
+				kvm_err("Failed to free VPE\n");
+				release_vm_id =3D false;
+				goto out_free_doorbells;
+			}
+		}
+
+		if (vgic_v5_vmte_release(kvm)) {
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+			release_vm_id =3D false;
+		}
+	}
+
+out_free_doorbells:
+	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	/*
+	 * We only release the VM ID itself if we didn't fail earlier. It does
+	 * mean that we might lose the VM ID (and associated VMTE, etc), but
+	 * given that we've failed to tear them down correctly there's no way to
+	 * safely reuse them. The VM ID allocating IDA will make sure we don't
+	 * accidentally reuse this partially torn down state.
+	 */
+	if (release_vm_id)
+		vgic_v5_release_vm_id(kvm);
 }
=20
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
 int vgic_v5_init(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	int nr_vcpus, ret =3D 0;
+	unsigned int db_virq;
+	unsigned long i;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
-	ret =3D vgic_v5_create_per_vm_domain(kvm);
-	if (ret)
-		return ret;
-
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -597,7 +704,63 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret)
+		return ret;
+
+	/*
+	 * Stash a backpointer to struct kvm. It is required to resolve the VPE
+	 * ID from the doorbell index, which matches the flat vcpu_idx and not
+	 * the vcpu_id.
+	 */
+	kvm->arch.vgic.gicv5_vm.kvm =3D kvm;
+
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		goto err;
+
+	db_virq =3D kvm->arch.vgic.gicv5_vm.vpe_db_base;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			goto err;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		goto err;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto err;
+
+	/* Populate the VPETE for each VPE. */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
+
+err:
+	/*
+	 * Explicitly tear everything down on failure. The teardown function is
+	 * written to handle any partial state we might have, so we don't need
+	 * to do any clean-up first. Teardown will be called a second time on VM
+	 * destruction, but that's fine - it is better to leave things in a
+	 * clean state now, and doubly so because userspace could actually go
+	 * and retry init.
+	 */
+	vgic_v5_teardown(kvm);
+
+	return ret;
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 593145760812f..a00d5151536bd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -371,6 +371,8 @@ struct vgic_redist_region {
 #define VGIC_V5_VM_ID_INVAL		(-1)
=20
 struct vgic_v5_vm {
+	struct kvm		*kvm;
+
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
 	 * combination of the PPIs that are actually implemented and what we
--=20
2.34.1
