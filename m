Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010011.outbound.protection.outlook.com [52.101.69.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485842D753
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890532; cv=fail; b=oe5EagcVtDzVg79CS7IAWswS8hiFPChpGf0mEhEiN7KwPNijAjeS0nX3+k3sBw2V0YVbREjwYsfJIJ1VHJfOEQNQ5uoksl7ms7wsjcXfeK1pnehPZE6eR8ZOa/iSpitsOyuw6lFcZN81eGGF6YAPSaSy7xqbRIydtgApmDw+fw8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890532; c=relaxed/simple;
	bh=naOhq2SIvewduTqZDnf3pOg1v5krcprEv0tb7q84z7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WLhC1Bvse2QRYmzWcACOyhypAQ3y66cgG4JNU9FaNJcXOIkLJ6u9tVIioWw52har40+/rO4JNu/3FHmHkAmpItSk4YBFiR5T+c1Hn4Jc6MnC/zsmsW011lciSlum/m7vDfMpXgZ0TcmPc1CfXhY/nalj+ZhcRpf2x8ijNK0tATw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fPN5mYnM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fPN5mYnM; arc=fail smtp.client-ip=52.101.69.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fPN5mYnM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fPN5mYnM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RD2VPaBesKVB3nujB63pED7X34DHYC9qIUHliVQDfSGXg/aBAle//Bc18xXmslRtiD0m6FG8IdDgh0pX/ZxYu4iwJfdluf08wo7tyi9PLYfF7GZEXwwr3MKUG5INDPLtvxDO8JozcSnsZ18pVjSfRIDZ0BYdwCHg56xxI42IrMme2qADb1bV/jlDSWQXv/GCGH/buedPWubYrW0xgwpldJoLa/4StyA36jAbJ9JSu6unMq5poQBPA3xkCu9yRxE6y+Sp6e3MCkgd/J/eN9oJWrZZ03u5qSw9C9qhCnJ/j3cqH4VQOR0hmEqZEZV1+3BkQQTlfxkZjCb3po5wy3uf/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+tEoKHeLLeqVFoGW0jYK6XGTcAfyTtr/K0gXYiYi2c=;
 b=mF8cCahI50sNVJEDycGQNS1oK04cb4G+YnIk4TGQXvCto73iZiia2A3EJRbhevkv3LP8VxmP5VbGzP0uKMQsIztj8QE+UkSzreeJG+qGdBVT2iIIkS8uxwZR43kdMRmyMqZpoWlDHjza5KEOBQN8Qufav8I9649PYn6GsS4eZbdVeiDphQEyGCaS5J0EKyjaJEBGuvXGCILCkqt3vPghMSI0tp4pccWfehrRrh/fzUsFHzBOmU5y8GuIUs+OXKNuWPAledHphSIpN40xRfPsZbN/aneWpnuET/+y0KUpOjMaWRG4S7HrFTtMsIdn5jP6RIHBzsA7WpEI437JS6hLMg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+tEoKHeLLeqVFoGW0jYK6XGTcAfyTtr/K0gXYiYi2c=;
 b=fPN5mYnMkriIRPPqbnWK20eVAZJSwi7ta19acCIuEN0CswM/bZIvTwy6VTiiZBQy960geQxnfRT13TBSi9ICX3L94oxIda/rJWNleORgvIwlz5f6mjhSgsYQLsypLfuM6xNhjWHxiviART93UP9Zs2TlIe9fLeG8kzmrNNmG/QE=
Received: from AM0PR02CA0138.eurprd02.prod.outlook.com (2603:10a6:20b:28c::35)
 by PAXPR08MB6512.eurprd08.prod.outlook.com (2603:10a6:102:15a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:55:25 +0000
Received: from AM3PEPF00009BA2.eurprd04.prod.outlook.com
 (2603:10a6:20b:28c:cafe::5b) by AM0PR02CA0138.outlook.office365.com
 (2603:10a6:20b:28c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:55:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA2.mail.protection.outlook.com (10.167.16.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:55:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2ugnor4gDgrPzC53jyPLS6DGrEeKg0D9FxGLij8v6YaBdWiu3XK5AItAXEEQJG2Z5pCmLR6a5aLNB5V9+5pvfU4oN9PRUiHZoTCxr7FWtarxumcMYt4+47wLwOu6i6EiNL5Pjb00BFI1psVXVMUDR3W2We2xeiKPr5jBgW1n+pTPR2YS8DYVhItTTAqzw7kcgNYnA0ZojQyst79RGK8fqDQK0mNdKDW0OIzhdm8Iwc+wB+ZwoQn6Eulixjt+Cw1U0nFrl3dEfmjdA1KC9ZSWJ50VBu4NFqdTcMdgyc6+XD6QhxNGXuKypYiDBh45BkHeR4Mk33OvU7vzSdLcn/MaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+tEoKHeLLeqVFoGW0jYK6XGTcAfyTtr/K0gXYiYi2c=;
 b=VC6Zts9QDjK8LaGBCLGWKiHCAjwC4dVHdSiVMstQF3pRSLQe7W2AvqYcUF0e5rnipb/S3bR6jrorGw6NRc7/AK9wV+7+9mOiVux4IDAalZhReC1J+PjAOGztR1NWqEKRkq22BJy7biqgc418oyZFwnwcNWGivWJtVjUM8Pb7y1jUS5M68jgU6j38QrJp1L41te+bC6p1NLN8NZw/fexF+s9DXk7W0Lfs/ipaFXVhvSZcryxtMmTsevKbDSIxFxqowUAvXCl0C1iaLLmoxrdtpjjQiYpHsOz1pd2RHgE+fCN0QmeHKiSsINncRjXA9m8j2n6yeIYgV4Dz1MH/5RDsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+tEoKHeLLeqVFoGW0jYK6XGTcAfyTtr/K0gXYiYi2c=;
 b=fPN5mYnMkriIRPPqbnWK20eVAZJSwi7ta19acCIuEN0CswM/bZIvTwy6VTiiZBQy960geQxnfRT13TBSi9ICX3L94oxIda/rJWNleORgvIwlz5f6mjhSgsYQLsypLfuM6xNhjWHxiviART93UP9Zs2TlIe9fLeG8kzmrNNmG/QE=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:20 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:54:20 +0000
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
Subject: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdG1rHMEBbTcIjEk6cvjvril31Ww==
Date: Fri, 24 Jul 2026 10:54:20 +0000
Message-ID: <20260724104819.1296803-24-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AM3PEPF00009BA2:EE_|PAXPR08MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fbb5ec2-efaa-4216-4129-08dee97210f0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 nJjRJMiBNchPU30NLwnOygnIqvwAkjc5UGZCqDTptdPhiLCl7KYSQUd5ojAnm1f4Enn9Je6yYO9O8NP1NVsPHGsoSY5wZ5F9rD+KQHckHRf0Qr7oU6o3U4cFW2XrMgVRGKqrfV9x7Ym2DDXOw7wKYH8T5O94WSevwNwvj6KGfRTCGTY671E+qT89SmxGkEGnXF/Pci93cJGdnM/fR9BGnYP2CYmHssXubH0WctGaCW0iJf9/YI4SL+Vq+3++unGyeTS9jbujv0Mnjuq7Uubl7Psm3Mm8ttIhRJZ+nLjLm5wtqIiOdmlesZZE4MF72GiTBzg2IfmrbTcxgLI9eLfX0rCJgliDk5zN8cXVW4TKDz0LlHHZXD2XKVMbk48dmwxGOe3KyDeFH+IdMM9mmnrUAIOrvZmQGhtizBbYeFxHPrc1wZNNtntAXkcp6OmH4yy0Nx1NlqdLCMgGsiL2GX8dr6LUjR8Jr9aqxVfC9OTCPr94XmX0sQjEgjtArEHxriyl519JJK8WAfXUY3PXzrBj50nDjuVGfoE/xr54FjtK4Cec6DjBT/9N0zuVHbeKJXtINT1UzPpkmYkQ8Jz1/pvPKzUkb4Hy5JAL4J3CU1oOXS14nUl+uv5O/cWB5jDMlXSnhkBuDbjMafQyJaF0zwqSISKFBx30T0Bo8oLWb93ebjuM/foQrEEda65t954N587vKz4Ug1Roxk9toxXfWkuByxTMqGOdmV5X1tQYeN5pqB0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 mlKEEFQK2T11F3fh/bpzqhnxahfZt7mUgw/nM7af+2BHqUgdqw6JQqwbfeBzrMhkqDBe6GWyhlvNpwolvGt9miO5r6LfwB3+ZNiZeNfU5DNUNfpqTrG4s/dcVix+xa12ZhR1Ch/z5xcFT3xyJHrQ+ik2L9DYv8e7MTEB8Ce7vfTblcKSzz1FHqBXyQwWBslqQNF3rg3TyTvNxv2n64W+UXNKYfW20Ie2DD9JRq/tYtjK1YSLIznyTUl+NIPLx6zcKNx1jD9V7v5jWOqQB49LUyXOBc5sxz7qdOLKdFHRwGsWAJmD+OqKwwRMZdqKJ4+zHYh/q33IFuyoiHWE5Xa9Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	17367e7c-1fa7-4c20-dd55-08dee971ea17
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|14060799003|35042699022|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	35zsS6Je5ZEX/PL33x8KCG37FpbgKz4vtIkkdITZpvF7ZZvStv//kii2yk55gK8OVFmX1o+XHX3QRrL0sloDZdyRW5LXaPlJP3eYt5OD34rNNz2Oe3hDdzEPKDe+TQ81XUDUFSp56WlSmTmmSA5NtLfCBFzeW4djoF0p15m5Q9uovZCFVDsawlphPQWnzM7gdUjplgtM0vVqFHxTamPdsLrmVf7Msynj6f1XqDLeXoEkZDygZxaYlvc73GlT/zae6OXS0VPhQAINjH82NuPX/u3+wXG61sUpLeAe1KJR8tXexJZwxgr+MuEdusk0GYuY4u74eb2WQsXUpv+VoThFIbNexWGBpefS573jlrNBh6hCQy0UfnjBIS4ORyNYNbN3mCimJyn+2O+jH7cGQ4vhPSbDb1TMGjpw49oyaMKBtVvWzUJ2bjKt9et7Ba2zLQLCaOuu8WP70MlY5TNIV5jxBjTG6RuYR3CaNXrz7QxQEPzt9ns/Egq81iLfIC1jalee6AO4TH8OttkTZbe+TV2YJqaJcLZ6RYVzaXxC5IKA0SP4ikGh6dNSUK5+hTyO6aUJo7v2/4V3Vuux23eemvDxP2kELyzzlwVjb3bj8127uMZR0XutjzNgTLlVJ+AGjQItn0wfqgKyZyTaWkMngynIjc/1ZR9m65u+WZA/U7jKpImrHHxNMXqhWySUmMj/NPusH8/42tiG3jZJmnLErU4DeQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(14060799003)(35042699022)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	D4kWtTNoDWuHDxSetgiolwGEnNrfAthEktXN/Tm71g+JWwbIlIaMzZNotij4erInOJ3EBoBJ5c2vF3peB1L3fFO9NMhQ4jsqiws+bfsTc7MtMaUHLliN/G7nw2XHXTyFGLFfkiPAz4aQ+10slXmIhImKyg4kB5Av9AA5d85jq/MkeY0l6R6fsZaOk8Db5LkmibO+Xxy0oHR7t35nWNLfQw0pNmPyYOlFw7xgZ2Iby/83mcvI2J7bxCRXw63UQEnBkFzUt2wAR7Q/S/y543mWYHHSsP33CAZMJN0Rd30QqmFMyP+v/EkPkdRlGMaaUb/55qqhcpETd+PzC2PeuQyzxmTxklhU4GSnv7xRuWjAQZl8rGTGJfu1Uwy72kvs2XU/tp4IOAldhipTyZX4+tooB3+YdTVWhKrwBaUA35LVgA+y/faRxZX6SjXS7ZVslGry
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:55:25.2030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbb5ec2-efaa-4216-4129-08dee97210f0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6512

The GICv5 ICH_CONTEXTR_EL2 has the IRICHPPIDIS field, which allows the
hypervisor to enable/disable the HPPI selection for SPIs and
LPIs. This can be used to emulate the guest enabling/disabling the
IRS. Therefore, make the state of this controlled by the IRS enable
state. Thus, SPIs and LPIs can't be delivered to the guest, until it
enables the emulated IRS, which matches the behaviour of the real
hardware.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4042d468431b1..7957b9da95e7c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1066,6 +1066,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1082,6 +1083,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
--=20
2.34.1
