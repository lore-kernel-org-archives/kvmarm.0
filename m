Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5009E426EB2
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890469; cv=fail; b=YrLOgCj+mhGbY402GwCTW4K1/R2SvsrazmLx+cBNuRhBhZfKU2CM/Yuq6aiktAdlnGH9TOn28SyMWErigbv2tmce4cXMmgHsMPEoYUq+AMcfnAyEKzFplUj+008BMi4pr8DQj/rnTGry0huCnSfMQEFSLjGfijNLctaucl+1kPQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890469; c=relaxed/simple;
	bh=cgLTExn/0dTE2MV3XP573SDzRp1xA9leFLgiPJ05S6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GDDA1FU2KLg6/k6y7cuIj2CDGwh0WlY5NLBSBHhc45LkMuJWkyEl8rbVb00bhzACCFc/a06mElZoi9yu9M4sYetWit9v5F4Hd1brKoEX+pWGgfdlxpApnJC1Zuf0+InN0itd2VEpg++wPNUphXZ/I6KEb8Pt41RoF9NfxxZdIp4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Tzi1rNdg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Tzi1rNdg; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Tzi1rNdg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Tzi1rNdg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SSZv2WD+uaR80n7yHTQCrST63RCrF4n31O8Rx6EGViYNQAZUtCfgsz61Zx37j7kcgowoi8WS91aYyWtn9KNcYPCFoDYiiItRRJJvpMICIPReKLWcI5D7Cd7PStbqd9DbCuh4sqey1uljX6KHsR2BSvz5jQGBAXsqI7xUkPf7mikhzaaiCCQA7W2aBisgU/7NL1ujcH7RjM3rULvOMe4OEtCdcbbh+xSS/zIJ5gZq8vC8uQJyniRp4wiBZyxbdRHTEyp7BcElu1TgaqDZnLrPbecO+LEhTw1ZDN6m+a4Q/QvNjOFYMwiaQTQO0k4zKoGmzsTQ7HKjg6thAUlA8Y4+6g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=sj7Fx5rjc338jjpvUFccQlOOs4yLgJiEVI+3d+IAuYOLAgnduvH8ES2HXJPcKSIZ+/KKazUNnOyVE7MrtbdiXm+xUuIQR18/fouuJu10gpJm0Wcy1VDLH+jvEIvULW0ocx485yY+YHfvLNoAlhsXQOiegyToOh1F1TpDQ1C0D+KhEYOf+nPUP9dkJFYavgNCfK1qaIFwj0ggs4VtM+d2qzKJlYRd96pwDl/NbSNbiJ61850eEx3gI41Ihxs1OoHoifM/+BPP7RpAA3McsZvU87HyRUzs4D+WFXwdJ/BS5RH66CuBzQW1nNnnDqkNqxYFm1ri66dVrggaMDXj7d4I/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=Tzi1rNdguEpUSFgjOw2jgdEUJfVpvoIhqe6mE5J7s2raKkeubkTL504fccIHoeFZQX/MkSgakG2NKh61n49nUaJ8kNnPImH4+Ilg0jXCLZ2K1jd2ut2A4oYr803iBs1Fx7a0jYSXlY4opE/M1OrCfqWCbnVvyWRCD9NgGh+hwJM=
Received: from DU7P189CA0024.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:552::11)
 by AM8PR08MB6386.eurprd08.prod.outlook.com (2603:10a6:20b:362::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:21 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:552:cafe::5a) by DU7P189CA0024.outlook.office365.com
 (2603:10a6:10:552::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:54:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via
 Frontend Transport; Fri, 24 Jul 2026 10:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v2zvJdDngnPv5i8VixCgsmsisznX53Te0Ka+llNUpksDNe4tcbIlsFQX3jmcgMMtReKFcC1ZZIfI6hoaKPvVF+iFhCBu6iV6zbxMNGsAKDE8MPxshqpyEdA8WD0AfnCGq5W4DGLJ8Q0QKTxXy/knH8OsZJyl/4ugtxlbtAGxeqMC8luZG8EZJPedWzTJ6w4H2lfafCyWtt9hXNuzXwL8ACQzoCU3jvyV3SIEG7uXENelhdG4MaZqdI6JAZp4GGYnOjkjGrIzm6mD0e0e1xPq/MzIMxAZ/22WWoSF7v/xPqEXXBcyXmeqYEMxKVJrJrzOvEOnXb8Ujz8/zYl23I5SIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=BD4pWTDJUWAJlhmXS9pB4VKpE5UHzyPf0y8EGEB7eg6IKaw3WF9poVIqzZtOW9nQ1aQgAUqV6t/kXkM5LqgezdFb2FqNxZxq/FG2SZ24dyUIpP7N/uv0LFbh7UQqXvH9Ense93bdcXjTGvSVPTRLYEWZ8GVbhriETfomJNO5XK5o4bGmmYk2Kq/BhMxW5vewyMezCufEs8PhfY8vKUc6nD5qsRmfjJMIlT8QpKcokgyV/h+ocpok9jDVB6TsCwkzMQfA6b07H+Lf5MQ2Wi0KKl3sYhXrqkUVkvWlCPBbllw+AUAV5W+Q1JlBYUm+kt0nh94Fj1mGQJkCgsZFw3vvjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=Tzi1rNdguEpUSFgjOw2jgdEUJfVpvoIhqe6mE5J7s2raKkeubkTL504fccIHoeFZQX/MkSgakG2NKh61n49nUaJ8kNnPImH4+Ilg0jXCLZ2K1jd2ut2A4oYr803iBs1Fx7a0jYSXlY4opE/M1OrCfqWCbnVvyWRCD9NgGh+hwJM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:53:18 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:53:18 +0000
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
Subject: [PATCH v4 19/48] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH v4 19/48] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdG1qi9nc1ATSXo06CeaTJMPHkyQ==
Date: Fri, 24 Jul 2026 10:53:18 +0000
Message-ID: <20260724104819.1296803-20-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DU6PEPF0000A7E4:EE_|AM8PR08MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc60f97-9bb6-48a7-5519-08dee971eafc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 uM3arhWWdwcfVdDsFuc3O2rNiL0atTRSNzNujQ6QqTvd+NKro4B/m+EFDJHgCCTrUfzWwbxQOArfwyQqcOoJSkGCS5wZ5wHQ3cRBOcWYJF9pD1bAgNQHIouXZSubrDOSdXs0RQw9K+kuzzRnFDcV2Y7SjAC7GHi/vZAcdoqiirTsJF1tHyz3tn0C8Ya1piWtDUsmizKA+bwcDADj7XxKarj9P10Bj/YPRJL1vgK0znd7xWF54gqQyi4Q9pVIPeg4RBl8O9+LbgrrglNwnF18eGU4jNTPZI8mrqFY1UHX6gKpfRe1KL87D81gLO3a3HTwJ9PmqlFGvK2snt6iy0RHYrCc57G6X2iFRSih06D+ZsC7EaJNbLhF7X6BGIahSF+/9aCthVlxcLb2tk69aOLiMdwDU2P6YlFtgpbQtUdZMkxYsMTFCrE9fECRR/lOAGKSVWZuAUfUNxlnUDr7ZQ8mJW87NviGeLPgU1Z7eu5Gkupff4omu73OnFbgDc7JrYYdroB8sZqJcwMq2mA41P/8NqmRS05gU58EbLTHwEyO/AbxdJGdqIc/CQuXUTrXYEsgTxB7z7fuNBTny4Pm/7p6doEc9TYmjItmoqcD+z8OgONkQoJxi0TWQ0XogcIvV7NupxbH/KD5JntJ6x0VhrljZp9zN82SW4+ADUZk1ywV7fRMbx1pJTQrLytuxAb+j/bp7GFy6WSq3/3wV+UNHDClE28VTYgjzzgcicLWXB6XwM8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TfK1Q0tI3MNFHGHu+jYwoeRz4GqdR3VFESu5M3J6MkYnRhSf4L+hVuzVSc0lfLyU16I4VC3eh0d+vkM99mz8IIbO6QbtVQnF/Tu5xPT3VYz8Q3Zh4ZSqyNI3pPrU9NpC1Tgqb32BxU53r6iIPaFZi9oCmQDwE1Ftmx57sWmTlbBYRJ9FfId8T/sf2JKRCH0jcVGTGYX8MTzIZ4W9lJVQ+5I+4LcEKJBhNXjJKMNXzbQ71AbQ8E5qJP9cL47Z7BFM+1NCxNLNyj9hl8aWx7MUsIIJ3C9IbzzQ2rH++3oo/ul78aQ/Sivl+dgA0obrPXm12/MojMVkkx1WT9mW0Twa3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5db59467-4b65-43ed-e4e6-08dee971c54c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|23010399003|1800799024|36860700016|82310400026|376014|56012099006|10067099003|18002099003|22082099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	BhqZLblNkNwn5z94fdEHgakJMClGJIAL+00UuyQ8kXBnow6AhlcX60baCr3PwbVHmIqz8SDyTIEg3HT6saR1JFVtjtw07iB4TIk6xbp0JfzgHt2SeXVG914dBUQxrkzycm1gaInGoJZRc/YFwp3PNmMdHdrdZp3Uw52J802KSt3xOKwp+nZhjDEOoisn/1HmzdydXnaxHuwGTnWkYy5q85GG/Llt6SfBXFHCux5JmlGv57B9dGRRq4bxCMlWi1HET5QoYtpsfK7nW1XqqoAySJmslA0Arh4dKA0WTpm3wd8gv77iZDIijG/Q6GfMeOTUOh+dnUo0n7cO1JyLe39nHAeK372PpnNu1M7uSyopk8DEE37ENc951tt6HrCBxo2AoUaGwJJoQtX5YR/9SFi1Lpou4/Y2XZbB19X/xO4z3SmXJEQXZWSa5Ajl81xGPqHDG+vVuj7bl/wPp8McdK7BceDzgwqqhvM8OEWltZZRt29DeoMltB+8CIwIUE/oq/vgYs32N0kGsJRlVUakJcgxtChq0uuOYIBe6YwjGG7icwmsUBdxZ1VZfPjmUwCYFzgKkTwOWKENonJiztYvYF7IlUP8qTWQQYhkJiCpu96ZhwLgEt27tc0rk3ypRlKZuebU9L62VDgWK0bX0f1nqMrIr7mM7kTMcOY3M2hCYzVUJgVan9s1XYo6eO4B2vWnIxsZGyDTJ9ExGx4veLzCmC8z5A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R3TkkSpDtkGdpvFssuDN+Z8N5wzkE4NWeVN3SWR2bw1HZp5gcNkSeuqaFgKswT6o/vkr1umzFDDHDiU/WmIKVFKXqWR1I/COifGWKuMzte+5lkA+Pcoxn3l0RsgjlFF7vFL6DKZ6UfECmzo6+RXma7moNLM3HSIg2Mye6SjT0pAoTTWRkM3k/C04ji3I5W0BougHMpJs1jnsT8XJ1Ym3tdh+EJClu3gdwnSjuhtvwxe0rKtk2rfghBAebkmO2ShCjE5xz+KCymh97OEltMxGlCZkZ256uxCQ7z6zImbpKy7fytPIHTPW88V5R/SEBuhmG//i85M6FY191r+dqXaLD5nFdcVr2dm0hnPv7JP5y+zPBRFXbsX8Csom06OdmHXHOfvrtK7dCNO1pTFMZn78MV5FXkS/nlK0kO6gbud2Uy44CtjJz150WI2m2MFpyj54
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:54:21.5190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc60f97-9bb6-48a7-5519-08dee971eafc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6386

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 5 +++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
