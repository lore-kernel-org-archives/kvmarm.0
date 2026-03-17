Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013041.outbound.protection.outlook.com [52.101.83.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579313ACF0F
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747811; cv=fail; b=cax/7G7QA6bUJdmNeuIazXJKSHrcWhYWBLUVaGyEVCkun1y4CPT4Z68IMi4BP07vIWuYk4IKDdDFwsLMeJPiQanRaI6mfKaGs65Fxgh8F+QfwcL/fBad8WYuLywy3+FCxh7rLICyruOeFdnR0eL6knTR/ydv05AqDXZeadxByhY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747811; c=relaxed/simple;
	bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JkwkImRqtx0GRRZzEJ86ESC/slEg0uRk/L3kG1XWcw1pYoe2OhPor7OVEF9WiBvrW9tHUyRg5J8ezyDMkfiwF1PjdFxxdJqlNUImvTuZ8WSqfWLz/PnOF/qWFcx+uSeSI5ZEN1WFT1hUgrp7jOE1g8qPFdyxzlKvMTA9Kpnz7wI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nxn452yC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nxn452yC; arc=fail smtp.client-ip=52.101.83.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nxn452yC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nxn452yC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ss6Vevs6WCNiAtn0zFXEgr1xnQxam9J+P+JV8aKxbVBWhB3JWtxsmGZ3nWEz1VKN3mD85SAUzq902P9G03ueYLBA8LMoJHmT1O2JGDliJE6BUEnV3gGQNig3ontls67SZ98CON8kiqIo/cC+F8GFSTfVda1Rbh4qA20sHiOGsDombD7gmcfHmsCKfzw72m5hgElfaYX77RYB0Ayyt1lmscmOZueSKJwL90U/zmLqIjt4VLwUIzxqLr48JWCe2PB5U/RzabuCloXumO7ze8ZM+2CHXvMeCh0R3i5aD7kH4a2zpgqx66P55dlpNYKovt/p+FQYFDnaQw+1j7M62UkAtA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=ajkWo4Fb1cP7qUpBdRxJspEEa0Od4sAOgu+SNKY/3r9vC9+gPk+5j//Ij/mvAXm4gOjDaHVyqS+z36hx77LsQci12q/lOelNq+GRbIXMy9FjZ67TfEi/InWNShV5HHmUccANOobs0YFC4PNseD/MkmMbvJKzpA4xH5qZ2ECSiuBdyEzzn1do60LmAIXb6qnOalb+Tr4w4QxgQonltcxwdrkZtucKugL9hE9ldMCmEASZjkBlzpdzU6H6V0DfrOsfOYePg0gH/2EBYcjOmdOrzm8KAHHXffwHnuDoAjpaCMPT6a/7AOxRM8P/Ppk/MO4ifc4lC378KuTFfcuCiqs6XQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=nxn452yCLaYoocSE3aktXy5RoVCPRpIGYL0GvgW9UztHsvup6vDnuwyO0DGGvEDCT80qYg86XG8L2aowXBtY3TvymKwBJuM/gnwSiXcYldgLK7eYgFY4prXQHm8uupZt3rRdQ7rQfoXerWHqCje75b4ukXw4Bcj2itzW5F4i458=
Received: from AS4PR09CA0005.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::11)
 by DB9PR08MB6441.eurprd08.prod.outlook.com (2603:10a6:10:252::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:43:22 +0000
Received: from AMS0EPF0000019D.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::a1) by AS4PR09CA0005.outlook.office365.com
 (2603:10a6:20b:5e0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:43:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019D.mail.protection.outlook.com (10.167.16.249) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:43:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDQ7yX7JEJKZC67OS/OxYJom7GMclh3kMWvn3d8b5ykx3a13kjdNxPo/ccA0H1H76KXrfbRUdDsv3lkMg+TEPVrLFrAs7o/CqL13wbCDFH5ImVtbwmER5i/2pa9JGPOIYK5cLJ6T8DMpvUow32yc1wmFTU2OLWYbDq/VSzaVJLgWp5KuJxaXPcCBjgsPbi/953f17WkXMmyxI89W4Ug00+6W0POVLPqMseCSG1Ay4ddt27NTjg3nHinMoPsxgrFXYs1nnbVI5yJIUwaDZBOQy6Qc4Axr6iKyE/OayMYfkVLL1OSUVAiWVe2oczGMXo2q9kZ0wzyx2novHcUiiAm7dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=ysjzOHQKqNCYf8tWSH/m9S3FPfZeQePjKRdslM557sZpjKNKH50udVQV/kqZe6z38R6R8KnQ9UsZ51zNXbaYETggvfd8/cJ8hPomBBIyzComxzR/IcNxbWhqzuw1ypbH8kmGTp7co69k2ZyHbY79kxsF7hQTgBDGU7hvl1KURhuvk88Yv7vu5uotHUUb/WBJnathQd3aQfeI/3FiTeb8XI8j+yJz6PgdVCdxmij86ksOH+vKmwNjRUVpRVZOJ+k2UNuDkzh5jt84Mpsf+3mxEbYFIliYpzAFjOUK6dD2u3YpzJ2F0rCnyBaOWUuyYfhSAKfGL7Sz4UWi/ItJ2OE6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=nxn452yCLaYoocSE3aktXy5RoVCPRpIGYL0GvgW9UztHsvup6vDnuwyO0DGGvEDCT80qYg86XG8L2aowXBtY3TvymKwBJuM/gnwSiXcYldgLK7eYgFY4prXQHm8uupZt3rRdQ7rQfoXerWHqCje75b4ukXw4Bcj2itzW5F4i458=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:42:17 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:42:16 +0000
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
Subject: [PATCH v6 09/39] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Topic: [PATCH v6 09/39] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Index: AQHctgMaGy6o29iS5kqoGOAA+dD29A==
Date: Tue, 17 Mar 2026 11:42:16 +0000
Message-ID: <20260317113949.2548118-10-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AMS0EPF0000019D:EE_|DB9PR08MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: e02c8fc0-e2d9-4416-1790-08de841a6474
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 DkkY0/5oB33Ur6e+sVHH8DYtrptln4dtNsUBl0teLVNzLUvNo2KcCzZTZ5416sXWakaArSDgJ3rz9mSz64S1P8+WwihjEl6HvNR3qX+/BlhtIDL029EZHIngG4boYkO0lda9wfCHtizDQT8JDwUe/psIrI8uKdl/puvS9Vj9YYGR3nvogrh1yXxPHEdJHqlxi0M42VmWaNexCM82PSaVClmPmROIjVSybuE4ju66FVmkgFezPHkw0AeMJ0pe+5HEGGpmRfx4BWA05E03KQ2fPx5dM0BDYQFl+4VBaTqmaZjsDyg9jRVXEB1Pa3ckRH6fb4GwVJ8vBY5Y5Gl9CAsJVxxaFrBUKN9LfTq7pVuh67oSVS6MRo9XZf4b8tbCfKJH9poP853UAIMhzp2UqNmG49bgXHN18T+g1VktAyQ0n9rHSLl62ymqs1A9IDfM3Yevz2fYkg9RLzjc8zK6aTwlg+dq5nFAuWR92VnO71H/7ttHxjxCF077whfGuuMYkIuNXTwflPzTdUuxOHH3sV7FOgxWa71eb5yyLLMHdw6lYTVlcdVYwt+b/HEwxaYHXd30RXp8HJsMGt8O3SvdkemPyQqVt/LVZcdSnaUAsRh5x6NT3ANJx4Uw0djGUIV+RdLuSz8rZNqb+y5iPbevza/HOP05LjQmjGcZyb6X1+t2h0JiYs/OW6OfBZUwwFdGM+ehgw+jEUXbNq4WYlQvC0btud0dwYKGftnoVNeUkP3XVGTNBDD8uO+68HeWTqKBhNyR4kjUhFSHotbabjJ+h4P1DtuzDF3ViotjifYMjoXGFeo=
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
 n0MOTnw+Yh030FsdGMX+rNVYhnegHiiwGoYzdC57CdRF8yfqzUYaDN+Zxi2BMmPYjICksgCPZFXMIknLAQPPL9YAkBZRpj8+IKzn+zhnOdzbs6oCNRV8M96AxBB7kiXzB20vvM0YX7nKb77JoawA8C9LXO+24XexjxqNB/MVdcrgsFaJY2aHqdSvMdQ9pNDqgM5vdFgFAwFQGF8jwHIx/PuJNZrzRUaOuIo14M5mAgiXBI2ipi+zs79nIPhf7zdGrlsh/0GniYfhKB8kiJOxjXGwnNBKQeQllt59wm1ngg3LdTGXd2pod0PJhtuXVDfxIptNzCoI1njNtvIlbhKycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	97d9657a-31ff-4971-d4f6-08de841a3d80
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|35042699022|82310400026|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Q0b5jEbbMMGPMPCPHeL2GkV82P655+ewf16aRd4ZLsQIOmdqoK59BXG8Mhz4QWkbB6ZoLhs20ng0xbP4TeWi4+8DdLX67UxB1NbV/HSNpK6VSiAqeo3OFzL4uCLkesbVFOjqlXuKr4P26rGn3ifYPdsg8MqQA1Tv4VxvzK9CkFToa50ch8fubUxEvRGh5XMCmuFtjBIsHxlKkSVY7tn5S36lKV9SoVG+5A/6osHCo4qeHDyehpC4aLyPWG3ks0CJueJaZSIstS87Y3P+RFUi0R4J7cUs5JdqmynY8E6ygVcoPyWkMHg47ZaO6zzELoBJ3r7Ugs2JNLdtIJ6ub5SxMphhxwnojsUpbIT5PrvWaVfl9d8iJbLEEkEhF21jP1niV7KCp4yHpsras6KTlm4Fq28oxOKruB6jcSY4FIxV1RaI8HgFMTVSEDjJaStMkbekbMGYuixpqL1X7YRukJqqr3kW6EH5Jl4YO9LEhcEv23dJcpwF+g1NZxLcxUhHqnBOYILqqZLCV8UyoX4fNzzXjnh8744jn1+tYTX/1H68GcKjdbqHKKWzRbJFaG391OB0o3buu2qmJoGlvBNWPtZRqx/3zSykh5r2Em98Hilfc4QQ8XN1uaPORx+RBCiWsI/GjXq7f89NV9yHS2x7Bm2/WGYJUB3DO8nIgIciGoxQ8FP3zC65N+H3WTfaXZl8S2c86IXgraPJT+QhtTsAOfZsTt26z5p5fCXBDM8H1hVTKSgH8ID10RhbSYoiOezlcWwc+lpksAgYoAu1tkvvWnZ5Wg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(35042699022)(82310400026)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9xDZ+I9rlMP/6P09Yt9ApHuqZdBIIyeUQURmlIupywAnIsuF4oODe/4t40wH7F9UQwtEh/QcbcxLFVFZcnT0jcxImSqGnmkjPaWencOq9RvS2UfF7Z/YEyh3ZvI66yTy/RG37g9Y64IYCj++MEpbZY5tA24SkokuPf+siEjlPU8dLsymPXqYYQrj4bb7AQoQhX6HleH7gpG873kOygRJwbN7VCCc0KY3rYNsSBsqDBTuckb3Vbw/5Ddp+u5pkNd3as2OYQGgDeypKuDsPj010NTTM36P6RMcDZX4SOsV1RSCRL7gyEdrpvnUX/BVFLDrGIf/7F55VKUGc+J69onc4KIHOj14YfBlVotctAKOgpMaevS4cHEAMgUeIuE8/zk8lnUHEo+TzvsumACTFa25NcLDzC3UP+4hJ3C/GQbWXkAddKXrXLpDfzYGCf5aI0Pl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:43:22.1591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e02c8fc0-e2d9-4416-1790-08de841a6474
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6441

This header was mistakenly omitted during the creation of this
file. Add it now. Better late than never.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 331651087e2c7..9d9aa5774e634 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
--=20
2.34.1
