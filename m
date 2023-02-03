Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F911863;
	Fri,  3 Feb 2023 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675413586; x=1706949586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ECoGMr772KofJBdgD1S1/3Yo5hWMGB9RayNmZ24EWEI=;
  b=bdRr7Fhcm9QdrxOFCoIUWOjobSCNEtab2MXKIkLzXE/KIyKEgHYEMzOV
   9m3G5TIfY4UjTfFGmOKzVgHoyqkV9RLVTa/QsuipnbCbVCpi8VmFG+M9+
   vupcTK0J5gF0phAJg8bLl4Coia+3SwXoNrIv4wG5Y9eTkBxmlZg8hNDdE
   eyImuIvC5IUgUVRdx8g2Ge4DhAPhE4RtrqZa2mUMDmtaO5gw0p48qphur
   dpBhbXSBTBWmFn5EYT/Un4qVrFcsWGuqRylFekLxhcjtRMH5d3ghFZI/D
   Cp7kdwR0ANlbbe5Sz8y4+HfdhIkw5vuV3SDwWPGmDqrO9Wsi7wfDwb2FW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="356035215"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="356035215"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:39:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="615633189"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="615633189"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2023 00:39:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:39:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:39:44 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:39:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqbcdcF1HhucZBiiChY0md54bi8dlS+abGNlEnccdy35arRso6IARtSNgg9jRLISisyiA1AO8RCzgyp24MmE+7msc9PkzDtIz7sc3w+NGvsYx59joL+onIeSSdAAKEW5i0JQuTVKaJ7moGTF72q2nZ8F4KedHCXFdVwih7N1gmon20iZn/K+4u3copUfbhx4fuqGsFpqPB6A4b5aWv7MZdx13rrTaKJYMyZV6ZMZO2A27mPzlAcIcU2bDZJP70txUMJiUSbqbxw79n+el8Tm2vinodBbOTTnxFZJsVXJwwU/Gj/BoNEI8a7omGEasP2q+BM1lE9gDgntHHdGs387uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECoGMr772KofJBdgD1S1/3Yo5hWMGB9RayNmZ24EWEI=;
 b=nSNkwe0+dqd7yFdyeoKhaXymootqkdBxSw3vBENtNZESPaJd26zt6QzeuNHdIxhUb731j06AK7tJuV4LNWLTgRP8M6G9EBUcsMSOXad+Ldi8sTziG6dyuTLoH8F0DZMzAanI8oN/AMvyQKvWonV1yLNSJrZCXghmQIeX8s8YTyAh2KBg5CuVVNmkIfIC8ek/MW/UZ/B8bOo5zoYbfCVrUb5vFuZ3J8xilVhbmOI86Yi1JOVMhaSQwnVsRIs60yrBrKL+GKkFh7nh57kf2oC7QigqcxNx32YBzSsRb9vybv6ClGTweyMAU2lEeWB795ZPSJeCPSMeygpdFiIsxDwnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by SJ0PR11MB5679.namprd11.prod.outlook.com (2603:10b6:a03:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 08:39:42 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::bc10:16cc:c241:c17e]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::bc10:16cc:c241:c17e%9]) with mapi id 15.20.6043.038; Fri, 3 Feb 2023
 08:39:41 +0000
From: "Chen, Jason CJ" <jason.cj.chen@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>
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
	"Zhang, Tina" <tina.zhang@intel.com>, "Chen, Jason CJ"
	<jason.cj.chen@intel.com>
Subject: RE: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Topic: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Index: AQHZNj0Z75MJAroLaEu1t0w+O+6LDa67OeWAgAA1WQCAAQr18IAATCtA
Date: Fri, 3 Feb 2023 08:39:41 +0000
Message-ID: <SA1PR11MB5923FE1EFFA389E80E403C3FBFD79@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9uK4t1iAsmnuyyi@myrica>
 <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|SJ0PR11MB5679:EE_
x-ms-office365-filtering-correlation-id: 691a1ab5-21bd-4053-b661-08db05c231b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQnnQ1199CDX06mlRV8k7LdoXy/jXxJSPmOaE26mX5pUAYY+VoMgatoPuz9lnU/ajfzGA+n6VEFrqg/WyY5TOMxL9J6KG3IAGCrrWR09Jd7bAH1ddybO+VGOa51tZPBzHrgi/EgPBhryLZ9y/uD6ZYgj54vJBoKKngdlyPdPn6c68OA9PnEkiAGBRVy3eodQrURWZ4uSzovQF47doiNdVDH4ySworrpx/DI2/avZeIAsEkB13Jl6h0DS64fLfvRucEGkJIXgddgkHz6pO/MGH8lRTZLBdVc4OkDnFh5dJEpJFaChVaXC3PEtzmbeSaP1PZKyosKB1ard9Wf1+wWH8dy429cR7GBndA0anwcco29M7TiBEVVWMPFSJCrSckwQp1Jij8cYNqDF/FWA+GR4i5ryCof1+KxlgWUFbO7mzdxX1DY2M8xlu764wC0bsoDOQe8Do89+TmNNmce+y+wbS99ptJzc1LFH1/klDxHbZNN9Ez2Xb+7NNprQ223VWTIVEZw1SCOaOaoJknyU2ieTYJdypxgcUaM2p+0dDN4w3U+ZV2BBMqI81BGtvt7eJHpNAywB9Q5EGw9fOOvWAAlVrN7OOYbF0sfpxcAg+Napj3Z0LicWStrKY6WjD8NN5xlyMOsW7RAPOZDc4i+XTLLWOScRSO0PnOdm02lmttPJqkHl2hvT58qeShHGTaoBsHrTOxR5JigtgDoDkQ5P556nNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199018)(76116006)(186003)(66476007)(8676002)(38100700002)(38070700005)(316002)(54906003)(5660300002)(122000001)(2906002)(110136005)(82960400001)(66446008)(7416002)(6506007)(52536014)(66556008)(64756008)(66946007)(41300700001)(4326008)(83380400001)(8936002)(53546011)(55016003)(9686003)(71200400001)(33656002)(107886003)(7696005)(478600001)(86362001)(66899018)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG93SEpQeVRxTVVsb3VFK2o2dE1ucW1uVGlnd0NTc2hmcW1vZ0k2ZHVKNmh0?=
 =?utf-8?B?SC9HUlRJOG5TcHZCa1l3NVFlV0N4Sjk3bGUrRHk5bFRwZzB0bEJzLzRPS1NK?=
 =?utf-8?B?cFk5Yy9PcXJOLzZVRlh4VU5Yc2FZYm1hcnEyaHhHRzVDRVVOcDQ1SjFMNkpS?=
 =?utf-8?B?eVRDa0I0enZkdjlpMDJHVXVib3YxNHF5eWd2OE5TcVBHdUdvU1hhS0NZRTYv?=
 =?utf-8?B?RXRRK2RpTlZIZGVpNEk4cUlOTjFWSXRxMFJ4REY4Y3hqZzdCZWE0U2tOeUhh?=
 =?utf-8?B?YndRWEk3RjVvRTU3aUVldlFoZytHa29KUzA3Y1pBSDR2K3UyNXA2NmtkZ3FE?=
 =?utf-8?B?WHE5TTRUZDNSVkxocC9lQVBHUzd4YXpRaTlkZ01JaVpzUFBqMk5sWFVqVDF3?=
 =?utf-8?B?anVYanZNeGg4bGZzQ2g2RW93MldnZFdmbEd4OW9KT0hYc3ZFTTE2OURHZ09Y?=
 =?utf-8?B?OXpQSy9iRG9MRmJ3Qis1S1Zoc29wa1dNdHNqdXNueVlkbzQxdmYzaHBlZ2oy?=
 =?utf-8?B?QlN2SlZLNjNTRitpRTRGdVNDNkxDVDR5Q1lKTC9VS3BucnVNYUREMEFvNzNK?=
 =?utf-8?B?MHpCRUpUZDlFalJEd1lQUjNxTHlyaFpoZTdQcTZJNXI5ZkVJaDc4QkxiMEhn?=
 =?utf-8?B?aHVJNzFhL25XUWg1NDFkYmZrTHZpM3c0bEQwNTJGYkVEUTluMmJsVWZuVXA3?=
 =?utf-8?B?TnozTG11WW5Ibm1vWTZiU05GcEJSNEdDeUlmNkVLTHQvK1NtbTl6Y2lhVXQ4?=
 =?utf-8?B?cjRMR1pWWFZaVHphWmZlVTRCYTZBVGg5dDFqb2padEgxMG1waWxxd21ESUNv?=
 =?utf-8?B?Nmxoanh1ZjRsajBoY0xVTDdNNUlYS0dCNU5vdkxZMmlxRzhEYjJmOGZvTDk5?=
 =?utf-8?B?WlRMSCtqTHNXeG9UaGcvMGxkSkI0Ukp2RkswRzV1RTQ5WTNEem9idzYvNURw?=
 =?utf-8?B?cmVzNE1hNldoRC9ucHdzSUFlVitTNkduelRJU2ZGMXZ1Q1RQbkw1VEVOVWxh?=
 =?utf-8?B?dklMME53RVM0YnU5Zmw4NVJsdWZlaUF2SEFtck0yZUhoMW5uSUNnVEN2UG10?=
 =?utf-8?B?WEY3d3NaU1BFZUZOWGZrQ3VVN01vWlNvWnNjbzJjVU02eUJFeElDK3lSWkFP?=
 =?utf-8?B?RUtuMnBxQm12alpVTWM1ZHc2eUxmWlBPQ2JsTmdKRDhSRzBFbmRyNHJRV3Vm?=
 =?utf-8?B?MTZ2NjNNTGJCUTNUMzhzQUFFR3hqUE8rdVJrc2toaEpyZElEZE9qaVd4bUtV?=
 =?utf-8?B?cGgycHJIMDRIb2VtZElqOWhacHRqSWpaeGtIcmY1VStiY2x5V2FldnR2WUhY?=
 =?utf-8?B?TjA4cE04NGRONklCZUF3UzROdndUc25TbVBCd09Jc3VsNzVPUXVjc0tGekRR?=
 =?utf-8?B?MDhtb0h4b0duOTNpdVdCWjdNLzFVcXFQeGs4aDg2WlVCV0dkdk93QnZLeVlJ?=
 =?utf-8?B?ZTRCRms1Z3E1c0x4bmI3TkNTeXlSZHFid2VUSldaaWxXb3JCZ0tFRFF0dFkw?=
 =?utf-8?B?UG1wbUlpOE03Zjd1VFJSWTNXaVNWWEMxR3dGQmwwSkhkRHZMUytjWGorUm02?=
 =?utf-8?B?Q0xFWTJWRC9yZ01scEx1SDBpRitaMHZqZzhKOGFTa08zZ2dmamZjUUozU3ll?=
 =?utf-8?B?WmZNdjFLR3g5ajFmRTJMU0d4VWpYb21KSE1McW9BU2ovamRqN2J1aVRRc01y?=
 =?utf-8?B?VEdXemYxYmFxT3NIZnc5WWw3YS9UYU9pQlh2SUYrdFhLeVRvZ0dyamNIVU9E?=
 =?utf-8?B?Z25OT1c1NHhmNVRJVWZySUN4bW5KTU1hUktlNC9VblFWY2VHSUt3M1J0SkZt?=
 =?utf-8?B?VEQ3cG00a1IzV1E3YVFLbnhWTVZjSjN2Z0FCbHVWbmQwOXhmeGZhUmE4eDBK?=
 =?utf-8?B?TnpScnFROUppczZFaEU0SG51L1R4d0dmRm92Wll1bUx3QzFqN3dscUdjZjE1?=
 =?utf-8?B?Wi9sN3E2YXRUQUhyaFdKTTFzQ1RRblA3VkN2bmZ1T0VoclpjVk9VWWpGWUNU?=
 =?utf-8?B?OXRSSDVPR0xBRUt3NXNFVWloWVYya0g2RUpHV3ptOS9MeERyK1laNUk0OWhB?=
 =?utf-8?B?eEVQYysxeDdqZFh0ZkhRcnJPSUlSK1gySnZNNm5tYks2THV5b0h2WHF3TWM2?=
 =?utf-8?Q?phlJ25kfG8D8rmxd0lgVAOi8a?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 691a1ab5-21bd-4053-b661-08db05c231b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 08:39:41.8375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /4/Ganqemrl4TqL8mglM0eJ16vhakInPPhcq/42FPu7svE+LiJwbcROokOry5NQ7p+U67VknCELN2ZdHQhpz2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5679
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgRmVicnVhcnkgMywgMjAyMyAxMDowNSBB
TQ0KPiBUbzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+
DQo+IENjOiBtYXpAa2VybmVsLm9yZzsgY2F0YWxpbi5tYXJpbmFzQGFybS5jb207IHdpbGxAa2Vy
bmVsLm9yZzsNCj4gam9yb0A4Ynl0ZXMub3JnOyByb2Jpbi5tdXJwaHlAYXJtLmNvbTsgamFtZXMu
bW9yc2VAYXJtLmNvbTsNCj4gc3V6dWtpLnBvdWxvc2VAYXJtLmNvbTsgb2xpdmVyLnVwdG9uQGxp
bnV4LmRldjsgeXV6ZW5naHVpQGh1YXdlaS5jb207DQo+IHNtb3N0YWZhQGdvb2dsZS5jb207IGRi
cmF6ZGlsQGdvb2dsZS5jb207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyBsaW51eC0NCj4gYXJtLWtl
cm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBrdm1hcm1AbGlzdHMubGludXguZGV2Ow0KPiBpb21t
dUBsaXN0cy5saW51eC5kZXY7IENoZW4sIEphc29uIENKIDxqYXNvbi5jai5jaGVuQGludGVsLmNv
bT47IFpoYW5nLA0KPiBUaW5hIDx0aW5hLnpoYW5nQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6
IFtSRkMgUEFUQ0ggMDAvNDVdIEtWTTogQXJtIFNNTVV2MyBkcml2ZXIgZm9yIHBLVk0NCj4gDQo+
ID4gRnJvbTogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+
DQo+ID4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDIsIDIwMjMgNjowNSBQTQ0KPiA+DQo+ID4g
T24gVGh1LCBGZWIgMDIsIDIwMjMgYXQgMDc6MDc6NTVBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3Jv
dGU6DQo+ID4gPiA+IEZyb206IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBs
aW5hcm8ub3JnPg0KPiA+ID4gPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDEsIDIwMjMgODo1
MyBQTQ0KPiA+ID4gPg0KPiA+ID4gPiAzLiBQcml2YXRlIEkvTyBwYWdlIHRhYmxlcw0KPiA+ID4g
Pg0KPiA+ID4gPiBBIGZsZXhpYmxlIGFsdGVybmF0aXZlIHVzZXMgcHJpdmF0ZSBwYWdlIHRhYmxl
cyBpbiB0aGUgU01NVSwNCj4gPiA+ID4gZW50aXJlbHkgZGlzY29ubmVjdGVkIGZyb20gdGhlIENQ
VSBwYWdlIHRhYmxlcy4gV2l0aCB0aGlzIHRoZSBTTU1VDQo+ID4gPiA+IGNhbg0KPiA+IGltcGxl
bWVudA0KPiA+ID4gPiBhDQo+ID4gPiA+IHJlZHVjZWQgc2V0IG9mIGZlYXR1cmVzLCBldmVuIHNo
ZWQgYSBzdGFnZSBvZiB0cmFuc2xhdGlvbi4gVGhpcw0KPiA+ID4gPiBhbHNvIHByb3ZpZGVzIGEg
dmlydHVhbCBJL08gYWRkcmVzcyBzcGFjZSB0byB0aGUgaG9zdCwgd2hpY2gNCj4gPiA+ID4gYWxs
b3dzIG1vcmUgZWZmaWNpZW50IG1lbW9yeSBhbGxvY2F0aW9uIGZvciBsYXJnZSBidWZmZXJzLCBh
bmQgZm9yDQo+ID4gPiA+IGRldmljZXMgd2l0aCBsaW1pdGVkIGFkZHJlc3NpbmcgYWJpbGl0aWVz
Lg0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIGlzIHRoZSBzb2x1dGlvbiBpbXBsZW1lbnRlZCBpbiB0
aGlzIHNlcmllcy4gVGhlIGhvc3QgY3JlYXRlcw0KPiA+ID4gPiBJT1ZBLT5IUEEgbWFwcGluZ3Mg
d2l0aCB0d28gaHlwZXJjYWxscyBtYXBfcGFnZXMoKSBhbmQNCj4gPiB1bm1hcF9wYWdlcygpLA0K
PiA+ID4gPiBhbmQNCj4gPiA+ID4gdGhlIGh5cGVydmlzb3IgcG9wdWxhdGVzIHRoZSBwYWdlIHRh
Ymxlcy4gUGFnZSB0YWJsZXMgYXJlDQo+ID4gPiA+IGFic3RyYWN0ZWQgaW50byBJT01NVSBkb21h
aW5zLCB3aGljaCBhbGxvdyBtdWx0aXBsZSBkZXZpY2VzIHRvDQo+ID4gPiA+IHNoYXJlIHRoZSBz
YW1lDQo+ID4gYWRkcmVzcw0KPiA+ID4gPiBzcGFjZS4gQW5vdGhlciBmb3VyIGh5cGVyY2FsbHMs
IGFsbG9jX2RvbWFpbigpLCBhdHRhY2hfZGV2KCksDQo+ID4gZGV0YWNoX2RldigpDQo+ID4gPiA+
IGFuZCBmcmVlX2RvbWFpbigpLCBtYW5hZ2UgdGhlIGRvbWFpbnMuDQo+ID4gPiA+DQo+ID4gPg0K
PiA+ID4gT3V0IG9mIGN1cmlvc2l0eS4gRG9lcyB2aXJ0aW8taW9tbXUgZml0IGluIHRoaXMgdXNh
Z2U/DQo+ID4NCj4gPiBJIGRvbid0IHRoaW5rIHNvLCBiZWNhdXNlIHlvdSBzdGlsbCBuZWVkIGEg
ZHJpdmVyIGZvciB0aGUgcGh5c2ljYWwNCj4gPiBJT01NVSBpbiB0aGUgaHlwZXJ2aXNvci4gdmly
dGlvLWlvbW11IHdvdWxkIG9ubHkgcmVwbGFjZSB0aGUgaHlwZXJjYWxsDQo+ID4gaW50ZXJmYWNl
IHdpdGggcXVldWVzLCBhbmQgSSBkb24ndCB0aGluayB0aGF0IGJ1eXMgdXMgYW55dGhpbmcuDQo+
ID4NCj4gPiBNYXliZSB2aXJ0aW8gb24gdGhlIGd1ZXN0IHNpZGUgY291bGQgYmUgYWR2YW50YWdl
b3VzLCBiZWNhdXNlIHRoYXQNCj4gPiBpbnRlcmZhY2UgaGFzIHRvIGJlIHN0YWJsZSBhbmQgdmly
dGlvIGNvbWVzIHdpdGggc3RhYmxlIEFQSXMgZm9yDQo+ID4gc2V2ZXJhbCBjbGFzc2VzIG9mIGRl
dmljZXMuIEJ1dCBpbXBsZW1lbnRpbmcgdmlydGlvIGluIHBrdm0gbWVhbnMgYQ0KPiA+IGxvdCBv
ZiBleHRyYSBjb2RlIHNvIGl0IG5lZWRzIHRvIGJlIGNvbnNpZGVyZWQgY2FyZWZ1bGx5Lg0KPiA+
DQo+IA0KPiB0aGlzIG1ha2VzIHNlbnNlLg0KPiANCj4gPiA+IElmIHllcyB0aGVuIHRoZXJlIGlz
DQo+ID4gPiBubyBuZWVkIHRvIGFkZCBzcGVjaWZpYyBlbmxpZ2h0ZW5tZW50IGluIGV4aXN0aW5n
IGlvbW11IGRyaXZlcnMuIElmDQo+ID4gPiBubyBwcm9iYWJseSBiZWNhdXNlIGFzIG1lbnRpb25l
ZCBpbiB0aGUgc3RhcnQgYSBmdWxsLWZsZWRnZWQgaW9tbXUNCj4gPiA+IGRyaXZlciBkb2Vzbid0
IGZpdCBuVkhFIHNvIGxvdHMgb2Ygc21tdSBkcml2ZXIgbG9naWMgaGFzIHRvIGJlIGtlcHQgaW4g
dGhlDQo+IGhvc3Q/DQo+ID4NCj4gPiBUbyBtaW5pbWl6ZSB0aGUgYXR0YWNrIHN1cmZhY2Ugb2Yg
dGhlIGh5cGVydmlzb3IsIHdlIGRvbid0IHdhbnQgdG8NCj4gPiBsb2FkIGFueSBzdXBlcmZsdW91
cyBjb2RlLCBzbyB0aGUgaHlwZXJ2aXNvciBwYXJ0IG9mIHRoZSBTTU1VdjMgZHJpdmVyDQo+ID4g
b25seSBjb250YWlucyBjb2RlIHRvIHBvcHVsYXRlIHRhYmxlcyBhbmQgc2VuZCBjb21tYW5kcyAo
d2hpY2ggaXMNCj4gPiBzdGlsbCB0b28gbXVjaCBmb3IgbXkgdGFzdGUgYnV0IHNlZW1zIHVuYXZv
aWRhYmxlIHRvIGlzb2xhdGUgaG9zdA0KPiA+IERNQSkuIExlZnQgaW4gdGhlIGhvc3QgYXJlIHRo
aW5ncyBsaWtlIEFDUEkvRFQgcGFyc2VyLCBpbnRlcnJ1cHRzLA0KPiA+IHBvc3NpYmx5IHRoZSBl
dmVudCBxdWV1ZSAod2hpY2ggaW5mb3JtcyBvZiBETUEgZXJyb3JzKSwgZXh0cmEgZmVhdHVyZXMN
Cj4gYW5kIGNvbXBsZXggb3B0aW1pemF0aW9ucy4NCj4gPiBUaGUgaG9zdCBhbHNvIGhhcyB0byBp
bXBsZW1lbnQgSU9NTVUgb3BzIHRvIGxpYWlzZSBiZXR3ZWVuIHRoZSBETUEgQVBJDQo+ID4gYW5k
IHRoZSBoeXBlcnZpc29yLg0KPiA+DQo+ID4gPiBhbnl3YXkganVzdCB3YW50IHRvIGNoZWNrIHlv
dXIgdGhvdWdodHMgb24gdGhlIHBvc3NpYmlsaXR5Lg0KPiA+ID4NCj4gPiA+IGJ0dyBzb21lIG9m
IG15IGNvbGxlYWd1ZXMgYXJlIHBvcnRpbmcgcEtWTSB0byBJbnRlbCBwbGF0Zm9ybS4gSQ0KPiA+
ID4gYmVsaWV2ZSB0aGV5IHdpbGwgcG9zdCB0aGVpciB3b3JrIHNob3J0bHkgYW5kIHRoZXJlIG1p
Z2h0IHJlcXVpcmUNCj4gPiA+IHNvbWUgY29tbW9uIGZyYW1ld29yayBpbiBwS1ZNIGh5cGVydmlz
b3IgbGlrZSBpb21tdSBkb21haW4sDQo+ID4gPiBoeXBlcmNhbGxzLCBldGMuIGxpa2Ugd2hhdCB3
ZSBoYXZlIGluIHRoZSBob3N0IGlvbW11IHN1YnN5c3RlbS4gQ0MNCj4gPiA+IHRoZW0gaW4gY2Fz
ZSBvZiBhbnkgZWFybHkgdGhvdWdodCB0aGV5IHdhbnQgdG8gdGhyb3cgaW4uIPCfmIoNCj4gPg0K
PiA+IENvb2whIFRoZSBoeXBlcnZpc29yIHBhcnQgY29udGFpbnMgaW9tbXUvaW9tbXUuYyB3aGlj
aCBkZWFscyB3aXRoDQo+ID4gaHlwZXJjYWxscyBhbmQgZG9tYWlucyBhbmQgZG9lc24ndCBjb250
YWluIGFueXRoaW5nIHNwZWNpZmljIHRvIEFybQ0KPiA+IChpdCdzIG9ubHkgaW4gYXJjaC9hcm02
NCBiZWNhdXNlIHRoYXQncyB3aGVyZSBwa3ZtIGN1cnJlbnRseSBzaXRzKS4gSXQNCj4gPiBkb2Vz
IHJlbHkgb24gaW8tcGd0YWJsZSBhdCB0aGUgbW9tZW50IHdoaWNoIGlzIG5vdCB1c2VkIGJ5IFZU
LWQgYnV0DQo+ID4gdGhhdCBjYW4gYmUgYWJzdHJhY3RlZCBhcyB3ZWxsLiBJdCdzIHBvc3NpYmxl
IGhvd2V2ZXIgdGhhdCBvbiBJbnRlbCBhbg0KPiA+IGVudGlyZWx5IGRpZmZlcmVudCBzZXQgb2Yg
aHlwZXJjYWxscyB3aWxsIGJlIG5lZWRlZCwgaWYgYSBzaW1wbGVyDQo+ID4gc29sdXRpb24gc3Vj
aCBhcyBzaGFyaW5nIHBhZ2UgdGFibGVzIGZpdHMgYmV0dGVyIGJlY2F1c2UgVlQtZA0KPiA+IGlt
cGxlbWVudGF0aW9ucyBhcmUgbW9yZSBob21vZ2VuZW91cy4NCj4gPg0KPiANCj4geWVzIGRlcGVu
ZGluZyBvbiB0aGUgY2hvaWNlIG9uIFZULWQgdGhlcmUgY291bGQgYmUgZGlmZmVyZW50IGRlZ3Jl
ZSBvZiB0aGUNCj4gc2hhcmluZyBwb3NzaWJpbGl0eS4gSSdsbCBsZXQgSmFzb24vVGluYSBjb21t
ZW50IG9uIHRoZWlyIGRlc2lnbiBjaG9pY2UuDQoNClRoYW5rcyBLZXZpbiBicmluZyB1cyBoZXJl
LiBDdXJyZW50IG91ciBQT0Mgc29sdXRpb24gZm9yIFZULWQgaXMgYmFzZWQgb24gbmVzdGVkDQp0
cmFuc2xhdGlvbiwgYXMgdGhlcmUgYXJlIHR3byBsZXZlbCBpby1wZ3RhYmxlLCB3ZSBrZWVwIGZp
cnN0LWxldmVsIHBhZ2UgdGFibGUgZnVsbCANCmNvbnRyb2xsZWQgYnkgaG9zdCBWTSAoSU9WQSAt
PiBob3N0X0dQQSkgYW5kIHNlY29uZC1sZXZlbCBwYWdlIHRhYmxlIGlzIG1hbmFnZWQgDQpieSBw
S1ZNIChob3N0X0dQQSAtPiBIUEEpLiBUaGlzIHNvbHV0aW9uIGlzIHNpbXBsZSBzdHJhaWdodC1m
b3J3YXJkLCBidXQgcEtWTSANCnN0aWxsIG5lZWQgdG8gcHJvdmlkZSB2SU9NTVUgZW11bGF0aW9u
IGZvciBob3N0IChlLmcuLCBzaGFkb3dpbmcgcm9vdC9jb250ZXh0Lw0KcGFzaWQgdGFibGVzLCAg
ZW11bGF0aW5nIElPVExCIGZsdXNoIGV0Yy4pLiANCg0KQXMgSSBrbm93LCBTTU1VIGFsc28gc3Vw
cG9ydCBuZXN0ZWQgdHJhbnNsYXRpb24gbW9kZSwgbWF5IEkga25vdyB3aGF0J3MgdGhlIA0KbW9k
ZSB1c2VkIGZvciBwS1ZNPw0KDQpXZSBtZXQgc2ltaWxhciBzb2x1dGlvbiBjaG9pY2VzIHdoZXRo
ZXIgdG8gc2hhcmUgc2Vjb25kLWxldmVsIGlvLXBndGFibGUgd2l0aCBDUFUNCnBndGFibGUsICBh
bmQgZmluYWxseSB3ZSBhbHNvIGRlY2lkZWQgdG8gaW50cm9kdWNlIGEgbmV3IHBndGFibGUsIHRo
aXMgaW5jcmVhc2UgdGhlDQpjb21wbGV4aXR5IG9mIHBhZ2Ugc3RhdGUgbWFuYWdlbWVudCAtIGFz
IGlvLXBndGFibGUgJiBjcHUtcGd0YWJsZSBuZWVkIHRvIGFsaWduDQp0aGUgcGFnZSBvd25lcnNo
aXAuDQoNCk5vdyBvdXIgc29sdXRpb24gaXMgYmFzZWQgb24gdklPTU1VIGVtdWxhdGlvbiBpbiBw
S1ZNLCBlbmxpZ2h0ZW4gbWV0aG9kIHNob3VsZA0KYWxzbyBiZSBhbiBhbHRlcm5hdGl2ZSBzb2x1
dGlvbi4NCg0KVGhhbmtzDQpKYXNvbiBDSiBDaGVuDQo=
