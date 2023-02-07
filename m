Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6715BD;
	Tue,  7 Feb 2023 02:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675737494; x=1707273494;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LK26NHBLsTO57qFqZ4Hn7QfcMwDhQvXbHLdiVS55djA=;
  b=f2QIftuIT6HZay+rdRy4cQsv5Wz8P10EcCe0mTegkZpCnw5HphJDRK42
   ZL9RplsB3R70TVHY/9mUzgbAAevA4NHXv7k0xv5U6LRCc8MfwDn0onYTc
   dC721V2+eWndt0KSBM7N7X35e8DtlSJUQvzdNMmwiRQ0pbnDtY55o1xra
   UTs5oJz8hyYRo3FI+HaY3n45RzRAYxkkLQtfXVOrAk9hYkQZib4O1VA5a
   FnLrmmuNOYYr0ouWRs+aVocqYGTFCPTwJVBi2AdxI3f9PqElHxPMmHHzg
   3K0n/P1bkOVitVgB4ECTVCCRuDYq7W/NIa6+lqQySVGgV6uemlKhYMpDD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="415603161"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415603161"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 18:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="735388715"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735388715"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2023 18:38:07 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 18:38:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 18:38:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 18:38:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 18:38:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oN0CGxr0BRqNycd3FEwfzUoTc/HCS97G2NdkivH7h6qk5zwdusi6kDeRSE7/hvs5Ub/+Ogs9ispQcbWlhbyVSxYnyBENbarrlLk8lSoBSfUCUCR126apjOiw6lA2Rn7gLbfrDYYfXZRd2MNs2izVYzWoUyAwX78rYkpdW4kR8h7RyUJ9/C/Zllk7cg0qmDyMjL1x1+lZvLNPSGktQt2wL+ajPqjV0XKlp5GZNUCmcyhKTxyXKYHUaEpshmtzUQzwgiu1X+n2zoJYFL0miNRC2fVm/dCSDliZ/OgYX0kSYgcOkY6+U856xidKvt4M/W3gQmuZd1FqHDtF7brYXzGbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBqoVPVs1ycYGzIzErX/HnahQlowJx7Z/+05wztH6iw=;
 b=MoaWgqvoKeG1z92CD9OW/QR7yqLHlIqZIBnR85Xk9sVQk/2940fbjf8Gt7Q8DTG+TDnaiFuXq/Agld9IHjXapovgqVFmhobInXy5MwwEbApIYnoWhRaUaYox8et3+T8Grqz45+O45w/U69sAulVY/PKKFWd1pJybq1UFzgCLM/OYfmiXJMh7Td/mCDNPMIT2V/sUpMnL8Y6O+HVJNMWgOo7n0mRlkzq3mW7UgRNS8ufnFmBNmZw0IpEyyBnYhFC/fnsAKrW/S/AneDYtfiijH9xKwmhj4YCobVLKdbuOiXvjhM7V/hWYADU2mmU9JBOJ3112SSe9Ppxax2L9c+i7Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by MW5PR11MB5882.namprd11.prod.outlook.com (2603:10b6:303:19e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Tue, 7 Feb
 2023 02:38:05 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479%6]) with mapi id 15.20.6064.027; Tue, 7 Feb 2023
 02:38:05 +0000
Message-ID: <c06440b2-1ce6-b2c2-59b7-6ccdfd8b5ab4@intel.com>
Date: Tue, 7 Feb 2023 10:37:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 15/45] KVM: arm64: pkvm: Add
 __pkvm_host_share/unshare_dma()
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
CC: <maz@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<joro@8bytes.org>, <robin.murphy@arm.com>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <oliver.upton@linux.dev>, <yuzenghui@huawei.com>,
	<smostafa@google.com>, <dbrazdil@google.com>, <ryan.roberts@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<iommu@lists.linux.dev>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-16-jean-philippe@linaro.org>
 <dec54922-37cf-89df-477e-eed1e9461db3@intel.com> <Y+Du0fZetGVdPVW2@myrica>
From: tina.zhang <tina.zhang@intel.com>
In-Reply-To: <Y+Du0fZetGVdPVW2@myrica>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To MW5PR11MB5881.namprd11.prod.outlook.com
 (2603:10b6:303:19d::14)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5881:EE_|MW5PR11MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e24bc82-870c-47b3-5d8e-08db08b456df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2wNmk6Elmc45KvBFYxCmyjwMnEF+RlNgOiMELpP88t2ql/IDBFJMRdUWu8xQLosAf7shg3zfZ5/xoEViiKIbs0FWMlpE2mWtC1FI60FIq7HnQBFzgQWSSKGPp4AY1n/5UK8eQxfG/XS/pFMrH4YXZeW6hU8bquj9OAf/7rrDk7hU4yx/ZE4x8kRDe0VSdPe2kGPmtjVjDhWZurrDYkp4SnvO7IoSTLmb9/UGPkiiKVsJmMK5NdUaq1hq63JdqwIg7A3tM1a5ChhNdQKlKoqKrHeN+rDgmLJVibeRyNemF4cBBrrS42uyBVyz4iPSy+ZlRlmXm4P0frc2WOWqLC1WACn2e6e5RdH6kC4hw3UmLBd3Odh+XWRiiB5Mzydbk87om87z1gJDzzhNrAIA/hunXpHMDNxPHu6DbTfQJzWn0KLUrA9dsAkenHGZrhP1GUOFpsvkgJU38lCGSdwSwx1g4JemTtZPyL2mAdGFGLSQ+6b3DsAQku3c4QVYW60iJ1oIGGaPugzXLCB8joiAfova20WD/e+kvaXK+/TBRiM5tmKt6Qsu/zi7wxi/0uxRNWSDadPv5gleMFWsqQini81rNNMQcvfolc0YIFL4oihZofyVcZJHznkj2FqHC4014SQ5Vxe7iYc5P8G589m2UBY+XhGv1mXeiTwrFxGzkBdOVZB5IYmWrOD0EuZLkZsmkyBSubISgd4U6tpsXTLjqCzM7hDiQzc76ZgQSCMXLm92mU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199018)(7416002)(53546011)(41300700001)(186003)(26005)(66556008)(38100700002)(2616005)(6512007)(6666004)(83380400001)(66946007)(6916009)(8936002)(31696002)(316002)(4326008)(36756003)(86362001)(6506007)(478600001)(82960400001)(66476007)(6486002)(5660300002)(8676002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGQxZCs2NCtBRjRWSklac1ZDQWFEaEsrcEV0Ulpha3ZSTGJDZHVnb0QrbmJy?=
 =?utf-8?B?ZXdvZWZVV1BvVHV2UC9RZWJJLzVpKzcwaDVtN1IzdWErakpZdWFSVXJ6RnA1?=
 =?utf-8?B?YzUxSXp6UlEzSFVXaSsxTVlyaDVla09YMkZsUW1MUzhqcDNXalV6eTNtQ0FS?=
 =?utf-8?B?OExpUHVRYlNocFIxMjJiWGp5Vy8xazZ4aFBrNjlCMGNtZ2pDUXIzRDhKTDFG?=
 =?utf-8?B?NFFod1h4aHorbHVQWUs1aitZUEFVb3RwazREVzRLZ2NRUHladzdFSVlmM3FM?=
 =?utf-8?B?VmJBWVJ3ZGU1WVpaTHZGazlUVEVXVlFqYzN6akkwdkRCUjZZUXdNNVNHZnhS?=
 =?utf-8?B?SXp6WTFadmNyMU1JdUFrVTl3UmNOMFNtVHM5VFhFMFhJbDg0Z3N0TEZmT3or?=
 =?utf-8?B?Y2hHdi8rZjFJQ0xZWDFKbHdPNUZLTWJWQnVHMlA3d3k4dTFqNnhzL2QxbGxE?=
 =?utf-8?B?QTNmbThUV3ZRdStwRjZFTEI2NzNkOW8wZit0ZWlQTFF2TzUyNnZNUEJ3Tng2?=
 =?utf-8?B?dGQ0UjU2OTArdnBmSW96cFFyR2c4Uk1kajczdE5Fc0RBQUFrTVVteEphTjd4?=
 =?utf-8?B?SFFybHVod21DWTlTOENDQkJ3eUZXek5WdndqVWpNcnJSNmxZL0ZLNXJRYUph?=
 =?utf-8?B?SDhvZjUyWVd1c2pyZnBNSWdLUXBSRmVZNlFZVjdwMmY1RTJZMVVhTmxpakZS?=
 =?utf-8?B?Z1BlS2w4aVVIL216c2I1VDlzYzBLMHJvc2JnbERSRlJ1bDFiU0x3YkRlR1p4?=
 =?utf-8?B?cDIzQXBoS0JQTXhkQTdTMEVremF4Y0haWkpjYjRqeWZ6aE53a3pEdDlxZWNG?=
 =?utf-8?B?TnVZbVlIUFNUM3ZJN1Z4Q0tOa3JqajJ5NVViQzZqaEVZUXVvR0RYN3Jvemtm?=
 =?utf-8?B?RkxIRm9XRXFlSXEvelNKQzRUbWtGNFlYalJjVTBYQTl1Z3RkNEsycU5zQVM1?=
 =?utf-8?B?LzlXcGFDTExUakxQZTNjUEY2LytBZC90M2JlbzV0ZUpza0FJUkVmWkRVRVh2?=
 =?utf-8?B?Wk9EZXpMT3VTVTBIdTA3L0tQWFdWVUdzMDRXd1NUWlRIbUpkVVErUGdSTmpo?=
 =?utf-8?B?OGFBTFhyS01YYVhrUllPNTA1WVg5RmN1TzZyMmxNbndmQktmTXRtbnZyQTY3?=
 =?utf-8?B?cVVWVk9rOHNDK29sbG9jSkpFWFZrbzFWeFcrM3ZSWFdQUjAzTE4wbzREYUJX?=
 =?utf-8?B?Rzc5ZDR6dWtncVhBYXVSMW1pRGlPMmoxL0hkYnBycFllOU9TQm1jZXNSc0xU?=
 =?utf-8?B?c3ZZbHB0cUhxbVZrMEdXa25ScmJtOVRzUitTdERqRzk1TU9PZjh5YUU4dmho?=
 =?utf-8?B?K0hhWjRheHpQT1l0NkhVaHpzcHNaSU9JVEs0Z0I0TUFJTEJxTW5MeFFKYUQw?=
 =?utf-8?B?MEJ5YVJvdmxlUStHMDRRSWR1eER2dWpwNDQydnlBSnllVmxMQ1NBSjVGemho?=
 =?utf-8?B?dURhZ1oySGRVc2JJOHh1Ny9zZnB5aVRwaUJxNjc4WThlYWRBRUgra1pnQU1m?=
 =?utf-8?B?SXpFTFFabHBiLzQ2TlRJamg1UXpNMXdKQVZXVEFOcFZ3d1Eyb09Dd09hTi9q?=
 =?utf-8?B?UjhVOFllZG1GMjMxcW9SQ2pVK20wVXZXSmZsOFBNa0VQak1CUmtTTTR3MXY1?=
 =?utf-8?B?ckIwSU1Bb3IveDJPYUVJM1VPZzNxOS9TLzI3eFhCeHJwTWRlVEJ4TkxLUnB5?=
 =?utf-8?B?ZjNSc3QzZlo1NldyRU0yZ214M0k0Q2FZUk5ta01MbW80REhKZm9kcnJ4NGU5?=
 =?utf-8?B?TmlxSEdZV0FVZmEwb05qYkNEcFpBSUd5dFJBM0kyWWVObmk2NXF3YU1vV3JW?=
 =?utf-8?B?YmRDOTNKT0JZZWJ3cGVGYTJYQnVzNFAzUDJ6L0VLUzNRbTlwY0dHbTBaUFNV?=
 =?utf-8?B?ay9KS0RhZ2IxWklyeGZFNlg1VDNyNllzYS9jYzRpS3N0WGYyVXlYNGVZRmFF?=
 =?utf-8?B?K1ZPWmp3eUlTcEtXZ2p4UzRlSFBvMktQdUJMcnVUL1RwU0I3OG1PM2taNUQy?=
 =?utf-8?B?Rmw2U1MyYlFoT3lHRWtVeGtPelR5ajZsbDZRYjJvek1Ea0M5N3pKOGxrdFRF?=
 =?utf-8?B?MS9Pb3pZckxwbHVKaDBxYlpkaXFPbmhIeGMxQnk5UjBXdHBJeGNtMk4rbCsz?=
 =?utf-8?Q?LTMIr/EkbP2mNI1iJIb363q2t?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e24bc82-870c-47b3-5d8e-08db08b456df
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 02:38:05.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvnerzut9cVVw+8DJqMIMHqbHPhCT1exBEJ1/zvX54G17EK/PKpcPJRkXwO8o5fm9CAgLOosyiJfwmxC3giX9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5882
X-OriginatorOrg: intel.com

Hi Jean,

On 2/6/23 20:13, Jean-Philippe Brucker wrote:
> Hi Tina,
> 
> On Sat, Feb 04, 2023 at 08:51:38PM +0800, tina.zhang wrote:
>>> +int __pkvm_host_share_dma(phys_addr_t phys_addr, size_t size, bool is_ram)
>>> +{
>>> +	int i;
>>> +	int ret;
>>> +	size_t nr_pages = size >> PAGE_SHIFT;
>>> +
>>> +	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
>>> +		return -EINVAL;
>>> +
>>> +	host_lock_component();
>>> +	hyp_lock_component();
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		ret = __pkvm_host_share_dma_page(phys_addr + i * PAGE_SIZE,
>>> +						 is_ram);
>> Hi Jean,
>>
>> I'm not familiar with ARM arch. Just out of curiosity. If pKVM-ARM populates
>> the host stage-2 page table lazily, would there be a case that device driver
>> in host triggers DMA with pages which have not been mapped to the host
>> stage-2 page table yet? How do we handle this situation?
> 
> It's possible that the host asks the hypervisor to map on the IOMMU side
> a page that is not yet mapped on the CPU side. In general before calling
> map_pages() the host zero-initializes the page, triggering a page fault
> which creates the mapping, so this case is rare. But if it happens,
> __pkvm_host_share_dma() will create the CPU stage-2 mapping:
> 
>   __pkvm_host_share_dma()
>    do_share()
>     host_initiate_share()
>      host_stage2_idmap_locked()
> 
> which creates a valid identity mapping, along with the ownership
> information PVKM_PAGE_SHARED_OWNED. That ownership info is really all we
> need here, to prevent future donations to guests or hyp. Since the SMMU
> side uses separate stage-2 page tables, we don't actually need to create a
> valid mapping on the CPU side yet, that's just how pKVM's mem_protect
> currently works. But I don't think it hurts to create the mapping right
> away instead of waiting for the CPU page fault, because the host will
> likely access the page soon to read what the device wrote there.
Right. I was thinking if stage-2 lazy mapping method is being adopted, 
whether there would be a case that the check_share() couldn't pass, as 
the pte might not be valid at that time. After checking the logic, I see 
we check kvm_pte_valid(pte) as well as the value of pte. So I guess the 
check_share() can return successfully even w/o having triggered host CPU 
page fault. Thanks for the elaborating.

Regards,
-Tina

> 
> Thanks,
> Jean
> 
