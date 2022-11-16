Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9239FC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 01:47:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013BE4B8B4;
	Tue, 15 Nov 2022 20:47:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yJQ09M3FvEot; Tue, 15 Nov 2022 20:47:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 963184B8CF;
	Tue, 15 Nov 2022 20:47:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F05BD4B8B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 20:47:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f0CcuQD5+bpL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 20:47:10 -0500 (EST)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D725F4B8A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 20:47:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668563230; x=1700099230;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=Mau0LE7ACRC5uxvYPmJkveKAExIXw120xLwnM8PzuPE=;
 b=Y9WPQWrToI9aSQAGHGr0ncD2+WWGlNZGiJPytRyDphNZZoP9p8NOBaow
 rCP0Erf2ka3gNz0tK46W5zb1Oecwnq93LhiTYmT73bVHysVwJaE78XlnJ
 vrKGanVvSK/qlOBntJLnV5fXz2r5jkoWC7i0QroCWEKDqbGZ8S3OHc7BN
 Xm1W4hZq6soWJXSbjmsILEC0gS1utbQqAzi6KiY+Rs6aLauTSzJtVYWex
 jRRWn2EzLnaalxKHaD1wKIq1pUj/X0aDIxBD3hfMbjeNpunrRF5eWFxa2
 gPcwHmJC8WJE3K24o2vJYTViVA/qyTi5hp/sQelHOhCpDxqykRbS6hhM+ g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="295785073"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; d="scan'208";a="295785073"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 15 Nov 2022 17:47:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="813897182"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; d="scan'208";a="813897182"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
 by orsmga005.jf.intel.com with ESMTP; 15 Nov 2022 17:47:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 17:47:06 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 17:47:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 17:47:06 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 17:47:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BM+WtL8obOtiBXd9s/gKH5TunKtCi5IfUm2Kd7N9EgqLp9l4lhUhdnGia3ZGA6skXLzvd1gCW5/q4euUTpV16/iGfK07s8q2xo/NreTMbamLYY+ScPxqivUKwpE2JX1Ul36r4MBD7UukHeKyvPnCJ8c656YF9nirtPBEWU9SAC8cmFaB2jXslKfwiKf1g1UXLPv5fMJd7s+AZMyLg/SOa7eaGGAoTCGQrBmvWtAU3u9qiOChIcBxo5BtNscrM+YJB+0ihtGUeeUJX+/C+oUkz2PQr+eVVGOrxeUf7JPb88RURuLVU8NUWEht8k/aiwUdC1N0PM5V/FqNmbVXg8lf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mau0LE7ACRC5uxvYPmJkveKAExIXw120xLwnM8PzuPE=;
 b=imD6LkY7pP4SLhptmtE6Y0gQMAtWCMrUwycL4OmIsvryoF5jXRBSkdPsZPAl271XLjhpbSNoQhtczhDJfsoIRjrn8KSlGSfztx4ILZtIO4iTVUZHC/sfug7+aph+tlEL5u5zAv/y5elKiKrt6zBvgE8fnVS9z3B8v2FBMswPLQiXitgTnYUVzC2/KWXdRAKb/0YCykDMdpKUASBoPXQZ0tprTG86Ni1ziMfXB/S4SFEHAx4sv76pN9ZRVRTkCBy33AzvEhcbNXl44MiUOa42soKDg8/4IHcpwYoDweqDgfXsmdbadnKAlxNDpjidrfht3YGuFDvcol2EWABcxDXRmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 01:46:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 01:46:52 +0000
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
Subject: Re: [PATCH 13/44] KVM: x86: Serialize vendor module initialization
 (hardware setup)
Thread-Topic: [PATCH 13/44] KVM: x86: Serialize vendor module initialization
 (hardware setup)
Thread-Index: AQHY7xHq2cS0mXAh8EqkP3LwhIvmL65A3HGA
Date: Wed, 16 Nov 2022 01:46:51 +0000
Message-ID: <e8e3b4c7bf3bd733c626618b57f9bf2f1835770e.camel@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-14-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-14-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5955:EE_
x-ms-office365-filtering-correlation-id: ba13ab62-4e14-4773-a7a4-08dac7746ef2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZCT0SncC51GO28yUD+xZHv0F4f2xc+3Ke3MQyn8WbqwtI+86vkq/Ld3DvGoYtuj9/8awapGgAqMGb2Y1j5sUz8rWx233IuZV1NkW1nmCKLfJlv9dV7Fl10boHcuDdlHKvlXJkdUeodxyOD0neUoXoKYSG3SkHReH3KAV2e7tFC9QxpJ2arwPfobyI5XqSkxt6986GJSPhEqGay9V0QMF2JAYMUSmET3ijSDDn/96rIMfEsmUSvt/Sqt/GzbgohJ5lVlyi6igdM8HGmX44sz3ChRq6lQLugozcqY47cEs57J+jfiSB+3OVRMbLOd6m/wnDg+/53BmP5DZnZtvmm6xhjprt3LsmQbh6M14fpNYDF+3FASrqur4Ifjkruvg69UcI1C5Y9ORQpjZCaBQEHfxzMmzvOGPQ2CkNX1/pBojI/JGB+J612DsHTRdhjQWkHAnCSZtVsemoU1cnRe9BOhKlwCSFzOJvZx6jGgwayb4GUSKzg/q9Qegt6ipiWWwdYRlf6naIA5AUrJhqVDyu5KdDW0NbXBFiERHP6V47zXLy4+XqGhFqakdQLjtoS3HmW2xqzlzU4qC6HmhF9npPUBA5UodXCB7ZB7FknpQ42f7k+9l54lcyjp8Zpad3edk30ae0byU4EE6t42FlXPayWcNwsbHrLtAs6glZcHaOP7swghjVkXdzxnL2fB2iqF0allyj1N95bliC6EAG0fY1hMbR7y3WXRbYbSCvu3oDWDFFSAbW7fu2xvPaPRZvwys78Efe9GMJFwASOvTMnYdW/PzXvYAdIPJoJ0YPpJQBoWqfc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199015)(71200400001)(478600001)(122000001)(6486002)(110136005)(54906003)(76116006)(186003)(316002)(26005)(6512007)(83380400001)(66556008)(4326008)(64756008)(8676002)(36756003)(2616005)(66946007)(66476007)(8936002)(91956017)(66446008)(41300700001)(38070700005)(921005)(38100700002)(5660300002)(82960400001)(7416002)(7406005)(6506007)(86362001)(2906002);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmsvRGt0LzhNeU54QWk4Um0xNmNmQThVQUpla2lCK2VwRnduQjRxWk1VOHdy?=
 =?utf-8?B?WlB3SkFOV2RZNUs3YW5JVnNwcU5xTENwWWJ4c1Q2a2JtL3VuV3Q1RXI2SW5s?=
 =?utf-8?B?ZDVEWVZ4SmpJVThLdlY5dXdpS1dndmZHUVFiVi9DTk9Xem96MjJjT0o0WmpV?=
 =?utf-8?B?bWNLN0FTTytWeVRQSEtJaUs2eERjSmNkbzNiUFVDR3o0S2pDTEMrT0J0aC9F?=
 =?utf-8?B?a3dDSS9sSG84TmU3Q0Irai81STJIQ0FmVGMwOWVtUTRLTGZEeEpFSnJia0U4?=
 =?utf-8?B?ekFyWGNxRlBJMXE1K0tyZjc5SWtOd2xvZ0toN0gxQS9KS3czUHlsbGhETFJu?=
 =?utf-8?B?VXhoTHhZVVpLZUZUbm4vVXNKTG5GanJIc2NERFNxVXlZS1J5bVVlcmh0NUxS?=
 =?utf-8?B?d2Q5ZzZzUWE5Yk1rSDNhcXNOcHhSVUp0dm1BT2ZDK0t0ano3MVI3UzdLT2Z5?=
 =?utf-8?B?Zy9WcnFFWWN6a29WM1RmTDJYZnpGck8wdHN2RFpIOXNROFlwYlBRWWFDSHFS?=
 =?utf-8?B?WnZxc2NJdGNKMUFROUlEMjFjR0NpamtFakVEZTZaeVoxNFZERjBqWGVpck1F?=
 =?utf-8?B?Y3dIaEs4cTFnTG5KazZTNnAzVytFRHZHVG1JUGNFTEpjcDFVOE11aFBKT1dL?=
 =?utf-8?B?dkVpNUgyRENwYm5vazRacjJ2WWtqMU8rOTh6T2hFaXdkM2g2Mm82VC9zNHg3?=
 =?utf-8?B?Ky8wcUwxYmMrYnpVQUpnNXUzcWdUSVYySE4ySWh6YTFHUEhWS1N0S3VUYmJM?=
 =?utf-8?B?dDc2bCtzRVJuNWpKK0N1Zld1SVdKNFF6OW8zVm1YRTlZck43OXhtZmYvTkQw?=
 =?utf-8?B?RGFEMWUxT2w1ampKR0hoS3BQUG9oZkxTendQdmRmcW85aW1JYm56bDZuNjRy?=
 =?utf-8?B?MGxYWWJVQjR6akZEK3Q4bFRQczl3TGV4UE5SK1QvWG5SdFh1Zk93R1o3RVhO?=
 =?utf-8?B?d3prd0JLeHY2VWxxeGNRYXhKbWRJVU5uNWw4cVJKVndrTTdjSG1vaUNzSFFm?=
 =?utf-8?B?NWh5dXVaSGpVWTUxUXBvWjltNDU0OHhMTXBrV0RvaVAyWDNXeTIwYmIrQUtX?=
 =?utf-8?B?N2ZaV2prMWxBL3k2aVEzYUx1LzFHczdOUnZKUGJ6cExSMVlVRUd2cUNDaTB2?=
 =?utf-8?B?ckZUTm1rNHRsMUNzay83L1BNWDJZZHczMWdlaERCUkI2YjFxUGJ5ZzhYM0dI?=
 =?utf-8?B?VXBzVlR1TmR4RHlsRWJsSWJwVktLS1JxNGJCdmpRTXVUR1lJQ1hQb01ZQ3RP?=
 =?utf-8?B?azdJeXI2VzRncVppeTZ2eGtmV3dFeCtNb0l0ZXBnYy8zalhIdnRidXhMZG13?=
 =?utf-8?B?MmxsTUV3bkhNTmNyT2dNOWI2SXRKZzBJVVhuMWVkMEljeEFNLy9oRWppT1hL?=
 =?utf-8?B?SWpNWU5tdTVyTWZLK3d2TG1GbHhRSkZhK21yc1grVHlZQ2JxVWJXYXkrZFd1?=
 =?utf-8?B?VVNnVHQvem5VT2d5TVd2UEo3WklwNU5oRS9Kd25DS2hvRE0wQjljbDRPQjF5?=
 =?utf-8?B?VnJPRUpkOUNld0EzSzFhcHlXUUFReDQwSVRrVmlVWTN1am0yelBsUDI1WnZP?=
 =?utf-8?B?TDhvM3JWbFVkeHNVUDZubmFDUEp4RTdQem5vMnV2NTRPOWs1Q2J0MUJHdWdY?=
 =?utf-8?B?WXZ5SU9mMDhKaXBDZGduWEVuclliOXJxRS80c0tkd0tzaWNkVEN1SjBYZ0Ur?=
 =?utf-8?B?NmovQWFYb1V1K1lZbzNKdnRGQVZTRXZwMFQ5Q1UrbXpuclNySE5pNXlsSnJv?=
 =?utf-8?B?M1VOUmQ1Y3hZR1hZVHZyT3pXSUxyOUZjbFBWM1hXWW1CK21mb2NxcjdpR0VF?=
 =?utf-8?B?UWs2dHFLOEdhMTM5M0dZa0ttaldUSVhVSEh1K1dTeUR3YVBxSURHN0JJcGtq?=
 =?utf-8?B?eTRydk5EWGpmaVZibTllMXFkMTY4UDJJSDM0K0s0L1M3a1R1dm1JOTBHQU1F?=
 =?utf-8?B?aEE0U1lMQVZVN0trZWNQUUpGTXk2TUEzOGd1VVQ0TE9vTitVczN4UFlJRmJZ?=
 =?utf-8?B?N0dxbUUrcis2eC9iOVlVU2o0Sm14Nlhsa1Y0SzQrblh6RnJhNGNuNUJlM3RZ?=
 =?utf-8?B?NHpuK2JENmNNSlRVSGpjRThEWC9ualhDdXR6TDIyVXNHNjZiZEhZZk1WeldE?=
 =?utf-8?B?WmVrcFhoK05CRWhQQUJwS1QrUllXZWRvQVBDejd6QlM0R2FPbVBDdUxnM0d4?=
 =?utf-8?B?a1E9PQ==?=
Content-ID: <1EFCF1F2EBB7CE48AB9819352B425CDF@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba13ab62-4e14-4773-a7a4-08dac7746ef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 01:46:51.7407 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QKK1Ze0TAVAfwWgEyaoUrtbbVOPHC0I6JwVjIkCWtOO486x0EtRlFirBY/ui7f2i3e59aPw5QoBSkPS993g+Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com
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

On Wed, 2022-11-02 at 23:18 +0000, Sean Christopherson wrote:
> Acquire a new mutex, vendor_module_lock, in kvm_x86_vendor_init() while
> doing hardware setup to ensure that concurrent calls are fully serialized.
> KVM rejects attempts to load vendor modules if a different module has
> already been loaded, but doesn't handle the case where multiple vendor
> modules are loaded at the same time, and module_init() doesn't run under
> the global module_mutex.
> 
> Note, in practice, this is likely a benign bug as no platform exists that
> supports both SVM and VMX, i.e. barring a weird VM setup, one of the
> vendor modules is guaranteed to fail a support check before modifying
> common KVM state.
> 
> Alternatively, KVM could perform an atomic CMPXCHG on .hardware_enable,
> but that comes with its own ugliness as it would require setting
> .hardware_enable before success is guaranteed, e.g. attempting to load
> the "wrong" could result in spurious failure to load the "right" module.
> 
> Introduce a new mutex as using kvm_lock is extremely deadlock prone due
> to kvm_lock being taken under cpus_write_lock(), and in the future, under
> under cpus_read_lock().  Any operation that takes cpus_read_lock() while
> holding kvm_lock would potentially deadlock, e.g. kvm_timer_init() takes
> cpus_read_lock() to register a callback.  In theory, KVM could avoid
> such problematic paths, i.e. do less setup under kvm_lock, but avoiding
> all calls to cpus_read_lock() is subtly difficult and thus fragile.  E.g.
> updating static calls also acquires cpus_read_lock().
> 
> Inverting the lock ordering, i.e. always taking kvm_lock outside
> cpus_read_lock(), is not a viable option, e.g. kvm_online_cpu() takes
> kvm_lock and is called under cpus_write_lock().

"kvm_online_cpu() takes kvm_lock and is called under cpus_write_lock()" hasn't
happened yet.

> 
> The lockdep splat below is dependent on future patches to take
> cpus_read_lock() in hardware_enable_all(), but as above, deadlock is
> already is already possible.

IIUC kvm_lock by design is supposed to protect vm_list, thus IMHO naturally it
doesn't fit to protect multiple vendor module loading.

Looks above argument is good enough.  I am not sure  whether we need additional
justification which comes from future patches. :)

Also, do you also want to update Documentation/virt/kvm/locking.rst" in this
patch?

> 
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   6.0.0-smp--7ec93244f194-init2 #27 Tainted: G           O
>   ------------------------------------------------------
>   stable/251833 is trying to acquire lock:
>   ffffffffc097ea28 (kvm_lock){+.+.}-{3:3}, at: hardware_enable_all+0x1f/0xc0 [kvm]
> 
>                but task is already holding lock:
>   ffffffffa2456828 (cpu_hotplug_lock){++++}-{0:0}, at: hardware_enable_all+0xf/0xc0 [kvm]
> 
>                which lock already depends on the new lock.
> 
>                the existing dependency chain (in reverse order) is:
> 
>                -> #1 (cpu_hotplug_lock){++++}-{0:0}:
>          cpus_read_lock+0x2a/0xa0
>          __cpuhp_setup_state+0x2b/0x60
>          __kvm_x86_vendor_init+0x16a/0x1870 [kvm]
>          kvm_x86_vendor_init+0x23/0x40 [kvm]
>          0xffffffffc0a4d02b
>          do_one_initcall+0x110/0x200
>          do_init_module+0x4f/0x250
>          load_module+0x1730/0x18f0
>          __se_sys_finit_module+0xca/0x100
>          __x64_sys_finit_module+0x1d/0x20
>          do_syscall_64+0x3d/0x80
>          entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
>                -> #0 (kvm_lock){+.+.}-{3:3}:
>          __lock_acquire+0x16f4/0x30d0
>          lock_acquire+0xb2/0x190
>          __mutex_lock+0x98/0x6f0
>          mutex_lock_nested+0x1b/0x20
>          hardware_enable_all+0x1f/0xc0 [kvm]
>          kvm_dev_ioctl+0x45e/0x930 [kvm]
>          __se_sys_ioctl+0x77/0xc0
>          __x64_sys_ioctl+0x1d/0x20
>          do_syscall_64+0x3d/0x80
>          entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
>                other info that might help us debug this:
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(cpu_hotplug_lock);
>                                  lock(kvm_lock);
>                                  lock(cpu_hotplug_lock);
>     lock(kvm_lock);
> 
>                 *** DEADLOCK ***
> 
>   1 lock held by stable/251833:
>    #0: ffffffffa2456828 (cpu_hotplug_lock){++++}-{0:0}, at: hardware_enable_all+0xf/0xc0 [kvm]
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a0ca401d3cdf..218707597bea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -128,6 +128,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
>  static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  
> +static DEFINE_MUTEX(vendor_module_lock);
>  struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  
>  #define KVM_X86_OP(func)					     \
> @@ -9280,7 +9281,7 @@ void kvm_arch_exit(void)
>  
>  }
>  
> -int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> +static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
>  	u64 host_pat;
>  	int r;
> @@ -9413,6 +9414,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	kmem_cache_destroy(x86_emulator_cache);
>  	return r;
>  }
> +
> +int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> +{
> +	int r;
> +
> +	mutex_lock(&vendor_module_lock);
> +	r = __kvm_x86_vendor_init(ops);
> +	mutex_unlock(&vendor_module_lock);
> +
> +	return r;
> +}
>  EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
>  
>  void kvm_x86_vendor_exit(void)
> @@ -9435,7 +9447,6 @@ void kvm_x86_vendor_exit(void)
>  	cancel_work_sync(&pvclock_gtod_work);
>  #endif
>  	static_call(kvm_x86_hardware_unsetup)();
> -	kvm_x86_ops.hardware_enable = NULL;
>  	kvm_mmu_vendor_module_exit();
>  	free_percpu(user_return_msrs);
>  	kmem_cache_destroy(x86_emulator_cache);
> @@ -9443,6 +9454,9 @@ void kvm_x86_vendor_exit(void)
>  	static_key_deferred_flush(&kvm_xen_enabled);
>  	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
>  #endif
> +	mutex_lock(&vendor_module_lock);
> +	kvm_x86_ops.hardware_enable = NULL;
> +	mutex_unlock(&vendor_module_lock);
>  }
>  EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
