Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011031.outbound.protection.outlook.com [52.101.70.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B833E95B0
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935945; cv=fail; b=FIw2clL6KoN7U9knyINoRgzfqGHlDk76hsCdF1gWVmYTXvdK9f43p44ZCleTiowLKjRCfvJxnVh6ilcIK2ndBtO5sk6RPM7pJR7oEORZTO3Xh++n2oVOhgz1uil+BlS9NTJ2fxMa8rbY9AayCvXCN7DMt91LXvbxbhhhUaMOg7s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935945; c=relaxed/simple;
	bh=PIpVHqzV5QlEsXFaYSchGAmR1wIJgdJWIFxo/vNvQzY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PqLjMHTFXmprs460/dpJouXd7ApyrxWeq6csY58DYDoT6lIg8B20EXAv/nJjySDUzqML0+i8wLyXn6HFnWRTjdVXCC4b5s+gQk0P5uANRCZcBX/VtQfmurQo+bWph7JDdFphbiMSIeJA+8AiCT/3pqJ0zC0FgZCGmDbNdS5zlCM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p+k8GEj4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p+k8GEj4; arc=fail smtp.client-ip=52.101.70.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p+k8GEj4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p+k8GEj4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ve9wnx28yj9xe6BoKJx0M92zKtTWdVmn7gQ9fc6/nLmzHwRzrSyhmnGO8K3hvqvnaNvOA9/Ljfd7YLSz9ykleFQaM2rdXuVwvZtmwTUqNOg5GQvpCNJNEqdG7wCA+HRDbn6JW7aT7pVXjhreR9jVbLiyRuVXEY0Aaf8JR/mSLAw9gwYB7IEyDOmtG4sZQriW1R2M+mN8GXDphAEiSCMEAkXqEFB7gfVWNs0dU+Vz0skf4QJdFnpNDl3Il2aZ75lH4s5z0c2uOosbqGe1XKBfbVB02r3CcGyHbU6G++y9y2DAHVyYDhlo55Op4zmaup07xiRrBNl6IY0O0SldGioeSg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnXu3CZvP8rG4CC/Nj/F/rDeNrZqyU39i1LyY0a8Z/8=;
 b=aAlwDQs7gMXD1xhCJ6Rm+WeBv9pZ0gGlICL9r8GYHiHCZ4F3HsL8yTzq72ArntnU3/vO2tB6kfeoUk8Nx3TjW3c5auEmdx3i29AChudvivm5Odnupo22L9t9Zy4haoo1Ql1hYkrbWMZKJKvOpo43tC59RinBcgbjThicmJUzeRUjhzCbDT8j7FF70QubfiFHr1y2Y/EjmcyGVr754rZJkSLQ4Bgp3S3OdYCKByGC7IXDjlktrNQwEv2lp0oMjU7HCa1Y6UpFEP9O5rp4s2lkhy8mf7xJuUN71lh9ub0wdWPqKd/0wH38ZiKjJDqPV588MqI4BNP6eLNqzhjVtC5K6w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnXu3CZvP8rG4CC/Nj/F/rDeNrZqyU39i1LyY0a8Z/8=;
 b=p+k8GEj4ycK+HJYgEv0+nxPisAf6TtIhyTZVDrW/y77jQ0fXtKmTr8EgF1EwEiAH14Y0TmzdoMdqZGqk40vzE36GWC/iLpldWvrTMmI5fg02Au5Y875Z1dCUXpD26766vWAs/HDqsti7PlszGnVGC8phBRV1MfwrXbNcgBbj0aE=
Received: from DUZP191CA0032.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f8::10)
 by VE1PR08MB5678.eurprd08.prod.outlook.com (2603:10a6:800:1a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:58:54 +0000
Received: from DU6PEPF0000A7E0.eurprd02.prod.outlook.com
 (2603:10a6:10:4f8:cafe::ce) by DUZP191CA0032.outlook.office365.com
 (2603:10a6:10:4f8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:58:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E0.mail.protection.outlook.com (10.167.8.39) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Thu, 19 Mar 2026 15:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6sqVie9/onPK74WTON0tdDwoQJwWxM6YQJYqqm0ESWiXICTvXchQ0xgD5BreIXrDo5ZY0wn12YvWrTQwjihYOsvR0H5fHQdFGPMgh+OYkraeZ7iKWMYCAYtv7xQR/jEGT1HZdz0UnaJQ6vMnQBpkvfshiGi2lGMA7+qD8l45D0CukLBm60bq/bTXvc7ILLE3RzVF8ihHiSnx4WlIbH4nfoMIKF2/7QeFG9jhDSEM5DPvBhhcL6T74xWQD51DBRfcGgAXK/sJSv7saWkOX7Gleh73HN6T+KDHL7gsyu5xLKQSIALZviCKA3EFaUyEj4VIwdM4Qy72K8eoenwGdOF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnXu3CZvP8rG4CC/Nj/F/rDeNrZqyU39i1LyY0a8Z/8=;
 b=KqkGeDHI0KrYanewXY3mpep9EcL3HpqJA6YKe6/R0gsdZivjtxRUanV4v1flacSc4o92ynmcPIzeMpCLoqZ8Ap1udC2+nySrirGUkUnc87bp+UMlaw+fClZgnDGMJm2V+93C1dL1lCqG+C13ejtN7Ipc+tuiuSYNY81qQ+hwaDPsAgF2plf5VfvLXpnh/ELDKrYFDkKFvTjZs9P9yvWAJOjs8GdDhthVp8Cl9/dAuXRnooDS1w0IIuMjXh4AahSoZSSzn3Xu+wLnMuxeM9eTQkNyXYJiupJeuTOD3aT2WAERfiVSDCCbRfRWaPVgwiUJNT3cSYAU+YY2v424cOPk9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnXu3CZvP8rG4CC/Nj/F/rDeNrZqyU39i1LyY0a8Z/8=;
 b=p+k8GEj4ycK+HJYgEv0+nxPisAf6TtIhyTZVDrW/y77jQ0fXtKmTr8EgF1EwEiAH14Y0TmzdoMdqZGqk40vzE36GWC/iLpldWvrTMmI5fg02Au5Y875Z1dCUXpD26766vWAs/HDqsti7PlszGnVGC8phBRV1MfwrXbNcgBbj0aE=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:57:46 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:57:46 +0000
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
Subject: [PATCH v7 31/41] KVM: arm64: gic-v5: Enlighten arch timer for GICv5
Thread-Topic: [PATCH v7 31/41] KVM: arm64: gic-v5: Enlighten arch timer for
 GICv5
Thread-Index: AQHct7kgmYo8K6sdJEWzVGxF6WbBKg==
Date: Thu, 19 Mar 2026 15:57:45 +0000
Message-ID: <20260319154937.3619520-32-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|DU6PEPF0000A7E0:EE_|VE1PR08MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 318276ed-fffe-4935-db2b-08de85d06bd1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 WUNk6artkIyjSUedaqgY8/7RvGnP36HjlqbgkSQRM6aTmGbquet1pO+bUbzCcfLXaJYhMIQthjnO8QKb4jOaw4q4tOl1kzx4+RkxbGUVq6nan5oYc5vsQk0AfVb9GhsAoZCFT6yvUr0SeAeFdO+w2B2AUR3g3ubEwRF/VShKFVK4Fbi1tqO0ICBliFADlNGdZTNxf1JxtqSg8iIoOplAL/EqzbtOFh6Hd0JNz19bgimAOPnjpPB0KcrGkn5sWvs8uLAJstCXEpcOBNKBad4nFtw8tuF0xl+q6LVLJ9NAQWRzK3ZQS45bFxU3Vc5+s2dV+LUjik6ss/XLUOBkH7gV6WeuLCzPCDArz+kwBG8soadaXMYBPFpyxJ7zeCioKPLIrrsnoMZjTSqamYzNpBR6q4k4QJnpj6rR39oFsmjyH2Ym4i4MdoTp/ghqz39aQ/agO43Haj/+b2iHrZ4wVeB9k+Z60oexDd1kn/CpFMoEGenyOnKeUYCN6BJV9Nk8BqRHxoF1VJ05kD9cy/wWWEPakgk9J3BNKyv6MdkEMNfV0hvEnNXxbfLAur71VKxmjzYh28z/kUrLborNqNmkKAahs/D4TzVYYaLaJzWOPd6M9S9e6bcIpm9lXwv6tRxfA+L1eg4yuXX8yHk+Drnkajuc/+cQSMMCLu8BCkf1+BsTiOtuq8QnSPc8sLBpmsDGLPvR/n7VrLWPdxMOGhEsWKXYl20LfBLFQq/Q7Z9bJD91umSK9txET2oK3UbBtZPxMrn6EVTuFkHwrcvKE9yqPZF2vkTnCNWDqvSeapnkJ0v/vYE=
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
 nqKHZwgDRJs5G1xrYkkOBv2S96w0I4HqLLr0fPzvUwcFcfuI5dPx4VbORO5z4D4WZXJghuFbYWLXMJbC44iPa2s87JhsqIt3augUwIVQJ4Z09Y70ICI+j2fXxhMVCt6Wtuq4MfbEgfDjIdo0VtXN1+R3rhAOCwbNiXZ0rHUuHgQIQkWcn21y9IT+lTzLNSUFHAlU2I+hKKR6vkZsIQrQFi9HvMN9NUODeqXZpy+/qVY+kcbjhjSunbuVC6oh27Y0sYU9Y92aCC9tPGSm3NjB5xWAsu/80Ia/xxmY0GIgZekWZ3mMfe1K4fu+b8Tnil0VkE/n99YwOJv8Fq0nCdQkRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d0ac3557-c51e-4190-b1fa-08de85d04331
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|36860700016|35042699022|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5NQY7LFRNygRBWnRLB2+qjT18gBa1URb+VVEgzs5eKEM0G2ESpBJ4H3IhTufL4k1q+83L08Yj3autNokmhdy4WgYwicFXPN7VtCoQqNVzwK6lDz4ITvN/pH6apxrtYulamt4K4YUXdyvEOD7ooGlG0aplM81TUmUOPQo7AfSwy+QwN3q0woWbKkvYbci1n4EjMvaDLFq6EKEuvnYdV3M9XfVQ6qseW04OoehfOX1ef7q4fNEZBnU8zp+YizSv3EUWSnox48WfumgqObDW6y8abERNkfTBNoQbXOF6g37TThqoMzMc+XLcD+50r7FugwzwZgsNgblOvJR8dm+iaLGhelIuBt9ulRLApN69ha7s7cSoHYGjCTS/vSsEZKPAg7QeKUUGQVe5bLxWHDahHqIhK6aG4jc/cEOmPNJlEELbq6m8Ges0R+4nOFX+0510Q5+Q423yfc4D/dTDK4Fq0qU+5EUapkU0WGn4viKPVsdPY+UxRzEpkgbUyyFHy5yJIcR8VzLC2JvWN1BMDR93gItqRdce7UdeaPNeUX9OzwQoCBabl0mmbGUluTiEatKytle5EJIzRN9e5CdIifdZQJv5B174IoE+oYp5/3VD/rVhNqwRi/fxUwHlWmgtEkBw2fFXumRIfOa/eDSc7DeVl5+ctODGzJHmOmqaduomN0MqP+18kuJfs4Fh9yrj6gpnAh4efJ9/dhUyq0Q9M79tuXV/0iWBY63ypExLJ8fjikBj75HvYS5RTBVvzFmgBqapdnWkVwZ8Yhr45Q9RdSMMcnYAg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(36860700016)(35042699022)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2EIi8UGC2pZpz8e0z5xPq4H/lFn8AifxjYgZ3Ckb9RDZDG5r2rHtmOTYy56Ah5jiJIXgZ3RNpP0MgzCkcDXM6gO7OhCobeT6drggYx2CnlxvziWqrvWjrZ9k0c9OO++eIdr+PNIgVmWK4Bed9U/mJ9DfVec5NViUxXttoI95f0nWmPbg6YIJ63cZYkJd6SWJym/o+y8CFaStM1PDN7EBC+RZ0A+o+bzAEK3OgFW1DHp9DxsYGJyB1Rmn32/WEV7MyXBmuGkZoijqK/9Rw/jrD/wpK5e+GUROXX7Ic6ZF+L1E2PWTh+X3BxpsGwBIeG+PNMDLClOqUa9Bs6smdAZn8NoCrsYWsVHreFSKkCY2B4VBBO8QS4oS++dK3a5A8SfIaxC+nIJOHfwLCUmeFUH97JRNQ4SDYjwzN3rG2wwfreecopm1idnfyDSk1ucXinS6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:58:54.0714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 318276ed-fffe-4935-db2b-08de85d06bd1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5678

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the queue_irq_unlock irq_op is used as AP lists are
not required at all for GICv5. The arch timer also introduces an
irq_op - get_input_level. Extend the arch-timer-provided irq_ops to
include the PPI op for vgic_v5 guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state into the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has three impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

* Thirdly, it makes zero sense to attempt to inject state for a DVI'd
  interrupt. Track which timers are direct, and skip the call to
  kvm_vgic_inject_irq() for these.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c     | 94 ++++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c |  9 ++++
 arch/arm64/kvm/vgic/vgic-v5.c   |  7 ++-
 include/kvm/arm_arch_timer.h    | 11 +++-
 include/kvm/arm_vgic.h          |  3 ++
 5 files changed, 99 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index ef9a3df507ee1..f6d2f0246d057 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,12 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+	.set_direct_injection =3D vgic_v5_set_ppi_dvi,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -177,6 +183,10 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer=
_map *map)
 		map->emul_ptimer =3D vcpu_ptimer(vcpu);
 	}
=20
+	map->direct_vtimer->direct =3D true;
+	if (map->direct_ptimer)
+		map->direct_ptimer->direct =3D true;
+
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
=20
@@ -396,7 +406,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -447,6 +461,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu=
, bool new_level,
 	if (userspace_irqchip(vcpu->kvm))
 		return;
=20
+	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
+	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
+		return;
+
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
 			    timer_ctx->irq.level,
@@ -674,6 +692,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_c=
ontext *ctx)
 		phys_active =3D kvm_vgic_map_is_active(vcpu, timer_irq(ctx));
=20
 	phys_active |=3D ctx->irq.level;
+	phys_active |=3D vgic_is_v5(vcpu->kvm);
=20
 	set_timer_irq_phys_active(ctx, phys_active);
 }
@@ -862,7 +881,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -932,6 +952,12 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_active(map.direct_vtimer, false);
+		if (map.direct_ptimer)
+			set_timer_irq_phys_active(map.direct_ptimer, false);
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1081,6 +1107,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
=20
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
 		timer_context_init(vcpu, i);
@@ -1096,17 +1123,28 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
=20
 	get_timer_map(vcpu, &map);
-	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer),
-			     &arch_timer_irq_ops);
+
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
+	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer), ops);
 	if (map.direct_ptimer)
-		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer),
-				     &arch_timer_irq_ops);
+		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer), ops);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1275,7 +1313,15 @@ static int timer_irq_set_irqchip_state(struct irq_da=
ta *d,
=20
 static void timer_irq_eoi(struct irq_data *d)
 {
-	if (!irqd_is_forwarded_to_vcpu(d))
+	/*
+	 * On a GICv5 host, we still need to call EOI on the parent for
+	 * PPIs. The host driver already handles irqs which are forwarded to
+	 * vcpus, and skips the GIC CDDI while still doing the GIC CDEOI. This
+	 * is required to emulate the EOIMode=3D1 on GICv5 hardware. Failure to
+	 * call EOI unsurprisingly results in *BAD* lock-ups.
+	 */
+	if (!irqd_is_forwarded_to_vcpu(d) ||
+	    kvm_vgic_global_state.type =3D=3D VGIC_V5)
 		irq_chip_eoi_parent(d);
 }
=20
@@ -1339,7 +1385,8 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 	host_vtimer_irq =3D info->virtual_irq;
 	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
=20
-	if (kvm_vgic_global_state.no_hw_deactivation) {
+	if (kvm_vgic_global_state.no_hw_deactivation ||
+	    kvm_vgic_global_state.type =3D=3D VGIC_V5) {
 		struct fwnode_handle *fwnode;
 		struct irq_data *data;
=20
@@ -1357,7 +1404,8 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 			return -ENOMEM;
 		}
=20
-		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		if (kvm_vgic_global_state.no_hw_deactivation)
+			arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1508,10 +1556,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1608,12 +1659,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
=20
 	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
 		     &vcpu->kvm->arch.flags)) {
-		ret =3D -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
=20
 	switch (attr->attr) {
@@ -1630,10 +1680,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 		idx =3D TIMER_HPTIMER;
 		break;
 	default:
-		ret =3D -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers are architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
)
+		return -EINVAL;
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
@@ -1641,8 +1697,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	 */
 	vcpu->kvm->arch.timer_data.ppi[idx] =3D irq;
=20
-out:
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index fe854cac5272c..47169604100f2 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -173,6 +173,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
+	/*
+	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
+	 * have been initialised at this stage, but will have done so assuming
+	 * that we have an older GIC, meaning that the IntIDs won't be
+	 * correct. We init them again, and this time they will be correct.
+	 */
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm_timer_init_vm(kvm);
+
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	kvm_unlock_all_vcpus(kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c263e097786f9..9384c7fcb1aaf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -200,8 +200,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct k=
vm_vcpu *vcpu)
  * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
  * state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
@@ -232,8 +232,7 @@ static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kv=
m, struct vgic_irq *irq,
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
-static void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *ir=
q,
-				bool dvi)
+void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u32 ppi;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..a7754e0a2ef41 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -74,6 +76,9 @@ struct arch_timer_context {
=20
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
+
+	/* Is this a direct timer? */
+	bool				direct;
 };
=20
 struct timer_map {
@@ -130,6 +135,10 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+			    (i) : (FIELD_PREP(GICV5_HWIRQ_ID, i) |	\
+				   FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a5ddccf7ef3b0..8cc3a7b4d8152 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -627,6 +627,9 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
+void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1
