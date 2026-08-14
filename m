Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011059.outbound.protection.outlook.com [52.101.70.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402D414A09
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 07:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693928; cv=fail; b=t9GNZBET/fmfJirwVllu2vICkOgRT2sNRdReXQhyN6HsXGsStsCCz0m4GmieQamsnojBeR5O0i2u7y6R3mZeHAoRa5r1EX9p1hwqYibkc11cqixtFGlUP4U/Zn4JChi1g5my8aafUZSeCdvv9WMChIZ2I/ee5GyLFwART9owDhU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693928; c=relaxed/simple;
	bh=NVa/SVvl5irZFvik7wikMN7GWFdZ7khC2PMFJfBcEwA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z//eb2R9uqjiRx8MSaoTdGR48mSnMeuLQvXjDfGYnQV20yPCsUT9JJWqjVfNnmDtnXnhcuL4q1eOgd5VAWTDi5vbxMR2ovvT/LwCfV9ax9fzQ64Yv8/JnWnwTbJlWjlXiiiE3tpVZdgNz7c/B5BiD2fb8OECvCDy7UsDQrWtVE8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mIM577VK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mIM577VK; arc=fail smtp.client-ip=52.101.70.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mIM577VK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mIM577VK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GnufWaKrT4VPKpwDH0G50E1Ga6ZupsVtWDodpWA/t6c/9W7j/6D2EXOfpgiT6qwE+OQ3uA0GQLopAEjpVDSVuu+fo0Bj0AWmknHv3DdlYkNA7gU36hdyQkubzwAO0x6+dfTOyYMFuoJDfEOuO3qDH/LacKXAbrNgKPJ3VYBJKJj7QAJlJIQgIn46omkrd50CdJ7T2egVigySMcYFEnUgHMRnXcBWxjBbO0+X1viAchHiOwz8wqCZZWb22sRAIko0YW+qjlC0SVHR61Z1cFC+ZLqXSiwd3BuEI9HwGqFQNvvuXSLriiJ2wCl+KkX7JTKYx3bwLj+SjknK498OnxyohQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xK3QEnlDnwiY+1vhfWnEp9bgn1Cw9lsCgP83UuEM0s4=;
 b=Y/c3NLfQfbGKzH2rIrhyn096I0/xjxGvUZPWLOauTk/G6YUjEl10kdPTfMWSwCIqKnCL3dUIW/A4TJRT5XXKiz2h/8lv0Adzhp9DecAiY+43jUlyykkbzGt0FSvPw1gZYZ3V637CqLoEFxLaYvYFI2dyXSb/qXS7wvQFzBZIszUVndNlapXowDVYp7KIceysswtN6J462+0dlwJotw6Z18XobGEFR//bhpub9QImHl9wCbufCOf15LYW8okSGWFTEXU4BOcvoIIYvaFVkFEpEec6W2PsNe7iCUvnEJ2uZ4Ew2+MUVk9m+bcobjOgsUNP1m3EG/hvmCSgMH9WfYgj/w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xK3QEnlDnwiY+1vhfWnEp9bgn1Cw9lsCgP83UuEM0s4=;
 b=mIM577VKllZEjrraI8EBlIaO2CGS+YKrWeiH1/B7VFanuYxD2IZKcMyMGGpTrwQBJEDe8ULhLI+7BrJHpICiSJuiRP3RR+56Qr06ks+TweMz4igCJX6EUkC2GMCR+jE//Wv0nxyS5AhY3z7ULnA+TPqK1W9Ymn4cEurTusM7VO4=
Received: from AM0PR02CA0192.eurprd02.prod.outlook.com (2603:10a6:20b:28e::29)
 by PA4PR08MB7668.eurprd08.prod.outlook.com (2603:10a6:102:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 07:51:54 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:28e:cafe::9f) by AM0PR02CA0192.outlook.office365.com
 (2603:10a6:20b:28e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Fri,
 14 Aug 2026 07:51:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Fri, 14 Aug 2026 07:51:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AsoJuIBRtH66TXBciJfNOOCv5O3fV51HYLs7JSO4R03sXYfrXY+pdD/KeChh3sBowZkj7Ng8xwUq02KegUNg/Mj0y3dSji0jDPmKG8soIInEPQqMOl1i5/hNB8SREh/IF3RnJpTxm0XseJn2qqBIoMLNmg2/7fmnHxDxCib11IBevxwVFplGsKnVoo5QE8JcUONKhe7xnCyX01JMhagm5Ju0bwdjJE3L913KeQ2cJAWEIM/bKUGvDYCuhMMAOiqifZ9BbYZS+trQ+oMjg5f+pd4IAokqjqTDxn21AAbI0/jEivlaRTl57v5+K18U4vOgtBSqH9e/72VTI8fnjzdQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xK3QEnlDnwiY+1vhfWnEp9bgn1Cw9lsCgP83UuEM0s4=;
 b=uTph3P4R3NomTw58H+JyAVLnOM3taHEEG+KBy5YyNrcKYtKXAMFqGeioXmZmCBsT/kW6P0CxZf5trCvUx29rElWtsk91FEbTduNsFQmtQLNb3MFpSeUSFKkqAZqDxRAfYsv83TmgXmfz7ovkNdHOSKiKP6O5+CJMEGe8CdGdPwcDEWj3knY5DEeH2V/8Um4Eu87fMgGwhDzsr52Ktj7AqiC/+2Fl8DK2naTjhOW3LmwrhKlGTjUBLBIlZcxmO5kH0JGAFr3bXnNC8IuD9L9+bdV3pf8//vBpw3P2phBl42aY7OOdQO9F+3SrL7XY3O7a60Tw+CYXFzML0QiyLu0Oig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xK3QEnlDnwiY+1vhfWnEp9bgn1Cw9lsCgP83UuEM0s4=;
 b=mIM577VKllZEjrraI8EBlIaO2CGS+YKrWeiH1/B7VFanuYxD2IZKcMyMGGpTrwQBJEDe8ULhLI+7BrJHpICiSJuiRP3RR+56Qr06ks+TweMz4igCJX6EUkC2GMCR+jE//Wv0nxyS5AhY3z7ULnA+TPqK1W9Ymn4cEurTusM7VO4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by DB5PR08MB10046.eurprd08.prod.outlook.com (2603:10a6:10:48f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Fri, 14 Aug
 2026 07:51:20 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 07:51:19 +0000
Message-ID: <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
Date: Fri, 14 Aug 2026 09:51:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com> <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com> <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com> <an3sEiQlIuGEjUur@raptor>
 <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com> <an5UJ4S_P1LUFmzD@google.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <an5UJ4S_P1LUFmzD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0450.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::23) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|DB5PR08MB10046:EE_|AM3PEPF0000A791:EE_|PA4PR08MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: e079ea3e-5896-4f78-4cdb-08def9d8e848
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|56012099006|10067099003|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 MPIi1ubVNyVPMi4WhFrT/4qLljucmXtOLQLarEqtj4LolEad7lFnpPrl4Aotp6KxYRZ3xS/Adrfd+vOxz+v4Dw9iKLbmiXtzqCbRRUQXGQ1diiYQHesVAs8xjBvA0EKZHvXRk3jfmhvw2G2smfwU+pOuBGHGcGSrtfCiM00mj7q1xIPNIsYSdp6moWU5oVTnQI9UB+TlGoUh7DLRrKzfmMPsOf0g5/TXnC0t9x8BtklG5cbo0ySJCozHo42E2FP/Q4C+kS/3QQ9A6w/MYkfl7z5ilBPrduNsHG4E/fupVmMICjCdCy80kR988byzOZuXAAigmap4lA5ay+GnfGTZclsSeLx8gnMrevtOYDYrI/rm3KrPH8kEWfM+e6rkPdpe2b8vnwTHmEHYIYuclY9vEyX2vSmjQbA7ZejFLe+K3OVmDbyVtEzsn1zq8dDkLvwX6xQ/xjW0QECLd+hyhKvG8XDu4iEyuTrVyt4/ZHU6OkFFd0Mf1LtMGhxRAPkAkHmPv8NRWg/sBZcm/MA3QcLNndcWn8vS2wRE/nMr55Pn8kszC3a90iyVCrhWSUnTFM7aOHwTbc4tljxs0uS4AmrpAQ6MQD/UTBAQ357DhUIgHTW2H1mWdEWEVhs9XINA/Xue+JgSBO75WffhPm7C5tJ7bEVMF7IfwcYBwGFkHKgN854=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 S36bHT0W8b0dgPgVgLbIS7w0yhBUaRgh58VA+5dGXcGF3mD5DPIXapFnecahWnrSdzwFxYhefpnXQDVoghDiY1nJWmKT4SIAz3L6YOYbIvCihTgyWYwLZ1VFeJ3ytG39gxbjK0Xq4E3mJ+66mAQiDC595MPcENFfIUszBus+/4HYjYhC2/xkIZIgAyoNBl/ueEb/HVoEzgxhxb4JiRgU9ngt6ylzH9NLaKybOym3PNz39jpkwouNhGLhsS6Pr+LBTs7I33Lzo6F4FZWjosR1TZsWzBwaAY6p7A4NcwDx5XHRzTgqSWOFQhOjlR1VL6p/YXfkJ3lkuNBvZcUS49vvvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10046
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1e906365-70e9-4a58-b503-08def9d8d3cc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|30052699003|7416014|376014|36860700016|23010399003|14060799003|35042699022|82310400026|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	+Bl02aYqEccxSXv8ZNhjg8NLLJroo8XYQRT8HfNIDMBHEbz7W2uUqUv6hONAH/IQcxc6wskZYIqlxkiu9/uhObBCAoA1dOYah8kik8elqwq9ccfrVFggRyjHHVPfPtpfaFyQ0uWAVzDK0QaQOokLfWOemtjzl28KiQirYJH/UgtOYpAt1B6Uv53zqfAF5vBiH61TH66OH7YNhsdljhLkcf25+x3ssQPSltLiWbJcsJzEM82wGHcG4GUXg2QpueQMuuWCmw3cCAvKWth1arzpEjRLfOSLoS4QVmNcZ3D3eBA/SX6VoqpHCRRF85qw+ajWVO46eejLWg3VXFlY8eh4PWuHLkNHzwsIIxJUxnFGmCOzvhWG5fRp+EP+7gSbq4ra4MAOaP1mGB4IIqxA6sEb3fcHh6b99NPUHhXHSjnlkWkuXYgSm71qhbVXBiU9kYlQBAurZiinte9eqZ0m5T12d9s91o5iVKJIhn7xTGWhKFe6CakGwP1faduhFxhxpqrQ6Zlrm4SP1tDFlX9DjXMmKZ2xxjFeNErCXPWArEHTC8mY1YWtomAgw5TZ0Noj2JO5vromF1dH5gY3KnODQL6ZSTDrGMOblD/H33PS3EKJE7/6UDZehCcSSJ9ECQ8t+ukShHn2yLcWDk6JNuzsvOVExFBJaKUwhVfANP/CqjWztw/0yDhK6tUL3dkiq+wjB8E243pUBtjAbDuh7Gvr/xf6rA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(30052699003)(7416014)(376014)(36860700016)(23010399003)(14060799003)(35042699022)(82310400026)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y5voQb2wXAmb025eqAK1tC8Jg15oNuOJ8LcB6mUV66tqP7YNjcZBTjT742oSJeX7ozABKgbRGgmNNyEFqXgE1Cay59QTbC1xqQDfdzmZnwjpt109yDgNd71t9+T60/1nU/reqO/PETyTfEo+Vlhf8UjokpIAB51+Ug8N4sp9ubB5BHZ4jUBgWysI8w1rxmY7LqrdRIUlTg0ddANq8KDLuKqgF3fs4IFIQIiL9OkrmexbZtaJDuBDF3Tysufrf72pgl5xeX0NEB1a5is1D4H++WCEF+vCiJM9AAM7BcF6WiCPGeD7LnaVyFGRwCIqeiu3Mg5ZDo/2noNCmeMwmah1vwSmnFOOwMXgyZDL+NdHE0j9hS4IgRjwhRrDZcwny9H/h66AyANRLRrbJZl5DBSnbMsTeZcs4b0Du1cOYBSvCwGX9AxdgFzme3AzrrzWWqkk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 07:51:53.7489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e079ea3e-5896-4f78-4cdb-08def9d8e848
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7668

On 8/14/26 01:32, Sean Christopherson wrote:
> On Thu, Aug 13, 2026, David Hildenbrand wrote:
>> On 8/13/26 18:09, Alexandru Elisei wrote:
>>>
>>> There's already a proposal for how to do this in the migratable guest_memfd
>>> series [1] - it's a new guest_memfd creation flag that disables migration.
>>
>> In the guest_memfd call I was arguing against the flag in the first version, and
>> instead adding it when actually required.
> 
> Ya, right now a flag is meaningless.  Telling guest_memfd not to do something it
> doesn't ever do...

Right.

>>>
>>> I'm a slightly concerned though that all of this will work by chance, and
>>> not by design, and in the future the behaviour might change to allow
>>> guest_memfd memory to be unmapped from stage 2 without the VMM or KVM
>>> explicitly allowing it or initiating it.
> 
> Meh, TDX on x86 already has the same requirement.  Unmapping a page from the S-EPT
> kills the VM unless the VM was expecting the page to be lost. 

Right.

> 
>> Thus my idea of the explicit contract between KVM and guest_memfd. Instead of
>> being a "this doesn't support migration" it would be a "S2 always mapped"
>> kind-of contract.
> 
> Who would that contract be between though?  KVM can tell a guest_memfd instance
> that page migration is/isn't supported, but telling guest_memfd that the VM will
> always keep the entirety of the guest_memfd mapped in stage-2 is nonsensical.
> guest_memfd simply doesn't care if the page is mapped or not, it only cares if
> migration is supported.

I think there are more details to this. Let me try to express what my mind was
up to last night.

We have a hardware feature that requires pages to always be mapped into S2. Some
things I had in mind:

1) Page migration would not be a problem as long as hardware could be paused
   while migrating (e.g., kick all vCPUs). I doubt someone would implement that
   right now,  but you could consider it an implementation detail that page
   migration cannot be supported right now.

2) Newer hardware could mitigate this problem, allowing the feature to support
   pages temporarily being unmapped from S2.

3) Disallowing page migration is really just one implication of "pages must
   always be mapped into S2".

So what we really want is "if feature X is enabled and hardware requires it,
always keep pages mapped into S2, which currently implies that page migration
cannot be supported."

Which isn't all that different to "if a confidential VM is run on current TDX
hardware, always keep pages mapped into S2, which currently implies that page
migration cannot be supported."

So I was wondering whether the flow could be:

User space enabled CPU feature for VM -> KVM knows that current hardware
requires for that CPU feature to have S2 always mapped -> KVM tells guest_memfd
that S2 must be always mapped / disables page migration.

That would be in contrast to user space having to guess that page migration on
the current hardware with the current guest_memfd implementation does not
support page migration, to then disable exactly that.

Does that explanation makes sense? I don't know the exact mechanism to do that,
but that's just my high-level thinking.

> 
>>> My understanding from the conversation so far is that the plan for the
>>> future of guest_memfd is to support an option/mode where the memory is
>>> effectively "pinned" at stage 2 (but which allows userspace to explicitly
>>> free/unmap it, of course). Is that correct, or am I being overly optimistic
>>> in my interpretation?
>>
>> We could then even disallow fallocate() to punch holes if that contract is
>> negotiated.
> 
> Why?  If userspace pulls a stupid and kills its guest, that's userspace's problem.

It was late, agreed. Unplugging memory would just work, so that's not a concern.
It's a userspace's problem.

> 
> KVM would also have to block memslot changes, and probably other things in the
> future that would unmap stage-2 in response to userspace syscalls/ioctls.


-- 
Cheers,

David
