Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010056.outbound.protection.outlook.com [52.101.69.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA0D13A258;
	Fri, 31 Jul 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509416; cv=fail; b=dvfcyD8YSO7jgpfXM24Iarl1guDrYM7dFDxN7Nb6sh++lngs2KrwZgnz1x8oweVtURuKcUEYVrXv2Qn8BT02LhP0DfHJR4bihNKsrCfIDUrz2t287tHjpwEhJf8Ym612W3OJyLUE05kCJ5tIJaAhrABc624kIxk3qPW9W6VHrgE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509416; c=relaxed/simple;
	bh=uc3/Jf3B0k59CaV3GEkG6H2wDkwyD1pllZFDgurHykw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JNYjKfvsi/5jK7chket3NwQJKeIK8foq3TlkIQkhpOc+iaZ4fOrWbVUcYBJZkiNdnLxzEpq/Jd5HTwNFMTy9ngzePUfU5M9R17ZndUco6EOqBitnrmzPNWeRRJo9N3Nf82jgslOvYeHojWyjf++VdCZ8JEs2P6xq6Xy7y05R9fw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TWFYA/Lv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TWFYA/Lv; arc=fail smtp.client-ip=52.101.69.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TWFYA/Lv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TWFYA/Lv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hnw/Ae/Oh1fSZKd1JRJgLe6EkWgzcI/xdHg+wK1rhj5rgkF8H9sudvDodNyQAKt1oRQHXB2iwcKGXHtlp12Y007YrMZCuPpQqzF7SXEBZVbTFEP/vVeODYzJfkeW7p1dBjs5UOtJu07n60VXzFpyY7xvkM7qyuAtTinb2Lbp0pxP/9EGiLVzs1g+s3unwi0bVfZ8nZapGKwV7Y8BPwOxZllklpfGHEE8iEpgy2m4VuWcWk2SFNIk13HW71cPAJBLrPE6PmQ6faliUrp+Zi51LZ72VrBRH5lqy9K1v72yzOVLBX2rE67FQzU0ZguoepIe0PCfS6yxN+Z85k2EH4RsQw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uc3/Jf3B0k59CaV3GEkG6H2wDkwyD1pllZFDgurHykw=;
 b=QySWdfrYZyVJ5UrhkyX6rIUcvB8uKrE5T2B0zalHNg1JRaZdzRJHwhGVn/87YT5B88XQ3e0TDlXgYse295H0msMmIiFkayuybWk7OzBZcxJx3didiHZmEeUcTpRYK4mQ9Is/lYn76StBgo8LeNcqQogXIgm/HiKoXY3V4grLqiYZl+qeImO32TcS9RGiGcWQjJwZfih/GoSY8kGttYk7VLSWigM+FTPgzGkBsMc4fTVu71l9M5DKeFzwCJRW0NZbM/1wCF45u+XTO7/hPFnQmigfaiTCdw0sygm2M4vCKWqJ+LEw4kYi1322e9GGdOoyjrdbb1+ob4HfGAyrly4lLg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc3/Jf3B0k59CaV3GEkG6H2wDkwyD1pllZFDgurHykw=;
 b=TWFYA/LvOv+h95NTrY0qBsSHQQGuD5R6NA7kt94OhvAsVbZ1U3AfcDZySYagsrvFakf2vf8H2TQd0m6VxqKgLN/TIcY8TvGJFaaT+L2nc1DlzRQRjQfhLeOnVXhwAUWSuTNkG3SYqzmjE536wARCEni5qWBhw3UcyCW8wbzTbcI=
Received: from DB8PR04CA0028.eurprd04.prod.outlook.com (2603:10a6:10:110::38)
 by AM8PR08MB5585.eurprd08.prod.outlook.com (2603:10a6:20b:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:50:10 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::46) by DB8PR04CA0028.outlook.office365.com
 (2603:10a6:10:110::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 14:50:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:50:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJ4vFi7LDyO6St42PYwAQjlqBPBGq8ShQK2i/KjvkaBLSkBHQuo1VnGh2QvxUD7yo+dsGAf825VdGTTeDApSzAljCE/I2IweydP+WPqPoGwd8EZLXgqOLIhvAkkLhuYQA8dk5ax3o7+keK7Gvtvh5PrJUPw4IavQ3VAIPX9MKdp9KsT3BLtQlU5mE7Rr5dQAiYSzqoZW8wB2hNo9H1zKx5VREuQS0DtqbkN8/rtkdEpg3qtqQ5UWCcvJXID68XSfaBrk7Ye2sZO6EPDs6ig+HOyGYB1Qr3mNAKUNNseqY+9+4dLqYW1eoHtXNU8m2car2Pp/ADcpoRfuGYSvDd4+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uc3/Jf3B0k59CaV3GEkG6H2wDkwyD1pllZFDgurHykw=;
 b=ePzH5v6YP0dwKcFi42zDBWnWJYh48IdMxqxmsQkIPqwcYIAbipZ9ekOeDDkihlFzGpDVIlva+UIn89fpFyUIy9D+lGnrSdlCngwujNJeK3e+5eGAYk8joN6y7z4sC8GZVCGs/sO6WYsUlBBB7ogsitrJ4qpAIagdyAxD31zbO+qxMO5GFpB9RKYQNwjT2tpz5BB64sIb8FeeXtgB3W1L7LhEAfwS/ZsqC91jKZtkkep6u+aVMpmp0ItWhwAO4T4vwJo59nWauB402w+Vn6FcDy2AJ9My9rCudIlTZqTH3nebTIiYzs5F8xmhswJNVs6JJk387iPVQxaHqdI3NZhU4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc3/Jf3B0k59CaV3GEkG6H2wDkwyD1pllZFDgurHykw=;
 b=TWFYA/LvOv+h95NTrY0qBsSHQQGuD5R6NA7kt94OhvAsVbZ1U3AfcDZySYagsrvFakf2vf8H2TQd0m6VxqKgLN/TIcY8TvGJFaaT+L2nc1DlzRQRjQfhLeOnVXhwAUWSuTNkG3SYqzmjE536wARCEni5qWBhw3UcyCW8wbzTbcI=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI1PR08MB5487.eurprd08.prod.outlook.com (2603:10a6:803:13c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:49:05 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:49:05 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Topic: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Index: AQHdG1ulFmLsDa1l4UqNn7Nr/cwa17Z8llqAgAsqZQA=
Date: Fri, 31 Jul 2026 14:49:05 +0000
Message-ID: <f7490df473f61f795c34c7f8530fa8f5844bf5e5.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-48-sascha.bischoff@arm.com>
	 <20260724121829.E2F181F000E9@smtp.kernel.org>
In-Reply-To: <20260724121829.E2F181F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI1PR08MB5487:EE_|DB1PEPF000509E5:EE_|AM8PR08MB5585:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e128c71-6fd4-43f6-dd3c-08deef1304d9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Xg03jwKXry041uywd+ZVuxbmul6x6gxIOWXD0vT46qvjwspi+/fUta53yXEU7IUfdW+NqI0SGP1QN3MbNM3ZOrvmBCJIgjBp8H8Xx9ZOsZkfl13kgeIX3guJHVsQ/nOZ0JMT3wHdDqOo+UQkQrtO5Ehq+Kk05FEHIRCixD3YuySy9mwgJDMp1TIXQLsMAjGRjy+45eMOhJR9/Kjvvms4I5gjrd0nXEHe+0bZZp5yjuQMI6in9rXAcoMGYLvoZjDZXhGoyZGop8hrgirVgnqxwRjxSVAky40iIO/6kZjO0h6g1lNQBmUEa4k2vXu0/6Os3WJ1WOXPDDtq13xdSJb1bB8hWq8/9izA8Z6TWyABgK+ssnfkmQh9VoOS6aUq6V9bJVawftsQ0DJ8zQyw7LKMoRPnW+VXuaL1L5zea4m/+u6PU6Zfxi9hchh5FWvO/kayjOQEm9NVw8sSblUbsvjy508XcnmiNRZt5hT28p6C+GMMBQLt4pUjS5E47J7v3IcZqLruL5lMlhOPBKQQLDZHmi4t+Kmfl8xvxnGdty5024I+PLJM1bkkf+xjRIznO+mLbpNY+XqY1/WHPFRtmZ4GYT0+obZcdn+Fm6OtRFUe2fVks1WhJ770RK5JTkVylDi1RzanknKqtIKhnRAO+HbExxoWosHDkk9e3LicHgVzwjrIEu2zDJ46Y/c8pY3tOeWVxrzQKi7Rh2ZoV3uYci/ONN7EBaIuxQa/XFwltSN+OGs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <09593DAF5EF7F0419CEBFB9FE3A16419@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 V2X4NrcjziGpsOrZcxbqZEN9AH2AXyy8Vz8yUhrHssmWiD+iuFbJVO6Oa4Yv9B0kSpn7X3/t2nnZaxWow+qAMo2NH8d2D/LeC5eDDvD2OeD9YXCiFW/o5ktEIZr9iMjpaqqY6xsE4h2JSA4xQYDDDkdEevyMi7zoiiRAT/CiYCHOs7PCQ/PWSbqVrTQWo1NXrNqn/rgOQ+xnoogHGzHnXxrXKdavM8oyG3wr1ChDAk3b1b7SQ/gw58S9+9G6sVhT/YNBMMVIPc2zVIqDTjtrfu6LxTsleirJ3Xx3/PSBEI9LBwAH95i8kpWRSCYLhiVahYX4bGf6EFOszG+ZLTJ9Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5487
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	99ffaa24-9102-45de-4817-08deef12de57
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|376014|36860700016|14060799003|1800799024|82310400026|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VSB3xUJc3pNMsQ4FmJC1/ovof2z8zeu1THhoRGjCfv9xa4tO1srUnCzwgAcnt1PxPaBiWyxelDo3WBBG0UIcOz+1Xml492JPFJViZO7ouAhueOF0onhKhIU7Yoa9p+rdsAqG2SeIbZUCbRgGpDyRt/cDva/2fxYZwiYVIdAtQmrL4Fks43LmnQqf9D8pOX3VMU44+5h7sq+rmNJpvUG7/DM2Wk118FCpe9swCpXtqHIPF6LCLUhkcOdB047x02EcsKR3HywQnR+oal5ZGEtEbIgfcFYPkdb2aTmSbY56tBItxabjQ/iYgfOkrayyOCpNBlRql8/R7zeGUQsZmGcwsJ/ILU16tm6M1P7Sf5C558jUC5qlrEDh8ROqPo9+4cmKNWSg3vVJrB32Ornijkwbg7KVJ6DHV/OJbO33ehGrOCARA8YLZjfndVk8XcAj/f6gZ0olhZw3qUabZ/Z5/TfdNYRTCpEtN4qlZRUvMHcZNjCpbd2fG1zT3yTz/ivED0pKJ23mcRnKbbCH08fPDprrgy2hRciAeqDakLU4f/WK2I/YGRIoPFsc4yHdxx/ApRlsBrK8lN7vvrolrdWndTwFQR25EwmxHX0RAH+yxAYjdtrgNK4oE9SJaGLMYBP/0Y/44e7qR5dhUMp4nzQNQ8lDZNyWwb7QS2vr+QuBu8nOvDlmGDys7zQXrZ48Pi8cXl9WTqfisDq6hDzYPZ9y+M3ivQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(376014)(36860700016)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YqGm7pRYpxwWXlDQ63uXya1abxv8ch/2weEgGnd0CefBvCcWodMdbtYR5lKK4NjYOC0xwJKuDA9TMSml/3VHCwjhTfah0FSrXrTdwyoIpgEbtrKGhE/nvdrr2tQElXdcRxgDGy2jTzqQ26PUNP6YIEkH4vEzhWNJyY2f1+9TD1kaWJt4jq6TNgbWL2TugadLSmsnDBi8CSeoY1vcBemOB4M84lhgQQjrb6qv+W1bN0n4IbzyIUm174BM1X7RXOiJw/cgf5AQ8slD02Dw0McwKclKDAOmAdBOsFEJ+6mJ6rUCHK9kH6r9f78Dtbb9IZ5sptqySGcRzIv+8aqzXTwi8noZFErSAIglOzBM7j6O58T4sFk0sLfob/YIJo1Mn20Wjlj2yVnKkPG2fV81pUt7acSAdRwEsmt/RmwhHW5x7TOW/6K7cdyEKsYcgK9vw7Jp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:50:09.6993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e128c71-6fd4-43f6-dd3c-08deef1304d9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5585

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjE4ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiA+ICsJLyogVlBFMCBwcm9ncmFtcyBhIGxpbmVhciBMUEkgSVNUIGZyb20gdGhl
IHZpcnR1YWwgSVJTIElEDQo+ID4gcmVnaXN0ZXJzLiAqLw0KPiA+ICsJcmV0ID0gcnVuX3ZjcHUo
dmNwdXNbMF0pOw0KPiA+ICsJVEVTVF9BU1NFUlQoIXJldCwgIkZhaWxlZCB0byBydW4gR0lDdjUg
TFBJIHZDUFUwIik7DQo+ID4gKwlURVNUX0FTU0VSVChnZXRfdWNhbGwodmNwdXNbMF0sICZ1Yykg
PT0gVUNBTExfU1lOQyAmJg0KPiA+ICsJCcKgwqDCoCB1Yy5hcmdzWzFdID09IEdVRVNUX0NNRF9J
U19SRUFEWSwNCj4gPiArCQnCoMKgwqAgIkdJQ3Y1IExQSSB2Q1BVMCBkaWQgbm90IGJlY29tZSBy
ZWFkeSIpOw0KPiA+ICsNCj4gPiArCS8qIFZQRTEgb2JzZXJ2ZXMgdGhlIElTVCBhbmQgZW5hYmxl
cyB0aGUgTFBJcyBpdCB3aWxsDQo+ID4gcmVjZWl2ZS9zZW5kLiAqLw0KPiA+ICsJcmV0ID0gcnVu
X3ZjcHUodmNwdXNbMV0pOw0KPiANCj4gW1NldmVyaXR5OiBMb3ddDQo+IFRoaXMgY29tbWVudCBp
bmRpY2F0ZXMgdGhhdCBWUEUxIHdpbGwgZW5hYmxlIHRoZSBMUElzIGl0IHJlY2VpdmVzIGFuZA0K
PiBzZW5kcy4NCj4gSG93ZXZlciwgbG9va2luZyBhdCBndWVzdF9scGlfY29kZSgpLCB0aGUgTFBJ
IGNvbmZpZ3VyYXRpb24gdmlhDQo+IGdpY3Y1X2NvbmZpZ3VyZV90ZXN0X2xwaXMoKSBpcyByZXN0
cmljdGVkIHN0cmljdGx5IHRvIFZQRTA6DQo+IA0KPiAJaWYgKCF2Y3B1X2lkKSB7DQo+IAkJZ2lj
djVfZW5hYmxlX2lycygpOw0KPiAJCWdpY3Y1X2NvbmZpZ3VyZV9scGlfaXN0KCk7DQo+IAkJZ2lj
djVfY29uZmlndXJlX3Rlc3RfbHBpcygpOw0KPiAJCVdSSVRFX09OQ0UobHBpX2lzdF9yZWFkeSwg
dHJ1ZSk7DQo+IAl9DQo+IA0KPiBDb3VsZCB0aGlzIGNvbW1lbnQgaW4gdGVzdF92Z2ljX3Y1X2xw
aXMoKSBiZSB1cGRhdGVkIHRvIGFjY3VyYXRlbHkNCj4gcmVmbGVjdA0KPiB0aGF0IG9ubHkgVlBF
MCBwZXJmb3JtcyB0aGUgTFBJIGNvbmZpZ3VyYXRpb24gc3RlcD8NCg0KSGF2ZSB1cGRhdGVkIHRo
ZSBvdXQgb2YgZGF0ZSBjb21tZW50Lg0KDQpUaGFua3MsDQpTYXNjaGENCg==
