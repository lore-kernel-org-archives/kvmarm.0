Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010060.outbound.protection.outlook.com [52.101.69.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679BA3E9F9D
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101440; cv=fail; b=eSpRi00QH3L5iX4zOetPSd7jkt7rKjwrQwX3PoJg10mq/qaBM6WJfZaENotsIhhjLP3ddmjeVf09LL0xFxAWC6XRXpkiEcYqMeU67LCSGDnTLzjd77IabagZdGA4wvdLXAJJ/UNZ2LYUth5lWNU9ZQm/ASbu67BiDrerHPmjvzg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101440; c=relaxed/simple;
	bh=0++yqQjA68/b2EWbNOZbqPB+4r3CQNxJf8H1MVDvLd8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ciG606JQEUjpo8S2h8ztdjFn+C5SukN6hlrLOwWJ6SiTVpbxFDCG2V+zGkk9hr7wodWDBSYLVkRxT1ahnjppTh+5vC3zy6oXBMEqqv1G66G49waS9SJ1JFzZyeu4zbV8vX1bTii80xOUaP67qB+Q6w1quL2xNBgjPvg5WjdzRII=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EcP5ti4F; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EcP5ti4F; arc=fail smtp.client-ip=52.101.69.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EcP5ti4F";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EcP5ti4F"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZypgNn0zvqS+idckSUQYBPotDVUhrwH43egnzpH7EmJ3OA+m5NyYgQTMdTGrg9vrWh1bCcgtdM7qb68k4VyWyjwyhTybY7PoNceJG+IbWFNxbslRSnXCWTDMZVOfldiixv51g0GYdo2sQv1qq47ZHpN4ffibYiejLBiL4ckfHYqRdo7BNfdLFmZVF9tQP+PRy1bSczNAmsTiVVCGCeaCjm2/i4YIp99Bv2pljBtDqKmicgx5TbVPKZeGWumdYSldQ3yUzlwEZZTCzvP8daDx47mj9xn8X+2HkGwuv7DGyWc6ih3osqhIpx6TmGrD8fvCmivlO2/bLXIMYJmNpFF26A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYcZkkdOGg6FX9sP2TAHTKj7VpqS4X9IdxETVrEonno=;
 b=tpFrdTb0TBUg897eVjI6kE4SxMN2ICXGnCYFam1K3HSvtSry5Ig2LoWUxukHelhddlamksEGfdrIx2JfvOW/mQIQGhDsJfXe5n5+KQEv5Wgg/XE+qVt52l0j/laKBXgIIY1toMZti+LvbzyRrbxlIg+G/YUx8vyyy1PmlZiHHP2/niupftWcMcIjl3z0uJDdXYZVgXPATIKchxSiyhhOKnsUvKRz9Hz7j5F7cxw0p8QAHD1aqd9pNmykAScs4B/doflm8fu2BGjzfhkRQ+XW0vY1f5pOaOS13KtW7cEJuLDg9ArRHA/CuJWV/g7nGG2Ammh3ATVwjnNus0+Ic6dQ4Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYcZkkdOGg6FX9sP2TAHTKj7VpqS4X9IdxETVrEonno=;
 b=EcP5ti4FNp8f0/suOV1GlKugH9yMI9d4FzGAn7RShm7kIWoL/VXl9kKCGxvCKq9jSgWV6l/GDNlGstZSO1VVZ0+3EXG7VGFTSC9rm2hj6yGMoE+ILC+bboR1G5rt2RYlc0tmmKGEipcFq7JksEjmowCYJYdvou933VzH762qJLA=
Received: from DUZPR01CA0165.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::6) by MIYPR08MB11947.eurprd08.prod.outlook.com
 (2603:10a6:290:7c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:17:13 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:4b3:cafe::33) by DUZPR01CA0165.outlook.office365.com
 (2603:10a6:10:4b3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:17:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6 via
 Frontend Transport; Fri, 7 Aug 2026 11:17:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewJOlL5eVNG8Digo7o0WfKPgxreN6mSqFIrBUY+hNdy/j/9Ua9BlPap0S63qvEoIBnNQGewPFh3ave4kShurgqVWUAUJKq1Pj+yY8KT4LChXORlJDESt216wzplyc0ikx1nUlrALe0wFODHfVYeFyWEpSuzaYX/m2FCBPJGnttGTMVvp6rG/iIAMQpjRXJX2+iTMQ6mfTQH8eu/zMCzQhMPU+uiEZfx+XMzTVMtrNtEC21OkYFOKBiYO7n9L1PmrG+lKnLmLD3xssX75ZW/8+HYzcffZbOHaLPclJmLunugJnko71uIM/hsFBjybJoWUfBcAW26tDLfV1RaKy+gIRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYcZkkdOGg6FX9sP2TAHTKj7VpqS4X9IdxETVrEonno=;
 b=A5yCI0gzutGQu4/b5Qn9CMX4tQ+lagtfIGGlbzAYCIlGnMHujwstNtWz7xMeX0of40MyZg/2oN6OFrC0uI7q+vK0LAH28MiEwh67UvC7W23TM/LnCm1vjXvRjlemM6hcInuetLAs7fMtJpvN0ZucR6rCYC3Qc4ueQ2G4hEWYrLRqfETBzQGwESb3TxrbB/f7u9CY5VIT5xFUUM7n6EwddM/Ivx+gylwy02wY8oY4bfRdnK7K9vVeQGN9Ue8OcMR+Jxx1dD35FfDfUwme8WLZ9C5Q1hzbuTsuO1RQoeylHT3dSmlbbr2Tg3hEb0F2gS6DLGx8F2f2cyS1TLIea/ORdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYcZkkdOGg6FX9sP2TAHTKj7VpqS4X9IdxETVrEonno=;
 b=EcP5ti4FNp8f0/suOV1GlKugH9yMI9d4FzGAn7RShm7kIWoL/VXl9kKCGxvCKq9jSgWV6l/GDNlGstZSO1VVZ0+3EXG7VGFTSC9rm2hj6yGMoE+ILC+bboR1G5rt2RYlc0tmmKGEipcFq7JksEjmowCYJYdvou933VzH762qJLA=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB8PR08MB5356.eurprd08.prod.outlook.com (2603:10a6:10:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:16:40 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:16:40 +0000
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
Subject: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdJl44UYwKlt3VlUyepnPLCQGeRg==
Date: Fri, 7 Aug 2026 11:16:40 +0000
Message-ID: <20260807111159.429128-9-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DB8PR08MB5356:EE_|DU6PEPF00009523:EE_|MIYPR08MB11947:EE_
X-MS-Office365-Filtering-Correlation-Id: b78e8433-8e23-4581-3c4a-08def4756e25
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|10067099003|6133799003|3023799007|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 /vXL7BhJ9rfVmEcobu8wKVu23Hq/GZE/ZdYPMD9SLjBDDl+F1FHSpCzAr1m+gMbL8DG4/UVGQWATxNv27FCaNqBzNj5avudVXQ2yd+cxdhI8p9qZNVTNWtzmhPHungAHuL+9rP3fjU7hzv+BmGHoBdmy1UCZ6PS70B9YfovVooQCSViU6izL34UB+8W5EJlDhuE4NfRD/xt1u0O8P2VR4V3pGblm8bbhPUGgY1VFveFLeOurUJb1b0Yuecn7uOF95hGR6JemkaMR/mFgxci6d21R4RxOCmaxPN5nlG5NhxzqigMyL8R+0XppTng/dKreBOH4NutNuz6yBAhVPqyKl4aI0792UlnJYLzMBRynGB0HoSTO5/UKbnd4O9ToLgGxdhOP8SLE4rxZ+kptT4+nRQvys/b7HCIQ96NVMJO+UXThtIgkTvREb11eBtCN2FbJDQkLdiEJgXrP2AVy/Ffx7gGR60LEEJN26atXqf1xTltjTAmhRI3TYeXvfch9NAkHVhO2STi5PcZsnyp5oACvOoVRTvR4Z3QABdXc/u1qFgjvt7h32iNe/jil8gNbxENLpg6VRNbzRNJs973JHbgwY3OwEoyCtTOHXB8CS+WpF3FQbkDwHjLGPfLJ6BYGeO0UKJUE5jUA8mYDiSs4IDAuj0sTAO02DxlQExGyMsFpoRKjZdOP8MD1MJw6WN2RVggwR1zDtVi/PGEvh1QRw5Lgd5ki5ScsA4o8QovaSkKt25Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 DWe++8aIouqKzh/5f1tcxAkpbLDnFLCoGerhncW+/LB5+GtbL2rUReHMthDpmZ8V/Hj8v8ZgXVi4mJjKJXlkkLHxXAQxrMrKcXSa82WF6ncrBSEKpo3ojL9rGleGcNaBTv45nWRTc0Zdlyo8o6TsO1VU6qqsBp4OL9X2BJZ+I9IFXacqEc2ssGKRv8VN5LNVK+0gsDv2zCKafHEjj4TuoMtT0CmVdZ8pq21BFvSGp/wjeVGQOxMTbjBBJvO5iVBhgcKBC0uc1r0oMelJoUL5ebzC/7LKkif/vjM6DCjTCWcYEDWoqBtma3py8PdQzLqttnJXq3HM9+Iqmow/F4MYEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5356
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	68379940-bced-4b72-df59-08def4755acd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|1800799024|36860700016|376014|22082099003|18002099003|3023799007|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7JwdjiWfltoQOOVCZKCzhpr5IqeS/gCCqwcXwb8ujdfXcofBAvu1FQ/s+fMYjvm/aM7zdFptTGbwfKp53Vour1SHofH8j+Pzu5DLQH8Wgmu+SvUNuduBNQHB5nVpXOlJsFgpWo5QnVoUq44zAkjhEsn/d/NLAvWT96JTaWrj63eS5uRTtlRMboKHeERRThtTEbUhJiWiUmLhLS6qZtbt2tF+wWYwZxCB7ekHkRNlmcea4DN6uRCFjPCOY6a2J/qIshDvJaiTCRZOFxZVFCLGLGBmUw3HtZh8ovjTn7bZ7hXYCqlkfnvJ94XR/3NvvN+60l30DBscWschxqcLsU/fXwdMQugSHdC/7GkkyfiQfbUocSbEOKyHr5vvitmBLswH4cqhNdTOpSnhXsJRs0OnFSFgE989t8I2Sw+E8qPinJlQ5kwPpPDVrS9MKEgUqoqkPgyzI9QCBYELs4D8ELg8YJ7jDj20M37rMZIuZgUeQ/+eJOHjzu8nWla3UtVWc3JTqRnbfdZ/ZT+8JG//x8/78XWbgtalVS7cEIz6vU3MKNPbZp1w8xadJv9yOxs+8Y1WOS8lqOzslrc7tk9eY+ehRmEmyGRvJSXhfkfHITPNmug2KbKLPBf2baIlXSRXVzA6y/B4Ho1VgKwfKfPa4wBjVOKaTl8UhoVOHxMk5axeMk0jPBlcZdusaGxeHyxeXNdTGPUPrYIWTTUy/6p7oyG4bA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/7pdHMeaDaJuGDvcQkzxqmP6UxYM78xGVBOGyogCBJybWBarFm8GnQ8nbujMW/RbtDUVrJr2NVEQERlkh5fEZp6/eUBGHqkPwfFND02IQDjPfHgqwtlMWY+R7DM4KtXfzkjGSdsytEQuA30eygIJ6huhewSa7h3nLRvZZ7cwdADNUE3ryl83HeWnOecncegIseqeCSdF1xYxGES8z49jtJ80Gx+iV2cZYIKFevYfQCLlweiWEsY2w1I7VcdWxKcZjojKFTAprKSilrzdnu6iOWus4GemsxJ7j1Nu+ulyBVK6CBEIRqF8y/W1dxozCIUAjNtVrk6HfGUUiJTMqvE2AolzKkTFwl8AVNDYBcMkSSfsuTdhiMrz2F1KsObOI+tyk9MIWI5NW6qsPLV6kGrS30d84kLJeD2FWTs1RCzRSOi/kpxPsZI5QdDke3MGC6dk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:17:12.8389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b78e8433-8e23-4581-3c4a-08def4756e25
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIYPR08MB11947

VPE doorbells allow the GICv5 hardware to notify KVM when an SPI or
LPI can be signalled to a non-resident VPE. This provides the
mechanism used to wake blocked vcpus once the hardware determines that
the interrupt is eligible to be delivered.

Add support for a per-VM VPE doorbell irq domain. The domain is
created under the GICv5 LPI domain, with one doorbell allocated per
VPE. Store the allocated doorbell base in the VM's GICv5 state so that
later patches can request per-vcpu doorbell IRQs and use them for IRS
commands and wakeups.

Add the per-VPE doorbell state to the GICv5 CPU interface state. The
doorbell IRQ number is populated when the IRQs are requested, and the
db_fired state is used by later patches once doorbell delivery is
wired up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  18 ++--
 arch/arm64/kvm/vgic/vgic-v5.c      | 144 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |   1 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/irqchip/arm-gic-v5.h |   2 +
 5 files changed, 163 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 907057881b26a..625d352756fcf 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -492,16 +492,22 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->nr_spis =3D 0;
 	dist->vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
 			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
-	} else {
-		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	}
=20
-	if (vgic_supports_direct_irqs(kvm))
-		vgic_v4_teardown(kvm);
+		if (vgic_supports_direct_irqs(kvm))
+			vgic_v4_teardown(kvm);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_teardown(kvm);
+		break;
+	}
=20
 	xa_destroy(&dist->lpi_xa);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 41ca2098ecb73..752329fc3d566 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -7,6 +7,7 @@
=20
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
+#include <linux/irqdomain.h>
=20
 #include "vgic.h"
=20
@@ -128,6 +129,139 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * This set of irq_chip functions is specific for doorbells.
+ */
+static const struct irq_chip vgic_v5_db_irq_chip =3D {
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
+static void vgic_v5_irq_db_domain_free(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+
+	for (i =3D 0; i < nr_irqs; i++) {
+		struct irq_data *d =3D irq_domain_get_irq_data(domain, virq + i);
+
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
+	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
+	struct vgic_v5_vm *vm =3D arg;
+	struct irq_data *irqd;
+	int ret;
+
+	if (!vm) {
+		kvm_err("invalid parameter for doorbell irq allocation\n");
+		return -EINVAL;
+	}
+
+	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		return ret;
+
+	for (int i =3D 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i, chip,
+					      domain->host_data);
+		irqd =3D irq_desc_get_irq_data(irq_to_desc(virq + i));
+		irqd_set_single_target(irqd);
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
+static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	int id =3D task_pid_nr(current);
+	int ret, db_virq =3D 0;
+
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
+		return -ENODEV;
+	}
+
+	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
+	if (!vm->fwnode)
+		return -ENOMEM;
+
+	/*
+	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
+	 * doorbells. We know how many doorbells we have, and therefore we
+	 * create a linear domain.
+	 */
+	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
+						 0, nr_vcpus, vm->fwnode,
+						 &vgic_v5_irq_db_domain_ops, vm);
+	if (!vm->domain) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, vm)=
;
+	if (db_virq <=3D 0) {
+		ret =3D db_virq;
+		goto err;
+	}
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
+
+	return 0;
+
+err:
+	if (db_virq > 0)
+		irq_domain_free_irqs(db_virq, nr_vcpus);
+	if (vm->domain)
+		irq_domain_remove(vm->domain);
+	if (vm->fwnode)
+		irq_domain_free_fwnode(vm->fwnode);
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D 0;
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+
+	return ret;
+}
+
+static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!vm->domain)
+		return;
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base, vm->domain->revmap_size);
+		vm->vpe_db_base =3D 0;
+	}
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
@@ -143,10 +277,16 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
 }
=20
+void vgic_v5_teardown(struct kvm *kvm)
+{
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long idx;
+	int ret;
=20
 	if (vgic_initialized(kvm))
 		return 0;
@@ -158,6 +298,10 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		return ret;
+
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
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
index 62ecb525557b6..6e5aa248f3cfd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -379,6 +379,10 @@ struct vgic_v5_vm {
 	 * convenient way to do that).
 	 */
 	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+	int			vpe_db_base;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 83cfcd056b250..21c8a69f99bb6 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -613,6 +613,8 @@ void gicv5_irs_syncr(void);
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
