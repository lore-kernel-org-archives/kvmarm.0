Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013068.outbound.protection.outlook.com [40.107.162.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6EB47DD59
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060781; cv=fail; b=cBoa584xq3lEGxSWFzDLXO/qkvJh9jrX66QuxGq/hEs0xkA02gYfukJIZvJovrlan991eBUBZKc3yfGR3KVYaEd4myMRIsjsy/5zwipw5cNX480xmAH9CfhmDS9K1mvGOnlCOc1aQprOZZRhA9NhUztWpzPptCY93gwKjhE6AVk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060781; c=relaxed/simple;
	bh=yIUXZ9z21gs2mWGPa25hSezChPu4Z86FLUTl2J6AZwI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XR0y6JF/EeZwfcaU9IgV9H7LZMi3KQ7ntYuhsqiII9PTdFBPspiiU0MTE+GRmNIT71AazmSMT3S7+10gzDutakTcGz7Vj9/GlX/ai+fZMJJtYObFe4CtJAJ9KLxTSO/XoT6+sH7K5MMpjaUwNmXCYvz06oq5X5bfzESFqUUjFqk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oPFIG8Ep; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oPFIG8Ep; arc=fail smtp.client-ip=40.107.162.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oPFIG8Ep";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oPFIG8Ep"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=THTq7DK9RBKU40sMWSoHJJ/KcOLOMVs55TGXdY/g8U8py/pkkWWnWRElklhu59WMXu3rhfQTshKrCEg69HlCqa2YZtbTdUdPqQieXDY71u7bq5KelXx472A4/PAPDmhHVBCwGm73lLH0R6XWpJUkGvrnOE2f7HuAt4/0BcmYDbCesGS5gnTExEoZnehfODl2hbLWeb9cbNsGCsc6JrfK6/5kSvpgWj8F3F179shgYD6aRhjYoUtTsIiMqd3mJgi495WjTz7vDshrLjbyJCz+zG+Wzqqiw4vujXMqSB3N9hUpYqmPL1AZNhLsWs0W/AiP0eCFdbuHGBAnJ8Z/PWpB8Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIUXZ9z21gs2mWGPa25hSezChPu4Z86FLUTl2J6AZwI=;
 b=m2EQLBLm8O2HNI4O0BpyX7S/v2JqiMXosifXgYVrV+CUdBGkp6SxdOojdlQKg7OdvZTFlaKxRMNOqLidjSI0YOneQyZaairNSRGAC8Rl2JQNXbnIh9G+iI2mTbP/UJWpNrLKmt9FJIXKCdLrxkZo1vbnBeARwlinTQtPPEtfNNuORGZKArSUY/2p9UtibT+69fWZmaIMZItE34WWkAvdHSlXyq2jUwGfOLb9/MlIY3NxoRj/eCtBg6lrbvd7fQw8MjTL1nfviKIPInu6/5Hk197bVjd/oUUHBrtNs8P89AzMPYcGMKNFqXkXZAIUntegFfF9eFviZimJaQT5+O/vYQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIUXZ9z21gs2mWGPa25hSezChPu4Z86FLUTl2J6AZwI=;
 b=oPFIG8EpB21ZCBD5QrPp/f7plieFgjLk4N0GuzcauUQfXL7OubBxGYDQj9IKiePXjoQEhljE9sEO+42gJKyo7NvzJBjTXHuKjXWDrm4G2r3IIaSodM0p/vw8Ouzy32GuUO7jFe5i1W6pxmIm3qlXvDEa+to/RYLqXzbCtcc0crc=
Received: from DB9PR02CA0003.eurprd02.prod.outlook.com (2603:10a6:10:1d9::8)
 by PAXPR08MB7395.eurprd08.prod.outlook.com (2603:10a6:102:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 16:26:04 +0000
Received: from DU2PEPF0001E9BF.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::9) by DB9PR02CA0003.outlook.office365.com
 (2603:10a6:10:1d9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 16:26:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9BF.mail.protection.outlook.com (10.167.8.68) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21 via
 Frontend Transport; Wed, 1 Apr 2026 16:26:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iESgu0NDRACXqk860VpRQ9JxiWUYEKEdjibuTasdh7LRInrsZ4uHVnmHjvF7d7wlTkWSnIlga59MMZ02xBa0stcLKSnDO9Sq6AMxGaTUaxwrm7Vk4fsKXtkivrofxiyzytgNV8WZvkTetdQxNTUAp0haqKAqMyIqW4sLXpm9g+poiOPxEJLB1YrSUT5VFHjdIBwBvP1i2k4nNqy3BK+H/FMg5eeiWQiESDPR6fZddOa2bVN8fEIHrer7ksaTAwrvwxkhsLYE/VASfc1Wc4URMm+J5olroETXT5nTq+AoqO+/h4nzIe58rTGWkVP0r+xqMZjl3ww+SEolL1FEkxhKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIUXZ9z21gs2mWGPa25hSezChPu4Z86FLUTl2J6AZwI=;
 b=NBe2NxT8KoZfn4NwkGkESuqi5e6YP6tssZsO1Uz6ZByki8+PsoyRgr/MZ/j8ZIYbIfQSDPbV+OmYHmw0W8L+rRoxtK9MpQrO5gmu7VUn0e76+DD7+PH9gyvmJBU0HDuPgjAlZK91xQEPAyK8+b5Z8DU2OQkYMSRi3XhQNLjOFYFPv/YRyfAKJzYUxXIw7Um4rPETmhZjSNbS32HCihJHN+RM9tD/JsixAeiqrRMFxpLTr6MvfU1i2GqN7RmHYoQFkRhK01VkY+j1n05SBVfkouG0QxwVecfvDeDe0C9QUL1dpe0Zp6f9bgUBqviSzDAldTegq/wjnwcFKauH4BlfZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIUXZ9z21gs2mWGPa25hSezChPu4Z86FLUTl2J6AZwI=;
 b=oPFIG8EpB21ZCBD5QrPp/f7plieFgjLk4N0GuzcauUQfXL7OubBxGYDQj9IKiePXjoQEhljE9sEO+42gJKyo7NvzJBjTXHuKjXWDrm4G2r3IIaSodM0p/vw8Ouzy32GuUO7jFe5i1W6pxmIm3qlXvDEa+to/RYLqXzbCtcc0crc=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI0PR08MB11646.eurprd08.prod.outlook.com (2603:10a6:800:308::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 16:24:56 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 16:24:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v2 07/16] KVM: arm64: vgic-v5: Transfer edge pending state
 to ICH_PPI_PENDRx_EL2
Thread-Topic: [PATCH v2 07/16] KVM: arm64: vgic-v5: Transfer edge pending
 state to ICH_PPI_PENDRx_EL2
Thread-Index: AQHcwcNvjVcgGJzw2kedD5XCuGj9UbXKZJ+A
Date: Wed, 1 Apr 2026 16:24:55 +0000
Message-ID: <d81f9dbd28203f8894c7d4359ff99b6f9a26c9aa.camel@arm.com>
References: <20260401103611.357092-1-maz@kernel.org>
	 <20260401103611.357092-8-maz@kernel.org>
In-Reply-To: <20260401103611.357092-8-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI0PR08MB11646:EE_|DU2PEPF0001E9BF:EE_|PAXPR08MB7395:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fed9761-ffe6-4d89-d0c2-08de900b5ed2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Zvxc76iWFOo/bYsO6fA4ZnDVcfJL358+mH7jDms50NfRg3Axxj7XSGR0zuUHMELntdet+GMUtGK9p6r73gYka7J9POeTpVx+3Kdaj3jw+EbeHM3y696CYsWTYL3idLJ7KvQyzrsdVCRnJFzlklGbYJU+hlXDvOnbIRmDNQ7wn7ahf/jWXDkWAEeukVjvKqhZYXAXHSo1He5SrglKb04zGzvCt2q0eiWmgBB71GyI1kVPR73z4H6eWXjCcBvMg4lk7B5pAIGDVbzN+Y4EmP2bWvTKHmtQtwC8q1NoVzj0wvWxUY5LTHAb/9MIGoPkuR5SeQnda1BlorojAg4FMOtwbhHileQFrL1+eslynj2g3KDIem5UyYjcI8MJVkTQ5Z+hVAW9biYwsqaV+CFy6Dnh8kA/x6IgYh1Xk+HevwZ2VjJMBnlBzmwKLpa1JX2GGOQ0KGMnDbhXjoimZXl9ejwydmHLqVmaWCPM3lh6blU/12q2WWJAUELzaql37rrBh/fX93k3GrqPrBltb4yjUvCjLet8O/nLCU4eWD8ZQonziZpD6sY7F3sP3ns16uWT++F/xSoZ0nA/V3NKesbuWAGyMTN/O0wjJYZb+lUYASK0HeaPhP/B16g5ZPv8m0o18JKGWDDYAuUV3AIF9Zfdm185A3T/OxFbgFGTQdO8u3Cz0zjB33EJXGkPSmN0dAgiWbjZ4Z0nvP9J+zhhpU91mzkUO2sE/gwXGdb2vMs4H9eIsPk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C434EFA0F2E6741A45BDAB910809795@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 u8z7oDDTZ3j6+ZGOcxv75iCzmsCqRCQFWk0jsaXC4VyJl7vEp2M73EkCq/xUcNB7Hu5vRdt+OHUbUPj51jWZFiCHcJVCkKdRGBx4Vvl12RtQ6BQgb2vMtT7Yd519E5YJgPEeE1slGAXiEl1DSwwSht6Og0XAdHzt0b+FqAh3BNhOykHFIlZeGm2ba064pRlW51/lJndM9xMFM4bjmhUui0B3b0fdeU9HFKCYQRUF5V2kCVxgiY4u4Rh8EuAAumvbZtiKaO0gQNzCXSDJI03oWYVJFSxbjzVH6lbz74b/r3l8VUM0jloVVtWJpA2PNEKTsp+RT4fXMCiuOxK+5wyLgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11646
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e5866a19-e871-450d-eb79-08de900b3610
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35042699022|376014|14060799003|36860700016|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	IJ99ETXqWk/AFK2Z2tG4/0CHuevWvK58iCI8q8Mpql3QDDKhGu9smBpyNIpTHrqCmPA/ALOMpH9Pu66x6SBdnpKTZt+zgIAEwN+IcS0LYQGeoG5P7EkihrIDBzEnQgGM8w21fubYlZFUPUr4Q8EX4dQb81TeZL0N04Ngt3sUySTEc2M6k1lQZsX2TbxE5aJIN1iRnGP+K3NyegUf8ib34ME121XHfhLqTgUMSHw4TYPCeaT4C8nbNkc2vKt02gpZ/pZUHb44N8ZOeagFNEWLhJYPO85UQI+FA7+H3r5zSffPhvVrB4r3AB4UvMXOfqxhOKgUnrgTAwwW8vEMJDhxGNvZaj04PrZ/cPXfvXwdMT+M96TSpg6eK/Mt98Lg4cRg1wBJQDpHVKNVCAaV7aayUSMq/Ep1BVBVxR90xlTSQS27DRdcOEXyWGMYRxgYEAJipPrWdTkeeTX4znbRSLMpImNW+vBT0+1AFDAjEx5KGQ2GkOpQM9RCOHkPlrTcmE5BVfUn3Daq9uUZip6DleI17VGNx9w95EC166uCC3vwIesV5T/+xa5H0QI1anLQeMTx3+qEAf6m51E2NT5JEzHGyRJbXTUA1kFEVScHoRKOidLSQ0+3mSb87FmV6NUPJQYaGMt8di2nZLSCgKXnP73wyBZscGHvFetxzzoFLXiROxhHWHpjdrHPVQ0vGbK75tsLLktAwtpaOFUVrlxZakd3HaOzvtIG/JZW56cV6mokHZI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35042699022)(376014)(14060799003)(36860700016)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KDCgQLdAU09uVVvkolZxD0i3QSSZ/cSwUGn+MrD30MWJjocftVJZfowykeBOZH7FrMYAweXKHclqAFeOC/Hfp68xqGtIemJdJiIx5bPRMUQwvqb2TrxoCrxJUrqja7Nx61hnxm4JlUPbEO0MxXIK4xMjDh5HgZFQLXr+Jwmhg10D8jHfKAVsWwYtaKIIC+AY7H5So2sj7RxqWdPJ3+mLWnt4JuJw6r88qrdk+6B+A2Igno53nEKar7l3M0PPHEdo1+tE3WKylpTctXc+ZjA7v7UeobBgvsSHz81/7DXCwogt9eKtGm9d/ytUvxG84JmsAoN2X1oQWpseUdm+5ZoKmhj2rI9h1cSOgDBNthqo2zrpoaui0AdOAgD9qVsVu/1lpF+kFzgRC9UtJgvieQdofkeSY3EKugBB1d0IoCkW050AarYL+KaLHsaLf+49HPLL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 16:26:04.2079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fed9761-ffe6-4d89-d0c2-08de900b5ed2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7395

T24gV2VkLCAyMDI2LTA0LTAxIGF0IDExOjM2ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IFdoaWxlIGl0IGlzIHBlcmZlY3RseSBjb3JyZWN0IHRvIGxlYXZlIHRoZSBwZW5kaW5nIHN0YXRl
IG9mIGEgbGV2ZWwNCj4gaW50ZXJydXB0IGFzIGlzIHdoZW4gcXVldWluZyBpdCAoaXQgaXMsIGFm
dGVyIGFsbCwgb25seSBkcml2ZW4gYnkNCj4gdGhlIGxpbmUpLCBlZGdlIHBlbmRpbmcgc3RhdGUg
bXVzdCBiZSB0cmFuc2ZlcmVkLCBhcyBub3RoaW5nIHdpbGwNCj4gbG93ZXIgaXQuDQo+IA0KPiBS
ZXZpZXdlZC1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4g
Rml4ZXM6IDRkNTkxMjUyYmFjYjIgKCJLVk06IGFybTY0OiBnaWMtdjU6IEltcGxlbWVudCBQUEkg
aW50ZXJydXB0DQo+IGluamVjdGlvbiIpDQo+IExpbms6DQo+IGh0dHBzOi8vc2FzaGlrby5kZXYv
Iy9wYXRjaHNldC8yMDI2MDMxOTE1NDkzNy4zNjE5NTIwLTEtc2FzY2hhLmJpc2Nob2ZmJTQwYXJt
LmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiAt
LS0NCj4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYyB8IDUgKysrKy0NCj4gwqAxIGZp
bGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gYi9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjUuYw0KPiBpbmRleCAxMTlkN2QwMWQwZTc3Li40MjI3NDFjODZjNmE4IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBAQCAtNDQ1LDggKzQ0NSwxMSBAQCB2b2lkIHZnaWNf
djVfZmx1c2hfcHBpX3N0YXRlKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSkNCj4gwqANCj4gwqAJ
CWlycSA9IHZnaWNfZ2V0X3ZjcHVfaXJxKHZjcHUsIGludGlkKTsNCj4gwqANCj4gLQkJc2NvcGVk
X2d1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlLCAmaXJxLT5pcnFfbG9jaykNCj4gKwkJc2NvcGVk
X2d1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlLCAmaXJxLT5pcnFfbG9jaykgew0KPiDCoAkJCV9f
YXNzaWduX2JpdChpLCBwZW5kciwgaXJxX2lzX3BlbmRpbmcoaXJxKSk7DQo+ICsJCQlpZiAoaXJx
LT5jb25maWcgPT0gVkdJQ19DT05GSUdfRURHRSkNCj4gKwkJCQlpcnEtPnBlbmRpbmdfbGF0Y2gg
PSBmYWxzZTsNCj4gKwkJfQ0KPiDCoA0KPiDCoAkJdmdpY19wdXRfaXJxKHZjcHUtPmt2bSwgaXJx
KTsNCj4gwqAJfQ0KDQpXaXRoIHRoaXMgY2hhbmdlIHdlIGVuZCB1cCBsb3NpbmcgZWRnZXMgKHNv
LCBhY3R1YWxseSBoYXZlIHRoZSBvcHBvc2l0ZQ0KcHJvYmxlbSEpLiBJJ2QgbWlzc2VkIHRoaXMg
aW4gdGhlIHByZXZpb3VzIGl0ZXJhdGlvbiwgYnV0IGhhdmUganVzdA0KdW5jb3ZlcmVkIGl0IGR1
cmluZyB0ZXN0aW5nLiBJdCB3YXMgaGlkZGVuIGJ5IGNsZWFyaW5nIFRXSSB3aGVuIHdlIGhhdmUN
CmEgc2luZ2xlIHRhc2sgcnVubmluZywgYW5kIGhlbmNlIHdhc24ndCBwaWNrZWQgdXAgd2l0aCB0
aGUgR0lDdjUgUFBJDQpzZWxmdGVzdCB1bnRpbCBJIHN0cmVzc2VkIHRoZSB0ZXN0IHN5c3RlbSBt
b3JlIGhlYXZpbHkuDQoNCkluIHZnaWNfdjVfZm9sZF9wcGlfc3RhdGUoKSB3ZSBkZXRlY3QgY2hh
bmdlcyBpbiB0aGUgYWN0aXZlIG9yIHBlbmRpbmcNCnN0YXRlIG9uIGd1ZXN0IGV4aXQuIElmIHRo
ZXJlIGlzIG5vIGNoYW5nZSwgaS5lLiwgdGhlIGd1ZXN0IGhhc24ndA0KY29uc3VtZWQgdGhlIGVk
Z2UgeWV0LCB3ZSBkb24ndCBlbmQgdXAgc3luY2luZyBpdCBiYWNrIHRvIHRoZQ0KY29ycmVzcG9u
ZGluZyBzdHJ1Y3QgdmdpY19pcnEsIGFuZCBsb3NlIGl0IGZvcmV2ZXIuDQoNClRoZSBkZXRlY3Rp
b24gb2YgY2hhbmdlcyBvbiBmb2xkIHdhcyBpbnRyb2R1Y2VkIGluIG9yZGVyIHRvIHJlZHVjZSB0
aGUNCm92ZXJoZWFkIGJhY2sgd2hlbiB3ZSB3ZXJlIHN5bmNpbmcgdGhlIHN0YXRlIGZvciBhbGwg
MTI4IHBvdGVudGlhbA0KUFBJcy4gTm93IHRoYXQgd2UndmUgcmVkdWNlZCB0aGUgc2V0IHRvIHRo
ZSA2NCBhcmNoaXRlY3RlZCBQUElzLCBhbmQNCmFjdHVhbGx5IG9ubHkgdXNlIGEgc3Vic2V0IG9m
IHRob3NlIChTV19QUEksIFBNVUlSUSwgdGltZXJzIC0gdXAgdG8gNA0KaW4gdG90YWwgY3VycmVu
dGx5KSBJJ20gbm90IHN1cmUgdGhhdCBtYWtlcyBzZW5zZSBhbnltb3JlLg0KDQpJIHRoaW5rIGl0
IGluc3RlYWQgbWFrZXMgc2Vuc2UgdG8gaXRlcmF0ZSBvdmVyIHRoZSBtYXNrIG9mIFBQSXMgZXhw
b3NlZA0KdG8gdGhlIGd1ZXN0IGFuZCBzeW5jIG9ubHkgdGhvc2UgYmFjayB0byBLVk0ncyB2Z2lj
X2lycSBzdGF0ZS4gVGhpcw0KbWVhbnMgdGhhdCB3ZSBmaXJzdCBvZiBhbGwgYXZvaWQgbG9zaW5n
IGFueSBlZGdlcywgYW5kIHNlY29uZGx5IGFyZQ0KYWJsZSB0byBkcm9wIHRoZSBleHRyYSBwZW5k
aW5nIHN0YXRlIHRyYWNraW5nLg0KDQpJJ3ZlIGp1c3QgcG9zdGVkIGEgcGF0Y2ggYmFzZWQgb24g
dGhpcyBzZXJpZXMgd2hpY2ggYWRkcmVzc2VzIHRoZSBpc3N1ZQ0KaGVyZTogDQoNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LWFybS1rZXJuZWwvMjAyNjA0MDExNjIxNTIuOTMyMjQzLTEt
c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20NCg0KVGhhbmtzLA0KU2FzY2hhDQo=
