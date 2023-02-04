Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D841FD0;
	Sat,  4 Feb 2023 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675515134; x=1707051134;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BqswBQDKJxrTUc3nIiclaSQUCmAoVQWOGN9sS50ioHs=;
  b=L8cHu78QE7JzGXbj32YgNrXC1mCoQ+hFCiWlMQzIscugMJxkzTQbTd0+
   R+pRTgEcHg4/KatLENOyjCg9AxNktPlh6CBxYS2QJGSPAiN7atNUwtZ75
   A8Wjye5bJZT9Z7F4fZA7f/Zj+H8YKeZIF6CZZ2aOYZn/Yg+iIIkHFVm3/
   mLpURk0wTcQ4duDeP6bfmKfN32cLAg8oHXXRvWrH2iU1ADH9Bpva6VzGO
   9dUP+EjP3Gdie1g47sq/z4o95zkUdIuWqhfvLwZ/lY5phbaC2ft2BwGDe
   3/enZ1oayF1IXACm2qEB3UfAmDE1qE31mjDu2wD8Iz3Ey3EmQ124nyPKn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="327577010"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="327577010"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 04:52:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="994793707"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="994793707"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 04 Feb 2023 04:52:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 04:52:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 04:52:12 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 04:52:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2DHYWsfmGUfBef1hSsGCAEPvi9r98A4sF9wuJAIfsF/5LFOkdMKSkTqBTBo25BftCiN+rwrN7QRyQDwXWXDGJr7xW/CMMd9ROEH1EmQAhdGZOINglTa0NsZu1Kls8CEiQzWBtzGesMxG0ZrTb/ZTKJCRAuC5ZDDhss1s4/QmCpUu+bHJqiUeMjbonCfB5G4xxvV2ItZ1IRrrv8UuosqI8fJ2c6TgMl/+QlAFoO6APt4mU3nqReJfTMyjHC5bO6o76TgEr4VVw+mz8RkonCHViLPLnDKX39ChNi6sbnyTu2igIRuDB9rTSEn957C3n3cAOGpq9OrdyC4zmDj2U2/Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtOW0+NsZdUJCyhDtNhsp3GgUmVtzr33XLf4miP724U=;
 b=hU79Mfqu9LV+6ndk9L9+7W5+PGMSYnm4Jo/yk4mn5P6NYsGRPYp931h+CHILcYNVSkzAGE84YmIZBbvtaFntB8DpJ7MR2VUqRrmhzk+yayPZbPtC2dWA2TUjihxkAwnfD3b/+axWfzmmjLdsQ/BPFsNSUBTdVLnIzohwyhrKrL8tOpmeZF27C0gNfRlR8wDJAi2fQybsiYpUcWvfCRzzejvsG9pjbGwScyvvW9ZLiICWMIJHLFCkYD5VWofqmrjTxmtT0BkNDIYawEXZszR8PTs9W0ZnXlcUibC7fhI2bKt0k0cs1UfXO1Xaf6F6iyI6nFoiAlxtUu3qr2ZALsIM1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by SN7PR11MB6874.namprd11.prod.outlook.com (2603:10b6:806:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 12:52:10 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::d1f4:4d52:6667:5479%6]) with mapi id 15.20.6064.027; Sat, 4 Feb 2023
 12:52:10 +0000
Message-ID: <dec54922-37cf-89df-477e-eed1e9461db3@intel.com>
Date: Sat, 4 Feb 2023 20:51:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 15/45] KVM: arm64: pkvm: Add
 __pkvm_host_share/unshare_dma()
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, <maz@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <joro@8bytes.org>
CC: <robin.murphy@arm.com>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<oliver.upton@linux.dev>, <yuzenghui@huawei.com>, <smostafa@google.com>,
	<dbrazdil@google.com>, <ryan.roberts@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<iommu@lists.linux.dev>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-16-jean-philippe@linaro.org>
From: tina.zhang <tina.zhang@intel.com>
In-Reply-To: <20230201125328.2186498-16-jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To MW5PR11MB5881.namprd11.prod.outlook.com
 (2603:10b6:303:19d::14)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5881:EE_|SN7PR11MB6874:EE_
X-MS-Office365-Filtering-Correlation-Id: 9582acd3-2947-4fae-b4c6-08db06aea134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgB46Xh2U5E7PZ+rrIY8bWVDZh8M/wjlD1us2HqbN8hm6Gv8wJaw7iWhdJbhE366HPPtLXm93SnLTzfM9uCYhyvrz6pv6f9A+MVAzSrcKgD3KbXlyu4t1wEwZZwaDSZr9+/e8m8CDMLTOBAzcgCIRym8nnBJ0hz5H8Nyy9UIhf4Y5zW3Z1xLMYK9byA/WV8x2HuvJ5zUqBGFkW0xZ/Qcw9k+feOWextRJHHbY174TBH2WDBf4T91sOzQQmIH1cCXqCKxQdpf5oxTRTsyxxrtCpBSzb28DU0y5HJP1Vlue+x9ulQLwEJYL9qQfe5+nFmF50TDs7pdg3x1OyaO5fBuFgOqS8+UqQQsLFf6yKrzUl5jZQ7FwuHSdKBE1eseA2WJRouaf+mN3wqyUhjOlr2yCt2vYNcXuLJlXw76o6oq+A03QHZWLExCvnp+PY84eA4Tvq8PYFLXnM5kv6OU0bZ+u+ahnpHyeVzRPUO6nNO01qWr2WWLPA3JqQ5xTUAXpgXDkKIdgUXSqPN2T10vul46ptS1jLpuQS/sGS28Oje0umkMn2kPQpxnnCnE95kWMOem8bb/HZD/1h/iZz352WwelihOwGt/0hLEgO1Kg7Wbc5giOfnNTOOMhu/k1aNUGmfKJjoZnWizYYIM6+pFYg+wP7nOBkwxWV7r5WS6R4e1AuhudQrxXTMZezcJlJaCWAApM/sFZVoNCszVQ7nBnzrTA079J2rmVTjLA+3StBC69LM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199018)(186003)(478600001)(6512007)(2906002)(26005)(38100700002)(6486002)(6666004)(6506007)(53546011)(8676002)(8936002)(41300700001)(66946007)(4326008)(66476007)(66556008)(5660300002)(83380400001)(316002)(82960400001)(7416002)(36756003)(86362001)(2616005)(31696002)(66899018)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXV5alI0VmxDeEtqZWVjdHNZSmF4Y1ZsWXZlKzhnd1pYWXlocmc0ZkZNT2hj?=
 =?utf-8?B?cS90bjBYRTgzNllzZkR6aHByU0IwQmlKYlFNVkVRSDM0LytGUVU5NGNzYks4?=
 =?utf-8?B?M0F0RWlva0tRQkNMeHNPVURXSUFJZzB2ZXdZY2tVb1pHMWhnRDUyN1hhOThz?=
 =?utf-8?B?cEhzc21TeERaT3ZTengydWlhSjFkbVoyQ2JWbTgwRjgwZ1ZmdzZzUFlTaG1L?=
 =?utf-8?B?NG1xd01jMzZ6TmxoaXV0UUw4NXJjRUhWYmRiUjNiME85RHVYZmtWb2NGMjZh?=
 =?utf-8?B?TGdwNWU5RGl2dlczdGZHK2tDV2g0WDBiUmtaU1ZRTnNvbStwWXFWU0RXRWR0?=
 =?utf-8?B?RHNndkdPNDAxVzJxMEkxbU93VUZsOUhscUJDaGFUcE5RUmFtYnhSTTNaaG55?=
 =?utf-8?B?eC9UUSthMkhwcVZhcEdST0F4ckVLRVpqdHRwTmZ5YVM0UEpTRTB6emt1eGpD?=
 =?utf-8?B?QWV4VW8wOW1WWjVkWmdWZ096NGFHYlVNU0JGUXdJWmJtOUoxUVNWN0VIS05y?=
 =?utf-8?B?d3lMRkZBUExzOE9vQklKeHNzQ2szY2lWSlgxdktTU2JicElVd2RVUG1yVjFo?=
 =?utf-8?B?R3A3K0pscUk3OTlKSm5uZ29yU3ZXSXlJek01a0JSbWdUNy9GY1JhYmg3dUVH?=
 =?utf-8?B?a2FsRzY5UTh4NUFMYW5udXhXWjM3aU9qR3N6dloxUzlCbHNwZkQ2K2QzTkdm?=
 =?utf-8?B?UHpaaUQ4dFJFOVcwOE8rcG90WHhnWlpBMkI2MGJFY1IxTnJiOFR0NkxPbWlQ?=
 =?utf-8?B?ek00ejVvK042eTA4ekdVdHZmRVN3VklLNHY3UDlKZDhCY0ZyYkZIc3QxL2ky?=
 =?utf-8?B?TXk1V2VGd2VSSGQ5dGZTZTdZMXJONHAvTHBJMUIwZUF4bWFFV1dnaW92SFZH?=
 =?utf-8?B?OUtqSmpaMXhFbmU1SE1CaHh0S1lubjRibWp1TWpPbVd2SmNoSWRmckZNVWpt?=
 =?utf-8?B?Vk9OL0Z2ci9vYVUvMTZsUU9PVzIzSkxFYWhEakdNVTNveXdtUmVKVkxJNExW?=
 =?utf-8?B?K3VqTjlocUJJY2o0MVdWV2xlQjlMRGtVL2VjR3FHWnZUdWw2WkJEQlZMZlNM?=
 =?utf-8?B?N2JLb1NEb2NNbzM4dkM2aXJ5bkc0YUZrclZEbUE4Z29aM1JpUFV0eTJTZTFL?=
 =?utf-8?B?d1NzRmM0ekxkb2lUWlB3ZktiV1g0WnVzenh3eWpRYm1DeUNnMHhkaVpRd1BC?=
 =?utf-8?B?VEpKblNSTm5wTjNMaDJMYW1LZklQN00wK01zQ3NMV2tEM09NSklMaTlKbzVp?=
 =?utf-8?B?QjBmUHZ6cUpxUDBnT2lHdU1sM0ptZ1cxeEZydmhzbXc2ZnRHL0pmVWQ0TWVp?=
 =?utf-8?B?dld0R2F5cmtrK0dIaUordnM2am1IK1ZEbkdJTnViWm5iUkZFS094TzI0a3Z1?=
 =?utf-8?B?SncwbnRPYTBkU25CZWpwZWJLRzFrWVFLQUg1WE1HdCt5U3lKUHo2SnBKSVdM?=
 =?utf-8?B?cGJrczNNVWlOdWJ0NzNxZ054QkhSVmJJVms2dDhUREhsd3g2UGpDZ1JaL001?=
 =?utf-8?B?c1MxcEx4K2V5ZEE4TnF0WEJ2N1d0T0lMcXlBcmhOSk5rL3VqbGtMdU50T080?=
 =?utf-8?B?MEJxOUpzSEwrOGZDalhPQ2c1NllUUm9JWUF5NTA4RDdHRGVLME9ncmQwNXVO?=
 =?utf-8?B?Yk1uVE13RUo5UnhINGQ4bXZabDZ1c21tTU14RUlPZlRaaTA4OERjR3o1Ui9X?=
 =?utf-8?B?YW9nN3Ayby9taHhObXdwRW5RNE1HVkFmVDlsbW51THJUS3FFeUZzR0M0MFJF?=
 =?utf-8?B?YVVXWHFZUEp5WTNUOHYyK25tVCttNEN0NDJoZDlYVmtSNjdweXdiTkJpaXRK?=
 =?utf-8?B?d0N5VWtkaHd4VFI5OW5kbG9qOUNrSkhKSWpPRmlKMEFBV202UFhhUHJ0ZlVC?=
 =?utf-8?B?WmtVdTJVbXVodFRGKzNkVVFEUnBXb1JrTG5VbXExMTY1MWx0S2ZQUHNNNFBx?=
 =?utf-8?B?akVVM1VETkNlZlcwZ253NXBTUEtlczNGNUZEYnlFcXcyMkNvQzdpb2NPTXZN?=
 =?utf-8?B?TUlHMTMvOCtoT3JkbXBkbkZVZ05UM2NpVWdUanFxVzQ3YnRMNUpnNnl2VU92?=
 =?utf-8?B?eUFmcXV3elM1eTlSeW1MbVFWbGtOMjEybEhRcEE2SkUyK1luZXB0NmkyNEZr?=
 =?utf-8?B?aFdSamNxNld1QncrczRhUXZvcEVtUUlPSVQ0cWFoNVEvVkt1MkY3Q05qbVp0?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9582acd3-2947-4fae-b4c6-08db06aea134
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:52:10.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSqQI4MaltU6gyvmU2VAR/o5XBACLPzgTOpVsO+DQ+WXRYrbEOyEs7CsbZogvqCaBe4vmbMHha8L/9Wf+7bOuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6874
X-OriginatorOrg: intel.com



On 2/1/23 20:52, Jean-Philippe Brucker wrote:
> Host pages mapped in the SMMU must not be donated to the guest or
> hypervisor, since the host could then use DMA to break confidentiality.
> Mark them shared in the host stage-2 page tables, and keep a refcount in
> the hyp vmemmap.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 185 ++++++++++++++++++
>   2 files changed, 188 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 021825aee854..a363d58a998b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -58,6 +58,7 @@ enum pkvm_component_id {
>   	PKVM_ID_HOST,
>   	PKVM_ID_HYP,
>   	PKVM_ID_GUEST,
> +	PKVM_ID_IOMMU,
>   };
>   
>   extern unsigned long hyp_nr_cpus;
> @@ -72,6 +73,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
>   int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
>   int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
>   int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
> +int __pkvm_host_share_dma(u64 phys_addr, size_t size, bool is_ram);
> +int __pkvm_host_unshare_dma(u64 phys_addr, size_t size);
>   
>   bool addr_is_memory(phys_addr_t phys);
>   int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 856673291d70..dcf08ce03790 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1148,6 +1148,9 @@ static int check_share(struct pkvm_mem_share *share)
>   	case PKVM_ID_GUEST:
>   		ret = guest_ack_share(completer_addr, tx, share->completer_prot);
>   		break;
> +	case PKVM_ID_IOMMU:
> +		ret = 0;
> +		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> @@ -1185,6 +1188,9 @@ static int __do_share(struct pkvm_mem_share *share)
>   	case PKVM_ID_GUEST:
>   		ret = guest_complete_share(completer_addr, tx, share->completer_prot);
>   		break;
> +	case PKVM_ID_IOMMU:
> +		ret = 0;
> +		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> @@ -1239,6 +1245,9 @@ static int check_unshare(struct pkvm_mem_share *share)
>   	case PKVM_ID_HYP:
>   		ret = hyp_ack_unshare(completer_addr, tx);
>   		break;
> +	case PKVM_ID_IOMMU:
> +		ret = 0;
> +		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> @@ -1273,6 +1282,9 @@ static int __do_unshare(struct pkvm_mem_share *share)
>   	case PKVM_ID_HYP:
>   		ret = hyp_complete_unshare(completer_addr, tx);
>   		break;
> +	case PKVM_ID_IOMMU:
> +		ret = 0;
> +		break;
>   	default:
>   		ret = -EINVAL;
>   	}
> @@ -1633,6 +1645,179 @@ void hyp_unpin_shared_mem(void *from, void *to)
>   	host_unlock_component();
>   }
>   
> +static int __host_check_page_dma_shared(phys_addr_t phys_addr)
> +{
> +	int ret;
> +	u64 hyp_addr;
> +
> +	/*
> +	 * The page is already refcounted. Make sure it's owned by the host, and
> +	 * not part of the hyp pool.
> +	 */
> +	ret = __host_check_page_state_range(phys_addr, PAGE_SIZE,
> +					    PKVM_PAGE_SHARED_OWNED);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Refcounted and owned by host, means it's either mapped in the
> +	 * SMMU, or it's some VM/VCPU state shared with the hypervisor.
> +	 * The host has no reason to use a page for both.
> +	 */
> +	hyp_addr = (u64)hyp_phys_to_virt(phys_addr);
> +	return __hyp_check_page_state_range(hyp_addr, PAGE_SIZE, PKVM_NOPAGE);
> +}
> +
> +static int __pkvm_host_share_dma_page(phys_addr_t phys_addr, bool is_ram)
> +{
> +	int ret;
> +	struct hyp_page *p = hyp_phys_to_page(phys_addr);
> +	struct pkvm_mem_share share = {
> +		.tx	= {
> +			.nr_pages	= 1,
> +			.initiator	= {
> +				.id	= PKVM_ID_HOST,
> +				.addr	= phys_addr,
> +			},
> +			.completer	= {
> +				.id	= PKVM_ID_IOMMU,
> +			},
> +		},
> +	};
> +
> +	hyp_assert_lock_held(&host_mmu.lock);
> +	hyp_assert_lock_held(&pkvm_pgd_lock);
> +
> +	/*
> +	 * Some differences between handling of RAM and device memory:
> +	 * - The hyp vmemmap area for device memory is not backed by physical
> +	 *   pages in the hyp page tables.
> +	 * - Device memory is unmapped automatically under memory pressure
> +	 *   (host_stage2_try()) and the ownership information would be
> +	 *   discarded.
> +	 * We don't need to deal with that at the moment, because the host
> +	 * cannot share or donate device memory, only RAM.
> +	 *
> +	 * Since 'is_ram' is only a hint provided by the host, we do need to
> +	 * make sure of it.
> +	 */
> +	if (!is_ram)
> +		return addr_is_memory(phys_addr) ? -EINVAL : 0;
> +
> +	ret = hyp_page_ref_inc_return(p);
> +	BUG_ON(ret == 0);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret == 1)
> +		ret = do_share(&share);
> +	else
> +		ret = __host_check_page_dma_shared(phys_addr);
> +
> +	if (ret)
> +		hyp_page_ref_dec(p);
> +
> +	return ret;
> +}
> +
> +static int __pkvm_host_unshare_dma_page(phys_addr_t phys_addr)
> +{
> +	struct hyp_page *p = hyp_phys_to_page(phys_addr);
> +	struct pkvm_mem_share share = {
> +		.tx	= {
> +			.nr_pages	= 1,
> +			.initiator	= {
> +				.id	= PKVM_ID_HOST,
> +				.addr	= phys_addr,
> +			},
> +			.completer	= {
> +				.id	= PKVM_ID_IOMMU,
> +			},
> +		},
> +	};
> +
> +	hyp_assert_lock_held(&host_mmu.lock);
> +	hyp_assert_lock_held(&pkvm_pgd_lock);
> +
> +	if (!addr_is_memory(phys_addr))
> +		return 0;
> +
> +	if (!hyp_page_ref_dec_and_test(p))
> +		return 0;
> +
> +	return do_unshare(&share);
> +}
> +
> +/*
> + * __pkvm_host_share_dma - Mark host memory as used for DMA
> + * @phys_addr:	physical address of the DMA region
> + * @size:	size of the DMA region
> + * @is_ram:	whether it is RAM or device memory
> + *
> + * We must not allow the host to donate pages that are mapped in the IOMMU for
> + * DMA. So:
> + * 1. Mark the host S2 entry as being owned by IOMMU
> + * 2. Refcount it, since a page may be mapped in multiple device address spaces.
> + *
> + * At some point we may end up needing more than the current 16 bits for
> + * refcounting, for example if all devices and sub-devices map the same MSI
> + * doorbell page. It will do for now.
> + */
> +int __pkvm_host_share_dma(phys_addr_t phys_addr, size_t size, bool is_ram)
> +{
> +	int i;
> +	int ret;
> +	size_t nr_pages = size >> PAGE_SHIFT;
> +
> +	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
> +		return -EINVAL;
> +
> +	host_lock_component();
> +	hyp_lock_component();
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		ret = __pkvm_host_share_dma_page(phys_addr + i * PAGE_SIZE,
> +						 is_ram);
Hi Jean,

I'm not familiar with ARM arch. Just out of curiosity. If pKVM-ARM 
populates the host stage-2 page table lazily, would there be a case that 
device driver in host triggers DMA with pages which have not been mapped 
to the host stage-2 page table yet? How do we handle this situation?

Regards,
-Tina

> +		if (ret)
> +			break;
> +	}
> +
> +	if (ret) {
> +		for (--i; i >= 0; --i)
> +			__pkvm_host_unshare_dma_page(phys_addr + i * PAGE_SIZE);
> +	}
> +
> +	hyp_unlock_component();
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
> +int __pkvm_host_unshare_dma(phys_addr_t phys_addr, size_t size)
> +{
> +	int i;
> +	int ret;
> +	size_t nr_pages = size >> PAGE_SHIFT;
> +
> +	host_lock_component();
> +	hyp_lock_component();
> +
> +	/*
> +	 * We end up here after the caller successfully unmapped the page from
> +	 * the IOMMU table. Which means that a ref is held, the page is shared
> +	 * in the host s2, there can be no failure.
> +	 */
> +	for (i = 0; i < nr_pages; i++) {
> +		ret = __pkvm_host_unshare_dma_page(phys_addr + i * PAGE_SIZE);
> +		if (ret)
> +			break;
> +	}
> +
> +	hyp_unlock_component();
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
>   int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>   {
>   	int ret;
