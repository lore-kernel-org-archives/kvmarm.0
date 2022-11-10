Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7515FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDBC4BB74;
	Thu, 10 Nov 2022 09:52:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Co6PHZnOfjsT; Thu, 10 Nov 2022 09:52:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5080B4BB89;
	Thu, 10 Nov 2022 09:51:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B864BA59
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 20:09:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ZC8We6WsRPu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 20:09:22 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9047B4BA41
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 20:09:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668042562; x=1699578562;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=jcgLPKFY894y3Vfw1oCpIEzLG3GySTKymBaGb2vkDjs=;
 b=nlKHiVuj5dp7WdVioUhJ9sbDc1pb6rr8IkEVP2eG7qG1f7ymAQBJDofl
 DGBTLA1a4KaNQAk8iEqgh+OOC7wFphqpln3cHMEavGkfK0OuXuhOlGOnq
 TCRNFnDfjJkWhoyRARLyep477iPY9EN0U7b8qyD11yxxoVfgv2k16nbHQ
 a3IwUbfFNwr7BqPIw74/jMY1NAxw7tNW+ln9J2dcKA7g3+1USFHtU8PC8
 h21m6u01PjVjQPHE31uncAjzRQUbruaUb6nSobnoQqxSlI+W0/b5A9zZN
 EVGP0RZRjum2OZ27+d+ZZ6TRBQ4vqk/wUbiPCwltal8zLNtYlOYI0nFyR w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="337920748"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; d="scan'208";a="337920748"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Nov 2022 17:09:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="700590622"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; d="scan'208";a="700590622"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 17:09:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:09:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 17:09:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 17:09:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YchRpHkeAcZTP4nJqFgjJhay6lz3OOF1iNbcehfYU6Cw0/rayw30601mfJS6xm9AQVUQC+Nq5Q+mua2d1m+JsEj2H6ASYCpwDg29cDBJ2fcmO3xFGlKv7bHst7g8plw5OZ0IgVWOtY3F4jvDtPStiYkSbm/VU5Pxg51bq9VqIAuWcbM7NfNGSHTZI3IKAv9NCF47PPqc2FEJ/VkWjmlr0T9xakVFYP2wwa/cyA9iCouBVmEWG0SJ9ju9Cq0mIFNalnS6VHL/6odMYjsLZwS+IltM0ihLbwqxnAc2NWP24bacMj5pelWRRHfZ2yDw5MOjOwfJjuMVC+VtfDIbKBRlEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcgLPKFY894y3Vfw1oCpIEzLG3GySTKymBaGb2vkDjs=;
 b=EK6f3gSFb9yQPa5UpGyXZEBl6FiEZbgmVPRIG6YolKxO9cSNs1Tz+9CEQrweEVUuuH/bMNo5wYzm+xglaheol79sLCELQtbHA2dZ4oYt3BUOSmuILjWJmXHtOz9BR/klElcieN5j2LRpjlhlJFpUCGPPaLek2dDVBwftCQFLvlG9vyxDt0U0duszIFUZrDlWAxXl7+5e7dpw/e9vEhCMcwBepJ+95IQ23h6rOTweezGvon99LmiUSeot5udsAhf3g2NkWXb67CWmQ1uRyHsIBpHCKTlL/QrSQr5dOVBbFbPvAeG8y3bxrL637lm8dhVRPBmcclp01mqwRTcnlKdS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Thu, 10 Nov
 2022 01:08:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 01:08:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "Christopherson,, Sean" <seanjc@google.com>,
 "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>, "vkuznets@redhat.com"
 <vkuznets@redhat.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "paul.walmsley@sifive.com"
 <paul.walmsley@sifive.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "maz@kernel.org" <maz@kernel.org>, "anup@brainfault.org"
 <anup@brainfault.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Thread-Topic: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Thread-Index: AQHY7xJy2pUg1L4bCkib6AOkbzD9bK43Y9yA
Date: Thu, 10 Nov 2022 01:08:56 +0000
Message-ID: <4f523a166badbd61a1cfb6269334e9c9354ade64.camel@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-39-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7004:EE_
x-ms-office365-filtering-correlation-id: b2141e33-2e02-4dd8-d3cb-08dac2b82439
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /qFPy9VWXMeGK+hFes/uZZGdeh97H2PElqBbxH2mCgwT+IQRlo8kIMnZApNHmVFhyC/2Oy6kyYaggTOX/gDoEdJI6W+uiC+6F8RYHx0lthgKVf/ufC9zAb/KyLHqwcxaE7sNrWVBsBOV6/p2qq9ZosF3VkJiaLLq02KBCm4F/2UcMyezzjqGrgtbROxoe0+u5xcMJcgfSQvREoWHVkVbx3d4lS4+EKb471S5nqQKpsczHxdVKdqIcRRfeGeW/OEXvK+NPdjo2mdLtwI6CoyrxyHDrOG16liRbMmuyLCoFWwjcyUDDWU58KOf3k7L+u0EZqnqJdh1nqAJ5fEmDR+caMIVMheTNlCksNvzQXP+aokNLzXwNPnESzqoBR1RJ/ojB2KgSCYf0zm3oYSGqQAUTOEXDpUxnz45FVsljRdk0IYdg3Ti+/hXGgKHmIeyTeGONs7XH/9sBAEONmANUBhkX5q5t7TwHm22HUPdU28EcXfcTgnxJo5TFY851GQTugLO8uQFWNka2ZQF0vYzCApzqIEUZjVbdXzbpLONXp3Kc+v8h8fHUA91rRk3A04NQsuEaSOTrnU3DTTTKQZTyqpq6owbr2ce/NCLmKm9TVddy/YrZ7G7ifAKD9zp47DOk06JeYMkTyjXw3J+h+H1QmEkwOICyAWTmk3W1Kgqgx7vHDfsquk9cP9t8wwtjUYHbaR26/d9m9Yh6VJBzA9DRNrOGmE8xd44rVoulv/uUMJskcwKygPL3QM8EyvnpvWxLvMYE1BaBpKxkI17qfnJtPx93OOn43hHAyHVDKTyVE/bC0s=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(91956017)(86362001)(38100700002)(38070700005)(82960400001)(316002)(921005)(122000001)(54906003)(6486002)(2616005)(110136005)(2906002)(66556008)(83380400001)(66946007)(64756008)(8936002)(41300700001)(7406005)(8676002)(186003)(7416002)(66476007)(66446008)(6512007)(478600001)(26005)(4326008)(6506007)(76116006)(5660300002)(71200400001)(36756003);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDNpcHo0eVhKU1BPbzMwLzNxM1BEYW9UR2gxL0QxMy9lUTh4R2NOMFFsM2hE?=
 =?utf-8?B?bFBYL1BJaGs5UVhMenF0WUFJTjdOdGVTMGRCbGcxRkpKTHhldmhhZWlTV21m?=
 =?utf-8?B?WTNJRUV3UUhScXU3dXZkWE5lL1RmM2pFWVFwa29yUWlTVy9vcm5ZZyszL2ta?=
 =?utf-8?B?cDF3RUtUUjkyM003TnYrS1hXV2RsRmlZWjhLazIra2E1Mm4rN3BYNWJhUWdy?=
 =?utf-8?B?UTlQZG9GcklhdkFmRFJTTGt4ZmkzSVdack0yVGZtalQreWU3YWtZTXpnNXND?=
 =?utf-8?B?UGdXUUNRNGh0TldoVC8rVlFvakY5Q0JNMENWanZoSDRaOXlQdmhITlVBMFBB?=
 =?utf-8?B?UElDUVVyUmpNUkl0aWw1WDRyMmpXSTdlRE5ScHB5SlM4RGU3c2JGWHlMOGRN?=
 =?utf-8?B?YThzUnlTMEU3RCtXSEZQbjdNeHBJRWNZbUY3bVZ1RTJMOVFuY2M2c0xnQ1Bi?=
 =?utf-8?B?Z04vQ0Q1OG9tOFFOWVNFMDl2ZVNYckRiYTdFdjZVOHVjWm16dk9lVWllb0pN?=
 =?utf-8?B?VnM1d2dwMUxnSVV0WFZyT0hWNjNhb05kZGlyRmpmQ0lvUW5UMXdHWUxENm9I?=
 =?utf-8?B?NElVTVdXR3h6Vnk3cFhRanBXVHpQRmMzL1hBMWZ2Q0xzdG9rdyt6bWo4YTJJ?=
 =?utf-8?B?dDBUc1BoaFBJV3Q2VCtDUEt6bWNqME9pVy9NM0NsSEVGUUpoOUZ3S2xOWC9z?=
 =?utf-8?B?OHhhRDI3TjNzTjJvMkJvdE03VmZPS0FGSjNwTWtHVTE2cW85M3c5Ky9EcVhF?=
 =?utf-8?B?anNJVzJpQmJxZWtsYkpvSU5oUWlBYXh0OGJ6MzZ4R3JHMWx4aTNNVHFacVN5?=
 =?utf-8?B?R0gwY3pHeWhJSHRzSmJHSnVtTEtaK0JHdHVqYXpXd1A0VTN5OVN1SElTNGRl?=
 =?utf-8?B?WDJRVHo4bGtQbVZ3MFc2VTMvb2lqVmVuTmp1TzIreDlDMVFaWTlvZERUNmF0?=
 =?utf-8?B?RGlhRXNMaEpCejVDWnErQVBwMGw1UUxUVVUrQU9mZUkxam8wckcxa0Ywc1VU?=
 =?utf-8?B?NU5Jb2hwYmNKQXpwbXNKeTdXTjU5M0VTQWNpWGFKa0NaUFFpWEVBcC9OVFZv?=
 =?utf-8?B?L09XZGhYV00raGs2V2ZTUG9vdlVsNVFSUVN1K1RlZWh1UmhmakV4N1Q2OVp2?=
 =?utf-8?B?TXVCT1dQTTNxS00ycnEzcG1xK1c1NWV5dWZjb2xRVTBDeUwxL3l3VG4ybWZZ?=
 =?utf-8?B?MFBVSGF3azV1V2s0VUFGcjV4cmV3Y1ZUa3o3OENvWEFBMkF5UlJJT0syQk9G?=
 =?utf-8?B?bEFoMW1tamhaSUhTdXRJZXB2bktyU0xrckw2Qnl1V0xWdlpGaCtHcFNPNVVH?=
 =?utf-8?B?Mlo4WGJrWkNHcUwwaS9Ec0FzQiswUmNnN1dFZ1JKNVhYdUtWMGgxdzIxOXlm?=
 =?utf-8?B?ek9MM3FPKzJsU0pzbGRONS8zeXpaUlJDcWNyQVdBZGdBR1hYSm4zc29uZmhr?=
 =?utf-8?B?dTJObEdOYS8xa0RLeVZTdW8wam04SXFrcWttRVVrRHVDNk5TeEN4QzM0ZXFt?=
 =?utf-8?B?b1hpTDdyS1ZCUzJLamluS0NsbUNvVEtBYVdSazZQZ0xtU091bnZXRXFiTSsy?=
 =?utf-8?B?bzl5cXJoNzdFMnM0eHZYRFk4RmZBdkZ5STRSUmsxMHYwUVR3d3Z1RzlQajBE?=
 =?utf-8?B?OWlKb0lxV0N1Y3JoaTdPeUVpbEo4VlQ0M0hqKzMvVkdIK0gxV1haMndhMk1x?=
 =?utf-8?B?bzExMHBQZUExOTJiSEhySlNxcjdJNmNuU1FtaXF5OXkxNEtXRGZKZzNmRDhz?=
 =?utf-8?B?YzE0c2U0S3FjVXJieVVtMHpUNTdiRCs4eStUUWdwVENabVBWeUt3M1g2U1RC?=
 =?utf-8?B?a1NtL0huWXJ5N1R6WCt1a0QranV3YVJhQndnaE9Ob3dzemVWUWxJNDlWalNW?=
 =?utf-8?B?Uyt2QjN6Q01QNFdLZ3ZsQnUrcTlPYUVYWUZ3UmhTSitsQ0R4L3ptUmhNSFds?=
 =?utf-8?B?NksyZ0lzL1pjU0RtY05wRGZvNzAyMUdjVm5TdCtuckdRRjhNTStFUjZZOWZm?=
 =?utf-8?B?Z1ZOdmpiRWVxbmttOGphaFUyRVpyaTArNUFsOURlaTJXTUMydkNhWUhEYTZm?=
 =?utf-8?B?d2pIcGUwMzE5UlBENEpsVHozUDlIek1MZi9ENW9SdlN5YjluVHlvenVuNGpF?=
 =?utf-8?B?RzYza1VKcCtpelVMTDJFeGlTZUo0N1I5b0xZc3NJWWNCVW1JeThvakQ1YnNq?=
 =?utf-8?B?alE9PQ==?=
Content-ID: <F531378AAD316149A0F3DB4A2C117806@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2141e33-2e02-4dd8-d3cb-08dac2b82439
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 01:08:56.3730 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iLzH8w0zrhEm2Mhp+8JuyKIh98ykBKshLGZajwGrh1Mhe3OXS6o+w515gGEVOTZlfw9qY+mS+Q5sbchaDBvmng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
X-OriginatorOrg: intel.com
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "david@redhat.com" <david@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "Gao, Chao" <chao.gao@intel.com>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
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

On Wed, 2022-11-02 at 23:19 +0000, Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Disable CPU hotplug during hardware_enable_all() to prevent the corner
> case where if the following sequence occurs:
> 
>   1. A hotplugged CPU marks itself online in cpu_online_mask
>   2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
>      callback
>   3  hardware_enable_all() is invoked on another CPU right
> 
> the hotplugged CPU will be included in on_each_cpu() and thus get sent
> through hardware_enable_nolock() before kvm_online_cpu() is called.
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
>  arch/x86/kvm/x86.c  |  8 +++++++-
>  virt/kvm/kvm_main.c | 10 ++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a7b1d916ecb2..a15e54ba0471 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9283,7 +9283,13 @@ static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
>  	int cpu = smp_processor_id();
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  
> -	WARN_ON(!irqs_disabled());
> +	/*
> +	 * Compatibility checks are done when loading KVM and when enabling
> +	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> +	 * compatible, i.e. KVM should never perform a compatibility check on
> +	 * an offline CPU.
> +	 */
> +	WARN_ON(!irqs_disabled() && cpu_active(cpu));

Comment doesn't match with the code?

"KVM should never perform a compatibility check on on offline CPU" should be
something like:

	WARN_ON(!cpu_online(cpu));

So, should the comment be something like below?

"KVM compatibility check happens before CPU is marked as active".

>  
>  	if (__cr4_reserved_bits(cpu_has, c) !=
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fd9e39c85549..4e765ef9f4bd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5088,6 +5088,15 @@ static int hardware_enable_all(void)
>  {
>  	int r = 0;
>  
> +	/*
> +	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> +	 * is called, and so on_each_cpu() between them includes the CPU that
> +	 * is being onlined.  As a result, hardware_enable_nolock() may get
> +	 * invoked before kvm_online_cpu().
> +	 *
> +	 * Disable CPU hotplug to prevent scenarios where KVM sees
> +	 */

The above sentence is broken.

I think below comment Quoted from Isaku's series should be OK?

	/*
	 * During onlining a CPU, cpu_online_mask is set before
kvm_online_cpu()
	 * is called. on_each_cpu() between them includes the CPU. As a result,
	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
	 * This would enable hardware virtualization on that cpu without
	 * compatibility checks, which can potentially crash system or break
	 * running VMs.
	 *
	 * Disable CPU hotplug to prevent this case from happening.
	 */

> +	cpus_read_lock();
>  	raw_spin_lock(&kvm_count_lock);
>  
>  	kvm_usage_count++;
> @@ -5102,6 +5111,7 @@ static int hardware_enable_all(void)
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
