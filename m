Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013050.outbound.protection.outlook.com [40.107.159.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD0C37DE8A
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775031609; cv=fail; b=AoTju8Nuc5BnnzcZh3Jsbm8635ctHMwkrLYdJhtv0ATDZZV3DavsBgQR2Nhwiszh0+AZxZLoDu5U2qdygCBYg8B+Im5YJDAV4tdO1W9ekKJanmIP/nzTOz9jwEfINuWDqxho+SQUBDAuLZy3JTEGA16oxb4gbSd42wAfMN6zcAg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775031609; c=relaxed/simple;
	bh=uX7FbjOj+B0LDZ3krtYFY2Yxd3DencAJMVoYh2J4FuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rnjO910rdjzF7PQmIaEN/y7O0hdZ+vVGvvBMvYQBC7LEH5S3MX9sPrLmaUZZ0X/8VqDjQIHgHRtD1U6cyT5GYxErIF+NXp9KnUTyPCFWjVxwf5Reg7l2beDRt1KjhQnpXYa7UsyAjwvsTfob+EdOGDg8PcA0B86JUryQFmqy8yg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hk6deAwV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hk6deAwV; arc=fail smtp.client-ip=40.107.159.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hk6deAwV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hk6deAwV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DPxkSFaEEpNnnuCklXCj/tHIOq2FKiuO7ny5dpDZpSisrLdhjSGCSUq+vFcOcBi3QPiy22P1klh2xkrKM+KV735qNL/fxEf6PlNKmcHJy9BoNvBLLk5eJ/Cxygnzq+v2FEQGwacDjT96Jgoj7WHE51/SeMIwWlEFkl7bU0LR9lz8/EpYy5ezyhBdSiigjNSDmMBGMYu+Yy9v2c+WPUSLdT34lL/BABfP9UpZCipz/DIytACgAB2sR2fwkX8zN5FoojGS2CY9f0F3pWZTer16tv8hfvjfTowEjTfWNclu7AzOL0862sd2D88NkLmPqaV5AXNkXY3i9iP3ZLDm3eGThw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uX7FbjOj+B0LDZ3krtYFY2Yxd3DencAJMVoYh2J4FuQ=;
 b=QRvkdRtFXkKAtblGE62oNvqVlSBTmcn0+fBbjlzvSnqnquyfx8BUfJjoFRTGeVvT7Zjpum5IHy8aODxGMkT81/1bBeDt3O+LSudSjnfLPvMY2NETNG7+1xNXZWkeDXOJVOJgNl1WRqvO2GOoqX40vUEBCfJYp3KDHfwrJLdJ0DMdleUErBmjL4btRk6vdsTRTswafu3ADf4B4bB8g/BOJFy0pcoAa0UfZ0mTL/IYFWimyMv3J0MyTJfdZWwKz2Xp5VY5gy3D2CEBmix72vq83lS3DiGuRCIwDcSaYnudhjdWIuEdXyMrbWEdIv8iuXEND25L6XS546ipi13m1s+WvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uX7FbjOj+B0LDZ3krtYFY2Yxd3DencAJMVoYh2J4FuQ=;
 b=hk6deAwVkrdQJWMAw7e7fDKMzP9VHNaqSqCBDtnt77Kku+CUQ37CRHEFKU90GnWX4xzkpQkGh56+CNjothpegz7DxtfZYQubjK0aObUs9EAhReCxOVZBCFq4H8Yjw1SxhA1JjJk4jPSdL2WPHv1faBjr5W0rcQoal4Wf7+xiaP8=
Received: from DUZP191CA0055.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::19)
 by DB9PR08MB6443.eurprd08.prod.outlook.com (2603:10a6:10:261::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 08:19:57 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::25) by DUZP191CA0055.outlook.office365.com
 (2603:10a6:10:4fa::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Wed,
 1 Apr 2026 08:19:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Wed, 1 Apr 2026 08:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEEKJE2EslyqDKDTiGhvOHm2R+fgHb/ErX2VdySnl/pNh2Vq/qtjcikkI3BZEcZamXfltL7uwUpfHppdTOg8AIaADMoqwE9cIwE1ECVwHpiBKxCX9mP7T0clDr6ftlq5k9ar+r4W6n8HsniVPW7PDnG7fLPtGVeVlyTzDRbNLJZK4yhtpwl+pyZrsrzGulJENCofPgJ+QFD+/NEum02U3aOaM2Py0DOhT2gAeO5iqpAIve7wc+zGhZ5kC8cArVsJd74ftMSYIgeOG7gELsAdwx2HSmGx28f5nyvsDEFFkZV0/0t7ucuz0zyFvhgFbG0eUskzpTgKvyV6GQB4Jbkmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uX7FbjOj+B0LDZ3krtYFY2Yxd3DencAJMVoYh2J4FuQ=;
 b=seAx0OeEZkYwTzlzG27OBNM4yOpHNCmDL4/6cOd765AHTP/jDMztXlCGcAkC1mb8QYwbJeTqLBeb1aTJjfTg9qahnVn5rwhz7LbBmzOFw4cqmD2r5EKoog1ba4koQOn8Sit7lKS13IAaI4TRkDKxmVkxiTPVON2PSq1/infRKaWq4QBhTwyjBKFxkT7Wy7PNRLOr98vxwnTBlhqT5rmqxEtCNxGufc3Q77yvrZ2rPhnQdG552HveIe7OqXHblugiBuNtq4Od8UuY4TaXXu/0SE1DDYlYXyEJqiT41EwIhgcjUXTRmwKFFKq+OGnuoA5l/TadcZab6pXKlPXufxeMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uX7FbjOj+B0LDZ3krtYFY2Yxd3DencAJMVoYh2J4FuQ=;
 b=hk6deAwVkrdQJWMAw7e7fDKMzP9VHNaqSqCBDtnt77Kku+CUQ37CRHEFKU90GnWX4xzkpQkGh56+CNjothpegz7DxtfZYQubjK0aObUs9EAhReCxOVZBCFq4H8Yjw1SxhA1JjJk4jPSdL2WPHv1faBjr5W0rcQoal4Wf7+xiaP8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 08:18:52 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 08:18:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "broonie@kernel.org"
	<broonie@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "oupton@kernel.org"
	<oupton@kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH 09/15] KVM: arm64: vgic-v5: align priority comparison with
 other GICs
Thread-Topic: [PATCH 09/15] KVM: arm64: vgic-v5: align priority comparison
 with other GICs
Thread-Index: AQHcvTY1cdajWVfb70W1MqZk1TpkF7XIxjmAgAAkHQCAAPuUAA==
Date: Wed, 1 Apr 2026 08:18:51 +0000
Message-ID: <5bae1013c735c4d83813c070399f8a5dc2125e0a.camel@arm.com>
References: <20260326153530.3981879-1-maz@kernel.org>
	 <20260326153530.3981879-10-maz@kernel.org>
	 <729851f0e7d277d308adf04d0008156a01f482bb.camel@arm.com>
	 <867bqr534v.wl-maz@kernel.org>
In-Reply-To: <867bqr534v.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PAVPR08MB9724:EE_|DB1PEPF000509F3:EE_|DB9PR08MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2601d3-6534-4782-418a-08de8fc775bb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 l1dewTnZFiDWCX2vX8TeWXn1WWYnV/qxmUQbiQGj+2Fuk+bbZ0E5wEtW5KeEV/rMIiZXOndQdXkXCsuo4mkaVoV/85qnn0nrVriknEwwpP+Rj7Iu85gCqPJW192msfaqFClth1LkaTCt49eJ0Y4iZ62o5kHsCO+3Tm0ij0vvDS0g874CXc5pCYrnBxhb36M/7iqTs3k38dRbwVCC5Hz4epSm4QalF7SQOEYTsLkC7eQafYL5e0+QevtYaLsv6iW1hjP3pE9ZKT9Wqj8A3YWcMf+ApnBSyPuZTFvAaZi7csrYiuH0y4671SJ/QSCsXfV56ClIrYf8/Y3Crlqfgle0Kz/cwnbxt8qqyafXo169fGD+ww2539rezhS2X22Dz0DbLhJdUCmt22Z0n3rckm79IDQsAg7baFwUMpMI6KOYlNdbH/wzcHJMBfi6VtF96lYV9RWBMDzTL55y0HUrkFcHfwZIACk9x1hU7wjOcDeI8wa1gFSslxycl458PyKM4t2LPEympUkDsj6uV/4l+HIS28dMalAxRriQmdL4szmnFeM+QhHtrmGC8gofjf7M5Uq4foNWXDmKDybbHhprng7vZxR3GCDhd1xcAM69zsSFzZ9YwThCRM8yGLFtt8PPxlWH2J79V0HMh4lbgF1yj/OTP5zOoPoUQL6UJE6Qn42pCL+BfcKx1RVjKqNqYaysNbQaML8BTxDMJwxUJXGoOndUgxoz28JWo4Gm7raoLKr8oUs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <19311187CE54D14A9068B594A969FB81@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 RmuBOzaEekkTbPkBTBO0yHQX6lOBlOpD41Na1snJ1Qe6NApXOzDJ1z/4nz64ufRO65BmbOM1UA1UaNs/4b7Y6T+/xCep3nxNJzk02lOpjZfw5Mw6Q2sHwSc0YJJL9w6j8RJMZSoGQrMlTQ8VRWcvZ3Z1Wxea8WcXlgN4EMohp2T/pVZWOZ4Ph16itY0r0/qMwd0/QuLkCVip7wab1rxbYc7+GvxvG0yPz/qDOZptWmHgbeadwCYV2icSMWn6Xr1imYVGERtYxoIymI4nbor1H1ddxdbhk0sMgDza+rThGhB1cxP64oXTAP7I8jvFxaSHN5dowmPWRgW2GgIIdpcFaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8bd68636-f643-400a-4faf-08de8fc74ea4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|82310400026|35042699022|376014|13003099007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	S5L7rDWhon3uumAqR7fFBc1T0TDQPMVJ8bJsqMDvwVhuk/soG25RgAGuxEfr9DX49ZO6QRTBKUNlmgEXwA75YtDhTDVaDWd8MC6SsfXvz84iRhjcSciUwWWNse2541O1uATJ69tAiWDp29sE9aOQ/bWncvZ7VsdvbibOyi3R79u4bidyYXMdRPAM5ut6wvyao5b4O9/Fo7FjY+WxPy/dXAhcdF0/RITWr4YLpBS2sEuMqL5kQ+1HbBj65h146P0f9CUfpbQ5fQdUPI8DCZ9jbjqjHadNtD24AcEz8o24tj+0E8Hbr9VGHVippEIYxi2BEMmDxw9jPXMOEvTeg0LjdfTBPjNHCJKe2QwZ8bs1MQMSl5XYTJzQsLvr7sQek3447ZM8GtxdsGGBAF9i6XBYhBq5ZAmrS1zzUbwEc4cdgO5Sbq3T7d3oZ7uzrN6nErXQHI7Sr77gkZ+6ALnW9WG//jrY1OFGMuEFibOFWpC4ZwhyJFyLKwnEa4BrEQWvE8Oc5+rGlZ728Cvrcd0QyRdZWX1NY6J9OgEyfbKEYOV25qIXmRB16sKfJ6OAs5kzgQvGxdcv+mfQchQE9Jksdsb6oGgFzwACP2ryqpbpnFTYWQSHtuZMnyP8qVl2CHWEGMReRPV1YAlC30Qgj0bC7Sg1goVWq8gOd+6AnIrOmrEwqdud6RX2eY2hvmBGBSc71G1I6rcitBBFSjZq4Xr81U2VKg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(82310400026)(35042699022)(376014)(13003099007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l57CzHc+hSOX4pgVTvUHsDjnH/5ztukoPxLJdDOhPUfcaVz36Slyplgrv4Zq6J5iOBV0LVJ+5YxaEaD72VWJGz7wTHwnZ0UoBtTVl+LD4lCE6zryfaqM/a6PtGhSdxHxcVQQ+vNTz5uMlaoBdSu+xdFfli2vvgrZHEM4V+s4ApvgWqBC+FH50IZZM4qamOgW79Rs7ZOSfUsf8Hfk4LkpXHFHpt70XdYXNdeom6TbRW/Ly0O26/J1W4c0qivyv2Bc4NC6rsRxf1uzJsH+EmwlUyk/q/3S6nk+mY3RHQTD/ZxJnqB9/4jHwrgWXC1rtBNbYQkNYGYUtW6vT3fxlMMLTynfEf1l5OKQAF+vJDtDtBRH038MqmGXO3BYlYk35L5sUWbeUh0++wka+BXOe94JmsCSGNIZv70rMbAmusjPS0xUfLhFWKq8Kfo62pWqlZLm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 08:19:56.8380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2601d3-6534-4782-418a-08de8fc775bb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6443

T24gVHVlLCAyMDI2LTAzLTMxIGF0IDE4OjE4ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgMzEgTWFyIDIwMjYgMTY6MDk6MTAgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFRodSwgMjAyNi0w
My0yNiBhdCAxNTozNSArMDAwMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiA+ID4gVGhlIHdheSB0
aGUgZWZmZWN0aXZlIHByaW9yaXR5IG1hc2sgaXMgY29tcHV0ZWQsIGFuZCB0aGVuDQo+ID4gPiBj
b21wYXJlZA0KPiA+ID4gdG8gdGhlIHByaW9yaXR5IG9mIGFuIGludGVycnVwdCB0byBkZWNpZGUg
d2hldGhlciB0byB3YWtlLXVwIG9yDQo+ID4gPiBub3QsDQo+ID4gPiBpcyBzbGlnaHRseSBvZGQs
IGFuZCBicmVha3MgYXQgdGhlIGxpbWl0cy4NCj4gPiA+IA0KPiA+ID4gVGhpcyBjb3VsZCByZXN1
bHQgaW4gc3B1cmlvdXMgd2FrZS11cHMgdGhhdCBhcmUgdW5kZXNpcmFibGUuDQo+ID4gPiANCj4g
PiA+IEFkb3B0IHRoZSBHSUN2WzIzXSBsb2dpYyBpbnN0ZWFkLCB3aGljaCBjaGVja3MgdGhhdCB0
aGUgcHJpb3JpdHkNCj4gPiA+IHZhbHVlDQo+ID4gPiBpcyBzdHJpY3RseSBsb3dlciB0aGFuIHRo
ZSBtYXNrLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogOTMzZTUyODhmYTk3MSAoIktWTTogYXJtNjQ6
IGdpYy12NTogQ2hlY2sgZm9yIHBlbmRpbmcNCj4gPiA+IFBQSXMiKQ0KPiA+ID4gTGluazoNCj4g
PiA+IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDMxOTE1NDkzNy4zNjE5NTIw
LTEtc2FzY2hhLmJpc2Nob2ZmJTQwYXJtLmNvbQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFyYyBa
eW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gPiA+IC0tLQ0KPiA+ID4gwqBhcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjUuYyB8IDQgKystLQ0KPiA+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLXY1LmMNCj4gPiA+IGluZGV4IDBmMjY5MzIxZWNlNGIuLjc1MzcyYmJmYjZhNmEgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ID4gKysrIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiA+IEBAIC0yMzgsNyArMjM4LDcgQEAg
c3RhdGljIHUzMg0KPiA+ID4gdmdpY192NV9nZXRfZWZmZWN0aXZlX3ByaW9yaXR5X21hc2soc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gwqAJICovDQo+ID4gPiDCoAlwcmlvcml0eV9tYXNr
ID0gRklFTERfR0VUKEZFQVRfR0NJRV9JQ0hfVk1DUl9FTDJfVlBNUiwNCj4gPiA+IGNwdV9pZi0+
dmdpY192bWNyKTsNCj4gPiA+IMKgDQo+ID4gPiAtCXJldHVybiBtaW4oaGlnaGVzdF9hcCwgcHJp
b3JpdHlfbWFzayArIDEpOw0KPiA+ID4gKwlyZXR1cm4gbWluKGhpZ2hlc3RfYXAsIHByaW9yaXR5
X21hc2spOw0KPiA+IA0KPiA+IEhpIE1hcmMsDQo+ID4gDQo+ID4gVGhpcyBwYXJ0IG9mIHlvdXIg
Y2hhbmdlIChkcm9wcGluZyB0aGUgYC0gMWApIGlzIG5vdCBjb3JyZWN0IGZvcg0KPiA+IEdJQ3Y1
Lg0KPiA+IFRoZSBHSUN2WzIzXSBQTVIgd29ya3MgZGlmZmVyZW50bHkgdG8gdGhlIEdJQ3Y1IFBD
Ui4NCj4gPiANCj4gPiBGb3IgR0lDdlsyM10gdGhlIG1hc2sgaXMgZXhjbHVzaXZlLCBpLmUuLCBv
bmx5IGhpZ2hlciBwcmlvcml0eQ0KPiA+IChsb3dlcg0KPiA+IG51bWVyaWNhbCB2YWx1ZSkgaW50
ZXJydXB0cyBhcmUgb2Ygc3VmZmljaWVudCBwcmlvcml0eSB0byBiZQ0KPiA+IHNpZ25hbGxlZC4N
Cj4gPiANCj4gPiBGb3IgR0lDdjUsIHRoZSBwcmlvcml0eSBvZiBhbiBpbnRlcnJ1cHQgY2FuIGJl
IGVxdWFsIHRvIG9yIGhpZ2hlcg0KPiA+IHRoYW4NCj4gPiAobnVtZXJpY2FsbHkgbG93ZXIgdGhh
bikgdGhlIG1hc2suIFNlZSBETVNRS0YgaW4gdGhlIEdJQ3Y1IHNwZWM6DQo+ID4gDQo+ID4gQSBw
aHlzaWNhbCBpbnRlcnJ1cHQgaGFzIFN1ZmZpY2llbnQgcHJpb3JpdHkgdG8gYmUgc2lnbmFsZWQg
d2hlbg0KPiA+IGFsbCBvZg0KPiA+IHRoZSBmb2xsb3dpbmcgYXJlIHRydWU6DQo+ID4gwqDCoCAq
IFRoZSBwcmlvcml0eSBvZiB0aGUgaW50ZXJydXB0IGlzIGhpZ2hlciB0aGFuIHRoZSBwaHlzaWNh
bA0KPiA+IHJ1bm5pbmcNCj4gPiDCoMKgIHByaW9yaXR5IGZvciB0aGUgUGh5c2ljYWwgSW50ZXJy
dXB0IERvbWFpbi4NCj4gPiDCoMKgICogVGhlIHByaW9yaXR5IG9mIHRoZSBpbnRlcnJ1cHQgaXMg
ZXF1YWwgdG8gb3IgaGlnaGVyIHRoYW4gdGhlDQo+ID4gwqDCoCBQaHlzaWNhbCBQcmlvcml0eSBN
YXNrIGZvciB0aGUgUGh5c2ljYWwgSW50ZXJydXB0IERvbWFpbi4NCj4gPiDCoMKgIA0KPiA+IFRo
ZXJlZm9yZSwgd2UgcmVxdWlyZSB0aGlzIGArIDFgIGZvciB0aGUgcHJpb3JpdHlfbWFzayBpbiBv
cmRlciB0bw0KPiA+IGFsbG93DQo+ID4gdXMgdG8gY29tYmluZSB0aGUgYWN0aXZlIHByaW9yaXR5
IGFuZCBwcmlvcml0eSBtYXNrLiBFbHNlLCB0aGV5DQo+ID4gb3BlcmF0ZSBvbg0KPiA+IGRpZmZl
cmVudCBzY2FsZXMuDQo+ID4gDQo+ID4gSSdkIHRyaWVkIHRvIGV4cGxhaW4gdGhpcyBpbiBhIGNv
bW1lbnQgdGhhdCBsaWVzIGp1c3Qgb3V0c2lkZSB0aGUNCj4gPiBkaWZmLA0KPiA+IGJ1dCBoYWRu
J3QgZXhwbGljaXRseSBjYWxsZWQgb3V0IHRoYXQgR0lDdjUgb3BlcmF0ZXMgZGlmZmVyZW50bHkg
dG8NCj4gPiBHSUN2WzIzXSBpbiB0aGlzIHJlZ2FyZC4gQXBvbG9naWVzLg0KPiANCj4gTm90aGlu
ZyB0byBhcG9sb2dpc2UgYWJvdXQsIHRoaXMgaXMgbWUgbm90IGJlaW5nIGFibGUgdG8gcmVhZC4N
Cj4gDQo+ID4gwqDCoCANCj4gPiA+IMKgfQ0KPiA+ID4gwqANCj4gPiA+IMKgLyoNCj4gPiA+IEBA
IC0zNjcsNyArMzY3LDcgQEAgYm9vbCB2Z2ljX3Y1X2hhc19wZW5kaW5nX3BwaShzdHJ1Y3Qga3Zt
X3ZjcHUNCj4gPiA+ICp2Y3B1KQ0KPiA+ID4gwqANCj4gPiA+IMKgCQlzY29wZWRfZ3VhcmQocmF3
X3NwaW5sb2NrX2lycXNhdmUsICZpcnEtDQo+ID4gPiA+aXJxX2xvY2spDQo+ID4gPiDCoAkJCWhh
c19wZW5kaW5nID0gKGlycS0+ZW5hYmxlZCAmJg0KPiA+ID4gaXJxX2lzX3BlbmRpbmcoaXJxKSAm
Jg0KPiA+ID4gLQkJCQnCoMKgwqDCoMKgwqAgaXJxLT5wcmlvcml0eSA8PQ0KPiA+ID4gcHJpb3Jp
dHlfbWFzayk7DQo+ID4gPiArCQkJCcKgwqDCoMKgwqDCoCBpcnEtPnByaW9yaXR5IDwNCj4gPiA+
IHByaW9yaXR5X21hc2spOw0KPiA+IA0KPiA+IEkgYWdyZWUgdGhhdCB0aGlzIHdhcyB3cm9uZyBh
bmQgc2hvdWxkIG5ldmVyIGhhdmUgaW5jbHVkZWQgdGhlDQo+ID4gZXF1YWxpdHkuIFRoaXMgd2Fz
IGRlZmluaXRlbHkgYSBidWchDQo+IA0KPiBDb29sLiBJJ2xsIHJldmVydCB0aGUgcmV2ZXJ0IG9m
IHRoZSBmaXJzdCBodW5rIGFuZCBrZWVwIHRoZSBzZWNvbmQNCj4gb25lLg0KDQpTb3VuZHMgZ29v
ZC4gVGhlIGNvbW1pdCBtZXNzYWdlIHdpbGwgbmVlZCBzb21lIHJlamlnZ2luZyB0b28uDQoNClRo
YW5rcywNClNhc2NoYQ0KDQo+IA0KPiBUaGFua3MhDQo+IA0KPiAJTS4NCj4gDQoNCg==
