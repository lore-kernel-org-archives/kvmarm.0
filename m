Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D5BC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 14:32:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE204B9AB;
	Fri,  9 Dec 2022 09:32:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VBaAYME13Zy1; Fri,  9 Dec 2022 09:32:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 276E64B9D1;
	Fri,  9 Dec 2022 09:32:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5AC64B9A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 21:38:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1pCb9fSEYfVq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 21:38:19 -0500 (EST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2D34B996
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 21:38:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1670553499; x=1702089499;
 h=message-id:date:subject:to:cc:references:from:
 in-reply-to:content-transfer-encoding:mime-version;
 bh=LRIVnDgtI3pNF8EsnbjyQe3jwIxDGCQ9jKtpA9As9I8=;
 b=Sy+yAkomG80Ah8KL+hDgwJsCisHqEfbLFbrWElujl8v1qIjKPuo018aD
 3vmw0YDYkUDYVvsHEb+bYASp30lO5amFbgG4OBFpThZMuZNkRa1n719YM
 qvTVv0rPk74TVjj6i5lUYSKYEtnZ7ye5UbZmiOqWQBpLCTizZmihdh5Px
 3fKHGC1bcbDIJ+0oylUib3fGOSyLnzvnGjx7OyRkpaXeF6Q9gcjGatFp+
 Kih4sMVEPDi6NddWvEdDweW8gahJ3E/12ezG4oPThMy5+pERA4VvWd857
 jUOebu6OQ4gBDlgsneGOZTMg6PrFhpOQq6eRxU25dOF68jNfcCoOSlWkX w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318517061"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; d="scan'208";a="318517061"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 Dec 2022 18:38:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="640874824"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; d="scan'208";a="640874824"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by orsmga007.jf.intel.com with ESMTP; 08 Dec 2022 18:38:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 18:38:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 18:38:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 18:38:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 18:38:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDY9AUWlGBZnj+XTMfYnHTlVYbbwwBopSU97XWQaNQ5mXaxspYEVtApu1TXs7BztP7EMCUMo+ChRZbDGFnKCvvkw/53uGBas66HE+q5+r6Z/GpY13V6gxyhGn+xqmigVELyINsxT9ZTl20HnHaz7JG8edbhzUxw2BoUoU7KRc+wD+tX0g5QJsHkwQcc3hKcTQYB8toM7/wty5wUNfr9XlAiGsEbpFpWoKgHKPlRn9U84Eq9lAEe9UFaJ2xKcz0fJX9UEvpjbkN6g2RP0mzFJ22oSVWQ/dpeDbSy5ME8AzDYKL1e1zGk9pozHjShJudZA+Id4H5HQfOlX0pT2iNHRVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Z0YDB+vzVgOHlQGauN3OImJ1wxCVp1+bavqurxmt94=;
 b=XBaiE33AuaJ85QZYNuVzqGLM6IEz72UhxxiaTWng+j9q+ODSJgnd3ivJ2Al8OfhfXbNMlPiaGebIixj1yyh52vS+HS7QDnR0QTsRhlqf9HHu6pLOXSsjLBzxu86TY3J5WTsSOMRuKFato/hJ7CBa2kVdyMLQ65RpS7S9uz8SoeDgeW1z+5NowO5MkmrzwX/UIejSn930qcKmw/odmJ/VuCx7dZjX0ktkWX6z9U6CSPKGTIHopPjkpMM85snJTY6MjwezVdpqEZcoVNjVLn+wnSWaIK9AHKrUYhOXgpVFB1cP6/nPHPYvN3KIbAcBlpZ1EyZPFSCd83VgHr8KW5Zk6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB6422.namprd11.prod.outlook.com (2603:10b6:8:c6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 02:38:06 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 02:38:06 +0000
Message-ID: <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
Date: Fri, 9 Dec 2022 10:37:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221208193857.4090582-2-dmatlack@google.com>
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 17bd9d23-f727-402c-8981-08dad98e66ef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NJPTTRtQs9AEXaoROXyWDvBS5EDkAeU0fyncUMUVOoKlGHcRn5Bma43rYexsmYI2rWv/PtSNVR9lCMBpZk/QFizTSjAfltv4z+AYmzAEsoFKaiVd8y/CW8OGclIKXy3HHDHDaU9v1Z6o1Ry8+rzByv03031m+UTBPXjMv7srmodn6ZI/xjC5KwIxMxoQUV4Vz6VdQ/LObRYG61WyddviGIHxAJx+iXYvAvQj62XoVCXn7hru5kK8GL/Zpyx0wJdQ+7nuc+2AFcRnWAheONhyHBzIVtXQWyIUNtN+k8Tm+jqfegKUN+XmYOr+DRm09CgbpPCJBpa0PDUFx2wR5LMOlKHeGW9VuBx+4H012MigDNMGHoMTHcuBqXFGl4JYxOzBzLzwtG2vIpMqNTuykRPBHmtJ92jFaKt1F84cAFdaYHgcIE+yK5f6nm9OWxPbC2vMeN/1eR59xR7gEOE5o88eXu1ahmn8IZnQPhAzIiLXYHxSh42sVpc1HqqXXzcjQ4ADtuHeIEs5vwaI1YbRj+nf9QhH/xm15NA4EHyG87+/0Rx0mrIol7pJJa6lqAQfXyXt8f5706L7YxEZbuAdbAHx7GI3p7NV+LsX7sdrQFKKOJwbqfHNsUC68+CIHKeX5wGUYZbvWaYuaRjTVrqx9xuyAepoV9oz7qN2ziFRo6LOK2pYJeeSNqkJ/3aq3fw7QaQZUPnCykJpM1Vjvdedezu3jpozlvP2sfAeTKDXKAkYx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4965.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(6666004)(6506007)(41300700001)(6486002)(7406005)(478600001)(7416002)(66556008)(36756003)(4326008)(8936002)(110136005)(54906003)(5660300002)(66476007)(8676002)(316002)(86362001)(66946007)(53546011)(31696002)(82960400001)(26005)(186003)(38100700002)(2616005)(6512007)(83380400001)(31686004)(2906002)(45980500001)(43740500002);
 DIR:OUT; SFP:1102; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTZpUzlPNnNNVGlKRVd5UElsVXpiSWtsbTdTK3FTSkEvcHh2a2xXSDM3ZUJB?=
 =?utf-8?B?K2NMczFWWWVrdENIR2hUZmtxZ3BZeElvMTB0M051QXB0WlFYenhZTXJDMEt1?=
 =?utf-8?B?Qmdnc1U1RWhKcllZZGYwV3JVdnkvSERnSDAwcHZjWk1uK29INEx6enlaQXdy?=
 =?utf-8?B?TWhiVjBwMnpKYXp3ZzRXeDA5VG9sV3FCTmI3dXhUYXNtWVVWNmxMMmNkODMw?=
 =?utf-8?B?YzljY0tIbmtNbkF0aWtrdWdsd3k0VXBVWXdKTmZwL1p0L0F6bzdSamJOM3FB?=
 =?utf-8?B?Y1pxSW1RSHVDcjBxd1lRVTFqOEVXQ3FRSW1Ob04yOFhIYk5DYlZybkNETGFo?=
 =?utf-8?B?bzZlcDhnQVc4eDJESUFIK21OOE5OeVM4RmVyN2x1UE5oc3lRaHpBdi9QSFZH?=
 =?utf-8?B?SzMrOFZhVzlZWTNMRjVLWU1VQVh1Y21nWDdoYTl2WGpSRHp6a1BKM2xOajdI?=
 =?utf-8?B?aFFXbkQ0Uk5GMlZTZWU2VlZzK0RxQU5jMEFZenc4Z0hCT3ZqVGRHSkJtMFdj?=
 =?utf-8?B?elZrMlJUd3lOaFRMOFU2czd6NjF5bGVHNlBnQUlwZ1NZN3Nlc1hLN1FobUJ5?=
 =?utf-8?B?aVR2UkZzY2NkMXdyamxwZks0WmNQM2M2aVhWTDBvZmJOYTBlS3gyek5MZUpW?=
 =?utf-8?B?NnlwNlUxZG9WczZPYXZwVUVaaWNrY3lTSGcvRG5WSTY0cmdibHJSb0NmaGJ1?=
 =?utf-8?B?M3hYWVJZT3RhN2tyK2dvU0ZCR2hFNjRaOFpKR3hIcUtNdWJUK0V2Yy9pcE5h?=
 =?utf-8?B?eS9taUlELzRuMDlCLzFaVUdnMDhJRit0cTNmZjEwVXdVRWZqdHdlSzI2MDMw?=
 =?utf-8?B?S2szRnVhZzFKQ1VvMGVUdisxUlNpTkl2emxzZE9IeVZIM3k2NEpuK0I3L2xr?=
 =?utf-8?B?ZHF0OGVvd2ZZWTFMMW55cVBTRW9SVmR5QWd3NS96SmNNRFByL203RUxCZVJp?=
 =?utf-8?B?WHcwNlFJRkVPTU5BVHRTMFZ6YldXUTBuYXhDazczR1VZT1ZEQ29lbGZaNFRs?=
 =?utf-8?B?R09iZFZnc24wUi9EcXZyVUczOEJmMkJEUVRSbGZ5WkNLS1NwQXdhSktXd01a?=
 =?utf-8?B?aEVaYXhGSGVubHVFamtBOEVVMldyOGNPVm5ka0RGR25KQ2FuN1J5alFCNVdr?=
 =?utf-8?B?NDczVXVhR1EzUmVUWjFjcTFkaXN2NHdzUjBpaXR3TzVhMHJ0akVaRzNHcTMy?=
 =?utf-8?B?M3ZUa21KM3hoN0ZTcWRUMXBtV2xYcFUyOGh3M2t0SVNzVFErRGxsTFpvcGpk?=
 =?utf-8?B?Mm1pZWJSaUgwc21BZTEyOC8valc1Y0lCMHZxTk1qb090VGFNZjlRQklOTU5C?=
 =?utf-8?B?am1KOEtybnRhUkFveHJ3R3hsWWRtaWpqeDhhMFl2RXc3aDlXTmpDdGd6T0Ny?=
 =?utf-8?B?Mkd1RVdCVlB0aFc2R3pmZ0w4L25odERhVjcrOGZ0L25wWC9iUFpad25BRjBZ?=
 =?utf-8?B?S2dMWk8zTng5WXIzdHY2elhhdnB0RjA0YVdGcitnN244cGpabWJGRGlQK3l1?=
 =?utf-8?B?d2F2eXF1Vmoxc3psUU41ZUFXTTVqaldYM0hmNjhESXIzbzdDd0Z0VDA4SHJr?=
 =?utf-8?B?M0JabHBTYVpIZUl5eXJra2RESittWWpCLzAwU0pvZ1FhL2RVbFI4dW00ZWlj?=
 =?utf-8?B?Sm9iZzFVS1Y3NUNnZHRlWStrc24zK3ZQM3BkclJXWGlDakY5WCtoS21sN0VW?=
 =?utf-8?B?QWFlNHdaSXMyOTdxNXRWa1pxVjdlTlZ0ZXBGMlZIYUNDb3FnRGR2SUZpZ2tI?=
 =?utf-8?B?aGNnbGVvWjROMXdLWEsxckMrNWNFcVpOZmNIOWlDeEJzNmc0RzU4M210Wk1s?=
 =?utf-8?B?bE9rNFFFeVI2MTNZb044dzNhSGU1ZVQwZjhpT1Q1R3ZTYzNMSXdreVR4QWRz?=
 =?utf-8?B?bFY2WkpPS3U0a21hZTAzclM4d29Wb1UzbHl5TnF5TzhOMlQwRy9jZlhKRE1U?=
 =?utf-8?B?Q1E1Yjh5NmE5Q1VNbEhEcTFnR1BnK3owUVR1cTNDOEc0dHpzanB0ZEJQbzFD?=
 =?utf-8?B?aFZPT3lyVEk4WUZvcTY3TDV6Nm1kTzVjTVB5Uk0wVGN0WS9KTXBXTk1obVNk?=
 =?utf-8?B?VnovL2dIUW02Zk5lem85WC9GV3ppNnhXazd1alZPNDlueE94K016eXFIQ0x4?=
 =?utf-8?B?RlZXeVdjRnhqZTU4L2Z4d2cyL1BKRVhPSzVHa3JqeldjWWZ4V21WUVVvQk94?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bd9d23-f727-402c-8981-08dad98e66ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 02:38:06.6122 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LR77t8ZjqHME8AJflpMrdjarpSXuAAw6KfMLTT/GPomZDdVzOkUZXHaLPWhFg8bCXocUAk+tQ6YrSofbRm5kog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6422
X-OriginatorOrg: intel.com
X-Mailman-Approved-At: Fri, 09 Dec 2022 09:32:03 -0500
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Amit, Nadav" <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Atish
 Patra <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 12/9/2022 3:38 AM, David Matlack wrote:
> Rename kvm_mmu_page_role.smm with kvm_mmu_page_role.as_id and use it
> directly as the address space ID throughout the KVM MMU code. This
> eliminates a needless level of indirection, kvm_mmu_role_as_id(), and
> prepares for making kvm_mmu_page_role architecture-neutral.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 ++--
>   arch/x86/kvm/mmu/mmu.c          |  6 +++---
>   arch/x86/kvm/mmu/mmu_internal.h | 10 ----------
>   arch/x86/kvm/mmu/tdp_iter.c     |  2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      | 12 ++++++------
>   5 files changed, 12 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aa4eb8cfcd7e..0a819d40131a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -348,7 +348,7 @@ union kvm_mmu_page_role {
>   		 * simple shift.  While there is room, give it a whole
>   		 * byte so it is also faster to load it from memory.
>   		 */
> -		unsigned smm:8;
> +		unsigned as_id:8;
>   	};
>   };
>   
> @@ -2056,7 +2056,7 @@ enum {
>   # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
>   # define KVM_ADDRESS_SPACE_NUM 2
>   # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> -# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> +# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).as_id)
>   #else
>   # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
>   #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4d188f056933..f375b719f565 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>   	union kvm_cpu_role role = {0};
>   
>   	role.base.access = ACC_ALL;
> -	role.base.smm = is_smm(vcpu);
> +	role.base.as_id = is_smm(vcpu);

I'm not familiar with other architectures, is there similar conception 
as x86 smm mode?

If not, maybe need to re-shape is_smm() as a common helper to get the as_id.

[...]

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
