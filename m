Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013018.outbound.protection.outlook.com [52.101.83.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100EC3101D8;
	Mon,  8 Jun 2026 09:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780911096; cv=fail; b=WIwCs6Rp/pKW2lLL9YllpUr39KIYTqKECcxhEbOlCXYJIhkSx8nMShWGjej3aaKXQGk/SY581GLpuYWiniZGC1DIeq5fYoCVqBKMdec527ENbk32w8VIzgRoSALFMkQ19b8mdmBQ//Bxo5S79/FHv6qaSAHyQWB3X95Vh2rEmFY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780911096; c=relaxed/simple;
	bh=GQ+uA3drBrL0eGmBvIrnj+pwZVMXFqlsbDE70+aM3Q0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MEq74W5XEExomuBcaWpMC4zHLb/j+/PwoIv6oCZ2pbxzrvPuuBq6MkSFid7w+ivdGDCPCsoZEA49r/d5TvbBr0llwORJZcHqpntuXliHlcHrIqCYJapn9ytioHHH+5QWMFyQV5YDhseH1AJoXgY8r3gQ8lZKYmsnsDiNZ3tgHso=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HSRFhtxD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HSRFhtxD; arc=fail smtp.client-ip=52.101.83.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HSRFhtxD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HSRFhtxD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h/kdvQeYMbf3So016K6P2Ua5Z3e9k6U5AM3C7/LoHkKAWSs+dOP3Io+aVuS4TzQjc4cw6r2GrOWbIBlXaHK+iXpGWC2knopbtAF8KED7HBLQYF54vf/zKi3ylfpgnKS5DPzsKhKIFeq8upg8XPYJ4cZ2MSqG8cv1mQnDnbkNzPQFSb90z3I8fWc9H3zEGo+UPz7NPbbdwUZl6LZuveAWWIovtImpWR9F92EJvIsdZslZ73vKipTmJsQ5Bt+nVhkFJeg/fU4D8uB5j9RVl2oCJ7bSa5lze34PTRlPHaP6cO7H7O6k8WrXcaqzl8dnDCnWiSQYzb7fQCz2i2N6ZulCVg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7K3vPLjJv46/Ti5hXQARgwM7MGIigBsYwm7Pz6QGHg=;
 b=njvFWoD3UQy/XH4VolArxsMMSnryG2mjLsTEXivRIvRjRpHKKHqv87hxw4ofXbC9VXqCH1G3yDiK1DdmonRWBex5Kw33o837RLgjt6X6hrY8pvh4S/HaVBo22mQcuXOk+xL+uLTvWe+edFzstkI5PFbbOye5ta4wy1cnUSIp8haDmhSJbp3ceYKn2PyG3cJ4PXgjrDWSMtHBswz1Cvq+aGd/7PYA3BC8FQkmSHgpXPBsrZDklmptDDZttH8PbQnYJFXJxjrma810aXDSsnFBwKQNuutDf7hrHZiiQ2OlZFsjAkMWdjqw0MvJnM15NFRYrs3uhYf3hxrgkHwEQa99vg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7K3vPLjJv46/Ti5hXQARgwM7MGIigBsYwm7Pz6QGHg=;
 b=HSRFhtxDf/zXSech2Nz8esOJKZ7kMS7y5FIjN0odsOp2sbYOWk3Ro0pLdum6VbaVkNkBQaB9r7tchMOi0I1d/97ZlX85SOebwqBeHRD19J8ierItEt2oe2Bg+mlb3VvhS0OQMGIYQfSsbc3ptpaO+UZ4Q5C6H3lr/bnpSoMiYgQ=
Received: from CWLP265CA0477.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18a::6)
 by PAVPR08MB8893.eurprd08.prod.outlook.com (2603:10a6:102:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 09:31:22 +0000
Received: from AMS0EPF000001AB.eurprd05.prod.outlook.com
 (2603:10a6:400:18a:cafe::a8) by CWLP265CA0477.outlook.office365.com
 (2603:10a6:400:18a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.12 via Frontend Transport; Mon, 8
 Jun 2026 09:31:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AB.mail.protection.outlook.com (10.167.16.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.7
 via Frontend Transport; Mon, 8 Jun 2026 09:31:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xu/j4ORHRDJpjA1/QCmyBvpBgANjbs7UgACR/yNfkrGQunnloIsZz+l92YV46XPKurxZs8ZEMY8yp2yHpLVmOvVV0Bx9plap7p7J31JkpUiA7srHP4i/W21pTXX3AQfiV6cE1+MC23LV1suLfFvTtOdC7s5YQuJ4ogZl3urmX9FVi4PH/UCsag2/m8ObYhzPLfC5eygNFMesuPh/i4g0YryAob5ahYOe7HsJsaBSYZWSysyzQ7Xjb+3MJDF96qaEBLuvdipXCnay6TbkFWhEblcs+6MaRDqOcIMSufQfU2kudpnuBEyurXJzJv+fvNzVW7+BNRgOF7CWZo1ZY48fcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7K3vPLjJv46/Ti5hXQARgwM7MGIigBsYwm7Pz6QGHg=;
 b=uDjFJDg07SyWTqsPR5TZW3jpcRzAhjK3guHJDg7FPm9U5lU+PqtwF8r7oGpVIpEl9WlQ3v+OPRuEXawA+VT5OUFD5MVv8KSGkaN2GynL8YDzfVeVLG2bl335EYOn3E/WaupD+NFBF/zJMFcmIrPrwUSZS/Bdfaagvhl+kQyZuX6Foq2AWimu+v9hyMxBVTx/9YfrSbaxMdDgXFRrMXIG1m9noA1l7ye8Na7IRZVui+6h2xmDWunzwZksUTW/ZQ247FvSxpe5iVlBpJyMPEDdx/HkHRfaWWZeBoYhtxitAqMwpr9JoB6Jwwe31KNEitEoaTI+Q6rOy95eWKantTtDYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7K3vPLjJv46/Ti5hXQARgwM7MGIigBsYwm7Pz6QGHg=;
 b=HSRFhtxDf/zXSech2Nz8esOJKZ7kMS7y5FIjN0odsOp2sbYOWk3Ro0pLdum6VbaVkNkBQaB9r7tchMOi0I1d/97ZlX85SOebwqBeHRD19J8ierItEt2oe2Bg+mlb3VvhS0OQMGIYQfSsbc3ptpaO+UZ4Q5C6H3lr/bnpSoMiYgQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS8PR08MB9717.eurprd08.prod.outlook.com (2603:10a6:20b:617::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 09:30:15 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 09:30:14 +0000
Message-ID: <cecbd148-5d33-49c8-928f-572f71b3dd69@arm.com>
Date: Mon, 8 Jun 2026 10:30:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0620.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::16) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS8PR08MB9717:EE_|AMS0EPF000001AB:EE_|PAVPR08MB8893:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c20a80-d349-4da5-2c78-08dec540b43e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|6133799003|3023799007|56012099006|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 7yHQ2w7G7tLwyDatgCgpiUWyjJ1wRcuUoAJCe4T3h8qBElH+HQeBur+We04iY2kooYSxI2Sw+8BtgNQYqdndARbiQs8EGAFijzt2nxwGJCDLxPYVGnjmpK2aE0Gh0CJiWBBWfGFePabaw5IrFDvLSOSjkNqMqtb7+TZuMOaf4ZXGOuScmnwd9w0OKeI7TkKCB6kIw3zdlxmYQR7L314/hlPj2SwdfMVZT0T7MSzCMJAMKDDaStaRi1Js1YtJihvG/mBVohBuFNbknOrutTNnZQMGq75fhLrA/aqIirZBQHIQtSBGaaF/SorrC4Xsf3Gd5OrST7ia1eOkiF+wmAJAFpdWF0BeEX+9QQHi1X/2ENhwaeDoN8I2OJ1Yox6szj8/LSiJar9Xp7V4mEM1RGHi/aNawAfHUEPedATGkKPy/oG83NXfit3FFAGIxN9tyQ2n5/5NNC9S04IqviXxyZBueX1yB48KQLQg1LtivNL35Ugx4UJUM34o45+MMNiHamDNaWSPTTP12mgEIdaTX45KdXgxI5vkK/eGvumUL4cBO5FhLORoPd3KBM4K6ebNyelozaFNBHWX8w0spps0AwVuG3N0KsYopChAEQ7ufGUj/ESvk8ssw0c0iOOc5hbJfbM4oUJXaCQqeU2tAMV2UuG/YCIAutRW+R657drdDhz5BtjaVbmKBBZ+6mKK5Qml4NVl
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(6133799003)(3023799007)(56012099006)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LSHAcOKYf0fP/qIV4CYXxl4DZnE/rkZHQXkmLqpuQPx2eMKlEDDKMeActnku/PdCJ8U0B/MVujFzoy/D1e71YSgkBY5NXdnWRrQ4i1irEzSGP6KuL6qrDy3kmmtB5ms1QyzwBq07d6rW6zsnEcg4+UHhiQ9Nm1Uy+R6eX7QnFHLPp1qWyyL6gkU3P3kJTEXKSHxKUcCM8rn2+jT90NdMuWgWJpxbEYBPlinsOQZh1+6YSil9IPVO6AzrgNmFzdRpdZ4JpAc3ydFYeMiLWSL06NyD/s1JusBCy9Bt+kUoAOktftgkmQ7y08stUUI84FbxTxn4g+K5jqmUGgbMGVfPfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9717
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ba41ec3b-549d-47b9-36ee-08dec5408bb5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|7416014|376014|35042699022|36860700016|6133799003|22082099003|18002099003|3023799007|56012099006|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	3DgnZQG/0sl5ueaHQZVPxWy0DkuG69VSNZKOnDwPhjk5hT9QnUEN20OCnwKRWub3a90mDnBg/VdVChtgl7pSjz8bubUZJNkbU5w5fX/Emn8hDmwFgkt0F+e+LDdsu/8sTr95uRh2XXYG9tBOrAE0rFqyZEtEFA/v+Hn6eUZlbWct187R1rkyMk7x9kx6P3g5wha7pgoBX/A5UkQMbuIsZdgn2U3267VmNl3y3rdLe8o5DCPAiVIhdejxypCr4zk4N+Vr1Qxeia0IgyS3uyG3FxYymAnkhHVDAKKEPUWIlNSj4cF5inytP+YquLk9sarOqgr3pqnwRIa5gHerfkjTlBlN6lvxnAwfNE0zrBL7PA3oOl2iDECZl9uSguvSKauEgIJ5msTbuOVzT5FUkxKhc0SheNZQmByb5IcJKBSGXeQ7J9lZ2EoVBtlni/KBzyerBF1y/ZPwY8A1vQUTwmtJTQiFHLPj6Ze8+uIV2HXPxnia3QP/W9BNhbpXWgTtGh1cduD2hbnT1rC90mmxY5OtpEaS5LEx1Dd9s4zpt5bB1OxwyiGgZ6MYiuXWbZVWZoRNob/OC3VLG/we9asww1ftrL6xNsMZYlTfmR6RhDX6k9hgoq0LjlARm7krOMrk+XUPXVOpxdgP+KiKxlv+pWqQOvyUrJEi+iOD58nvI5TIIVkN91wsIKX3dJlOSGEEMJQsb+n/07moFybuEzqlTini2yYnIU2vP67L1D+TZD5lJdM=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(7416014)(376014)(35042699022)(36860700016)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RZUZzP0VW43xt0n4YMbNdwuVRP9/RqV2OzRfl6vjg9uQ2njlDuzFMC9hZ0YAn0fyPHKcFWfKS4hYO7s/e96dbd+NNKN1DM1kBjKDjB/McCy4Plza8MreDySRq58DHlQtDlFk+V1pb4Mmyb2S8gfUfVjyhAguQJfr1vw4YGJZ3deyirZH708Ds0cAL+7NwPn0xXSnq0SYpq+5H5KYnjXYuRgleRtYrtLi7yHwgAdowFPd7oDT8J/V4K76mkHLjA5yn/Ri5CwRGmwRKAxv/DUT9KlFnGG18Lf5pRgHX3H9z/xmM/CXkxIfBvgfkEFPyE++iMyg+i74QTqe+jc0cMZ8rCCTkzK012/L/em20GmvIjC1KEnnLKE3PItkkx/H8ukN5mbMzYLWmGUWsF7MIkgrZX6Dauw4OxnJDjtGHNRwrh9WhYhh+hD21poCIPcls6rW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 09:31:22.4751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c20a80-d349-4da5-2c78-08dec540b43e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8893

On 05/06/2026 07:23, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Numerous changes due to rebasing.
>>   * Fix addr_range_desc() to encode the correct block size.
>> Changes since v12:
>>   * Switch to RMM v2.0 range based APIs.
>> Changes since v11:
>>   * Adapt to upstream changes.
>> Changes since v10:
>>   * RME->RMI renaming.
>>   * Adapt to upstream gmem changes.
>> Changes since v9:
>>   * Fix call to kvm_stage2_unmap_range() in kvm_free_stage2_pgd() to set
>>     may_block to avoid stall warnings.
>>   * Minor coding style fixes.
>> Changes since v8:
>>   * Propagate the may_block flag.
>>   * Minor comments and coding style changes.
>> Changes since v7:
>>   * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>>     internally WARN when necessary.
>> Changes since v6:
>>   * Handle PAGE_SIZE being larger than RMM granule size.
>>   * Some minor renaming following review comments.
>> Changes since v5:
>>   * Reduce use of struct page in preparation for supporting the RMM
>>     having a different page size to the host.
>>   * Handle a race when delegating a page where another CPU has faulted on
>>     a the same page (and already delegated the physical page) but not yet
>>     mapped it. In this case simply return to the guest to either use the
>>     mapping from the other CPU (or refault if the race is lost).
>>   * The changes to populate_par_region() are moved into the previous
>>     patch where they belong.
>> Changes since v4:
>>   * Code cleanup following review feedback.
>>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>>     This is now set by the RMM and the host has no control of it and the
>>     spec requires the bit to be set to zero.
>> Changes since v2:
>>   * Avoid leaking memory if failing to map it in the realm.
>>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>   * Adapt to changes in previous patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |   8 ++
>>   arch/arm64/include/asm/kvm_rmi.h     |  12 ++
>>   arch/arm64/kvm/mmu.c                 | 128 ++++++++++++++++----
>>   arch/arm64/kvm/rmi.c                 | 173 +++++++++++++++++++++++++++
>>   4 files changed, 301 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/ 
>> include/asm/kvm_emulate.h
>> index 2e69fe494716..8b6f9d26b5d8 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -712,6 +712,14 @@ static inline bool kvm_realm_is_created(struct 
>> kvm *kvm)
>>       return kvm_is_realm(kvm) && kvm_realm_state(kvm) != 
>> REALM_STATE_NONE;
>>   }
>> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
>> +{
>> +    if (!kvm_is_realm(kvm))
>> +        return ipa;
>> +
>> +    return ipa & ~BIT(kvm->arch.realm.ia_bits - 1);
>> +}
>> +
>>   static inline bool vcpu_is_rec(const struct kvm_vcpu *vcpu)
>>   {
>>       return kvm_is_realm(vcpu->kvm);
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/ 
>> asm/kvm_rmi.h
>> index a2b6bc412a22..b65cfec10dee 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -6,6 +6,7 @@
>>   #ifndef __ASM_KVM_RMI_H
>>   #define __ASM_KVM_RMI_H
>> +#include <asm/kvm_pgtable.h>
>>   #include <asm/rmi_smc.h>
>>   /**
>> @@ -97,6 +98,17 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>                  unsigned long size,
>>                  bool unmap_private,
>>                  bool may_block);
>> +int realm_map_protected(struct kvm *kvm,
>> +            unsigned long base_ipa,
>> +            kvm_pfn_t pfn,
>> +            unsigned long size,
>> +            struct kvm_mmu_memory_cache *memcache);
>> +int realm_map_non_secure(struct realm *realm,
>> +             unsigned long ipa,
>> +             kvm_pfn_t pfn,
>> +             unsigned long size,
>> +             enum kvm_pgtable_prot prot,
>> +             struct kvm_mmu_memory_cache *memcache);
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index ac2a0f0106b0..776ffe56d17e 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -334,8 +334,15 @@ static void __unmap_stage2_range(struct 
>> kvm_s2_mmu *mmu, phys_addr_t start, u64
>>       lockdep_assert_held_write(&kvm->mmu_lock);
>>       WARN_ON(size & ~PAGE_MASK);
>> -    WARN_ON(stage2_apply_range(mmu, start, end, 
>> KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> -                   may_block));
>> +
>> +    if (kvm_is_realm(kvm)) {
>> +        kvm_realm_unmap_range(kvm, start, size, !only_shared,
>> +                      may_block);
>> +    } else {
>> +        WARN_ON(stage2_apply_range(mmu, start, end,
>> +                       KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> +                       may_block));
>> +    }
>>   }
>>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>> @@ -358,7 +365,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>       phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>       phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>> -    kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>> +    if (kvm_is_realm(kvm))
>> +        kvm_realm_unmap_range(kvm, addr, end - addr, false, true);
>> +    else
>> +        kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>   }
>>   /**
>> @@ -1103,6 +1113,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>       struct kvm_memory_slot *memslot;
>>       int idx, bkt;
>> +    /* For realms this is handled by the RMM so nothing to do here */
>> +    if (kvm_is_realm(kvm))
>> +        return;
>> +
>>       idx = srcu_read_lock(&kvm->srcu);
>>       mmap_read_lock(current->mm);
>>       write_lock(&kvm->mmu_lock);
>> @@ -1528,6 +1542,29 @@ static bool kvm_vma_mte_allowed(struct 
>> vm_area_struct *vma)
>>       return vma->vm_flags & VM_MTE_ALLOWED;
>>   }
>> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>> +             kvm_pfn_t pfn, unsigned long map_size,
>> +             enum kvm_pgtable_prot prot,
>> +             struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    /*
>> +     * Write permission is required for now even though it's possible to
>> +     * map unprotected pages (granules) as read-only. It's impossible to
>> +     * map protected pages (granules) as read-only.
>> +     */
>> +    if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>> +        return -EFAULT;
>> +
> 
> I'm a bit concerned with this. We don't have KVM_PGTABLE_PROT_W set in 
> @prot
> if the stage2 fault is raised due to memory read. With -EFAULT returned 
> to VMM
> (e.g. QEMU), the vCPU continuous execution is stopped and system won't be
> working any more.
> 
>> +    ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
>> +    if (!kvm_realm_is_private_address(realm, ipa))
>> +        return realm_map_non_secure(realm, ipa, pfn, map_size, prot,
>> +                        memcache);
>> +
>> +    return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
>> +}
>> +
>>   static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
>>   {
>>       switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma- 
>> >vm_page_prot))) {
>> @@ -1604,27 +1641,52 @@ static int gmem_abort(const struct 
>> kvm_s2_fault_desc *s2fd)
>>       bool write_fault, exec_fault;
>>       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>>       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>> -    struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>> +    struct kvm_vcpu *vcpu = s2fd->vcpu;
>> +    struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
>> +    gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
>>       unsigned long mmu_seq;
>>       struct page *page;
>> -    struct kvm *kvm = s2fd->vcpu->kvm;
>> +    struct kvm *kvm = vcpu->kvm;
>>       void *memcache;
>>       kvm_pfn_t pfn;
>>       gfn_t gfn;
>>       int ret;
>> -    memcache = get_mmu_memcache(s2fd->vcpu);
>> -    ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>> +    if (kvm_is_realm(vcpu->kvm)) {
>> +        /* check for memory attribute mismatch */
>> +        bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
>> +        /*
>> +         * For Realms, the shared address is an alias of the private
>> +         * PA with the top bit set. Thus if the fault address matches
>> +         * the GPA then it is the private alias.
>> +         */
>> +        bool is_priv_fault = (gpa == s2fd->fault_ipa);
>> +
>> +        if (is_priv_gfn != is_priv_fault) {
>> +            kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>> +                              kvm_is_write_fault(vcpu),
>> +                              false,
>> +                              is_priv_fault);
>> +            /*
>> +             * KVM_EXIT_MEMORY_FAULT requires an return code of
>> +             * -EFAULT, see the API documentation
>> +             */
>> +            return -EFAULT;
>> +        }
>> +    }
>> +
>> +    memcache = get_mmu_memcache(vcpu);
>> +    ret = topup_mmu_memcache(vcpu, memcache);
>>       if (ret)
>>           return ret;
>>       if (s2fd->nested)
>>           gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
>>       else
>> -        gfn = s2fd->fault_ipa >> PAGE_SHIFT;
>> +        gfn = gpa >> PAGE_SHIFT;
>> -    write_fault = kvm_is_write_fault(s2fd->vcpu);
>> -    exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
>> +    write_fault = kvm_is_write_fault(vcpu);
>> +    exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>       VM_WARN_ON_ONCE(write_fault && exec_fault);
>> @@ -1634,7 +1696,7 @@ static int gmem_abort(const struct 
>> kvm_s2_fault_desc *s2fd)
>>       ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
>>       if (ret) {
>> -        kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, 
>> PAGE_SIZE,
>> +        kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>>                             write_fault, exec_fault, false);
>>           return ret;
>>       }
>> @@ -1654,14 +1716,20 @@ static int gmem_abort(const struct 
>> kvm_s2_fault_desc *s2fd)
>>       kvm_fault_lock(kvm);
>>       if (mmu_invalidate_retry(kvm, mmu_seq)) {
>>           ret = -EAGAIN;
>> -        goto out_unlock;
>> +        goto out_release_page;
>> +    }
>> +
>> +    if (kvm_is_realm(kvm)) {
>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
>> +                    PAGE_SIZE, KVM_PGTABLE_PROT_R | 
>> KVM_PGTABLE_PROT_W, memcache);
>> +        goto out_release_page;
>>       }
>>       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, 
>> PAGE_SIZE,
>>                            __pfn_to_phys(pfn), prot,
>>                            memcache, flags);
>> -out_unlock:
>> +out_release_page:
>>       kvm_release_faultin_page(kvm, page, !!ret, prot & 
>> KVM_PGTABLE_PROT_W);
>>       kvm_fault_unlock(kvm);
>> @@ -1847,7 +1915,7 @@ static int kvm_s2_fault_get_vma_info(const 
>> struct kvm_s2_fault_desc *s2fd,
>>        * mapping size to ensure we find the right PFN and lay down the
>>        * mapping in the right place.
>>        */
>> -    s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> 
>> PAGE_SHIFT;
>> +    s2vi->gfn = kvm_gpa_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa, 
>> s2vi->vma_pagesize)) >> PAGE_SHIFT;
>>       s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>> @@ -2056,6 +2124,9 @@ static int kvm_s2_fault_map(const struct 
>> kvm_s2_fault_desc *s2fd,
>>           prot &= ~KVM_NV_GUEST_MAP_SZ;
>>           ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, 
>> gfn_to_gpa(gfn),
>>                                    prot, flags);
>> +    } else if (kvm_is_realm(kvm)) {
>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>> +                    prot, memcache);
>>       } else {
>>           ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, 
>> gfn_to_gpa(gfn), mapping_size,
>>                                __pfn_to_phys(pfn), prot,
> 
> For the case kvm_is_realm(), need we adjust 's2fd->fault_ipa' for the 
> sake of
> huge pages. In kvm_s2_fault_map(), @gfn and @pfn may have been adjusted by
> transparent_hugepage_adjust() to be aligned with huge page size. If the
> adjustment happened in transparent_hugepage_adjust(), we need to align
> s2fd->fault_ipa down to the huge page size either.
> 
> 
>> @@ -2214,6 +2285,13 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>> +static bool shared_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
>> +{
>> +    gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
>> +
>> +    return (gpa != fault_ipa);
>> +}
>> +
>>   /**
>>    * kvm_handle_guest_abort - handles all 2nd stage aborts
>>    * @vcpu:    the VCPU pointer
>> @@ -2324,8 +2402,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>           nested = &nested_trans;
>>       }
>> -    gfn = ipa >> PAGE_SHIFT;
>> +    gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>>       memslot = gfn_to_memslot(vcpu->kvm, gfn);
>> +
>>       hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>       write_fault = kvm_is_write_fault(vcpu);
>>       if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>> @@ -2368,7 +2447,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>            * of the page size.
>>            */
>>           ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
>> -        ret = io_mem_abort(vcpu, ipa);
>> +        ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>>           goto out_unlock;
>>       }
>> @@ -2396,7 +2475,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>                   !write_fault &&
>>                   !kvm_vcpu_trap_is_exec_fault(vcpu));
>> -        if (kvm_slot_has_gmem(memslot))
>> +        if (kvm_slot_has_gmem(memslot) && !shared_ipa_fault(vcpu- 
>> >kvm, fault_ipa))
>>               ret = gmem_abort(&s2fd);
>>           else
>>               ret = user_mem_abort(&s2fd);
>> @@ -2433,6 +2512,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct 
>> kvm_gfn_range *range)
>>       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>>           return false;
>> +    /* We don't support aging for Realms */
>> +    if (kvm_is_realm(kvm))
>> +        return true;
>> +
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm- 
>> >arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, true);
>> @@ -2449,6 +2532,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct 
>> kvm_gfn_range *range)
>>       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
>>           return false;
>> +    /* We don't support aging for Realms */
>> +    if (kvm_is_realm(kvm))
>> +        return true;
>> +
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm- 
>> >arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, false);
>> @@ -2628,10 +2715,11 @@ int kvm_arch_prepare_memory_region(struct kvm 
>> *kvm,
>>           return -EFAULT;
>>       /*
>> -     * Only support guest_memfd backed memslots with mappable memory, 
>> since
>> -     * there aren't any CoCo VMs that support only private memory on 
>> arm64.
>> +     * Only support guest_memfd backed memslots with mappable memory,
>> +     * unless the guest is a CCA realm guest.
>>        */
>> -    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>> +    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new) &&
>> +        !kvm_is_realm(kvm))
>>           return -EINVAL;
>>       hva = new->userspace_addr;
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index cae29fd3353c..761b38a4071c 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -597,6 +597,179 @@ static int realm_data_map_init(struct kvm *kvm, 
>> unsigned long ipa,
>>       return ret;
>>   }
>> +static unsigned long addr_range_desc(unsigned long phys, unsigned 
>> long size)
>> +{
>> +    unsigned long out = 0;
>> +
>> +    switch (size) {
>> +    case P4D_SIZE:
>> +        out = 3 | (1 << 2);
>> +        break;
>> +    case PUD_SIZE:
>> +        out = 2 | (1 << 2);
>> +        break;
>> +    case PMD_SIZE:
>> +        out = 1 | (1 << 2);
>> +        break;
>> +    case PAGE_SIZE:
>> +        out = 0 | (1 << 2);
>> +        break;
>> +    default:
>> +        /*
>> +         * Only support mapping at the page level granulatity when
>> +         * it's an unusual length. This should get us back onto a larger
>> +         * block size for the subsequent mappings.
>> +         */
>> +        out = 0 | ((MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1)) << 2);
>> +        break;
>> +    }
>> +
>> +    WARN_ON(phys & ~PAGE_MASK);
>> +
>> +    out |= phys & PAGE_MASK;
>> +
>> +    return out;
>> +}
>> +
>> +int realm_map_protected(struct kvm *kvm,
>> +            unsigned long ipa,
>> +            kvm_pfn_t pfn,
>> +            unsigned long map_size,
>> +            struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    phys_addr_t base_phys = phys;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    unsigned long base_ipa = ipa;
>> +    unsigned long ipa_top = ipa + map_size;
>> +    int ret = 0;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
>> +            !IS_ALIGNED(ipa, map_size)))
>> +        return -EINVAL;
>> +
>> +    if (rmi_delegate_range(phys, map_size)) {
>> +        /*
>> +         * It's likely we raced with another VCPU on the same
>> +         * fault. Assume the other VCPU has handled the fault
>> +         * and return to the guest.
>> +         */
>> +        return 0;
>> +    }
>> +
>> +    while (ipa < ipa_top) {
>> +        unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>> +        unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
>> +        unsigned long out_top;
>> +
>> +        ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
>> +                       &out_top);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RETURN_INDEX(ret);
>> +
>> +            WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              KVM_PGTABLE_LAST_LEVEL,
>> +                              memcache);

Could we give the RMM a chance to make use of the Block mappings by 
creating the Missing RTTs to the level that may work for the current
range_desc ? i.e., if the range_desc is a 2M block size, we could create
tables upto L2 in the first go and if the RMM still needs RTT, we could
go further down to the KVM_PGTABLE_LAST_LEVEL. I understand this is
kind of an optimisation, so may be we could defer it. (Same applies for
the non_secure map below).


>> +            if (ret)
>> +                goto err_undelegate;
>> +
>> +            ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags,
>> +                           range_desc, &out_top);
>> +        }
>> +
>> +        if (WARN_ON(ret))
>> +            goto err_undelegate;
>> +
>> +        phys += out_top - ipa;
>> +        ipa = out_top;
>> +    }
>> +
>> +    return 0;
>> +
>> +err_undelegate:
>> +    realm_unmap_private_range(kvm, base_ipa, ipa, true);
>> +    if (WARN_ON(rmi_undelegate_range(base_phys, map_size))) {
>> +        /* Page can't be returned to NS world so is lost */
>> +        get_page(phys_to_page(base_phys));
>> +    }
>> +    return -ENXIO;
>> +}
>> +
>> +int realm_map_non_secure(struct realm *realm,
>> +             unsigned long ipa,
>> +             kvm_pfn_t pfn,
>> +             unsigned long size,
>> +             enum kvm_pgtable_prot prot,
>> +             struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    unsigned long attr, flags = 0;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    unsigned long ipa_top = ipa + size;
>> +    int ret;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(size, PAGE_SIZE) ||
>> +            !IS_ALIGNED(ipa, size)))
>> +        return -EINVAL;
>> +
>> +    switch (prot & (KVM_PGTABLE_PROT_DEVICE | 
>> KVM_PGTABLE_PROT_NORMAL_NC)) {
>> +    case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
>> +        return -EINVAL;
>> +    case KVM_PGTABLE_PROT_DEVICE:
>> +        attr = MT_S2_FWB_DEVICE_nGnRE;
>> +        break;
>> +    case KVM_PGTABLE_PROT_NORMAL_NC:
>> +        attr = MT_S2_FWB_NORMAL_NC;
>> +        break;
>> +    default:
>> +        attr = MT_S2_FWB_NORMAL;
>> +    }
>> +
>> +    flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR, attr);
>> +
>> +    if (prot & KVM_PGTABLE_PROT_R)
>> +        flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, 
>> RMI_S2AP_DIRECT_READ);
>> +    if (prot & KVM_PGTABLE_PROT_W)
>> +        flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, 
>> RMI_S2AP_DIRECT_WRITE);
>> +
>> +    flags |= RMI_ADDR_TYPE_SINGLE;
>> +
>> +    while (ipa < ipa_top) {
>> +        unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
>> +        unsigned long out_top;
>> +
>> +        ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags, range_desc,
>> +                     &out_top);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RETURN_INDEX(ret);
>> +
>> +            WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              KVM_PGTABLE_LAST_LEVEL,

^^ Same as above.

Suzuki


>> +                              memcache);
>> +            if (ret)
>> +                return ret;
>> +
>> +            ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
>> +                         range_desc, &out_top);
>> +        }
>> +
>> +        if (WARN_ON(ret))
>> +            return ret;
>> +
>> +        phys += out_top - ipa;
>> +        ipa = out_top;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t 
>> pfn,
>>                     struct page *src_page, void *opaque)
>>   {
> 
> Thanks,
> Gavin
> 

