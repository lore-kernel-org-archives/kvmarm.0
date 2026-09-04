Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011019.outbound.protection.outlook.com [52.101.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC710470E8A;
	Fri,  4 Sep 2026 10:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518405; cv=fail; b=SbjWvJTdpksdkQZv+cjs4/bO0Txhh5wPef0HpoTaeeZPeTEA7THAreOLc16wGmXH78OxNNEdsxUSZMbBsj0yOocxgd1AVpOX0HVNkAi0T8T7tewxgeUmnoWSyx6kBFArf1h5AedRO7irB2sa+i45O/A4KzH1E04Tff0KnUqdoKo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518405; c=relaxed/simple;
	bh=LpZX9Sk2ES6ssYKbMsL3ZVfDLfEU1UC3cC0JNv055pg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hJl40WGr2YOXk/9xtszra6HirxJd5tKe7nhtSee6Sv7b73L2eREm3oelQ+AMfFhkLBwh+N64AilXUXtassaUvIKpRPWCRA1XBJuPWCkuuQ4QjOLNUeJA42NMTXuJNN3jBrQtdMMGoCJOyUry31/iiEHfG86dGA33IEdnTU+BSAY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6TOFVoH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6TOFVoH; arc=fail smtp.client-ip=52.101.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6TOFVoH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6TOFVoH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kWA87tvtZrH3+Oaijb6S9NEknLA9YWQlBkUguJyuZ4mWy/PFAet/qRjLu4fdVFYPthrjK1VD/j88oYBgKMECx8/39zFyJKBCvaLzt+0QLDJZ2atQl7QQsWeYmwt/8BN3mEWnMIo/Kb1UXfvNFW9mDKE9jOgpB6MyZ+ljevIE0byz44XQhZeE7s1aTd59KUZRWkUNF3hxCrCyAY0OvFj17i0Y/c160swAI4hUxs0uiVRpZ+Hb/7IrWhj/uge0KMrUvAEyrep64YnxqGNahvepVwW8KGNqPe7OkXXHKG/DDXSlIQzhZph+qRZSk4F13DpOxgJNHnZX288KFMaXwq69mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpZX9Sk2ES6ssYKbMsL3ZVfDLfEU1UC3cC0JNv055pg=;
 b=zMw/MLcoQnYeSAdMLQAlcv1JlkJYBiOUU/Iv6OPgS/zL0RdRNEwjnDACsjmXwgm5JzX03XABQCCS9y2QkWhSkOnSyE2iHpmMCWqFugvKnkm4xub4oSIGMqbeF8uvYT/DzCG13Plbh5WJBc0dNtb8uzrb9wNozESgXcRVMg1DXlzOMTUgmBZurGX6Rp5EnjQWTfGTC37w2kpTmikWY+rlh9pyi12kAowVwTIOguvRZP2fFX9UT5HOPZoIqvvWugbjBylgOrxlr7kBwslWi5kbmQ8OnD/sFRc48+JJE66O/SFNNDc2hke9tEUfPTIZT4jCx3LoX2j/Q/ReAcPOe//mtA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpZX9Sk2ES6ssYKbMsL3ZVfDLfEU1UC3cC0JNv055pg=;
 b=G6TOFVoHhQXfNtg8qWOjtrAPSeD7Pk0X7kD1taCwEwYR+h8Qz/xpQWjXLBpXk4yrucmJ0C4aXKlOQI9Xyh5R/C5l9tMzv7hvn8emTWr0oCGHOwYa1EVj/GNYmQQaob4CR3a86KWioz0zF+jUMRJixdwEgSWXmjYVsD2v2ABWdiw=
Received: from DU2PR04CA0209.eurprd04.prod.outlook.com (2603:10a6:10:28d::34)
 by AS8PR08MB7717.eurprd08.prod.outlook.com (2603:10a6:20b:525::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:39:49 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:28d:cafe::11) by DU2PR04CA0209.outlook.office365.com
 (2603:10a6:10:28d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 10:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 10:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VCv+A+Mj6loqERq2INlz8F8rTG22rHC8bbi3bW1tb17yqt9Uuch78HFfk6bBd5XKwrirXcTuXhjqbNHZ9SqN4TfEIN3Yo8lABwLXCNYsSihtsY5LRmdg2yfMLkjcP7OU7yPom36G+mysocXOBJ/uEOBL+DmIjrpX3SE82mKy0z+d9RRgwaz/kOKDbd4C9LiyMr2oJPIz5EhPM9asJnNbsxtd8aKubxLGP8mJnhryLgob+7isyrzfVz+eJag07DpHMjf6LZjwLA9GFmhIdh35gtRiMesq59vY7MalMvTuZU/AT+DCM2iZaK5lgngrvXgCYdVhSJkX1eK6j9ryj3UB1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpZX9Sk2ES6ssYKbMsL3ZVfDLfEU1UC3cC0JNv055pg=;
 b=H/jozHA7wZc/zltdCUWes+YrxKJHlGuBhqidG0zi2id8j34kXc/De+yEDFn75bt5+mkEAb7uaxnhT5/T/ky9dTfL1VwB4V2DksmDr2ZO5WovaReAG1u7zviCemXnXyHHPvKJWKIuQau39YhAohjtvlWX1wgiiyA6OeRt84qRUjPcGCUlAM14StaQo1RTC7qeEQ3BBP5FO5dEaCkPdDu+9eDNzDAWBI3q4p4zNrcnEMv54QkN3CoGD1JfdKNj3jKD6NqP7KROSooS5G0PDU++81a6mjg3cPaVOjOiq3hIpHnvmEWY4LKCgBsfqykpSq3KGnBb4RNCm/l+37wHEv9RfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpZX9Sk2ES6ssYKbMsL3ZVfDLfEU1UC3cC0JNv055pg=;
 b=G6TOFVoHhQXfNtg8qWOjtrAPSeD7Pk0X7kD1taCwEwYR+h8Qz/xpQWjXLBpXk4yrucmJ0C4aXKlOQI9Xyh5R/C5l9tMzv7hvn8emTWr0oCGHOwYa1EVj/GNYmQQaob4CR3a86KWioz0zF+jUMRJixdwEgSWXmjYVsD2v2ABWdiw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AM9PR08MB6129.eurprd08.prod.outlook.com (2603:10a6:20b:284::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:03:58 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:03:58 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Topic: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Index: AQHdJl6Bj4OHFsGd9ki5uUJ/gZxkkLaSlS6AgCvHe4A=
Date: Fri, 4 Sep 2026 10:03:58 +0000
Message-ID: <c1bc74f1bcb6505dce9f237f588fbafa3866efaf.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-13-sascha.bischoff@arm.com>
	 <20260807133051.15D381F000E9@smtp.kernel.org>
In-Reply-To: <20260807133051.15D381F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AM9PR08MB6129:EE_|DU2PEPF00028D12:EE_|AS8PR08MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a6a96a7-f2be-4ef4-c79b-08df0a70d85a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|6133799003|4143699003|11063799006|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 BxDghLLgW3s2uBUyRthzfPkMoVfvXMA7gHy+18bKE0ldZPQ7YzsXRpbQ2BoM0y1Phl9Er9yiUfJQaow7H7DdtkvLszcf/V8JVT4fm03ULiASrOh2/+1RvB03kzy+K+8NQ4ugWyvgUVhhYrCjKbVdaTguDnCFjKaqZwr2mncftRST54/zq7TgN/ofwkjg0cbCR5/gW7ohctKpIZiRGxEIDMWD5D5HiQgR8JACIxWbXQnOb5SDkqg879lx5joHoTKwCWgG9l59oM2fwy5hRyugkjYBaT+h54yeeVDjGYxGv9L0TyuEH2lfLq2jA78h14cSAHSquLzPHlGcOkLLI5+02/LpTTiUme3BoQE0tjJgfExIlAgPXTSbxJmfM7s+QNU+36XYLgr0zF2b9jNWwiMC3fRh0Ql8xF/ce5Wxw5d040isWw8rMZCFQ+OsPYLb3lBPZrQSw6R/MNDFxJOFOdvtm3DaTVpvVJqDci9W7hwaElRVARz6lxl4ftTNR9JxVXA6TN6RKc6hcKiAK9p2j7IZNtTgrr9uDa0OQETs4JhLuCHr4kjtPZVZiT3mCRmDrYPYUGXzHa2v6XaQtqAJ8YOwVy2xkg3SqUfg6mSuLFstSxb/65HsA/NVtbKtxiSmTwXG0tYDATDI6sSK+Pjvgf2ZWxEAd+9cjXszCmViPwPbYjufK0PUmx99q9UXS4Iely68bfD+kwoYRZfA4dCvitykeU7GhmFF/ZPughuw4NFoMrU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <409E452B9FF5C24ABDAEAF761C8494A0@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 2Pl7/uehiLjy3WIduArmSJ4re7RYt9zkESo3hlXPY52neEJQ5U4zWPATsH1oMUzt8VZpDTRoBSb4qDkEg0bEdGLAfAMLaxkOo2XvR+7vgnCqe9RbVnstWMk34p+MhgmScadD0cxWIP2Qey9ggu7rXU7I9cK1zxydibx/VpfAM7z4r73prCGZL7yLHZqnhQIQTAp1tzF3mzWDHUm+nYmI2JpZqhg6w+FqBFulqjLBwlVN1rNdEg693gHcAb32nYMVQLXYfz3jKg/OXAhBu/004pE4rAoMnbK3P4E27aX9itGfnEZb3KrT3ykqkDRYmAv4aUOZO0LTmv0h6MpDoIx5Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6129
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	95de3aa4-bd0e-460e-cdb8-08df0a6bd673
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|35042699022|36860700016|14060799003|4143699003|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	0w0pjd5224Kyj7fg+bsJvfE/O9RzVrP3Fx8F7gYfjHP2oNsCeY/Je6RcL3zWTTlNLTOrauwbBznI/n/jzNhFPtBbpo1QGq0Q7Buy7xDg0/dVXoo3IhsscWUFhZKLH6YvG25XcGFvSHxP7JCcdz0JK/SJ70v6eTVCp+yH/qSm/7WM5Wvl6X91MFdV1ILME0yQFOv2DAd+sBcyYQ7KBKZCJvW6XpuWLP+0hXT9kXHnuer+STsW1R4XxoqiQEw+fA8Pu3VE0ulDOenaiy3dwBVO/6iLPH5vT94JwwsEueDKznSYAxBNg5k9qJ/qptnaWAq36vVyhkUI4qTnboyffPQdTmWzW9uJvb+XrPX0g/nGFtr0eEBx6a8bLLOgzdbD8rCSO6g/HXqOVQVNK2EAlOcvVwuCG2CJ5DUXt/m/anLKLoMjtZCjP6GhQd8KWhSMlOz3UoTtpuU2DP2hQiC8xZ3+KYCRN5MXHQu7aeGqgtkm6dUr9exphPiA5a9kdmaItTLPS59ocuD97lz2JHr1Iztk+fCpDBO7mKqvj8nO1VCXkvrECCa7YMQGZAcLDeE4iokvnNE2AUDz6QlhNGxQw3m2KivJQaqwdT03Db1a9tTu2mi7utjJ2S8WrQJeqTa4XPkYwq7bo99J+2xLc8Rp/aEAcdVuutLGfDQ1UIGaWp/IyyM=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(35042699022)(36860700016)(14060799003)(4143699003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CHEeGBT3QwCtdLwE2ezdxqkmsUP+4CtRcouYOe62ogiib7S0YWOzZMLP7rFeyXeLoHDNMvKG2HNJnS5bI6mExDGZMaWv06PE6yu/ilUjGcGyvSF/N5X/ql9ds8C+7VA4z7CuWkulA846VOOqQHF85IqE4RejPcPg9FzOEQLEXVXA1Y+88GRd2+42su6ql7KlXNAXcterWH7a5epOc3nE7nKzgMcSjq+AEgaZ19G7kD+V8PPpEJbzXOSWAT8OMkOtZcioueuwwY/s2U3YVJSO4xtzAc4I+AFYOTOwgtWuHi77cjHBTAwuflveBh416JDOBiVypbAxIJVpc7G90Q7bfhmKPojHlwpCKlQadWqMXOMWxPBzGoJ8kVrdPPh16QR0qOgW403xJY2Q205NBRZfaaKp7FMKd6iSPe/l61txy7bv6BQfnNINlxACDXiJBA8i
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:39:49.1265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6a96a7-f2be-4ef4-c79b-08df0a70d85a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7717

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEzOjMwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIGt2bV92Z2ljX2NyZWF0ZSgpIGZhaWxzIHRv
IHZhbGlkYXRlIHRoYXQgcHJldmlvdXNseSBjcmVhdGVkDQo+IFZDUFVzIGhhdmUgSURzIHdpdGhp
biB0aGUgbmV3bHkgc2VsZWN0ZWQgVkdJQyBtb2RlbCdzIGxpbWl0cyAoZm9yDQo+IEdJQ3YyIGFu
ZCBHSUN2MyksIGxlYWRpbmcgdG8gdW5kZWZpbmVkIGJlaGF2aW9yIGluIEdJQ3YyIFNHSSByb3V0
aW5nLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsxMl06IFtQQVRDSCB2NSAxMi80OV0gS1ZNOiBh
cm02NDogZ2ljLXY1OiBLZWVwIEdJQ3Y1IHZDUFUNCj4gbGltaXQgbW9kZWwtc3BlY2lmaWMgLS0t
DQo+IGNvbW1pdCA0MmJhY2Y2NTQwNjk1ZmMxMmEzNWVlZTAwNmQ1MzgyMzAzMTc2OTcxDQo+IEF1
dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtW
TTogYXJtNjQ6IGdpYy12NTogS2VlcCBHSUN2NSB2Q1BVIGxpbWl0IG1vZGVsLXNwZWNpZmljDQo+
IA0KPiBUaGlzIHBhdGNoIHNlcGFyYXRlcyB0aGUgSVJTLWRlcml2ZWQgdkNQVSBsaW1pdCBmb3Ig
R0lDdjUgZnJvbSB0aGUNCj4gZ2VuZXJpYw0KPiBLVk0gbWF4aW11bSBsaW1pdC4gSXQgYWRkcyB2
YWxpZGF0aW9uIHRvIHJlamVjdCBHSUN2NSBkZXZpY2UgY3JlYXRpb24NCj4gaWYNCj4gZXhpc3Rp
bmcgVkNQVSBJRHMgZXhjZWVkIHRoZSBHSUN2NSBtb2RlbC1zcGVjaWZpYyBsaW1pdC4NCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBpbmRleCAwNzlhNTdjMmIxOGY2Li44
ZTFlODQ0ZWQ2ZTkzIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
bml0LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+IA0KPiBb
IC4uLiBdDQo+IA0KPiA+IEBAIC0xMjksMTMgKzEyOSwzNCBAQCBpbnQga3ZtX3ZnaWNfY3JlYXRl
KHN0cnVjdCBrdm0gKmt2bSwgdTMyDQo+ID4gdHlwZSkNCj4gPiDCoAl9DQo+ID4gwqAJcmV0ID0g
MDsNCj4gPiDCoA0KPiA+IC0JaWYgKHR5cGUgPT0gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1YyKQ0K
PiA+ICsJc3dpdGNoICh0eXBlKSB7DQo+ID4gKwljYXNlIEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19W
MjoNCj4gPiDCoAkJa3ZtLT5tYXhfdmNwdXMgPSBWR0lDX1YyX01BWF9DUFVTOw0KPiA+IC0JZWxz
ZSBpZiAodHlwZSA9PSBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjMpDQo+ID4gKwkJYnJlYWs7DQo+
ID4gKwljYXNlIEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMzoNCj4gPiDCoAkJa3ZtLT5tYXhfdmNw
dXMgPSBWR0lDX1YzX01BWF9DUFVTOw0KPiA+IC0JZWxzZSBpZiAodHlwZSA9PSBLVk1fREVWX1RZ
UEVfQVJNX1ZHSUNfVjUpDQo+ID4gLQkJa3ZtLT5tYXhfdmNwdXMgPSBtaW4oVkdJQ19WNV9NQVhf
Q1BVUywNCj4gPiAtCQkJCcKgwqDCoMKgDQo+ID4ga3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLm1heF9n
aWNfdmNwdXMpOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBLVk1fREVWX1RZUEVfQVJNX1ZH
SUNfVjU6DQo+ID4gKwkJa3ZtLT5tYXhfdmNwdXMgPQ0KPiA+IGt2bV92Z2ljX2dsb2JhbF9zdGF0
ZS5tYXhfZ2ljdjVfdmNwdXM7DQo+ID4gKw0KPiA+ICsJCS8qDQo+ID4gKwkJICogV2UgdXNlIHRo
ZSB1c2Vyc3BhY2UtYWxsb2NhdGVkIHZjcHVfaWQgYXMgdGhlDQo+ID4gaW5kZXggaW50byB0aGUN
Cj4gPiArCQkgKiBHSUN2NSBWUEUgdGFibGUuIFRoaXMgZW5zdXJlcyB0aGF0IHVzZXJzcGFjZSdz
DQo+ID4gdmlldyBhbmQgdGhlDQo+ID4gKwkJICogZ3Vlc3QncyB2aWV3IG9mIElBRkZJRHMgcmVt
YWlucyBjb25zaXN0ZW50IC0NCj4gPiBHSUN2NSdzIHZpcnR1YWwNCj4gPiArCQkgKiBJQUZGSUQg
aXMgdGhlIFZQRSBJRCBpbiB0aGF0IFZNJ3MgVlBFVC4NCj4gPiArCQkgKg0KPiA+ICsJCSAqIFJl
amVjdCB2R0lDdjUgY3JlYXRpb24gaWYgd2UgaGF2ZSBhbHJlYWR5IGdvdA0KPiA+IGFueSB2Q1BV
cyB0aGF0DQo+ID4gKwkJICogd2UgY2Fubm90IGJhY2sgd2l0aCBhIEdJQ3Y1IFZQRSBpbiB0aGUg
VlBFVC4NCj4gPiArCQkgKi8NCj4gPiArCQlrdm1fZm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBrdm0p
IHsNCj4gPiArCQkJaWYgKHZjcHUtPnZjcHVfaWQgPj0ga3ZtLT5tYXhfdmNwdXMpIHsNCj4gPiAr
CQkJCXJldCA9IC1FMkJJRzsNCj4gPiArCQkJCWdvdG8gb3V0X3VubG9jazsNCj4gPiArCQkJfQ0K
PiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJYnJlYWs7DQo+ID4gKwl9DQo+IA0KPiBbU2V2ZXJpdHk6
IEhpZ2hdDQo+IFRoaXMgaXMgYSBwcmUtZXhpc3RpbmcgaXNzdWUsIGJ1dCBkb2VzIHJlc3RyaWN0
aW5nIHRoaXMgdmFsaWRhdGlvbg0KPiBsb29wIHRvIA0KPiBvbmx5IEdJQ3Y1IGxlYXZlIHRoZSBv
bGRlciBtb2RlbHMgdnVsbmVyYWJsZSB0byBhbiBvdXQtb2YtYm91bmRzDQo+IHZjcHVfaWQ/DQo+
IA0KPiBJZiB1c2Vyc3BhY2UgY3JlYXRlcyBhIFZDUFUgd2l0aCBhIGxhcmdlIElEIChmb3IgZXhh
bXBsZSwgNTAwKSBiZWZvcmUNCj4gY3JlYXRpbmcgDQo+IHRoZSBWR0lDIGRldmljZSwgaXQgc3Vj
Y2VlZHMgYmVjYXVzZSB0aGUgcHJlLVZHSUMgbGltaXQgZGVmYXVsdHMgdG8NCj4gdGhlIA0KPiBt
YXhpbXVtIHN1cHBvcnRlZCBieSB0aGUgc3lzdGVtLiBJZiB1c2Vyc3BhY2UgdGhlbiBzZWxlY3Rz
IGEgR0lDdjINCj4gZGV2aWNlLCANCj4ga3ZtX3ZnaWNfY3JlYXRlKCkgZHJvcHMgbWF4X3ZjcHVz
IHRvIDguIA0KPiANCj4gQmVjYXVzZSB0aGUgdmNwdV9pZCBjaGVjayBhYm92ZSBpcyBpbnNpZGUg
dGhlIEdJQ3Y1IHN3aXRjaCBibG9jaywgd2UNCj4gc2tpcCANCj4gdmFsaWRhdGluZyB0aGUgZXhp
c3RpbmcgVkNQVXMgYWdhaW5zdCB0aGUgbmV3IEdJQ3YyIGxpbWl0Lg0KPiANCj4gV2hlbiBjb25m
aWd1cmluZyBwcml2YXRlIElSUXMgbGF0ZXIgZHVyaW5nIGluaXRpYWxpemF0aW9uLCANCj4gdmdp
Y19zZXR1cF9wcml2YXRlX2lycSgpIGRvZXMgdGhpczoNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy1pbml0LmM6dmdpY19zZXR1cF9wcml2YXRlX2lycSgpIHsNCj4gwqDCoMKgIC4uLg0K
PiDCoMKgwqAgaXJxLT50YXJnZXRzID0gQklUKHZjcHUtPnZjcHVfaWQpOw0KPiDCoMKgwqAgLi4u
DQo+IH0NCj4gDQo+IEV2YWx1YXRpbmcgQklUKDUwMCkgc2hpZnRzIGEgNjQtYml0IGludGVnZXIg
YnkgNTAwLCB3aGljaCByZXN1bHRzIGluDQo+IHVuZGVmaW5lZA0KPiBiZWhhdmlvciBpbiB0aGUg
a2VybmVsLiBBIHNpbWlsYXIgc2hpZnQgaGFwcGVucyBmb3IgU0dJIHJvdXRpbmcgaW4gDQo+IHZn
aWNfbW1pb193cml0ZV9zZ2lyKCkuDQo+IA0KPiBTaG91bGQgdGhpcyB2YWxpZGF0aW9uIGxvb3Ag
YmUgbW92ZWQgb3V0c2lkZSB0aGUgc3dpdGNoIHN0YXRlbWVudCBzbw0KPiBpdCBydW5zIA0KPiBm
b3IgYWxsIFZHSUMgbW9kZWxzIGFuZCBwcmV2ZW50cyB0aGVzZSBvdXQtb2YtYm91bmRzIHNoaWZ0
cyBhY3Jvc3MNCj4gdGhlIGJvYXJkPw0KPiANCg0KSSB0aGluayB0aGF0IHRoaXMgbWFrZXMgc2Vu
c2UuIEkndmUgcmV3b3JrZWQgdGhlIGNvbW1pdCB0byBwZXJmb3JtIHRoaXMNCmNoZWNrIGZvciBh
bGwgdGhyZWUgdkdJQyBtb2RlbHMuIFRoaXMgd2F5IHdlIHJlamVjdCBiYWQgY29uZmlndXJhdGlv
bnMNCmFjcm9zcyB0aGUgYm9hcmQsIHJhdGhlciB0aGFuIGp1c3QgZm9yIEdJQ3Y1LiBJbiB0aGVv
cnksIHRoaXMgY2hhbmdlDQptYWtlcyBubyBkaWZmZXJlbmNlIGZvciBHSUN2MyBhcyB0aGF0IGlz
IGFsd2F5cyBjYXBwZWQgYXQgNTEyLCBidXQgZm9yDQpHSUN2MiBhbmQgR0lDdjUgaXQgbWFrZXMg
YSBkaWZmZXJlbmNlIGJ5IHJlamVjdGluZyBvdXQgb2YgcmFuZ2UNCnZjcHVfaWRzIG9uY2UgdGhl
IHZHSUMgaGFzIGJlZW4gY3JlYXRlZC4NCg0KVGhhbmtzLA0KU2FzY2hhDQo=
