Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011036.outbound.protection.outlook.com [52.101.65.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73EC37FF78
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747779; cv=fail; b=N3rOgZ3JNLgvxjL7jpir7D7YIQQdkwC7jYW6wnVtILMPEOMZIGcEy9BmRQJu5suNYH4RH8vu3MdTXOFXc0GhBPW6zQouYjYt0/7gesjnX120UQGyRGzA+QKP4zqON9OzS+n5QjY3E8ujQxg7YcUTT3GAFmKsR7ZFrNiQgdmymqw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747779; c=relaxed/simple;
	bh=IxQKQKwuM3NhVHsNFS/xQcWptvR/kylPD4nwQYjeerw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NLXUyxndkslkS1BTaZPiZrzEjI/rsIm4hpyduETdDpHNaic2GpyHBWRMNjDKIJkpJV+/l1gDm7e3SiPqcMQgBVN4ZF3KHoxrbBsn38xZeJjuJpuLTs7yDmoPQg/b2fYgimXPTmmQ4ZuOWLmZD9lX+18fQPKXzbPCw/H+estGIfg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JI0dsVy0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JI0dsVy0; arc=fail smtp.client-ip=52.101.65.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JI0dsVy0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JI0dsVy0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OEImBlGOtX+dh6C8gKm4D6iCzzHaCYSv9VzoqIV1uM6GcKHoKkW4NuR8qnYfNc7lr7sIpBmu3Cs4UzT/yrtLz2TspDopOSq1iv0xBCZjsbgM8sKVi5qAI/V2Ap+3c2Zu1FR5njdW6nNBkBfjLTdE9kqtEyU9XE4A8eqqTbcFstLIo0/aSbk7jbn7Mn63ET+LiIUIAs9s2m9pzOgo/NH72GDMYZJGOL4cC6+0AVPlr4t6sctffpxiM7ngoSK36jPFn8xqU6+BAOPT8TbkRjlYHsKnauaQc7qzE0M61SlRPexcyx9zwnhBbx71gFIMDNqcC6JSawwdG4K/gtBzAgySZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=H+znKpH6lvHVmgtAy5r8QZ7s1Q6j6U3vtDIV5RtZQ8wkc7VKffyCKerE81KewBvr7YRCq7stuNGoYGMlow7OsPzTqAjjtIgOplSrSYqlf8WH9bVoRUE3wCR5SGzGCjluk2ieArd8wigry97isgpND6DL/CiCXKAZ5q9Sbz00b/j/nu4X5nbBey8zDh59DrAbcZGlnpyYx7SgHYOv+/vuzz9NYyTyrUAPh3pcnltM3Lmi+6FAG1Q49amTIpP3mhYTKqbja1I7OLHDCjEiqs1M/CtkAiOp8oHzwLu52Ee7pYgWxijevk33CD6zNonJBwOrHsV2dr90j6rWXjrABU4fdA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=JI0dsVy01IaZGV5dGMKU8uLnuJE+qL+fbvqoHeo9DguEBZvYpdNTnoL68i96QqLicAexp5DAsUqSU6GHD8UgqUgWpQPpPl+Pycow2i8ZZfjjQT/nMkAzf3vcMhw7OacFc88pFX6zcH2fVjKbGHokOqV5TFVJYpB54c//cqCyVl8=
Received: from AM9P195CA0006.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::11)
 by AS2PR08MB8926.eurprd08.prod.outlook.com (2603:10a6:20b:5f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:42:52 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:20b:21f:cafe::6b) by AM9P195CA0006.outlook.office365.com
 (2603:10a6:20b:21f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:42:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Our4SFBqi77oCDeR/EZk3BFUEA1Tk/zTV3+O3OXiGeJtvHv9O1HAI06OZKWPSomG7hi6cP5iEM5VEg+VkwbGVBnZu6CKEe9m+hZBEi9FGztYKLqD3noUBFZFDN7HoiLggImm7n+bYjETtUDHteu9JgT3fYp9ctuuaZAH7NolmVI8p7CD+Qi1Oz9ERT7j36bojLoskqJbl9zHeIEGdoyOkPS8gt6siTHJ6VbLdgxK5CHkecWqra3qtCv1tBEoKY7m4nEbTldwRgIARw/ZdrGswZZOD22UQneXKFbjVHveKq5qSVsPb0LgLvCvHyntORPzo+mnS0eIlqoU3TU4NUirTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=blbf92GSB6njyk4k9DjDCMviJjczONmIHfKADtxz3Rrk/Cw1aopeZava7z3BO6qY/7quqS+W7k9iitizfVe6yhshUf9WTod9v154d14HU03K8cmH5MEO2uOG//dYf5r068H38h1/haxCoHGgHF73EeATS5SzO037R07M8U0ClviY6QUvZsuU+JdE4BZmWjNv1K6QC6vptIWlVH5O0fgav2KTemUfVUn5YZWcPZKiw0DyjXDHi4zOwgiXXvoS/ucAfRQcFvjJB5VSZt+Rhp1ObXqXT5IsybmMS4jVd0f0BS1JfH99ptWQPN87yzxlfOcQysorG/sojlqcBEMcy89eJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=JI0dsVy01IaZGV5dGMKU8uLnuJE+qL+fbvqoHeo9DguEBZvYpdNTnoL68i96QqLicAexp5DAsUqSU6GHD8UgqUgWpQPpPl+Pycow2i8ZZfjjQT/nMkAzf3vcMhw7OacFc88pFX6zcH2fVjKbGHokOqV5TFVJYpB54c//cqCyVl8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:41:46 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:41:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 07/39] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v6 07/39] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHctgMI7Dy+22jZGkyR2UIXV9NeMA==
Date: Tue, 17 Mar 2026 11:41:45 +0000
Message-ID: <20260317113949.2548118-8-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AMS0EPF00000191:EE_|AS2PR08MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: c1e378ab-d2b1-4452-52e9-08de841a52bb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 u8AOa0b+UwWiM+L9SQFwGcJxzH3kWBb0QHWQKjUatbS1miTF1LXGfzOolrHsl83Si3OvvJhgsfg5Ks74mhtwmP3SS21ueJK5X+U8TibWhKGFhtr0s74+J7VrwJq3VoJDjxvsAXoEa9wFyrdS4JQ0x9SH58FWU6i6Pr6WCIuHypiJnnWMg80r9uzrGUiv9adpef66fqOSPSvh5z5lCSYeedAT+GLslZb3QxpM8X2wc4WaH8WdE1neH43K20Uht6Jp2QOlYuTtTlXeqG/+wOjN0MZkLSrvLSofkahid5kDfnOg/Xb3wTvrFW0DRyab/63M/yekNf5xS2OqeTIScBG0vxXrOLkEdUK/Z7vB9mfvToav6E6lObiBaoVIiJXy725GAYAb0XZECRlTzMXaRvjUvPNHzt57ynVejGAufcrjidAj8zEFv62DtfJLki6Zvp4xLhhcXM9Opv6xOrEI9EpWOqaCy8i4u3QYX6birBnDR9vMb820jQp3X4Y01oc374K/9bUUaWP7C1JwgzXEohncJg88U+H/h2Y8fgUpaAzFCanwMfFd6VWo12ysBgJIjS5YjD6RtEuI++cFj2dh9DbzYsOK/fhpR0IIiS9zspiBIzkEcnkf+s70xpV7CpmgCR+6vorEG1XPJ3iVsLs7VY1OzbRqaftxJ6g1NID04qkSN5f6DbRs3ppQdvbc3kVfH+HND6A8iPKPjJr8yvxKZm4bo796pw1JQnotU28hkxCr2Jd3CtCHhzl2VBH6s0ck6yeu36J94iuHaxx8U0WAb9PGfI8H+SRbi5MxZt5rLO9RRBg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 v5XRwb19tV1fkPuMoXaFAiVsuARoVrcMkWkj+AoR8klcB61pdMu1EzyOTs86dGl7NV5tlS5CtyweRHVJDRAx1YrmG0YLc07RVxVY8WsoZ7ovs+DNFLh01fHTzWyo+kp46UPabIF8ZSFIxeqjbhXBy9nTaWr0UA+3cYTKfph1Ly07Xmhm8NxhkcPHLXgFhomTVvJ4j4ShaSLbOZkJ5dzjMgf1UI+Whg3Fi2+WlHTHElCsWuQbXmyaAsuuBNA619Mw1XSLY/aKVqB3L4434pqQ80XU5HUbohvERZA6DIw1gFtT2SgBteU6Aw4R6u7vmD4WtCiW2VIYUKShKPu+HyNORA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e804d2aa-7463-44e7-d76b-08de841a2b0d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|36860700016|1800799024|14060799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	koV7Hbg/Gz7MAQZ0juKZ/t9z7FEBN76N8OjPRejtW3tKGzUeNbuuXHJvulAfV1RlXQOKElWG112hTgESPcvzXZrDmYXhFdnXDs4N8CZ7GVdYOrXpT3rSOPPuQ17Sfojq7EihYMMVXtxGpRZdBMgPG7HZW/d9hc5+oDmKc98fKb4KJtGI4j76K3oQRm2PKCxUQgNrZKBW4UQfUWkA+YZ+5G/vTNGW3HXCLqfHaRdA+EfgczR/sFu+HKlwwOLe2XL2z3l5JwfFjjYD6Q8o8XhTo0fW08ZmtWWm0B6qptgw0W0ToOXoEkOpv2Q/HIqThNjucFTXBmEBOl5ysu7U913zHOMXi5O7Ue9yR0bA1u5FMJQnyLTmDEA0Ejn8C+QOVBfIbZNnnXDrKWPPVkaZt0YLbJZuCTBqWizClkznn7A+c6h5dV8bDWo+iEEAz/HgPcjEGa6+fGLsVTy2Y+YTbCkbt97OFEvOt8g8LnlMmnK6xl6bqzjfpftVTaHke6mvEnF+zikqF92NcsnbEWMQYzyiizlRqasKerlYMU/ZKeo39f07l0KJthsraDcOJhlZWCen6l2UJo0jnvsyOxi1p6zI5a73Z81pXfd3EA7BUkV7HFds5IA24aGHCaKCpQ8+uXgWdeckDF4p7E4u9fr1UqXpn+pIfPJPMJgsa/nZQ3aVDH/rN1Skj9DJsjhf0M9Mcw1BSA/l3RGi4GFYtJdZlKfqTv2LMuWwt+hv3b0F6u0kZXIivOWRc/3p6t7fz3Qd+ITgqHGqN7LghQr55I1mJBNzPg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(36860700016)(1800799024)(14060799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cqdSd7p62W17pBXMS+uSJ/hFWzsg1FQ3cu+f/FT1WtqXptSaOr4phUvB3Ditxs4ZlpL5YCvgOJYPRowqhKw+MILSJsT0j0MqKa2mIt5MCc6TNY/3PnJPA43ERoW8VpfnqJyca8X7VL9wp8UceQy5YE1myWj1RzXd6kInaYH/GYNR5WvV3ojLRGYMGPrUlhDxRxOG8qKXJJcCvIObLRh14GqYKU+qkaCA+GM3+RzeQcTSVJePXAKPIWFMITjuU01JPKlX0ebzb3+Iti54pVr0jv+isOtiU3imJpmlOBf7ntdi1wW/bNDtz8IMGDfbTYo3TR6Qu4wHp2lReUNgxkrrxpR7V2C8snBPiZhatJs1OFvnk3rJWKOS3iZffiEDcSHv3K3Wz5L5igggLnRhsWhU85qLW5fZsMD2BYyt/PqiKKEXdyHeIsQi6wWHqJmSsWQE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:42:52.4247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e378ab-d2b1-4452-52e9-08de841a52bb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8926

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 80364d4dbebb0..d0c0c86059767 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1224,6 +1224,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index 65500f5db3799..713e4360eca00 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1220,6 +1220,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1
