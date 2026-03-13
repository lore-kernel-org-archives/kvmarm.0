Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013042.outbound.protection.outlook.com [40.107.159.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFC735A3AE
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 10:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773396060; cv=fail; b=S0MbH+VdTtovs29CXl1gh5daFMqZhjsHWW8afLqXIgo5KVDrLtRGdNmQDIuouOtKN43PVk5w07qM+xKAybyOAkp4qnOxrjbASo+VdUOCTfkghP6UJTEgUF/pROStnCnRLiPbm/c5xOnLl5FZ6nVEJ4DGakVidDldU/eWWpZl4YY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773396060; c=relaxed/simple;
	bh=Uem5hR1J53HAUuNAOZZr68xhlSwIolIEYkiwbC0AiF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=slbFXA3Va3U+CcBTDtGKvZcA3B0CN1kRoou3SDZg/y9oY3cBcSG54zjnmbNwza8IQJ+R1yeKguOdR2Wkc6bav9gx3Yam/qebmwWcSh3R+I2r8/I6TRq7trrbruGYTHz12B4WtoIVBK1xLTTIHSl61Rakks9N7qZOsL6nEFhqSlY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=geTup90p; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=geTup90p; arc=fail smtp.client-ip=40.107.159.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="geTup90p";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="geTup90p"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UCN+lFqEVRkoWZxA5TpKRZXzRml4mvON4OhZYNLs+li27kroBjS88oxIgCp4PVYkGGET2Pe8hBY5SMx4X/O/8p4FYBVLTccHrIADdEZn4rlJ2H+8uTAHwP0RqTab+sbN15t1eOUCgly8A4zNVucIyYRizS/smk64iZms7j+ApJh6f4QnasUldYBzB6EkWWXMiHlYvGeOxtvxKrT7pZp2y0WKvJ7Fufv2yUxNK3A5wu15BrlKv+4hvRbX9NxHt1ZgPjSTD1Meeg4FB2jhqbuINxR3OryZDzyPAryt01z9p35c11qgnos3hohRODaEFfjJZX9saSnRN5YNE19z+kMCcg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6Fx5OYIX866jELJrogbB69hAUhkdK9GqDE6v8G3RCA=;
 b=V0uZBxhghZnEaD4REmbhwF5GAYRl+Qa9CQ1hNa8adjMqdjgd1/e3yYSCPbuqQkcF98so9GlaVQ/KuRy/5JmBfftkk4sncq5t+ITyMLiZSUjiiMcUnfuOk+AFCIgGcd3xrhH00mjhInyx+sDqQ96MpW9JLgiXYiA8lxjysxudmse1xuAqRcKDAWnwy0cJMm1ibhw5QBHdoeQwjGlwP81G2JNjgRcVedf2c2v3oCA8T+s0hvdZoGFWwE4b3kSzSCqWg1unD6R3ti1JlTgMJ5VGhAntTxAE7hfas5Rx2qWcmoCOs1Fqv+Pol9R0h13o/WKbqSSn4KhVEif6mafFQv8ctw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6Fx5OYIX866jELJrogbB69hAUhkdK9GqDE6v8G3RCA=;
 b=geTup90p242/h8ApWeaKeXfovmNAxKusV0InGk62Qavja3jCsXhWB7OWr0SMAYCDK3yuzRVvLqweZydbZznBprFyQ5Qx1Ti8FR42N4A+d2bPdwiFIpG8oBo2FYkl3U02VW7EPuCr+sHqE6E4HO5cO83DpfrAw+DfZjgSHj0nCrQ=
Received: from DU7P251CA0026.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::30)
 by DU0PR08MB8229.eurprd08.prod.outlook.com (2603:10a6:10:3a7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 10:00:54 +0000
Received: from DU2PEPF00028D08.eurprd03.prod.outlook.com
 (2603:10a6:10:551:cafe::20) by DU7P251CA0026.outlook.office365.com
 (2603:10a6:10:551::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.16 via Frontend Transport; Fri,
 13 Mar 2026 10:00:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D08.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Fri, 13 Mar 2026 10:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5G8s8rexyj2WLVfGOfmCR266WepfNfMpOU2roBx9+CcNj5t7QmiP+FAM/MWZTvfrpglv56FK4fYtVcUqPMLqkiQmRL9r5VzFW1VYRvNqpJHe9YkJOmvKWFD2jTc2IOpt/jVOgNXbaPRJH4cVWi4D4G4/E6Y9xWlI1xWtBxsELOUeCDQ78eHCYCeNUXdaLc4MdcQyquCV3iabPd7j5lnheVJaCQd9x+nO1czVgqtFPaxqTU3ugX/E3oZjIHHm34pYkT9v0xdxtqJ+7leVE00K78fvxqGy/zlgmpIUIrAaZtRwpU4V14B2E9acJu9mg1xT/bWw2KeeJw1hSsOKxVmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6Fx5OYIX866jELJrogbB69hAUhkdK9GqDE6v8G3RCA=;
 b=Hd8EEnDNAx68UnsT3er9srlHhQ74omgbYrEy0AqHtjj+DRQ5K2yTnpV9y7Ze2MAQGCzH9SSsrdpJ3BYFjRZfB8BG1j8IU4zOBs5XA0VC/CykbAk8amBfW1UgrPE8foovuOWSMoWmcUSOHJV8BM5MPk5vlndbENMgM3iFS8E4H7IpKOtH6+y1X440RmT+hww5zBF+10JNCkyKJrEYRxu23U+0VWe4iHg0HF3KCY4TMg7gMtgG64iY3a/ykxVVIO9IF8K9hzBaAXX8BTjT/GciyRqBdhQgCMdRjAKREpr0PCRzw5PueCEx+4YtgcHrbQi1BsBBw1aIW/mVzkuQYy0dvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6Fx5OYIX866jELJrogbB69hAUhkdK9GqDE6v8G3RCA=;
 b=geTup90p242/h8ApWeaKeXfovmNAxKusV0InGk62Qavja3jCsXhWB7OWr0SMAYCDK3yuzRVvLqweZydbZznBprFyQ5Qx1Ti8FR42N4A+d2bPdwiFIpG8oBo2FYkl3U02VW7EPuCr+sHqE6E4HO5cO83DpfrAw+DfZjgSHj0nCrQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB8237.eurprd08.prod.outlook.com
 (2603:10a6:150:5d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 09:59:47 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9700.010; Fri, 13 Mar 2026
 09:59:47 +0000
Date: Fri, 13 Mar 2026 09:59:43 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 7/8] KVM: arm64: use CAST instruction for swapping
 guest descriptor
Message-ID: <abPgD8JkDAg8kgJK@e129823.arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-8-yeoreum.yun@arm.com>
 <abPfZ27gbcBoAhEi@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abPfZ27gbcBoAhEi@arm.com>
X-ClientProxiedBy: LO2P123CA0064.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::28) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB8237:EE_|DU2PEPF00028D08:EE_|DU0PR08MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: c527f024-e1cb-47b2-be78-08de80e76a41
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Qje4Wz00KhbWdnUgBxdUBeHUntxRhhH4IZXsd2KThFyrTnvZVmTdIA1d5dRyx6yLRnRpWZFJSdHdV306RAfvlalMCgiCIcUVVsQdxUA9/rSJVWH9V0qZWladLbnEYMO/M4N7g1w/XPB97iZKlfZxxTRijX2QsM+jYYVgRe4PRObmYa5xkGKc4iI6hqeN+UBxRYpzE/4acH3iWTq1cdBsMCePMSGl0dwl3RxXlMf7Ht9AZogBE8PeU7XcE6i/ndh8Acz3LvLnhm/cg5d8h6RakWT+lk86iGo7AP00lV8j1cozAG5yG9ZbFR1589QWQ2Hsj0CwTLIw497VYNxuO3XZC0YXNZAaNW+aO7DpjpCZ/feTaOh4gIUNkG48PdZq2BpK+dSgl5nwzh2Gd+o1mjqPc5zXK6RGcKEbC2WDiDvSA86cBXaWZCTf2VILMwKWTxhuNbE9S2HC8zDLWU/wP2G9v0goP9WsbhHE7Iq0ghL7PlR/L36rfrupqeutaSyA8xoSbzUJrg+8LoLEYrjB6Ovx3Zgh8yzaSz6UG2r0V3Qp2QZS6+Y5FL9LyAGz1YgNoiDYc/jauQ1Mjk3czrKiYrZJm2zcTB6QRiByRcVCHDiM5DjAsGP/5M0bPFQEpD6UgYImWTP3eHUNiku8tpDdQgUS23NSA7aQv2I8PIUBsHn6FGRG2exrUUkxYnetBmQeCftXjuHKTT0L/vOfdNG63jN6jJOpeDJGY8QzydyoG2Do/VqRig7bLPvuh64aCKgteH+w
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 CkYo7e/cbgtZd4/PXzpyuOZWWa5QcaNtu9SSJJt9reg8fGfcjKqjl3oLqlsVnm2MSw7IqJN9LRRsi3tRM0bERgv05M4tNpOrIqCFhtsun+pkVZlWiCP/ZLxkw7/Z+gkHmEqQ1wVxMa+RgSd9rvk6oIIodyuQTpC6X+ceAzGnU0sJRJgG44XZwuqfAb7zopQKtVrNUtecQID9e1ojLJpI8VtmBer5kXkFI/P/kNkQbJ0/UJFbtgu+938AUsDA6OuO9MXpQAVaP8dwjJrcU9FCciFxAaDtxES3BSIpd3hc5rGdRaynizbQ9e85cfx+gNKZrEL8dVgI4PnBwsWTz3r9Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8237
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D08.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cd35e026-b06d-4ea5-3330-08de80e74221
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|7416014|36860700016|376014|35042699022|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	IZgDw0tVNMy0IYXUfw4MTzsyJIRrpEIWQ7sfV6CcGmTYJZRWCmxFUGlKhQctcnjMS5gUDQzVNQ3ea/4bSg9SwBi0O6cn2wkY++hmPtHPrMvyDf+Gv8n/ZMKBz7RMQvTysS9PIvUO4TMllRk4YaR0ahfeYkWRAUo8Qpl5sIz9ulS+wkuH4I4aPpjobexXlwtQopziErdPb4la+T1eM693mvGVP+g+5miSSc2McwCeLAxCgX2d5dJDmOGJwCZJPxWoaxaIsyePntoakZBoJyVpR8oDG7MphtwCMb0V2FJRW1pKTDFWIlwjFIcwulEGAxSigohNQpBoCazYehgcL7JhPe/1PgaR1ya5Trz/8o2lBChXX9FrnPZOjfIrHPgzYfWj03JWVtAif2nNKFDnAI8IBhIBh2BOi1kDIkDkrPkTx9qoY+16GdKjEvakcqL7IIbsa6IIPNFXOwpSmpcyiwZbBDJxU4G+augADRxJrVz5ds71PkqigDv/kz3dok0jwvKn7drWKUw+ksa1JfWlOOHP1XFofGO70qYhSrHYd5mS3YuDlnnYwaJtDsz0TCTeMxhoGaTRHtYHK7BSQMe58V16Ija46K4HNR3armUCwlPIJ7qgoMdkypPxFmjLOReslhQW6/ITv2Xx3JZWEZua3pnVhDySWxdciPiYCZtuCuUTRNEonuBh1L533XnMICoClOyFOglG3OoEKLGKKmsu2vTkF/jStxBkj83g8np/enYgM10vXViULzeNjZbVosM2AT7r1x8FzOOmzri0x5Ew3U+ngA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(7416014)(36860700016)(376014)(35042699022)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SNZaPnFZ038QchoHBY80dcROTRj4bTztFIs10cD0gOY1u1/+JAFaxZ4JxCIbXf7mETNxtmeFO8RXljdGIrn+qqK1aO1Y/yc/6hsX+cVG9Z89vOuaSCmNKGW4tqSjHgkCLHibJ81CNPT72NbPwvJDJBjCSNdzyVp8QWv8qJWzHgeapRWkIkjpzeBoywCnxktARhMuRFwp4iP3ZyjcOaJXWNI0otXqkA9JZwyuZTQKihG5YZnf6jgwilk+OUKKmKo0DxseTX/9fYk1/Ws/hHK7TJBj1mUG1BbE3kTrOfAO1N1iSdb10ZkUMIV6Df7tub70klo8EVap3WER9Shrd9XhDCV/fZFwL5GSfYLaWxO/f7n15mx5ZgONAhxZxOmgPdzwVgUN58hIIHQojm2SBelwdA4dxW636d4ilyV43eJ29O4sRvsRTeNqd1HuKDNBfO7I
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 10:00:54.0712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c527f024-e1cb-47b2-be78-08de80e76a41
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D08.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8229

Hi Catalin,

> On Fri, Feb 27, 2026 at 03:17:04PM +0000, Yeoreum Yun wrote:
> > +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > +{
> > +	u64 tmp = old;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * FEAT_LSUI is supported since Armv9.6, where FEAT_PAN is mandatory.
> > +	 * However, this assumption may not always hold:
> > +	 *
> > +	 *   - Some CPUs advertise FEAT_LSUI but lack FEAT_PAN.
> > +	 *   - Virtualisation or ID register overrides may expose invalid
> > +	 *     feature combinations.
> > +	 *
> > +	 * Rather than disabling FEAT_LSUI when FEAT_PAN is absent, wrap LSUI
> > +	 * instructions with uaccess_ttbr0_enable()/disable() when
> > +	 * ARM64_SW_TTBR0_PAN is enabled.
> > +	 */
> > +	uaccess_ttbr0_enable();
> > +
> > +	asm volatile(__LSUI_PREAMBLE
>
> I haven't tried, so just asking. Does the toolchain complain if it does
> not support LSUI or is this path eliminated (due to
> cpucap_is_possible()) before being handed over to gas? It's probably
> fine but worth checking.

Yes I did with clang-19 and that's one of v14's modification:
  - https://lore.kernel.org/all/20260225182708.3225211-1-yeoreum.yun@arm.com/


--
Sincerely,
Yeoreum Yun
