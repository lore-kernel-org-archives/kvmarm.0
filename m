Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282681105;
	Sat,  4 Feb 2023 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675513874; x=1707049874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2V7twLU44yp0hvOveyY7kh9wg5JdEmiIN2gH12lV4zE=;
  b=MPC/86tDyt7Ow+jL2r3swrxeGsWv4Ic7gp4eza5xz9nyT3gl2shCdF4k
   +5gmEbRtLaJPoo/cYS+42e9/odjAJNgKH8pO+obDw8101PEv4MXj4PF1w
   olsW5x+d0yjmMq3Stm28GwrX/rn1alT147MrWviAK5MAoRpTesAwF3EvP
   Z4LPx5gVMnZzjd35HwN0vq3am0T8973ZQupAtkBZpYJ70rzzw6d54Qytu
   MMzrbUZ0Tu3f92lDxW1FqbU7xiAMfaVNx2IE2Y+UfWsSIItQM+T4gRw2d
   bWtJ1jPzDb7G0DDqVVkoIIjqexhgckFmy08HOB5fayY78bzkaaXhwrR55
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="316941498"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="316941498"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 04:31:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="696408316"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="696408316"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 04 Feb 2023 04:31:13 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 04:31:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 04:31:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 04:31:12 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 04:31:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMcVyFfvL03et4nt/Wu3RQtxiVaZUo6TtlBXjyARYOwOMpdGjnc5qrLpHCmczGc/caiivLt4djgIVj9aUZ4dYmXK/bxIWD66V5TOqxtkr4dFp5qsZNQDjk1tYUHeHiqeVuvXB6SHBWNb5LlnJh8DxhUamaQE/ocx5j5Eap4kDDtcObPgj3ge/9VpeINuk8+qAV6norgC25W83jbegG6O1dkL7DbNgmdtDjp9Y9GurysvAKS9/ayNw2qWDXFJPAjXp3ipGFoxCSZVUn5fBa3mWjtEwNIUUZbNt/zIhpi+48Kb8UFLZugChT6jYh098tlBB7czbmtyGT0OaDGQZ42vRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXeHqG0OpWeiPedr9adZvcDmUCZ3VCOFMaET+mTlVS8=;
 b=fOKmKVhXJBGfarUmXdKlCnqauQ8OAJ2XcS64EgPTJMU6aN3qmBLFU08KuMzadwgxG5iNQYE50AejqcaOKZKp+vG3H+8n6ADtJRjx/PbtTAFT72loIOIH1Cp2nHes8v8p2H15tfsc5v50tynCwzgY6gG2K2PDSssTkT78T25rFkOyJXZuwlS9l9J971UxByGJqaJ87De1LOICFY0OM8AMgvditFGKCEq9v+4DnDieNLrqehmKQ3AFh+Xn0rDFmOcutDFGuHrLWGnrRqKrFjIxb+99ND7ANGIOPwkWOjAHXZY/+/yYAn+F6VG85+9KtSdlCm6SVEJFmwk776GTKzPzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by BN9PR11MB5515.namprd11.prod.outlook.com (2603:10b6:408:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:31:09 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479%6]) with mapi id 15.20.6064.027; Sat, 4 Feb 2023
 12:31:09 +0000
Message-ID: <0ddefee6-3fee-c491-2b80-aaf0b3753d90@intel.com>
Date: Sat, 4 Feb 2023 20:30:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
To: "Chen, Jason CJ" <jason.cj.chen@intel.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "smostafa@google.com" <smostafa@google.com>,
	"dbrazdil@google.com" <dbrazdil@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9uK4t1iAsmnuyyi@myrica>
 <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <SA1PR11MB5923FE1EFFA389E80E403C3FBFD79@SA1PR11MB5923.namprd11.prod.outlook.com>
 <Y9zuv6OnBEow/gf0@myrica>
 <SA1PR11MB592386F3AEC5111F1C8B3F07BFD49@SA1PR11MB5923.namprd11.prod.outlook.com>
Content-Language: en-US
From: tina.zhang <tina.zhang@intel.com>
In-Reply-To: <SA1PR11MB592386F3AEC5111F1C8B3F07BFD49@SA1PR11MB5923.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0084.apcprd02.prod.outlook.com
 (2603:1096:4:90::24) To MW5PR11MB5881.namprd11.prod.outlook.com
 (2603:10b6:303:19d::14)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5881:EE_|BN9PR11MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: e78cfc8f-2d3f-4d86-a348-08db06abb178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFQOgwCTscIqW5WXOI9yqnCqSzoJZoCIkQ05r6TUXoI0d6MsRE7bt+gFogMC7i3HH67b5Cmiuuv6Ap5I4uCV9OrlUcAh17zB4Wi4A3hQHvdtUxQQ18wpjqpYvEVGTlsGl/gNspBPmG/rZXrJ/CLB+fuSfjjvTQMjBOxsST/rSHuLS7LmRhnAABb6aofSSgnBH89kO8MhHqPwLyg/GIuunTX7cW4tr7K+UEkRw2a9V0SFdl017UmxV3/wg198nqBmjZmVtVrAjP9KnCIAgBwhF7sQqq0Jfw6FbFH9MycWMrdpU0nLLpQsyWHSMuvLLAYldAp9+IAuGonJBU48HsX2jH02bZAe+AZV0hMxU5HwG1u5+igI1qQvXLR5urfp2q3UxF5qekEeTz9soZjWdYbafUQIRAGSfX+2LFYzPMC2MOiYcBKMEuih3QO5Kb4Eri40osfRcs/w6G7pSYMfUamXN9o4X0zZblOENljCcfZUypodYeRBj3wPzgxSG6eYhcVTOnafaKSBcgVHCssNiOuya050AXN01AyB54eo5h3bYg0R8pl7BfY/PT+FCPlxHJ9sL0qHNROD0L6ZvI3rgHOluAQw/D4t+fUg6x6JDrRj+6C5s5G/jQpX4DlWUPoxT0wDBV5LqkaqLIac7ZvvYECoOxm0ghP2+91Wsb0CTAyOINbam4dsCCgu0yw2eL+UorcsrJNFmdQJZEHyt+Z8N1j4yk9Ffot7O/m30oLhaDT8gDnqymwzY9ArSNpnNw5v433tvG5wJzrpW8/cpDN69VZmpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199018)(66899018)(31686004)(26005)(6512007)(82960400001)(6506007)(53546011)(186003)(7416002)(2906002)(36756003)(83380400001)(6486002)(38100700002)(6666004)(66556008)(66476007)(66946007)(4326008)(31696002)(2616005)(478600001)(110136005)(54906003)(966005)(41300700001)(8936002)(86362001)(5660300002)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZwNlBOSDN1V2RBT3V2bGlwbHZkTHdjbC80eUd3WUh1WWJMdGtXQUVZOGlZ?=
 =?utf-8?B?ZDBtc3ZjRk4xZGI1N0xLbFI0b1pDTkdKeEpSdmtYdnNybllSY1NDeng0WG81?=
 =?utf-8?B?Ky8zcS9wZGIwNjF4RjJqOG12bUVvRUFHWEtJcUlxeHZEd1RmRTNWd21ha3gy?=
 =?utf-8?B?NmZ4SVFoMzJvM3VGTXdHajgwaEVBSVlUVitCTldrVVNFZnRCL0o0V20rZWpV?=
 =?utf-8?B?Q0wyYkZ6blk0Z0piamhOM3NQWTA3ZXEyL0s2LzdPaHhhVXZ0aXNhYWs4SVFY?=
 =?utf-8?B?RDBmd0VqeVVGMGVGZmYxNnE5eFg0NkQ4VjZTc3BuYVlWSEVadjRHVVBxS25L?=
 =?utf-8?B?clNCOTVFU3FmbmlwL1YzV0xMd1p6WnJFV0x2aStLT0I2QUpISnd1dWNRM1Bu?=
 =?utf-8?B?eUtXamJCTWIySXY3MDFFeFNoZEFEcDZQcmNDVVNBdEdRUmVBYlhHV0ppb0Nj?=
 =?utf-8?B?NXVwNUl2bWFBOVRxd05BdXE4MjE2R28zUnRSMCs1UUNzY2NYNFJXZDhQY01C?=
 =?utf-8?B?SG5mMnhTcHRBK1lJNHhzMDZDbW4yVUg3STQ5bVV3RmlOMlRIRFp4NEdzbHF1?=
 =?utf-8?B?TmN0NUJxS1hHRjhQWnRhNTF1TUQ5aWU5M2tzMXJ2SDNWRXZ3cGU5emhPUENF?=
 =?utf-8?B?T01VODB3V2NCb2dFQjdHOGM1MFo1ejZqTWY4ZkRVQVUrZ2x0Z3Y3Zk5mNnph?=
 =?utf-8?B?RFV0TWt4MzUzdWZHVjI2V3cvdnA3VUhLYXpNUTdQbTJOK0krbURZOE1RTlZY?=
 =?utf-8?B?ekVtWnJPaGVaUDRMV01mZDBDcnJ3Kzd1QVpZSmVkbU5iN0gxa2tMdUdaTEFQ?=
 =?utf-8?B?cFppaWdZUnZNSVlvOW1qaVJEdEVCK1Z2WlIxM3ZzWTBNam56QnFaOGVpcno1?=
 =?utf-8?B?L1lxZEQ5c0tLWWdjNGxsODlqeHJ0b1BLQVVsQVBWSTg5SFMwdXloUGZ0bVlQ?=
 =?utf-8?B?R29KNUNxUnFZcGpDZDhaclI2WmJtRUs1UU51SGhxNnFXT2NaZWJzb3FEMk94?=
 =?utf-8?B?cFZSa21KdmdCT0hmRnh1TEltRGVJNlgvVjlha2JVVUw0QVRKbWxhYmJmOG02?=
 =?utf-8?B?M1hrbGhqeHBtcEhrdHFacHZtQWFHR3VGODBLeTlZdUdpZlkrOVFzUnpEYWhW?=
 =?utf-8?B?bEtma3pOVkpWKy9sNmw2ejh6QkNRTXN0aTJqdHkxemhFQWUwQ1JlbUZhOFc4?=
 =?utf-8?B?WkVtc0Y0dWJEcS9Ud012TGVVbVFQeExqYlF0Q1k2eXp0VVlOQkk1YWUrZnFW?=
 =?utf-8?B?ZnJDemJwd1hRNGIxd0NuTEp5cHFGSXc1Y2x2dXpDWFg3bzBNVFlFZi9TQWt6?=
 =?utf-8?B?WTlITXBDdThEbUVXVWdqZGFDT3RpQWFNMlg5RTE0cnhPTWhnMFREZnpjYXd5?=
 =?utf-8?B?V3JXTVdqOUd2MndaUzljTkFFY1VheUt3bXBRYXdhTFdzdGQ5RitYVndxaVBk?=
 =?utf-8?B?N2NUV3NCQmk2UXQ4Um9NUlVWS0N0LzRvMHE1cjIrVkk5OXBkT1hNZ1lOM211?=
 =?utf-8?B?dGRXWG5EaCtTQVZSZXY5VzBGMHNyVnVjQlVmTTZnMElHalErTlRMWldUaC9v?=
 =?utf-8?B?M2xPRUZwT0U3YXdINGhEV1FMVjBtZ1RTV3N2MTdvUzZZUGZzMjRMM0lqNzhS?=
 =?utf-8?B?eWpMK1NpNnpzL3BaWERiNnk1aFhJendJeUNRVmh2ZVc3Z2E1dU0zWm1HQ1Zy?=
 =?utf-8?B?cTVQdE1qc1l0N2NDckVMZUcvMS9WSS93cDRDKy9Fb25jM01lK2czaTFYajV3?=
 =?utf-8?B?aVpMSElUNFN1MVUxNnRlMXpoUUR3OHBZWGRIeU5ocHB5dTJ6SmNwSk0wMWRy?=
 =?utf-8?B?dTkvMU9VaUdoUFhMcnE5Q2Q3anpxczJ5VlQyd3Z5TkJvY25vdkp1MUhvWVVq?=
 =?utf-8?B?b1hVSnNZa01VZjFtcHNJaWZHb2FKdTE0bDFETDFlMDNqZFJLOGY1VlFYSkpm?=
 =?utf-8?B?YlJMaWJQVFBSQVdmeVlXc1hYcTlxc3FGcndZWENybkdaZkJXcDdBOGdxU1dB?=
 =?utf-8?B?QldHMDhmV1hOR2VTTFJRVGdZdjhzWnloUS92emwrRkpRZngyVzRiRDhkb3M0?=
 =?utf-8?B?ZEJFYTF2UHRxNDZMQ3NEQU5QU2lyQkx0Vy9CdC93YU0zMG5oRHJ6VEd4ME44?=
 =?utf-8?B?b0xZK2hFR1lzTXRra0diYlM4V3Y5Mzl4bVljd2hWRHlZSFdCcnM2bU9wUHJI?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e78cfc8f-2d3f-4d86-a348-08db06abb178
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:31:09.2998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wx6p+Oj0E0l/ocGiyR4yc/fiEfQAiPGakMvwrvYMAZlLkZ+i6EMZqHAIWGFJWZBgVtsDJakPltZCOu7DyAiPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5515
X-OriginatorOrg: intel.com



On 2/4/23 16:19, Chen, Jason CJ wrote:
> Hi, Jean,
> 
> Thanks for the information! Let's do more investigation.
> 
> Yes, if using enlighten method, we may skip nested translation. Meantime we
> shall ensure host not touch this capability. We may also need trade-off to support
> SVM kind features.
Hi Jason,

Nested translation is also optional to vt-d. Not all IA platforms could 
have vt-d with nested translation support. For those legacy platforms 
(e.g. on which vt-d doesn't support scalable mode), providing an 
enlightened way for pKVM to isolate DMA seems reasonable. Otherwise, 
pKVM may need to shadow io-page table which could introduce performance 
overhead.


Regards,
-Tina
> 
> Thanks
> 
> Jason
> 
>> -----Original Message-----
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Sent: Friday, February 3, 2023 7:24 PM
>> To: Chen, Jason CJ <jason.cj.chen@intel.com>
>> Cc: Tian, Kevin <kevin.tian@intel.com>; maz@kernel.org;
>> catalin.marinas@arm.com; will@kernel.org; joro@8bytes.org;
>> robin.murphy@arm.com; james.morse@arm.com;
>> suzuki.poulose@arm.com; oliver.upton@linux.dev; yuzenghui@huawei.com;
>> smostafa@google.com; dbrazdil@google.com; ryan.roberts@arm.com;
>> linux-arm-kernel@lists.infradead.org; kvmarm@lists.linux.dev;
>> iommu@lists.linux.dev; Zhang, Tina <tina.zhang@intel.com>
>> Subject: Re: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
>>
>> Hi Jason,
>>
>> On Fri, Feb 03, 2023 at 08:39:41AM +0000, Chen, Jason CJ wrote:
>>>>>> btw some of my colleagues are porting pKVM to Intel platform. I
>>>>>> believe they will post their work shortly and there might
>>>>>> require some common framework in pKVM hypervisor like iommu
>>>>>> domain, hypercalls, etc. like what we have in the host iommu
>>>>>> subsystem. CC them in case of any early thought they want to
>>>>>> throw in. 😊
>>>>>
>>>>> Cool! The hypervisor part contains iommu/iommu.c which deals with
>>>>> hypercalls and domains and doesn't contain anything specific to
>>>>> Arm (it's only in arch/arm64 because that's where pkvm currently
>>>>> sits). It does rely on io-pgtable at the moment which is not used
>>>>> by VT-d but that can be abstracted as well. It's possible however
>>>>> that on Intel an entirely different set of hypercalls will be
>>>>> needed, if a simpler solution such as sharing page tables fits
>>>>> better because VT-d implementations are more homogeneous.
>>>>>
>>>>
>>>> yes depending on the choice on VT-d there could be different degree
>>>> of the sharing possibility. I'll let Jason/Tina comment on their design
>> choice.
>>>
>>> Thanks Kevin bring us here. Current our POC solution for VT-d is based
>>> on nested translation, as there are two level io-pgtable, we keep
>>> first-level page table full controlled by host VM (IOVA -> host_GPA)
>>> and second-level page table is managed by pKVM (host_GPA -> HPA). This
>>> solution is simple straight-forward, but pKVM still need to provide
>>> vIOMMU emulation for host (e.g., shadowing root/context/ pasid tables,
>> emulating IOTLB flush etc.).
>>
>> I dismissed emulating the SMMU early on because it feels too complex
>> compared to an abstracted hypercall interface, but again that may be due to
>> the high variation of configurations of the SMMU. For nesting, you could use
>> some of the interface that Yi Liu and Jacob Pan have been working on [1]. It
>> should be possible with a couple of attach-table and tlb-invalidate hypercalls
>> to avoid emulating the low-level registers and queues.
>>
>>> As I know, SMMU also support nested translation mode, may I know
>>> what's the mode used for pKVM?
>>
>> It doesn't use nested translation because it is optional in the SMMU, and this
>> series tries to support any possible implementation. Since pKVM on
>> arm64 is being used on mobile platforms I suspect that, to save space, some
>> SMMUs might not implement first-level or second-level page tables.
>> Besides, supporting nesting for Arm would still require hypercalls for pinning
>> DMA pages (solution 2).
>>
>> This series populates the second-level tables with the complete IOVA -> PA
>> translation (similarly to how VFIO works at the moment). If an
>> implementation only supports first-level tables, then the hypervisor would
>> own it and put the IOVA -> PA translation in there.
>>
>> Thanks,
>> Jean
>>
>> [1] https://lore.kernel.org/linux-iommu/1570045363-24856-2-git-send-email-
>> jacob.jun.pan@linux.intel.com/
>>      (It's being reworked but I couldn't find a recent link)
>>
>>>
>>> We met similar solution choices whether to share second-level
>>> io-pgtable with CPU pgtable,  and finally we also decided to introduce
>>> a new pgtable, this increase the complexity of page state management -
>>> as io-pgtable & cpu-pgtable need to align the page ownership.
>>>
>>> Now our solution is based on vIOMMU emulation in pKVM, enlighten
>>> method should also be an alternative solution.
>>>
>>> Thanks
>>> Jason CJ Chen
> 
