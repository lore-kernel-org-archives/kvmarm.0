Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013070.outbound.protection.outlook.com [40.107.162.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC236D500
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522368; cv=fail; b=spYjK29WZmVY76hx7/4YzmM1QrbwAecvLlVErExi4qWhfo1/L8Q+K+M7eNde7JkY8txtB1BhdAWaP/YZV5ZDspRShj/Cjl7J/lagotrnVOgOOPHPGj9A9lhoMROka+q2pYJlEAlE9w7E34OH2sw4Stil25mQsbyWI3QnFk+9Emo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522368; c=relaxed/simple;
	bh=CCzoT6K9T0mAeOiZf1YiTlgLZg09JghFJ8yxbsxxofk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yb0tEdmU0nBedMs0RRLEDF9rcrOTWUjKzh7YLPeLYbK3Psu8Tkp/IKSiJ4smr1sVka+XmvtxoWPjdnxz1m9Z1D6A6bbbclTuAulm1VCqa5WmbIbWF6cGvg2jnrDRawUpeQ5xTCSLFzwZDVvVwttrAwq6YkRCKqn5qHh7VQzADic=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ETfQDwVt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ETfQDwVt; arc=fail smtp.client-ip=40.107.162.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ETfQDwVt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ETfQDwVt"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RWRTQMZL7wR77DagmZPBDMwXmL9zZxbTsCLSPRO3V+m42JAFGAuyfrd2H6D7Vly050OFZeZAyg/yIvDh3VUgM8EHW0DcUmDY8Hyf8X6CeCpuPiZjVlISZPWXfsWNB6VBVTr4rLRsM83cDOTr0e7d6WwIjd6ui2D0nWL5IdsJ6qCxy1v7oSRrBHLKKe4raOgXTFazyggBY6M3gTgECmS+7CaFjaKLlXwqGgc0rvh1FLhqBpMmmeptEBwBKk0IpvnxAGuIM8SHvlLeT8yEzr1IqRIGSHtP/XQP0jYI4cUMuCoGjkl1Qd3e02Ubhpfb/tW1gu9j3rl2zRttF3h46bnhdA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chVraEZBHXwM4TcRGHa7TNHZz/elr/S56EQZJzqmb3o=;
 b=N52WTz+ybBTrvATJrqrMbkH1nqw2TVG5GKOnA3HzCSNvEeCA2WuCKy3lfKL76udvyQ3CQXGA5ZQgguprBp9N39SpjYEKBdHTGKtlARZ5uzSceOp6wB9dP3EG4j5gZGhxRLiaooQ3zPRtLynoH/kd1PhG9yH8L3Dwp8c2mQuQnpAH0VymVDi57zcohbP1sgixG3fiwWt8F3REFI6Gag03rDVgcGz2YwZPrTyi82YZUkdsIlGeD6t3m9kN+dqJwtHIFTBlDVr8iXRs3u8DNYmbg8eTEjZ5Md88DWrLLFnssj/EwOsxXcwcd2iHxVbloUqLeXwcVfgdjmmiiBHSB1aTmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chVraEZBHXwM4TcRGHa7TNHZz/elr/S56EQZJzqmb3o=;
 b=ETfQDwVtGVnC32iq5YNlO6VAIt5bqG6yCdkcH+noWVUG6aP9WYsX3Sr9oDtNsBZmIdkRYeRZQcFsr58TRI5parc8eYo98TDhX13KsH+MySm4/NQIHi7+bYWF1iV3osIOm086Grma28e8mpqv5t+oH/ABFDn3PpJ86ByK96uzfAk=
Received: from PAZP264CA0035.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:122::22)
 by AM0PR08MB5409.eurprd08.prod.outlook.com (2603:10a6:208:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:46:00 +0000
Received: from MI3PEPF00008551.eurprd05.prod.outlook.com
 (2603:10a6:102:122:cafe::77) by PAZP264CA0035.outlook.office365.com
 (2603:10a6:102:122::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:46:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008551.mail.protection.outlook.com (10.167.240.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:46:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bNVIDScZcccyCbQmKQ1Awj52m7FsWD34yjqe0FYRjZySqAvRZWCn0vxVCbl/9IjxDNlT92N3UvbQOpc+NXPTBnv8SBn1Jl4tE0kwv2R0ST9gkTy2m+6KFZ90CiKVZ9oJW7Qj9GA7C+emdHJNWwM5J+2bwcL1MkgzrhNeiXVRzqzuGtrNxOgJPa/QMVkat9r41I31W/FuGIwhighyvps/iFOobsoDR3/Ns72DGpOrl8hZb0iMPHAg2HiQdCDv3y9wBTUCfhfwArB3pwLWEF8sJfme1AbeKfjZRV+05zJf8s+HPcdV8AW3SMZ/SmQMap187ysVP+Ef8s7dYm1l+bOgDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chVraEZBHXwM4TcRGHa7TNHZz/elr/S56EQZJzqmb3o=;
 b=fi6RHJggvGTCZpjzrSI8VpSpG8OpyaR0MKPTLSSBpsz7GZuAmAOzX3JyHvjRB75JV1mYLvURVlURiV3BXazGKf8FSDYiNzLFhfq8W6ZIF5tz43Gmqy+Tm06AF2AZp4pXmLw8JH/a1m9IPs86SrIDm9Eei5XFdChl9mxibyPRLxSvyGJrsW81nAcKPt08JTot/stOX3LJdRN9JjeUA7m1yHJDDjO21AI6sBuRCcQAt4cFRrN9JfAaiPOslh52Cpvlme7gXX6PFEN5EpXg5Ag+eIopKrJR2OBWXarRjtkxX2ykJacbxXeC+G963owD0HXfjmLIZvaiwrbN3EBSag2uRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chVraEZBHXwM4TcRGHa7TNHZz/elr/S56EQZJzqmb3o=;
 b=ETfQDwVtGVnC32iq5YNlO6VAIt5bqG6yCdkcH+noWVUG6aP9WYsX3Sr9oDtNsBZmIdkRYeRZQcFsr58TRI5parc8eYo98TDhX13KsH+MySm4/NQIHi7+bYWF1iV3osIOm086Grma28e8mpqv5t+oH/ABFDn3PpJ86ByK96uzfAk=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:45:26 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:45:26 +0000
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
Subject: [PATCH v6 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v6 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdPGLgqp8hQ4GRvUOi6R/Ec0cbBw==
Date: Fri, 4 Sep 2026 11:45:26 +0000
Message-ID: <20260904113404.4051341-23-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|MI3PEPF00008551:EE_|AM0PR08MB5409:EE_
X-MS-Office365-Filtering-Correlation-Id: fb4af2f7-4414-462f-a40f-08df0a7a1759
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 z16SKFaGN8+JAdSRVEITcZtk2tvJu2O6Ybjq3uo2yYg/899EM2lIlSiLgTtQgErAxAlgPP2PqhLsKZDdVEK0R5fOGZdJUkpPJ7rwlvQLRq5woUbhkYFAw++IqrPSkIcdPiKmphHyUt0ATdU6bTALgCE09phNxID7j+tXzsP/WNU1FbGJM2zWidyXew5g7pURg03Vu31nkOovxSa2tY7YetHA74vgWy9WNDeSSdkCz9NmJrFFFOuY1WT0hC68SEr11Z/OdhejJPL5/S09j7uY9OyjWXKAA1OA4GnuvM6zT4PrPomygeChI+//NzX4FtqVtBGE5eqmsX1IN306sa+uKiy3pvTYN+cI9NE3t1pptsJZUCsdHaSgSQ+h0lFAtf0fMZwsVKgsm3XQWrRYi3vO7V5UZ4bs9slZAnI5cPrPHELfrV2XK0TlYQJfTQXNZfrvkR8cXNnfJR8KNEykRx5XpMnspY5zwANUTmMZAL+jjXwdEcAguttTYKrcnAhsH29sITtcGA3QXAqnWBVhWrK5qFN4AGYQVAiNTcIqM5L5HiYylQRw9uHNDGoR7M5/LeT6nFrUWHD/Zf3gQPZzp8Bv10D5HUewnvIm6NciFHvgPGYzbhj/5VwKW7YJUewNfaflizBm4gzJsfQbQpud2HgdDqrDXvRBKg9kUOuxQUXgLTinYcyH6+fEiIOKDARAdAS+ypAeamzpYCbvzhAvPMN6oZ6x2RqbubP24Ip4iKk7EF8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Jo4zspbXzBG3ghm9hNzdvDN8iyiXx27yGAOkgAS1bQHKxiPM70miWcfFzW8ImVuOffL3K1QuvOeTWx7KNwHCnS7wkGhTZAwKsCMsdaO4782NfKNHs6Wsrig9aA0UmRzDCcSYg+q0NMUh+V2F+wj4vPONl6nLJp48kE38gWDSHpzXHO21wXqgi7iyXldqHIOWnxliD7Y2R9BbWLXjU2VkxnkQaHptFtntoOMB6Y+vWu0ix9/DVSp3Cu0Q248/W4XvR1J+ipe078wcJAu4Q2Gr6ZfHyjtKH/TgqJP/KvSO/lnknl7IVp6kjVhC0wf3b9AiSo/HlfrKkWW1Y0dY600pdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008551.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aaa8f8f3-e650-480a-c4d6-08df0a7a0353
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|23010399003|376014|1800799024|36860700016|14060799003|10067099003|6133799003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ASMarju2nQFfZQq3n4RCoWFSX/xqgOng3ahAtyv6LlXvBO3jtrEIIf7tFXKIKdqrfHgfo2vmFc7tYg3dGoOdAw6vmbosCLBbCISRrjE5YTus04IKdecLceaGQ+emwR/ZI90Lt5eDMspS8Sq9PJEPPU1I7iiyRzRd7VEob5KxDFLthtRnJBojd2Nyqruc7pY40LGyP7v6WXH4JmY8Gng80aEi9/doJO+MAJHm6oQert9nx1IwEvz3ke/S4XGr7lcVEc5C6VdQ+B9LzDmSKBB/rNaOOp6aJaOe/pWxT/fxgQde2z57NtrbTb2THktbgjgqQWghTVDsHnHCesbPomXqIWGXL2mJ7b0W1X6NFlzyEwRkINAk6fRkkVhOxImawd18OoJbVMOb/jYQrzwWqDeEoAozjnoslODYRBfudakqedzJ9jW0GkYytsVP4L3q/IB+jlo9Xyj2b8K9p2y0YVOE/KlM/1xogEgc2+XZKSXu3tN2asQwwoNbg3cIEZmP6ZKO/D1URpjvJtdwD2nsM89OyMFVKBz4mt5k23Ke8ilS7ztakbGjtwRiGSHimwKNe39t4wVnHcNjkjaA0MdliH7oW361W/nAna/36qTdToKGoqDkwezzOtNucKM5fnB4kZiFPi/9aqJezSjhRF6Y5RKaREbolQVAbgxcPx9hrBCPzIQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(14060799003)(10067099003)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vLf+Q0c4ArEsiBtTa7HFunv31qvK1YgGCZowklxl+9C2el0ONfFHw3feZOJHJEx7e14Sj8ghvGdMDoQgmQJE4vdVNHOy0YEy0900JI1YYwXrnU4NwhseKvY58kZOYAHIOsyoCgCfgwDpHZVj2i/aIb4F4639I8hvTELbApZmBZI83rcJy54CX5Yw8kdfX6udvsYY8cT1pb3wPLvfCOjAZeBF5dpNfz94bW2tS2PpLZDDDjYMqvRqo0VC/LUxfXicC7VzHfVLG7P84zjpI3OCOoVkagDCOI5dDqdTSYM6jWvchSZDtxlpYe+ugvWcGmF6nNcTP+vcRJfP8HZhoUWber8wm4BBvpwV4M/wK6xtj70/H/oWfxs9e5gWgI5dru7iFdumaGTt2YPe/fimDNJMzvFSDFAxLlSdgqWGRaZWZ/HdrTRSyPKRGOV8BP0p9eMK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:46:00.1890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4af2f7-4414-462f-a40f-08df0a7a1759
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008551.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5409

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow userspace to
set the number of SPIs handled by the emulated GICv5 implementation,
using a GICv5-specific SPI count rather than the legacy total
interrupt count.

Limit the configurable range to 32 through 1024 SPIs, in multiples of
32. KVM keeps one struct vgic_irq per SPI in a physically contiguous
allocation, and allowing the full 16-bit KVM_IRQ_LINE SPI namespace
would make that allocation exceed KMALLOC_MAX_SIZE on common arm64
configurations.

The default routing has one IRQCHIP route per configured SPI, so size
the common IRQ routing table for the largest GICv5 configuration. The
model-specific routing validation retains the 988-pin limit for GICv2
and GICv3.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  18 ++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 ++++++++++++++++++--------
 include/kvm/arm_vgic.h                |   8 +-
 3 files changed, 97 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 9b504b02aae03..1537f4d20318e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -690,9 +690,8 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
-	gpa_t dist_base;
+	gpa_t dist_base, irs_base;
 	int ret =3D 0;
=20
 	if (likely(smp_load_acquire(&dist->ready)))
@@ -715,13 +714,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -731,7 +729,19 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 			goto out_slots;
 		}
 	} else {
+		irs_base =3D dist->vgic_v5_irs_data->vgic_v5_irs_base;
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(irs_base)) {
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(kvm, irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..8c2c6886af4e3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			/*
+			 * GICv5 reports a number of SPIs, not a total number of
+			 * interrupts. Require a multiple of 32 SPIs.
+			 */
+			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
+			    val > VGIC_V5_MAX_NR_SPIS ||
+			    (val & 31))
+				return -EINVAL;
+
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +324,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +804,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +831,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ecb0e3526d311..1edc7b378f5ab 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -31,7 +31,12 @@
 #define VGIC_MAX_SPI		1019
 #define VGIC_MAX_RESERVED	1023
 #define VGIC_MIN_LPI		8192
-#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
+
+/*
+ * The common IRQ routing table must accommodate all GIC types. GICv2 and
+ * GICv3 need 988 pins, while GICv5 needs 1024 pins.
+ */
+#define KVM_IRQCHIP_NUM_PINS	1024
=20
 /*
  * GICv5 supports 128 PPIs, but only the first 64 are architected. We only
@@ -41,6 +46,7 @@
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(10)
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
