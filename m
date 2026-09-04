Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011002.outbound.protection.outlook.com [52.101.70.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41E470EB9
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521804; cv=fail; b=p6ckPo0AmDYi4yMwQIKdPm7DYD9ob7eXdI7q+MqcPvIqkgy/gs7WVltCl9Uc55AHZtBNiks96/9Gbbvjs6UFnyXH+7kWdrQLgDxmMp2m9tvSTdh7RhVouM5+qvYu+IsSmHYd8MZfyuoRlVVzqtR7zt6Yj4k0CfhuU54HeWYUd7o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521804; c=relaxed/simple;
	bh=usOSihedx2/Hm3OU9V7r0+M7knlymvsIzQZL9DHiKgw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fXI7Pbdxyc78RbX/QQWwltea5jP2dBuCLSxslF6w5dhI1kKIsypyEjiKwrCKzuwP5BJfAF1NQfUitGvdgkyJ8mmgJr9V9YgN7p8LknGysdna5tUwUACkbnxcRoct2anGWetTvBC+PfGj5BMFW+RBD39udofQZYDN3lcZ00/X7CU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Db84MUwR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Db84MUwR; arc=fail smtp.client-ip=52.101.70.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Db84MUwR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Db84MUwR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wVZAj1J1+FkUe94J8SKgnVV/JbsveJVmmJ7zff7GbQNi69L3HDIs0+Y+za+J6a0YzpmQ6eVllic9gtYobqovInBNzq83xQUBTjl1n51exuTTVWnGZdhc1jAWfdBt/HxZP1+4R8Bu1YJgauyiDRLJn6vq0KcSola/GMO3F+nidrbVwlWsM2kbXAWa9y365IufneQZZXwcNYQGcGkWhJRfGoTsJyY/aRJM2AJmTLk6napEP9Mvn4vG7cgytXZFQtERJqlue7hcexRm5/5PV0tNyV8/IaHwnj2HC6hlBqNoPM7A5VpbB6fpiSb7ceNzPoM7M1udFxEuL15AHgiFuokFug==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qvRlPXhAxXC4FYppteN9uSTZbACUn7gLH7zt7hbQ00=;
 b=dAkYAKmW0rw3TdIWtuh6MkU7K5of+MtlV6yACXHqkg1qqtV0KSAoXXFvdOsv0XuP3bQVehEgF7aWshmHQ4UCyQhYKxQr8jwzAMTUDGw486q8BtRwJOC390n+LXwGwckSbDbYfxPOAaLxyFzs6AIt5A87K5bd0vHVvIEbOj882E5CFAt7ZqbztRhLmpDRxP6ZB/K2kNWLEaaYmLfSISYlHe2mMnaWxYRfkDVC4ZoboouDBMTnscAHAoVzPMxaSkmcTNGfefGCVtXLyCEwXnJshLOL1b47Ly0vXieEjq2izkegSIfxvv3IPIQgagv+V2Jji1WorlEwQBwU8Snz0MxQKQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qvRlPXhAxXC4FYppteN9uSTZbACUn7gLH7zt7hbQ00=;
 b=Db84MUwRwcYPvxyEoniDie/SlT4I3e8w/Lap2n6bmsKWGY6H0EMARyUyFtUq3anoDylDjKs+sMl1kx3xs7pzmCU9V+AOZgOhNNOvH/b5FJhFYHvP24VaL7wALU77acD7fnGgeXCS4/aRu0G7dWWzvkhgmV9i+6LGGw11o/Xk6/Q=
Received: from VI1PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::46)
 by AS2PR08MB9944.eurprd08.prod.outlook.com (2603:10a6:20b:547::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:36:25 +0000
Received: from MI3PEPF00008558.eurprd05.prod.outlook.com
 (2603:10a6:803:28:cafe::aa) by VI1PR10CA0117.outlook.office365.com
 (2603:10a6:803:28::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:36:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008558.mail.protection.outlook.com (10.167.240.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:36:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mvrzg82FmEWAhLKTEocTXeDN57h/xpMlRklO21KcLFZkshuFqb5y/tz/kVEZp4wJx6x8r6+ITeCU7A4uD5wP/JUFw5aGqXT06dREVuA6raJcJ3htkaeEXBax7bJMT/R4XYAp6VhWwLLhhrf3eWfHVCPhN4NcsW95O088CZ8T6JC2RTEKQok5DdpywbF7bJwLjDLnrjM5MCHJgFt1Zhbp25TXKiT172RJyYIcOs08efQDvSovwhwrITBZe02rduCLuIKZYYjUgmFDsvslORKiFAfkp99gap4u5ehG4V7Z6djIIISDgU6NuUJgm6vWGL4oPy+UhObjCknEoeM8oK7huw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qvRlPXhAxXC4FYppteN9uSTZbACUn7gLH7zt7hbQ00=;
 b=EcedR733QEa/euisH7VGW8M5l/diAi51jUvzC+QJ0zmqqU0Q6ZJZeGig/atORghbJD1ntxGXgyRsGXy8ECTalmsavvsCtHLgBS3+ybf/fyGu9o/+PNYJxjbRykMDCds0Vz/r0MrDHnN/Zr+mhzM2flEpyoeCZBmm+QhbYXzKKgeABt6+IKXf/8mzmYVYmw8clwWcrTzmwu2EvBTHkr7NCpr30Hpd9DSYzctDcybNAcBQWDoce6rJheTctzJW/w0tRQHbTkaiTaR8W5MReozERFACc4sZjEljsiRH2BNXNKhbkQkMrY+Y50jEUL6AoIZnWxTHrmXf2aYHRQEyLiI96g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qvRlPXhAxXC4FYppteN9uSTZbACUn7gLH7zt7hbQ00=;
 b=Db84MUwRwcYPvxyEoniDie/SlT4I3e8w/Lap2n6bmsKWGY6H0EMARyUyFtUq3anoDylDjKs+sMl1kx3xs7pzmCU9V+AOZgOhNNOvH/b5FJhFYHvP24VaL7wALU77acD7fnGgeXCS4/aRu0G7dWWzvkhgmV9i+6LGGw11o/Xk6/Q=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:35:48 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:35:48 +0000
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
Subject: [PATCH v6 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v6 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdPGGIQnw0XeUPLkShwEp/S80KyQ==
Date: Fri, 4 Sep 2026 11:35:48 +0000
Message-ID: <20260904113404.4051341-4-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|MI3PEPF00008558:EE_|AS2PR08MB9944:EE_
X-MS-Office365-Filtering-Correlation-Id: f62ed58b-14a6-4ef4-c4da-08df0a78c007
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|6133799003|5023799004|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 fVEi6U9iBuWgEOTMlQ0qS9kSElQOdtLZ6AI9PsMM1GLDo2S0vUCsEN2wH6EwCSvndfCkl4vva6YE50D/hGfiijrk1CQ1pi/l33be+jZknc0abb3aaxFymMx9S+KmozXI+kzODeDvOoWLINYCL/s7RwucXl0IckB0kCAZ/CjAYMsMh8BzPgXGiiravAGHhCbjygUyl6xBpv8yJHjla7DX4bONofqr8yfA+FFSyxzkjjUkHGDOgattFNzXSqtiQ2qvto30kGXvfly1t0Yn39A69vjZKO0BVqYgEMpL3xxUAOgDY1ZuJRPszSRhOWW06X41tZ0Ihrx9exEn2OQHbYETUbiAAMs4kf6x9gPYftUp9kyy3LrbeIkMXeDzuQrTKBWk3Q2zNV9OQv6VuhAmVhi12k2Hs9wNTbFyaN62pU2svBKfrE5n2vmy+yRAoMAir+ofVhXRfYw+bAl7+QkFRIiXClhKuMxZge3ROJs48+izPRMjNg2rmNU9WfWtpDXKpgZM3TsRaWgTsCOqAdwn1+kzwAcWQ5irOKbonKcWHxaceJLYszKK8JvxCvj1RErAd185cl2yh86FeKlM4JbqAQd3BPBOIZUT3xzeofIcL1GVVO6+Id3CrnWGGVdzOg1jHgJZzrVHBMCJQJvmMbbgUsK74VlVLCkl+kSvhuq4qeO4YDow+g7DgBBp9QVVrAEJBU/FE+9qXCqp0cuEvo99bRStEhsr68bU7WoYNURrogHo9eM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(6133799003)(5023799004)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ItrVEswvWiWgMnrT7tgyMAea0TdImqrYKirbftfDpITA5iXdLTjdIGlwkSylv/yKMOjmpgteMsjGZe/P0BOIr2XATWxKQcx7xzZzT+W461oCVDVkm2JWSyQ4LCn2IYEn/mlzvxyuHuQvPDIy+j0xYn68vO9ePncS7MOrGfV18mDi+STAjBiZe2gzkJ2YWDPQ/3uJBXLJ7Su/RPnCsmYuL0D17OVIxzmUXr/wp3PqDnNAQusaMF0WDdWGzdtb9hZtQ5o7P7kEyOOXAXQsBiI648RsHSsDcRqYXmXCfZjD+NA9WiHNlSqD4Z+3HVXvhBUKcdVzMRJyvsqkqK5ymynilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008558.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	37cab7e3-3beb-4c96-efbe-08df0a78aab3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|23010399003|82310400026|1800799024|376014|5023799004|10067099003|11063799006|22082099003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	djVmb1cnsog0/ZmUwmqJTjuYiyW80TNAmmeiDSCyFQVahT3kwelwBsuKUeaGzksZZcMjCuUC02iyxnJE8844whWp+k9aNuwhBu3JEX0kVy3DZ8qUQElEuc1JNKrJzRufukf0nUoJky7Yls5gyUTrX3yPIDDse3A+iABdX/GAU6/K+84gNgYnZMb4hglSrBELh69oyJzpxbGm7YBhlwnbmFq7PBwQumWMJvA0rsEZEFPGN0LQOaAlDb/Hsg6W+LgtZ0bCliWNCxoKfAnWa2kuTmUZ1+lAW9x3n9SuklKzilBEtTXEoIP+CUTztF//hK/sZCu7BKNnhILRmjrTPLCvRNgbPhQGi2oD3x21s6rOezEXmQQq+4DLhL+hsCjrqig+Pz81hIcUWjp/BGtFlEtIw2jELnJ7Nvi6K1Es77Fjse2hubAZC8RkknT0Av5+JZNl0I1XH0CV4SUF2vhrLGxEtV57bwMAi4L8c5eU0gQtQ55Kd0kDqb53hpcvtOQXseYQ12rc5YkMGDKWuumL/iUh4F2kTx8VMWlHxrLlv8jTnekknt4TnlCBhcf2HWIjPlJcpq1udt0U1iORwHw331yWyKluDP1twUPvq0cEsxxa1wt4mYJjTY5WAQc7gB3tPzoJ8Dfax3llk4IjWOYaCLFEsV8sYHP/WAURvW2YFDO2R+U=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(5023799004)(10067099003)(11063799006)(22082099003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	k4L1vlXM8uUlepk1ZsX6gD0EjGxV+twu6g5dtpRtwDYZ2y6ZLrL5SU9R3Qs4uJq4FOPyCQ71shY5CB+PXMdVKqsYz1/lOM9Jj+gI0HSt/kuEp1r+eWG+NxMNxGnajbki9stTbjFYXcdbiwLqeNpqfQo31YnADLHl/555vtoWCKDRTAB7fLCbLai08xLaXlbdU6NyMKmmXiEtjO+7USxAaFWwa2XbpMVk84IYLmlnNjOiTsvSOCIQ8QQveRkHTAxzQMROy5nLv6cnGlvYPfnm9O3AJHOgWlPfN/P7fxjmQ5zSQJoNephqsTe1DwCu5znF5yr8GuiR+49G5rXPzfNQKog9nA43EqBOpoX4Q7uzEc1Yo32+B0mwzOllaEPhckfBJA8l0mAAxqNk8j82EcNCITd+IX42STRygz4V0NZp1U6EeT9Q/lCnVCuXk3AiJ7PZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:36:24.2015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f62ed58b-14a6-4ef4-c4da-08df0a78c007
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008558.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9944

Device-tree based GICv5 probing already passes the IRS details and
maintenance interrupt to KVM, but the ACPI path only initialises the
irqchip and installs the ACPI IRQ model. As a result, KVM never sees
the GICv5 host information required to probe the vGIC on ACPI systems.

Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
entries for the maintenance interrupt, retaining the value from the
first relevant entry and warning if later entries disagree. Warn if
firmware describes the interrupt as edge-triggered, but register it as
a level-sensitive, active-high GSI. Pass the resulting IRQ together
with the IRS base and coherency information to KVM.

Native GICv5 does not require a maintenance interrupt unless the
legacy GICv3-compatible CPU interface is present, so preserve the
existing no-maintenance-IRQ handling for that case.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 94 ++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 29e9c59a3fb09..40a1c47b6f2a5 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1120,7 +1120,7 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static int __init gic_setup_kvm_info(unsigned int maint_irq)
 {
 	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
=20
@@ -1131,17 +1131,19 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	 */
 	if (!gicv5_global_data.virt_capable) {
 		pr_info("GIC implementation is not virtualization capable\n");
-		return;
+		return -ENODEV;
 	}
=20
-	gic_v5_kvm_info.type =3D GIC_V5;
+	if (WARN_ON(!irs_data))
+		return -ENODEV;
=20
+	gic_v5_kvm_info.type =3D GIC_V5;
 	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
 	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
-	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	gic_v5_kvm_info.maint_irq =3D maint_irq;
=20
 	/*
 	 * We require an MI if we have legacy support, but don't, otherwise.
@@ -1156,11 +1158,93 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
+	return 0;
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	unsigned int maint_irq;
+
+	/* GIC Virtual CPU interface maintenance interrupt */
+	maint_irq =3D irq_of_parse_and_map(node, 0);
+	if (gic_setup_kvm_info(maint_irq))
+		irq_dispose_mapping(maint_irq);
+}
+
+#ifdef CONFIG_ACPI
+struct gicv5_acpi_kvm_info {
+	u32 maint_irq;
+	bool valid;
+};
+
+static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
+
+static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_header=
s *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =3D
+		(struct acpi_madt_generic_interrupt *)header;
+
+	if (!(gicc->flags &
+	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
+		return 0;
+
+	if (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE)
+		pr_warn_once(FW_BUG "MI wrongly advertised as Edge-triggered\n");
+
+	if (!acpi_v5_kvm_info.valid) {
+		acpi_v5_kvm_info.valid =3D true;
+		acpi_v5_kvm_info.maint_irq =3D gicc->vgic_interrupt;
+		return 0;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq !=3D gicc->vgic_interrupt)
+		pr_warn_once(FW_BUG "MI not the same on all CPUs\n");
+
+	return 0;
 }
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return acpi_v5_kvm_info.valid;
+}
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	int irq =3D 0;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq) {
+		irq =3D acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
+					ACPI_LEVEL_SENSITIVE,
+					ACPI_ACTIVE_HIGH);
+		if (irq <=3D 0) {
+			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");
+			irq =3D 0;
+		}
+	}
+
+	if (gic_setup_kvm_info(irq) && irq)
+		acpi_unregister_gsi(acpi_v5_kvm_info.maint_irq);
+}
+#endif // CONFIG_ACPI
 #else
 static inline void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 }
+
+#ifdef CONFIG_ACPI
+static inline void __init gic_acpi_setup_kvm_info(void)
+{
+}
+#endif
 #endif // CONFIG_KVM
=20
 static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
@@ -1270,6 +1354,8 @@ static int __init gic_acpi_init(union acpi_subtable_h=
eaders *header, const unsig
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id,
 			   gic_v5_get_gsi_handle);
=20
+	gic_acpi_setup_kvm_info();
+
 	return 0;
=20
 out_irs:
--=20
2.34.1
