Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011041.outbound.protection.outlook.com [52.101.65.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BAB2737F8;
	Fri,  7 Aug 2026 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097370; cv=fail; b=qGkR6YQWqZVILot3Czo0Mk/lr4hem9fZSQH3bVg2ZSjH+tBiDrGHXyfdZo7CM6xPHRVmvCFGL7z0hmI4MGenTIEWcYy+3lXC0i1cT3y/XMHqWaceiyMRkzWRBUe/+8ewDlWJCsFIEJ4vJ3W3dKrIycBeywFEusDEQhOClNb2NPM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097370; c=relaxed/simple;
	bh=yqyEq1RPeoLwfdirOILOVGcA+q7cZGAMcAmHzKJosS0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QoQVcM8zZLdfcugdO/B7R98fsN7abL/wjKL9oPHwAXi4Fhxn1vyOkMR4buT99JBe0JRCUD71GOR2CGbtE0JGvQlhalrPlPcBY0Q35vZYOR6DYtZKbFTGK1jhvbTCLzU5BXLlhAkyFhqfK2oX2A1AC6ZXmsOD06Gp/DRLL0HXqgk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e9xJ+JsX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e9xJ+JsX; arc=fail smtp.client-ip=52.101.65.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e9xJ+JsX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e9xJ+JsX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YfqrTL6k2M+BhRKN8qx+b8CmGm2cVco3mXy0h2O6la6gOnE1kmAoQ8HfJly5hjqMdqwJgeZjV1+RGbgjuVF3yUinxkNe4dTlHgxPyZ/QvAwh/7dWDJfS3mxk9Q/70fFbm2MTarxuuuJKTnUZWnTopxLbh84Fwsk47Ccp46BYKtlPioH5GGo7Q3v3X0LN+ut6vGIEdDt2tTzXeMlGZvZINk4dmYEphH8O44c28O9w2YRmSNLrr7Fv4/yqmYfTM1E9L4fH2IDrZFbG3NC+z4ij6KlMtjcc6ZFFHyvFMLOK0YCB3BbPEGcUgmT+u3ATdsSiKBepJfmvetB23kH+DCOFqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqyEq1RPeoLwfdirOILOVGcA+q7cZGAMcAmHzKJosS0=;
 b=mXwpN4aKMubVVEDTPZZo5QPZMq1kwMQlfbFSS3tHBXczR1wDQNTMAgp7fbC8RDcl5JhHaGmANeJdbnSGquCzhazvzh2ywWdJDLYjmJMxMmQWrIIwXZJpKmFQeV7WOfT18AsGGXtok0ujLZKn97FlhvDhMrcCksnJ02u0nkZ1HW6onQdbrDNhstMvsqMgYOaQz9oFRnRP3bJrk+/qUB2M1IeWnqrRp969qRB1f8F0r6XXpXBKlSKnRKSblsTEOI3CV/BYcwNccpjEqu0Kn3b6E9xqILg1cHV4EMZEeIopydos/lh5k6lGB2Wbrfr4YHdTGybAbTlWfkTc0yTORXBRwA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqyEq1RPeoLwfdirOILOVGcA+q7cZGAMcAmHzKJosS0=;
 b=e9xJ+JsXL7ZPQtxC9ZgrYKMuonpjEF/C7FzXcGTClQTU4zr57sWjd/vA300eeC4wpSvz0IlQV07SD98Xx9cOwlKQ7ZXiowo7Lg+fB7ccuYC0/YbsW8UIRAR2MaAwFcrcM2UYHM9ZXljUrLi/6OmB/VtU+34vrS6XH3fnGcPaZPY=
Received: from DU2PR04CA0041.eurprd04.prod.outlook.com (2603:10a6:10:234::16)
 by AS8PR08MB10194.eurprd08.prod.outlook.com (2603:10a6:20b:63c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 10:09:23 +0000
Received: from DB1PEPF000509F7.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::5d) by DU2PR04CA0041.outlook.office365.com
 (2603:10a6:10:234::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 10:09:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F7.mail.protection.outlook.com (10.167.242.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 10:09:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqNEqU50iFYSAUQ0a9ywcCj+EdMcNxuwkc2ch+sHd+4YB3mhkOCl3UAI3XNiTMlxojvLYD6QeRdu2Ma8ERfrXeOD17/KczMfzBbwGFV3RewZWoS1VREgMLLmbkaSBZGaeMh/n4VwHAJwe3Sbhqr9lx5wC8ZL/HNEZEGuG/vSYhQifd1O7sPD17qevq2i5DmrOR/ds8yTv8Lgrk4x0150s1zDbVbdkSSAs+pHKvcT1/apIVmIwiRsDVNEyzYAoQv7Put5cts8TH4fxPryV6UdUq1PJQFjWyfXjOlmLHtWvAJxWhvmztAU16oulybO8xQ3JC7jxhU+ukokHT0/SD/Mpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqyEq1RPeoLwfdirOILOVGcA+q7cZGAMcAmHzKJosS0=;
 b=PiNBj4mCuXUzitAIfaLBzfIVovdp5ya2t3+iVdxxZfIPpSjgzt8k4z+0Evkl/EOjzi77hajgyqjTg52RivN6E6qIMMt5b6Uyzfykxy5QckBK05B22lpkGY0hmhxFIZWItrvhEuCOOMHEvzz8UQHR+PtrqOcwbRZfSkSe2o3ObUEXGhE+3OIflUshq9m3I7Xa3OQ2geVJy9QHNbpB6cmfR8HsWptKynKqjE7L2PzFOLN5L2Di6c76oUJm39Lhrod/pdW/hSkAMEHpYfVu3MUQN7gIYq1hZF03MlrS/WcrLrCZ7A4iFIzbANPekCz7C3gz05rwV5U5w5QLlMk7XYUv3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqyEq1RPeoLwfdirOILOVGcA+q7cZGAMcAmHzKJosS0=;
 b=e9xJ+JsXL7ZPQtxC9ZgrYKMuonpjEF/C7FzXcGTClQTU4zr57sWjd/vA300eeC4wpSvz0IlQV07SD98Xx9cOwlKQ7ZXiowo7Lg+fB7ccuYC0/YbsW8UIRAR2MaAwFcrcM2UYHM9ZXljUrLi/6OmB/VtU+34vrS6XH3fnGcPaZPY=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AM0PR08MB5347.eurprd08.prod.outlook.com (2603:10a6:208:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 10:08:51 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 10:08:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>,
	"sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "oupton@kernel.org" <oupton@kernel.org>, nd
	<nd@arm.com>
Subject: Re: [PATCH v1 09/11] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Thread-Topic: [PATCH v1 09/11] KVM: arm64: Minimise EL2's exposure of host
 VGIC state during world switch
Thread-Index: AQHc+jkzWsqP7ocTDk+7+94JKMZ/dLaRIgvigAGS/gA=
Date: Fri, 7 Aug 2026 10:08:51 +0000
Message-ID: <6e9ba473046d17afae90a2df5e5def3315935004.camel@arm.com>
References: <20260612065925.755562-10-tabba@google.com>
	 <20260612072456.0F4D01F000E9@smtp.kernel.org>
	 <CA+EHjTyyDJsOEhcJnuxpyia5EU_GUck_GeQRP65n75S85f31cg@mail.gmail.com>
	 <CA+EHjTxiHyuw5EjWLha1OySm3xjRH6rbk41On+5V2+ig1FdCmg@mail.gmail.com>
In-Reply-To:
 <CA+EHjTxiHyuw5EjWLha1OySm3xjRH6rbk41On+5V2+ig1FdCmg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AM0PR08MB5347:EE_|DB1PEPF000509F7:EE_|AS8PR08MB10194:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf9489d-fe9d-4abc-9d19-08def46bf4bc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|11063799006|5023799004|4143699003|56012099006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 F3gKpV3ZZWjP5dJhmrYTRzWVmKOnWPtA8I/lrYVmlZWdk/bVq1rRny7V0Sda2GAVmmq0XNT+GloQ30MJMXhLXYKdYVnFwIg59H5EEQh1dYNJ1H19cUJriYBu3frqyQzSWyuQ+cQOY5wLqpSdEoNkyIm05ih5cvqU0CWsKhSjozCbeK3tYLE3FFKKHFUxWUzdF0/UdnkZvSybsHZp4S7HBxtPDxWZNdLNEbWgSZSrjCgr+LlbNbiojIpyz369RtzEWpWR28dEEeN3h3YCDL+N1OaqVYOiaUkFgi6DreX0ANeRyA7eRDBgu3KZPScDW0L5/Bd0kw1aLfGmH3DmquCoRLs8n2kskRmbK/XnaeLuI8GFSKWmJxnNSdXsE7m50ZGvqgY9UQGxyp20vKU/8l9eEYWVpBei/V1YPmirVPKTTi+OPrWTaiQJQFtwafnwsQFBiB1ewHwAejFmjjRBi1yVos7XU+UPjHtGFD5+hDJ8SJrOVnp+ivhPmSJ1KMLfgreoBBhDRvrFXX4c2CxpsDnTQFmu8UMLfQstYKhOH3jpB2sDC4XWwDTL/uu1Tk/15cIrbV2OXuUXY0R4mf+KgbhV0eaXPsYpFUkfRQg775t603fO2z1tA+8uPdoR9lvxhMznveDf2bwGecXgLUnDzXKTroW+16jIeTM80gBvXQ47y9g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(5023799004)(4143699003)(56012099006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AC855BA66B6B7449576BCD35AB49D70@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TQp2/70pPPNAE5M/i1b0TwEV4P+UeHDA8LEX9E0Jlc87pn9wnAa0Nu5BL+MsQ+48UTZ9ntC6RhlO/uhZYiMi3y3IWlD1ByvWePPdrBGTP7vCU/iONRD7lXEDvWUeNelCMRCQaZU46JCST+er5TKfUQcKCUg9G+GjAVtI/SS4fxWA6MXtI5eXF2rHxuxPe2/nDZmL3yMP/v7OKC3DgA9o7p/W6hnpO7ua7WJE5nZYjDvu1dZUlahmULmLGpRNomG6X3346+hTcTLsRBaNcpZ1Gcf3TZW9Y6HoIFGoDEHOcFIRawfnbzzkP0+MK70bxHleMqWYuI812KP/XxlFXogCCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5347
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	28a45501-2270-4364-61bf-08def46be165
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|14060799003|376014|82310400026|35042699022|11063799006|4143699003|56012099006|10067099003|5023799004|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/gTkvbeKuBd/1cKogshRBQ5aeWgh+/6S8hEOashs6Q4quJQh72lkqEo60Hg488kebeAXpK8vz+eq5od3SHuAmm7xfKSyCUwRsHR2Jecpk/zhVzF4p/nHQ//jLQmssqsmIN753asEBNkij9aVXuMmeX2s8+UrLNPXRvcfPpUZdlPPh++YP8J30M2ow8gASxg/mDL47LrIMEOo78HbIj8MOTO1ggxZE8GnTqn8aqdwlLksgV3EqgS3ADBZNjZ41B/W8NVr4WceTTLu+XaKk/KKNy1ouEZxBauzLnUitWqe7DV9T0PsjONCXOlvqcNErTSPX9jwLykOo7AuNbl67kZ2oDJ3ZknpS6NhPNrjGY+Z4HLCjvCPpZyMnw4kYhExdw+7LVN8dx4APs2/lee403Zh6qyAvW61ggXj9dn4vudtaVXSe5lxdnN+GozElGyYEBXWwTuepwx3Sxw2WfDOg6Dr9s5wdw0YRmZwaro0uU8wtRzqeaXU5tBy3B1GYnOnEvfPU3YN7iD0EFFyLNn5+ObYkWpLOXAH2reCPYXrZfSBEEBVlqLH8LbhccFulKx+LopM15CNJ5gxx7/oFY0jEnU7oCN3E8rAASEtAK33t+mytuDbssTspLCWotSh+9YOay8Dli7GD+DXEjs9fiFFhsZUQg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(14060799003)(376014)(82310400026)(35042699022)(11063799006)(4143699003)(56012099006)(10067099003)(5023799004)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p6sR15JW0CPO2QNn86lSEfRbaTl6H/BdxOHIZY7djT8JGHIuwAIhZ0UrIzU4NBwizEaMn705MZqLol71s0zplGxlsY4ZOYmJnVEvpIWfjcuyH4/HHVxNb5722UzacRoIIyMMFoqPmiakEABe0XbpLDaQbZNu94ML+fkJ4mlX+UuB9cHL6053jqvSmyTM3bb358aAVd3NWEzo+ap2aRDJXJFzObRkRNmJvgyDw3G8tX3hh4aSDhBW3lfI1j8Ym/PvpYAGCUgBcMEBNNjHKTvH81DcsvEgnmU+YvtiNXkSPxDVaYtg4kBJ5xrha5IltpDI7glujc5mt6WKLqPZuEh5z9vlBfrc+zo8z96ISHafMMuTNHNjzuyV0rb+3XyC5UpTvQot4fN9ICCIjPKlYvLRfRfqIFzCpN/R7k8kW1Ed9Il4P042ype82wtZKDve95zQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:09:23.6787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf9489d-fe9d-4abc-9d19-08def46bf4bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10194

SGkgRnVhZCwNCg0KT24gVGh1LCAyMDI2LTA4LTA2IGF0IDExOjA1ICswMTAwLCBGdWFkIFRhYmJh
IHdyb3RlOg0KPiBIaSBmb2xrcywNCj4gDQo+IE9uIEZyaSwgMTIgSnVuIDIwMjYgYXQgMDk6MDUs
IEZ1YWQgVGFiYmEgPHRhYmJhQGdvb2dsZS5jb20+IHdyb3RlOg0KPiAuLi4NCj4gPiA+IFByZS1l
eGlzdGluZyBpc3N1ZXM6DQo+ID4gPiAtIFtDcml0aWNhbF0gVGhlIEdJQ3Y1IGVxdWl2YWxlbnRz
IG9mIHRoZSBWR0lDIHNhdmUvcmVzdG9yZQ0KPiA+ID4gaHlwZXJjYWxscyAoYGhhbmRsZV9fX3Zn
aWNfdjVfc2F2ZV9hcHJgIGFuZA0KPiA+ID4gYGhhbmRsZV9fX3ZnaWNfdjVfcmVzdG9yZV92bWNy
X2FwcmApIGRpcmVjdGx5IGRlcmVmZXJlbmNlIGhvc3QtDQo+ID4gPiBwcm92aWRlZCBwb2ludGVy
cyB3aXRob3V0IHZhbGlkYXRpb24sIGFsbG93aW5nIGEgY29tcGxldGUgYnlwYXNzDQo+ID4gPiBv
ZiBwS1ZNIGlzb2xhdGlvbi4NCj4gLi4uDQo+ID4gPiA+ICvCoMKgwqDCoCB9IGVsc2Ugew0KPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmdpY192M19zYXZlX2FwcnMoJmhvc3Rf
dmNwdS0NCj4gPiA+ID4gPmFyY2gudmdpY19jcHUudmdpY192Myk7DQo+ID4gPiA+ICvCoMKgwqDC
oCB9DQo+ID4gPiA+IMKgfQ0KPiA+ID4gDQo+ID4gPiBbU2V2ZXJpdHk6IENyaXRpY2FsXQ0KPiA+
ID4gVGhpcyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSwgYnV0IHdoaWxlIHRoaXMgcGF0Y2ggYWRk
cmVzc2VzIHRoZQ0KPiA+ID4gVkdJQyB2MyBob3N0DQo+ID4gPiBwb2ludGVyIGRlcmVmZXJlbmNl
IGJ5cGFzcyBieSB1c2luZw0KPiA+ID4gZ2V0X2hvc3RfaHlwX3ZjcHVzX2Zyb21fdmdpY192M19j
cHVfaWYoKSwNCj4gPiA+IGRvZXMgdGhlIHNhbWUgcEtWTSBpc29sYXRpb24gYnlwYXNzIGV4aXN0
IGluIHRoZSBHSUN2NQ0KPiA+ID4gZXF1aXZhbGVudHM/DQo+ID4gDQo+ID4gR0lDdjUgaXMgbm90
IHN1cHBvcnRlZCBpbiBwcm90ZWN0ZWQgbW9kZS4gdmdpYy12NS5jOjYyLTY0IHNraXBzDQo+ID4g
R0lDdjUgcmVnaXN0cmF0aW9uIGVudGlyZWx5IHdoZW4gaXNfcHJvdGVjdGVkX2t2bV9lbmFibGVk
KCksIHNvIG5vDQo+ID4gR0lDdjUtYmFzZWQgZ3Vlc3QgY2FuIGJlIGNyZWF0ZWQgdW5kZXIgcEtW
TS4gVGhlIGhvc3QgbmV2ZXIgcmVhY2hlcw0KPiA+IHRoZXNlIGh5cGVyY2FsbHMgdGhyb3VnaCBh
bnkgbGVnaXRpbWF0ZSBjb2RlIHBhdGguDQo+IA0KPiBJIHdhcyB3cm9uZyBoZXJlLg0KPiANCj4g
c2tpcF92NSBvbmx5IHN0b3BzIHRoZSBob3N0J3Mgb3duIEtWTSBmcm9tIHJlZ2lzdGVyaW5nIGEg
R0lDdjUgdmdpYywNCj4gc28gdGhlIGhvc3QgY2FuIHN0aWxsIGNhbGwgX192Z2ljX3Y1X3NhdmVf
YXByIGFuZA0KPiBfX3ZnaWNfdjVfcmVzdG9yZV92bWNyX2Fwci4NCg0KPiB2Z2ljX21vZGVsIGhh
cyB0aGUgc2FtZSBnYXAuIEVMMiBjb3BpZXMgaXQgb3V0IG9mIHRoZSBob3N0J3MgYHN0cnVjdA0K
PiBrdm1gIHdpdGhvdXQgdmFsaWRhdGluZyBpdCwgc28gYSBob3N0IGNhbiBzdGVlciB0aGUgd29y
bGQgc3dpdGNoIGludG8NCj4gdGhlIEdJQ3Y1IHJlZ2lzdGVycywgd2hpY2ggYXJlIFVOREVGSU5F
RCB3aXRob3V0IEZFQVRfR0NJRS4gVGhhdA0KPiB0YWtlcw0KPiBhbiBVTkRFRiBhdCBFTDIgYW5k
IHBhbmljcyB0aGUgaHlwZXJ2aXNvci4gSSByZXByb2R1Y2VkIGl0IHVuZGVyIFFFTVUNCj4gb24g
YSBHSUN2MyBtYWNoaW5lLg0KPiANCj4gSSBoYXZlIHNlbnQgYSBzZXJpZXMgZm9yIGJvdGggWzFd
LiBUaGUgd2lkZXIgcG9pbnQgaXMgdGhhdCAicEtWTSBkb2VzDQo+IG5vdCBzdXBwb3J0IEdJQ3Y1
IiBkb2VzIG5vdCBpbXBseSAiRUwyIGNhbm5vdCBnZXQgdGhlcmUiLCB3aGljaCBpcw0KPiB3aGF0
IEkgaGFkIGFzc3VtZWQsIHNvIGl0IG1pZ2h0IGJlIHdvcnRoIGFub3RoZXIgbG9vayBhdCB0aGUg
bmV3ZXINCj4gaHlwZXJjYWxscyBpbiBTYXNjaGEncyBJUlMgc2VyaWVzIG9uIHRoYXQgYmFzaXMg
WzJdLg0KDQpZZWFoLCB0aGF0J3MgdmVyeSBtdWNoIG15IGJhZC4gSSdkIGJlZW4gd29ya2luZyB1
bmRlciB0aGUgd3JvbmcNCmFzc3VtcHRpb24gaGVyZSwgc28gdGhhbmsgeW91IGZvciBhZGRyZXNz
aW5nIHRoZXNlIGlzc3Vlcy4NCg0KSSd2ZSBnb25lIGFuZCByZXBsaWNhdGVkIHdoYXQgeW91IGRp
ZCBmb3IgdGhlIG90aGVyIGh5cGVyY2FsbHMgaW4gWzFdDQpmb3IgbXkgdXBjb21pbmcgdjUgcG9z
dGluZyBvZiB0aGUgR0lDdjUgSVJTIHNlcmllcy4gVGhlIGNhbGxzIGJlY29tZQ0KTk9QcyB3aXRo
IHBLVk0gZW5hYmxlZC4NCg0KVGhhbmtzIGFnYWluLA0KU2FzY2hhDQoNCj4gDQo+IENoZWVycywN
Cj4gL2Z1YWQNCj4gDQo+IFsxXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA4
MDYxMDAyNTYuMzcxMTY0LTEtZnVhZC50YWJiYUBsaW51eC5kZXYvDQo+IFsyXQ0KPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA3MjQxMDQ4MTkuMTI5NjgwMy0xLXNhc2NoYS5iaXNj
aG9mZkBhcm0uY29tLw0KPiANCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+IExvb2tpbmcgYXQgaGFu
ZGxlX19fdmdpY192NV9zYXZlX2FwcigpIGFuZA0KPiA+ID4gaGFuZGxlX19fdmdpY192NV9yZXN0
b3JlX3ZtY3JfYXByKCkNCj4gPiA+IGluIGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL2h5cC1tYWlu
LmM6DQo+ID4gPiANCj4gPiA+IGhhbmRsZV9fX3ZnaWNfdjVfc2F2ZV9hcHIoc3RydWN0IGt2bV9j
cHVfY29udGV4dCAqaG9zdF9jdHh0KSB7DQo+ID4gPiDCoMKgwqAgREVDTEFSRV9SRUcoc3RydWN0
IHZnaWNfdjVfY3B1X2lmICosIGNwdV9pZiwgaG9zdF9jdHh0LCAxKTsNCj4gPiA+IMKgwqDCoCBf
X3ZnaWNfdjVfc2F2ZV9hcHIoa2Vybl9oeXBfdmEoY3B1X2lmKSk7DQo+ID4gPiB9DQo+ID4gPiAN
Cj4gPiA+IFRoZXNlIGhhbmRsZXJzIGFwcGVhciB0byB0YWtlIGEgY3B1X2lmIHBvaW50ZXIgZGly
ZWN0bHkgZnJvbSB0aGUNCj4gPiA+IHVudHJ1c3RlZA0KPiA+ID4gaG9zdCBjb250ZXh0IGFuZCBh
cHBseSBrZXJuX2h5cF92YSgpIHdpdGhvdXQgdmFsaWRhdGlvbi4gQ291bGQgYQ0KPiA+ID4gbWFs
aWNpb3VzDQo+ID4gPiBob3N0IHByb3ZpZGUgYW4gYWRkcmVzcyB0aGF0IHRyYW5zbGF0ZXMgdG8g
YW4gYXJiaXRyYXJ5IEVMMi0NCj4gPiA+IHByaXZhdGUgbWVtb3J5DQo+ID4gPiBsb2NhdGlvbiwg
Z3JhbnRpbmcgYW4gYXJiaXRyYXJ5IHdyaXRlIG9yIHJlYWQgcHJpbWl0aXZlIHdoZW4NCj4gPiA+
IF9fdmdpY192NV9zYXZlX2FwcigpIG9yIF9fdmdpY192NV9yZXN0b3JlX3ZtY3JfYXByKCkgaXMg
aW52b2tlZD8NCj4gPiA+IA0KPiA+ID4gW1NldmVyaXR5OiBDcml0aWNhbF0NCj4gPiA+IFRoaXMg
aXMgYWxzbyBhIHByZS1leGlzdGluZyBpc3N1ZSwgYnV0IGRvZXMgYSBzaW1pbGFyIGFyYml0cmFy
eQ0KPiA+ID4gbWVtb3J5DQo+ID4gPiBjb3JydXB0aW9uIHByaW1pdGl2ZSBleGlzdCBpbiBoYW5k
bGVfX19rdm1fYWRqdXN0X3BjKCk/DQo+ID4gDQo+ID4gWWVzLCBwcmUtZXhpc3RpbmcuIEl0IGlz
IGFkZHJlc3NlZCBsYXRlciBpbiB0aGlzIHNlcmllcyBieQ0KPiA+ICJQcmV2ZW50IGhvc3QgUEMg
YWRqdXN0bWVudHMgZm9yIHByb3RlY3RlZCB2Q1BVcyIgKHBhdGNoIDEwLzExKS4NCj4gPiANCj4g
PiBDaGVlcnMsDQo+ID4gL2Z1YWQNCj4gPiANCj4gPiA+IA0KPiA+ID4gTG9va2luZyBhdCBoYW5k
bGVfX19rdm1fYWRqdXN0X3BjKCkgaW4NCj4gPiA+IGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL2h5
cC1tYWluLmM6DQo+ID4gPiANCj4gPiA+IHN0YXRpYyB2b2lkIGhhbmRsZV9fX2t2bV9hZGp1c3Rf
cGMoc3RydWN0IGt2bV9jcHVfY29udGV4dA0KPiA+ID4gKmhvc3RfY3R4dCkgew0KPiA+ID4gwqDC
oMKgIERFQ0xBUkVfUkVHKHN0cnVjdCBrdm1fdmNwdSAqLCB2Y3B1LCBob3N0X2N0eHQsIDEpOw0K
PiA+ID4gwqDCoMKgIF9fa3ZtX2FkanVzdF9wYyhrZXJuX2h5cF92YSh2Y3B1KSk7DQo+ID4gPiB9
DQo+ID4gPiANCj4gPiA+IEFuZCBfX2t2bV9hZGp1c3RfcGMoKSBpbiBhcmNoL2FybTY0L2t2bS9o
eXAvZXhjZXB0aW9uLmM6DQo+ID4gPiANCj4gPiA+IHZvaWQgX19rdm1fYWRqdXN0X3BjKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkgew0KPiA+ID4gwqDCoMKgIGlmICh2Y3B1X2dldF9mbGFnKHZjcHUs
IFBFTkRJTkdfRVhDRVBUSU9OKSkgew0KPiA+ID4gwqDCoMKgwqDCoMKgwqAga3ZtX2luamVjdF9l
eGNlcHRpb24odmNwdSk7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoCB2Y3B1X2NsZWFyX2ZsYWcodmNw
dSwgUEVORElOR19FWENFUFRJT04pOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqAgdmNwdV9jbGVhcl9m
bGFnKHZjcHUsIEVYQ0VQVF9NQVNLKTsNCj4gPiA+IMKgwqDCoCB9DQo+ID4gPiDCoMKgwqAgLi4u
DQo+ID4gPiB9DQo+ID4gPiANCj4gPiA+IEl0IHNlZW1zIHRoZSBob3N0LXByb3ZpZGVkIHZjcHUg
cG9pbnRlciBpcyBjb252ZXJ0ZWQgdmlhDQo+ID4gPiBrZXJuX2h5cF92YSgpDQo+ID4gPiB3aXRo
b3V0IHRoZSBfX2dldF9ob3N0X2h5cF92Y3B1cygpIHZhbGlkYXRpb24gYmFycmllci4gQ291bGQg
YQ0KPiA+ID4gbWFsaWNpb3VzDQo+ID4gPiBob3N0IGluamVjdCBhIHBvaW50ZXIgdGhhdCB0cmFu
c2xhdGVzIGludG8gRUwyLXByaXZhdGUgbWVtb3J5DQo+ID4gPiAobGlrZQ0KPiA+ID4gaHlwZXJ2
aXNvciBwYWdlIHRhYmxlcykgYW5kIHNldCB0aGUgUEVORElOR19FWENFUFRJT04gYml0LA0KPiA+
ID4gZm9yY2luZw0KPiA+ID4gX19rdm1fYWRqdXN0X3BjKCkgdG8gd3JpdGUgZXhjZXB0aW9uIHZl
Y3RvciBhZGRyZXNzZXMgYW5kIGNsZWFyDQo+ID4gPiBmbGFncyBhdA0KPiA+ID4gc3BlY2lmaWMg
b2Zmc2V0cyB3aXRoaW4gdGhlIHRhcmdldCBzdHJ1Y3R1cmU/DQo+ID4gPiANCj4gPiA+IC0tDQo+
ID4gPiBTYXNoaWtvIEFJIHJldmlldyDCtw0KPiA+ID4gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3Bh
dGNoc2V0LzIwMjYwNjEyMDY1OTI1Ljc1NTU2Mi0xLXRhYmJhQGdvb2dsZS5jb20/cGFydD05DQoN
Cg==
