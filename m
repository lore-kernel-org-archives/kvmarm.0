Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D0FC4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 13:01:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210F940BED;
	Fri,  2 Dec 2022 08:01:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b3KNx0F+XBjd; Fri,  2 Dec 2022 08:01:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A704B086;
	Fri,  2 Dec 2022 08:01:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7ACD40CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 08:01:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bhsHWNFzCQqj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 08:01:38 -0500 (EST)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA08240BED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 08:01:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1669986097; x=1701522097;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=aqZXLt1WlRpGTjHIKSC9AII12PephzHwg6VCmqrUgT4=;
 b=S0LczTa8Hd9UDc29s3FyWV4qJejBt7zHhwgijgakmoPmZQbfNoSdAFKN
 6aVjD1r5uzgyGpu695j4/vD8kkFVHkyKJn1JCTzuSjfTbxC/iMt8Ncm7r
 kQSr+XcWzlyDJ7l2F0OH1Y3Pe/I3DFwZAApSRUJywonU8n9a2QTZZgqsH
 YleMOQono5gJo2MIrLkbFmaD0ciExBKdT6arlalB8RjldJCcAhYnwy8DH
 WJR2d6kH6cvYCsvoaxIvod9XU14TinmLgHJ5KKAHikyvsFcZRrHQWJYDu
 zOJEClChH2dYpfSZnFLxafxQ9AEJavHD/j6ESQsRAaK2Rr/UxWsA6KMD9 g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="378100813"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="378100813"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Dec 2022 05:01:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="751255002"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="751255002"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
 by fmsmga002.fm.intel.com with ESMTP; 02 Dec 2022 05:01:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 05:01:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 05:01:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 05:01:29 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 05:01:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBKtPLDeRyGdVGzzti82ibIGZJ/v3J5KlcehfYjKtwsRV6Ayd4NghnN8+7FqqENJ0BPb8oXvmZzdx0MeB4eVJIDatOhv4wR0ae38A5FEnAZeqUTK7CnpBUAv8ABRIKzVe0dTtVqAiZZLPVDtm7aLJ2SysOcuu5CM/nGPJ91s98K7l0WZEoxrn0q1HrorFkK/eQpdMJ42X8pAmpVu7sG2N3imiBKN1tK/I7C+z/dBAxaWAK+2NwElVHslyKY8DQRyDmEYzLnCn4UsoW32fXhfb4vqa4fd5y5pw0vIrJBGbk9Rb258Fi5Kne5pWkkBloKqElidBbWqfTMCd2QyyXPMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqZXLt1WlRpGTjHIKSC9AII12PephzHwg6VCmqrUgT4=;
 b=V94vjaZPYNnMySpbycpa5cusrAyrsRZ/u2eWXvbIg9WLuW1qa33iAKSa0GQg8xxfrGi9mYOX2/W71OSrv4TRdZUlTRT5YjNSvuWofnIFnQFyT4ecxz1+aE/CnOdjgr3V4yRMW3uCcorKw0vMh/5ftGA8I8GJf/M4GCiYmbAcjFtqS3/T52lNnAm/K6ZaDmkz1SM1+HDEi8yO66k6ydB9MYJT9PbppPJpRVBAyy0SrmL79/YszmopjwswlqVV6cFRUqZbgWgkIVNXV61kyXpz3dI0HPTMDPPatMXPncSkzh19D2km+3ye0tQRk+EHSqP4KTG6pBRbTFe1TgsjJ6LaVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7818.namprd11.prod.outlook.com (2603:10b6:610:129::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 13:01:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 13:01:24 +0000
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
Subject: Re: [PATCH v2 39/50] KVM: x86: Move CPU compat checks hook to
 kvm_x86_ops (from kvm_x86_init_ops)
Thread-Topic: [PATCH v2 39/50] KVM: x86: Move CPU compat checks hook to
 kvm_x86_ops (from kvm_x86_init_ops)
Thread-Index: AQHZBREEXtDOKnrjT0enXrS6tk8i165akjeA
Date: Fri, 2 Dec 2022 13:01:24 +0000
Message-ID: <1b0ece3937436f59f466c352b84cb35f84347399.camel@intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-40-seanjc@google.com>
In-Reply-To: <20221130230934.1014142-40-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7818:EE_
x-ms-office365-filtering-correlation-id: cd298c8c-69e5-495b-a330-08dad4655129
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i73RYT/8IkegGzI3F6yi9S+VQDoThyiF27KPwrNSIJ+NhKikyrLoHADeK5u3zb81RNsQFglyRDKn6Ul7bl7a0AHhVjaX0BaLcxKe/7aWLafYvI4/aGzNikDKKmIqR3Rxyqwq2h1ypVjNjruxFam+9GCiuL1Nb2KfhOkb9Nra7FMZyvsYHx44yZ01VWfLqpCjLsQLuajxqjlEVLHUsIMM6mp3L5lzjiHnkq66RpP3uugvaYZtF2aJFJKs95f8d7vTKSzrLP5DunLmLxYi0pdTiY22AAe0bQntPMikuEeCTzTsshpqWOaBJ3p6LtwpwAWrN0ylXkLOC/IFzgEPlKodcNZFGSs3LCNCjyJzpNDNG53L542GqQO+rp1Mc/8vMPsypthd9kxBZV3CzmKnznCYHz6/FskbXHb+Pg6eVhfyFbBPGC1mkcuBaU3nqU/r77yohLdrj0tML1VU5XFxL+X/bqSTcGGdZV/4toFCKXlyHj7Mnx16nFoCBLcecYY5SDgRY8A52OvK4E9596i6Z636ELzckTSgDCzVvy+S44URhuX8n6npspLApwBRvKvBHsBhWbH5HVrtLIIBOxH2KuLkzivofLjJ9uUJUoXX9Ti+5K0Xhi7JoTsFMeZj74wdEZbUDsWLkCP+PZa85I/+bnAVyrJBt2cBX1xZT5cX0wspYk9hOfP0g3X2NxoQ92aBkGVfJkSb/WUZfslBAbnTWZgjIEWUGNWAwQsABPQiOJp/t3A=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(36756003)(316002)(921005)(86362001)(54906003)(71200400001)(110136005)(38070700005)(6486002)(82960400001)(478600001)(64756008)(4001150100001)(7406005)(91956017)(4326008)(76116006)(8676002)(7416002)(66946007)(41300700001)(66476007)(66556008)(66446008)(8936002)(107886003)(83380400001)(26005)(38100700002)(6512007)(2906002)(5660300002)(6506007)(122000001)(186003)(2616005);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1FSYUxPbGswYXJDUnNGV0ZLUkhTYUlYVU5maTQ3empwbElKRk1WMno0R0du?=
 =?utf-8?B?VEJkakN0MkZiUThVYlpOSEdNbXBqeEZqaGp3SE5rRVhPVitjdHJyQ1YzOG9a?=
 =?utf-8?B?OG9QczF5YnpvR09UYld2R0M5clRvbkJneThLQ3RqblMxNVVUNzNuUGQxWkkv?=
 =?utf-8?B?eHBDdERrS2dNMU4ySW9zbFNuRVZlQjIrSnlQcjJWOXlLak1BVXc4TldNTTdu?=
 =?utf-8?B?KzNrK1l3ZjFTRlJ4Z0E1bjgxcnBWL1dkc050Q016cklWdjdhNm5UcDFrR2VC?=
 =?utf-8?B?aFY3ZDJKT1k1SGFaaGl5UUlRVmJhYXhWWVkxTVJmRkliT0x5SkpISEVndEdv?=
 =?utf-8?B?a1I1aDRRbHRrZkkwTngrbit0N3lhNzJqb2dSbVFLVTJnK090VzBrNFhLQ0xI?=
 =?utf-8?B?THAvWGlFUkRJLzBGV0tpNXV0Vk1WNzU2aGVGdG1rekFKTzFCa0tPVTlRbmZk?=
 =?utf-8?B?ZExreVYvOWVYTTBYLzQxOW5QZUVEaHNBMW5ZSUhHcUFWRUppQVpleHBhRnRh?=
 =?utf-8?B?YVpGQzRDRlJ3dzVCY0hkbElUcVJnRVFCaHRsbHJLRjY4K2d1ZmlBd3UvUVla?=
 =?utf-8?B?bi9RanRCTDc0UTljUU5TVDNWeGQvcFdOMDkydU9mVm1ZL0pqZCtCS1hSd05P?=
 =?utf-8?B?VTQ2S2tiYnJNUEFDVjhhUkNaaVBuUVhGb1JnaDV4MlYzN25iVmNzZmxUNE9Y?=
 =?utf-8?B?Mk9rWlpkOWJaVDBFYldQQnZhZmJXZ3BzekdqYnVLL0tPaXczWFlHaEVYV1c3?=
 =?utf-8?B?b0g5cjJMdU1WaFpKZzg0bW1UUGNGaU9iOCtYQ3RxU01CZGtUSWxhQlhGYzg3?=
 =?utf-8?B?bW5KMHZOTHlORHJWcFJwMzcvdFQ4QzczRlhtSzRzQlByMDJuTkNWMDRQcFhZ?=
 =?utf-8?B?aE1XZGhwZnQvQ0R6bkxBeVhXRG1uanZDbmRXZW1RVTdPVlJaOXBiQ2FJYm1Q?=
 =?utf-8?B?MGJ5R3ZBdTNUS1MyNEpHT3VhTFpOYWhkaU95SFNrVXBXOUZ4NDg5SjlDOTZq?=
 =?utf-8?B?c2tyazZxSlBkNXpzMXpaUEMvdzF0OTE5NUw3NEU4WCs4anRobVkzeFE2Q0pt?=
 =?utf-8?B?RERlZDFzSGhFSlNWR0NaaHBvN25pNVRpcDg2TUZMdThhbjJ5L291eGZVRGhM?=
 =?utf-8?B?NUw0ekxHbFcwZEprbHB1MnZhUURHL2hRVVZMWEtsT2UyQ0cvbzJRR2dScHJl?=
 =?utf-8?B?VXhGTTVJL1hrV3h4Ymh5WmJMMFB4a3d1dmdZU2dobW9sb1d6Y2lvUyt6QUY5?=
 =?utf-8?B?a045VU5FL2hEWEt6OG9ZejFGeWxISWlpcUFoYkk2eTUydzc5TmJraFpVekd4?=
 =?utf-8?B?TE1WWHQ2U1R2Y2ltdVE4YlAxNDFsem1MbUFKR3h6MDZwVU1acURScnFBMEsy?=
 =?utf-8?B?YzJsc21NaHo3bFJhWmJoWEhnd05CR2pJTjhqTkRVL3dOZU50NnhOMG5iUHlw?=
 =?utf-8?B?Y0dxOEZjTk91THFvTmlxNzJkcVIrUHFzS2dscGRwTmZBRXVmb3d0K2haSEtN?=
 =?utf-8?B?SjlZdXFiL1Rhb2swMUFvMG1yQm1QOXp6VmF6Z2doSGRyTXpmYitHQk1RbkZk?=
 =?utf-8?B?VFFrYklSWlFGZlNka1BrU3JoMGNTYmRtcnRQY1FSVXBjMkZUMThYYWFLbTk5?=
 =?utf-8?B?SWRWcnErOGIxYkFuN0JsWXdTdU9qNjBQSnB2YUlDK2gxTWgwRml6R3BVWHlX?=
 =?utf-8?B?VVFWTWYxK0tUVWh4WjJ1VnVTZnZKS1diQnltL0cvWjllUW81a2MyeitPdVFn?=
 =?utf-8?B?TXZ3OUJDN0JId0taV0RCd0xsMlJvdFlWZ0JpdWVjaGJIcVQwTEpub3pvYTBQ?=
 =?utf-8?B?WHJVNXdMZE4zK2ZRRFA1RG4rQktEeFdPaHhzc2pJZmI2dWQ3OCtidzJrQUQ4?=
 =?utf-8?B?UWFpc3M5YjZtc29lL09PbGJNem1XdjV1RDJKenRnRVhqc0U2bWRXV0gvMnBX?=
 =?utf-8?B?MXZRNzN0Z25DZngxU3hjazFXek1QMU9NN3B0TFZVNGNJejRkL3V3eGU2Qkdm?=
 =?utf-8?B?ZDNoRytTSjdkQUwxVzIzUnlmTllSY1k3ZHFJa3Q0RXBjcDZnaG9ZY2VJbS9S?=
 =?utf-8?B?T0ZvMm5jNFlGS21YZXE3c0NIN2h4Tm9Pcm1UcTBtOTRDQWdhQWVETmIxdmNo?=
 =?utf-8?B?Y3pjenhkdndpWWg3MkNVZzFBbXV6VFU4djhVNTRKYmxMUFRmbzZmcGREZ0pC?=
 =?utf-8?B?ZlE9PQ==?=
Content-ID: <AAA12427268DEE47A4504740CB297790@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd298c8c-69e5-495b-a330-08dad4655129
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 13:01:24.4658 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtNGYq+uOMk6mAsbqmZMiACho43xu6iVNAtXSD75aFVMaQFueHVp9Rc8/Dqg6lZ0JQ0F+5aOoNI1ltcQYKMARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7818
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
> Move the .check_processor_compatibility() callback from kvm_x86_init_ops
> to kvm_x86_ops to allow a future patch to do compatibility checks during
> CPU hotplug.
> 
> Do kvm_ops_update() before compat checks so that static_call() can be
> used during compat checks.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 ++-
>  arch/x86/kvm/svm/svm.c             |  5 +++--
>  arch/x86/kvm/vmx/vmx.c             | 16 +++++++--------
>  arch/x86/kvm/x86.c                 | 31 +++++++++++-------------------
>  5 files changed, 25 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index abccd51dcfca..dba2909e5ae2 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -14,6 +14,7 @@ BUILD_BUG_ON(1)
>   * to make a definition optional, but in this case the default will
>   * be __static_call_return0.
>   */
> +KVM_X86_OP(check_processor_compatibility)
>  KVM_X86_OP(hardware_enable)
>  KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d79aedf70908..ba74fea6850b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1518,6 +1518,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	const char *name;
>  
> +	int (*check_processor_compatibility)(void);
> +
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	void (*hardware_unsetup)(void);
> @@ -1729,7 +1731,6 @@ struct kvm_x86_nested_ops {
>  };
>  
>  struct kvm_x86_init_ops {
> -	int (*check_processor_compatibility)(void);
>  	int (*hardware_setup)(void);
>  	unsigned int (*handle_intel_pt_intr)(void);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9f94efcb9aa6..c2e95c0d9fd8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -543,7 +543,7 @@ static bool kvm_is_svm_supported(void)
>  	return true;
>  }
>  
> -static int __init svm_check_processor_compat(void)
> +static int svm_check_processor_compat(void)
>  {
>  	if (!kvm_is_svm_supported())
>  		return -EIO;
> @@ -4695,6 +4695,8 @@ static int svm_vm_init(struct kvm *kvm)
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> +	.check_processor_compatibility = svm_check_processor_compat,
> +
>  	.hardware_unsetup = svm_hardware_unsetup,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
> @@ -5079,7 +5081,6 @@ static __init int svm_hardware_setup(void)
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
>  	.hardware_setup = svm_hardware_setup,
> -	.check_processor_compatibility = svm_check_processor_compat,
>  
>  	.runtime_ops = &svm_x86_ops,
>  	.pmu_ops = &amd_pmu_ops,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2a8a6e481c76..6416ed5b7f89 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2520,8 +2520,7 @@ static bool cpu_has_perf_global_ctrl_bug(void)
>  	return false;
>  }
>  
> -static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
> -				      u32 msr, u32 *result)
> +static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt, u32 msr, u32 *result)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 ctl = ctl_min | ctl_opt;
> @@ -2539,7 +2538,7 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  	return 0;
>  }
>  
> -static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
> +static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  {
>  	u64 allowed;
>  
> @@ -2548,8 +2547,8 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  	return  ctl_opt & allowed;
>  }
>  
> -static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> -				    struct vmx_capability *vmx_cap)
> +static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> +			     struct vmx_capability *vmx_cap)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 _pin_based_exec_control = 0;
> @@ -2710,7 +2709,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	return 0;
>  }
>  
> -static bool __init kvm_is_vmx_supported(void)
> +static bool kvm_is_vmx_supported(void)
>  {
>  	if (!cpu_has_vmx()) {
>  		pr_err("CPU doesn't support VMX\n");
> @@ -2726,7 +2725,7 @@ static bool __init kvm_is_vmx_supported(void)
>  	return true;
>  }
>  
> -static int __init vmx_check_processor_compat(void)
> +static int vmx_check_processor_compat(void)
>  {
>  	struct vmcs_config vmcs_conf;
>  	struct vmx_capability vmx_cap;
> @@ -8104,6 +8103,8 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> +	.check_processor_compatibility = vmx_check_processor_compat,
> +
>  	.hardware_unsetup = vmx_hardware_unsetup,
>  
>  	.hardware_enable = vmx_hardware_enable,
> @@ -8501,7 +8502,6 @@ static __init int hardware_setup(void)
>  }
>  
>  static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> -	.check_processor_compatibility = vmx_check_processor_compat,
>  	.hardware_setup = hardware_setup,
>  	.handle_intel_pt_intr = NULL,
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5551f3552f08..ee9af412ffd4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9279,12 +9279,7 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  	kvm_pmu_ops_update(ops->pmu_ops);
>  }
>  
> -struct kvm_cpu_compat_check {
> -	struct kvm_x86_init_ops *ops;
> -	int *ret;
> -};
> -
> -static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> +static int kvm_x86_check_processor_compatibility(void)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>  
> @@ -9294,19 +9289,16 @@ static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
>  		return -EIO;
>  
> -	return ops->check_processor_compatibility();
> +	return static_call(kvm_x86_check_processor_compatibility)();
>  }
>  
> -static void kvm_x86_check_cpu_compat(void *data)
> +static void kvm_x86_check_cpu_compat(void *ret)
>  {
> -	struct kvm_cpu_compat_check *c = data;
> -
> -	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
> +	*(int *)ret = kvm_x86_check_processor_compatibility();
>  }
>  
>  static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
> -	struct kvm_cpu_compat_check c;
>  	u64 host_pat;
>  	int r, cpu;
>  
> @@ -9377,12 +9369,12 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (r != 0)
>  		goto out_mmu_exit;
>  
> -	c.ret = &r;
> -	c.ops = ops;
> +	kvm_ops_update(ops);
> +
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
> +		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
>  		if (r < 0)
> -			goto out_hardware_unsetup;
> +			goto out_unwind_ops;
>  	}
>  
>  	/*
> @@ -9390,8 +9382,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	 * absolutely necessary, as most operations from this point forward
>  	 * require unwinding.
>  	 */
> -	kvm_ops_update(ops);
> -
>  	kvm_timer_init();
>  
>  	if (pi_inject_timer == -1)
> @@ -9427,8 +9417,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	kvm_init_msr_list();
>  	return 0;
>  
> -out_hardware_unsetup:
> -	ops->runtime_ops->hardware_unsetup();
> +out_unwind_ops:
> +	kvm_x86_ops.hardware_enable = NULL;
> +	static_call(kvm_x86_hardware_unsetup)();
>  out_mmu_exit:
>  	kvm_mmu_vendor_module_exit();
>  out_free_percpu:

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
