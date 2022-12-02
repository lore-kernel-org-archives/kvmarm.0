Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ABFC47090
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 12:59:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACEF40BED;
	Fri,  2 Dec 2022 07:59:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g7ljYqAH4dY2; Fri,  2 Dec 2022 07:59:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A540749E4B;
	Fri,  2 Dec 2022 07:59:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC1E40CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 07:59:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I3Gd7Y+rlzIH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 07:59:26 -0500 (EST)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD88B40BED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 07:59:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1669985965; x=1701521965;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=Y57nduZJ/KnCsYoa25EcTNImNFv7hA7gbKPEVW0u2B8=;
 b=B4/7rx7Y5e/WJ/6agrxxqzdfsoV3GLBVHTB4pJxOK4i6i+g/qFhslIMo
 qBDCGPzBgofDF+Rq9wpSbO9pX2oKLAHsxOWbwlvCQWDzapddCr5ZIbWfL
 jZu6KOOPa+Zim29Sobv9MkjOIvLUgXFVnZ9GHuIepAFxRKQ74J5iFp6FM
 JsvHsYtdqffIS/BJYc1SO+4khfzx1jn5qeh1yiy5pLvuMOPJT1dlV/2Ge
 scy3wB33dChNGvJKZxFCARxdlhADBLRv8h28dbI68Wn1tUW4zoX6IZ8iF
 VA+TS/DMmip4mT9cTvyttVShKfKZfzs7eKz/5DNg1DunnWQ/LUKOELw/+ g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315974581"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="315974581"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Dec 2022 04:59:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638744065"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="638744065"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 04:59:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 04:59:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 04:59:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 04:59:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST7vJ6slVCnrTkS92Zj/FSz7aL3+bJB20/k0cZW4XErsgnSe5L80eG5MD7bU2W/ClvnXCLGsh9RMDKRSCSUwyMbFHH6zL2XJJWhZjDCUPdNkzP7dFVn+nBMPtKjXksyt02TDYX63mV+3D4wXqH/Xe9bIEXd3+TtcecQn39iG2Tgn5yDu7HUv8izQtjYjKy03ee+4mtyzSC2nznGNRiz+CG5KGYT6RmxXPTAQKh8CWtnf1ULKnWm/6T58L/ewVszYdJZ6/rSDUT8+CjqsGd+qdAaxjQFmWyeGet9EEGGLcncnytpFE8pv+Oa9Wrr+WYgsr5DLlxah4ragqaf1KqpQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y57nduZJ/KnCsYoa25EcTNImNFv7hA7gbKPEVW0u2B8=;
 b=La4d9ubClC1jAgz3B+Ie+xeXyUjf2s/tPKlmqCfuV+hWHJjKhuQMeKevSPGOqkJc8r+Mqs+usoKXCfKicaOvTS/yVsUOFTmeKi9f6vL3i6ZQ29Cx18/MaPLZ+Pix9bNc6XaxygxQg9lDPwV1QLO3e8ITFxSCduSho6vJYdxG1mZ/zAbtqq6+iiYBfKA0LhzY+H8C1MgDjxNiOlakclW9Ot7ykmrjFnjanfoUGXoXnyxVhz8gXa8wktZ83fqtExKBAHN53lZyXFitWrxaQsE2B+YLp3EZdnntB02rclMrdMqL/UtDS79YE8LEAdivDb/dYiucHlhelRe4EO3iGP2g1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6394.namprd11.prod.outlook.com (2603:10b6:208:3ad::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 12:59:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 12:59:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "maz@kernel.org"
 <maz@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "farman@linux.ibm.com" <farman@linux.ibm.com>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "Christopherson,, Sean" <seanjc@google.com>, "paul.walmsley@sifive.com"
 <paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "dwmw2@infradead.org" <dwmw2@infradead.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "paul@xen.org"
 <paul@xen.org>, "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>, "anup@brainfault.org"
 <anup@brainfault.org>
Subject: Re: [PATCH v2 42/50] KVM: Disable CPU hotplug during hardware
 enabling/disabling
Thread-Topic: [PATCH v2 42/50] KVM: Disable CPU hotplug during hardware
 enabling/disabling
Thread-Index: AQHZBREJrC/cMYL66UyZW4tPjPbYXq5akY8A
Date: Fri, 2 Dec 2022 12:59:02 +0000
Message-ID: <8b1053781e859aa95a08c10b0e8a06912a2b42a2.camel@intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-43-seanjc@google.com>
In-Reply-To: <20221130230934.1014142-43-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6394:EE_
x-ms-office365-filtering-correlation-id: 502c7b12-9880-4a37-9254-08dad464fc66
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PeGKPdhdn9NEmZyXrYYhpPW+HYSwujBEj8H2bvWaUs6TE2lXQZ6PkM63ycyAo5YT5+b8QJ+62USGuMHEkGCfyUAM2Ha6Kn4sWRST5o6z5+zoHS8Nl767R3AlgeJqBRFKnriPNEkRJXhnCFFzres3TqvlgZUc8bfki+OQNXEPlUPYXnt06tm7mM0CR7mQ1YkrSeQ6IBQk1DFhqangs+RiEyPQt3we77wSQKyKxbsKC7FSVKQ/UQTMs6wLFQiNvTDm495w7n91ZcpLGuBERmQhXzTyX0EhNI8QoZNnM8oHMgbNa5TK2132WaAvmChnVMMOncl+dUKRq8m4i26OMFWWviTzyynlb+TzNFVL/lFJySeOYEDe+S+u9J3Fak5DlY9bT7z4I9ZbBhR1tpuEP5L3oEmPcebRq5WOHVhpYyK7AmwYOy1v9KBQhRgV7bE04hEmY5PqCZdh1Sy2McC74CCnzqGQXqsZJP84krRxhWnVS5/xmRJFdfuPN2BklUTjRS81LKppNHG4krDvl7JpiTA5GCZy5lJ3UovkxcUBLo73REZgUBqgUkuGdKU7Dvqp6vkMGqGRlX33OJr9+kxjIoWUcF7pmzYokMkZIYgAaXKfrxj6UYCynqjhM3ceayVOX7mDCv1JuWYBp4hOxWOIeLzeMlx72zOJ9pzPZT1secD4AxR0X1z8t/Pj1R7yXuW2+KLGFDVGPmL1bBOloqNEW9UjJ/DD4q6n8vRTpyYnWcvkLsc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(186003)(26005)(71200400001)(6506007)(64756008)(66476007)(8676002)(76116006)(66556008)(478600001)(107886003)(66446008)(6486002)(91956017)(66946007)(4326008)(2616005)(41300700001)(5660300002)(8936002)(7406005)(7416002)(83380400001)(2906002)(4001150100001)(38100700002)(122000001)(82960400001)(36756003)(6512007)(316002)(66899015)(86362001)(54906003)(110136005)(921005)(38070700005);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzRoUElXUFV1SzEzak5UMnNzamVsdzJTdW5sZlR3b1lGYnQ3alVWTlJEUHBn?=
 =?utf-8?B?RmUvRDNFYW0wTGZkak5lNHAzeTFMUUFUMHoxSFNsaExHRFVSSnZRanJHYkx0?=
 =?utf-8?B?TW1ubjVkQUpFajBGbzlwenR3Y1JkMDVGdVJjL1kxellkLzZDUzRYS29qNHZU?=
 =?utf-8?B?WDBqWWhRbzhlaVU1K0c1eDNuaEJZaWV2MjUzSkdDb0swZ1ZLZDY2R1pUUnlz?=
 =?utf-8?B?aDR4Q2hVZUV5eHQyTzc2bHNhRFJYTm0wNnk0REdpUE1DaCtKUmExZVE2SkRr?=
 =?utf-8?B?OWxMZDhtSUFLcVhpMUlSc2ZzZlkwMjhuQVRtUHBiRy8yVHowNXNxRnREZUNB?=
 =?utf-8?B?RjlLTmFGTXBxV004MlJJaFBxVTNtdkR3UUtueDJZQkt5VGxxazVHZjdKTGJW?=
 =?utf-8?B?SDZoaHN0bFRwSWMvcUpoeUV6b0h2TG9Xa3l6VHdZTTE4cm9nMElZOE5kNDM4?=
 =?utf-8?B?L0pWbVBRSGUwaVlUTzlkVy9oRWZYRWFuSVZtWGxZYk9Kc0xSRnBBYmtYL2FI?=
 =?utf-8?B?WEJFRk1NcUx0eDNCQWFHdDhISStkUXJ2eUw2cSt6T2k0NkxNMExrU0V1R1Js?=
 =?utf-8?B?MXI5Q1BQUzBpMjliRTk5NHVMR1N0eEN1ZGtYbSt1UDVkb0lnR0ZSL2N3SU9j?=
 =?utf-8?B?aXlhVnhEbWhIcHRSdkpPOFZ0RjY0NHUvQTNJc3FMenRhc25pYkhkNmlpdXho?=
 =?utf-8?B?aTJpdDl5QUtFN2E5Z29TMEw3YkxIZlFOSVlWUnFnUkpyMnV4aXhobjQxNXBR?=
 =?utf-8?B?YWVZNm9YazVrZ1N0c09KVzNwWnZOTHpEeFRGWHkyUzBYWm1GUHZhNDdiZ0U1?=
 =?utf-8?B?Y0lZMWdsVVpPVmt0OWk0V1JNeWRCOWlnK01qdTZiTXZjeGxHTUJDalJZWjk1?=
 =?utf-8?B?Tm4wRVh5STRld0VLdytqam1laDhzUVE2L1V3RDQ4RFFTWUd6enVjWEV5TU5o?=
 =?utf-8?B?ZTd6a0p5d3R6V0xmT1BFY0JZem1tOFRBQnErK0RPVG0xMDBUQWJOa1dCSUVX?=
 =?utf-8?B?S2NqQ2F0Zi9RbXVzazkvUTNGcWl3WDNCMC9RSkVDb2xzQStLY1BhcW9HTE1w?=
 =?utf-8?B?Z0ZPRUV4b2JUUWhqNUg2dXVrWDFjNjhhbDJQZjVXblJOemJBWDhTNDdZa05D?=
 =?utf-8?B?SFdyS1lZSkQ5ZFZpWG9iQXpGU0Q2M3NueWUwQlJTc3lOMEljYk05VzhhRjdI?=
 =?utf-8?B?MjdrY3JNZDJuR2JQZ2Y0dVJwZnRUdGxrakltb1dGQkNRSW5CcGp2UW5vL2lQ?=
 =?utf-8?B?d0dzZ3BtU3BrSW9qMmV4a0hvaG8zZEgyR0orZUs3Zk1hdlNiODAzbFVwMjJh?=
 =?utf-8?B?eVh1a1VhZktaTThHc05yQ3RVWmVFcXE4ZnRNM3hOcWFkb3ZDUTE5azJYL1E0?=
 =?utf-8?B?bWJhangvNi8yaWVHemZsb0J3TWFlZW9nQm9sM1NyV2NGTmlXUFp1VGNDUEJt?=
 =?utf-8?B?cjNlbGNvNkpPV09UMDZRdmRBTGlTdFUvTzIzY1E1S0JhVzdPV1JVT1JIL2Fl?=
 =?utf-8?B?ZTdoYjBmTlVneW1jdGtTK0ZiRzg4eXNkV2thVGdOQ2lzQWFKM2RsYllRZTFh?=
 =?utf-8?B?bnNwbUZ6dUpRUks2dTVaQzhPbnNHMEZkWG0zcElxZmhMeFBRTTFsNEdmUm5E?=
 =?utf-8?B?Um53aWY0ZllYVWkybGI2MGhOS2tVRWtXR0tPV0ZkZWZrZkVCR0gxQTJEZkhV?=
 =?utf-8?B?bmtJM3J0VUdIakx0N3hXQ2NmMk04WWFyTnBadFM5YnV2MEYzUmNYK3VPYU51?=
 =?utf-8?B?em1NWDhJTWRXRFpDaHNzRkJScWl4NXV4dmZNNkx2aW1QRE9LZ0F1Qm9RQVR5?=
 =?utf-8?B?Q1ZQQnBBVjlJZ2FqTHJBY1ZjdTNuRTBTWlpaRVFtQSs0VldBN1FGRTgydXZJ?=
 =?utf-8?B?ckxvNkE2QzQrVC95VzE0YklMMVZVUmU1T3oydE9SVDRId2ZuVW1xSmFTNGl2?=
 =?utf-8?B?TUpuNkZuZS9RRjVWN3Y4ZzF1Y2xOZjJ4YVFuelJ6TDNwdXZXNDFlVUxaYW1w?=
 =?utf-8?B?VUV4b0hkWVJRLy9DNTZtQTRiaGpGSGFMTGJDN0U4UlAyRWhFWC94TVU0QlpC?=
 =?utf-8?B?VXRZOVRCSkQrdGZ4SUVuNUQrRU1BL2MzallYc2hPTW5zL3RCNFNvZXdYRzZ5?=
 =?utf-8?B?c1BnWnVQbncwL2VjY29zNGRDTzBpbEcwd2hhYUQvOGR2L2hiTWNLa2hXNkdZ?=
 =?utf-8?B?a3c9PQ==?=
Content-ID: <1C396E37D994CC4CA9103DAD20883EAD@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502c7b12-9880-4a37-9254-08dad464fc66
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 12:59:02.2588 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2rjsNgdpw4MaFE4mt1ix9UHTIUKI8sSXwA81n3LkH9NsxPOfxwgwsqIFU4AjF6r25IcvPJmhd5Um0ddBD+WSVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6394
X-OriginatorOrg: intel.com
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "david@redhat.com" <david@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "Gao, 
 Chao" <chao.gao@intel.com>, "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Disable CPU hotplug when enabling/disabling hardware to prevent the
> corner case where if the following sequence occurs:
> 
>   1. A hotplugged CPU marks itself online in cpu_online_mask
>   2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
>      callback
>   3  hardware_{en,dis}able_all() is invoked on another CPU
> 
> the hotplugged CPU will be included in on_each_cpu() and thus get sent
> through hardware_{en,dis}able_nolock() before kvm_online_cpu() is called.

Should we explicitly call out what is the consequence of such case, otherwise
it's hard to tell whether this truly is an issue?

IIUC, since now the compatibility check has already been moved to
kvm_arch_hardware_enable(), the consequence is hardware_enable_all() will fail
if the now online cpu isn't compatible, which will results in failing to create
the first VM.  This isn't ideal since the incompatible cpu should be rejected to
go online instead.

> 
>         start_secondary { ...
>                 set_cpu_online(smp_processor_id(), true); <- 1
>                 ...
>                 local_irq_enable();  <- 2
>                 ...
>                 cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
>         }
> 
> KVM currently fudges around this race by keeping track of which CPUs have
> done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
> cpus have virtualization enabled"), but that's an inefficient, convoluted,
> and hacky solution.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c  | 11 ++++++++++-
>  virt/kvm/kvm_main.c | 12 ++++++++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dad30097f0c3..d2ad383da998 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9281,7 +9281,16 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  
>  static int kvm_x86_check_processor_compatibility(void)
>  {
> -	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	int cpu = smp_processor_id();
> +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> +
> +	/*
> +	 * Compatibility checks are done when loading KVM and when enabling
> +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> +	 * compatible, i.e. KVM should never perform a compatibility check on
> +	 * an offline CPU.
> +	 */
> +	WARN_ON(!cpu_online(cpu));

IMHO this chunk logically should belong to previous patch.  IIUC disabling CPU
hotplug during hardware_enable_all() doesn't have relationship to this WARN().

>  
>  	if (__cr4_reserved_bits(cpu_has, c) !=
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f26ea779710a..d985b24c423b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5098,15 +5098,26 @@ static void hardware_disable_all_nolock(void)
>  
>  static void hardware_disable_all(void)
>  {
> +	cpus_read_lock();
>  	raw_spin_lock(&kvm_count_lock);
>  	hardware_disable_all_nolock();
>  	raw_spin_unlock(&kvm_count_lock);
> +	cpus_read_unlock();
>  }
>  
>  static int hardware_enable_all(void)
>  {
>  	int r = 0;
>  
> +	/*
> +	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> +	 * is called, and so on_each_cpu() between them includes the CPU that
> +	 * is being onlined.  As a result, hardware_enable_nolock() may get
> +	 * invoked before kvm_online_cpu(), which also enables hardware if the
> +	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
> +	 * enable hardware multiple times.

It won't enable hardware multiple times, right?  Since hardware_enable_nolock()
has below check:

        if (cpumask_test_cpu(cpu, cpus_hardware_enabled))                      
                return;                                                        
                                                                                                                                                   
        cpumask_set_cpu(cpu, cpus_hardware_enabled);     

IIUC the only issue is the one that I replied in the changelog.

Or perhaps I am missing something?

> +	 */
> +	cpus_read_lock();
>  	raw_spin_lock(&kvm_count_lock);
>  
>  	kvm_usage_count++;
> @@ -5121,6 +5132,7 @@ static int hardware_enable_all(void)
>  	}
>  
>  	raw_spin_unlock(&kvm_count_lock);
> +	cpus_read_unlock();
>  
>  	return r;
>  }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
