Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90267F;
	Thu,  2 Feb 2023 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675321680; x=1706857680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fujvyjhd8ju/sF5BGaxVKJ5VAFNwTzkfglzv5n68M24=;
  b=VdSlLTiJG2jToezMA5m0yqLOa4TmvxJSD8AXsQJRPovvzIR6LexF77dc
   4yognDRqFbEUrWngA2Vo+HQxU1JvAvpHFh7zC0gj+MIH+dP4SUlkMpGx/
   /sy+0FOBsMgGp6ATIb9skipJqogbV9rzUp7nXZYe2UKMvqUw16FJVIbzj
   ma/PkYM37cLmtdqAGM+CFO2GtHDD+RRc7dxyIWSQNuLrIgrxMQ2IEIMqZ
   t9mQCTUVdjVnZS+riLgQBm5NOCJS1xNen84v7S9ggv602z/xdnEJglhvE
   VJvLjeT+pzBwJ2h9D1bqntR/eADw92MLijMXgye5CYqVB8TkZtVGOQ904
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="355710938"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="355710938"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 23:07:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="728736578"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="728736578"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2023 23:07:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 23:07:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 23:07:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 23:07:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 23:07:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/FUK9ubqm1ELI9EagN7XhRyPogboEGPIC+PWrgo0q/VyXmgaWhukoZFa/hdMUkKYD075b0MFBrD1hqa/JjpjSRiBzcbU9ZcMZew/YHWvxs2J60VO4G+6RgUlxSVNbyuQF+fBjy5KMf5cOFi9EF92NWaQUmLark9JBR1EBK8908NW4H4vffT+REp0yelK/VJdkIdnBg5E6o0BB7D6piM6z0vXQjl2saguly/wfGuKYcXygsQtd1ao5PQR2fnDbhQYm/u/Sevn8N4b6eXJYjwhUz5hx15Bl+vkJlLPR+dww4huMnhKIWoYKbHqguRspwpxbAMxzfkT4t788J6Ol4DSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fujvyjhd8ju/sF5BGaxVKJ5VAFNwTzkfglzv5n68M24=;
 b=MTCRUDRF/A4KcORQgZ5cenuTjApX1fsGMJD/X8F+praQzNtFxX8KYrAuN6ZtdtTfcQp/d6YTnDCIuTruNZ9qiNdgylLPtp6ZxoKO3gD/BbwXROzbMJeP71cDYkmDPeaPbNtFI0iVK/APn5dZR+3IYCJojMjwXK9IA2ckDUP4PGjg3eJQBJF5xdXFNgXKIxBNiIfXOTM6M81ncgz67LQDeGWGrPWQix7Y9pCaJodUaXNs+F8pJ50+F3/FruIIfOTSk95yJ61c7uuFjbsJHmwMMyWcN4Iw2Voq0bQk2s981kggHTGeQXdbZhls5ml0cR5wdO4IeJGgE6zkwtm9Ez1wOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 07:07:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 07:07:55 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, "maz@kernel.org"
	<maz@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>
CC: "robin.murphy@arm.com" <robin.murphy@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "smostafa@google.com" <smostafa@google.com>,
	"dbrazdil@google.com" <dbrazdil@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Chen, Jason CJ" <jason.cj.chen@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
Subject: RE: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Topic: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Thread-Index: AQHZNj0Z75MJAroLaEu1t0w+O+6LDa67OeWA
Date: Thu, 2 Feb 2023 07:07:55 +0000
Message-ID: <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6444:EE_
x-ms-office365-filtering-correlation-id: 967251f1-1062-4145-3d1b-08db04ec3556
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CR281o3j0vKLn1pmpLe2wGtZCtied/y8ZtrkjQiEb1MTP7L1OYIfe9noW9V8cM+SAy+sNCl1kBlkhrR4o/LwlW6TCJZ1tKe3qbLc0x6q73LWNfBZzFIRnyr2XQPiuL7uxK/FUgopwOhUd1wM/MmJzlP/A0kgB1QaIl8q6pGBCgWNFZOd/rr5do0gvSM1RL1cWLfbWz12njtOYZN2yV67MmaY9ZUKK5hzmEqmCPtCrWNTT6Ld8vBAyhlm08oH7w4AIQHriu2rjW0Qf71MK5rZl/d+N+ZGzXryimZtx7hejMMxGOHxVmrAX/i4487UYbfE/BnllqQPLPJs2ysvlJ8yteek6rVaFLLZlvLM3/Hv9z+1XUL5+io38wmZfHD9lznkqU4ztlSCPw7RnFjxo/EH+lGVmpWhiVuAzVYGUm6Rsi3QDFiBdL96xZ5n2z0k+6mhMC3P6Tu/WLagB6I/IHKjaLlhB9iR9yIjjfBXKDV/kH14E+ptLoK5V0YViLuv1Wwlz5Fmk7sf6rsxdSVv7pW/q5POQgb0g6CMhbYpUVgw8tpKvsLcEsPgfNWSpRb2Diqf/+JA+Wvg3TuzEvrSvEJ9dZoeMjPdlC3EhpTkFYshCWwxKVwvGXw8LSNSmyh+zeQcj3ZF8zLCiA5CnoIh8DlK6RtWUapJtsfybQffT9+Z3nvfwjn6M4o9gIZ5CrgfQknARC8TGhZvrimcgEjvspMUUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(54906003)(110136005)(4326008)(8676002)(316002)(55016003)(86362001)(41300700001)(38070700005)(76116006)(38100700002)(66556008)(82960400001)(66476007)(64756008)(66446008)(83380400001)(66946007)(122000001)(5660300002)(6506007)(478600001)(33656002)(7416002)(107886003)(52536014)(8936002)(71200400001)(7696005)(9686003)(26005)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGhHZ2p4NmFVbEs5Z2Y3YmxjeTJoelcvNUdyazNVb3kvVFZhNXdVNG45RENw?=
 =?utf-8?B?RmdGaUthR1NZRklOK2k0aEQ0aldMY0ZzMUhGN2J4bWZ5M0lmUTZQL1lBa1pY?=
 =?utf-8?B?aDBPeWZ0NTVCQXo2Ukd2WnZzdzJFRWtnZmUySURVMVlUWTIxV3NORm94VFhz?=
 =?utf-8?B?dDJmV013d2ptaWJPelF2UHJZK29kZlQ5K0RxZHp3TStVbnN1SVpnak5EVk44?=
 =?utf-8?B?OGtVSU9VeXdVV0pBRzBBYWlpSTVZQUVoRDF5MVg3b0NrVitadmVvNVFZYjdP?=
 =?utf-8?B?QjNpUk56Qm92Z3BhWUtLb1N6a2F2WVQxL1BYYzlIRVczczRzbFVVNGJmQTE4?=
 =?utf-8?B?ZS9GTnpEY1dHOTRLMTRuU0xnb3J3K1RZWUJPcU5tYnZVK3dQNmtmcWVnaW5G?=
 =?utf-8?B?djUrZGFoT1ZJUHJnSWJlWDRHWHFGdEJlWjcwdEhLaG04ZGF1ZGtCUU9DRnMy?=
 =?utf-8?B?SFdPSGdYOXdzQVExeS8yYVJENis2SVVqc2pvWEh0cDRJOXkvcXp4WWZXZ1h0?=
 =?utf-8?B?UUlWdzA0MUZHTDA0OHJZTktTN1JQVDlQYWJBR1hodFlnK3dWNVNiU0s0MEhC?=
 =?utf-8?B?RkxCazMxOVpNWDFpeVFLYWEyK04vY2VGU0J3OWZJaGFsWFlmbm0xTHQzeEta?=
 =?utf-8?B?bm9rYlg4ZDBzck82ZWxralo4S1N5dXF6YWZBN0pjbWRvV09ScENobkdSYzUv?=
 =?utf-8?B?VzJQMjkyZmV4V25Qb0locUk0RGlMc1pOYUxuZ2xCUDJmWGd2L1NyR1FmUEdR?=
 =?utf-8?B?S0M0YkRHVXFRNHoxbHNuUlhZdzVKT2ZVWDdJZ2xpWXJUL0o3ZmhFcmVoZlRx?=
 =?utf-8?B?ZURZNzMxVk5LdXQvd0h5SjFmaWRkQktYR3ZZK2cxOFF5Q1VsOWJtNlBBSEY1?=
 =?utf-8?B?eTN4eFlrcEpxUmJxVG5HTEd3SXN6OUFiU05aaEUxbmN2aXlvQ0QxT1hEUVk1?=
 =?utf-8?B?Y0NIcGZ3M2FIZ2xvQm5HaEhibmtlc201YnNadm14RjEwQkMwSTYzZDVvN0RU?=
 =?utf-8?B?M0wrbnA4MEVsaVExWWVmMTZsb1dKZjlyTUlISGkwbmNJcVRwc1lRcVA0aHAr?=
 =?utf-8?B?akxSZlJITno5MTE5L2ZEazRoL1FvR2dYMzZiMXFleVlxT3JmcUZKK1hMemlJ?=
 =?utf-8?B?cnN0ZU5hTXNsYzNGNmZGejdFRFVMcHliaCtreHJDVGJzelNzVm9tY3g0Q0dJ?=
 =?utf-8?B?MXhONnkrUnRwZUZXUGVudFZnT211L2l4anNZNnFBa0hGQmgxSWZ5NU1Ha04x?=
 =?utf-8?B?Ump3V1RXcERuTzYwdzNUcStKRExjRmI0bGFCYTlDLzQ2c3BYS2djb1NjZktE?=
 =?utf-8?B?MVJialRmVzZrM3BlZnBveEp1NWJXYnNQTHNrVFY5Q01Cd2V5QXRIcEdFcjdp?=
 =?utf-8?B?eGtXNFBuV1RUdzNEVXFCRWhSY1JiMTBlUERjVWYrSkpnZ094WFl5NVM1elF0?=
 =?utf-8?B?dlVBYXVsZXFlNDJMOStZMTFXellKVjVJRmRXd3JlclNFUmNJTWZVUlFiR2U0?=
 =?utf-8?B?UzdOSHlnWVd2cUtVU2p4U0RadVpaOHpnZHJZMWF5YWJhdWJwZjdncjhkdktZ?=
 =?utf-8?B?Skp1R1A4UHF5QUduK2hZWnQwOUxiZU8rQnFzb0JrZjZ5N1RoTFVINXBWOHdJ?=
 =?utf-8?B?QWhTVmVkcmt3L1RLc1lRZDN0RGJKdHhrc2FlNVdJa0dDRjNQN3dkQUszWWpo?=
 =?utf-8?B?cXc0UTNwQmRTVHNYTER4TzNsaG5IczBkT1c5TUJJWk1Dc3dwMUxIOTVqbFlO?=
 =?utf-8?B?SDh0b1B2dzNpZW8xRDZ3MDFzc0xJMFNxYk1RVFl0Q2Z1SXNyek95c2tncHRH?=
 =?utf-8?B?azgzS1BnSDVyMHcwcUdDYjg2QUhrVXF1bkFZdE5xSTdNb1NLVEJhbmZ5Ym1j?=
 =?utf-8?B?WjN2Z0hwOUkzbVZiVjRueEI2TTdBYUNZcmQvRzBEQ3FmTEVFS2RXbGJUMjBM?=
 =?utf-8?B?dWpBbUVLRFBjK0IyT0dkOTN5NUcrV3VaZ3VpeVVGejgyMUxLZUhFNC90aGtG?=
 =?utf-8?B?ZHo1UzU1NHg5WmYwUmVYb0wrNHFkellEUUhzdEpGTHRDaUpwVTloWU5XMTdr?=
 =?utf-8?B?UTVPKzhmN2l5cjZncU92ak9aRjVvWkF0eVg0aThDbEJDcmtGaVBBc3luVFZ5?=
 =?utf-8?Q?7BQ7vMNBaOoXzAyF2I/usl/Og?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 967251f1-1062-4145-3d1b-08db04ec3556
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 07:07:55.6381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXhLcNKguRx5lmrzyQR6zIVqdepHluffJDeoHlGrfFFMRu7WEbBnKe6qYjCHxNLKpD9MKHVSKUGge3x6+8zOjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com

PiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4N
Cj4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAxLCAyMDIzIDg6NTMgUE0NCj4gDQo+IDMuIFBy
aXZhdGUgSS9PIHBhZ2UgdGFibGVzDQo+IA0KPiBBIGZsZXhpYmxlIGFsdGVybmF0aXZlIHVzZXMg
cHJpdmF0ZSBwYWdlIHRhYmxlcyBpbiB0aGUgU01NVSwgZW50aXJlbHkNCj4gZGlzY29ubmVjdGVk
IGZyb20gdGhlIENQVSBwYWdlIHRhYmxlcy4gV2l0aCB0aGlzIHRoZSBTTU1VIGNhbiBpbXBsZW1l
bnQNCj4gYQ0KPiByZWR1Y2VkIHNldCBvZiBmZWF0dXJlcywgZXZlbiBzaGVkIGEgc3RhZ2Ugb2Yg
dHJhbnNsYXRpb24uIFRoaXMgYWxzbw0KPiBwcm92aWRlcyBhIHZpcnR1YWwgSS9PIGFkZHJlc3Mg
c3BhY2UgdG8gdGhlIGhvc3QsIHdoaWNoIGFsbG93cyBtb3JlDQo+IGVmZmljaWVudCBtZW1vcnkg
YWxsb2NhdGlvbiBmb3IgbGFyZ2UgYnVmZmVycywgYW5kIGZvciBkZXZpY2VzIHdpdGgNCj4gbGlt
aXRlZCBhZGRyZXNzaW5nIGFiaWxpdGllcy4NCj4gDQo+IFRoaXMgaXMgdGhlIHNvbHV0aW9uIGlt
cGxlbWVudGVkIGluIHRoaXMgc2VyaWVzLiBUaGUgaG9zdCBjcmVhdGVzDQo+IElPVkEtPkhQQSBt
YXBwaW5ncyB3aXRoIHR3byBoeXBlcmNhbGxzIG1hcF9wYWdlcygpIGFuZCB1bm1hcF9wYWdlcygp
LA0KPiBhbmQNCj4gdGhlIGh5cGVydmlzb3IgcG9wdWxhdGVzIHRoZSBwYWdlIHRhYmxlcy4gUGFn
ZSB0YWJsZXMgYXJlIGFic3RyYWN0ZWQgaW50bw0KPiBJT01NVSBkb21haW5zLCB3aGljaCBhbGxv
dyBtdWx0aXBsZSBkZXZpY2VzIHRvIHNoYXJlIHRoZSBzYW1lIGFkZHJlc3MNCj4gc3BhY2UuIEFu
b3RoZXIgZm91ciBoeXBlcmNhbGxzLCBhbGxvY19kb21haW4oKSwgYXR0YWNoX2RldigpLCBkZXRh
Y2hfZGV2KCkNCj4gYW5kIGZyZWVfZG9tYWluKCksIG1hbmFnZSB0aGUgZG9tYWlucy4NCj4gDQoN
Ck91dCBvZiBjdXJpb3NpdHkuIERvZXMgdmlydGlvLWlvbW11IGZpdCBpbiB0aGlzIHVzYWdlPyBJ
ZiB5ZXMgdGhlbiB0aGVyZSBpcw0Kbm8gbmVlZCB0byBhZGQgc3BlY2lmaWMgZW5saWdodGVubWVu
dCBpbiBleGlzdGluZyBpb21tdSBkcml2ZXJzLiBJZiBubyANCnByb2JhYmx5IGJlY2F1c2UgYXMg
bWVudGlvbmVkIGluIHRoZSBzdGFydCBhIGZ1bGwtZmxlZGdlZCBpb21tdSBkcml2ZXIgDQpkb2Vz
bid0IGZpdCBuVkhFIHNvIGxvdHMgb2Ygc21tdSBkcml2ZXIgbG9naWMgaGFzIHRvIGJlIGtlcHQg
aW4gdGhlIGhvc3Q/DQphbnl3YXkganVzdCB3YW50IHRvIGNoZWNrIHlvdXIgdGhvdWdodHMgb24g
dGhlIHBvc3NpYmlsaXR5Lg0KDQpidHcgc29tZSBvZiBteSBjb2xsZWFndWVzIGFyZSBwb3J0aW5n
IHBLVk0gdG8gSW50ZWwgcGxhdGZvcm0uIEkgYmVsaWV2ZQ0KdGhleSB3aWxsIHBvc3QgdGhlaXIg
d29yayBzaG9ydGx5IGFuZCB0aGVyZSBtaWdodCByZXF1aXJlIHNvbWUgY29tbW9uDQpmcmFtZXdv
cmsgaW4gcEtWTSBoeXBlcnZpc29yIGxpa2UgaW9tbXUgZG9tYWluLCBoeXBlcmNhbGxzLCBldGMu
IGxpa2UgDQp3aGF0IHdlIGhhdmUgaW4gdGhlIGhvc3QgaW9tbXUgc3Vic3lzdGVtLiBDQyB0aGVt
IGluIGNhc2Ugb2YgYW55IGVhcmx5DQp0aG91Z2h0IHRoZXkgd2FudCB0byB0aHJvdyBpbi4g8J+Y
ig0KDQpUaGFua3MNCktldmluDQo=
