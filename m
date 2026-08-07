Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BB434B669
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101593; cv=fail; b=dt34Z2xjbFUFoDRlLKIqqhc6cjKUxsNNUqNp34tWM1KZKtKdDgPdvCmafoxE7iCsUfGX40zVS2eRcAH0vz+xq7fMwiyNusa34Zc9mN0txWsdX4vj4+CZvArGW2KNU8nmpa/fYJ5MxwLjWsn2ko9Ey0DKAw0OhFVsya2M2VIrnE8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101593; c=relaxed/simple;
	bh=bpG7e1VPjPnO+l93fUmianZChTs75Z2c68KABij+wQA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5la1u0vBA5Id47gYGbEhiyQ9YEKg9DbLF/dfEFMkLecTjtoS9iDQWL1lmfHRImOnOCTXwuWvB0/69qRbrq4H5Qlk1kyCCzWQ9g/F2D9jfuc43ZhACtuFI5AfMCur19iTSmiPWyCHCSjuB0sWre/uUlHMNC7nZIf7iAJkGCvdNA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L+T9zHWY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L+T9zHWY; arc=fail smtp.client-ip=52.101.69.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L+T9zHWY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L+T9zHWY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OAsAXMWQWy75+q7rERHYx7EZcrDYRtoS18Rs+FnyIzRQUi9q5A5smncY2tLb3XZ39HhjWh58KXOXINKj3nZxU5Sn6MS4MapBSL73P4NedYxBLUDfSSN8RMOxfttMQiI7Kw3ER63SsroeF7k/UKizRukzwX9/8H1FpZD5l9zha2gidN6vl9rLsbfXzb1hmz4agYc1JH3qtgUDozKLAzfxlsOQD96UjAvFytHHsuJ0NqiTTKdXQmBiFKhKTF1hmngcXeAYQg5WmHZGiXs1jlVA9Q9BQiTFnU2yoq6Ru4Z1wvdlv5ZBKtOv6IoXeWm5dBF5XmmB7NKuAqxgvpbiJU5NUw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0p0Baxv0Zrz3yz3ZXjxo+JwV0Ye42h1SB2CtNLujJDU=;
 b=WmklfBc0SvnZ7hWuLO3VVmLuCYt5SvX5ZAt79D1cFFQw03DOgJWL848qn4Is0ShrOVsNeUa5TAUN5w3YXNuMMyaaZZJ+5QIygKgQppExMoKok4a1PDStDHIAqPSE8Dccf0kBfSkfdZ+4dg1q9AB6e5Y4BYS+PvIcVWG/SMS6eZgYFkruuF5J0qYfsNFji+wQBONpYLkG7QGtGSy6K0AhHoHN0icSMM8yZNcX9jfVV/hHobfFID1YUcrYnm+S55sJfhM1d5yYOJm/G/uUgSGzL8SLlJ9qtGmKBX5ADz7aC0+CgcwsjaXfgu/VbacIcc7qt0XcU+3YW1eqztQwpWVLaQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0p0Baxv0Zrz3yz3ZXjxo+JwV0Ye42h1SB2CtNLujJDU=;
 b=L+T9zHWYAcDxvjMvjdTYQdh8jXWrcm/0uKv+RTDIAyRQPq9e0xJr1dfXNZRJ6n6KxpvBjivVi4UFJnPWYJq+CsrAzU7XR8TBSI7c9XtafNPVgwILqmM6ko57QW570JhiKLTYRk/UgWB16wUUGk7aiZDsXuB3dk21fSBRCDDUYGQ=
Received: from AS9PR05CA0054.eurprd05.prod.outlook.com (2603:10a6:20b:489::13)
 by PAVPR08MB9356.eurprd08.prod.outlook.com (2603:10a6:102:30f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:19:46 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:20b:489:cafe::19) by AS9PR05CA0054.outlook.office365.com
 (2603:10a6:20b:489::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:19:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kDkP4cWP9l//QDUFz4HwI+G3jZrslih+2cfAVwDCl4hL2klFS/MIKpbHB0bxes3NCTEdUi4bzrtlyQN9NwET4LmERTmQYL1EZwnmfZB/kqU7L0GH4Q8iAvZWr4rJ2B8vawT1YDDMGPv3BQ2H1/PTMOA35wJxTNK8fnHCudh0O8fmaZHBd+LDgL+liNLqIRxJEj3vzi+xvn5qj6JiyAnc434EODyKOuwbDgidAWboDTfVBiw3PU6+MTqeIb3us7HhInfxoqU/j66uPCfZ9A4buguVRaQPV462EtLbJYjLf4BpJM3JEB0Bl9dcAS6qGf8NZb6b9xWAP8kdA3tW+ahsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0p0Baxv0Zrz3yz3ZXjxo+JwV0Ye42h1SB2CtNLujJDU=;
 b=eob9SRLVPSIOAEUKesmggoTaiAogG5fSlV7aJdkx/VTfIjXmsYuDxRfTNHlF/SJn91ETJ5fLXu1M2QZDHpLlCO4AMvxW/j8LsEwQBpm3r6YRWS0cSR/5R3sizei2+d61b5WDkmYv2lQ1XsE0sP6gCvjcNqyaK8PT39HZn9Lkgff7H7b4ywl9Oow9wO99gzazT06YAdk4EtbatBB+z4e+laf8tm0zIFmTDRruaOVghpIvYdUR3/uiigIBj9wguMbql+3S1tzjwcg1jTDHZnXTNaGk9d8VsTc1Gz+CfVNDT/BZLAjO+9XFtqj6Q8reiaU1eXBcQWQXyl5zSuNRsHMGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0p0Baxv0Zrz3yz3ZXjxo+JwV0Ye42h1SB2CtNLujJDU=;
 b=L+T9zHWYAcDxvjMvjdTYQdh8jXWrcm/0uKv+RTDIAyRQPq9e0xJr1dfXNZRJ6n6KxpvBjivVi4UFJnPWYJq+CsrAzU7XR8TBSI7c9XtafNPVgwILqmM6ko57QW570JhiKLTYRk/UgWB16wUUGk7aiZDsXuB3dk21fSBRCDDUYGQ=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:19:13 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:19:13 +0000
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
Subject: [PATCH v5 13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v5 13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdJl6TYgqYcES+iEiHSl/eQNdVHg==
Date: Fri, 7 Aug 2026 11:19:13 +0000
Message-ID: <20260807111159.429128-14-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|AMS0EPF000001B6:EE_|PAVPR08MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: ced8b136-5bd7-45c0-ff22-08def475c98c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 jIyPTWnmVXLz03kfp/UpgEDldCtrHWy8DqyGRCSgt7i5prDFIMkpD3NIUC3adYajq9oXTmRTRZjLbV4CugyNnQHp5uXeXXj9h1Y4Osyi6LvSdqfdN9fppCcxHGc5pIh7Dg+90PFOj2/FTvnuug/seqoxCdBOuYFyQpPHgU9xlsMhL0dJTTjdtInevy3mKOvn6/TRGy1VaqnSfZmOLlhIXTfIUaPLBGrJQsuvd0LuVj4UqfqXDX+KcBkI8RfnroA2+szHm5G3ehNGpgeDr5hhLvURoBysuzSLyEo1Im+D+jcUDGFDT9iEcuOIB0P5lCG+uQ7Yp53zZtAmAxLqlY7e7x3ah/gWVpnAATG+6BAlcd8M9tk/x/b7Cu4KgGhaBpmx0H78n2xCQpi9pzDBxhogZ2dJzq7BYyyouoycBXHrVNDCnX5S98L6nEj951ajTJwI5fQHS4JGTq4/78mVfkGwETCgBmBALUFSPQtr1u61Nfunp25xCUc+pYcZJ/Ixfoo4Mahra8OBp2QtwfFncxkBsf3N/FsIm0sxPV7zV71ZcG7AAYmtesRy4fO+R7DxTzjSSekw5aZ7jpqDO25+177I8EberJT+oenb/X3AAQ1eQ+6JagWTdePp2QgQVKLsPJvDArLFejdVNNsTcowCXKoSvjax0qd+SMSrb7KXYtSAZQDDXJ7XnUEOl+X5jz39g0s9PGaZKQWy4q1uxJPaa/K70lmJHcsJOZIYu7F8+K6kfjg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hYsAVh5UHHxctbFNusRFMjOz5vAlTgixSMotZnXBR7yQ6VrgiPTTG67nf15aDvyZ190odimw2w5t7/s7ks/SQ+/zQOYPt2mgXVAguh8whpXXdB58BXA/DxKYm1TirTcK3/5lO5WqDz44pFzIwDWBOMSQ5LDfUkIePhBkLDQqmzITrvRR+5uAsQTIqbUuFxOX9URPRNREq73le80l29nwE0vWwgS+59X2lVVGPy4NH9QH0FqnzTYALWF5HoQYsqktSrGhcOg6DOgqmQdKxOAyHf95OmgOYmeAl6x+QheXvA71HRQ2oK+NmkcGzpjahCnb8BiwBN1y3s4f6EG74bdR0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	294a62f2-5256-4c70-6d93-08def475b5f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|35042699022|36860700016|376014|23010399003|18002099003|22082099003|11063799006|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	zP0SIHoQsGZrPaXQv8/nzv12IOYjrKKfFbXuitFMR/T09haWhJXDLl2HNe4vCrFXpRLB1kYLachSvWeYUOTT8RpryKpLNLzgpDzuC0BKNcQx14yUbQHQAkzn/qvXdYLDiDbxNvGjF8xBbqloZPs6XIm3QizFGOdWaQ1qMyYTc8WCkAlXm8YZ5r2IL44Kg/T+J+ovrqjMli8Je2ZLIluR2nsURQBiv0nosDQF6MaJKdrjYoXOVa5RILBOVrAkI9jh40bxqzfH0UUnpIkHmwjUaZFR/nkBRif0+vmpKuXi47g+Kb+D26OEMNPSwO9KibJ4NPHPCJz1IEss1RRwdc2/iuVk5+helvLGynelgjpYQK7EzSp41HzSuOX/WHI3HSQIQbvMXHS0XYEGkHzzj4k6jMqjOHzA1jOwh6ucrikZcfl9/2whtAnMAtwkrxVoGqcyKghzX48pLClo/fqwCsM8L24H8boG3UD+mMdSrE8LIUZM9/tyO2MrrrEjYWTOM1dUhp/XcGFJ14h3Lg2mZAqnTMtw24DQRpQjIoRmORk2j/0kSn1lmBM5QGsRxQiZ17/68N5d4gnKWupwk5C+Wu+2BiF/LzlG5SJAElS1E13InuvDiJeZ09DsEIxHt2+jTkJYkbQ0zKJsYYnspksWMtEESuTUIk5MYKn+VGyyOuLUKQVQRee9DOR+nUSau1B5i/CwrA19HHuO2R6g9PLMrljI1Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(35042699022)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	07jbvVE9H+RZT6RWvZdgG9GC232AhAbrsc0+jE7KmoS85hZzvl9p8/DL/Yk4uTvYLPGeYfyQDZckUcpZh7Zx4UTzDt7w1rRn/NBonhJYaBIdSdSgAFeSmf5WmnCBS7d77fUZkqWTHx+t+Nh46zWjUZsnmmWk0duMW+mBCptDTQY23Bw7ctWxByEQ8aJmaRnbQOGGBhif2ErRSbgrk/+DBRQ+bYRx+ZmrL6eolt3po9POcFfXXCBxPjrgXDmrjxk5/aXkXUztWr9vJH36x60I/p9ZpJ33fBKPeoha9lf+8axEZpi7+Er0GGPoPrnS6uMXsCizhhfT0+eOgl818KhAb1975PFjwIe7GctC1faprGkFeN5fzJvMv7iYJiYyMh5moFR7GPoMYQZgBuhLfmAQxArFqXq37Xr/IqEQ3IlMGMkh4ndVqZ2EK1ipDAo2gnND
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:19:46.2024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ced8b136-5bd7-45c0-ff22-08def475c98c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9356

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 84 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b9257e0554b73..2121f67d3b59c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -204,6 +204,18 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VPE_SELR, IRS_VPE_DBR,
+ * IRS_VPE_CR0.
+ */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VPE_STATUSR,
+					GICV5_IRS_VPE_STATUSR_IDLE,
+					NULL);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -311,10 +323,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bo=
ol spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
+				  irq_hw_number_t db_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	lockdep_assert_held(&vgic_v5_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    GICV5_IRS_VMAP_VPER_M;
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       GICV5_IRS_VPE_SELR_S;
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D GICV5_IRS_VPE_CR0_DPS;
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
+	      GICV5_IRS_VPE_DBR_DBV;
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
@@ -325,6 +400,15 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 74152d22de070..8b6c497d3b590 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,7 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
