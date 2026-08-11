Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011013.outbound.protection.outlook.com [52.101.70.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF6443E4A;
	Tue, 11 Aug 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786460190; cv=fail; b=ibbG4OUcV6daqPUFVChmNu322gm+cVsUvlU/l/478AxTHPLeKXiVGuR1H9z+YAnaEB2DzNEuzZAtqiugrAba6hC4R174mV+i91Q3CaTH07JNtDnIEI9xcEir/BXcNkTBa9FAGVasc0FJ/OIhiW8rgzLWS5Ekatdrer6k9Yux6lA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786460190; c=relaxed/simple;
	bh=zPw33AKaY9Db7NChyQLCNdiHrSLPnnWJPfpos1oHFFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rYqZ5HCoMI3cbC14S76cGq3Hmm0oLiLh9bMC2FACWjlqQkKmwDzzPo2Pqi4s2n0/0ujwp+dMO5IxYTSnKQhbWO3KmPc5KGTboDap8T7P3MzBCoRw8XKKxiMo+BVQ81pwPPGgfgAd+JTPVE71qNEiTIEIiQivH/xxfnhNdIc4qAE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jL9GDGJb; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jL9GDGJb; arc=fail smtp.client-ip=52.101.70.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jL9GDGJb";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jL9GDGJb"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RS6eIRjFZxxmHMR2SBsyCSFpIqg/NPbCV00JQ1El06A8MXxtQwNpPc5NvGRhyM+QRN9V+LriSlv4aUpfoiEzYfY+SCYuhZVOE4d2+NGzPwt7Nlo5kvcNlx8gDHugh+b6s8phKnhjHQUtQ2/MIGiRT+FgF2ncjY/fk0/AzhBai2e3uyFZkThaQlWSuq3RoYrS57WM517e/aK3PSD/YAsNnPdOdAh7QNsbXqtgADL0alwmoMQBebgRIe4gw/ikTeHP9V4XmyIo9S6llGy0A6rcZpCrPcZ0ubyqw7hqF4u5udbO4RYm9OULUtRbPppvwkG5DUsqbsWoNRMB7aIkpgQKYw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPw33AKaY9Db7NChyQLCNdiHrSLPnnWJPfpos1oHFFg=;
 b=iqIoRvKrW5SDBy54Nyqwk/f1prIvSpsikVaKy4MQ4KlqUY+lSsaW+SXciHm7UOjMkZOQ4EnH7jCooOQTK9TXp3VkIhYM5UJ13aAVyUhnZ+ohp780aPWf3we2e+MjRRmr435rhzrpcM8Vc1yrRhKjZ54TOKojWymfxdM3aoiGKrwLlY8eysOqDWojfqcYGtq9oJ51nuB8T2Oj3bWWRkAefRxiH0fM+0YL5Rz+9vurHgL8YMV8gZp3sGs/jBwWPrPJPsIBM5Ym39emM8DGB5Se1UoVBfwtlyR7L20SXpPoRgZvQ6e7PPyzP8dYh+NDrewmdXJgrvf1CGU5ovMGuXeKLA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPw33AKaY9Db7NChyQLCNdiHrSLPnnWJPfpos1oHFFg=;
 b=jL9GDGJbwR82+DFPkxBuCCszTVzIE2fwydBd3faNMSJOrRpQI/ZjwJBJsGFFPry6hX1j4MT7Q0d4RCzgIv68NFKJho4/T8iGBwvSmYFO3VU9O8YjITHMUJjwuyajlR6iyfxXn+h8XkBA5bxupy8aCYmvjpyOLrOfnDRq9kU8iHU=
Received: from AM0P309CA0012.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:28f::19)
 by DU0PR08MB8280.eurprd08.prod.outlook.com (2603:10a6:10:40c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 14:56:18 +0000
Received: from AMS1EPF00000093.eurprd05.prod.outlook.com
 (2603:10a6:20b:28f:cafe::9) by AM0P309CA0012.outlook.office365.com
 (2603:10a6:20b:28f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.1 via Frontend Transport; Tue, 11
 Aug 2026 14:56:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000093.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 14:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAT/Jft+UtqG8ecdMM1i7RzPgqLcoVMTvbNTeN4mufIi057YvCcBfap+C9nypeMOdOLAXFjdGKvq12G3jM13lxKg5Hs/1CA/xcnI43DELtbi8dy0StKelubkHjfbqVr64ECKLkFYnSDPusEYb/+YlX6W8jTlYi2Esvv/EuZuVcgqloH6SZ79CYpRU+e0iow0Df7jfYArYm8CtPxJvXJQFKRv9JDlhDHS7fR7zTSjCoo0iKTtrOQZ2UH97QKR2zQUmNAbvH4o0DnunD2gH8/0T++xpHgFsKvydJhdpjOylfO9efS1T9mELXiTSRwhwjGYvae2xv9S8/MOXS2vWLSV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPw33AKaY9Db7NChyQLCNdiHrSLPnnWJPfpos1oHFFg=;
 b=T73GoRerjtiaTFrmAaU+yOO+uG6X7p4VqaI7MwrxLrF8WaKhv/NEzX/kHNal/0iftjBKbG507kZydOFeR7hq0KrXsDsyIegfm1fTY7XDV/e1Yhm8LKYKRU5YwkLHKwVppwWzYa15hNz+xV8JkmlntIh3x0v3nNvcDiDCBeUrTH4HDr1I+etFX32/ESpofEqZYdT3A9RXhxxQ9vkxWcA37/guYBHETPbg+BsfKuP38mXhbWIBQHy6qHDiVN4P2GuQUOEa/vFTCRUrBZkYDIDWgDKB5GoO/Qc153+MjQFYrM2SKFEVoYTxFs177XVm1CIDD9Lk+NDeoARUZT6cp4wdUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPw33AKaY9Db7NChyQLCNdiHrSLPnnWJPfpos1oHFFg=;
 b=jL9GDGJbwR82+DFPkxBuCCszTVzIE2fwydBd3faNMSJOrRpQI/ZjwJBJsGFFPry6hX1j4MT7Q0d4RCzgIv68NFKJho4/T8iGBwvSmYFO3VU9O8YjITHMUJjwuyajlR6iyfxXn+h8XkBA5bxupy8aCYmvjpyOLrOfnDRq9kU8iHU=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU0PR08MB8812.eurprd08.prod.outlook.com (2603:10a6:10:47b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 14:55:45 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 14:55:44 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH 3/5] irqchip/gic-v5: Synchronize CPU interface disable
Thread-Topic: [PATCH 3/5] irqchip/gic-v5: Synchronize CPU interface disable
Thread-Index: AQHdKLMBZdu5TuNnZUO1ZxnHsrs547aXG+GAgAHVsIA=
Date: Tue, 11 Aug 2026 14:55:44 +0000
Message-ID: <075ce9142e30944ef6dd6e97b13d9b9763138473.camel@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
	 <20260810102652.758719-4-sascha.bischoff@arm.com>
	 <20260810105440.17CBA1F00A3A@smtp.kernel.org>
In-Reply-To: <20260810105440.17CBA1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU0PR08MB8812:EE_|AMS1EPF00000093:EE_|DU0PR08MB8280:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bea7219-a7e6-447f-5cfa-08def7b8b31d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|5023799004|11063799006|56012099006|10067099003|6133799003|3023799007|22082099003|4143699003|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 usRGQoCOiEWsdQrndt0N2vfJEcSlr+nVAXEfwRgcDczT6NDpyYzUFefNqbyWQEncvaIKOhSPBQc+TQ2MnU0nwbjzdjdohhN9GpRSihpbn6jYq9JVwPJDM9B1CfSUoomasDrUJQJL9itGe2PNHyu1oynF4Dmd9Ot3q6CNokeh27p0bbwpa6+zaHsq+zkMZa/4V+YKzG9P8IrqBZC+MdUeyw8yiSVGRuFFXsiULaM815B6FLyvYYRvueQwt+vg7qVO0YtYTRn6j2M3RE4o1Qi/02ygyNod5PhNLh6jMcGTOLctYI/K+KIknPs5QBQ0GRMK7mYSwHkONUJlKcJnr/lj8K08y6F7FyQ/mtKaAjEFlY3whEWDmiQz+gBbSeMsfuokeTG/nvKUR0kJ0e5faedcA93eEWUHDPugUuMI9W9mG2cxy/F4lc2YwzZF12wXkFpfaoyv4Lte7zB0mBGuX8eujXIG8+yUCZ6SRVL1X39t6Bla8EW6zwrT6sDQFLJb/F8OLvHTSTJuvBGPKJm/HoCaOOvbSpHq+o2nn0aC53pNPDggTmrRCnkLNtFpEnuNKs1NZdpYtIKBPWv9i4gMN1+cHL/QXcqWuZsIuN5bS9XQtAv/4DrNnXQPHf5X3McJlf2buO1KFeKlaXBcg71DHE0+S+HzpZCv54LthBRlzfBNUno=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(5023799004)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(22082099003)(4143699003)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FA4322D8F917C4D8BCB6B68C2EB88E9@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Au8AbbCYnkBahBu02MNH8mRk8o6sWeqjyK3x712vb+TvYaqm8ohxs0y83w+cwctMa1rNGwbPIFoTV2Sn+pVWWtLfyZsaMRIUa4G3bqGpUVy4/RWFEEt4z94+SFRbUhhDMUjYeP6aRtL0SAKSJn2Dae3nspPk6FC1gf06SAG8gL+l+MTNwnrH9/SR3ZNlxyr1kVmkm5/zGCSBvNDvi2ogN/ZICpnhlBiyHwjSFWuteQ5FOjkav1UgFtaKMfXWfFhPRjvW9m1mtEgns5vQOBB55Gq05kZuJqTgBdoiSfRKbr04yc6zv56lU0ChGQVz1j2EYw5XTDSxYS+9eclOqo67Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8812
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000093.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0f5f1bf4-a266-4fab-eaf2-08def7b89f12
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|23010399003|376014|1800799024|82310400026|13003099007|6133799003|4143699003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	h1rfB8DbulxAZxInasQVPL28WKL9oOnBV+JzXvb8k/P1zkSWMHNaRW2lrpmZo6nR8nBT9KAsWpobiDIO7UoAUm7RAmGnAa2gefiS2kAyU03gcmJsJYlS+8tpdtW+PZtehFyz3CL5uK1cjayQG5ezsMBV0YOQ5SpjWYttHK49ouAjA7FqKLHlTViAb5szJtHswAqxUFICNBV66CCaoc2bJq5GVPjZlQ3c/uAdpJ6TQpW2HagrhuXSjeLhRYm4Wu3WUp/fZh2UYpMbPSP/GDA0Jr+BLzzhotCYtDvp6/5r60G9R8D6G+aigAhRZGKZkbX6++1u0jdpLdm9wVYoVU51gRGAwVwWQAgUDAmbXnGw12YyzpKa8RzUhDEupxYILSLS/5YHBbzNji9qx9Xz8UKy99YDqDcZQ6sYKGo9S9uNAnOoFEt20bvnEZ0KUVxWhXAp673696RrcM5hh3ag4q8D5pqxbDXKygenqFwdpQM+Y0nUF3IwYggD4EoSbF7mr05bQe7KLMNkDvv+OGPZtNdq0RScv2LVQkV+kTPn0XiPmx+RMvQjqlWeE2CmKW1i9yXt5KcdfrWbqNgs+lRBSIwFHqTRfdrlGpVWkcISZAlJfZ2H87M51p6i/83B7GPogdXXH4m+cAhtWq3k8fMly8wOUQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(23010399003)(376014)(1800799024)(82310400026)(13003099007)(6133799003)(4143699003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dN4I5n1Az7eAgNiNdovwnQ3oVU3H+G03uC9pd86fGE+6s3sjfQFV6gsqpi+f2ls+mfYsbAz/x5uQK0z8sdBLq4E4UutFAgr2adVIZXp1o/jFGkYoPo6MtO0nVXhvzMAdtrN8Tk9AOnY2F/BeQRUf2LVvhKSQyok22EFngHkgU5WV2ibNqPFmfYuav12aPDGwBGlvkd8DMwqRxD7X+vNBhw5x03ViB3/ZlZQT/z0b84gfC1kYmWp8bk6naLr1D3OD7mjXEIYMYiaW7zhBuq2Y3pn5yLux/5MGYfcXAlyh5raYMwan9SRe+yxJDryvsxLN+ZwtjBBCwpnnCsAgi1LlCdKQHwqpOwaoz/p2s3iACpVQEV18OiE4cAm+2GpERGfKstl6jZ7aMaOQBIEONU/6jq/gK2kviDehhJ8F3JphGW6M1U/zDig5ncnHPNMM+YAU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 14:56:18.3291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bea7219-a7e6-447f-5cfa-08def7b8b31d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000093.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8280

T24gTW9uLCAyMDI2LTA4LTEwIGF0IDEwOjU0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIFRoaXMgcHJvYmxlbSB3YXNuJ3QgaW50cm9k
dWNlZCBieSB0aGlzIHBhdGNoLCBidXQgaXQgbGVhdmVzDQo+IGNyaXRpY2FsIGFyY2hpdGVjdHVy
YWwgdmlvbGF0aW9ucyB1bmFkZHJlc3NlZCBkdWUgdG8gYQ0KPiBtaXN1bmRlcnN0YW5kaW5nIG9m
IEFSTTY0IHJlcXVpcmVtZW50cyAoYXMgbm90ZWQgaW4gdGhlIGNvbW1pdA0KPiBtZXNzYWdlKS4g
TWlzc2luZyBtYW5kYXRvcnkgYGlzYigpYCBpbnN0cnVjdGlvbnMgaW1tZWRpYXRlbHkgYWZ0ZXIN
Cj4gd3JpdGluZyB0byBjb250cm9sLXBsYW5lIHN5c3RlbSByZWdpc3RlcnMgKGBJQ0NfKl9FTDFg
KS4gVGhlIEFSTTY0DQo+IGFyY2hpdGVjdHVyZSBzdWJzeXN0ZW0gZ3VpZGVsaW5lcyBtYW5kYXRl
IHRoYXQgZXZlcnkgd3JpdGUgdG8gYQ0KPiBjb250cm9sLXBsYW5lIHN5c3RlbSByZWdpc3RlciBN
VVNUIGJlIGZvbGxvd2VkIGJ5IGFuIGBpc2IoKWAgYXMgdGhlDQo+IHZlcnkgbmV4dCBpbnN0cnVj
dGlvbi4gVGhlIGBpc2IoKWAgc3luY2hyb25pemVzIHRoZSBsb2NhbCBDUFUNCj4gcGlwZWxpbmU7
IGl0IGRvZXMgbm90IHdhaXQgZm9yIGV4dGVybmFsIGludGVycnVwdCBkZWxpdmVyeS4gVGhlIHBh
dGNoDQo+IGF1dGhvciBleHBsaWNpdGx5IG9taXR0ZWQgYW4gYGlzYigpYCBhZnRlciB3cml0aW5n
IHRvDQo+IGBTWVNfSUNDX0NSMF9FTDFgIGluIGBnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMo
KWAsIGNsYWltaW5nDQo+ICdpbnRlcnJ1cHQgZGVsaXZlcnkgaXMgYXN5bmNocm9ub3VzJy4gRnVy
dGhlcm1vcmUsIHRoZXJlIGFyZQ0KPiBwcmVleGlzdGluZyB2aW9sYXRpb25zIGFjcm9zcyBtdWx0
aXBsZSBmdW5jdGlvbnMNCj4gKGBnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMoKWAsIGBnaWN2
NV9wcGlfcHJpb3JpdHlfaW5pdCgpYCwgYW5kDQo+IGB3cml0ZV9wcGlfc3lzcmVnX3MoKWApIHdo
ZXJlIHdyaXRlcyB0byBgSUNDXypfRUwxYCByZWdpc3RlcnMgYXJlDQo+IGJhdGNoZWQgd2l0aCBp
bnRlcnZlbmluZyBpbnN0cnVjdGlvbnMgYmVmb3JlIGFuIGV2ZW50dWFsIGBpc2IoKWAsIG9yDQo+
IGxhY2sgb25lIGVudGlyZWx5Lg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFszXTogW1BBVENIIDMv
NV0gaXJxY2hpcC9naWMtdjU6IFN5bmNocm9uaXplIENQVSBpbnRlcmZhY2UNCj4gZGlzYWJsZSAt
LS0NCj4gY29tbWl0IDU1YzQ0MWQ4NDVkZjg3MThjYTBhYWM3ZmYwYWI2YTRhMzUxYzE5ZGMNCj4g
QXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiBpcnFj
aGlwL2dpYy12NTogU3luY2hyb25pemUgQ1BVIGludGVyZmFjZSBkaXNhYmxlDQo+IA0KPiBUaGlz
IGNvbW1pdCBhZGRzIGEgbWlzc2luZyBJU0IgaW5zdHJ1Y3Rpb24gYWZ0ZXIgdGhlIElDQ19DUjBf
RUwxDQo+IHdyaXRlIGluDQo+IGdpY3Y1X2NwdV9kaXNhYmxlX2ludGVycnVwdHMoKSB0byBlbnN1
cmUgaW50ZXJydXB0cyBhcmUgZGlzYWJsZWQNCj4gYmVmb3JlDQo+IHRoZSBmdW5jdGlvbiByZXR1
cm5zLg0KPiANCj4gTGluazoNCj4gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYw
NzI0MTA0ODE5LjEyOTY4MDMtMS1zYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT9wYXJ0PTYNCj4gDQo+
ID4gQWRkIGFuIElTQiBhZnRlciB0aGUgSUNDX0NSMF9FTDEgd3JpdGUgdG8gZW5zdXJlIGludGVy
cnVwdHMgYXJlDQo+ID4gZGlzYWJsZWQgYmVmb3JlIHRoZSBmdW5jdGlvbiByZXR1cm5zLiBObyBj
b3JyZXNwb25kaW5nIElTQiBpcyBhZGRlZA0KPiA+IHdoZW4gZW5hYmxpbmcgdGhlIGludGVyZmFj
ZSwgYXMgaW50ZXJydXB0IGRlbGl2ZXJ5IGlzIGFzeW5jaHJvbm91cw0KPiA+IGFuZA0KPiA+IHRo
ZXJlIGlzIG5vIG9idmlvdXMgYmVuZWZpdCB0byB3YWl0aW5nIGZvciBpdC4NCj4gDQo+IFtTZXZl
cml0eTogSGlnaF0NCj4gVGhpcyBpc24ndCBhIGJ1ZyBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gs
IGJ1dCBkb2VzIG9taXR0aW5nIHRoZSBJU0INCj4gbGVhdmUgdGhlIENQVSBwaXBlbGluZSBpbiBh
biB1bmRlZmluZWQgc3RhdGU/DQoNCk5vLiBUaGlzIHJlYWxseSBpc24ndCBhbiBpc3N1ZS4NCg0K
PiANCj4gVGhlIEFSTTY0IGFyY2hpdGVjdHVyZSByZXF1aXJlcyBhbiBpc2IoKSBpbW1lZGlhdGVs
eSBhZnRlciB3cml0aW5nIHRvDQo+IGNvbnRyb2wtcGxhbmUgc3lzdGVtIHJlZ2lzdGVycyBsaWtl
IElDQ18qX0VMMSB0byBzeW5jaHJvbml6ZSB0aGUNCj4gbG9jYWwgQ1BVDQo+IHBpcGVsaW5lLCBu
b3QganVzdCB0byB3YWl0IGZvciBleHRlcm5hbCBpbnRlcnJ1cHQgZGVsaXZlcnkuDQo+IA0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jIGIvZHJpdmVycy9pcnFj
aGlwL2lycS0NCj4gPiBnaWMtdjUuYw0KPiA+IGluZGV4IGU5ZDE3OTUyMzVhNjYuLjZhOTljNTQx
YjU1OWIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYw0KPiA+
ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMNCj4gPiBAQCAtOTgzLDYgKzk4Myw3
IEBAIHN0YXRpYyB2b2lkIGdpY3Y1X2NwdV9kaXNhYmxlX2ludGVycnVwdHModm9pZCkNCj4gPiDC
oA0KPiA+IMKgCWNyMCA9IEZJRUxEX1BSRVAoSUNDX0NSMF9FTDFfRU4sIDApOw0KPiA+IMKgCXdy
aXRlX3N5c3JlZ19zKGNyMCwgU1lTX0lDQ19DUjBfRUwxKTsNCj4gPiArCWlzYigpOw0KPiA+IMKg
fQ0KPiA+IMKgDQo+ID4gwqBzdGF0aWMgdm9pZCBnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMo
dm9pZCkNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhpcyBpcyBhIHByZS1leGlzdGluZyBp
c3N1ZSwgYnV0IHNob3VsZA0KPiBnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMoKQ0KPiBhbmQg
b3RoZXIgcmVsYXRlZCBmdW5jdGlvbnMgYWxzbyBiZSB1cGRhdGVkIHRvIGluY2x1ZGUgdGhlIG1h
bmRhdG9yeQ0KPiBpc2IoKQ0KPiBpbnN0cnVjdGlvbnM/DQoNClRoZXkgYXJlIHJlYWxseSBub3Qg
bWFuZGF0b3J5Lg0KDQo+IA0KPiBGb3IgZXhhbXBsZSwgaW4gZ2ljdjVfY3B1X2VuYWJsZV9pbnRl
cnJ1cHRzKCksIHdyaXRlcyB0byByZWdpc3RlcnMNCj4gbGlrZQ0KPiBTWVNfSUNDX1BQSV9FTkFC
TEVSMF9FTDEgYW5kIFNZU19JQ0NfQ1IwX0VMMSBsYWNrIGFuIGltbWVkaWF0ZSBpc2IoKQ0KPiBh
ZnRlciBlYWNoIHdyaXRlLg0KPiANCj4gU2ltaWxhcmx5LCBhcmUgdGhlIGJhdGNoZWQgd3JpdGVz
IGluIGdpY3Y1X3BwaV9wcmlvcml0eV9pbml0KCkgYW5kDQo+IHRoZQ0KPiBzdGF0ZSB1cGRhdGVz
IGluIHdyaXRlX3BwaV9zeXNyZWdfcygpIG1pc3NpbmcgdGhlaXIgcmVxdWlyZWQgaXNiKCkNCj4g
c3luY2hyb25pemF0aW9ucyBiZWZvcmUgcmV0dXJuaW5nPyANCj4gDQo+IFBsYWNpbmcgYSByZXR1
cm4gaW5zdHJ1Y3Rpb24gb3IgaW50ZXJ2ZW5pbmcgaW5zdHJ1Y3Rpb25zIGJlZm9yZSBhbg0KPiBp
c2IoKQ0KPiBjYW4gY2F1c2UgdGhlIENQVSB0byBvYnNlcnZlIHVuZGVmaW5lZCBwaXBlbGluZSBz
dGF0ZS4NCj4gDQoNCk5vLiBXb24ndCBmaXguDQoNClRoYW5rcywNClNhc2NoYQ0KDQo=
