Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5020C1C27;
	Sat,  4 Feb 2023 08:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675498811; x=1707034811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZLgt5x8tpRobwdXoRLpzaHboQOtBR0ONuiBzMqYM6t8=;
  b=W0riniNw1LjpNI0tx9ERcVIEpWnazYaAwTjAkAUcutuvwRsImifgASTo
   khI1ci3VBRU6a9u/g5365NzNI5arM3pUEIgPKgx0SJ0LlYF68a5E09hyH
   vtJ4y3S5KqUJXdPYgWUGpCAepql1oy8XmIza+QPHvBOr/rdE1Iw+agE80
   3AuzjsJ/NEThjaKCRpB77Xw/3n86TkEtfFlIjc3V5+gtbCNwB6n3S5fYX
   EkNh7MLd3H/Hdyd0aJ9WvaoNpk/XAuPYzB+e6HQgrDRaYDiLptoxlQ8un
   iZE50hueSwC7VwKDpNjkmHFKNV7dNNc/lToE/YFXKFVqdBe2c4TlamzD3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="328944607"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="328944607"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 00:20:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="774598438"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="774598438"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 04 Feb 2023 00:20:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 00:20:05 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 00:20:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 00:20:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0ni+u95bc592ZzLGzA0XWgXKTajg0j/gVQwt9Id6pDHGZTaTHZZbpgZE/IZz3thtFJMg9kGhI3vMyI7I4k4rIxnWjeIwiQGhZUAuEbgO3u6iVxcULZ2TneLuGLR4nzM7IhbPhHcRE+OsgEDs6RC+3q/EeNewd90uq3blu6oiYn2QH3WQHxc68zzpg3had5NvCEon50Chqg8Sc2bMKiJzFPYMhVHwrYybD45QSTXpn2nOdxDdDRe0Ed5yzS824Fv845EbbQ0PeIzbj8A8bMKGxv6LEhs5PZdDWOnVNI+kVSeC/j2wE2jElK8OoNzikkAUOfQESMVf+Hnssw4FguKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLgt5x8tpRobwdXoRLpzaHboQOtBR0ONuiBzMqYM6t8=;
 b=DYpo/l0TLSOYA479ZglLv7x5l5dlnIH96fSHnVIESciE+VfeImlKMqr1bkUAVRoKsuZFSOtEvpTToCgIJi/+6Y7QEXaajP8k5TLVw62h1SlXk3DOKfM3u59nJ2E97qKHBgLsXOIBSi6pjfd0MkFdk0xI8vsvJpcwtH7pa/q8glNF3UYKrTOE7TxkQVnOkzVmJwlNGwSvl4wd6wHuoKhCyXCwXti6p0ZBiZk1PNjriJffcjUaqBu44VHN40eBIH8VOzBF6ngm7h6RHdvkcaOpRtn40CJn79MpXG4sVUSjvUGUsOnerQq9TJyiQeapsb9bLIAAMfD7m7J3a8m0uF4rag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by MN2PR11MB4741.namprd11.prod.outlook.com (2603:10b6:208:26a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 08:19:57 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::bc10:16cc:c241:c17e]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::bc10:16cc:c241:c17e%9]) with mapi id 15.20.6064.031; Sat, 4 Feb 2023
 08:19:56 +0000
From: "Chen, Jason CJ" <jason.cj.chen@intel.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "smostafa@google.com" <smostafa@google.com>,
	"dbrazdil@google.com" <dbrazdil@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Zhang, Tina" <tina.zhang@intel.com>, "Chen, Jason CJ"
	<jason.cj.chen@intel.com>
Subject: RE: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Topic: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Index: AQHZNj0Z75MJAroLaEu1t0w+O+6LDa67OeWAgAA1WQCAAQr18IAATCtAgABRGYCAAVvOwA==
Date: Sat, 4 Feb 2023 08:19:56 +0000
Message-ID: <SA1PR11MB592386F3AEC5111F1C8B3F07BFD49@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9uK4t1iAsmnuyyi@myrica>
 <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <SA1PR11MB5923FE1EFFA389E80E403C3FBFD79@SA1PR11MB5923.namprd11.prod.outlook.com>
 <Y9zuv6OnBEow/gf0@myrica>
In-Reply-To: <Y9zuv6OnBEow/gf0@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|MN2PR11MB4741:EE_
x-ms-office365-filtering-correlation-id: 19a59cb4-492b-4166-3696-08db068899a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MkQNgUKlYZ8Jv+teYS9iDuLxSzoqOBSd2jbLBD+1yQ3TwFgIkI/HqG6vW8z5DuogWKwW2xuxM4Y7RRFQ1MvG4Q0qgimcuYmDGbioW486WEoY1wDBsGlyyavS4evLC12LP5MYjhz+jA5efsR1B7M8ocYRv0nWCQuDuVYroEoxJiK6kBhdgNks/If0jp+tfhVpZroMDS2xupTsndQ/yM+nyWfyZTH6TQSc+OIocX37GgxvYRW6+7GWGjurtMD3aqyk7s6zTS+ljUXsp6KRRwDZm1bTDYnZEKoYFR0oGBVjej0KB/yT8X+5wnffoPjSGy+a3zwclv4S9+OMYP8wxv3EpPwiYfWZ+meFz5NotkwNb3WAl06OFtyV8Ko2Rcw/p2kJtJ+VNsUoPLzLiIFKx/z9KW0IT8gs7UMZjIz/rIKI6o1BD6qEIrtgQ2f2xxiBrBb3w6n5P0eUqlAfy0xhIJ4KwwTL2tCs2tLn45a9uda76pRzst7/PvOuv8kaDlSRaLLb2V9w8SQSp5KDyaWigKYslOak5yU1yoNenYGn9+6bFYWVrTKJZXhBZLUWvutp24vpYh6uHfCEXpw2o+6KVwzRUQ4p86fvfOUqrA1eprqx4ko/r/w0bHGYpNmhDg9SUIPO+K6h4LqwGGUuOHExiX9dP3kiPBaSY/9mpIYGvkXvYqZvWfvwaGBUwV4UjwB6dXraNkn82/Y6IMkvJ6VYnl4H0MXycFXtssaX1mkb5F/9ww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199018)(33656002)(7696005)(71200400001)(54906003)(107886003)(316002)(53546011)(6506007)(966005)(478600001)(7416002)(5660300002)(2906002)(8936002)(66446008)(64756008)(66476007)(66556008)(6916009)(4326008)(76116006)(66946007)(52536014)(8676002)(41300700001)(122000001)(38100700002)(38070700005)(86362001)(82960400001)(55016003)(26005)(9686003)(186003)(83380400001)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzd4QmxHU0dTZU1WNEUreWk5bS9hUTNHcmNaa1hlZnhNUDZJV1BzYm1wbU0v?=
 =?utf-8?B?ODh6TjBaM2d5cXZRQmgvOWRkYmVtbFFYMmdrWHhMbHRmMUNadnJncHRpWHBB?=
 =?utf-8?B?OHhuSVhwYkdUeU5aOWVUZWpmMzJQYzNvSzNZa0FHZ0F0U25lbWdlT1lteGxM?=
 =?utf-8?B?ZG5IWFVpSnZ1em5nRUgzakV4cFRPenMyRGttZXc3ZExYdG1Yc1hRa0puYUxE?=
 =?utf-8?B?cWQ3YzNOWm1VVVpoOHIwVlh0NXQrVnFadUFESDdjRXFsV0RSc1Qyd3pISjE0?=
 =?utf-8?B?dmRzem90NXprNHNWOWlSRGpNQXdrUGxNbTVndkxzWkd0c2FMaEd0NUhNRDVm?=
 =?utf-8?B?UkF1THBLSzMrYmQ4c1JCcmxEOGZkeVNQaEJUZkk4VFh6Y2VOSktvYmVLemxl?=
 =?utf-8?B?U0dPNHRrYndUdUptV2ZhTTh4ZE4zWFJSbU95SnBwYTJPSnJtZ1NRc04zdFFr?=
 =?utf-8?B?NC94dExES3lsTzc0d3JKQVZNVnRQMXhNeXBPN05Db2plTVFhbWJ1ZXVaL0c2?=
 =?utf-8?B?ZXBqWlhVVnJmSmR3RmRVSENHSDlCNXFaVUI0ZWhaekRJd1FoNWpUa3JCeEhu?=
 =?utf-8?B?WHF3akNOUnRCcnQ5MzZtK2pHK0txNFZMbFg4cjN1VkdyaEdYaFliNFo4MkdH?=
 =?utf-8?B?eWVwNFhYbzVyWlI5NVQvYnNUdm1rVnBEY1MzZFNXR21YVm5mY3dzZVkzQ1JY?=
 =?utf-8?B?dCtHV1NPYkc4QjN1UC9XWDVVSDJ6blVKcVdHL2U5RzlVM2ZKODF0TldsNTZS?=
 =?utf-8?B?ZDA3ZmZvSU13RDFSU1BQRkZBdHZrejl0SDc2T0pRWDZvRGtvdGtmSG9Uc1Bo?=
 =?utf-8?B?QU1BR3Ryd3RuRmxLZW54VkFEMXpqSHl1dXRONFJlVFV6N08vdnlRZXRqUzZH?=
 =?utf-8?B?YXpHQ1ZnaXp3aG11VVFHTkI4R25ya1JWNGl5NERtajhlVUp2TkVPeHBRbGxs?=
 =?utf-8?B?QmEwOFVoOEtrdGg4SmVUdjZKTlFCODNXL3ZhY0ZmNUcyYkowVEdVVzVYQW5z?=
 =?utf-8?B?dmlKUmw0S0JNL3IwTFJpYU5TU0VYVkx6eGhkdkpGYVFXNThOQUNVUnFWYUtB?=
 =?utf-8?B?Z0F6d2IrZEc4S0JIUjRPc0oxbjdocEdGbG8zcXV3cUdwR0tjSTMvUzJNbHBV?=
 =?utf-8?B?RHR2dU52dGNETlpMWUZ2QTljbTVPbURlaWY2cXRFUkZneTU0TldHMS9WaDc5?=
 =?utf-8?B?Uk9mRU9FWEtPdmFXS2xleTdYS1hSbWp2YWtqRldQNmw4VDJyRkp4Z2xraVRq?=
 =?utf-8?B?aUdleW1maW9YL0RVYjVXR1hJN3V0VkkyTlNXYnoxenBMZFNLeU1kV05yOWpo?=
 =?utf-8?B?NkJXL3FKYU5tbDVOcTFVN2xHTWs1aUZDaG5SSlNmeDA0RmRId1hsZWwxL2JH?=
 =?utf-8?B?dHRlNTJMNlZLdWE1TUxuc2pyMGM5dE9BaGQ0SVR4VjY5M2F5cUcyRldtUXQv?=
 =?utf-8?B?OGltUU1kbzB1S2tLVnFCY2VJVkVJMk90azlNVlJOWmJpRm9IeVNqVGxkOW10?=
 =?utf-8?B?dGFEZDUwOXhKQ1NlS3hqcW1FWFRTOVBwbWhqWW1hVUhLTXR2bEh6MnRtN29w?=
 =?utf-8?B?TU1Vc2tjYTRDQjl1S0x0N0haUTZLRGJOVXd0UFhuYnkwcnhaY01zWXdza2g0?=
 =?utf-8?B?bmQvQ3VPenpxWWhyOXJVYzlPOENXOFNQNG9pbElxYkZEbzg2TnlPTjdPZ2VT?=
 =?utf-8?B?dUVabGc1SXhUOUxMNFpuMUdZSXRNWk1tODZIS1Z5anAwYkFiUE1sM3ZUTXFM?=
 =?utf-8?B?eGUvaC9PQnl2UUFtQld6S3VCQ2JZU21kazdydCtRbEllazhkSUxkMHVGdmFT?=
 =?utf-8?B?bGc4Q1FnMmhyK3FIclAxNERGb1duOGVNNkpmMVdrYUpseXZPWkZPNW9DNllW?=
 =?utf-8?B?L3d5c2xnNHhCTTNVMUU0QldFSVNQMEp1dmpsRGMxejhOWTdzc0piNXZJQWJr?=
 =?utf-8?B?VkduTjc1Rm56ZERhTXZvYkVTWHlJUEZYTmpXaEhkeG8xTUsyZmNCa05WUUU5?=
 =?utf-8?B?MUc2dHlhc3E0bkV6R1lIcXAxdXhiWFMxbTRMTWxwZ1h3eTdRR204blUzQlhl?=
 =?utf-8?B?bGNiK0cwcW9JcW9LSlIyOFQzVnRGOXdvWTdJYWtwVVlZY01LU3dKaGVmb3BH?=
 =?utf-8?Q?i+QcEDGkxZXSMLRSc0UDnSM7D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a59cb4-492b-4166-3696-08db068899a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2023 08:19:56.5961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Ve7LQUz6p4ZLaIdwmDb5O3WWWff7uy6uf0BW7Fat+cAf4y+boJJ+xjBNjTSky1g76vZwJwKpzQC0DQswGYlsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4741
X-OriginatorOrg: intel.com

SGksIEplYW4sDQoNClRoYW5rcyBmb3IgdGhlIGluZm9ybWF0aW9uISBMZXQncyBkbyBtb3JlIGlu
dmVzdGlnYXRpb24uDQoNClllcywgaWYgdXNpbmcgZW5saWdodGVuIG1ldGhvZCwgd2UgbWF5IHNr
aXAgbmVzdGVkIHRyYW5zbGF0aW9uLiBNZWFudGltZSB3ZQ0Kc2hhbGwgZW5zdXJlIGhvc3Qgbm90
IHRvdWNoIHRoaXMgY2FwYWJpbGl0eS4gV2UgbWF5IGFsc28gbmVlZCB0cmFkZS1vZmYgdG8gc3Vw
cG9ydA0KU1ZNIGtpbmQgZmVhdHVyZXMuDQoNClRoYW5rcw0KDQpKYXNvbg0KDQo+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1w
aGlsaXBwZUBsaW5hcm8ub3JnPg0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDMsIDIwMjMgNzoy
NCBQTQ0KPiBUbzogQ2hlbiwgSmFzb24gQ0ogPGphc29uLmNqLmNoZW5AaW50ZWwuY29tPg0KPiBD
YzogVGlhbiwgS2V2aW4gPGtldmluLnRpYW5AaW50ZWwuY29tPjsgbWF6QGtlcm5lbC5vcmc7DQo+
IGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tOyB3aWxsQGtlcm5lbC5vcmc7IGpvcm9AOGJ5dGVzLm9y
ZzsNCj4gcm9iaW4ubXVycGh5QGFybS5jb207IGphbWVzLm1vcnNlQGFybS5jb207DQo+IHN1enVr
aS5wb3Vsb3NlQGFybS5jb207IG9saXZlci51cHRvbkBsaW51eC5kZXY7IHl1emVuZ2h1aUBodWF3
ZWkuY29tOw0KPiBzbW9zdGFmYUBnb29nbGUuY29tOyBkYnJhemRpbEBnb29nbGUuY29tOyByeWFu
LnJvYmVydHNAYXJtLmNvbTsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
OyBrdm1hcm1AbGlzdHMubGludXguZGV2Ow0KPiBpb21tdUBsaXN0cy5saW51eC5kZXY7IFpoYW5n
LCBUaW5hIDx0aW5hLnpoYW5nQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0gg
MDAvNDVdIEtWTTogQXJtIFNNTVV2MyBkcml2ZXIgZm9yIHBLVk0NCj4gDQo+IEhpIEphc29uLA0K
PiANCj4gT24gRnJpLCBGZWIgMDMsIDIwMjMgYXQgMDg6Mzk6NDFBTSArMDAwMCwgQ2hlbiwgSmFz
b24gQ0ogd3JvdGU6DQo+ID4gPiA+ID4gYnR3IHNvbWUgb2YgbXkgY29sbGVhZ3VlcyBhcmUgcG9y
dGluZyBwS1ZNIHRvIEludGVsIHBsYXRmb3JtLiBJDQo+ID4gPiA+ID4gYmVsaWV2ZSB0aGV5IHdp
bGwgcG9zdCB0aGVpciB3b3JrIHNob3J0bHkgYW5kIHRoZXJlIG1pZ2h0DQo+ID4gPiA+ID4gcmVx
dWlyZSBzb21lIGNvbW1vbiBmcmFtZXdvcmsgaW4gcEtWTSBoeXBlcnZpc29yIGxpa2UgaW9tbXUN
Cj4gPiA+ID4gPiBkb21haW4sIGh5cGVyY2FsbHMsIGV0Yy4gbGlrZSB3aGF0IHdlIGhhdmUgaW4g
dGhlIGhvc3QgaW9tbXUNCj4gPiA+ID4gPiBzdWJzeXN0ZW0uIENDIHRoZW0gaW4gY2FzZSBvZiBh
bnkgZWFybHkgdGhvdWdodCB0aGV5IHdhbnQgdG8NCj4gPiA+ID4gPiB0aHJvdyBpbi4g8J+Yig0K
PiA+ID4gPg0KPiA+ID4gPiBDb29sISBUaGUgaHlwZXJ2aXNvciBwYXJ0IGNvbnRhaW5zIGlvbW11
L2lvbW11LmMgd2hpY2ggZGVhbHMgd2l0aA0KPiA+ID4gPiBoeXBlcmNhbGxzIGFuZCBkb21haW5z
IGFuZCBkb2Vzbid0IGNvbnRhaW4gYW55dGhpbmcgc3BlY2lmaWMgdG8NCj4gPiA+ID4gQXJtIChp
dCdzIG9ubHkgaW4gYXJjaC9hcm02NCBiZWNhdXNlIHRoYXQncyB3aGVyZSBwa3ZtIGN1cnJlbnRs
eQ0KPiA+ID4gPiBzaXRzKS4gSXQgZG9lcyByZWx5IG9uIGlvLXBndGFibGUgYXQgdGhlIG1vbWVu
dCB3aGljaCBpcyBub3QgdXNlZA0KPiA+ID4gPiBieSBWVC1kIGJ1dCB0aGF0IGNhbiBiZSBhYnN0
cmFjdGVkIGFzIHdlbGwuIEl0J3MgcG9zc2libGUgaG93ZXZlcg0KPiA+ID4gPiB0aGF0IG9uIElu
dGVsIGFuIGVudGlyZWx5IGRpZmZlcmVudCBzZXQgb2YgaHlwZXJjYWxscyB3aWxsIGJlDQo+ID4g
PiA+IG5lZWRlZCwgaWYgYSBzaW1wbGVyIHNvbHV0aW9uIHN1Y2ggYXMgc2hhcmluZyBwYWdlIHRh
YmxlcyBmaXRzDQo+ID4gPiA+IGJldHRlciBiZWNhdXNlIFZULWQgaW1wbGVtZW50YXRpb25zIGFy
ZSBtb3JlIGhvbW9nZW5lb3VzLg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IHllcyBkZXBlbmRpbmcg
b24gdGhlIGNob2ljZSBvbiBWVC1kIHRoZXJlIGNvdWxkIGJlIGRpZmZlcmVudCBkZWdyZWUNCj4g
PiA+IG9mIHRoZSBzaGFyaW5nIHBvc3NpYmlsaXR5LiBJJ2xsIGxldCBKYXNvbi9UaW5hIGNvbW1l
bnQgb24gdGhlaXIgZGVzaWduDQo+IGNob2ljZS4NCj4gPg0KPiA+IFRoYW5rcyBLZXZpbiBicmlu
ZyB1cyBoZXJlLiBDdXJyZW50IG91ciBQT0Mgc29sdXRpb24gZm9yIFZULWQgaXMgYmFzZWQNCj4g
PiBvbiBuZXN0ZWQgdHJhbnNsYXRpb24sIGFzIHRoZXJlIGFyZSB0d28gbGV2ZWwgaW8tcGd0YWJs
ZSwgd2Uga2VlcA0KPiA+IGZpcnN0LWxldmVsIHBhZ2UgdGFibGUgZnVsbCBjb250cm9sbGVkIGJ5
IGhvc3QgVk0gKElPVkEgLT4gaG9zdF9HUEEpDQo+ID4gYW5kIHNlY29uZC1sZXZlbCBwYWdlIHRh
YmxlIGlzIG1hbmFnZWQgYnkgcEtWTSAoaG9zdF9HUEEgLT4gSFBBKS4gVGhpcw0KPiA+IHNvbHV0
aW9uIGlzIHNpbXBsZSBzdHJhaWdodC1mb3J3YXJkLCBidXQgcEtWTSBzdGlsbCBuZWVkIHRvIHBy
b3ZpZGUNCj4gPiB2SU9NTVUgZW11bGF0aW9uIGZvciBob3N0IChlLmcuLCBzaGFkb3dpbmcgcm9v
dC9jb250ZXh0LyBwYXNpZCB0YWJsZXMsDQo+IGVtdWxhdGluZyBJT1RMQiBmbHVzaCBldGMuKS4N
Cj4gDQo+IEkgZGlzbWlzc2VkIGVtdWxhdGluZyB0aGUgU01NVSBlYXJseSBvbiBiZWNhdXNlIGl0
IGZlZWxzIHRvbyBjb21wbGV4DQo+IGNvbXBhcmVkIHRvIGFuIGFic3RyYWN0ZWQgaHlwZXJjYWxs
IGludGVyZmFjZSwgYnV0IGFnYWluIHRoYXQgbWF5IGJlIGR1ZSB0bw0KPiB0aGUgaGlnaCB2YXJp
YXRpb24gb2YgY29uZmlndXJhdGlvbnMgb2YgdGhlIFNNTVUuIEZvciBuZXN0aW5nLCB5b3UgY291
bGQgdXNlDQo+IHNvbWUgb2YgdGhlIGludGVyZmFjZSB0aGF0IFlpIExpdSBhbmQgSmFjb2IgUGFu
IGhhdmUgYmVlbiB3b3JraW5nIG9uIFsxXS4gSXQNCj4gc2hvdWxkIGJlIHBvc3NpYmxlIHdpdGgg
YSBjb3VwbGUgb2YgYXR0YWNoLXRhYmxlIGFuZCB0bGItaW52YWxpZGF0ZSBoeXBlcmNhbGxzDQo+
IHRvIGF2b2lkIGVtdWxhdGluZyB0aGUgbG93LWxldmVsIHJlZ2lzdGVycyBhbmQgcXVldWVzLg0K
PiANCj4gPiBBcyBJIGtub3csIFNNTVUgYWxzbyBzdXBwb3J0IG5lc3RlZCB0cmFuc2xhdGlvbiBt
b2RlLCBtYXkgSSBrbm93DQo+ID4gd2hhdCdzIHRoZSBtb2RlIHVzZWQgZm9yIHBLVk0/DQo+IA0K
PiBJdCBkb2Vzbid0IHVzZSBuZXN0ZWQgdHJhbnNsYXRpb24gYmVjYXVzZSBpdCBpcyBvcHRpb25h
bCBpbiB0aGUgU01NVSwgYW5kIHRoaXMNCj4gc2VyaWVzIHRyaWVzIHRvIHN1cHBvcnQgYW55IHBv
c3NpYmxlIGltcGxlbWVudGF0aW9uLiBTaW5jZSBwS1ZNIG9uDQo+IGFybTY0IGlzIGJlaW5nIHVz
ZWQgb24gbW9iaWxlIHBsYXRmb3JtcyBJIHN1c3BlY3QgdGhhdCwgdG8gc2F2ZSBzcGFjZSwgc29t
ZQ0KPiBTTU1VcyBtaWdodCBub3QgaW1wbGVtZW50IGZpcnN0LWxldmVsIG9yIHNlY29uZC1sZXZl
bCBwYWdlIHRhYmxlcy4NCj4gQmVzaWRlcywgc3VwcG9ydGluZyBuZXN0aW5nIGZvciBBcm0gd291
bGQgc3RpbGwgcmVxdWlyZSBoeXBlcmNhbGxzIGZvciBwaW5uaW5nDQo+IERNQSBwYWdlcyAoc29s
dXRpb24gMikuDQo+IA0KPiBUaGlzIHNlcmllcyBwb3B1bGF0ZXMgdGhlIHNlY29uZC1sZXZlbCB0
YWJsZXMgd2l0aCB0aGUgY29tcGxldGUgSU9WQSAtPiBQQQ0KPiB0cmFuc2xhdGlvbiAoc2ltaWxh
cmx5IHRvIGhvdyBWRklPIHdvcmtzIGF0IHRoZSBtb21lbnQpLiBJZiBhbg0KPiBpbXBsZW1lbnRh
dGlvbiBvbmx5IHN1cHBvcnRzIGZpcnN0LWxldmVsIHRhYmxlcywgdGhlbiB0aGUgaHlwZXJ2aXNv
ciB3b3VsZA0KPiBvd24gaXQgYW5kIHB1dCB0aGUgSU9WQSAtPiBQQSB0cmFuc2xhdGlvbiBpbiB0
aGVyZS4NCj4gDQo+IFRoYW5rcywNCj4gSmVhbg0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LWlvbW11LzE1NzAwNDUzNjMtMjQ4NTYtMi1naXQtc2VuZC1lbWFpbC0NCj4g
amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20vDQo+ICAgICAoSXQncyBiZWluZyByZXdvcmtl
ZCBidXQgSSBjb3VsZG4ndCBmaW5kIGEgcmVjZW50IGxpbmspDQo+IA0KPiA+DQo+ID4gV2UgbWV0
IHNpbWlsYXIgc29sdXRpb24gY2hvaWNlcyB3aGV0aGVyIHRvIHNoYXJlIHNlY29uZC1sZXZlbA0K
PiA+IGlvLXBndGFibGUgd2l0aCBDUFUgcGd0YWJsZSwgIGFuZCBmaW5hbGx5IHdlIGFsc28gZGVj
aWRlZCB0byBpbnRyb2R1Y2UNCj4gPiBhIG5ldyBwZ3RhYmxlLCB0aGlzIGluY3JlYXNlIHRoZSBj
b21wbGV4aXR5IG9mIHBhZ2Ugc3RhdGUgbWFuYWdlbWVudCAtDQo+ID4gYXMgaW8tcGd0YWJsZSAm
IGNwdS1wZ3RhYmxlIG5lZWQgdG8gYWxpZ24gdGhlIHBhZ2Ugb3duZXJzaGlwLg0KPiA+DQo+ID4g
Tm93IG91ciBzb2x1dGlvbiBpcyBiYXNlZCBvbiB2SU9NTVUgZW11bGF0aW9uIGluIHBLVk0sIGVu
bGlnaHRlbg0KPiA+IG1ldGhvZCBzaG91bGQgYWxzbyBiZSBhbiBhbHRlcm5hdGl2ZSBzb2x1dGlv
bi4NCj4gPg0KPiA+IFRoYW5rcw0KPiA+IEphc29uIENKIENoZW4NCg0K
