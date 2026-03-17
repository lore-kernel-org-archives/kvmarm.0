Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013034.outbound.protection.outlook.com [40.107.162.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C203126BF7
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747997; cv=fail; b=ST4WqtwhRtzk+XL+Isa0BB5spnSxSMbaHXPpL4TvaWwAhoU3KUFc6y30U8QPWZ7zjVAGM2oIxsTLca7nMp/J91wr4aBwelSZEKEORJx/ad86RSJwS974LUDn3MwRayIV2toi+0WMcJ9UJX8GkG8WBMg+9p6vloezxAP3QLnPUkc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747997; c=relaxed/simple;
	bh=/upcrM4ktByG2dQv37qKHwekr5o06nGvc8ZyTired9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ctLeYJhEsk5fce3MF5K+GFt56Aiz/QG/Tq4Dy52FwpBU3RTX8RbTVsP6W9YY8GRVvi0g/BkMxYkrtiQDHKvDaQunG5+z1FNMJl619HGqRxmyNBwvQvaWfboFzrNELnZw8cN9bU6Rm7xpf6CnkdU08/Qyx6km2nUt2SI9Z0DI6p8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lexvhd2F; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lexvhd2F; arc=fail smtp.client-ip=40.107.162.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lexvhd2F";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lexvhd2F"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vsTHwjrCKTF3AbgpBRqLwxVMvz50CGr/vf03ZiPWyy46S1iJ5PukESi2Qa6jHUqVmqHpzCxUTHGECji9ZPK34CZPcOyEo7dNlebYTkA3ZhFFbjsrkoTse3XBfk+KWyHLu7Od8Kit6voRc9YDYweLvJuklFUmgYxbJ6hBQoNT/w4Yq7+4cswQarT0wz965EBbLk0dTFFaBNVs+uo4Tjgb4Co5SNbazv4/qfz2Y86vP7KtC3RrFYeTB8pB/Zb5SxjrK7yAoN52/uTFwHxseT6qy2g+iuA6O8ix8ueViEc5rTEeFGL2uUULaL6CVPQ3ktQx4q/X5sir3H2tucOTJHfQoA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFs9wuXInKH0QrnRPoInGyoXQAVpoAWE14cdHiLdoCw=;
 b=vi8ooZWBvJFUxBUsAry9aP8QrfjGKVmbsWOmy9Hu/LwHrCCGuGWQ+xZgfXRYqiFmJcdu1ac0NjQcv44B0EHiSkMCYueUYZlPNcUP/N503SXuyQwF9G52il8LqelQGJw4VVBfOE9tfA0A7vuWZL1QiI6vUuBmTqy/nPm1Ms/4hJY9xnKBvj52DN5LDVjPV1sknOYUyfaaruXuQaUm/DBRN1YBC40i0IXsV08oZAfw2R4aCK+Zw7ov5fLGUMydo4Yly/KAJstNqBGftQG2sX3ROkpGnszmup7a8u/gKYysGcpIsNZmx2npMYAlt9lkas55UIpJAmQeUpwBMGkhJ5bvcg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFs9wuXInKH0QrnRPoInGyoXQAVpoAWE14cdHiLdoCw=;
 b=Lexvhd2FK39gOfqTr69cqPOjoOQrYKI1Umjld4Ej4eivhnbwsBPnhL8u45jQkEjkO5dvkWZBeaq0vR8Iq7kelJPDK/LnGUlLHDnPOAnQu/jtti0GnZGtru8kEqWfzkDYmasFVlM5Q+9+pBY1g1X/U1EPYcFjrp7OnxkN6Z3JpZk=
Received: from DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13)
 by PAWPR08MB8790.eurprd08.prod.outlook.com (2603:10a6:102:333::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:29 +0000
Received: from DB5PEPF00014B89.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::f) by DU2PR04CA0278.outlook.office365.com
 (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:46:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B89.mail.protection.outlook.com (10.167.8.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:46:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F//lYnkCJYSQ7HgCFroqwvOSnJEBxo10MqmLGp6jJJc1SGTPNwZAZIX54G+FtNidEurPjTuo7lPQ+oA0iMRQqATVQglUhFvnndEZm842NsfoxvtLCE1Kfw7/9xRdJ+S0CNg2HhqqEDtYmJlzT8bDe/L3S6Pi0TD13gsQvZ8yc73fUEUaM6RQWlsuPjhIGasvri1f8q4AFyX2XzYbQLYUijAqdru2B04bpS8Zpi1Qiz91qLV57+L8vBzEWewl2CXdw37CHOU7+6z/dn5T2y9foyYY2aBN2+hjoKqlVIIC6QsBlpcD9oKYfBvgJ7+CSrt+Z2X9FJdta0iTVBkZoHJTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFs9wuXInKH0QrnRPoInGyoXQAVpoAWE14cdHiLdoCw=;
 b=OKIYOLKaq+7ytjhxGQYEbxoV7W9uJoeQmUaF5I/V/4af9gNjLZIMtpHWw0cUYNNt0mQEPMANsZIQQGbsC1gL7Ka++8M2LSGmRN7P8sZyviNaO/q8HPYObwzfk7ULcyGgUNo7xqexq6PA06z9NAkn5w/fo5fXbBnoK7bOEqmxAJ3OLqQAh0RKng9kr3HlOD/gweP+T8Wt/vmlAsU4ueIzGC5l8SyPWOGE97md76Fc7qnd732bj6w+E65NlmfceTdJb8C6N1TpWVk5Zv3nt7d8qUCIUdF+KOSRiT4EPQSKBPIzO8Lq6RUMEbw56cHl2F3Z6SmVVJTXClj0z33HoILl3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFs9wuXInKH0QrnRPoInGyoXQAVpoAWE14cdHiLdoCw=;
 b=Lexvhd2FK39gOfqTr69cqPOjoOQrYKI1Umjld4Ej4eivhnbwsBPnhL8u45jQkEjkO5dvkWZBeaq0vR8Iq7kelJPDK/LnGUlLHDnPOAnQu/jtti0GnZGtru8kEqWfzkDYmasFVlM5Q+9+pBY1g1X/U1EPYcFjrp7OnxkN6Z3JpZk=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:45:26 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
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
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 21/39] KVM: arm64: gic-v5: Clear TWI if single task running
Thread-Topic: [PATCH v6 21/39] KVM: arm64: gic-v5: Clear TWI if single task
 running
Thread-Index: AQHctgOLX59M73sLJUeEZTfcw/G+mQ==
Date: Tue, 17 Mar 2026 11:45:26 +0000
Message-ID: <20260317113949.2548118-22-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DB5PEPF00014B89:EE_|PAWPR08MB8790:EE_
X-MS-Office365-Filtering-Correlation-Id: ad72866d-d029-4f8a-7fae-08de841ad388
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 XXxJ+IXd4d7p9Y4KDYzxW/hfm2Bl8nRh+a1QkTh1JbjuLyIAPShrgQ31vRqVEpxUkmQcn+7hLENf/5tfnsJrHmrkktgL0uaPNy6dKxsQ+LJzkS5bdzAccBhbIcRGCBsbXn+IP1YQJxjaEVkUMZd0PqBZQVDGMBmsD2W5eiWrKrFo83OTpwzNVk74wnAOnY+lVKH2iroOWEarPn49U/RCzKWkNqBTFnE6/R+hYwWdmeAl8pl06vne4tFDGPEvcx1CRf+fYpnAP7/mEa1VSP4wi+Es6lYensL1arOdBmFHl3bLZn4fzFllaveCS/2y5ds5SGUSmsB5IQQNzgpEwQNH503UN6uBnvj3fbNDH6tSGwP93GpKwGrPUGT0hL+Nj5slBpgGXp3xttDRB5aoXWz/1/LVupx7pKdjCY/sADNt4KKrRowhEVsmAJOYltXiYdEwMuyX0leqv3ZBpS84nVYpc+jHqcrHlTq1Fvfp89MhjRrKkmLl2aZw4R0xaH6h6FLhBpi1K3FedSBwBB/rpLSgzYhQalTSO+HXgSlar9L8PGOlGEO/PQCrRcx9bd52d99FDpltl2DQiNO6hh9Dd0rEZkH9QspCCcDrKviDNYBMPXrjT51sBpANXhWRMeMe74ofhVBfEoCCBfnq+Elyhac1eBtpe5/27W0jehQZbTJz4mDEg0uozUng1b1vN5XLY54mBeLsq3TlmcI8D14ODwu3nV8aciUtCG/zQXiNfXNvsFpglsLBo2Ql5qL6jz9lqpjphfGZ8dJgHg2nrCwlBukSoLlCQifm2WH/XN0J+dyM6zQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NZMws0UwUwR/184vZJtlwWjwJm5ZOwWLLzzqbUSQKlRTj00ZR+zbCBPiIyoswltvejw1+wBg0JCUPWSublNC22X+lJtlzbroHlgC6TlIspRYQCnyc+irwC6GIRMGUF4Q2FfyJsufN8wtLnDZBxL6FjV3lEwhl1hiYZqOajGfDi2YcHCngFIyhleKDUFXYlw5NqgkMGWb/Rgcnu6WiIuKU6y6j2jGPqwRU4XnqzmLZux8//UQH4umStACUAYePDThVGDACFMfu+oGxz2O4MIdorvoch2lZne2USdhSPo4RwkwmPZYphfWzib3Ycl5rk8pnsiRkOC56GesVB3A+L0T3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	77d2e44e-d684-4e47-5484-08de841aae60
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700016|82310400026|1800799024|14060799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	j6kfPUg142E9u8RkSS7oaaDDGA2dSeybMb9KswABZaGCdFoRI2dmXG0a6SrLIXvQTYy4zXraaPbGq8v6kjtMsm4CAcs3l7rZ462XWeV2zogDvwGo3+MeY2PdRxG91CcdP/FFAbFSqxuopdg1kCk3GjbBJfDQmf2x+n3lw+374VqN17rCxnNwpTCDuxmdYDlv98L/NmckNeVBJ+wHCBp66HF8NnorHMRp6RsjWzHYanXO34jBjQn+Kd2bnWSoS2IgWB9/LF0iOChV/nTpVjGiPk0cUATcJdoPTjAzP4U+gUqnLIUdb8Sxqs0a2BQHpcGtxfbJ4acj1aboH430QWz8Zlr6vSqg1Jeg2785Sas7ULoKlFJeSS6LnrDitoZ7u0qYmKPiSLYoStR+zeL54c6I/t+eL4sKZ9TVNqo4t0z0bEq9aqpiSvCMJ6IaVElKKqVEdbHzn5dCPoYGxeEHuESc/fYkID9CApxTj9eDAPxizu4G/h+kpxVbUWzdLgn9kCEi1g3xiUC5FeK5nFacK0nybToyb6mCDgl4+0LNFP/MA9Tw1K4thRzDU8/g0uZPXFgh2NLnmmxhE/yzDXUHzhPcnmIkEnC79b7YDgDLZcD8XPw+S37gQ0FXw9whZAnPk4SR9+QprEWVzXgUDp/NE9AF0D+CEHhiUTnM2XykqiVwhEdqNfk2lovk15RYQlVwyWBZAoWicSVOUUtIz5Yq2DfdVeEUoBw5ejiRD14fmBMbdURptqSHWuBjluzI1OnpvrWaptSevhKZi0mTPYZxQ9f7kQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700016)(82310400026)(1800799024)(14060799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/OZfS7LRx+KmtLcp2buklflSWb9ZSmMFXbg2HMbO7e9ZCNCbeJls8JLHhR5i3yoVqP0SDQyYMHVqXTViPrKPBNzO3vdFG3rC6aRgpnV+WUfKkgYG61qTHG1Ix7q7mwPay80cb0lHZTrq86O2TFfN86tyEtzDrEgvYLvlDeQXI0rdtFq0Zz68XBF+VJzp/PCt6Ob6ThXwd3yqhQ8FQxcs/i2L1FqUP5dyyAAgwK8JfLWSxEoFfzRVi5fJr2T+6n/BRxqmTr9wkGHexpcNid/3g/bdf/zt0G21B3YPaNEw07KsK6bLmP/B8Bv2RF90tSfjKW1JN6mGWS1UDdGNjJzWigTktWAtJHnH1iaDaHT6oXp7FDcSHcP3SPoHALxQL1Rus+dGdLWoMAs9SKIU6jojw+HQDVoULxmcdfX7aM0GyAZA5kgJ0ki/NImJA0F25H8n
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:46:28.5064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad72866d-d029-4f8a-7fae-08de841ad388
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8790

Handle GICv5 in kvm_vcpu_should_clear_twi(). Clear TWI if there is a
single task running, and enable it otherwise. This is a sane default
for GICv5 given the current level of support.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5bbc1adb705e2..f68c4036afebd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -613,6 +613,9 @@ static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *=
vcpu)
 	if (unlikely(kvm_wfi_trap_policy !=3D KVM_WFX_NOTRAP_SINGLE_TASK))
 		return kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return single_task_running();
+
 	return single_task_running() &&
 	       vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3 &&
 	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
--=20
2.34.1
