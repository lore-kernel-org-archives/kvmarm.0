Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9C42DF120
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760007592; cv=fail; b=VIQtmAv5yyEMIZ3+Avrrj1cAo2/Bf6se9pG8zF6Es6gGpOwtmCjMacarAXEA3vpFI1PQG1vsZra0pQi4OWAqwrqR1IinN0yLsjyV6lzMck1jytKYBfevrsgf+w9KSSpEhcwkzU3Cm+02+4ckvsLdIfeehZfL9sEweTO9z1cyUSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760007592; c=relaxed/simple;
	bh=rs8kBOc10yapnDXE6v/KfIk5hVBpNJs1TfMHop5sKJ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B0soEKf6EZnwV0MZHn0mzOTYVAb1bGMAymlQ5TbNp27JDmHXX6KhFUmNOIAfejs90Td0eDUNMh6Fq0clYriw46fINU1jP1mR7yIO0dcCKtL5EyVlEBzQbET4X7t/BQXGvR7ZcuVF5ne86j9k3MvO6f1lQd/uXYxz1uDPL2E/Ivw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=meCs+KNM; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=QytSWD3t; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="meCs+KNM";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="QytSWD3t"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5997prDx020455;
	Thu, 9 Oct 2025 03:59:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=rs8kBOc10yapnDXE6v/KfIk5hVBpNJs1TfMHop5sKJ4=; b=m
	eCs+KNM9Dlh6x+R22YOFi5AUlufSFxKSj5ggfGrHtE/KqzFgkzqKS7c3wmgx6gw+
	X9Rpb2Sx9Tvb/sTwTaIPeMCI+lGlnqJ3JwNAmw72Yllsc1dwjlZiSYfQ8ka0SBxv
	XB/JuWgodaE5Vg9coMI9Y5k6jDcaxy03FDOBa/0P+w0h1qQ8O7xAqPqkyEMabDo/
	GY9YiWGlBbDQitc7bZMy5vzOtBocglq06QzOC9kJ9cUn3sL9mRupWTh96o1HVspd
	e/kRfFOsyLgPYbPkqGIOBbrbqloCL6rQmsConI+NWAbmmw7c1IaZh2An1YrhmlwU
	vC9CidahbiaPtOl6SCKWQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022087.outbound.protection.outlook.com [40.93.195.87])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv5yv34x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 03:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBWEeM2lF3870Gw/0ETN9xSssxb/eLEGR2AeDiDV484r6o/AmZ9cGGjNh1k+Tf5BEAl6mJzgK6K6qowrx2hm+HZB16rzJwDoFZkOyz4sPvEjwA6cSEvfimMAhhjApbmM66U4pPDSHOWaY7Hx9Omy/WtCh2Blk4PqFQRbZtYgblxkkBurHvl0hsoDcd36/jUB6y2S8axJ/Zs2t/hyAYK/ycyIgp2wNdL6mfnFPTy2DlGGX4O7u0t4Ln1ZTqGmsmGu2eVXPmtzEPHI2aUjMPufeozx1yMNVbj6UMgeOvbSXMnurM399J0ySpnBXh/J7Ht0McEUTGacl6QNMZx0MLudPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rs8kBOc10yapnDXE6v/KfIk5hVBpNJs1TfMHop5sKJ4=;
 b=U4PGN9cru9nnYD/urk26XtRofXpId86uhq6SdU1ymCD8kfatQ+jhUTd6GilBiGqVu2tJ6t98Uf6szp30EkQbt3O+NGko2MFyV7l7Mh9gWohWV544bHwRDwrZIG/ubZeeCMx7dO2A0+YYzTcgsSk/w6d9zgtRDXkOZavF8eniV5ARF5yzPtPU8tx2cWUUqqQbnxQLR/E7HV/0zJGhndBmDO52P8qZtb6elqcincyc7hezM64BBwYNgBgrla27Oymb2ACyzxgGJXiZuXzIVxTGQm7x88CHa6ja4wQkNdGGSRyxpBCayfcSATpApaNoxnOIE9ensEkdqSEkdBgnxlTIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs8kBOc10yapnDXE6v/KfIk5hVBpNJs1TfMHop5sKJ4=;
 b=QytSWD3tepdYpLb4q1qJDE6zOXz7A9L+ZBNBqx6xQqsbx1Hy5O90oQLVDLp3kwD4Y35eS9MaWcoznEHJbvF2znx1c5her2rPc/aywKdMbeFEKp4SyJRCfDtCvI26edbuEm7zLrN8sx5eriB34bFHr7iYeLfwclZAx9wt59stgyE=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by CH3PPF24649D10F.namprd07.prod.outlook.com (2603:10b6:61f:fc00::218) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 10:59:34 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 10:59:34 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsAgAAP94CAACEnAIAABOgAgAAlOYCAAB0sAIAAG7mAgAFI0QA=
Date: Thu, 9 Oct 2025 10:59:34 +0000
Message-ID: <43EAA28F-4053-430B-883F-FE826D8360D0@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
 <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
 <E2FD1CD0-AE1F-4F9C-86FF-D576C212832B@global.cadence.com>
 <864is9zqs9.wl-maz@kernel.org>
 <677A529C-B3D7-4BD1-BEED-D8414D961BBD@global.cadence.com>
 <86zfa1y58i.wl-maz@kernel.org>
 <15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com>
 <86y0plxvt4.wl-maz@kernel.org>
In-Reply-To: <86y0plxvt4.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|CH3PPF24649D10F:EE_
x-ms-office365-filtering-correlation-id: d684ce76-2a28-4e05-4f57-08de0722eeab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MU8rLzZsazFYeTBKWXZTQzRQL0lxUkRnNzRNeTgxbFFENW96bWQ0ald6VXFa?=
 =?utf-8?B?dHhIZVlNdFN3S0Rsd1J2SXByY0NmQkxlakVvTlNNbzBIUk1YMlE0VG1FalhW?=
 =?utf-8?B?cXZta0JrQkQzZ2RhSSsrMmM1YUdteVBYdmlxUU81c1VTeXRVc0gwUVVhVmQw?=
 =?utf-8?B?WUMwbWZrVnRFRElRSEFMdkpSU0lWaWNtQjhDbHNnM3picDZFOWR2TmEra01I?=
 =?utf-8?B?WDBTTVhBNlh3clo1bWxuWkt1RjFaWk8rVUFscHk3QnMvbUJqbVRDdnJ4bVl5?=
 =?utf-8?B?akVXRmdLQUMra1lWdEdMNFBzYnd0VklpdXBBRnMzYXFRYTBBZ2Y2OXU4akRT?=
 =?utf-8?B?OTUyQml0Y1Z4T1VJQjNGb1NSa3U5RFZJZjFKZG5ldTB0cDRvWmZydzhNUEpV?=
 =?utf-8?B?UWJkcHZtZCtXT2tyMVJGTW1DUlhWTCtyWjJqeFRGWk8zUUVTWHBqeDE4Z21H?=
 =?utf-8?B?SHdmSFB4SWszZ0U0SDBSSEV5TmZtUURMaG0xb0FSWXVSc3dwckJ6eS9FL1lo?=
 =?utf-8?B?elB0MGptUlhnRnhGL1cyZ1A5UjNST2xDd2JyRklJM2FIeHp5SGs4amt0L3J0?=
 =?utf-8?B?N01iTUQrNTBLbEYrWDBmYkZGZGlMTmlsdGVyaS9UT0Y0Und6Zk03bERVK2pF?=
 =?utf-8?B?SkZ2WG5tMnpDQU15WEFRTkdHVWdHOVhIbkdKeGNyR2JiZ3ZOYVE2d21tTWpl?=
 =?utf-8?B?elU5Z3k2RkhPSkpEK0dJdG51UytVdUM3S2c3NTJ4Rjk1RGQ4Wm16L3NNL0pK?=
 =?utf-8?B?U3diZ2puc0NIR2V2emdLQVlSeEpnTFFFZVFaQWlBL3g3TzlHRWVOY05pT29i?=
 =?utf-8?B?S3Y1bkFlMVRwQ2FscDhqVnNKZUNaZWN2b1pYZXl0a1dFNzF0TGpuc1dpTjB3?=
 =?utf-8?B?NlpuK1JuRE12MmROZ1ZCWDdaVXhtYldNTUVGUlFsOHM1S3BoRWR5bU9zQTlD?=
 =?utf-8?B?ZGpMeU1kUmN6dUtzOEd6ano5c0J1Q3A2TmZiRlVicnJTZThOZlJLb3l4bFB4?=
 =?utf-8?B?bXo5VEpxdTNhdzVFZHhoMHYvQmVDTklQZ1BseFRaeE03K3BoQUJLelRUL2RW?=
 =?utf-8?B?ZE41ZDZYdU84b2JhQmt3NU9jYzByY0JyY3ZiM2JPb1c2dFJGa2VQaTJobGIr?=
 =?utf-8?B?QWZoMzZST3hyazdic0p3bnl2ZkRSbjhubllaVDc1eThQVzQreTZTN3FocURX?=
 =?utf-8?B?MmxtakI2NEQwc0ZHUXZpTUhTVzM5V3lUVlZzaXpFb1VUUjhjaGFrNWJSTE8z?=
 =?utf-8?B?ZmpvdEp5NTdjZkVlTVRIMXVVSUIvNnY2R3I5b21yNUxiL1FDQ1BOazQzcTVR?=
 =?utf-8?B?b0dlUHJ6NXZpb3ZLbUEwY0cxOWNkSmhCRFA1cUdyMDBGWjcvRnVWT0g1VGlI?=
 =?utf-8?B?QnlmWmNzTE1QMlhvRUo1b2ZPRnZyS3NSWjRnTzFsYTUwS3RmK0dXQk94VjJC?=
 =?utf-8?B?MEUvT293OHdiZWp3TW4wc2ZwUzlSY21JdEwyMEdiOVgwWFRweHdLR0lnYlht?=
 =?utf-8?B?dlVmanB2cG9qNlZOZDFFci9oWnFKaFpFdVhZVXhKOXNBSHcrQ3VvS2VEaVVt?=
 =?utf-8?B?YlFFVUt1UWZsYTl4Mjgvbis0Q1FGMHAzMWpoK0lQSkpvN0ZMeFFHUWJwcFZw?=
 =?utf-8?B?MUJVOFNhdXNNQjVIVG5xWU9kODBFV0R0T0lRQUtnZVYyWkZkUkxNREhzZ2k3?=
 =?utf-8?B?TVUxeDl3N1RObWVOVWp2NUs3Q2g1dG9tMm5nYjR3Y1NsRXVUK0NyQzgvSk9k?=
 =?utf-8?B?eWQ4akszRzBTYUZWZG9McWVHM3dEa3dFTllMRnZoZzFFNkJ3aFZ1S2RKbzVn?=
 =?utf-8?B?cXBLaXVmMStVb1dGWlViSGFpaG9IMm01Z3dsU1FzNG0yam00UkJlNzVUZk5M?=
 =?utf-8?B?blZFTVFIUW9pUjRRU21ON2hhM3dWbGZPWWtJN25rcm5HTmplT2htb2hCWk1Q?=
 =?utf-8?B?bWxpY3h4QlRRbHBpRGNoVDdYTzJ5aTBwSHBFVXVsQ3JjYS92RTZTMVhqTnFQ?=
 =?utf-8?B?Sm12N05LOEhNRVQzNWFpQVJMbkpjd2NodEg3SDQrekl0UUJ2Q2lMeEFaQ2tt?=
 =?utf-8?Q?6UB/km?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zlp4QzdySmdUR1NhREsyczBwa083dDFGbzVtZWtROXNzazY1anBnTVZqMitl?=
 =?utf-8?B?bGlLdVRPZTc0c1dPNUJhUm9uWFlIU2VFY0VIdC9qY2dlZVM5Z1dwazltVmVU?=
 =?utf-8?B?cFZSMUx4WjVCVXlrQUsvNDJpak9lMGlpamhBdkNXY3ozTkttNnBTemlEV1lT?=
 =?utf-8?B?ekRMV1JxZmNZRzJrMFVFVDJrU0l6bkpRdDlGVXdUOWNXZEFjRko0VzhoMUd2?=
 =?utf-8?B?YTFueVJQRUF6b0Y5SXQ5a3RpNzVwd0pCL3hWVGRla0oybm5HREVjdWY5RWFR?=
 =?utf-8?B?QXM2RHUzcnJDOHVVcjA2OXVlVlRNenBOVVVXSDNORkdrRWtjb3BsZGpVYlEz?=
 =?utf-8?B?WjVDS0Jmd3pYOHBQTzkyaEVtazl5b05lRTJJSG5NdTNvTUtjMG1URFNQOSty?=
 =?utf-8?B?OXN2Qjd4emUvb1BiNjZadkhaV2VQYmxZaEJWUlRuQlVpZmxBcTRPNngvV3J5?=
 =?utf-8?B?a05TOUY5YmV3N0JkQllCQUdKSWtSdjlXRlJQQzhBVlovMEg4cFBkQ1hLVlJY?=
 =?utf-8?B?SCtVR3JnWlU0VGpBeDA5NnpHejJBbTB4ZkJQVkh5WFNMQXZFOGNSaW0rUWJ6?=
 =?utf-8?B?ZE1xR3BuS0VJbE1NSWJkU3V2RGFUSVVJSHhmVXQ4bU1LM2lVVU9BNElpRWow?=
 =?utf-8?B?REFuS0dxSHhEREtDWUNkcE5iM2k4MWg4SlRsa0xWc2xnenhYZlVUKzJVdURU?=
 =?utf-8?B?MCtPNW5EM2pxMFpiSUM4OURKR1hBeG5jMzBxSStScDFEaWF3UWI1QnJkeGFE?=
 =?utf-8?B?b3IyQnFxSWl6UDhvZG5icHhTQWh3dDd6U2IzNVBoNnRLTTZYa0tJU3NKYzda?=
 =?utf-8?B?K3N5VUN4SWZaeHRaN3F6a0hneERGbkhuYWdSaGY2NkV5d3NnSDB3QkFtTElC?=
 =?utf-8?B?YUVvb1RWV3hhdC9hcm5oNFZSOUZBZ1dmd3JHcWJCZExiOXBCUXFneXJXMzY1?=
 =?utf-8?B?WkxqNDBIV003WXVWZm84WUdKZWJtelY2MEpISmx4N2FFcVlhTlN6L2R0aFVx?=
 =?utf-8?B?V1NCVXhCK2daWVFwd3pqSWpkMHRmQkpsb0VTa2ZROTdmWjV5WDRFb014Zk54?=
 =?utf-8?B?TlVOQmFKejdGSkY3WDdZR08xNDRGdWhncHdFUTlyYzFmUWpsTzRSUFJKOGpZ?=
 =?utf-8?B?bnhsNTZaWDhUVmxBMEN5czdkdmNnQXgvbGJIVUE2UnVRL0EwTkdNSXo1aHhh?=
 =?utf-8?B?Q2o0OWRWNVZSK05zSEI4T0lOVEhvdzNKTWljaTJTZldSYUZRczZQRWVsZzY5?=
 =?utf-8?B?YlVkaUJsRzM4Q3kzbmMzbUNkWklPUVdCRnhlem5KTlRiT3pqaUN4T21oT2Vj?=
 =?utf-8?B?VkhuT09sSVh0Ky81VHpnVllXUlI4bmdFYm1qOEJQTnBQVFlpSG1DZzVJOGZV?=
 =?utf-8?B?aTAzZ0FjbnI4MVNPRlYxeGFFbWdYMUYvUlZNT09ZUmwvZVBzSkZPSUUzcVRL?=
 =?utf-8?B?QUczWFdYaGtnbkpSUDlVek9Hdk9jc29UMXE0ME93OHZON1BWcG51SEZsdStU?=
 =?utf-8?B?aEsxeGRON3JJWDRHQXRXUW9vaC9LRWJ6ZXVOMU5OQjF5bDFtc2xWUytPaktz?=
 =?utf-8?B?cGZvZzBKOVdtZjVaV2xvekQxR01RMkhlWElhOWkvSVNGUXhwaXUzZFRGNy9h?=
 =?utf-8?B?a28ra2xNWVNvNzNabFNWRFM5TUd2ZGwxcnZPcU9oaTVRNHpNZ3Zid2JxOUI3?=
 =?utf-8?B?ZXc1RlEwMDB4R01WNE9rZGFjb21GNmxuT1RpYU03NVpVZERWRStqSFVRcnpM?=
 =?utf-8?B?VzNhemtVRXlsdDNScGlhMG9TMlRPbE9CWjBNQUdjZlBCTzFaZ0JHaXBBRmt5?=
 =?utf-8?B?aHhud012ODN1MElOUjhUQ3F0YytXWDJOR0w2K3pzZzZocWttZlowS3pUVnM0?=
 =?utf-8?B?azA5b2tmeHphVWovTzRQS090WXVXUGpxdDBtVmlPZjFQOWV2NWtQelA1eHVH?=
 =?utf-8?B?Mnp3WnlWK0x3eHhQQjdNd3BxRVdCNWFGMkE2dnJOejI1d0FGUEQwQUpHS2Nq?=
 =?utf-8?B?OEtmcFdQYjFPaXFMaTJEWjVyZUVVU1pVaFhidTgyazQ5aGk4ZTlqbHlXK1RD?=
 =?utf-8?B?S1EwaHdhcmRKZkFKcHFnZDEzaUVrdnpqSitBUDVNQ3Baei9TWGpUdytXcG9F?=
 =?utf-8?B?a3FaVW1sQlFhNXdwRHI5c013K2l1ZFRJZURxNVdTWWlZNGZJcUk2WGo4NWNS?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDCA37044F0AD3468267B103B30E7BE3@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d684ce76-2a28-4e05-4f57-08de0722eeab
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 10:59:34.7196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAT1g4vLCHJ2Z8W4ysXyqY1V9bDWtlFMtcfG04Lcwsd/Jrqu4/tfNfeikLkGyKxvdPGjnQ/MKskuBPp6LJ6P9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PPF24649D10F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX5ad3p+U2hQki
 N62y3ZKF0KeTOgn2KpJhJ9HHfpZ33hDKGjpV7CUypUqadpTsW8Unc6TYDizz0T8DsrlH1UbuqZQ
 J74QeSZ4auJvPl4P6jI9kShI3xbe/R9mZ62I4M43GhdKo3/szbOoDyWNe6b7T9DDIXumR1mXyJk
 Zagl3hbWF4SMHjQyUfdDCzHwtsBSDEeFUVKMQrpE9QGFlXUhqIWx6tW0vBoQdvem3+YLP2cFBBL
 sqyEd8Edu880gZ/2oWG4yddAuhr280g/0m4Ki2yGRZl4K9MNXkdInPF8jWTAYT/8AmwdCj2ZbNs
 W7Yc/+arPzNpHOu/F16iR9SJ5tw2DS76Pq3zav0NzY1S28sbzQI7x6YYno56liReAlSrwjkaCwb
 ZD4Zzd2ZFY1VY48hCpLW45KM/3A46g==
X-Authority-Analysis: v=2.4 cv=VuQuwu2n c=1 sm=1 tr=0 ts=68e79599 cx=c_pps
 a=7r/ioy5s1gfMry3CYkvllQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=ySm53CCfjCCpF66Xbj8A:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
X-Proofpoint-ORIG-GUID: 44I8WtO8cZ40MN7wLZsyOALzLLSGmVcf
X-Proofpoint-GUID: 44I8WtO8cZ40MN7wLZsyOALzLLSGmVcf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

DQoNCj4gT24gOCBPY3QgMjAyNSwgYXQgMTc6MjIsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOg0KPiANCj4gRVhURVJOQUwgTUFJTA0KPiANCj4gDQo+IE9uIFdlZCwgMDggT2N0
IDIwMjUgMTQ6NDM6MjkgKzAxMDAsDQo+IEphbiBLb3RhcyA8amFua0BjYWRlbmNlLmNvbT4gd3Jv
dGU6DQo+Pj4+IA0KPj4+PiBJcyBpdCBwb3NzaWJsZSB0byB0cmFwL2VtdWxhdGUgSENSX0VMMiwg
YW5kIG1ha2Ugc3VyZSBFMkggaXMgYWx3YXlzIDEsDQo+Pj4+IGluIGNhc2VzIHdoZW4gb25seSBL
Vk1fQVJNX1ZDUFVfSEFTX0VMMiBpcyBzZXQ/DQo+Pj4+IFdvdWxkIHRoYXQgaGVscD8NCj4+PiAN
Cj4+PiBUaGVyZSBhcmUgbm8gdHJhcHMgZm9yIEhDUl9FTDIuDQo+Pj4gDQo+Pj4+IEFzIGEgdGVz
dCwgSSB0cmllZCBmb3JjaW5nIHRoaXMgYml0IGJlZm9yZSBydW5uaW5nIFZDUFVzLCBidXQNCj4+
Pj4gcmVhZGluZyBpdCB2aWEgTVJTIGdvdCBhIHZhbHVlIHdpdGhvdXQgaXQgYmVpbmcgc2V0Lg0K
Pj4+IA0KPj4+IFdoZXJlIGRpZCB5b3UgcmVhZCB0aGF0IGZyb20/DQo+PiANCj4+IEkgY2hlY2tl
ZCB0aGUgWDEgcmVnaXN0ZXIsIGFmdGVyOiBtcnMgeDEsIGhjcl9lbDIgaW4gX19jaGVja19odmhl
Lg0KPiANCj4gVGhhdCdzIHRvbyBsYXRlLiBBdCB0aGlzIHBvaW50LCB0aGUgd3JpdGUgdG8gSENS
X0VMMiB3aWxsIGhhdmUgYWxyZWFkeQ0KPiBvY2N1cnJlZCwNCg0KSSBzZWUsIHRoYW5rcy4NCg0K
Pj4gDQo+PiANCj4+PiBJZiB5b3UgYXBwbHkgdGhlIGZvbGxvd2luZyBjaGFuZ2UgdG8geW91ciBn
dWVzdCwgZG9lcyBpdCBzdGFydA0KPj4+IGJlaGF2aW5nPw0KPj4+IA0KPj4+IE0uDQo+Pj4gDQo+
Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vZWwyX3NldHVwLmggYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2VsMl9zZXR1cC5oDQo+Pj4gaW5kZXggNDYwMzMwMjc1MTBjYy4u
MzkyYzlmNDAxNmYyZSAxMDA2NDQNCj4+PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2Vs
Ml9zZXR1cC5oDQo+Pj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9lbDJfc2V0dXAuaA0K
Pj4+IEBAIC0zNCw3ICszNCw3IEBADQo+Pj4gbXJzX3MgeDEsIFNZU19JRF9BQTY0TU1GUjRfRUwx
DQo+Pj4gc2JmeCB4MSwgeDEsICNJRF9BQTY0TU1GUjRfRUwxX0UySDBfU0hJRlQsICNJRF9BQTY0
TU1GUjRfRUwxX0UySDBfV0lEVEgNCj4+PiBjbXAgeDEsICMwDQo+Pj4gLSBiLmdlIC5MblZIRV9c
QA0KPj4+ICsvLyBiLmdlIC5MblZIRV9cQA0KPj4+IA0KPj4+IG9yciB4MCwgeDAsICNIQ1JfRTJI
DQo+Pj4gLkxuVkhFX1xAOg0KPj4+IA0KPj4gDQo+PiBXaXRoIHRoaXMgY2hhbmdlIEd1ZXN0IE9T
IHN0YXJ0cyB0aGUgYm9vdCBwcm9jZXNzLg0KPj4gDQo+PiBbIDAuMDAwMDAwXSBDUFUgZmVhdHVy
ZXM6IGRldGVjdGVkOiBWaXJ0dWFsaXphdGlvbiBIb3N0IEV4dGVuc2lvbnMNCj4+IFsgNi45OTg2
OTZdIFNNUDogVG90YWwgb2YgNCBwcm9jZXNzb3JzIGFjdGl2YXRlZC4NCj4+IFsgNy4yNTcwNDVd
IENQVTogQWxsIENQVShzKSBzdGFydGVkIGF0IEVMMg0KPj4gWyAxODUuNzgxMDYyXSBTVkU6IG1h
eGltdW0gYXZhaWxhYmxlIHZlY3RvciBsZW5ndGggMTYgYnl0ZXMgcGVyIHZlY3Rvcg0KPj4gWyAx
ODYuMTA0MTU5XSBTVkU6IGRlZmF1bHQgdmVjdG9yIGxlbmd0aCAxNiBieXRlcyBwZXIgdmVjdG9y
DQo+IA0KPiBHcmVhdC4gVGhhdCBjb25maXJtcyBteSBzdXNwaWNpb24gdGhhdCB3ZSBjYW5ub3Qg
YWR2ZXJ0aXNlIFZIRSBvbiBDUFVzDQo+IHRoYXQgZG8gbm90IGhhdmUgRkVBVF9GR1QuIE9oIHdl
bGwuIEknbGwgcG9zdCBhIHBhdGNoIHRvIGZvcmJpZCBWSEUNCj4gZ3Vlc3RzIG9uIHRoZXNlIG1h
Y2hpbmVzLg0KT0suIE1ha2VzIHNlbnNlLiBJ4oCZbGwgdGVzdCB0aGUgcGF0Y2ggb25jZSBpdOKA
mXMgcG9zdGVkLg0KDQo+IA0KPj4gSSBhbHNvIG9ic2VydmVkIHNvbWV0aGluZyBpbnRlcmVzdGlu
Zy4NCj4+IFdoZW4gUFNDSSBtZXRob2QgaXMgc2V0IHRvIEhWQywgSSBnZXQgYSBrZXJuZWwgcGFu
aWMuDQo+PiBUaGlzIHdhc27igJl0IGEgcHJvYmxlbSBpbiBhbGwgb3RoZXIgdGVzdCBjYXNlcy4N
Cj4gDQo+IFdlbGwsIHRoYXQncyBjb21wbGV0ZWx5IGV4cGVjdGVkLiBIVkMgaXMgaGFuZGxlZCBi
eSBFTDIuIFlvdSBydW4gYXQNCj4gRUwyLiBZb3UgZW5kLXVwIGNhbGxpbmcgeW91cnNlbGYsIHdo
aWNoIHlvdSBkb24ndCByZWFsbHkgZXhwZWN0Lg0KPiANCj4gU01DIGlzIHRoZSB3YXkgZm9yIEVM
MiBndWVzdHMsIGFzIGlmIHRoZXkgd2VyZSBvbiBiYXJlLW1ldGFsLg0KPiANCj4+IE9uIGEgc2lk
ZSBub3RlLCB0aGFuayB5b3UgZm9yIGdpdmluZyBtZSBzb21lIHBvaW50ZXJzLg0KPj4gV2l0aCBI
QVNfRUwyX0UySCB0aGUgb3JpZ2luYWwgR3Vlc3QgT1MgYm9vdHMgZmluZSBpbiBuVkhFLg0KPj4g
DQo+PiBbICAgIDAuMjA0NzQ0XSBDUFU6IEFsbCBDUFUocykgc3RhcnRlZCBhdCBFTDINCj4+IFsg
ICAxOC40ODM3MzddIFNWRTogbWF4aW11bSBhdmFpbGFibGUgdmVjdG9yIGxlbmd0aCAxNiBieXRl
cyBwZXIgdmVjdG9yDQo+PiBbICAgMTguNTAwOTU5XSBTVkU6IGRlZmF1bHQgdmVjdG9yIGxlbmd0
aCAxNiBieXRlcyBwZXIgdmVjdG9yDQo+PiBbICAgMjUuOTk5NDc1XSBrdm0gWzFdOiBIeXAgblZI
RSBtb2RlIGluaXRpYWxpemVkIHN1Y2Nlc3NmdWxseQ0KPiANCj4gWXVwLiBJJ2xsIGtpbGwgdGhl
IGFiaWxpdHkgdG8gcnVuIFZIRSBndWVzdHMgb24gY3JhcHB5IG9sZCBIVyB0aGVuLg0KPiANCj4g
VGhhbmtzIGZvciBnaXZpbmcgaXQgYSBnbyENCj4gDQo+IE0uDQoNClRoYW5rIHlvdSBmb3IgdGhl
c2UgaXNzdWVzIQ0KDQpSZWdhcmRzLA0KSmFu
