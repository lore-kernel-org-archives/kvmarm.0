Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795160900;
	b=ouN+HsJrpU9NlMepAAEBeaOTHRSW/y4wbBwOT84QOZcID2Fnge1WJf4gNWf1FCr6q/7G
	 UeByCf9o2UihqONQPHiOIsyvX5tJuM+Dqsy+3uzU0iwLnkLRBEVre38t+cugp8J8ldsIh
	 sox2XDKssvLojJJcNQ2yxxYSi8v0mQR/9bRABsflsM7nDng2Yf/6bMbklWRQh79VGBzCs
	 pL2dw0nzMft2DW/1SEsOCbAqjoFzCb0gvzilQs7T9OTmjm8wE+R+C9mDS5SrMv2vVP8yh
	 1EX/fBBZOTu+qz7ZdfhLkINiqfpq0Cws1A+USPnUGHuR2Vonw6cN70MFqHIQ4/L5yAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795160900;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Deferred-Delivery:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=+QsgWtY25rCev6XMJIO98Ze/sej+0EXiE6n2h1Splk4=;
	b=waykfSfDM9RsvVdxF+5BRHgPFOMbDTK/9CdWaI4h2jy4nrlBDCAfKM1uWfFmh0oQsmF0
	 6PERHc3EhiXi3Qku2Ut1lcDzGhYpEE7I5CODVyMWkjPBz150cgHPzPZM5DdeOJ/aNRIgV
	 o5SXimWrhj3/jYqOHhxnkXlP4DCtFq871aj1Ew2bjpYXgo1B5FKg9Oexq1ENzbED6ypos
	 WOOuu6tADHD07XilLhqbxVxxOX3O0WPrQzspT3P1Nqm5+IVzCLu56lvp0lrbJCC6Ow1lE
	 470yTXKKuvnoQqoNOk7XEEXzKIJrwtM6MPjep8b1PwiQP9dH9VJ6vJ52SCV2YJ/BA7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=OSTdvNqk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.37
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011037.outbound.protection.outlook.com [40.107.74.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C458606A32C;
	Fri, 20 Nov 2026 07:48:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C458606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=OSTdvNqk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtkNVHICaQG4LUZmMCF5G0bXPGCaS63F3F++/9eNW6hVE+fgZpmoFyYWuY0tHvy+4OYxLeBCGAXo3PDiUfMyh8fj74YUlxEABxqRIMwkmbH68WepQrzuRR1Er4nN0d8rj7yrf2uVmko+BazOXM5Zsmqdl6xvV/XFIoBHvEpoFAoB1aH1c7ecZWGHoIy2mkpOYESTd2QOVyR9f7oZPVccnEpeFjmdfHg1ZNMliam86LfyR9xCFZHSxuCnFzvhmnSHAyJk3ox7bF+VK10da3cZiDHxvBZ9oQ8P83j7Zy3BO85e2iVVG3LqAvTTruGcPfXZKA5nGrDv2kbBL/MY8JdvEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QsgWtY25rCev6XMJIO98Ze/sej+0EXiE6n2h1Splk4=;
 b=UmP6mV7/dmXYbzq/pKioyMmZWfJoSdg+mVHZCaF3xg6J8HLTHiFxOQZS9ad420b8RmzRiZ5o9UqDbgs1mXI1dOGqC1qa64yL2q6NvavVLo56NCRRwiZWXsxCYj8uem8Yllxfk6D/+UsHhq/tvFM7F36v+OFA/5MWhi7SPeR6rq7N8ZWn4p67ybPAfYd79YRvDTR0LL1+vpXsg6JH6gjrPU6OsbiIIMMvwqxNN4QofOyj4mqgjeEw0NN8TBb/l+r/6iakNu+uodNMYbYC5sPUqBAJyJYtu6AIu3wj318NlsBmiQR8DQZtO2RWI+Vz5M7byQC84yZrQeNMAK4kaYjtXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QsgWtY25rCev6XMJIO98Ze/sej+0EXiE6n2h1Splk4=;
 b=OSTdvNqke6fZrt3DwmhvBsa42NcdjIE6r5rMNbkDOf+8ky2y+Uc05QGQjzPNL74A3HgF0QxF5SpEzoAI3FSdbDR/b7JIGdrDYMeHJpMOrgP0Ljxnt3OqHUnyql8u/QWe16X8ms03uRVjjlfvW/6EcRGDPV5XzBhK56bkVj2bX4ErCJfxc5LJS93CF4ErW9Va3BjHo+MK+kgUM34O51LyXrDIG+48EWkOPsvOcoNk20GAaZYQQCY8L0hzKCGkIuF29doSztYcxwKxJsWlGjdnT4ZywpT5FZeuAJyNk7BWTIJ5FEqIIj8SvcFvG/9C1h2FojWQnLEkIB0B3eWXUT21wA==
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com (2603:1096:405:290::6)
 by TY7PR01MB14388.jpnprd01.prod.outlook.com (2603:1096:405:240::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 07:48:15 +0000
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793]) by TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 07:48:15 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: "'sashiko-reviews@lists.linux.dev'" <sashiko-reviews@lists.linux.dev>
CC: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Oliver Upton
	<oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v3 2/5] arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA
 Erratum E#030001
Thread-Topic: [PATCH v3 2/5] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Thread-Index: AQHdeAUaSaMCw8h0YU6xw3nNu4nTjLc1ISsAgAFx0rA=
Date: Fri, 20 Nov 2026 07:47:49 +0000
Deferred-Delivery: Fri, 20 Nov 2026 07:47:49 +0000
Message-ID:
 <TY7PR01MB15746613EF5B0DAEFC886919EE5782@TY7PR01MB15746.jpnprd01.prod.outlook.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
 <20261119-monaka-fix-for-upstream-v3-2-057df4d2ca3c@fujitsu.com>
 <sashiko-outbox-222837@kernel.org>
In-Reply-To: <sashiko-outbox-222837@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9ZjI4ODNlYzYtYjNjMy00MGZmLTkwMWUtOWM5YWYzZDM4?=
 =?utf-8?B?OTI4O01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI2LTExLTIwVDA3OjQyOjM1WjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?B?ODFlMS00ODU4LWE5ZDgtNzM2ZTI2N2ZkNGM3O01TSVBfTGFiZWxfMWU5MmVm?=
 =?utf-8?B?NzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX1RhZz0xMCwgMCwgMSwg?=
 =?utf-8?Q?1;?=
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7PR01MB15746:EE_|TY7PR01MB14388:EE_
x-ms-office365-filtering-correlation-id: 4ba7d831-adb2-4c97-60eb-08df46daa26e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|10067099003|4143699003|11063799006|56012099006|261022105027099003|261026140227099003|261022075727099003|261021121427099003|261026121527099003|261028144727099003|261102123227099003|261009223027099003|18002099003|6133799003|22082099003|1580799027|3023799007;
x-microsoft-antispam-message-info:
 MRZkG/Yy01gCi/5e8wNUtDGvHQq69Nnj7EZapJURFVjeQsD/Mp9ia238h+CqwpHo1JgT7++upsrEVgallAjOHZmeU8PE9kPB7r0JfqCowDNsb4W0uChL7gEEx1zTuZXF762G/qyo2FvwnY8lWKVwgADBu+//xGnsVNyTFQ0nxSDicV/jL4RbyyxgXr/QPMniBMYW4wGIssXCwx0OgSv1nDpWAtwFumJ+AAUYHX35Oi2VHE0Si9p7QxDtjKuH8KG8DoSPRfa6tvuGD/n5AFua55LB/dbgD/nNEcO042Rscf1lr6fA1uZ2vjY4cBgq1VQMUlKoq5NtkUpxn/Uc75pcrAtOO4EidAPr6UvRQvsXkh6bQt9qBkIpKxLi41vSeBk1WjuihBV96eD/9FW/aju8TnAjh7IPz2hJVFnO/EyuJ4lsLSKx350KsqdWdXwD1LghhJ76/pxC+KX0KWEaYv1aRp/oNWh6eN+GQKq0b21mhPZDMHdg3UjRAtxWDvctumJuYSiJXNjOGBFJm3MXVV/OwZ059kVa/b3uspnjM2jqSN4Tr281LiroxDv0zvT4exfnQqZb95wUMwsRijD/sVcEDLmw2nQw52eSKK3k+BWmKcIohBHrcumdvuYrcIkNOK7hfO/utysG4O/Cz5ozgC5fKq2LxwXUo9W5q3i/N7ZOM8VkR9UyzLaWRETQhQi9eOxY
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7PR01MB15746.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261026140227099003)(261022075727099003)(261021121427099003)(261026121527099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(22082099003)(1580799027)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eW9waUloemxWTmxLL3RUdkNhWnFETnlyaWJpUVU0MHdIdmdZVU84b01FVXBy?=
 =?utf-8?B?eVVFYTNBdlhNT0d1aWRYWXFtRDh0dUJnaWxlWjJ4MUtOSEFVNGlBMGpxa1hZ?=
 =?utf-8?B?Vit1SWZMVEdUclBsRlg2dU5LdDNISkNJTXBhcjhQenV4UXpldWR6ZWN3UlZP?=
 =?utf-8?B?Sk82aU5FU1FoaTJVV1NvUEtraHpjbzV3UGFacy9Xb3ZmbUluZ2pqNlRVRHpH?=
 =?utf-8?B?MUNUN24zRWluZ3g0SWFRU0UxM0p0RklRUnQ1MW9KZ0kxdkJtNFl0YTFsN3NJ?=
 =?utf-8?B?RVNxRjJwaU8xMThtd29ocDdhbGZvOCtWQkFEa0xXZGFQdWRyVlkwSzhPOWNq?=
 =?utf-8?B?bVl3ajJyMm13Tld5OUNiWHdOaWY5dXdCSnRmTHVPcE03VXY1RTlWRlgwQTdL?=
 =?utf-8?B?d1dNTXN5WG5YelBWZ0ZrUFF6enRGeGx6dlVPVnRNdWlQRUJ4QTBlcGtVWitD?=
 =?utf-8?B?ZWQ0WmNsQzR1RWUveCtGc0VGZW8valk0ZitjTGQ1NG0vV0kxbTFQTlNlM3VH?=
 =?utf-8?B?Lzh1am81NEcrRGNZa2t3cmtoMnBXSGdiSjBVN01wQVVVQVZUTjhCTDkydkRO?=
 =?utf-8?B?Z3pmeE9iMEgrUHJzK2dYNWxCeGpTS0ZyNzNya0wwQ0dnSVM1c1pwUU5nN3Zm?=
 =?utf-8?B?ODlHYklZazIzbnZxTmlRUnVSR2RIZERBeW5DOUx1aGRJUzRUbUxsdCtRbmNl?=
 =?utf-8?B?dEIzU0Vmd3NpckJiSGFRZEZ0SFp0aUpERkdGU2duTktWNnpvY1VJNXNZbm9E?=
 =?utf-8?B?TjBGTTFFSXRHTEc3MFIrQWFqYmpJaUNZbUdNQzdIcjR2V0NBUXFSNkVGcXhT?=
 =?utf-8?B?YkM4cEg0UVpSOWJQcXB3RUd4WEJNU1ZDejhjNnFGbytHUXFYVW50S0dtZlBr?=
 =?utf-8?B?WnoxeGk2QWhJdEVwbVZ4N2IxWHdxZUhJMlhiOUdmVFEwRnNVa3VGYjMxVUxw?=
 =?utf-8?B?KzBqakJvd0VtT1E2b1h6REJyUDhIS0hWRWJFYXl5SEIrbTQybHJvM2dESEpR?=
 =?utf-8?B?cjkyT2NoU1BLSHdTSnZSYWtPSnJ3bG9PZVFZZksxSkh4WVNnQnlrRFlQeEdu?=
 =?utf-8?B?azFYQmN3Wmd4Y0I0TDVJZXp6QzZNUkZYalBMb1JZWmRlZEpodW0vK1d4a2lF?=
 =?utf-8?B?Tm10c1cvWmtGSlN2RVJvVFpTTVR4UnRzRW5lZ1lKUTNHUEVONU1tek5ZVmw3?=
 =?utf-8?B?bVM0a0RDbnFnRUUzclljOWUrWVhhbTdpM1lBYkpRcTloQjN5aWYrQ1RwTEZ4?=
 =?utf-8?B?QVZrYTE0WmlSYzkxWXFvRkFmOVl2U1Uza2lHa3JIY2J6VlM1NE9KM2M3eGlM?=
 =?utf-8?B?c2QwVVU2cGJob2htcXBzZHZuK21zMXJLaWhjdW5OWE9NV1hWSnpjTU5GTks4?=
 =?utf-8?B?RjVyNjNvUFdxWjAvcmVSWG56eVdIcUhrWk8wZEljenZpcDdXdTNZN1NZM0Rp?=
 =?utf-8?B?R3J6Y3ZoTlVBY2NQN1A4Q04veW1wZ2diSW5Yb2w3Z05GaWtZVUZvOCttU0Ry?=
 =?utf-8?B?STNpOUJFV2pRbGRidWJpR0MyalJCNFU5ejVUNXVXRFA1U0xNeDA4UmdzVkty?=
 =?utf-8?B?bjRXU28rUG4xYjIzTEFHbG9UaWpxa2RDeWRaeFdIcUF4bkdLTitybGs2TTU3?=
 =?utf-8?B?TTJHMDBzbHp1c2pjMHNuYlcwek45Y21CRm1ZUDhsWTZSWEVlcmU1bURER2Ja?=
 =?utf-8?B?KzhXdURyUWNHMEkxd1lZemFnTzlSb0t2L1dVaXh4Q3dtaGJLQk12QnBtTHRy?=
 =?utf-8?B?aE9RczlpMks1WEVHV3dvbDlqUGlJdjF4RVJucUNvbTFNM2huR0ZXVWo3bnB3?=
 =?utf-8?B?c1RzZi9XdGNQaFRSRCtNUkNWZDlMOHU5cEVwNUkyQkxSek16Qm9uN1VMd1Bj?=
 =?utf-8?B?b3QraDBPOE12a2VTSFRPcW54OWhzYkF2OExyVGVuS0pLTU9nNjdyQzFwQ1Rw?=
 =?utf-8?B?SGN5WnY4NXAzYVhkYWNMaDFSYldZN2tmZDNQQW96cERlYW1QV0dFZi9Da0Np?=
 =?utf-8?B?b3laTW9SU1FoN3QwMHM2M2tVRUVYMnlqbzB0ZmdIS1VIbktTWUZNRU4vdW1u?=
 =?utf-8?B?N0V3VDk0S1RPZDZQSHRBUFJhRHVqdzBjbnlLVDZZOHNsSHJSZmg1akI4MWRt?=
 =?utf-8?B?blRxODVZTGNXZzhBczVzZGxCc0dlTCtaNWJkNVR2Z1dCREVYbTBhcDFTemxW?=
 =?utf-8?B?aDB4Zm9GQTROeFpSTEZXNHpDNWlHc2FFM1pNaitiMnVtWDJZSUFyMXdYNlhI?=
 =?utf-8?B?SGxFVGt5U3QyTStyOHJpNitYQnR2Q1UyZU1udHZnYy8vRXhTbGZVRnpWaDhs?=
 =?utf-8?B?YVpCalJTdll0Mjk3NzZ3NHl2ZTBKeGFOOUtGMFE2aGFQakxVWWhEQ1F2cGN5?=
 =?utf-8?Q?aNRwQ1nOPtqCJHaY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	v7NhQFvsh802OTqrRhL+MKRfgIyC3SatmNhcU3cQVctiSHQi7T+HbQrv5iahBXoId067/j7+B056OGQ3jKlG/4D8nEQq0gTQ9zohHSIACdFNq/U5KU1Yu+d1kYEcB5vTCOvHcKqVfwnRIx/W8YG2a3ZHEwA580vTlLBqYmIqUEbdzIezmTS0RPMQ7zqZMVMfBkWptFlIjj4t4sOUGNcV5A4CHqrLihkwDdZvAdWSvMunkx9Q8CYONnzVsVdAvtAjduZoFMJxoZ/Fhc+ZNcOJ6wdptC6Qv28qkGnhbfZ1DzLgHCPX6lMxM6jr7UERty40vEA/HbQb2lDYQYyNq98s4A==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7PR01MB15746.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba7d831-adb2-4c97-60eb-08df46daa26e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2026 07:48:15.1213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+Fch8b7ttj1yDSiJAjuJbDkVaYitlQel3NCqGuHs+robEFy9ncePdx+qKiLEK1ipDr0Fl+bL3GIdVIq9WNwMJ1F/Q1JENxpwB2riLRuM1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY7PR01MB14388

PiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDIvNV0gYXJtNjQ6IHRsYjogQWRkIHRsYmkgd29ya2Fy
b3VuZCBmb3IgRlVKSVRTVS1NT05BS0EgRXJyYXR1bSBFIzAzMDAwMQ0KPiANCj4gVGhhbmsgeW91
IGZvciB5b3VyIGNvbnRyaWJ1dGlvbiEgU2FzaGlrbyBBSSByZXZpZXcgZm91bmQgMiBwb3RlbnRp
YWwNCj4gaXNzdWVzIHRvIGNvbnNpZGVyOg0KPiAtIFtNZWRpdW1dIEtWTTogYXJtNjQ6IHB2bV9j
YWxjX2lkX3JlZygpIGV4cG9zZXMgRkVBVF9UTEJJUkFOR0Ugb24NCj4gICBGVUpJVFNVLU1PTkFL
QQ0KPiAtIFtMb3ddIEtWTTogYXJtNjQ6IF9fa3ZtX3JlYWRfc2FuaXRpc2VkX2lkX3JlZygpIGVs
ZXZhdGVzDQo+ICAgSURfQUE2NElTQVIwX0VMMS5UTEIgdG8gT1MNCj4gLS0NCj4gDQo+IGNvbW1p
dCA5MTNhYmViNDVmYzYxMzk1MTcxNTEyN2E5NTRlMzFhODBhMGUwMGNmDQo+IEF1dGhvcjogVG9t
b2hpcm8gTWlzb25vIDxtaXNvbm8udG9tb2hpcm9AZnVqaXRzdS5jb20+DQo+IA0KPiBhcm02NDog
dGxiOiBBZGQgdGxiaSB3b3JrYXJvdW5kIGZvciBGVUpJVFNVLU1PTkFLQSBFcnJhdHVtIEUjMDMw
MDAxDQo+IA0KPiBUaGlzIGNvbW1pdCBhZGRzIGEgd29ya2Fyb3VuZCBmb3IgRlVKSVRTVS1NT05B
S0EgRXJyYXR1bSBFIzAzMDAwMSBieQ0KPiBkaXNhYmxpbmcgQVJNNjRfSEFTX1RMQl9SQU5HRSBv
biB0aGUgaG9zdCBhbmQgZG93bmdyYWRpbmcNCj4gSURfQUE2NElTQVIwX0VMMS5UTEIgdG8gT1Mg
Zm9yIEtWTSBndWVzdHMuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNf
cmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+IGluZGV4IGM3ZDkxMTM4YTZk
NDkuLjJlODk2NWI3NzAyZTEgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3Jl
Z3MuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gPiBAQCAtMTk0OSw2
ICsxOTQ5LDE0IEBAIHN0YXRpYyB1NjQgX19rdm1fcmVhZF9zYW5pdGlzZWRfaWRfcmVnKGNvbnN0
IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiAgCWNhc2UgU1lTX0lEX0FBNjRQRlIyX0VMMToN
Cj4gPiAgCQl2YWwgPSBzYW5pdGlzZV9pZF9hYTY0cGZyMl9lbDEodmNwdSwgdmFsKTsNCj4gPiAg
CQlicmVhazsNCj4gPiArCWNhc2UgU1lTX0lEX0FBNjRJU0FSMF9FTDE6DQo+ID4gKwkJaWYgKGNw
dXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfV09SS0FST1VORF9GVUpJVFNVXzAzMDAwMSkpIHsNCj4g
PiArCQkJLyogZGlzYWJsZSBUTEJJIHJhbmdlIG9wZXJhdG9pbnMgb24gZ3Vlc3QgKi8NCj4gPiAr
CQkJdmFsICY9IH5JRF9BQTY0SVNBUjBfRUwxX1RMQl9NQVNLOw0KPiA+ICsJCQl2YWwgfD0gU1lT
X0ZJRUxEX1BSRVAoSURfQUE2NElTQVIwX0VMMSwgVExCLA0KPiA+ICsJCQkJSURfQUE2NElTQVIw
X0VMMV9UTEJfT1MpOw0KPiA+ICsJCX0NCj4gPiArCQlicmVhazsNCj4gPiAgCWNhc2UgU1lTX0lE
X0FBNjRJU0FSMV9FTDE6DQo+ID4gIAkJaWYgKCF2Y3B1X2hhc19wdHJhdXRoKHZjcHUpKQ0KPiA+
ICAJCQl2YWwgJj0gfihJRF9BQTY0SVNBUjFfRUwxX0FQQSB8DQo+IA0KPiBbU2V2ZXJpdHk6IE1l
ZGl1bV0NCj4gRG9lcyB0aGlzIGxlYXZlIEZFQVRfVExCSVJBTkdFIGV4cG9zZWQgdG8gcHJvdGVj
dGVkIFZNcyB1bmRlciBwS1ZNPw0KPiANCj4gaGFzX3RsYl9yYW5nZSgpIGRpc2FibGVzIEFSTTY0
X0hBU19UTEJfUkFOR0Ugb24gdGhlIGhvc3Qgd2l0aG91dCBtb2RpZnlpbmcNCj4gdGhlIHNhbml0
aXNlZCBmZWF0dXJlIHJlZ2lzdGVyIHZhbHVlIHJldHVybmVkIGJ5DQo+IHJlYWRfc2FuaXRpc2Vk
X2Z0cl9yZWcoU1lTX0lEX0FBNjRJU0FSMF9FTDEpLiAgRm9yIHByb3RlY3RlZCBWTXMNCj4gKGt2
bV9hcm0ubW9kZT1wcm90ZWN0ZWQpLCBndWVzdCBJRCByZWdpc3RlcnMgZG8gbm90IGdvIHRocm91
Z2gNCj4gX19rdm1fcmVhZF9zYW5pdGlzZWRfaWRfcmVnKCk6IGt2bV9oeXBfaW5pdF9zeW1ib2xz
KCkgY29waWVzDQo+IHJlYWRfc2FuaXRpc2VkX2Z0cl9yZWcoU1lTX0lEX0FBNjRJU0FSMF9FTDEp
IGludG8gaWRfYWE2NGlzYXIwX2VsMV9zeXNfdmFsLA0KPiBhbmQga3ZtX2luaXRfcHZtX2lkX3Jl
Z3MoKSAtPiBwdm1fY2FsY19pZF9yZWcoKSByZXR1cm5zDQo+IGlkX2FhNjRpc2FyMF9lbDFfc3lz
X3ZhbCB1bmNoYW5nZWQgZm9yIFNZU19JRF9BQTY0SVNBUjBfRUwxLiAgQSBwcm90ZWN0ZWQNCj4g
Z3Vlc3Qgb24gRlVKSVRTVS1NT05BS0Egd2lsbCBzdGlsbCBvYnNlcnZlIElEX0FBNjRJU0FSMF9F
TDEuVExCID09IFJBTkdFIGFuZA0KPiBpc3N1ZSB0aGUgYWZmZWN0ZWQgUlZBW0xdRTEqIGFuZCBS
VkFBW0xdRTEqIGluc3RydWN0aW9ucywgbGVhdmluZyBzdGFsZSBUTEINCj4gZW50cmllcyB3aGVu
IGludmFsaWRhdGluZyBhbiBhZmZlY3RlZCA1MTJNQiBtYXBwaW5nLg0KDQpJIHRoaW5rIHRoaXMg
aXMgYSB2YWxpZCBwb2ludC4NClNvLCBhcyBNYXJjIHN1Z2dlc3RlZCBpbiB2MiBjb21tZW50LCBp
dCBzZWVtcyBiZXR0ZXIgdG8gY2xlYXIgdGhlIGNhcGFiaWxpdHkgZnJvbQ0KSURfQUE2NElTQVIw
X0VMMSBjb3B5IHRoYXQga2VybmVsIGhhcyBzbyB0aGF0IGJvdGggS1ZNL3BLVk0gc2VlIHRoZSBz
YW1lIHZhbHVlLg0KSSdsbCBleHBsb3JlIHRoaXMgYXBwcm9hY2guDQoNCj4gW1NldmVyaXR5OiBM
b3ddDQo+IENhbiBvdmVyd3JpdGluZyBJRF9BQTY0SVNBUjBfRUwxLlRMQiB3aXRoIElEX0FBNjRJ
U0FSMF9FTDFfVExCX09TIGVsZXZhdGUNCj4gdGhlIGZpZWxkIGZyb20gTkkgKDApIHRvIE9TICgx
KT8NCj4gDQo+IElmIGFuIEwxIEtWTSBob3N0IG9uIEZVSklUU1UtTU9OQUtBIGhhZCBJRF9BQTY0
SVNBUjBfRUwxLlRMQiBkb3duZ3JhZGVkIHRvDQo+IE5JIGJ5IGl0cyBMMCBWTU0sIHNldHRpbmcg
SURfQUE2NElTQVIwX0VMMV9UTEJfT1MgdW5jb25kaXRpb25hbGx5IGFkdmVydGlzZXMNCj4gRkVB
VF9UTEJJT1MgdG8gTDIgZ3Vlc3RzIHdoZW4gdGhlIGhvc3QgZG9lcyBub3QgaGF2ZSBpdCwgY2F1
c2luZyBMMCB0bw0KPiBpbmplY3QgYW4gVU5ERUZJTkVEIGV4Y2VwdGlvbiBvbiBvdXRlci1zaGFy
ZWFibGUgVExCSSBpbnN0cnVjdGlvbnMuICBVc2luZw0KPiBJRF9SRUdfTElNSVRfRklFTERfRU5V
TSh2YWwsIElEX0FBNjRJU0FSMF9FTDEsIFRMQiwgT1MpIHdvdWxkIGNsYW1wIHRoZQ0KPiBmaWVs
ZCB3aXRoIG1pbigpIGluc3RlYWQgb2YgZWxldmF0aW5nIGl0Lg0KDQpJIGFncmVlIHRoYXQgSURf
UkVHX0xJTUlUX0ZJRUxEX0VOVU0oKSBtYWNybyBzaG91bGQgYmUgdXNlZCBoZXJlLg0KSSdsbCB1
c2UgaXQgaW4gdGhlIG5leHQgdmVyc2lvbiBpZiBuZWVkZWQuDQoNClRvbW9oaXJvIE1pc29ubw0K
DQo+IA0KPiAtLQ0KPiBTYXNoaWtvIEFJIHJldmlldyDCtw0KPiBodHRwczovL3Nhc2hpa28uZGV2
LyMvcGF0Y2hzZXQvMjAyNjExMTktbW9uYWthLWZpeC1mb3ItdXBzdHJlYW0tdjMtMC0wNTdkZjRk
MmNhM2NAZnVqaXRzdS5jb20/cGFyDQo+IHQ9Mg0K
