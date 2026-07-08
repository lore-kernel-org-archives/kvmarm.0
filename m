Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013051.outbound.protection.outlook.com [40.107.159.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353823B71C7;
	Wed,  8 Jul 2026 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522255; cv=fail; b=pDm7XL2Y4ESQGxX/TKwLEET6674xfse5jHEQRY7e7bGwBkzYejPfWNJsH4a5nRZz5DaucJJnIYEB3kgnilloea+3ff3t1sWan67mZbdZEsuTS337Y8wOqC4MEPKN1G293xb/4uoWa8IxUg0e44IZhnftw0hjqejvP3eEln0gPkQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522255; c=relaxed/simple;
	bh=RFrYzDdA+4Oka4jHXSNFtz9ZLQ3rJ+wHTy6LE/S8KF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jO7IaLEsvprQ5BGbYmSDegGtSzPfaLpkkwbNRzjf4dACfKMUnQ7PTysd1yeOrqd+bDOtxeGCX553JJTDifXZv58UFeBgb74fUi0964W2Bo8VJA/5aQJwSJjFXov5zLisexbbSz1YYH/A/WSOUqb5nSBT29eqem0ZTKx2PMJByNo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qftdWWDa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qftdWWDa; arc=fail smtp.client-ip=40.107.159.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qftdWWDa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qftdWWDa"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LVplReC4fTGLSivBLkgEX1ZFvv96wH+GltuFsR1DnKpyn4WkOG289ypNOZgubrtHWv3vbzpPsE55mP9zUzQJF+KJNr53Mqo3Tl7Is7zzy87Deduq1vOg/EfuXAr/PE082MIVtJLQrqnSJc1yl0UNwdcV7F5YDtH2jwuYvVh6KFuHG2sIS9ZBRCw5X/rEa1NwpibTdslH1L0+ypmN9l70mbXx426m6IXXojYMRtPi8Mo8eCVzthzCz6wjGpD929NjJFIP0yO4rW8QRB69Qm/MFEL0+79ePbfP8GnikDmgpq8RYPSAKJqczVYf+XUjMWEtbDZVPYmCYmty2WJP4dNb8A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFrYzDdA+4Oka4jHXSNFtz9ZLQ3rJ+wHTy6LE/S8KF4=;
 b=ChWeEKnR6C3+ssrVH9LWXxdMHyws3GSsLplYRLUfe4sSNseLbRT/fX6bhVQ/Y8cos8QFBcvWEFnefrDHKqb860QAlhkSjahfADAeMFUITz05GOsy4Pqyg/K7FuwdU3TgXeGk2UbALrFQ6bPlC4saib4AYbdj/ECMqGobrEzsMV2dYn6O4NQQk6c0Y4Bq0fm0Gd8jzAXWgla64ondC3NKOtAouNmKoGTckRpiDbvcbWD1SQViy3HXn02zqYK5qQLgIvuSQzB8UXFn1c4id/xyhLqN6qCevWH67fEKmNSUa+IKxErYn1Yne+l3Z/mNZBIgU1VyBQUKrhR1D2klIVMdVQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFrYzDdA+4Oka4jHXSNFtz9ZLQ3rJ+wHTy6LE/S8KF4=;
 b=qftdWWDagzf26pAiBvghDFJFIC8PO4u3eUYy/xvwLExvBOJOWDSPy3ZJFYqH4eIejhrRxKA6VboRym2hlmXkr8FnQjP82YnOvBPO99NeVvAmkmDzUUhlMwwT7Y7JFjqz+/J6cWm9njxYTRSlDRnhUN3WSMc+T/dCvcOb9GHKsBo=
Received: from AS4P251CA0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::19)
 by GVXPR08MB11058.eurprd08.prod.outlook.com (2603:10a6:150:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Wed, 8 Jul 2026
 14:50:42 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::4e) by AS4P251CA0001.outlook.office365.com
 (2603:10a6:20b:5d2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 14:50:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 14:50:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2smKHPQBbTWJ3/3xs+AO1dM84UE7/hSBUoml0a8N4Q7WjSOJGM4k21hMjwZFgE/UMWXEjCv+161GT1omMyWyxPBMtXSs+5HuJpffLegThO6RmI69Yu009VNSUOpcL9P22m8vGXf1k+OjkYegCXdEkuwVpkvQUkrz4UUrryG4rwWhUo2+17qtvzMcBwrwMGk+/oDa11cV+jrCrUtHZBaaQlQ/hEIaKYWjxJLllx9cm7v/vzAPIHrIkwYWH7Mb4Gbf6Z1kJC/ODkNqLrTv890thx3nTm61Eso1DEhJHxReGyOaodqpZPvmm6LzEr3SBRLm3kjnw7a7FbDWyH7VflT8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFrYzDdA+4Oka4jHXSNFtz9ZLQ3rJ+wHTy6LE/S8KF4=;
 b=pkBiSIIp+z/TXO2/5HgFvdek0Rvq4D96aUFc/BVO5Bte3xAqsYAZS/Q3K0JAiVDray4viDJoy7Pc/tFZvTV2IBaRvUeSrR9Cs6WGpflJVEsp9Y3WjNOMFa+fEtOQAgTX8r3v6Wb0+HhSSAl1qtK/chfVM6XsfIKV9ni1sXKFA8kI0olZKYBIjjWF4KfeEuvCltkRMJOQB8QDOyOmu2OTQReuF6INY7DxWbWMPS1wOhs021W+o4LeZL2kXS6taMJVu0DReVvfrm0dK3e3I7Ppx3S4ArRYXnYLqdF+wnE0+pns+W7SUe9iDD0Ss0cIrmzg2ZDuMQZEIjaV+kpwO6f+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFrYzDdA+4Oka4jHXSNFtz9ZLQ3rJ+wHTy6LE/S8KF4=;
 b=qftdWWDagzf26pAiBvghDFJFIC8PO4u3eUYy/xvwLExvBOJOWDSPy3ZJFYqH4eIejhrRxKA6VboRym2hlmXkr8FnQjP82YnOvBPO99NeVvAmkmDzUUhlMwwT7Y7JFjqz+/J6cWm9njxYTRSlDRnhUN3WSMc+T/dCvcOb9GHKsBo=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PR3PR08MB5659.eurprd08.prod.outlook.com (2603:10a6:102:83::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 14:49:39 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:49:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 11/40] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Topic: [PATCH v3 11/40] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHdCwR2mumTBChLrEC56eoT9oUBubZb/wMAgAe88wA=
Date: Wed, 8 Jul 2026 14:49:39 +0000
Message-ID: <322387d777eec2a35b267f56ff340f885104bd6a.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-12-sascha.bischoff@arm.com>
	 <20260703163933.5F7E11F000E9@smtp.kernel.org>
In-Reply-To: <20260703163933.5F7E11F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PR3PR08MB5659:EE_|AMS0EPF00000191:EE_|GVXPR08MB11058:EE_
X-MS-Office365-Filtering-Correlation-Id: ef41f9e7-bdcf-4c52-7a87-08dedd00488f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|3023799007|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 tdrCgbgvHCGXQ7XdKljQxv9WD3tqFrqi8O1vsTqumn5untJvZ4ZIi3rv3X3HpIGabruLocHpmLAVMtLS+4gB2nKhJH2yxhNeBiL6p94gd0lRsY16GwWMwD7h8Xz7ICAXfmL2ES/2ZvSDGE0H2zUmXBWLxnh23BZVbh14fsnEhxraKcQvyUoFgSgudleVu/fh1EgHatPMG05UzJWMWI28Kco+uaNo9u9izceoHUxIT0ssQOleHndf8cw+DwqX4biWa8mB5Ob8zx16hnKgAdvd4hT2qKMYOQq2W6NJk2cwKYcUylYInRtiTL9h+jIbirNk6CKnq2D+6m9G93sypr9fjS9ir83ZoZG7EXop59RzrSSd8W5qr5q9P4SLX0mak6Zb1LL8ruwZEc5uMFXfXU71YfF5V/vKr4wIvD5T5XtZGLFg1oKAKyz3nGvTwfahrJV0dG2JHBO1a+Pa+duJQJBlzLmPkCuCALooGqhDJjvSx7KNYmkWM/eQQej0y11ngtFS54B9qfa7de1Hu7BVQAzjaVnszuOh9DFpxwBgkGJriu+lkqYAhGK+FbOtV/ELdMr9xfnzD+lxAeWlkoQm80/D8iFAizM6GbNAXeTtM8fFhLNVg+XnFj/Dp2LwbwSFc1KQiWZab9c7pcBPlGYyKrWRtszy7J4CDWtUw81OXJEyCqtWo6WYXCmGePIflMPJIJdcgn9z6x7bHl7H9DcXIr/IXt3XYo6JBR6CFBwxej0BVKw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(3023799007)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C2F300B3A531C4B8601133FA0825DFE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gRO6gToHUMztttLwObEtaJz+Cl9fzMQItfu1yI3L2l+7eLIelGsu41QwZX4LowF59DMQB8A/g9ll2+S8hXHw8L55z3h3LKFicEWi5OWTeBU8IP1zKvzI2rAiWmXsn+HozPU5DbDQ+jTpc2oDwSxscBiI64P29LE4JpLaJflheg4T8mtSB8RJA91QtADcPIvYUK85v4wB+oME2Jd/xcOOEkAEt3XrmO9Non2KQAxohspL9IXetFYEkwmIIi0/7O/O5lhCFONG+1W6RE9MBkVf972lXxXgUqWmMJMnqlyho+yTMEk3yPcJBl7ZiIojL1KfO5i3E6eC2zVivI1v9pVwTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5659
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	95acce63-f115-466a-0be5-08dedd002349
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|14060799003|23010399003|35042699022|82310400026|36860700016|30052699003|3023799007|22082099003|11063799006|5023799004|4143699003|6133799003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	JPkjcFoo6IpPNPCJvvEMhoopPD4gTzBQ+GUdW+shk+KS57EgcpV9LxfXwHDNzHvDPBRQWDvbMcYcqbUs8MgnCal18mGPbfGhHs8kFFs9K0yZJdr6Jddu4oNOZ2b86UlYjAdAmZYMF/04ebWc85dr7tzqSC147ooodguaCM3G0EeE2kVPdH5bPEKnD6XdIUYfKCD5Dh/o0FlWp9CSW37iD8+KWgnUAR36kQQGgQgzF4wLjmqSbuZd9Df6uj25sY2EWKDhtzwlDaMCI1CHc9nso2cviaoZkX/F5b0b/gjOqErN4JGEzJTmXGh+5paPbeeg7E8BWzFgboMmGy+90v0C1m29bibM0RTnZsdxl7aXKzwR1V90/X4mR8RK+AiNDj9AS4cOnFLZK/kxSibEBBgpanydPRKBle2AIDqxpwYumBLR0u33jLJMNTIXh9LsOehBv8G7CNmjURplkIMiYm+32mRtCEEJYlgjSkWHv6mUc3mEpOfq0bQqLnPvFdNk6Mao42iORb8mNL7hvwmoPaNQRWzrtRlH13qw5LQdrKUwXdnGoK6NnrVcDw8F3t347IlzOIm74kfKQ5/CDmVb4CHXvNm7M3qRWy9RrhlwfUzyfA3W1fDq3b+YJBf5OGlxCeyYDK+pDSvCRSwp3FqtnT49lojXBVOwnfoNxbOzL47CPqS/GG7M/ggppHUs+Z/2mn2oc1gw3RPihli2ycXjAidtSQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(14060799003)(23010399003)(35042699022)(82310400026)(36860700016)(30052699003)(3023799007)(22082099003)(11063799006)(5023799004)(4143699003)(6133799003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UnmG1O1MJJ/zxs3ppt0v3Q4sIGCATR/e06feOt4s2/ufR5CwCXawZ9ZASScnzpd0iJcqlUMVgfHQjs1IFzEA6iNXr5xvTKRP5dp/wGE4FqNGMESO/mlnX9/2rXclY53W7BybEjaaLrskxP6Igv5rBtI1cI4fKkP3WYkAHohOlbgvMaoCNccJ/+p7/z1qr3IJH6AcPTMvrTP2EIcGUgxzL3ggUU7QeUy1rYUJkQvyMWEAJ03I/1FdjFOw3t721uZ+/RFOtP67pBFn/sjJj7jAnv8QTAQhVJXy3OhhdcfG2z+Y1ziZOHsPbjBoG/5duQz+zb35reOhzZiTMoXhGWsdWtAJYVz1IDqrVqohXFJ/kit8AyfW3dhEYTgRnBgGLyQSpHuIn4oYb3ij0Y9oB841MNqEUR/z4Y86dGoHJX8U9k2ZHj4szK9FAj1GaJ9c+V60
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:50:41.9198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef41f9e7-bdcf-4c52-7a87-08dedd00488f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11058

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIFRoZSBlcnJvciBwYXRoIHVuY29uZGl0aW9uYWxseSBmcmVlcyBWTVQgbWVtb3J5IGlm
IFZNVA0KPiBhc3NpZ25tZW50IHRpbWVzIG91dCwgcmlza2luZyBoYXJkd2FyZSBETUEgaW50byBm
cmVlZCBtZW1vcnkuDQo+IC0gW0hpZ2hdIFRoZSBlcnJvciBwYXRoIGZvciBLVk0gZGV2aWNlIHJl
Z2lzdHJhdGlvbiB1bmNvbmRpdGlvbmFsbHkNCj4gcmV0dXJucyBgLUVOT0RFVmAsIGNvbXBsZXRl
bHkgYnlwYXNzaW5nIHRoZSBpbnRlbmRlZCBmYWxsYmFjayB0bw0KPiBHSUN2My1sZWdhY3kgbW9k
ZS4NCj4gLSBbTWVkaXVtXSBgdmdpY192NV9pcnNfYXNzaWduX3ZtdCgpYCB3cml0ZXMgdG8gSVJT
IGNvbnRyb2wgcmVnaXN0ZXJzDQo+IHdpdGhvdXQgZmlyc3Qgd2FpdGluZyBmb3IgdGhlIGhhcmR3
YXJlIGludGVyZmFjZSB0byBiZSBpZGxlLg0KPiAtLQ0KPiANCj4gY29tbWl0IDdiYWRjZWY5YTIx
NjVkOGVjNDg5OTc1NWQzMGFlMTFmMzIwMjk5NWQNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYg
PFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBJbXBs
ZW1lbnQgVk1UL3ZJU1QgSVJTIE1NSU8gT3BzDQo+IA0KPiBUaGlzIGNvbW1pdCBhZGRzIHN1cHBv
cnQgZm9yIG1ha2luZyBWTSBhbmQgSVNUIHRhYmxlcyB2YWxpZCB2aWEgdGhlDQo+IGhvc3QNCj4g
SVJTIE1NSU8gaW50ZXJmYWNlLiBJdCBpbnRyb2R1Y2VzIGZ1bmN0aW9ucyB0byBhbGxvY2F0ZSwg
YXNzaWduLCBhbmQNCj4gY2xlYXINCj4gdGhlIFZNVCwgYW5kIHdpcmVzIHVwIHZjcHVfYWZmaW5p
dHkgY29tbWFuZHMgdG8gbWFuaXB1bGF0ZSBWTVRFIGFuZA0KPiBWSVNUDQo+IHZhbGlkaXR5Lg0K
PiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggMDJkNWUzODNhODdlZC4u
MTRhZGM4MmI2NTgyOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+IFsgLi4uIF0N
Cj4gPiBAQCAtMTA1LDEzICsxMzEsNTQgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0
IGdpY19rdm1faW5mbw0KPiA+ICppbmZvKQ0KPiBbIC4uLiBdDQo+ID4gKwkvKg0KPiA+ICsJICog
V2UndmUgbm93IGFsbG9jYXRlZCB0aGUgVk0gdGFibGUsIGJ1dCB0aGUgaG9zdCdzIElSUw0KPiA+
IGRvZXNuJ3Qga25vdw0KPiA+ICsJICogYWJvdXQgaXQgeWV0LiBQcm92aWRlIHRoZSBiYXNlIGFk
ZHJlc3Mgb2YgdGhlIFZNVCB0bw0KPiA+IHRoZSBJUlMsIGFzIHdlbGwNCj4gPiArCSAqIGFzIHRo
ZSBudW1iZXIgb2YgSUQgYml0cyB0aGF0IGl0IGNvdmVycyBhbmQgdGhlDQo+ID4gc3RydWN0dXJl
IHVzZWQNCj4gPiArCSAqIChsaW5lYXIvdHdvLWxldmVsKS4NCj4gPiArCSAqLw0KPiA+ICsJcmV0
ID0NCj4gPiB2Z2ljX3Y1X2lyc19hc3NpZ25fdm10KGlyc19jYXBzLnR3b19sZXZlbF92bXRfc3Vw
cG9ydCwNCj4gPiArCQkJCcKgwqDCoMKgIGlsb2cyKGlyc19jYXBzLm1heF92bXMpLA0KPiA+ICsJ
CQkJwqDCoMKgwqAgdmdpY192NV9nZXRfdm10X2Jhc2UoKSk7DQo+ID4gKwlpZiAocmV0KSB7DQo+
ID4gKwkJa3ZtX2VycigiRmFpbGVkIHRvIGFzc2lnbiB0aGUgR0lDdjUgVk0gdGFibGVzIHRvDQo+
ID4gdGhlIElSUzsgbm8gR0lDdjUgc3VwcG9ydFxuIik7DQo+ID4gKwkJdmdpY192NV92bXRfZnJl
ZSgpOw0KPiANCj4gW1NldmVyaXR5OiBDcml0aWNhbF0NCj4gSWYgdmdpY192NV9pcnNfYXNzaWdu
X3ZtdCgpIGZhaWxzLCBzdWNoIGFzIGR1ZSB0byBhIGhhcmR3YXJlIHRpbWVvdXQNCj4gYWZ0ZXIN
Cj4gd3JpdGluZyB0aGUgcGh5c2ljYWwgYWRkcmVzcyB0byBHSUNWNV9JUlNfVk1UX0JBU0VSLCBk
b2Vzbid0IHRoZQ0KPiBoYXJkd2FyZQ0KPiBzdGlsbCBob2xkIHRoZSBhY3RpdmUgcG9pbnRlciB0
byB0aGlzIG1lbW9yeT8NCj4gDQo+IENhbGxpbmcgdmdpY192NV92bXRfZnJlZSgpIGhlcmUgdW5j
b25kaXRpb25hbGx5IGZyZWVzIHRoZSBWTVQgbWVtb3J5Lg0KPiBJZg0KPiB0aGUgaGFyZHdhcmUg
cmVjb3ZlcnMgb3IgY29udGludWVzIHByb2Nlc3NpbmcsIGNvdWxkIHRoaXMgbGVhZCB0byB0aGUN
Cj4gaGFyZHdhcmUgcGVyZm9ybWluZyBETUEgaW50byBmcmVlZCBtZW1vcnk/IA0KPiANCj4gU2hv
dWxkIHRoaXMgcGF0aCBhdHRlbXB0IHRvIGNsZWFyIHRoZSBWTVQgcG9pbnRlciBpbiB0aGUgaGFy
ZHdhcmUgYW5kDQo+IG9ubHkNCj4gZnJlZSB0aGUgbWVtb3J5IGlmIHRoZSBjbGVhciBvcGVyYXRp
b24gc3VjY2VlZHM/DQoNClllcywgdGhhdCdzIGxpa2VseSBzYWZlci4gV2Ugd2lsbCAibGVhayIg
dGhlIG1lbW9yeSBpbiB0aGlzIGNhc2UsIGJ1dA0KaWYgdGhlcmUncyBhIGNoYW5jZSB0aGUgaGFy
ZHdhcmUgaXMgc3RpbGwgdXNpbmcgaXQsIHRoZW4gaXQgaXMgbm90IHNhZmUNCnRvIGZyZWUgaXQu
IEkndmUgdXBkYXRlZCB0aGUgY29kZSB0byBkbyBhbiBleHBsaWNpdCBjbGVhciBvZiB0aGUNCklS
U19WTVRfQkFTRVIgYW5kIGEgY29ycmVzcG9uZGluZyB3YWl0LWZvci1pZGxlIGJlZm9yZSBmcmVl
aW5nIHRoZQ0KbWVtb3J5ICh0aGUgc2FtZSBhcyB3ZSBkbyBmdXJ0aGVyIGRvd24pLiBJZiB3ZSB0
aW1lIG91dCBhIHNlY29uZCB0aW1lLA0KdGhlbiB0aGUgbWVtb3J5IGlzIGxvc3QuDQoNCj4gDQo+
ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKwl9DQo+ID4gKw0KPiA+IMKgCWt2bV92Z2ljX2ds
b2JhbF9zdGF0ZS5tYXhfZ2ljX3ZjcHVzID0NCj4gPiBtaW4oaXJzX2NhcHMubWF4X3ZwZXMsDQo+
ID4gwqAJCQkJCQnCoA0KPiA+IFZHSUNfVjVfTUFYX0NQVVMpOw0KPiA+IMKgDQo+ID4gwqAJcmV0
ID0ga3ZtX3JlZ2lzdGVyX3ZnaWNfZGV2aWNlKEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSk7DQo+
ID4gwqAJaWYgKHJldCkgew0KPiA+IMKgCQlrdm1fZXJyKCJDYW5ub3QgcmVnaXN0ZXIgR0lDdjUg
S1ZNIGRldmljZS5cbiIpOw0KPiA+IC0JCWdvdG8gc2tpcF92NTsNCj4gPiArCQkvKg0KPiA+ICsJ
CSAqIERvbid0IGZyZWUgdGhlIFZNVCBpdHNlbGYgaWYgdGhlIGhhcmR3YXJlIHN0aWxsDQo+ID4g
aGFzIGEgdmFsaWQNCj4gPiArCQkgKiBwb2ludGVyIHRvIGl0Lg0KPiA+ICsJCSAqLw0KPiA+ICsJ
CWlmICghdmdpY192NV9pcnNfY2xlYXJfdm10KCkpDQo+ID4gKwkJCXZnaWNfdjVfdm10X2ZyZWUo
KTsNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9l
cyByZXR1cm5pbmcgdW5jb25kaXRpb25hbGx5IGhlcmUgYnlwYXNzIHRoZSBpbnRlbmRlZCBmYWxs
YmFjayB0bw0KPiBHSUN2My1sZWdhY3kgbW9kZT8NCj4gDQo+IFRoZSBjb21taXQgbWVzc2FnZSBt
ZW50aW9ucyBmYWxsaW5nIGJhY2sgdG8gdGhlIGxlZ2FjeSBwYXRoIG9uY2UgdGhlDQo+IElSUyBW
TVQNCj4gc3RhdGUgaXMgY2xlYXJlZCwgYW5kIHRoZSBvcmlnaW5hbCBjb2RlIHVzZWQgYSBnb3Rv
IHRvIGp1bXAgdG8NCj4gc2tpcF92NS4gQnkNCj4gcmV0dXJuaW5nIC1FTk9ERVYgZGlyZWN0bHkg
aGVyZSwgaXQgc2VlbXMgS1ZNIHdpbGwgZmFpbCB0byBpbml0aWFsaXplDQo+IGFueSBHSUMNCj4g
c3VwcG9ydCB3aGVuIHZHSUN2NSByZWdpc3RyYXRpb24gZmFpbHMuDQoNCkFoLCB0aGF0J3MgYSBz
dGFsZSBwYXJ0IG9mIHRoZSBjb21taXQgbWVzc2FnZSENCg0KV2UgdXNlZCB0byBoYXZlIHRoYXQg
YmVoYXZpb3VyLCBidXQgZnJhbmtseSBpZiB3ZSBoYXZlIGEgR0lDdjUgaG9zdA0KdGhhdCBmYWls
cyB0byBpbml0aWFsaXNlIHN1cHBvcnQgZm9yIG5hdGl2ZSBHSUN2NSBWTXMsIHRoZW4gdGhlIG9u
bHkNCnNhbmUgdGhpbmcgaXMgdG8gYmFpbCBvdXQgYWx0b2dldGhlci4NCg0KSSd2ZSB1cGRhdGVk
IHRoZSBjb21taXQgbWVzc2FnZSB0byBub3QgbWFrZSB0aGF0IGluY29ycmVjdCBjbGFpbS4NCg0K
PiANCj4gPiDCoAl9DQo+ID4gwqANCj4gPiDCoAl2NV9yZWdpc3RlcmVkID0gdHJ1ZTsNCj4gWyAu
Li4gXQ0KPiA+IEBAIC0xNTMsMTggKzIyMSwxMzYgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qg
c3RydWN0IGdpY19rdm1faW5mbw0KPiA+ICppbmZvKQ0KPiBbIC4uLiBdDQo+ID4gK3N0YXRpYyBp
bnQgdmdpY192NV9pcnNfYXNzaWduX3ZtdChib29sIHR3b19sZXZlbCwgdTggdm1faWRfYml0cywN
Cj4gPiArCQkJCcKgIHBoeXNfYWRkcl90IHZtdF9iYXNlKQ0KPiA+ICt7DQo+ID4gKwl1NjQgdm10
X2Jhc2VyOw0KPiA+ICsJdTMyIHZtdF9jZmdyOw0KPiA+ICsNCj4gPiArCWd1YXJkKHJhd19zcGlu
bG9ja19pcnFzYXZlKSgmZ2xvYmFsX2lyc19sb2NrKTsNCj4gPiArDQo+ID4gKwl2bXRfYmFzZXIg
PSBpcnNfcmVhZHFfcmVsYXhlZChHSUNWNV9JUlNfVk1UX0JBU0VSKTsNCj4gPiArCWlmICghIUZJ
RUxEX0dFVChHSUNWNV9JUlNfVk1UX0JBU0VSX1ZBTElELCB2bXRfYmFzZXIpKQ0KPiA+ICsJCXJl
dHVybiAtRUJVU1k7DQo+ID4gKw0KPiA+ICsJdm10X2NmZ3IgPSBGSUVMRF9QUkVQKEdJQ1Y1X0lS
U19WTVRfQ0ZHUl9WTV9JRF9CSVRTLA0KPiA+IHZtX2lkX2JpdHMpOw0KPiA+ICsJaWYgKHR3b19s
ZXZlbCkNCj4gPiArCQl2bXRfY2ZnciB8PQ0KPiA+IEZJRUxEX1BSRVAoR0lDVjVfSVJTX1ZNVF9D
RkdSX1NUUlVDVFVSRSwNCj4gPiArCQkJCcKgwqDCoMKgwqDCoA0KPiA+IEdJQ1Y1X0lSU19WTVRf
Q0ZHUl9TVFJVQ1RVUkVfVFdPX0xFVkVMKTsNCj4gPiArDQo+ID4gKwlpcnNfd3JpdGVsX3JlbGF4
ZWQodm10X2NmZ3IsIEdJQ1Y1X0lSU19WTVRfQ0ZHUik7DQo+ID4gKw0KPiA+ICsJLyogVGhlIGJh
c2UgYWRkcmVzcyBpcyBpbnRlbnRpb25hbGx5IG9ubHkgbWFza2VkIGFuZCBub3QNCj4gPiBzaGlm
dGVkICovDQo+ID4gKwl2bXRfYmFzZXIgPSBGSUVMRF9QUkVQKEdJQ1Y1X0lSU19WTVRfQkFTRVJf
VkFMSUQsIHRydWUpIHwNCj4gPiArCQnCoMKgwqAgKHZtdF9iYXNlICYgR0lDVjVfSVJTX1ZNVF9C
QVNFUl9BRERSKTsNCj4gPiArCWlyc193cml0ZXFfcmVsYXhlZCh2bXRfYmFzZXIsIEdJQ1Y1X0lS
U19WTVRfQkFTRVIpOw0KPiANCj4gW1NldmVyaXR5OiBNZWRpdW1dDQo+IFNob3VsZCB0aGVyZSBi
ZSBhIGNoZWNrIHRvIGVuc3VyZSB0aGUgaGFyZHdhcmUgaW50ZXJmYWNlIGlzIGlkbGUNCj4gYmVm
b3JlDQo+IHdyaXRpbmcgdG8gdGhlc2UgSVJTIGNvbnRyb2wgcmVnaXN0ZXJzPw0KDQpObywgaXQg
c2hvdWxkbid0IGJlIG5lZWRlZC4gVGhlcmUncyBub3RoaW5nIGVsc2UgaW50ZXJhY3Rpbmcgd2l0
aCB0aGF0DQpwYXJ0IG9mIHRoZSBJUlMgYXQgdGhlIHN0YWdlIHdoZXJlIHRoaXMgY29kZSBpcyBl
eGVjdXRlZC4gSXQgaXMgZm9yDQpzZXR0aW5nIHVwIHRoZSBpbml0aWFsIFZNVCBkdXJpbmcgYm9v
dCB0aW1lLg0KDQo+IA0KPiBVbmxpa2UgdmdpY192NV9pcnNfd3JpdGVfdm1fbW1pb19yZWcoKSwg
d2hpY2ggZXhwbGljaXRseSBjYWxscw0KPiB2Z2ljX3Y1X2lyc193YWl0X2Zvcl92bV9vcCgpIGJl
Zm9yZSB3cml0aW5nLCB0aGlzIGZ1bmN0aW9uIGRpcmVjdGx5DQo+IHdyaXRlcw0KPiB0byBHSUNW
NV9JUlNfVk1UX0NGR1IgYW5kIEdJQ1Y1X0lSU19WTVRfQkFTRVIgaW1tZWRpYXRlbHkgYWZ0ZXIN
Cj4gYWNxdWlyaW5nDQo+IHRoZSBsb2NrLiBDb3VsZCB0aGlzIGNvcnJ1cHQgdGhlIGhhcmR3YXJl
IGNvbmZpZ3VyYXRpb24gaWYgdGhlIElSUyBpcw0KPiBidXN5DQo+IHByb2Nlc3NpbmcgYSBwcmV2
aW91cyBvcGVyYXRpb24gKGUuZy4sIGR1cmluZyBrZXhlYyk/DQoNCldpdGgga2V4ZWMgdGhlcmUg
Y291bGQgaW5kZWVkIGJlIHByZXZpb3VzIHN0YXRlIHRoZXJlLCBidXQgdGhpcyB3b3VsZA0KYmUg
Y2F1Z2h0IGJlIHRoZSBleHBsaWNpdCBjaGVjayB0aGF0J3MgYWxyZWFkeSBwcmVzZW50IGZvciB0
aGUgdmFsaWQNCmJpdC4gSWYgdGhlcmUncyBhbHJlYWR5IGEgdmFsaWQgVk1ULCB0aGVuIHdlIGJh
aWwgb3V0Lg0KDQo+IA0KPiA+ICsNCj4gPiArCXJldHVybiB2Z2ljX3Y1X2lyc193YWl0X2Zvcl92
bV9vcCgpOw0KPiA+ICt9DQo+IA0KVGhhbmtzLA0KU2FzY2hhDQo=
