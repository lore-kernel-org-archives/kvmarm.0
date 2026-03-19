Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010064.outbound.protection.outlook.com [52.101.69.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF143ECBD7
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935953; cv=fail; b=uYJhaF1J2CfJqQODs3L/Z+jmNj5rZ0XBmuAem/kUzWM0z5IJpDpZb4oABs+uebKcaq+DO3ueMKH7yXy0WEGcfwi0/KnrxH/NrTipYQnlkWdVOv5mmTV3/BuP4Hu0fvhkOKhtKoZlWzBb+RksrpKjOkegIQh414j54GN3NhF9Wuk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935953; c=relaxed/simple;
	bh=+MHIF5c+2vRDKKGrJcQFZrxNJW1Z2TEyEwmeZseogyA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tq+Z0jtnAlFSLnrrJDIoXJtZRZIr95zmjlDzx9O5rxCRoB26QAA3wYsFjJK8DDlY7MDvNur2X7rpPOPNOI7WL6NtspmfzyhxToM5CLWLuefoGv/7Dx5D0UK9vvdzQ1eFD5FPkTkShn7gVhEQIa47bgMpyktAXWF342Vlx7nV07A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QOW0EAeA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QOW0EAeA; arc=fail smtp.client-ip=52.101.69.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QOW0EAeA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QOW0EAeA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Gwm0AmiBm4fAp0+tWELqD3gMYLYCWScQWEo05BvfegTfZDqk8nxc17MLIKhlR4YkJV3Bdw7qpxdjFl5nRJDOqQo0gUHDb1XXtc7KjsMPzf24a708oZKvFY8ImFi9nB/NSG0K9fUfcHYc2SFzdoQ/eqlSb8eYvFARa6ymRQfdw1UPRVp9aghNgVkTrq/DSeSoSp8FLdCh7Sn2TVhNjprpq7VIj1GmiYqafAgeFZEkBVZAJxQWMukSnTFpgLbrXgvjoXz1YxpG+sXA9oVliRD3ghEdRtQ7OcTBsKI27ioPITjRmu2CqZ1l4ewjB83NYncC4jItyeOB3UDtkN53Jpxz+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=gwRmMiHNGEjy7R5KxceIj6nDAZbkKW5gWFJi+HBdjp4UZ2+8j/fb/Vga81GoLaTRmmE/DJ2BK60aVL+d7lioLihcuxnnYM3LEfSQJ8grjApjiWNU3TJO6QxWwJl8f5QUC82NbAV807iE2gfsuhNUhPYff9eNHj/Av+UBnLWCIgLSLhcJpF8UBxuQavLwZ1AV/HxHE1246elPrlPgh4OA6EdF8usarTAgUiNy8DjTRKf8ZH353NhvvDcam872RFKsy//nfFFU7xy1AI8NBGqqeuHmfFyCm4Pw3wA7tJu+nboUamfCi8PIvaiosmey8Z4s4mkmKbWAgqxdoevvUKRdYA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=QOW0EAeAsrzJTg1T4A+IzSN88bpHHwTndI8RigkrHDNCsnokjyyvpeOCMFQQ4cUJqt9jBX92aZ96U4GVuZh6RZu+uFZ+CEvmGlOqPlWKttL/kaPNIhDjuFwWWJ41Sggek7jpkwSRPXXlQnm43nLYIzMONOgteN0YpwNvIlprlpo=
Received: from DUZPR01CA0273.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::14) by PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:59:06 +0000
Received: from DB1PEPF000509F4.eurprd02.prod.outlook.com
 (2603:10a6:10:4b9:cafe::90) by DUZPR01CA0273.outlook.office365.com
 (2603:10a6:10:4b9::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:59:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F4.mail.protection.outlook.com (10.167.242.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8kOPCryjLdh/VKuxJwkwSsKt9+1nd+LxedNXP+HCsPzKUZ9Z58EkpQrgLs3hDcOwTGIGPxMgepuiIjzPefpyDO/916xAenkHP2lkfy5Z87rIu4yCnGMQU1CuDbocm2bb6WtqAT+T13CVU921iQ4/iSwO/d561Ix0r82qgtok8obDMnNv2M4zdKkfDB/jOexV4WrOpjauaWEPQ2dBf1ylVRHN7h9Rtk3he+dMScApXKI8jkIf97bwE2UeDy7hs5GSlDS16rfeFVp7S+Yi9JNGvZkdZA4LNxtD3I5FrKCFmvNUCDI/3x69vPOniP+b3nZPeY/viQug/bmLDEXwhkwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=hepmGKD5prhbBO/f4Y3pHzP9ERbI2pyVlyLWjj4h5XJ754F/rDThjeeFqPZIj4M53h4i3DSiL3W3NFtg+YF2dhC46EPJpRWTIi0JR7GCL5skqPoIXxljMbTm0KMJ/dNNQtcpmjEpppd/Zce9VS4S3ySQqroORUMpnoPH5k3V2qCBIYfsmY9h/4qe9bFtdU+QJc+Wrnr7aXbikX2a0WWLVbl9hsUCCGSs0cA3LwyxnLqrVf2Dma+bsYRuHbiKCEWsvhJ6hPHINHqs9qC4irMUJpBEbZ4CNsebNak6MRuTbQNGK6zFyzUXJL4q/H6wcxBNy75RLWUm1EWuTg/cBFhxZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=QOW0EAeAsrzJTg1T4A+IzSN88bpHHwTndI8RigkrHDNCsnokjyyvpeOCMFQQ4cUJqt9jBX92aZ96U4GVuZh6RZu+uFZ+CEvmGlOqPlWKttL/kaPNIhDjuFwWWJ41Sggek7jpkwSRPXXlQnm43nLYIzMONOgteN0YpwNvIlprlpo=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:58:02 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:58:02 +0000
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
Subject: [PATCH v7 32/41] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v7 32/41] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHct7kq11fEFlShgk60Trbx78I0fg==
Date: Thu, 19 Mar 2026 15:58:01 +0000
Message-ID: <20260319154937.3619520-33-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|DB1PEPF000509F4:EE_|PR3PR08MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: 303b9ebe-d3c8-47da-db38-08de85d072ba
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Zyp5NI+yCkSqsjPJwPFFsoyg5TXEmf9MRgkBH6y2j++0ixQdRIsV3zhFkNg+IG97YPH1T87mK2fTcalOTatUs5NbfMvzLiCb+9zL4XvMd/1aH0uXHU18k8kzxL5FuZmZSenMWRFLpg846LH/zO021gy0SYD9etRjhnaggBNP/p1im9pg3abbb65gpLycXQJTozhMXomq7afjINcdPmJ0E1gJteePf1szwd9fBanm0y4oxlD2thZxdeMNPFvOUsDhwiZeSTLTZv79KiMm6sUScEnONOOcQlf8bQAKglw7sfx9/IwbuoqsnZpUI+tV8BERRNy92cEqRYSjImBQbFgIq+YpFojbDhnLtFTdYck8gOn3oI8eioFnXIlc7O1xLUPqzr8QmkS1f0FYrgZubKRdYy2H4uG0UCH6cWx0VlbNz3xvH0oFHWlDGAzv0PpofCjTTO7l+/pZVEM2QsiExzobz/4nUCFEFHBUiqT4fTBBWwp2asnyLNTXkWoOugjgtFBSgR5TW3sSS+BrcJY3t3r+3QUyin7Au29mVX6EW3ZUXM8kYx1a8mk8+CDgY/kWN0F1y7xmbSsQc4bpWceF0K1m5PjOAkFJp8erymai18Nda+csa5Jp/T5ggslx84FnKvl1HTwdiOxJlSDsXyBC5ougzMSujrhHlNVJJOKlfsb7nA6owL+GAY/piXRQhb3yQ7q9YN6XO8c1Lt/ai022DZp9osUoYyIaN1rGql42mzGvObtKaB9JXR0L41Mgz7rxOC0ykzc4jNLZHuBa8gP6KbMjyB+XuxI9RKPxyKWHccYDh4A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FPXq5rHLaZkZdSbhr2dDhe0oLnIbufaZqj8/BCY01dgddaomq2d3DPbRjPrdmWDQQz/rESdBxeLcNQdeCbPMwzYQ8XDMwVw0FABQu4hOJ201zZxKqYGBHeraeRI4UwnZp+8Z3F3wmBUbT41eYbAQbTjLGsMjWGAfxVC59A+dOjOWmyWvMyNX5Syx8/eZresfCZi0bM7uLgjW7GnBePlvAk8epIOXCkGBhw3QBb+dDo4T4vxFLXg+5jBryjBLmEDQ5L3CiKI+DP3Fdps5I50ohlLPN8YLPRVVBJPHffB95EUrYuHnY7VqPIPfOF7gzfoUa/Y9wMhxbF8R0hkiTP9Tyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f368d2cf-cdc2-4c7e-834c-08de85d04cb3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iVck024p8VJU4MYpFQJRFAS0WGc+EZ5T3M6IOJkiDfXYas9hp2J+nttpxFP3o4V1DvKtZjeQdxUC7pWKjY3fzRU7V3fB4Ce92VKagHUYDZ/k1N7+s1UjneeCzlzD8sj60uSlEc/i+HJDn3neBeT2d9az6pt0JRAxO7nZ5df09shSqFgO/07KoohlqAD/h7ROgiJqJJImS42+/NGVbGDDge72iE500QY0kHmRxfaYPSE9Q93G2otc1rrER0zPg74xfL3K96J6UuwWpqZWYS79kaPJ2NvXqkJ/1oRxbIXlJUXomzuh9A4erdjOCIMgTBYlHged26kagtCclcz6SRFHOPEQND+BUTlfIy8cAFF/QwJBcFDQIqhZYgrizU+/vNWdmJLc+rnAnmdqJ60jgbybwhFbaenqQ/KXDeM5eelwQRKLZ2CYRMptbhvK0HjkZgILozgWtIVpAJK+Dh3gWbnEcbxyDBBqzUbXvitzUxrpTFHhbyBLWQpxo5nnB41C+k/XxBFHvkPSYpccUNBr6XXI+M9PPV8JTWvShE8bgn6Uh/G4JYk/4mxOAe4ETYEFhZlV4cYUEpUpA5S2JEoGbiyFrzY5yuWKFYzF+bK/A15EIqzAZETcZYMtZQkiusU3KxYO0ypzTy9mYMnczxZAVU6ckk/NcbNy16maVdr30nENO2zdoWG260av8jINpfb4dS6WpUl03TipJG+ODDZpSf0WH55S62G4lIqkWmuPfbtP7RuzVdVnnrM4lUq9zlTn2rsRwq+5W3v5rfOoOpxYe8SkNw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VelqxM2plvAjDvsjFSTkHwHS4yuel2yGBtF96vGshV9T7PQhFmNWkxE2yc7pMV1SjbdDXNTjYmdkn7rIdX7Xtu3o+m6/8jWY+M06QFLHhE15RX5I0uoiNz8yihYZTidanGotQUyXj6v/U0tRvjUYBowAjTzySK+Swh2TIt7JNJMfN6JjcglaqyfI/ssUh6BX5DBVTd7D+6sKUcPrQrWzwOOmpxjnpJBzVKocLCimBGMHYVa16IccRBgeyd8wYcVcNeVM3SGffDm5vr20j3xBIY5B5ob3ov+j/DYM9O4JJNEKNlA7aLPUvHXSC0sjedynqyZzLpzjhwySWH6fALGVQJmP32NhmRSC4OLacxg8pCWcZd1X19jb523rxSRlm85peTH/SyzfwHkGDYt68gCxumQZn46sTnn/8YdEMunGO211d2cTWYoCN61forocGAHg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:59:05.6617
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 303b9ebe-d3c8-47da-db38-08de85d072ba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5564

Make it mandatory to use the architected PPI when running a GICv5
guest. Attempts to set anything other than the architected PPI (23)
are rejected.

Additionally, KVM_ARM_VCPU_PMU_V3_INIT is relaxed to no longer require
KVM_ARM_VCPU_PMU_V3_IRQ to be called for GICv5-based guests. In this
case, the architectued PPI is automatically used.

Documentation is bumped accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  5 +++--
 arch/arm64/kvm/pmu-emul.c               | 13 +++++++++++--
 include/kvm/arm_pmu.h                   |  5 ++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/k=
vm/devices/vcpu.rst
index 60bf205cb3730..5e38058200105 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -37,7 +37,8 @@ Returns:
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interr=
upt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interr=
upt
 type must be same for each vcpu. As a PPI, the interrupt number is the sam=
e for
-all vcpus, while as an SPI it must be a separate number per vcpu.
+all vcpus, while as an SPI it must be a separate number per vcpu. For
+GICv5-based guests, the architected PPI (23) must be used.
=20
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 ---------------------------------------
@@ -50,7 +51,7 @@ Returns:
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set
+		  number not set (non-GICv5 guests, only)
 	 -EBUSY   PMUv3 already initialized
 	 =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 41a3c5dc2bcac..e1860acae641f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
=20
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			if (!vgic_is_v5(vcpu->kvm))
+				return -ENXIO;
+
+			/* Use the architected irq number for GICv5. */
+			vcpu->arch.pmu.irq_num =3D KVM_ARMV8_PMU_GICV5_IRQ;
+		}
=20
 		ret =3D kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
 					 &vcpu->arch.pmu);
@@ -988,6 +993,10 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
=20
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (vgic_is_v5(kvm) && irq !=3D KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..0a36a3d5c8944 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,9 @@
=20
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
=20
+/* PPI #23 - architecturally specified for GICv5 */
+#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -38,7 +41,7 @@ struct arm_pmu_entry {
 };
=20
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_NR=
_SGIS)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 =
val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx,=
 u64 val);
--=20
2.34.1
