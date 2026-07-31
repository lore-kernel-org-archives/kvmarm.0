Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011052.outbound.protection.outlook.com [52.101.65.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E614E3E5A01;
	Fri, 31 Jul 2026 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493105; cv=fail; b=Ucmmn8QLRAyJJmp3Pdibd0Fi10xwJDbMQigN+RGTj/6REdg9ze8ipDhg2MkLgP/g4JlQpehgkYpZEQqDAvIn3JPnWZwEMB/MkxXEGi9LMj4iM3ED1cBIJC0PpyynQrLmXTrC2KIxjc1/68lwVgWylz17pEmFNE1YeLge9GPzD2I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493105; c=relaxed/simple;
	bh=/aLf9iS9aYXqUMEdgbi24lnQMGJQuDqjfh3Y/6DRXtI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fvXZOCCtFfLekMc+xSzOhO8DuCYYzbTKNcNFFqSm8WnZuTo2d+c0XleKSpPkRYw+VFKpiYWSVOcVx3MryTcqMAOSDdrBmLMWU0vBd7P5T/2TssZE0CfmRc1+cGM3Joo6cPwWh/iMaJWrvG+TMPwcYkWbzQ3Jpl9UPExB/XCndUo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fd5aDpTZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fd5aDpTZ; arc=fail smtp.client-ip=52.101.65.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fd5aDpTZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fd5aDpTZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wEs4LLL1XpKEKVcbW7HYEppmFsFVqWKnAQXXr6ga0nYWWP8/RA1zZ2q0sGhOlnBL3KqCwp7YV+P09+NSM7okm6Z68IwIKO8rIDfLvwUR6SBu86F+R9odOthbiP38wao3jXzaeHWxLcMQ4Aq0kVQKuiY8fHagGxpt8H04zmFr52AYw3pJ+TuM8xAQ2ottnL+a+Bgr9ArtdGELkck/sf2UJgbLn1Hawo0dmCnd9+JMcJHMDHh6qb3dTNTdderVtwqeNmIOy1LbYqsaN38zdfXa3RS0Hapf9F6mtpbEXevDYq8zK7PBLXY6JUJrCviiDRcY1cI6wZTh9pyMqFHV9TrmmA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aLf9iS9aYXqUMEdgbi24lnQMGJQuDqjfh3Y/6DRXtI=;
 b=uAuH+A/SNVVEYSzJydPwOucfLU+j2B2wSpePTe6ai/pMwQs0zl8h/jQW4HemZdGfLC8GfHWpJ0AT/EmQuNNr6H6alnOi8UM1aB2AfC1fap3fPvF25ypRxRxSXzWcjYop/Uw/xLWZE+8ZdY95q8U/tprhMvvc/NanOK1eFrSiRso3E6iCGQw+4IbkXlTtQr1UvpbwsDUR/3DoljBravwowaan4xA1yBE2PTGSnhqSN5/HwPEoX83z8fVC4sPQbFV81PB/43KdJEk9XVumKntJupfqdHJGNNyyRO1P/6ddMTaFAKkUmf4TKrUslQmBJvDkj3zwZtOE4cUpD+9hE0YiPQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aLf9iS9aYXqUMEdgbi24lnQMGJQuDqjfh3Y/6DRXtI=;
 b=Fd5aDpTZvvJcKUkcVAiZffKFGgTc3GoiG3RP+w+Zp1vws/wqQRZOjE1jgaAS0Y2xck2Edd3WhdnmdQn+9wMYWYN03pIKnaj2CUVTweJo1bCZeIbYrYGe7Nnlv5gEdUpS+BIZ8pC/BiZGwHYK9/ObJE+Zh169hufxaQxpBb5w8oA=
Received: from DU2PR04CA0181.eurprd04.prod.outlook.com (2603:10a6:10:28d::6)
 by VI1PR08MB10074.eurprd08.prod.outlook.com (2603:10a6:800:1be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:18:06 +0000
Received: from DB5PEPF00014B88.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::8) by DU2PR04CA0181.outlook.office365.com
 (2603:10a6:10:28d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 10:18:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B88.mail.protection.outlook.com (10.167.8.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 10:18:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXTa8s/jwRMONGJSdJl3sfqSMUrTZCPonxHs5bwE9lZBrfNoDYDIyLQqGKVWQr01Fqdx2BYAMpaOou5ZCxqID5B2xfaEvgt/VjxPrT4ocqJfBoLTvJbwfZHRdYRHumnMIpNbhMPuDTKU4mRjykXJyCLB9CIz8MxVtltRBkdELxtziXUjykLOdd1O/G4ho2p/8bSeSTN3kwPDBKPzvy5J5EvqjjJI9BIag7rSPr41Cuw+sGRCJ0HrlSq0iQ8S4z2WSeQnY8F15feQ/sJndZqPJddBkp5vsR7Hl31DTlVFlqIjOsajFfkL/7XKwXE7ToiwwaaAL574vHjLHedRvqchzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aLf9iS9aYXqUMEdgbi24lnQMGJQuDqjfh3Y/6DRXtI=;
 b=SFNorp3uU1/T+unYc+R3pwDmm9KcCO+vfjvyTrdbnFHGwgcNqM2Pavb6W9pjuZiZJDyok3ohZHotIFd3b2OthNkz2OM4uaSLHXL3xZxLQ38rFfT4yvwIMAmhgSx99j8yxAVmH+IEbQK+HW1DJbwgSeG5PQtalT/y9i5MsY5F/6bPsUZ2a63kbSnUc8CLAZKr5zY4u3SqVBAk5/1FnxMmbDBqP2/p0kR12mevsLnx+xxFuAurs8iL0g2MKgU7OXTfFA1rDNnwvsukzj301Q3QdMPJIH+u9HU3XnobzqGnD3/4Ca63YTyCdmEBCEU4VVa6V3IFaHx+2wzgArA4UJo3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aLf9iS9aYXqUMEdgbi24lnQMGJQuDqjfh3Y/6DRXtI=;
 b=Fd5aDpTZvvJcKUkcVAiZffKFGgTc3GoiG3RP+w+Zp1vws/wqQRZOjE1jgaAS0Y2xck2Edd3WhdnmdQn+9wMYWYN03pIKnaj2CUVTweJo1bCZeIbYrYGe7Nnlv5gEdUpS+BIZ8pC/BiZGwHYK9/ObJE+Zh169hufxaQxpBb5w8oA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS8PR08MB6039.eurprd08.prod.outlook.com (2603:10a6:20b:23c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:17:04 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 10:17:04 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Topic: [PATCH v4 14/48] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdG1p0GiroGuGSGkuA65XJ2pMBfbZ8iDYAgArsigA=
Date: Fri, 31 Jul 2026 10:17:03 +0000
Message-ID: <f8910d60c5b6418d03e38b48b360082c72adce78.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-15-sascha.bischoff@arm.com>
	 <20260724112751.0D7BC1F00A3A@smtp.kernel.org>
In-Reply-To: <20260724112751.0D7BC1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS8PR08MB6039:EE_|DB5PEPF00014B88:EE_|VI1PR08MB10074:EE_
X-MS-Office365-Filtering-Correlation-Id: 6292f670-b562-4746-fb49-08deeeed0375
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|10063799003|6133799003|22082099003|18002099003|38070700021|4143699003|10067099003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 6OhSzZ8BZ0peBL4dA62MBZh4XL9J8JLFiXFz8HAhHUuUIG06d+suhK+cXK7v0pAhh/XuXAYvEDF6dvs9L6eDksLPGNrOB0+/ojxJV87QDb8pw+2aakVmhCZWN3LzAG3vfUtKvCgacjmSvDG6GgAqcDgxHFE+xgwQRF/MjfvGan9anj7+J7CRbjGbDw/RvJ+4q3GiIL7V/XqneNLGu02AONPyPPUpxTcMUq6jQ+AWN3G18+O1d31pkXPDZl5jF1Dp1Ou3A0T5+ZkBuIvaQZ8zjFbWkPy3QIhoE92QrF3kAtPnrpoMSy6ZQumU7JGrv9Fa+nTgd7f4tSU9pdFeRtLvMj0x3amdGp4SLegcufuhJqljcXjjwzZ1tQXiiKCYXPE7sukHIkTya/KOFdRM4IDAqmOKW5lxM4dYoZEruBdoEI2lb4LwtQ/inll6A67IqdXqi4oPcWXrz8zTeIcGjPucstTiKhb7HaRslXDZCmcSCt9frgsTaJRfX4v3NwT+i2c5/5jwrXCqpzLeOsyePnsNCjrbKSo8wAuKOKGMyQTP5xpMyqReV/xlDTZbRLkodtKsKDy5gqW88ajQ8Ak81pxL5BBepieus053jgLqU8vYTQMAr81zG/WVnzEeflmKjbQyhSfIhm1H/IfPbDI7X8EG3LZL9b+Lwwu+7yxOg41t9aJI06GSAfrqSav5TAZFHjtyshTouwXITZUJjsJE5UxiUzCDXC7/8nlPUP+SLldC3CA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(10063799003)(6133799003)(22082099003)(18002099003)(38070700021)(4143699003)(10067099003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <14ABB8001C049B47B28A3EBCEA0AD088@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 nNCyA/L12796lG7Mz/sYx98z2fSSNX0rq9TqOq2BQiq+NTclHccVKO9RcsvyQQ3GVl81hwWismSOgg1pE3tASX3EDUIAsuXH4PzmDqHumpcu10bsw4JredMCckXqnsxR3S3mk7QNiUeO+zl3F58EQ0sZH4E0Rd2bzrXqdbWXO3eVdv6U50dykMNjZ0MVDpDzC03NDxlggFiXQqP+6VG8O6gxwfIHuxKGWYpQvZspiOrUoq+uwUVgagVUcAf3NU/V42A7+SRndCNEvI2onGVGO7FUNJAZSY+PTdOUmw2wzN7+dTziTRiMPAzsZx/3fp65aYHk5yg2Vot7Q+V8wqUVdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6039
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	94cca4d2-1795-4492-c097-08deeeecde19
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|1800799024|376014|82310400026|23010399003|14060799003|18002099003|22082099003|4143699003|5023799004|11063799006|10063799003|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	GVYFEqAX3KDS/9JsTjuUxw2KTPRErvGVhG2sZCslzR9F36010JVSsh14uivqCDzLPNcYiQ/7zEhoClN6Jz44RhlWGYk0ihxVj92lov2lzNxjQ0JEEkXEF5p/g7yFf0lmfEZK1k00372aptMuKlXql8vF+TClLMLQl29uy6R+tC5JUQmSgiC5aWMkhOYAIvZP2pZ4BPeVyCMpoK/n9a42F2M3jcONfU3upzMZkaccLP2paAvK1ytVRhgSVzVpDYoR7CFPAzjgLmril7MBiVcVsfYkxPB+gQW6C+Ffptc9+1U8nDvQ/9Zy7nBzzIhYEOl4eWhhhbFnLFow14qlvw24G4AUKLHzLB93mT4zxmAUj7joIqrtgD7F/kkbaTtbXwKSxsB7nUIurrHeQhsI2QUpxQ9hlNg+X7B1KWBUjGp0eIcMZzbs2fV6+k69lIhyqx9YNpNjo6v/KChk9wq1xZWsS5QmR4odKoLzaQOL3TQ5WjVSiYTC8oDm7D/Y0Z0jtC7eP5gXEMYrLnYDEH4t3+06SpZzwVLqyV/R+pMhBSCgq49oyPorMFxWh44xW3WVao6CEBxnbWCl6wnZ4A+MEZ279PQw0AstJoqGoex3H0cHOjgN+jU33fJ0fnsFxAbkEgymsMsLqXZuxWSDOR/9K9Z+eNOHTC8k8nnfoE+31Q0Fdq5cO8EKQqCrWQNeE/60b3i7l2ifd5mHFzIYPC/GAtteSw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(1800799024)(376014)(82310400026)(23010399003)(14060799003)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006)(10063799003)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w9Gl60wmzi6/DfFDbQ2yf1GcAfOqyCPPUX+2ppACLwu6gZeejJEOBOGoGNk0SN9r2UXSiclUxPkC+V5q/5ebFj8c2cfSLY2VEi3PGZP2wYNKKNM8858XylBkVCEWLGc1Q4cpId+c/RbBxQr0l5MHbtVIjNjz2OsHtfn3GYJqryyEzCSUWc7X2hKExls1jTlavNkp7UiZv6sO6oM4QG/WreRs8LpZdn7XdLvyeo7Drtbcf9XdJ5PfqIz9d8k42OqwzruwywdqPlADRIX2GyNJmD8cvxMM8bgtc/zvP5XutlnuBIwF8Z3b+jOR5ybMPqXUVFGto0sjdvDgb0cKsigNlv0uOCDRjAswGTeo+H17trvf8dGvhaOi5V+Pr1Al9Ql03TvZPz1bw4urdFfAozjYsg93chinxmr4hqxICUXcPQ2hEhbk4qZC/8/Rz50H+G2V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 10:18:06.4837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6292f670-b562-4746-fb49-08deeeed0375
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10074

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gdmdpY192NV9zZW5kX2NvbW1hbmQoKSB1bnNhZmVseSBwYXNzZXMgMCB0bw0KPiBpcnFfc2V0
X3ZjcHVfYWZmaW5pdHkoKSBpZiB0aGUgZG9vcmJlbGwgSVJRIGlzIG5vdCBhbGxvY2F0ZWQuDQo+
IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzE0XTogW1BBVENIIHY0IDE0LzQ4XSBLVk06IGFybTY0OiBn
aWMtdjU6IFNldCB1cCBWTVRFcyBhbmQNCj4gVlBFIGRvb3JiZWxscyAtLS0NCj4gY29tbWl0IDNm
ZTg3NDE3ZWM3MjRjYzZlNjU4MWJhYWI2MmI5Yjg1YWQwNGFlNTANCj4gQXV0aG9yOiBTYXNjaGEg
QmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2lj
LXY1OiBTZXQgdXAgVk1URXMgYW5kIFZQRSBkb29yYmVsbHMNCj4gDQo+IFRoaXMgcGF0Y2ggaW50
cm9kdWNlcyB0aGUgc2V0dXAgYW5kIHRlYXJkb3duIHBhdGhzIGZvciBHSUN2NSBWTSBUYWJsZQ0K
PiBFbnRyaWVzDQo+IGFuZCBWUEUgZG9vcmJlbGxzLiBJdCBhbGxvY2F0ZXMgYSBWTSBJRCwgY3Jl
YXRlcyBhIHBlci1WTSBWUEUNCj4gZG9vcmJlbGwgSVJRDQo+IGRvbWFpbiwgYW5kIGFzc2lnbnMg
ZG9vcmJlbGxzIHRvIHZDUFVzIGZvciBjb21tdW5pY2F0aW9uIHdpdGggdGhlDQo+IGhvc3QgSVJT
Lg0KPiBJbml0aWFsaXphdGlvbiBhbmQgdGVhcmRvd24gd29ya2Zsb3dzIGFyZSBpbXBsZW1lbnRl
ZCwgaW5jbHVkaW5nDQo+IHVud2luZCBwYXRocw0KPiBmb3IgcGFydGlhbCBmYWlsdXJlcy4NCj4g
DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IDgyNmMyMjg0YTE0NTMuLjRh
NjJhYTdkNjUwNWEgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1
LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBbIC4uLiBdDQo+
ID4gQEAgLTQwNiw2ICs0MDYsMjMgQEAgc3RhdGljIGludCB2Z2ljX3Y1X2lyc19zZXRfdXBfdnBl
KHUxNiB2bV9pZCwNCj4gPiB1MTYgdnBlX2lkLA0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0K
PiA+IMKgDQo+ID4gK3N0YXRpYyBpcnFyZXR1cm5fdCBkYl9oYW5kbGVyKGludCBpcnEsIHZvaWQg
KmRhdGEpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9IGRhdGE7DQo+ID4g
Kw0KPiA+ICsJV1JJVEVfT05DRSh2Y3B1LT5hcmNoLnZnaWNfY3B1LnZnaWNfdjUuZ2ljdjVfdnBl
LmRiX2ZpcmVkLA0KPiA+IHRydWUpOw0KPiA+ICsNCj4gPiArCWt2bV9tYWtlX3JlcXVlc3QoS1ZN
X1JFUV9JUlFfUEVORElORywgdmNwdSk7DQo+ID4gKwlrdm1fdmNwdV9raWNrKHZjcHUpOw0KPiA+
ICsNCj4gPiArCXJldHVybiBJUlFfSEFORExFRDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGlj
IGludCB2Z2ljX3Y1X3NlbmRfY29tbWFuZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGVudW0NCj4g
PiBnaWN2NV92Y3B1X2NtZCBjbWQpDQo+ID4gK3sNCj4gPiArCXJldHVybiBpcnFfc2V0X3ZjcHVf
YWZmaW5pdHkodmdpY192NV92cGVfZGIodmNwdSksICZjbWQpOw0KPiA+ICt9DQo+IA0KPiBbU2V2
ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBjb2RlIGhhbmRsZSB0aGUgY2FzZSB3aGVyZSB0aGUg
ZG9vcmJlbGwgSVJRIGlzIG5vdA0KPiBhbGxvY2F0ZWQgeWV0IG9yDQo+IGhhcyBhbHJlYWR5IGJl
ZW4gZnJlZWQsIHJldHVybmluZyAwIGZyb20gdmdpY192NV92cGVfZGIodmNwdSk/DQo+IA0KPiBQ
YXNzaW5nIDAgdG8gaXJxX3NldF92Y3B1X2FmZmluaXR5KCkgY2FuIGNhdXNlIHVuZXhwZWN0ZWQg
YmVoYXZpb3IsDQo+IGluY2x1ZGluZw0KPiBwb3RlbnRpYWwgbWVtb3J5IGNvcnJ1cHRpb24gaWYg
SVJRIDAgaGFwcGVucyB0byBiZSBhIHZhbGlkIGludGVycnVwdA0KPiBvbiB0aGUNCj4gcGxhdGZv
cm0uDQo+IA0KPiBUaGVyZSBhcHBlYXIgdG8gYmUgdHdvIHBhdGhzIHdoZXJlIHRoaXMgaGFwcGVu
cy4gRmlyc3QsDQo+IHZnaWNfdjVfcmVzZXQoKSBjYW4gYmUNCj4gaW52b2tlZCBiZWZvcmUgdGhl
IFZHSUMgaXMgaW5pdGlhbGl6ZWQsIG1lYW5pbmcgdGhlIGRvb3JiZWxsIElSUSBpcw0KPiBzdGls
bCAwOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmM6dmdpY192NV9yZXNldCgp
DQo+IAkvKiBNYWtlIHRoZSBWUEUgdmFsaWQgaW4gdGhlIFZQRVQgKi8NCj4gCWlmIChXQVJOX09O
KHZnaWNfdjVfc2VuZF9jb21tYW5kKHZjcHUsIFZQRV9NQUtFX1ZBTElEKSkpDQo+IAkJcmV0dXJu
Ow0KDQpUaGlzIGlzIGV4cGxpY2l0bHkgY2FsbGVkIGZyb20gdmdpY192NV9pbml0KCksIHNvIHRo
YXQgaXNuJ3QgYSB0aGluZy4NCg0KPiANCj4gU2Vjb25kLCBhIHNlY29uZGFyeSB0ZWFyZG93biBy
ZXRyeSBjYW4gdHJpZ2dlciB0aGlzIGluDQo+IHZnaWNfdjVfdGVhcmRvd24oKS4gSWYNCj4gYW4g
aW5pdGlhbCB0ZWFyZG93biBmYWlsZWQgdG8gaW52YWxpZGF0ZSB0aGUgVk1URSwgaXQgbGVhdmVz
DQo+IHZtdGVfYWxsb2NhdGVkID0gdHJ1ZSBidXQgc3RpbGwgZnJlZXMgdGhlIGRvb3JiZWxscy4g
QSBzdWJzZXF1ZW50DQo+IHRlYXJkb3duDQo+IHdpbGwgZXhlY3V0ZSB0aGlzIHdpdGggYSAwIGRv
b3JiZWxsIElSUToNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jOnZnaWNfdjVf
dGVhcmRvd24oKQ0KPiAJaWYgKGt2bS0+YXJjaC52Z2ljLmdpY3Y1X3ZtLnZtdGVfYWxsb2NhdGVk
KSB7DQo+IAkJLyogTWFrZSB0aGUgVk0gaW52YWxpZMKgICovDQo+IAkJdmNwdTAgPSBrdm1fZ2V0
X3ZjcHUoa3ZtLCAwKTsNCj4gCQlyYyA9IHZnaWNfdjVfc2VuZF9jb21tYW5kKHZjcHUwLCBWTVRF
X01BS0VfSU5WQUxJRCk7DQoNClRoaXMgb25lIGlzIGEgcG90ZW50aWFsIGNhc2Ugd2hlcmUgdGhp
bmdzIGNvdWxkIGdvIHdyb25nLg0KDQo+IA0KPiBDb3VsZCB2Z2ljX3Y1X3NlbmRfY29tbWFuZCgp
IHZlcmlmeSB0aGUgSVJRIGlzIG5vbi16ZXJvIGJlZm9yZQ0KPiBwYXNzaW5nIGl0DQo+IHRvIHRo
ZSBJUlEgY29yZT8NCj4gDQoNCkkndmUgYWRkZWQgYSBzbWFsbCBjaGVjayBpbiB0byBlbnN1cmUg
dGhhdCB0aGUgZG9vcmJlbGwgaXMgbm9uLXplcm8NCmJlZm9yZSBwcm9jZWVkaW5nLg0KDQpUaGFu
a3MsDQpTYXNjaGENCg==
