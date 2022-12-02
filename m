Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3418C4321E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 12:16:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 274D24052C;
	Fri,  2 Dec 2022 07:16:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MIQp1TJ3m3X3; Fri,  2 Dec 2022 07:16:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A02C140BDF;
	Fri,  2 Dec 2022 07:16:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A14AF4052C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 07:16:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-RLACxCCjWg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 07:16:29 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E926A40443
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 07:16:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1669983389; x=1701519389;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=iMi9cp3HVbc9+2IblD0hRNZ81/PXaoT7ZFy2T0sea+M=;
 b=de1hu0TudJyp5I1CK4SS5AfK2Np0Jv7RRbrp+iAuj115VovAwu4JHDmd
 6ns/f1F1Y/g+2Gxoa0qVayrVGTBhnzt+o2G64mp04Ets9DWDo+NXHGp+n
 3govdS4Czts9M/3w8JTb/FEON5wanvr6nJZ9snvbpQb5ukyvuz2O3Eu0u
 Z1CDwgTiXTXPKvIFz8589H7MDaLsMLPY+bCDFlaGFyh+iTfMVftrsobrb
 2zx3NRWgGFgmOR91lOC/IYa4AP9u0g5ATm5rHTbx1XldQNkZqo7GKEdn5
 enP1lbjQzpj4bCiBiusjOdC1C+J2hvPd+xybAV4P58HPxAXlghzAjXoK4 A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="380230651"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="380230651"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Dec 2022 04:16:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="713600670"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; d="scan'208";a="713600670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga004.fm.intel.com with ESMTP; 02 Dec 2022 04:16:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 04:16:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 04:16:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 04:16:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 04:16:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4iSgLCb2DNUupUOnUr8tamzTGn1o070pM+aNo1B5oGNpS3VWSwKoZEUSGc04SLBJNSAyoBkgvbCkdsiZSccrMSi75MqsVAM6VZwN+iNolaFhTc2pWJd9r+/GxyT8nOPGld6Amj3Y1xT0LsqXJoNeTSv2gR9dashAr4kBBWtBMi5ZpuqU191ltZz6LSU2ZXLJMcMEP55PIYV49nIMR232ui/88GKjcptfX5zPQXPwNj8QervYAsXEfexeSVdBHe4MXf1gJUBe2/zY+7FJyCJyjMBqgXFR3ZzIGZjdvln+D3shlbycAPVU+ImweVkLDAbKzat10APUC5lXrOJmSS1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMi9cp3HVbc9+2IblD0hRNZ81/PXaoT7ZFy2T0sea+M=;
 b=YPZYsKpaoSN45P3CyUVBQDTNt3kEivnsBIPJOmK5ngUvmfgpaULNCWsDrKO9YoYwas+VKUl7QpQMHx86vHi/gySAoCNEQ13BZ+j/O/npmsO7bxPWJfoOhc4GhB63OJdQitbbjFeEAQqemTeFXTScCgyadR1YrcjG05VARc/nzFM5EcZeA9tLONe2WwD8eFN4jBSvD7/iUc/AMr+V1MpuPgAp1uG6dGzkRW2cGcHSlKmPX8mycpQaZoEOqOsVWZC9Bht39OZXh2nQH4MiBcm20iZiEI5d46WBFAdKf0MFjCX/EbK4WxQPiSE9YKMhlN+WunDHZ/e3oY9RBue7b8psqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 12:16:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 12:16:22 +0000
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
Subject: Re: [PATCH v2 31/50] KVM: x86: Do CPU compatibility checks in x86 code
Thread-Topic: [PATCH v2 31/50] KVM: x86: Do CPU compatibility checks in x86
 code
Thread-Index: AQHZBRD2PDkXQ8EFfEOzFA5Z56fIH65ahaKA
Date: Fri, 2 Dec 2022 12:16:22 +0000
Message-ID: <fdc18aa646a1636d0523b3848d938e43e7553725.camel@intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-32-seanjc@google.com>
In-Reply-To: <20221130230934.1014142-32-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5657:EE_
x-ms-office365-filtering-correlation-id: e48cdc5b-63ad-47ab-afd3-08dad45f0697
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QKM/oHcYYUILrWMGqgy4u35nYTK+Kv+7ODn63hf0hIrQT2L7paFFN/EkaeGihhIz4SoFJdC9vd+ffVpXMXxLwFR6ol31qgZxEArMjKQCKwIx1nygq16mdHwj6WfOUWxm9W2T9/gkLnIxfjyzDlGq/hd4pqAqbXdzH9Gztkr5OJ0C0snT08DLugu1KFQoLseR+V6cmk+4O8kFzTYOdWwOGxWvxqAgrVwVJ4SZYTwLx3F3Otu8yTgfMpH7DfsSFs/RGDzt5rdvSlsTjEynTCWEhndaBBelHae0JDwSWqSL/Qvjnx37bu8/otGTWM6MCX0hKF0EIWNuhAjKl++shy5Lgt5HHbMkUI903DITaG0smQ7rUeP4v+QvtbhVtWgOB7GLaMULXzzK2H7N9e8Lsd3Y/lEQKtb+3Vo1+xYl/j/HrQ4yXm9zbABcSdVbvGpPgFd0+9hRcA0mXk4XqJBAWDU3GGQeidl4/wm+VedrXk3PRAraFVrNSKfQWvpY+bArLYtdnPVoLuBpwUusv3frRYB+K/C0YBST3a+35wnt9PhyOEUBR5JwDIlSx9BFoktO4hnB6HOYJYGf6dxLAye2tLi3TCncsnrS7dvIGZ7dKoeDOkjo4TynYtx+rY1uhuEOT+qUpeF6ilo43Hbi4CK4cN7RC+QEVLhXNtyECPSzi7nzA6d5PcJNQAvZfGm5j6UBGtMoW/mHBdE2AI8+HnZ+cYaENj0w0aBtiyZ33OjYqqJXv5M=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199015)(122000001)(82960400001)(38100700002)(36756003)(921005)(38070700005)(86362001)(316002)(110136005)(54906003)(66556008)(66946007)(76116006)(8676002)(64756008)(4326008)(66476007)(66446008)(91956017)(6486002)(478600001)(107886003)(26005)(6512007)(71200400001)(6506007)(2906002)(4001150100001)(83380400001)(2616005)(186003)(41300700001)(7406005)(5660300002)(7416002)(8936002);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0FENFNHdUhLZEM3L2RlODQvcWVoZFpqaDA4Tm1LNURVQVpidHh1NEM0OW4w?=
 =?utf-8?B?MzRqaHg3SEYxaTNSblpIcUpKYXRNNytYb0ZEUEhrM1I2TmREclB3U3FKOEgr?=
 =?utf-8?B?TFhSWkJjblU2STdsdGZuZklUaS91blJhZCtWNmZkQmdqRUkyQWZ5MHc3SUdS?=
 =?utf-8?B?WHgzeFc2OFM5UisvYjFPYkhsNkN4QWNKRmd3eno3TGU5WGpZUjdlbzI0QjEv?=
 =?utf-8?B?ejk2U09OZk1GRERkZkY2cElaOXlKV2ZUVnRoODg2YWFXWVFaU3RtWTZYQ2ZH?=
 =?utf-8?B?RVhUOU10TXAwR0VIdkpOTzYyS3hLbXY0R3JzazQyWG5BUEpNYVgxLzlUY2NC?=
 =?utf-8?B?Z2NZblFuM3BVem9FTnFLZEZ6cm9vUEo5RVo1enMvMHN5VEw5MlFOSCsrdGh4?=
 =?utf-8?B?RzhObGZWWXNYeVpsWnc3SlF0Qm93SURZZU1SbmtCeFRLdjRPT3ZLbUZobm5p?=
 =?utf-8?B?ckVzTHlJM2hEelZkR1JIQ0ZhRW9UN3lBUWFZK21tS2NZazRDMHFVSUFjamNp?=
 =?utf-8?B?SDBWeHkxU0JMQUVsVWNnbjZKc2taSGFGN1hHZGd4bkJyMDRaZFdPSHVTMVZR?=
 =?utf-8?B?TEdiOFJ6bGZlZ0NDOXZnbjRJaXMwY1hWMzg4YVBZYjhFZHo5a3VhRHUySFNI?=
 =?utf-8?B?UzdWVUhWK1ArODJyQUMxV0JLaGRHNFZTb1lqbFgrY01kaGp4U0JEcU9QbmE5?=
 =?utf-8?B?U0ZZc05QL1hiT25CY3dLa1NreTRyRVRrRElEeDZEbCtTQ0tpZjN1bGpFcjJs?=
 =?utf-8?B?YTRpd2JZWWp2M2V0YW5ncnd2MG9nc2c1alFMMVdpUnI0YlA3ZmlaS2o4Wjl6?=
 =?utf-8?B?ME5xWENiNEtZbCtJTWRvYTUzL1BGNFQvV2cyeDlrRTl0Ky9BTjgyWTNMdXQv?=
 =?utf-8?B?anFvZzlZRWdPamt5bk9XS3l2WjN0OE1KOUtUNk5ldGlPQWZvdTZDc0hCNWpm?=
 =?utf-8?B?UFdvc1JRbFIxQ3ZzRWdjOHpOSnRKUjhyY3hIc3NjTjllY0VnYTJVbXMxTTdY?=
 =?utf-8?B?cHI2bmxtd2ZjeFVjYy94VVVQOHJ0OWtMdjJicGs5cFZDVFJ6ZG41Vy9Wa2JU?=
 =?utf-8?B?dU1RcEFnNUdkZm1CTnBKQk5VLzI3RER3dHhDQmxiRnM3Z25UQWJQblVvREh6?=
 =?utf-8?B?bFRhL1VlbHNtaSt2TlhKSmQ2TXRJWkVUVXRRZzI1KytyUFRLK0t0emRFM3pL?=
 =?utf-8?B?UmdjTzRDVHJuQjI4bnM2RXZJOVBsVHJsaGl0a1VyQUNSaWtGSjZEZTZpOWdH?=
 =?utf-8?B?VjcyY1AreWxvcnZRYjQ3TDZ3Y0U0RUhlUE4yN3BDVXFqbUY5RCtmR0pqa2Z4?=
 =?utf-8?B?cURxenM2WFRIWGFuN2xJTGlvNGhTaFE3TDlKR25nQW5TMmRoM2ppaHo5ek5y?=
 =?utf-8?B?RXZJclNRa3dvbjg4dUIxMXN0bjVZbWZiRklGMWFuUFpGUi84dmFaNHplYzFE?=
 =?utf-8?B?K3lGZFowdXIzWVNURVF3M2RqMmsyd0tJL1R0M3RuZmFDVVMxTlRiS0E3enpa?=
 =?utf-8?B?VHNjUlJwZldqRXhBU0pkb3dON2VUeVlFQXVqbGF6TU03d1FGWVdSTUloS1dO?=
 =?utf-8?B?cWcyNHpjNHRMdGRCQmRIMFNTY1BQdFZlVm11QVpMTGV2amxSMG01R2dqbkVX?=
 =?utf-8?B?SzdKNDM2VzBPNlR2LzVqVVBxUWQvbjJOWDhPNytoMWcwS05rcE9RQTF5NDdM?=
 =?utf-8?B?NmVUQVB1eUk1UVhDcGFxcXZLTE5PbnZKOVA5YWZ2dmJRTkM1Zi9HVWxNZlZX?=
 =?utf-8?B?RnF4bUZRZzM2eUQzNzhWOCs5MVZXYlFZQ2V5Vk12YVAwUFlhR29kOURqMTFy?=
 =?utf-8?B?OEdzTHJUUEZTQ3N4K0lRbUJGWjcxdTNWZ1VjdXdrVTk4UXpEenM3ZCtFdUhE?=
 =?utf-8?B?MGJBZzJQVWU2VzByM0Fka056cmE5dFJtNjA5cnF2eTd1M2xqc1lVM2dBb2J2?=
 =?utf-8?B?ZkI3Ui9GaERqR3NycGJWcUh6M2ExQ2w4c2pGQ3pWcXYzYmNlY1c4YWY5Z255?=
 =?utf-8?B?U2c5dllXMEQyVGNVbUFsQkdzcUxKZlZPanFUYy8rMW9kNWhyUnMyRW9naXZp?=
 =?utf-8?B?WlBqTmRwRHVrRWpUcU1LYXZ3ZWZuYzJDLzNpNnpDS2hETHhkVEtYQ294aCs5?=
 =?utf-8?B?SDk2a0xQK0VUa2orRmhncERsRlhHVTBteWxDSS9iK1F6TUhpM0ZFcDM5T0tt?=
 =?utf-8?B?M1E9PQ==?=
Content-ID: <728564E9A355194291ED5B0EA1135406@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48cdc5b-63ad-47ab-afd3-08dad45f0697
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 12:16:22.3776 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7RHcwjIm102bqYiHSz1Qs8a6ixcOxMqT3uUkhusGMkamDpdPRZAV4PY0va+P8fUGfh4v1lanozVoR4dq2FlIhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
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
> Move the CPU compatibility checks to pure x86 code, i.e. drop x86's use
> of the common kvm_x86_check_cpu_compat() arch hook.  x86 is the only
		^
		kvm_arch_check_processor_compat()

> architecture that "needs" to do per-CPU compatibility checks, moving
> the logic to x86 will allow dropping the common code, and will also
> give x86 more control over when/how the compatibility checks are
> performed, e.g. TDX will need to enable hardware (do VMXON) in order to
> perform compatibility checks.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

> ---
>  arch/x86/kvm/svm/svm.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c |  2 +-
>  arch/x86/kvm/x86.c     | 49 ++++++++++++++++++++++++++++++++----------
>  3 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 19e81a99c58f..d7ea1c1175c2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5103,7 +5103,7 @@ static int __init svm_init(void)
>  	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>  	 * exposed to userspace!
>  	 */
> -	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
> +	r = kvm_init(NULL, sizeof(struct vcpu_svm),
>  		     __alignof__(struct vcpu_svm), THIS_MODULE);
>  	if (r)
>  		goto err_kvm_init;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 654d81f781da..8deb1bd60c10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8592,7 +8592,7 @@ static int __init vmx_init(void)
>  	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>  	 * exposed to userspace!
>  	 */
> -	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
> +	r = kvm_init(NULL, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
>  		goto err_kvm_init;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66f16458aa97..3571bc968cf8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9277,10 +9277,36 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  	kvm_pmu_ops_update(ops->pmu_ops);
>  }
>  
> +struct kvm_cpu_compat_check {
> +	struct kvm_x86_init_ops *ops;
> +	int *ret;
> +};
> +
> +static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
> +{
> +	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +
> +	WARN_ON(!irqs_disabled());
> +
> +	if (__cr4_reserved_bits(cpu_has, c) !=
> +	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> +		return -EIO;
> +
> +	return ops->check_processor_compatibility();
> +}
> +
> +static void kvm_x86_check_cpu_compat(void *data)
> +{
> +	struct kvm_cpu_compat_check *c = data;
> +
> +	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
> +}
> +
>  static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
> +	struct kvm_cpu_compat_check c;
>  	u64 host_pat;
> -	int r;
> +	int r, cpu;
>  
>  	if (kvm_x86_ops.hardware_enable) {
>  		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
> @@ -9360,6 +9386,14 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (r != 0)
>  		goto out_mmu_exit;
>  
> +	c.ret = &r;
> +	c.ops = ops;
> +	for_each_online_cpu(cpu) {
> +		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
> +		if (r < 0)
> +			goto out_hardware_unsetup;
> +	}
> +
>  	/*
>  	 * Point of no return!  DO NOT add error paths below this point unless
>  	 * absolutely necessary, as most operations from this point forward
> @@ -9402,6 +9436,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	kvm_init_msr_list();
>  	return 0;
>  
> +out_hardware_unsetup:
> +	ops->runtime_ops->hardware_unsetup();
>  out_mmu_exit:
>  	kvm_mmu_vendor_module_exit();
>  out_free_percpu:
> @@ -12037,16 +12073,7 @@ void kvm_arch_hardware_disable(void)
>  
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
> -	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> -	struct kvm_x86_init_ops *ops = opaque;
> -
> -	WARN_ON(!irqs_disabled());
> -
> -	if (__cr4_reserved_bits(cpu_has, c) !=
> -	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> -		return -EIO;
> -
> -	return ops->check_processor_compatibility();
> +	return 0;
>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
