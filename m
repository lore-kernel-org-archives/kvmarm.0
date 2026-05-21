Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012045.outbound.protection.outlook.com [52.101.66.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F2277CA5
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375727; cv=fail; b=F9Eh8t5ubzQqJ4d4kH0XDXbQ8CPN/qDY84AWj98c4zpJMbVB1XAxXkNxnohP4fMZ7e2pDNTqf6dzHhnTOo5x4vURPgfojBFF/wr+J3uW0LcfCaOZOhbQ3CIIzkmRo6y6+NYUBcZXslQ2KKCFvzKbNJnLrIIB5owacWaDzbs1edU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375727; c=relaxed/simple;
	bh=iMScTY9788d7RZjPClbJg+lM17G+Xdpp6sC1bSvMe/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PCWgfEtnn0+x70PdyHoBkVte9zmgvci2/dnX1Efb0SKhT6R53x1mDMwyC/M9STQMYwbHroo76RyNQMznvDR54Wov4O9px98YAjl6sp+3m2hbr3b+L3zHUPSQDSxp/MOzRRCpjAD8UWtZC5G7Oq8MG8CENhEsOjRZ047ftz9reRk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nDWYTlM2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nDWYTlM2; arc=fail smtp.client-ip=52.101.66.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nDWYTlM2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nDWYTlM2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=Ko15nPQVGie5B3QQm5TyLf3idgDgUz8Cl7+MsvXRprnCZjjYESGwcVwl1HyMAOA0fGOcOD8Z2z6pNHvtAkT3eKRgFAhJO4HNMmqBH8MyjpDn0Q6HZlGRkyl//XyAbs2ZISmcKC5sfccos/53ABpY7qfmROK9TGTTpfsJNrSTj7nOwDqHfgkjLm5SDIlnIRMBVCY9e9As6IaYNyhFm5NM33UvtR1qmQgNa52H7M6STcaWXkTCVKpEQtUV+3Fg7MzPEJYTT2LrVAjrS9tvZ3HwIIkJHMoKMbqstkyBOde4s49tfe6mnBf+o6HEINntSbjpP9vvciipzZLaQkouQeKMJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2K1fhGrhwhNn8kI6Q39xA5u/HIXfg+euH4WKrGgM48=;
 b=bFdhv0O31f+Zsi0QMG33QJZriVypFXQC6eO/kvy1fnXUMrD3rLaGRiUItrxKIN8sGDoaAv7vkZ+1tIo6J1hmiEBIEMqRfdgrNnqF3rB2TmiYwjO7oiLly7NX4jZBSUpKTOnHFtM95sKfe/4Af5QcUphwJp5zwKvvQE0v5T5F+0sxEgchcEvdo+gVX+J9qQazkfngYSBgdh1Nb/8zmP749h2AnqgyBj5+6qNUUNtuL4E/3Aj6hkgyh5IPGEpWQPMrDK4qh1LnVxNP27aWeeNbY6xmtDPFL1KsK3GlQgk38RYGOAuXsorNUvdRjaA5A+wg77fhy70/WCZero4ECuR4eA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2K1fhGrhwhNn8kI6Q39xA5u/HIXfg+euH4WKrGgM48=;
 b=nDWYTlM2Hri5DuSZ0nhPDFc2i6/oAtVEKinr8zjc2hkxf9BMhMrV2RkK0ae6Fh7T7SW0F5Wbj+q7NmgyuSVXQvsACPTEk+xXj8OKvAUwBFk0TMrNWl4T+5eXOo7bb0in3e563FyB+IMglXD7wePGFerOSfNt6bvqogMsLGHy+wg=
Received: from DU2P250CA0029.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::34)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:01:54 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:231:cafe::9a) by DU2P250CA0029.outlook.office365.com
 (2603:10a6:10:231::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:01:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5yLtAkxoKUQBelmIwFs38fYwX9XypS9pVQ+1NfKmZ2bkUVtZTqnoX15q7sy8Mvk/SCEwSuo404baoMzqGsorcLYEB/Y6Qq/zCl80PAZonhP/U9dYA5wTgotVjGHCI9G5t5WHNg2LRSzu83kmhJkjjwGL9DRfQO4nzAtGpGEg7WrQYinVL9sLkAMJUs0EX2DC3bPH4GEFF7gI/Q3smrdS45NypfOFgwuUC1Fz/YTH/ySS3vlDfsuzw9YE1u+Er3ZMuAzOo7KIghQ4milfHtqBbDq9soLAV16lFkZO+9WwPgyCtJZLqRibebepHqDBHjmLhYrJTznVtGo7FHlhAZCBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2K1fhGrhwhNn8kI6Q39xA5u/HIXfg+euH4WKrGgM48=;
 b=ZJlp+98GP9Go3pNlK3e+vbtd+L57jEFlbRiGkWEUy0byMG13Gx74pRp5wd/Y3Hj9kD09+etk+Egk+c36M9lSDrZVsx6d1ehczvHa2EUq28WUxQL904kXO8i8tIG1LOuK2/o1eh5UUJ9aN0TJ5tSMKS82PF3D6y9PduUFnN3BCZu5vB4a/Iyr56tlMkxdiu28tLK7ZwUKJb2ctGrzfypRkIg2kQ4Gf7dx/leFhLctiOJyyejoeHsglJTWJ70MIqKKHXGBsgkemu7had6WIjRhb+wnsoLpLQpgOJA2Qh2DVC83VDzfT0QtBeQ8ghZveGWm1s60jkXXq1z8vJHEa3FK2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2K1fhGrhwhNn8kI6Q39xA5u/HIXfg+euH4WKrGgM48=;
 b=nDWYTlM2Hri5DuSZ0nhPDFc2i6/oAtVEKinr8zjc2hkxf9BMhMrV2RkK0ae6Fh7T7SW0F5Wbj+q7NmgyuSVXQvsACPTEk+xXj8OKvAUwBFk0TMrNWl4T+5eXOo7bb0in3e563FyB+IMglXD7wePGFerOSfNt6bvqogMsLGHy+wg=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:00:51 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:00:51 +0000
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
Subject: [PATCH v2 34/39] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH v2 34/39] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHc6TKdd1EaTmFbzkmmh+inpWpvQA==
Date: Thu, 21 May 2026 15:00:51 +0000
Message-ID: <20260521144846.1899475-35-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|DB5PEPF00014B98:EE_|PAWPR08MB11014:EE_
X-MS-Office365-Filtering-Correlation-Id: 948e4665-3f7a-4124-c93b-08deb749e58f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|3023799007|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 D8Yk9jwY1jqPGopQ3YNLKgafsArDiUB3nRlU8cFeRkstlqsMmmLfIj5KzSV2TPEUNBJfxkw0vG64ochd0ag1ow3dI1M5P6IkW3eS+AMPIRDrcrtTqr6vuhPvCFLP87sp+m6A3QIglsAXGNeoyB/70osgbzMMW3tVwqALkUZumUxAHpDvVqysIVVlTZuQRKniJUr3mNtTnw9blegHA8bvBhYfwCfM12WYmpLwfhz2VzcAl6EZ3S4pL8ZtoD1RwFeY2eu8Hx7SDv8WaavsMUIa8v4GJ9V9SSPE9wAgnb63XasAIxbGpPEFuCy6fEA+VyNdekRr+b89HQuPrHjbxai6W5eYU41umCX+uIMAfgMbif9hs3GUVzOXtBVEx2MPves0BkcCtaeeJt82l2y7D94fKnuNcwqUwX1oeT+pXXmiuZdfxdMJNwlJxk3idTO8SeEKrPh1lu8Ah3dKHr3OFPEyBRYh8UAskzPxNKHQ8pNp36zW0cfLZuyG2+8Mn19w+AiLyTsenzA9Ipjmw+VYGbcayoqQDDxhC7qh9EAVe3KJbkhUCR+AefwzltdDNb5Yqs6JzPLY40rZkK3iz2+S/y0oPAUjvH+oqbCDyvkUrMLcQGBamfd2A/JpjMQLe5E+8vsJle1/Mksd56s2DwDaIjxrWsUBSuJDRvfawYa2gil2aj8oN9mJzP/qmtXbMmh9kMq01nb1TC/PIwyQoBk8vNmkuWBddFGfd1fKdfQwe0GwFdEEZfeIbdyuBQciF5EjjohO
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(3023799007)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Vie04z4AXuGf9BI/zIWbs2WTOXQQRBahLDdOf7bSFbwnEIB44R9EplTiFsVhK79Rne5zYN5GltcGbt2rb2HYKH1lb4+tupRltZyuUWEI+81YSJvKg69MxESWcrZnQjNRPFm9OAboHdWclTjxiGD6+xq1sAoeKThcVmMoH1nCcsC/Ujs9VZwaZMoQzptashVO7ibB02HOCjCr6VdalVUUZj1YLRIVKjUghUMinckDpVFMmVf2SNm/1KsFEc8VD+cAceLZw1T8Gn5Pm3+QrqphW8/M3tsLEr8nCuBgLTW7ZxqwM+RgTfgNH+RwrStLFjqx+cHZ254BxtKccwgeDd+UNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3c740d2-2812-49b2-7f98-08deb749bfd7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|36860700016|35042699022|376014|82310400026|14060799003|1800799024|3023799007|11063799006|5023799004|6133799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2R1b/E/WlBMuEChZbVt8vJ0Y/t5htRQmSS8Mx3INpTrhRapd3iRhzJ8hDbzvxxq7IyKJsBUlW5M06je0g4hJVvFNwdJRSM+wn3k/82VeVMWAaq/8RDpKUPLVDiVpRsrL9ye5MQ1IHfkXsG1QP8MKZRZuxGEq4edCWZQoRg6kOt1o+J7gtAi1azVYOSCVTl+ggmg3txFz7jsTzvFiSp3i5FCxPqtMvthZsx0Hhn5Zo2K7KlxznbQffJFnTIgjqinkqXznNQgRZdgcp8H0PfC4fXDgjXqm7QysAr55OM0LqnEs3ixqyBEMbMFguk2RhcygZcUgPtk14cFxxJmMzhoKxA5pbl8MlFvk43Z9dOhwZqTJeQzrnduTodxi2XBhIBnNl7fMIyNscHzGGuobLIJo77eJoOLEbw0LDKqV5llVMb73yBVbpLrbd14cZtDuSyY6VQyQl5kXyDz3dkIBCfHYIAo5n+wUJsMGmCMoaf36P0uEzTDHBlkWUw78S41PiTdsWV0MTkpFp8SpJSnnx8C2FVcf5bowE735uAXRYuDLsvRyhXe9S19onLR0jKWvvYbP3aaxnp0Rbx7+GulNr4cRA16SiIC7e44BCqAD2gcZzw+yEwY0XcN6bqhQegHnEQB11Uvv8t2fIwg6zsePgd0jyjWz8Ol3PtO0sImLG5x94OdjPbIl5k1/Kzer32+Tx2ITGHAm9YNzM8h55qON9r2U8k2zNM7c3ex8uVKBQ3IhppY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(36860700016)(35042699022)(376014)(82310400026)(14060799003)(1800799024)(3023799007)(11063799006)(5023799004)(6133799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RFNOeX/LFb0VjPfnJsNT+R2Ek9Ly65jy4+T5GvpZ2AgIMXsujcfI5iSnhRDc1UGTtrU5blr0HRatUz4vXNKlr+9spLKoL6liB6KvdMarZxK+PoMCZugvH+mzbeTiPYNMQfpBXu15oaHM0/opaCmkkESk6IyeS7Fp/qpYcmA8p6Ln2XvDIoHGtmAAS8cGdPl1ki2Nn3X54OFH31XCFTYQiw+KlFnvhm2vNjh36w4R3xjp5aJNBIILz2R6lIkPinnBUQE0AA3OIVpUGjGBJ86PdvinIa6bGfC/PlEEmZkCTQNHR1YkbW5fvtryKYicaV97nn9kcWxU30Z6FQX1uq2V8yOUtjH1EEQaeYu2Dd7rQVQWxvNttBbhV1/o/6HHzh0OBsSV7kWRIqxAAy/jzVA1V/deJ3LDuBAdMH/ctsXxQlT0Cw/tf5BamU/OYENdqXha
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:01:54.4014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 948e4665-3f7a-4124-c93b-08deb749e58f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014

As part of saving and restoring state of a GICv5-based system,
userspace is required to save/restore the IRS MMIO registers. These
include important information such as guest IST configuration, and in
general KVM needs to present consistent state to the guest.

Provide accessors to read and write the IRS MMIO state. This is
modelled on what is already done for the GICv3 ITS as the idea is
broadly the same.

Where possible, the existing access mechanisms are used, but for some
registers the access is handled a bit differently as they have wider
effects. For example, some writes need to be sanitised to make sure
that the hardware is capable (IST capabilities presented to the guest,
for example). Similar things apply to the SPI config where we block
userspace from setting anything that doesn't match what has been set
already.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       | 415 ++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  55 +++-
 arch/arm64/kvm/vgic/vgic.h              |   4 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 5 files changed, 396 insertions(+), 80 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 6352d17d557e0..b7808555adc82 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -393,12 +393,61 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static void vgic_v5_update_irs_ist_baser(struct vgic_v5_irs *irs,
+					 unsigned long val)
+{
+	irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+}
+
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	int rc;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+		if (rc)
+			return rc;
+
+		/*
+		 * ... free the host IST if we successfully marked the
+		 * IST as invalid. Frankly, if we failed to make the
+		 * guest's IST as invalid, we're cooked because it means
+		 * that the IRS may still be using the memory that we
+		 * want to free. Hence, we leave it allocated and skip
+		 * the clearing of valid bit in the baser.
+		 */
+		rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
+		if (rc)
+			return rc;
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs)) {
+			kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+			return -EINVAL;
+		}
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	vgic_v5_update_irs_ist_baser(irs, val);
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -408,72 +457,192 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
 		return;
 	case GICV5_IRS_IST_BASER: {
-		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-
 		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		vgic_v5_write_irs_ist_baser(vcpu, val);
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
-				break;
+static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
+							  gpa_t addr,
+							  unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			if (vgic_v5_lpi_ist_free(vcpu->kvm))
-				break;
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs)) {
-				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
-				break;
-			}
-
-			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_SYNC_STATUSR:
+		return GICV5_IRS_SYNC_STATUSR_IDLE;
+	case GICV5_IRS_SPI_STATUSR:
+		return GICV5_IRS_SPI_STATUSR_IDLE;
+	case GICV5_IRS_PE_STATUSR:
+		return GICV5_IRS_PE_STATUSR_IDLE;
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	default:
+		return 0;
+	}
+}
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-		return;
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val) !=3D
+		    GICV5_IRS_IDR0_INT_DOM_NON_SECURE)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR0_VIRT) ||
+		    (val & GICV5_IRS_IDR0_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_VIRT_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_SETLPI) ||
+		    (val & GICV5_IRS_IDR0_MEC) ||
+		    (val & GICV5_IRS_IDR0_MPAM) ||
+		    (val & GICV5_IRS_IDR0_SWE))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D !!(val & GICV5_IRS_IDR0_VIRT);
+		irs_data->idr0.setlpi =3D !!(val & GICV5_IRS_IDR0_SETLPI);
+		irs_data->idr0.mec =3D !!(val & GICV5_IRS_IDR0_MEC);
+		irs_data->idr0.mpam =3D !!(val & GICV5_IRS_IDR0_MPAM);
+		irs_data->idr0.swe =3D !!(val & GICV5_IRS_IDR0_SWE);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1: {
+		unsigned int iaffid_bits, priority_bits;
+
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
+		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
+
+		/*
+		 * IAFFID_BITS is derived from the number of vPE ID bits in
+		 * the VMTE, and is encoded as N - 1.
+		 */
+		if (iaffid_bits !=3D vgic_v5_vmte_vpe_id_bits(vcpu) - 1)
+			return -EINVAL;
+
+		if (priority_bits > gicv5_global_data.irs_pri_bits - 1)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D priority_bits;
+		break;
 	}
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!(val & GICV5_IRS_IDR2_LPI))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (val & GICV5_IRS_IDR2_IST_LEVELS)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR2_ISTMD) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) > irs_caps.ist_id_bits)
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    irs_caps.min_lpi_id_bits)
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D !!(val & GICV5_IRS_IDR2_ISTMD);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D !!(val & GICV5_IRS_IDR2_IST_LEVELS);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		vgic_v5_update_irs_ist_baser(irs_data, val);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		break;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
@@ -483,9 +652,12 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SYNC_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
@@ -493,35 +665,48 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
-				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_STATUSR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR,
+				  vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_PE_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 8,
-				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 8,
+					  VGIC_ACCESS_64bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
 				  vgic_v5_mmio_write_irs_ist, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
-				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_STATUSR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
=20
@@ -759,3 +944,93 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 075e4c1326754..cab3d6db070ac 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
 		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
 		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -818,8 +821,11 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
 {
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
 	int ret;
=20
 	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -828,6 +834,22 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
=20
 	vcpu =3D reg_attr.vcpu;
=20
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
=20
 	if (kvm_trylock_all_vcpus(dev->kvm)) {
@@ -846,6 +868,18 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -856,6 +890,9 @@ static int vgic_v5_attr_regs_access(struct kvm_device *=
dev,
 	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
 	return ret;
 }
=20
@@ -865,6 +902,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -891,6 +930,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -922,16 +963,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		struct vgic_reg_attr reg_attr;
-		int ret;
-
-		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
-		if (ret)
-			return ret;
-
-		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index bcdac044a23f4..e05b4a5c2e49b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,10 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
