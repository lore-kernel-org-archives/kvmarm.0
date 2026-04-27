Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013011.outbound.protection.outlook.com [40.107.159.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABA34DB4A
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306222; cv=fail; b=c42JPbstemHCC+1vj9JLwiFs31eqzmT7feDPPvwv8mpvepI4OoANfwNGjb6rK1xKnIqU9muv87lrtsetshRePct62v5y6k9HyNvw5zrmURDIg+HqY0RqVH9zeYwi2PL09vTH2FLPPzu096BKhopELPhLEvL1zpfP4Zs9NGLPQjc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306222; c=relaxed/simple;
	bh=4mQGX63h/hX+MEHsg4OGUhGfjyql+xdhAUtT+xYY0LU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nLhrrbIOCQ6nC3bZ6ciLWuTKzupLt6dfmOOQOFQxgnrjXl7/QuBgnqT08+wf5GEhPxZ7mYe9sgBHX6GCAtS+htTgKie/n9KRLATpRCEW1RbyUrKpmLbRyrtQwYiP0jol+YIYDyZVdp5UEr/TrpEMmkkJZxQ0vwjo9dyVWTlAiUg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cbvwtAaz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cbvwtAaz; arc=fail smtp.client-ip=40.107.159.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cbvwtAaz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cbvwtAaz"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nHLvUlDqPaL2OtxB8Bc8J3ee8fvbJz2rKZvme+bAFsrlo1JSIsXF5pRdL99HI9rJDpg3ZwZWNw7RZO8CfWH8dIRwPTjBcrsWxXFg1Rrc5YbqZv1RlXS3n5o0U9zZ/6z6N8N+O8vmYY74ws01oq3OjKTOotP7T4/ZfIj/cfM2z6AukT4T5jAbN/IbhrQyn6pLsyIDcgWis4vDNKFPCm6KNG/Irevll3gkwWgzx1z+ep57NNS1oZFznWzc4zA/6yQgJAeFOcGzHpha6RavES62ESlCpV23qWZKUXWkb+OvHTqrEG4k67Ex3903RFEcOd8+wN1Qeqdn7VTUAl4Px6MBsg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ust1zRCtsAcxQP8w7YyOhNG2l2jsvao5CNomP0mQlRo=;
 b=iF5SlNLSf0xJKw0f8LkJiaB7ClS3WGmVfrHT9B4UPpUVbyQPthvcGdX7VZLL08SmC9Y672wygswjshGtbUumDoVqbXGv6Y1/vcfpLhP+hbdmC0tk9mQFDbo/J5hdRYX7qPC6pziKx7VU73ynPbLbmhX/nPxIfav6/Kl8eAQRuKBgvQU6SAX4DjNXoqaPo+UK/VxjsKE73OWAUIzh6loLvqAd5nVZgx1dLVuR7Wmhve8ZI748sk8F5mylRH/DEC9CwtArSzhrjzvsmxaKhnToGZf6OeFG/94t+ZDgOxWfl+M60s/TRLoYpdLFhgXtaQlSj17WhUW6aQfkq949j2B7Dg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ust1zRCtsAcxQP8w7YyOhNG2l2jsvao5CNomP0mQlRo=;
 b=cbvwtAazeSpzsu/7bd2uTLMMmD4ltsPheLyb2a7L+XfPgWs3wP1NkMfEclLbbPpsT67J8aGlOeOV5TFKa4hmj+uLm67vq0/Ww91OmOAptWGIUQGeloa2cW6RxLYGQPRjvBH3FOFGSXfdKgQ6aWlkJWRQYKGo4zHywpYEFMmVqFo=
Received: from CW1P123CA0017.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:292::17)
 by AS8PR08MB8947.eurprd08.prod.outlook.com (2603:10a6:20b:5b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:10:10 +0000
Received: from AMS0EPF0000019B.eurprd05.prod.outlook.com
 (2603:10a6:400:292:cafe::c) by CW1P123CA0017.outlook.office365.com
 (2603:10a6:400:292::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Mon,
 27 Apr 2026 16:10:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019B.mail.protection.outlook.com (10.167.16.247) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDHKLEer43VFZNRKwUpJ97HBXTJoBxROwXcuYe1DIKZOSF0RbJh+qvzXVVCldMTpIs85gO9BpkGDMP3qHYfaj38KY+yJGDYF07zTk8FVwMvimrw59fkAFGDxDjBUw3yDMuvGiyUMF2JYW7MGIXs/BaOX6PsQy1B3KfD11DoPPBbNwA8vE238jpeuxq3NC4M2ysRaOW/BYqhsqg/znplCsZx1VIKTqrNOducDSFdwckdtFNuw/nUQbPglZVD8nZ4ekZsoEzw6I4kYGiqPYbusgQcnGRW5YrOG+K+FaycrJl6cQzSGjcTWB3z6wQw4kRcit2naQCR/yeDdqAoOKrFObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ust1zRCtsAcxQP8w7YyOhNG2l2jsvao5CNomP0mQlRo=;
 b=BSRf0XnSyiAzFWBfcg9zi6BF6n3KQ4zp1oEWYCd93R1MVsw/Hf5FqQjWmC30eMdA85GRv2OFonn/XnFpsPDBAuE3PArEWlh5bIzrXQn8YKDe5ptw9elfT2I7EWzVYrBOtsGsEkP/qSoJesfcV3s59tFdF2RiUXdEzXemgthaTkN2iMkNX9rc7ngiDNxvWpq350b6mIjGeZHPwngEqcFr6arKT4fr6JKPgJutOhzZf1CitSWCfMHn5hvEc2B0BEWTf2MLqFcaM0oSj3cg7NeVaXd4tuEqcBdMQDNilCgJR7w1kYQ2NFQdAlF8C8Eyhp1MSzhqZA3OiM4u3wCwcD9s5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ust1zRCtsAcxQP8w7YyOhNG2l2jsvao5CNomP0mQlRo=;
 b=cbvwtAazeSpzsu/7bd2uTLMMmD4ltsPheLyb2a7L+XfPgWs3wP1NkMfEclLbbPpsT67J8aGlOeOV5TFKa4hmj+uLm67vq0/Ww91OmOAptWGIUQGeloa2cW6RxLYGQPRjvBH3FOFGSXfdKgQ6aWlkJWRQYKGo4zHywpYEFMmVqFo=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:09:06 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:09:06 +0000
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
Subject: [PATCH 09/43] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH 09/43] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHc1mAsjEfZCW9CsEeNM31Bz6Nu2w==
Date: Mon, 27 Apr 2026 16:09:06 +0000
Message-ID: <20260427160547.3129448-10-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|AMS0EPF0000019B:EE_|AS8PR08MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: e30c927d-10ec-4dd3-c4a4-08dea4777470
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 3D41SxLVwB9cg6clTTn9jwRE+6FbRqkbWKGqn06bql20WrTs4hb7PfTkOoVRJ6usRhdDbpJwxFqD4KAZdluAAgEKkQQCbtEqLQ72BB9rfMhukSupNSGIm7gdNDIg5JLRu8zyFSZC3CeopbN7GWP6+AiWZDTrSZqXEMLDneEJuA+U/JcTAjhp0lo2LTsPG8iSxAc+8k7iJOY62LEkwptEvw9Xkx6/6MtGCp3cHjsrbZnwGHUPDFq9b7x0JSwy22LGosdOdkPpcgjlef5BwrCAVYNupJasT/megNfAMnaTBKH4CA99dCY2IouJWpVGniw/AiuwBkCHS2Xcak5nHsgFS6ux0biUJOGMk+yuPReGXMRXmRikCfoKu1GJi3XK0W6B9AMiCjufq/yxjSd7q5GBFWtZwNfVJ2sjxg8DBvuig3OjFkB4YyTSYQqKykuhasNzA9/eb+AcyjyT+mKjPcFdSz6C2m+HCrRZ91uwzZAuGMfUKTxCgFuhcDKV3olzVrVEBhtCBqzJoG5BsQ8Yp+2bM6qENsSlyEpnXUF8GIohtBMxzwYfkeMvzEaGsMJQMAj1OLZcMQRT8Svz3MztWxK3V4EKtSSBKfB8nfMpCwOhV+jxR8W5g2u22t9rmf25vu+Jz7f4nJdSe9c2E7btQb6RtMsIbCOlFKMDoOr9ZynNZOmT4Q0Km5feqoQTvlmFzr0oqpKCROU66I5WCTBYcQfj14zEmtAkPZYt1ZuFKrpcJk7ZOuLcJSEoH7FAzAsjt0Haxm65Qf2gaJvuJxnJ7MeVNlycpPG1v/BRmCHBanL7C50=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 SWqn45Uu/Qm7B4B66CjQV1YVyg8I90W+fLPAch5PpcyXvk9/BRKRpn9plDEiw2j8Qf47yF8Q+zIkJ5K+rn/lttaz+60gMkdHefpoJs7iOQoQWwOgUnU8iab+a1iMAe4++7mnBAdiegt397vx5Rc/ehlUOhZU++PJIx4CzsOmnqKW02RqEn40UxvmWBs5qayASgww8xWHB7ugspLzkDXvCc3WPHUpNrEpCV2Z/GfGcvOzV1N17f3Csz3rMLTnVfpoToI5LGHSH2cJkWN5fmDY7DkSuhZtbhWwHmZw7PgbDenGEUX5nGbMZy0ghPCo8d7TtaQdvCM1e4oPqgZ95vNKjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6c99dcf3-2219-4dbb-6500-08dea4774f15
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1c0/kk1JjEe2cXXU5QwEmoEzjC0jvMRTbhQwYy6+F2bcKTFSPmUxofcvhkLVhcKkNo6wJ1OwtReFqotC9gRuawfPejhK6D0eZF9A/6OfVJ5XyBMM9RXjca40Gaaqah99AFl5l6aaHJbRZrUWHvRFTIEkvP/9UNj17GDiKGoUv3DZDpxYe0w0YAIU12xXdy/v0xOiiJWTyG/a5UGQf0ftGuGx3/XtA29SGA85fkypmXVZMx9WTSxNl1WpGUAdddmKWxoEBQ1/WnCdqaThIvd+aueoSsEPJCJ6/hwpHpq5lewOHXuz4R8E3olI9Pu6tNl+mlPw+yV1fXqn45VSXhtAIAHs9RshwK5w/8/4QbrAuVnZzUlh131YEVAOE1UnD1hykSFrFzt5NYXE7de/GR61EnyI3rp2xPKXRJvUQC1SoZTbL4CBG2ZaXqbPaMJj/EP2fmSFjgiDseBXeI4wNh0qFSs6qEmT7wYogHNrfED1dJ9d1fLtcicnle+7+EDpRs+MusnmR3oqAD14Bz98gdl/j4IuhPr+n0qINEGDS/PAn6pheVFPHt+oY3QKyZjmyvkKOTixvH8Wdb8VzU6j+Yw/LtOJr2E5/CEbHzedSIR0Q04JRQ/JwUgRo4ND3ZPvUOJO/wjbTAmtZe0e0Thdb5mnIS+ZTmM9zwBLPEvA9MhSO5CilGS0LW2DwmTmEXtZ+pr8+Mz4BFJ+yizDEGcyDyAlDRbZS3g5N9t6RR1T/c+WXiweRj1hg6Aecc0trLwmWfDv7a9eoJC7UTul9KlTBWhqNg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1Ouzq9/4uwoDRAzUdbK1OOsuwHF4nbcRNQDQXkO9KSlQTRMl5LHyZtJMQZGtBldWStMSd5Fqc310eXyUX/NMsE95n10A7pxry82EtAJv+Fx5mqICO6ijha83HcPSwDl/CA2TEIqWj7Q6eSaegrEeXmc7mlvKk4HbupdmaIK5CiSR3Z0ioi9gsq/q8wuVglb9kEU50W/9Jx2okeWnMf/zTdxeXhaAELe7/AVxNnXJoBYIv/TA1+ptJnX+dWyhYGEgPQ3QVNtEaDXSDWxisjvGcPEyZ8w4AVnSjj+6UUo7EwRtX1rq3P1YwnXX4YRX22OLsbxB/Nc0HFXNsA0TbGoonlH2SIFXdz+nGh9KJJe6VKx16u6Dt5ELvtsv5LE0pwInJfuFuqbXQs8WPm2ZwvjnoxfM+7jI05xPoiKAbf12x+bs9bYOUS/1W/QoN9s21JYS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:10:09.3769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e30c927d-10ec-4dd3-c4a4-08dea4777470
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8947

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc, valid.

The hypervisor is responsible for populating the VMTE for a
VM. However, it is not permitted to write the Valid bit (as the VM
table is already valid). Instead, the VM is made valid via an IRS MMIO
Op. The same applies to the ISTs - they must be made valid via the
host IRS.

This commit adds support for:

* Making level 2 VMTs valid (only), allowing for dynamic level 2 table
  allocation.
* Making VMTEs (VMs) valid or invalid
* Making SPI/LPI ISTs valid or invalid for a specific VM

When (successfully) probing for a GICv5, the VMT is allocated, and is
made valid via the IRS's MMIO interface.

This commit also extends the doorbell domain to allow the doorbells
themselves to act as a conduit for issuing commands - this is similar
to what exists for GICv4 support. Effectively, irq_set_vcpu_affinity()
becomes an ioctl-like interface for issuing commands specific to
either a VM or the particular VPE that the doorbell belongs to. This
change adds support for the following via the VPE doorbells:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE (and hence VM) valid
        VMTE_MAKE_INVALID - Make a single VMTE (and hence VM) invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

Note: It is intentional that there is no SPI_VIST_MAKE_INVALID - this
cannot happen while the VM is live, and given that the SPI is
allocated as part of VM creation, there is no need to make it invalid
again until the VM is destroyed, at which point the VMTE is
invalid. Therefore, there's no need to do this via the host's IRS MMIO
interface, as it can be directly marked as invalid and freed. LPIs, on
the other hand, are driven by the guest itself, and the guest is
theoretically free to invalidate and free the LPI IST at any point.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  25 +++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   2 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 236 ++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-v5.h   |  30 ++++
 4 files changed, 290 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index de905f37b61a5..0120c3205dea6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -666,6 +666,26 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+phys_addr_t vgic_v5_get_vmt_base(void)
+{
+	phys_addr_t vmt_base;
+
+	if (!vgic_v5_vmt_allocated())
+		return -ENXIO;
+
+	if (!vmt_info->two_level)
+		vmt_base =3D virt_to_phys(vmt_info->linear.vmt_base);
+	else
+		vmt_base =3D virt_to_phys(vmt_info->l2.vmt_base);
+
+	return vmt_base;
+}
+
+u8 vgic_v5_vmt_vpe_id_bits(void)
+{
+	return fls(vmt_info->max_vpes) - 1;
+}
+
 /*
  * Assign an already allocated IST to the VM by populating the fields in t=
he
  * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
@@ -715,6 +735,11 @@ int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr=
_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd_info.cmd_type =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID=
;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd_info);
+	if (ret) {
+		WRITE_ONCE(vmte->val[section], 0ULL);
+		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, false);
+		return ret;
+	}
=20
 	/* Any cached entries we now have are stale! */
 	vgic_v5_clean_inval(vmte, sizeof(*vmte), false, true);
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 37e220cda1987..6a024337eba79 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -150,6 +150,8 @@ int vgic_v5_vmt_allocate(bool two_level, unsigned int n=
um_entries,
 			 size_t vmd_size, size_t vped_size,
 			 unsigned int vpe_id_bits);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
+u8 vgic_v5_vmt_vpe_id_bits(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4e0d52b309628..49eb01ca07961 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -36,6 +36,12 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+/*
+ * The IRS MMIO interface is shared between all VMs, so make sure we don't=
 do
+ * anything stupid!
+ */
+static DEFINE_RAW_SPINLOCK(vm_config_lock);
+
 static void __iomem *irs_base;
=20
 static u32 irs_readl_relaxed(const u32 reg_offset)
@@ -43,6 +49,21 @@ static u32 irs_readl_relaxed(const u32 reg_offset)
 	return readl_relaxed(irs_base + reg_offset);
 }
=20
+static void irs_writel_relaxed(const u32 val, const u32 reg_offset)
+{
+	writel_relaxed(val, irs_base + reg_offset);
+}
+
+static u64 irs_readq_relaxed(const u32 reg_offset)
+{
+	return readq_relaxed(irs_base + reg_offset);
+}
+
+static void irs_writeq_relaxed(const u64 val, const u32 reg_offset)
+{
+	writeq_relaxed(val, irs_base + reg_offset);
+}
+
 static int gicv5_irs_extract_vm_caps(const struct gic_kvm_info *info)
 {
 	u64 idr;
@@ -84,16 +105,22 @@ static int gicv5_irs_extract_vm_caps(const struct gic_=
kvm_info *info)
 	return 0;
 }
=20
+/* Forward decl for cleaner code layout */
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base);
+static int vgic_v5_irs_clear_vmt(void);
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
+	struct vgic_v5_host_ist_caps *ist_caps;
 	bool v5_registered =3D false;
 	u64 ich_vtr_el2;
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -114,13 +141,53 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	if (gicv5_irs_extract_vm_caps(info))
 		goto skip_v5;
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	ist_caps =3D vgic_v5_host_caps();
+
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artifically cap as we
+	 * can't use them all.
+	 */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(ist_caps->max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
+	/*
+	 * GICv5 requires a set of tables to be allocated in order to manage
+	 * VMs. We allocate them in advance here, which alas means that we
+	 * already have to make a decisions regarding the maximum number of VMs
+	 * we want to run. For now, we match the maximum number offered by the
+	 * hardware, but this might not be a wise choice in the long term.
+	 */
+	ret =3D vgic_v5_vmt_allocate(ist_caps->two_level_vmt_support,
+				   ist_caps->max_vms, ist_caps->vmd_size,
+				   ist_caps->vped_size,
+				   kvm_vgic_global_state.max_gic_vcpus);
+	if (ret) {
+		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
+		goto skip_v5;
+	}
+
+	/*
+	 * We've now allocated the VM table, but the host's IRS doesn't know
+	 * about it yet. Provide the base address of the VMT to the IRS, as well
+	 * as the number of ID bits that it covers and the structure used
+	 * (linear/two-level).
+	 */
+	ret =3D vgic_v5_irs_assign_vmt(ist_caps->two_level_vmt_support,
+				     vgic_v5_vmt_vpe_id_bits(),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		vgic_v5_vmt_free();
+		goto skip_v5;
+	}
=20
 	vgic_v5_get_implemented_ppis();
=20
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
+		vgic_v5_irs_clear_vmt();
+		vgic_v5_vmt_free();
 		goto skip_v5;
 	}
=20
@@ -148,12 +215,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
 		kvm_err("Cannot register GICv3-legacy KVM device.\n");
-		return ret;
+		/* vGICv5 should still work */
+		return v5_registered ? 0 : ret;
 	}
=20
 	/* We potentially limit the max VCPUs further than we need to here */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  VGIC_V5_MAX_CPUS);
+						  kvm_vgic_global_state.max_gic_vcpus);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
@@ -163,6 +231,167 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VMT_BASER, IRS_VMAP_L2_VM=
TR,
+ * IRS_VMAP_VMR, IRS_VMAP_VPER, IRS_VMAP_VISTR, IRS_VMAP_L2_VISTR.
+ */
+static int vgic_v5_irs_wait_for_vm_op(void)
+{
+	u32 statusr;
+	int ret;
+
+	ret =3D readl_relaxed_poll_timeout_atomic(
+		irs_base + GICV5_IRS_VMT_STATUSR, statusr,
+		FIELD_GET(GICV5_IRS_VMT_STATUSR_IDLE, statusr), 1,
+		USEC_PER_SEC);
+
+	if (ret =3D=3D -ETIMEDOUT) {
+		pr_err_ratelimited("Time out waiting for IRS VM Op\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base)
+{
+	u64 vmt_baser;
+	u32 vmt_cfgr;
+
+	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
+	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
+		return -EBUSY;
+
+	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
+	if (two_level)
+		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
+				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
+
+	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
+
+	/* The base address is intentionally only masked and not shifted */
+	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
+		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
+	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_clear_vmt(void)
+{
+	irs_writeq_relaxed(0ULL, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_vmap_l2_vmt(int vm_id)
+{
+	u64 vmap_l2_vmtr;
+	int ret =3D 0;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VM as valid */
+	vmap_l2_vmtr =3D FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_VM_ID, vm_id) |
+		       FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_M, true);
+	irs_writeq_relaxed(vmap_l2_vmtr, GICV5_IRS_VMAP_L2_VMTR);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int __vgic_v5_irs_vmap_vm(int vm_id, bool unmap)
+{
+	u64 vmap_vmr;
+	int ret;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VM as valid */
+	vmap_vmr =3D FIELD_PREP(GICV5_IRS_VMAP_VMR_VM_ID, vm_id) |
+		   FIELD_PREP(GICV5_IRS_VMAP_VMR_U, unmap) |
+		   FIELD_PREP(GICV5_IRS_VMAP_VMR_M, true);
+	irs_writeq_relaxed(vmap_vmr, GICV5_IRS_VMAP_VMR);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_set_vm_valid(int vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, false);
+}
+
+static int vgic_v5_irs_set_vm_invalid(int vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, true);
+}
+
+static int __vgic_v5_irs_update_vist_validity(int vm_id, bool spi_ist, boo=
l unmap)
+{
+	u8 type =3D spi_ist ? 0b011 : 0b010;
+	u64 vmap_vistr;
+	int ret;
+
+	guard(raw_spinlock)(&vm_config_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the IST as valid */
+	vmap_vistr =3D FIELD_PREP(GICV5_IRS_VMAP_VISTR_TYPE, type) |
+		     FIELD_PREP(GICV5_IRS_VMAP_VISTR_VM_ID, vm_id) |
+		     FIELD_PREP(GICV5_IRS_VMAP_VISTR_U, unmap) |
+		     FIELD_PREP(GICV5_IRS_VMAP_VISTR_M, true);
+	irs_writeq_relaxed(vmap_vistr, GICV5_IRS_VMAP_VISTR);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_set_vist_valid(int vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, false);
+}
+
+/* Note: We currently do not use this as we rely on the VM becoming invali=
d. */
+static int vgic_v5_irs_set_vist_invalid(int vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
+}
+
+static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
+{
+	struct vgic_v5_vm *vm =3D data->domain->host_data;
+	struct gicv5_cmd_info *cmd_info =3D vcpu_info;
+
+	switch (cmd_info->cmd_type) {
+	case VMT_L2_MAP:
+		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);
+	case VMTE_MAKE_VALID:
+		return vgic_v5_irs_set_vm_valid(vm->vm_id);
+	case VMTE_MAKE_INVALID:
+		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case SPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
+	case LPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, false);
+	case LPI_VIST_MAKE_INVALID:
+		return vgic_v5_irs_set_vist_invalid(vm->vm_id, false);
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
@@ -174,6 +403,7 @@ static struct irq_chip vgic_v5_db_irq_chip =3D {
 	.irq_set_affinity =3D irq_chip_set_affinity_parent,
 	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
 	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.irq_set_vcpu_affinity =3D vgic_v5_db_set_vcpu_affinity,
 	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
 		 IRQCHIP_MASK_ON_SUSPEND,
 };
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index ccec0a045927c..ff5ad653252d2 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -87,6 +87,12 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
=20
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
=20
@@ -181,6 +187,30 @@
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(51, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
 #define GICV5_IRS_ISTL1E_SIZE		8UL
=20
--=20
2.34.1
