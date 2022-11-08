Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFFAC43217
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC154BAD9;
	Thu, 10 Nov 2022 09:51:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0uhrrXFbWV1A; Thu, 10 Nov 2022 09:51:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2AB4BB43;
	Thu, 10 Nov 2022 09:51:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E94F4B87C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 20:09:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S9R0kdBWe2Iu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 20:09:36 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54DAF4B862
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 20:09:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1667869776; x=1699405776;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=VkqNyk2uy7aZU4BJCc8txVHZE1SS4+Ujzdx5wfRzL4c=;
 b=HYlgDrPJ4WK9TT+Zgig7WVraFAKWlb9V2s8Vwa270QbAuoVCJKPnZQrl
 x5lsqSvQoKsYhOqGGPlsfDrRx6/gXTClwdKW8k3CQ1FtEVyuv+x9YANeQ
 CWfhyWZi9xxBFwPmeEiyq+icPX44D385xeSLBeC8cQpYJTk/BOkK1v+98
 vSAyP1K5pkHFT9fxwhTz4+P25nRiNB/Yk8Toan9h0dEs7tIHZhNqT65yy
 s+iMcvw2p4cVNwBq98/m3k7lOUyVAUilnK+5Eqty+318hrh41FVVTvUP0
 RZu342bxB6VzjPkfpHG8t6n7QO3nrt9sgXjW/N6PUtQeVgszsvoYXSt/g w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290288950"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; d="scan'208";a="290288950"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 07 Nov 2022 17:09:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="705098742"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; d="scan'208";a="705098742"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
 by fmsmga004.fm.intel.com with ESMTP; 07 Nov 2022 17:09:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:09:29 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:09:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 17:09:29 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 17:09:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yqj7/9VmIbXC8sWWzshWUHoOZVBWO5A50PHV13zSwJ4O3Wu4aH6tm2ODuuhJYIZA8y1Q5UKJyfjdZewLxcs8jXRr0ICu6Sr/gR72hXQL6TjsvBVp/MSDXlASwgq8JCD338smfg/9yI0lemfqOtvBYvCOMGEKVj/MpD59QuUUTjYtSbcjbFD0Wk9ZRms+N4STopCmfbjU6F2dwhLvwCbehhTW0q8AkAIXUcxLWlF75lOzGhKvHx8fXSVmWTyCtfxwIuMR+U+aj81/RU1eNGotaYnZw9DISqL9vhbp1q0OXIK8Uj8vkzldwK361QA2W7+FZ4oEW+jahMhaq8Bi8haowQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkqNyk2uy7aZU4BJCc8txVHZE1SS4+Ujzdx5wfRzL4c=;
 b=ktrt00OaBdyPTXiRYVEEyAxqKSJZCj4pdOnlEUrU910WkZ2nwB5VUfl643Q1YqUInmYX7aK2OZmBTpZKbfcEtFmTHJAqJ7Cc+b3fPR6auMsbaWRekzLSERUdCRIxxy3s9npxpG2Kg1NrplLW6u5+Cjaut8XwD3ocOEtOUk3FNWOSuHNF3ShWFJd/IARx16bEKZ2/oxd/ZOdGKdrQmM2/Z5rh2spJiAgCN965DOQk8kM7cMzZeJSyBq8nKJdLA9qakpA6ngoinXlZnGQa4lNNjym6ExCxXFp4bMF2hXEpkV0ta61OpHQGzuawyJQMTP2SsPMKrL+BXTs+wDEvfVIr8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 01:09:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:09:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Christopherson,, Sean" <seanjc@google.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Thread-Topic: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Thread-Index: AQHY7xGUTp4lUVPML0yWgaOmsA79Vq4uXPOAgADckACABM0oAIAAOK8A
Date: Tue, 8 Nov 2022 01:09:27 +0000
Message-ID: <bf29fe1ac84cae8ddb06e566b56c653600a1901c.camel@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
 <20221107214634.GE1063309@ls.amr.corp.intel.com>
In-Reply-To: <20221107214634.GE1063309@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5078:EE_
x-ms-office365-filtering-correlation-id: f3173709-8644-456d-08c0-08dac125e1b6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tRVN7ieVEs7UUPBr4s/6sRl4w30qcOlzXJ0bb4EXvUEO5NruxHDDGfhugZflEVHHky0k4r3zuwj1rcJ1BRFMBSytllvDW5zm9vbussiAbfu7cq0ME0zpUBTJ5zBABx96zq6yw/hjQaYqER1lx5F2MSRal6JQv9fWsywxbj1qI4YyJ3rkijevLFMgzotqAeAQbifEAbKzKq0CcgNY9NqvAaXWcTBNsCqyDZlR72Dq977kJnr7903EHeDwp4mhZ+6k9csCID3VAvqfAtHa7txS21YPsWA5euS9ExGMVSp6QbGwM2pnUQzc9ylfovHwd88qnv/lI2wT94xaD8o39PQp6rl6zEeBSgyyuY/idzg050ymkN9NZ20GOLaMkxhZw0rEh4n3dhlIR/cqixCjpsWVCH11/4mrAjbO3of6aWG63jmPRLYPtfg1IaNF5sfBlRfnjwkWjjRkOEV5WGDyBiPxwRTMu56Z9p3BGfNAK9Y+pBn4MGHX+eCO3n6tJLEewd5JspDgUgt7H2P0rMFwKIzqMRgl+mOc3lsbL7qwj67XZgscSoQbWI+vLt2an9CJcsbsf6zSfDD3Pd349uydzak1YhsqvET5v0v/RjISdOSs9tMOCm2WJF8SxJKWTrtUA1gXpGC8DYkgVfMw+SBELGKt/9Suf93mAHfufK8K/yTTM3WcxZ4VGoPu2tzXe8p06JVGZATPN5SSjS0N07fLkx4tr4NI2CxEqqnqRwC/JZ/dLQIugMh7VJ286DULquEX+i/CXR4iRGBUNjs8Dw3NLLnAog==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR11MB5978.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199015)(26005)(186003)(6512007)(83380400001)(82960400001)(38100700002)(2616005)(122000001)(38070700005)(7416002)(7406005)(5660300002)(2906002)(8936002)(41300700001)(6506007)(66946007)(71200400001)(478600001)(6486002)(107886003)(8676002)(66556008)(66446008)(66476007)(64756008)(76116006)(4326008)(54906003)(110136005)(91956017)(316002)(86362001)(36756003);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1lEMjc1UklnSWJpc2JKVml4ai9PNkxrRnordm9DMzNTdHJLbkFOOExGZmRH?=
 =?utf-8?B?cmJiOE5Td3dpZDlkUURzSzNDeDRtSmhoRmRrenVqTm1Ldk04NGlGSTRZNzBV?=
 =?utf-8?B?dzhFcVBZdWFoRlZwcXg1RS93UHV5Ky8yNm82bHdObjlpTzhVUzlLd0lyaG5s?=
 =?utf-8?B?eGVLall3NGY1RkZmL0VkeU1Galp6NGY2OU52bEdRRm9OdUgxQjk5MXZOa3FC?=
 =?utf-8?B?enM0ZXVwQytsU0JTcU1tbm1WNlFLYkVtWmNDZVlBY0lzeSt4cTRnWDUrVm8z?=
 =?utf-8?B?TjY0ZW1sUWtRZlVyMXhhdlhFcnlpdUZoaGJmdW12KzRLVUpQcGVQM25kS04y?=
 =?utf-8?B?cE5vcm1CZW5kVkRsNFJYQVVPb3gwRXNiOGhGWjN2T0c5V0pScjVudWN5N2w1?=
 =?utf-8?B?SjUxU1B5NXI0TWVHZGpzNGZHd1hwM29vdkVsTEd4L05uRzhHZ2ZvYU9rcnJl?=
 =?utf-8?B?cHFqOUJqaWVLK1BrSk9PM2xvbGdDN25HWGNUZkdFMERUdFZWMndMN2p3eElq?=
 =?utf-8?B?TFllU1pzRDR1M0VBOXZuSnNZQ2VaY3BMV1lPK1dlenVWeGZBUUdHbW9VNkt3?=
 =?utf-8?B?eUtQVHBUd1FZRGVtZjFobGw1dlpZTTBYYlJLVHllUmErVStiY3pjeFVaSlFF?=
 =?utf-8?B?QTQ4dFhCU0RYZ1hwWHozOTVIWStCWXY5YjJqT0ZrTFZMVjQwR0F0eXFLTCs1?=
 =?utf-8?B?UDI4Uk9paEJWRG1hWUUwNVl1bVA1ZnFCY25INnZRaE1OVEFJc01PVXJ4M2Nn?=
 =?utf-8?B?UDBqeWdXU2JlR3VVVWphcVo5WkZ1QVJxUnhpNXZmcVF2aGF5a1RIR1ZWbzlL?=
 =?utf-8?B?Ny8zdXNJSFVtOWp6L0paWHMvazFJbkVrU2pKbUVlenJXUStEaE5mK3lzUW43?=
 =?utf-8?B?a1huZkRvOHhPc09kOThXYTRQS0ZJMGRQYjY5QndiaGJmV0VyaUw0ZTEzNjha?=
 =?utf-8?B?Y2ppWjVUNWFJdjlRUkdXVVJCam95bW5jRFlJcmhHcW1NL1NHZ1R4M0tIR0Y1?=
 =?utf-8?B?SHZPK1o1Nmw5QXI2a1dac011dWd2NGpnUi9CYnFKbTdMcFU2bk1xMjRZY2dN?=
 =?utf-8?B?aGFPR3dNU1REM09sWEoxaHpUdExqaG1LRHMvaGVYeDFoMGhVMlpXbWYxQ0Q1?=
 =?utf-8?B?OTJQK0U3OXdUVG1EWFVoc2dUSU56MGpPUlBleGFGUjgvM2pPdWVNMXhYUXBh?=
 =?utf-8?B?a2h5NzE3TTJlcElrMlIxcjBENFdZWjNOcjAwWUdDY1ltSlpDU2pVUmhqVXVp?=
 =?utf-8?B?TFNSaWpDMFo5c3IrQ2FyZkswbC9KRzhSVElNZnZLY2w3ak02dE11OUQrZUR4?=
 =?utf-8?B?aWZOTHB0NzczaWkvOENXY1NPV203TWlITUR4TElRSXNYM0lpQ1pwQ1ljc0Va?=
 =?utf-8?B?UFJCcWJ0dUxKd3pDNi9oZElENU9FK005cWZ1dSs2MGsycmlBVllwTFFmeEJ3?=
 =?utf-8?B?clcwOEtpUXEreGZXWTBhKzcySzM4eURuUVVqeFpFcjBHaERFMThtK2RHbHlB?=
 =?utf-8?B?a0haeGt2UlFEY0Z6NWpNb0pQd3kzQXBZSGYvSFIwcDdQU2lzZTZhWGlSME84?=
 =?utf-8?B?MzFRUDVBcFVHOWZIOFJBTFJpT2RQNHNMQytTRkFjYzJTeGtUMTFrR0VobFhj?=
 =?utf-8?B?U3dxNm5oRkd1bnRDaEJ0aXlsNzB4R3V0RjV5RElsdVYwS1hoaC94cklZMk1s?=
 =?utf-8?B?bEZlZzJNUThWWFBvMW54SWNSV0h0Q25ZZm0zWEoyVlJQRXo0aWp2R2hhcG1j?=
 =?utf-8?B?YkR6eHhhRkRQUDFPM3hKVXI4YXVHRGd0SjcvVzUzaHFlZEhXa2RsZHRyTm4r?=
 =?utf-8?B?Z2RMLyt1VEdZQjFOWUlSalV5Y21rd2s0Tzcwa3hPZmNwdFNTempORlRVR3JD?=
 =?utf-8?B?eW40b3RTOXhCS2FoVkp4WmJpa0xTZ0tLZlF1eERZYURXUkVxaFJFOW1HZE9r?=
 =?utf-8?B?WThUZmFTalB2NXlaL2x1c2lqN2RaYVUvMGRWUVlqSmtkNmVraWtoQm92UzZI?=
 =?utf-8?B?aThCelBneVJpMUQyb2paYVpHTld6Ym1NOXlwT0EycWI0bGFMc1I5cDQ1MmtU?=
 =?utf-8?B?ZURuZiswTWZhWlNjb0VlTWllQzI4dmdtMnl3dEd3RUE0NFY5UHNCMGlFTnpt?=
 =?utf-8?B?VUFjQ2k0NXUvNjBkU1dpMnVXaFBVbFAwS0lPMW5GdWw3OCtMY2NoWXBGKzRh?=
 =?utf-8?B?Znc9PQ==?=
Content-ID: <737100AB69F03E4EA2AF6DD9B8BD99F4@namprd11.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3173709-8644-456d-08c0-08dac125e1b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 01:09:27.0631 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qMnjBY91n3Cjz0ECxgnFn2pNqk00oWRsibzMaAk6wp+8Ix1bjWtZX0+l+VGgTT9cekEfkmGg9PfQNvAqxmbQow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
 "david@redhat.com" <david@redhat.com>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "Gao,
 Chao" <chao.gao@intel.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "Yao,
 Yuan" <yuan.yao@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "frankja@linux.ibm.com" <frankja@linux.ibm.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>,
 "atishp@atishpatra.org" <atishp@atishpatra.org>,
 "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gTW9uLCAyMDIyLTExLTA3IGF0IDEzOjQ2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBPbiBGcmksIE5vdiAwNCwgMjAyMiwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiBU
aGFua3MgZm9yIHRoZSBwYXRjaCBzZXJpZXMuIEkgdGhlIHJlYmFzZWQgVERYIEtWTSBwYXRjaCBz
ZXJpZXMgYW5kIGl0DQo+ID4gPiB3b3JrZWQuDQo+ID4gPiBTaW5jZSBjcHUgb2ZmbGluZSBuZWVk
cyB0byBiZSByZWplY3RlZCBpbiBzb21lIGNhc2VzKFRvIGtlZXAgYXQgbGVhc3Qgb25lDQo+ID4g
PiBjcHUNCj4gPiA+IG9uIGEgcGFja2FnZSksIGFyY2ggaG9vayBmb3IgY3B1IG9mZmxpbmUgaXMg
bmVlZGVkLg0KPiA+IA0KPiA+IEkgaGF0ZSB0byBicmluZyB0aGlzIHVwIGJlY2F1c2UgSSBkb3Vi
dCB0aGVyZSdzIGEgcmVhbCB1c2UgY2FzZSBmb3IgU1VTUEVORA0KPiA+IHdpdGgNCj4gPiBURFgs
IGJ1dCB0aGUgQ1BVIG9mZmxpbmUgcGF0aCBpc24ndCBqdXN0IGZvciB0cnVlIG9mZmxpbmluZyBv
ZiBDUFVzLsKgIFdoZW4NCj4gPiB0aGUNCj4gPiBzeXN0ZW0gZW50ZXJzIFNVU1BFTkQsIG9ubHkg
dGhlIGluaXRpYXRpbmcgQ1BVIGdvZXMgdGhyb3VnaA0KPiA+IGt2bV9zdXNwZW5kKCkra3ZtX3Jl
c3VtZSgpLA0KPiA+IGFsbCByZXNwb25kaW5nIENQVXMgZ28gdGhyb3VnaCBDUFUgb2ZmbGluZStv
bmxpbmUuwqAgSS5lLiBkaXNhbGxvd2luZyBhbGwNCj4gPiBDUFVzIGZyb20NCj4gPiBnb2luZyAi
b2ZmbGluZSIgd2lsbCBwcmV2ZW50IHN1c3BlbmRpbmcgdGhlIHN5c3RlbS4NCj4gDQo+IFRoZSBj
dXJyZW50IFREWCBLVk0gaW1wbGVtZW50YXRpb24gZGlzYWxsb3dzIENQVSBwYWNrYWdlIGZyb20g
b2ZmbGluZSBvbmx5DQo+IHdoZW4NCj4gVERzIGFyZSBydW5uaW5nLsKgIElmIG5vIFREIGlzIHJ1
bm5pbmcsIENQVSBvZmZsaW5lIGlzIGFsbG93ZWQuwqAgU28gYmVmb3JlDQo+IFNVU1BFTkQsIFRE
cyBuZWVkIHRvIGJlIGtpbGxlZCB2aWEgc3lzdGVtZCBvciBzb21ldGhpbmcuwqAgQWZ0ZXIga2ls
bGluZyBURHMsDQo+IHRoZQ0KPiBzeXN0ZW0gY2FuIGVudGVyIGludG8gU1VTUEVORCBzdGF0ZS4N
Cg0KVGhpcyBzZWVtcyBub3QgY29ycmVjdC4gIFlvdSBuZWVkIG9uZSBjcHUgZm9yIGVhY2ggdG8g
YmUgb25saW5lIGluIG9yZGVyIHRvDQpjcmVhdGUgVEQgYXMgd2VsbCwgYXMgVERILk1ORy5LRVku
Q09ORklHIG5lZWRzIHRvIGJlIGNhbGxlZCBvbiBhbGwgcGFja2FnZXMsDQpjb3JyZWN0Pw0KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
