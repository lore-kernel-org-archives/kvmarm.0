Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E51F7C;
	Fri,  3 Feb 2023 02:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675389895; x=1706925895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HM4Imr2fS8Bs/eaglCxNuTO8ewwme4D8Jum9QWIT1g8=;
  b=MgMcrF8EeMG524Me8fTMgDn/+fEyKg1b5i0UefFZkaUvOmlFiTR1wta8
   2IXaznlvd+X9WgH5nqoY/bQzujNjA7+0by3ROfvVs2ZuECQNvyeV4bXSk
   RSenlSY5b3YS244q9SPJhkcNoVizFze/h90Ey8h3XSh4UeFdvwOHqZoMq
   DRov4f0X5dV+KlutHJtkYvnrUDRHhOMOfEhjsU6MxVkIFbSiFcpRnaBFX
   XESe05HYKVREuURZiRyVLE3A2TPLaPp3UcNTJSK5icI0zinpeJUkVJI00
   cCYXk6AMHv0t8tzheawa15rsihiMykXFLXt8Mr6sqzStmlJzPErv0a/s0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="327277286"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="327277286"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 18:04:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="695995770"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="695995770"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 02 Feb 2023 18:04:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 18:04:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 18:04:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 18:04:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVyq6IaPS9c9A+I7vcA/ZSXf4UJUOuF4C0N2IxYTmV+yZCrtQvKsR08puCfd+AoxhEiS5wi0POCYyqKaW9TySuzYngxmoIM+jszgev+/Sl0YiPJX8IPjmrapU70fMez9eLSUXWNQSzhKuYkOkSFloBcwuvneQH0uHMIrh7yxxAIzBXKz/LsL8OR2sJxt4cMRqCfhhSJP/eVfK/5coNySHYpg2BmWINOj/yz+fSf+mrCZpG4/pfYQIh4igDgskxWtzO4vAO69N2c6jSfHabhMSeZ40zy0TZRwBQVFuMARMtgVKZuE/A+G+oCTlbk7t1tr3uQI1Bm1HpM6Yv/MZDIVIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HM4Imr2fS8Bs/eaglCxNuTO8ewwme4D8Jum9QWIT1g8=;
 b=bOPolfAprMa3n3/YFZOzZyRyXTnebHeHoKX00h+ZsCfOoHezgMo1VzBVe54Z50GLFZbN5e53r/LzifDZ1c0KNvlp8fxntaRXNwk4BMo63VrXnjpepakiyYXhRMIZMngV1ZJnIou5epao6e4YkOskCq8C853SgLxtzdliZlu1R3EWgQo3NTdijTBmTWCiV8h4jjFfDohV/8OddYmMs1Jv6RUF66jHZUBD6DfuuMjdHdYnQY491C/MZNWomA0qwLUGnuxZXG6qgOSNIN5TEpVpWdvQ0oSaQUNV1UEoS8FeYLhI3boLqK37v+8SZFt1Ho/Dz4iU/z9kUV2GYE+QOwPFgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4745.namprd11.prod.outlook.com (2603:10b6:303:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 02:04:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 02:04:46 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"smostafa@google.com" <smostafa@google.com>, "dbrazdil@google.com"
	<dbrazdil@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Chen, Jason CJ" <jason.cj.chen@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
Subject: RE: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Topic: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Index: AQHZNj0Z75MJAroLaEu1t0w+O+6LDa67OeWAgAA1WQCAAQr18A==
Date: Fri, 3 Feb 2023 02:04:45 +0000
Message-ID: <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9uK4t1iAsmnuyyi@myrica>
In-Reply-To: <Y9uK4t1iAsmnuyyi@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4745:EE_
x-ms-office365-filtering-correlation-id: 3ae354d3-20c8-4e6b-cd7b-08db058b05e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kja6Us2G8DFs5F40PXyrbvXWuRuqL2MWgZFCYqEWwg7CfstMEfh6m5N1ULDmViC4PBsy9v14xZNjO1WmmhB4+t9maq5iORq+FTiQ1cr1FuxVf/IESH5/DTf3RzuwIOXnYxKa0jSMerZDZhKwmBvvSh25r2gHGysrHIZI4fq3PQGDGvm5kW9yXQeONrGUrgPSyzufVxb3/Ph/wsTPmtt+rr/WSIQFh/C31L1E3VzX8DEZxzCZVISIJY5HueHhpEzHJDHcevQorHx1qu9RteCmpB2Y1sdUN3v6Kjx4uk7z83ReS+2vHvuER4LUSslIMAaDP3H7N75x//Hq6JHhU5jVW5sj9P1AgPzsl1qTC/Gf49Lr78SjcDR2IgRO65A8iJNMCrzcKV187K+oRVVhX+Ro9jBVDOTjB7kgRqxLJuXVHnYpxhgreLUcPYhnVdWB/dnncPdjK/7QFT2w/Kv5QkPXRZVtPoBarpyP0ptpLB7reSxNNVgWdOs5UobNg8jHG5JdFhNYylH5ghs7Fc+5oW2es8uF+m68Ms56It1ttOgq84epIarx87sUbMT002Rj13NlRN7NlKZYkApvtXPEzDsOXjAIk85DFoJ8zt0eDSaIxeykg/FnH46s8Z4TiPzUJelywf3C66zprzHGjk4dQTuv3eQdp90sy4WLOboyOvYgpP0w6+GMHTN9m8N4KrxvgUe+cMASS7pv/XjIuwmTNdK/KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(82960400001)(2906002)(5660300002)(7696005)(7416002)(52536014)(6506007)(316002)(38070700005)(9686003)(26005)(66446008)(64756008)(66946007)(6916009)(66476007)(66556008)(86362001)(76116006)(33656002)(55016003)(8676002)(478600001)(4326008)(41300700001)(8936002)(107886003)(38100700002)(122000001)(54906003)(186003)(66899018)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXpSSU1tTllJY0J4bGNDWlZEL28weWxpYWJxSldrY1FRdkJiWDdQYnQ5WGp1?=
 =?utf-8?B?YVl3NlpPeGRSKzAvVnp4K0xVM3JjQjhkR0drbUd6bWJaazI5NE1KSGJHd1Yx?=
 =?utf-8?B?SXRoTWQ3ZjRHSCsvakowZHRpS0gvQ3VnM2ZCUGQ0Z2NvaytmRUQxUEFYQXY5?=
 =?utf-8?B?eEFuSzVGUG9Tc24vWVdIam5QY3Z2b0JXNHZnWUpzbkVoWEZCd24rQ3hXUGxm?=
 =?utf-8?B?b0ZONms0ajVPT2huRlpvUHdVaTJPc0trM2dLUHhXZXgvaHJQRjZyNmpzSU9P?=
 =?utf-8?B?eFd3cmo2SlZwRWtqYkI2KzM2SitEalVPZGxrY1BvbnpBaTVxTHBlQUcrMnNO?=
 =?utf-8?B?bHFEL0Z4VjdQdnIyOGNjRHZTWnl6MG9CS2xGVDkvTjFTekFFY3NmQW5VdC9Q?=
 =?utf-8?B?TDlMajhvMDEvbDc5b3QrUVc5RlNtL3I4ek5vMWdsOGJkVUszRzhlYUs4ZUQz?=
 =?utf-8?B?bjR4TDVtTGZ3ek9jZWg3ZEh3Rk5YWkMzYnJBREJSTlZZTnFSRHVEN2YyV0I1?=
 =?utf-8?B?RGJaNHhkTFlyVjVSQ0wzSk40NU40UFhydXN6NXFMdi82akZKVzhXQ1VQT3U3?=
 =?utf-8?B?cmZyK1UwWG83YW5VaS9xa1M3b2lUWnZaZUtwQ3NoR1dSazBCZnJ2cTVFR1lk?=
 =?utf-8?B?dkRnems2aURLSmgrWWRydVQxRE5IcXZyRmlWcHArMFIyeTlCZEZZa2ZReTNG?=
 =?utf-8?B?WEpjaUEzUjZob3loZ1Bja0h1TVdDU2JHWHBFT3RpRnYxYTRuN3JmdlRFd1Zh?=
 =?utf-8?B?Z1FWYitZSm15S2xjS3NiVTZQM3p0K3cyYTd0dk1TZUVBeDNwNmZZb1FpZHhx?=
 =?utf-8?B?Y3diVG1BMkxoMHV0Ky9tZGt5K1AyUXIrMGtnclNqT1N6bmVycEpubTN6N2oz?=
 =?utf-8?B?bFVFNDg4Tkg4dmtidURCeHdjOVVJVTNGUG5LbUFKVmNpbGRIM0swT1NnWEli?=
 =?utf-8?B?ekRYdEh1QkYrMENPV1puZmdZUzU4V0FZVE1PTFNsanpZOXZWSjlZZnVaN0xM?=
 =?utf-8?B?eVprS2JQVWRDSjlzTTF4RG5zOFlaTEVYMFRWM3RrUjZ4blYxR2tKeUl1b3F3?=
 =?utf-8?B?RFJwRXB4amJuRFY2OUU2UEJ1djUrLytaMkVqUXAyTkNteE92N3lwK05acFV0?=
 =?utf-8?B?bUxLUm9iSDRRSGoxUUc1aGdSam4rVldRTjNzR3pSdVRBT1NEOGhEZENZR1Vk?=
 =?utf-8?B?NmVQd1ZhazQzY0hZcUh0dmVmK0RUUStmQmZ0WDlkU2NPQng5TjNnSTAvU1Nm?=
 =?utf-8?B?Q1gzVSs1ZHlDQ0VMMzh2NTkvK05XUkY1alg2ZmdzYTBXRXQyT1VTNDBLaUxS?=
 =?utf-8?B?RkMvL1VSbHRKMThLeXpOM0JEcW1VWlN0ZUR3NW5QQXNIOTNjNTNHdnptY2Zo?=
 =?utf-8?B?UlpnbTNRYjRVcWxJMktvNnJJRWtPQVJmT3h0WlpWTzl1aXpZQk85djdqS01H?=
 =?utf-8?B?aFA0YjFzaEFSQ0s2WlJZVm85TFVxMEZZanlUVGhzYlFjeGRKQU5pQjFFR0xZ?=
 =?utf-8?B?STN3dHk5b1NGQ25DNHZSQ3VMR0xCMlNTcldWcmlzRzI1TzltN29mcHBmSTNj?=
 =?utf-8?B?QTV4QzFKN01pUUUzemFJcVhOUHVTNHF0WEdKeVg3dkJRM1pJNkllcUQrempI?=
 =?utf-8?B?NnJPaWJ1dFRlUmRrNkZCR1FtRTJYbFBKbVVCOG5FUTdTaTkvT0hvUzV6OU9i?=
 =?utf-8?B?bkJGKzdNU1ZyRTlYMUFSaUE1TXlKcVNWbDh3NkkyZkFhZ2o3Y2lVTGNSSzVX?=
 =?utf-8?B?U1hONHNPL1JXQ3kwT1dEZ001em9WS1ZXWW8vZXEzOW9oN3U4em12THpRSm9u?=
 =?utf-8?B?OFF3OTdscW1HcmJSaUZodHVKRWhsL25nMHMyejBQVE1YbmJONXh6OGNiSkd6?=
 =?utf-8?B?WXVtam1RZFpCcnA4bVlHdVZhTTk4R3FuQk9LTWkyVlc4MFZEcjBac0tzWWw1?=
 =?utf-8?B?MnpoL1BSb0ZoWSt4REJ5NDZBQndTblpmYTFZVnRwdy9MaXNxLzI2T2ZYYlpm?=
 =?utf-8?B?SGtHUGVESEFFSk5pRS9VbndGK3VZMjREczR2NDZpQjV5K3A3dkF4TG9VUHNx?=
 =?utf-8?B?dDJTZmh5MER5UGgwR2ZKR0E2ZFlaRWswMFRCS3Ywb0NOd05uY1g1Y01KQlJy?=
 =?utf-8?Q?k+n6RDBfueXnfJmkSsF43+jCJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae354d3-20c8-4e6b-cd7b-08db058b05e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 02:04:46.0102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NM5TeOVbK60ie+6dN3r3to5xu9ZBNGyMN8TOdi6QkjUdIBpzqnUyQrMgmly07lLadDbZiht6/QfIRmi9wRqpxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4745
X-OriginatorOrg: intel.com

PiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4N
Cj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDIsIDIwMjMgNjowNSBQTQ0KPiANCj4gT24gVGh1
LCBGZWIgMDIsIDIwMjMgYXQgMDc6MDc6NTVBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+
ID4gPiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9y
Zz4NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMSwgMjAyMyA4OjUzIFBNDQo+ID4g
Pg0KPiA+ID4gMy4gUHJpdmF0ZSBJL08gcGFnZSB0YWJsZXMNCj4gPiA+DQo+ID4gPiBBIGZsZXhp
YmxlIGFsdGVybmF0aXZlIHVzZXMgcHJpdmF0ZSBwYWdlIHRhYmxlcyBpbiB0aGUgU01NVSwgZW50
aXJlbHkNCj4gPiA+IGRpc2Nvbm5lY3RlZCBmcm9tIHRoZSBDUFUgcGFnZSB0YWJsZXMuIFdpdGgg
dGhpcyB0aGUgU01NVSBjYW4NCj4gaW1wbGVtZW50DQo+ID4gPiBhDQo+ID4gPiByZWR1Y2VkIHNl
dCBvZiBmZWF0dXJlcywgZXZlbiBzaGVkIGEgc3RhZ2Ugb2YgdHJhbnNsYXRpb24uIFRoaXMgYWxz
bw0KPiA+ID4gcHJvdmlkZXMgYSB2aXJ0dWFsIEkvTyBhZGRyZXNzIHNwYWNlIHRvIHRoZSBob3N0
LCB3aGljaCBhbGxvd3MgbW9yZQ0KPiA+ID4gZWZmaWNpZW50IG1lbW9yeSBhbGxvY2F0aW9uIGZv
ciBsYXJnZSBidWZmZXJzLCBhbmQgZm9yIGRldmljZXMgd2l0aA0KPiA+ID4gbGltaXRlZCBhZGRy
ZXNzaW5nIGFiaWxpdGllcy4NCj4gPiA+DQo+ID4gPiBUaGlzIGlzIHRoZSBzb2x1dGlvbiBpbXBs
ZW1lbnRlZCBpbiB0aGlzIHNlcmllcy4gVGhlIGhvc3QgY3JlYXRlcw0KPiA+ID4gSU9WQS0+SFBB
IG1hcHBpbmdzIHdpdGggdHdvIGh5cGVyY2FsbHMgbWFwX3BhZ2VzKCkgYW5kDQo+IHVubWFwX3Bh
Z2VzKCksDQo+ID4gPiBhbmQNCj4gPiA+IHRoZSBoeXBlcnZpc29yIHBvcHVsYXRlcyB0aGUgcGFn
ZSB0YWJsZXMuIFBhZ2UgdGFibGVzIGFyZSBhYnN0cmFjdGVkIGludG8NCj4gPiA+IElPTU1VIGRv
bWFpbnMsIHdoaWNoIGFsbG93IG11bHRpcGxlIGRldmljZXMgdG8gc2hhcmUgdGhlIHNhbWUNCj4g
YWRkcmVzcw0KPiA+ID4gc3BhY2UuIEFub3RoZXIgZm91ciBoeXBlcmNhbGxzLCBhbGxvY19kb21h
aW4oKSwgYXR0YWNoX2RldigpLA0KPiBkZXRhY2hfZGV2KCkNCj4gPiA+IGFuZCBmcmVlX2RvbWFp
bigpLCBtYW5hZ2UgdGhlIGRvbWFpbnMuDQo+ID4gPg0KPiA+DQo+ID4gT3V0IG9mIGN1cmlvc2l0
eS4gRG9lcyB2aXJ0aW8taW9tbXUgZml0IGluIHRoaXMgdXNhZ2U/DQo+IA0KPiBJIGRvbid0IHRo
aW5rIHNvLCBiZWNhdXNlIHlvdSBzdGlsbCBuZWVkIGEgZHJpdmVyIGZvciB0aGUgcGh5c2ljYWwg
SU9NTVUNCj4gaW4gdGhlIGh5cGVydmlzb3IuIHZpcnRpby1pb21tdSB3b3VsZCBvbmx5IHJlcGxh
Y2UgdGhlIGh5cGVyY2FsbCBpbnRlcmZhY2UNCj4gd2l0aCBxdWV1ZXMsIGFuZCBJIGRvbid0IHRo
aW5rIHRoYXQgYnV5cyB1cyBhbnl0aGluZy4NCj4gDQo+IE1heWJlIHZpcnRpbyBvbiB0aGUgZ3Vl
c3Qgc2lkZSBjb3VsZCBiZSBhZHZhbnRhZ2VvdXMsIGJlY2F1c2UgdGhhdA0KPiBpbnRlcmZhY2Ug
aGFzIHRvIGJlIHN0YWJsZSBhbmQgdmlydGlvIGNvbWVzIHdpdGggc3RhYmxlIEFQSXMgZm9yIHNl
dmVyYWwNCj4gY2xhc3NlcyBvZiBkZXZpY2VzLiBCdXQgaW1wbGVtZW50aW5nIHZpcnRpbyBpbiBw
a3ZtIG1lYW5zIGEgbG90IG9mIGV4dHJhDQo+IGNvZGUgc28gaXQgbmVlZHMgdG8gYmUgY29uc2lk
ZXJlZCBjYXJlZnVsbHkuDQo+IA0KDQp0aGlzIG1ha2VzIHNlbnNlLg0KDQo+ID4gSWYgeWVzIHRo
ZW4gdGhlcmUgaXMNCj4gPiBubyBuZWVkIHRvIGFkZCBzcGVjaWZpYyBlbmxpZ2h0ZW5tZW50IGlu
IGV4aXN0aW5nIGlvbW11IGRyaXZlcnMuIElmIG5vDQo+ID4gcHJvYmFibHkgYmVjYXVzZSBhcyBt
ZW50aW9uZWQgaW4gdGhlIHN0YXJ0IGEgZnVsbC1mbGVkZ2VkIGlvbW11IGRyaXZlcg0KPiA+IGRv
ZXNuJ3QgZml0IG5WSEUgc28gbG90cyBvZiBzbW11IGRyaXZlciBsb2dpYyBoYXMgdG8gYmUga2Vw
dCBpbiB0aGUgaG9zdD8NCj4gDQo+IFRvIG1pbmltaXplIHRoZSBhdHRhY2sgc3VyZmFjZSBvZiB0
aGUgaHlwZXJ2aXNvciwgd2UgZG9uJ3Qgd2FudCB0byBsb2FkDQo+IGFueSBzdXBlcmZsdW91cyBj
b2RlLCBzbyB0aGUgaHlwZXJ2aXNvciBwYXJ0IG9mIHRoZSBTTU1VdjMgZHJpdmVyIG9ubHkNCj4g
Y29udGFpbnMgY29kZSB0byBwb3B1bGF0ZSB0YWJsZXMgYW5kIHNlbmQgY29tbWFuZHMgKHdoaWNo
IGlzIHN0aWxsIHRvbw0KPiBtdWNoIGZvciBteSB0YXN0ZSBidXQgc2VlbXMgdW5hdm9pZGFibGUg
dG8gaXNvbGF0ZSBob3N0IERNQSkuIExlZnQgaW4gdGhlDQo+IGhvc3QgYXJlIHRoaW5ncyBsaWtl
IEFDUEkvRFQgcGFyc2VyLCBpbnRlcnJ1cHRzLCBwb3NzaWJseSB0aGUgZXZlbnQgcXVldWUNCj4g
KHdoaWNoIGluZm9ybXMgb2YgRE1BIGVycm9ycyksIGV4dHJhIGZlYXR1cmVzIGFuZCBjb21wbGV4
IG9wdGltaXphdGlvbnMuDQo+IFRoZSBob3N0IGFsc28gaGFzIHRvIGltcGxlbWVudCBJT01NVSBv
cHMgdG8gbGlhaXNlIGJldHdlZW4gdGhlIERNQSBBUEkNCj4gYW5kDQo+IHRoZSBoeXBlcnZpc29y
Lg0KPiANCj4gPiBhbnl3YXkganVzdCB3YW50IHRvIGNoZWNrIHlvdXIgdGhvdWdodHMgb24gdGhl
IHBvc3NpYmlsaXR5Lg0KPiA+DQo+ID4gYnR3IHNvbWUgb2YgbXkgY29sbGVhZ3VlcyBhcmUgcG9y
dGluZyBwS1ZNIHRvIEludGVsIHBsYXRmb3JtLiBJIGJlbGlldmUNCj4gPiB0aGV5IHdpbGwgcG9z
dCB0aGVpciB3b3JrIHNob3J0bHkgYW5kIHRoZXJlIG1pZ2h0IHJlcXVpcmUgc29tZSBjb21tb24N
Cj4gPiBmcmFtZXdvcmsgaW4gcEtWTSBoeXBlcnZpc29yIGxpa2UgaW9tbXUgZG9tYWluLCBoeXBl
cmNhbGxzLCBldGMuIGxpa2UNCj4gPiB3aGF0IHdlIGhhdmUgaW4gdGhlIGhvc3QgaW9tbXUgc3Vi
c3lzdGVtLiBDQyB0aGVtIGluIGNhc2Ugb2YgYW55IGVhcmx5DQo+ID4gdGhvdWdodCB0aGV5IHdh
bnQgdG8gdGhyb3cgaW4uIPCfmIoNCj4gDQo+IENvb2whIFRoZSBoeXBlcnZpc29yIHBhcnQgY29u
dGFpbnMgaW9tbXUvaW9tbXUuYyB3aGljaCBkZWFscyB3aXRoDQo+IGh5cGVyY2FsbHMgYW5kIGRv
bWFpbnMgYW5kIGRvZXNuJ3QgY29udGFpbiBhbnl0aGluZyBzcGVjaWZpYyB0byBBcm0gKGl0J3MN
Cj4gb25seSBpbiBhcmNoL2FybTY0IGJlY2F1c2UgdGhhdCdzIHdoZXJlIHBrdm0gY3VycmVudGx5
IHNpdHMpLiBJdCBkb2VzIHJlbHkNCj4gb24gaW8tcGd0YWJsZSBhdCB0aGUgbW9tZW50IHdoaWNo
IGlzIG5vdCB1c2VkIGJ5IFZULWQgYnV0IHRoYXQgY2FuIGJlDQo+IGFic3RyYWN0ZWQgYXMgd2Vs
bC4gSXQncyBwb3NzaWJsZSBob3dldmVyIHRoYXQgb24gSW50ZWwgYW4gZW50aXJlbHkNCj4gZGlm
ZmVyZW50IHNldCBvZiBoeXBlcmNhbGxzIHdpbGwgYmUgbmVlZGVkLCBpZiBhIHNpbXBsZXIgc29s
dXRpb24gc3VjaCBhcw0KPiBzaGFyaW5nIHBhZ2UgdGFibGVzIGZpdHMgYmV0dGVyIGJlY2F1c2Ug
VlQtZCBpbXBsZW1lbnRhdGlvbnMgYXJlIG1vcmUNCj4gaG9tb2dlbmVvdXMuDQo+IA0KDQp5ZXMg
ZGVwZW5kaW5nIG9uIHRoZSBjaG9pY2Ugb24gVlQtZCB0aGVyZSBjb3VsZCBiZSBkaWZmZXJlbnQg
ZGVncmVlDQpvZiB0aGUgc2hhcmluZyBwb3NzaWJpbGl0eS4gSSdsbCBsZXQgSmFzb24vVGluYSBj
b21tZW50IG9uIHRoZWlyIGRlc2lnbg0KY2hvaWNlLg0K
