Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010059.outbound.protection.outlook.com [52.101.84.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA92EF653
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373108; cv=fail; b=ldVJdrQsfJ9rSmcHMEw3SQQPnx7S/sJll/5dS1/WUqIUux26GqKoIat8+7VZXOOCMdKxlycBzMoNgu32SduQ7msa1/+N3bXSyT09SB38JR70xPCxg3ye+cbA0LHKAXH+wwg3vxZrzKm84dpkWuXtqxbnMgwqaCSSimF2SxF3yxs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373108; c=relaxed/simple;
	bh=Q3EPmytiYYIPSz7o5mNLUDYYYh27sJM0ubBpmSCKyIQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=atQMHKB8C4gmynr4mGPs2tmDMzxRehpvwmf0Y0QBvn40P09GSEGiDyt3BAr7dyErG6eG8WtSC5SEr4liZcgJ8A6sl/E8y004fsKsfFXHwUZrVyrmsPfbUVVybbxQzbwYEoiSNqQDgW9F/BbTKH+lIE6MbU5L88g22NvKH9Bwm8Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bXPXYJVe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bXPXYJVe; arc=fail smtp.client-ip=52.101.84.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bXPXYJVe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bXPXYJVe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=FAQ3er6OOTIKrNbNl5GchkXYmUJKwMZSDQqUf76VHLpssqx3ihn7fVenl0n3zwitsZYksvHJfkK9+BhzjwzF1fxffEkPYCtjrBsvYjod758Ok0oHah4HRDEn23V+jzaTpHsZU0uPbRDRLsUI99amcnvDE053UplQu8aUALnCrjC/zDzDfSFkvWIR+GtmPFdds4FJk7tkhnAolPP+B9/ZVNlPPXZhsOzfwkyiVyx/ZDg6R/Q+cQ8ovisvoZuR3dy/+P6HStKw6qaE4IrrwT17xOBf5DyYRbjovFdiNVUdYFguCdBHFyQt86PplwlOUcqwd1MCoUFuR3a0n77muZQGjw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3EPmytiYYIPSz7o5mNLUDYYYh27sJM0ubBpmSCKyIQ=;
 b=TAeoiJ3V9NMq6EduWXc30PcA8yTwsOqza53Tw1TORlKqhVfgIwqKGfbgCerjwa/5YKIG+WSthhc3mFZzubFAtSzxIFVNID/JqM8lHWzcav7v+ZTwGh0Del7NXyD6bh/YGyD58jqwkCOgr2yDXFmaABwVFv8XddkMQERb0fb2WurrDBIpsSZRHuyDoXckILgHBLR/5SsNX7CZQz3edteENKWPPaYG8mv5QjyLCzMz7j1HEC5+uKbpNqFsOBK6NvV/2R0CGs3s4WUKSSsM9LpABvTKofKuM0YCfdSspq8ZRCDM2WP3WsYnYPkbhv3tquR3AzgSazJ6JstbhhkfE/n7ww==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3EPmytiYYIPSz7o5mNLUDYYYh27sJM0ubBpmSCKyIQ=;
 b=bXPXYJVeHTAGzHde3Naa2Cdk79R3cxdT5jzfD8VswrepUg5IFpIcv40CQ/AaOFyLiEsSHcTlihirIXQpQmRxLKyngVOe09q9saQ8U5Qc3r5qXjsRXdaJRMqPHhqh7cqARAsSnMBjmXmIV8LaI1TBmuxEb7O7d6en42e5IG5JEWA=
Received: from DUZPR01CA0206.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::21) by PAWPR08MB10305.eurprd08.prod.outlook.com
 (2603:10a6:102:367::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:18:17 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::36) by DUZPR01CA0206.outlook.office365.com
 (2603:10a6:10:4b6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:18:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:18:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FdWP+1nPSDyO8dbJiv1OvD7IFOj0Rhb89KJGJy2A9GMIS+Hl4FG3JY1O1dx5w2AlEXGOHRpuY66iMzfHXhFN5cMmEhdRh6XZr5ZvMbFwzzHuxjjNQ7x+oMj7/IQEDesA9BwQAso+yDgIU5mH1gtHG/OkfmP7qX/mNbi0JE7hsiOOqshLzfjmRrOCK5C1ld9ahe0mIHHLp7qIz1aHdhiWbDkdChzdAG4xIkv7l7lELYf7j1xrbLaTK6kCBJivsNPRMBROmCONXwbo3M/DXFwS9caAMmEgSFmRpbqcUs/P9uE9FL7yXzW0U4VlLEuAPT9jLSOln0WpXF0n0yQIcX/TBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3EPmytiYYIPSz7o5mNLUDYYYh27sJM0ubBpmSCKyIQ=;
 b=fp3nKrQEYGeLsTQ7t73WlbIxDUONo1VELb4pQAocdA8TkNuP6temLJYjspc0mxBjcwOF/VUykzrKs6z9Lz+R8zYXJnZMeZNSRXW0/Ti29ObsK6gMIKwUlFokjp6Pq02rN2BARwaQXg0OQQGT/HylWNQsfWDwFE6dri8CcmsD2i9DZ4LUC0mYxIc4CuFV5kqX5MrrsEsNVtkoo7guOUqeuhkp13DoiNyQYDHEZwUe+nCs2bBOe3mdVQbE6MbR/WLOZYnrO/vA6f+a/GPlf1ARl9L38sq4XUToqWZexZR8WKiQuhpnquBZkiibd0aneNvRHnQwLseyTsBdGbPkDJ0oVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3EPmytiYYIPSz7o5mNLUDYYYh27sJM0ubBpmSCKyIQ=;
 b=bXPXYJVeHTAGzHde3Naa2Cdk79R3cxdT5jzfD8VswrepUg5IFpIcv40CQ/AaOFyLiEsSHcTlihirIXQpQmRxLKyngVOe09q9saQ8U5Qc3r5qXjsRXdaJRMqPHhqh7cqARAsSnMBjmXmIV8LaI1TBmuxEb7O7d6en42e5IG5JEWA=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by AS8PR08MB9868.eurprd08.prod.outlook.com (2603:10a6:20b:5ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:17:14 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:17:14 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 17/43] KVM: arm64: gic-v5: Enable VPE DBs on VPE reset and
 disable on teardown
Thread-Topic: [PATCH 17/43] KVM: arm64: gic-v5: Enable VPE DBs on VPE reset
 and disable on teardown
Thread-Index: AQHc1mCO6WZjLSSAYEGzsoV6jlitxbYBJlmAgBeF74A=
Date: Thu, 21 May 2026 14:17:13 +0000
Message-ID: <fd4cb8ab4d189ea107e6abdfb6617302996e1fdf.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-18-sascha.bischoff@arm.com>
	 <861pfozijq.wl-maz@kernel.org>
In-Reply-To: <861pfozijq.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|AS8PR08MB9868:EE_|DB1PEPF000509F0:EE_|PAWPR08MB10305:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e998f82-3b7b-488f-9a8a-08deb743cd4e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|56012099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 Pg7oA0yWlvF8kmzLtvNDNTo6xj2E/Po8YADDlxlBa9LEI4sp42HrVO8s/Od+g66ok/RPLVgATBpSJsSHVsBNdOaUb/n38AI8VdgSeensKrsH1Qvi9/kYrOC+1pPoeJuTKAITTKRlxBArmsK+Pe3IJq936JSFlYhmUGBPvje48oJRz9xrSdsh09/bIybaurV1MUZjCJki+l5CgKlTx182AxHCrDKqeVaZXWVIYbQKj9Z18Ensp2QalVTxYs498BCIBTFqOwDcxy0ENxM1Z07MXRdetDGK5QEbhfoLrzL1/HHJncW4kzqKmHJVcMNtq0QPRI9SKmlAoHUEZ/35AtWhNbCDxNffAj1ORO6xKeN8IQaKlnuuJ31kXjA67VJU4YeOh5B+BtfjZIEoIiFaGJVhRFWOvICbr649MkDFNES391AAys0ebB8yPDXLBOPFMSIb3H+73ts5erFBdsZ7S3Y8QbKICuVvASjRGgMqXWft1kyLTl9Z27EBAPR2GgO1mufEVnI6Fke2PVuJ8K7rH1xdCRFeiYiSC1XPhySQpiW/mLxT/n2dvY5/PLRFEp3j4qlefy71eXTso6FsaEJQUVR31MqYC31CFEsp3RTtHrdOiZoY+plqOOzYbm7ZCm26aHmAjjbdMBOWYOlV3rJG7YborAkptYLiWwU6dKJAP1LlkJHZm9ZKCnVpDYD/PVUkpJcm1FgZa7wPnVFFFC2WniucCAstJr1uYeE5HzGsIAj3ppPDW/eaKuCnRa++ak7dePTT
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAD197989EBD784A8B619F963A76F774@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 c3O3AsnJEF0bXsc6CAtfjyjX29B4LoCFSaE9AUtgnCctFEpvPsIeNBboz19d4FygbIJ/PD7UEs7BDuHK30oRGd+4eoxg+5fibLER9ZvrYJUD7p6rZIh00oHmD6x7LxrCRUl5gQqgC2j3nVynHeNtdkJ3hG127DAzEigLLb8rGMOl5nJT1I/yv5WLQi6q9zffH6fSTbe2b/tfQ8C+XPECyrHY1Htsg19aSw7HvPm+qeVlhoFO5VngSv1h/io+ZpV/EkLlNqMkFa1OkeBThof7j8mqTBTtvWi3oVsdWkIAnsjrBVDmIUQMAqdhxDx9O8+D0T/RI1+Ofhp/9lp4LRVyYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9868
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9aa9bdda-e115-445e-94c3-08deb743a7e3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|1800799024|376014|36860700016|82310400026|22082099003|18002099003|56012099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	yKtzFE12RRwJr8VvyDaZh9nnHgWknZnmrChN3lp32+MzoSJEOliBetU0MVRdwhOwe1+Upd+eQO1stM3/rhAUYF8N0sDMQsEIyPDHC2Hqtrk4rinyToIUTwE1jK5sONgqRSOXYqJ1kFmDvfpo2DAnXVUmDJrvelyM6QUhyoEt4wEdxqN+QEPH03QZbYiCht7C2pH28H5+hs6HdEwUhpRTEswWXc0ylAXzqnsDFjLWs+GzODwvm1aZa1l1wsCiugxk8lXokJOeUbdXgy6PMD9vXFcA7NpKW2nZ9nECaWKAwxdBy8k5/QGYyT/2OCCsK/OojJvgVjyPlSCXnMMPMMHROTMJKnJfgyYXWCqqap2vBOtUO2A6JTVN6jHIpQPQgExqJ5T9JwMARqbb7O992B6ec5V7gN0naenKRHNrKHmKytephVwu6GAkTJS3DBhiI4wgX2gV6JXSXLN79ps+dVbLnaGrSC5M9jKzH0Gzqp0hqMvnYe7i4wZ5EW3uubazm/AJdB4YRkFgnc6SI3hQUy3Pg21Y7ysUfg3ENyXxtjCEe4EnbezoW+mYzSPZtlxh3JlRFto6D1eqMmpah7yFiduPuis8bbMTx2xePqUWDQz7N9SWZsEW3dYA+OLNFRdPUgEgS3hlkU/m5/LT97saE8Lnkuu/gdzN5VW0qP7eBL0hqGgqImzMxtUsH5Yoz6kaBVEIW57/bR3/0ubSZ707vQT64dVpCOPaZiZuKa4DyM798uo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(1800799024)(376014)(36860700016)(82310400026)(22082099003)(18002099003)(56012099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VPJp1gPrG1dIkWtXvN5Wb3MAvgWC7QcGF2iDRGNqXWv7R9ZYbpXXa3X5WtSBC/w2RWQaJblpdbrhwuz+rTqbEKMQXWdsgB/dTeRPpJlvMINaB1ANRU1Xfj1wZ553vYOCqaWBbL8BtHKARYGjVjNUpXEQIb5b1BguepFxC6Jba7+yZg2ee9bx+H6FUddFNihZ/7e/lmV4PD/h1oiZPLbi/fBbnvbDIxrVDPh1LtJsndUuMCSBZbxoeSH27gJkfxX99RjW/JGs7g5YxqWH915Iaxf7OeU5iOv7RQRkSphP3JhBuqQBgz8kjrtw/oYLW2uzH8y+yInP821ceDDMjNveTa074DM57mHcTxtMdh59+a4DPo3zJqXX21Hy7f38BsP1O3TzarVMAiNRum6S5BegMI0iOe1EfAaFB4qv1FZExmo20ogy0h0pcU67Ut0jaodw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:18:16.7149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e998f82-3b7b-488f-9a8a-08deb743cd4e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10305

T24gV2VkLCAyMDI2LTA1LTA2IGF0IDE2OjAzICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MTE6NTAgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEVuc3VyZSB0aGF0IGVh
Y2ggVlBFIGRvb3JiZWxsIGlzIGVuYWJsZWQgb24gdGhlIGhvc3QgcHJpb3IgdG8NCj4gPiBydW5u
aW5nDQo+ID4gdGhlIGd1ZXN0IGJ5IGVuYWJsaW5nIGl0IGFzIHBhcnQgb2YgdmdpY192NV9yZXNl
dCgpLiBBZGQgYSBmdW5jdGlvbg0KPiA+IHRvDQo+ID4gZGlzYWJsZSBpdCBhZ2FpbiBhcyBwYXJ0
IG9mIFZNIHRlYXJkb3duLCB2Z2ljX3Y1X2Rpc2FibGVfdmNwdSgpLA0KPiA+IHdoaWNoDQo+ID4g
YWxzbyBmcmVlcyB0aGUgSVJRIGFnYWluLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2No
YSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYyB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCA5MzQ3YmM2ODk1MjIzLi40OGZmY2IyNDk0
ZGIzIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4g
KysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtNzM2LDYgKzczNiwz
MSBAQCB2b2lkIHZnaWNfdjVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgCQlr
dm1fdm1fZGVhZCh2Y3B1LT5rdm0pOw0KPiA+IMKgCQlyZXR1cm47DQo+ID4gwqAJfQ0KPiA+ICsN
Cj4gPiArCWVuYWJsZV9pcnEodmdpY192NV92cGVfZGIodmNwdSkpOw0KPiANCj4gT2RkLiBXaHkg
ZG8geW91IG5lZWQgdG8gbWFuYWdlIHRoZSBlbmFibGluZyBvZiB0aGUgZG9vcmJlbGw/IEkgc2Vl
DQo+IGZyb20gdGhlIHByZXZpb3VzIHBhdGNoIHRoYXQgeW91IHNldCBpdCBhcyBJUlFfTk9BVVRP
RU4sIGJ1dCB0aGlzDQo+IHNlZW1zIHRvIGJlIGNhcmdvLWN1bHRlZCBmcm9tIEdJQ3Y0ICh3aGlj
aCByZWFsbHkgbmVlZHMgaXQpLg0KPiANCj4gTXkgZXhwZWN0YXRpb25zIHRoYXQgc2luY2UgdGhl
IGRvb3JiZWxsIGlzIGNvbnRyb2xsZWQgZnJvbSBLVk0gYW5kIGlzDQo+IG9ubHkgb25lLXNob3Qs
IHdlIHNob3VsZCBiZSBPSy4gVGhpcyBpcyB0aGUgZmxvdyB0aGF0IHY0LjEgYWRvcHRzLA0KPiB3
aXRob3V0IGEgbmVlZCB0byBiYWJ5LXNpdCB0aGUgaW50ZXJydXB0IHN0YXRlLg0KDQpJJ3ZlIHJl
d29ya2VkIHRoaXMgdG8gbWFrZSBtb3N0IG9mIGl0IGdvIGF3YXkuIFdlIGRpZG4ndCBuZWVkIHRo
ZQ0KSVJRX05PQVVUT0VOIChpdCB3YXMganVzdCBjb3BpZWQgZnJvbSBHSUN2NCksIGFuZCB0aGF0
IG1lYW5zIHRoYXQgbXVjaA0Kb2YgdGhpcyBjYW4gZ28gYXdheS4gSW4gZ2VuZXJhbCwgSSd2ZSBy
b2xsZWQgdGhlc2UgY2hhbmdlcyBpbnRvIHRoZQ0Kb25lcyB0aGF0IGluaXQgYW5kIHRlYXIgZG93
biBHSUN2NSBWTXMgaW4gZ2VuZXJhbCBnaXZlbiBob3cgdGlnaHRseQ0KY291cGxlZCB0aGV5IGFy
ZSBpbiB0aGUgZmlyc3QgcGxhY2UuDQoNCj4gDQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2
b2lkIHZnaWNfdjVfZGlzYWJsZV92Y3B1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiArew0K
PiA+ICsJaW50IHZpcnEgPSB2Z2ljX3Y1X3ZwZV9kYih2Y3B1KTsNCj4gPiArDQo+ID4gKwlpZiAo
IXZjcHUtPmt2bS0+YXJjaC52Z2ljLmdpY3Y1X3ZtLmRvbWFpbikNCj4gPiArCQlyZXR1cm47DQo+
ID4gKw0KPiA+ICsJaWYgKCF2aXJxKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwkvKg0K
PiA+ICsJICogV2UgYXJlIGNhbGxlZCBpbiB0aGUgdmdpY192NV90ZWFyZG93biBwYXRoLiBXZSBu
bw0KPiA+IGxvbmdlciBuZWVkIHRoZQ0KPiA+ICsJICogZG9vcmJlbGwgdmlycXMuDQo+ID4gKwkg
Ki8NCj4gPiArCWRpc2FibGVfaXJxKHZpcnEpOw0KPiANCj4gQW5kIHRoZW4gdGhpcyBjYW4gZ28g
YXMgd2VsbC4NCg0KWXVwLCBnb25lLg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qIEZyZWUgdGhlIGRv
b3JiZWxsIGlycSAoY291bnRlci1wYXJ0IHRvIHJlcXVlc3RfaXJxKSovDQo+ID4gKwlmcmVlX2ly
cSh2aXJxLCB2Y3B1KTsNCj4gPiArDQo+ID4gKwkvKiBSZW1vdmUgdGhlIGlycSBmcm9tIHRoZSBk
b21haW4gdG9vICovDQo+ID4gKwlpcnFfZG9tYWluX2ZyZWVfaXJxcyh2aXJxLCAxKTsNCj4gDQo+
IFN1cmVseSB5b3UgcmVtb3ZlIHRoZSBkb21haW4gYXQgc29tZSBwb2ludC4gVGhhdCBzaG91bGQg
Y292ZXIgdGhlDQo+IGZyZWVpbmcgb2YgYWxsIHRoZSBkb29yYmVsbHMuDQoNCkFnYWluLCBJJ3Zl
IHJld29ya2VkIGFuZCBjb25zb2xpZGF0ZWQgdGhpcy4NCg0KPiANCj4gPiDCoH0NCj4gPiDCoA0K
PiA+IMKgaW50IHZnaWNfdjVfbWFwX3Jlc291cmNlcyhzdHJ1Y3Qga3ZtICprdm0pDQo+ID4gQEAg
LTg3NSw2ICs5MDAsMTAgQEAgdm9pZCB2Z2ljX3Y1X3RlYXJkb3duKHN0cnVjdCBrdm0gKmt2bSkN
Cj4gPiDCoAkJCWt2bV9lcnIoIkZhaWxlZCB0byByZWxlYXNlIFZNIDB4JXhcbiIsDQo+ID4gZGlz
dC0+Z2ljdjVfdm0udm1faWQpOw0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+ICsJLyogR29vZGJ5ZSBk
b29yYmVsbHMgKi8NCj4gPiArCWt2bV9mb3JfZWFjaF92Y3B1KGksIHZjcHUsIGt2bSkNCj4gPiAr
CQl2Z2ljX3Y1X2Rpc2FibGVfdmNwdSh2Y3B1KTsNCj4gPiArDQo+ID4gwqAJdmdpY192NV90ZWFy
ZG93bl9wZXJfdm1fZG9tYWluKCZrdm0tPmFyY2gudmdpYy5naWN2NV92bSk7DQo+ID4gwqANCj4g
PiDCoAl2Z2ljX3Y1X3JlbGVhc2Vfdm1faWQoa3ZtKTsNCj4gDQo+IEkgcmVja29uIHRoaXMgcGF0
Y2ggd291bGQgYmUgYmV0dGVyIGZvbGRlZCBpbnRvIHRoZSBwcmV2aW91cyBvbmUsIHNvDQo+IHRo
YXQgd2UgY2FuIHNlZSBib3RoIHRoZSByZXF1ZXN0aW5nIGFuZCBmcmVlaW5nIG9mIHRoZSBkb29y
YmVsbA0KPiBpbnRlcnJ1cHQgaW4gdGhlIHNhbWUgcGF0Y2guDQoNCkFncmVlZCwgYW5kIHRoYXQn
cyB3aGF0IEkndmUgZG9uZSBub3cuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiAJTS4NCj4gDQoNCg==
