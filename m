Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011023.outbound.protection.outlook.com [52.101.70.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878D3E95AE
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935921; cv=fail; b=V7P2rzVWVhTs5oUDObzNINQBot9YRhB4bOeJQFQ1UE1F4/L+vjctWX1PhE5TXlBMFo766G+rM9XUyoIUszmSOgvQpZamT+C16gNo14i/4eGtzjttxJ6jCTJJmM5znL1jucJspC04t/VUZ8tzpYp7ZE+KP69WUtHutt3BOAszdCc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935921; c=relaxed/simple;
	bh=xdtA8Vzp3svIN/SdAKkk36LKGixanzOlFIv1TuhbdUw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tknt82atNDAGgk3PJBn0G9xlhtBmiu6JH4K3XPynBZ6y0iVeFNFIbhRWhH9ZICn9A3LGBlTKwn5BeIi7YBgAZHFWlrOmVUdheMWsc+0pKsOHRtDznJixEqKYZPtnlx7sgFv9nY9TriA//rqD9WvCU+VA0aeNdwXRKp5R2kr1PcE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZuiylVEo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZuiylVEo; arc=fail smtp.client-ip=52.101.70.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZuiylVEo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZuiylVEo"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JbJXA1ni0YVMAl6s7WnneYDbE3EUO2A4QJJUDSzqLyv57XqAUcIvjNEPO7xJYaEFZOPw0POC3EOepMOxy/oS+w+h1w8y/GDouAoar6mxBI3upD7mljlHjkRxre1vyNLEzBrLlTPji7xHBRliqGpwBGRhCWpga9VM39gSv+UcvS47vgrFy49CcppSIuuCkDnRIyxZ9YlPTq4VPjRWC0fCrVv8OSKB2Bd1/TsaM5ubuxJuJZurEbWSzeqyU3KN+TSth5uQYuhdJpV3f+/8qpv8TQOeGi66zuqa1Y3rbD1ebqC7Wh1KCtZcc4/SMe2UTuqXhHxmrdlzuVe0BkPNYdXHOg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFBeZYr26jkFgZic8WfGKcVexh3Cn6TmFY1lSNrvWxw=;
 b=Hl05fWWpdQuV1f6oA+3Y0iCRX25de89sZYak0QcHHQHo/YKsaTmA4mYnHximkWJiMt9plHVfZf4CWYw1dNbXRVIJG4qaukriujh9mer6YV8xryOLmGx71jrsdrKXSQ9hs2rwtCMI/YXNvxHxugwQXKfs7jMpNVP6YjDbrbWH+F34IMcFnqYvXXR+PIPFuSYfk4HQqIL8Xwnu1J3V0wUY0flkDOwczfdVPb5Q+2kJF6XgBMmHcYqPSOFhCW2f4kuExCZC69SVvACTNs/fho+czhZUMo0jD+H2Zd5G3JOxDKNyxf0GIrgjKlxbPvwKwjj1cF56NT4stgf8owBZV54Low==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFBeZYr26jkFgZic8WfGKcVexh3Cn6TmFY1lSNrvWxw=;
 b=ZuiylVEoT5xlU0r0LdtQYKcwafoJgWI7EY5yEoiiD2mgq1nVfx9P1PNLlnu84+NsIi3ayBhrSWCqatXoAJTa/5vDxODLAIQGp8C8WHhe57/N+OqXmenY/X8ntGfQBNRXoZ2TkVdyzSvfHA2SlIbAdj9iVVAoL34BhQxCojDqOSE=
Received: from DB3PR06CA0022.eurprd06.prod.outlook.com (2603:10a6:8:1::35) by
 DB9PR08MB6697.eurprd08.prod.outlook.com (2603:10a6:10:2ad::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Thu, 19 Mar 2026 15:58:34 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:8:1:cafe::a6) by DB3PR06CA0022.outlook.office365.com
 (2603:10a6:8:1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:58:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImINtkiGuGqHsbderFCGgtJIspiOpxCdJL3jh3nI99rmRXfcEx3FRzboJFTS4OUf3ROf0vHKQ9Nk34faK7IY58do5jX91ZpAJv1cOVC93ipMkoZlQMGJ+0qOGN0xXuiW4GcI99+QmBfzZi5R2UN43MksP0odOGZcB6gc64ipBRUaR9esxZXAl4yaE/+cXkEAIhCZjLN76rKR06zPhxhQr7HMcrbH1i/er4o2jz0N6oBmuhLbFA6tzUq7aSFSLDyOaWIoDig/cN8YBM5FwGPj1FXeqBvC5pEr/AvtP+svT4Ey0+bLm0i6ayfjlu7pY7tDhZ8g00/nX8e+ig4cpOxHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFBeZYr26jkFgZic8WfGKcVexh3Cn6TmFY1lSNrvWxw=;
 b=jCInDK0qZ8qgAWrtN5KVDxGQQfE8o4pVf+sPtOq4Q3I8HijbiXjLy9BehbnwqUkzY8AEstqcCEqkGu1T9PglKChzQV0WRlk90y2CxKZpL046zqJz6IMtos0+gBDcjaVwv+U6Yt7mTCzqHGsr3FzWFShgd+svaJoeQfJpFaXHMUOzCRvU/FZPklabnIHv1dyonIe7L0N8o+bUOfYQou+zn4o7KJG3bpoaI4lfutuZ3bLEnWL9c85e+lp3mhJ1FdeDN6p+xdf3vlNbHbdEn7ozA3u6qRCiN3o2mGf7eUNrRjGqC7gkn55DaTv2gacmtgTx4JAKcQUcJ4mhxOnfiHHv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFBeZYr26jkFgZic8WfGKcVexh3Cn6TmFY1lSNrvWxw=;
 b=ZuiylVEoT5xlU0r0LdtQYKcwafoJgWI7EY5yEoiiD2mgq1nVfx9P1PNLlnu84+NsIi3ayBhrSWCqatXoAJTa/5vDxODLAIQGp8C8WHhe57/N+OqXmenY/X8ntGfQBNRXoZ2TkVdyzSvfHA2SlIbAdj9iVVAoL34BhQxCojDqOSE=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:57:30 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:57:30 +0000
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
Subject: [PATCH v7 30/41] irqchip/gic-v5: Introduce minimal irq_set_type() for
 PPIs
Thread-Topic: [PATCH v7 30/41] irqchip/gic-v5: Introduce minimal
 irq_set_type() for PPIs
Thread-Index: AQHct7kXnS4xjf6QVUmKmp0YDPwKcQ==
Date: Thu, 19 Mar 2026 15:57:30 +0000
Message-ID: <20260319154937.3619520-31-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|DU2PEPF00028D0D:EE_|DB9PR08MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: c575506d-808b-44f2-89e9-08de85d0600c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 f5+SvKR6SCe7B+d/NZGR9UlEbczaJznz4bplaNJb4yd2uYPqw98UlKMhvmOk/LkghsOUsTYd/hSXprI3OPyxMrEda9suhvuUwPg3AhXSdaxNL5Dc80RWs3fSNInWEQj8Iv+URqUJ7blLXHuJ2GfFG8nXINVKt6AbmqRSsO03ZzNA25DnC2xO++CwsTSImk10mhce0xn9EIRoqoo4AksyEFV8eZPi93k09zTVyIQWc6zgXEQK8jFFFK0r+RhIyPc4ub8vmqjJcKRucm/o507yrzZaQ6/ZdV1RXFVYrsM9IRjeJpP5JRgEu11y1mBvEvYzgfOsX+QJfTWqXo/lly1KTxytV4nxSVPr4tsbPtNs5vekRBOh7w3XTTvpuTB5bG1DzHIlnmSxGO+Tvjbd9BVz28SefjC9SIf2YgsrPVbNqFHSfknjfn4vuWsJV7VfPz5q+tHtH7V5m7lcXyjgznMLagLF3nnPd1GPaXogSNTgeezwYD1YOf5pX2JIYPsc42Vh2J0OnNMyYjumfqDidxnCXrZ9ZD/jt6DCLVFryq8uROmv2MeAwyQq7tjlKLI3YHb2322oZuIMpLV1vP2JXrZbwlt99ptTdKx86Qv1c822ovUfQiyhmvqlro/80ATc9WwgoqDG3mRp3VOtuo2RxnF3GYdnerHVdfH9cgbgmJ89/D/OshOIM3d6JyEvFyjOXwaGkQyndxhmr7iZuCG8VVcTlsMiQqrLqI7+3JvHu4FnExGBjIGmNtV+X3gCYNIztJGzMwW6TgPAfj0S1R6sQjYv9aB6WxZeUrGSYtSauTIDCBM=
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
 nIfL6NAWlrOXzyeMa1Jpy6aNxHkFVfolbKD9KVTpOJB3R0whbXqXr7sr7QoVxM3cAZAYEzbpvt2DB+8i2aYg/TL9VI6WtsrZx+HZptm8Dg4lzDN3osy6E7Y9nBa3N4eZncaCjaHgUetFE3/9Ta8ThBZLWza8HCuO/Olp7hqCLrtGmL9fm9LyZsv11AlGb6x22aHKKq81JKQulmAOe9eT/bL1+K18hQKt/T2pxyyd/E2oyi4isAiNi0ksnbrvLp1anad6Lim0S7Q5+TCpEpG+CcCF2gg1gHrKnZJ+09ZePQ1SGfNLqSo3COtZ9A7s0Q5Tu34x3/rL4fXwSN6la/KZHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f2cfedb2-1999-42a1-7fcf-08de85d039f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|14060799003|36860700016|35042699022|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PmLGiBXQi3nld1tqisTyH0d6OmCjTXYK0E+nHqQNGPHHcWLSTgpgC3iJ3VEuNocX1JEMAGMkfolCJ0qMXU74CGO4sEIxDE8cgpuzAtN++idqkyoy+HyV/lJF80B/tGCwSejeL2TkOuYDuy8KgMJuS30fz8rvfHuaSIH/kjVbfvkWtWeY8W/MMTk6NhF7voqS1GLcaPvj12Q37e0lwKzmZa3+k4k5infieNwDIzp+lsNfcQnVKO/MC2AywoKKFILsJtJDZUPXky/IyHgE8gtJtM6cOPgOCJLc8FEv3Bhb04BGRvXfijdT3DYeYL+DGUM5UgKYRLLBHWOZ9ZVKyYl4VNFTDe4INhAfD7Q9MNH2Bw4V9InKPwkzWzZY+sqmTpRBjfvbrBX1dgqQkYHrhd3iWOb7qbdz4cwKU1cCYqXN+3ltaA6ZpIPegbU7rV9rve2jRnEm3PHDYE8BQoRjHLgX0WfdZEZO2xynueAHplOda7d8EB2VZMGilc1JEAw9dZ9xbTD4sbfbOUUbHqP2WPMgpKCnoMF6m2Yb8P6384Kh4SFUvFTeGGbtQZHuemmqQMV1GpBqIdpuMl8r7RzjGP0a2T9/SulylE1gfwp90HoZtm9b39kl2OM0sW2Sd1K2C2jsElkyCZjxcFQtsfTYuKUF71SYbADI/isGqpAovNEs8l8vjGR6n0vnh/78rjTFBxXHXSYcpNGmhc2dKj0ja6aGmF7DduGPlgHsFmsGeH2coXSFVEAEDHotzNR6OMKeQFnfK8lWtG6rG5iop8WjJvsqWQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(14060799003)(36860700016)(35042699022)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M7M1rCAz1PIS/h0LVsWKaO2K7qKXzh/9cq4xy5gURkE9SW/3BPl48rio1250sklODjnTy628hEFtK5+aldTsNQTfvtLR98kYMQET9ia5Fy7TsO6uXLa73ARYLk3mVM8MUfUOTQUQ9jbEg3+1KMz0apLoUNWkg7hs+KGZEwimSGXoTV84+Wvq8NQ7k/NoHcAzNQAcg/BlgT8mcxppJAHgNLSFbGOgy9hrtVnm33vTD7uVObNe0qV+TEc5sp2UjX1IQ1sAyeWDfh+aiANI75WSYJNGvP4OcVRalBh2BtW4kmeLPGrkxNu75oBAXHinSUpvOg9bDTslZ3lu+lk2BxULp6xnff5w67LvxMqAmPIaCEFZ/7HvnwlwliX4197ygehzoKo+0fifTxAKlPfczOUBnlAmJuiqQGQdDSctgKBuKbKlKe7P/Q7eo3Ld8CqM135a
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:58:34.2938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c575506d-808b-44f2-89e9-08de85d0600c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6697

GICv5 does not support configuring the handling mode or trigger mode
of PPIs at runtime - these choices are made at implementation time,
and most of the architected PPIs have an architected handling mode (as
reported in the ICH_PPI_HMRn_EL1 registers). As chip->set_irq_type()
is optional, this has not been implemented for GICv5 PPIs as it served
no real purpose.

However, although the set_irq_type() function is marked as optional,
the lack of it breaks attempts to create a domain hierarchy on top of
GICv5's PPI domain. This is due to __irq_set_trigger() calling
chip->set_irq_type(), which returns -ENOSYS if the parent domain
doesn't implement the set_irq_type() call.

In order to make things work, this change introduces a set_irq_type()
call for GICv5 PPIs. This performs a basic sanity check (that the
hardware's handling mode (Level/Edge) matches what is being set as the
type, and does nothing else.

This is sufficient to get hierarchical domains working for GICv5 PPIs
(such as the one KVM introduces for the arch timer). It has the side
benefit (or drawback) that it will catch cases where the firmware
description doesn't match what the hardware reports.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 405a5eee847b6..6b0903be8ebfd 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -511,6 +511,23 @@ static bool gicv5_ppi_irq_is_level(irq_hw_number_t hwi=
rq)
 	return !!(read_ppi_sysreg_s(hwirq, PPI_HM) & bit);
 }
=20
+static int gicv5_ppi_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	/*
+	 * GICv5's PPIs do not have a configurable trigger or handling
+	 * mode. Check that the attempt to set a type matches what the
+	 * hardware reports in the HMR, and error on a mismatch.
+	 */
+
+	if (type & IRQ_TYPE_EDGE_BOTH && gicv5_ppi_irq_is_level(d->hwirq))
+		return -EINVAL;
+
+	if (type & IRQ_TYPE_LEVEL_MASK && !gicv5_ppi_irq_is_level(d->hwirq))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int gicv5_ppi_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 {
 	if (vcpu)
@@ -526,6 +543,7 @@ static const struct irq_chip gicv5_ppi_irq_chip =3D {
 	.irq_mask		=3D gicv5_ppi_irq_mask,
 	.irq_unmask		=3D gicv5_ppi_irq_unmask,
 	.irq_eoi		=3D gicv5_ppi_irq_eoi,
+	.irq_set_type		=3D gicv5_ppi_irq_set_type,
 	.irq_get_irqchip_state	=3D gicv5_ppi_irq_get_irqchip_state,
 	.irq_set_irqchip_state	=3D gicv5_ppi_irq_set_irqchip_state,
 	.irq_set_vcpu_affinity	=3D gicv5_ppi_irq_set_vcpu_affinity,
--=20
2.34.1
