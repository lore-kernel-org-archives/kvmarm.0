Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012058.outbound.protection.outlook.com [52.101.66.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CF93AE18F
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747765; cv=fail; b=AirlpRgFqa6iOy/iBZ9SnvDgu0mARyxxJyRrSr0E6zudYw/syzA+so6hpoXTVtgILXd9SvfzOELgwob6+Bx1XRmgNPOaNB0puukt98iJ2e0iqlJM2vGJJyhcmGmWzaFX0LUjL3CS0Ltm/XpFK7ccoY/qh65S7YdciSP3O15ToEo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747765; c=relaxed/simple;
	bh=S0jSX+XpLXhFjX817OLLVQQC/8wFe+lATbzKSIceTNk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gdi6ZWOhrGgD9u221zkPWApPjsMLIQwu0249afcAtI1mQ7BQ/GRsqa7XMCxrgEJK9EO7gJhAue+EGq/aU7f8pAz2aC5KzqZ6rrawyTk2OnMM/Egi1XYObmdtzxtxzGp2xlJjGhOgwl8U5W0f7sWneCPLTcPrLpw03ah2LpLbwyM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gVdAcGeO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gVdAcGeO; arc=fail smtp.client-ip=52.101.66.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gVdAcGeO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gVdAcGeO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gdS+ICKU0cxLkUemRAhR59KR/zu9UWMrqIYJHvCxHQVZ+L37WREQ5jOKOHX31tgQMA0pTPPlqHu227He3frKlwuQvsZD3kMmbTzWrAeBETgUh0TqR+/HK8iqVkEptrnX42g27S2AkaI6CvBPGlOMfKhuO9Fit+yRNCmqok6Qd9IVuLbeCI1KV01uQs+kU12cdnCrtRWLRoKGTNRwV+RPRgbds5q7dtonuv/rUCdLFmsKVR9Pi2/0+6uzp6XzkQ1VXN6mdtVrdSEKuYSC+FY3ws+CovR4XTNobeIjZMmFhMNYGJDz2pBuuEoXo8uoM8yfoRvNpZSfUJHIQpQSy0INvA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=t+Tdq2QrbqgkF2N8rUIs6/59eFECWBB6s6oJ0c1cH0k21ULaJMUetOg65XImA5ni6sIgOPGpZdTvOpwCqo7su+bfu2bmpFv19zmr6qtoFlptT2SJ0TILohT+QQE9ViLAN8xQe1lIelDNvu9qSUEUkU7un6dhQUAsl54gTcnxbBN7UqX9znXNyDWNDQQOg4KNia2Prfeg9t+XiIBhuxIkBxC6wDYyiw9i3JJnsVuZbuTBr6d6KibRveWDZGb6/SqRQloa1TRwvzpPK/rJyUGyYwwHWgtaRXMddgxVnCXC7Uoz9ngicaTzUKodd3wDXWxFnVEUAM7egt8fGXCOvonwNg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=gVdAcGeOawd5ZBrw/u9BSJixyTzPmUjhiMgkMGoLzUIKuvB1wGNi9UBcGiHeBlzQ+y+YYybM7RFCtAZjzNMDSB2RzPmSC4zbZ0NIoy0U0/o4JIOa/RCsZv9jKiSSzfo5kKpntNtP6A7TyGVwrEVF9GND1QRySV6EXjHPBRBxNTQ=
Received: from AS9PR05CA0026.eurprd05.prod.outlook.com (2603:10a6:20b:488::31)
 by AS4PR08MB7479.eurprd08.prod.outlook.com (2603:10a6:20b:4e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:42:36 +0000
Received: from AM4PEPF00025F9C.EURPRD83.prod.outlook.com
 (2603:10a6:20b:488:cafe::d7) by AS9PR05CA0026.outlook.office365.com
 (2603:10a6:20b:488::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:42:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9C.mail.protection.outlook.com (10.167.16.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0
 via Frontend Transport; Tue, 17 Mar 2026 11:42:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCEeOvWDqfHs/Gu5q+tm7nbS6EbAMB5Vsa2aJ0nSobeaNYPo9B9klt3N13XStTG938q3xdyYW2/ryRQxY0cWYNI4D+JAfAHLxM6p+1CpX0WakRnctNlv0VkbLC6F9YAnkIpQgPs8dhWckiFGlG5j5XMezcJJYPAWxxL3MI4fAom5Mf/hgK9eJ2vFSEbcbvkqNEnDBQ9QsUs5dMOS2rfqTGYbEu7BTYxHWMSArYRKcuuAY+JCLO2i/+e3Glqunocc1n7iv8QTMGx4jWs7af8y99kIIcbG5+3yUsCLB/LLnCtQdYv16UGnWE5bAsfdKQVBtq+ZqTj4y2xiv0BO/wqdbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=thJf6uEdX4cbTR46YMqY3KwNxLk4okA2tJ3Z7BCl4ptkA5J3bZ/SDHQ9jEol/pHM5UeHA/X5u4wOYnoc8cmMtz9qisTceafJwhWWnm2pKJw0tS8WXe+xpSqHFM0rlMxOTLxuv7FM06LhI4hQjZ9u1IjCDEwZfQtCy/qgdqqct9Ru9MaCz8b5lFSNBqQtneo7gn1HsnfqGLfaF+qu4kmw+cqJRxXAEGAeHVm5Y5pPo+KxSTAARHw2pIjBMJXnDTgGHx9tjJ6BifVodWHQRBdrI5z64qdIDnUa/2HO2H54S9fYzgTpeWk4Qw0GvDULjyKjC9R0+e0rGfpE7uHpZDU+GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YQghSWbTt/jnx4d5WQqLC4OFvC/R38D7bVUUOMANxU=;
 b=gVdAcGeOawd5ZBrw/u9BSJixyTzPmUjhiMgkMGoLzUIKuvB1wGNi9UBcGiHeBlzQ+y+YYybM7RFCtAZjzNMDSB2RzPmSC4zbZ0NIoy0U0/o4JIOa/RCsZv9jKiSSzfo5kKpntNtP6A7TyGVwrEVF9GND1QRySV6EXjHPBRBxNTQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:41:21 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:41:15 +0000
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
Subject: [PATCH v6 05/39] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Topic: [PATCH v6 05/39] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHctgL29Dotqs/gQUKGgdkGfNewiA==
Date: Tue, 17 Mar 2026 11:41:15 +0000
Message-ID: <20260317113949.2548118-6-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM4PEPF00025F9C:EE_|AS4PR08MB7479:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9f4520-fe05-4594-f321-08de841a48f3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 AMaUngh5D5PB6Adm6Vyhy82Gisu2OoctQUSS3RduYvMT7grT8X6HgTbwoXN3C5vLHsXpyrz4eVe4sMCyVk6MU03Ulal+8drIGTx+bzF7qusxiZjwyr3qsieQGT49GExldykacBwzDQIBt3KyyQdsOgMDnq+cK5tkIJRjsqO506KokCPn4VFynk1ihQicwJPIJBiTdVs+RHJZ1A5W/TwuP1b5DthvRCnmdf7tpkg321YDPYlP0ygFcAN3duKdTypTqKxUnArJKGPTXnifeLvH1ZOSEiFV3kG7kYRvovDJ37fMtHbMTuXHJZW++YwNt+UBORpXMCYJsrRvXTrCfqWsXj2YjT6zI/H/wge61KhnJHHigachMLYIwjZlFyWzrpW3Rb1lwJycRLgZy5orzMG8OZpL6KJ8BJUMmXyZIQWyZYg29Tx/eOoVSUUb/iR8Kqw5QsAfFxjGLLYlLJYa0Kv5z5YVHaEU76GIm61uyn+OIFUlE80jYbj9mGQ+ohWpH7kXXzEoAfICA8p50Ns7fdBSUvoTtX7p9xO4PNkqQbXsIIvT+joxJ1t4aEeeEKbpWJOzOAdoyZYTGVeKXes7bmGltsxDV4aGmR6ouoWxs8fEpMkc+OBX5dDh33sN/ZW4laPi1TPuu/xI9lU+HTfZUqsJgu7DbVXhHI7VtflleyXswSVJ/rNR9XmJNQxDdmDjLkVzkCwTQVVLvdbrfI/fbLW+BuS6Cjq5RVO48rUAG5U4ozK+KaM/wUD3c5DQXKO8f02P+qr7kqX+12p8QIxobXzpCZR3n/OiOcNlF1jrGUCZc8U=
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
 GEX4C2kJ6lRmdm6ZhFuerL3pv1Vz4fk/1BOFYZLq1hKcDsi7wTLtNJhTM9x3dDKFgJ5QX+wcyvWy8Gl2omHoJmUKI1ouF9bjix0XHDv6YcZd/yI+i4JUrPmr2kfP63OjyXF90WTndoiMQ0H+VlrZnzjQZgsAFSTx1dB48C81Nfkmc1wuazv4Hwx14ISTLoqVbJQbob6KcJE/ngemLjwkUkSwg6xAGrR7oiYZTC+3qRSunrKCf1tgWNKybgXWSLcnW8l3N1PEeJu62byosxX4Ci/eeCFuoUUgzFL0SrWicbIN8qWc3gphpm4o4TR33KVp1QUb4Ai91iDkoWNYq9oBZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4212f631-40f1-48eb-3c20-08de841a18aa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|36860700016|14060799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Gk5loava051ubfs5boEwDfXcZdLMnIabwWX49u1kmd+yHo1WXYUzXLpjvkJnOFXqjTMMpPLvAEMd0wTA64fIICEjEd9xCG1j9khHzwRyVVPC0h+kBuDHQUbHc7wdfohPK3HorsrBK27JM+RbCgyGakQZMdiJWzthXI9517svfanHdOYNg/BTEu+JwO+frDjjMDtalCiaj4suWI6quR7MqU3ovgzM0MkVENNkNl+FwO+Ag18PiQeAbIQFLrIyhCaCLFaSpMIMebDGJACKS4L4hUlkpbmYYxi2ZRm/v7+v7kLVb8fhNJE9BJFe56zRr0jX17MjEp50Y1ps8Sh5l1YTGnr49O+hqm1B+PeEHJHopNpjKlKX9+0h6SR8j5Cy6KJz/5+IRk8ZtckkgI87Pq0UxP8BrV/CDMnm3wDHoxomRmTOclqx1mCs6uvXck2r6AHKe3rsE41q++ykQYlCFJm9M1c5EIjTlOF26TWtz2RSAK0WgaoYr8qW92IYrpfoU3njwebAledXISOa1g5R1dvft2LZgMI2KyFhQHZNYVkta+6Hrs4C/EEI37M3QQPdJ/W2Hs+kZDmq2l6vpS7N7EZpQPUy//T/T9Px3SOkrAp+2H0sXy1NS5X5Yg2oat7ptO9wcTR6DprOch0wARjImcjH/294xOeyIDyu5KV6M2decoPcGqhcijifA9FBu9HQHYe7GNnWXl7KeNjk/bXJzTDkUS9Gpgu6ILdcdLb/abHzW6L8fZpj4N2ZzrCXLXXk3Qqv654LsCAQsSdTEU0uij1XhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(36860700016)(14060799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VjduJEHGv9qVJ9uGMXpWJS8yEr+LopAu5EG1ojibSQ0VTQvWwbb0dFgkh03M1CYrmsrbHBesNkUd7dkRgAU25I553FLMJHDuGxIqDo947Hl/Tm8JvxNJcb19xwk4CyWPEs5gv6TYOx9IQZuvt0h2nv08KPq6D8Iv7stRO0/xQ1tCw+yP+jT6VnSq0BQxMZRJefAPje9tHXDZAu2YFF0v2LmLSh+jWhasItfDiHb0QdM8V2WQZn5VdOkNkYHXYdARgQNXWK4PnhrHO78NUMYKEXKXXA1s32IYWrMRtpe1MVIJVKNgAg/LpSF2O8Ay2hxjWOpQJlHSBlf+/0i3nEbZ+ktP04/0C2DcY0On6DGSWyzZlKj/U3qg+pxibIRX2e2BghIHI+bPHTLH6w6FNT2DCZLRCLSweN4nfv8q0Qp7GCNOK/EF2lWotrbs2/QObLFM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:42:36.0096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9f4520-fe05-4594-f321-08de841a48f3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7479

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9d1c211080571..51dcca5b2fa6e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3243,6 +3243,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3257,6 +3265,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3663,6 +3676,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4687,6 +4736,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4735,6 +4820,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4789,6 +5174,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4810,6 +5207,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1
