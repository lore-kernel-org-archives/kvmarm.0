Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08AB37268D;
	Fri, 17 Jul 2026 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=3.72.182.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309608; cv=fail; b=YYe2Bqe2MyLnhANQ5OCwneTaZiAuJ+Ee+zs/R5sneCrGq3A+bWqQIFGgreqVb0/L+Fnp0Ry1e351eCoHxZAMtFtkV/e+09wk2761GhspbECQNAm4Sxj15K+gyz56T91CroS118EI1bERkimyqHniUaltdiW3AfabdkANjbawrRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309608; c=relaxed/simple;
	bh=PIGcfLYUl7LIEC94VnO4vxW+7a3j6Sl1eSZbi8POaRM=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bsVxFAn7T4KtVYRczqgondN7yTPsOn0AHNql6B2X+0k//Xp2cYzO7Bego5rBR69e3cDpO5c1VpdRC1wYilWQBMfesFzgsUpKCZ3VJDw8PQBdtLIhltZT92Y6q71he1x5o9TWQn9/iBCz3fSQhuxU9hXj+VNTmKmGHM+IG/YhQEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.es; spf=pass smtp.mailfrom=amazon.es; dkim=pass (2048-bit key) header.d=amazon.es header.i=@amazon.es header.b=Ql6cmN7x; arc=fail smtp.client-ip=3.72.182.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.es header.i=@amazon.es header.b="Ql6cmN7x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.es; i=@amazon.es; q=dns/txt; s=amazoncorp2;
  t=1784309606; x=1815845606;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=PIGcfLYUl7LIEC94VnO4vxW+7a3j6Sl1eSZbi8POaRM=;
  b=Ql6cmN7xxVvmcuzlhX49FKqnichiC5bu0zkM7KiE80cB8KpYS3bm9fPx
   kG3jGqBSG+cvAEF1Hk4r3/yfrK7LjGld2WenuEYPMup3BVfbkbUvyCOdj
   s/j/B3shmA3nK9WsmiuY5KKYn2aXU/IV2xazwuO6BFu8XkPHbfYTrjkf0
   PUeoZkn6WyhO4cpg82Bx+jCTNEIqlB0xsi6vVuWcmUhQlbb3ZVkLTjBaN
   AMnFvzzmklHsdVg4OTQwdTLtfrInE6vJ32liYLNOQ/WPkk0sdxjtQru4y
   nEKuoJpHGaX5sD1vYeYt0pgUtQJsQoVGikQRytZp8e8jkAP3h/HNJj1oS
   g==;
X-CSE-ConnectionGUID: oX30EYh2TQSYtUHTff7C2A==
X-CSE-MsgGUID: GhR/rKoWSTO6OlRL5UY/hA==
X-IronPort-AV: E=Sophos;i="6.25,169,1779148800"; 
   d="scan'208";a="16606300"
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Thread-Topic: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 17:33:21 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:15026]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.14.105:2525] with esmtp (Farcaster)
 id 1888babb-3276-4d9f-a1cb-f2ab67553105; Fri, 17 Jul 2026 17:33:21 +0000 (UTC)
X-Farcaster-Flow-ID: 1888babb-3276-4d9f-a1cb-f2ab67553105
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 17 Jul 2026 17:33:21 +0000
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 17 Jul 2026 17:33:20 +0000
Received: from AS8PR07CU003.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43
 via Frontend Transport; Fri, 17 Jul 2026 17:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7UFo/ezpRcRLraXjJznb08tjcMYZ+S+KrmrE9GGaM+1zLaP2cU1X5phLbeJ3sib53xgcBjoeheZYzPlPlaP4NhgDQYDtswFKtTV56qWaCoXJWi0Gd/y/aCbpNFCINl5jRSyV9RM5jMRkHPS7r0fem7A19v78xFBBJxJDf1CV1HeOMux3QwOqZ3NJAajuMwhiecVz8WgFIYlXZtj9ml00QCO6eSMvuiVBUON9/25oiO2v4ECObKMR9G4zVGkY4SZNdDTYkLvzrPaklHNn/OUasuzSZtNEkXXCJ19mw6LlKktO7J6IjrgKOfQ31DVqEnOs+tkXMwO96blKHiFzCWlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIGcfLYUl7LIEC94VnO4vxW+7a3j6Sl1eSZbi8POaRM=;
 b=oIJ+sbvVRezcD71s5LLR+IekAvIqWaM7wMWNoMdnmpCXXytoDdBH0ETsx6fB/xA1EnwuPUOzcb6aImU6pXJ7MWQbM0vzhpHIL3sRjlUur/pcjeyZX3HOL63PybvbomlAJFGLd/IgLfR8AdYqxauOSMIHbM1WFw32jOFIMF5LWl5lFHkI+xQyQACCTXpDmGxq8B66bFIJM9OietE13D6AgDdyx/z8sKxAn32HdTTqN9R9nQFGccd1uCkRmZrQyvAayM4SYlrRW7mgixFgE3+z00SAjnIQyPqVVmvBwgvuOhS0cgo8+gLBNssJJXwZ6OqRESKMuttWdFFsQdYAgA6ctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.es; dmarc=pass action=none header.from=amazon.es;
 dkim=pass header.d=amazon.es; arc=none
Received: from AM0PR06MB10511.eurprd06.prod.outlook.com (2603:10a6:20b:700::7)
 by AM8PR06MB6898.eurprd06.prod.outlook.com (2603:10a6:20b:1da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Fri, 17 Jul
 2026 17:33:18 +0000
Received: from AM0PR06MB10511.eurprd06.prod.outlook.com
 ([fe80::9834:3241:1f23:20ed]) by AM0PR06MB10511.eurprd06.prod.outlook.com
 ([fe80::9834:3241:1f23:20ed%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 17:33:18 +0000
From: "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Saenz Julienne,
 Nicolas" <nsaenz@amazon.es>, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Orazgaliyeva, Anel"
	<anelkz@amazon.de>, Melody Wang <huibo.wang@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>,
	"coconut-svsm@lists.linux.dev" <coconut-svsm@lists.linux.dev>,
	"joerg.roedel@amd.com" <joerg.roedel@amd.com>
Thread-Index: AQHc91VNfGXASvbj1EW/r45M3lCQtLY03m8AgAAR8gCAAAHXgIABOIgAgDvMboCAACO/gIAAGxyA
Date: Fri, 17 Jul 2026 17:33:18 +0000
Message-ID: <DK10YP78VVQO.7BFETGMA9P4F@amazon.com>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
 <aib8n5lO6HKbLC4Y@8bytes.org>
 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
 <aigE2EvJyZlYDz0V@8bytes.org> <DK0W6G329B6W.2KGT7FAVSKNYS@amazon.com>
 <976f1a8316438d5b7c2f446a0369dcda3289cc92.camel@HansenPartnership.com>
In-Reply-To: <976f1a8316438d5b7c2f446a0369dcda3289cc92.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.es;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR06MB10511:EE_|AM8PR06MB6898:EE_
x-ms-office365-filtering-correlation-id: 7e5155ec-64ac-4a11-2854-08dee4297db9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|3023799007|22082099003|4143699003|38070700021|10067099003|11063799006|56012099006;
x-microsoft-antispam-message-info: lK11OHJRm6MOr99AdZhGX9H1mGplHi9pMjbSJ8AoAAHgqs5CgdP5u1G3qafou/6Md8qUfLUXhEwPGzwNN/YDdICn5ko1nvAtxd9ZL0vltXPhUf08VLOJFifI7/UQUfx6lvg6n12lF1v7DMslTlSTR2K+nLMCzeFG9Vu6bgsOhNMq0m+eHkmpP7+ZzXyJ11YH3sH2yN4u5KPK1Wm3juqO73Jm/ZXyftccQBDhB6juXhfJc+4kleyHlu15PN1Ah04bEfwznN29nnfTjm7mPG2i/utro7JSN4/XbssB6o3Ne31Kh5UnN3fDbMhcwGjod0c9TLdRpKbEb5yQMKOmrpBJfZBkxjkgcTIUlN7Z2MDHrqSORTlXBkW/iDAk+F0QsKurW2b6scQXoddsC+okWCB+2c5Ls9hTzXe0ki49mygft3r1setLo0l7Sps01EYNxhCwIypPOp0x0QGRntcu/ItdQchrWC1SwI75D5agiqsHW4WM6bTG7Z0x+uOQR1ogfFvIX3CVfb59KNv+fssNve6ItjkxJGIoNrPS1hd5FCXaGJi5wHab9hrtPA+tNjq5TQXDcj2jOKz9RByLHUclJehqdIK221vq31rGeWRYwTZ6tyjkgLLT4SmnzuCSyFf6avs0v1SO2IR6tOqD6ZH9piDnDu2UNRaN6mCxbKRGEMgEKYTmvob+wwU2aSenXiCBmtN+W1ZbDfgyvn+mwTLhx36sbIIpbZU1fdk+LKIQlayl8TA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR06MB10511.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(3023799007)(22082099003)(4143699003)(38070700021)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MThPcW5KRTJ4NjlXZ083Vkw1Wm16S3VPNTEySkk5WCtaMm9qSkMxaXcycGNM?=
 =?utf-8?B?OGhEZldKSmdjZFN1THY4KzA0TE1OeWhhMWxpc1VKckpqN3c5MzdNYS90eFc4?=
 =?utf-8?B?bXdxYWtrYllVUXgvamJUNEhYajR4THlJWUdzcTQrL1Z0WFFOMmpGUU5lOUNN?=
 =?utf-8?B?bFd0MHV0endaSTVmSFRmNlNlNXJ5UllzY3J1Y2FQS05UNms2TVRvWFowOUY5?=
 =?utf-8?B?Q1JlNnR6eGJmU1lIZmRubHA3aStNakplblh6aHVBOGp5MGpIdEtKeFlBR1Vv?=
 =?utf-8?B?U1BEdnVCZEZmQmZqRlRTR1ptT3JPQWp5WTRGZVIzOUZsbEswN3NDSGdTMDV2?=
 =?utf-8?B?RTRkZ2JqVUtuVWw0bHlWNmZRY2w1a1JVaEtZMzAzcFN3M04wRlhabmdkSVFQ?=
 =?utf-8?B?VnE2RGw4OGR0VEtZSEp5aU4zNUY3NElVVE1TVmlPY0FDMzd3UXNKbW91Y2Ni?=
 =?utf-8?B?Y0U5N1ptR21YcDA5L2todUNKVVBzMHBQRGNPUzNPdXJhRUpKOXFUZXlRR29q?=
 =?utf-8?B?aGlRUy92cHZuNXZtM1F1ZlRwR3B3L2RKWEZIZHhrZlorMXBMa2krK1QzNGg4?=
 =?utf-8?B?WmtwNGk3Ti9HaG8xYk1oVGNKOHdHcC9KTW1uZWc1djBselgrdytOVGhLRmFO?=
 =?utf-8?B?UVZoSVYzTEQ1K0MzVHpteWlSUWdtK3psVjRqZ1pVb1VqWlp4a092aUJTS0di?=
 =?utf-8?B?OXpqSHpUMFpQSlptMGJHcWw3eWxFVUZldlBxdzBVOVcrVWlxUi9aQWRwVk9W?=
 =?utf-8?B?Q3BHeHFUR2U1bW5WM1kxMldNcVltaHZsUUNYb3RGcUtGT0FGWUhZSzU4T0Fr?=
 =?utf-8?B?NUFDU20rSXZzR0UwN3k2OVNVRlM0TXNBbHNkZVBxakhRd0MySHRxd1J2WHFE?=
 =?utf-8?B?L29scFZ4YTBSM0lqM1FEMFAyR2p5WXhHcm5PQXlWRzd5TEU1VEl6YVVOWGc2?=
 =?utf-8?B?d1dTOGVQRmNPMHExcElaVVp3TkNWVlpjbi9tNmJOc0FzMWFHWnVlV2gwb2Rq?=
 =?utf-8?B?QzgyUndvdDBFKy84VDNPSDlWZ2JQK1BFN1k2SE8xSk8rWFlGT1Jqc05DNzVs?=
 =?utf-8?B?dVo0azdudkRrN3NhTDZiMkRiazJaU0tUb1ZWNklBdkdORzNMQmxDdnkwbjRK?=
 =?utf-8?B?OGtsUzloMjVub1RrTWRpUzFlQmlZeFY5K2dZcjgrdUV2RjFrVW1oSGlSRFdL?=
 =?utf-8?B?NGExVkpjWmQ4V2QveGN1emFTREhKU2ttRDRlMWxnVlNoOTZlU1VOMlA5V0FH?=
 =?utf-8?B?ZFNraVMyeEU3d1VXWk44SmczSEpxa3JhSjlubXRhUFdqRTRhdi9NallycGF0?=
 =?utf-8?B?cWVrNVo2d0VJSEdnN3pDaDVQNm9xZkFZTGVCLzF1ZFp1WGJ5QzliU2ZtbVpi?=
 =?utf-8?B?c2ZzaFBFNVNYclVHSW9IK2VhR0hLdjJKNjBxMnl5M0lBbHZ1S2JhS3kvdlZw?=
 =?utf-8?B?UGtLMGswdHFqY004aGRjM0tqdityZ2RDbS9kU2RydFdwdnVVMlZ5TzdEZ2Z2?=
 =?utf-8?B?eWE2Y1ZDaHdvVmVmTjU0d2hnZ3F6bElqYTJnS01oRCtrR0hITXVRR0l5Y3lt?=
 =?utf-8?B?T1VDTDFDM00vUWVQR0pGOVBSeSs4RUIwQ1FHWXltYWRQdm1hUkkzTUZ0eGM0?=
 =?utf-8?B?SCtWNTlRbzR5ajlpZWJWSGV4MXIrbU11SWR5QkFDajc4d2V6SmI2a1h1aVRh?=
 =?utf-8?B?VkdEckRVVFpQNEF3dDhzYVNndkgyT05YUSt5eVgrZVM0QlovTFdtcWUxcDFa?=
 =?utf-8?B?QXZWRFJ5YW55a1I3Z3hCOUR1R3hVS29iNENNdFJvRWs4SkNqNHIybFpxNENn?=
 =?utf-8?B?V3YwOUQrRVFreWpEaXFsT3AzNHJqRzZDbmZZYzNIQVJwVjNEbkJYS21vUzJQ?=
 =?utf-8?B?ajZrZlRVY2prQkN2eHRERUVmSGxLdEdjdi9ZQzNSSE92MFQzN0dIZC9PNTFV?=
 =?utf-8?B?MWVROTI3eStWRjJtQWwyVURXNFprZ1FBVlhML2NuRHcrN2VQR1JSeEhCWmJh?=
 =?utf-8?B?YWphcFlucjZRNUR5U2J4OFplenlXSWkrTUxlUFgzQ0Ixa3hna2VWWDZPcUFJ?=
 =?utf-8?B?Uy9zUWc4Rkh1ejVHTEdDU2Z1RVZwRFZESlVYWlIyV1VuMFhaakRnK3FOWEk5?=
 =?utf-8?B?UktBNXJOb2Y0bldpUmVHM2Nkcm5PTE9VZ1JieXVpR0p6R3d6NTVXZGVXdzlB?=
 =?utf-8?B?RjJ2VjVoZmFmeHREcGI3THc4ZkdDOTZqWkk3SW9hbnplSDZVU2N2ak9XcUxB?=
 =?utf-8?B?SDRmbTRucDRyUjFTNk93SkdTOVJ6b2NFNlhINm8vSkdHOW1GNVFPeTI4alJF?=
 =?utf-8?B?Uis3eU1pQWR4clZ1VEZyVmVHMUFncUVLMW1LWG11L3lnclAxTm03Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <407FC8A1B2E92440A51D211D34701BA5@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TPt5/TJofoiIgPbh0xsc8jjXt6sZaU0Cg9q19UUkiWkx6J+mPYtIWk6+6XHQGi+q6OQXQ2rRRouGaXrOcs173jQcCi8CG6BjsTzigcecxIm4JQDN87wq2m28mRGi2jNqvZpqXohfmS8cFOXltLoDb0bxN1cmmXA28UFVFLn7X/Qi06yhPeMTzaTIMRG/9ZYBrbiRYpn3a4jyV50o7U3DTscOFA4rIeJITwe4AZxf/8YR4yKlqlTqE8bJbAqF7SByuPPVjQenSj+Khzsxm2nkoscY90IYNnfnd102EzJA1rxa2z3PXHC5RZx7pceZ+g5yl27RyHjfcvlRUQRAyhxo2Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR06MB10511.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5155ec-64ac-4a11-2854-08dee4297db9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 17:33:18.7235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ing1bDfQdb43ZDSmLfhp41cwsMm/FZTaP7IPlUTBhyUUR8jg6R08F9Q1lQdvbylAwccTNWu3Kwi5QTdpwmITgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR06MB6898
X-OriginatorOrg: amazon.es

T24gRnJpIEp1bCAxNywgMjAyNiBhdCA1OjU2IFBNIENFU1QsIEphbWVzIEJvdHRvbWxleSB3cm90
ZToNCj4+ID4gPiBUaGUgaWRlYSBvZiB0aGUgdXNlcnNwYWNlIHNjaGVkdWxpbmcgd2FzIHRoYXQg
eW91J3JlIG5vdCBmb3JjZWQNCj4+ID4gPiB0byB1c2UgaXQgLSB0aGUga2VybmVsIGNhbiBhbHdh
eXMgY2hvb3NlIHRvIG92ZXJyaWRlIGl0IGlmIGl0J3MNCj4+ID4gPiB1c2luZyBhbiBhY2NlbGVy
YXRlZCBpbXBsZW1lbnRhdGlvbiBvZiBwbGFuZXMgKGFuZCBvZiBwbGFuZQ0KPj4gPiA+IHN3aXRj
aGluZykuIEJ1dCBpdCBhbHNvIGxlYXZlcyBzb21lIGxlZXdheSB0byBkaWZmZXJlbnQNCj4+ID4g
PiBhY2NlbGVyYXRlZCBpbXBsZW1lbnRhdGlvbnMsIGVhY2ggb2Ygd2hpY2ggY2FuIHBpY2sgdGhl
aXIgb3duDQo+PiA+ID4gYWxnb3JpdGhtLg0KPj4gPiA+DQo+PiA+ID4gQ29uY2VwdHVhbGx5IEkn
ZCByYXRoZXIga2VlcCB0aGUgcG9zc2liaWxpdHkgb2YgdXNlcnNwYWNlDQo+PiA+ID4gc2NoZWR1
bGluZy4gQnV0IG1heWJlIGl0IGRvZXNuJ3QgYWRkIG11Y2guDQo+PiA+DQo+PiA+IE15IHByZWZl
cmVuY2UgaXMgdG8ga2VlcCBwbGFuZSBzY2hlZHVsaW5nIGF0IG9uZSBwbGFjZSAoaW4gdGhlDQo+
PiA+IGtlcm5lbCkgdG8ga2VlcCBpdCBzaW1wbGUuIEJ1dCBpZiB5b3Ugc2VlIGEgbmVlZCBmb3Ig
dXNlci1tb2RlIHRvDQo+PiA+IGludGVyYWN0IHRoZXJlIGFzIHdlbGwgKG9ubHkgcmVhbGx5IHdv
cmtzIGZvciBWU00pLCB0aGVuIEkgY2FuIGFkZA0KPj4gPiBpdC4NCj4+DQo+PiBUaGUgcmVzcG9u
c2liaWxpdHkgc3BsaXQgd2UgaGFkIGluIG1pbmQgd2hlbiB3ZSBidWlsdCBhIFZTTSBlbXVsYXRp
b24NCj4+IHByb3RvdHlwZSBbMV0gd2FzIHRvIGtlZXAgYWxsIFZUTCBwb2xpY2luZyBpbiB1c2Vy
LXNwYWNlLiBUaGlzDQo+PiBpbmNsdWRlcyBWVEwgc3dpdGNoaW5nLCBDcm9zcyBWVEwgSVBJcywg
SW50ZXJjZXB0cyAoTWVtb3J5LCBNU1JzLA0KPj4gSW5zbnMsIENQVSByZWdzKSwgVlRMIGF3YXJl
IFNNUCBicmluZy11cCwgZXRjLiBFdmVuIHdpdGggS1ZNIFBsYW5lcw0KPj4gaW4gcGxhY2UsIG15
IHRoaW5raW5nIHdhcyB0byBrZWVwIGl0IGFzIHN1Y2guIFdoaWxlIGFsbCB0aGlzIGNvdWxkIGJl
DQo+PiBpbXBsZW1lbnRlZCBpbiB0aGUga2VybmVsLCBpbiBwcmFjdGljYWwgdGVybXMsIEkgdGhp
bmsgaXQnbGwgYmUNCj4+IGVhc2llciB0byBnZXQgVlNNIHN1cHBvcnQgdXBzdHJlYW0gdGhlIG1v
cmUgd2UgbW92ZSB0aGUNCj4+IGltcGxlbWVudGF0aW9uIGludG8gdXNlci1zcGFjZS4NCj4NCj4g
SSBsb29rZWQgYXQgdGhlIGtlcm5lbCBiaXQuICBUaGUgdnNtL2RldiBicmFuY2ggY29udGFpbnMg
NzIgcGF0Y2hlcw0KPiBvdmVyIDYuMTIgd2hpY2ggaXMgcXVpdGUgYSBsb3QgLi4uDQoNClllcywg
YW5kIG9uIHRvcCBwdW50aW5nIG1vc3Qgb2YgVlNNJ3MgaW1wbGVtZW50YXRpb24gaW50byB1c2Vy
LXNwYWNlLA0KaXQncyBpbmNvbXBsZXRlLg0KDQo+IEhvd2V2ZXIsIGZyb20gYSBxdWljayBza2lt
LCB0aGUgbWFpbiB0aGluZyBpcyB0aGF0IHlvdSB1c2VkIG11bHRpcGxlDQo+IEtWTSBzdHJ1Y3R1
cmVzIHRvIG1hbmFnZSB0aGUgcGxhbmVzIHdoaWNoIG1lYW5zIGVhY2ggcGxhbmUgbmF0dXJhbGx5
DQo+IGdldHMgaXRzIG93biBhZGRyZXNzIHNwYWNlLiAgSW4gdGhlIGN1cnJlbnQgcGxhbmVzIG1v
ZGVsIHNvIGZhciB0aGVyZSdzDQo+IG9ubHkgb25lIGFkZHJlc3Mgc3BhY2UgKG9yIHR3byBpZiB5
b3UgaGF2ZSBTTU0pLiAgU05QIGRvZXNuJ3QgbmVlZA0KPiBhbnl0aGluZyBhYm92ZSB0aGlzIGJl
Y2F1c2UgdGhlIFZNUEwgcHJvdGVjdGlvbiBpcyBuYXR1cmFsbHkgbWFuYWdlZA0KPiBpbnNpZGUg
dGhlIGd1ZXN0IChzbyBub3QgcmVhbGx5IHZpc2libGUgdG8gdGhlIGhvc3QpIGJ1dCBhIFZUTA0K
PiBpbXBsZW1lbnRhdGlvbiB3aWxsLiAgU28gSSB0aGluayB0aGUgYmlnIHF1ZXN0aW9uIGJlY29t
ZXMgaG93IGFyZSB3ZQ0KPiBnb2luZyB0byBhY2hpZXZlIGFkZHJlc3Mgc3BhY2Ugc2VwYXJhdGlv
biBmb3IgcGxhbmVzPyAgSXQncyB0ZW1wdGluZyB0bw0KPiBzYXkgc2ltcGx5IG9uZSBhZGRyZXNz
IHNwYWNlIHBlciBwbGFuZSBhbmQgbWFrZSBTTU0gaXRzIG93biBwbGFuZSB3aXRoDQo+IGRpZmZl
cmVudCBzd2l0Y2hpbmcgYnV0IGl0J3MgYW4gYXdmdWwgbG90IG9mIG92ZXJoZWFkIGVzcGVjaWFs
bHkgYXMNCj4gbW9zdCBWTXMgd29uJ3QgZXZlbiB1c2UgcGxhbmVzLCBzbyBpdCBsb29rcyBsaWtl
IHRoZXJlIGhhcyB0byBiZSBhIG1vcmUNCj4gb3Bwb3J0dW5pc3RpYyBtb2RlbCBmb3IgcGxhbmVz
IGFkZHJlc3Mgc3BhY2VzLg0KDQpXaGlsZSBhZHJlc3Mgc3BhY2VzIGFyZSBwZXIgVk0sIEtWTSBt
ZW1vcnkgYXR0cmlidXRlcyBhcmUgcGVyIHBsYW5lLiBJdA0Kc2hvdWxkIGJlIGVub3VnaCB0byBp
bXBsZW1lbnQgVlNNJ3MgbWVtb3J5IHByb3RlY3Rpb25zIGFzIHdlbGwgYXMgdGhlDQplbmNsYXZl
cyBkZXNpZ24geW91IG1lbnRpb25lZC4gV2UgaGF2ZSBhIHNlcmllcyBpbi1mbHV4IGltcGxlbWVu
dGluZyBSV1gNCm1lbW9yeSBhdHRyaWJ1dGVzIFsxXS4NCg0KVGhlIG9ubHkgdGhpbmcgdGhhdCdz
IG5vdCBmZWFzaWJsZSAibmF0dXJhbGx5IiB3aXRoIGF0dHJpYnV0ZXMgYXJlDQptZW1vcnkgb3Zl
cmxheXMgb3IgYW55IHNpdHVhdGlvbiB3aGVyZSB3ZSdkIG5lZWQgdG8gY2hhbmdlIHRoZSBiYWNr
aW5nDQptZW1vcnkgb2YgYSBndWVzdCBwaHlzaWNhbCBhZGRyZXNzIHJhbmdlIGp1c3QgZm9yIGEg
c2luZ2xlIHBsYW5lLiBGcm9tIGENClZTTSBwZXJzcGVjdGl2ZSBpdCdzIGZpbmUuIFRoZSBvbmx5
IHVzZS1jYXNlIGZyb20gYSBWU00gcGVyc3BlY3RpdmUgYXJlDQptZW1vcnkgb3ZlcmxheXMgKGFu
ZCB0aG9zZSwgZnJvbSBteSBleHBlcmllbmNlLCBhcmUgdXNlbGVzcykuIEkgZG9uJ3QNCmtub3cg
dGhhdCdzIGEgZGVhbC1icmVha2VyIHRoZSBtdXR1YWxseSBkaXN0cnVzdGluZyBtb2RlbC4NCg0K
Tmljb2xhcw0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjYwNzE2MTgxNDU2
LjQwMjc4Ni0xLXBib256aW5pQHJlZGhhdC5jb20v
