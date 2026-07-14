Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C8D346FC3
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 05:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784007553; cv=fail; b=HE6D3auQHSPdZ3N2jsjOUyQELvtfo+p4n3Ki8ZGAfV59WYL7fT5hvXRvXSOecUfMdzkptNlocBaTKI5UVEXAekU3J5I5S9jmWX8+9FCJLj8h/cfpgYUMdcPI1taHBKbQ6N/fFxe/dG9MwdWTG+U2GPE+RwtRTWiJJ08kwRws3lM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784007553; c=relaxed/simple;
	bh=DDgmMAzaOA7vlAs5p5Sb7JvLQZYM5U/z5Cev6/sFrC4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rUWvEXl2K/Gmwb+kEthTIQ4R0pQswLCnNags4C7D9MNdVNXom+q6slwXlWajbN7VGNMw0bJA6/rwPOTkGqLG2Ks22xEVejjm6XAgHevfoA7cVmK4+JDftfxGtnsGxFTWHgOm2R/28Xd5sQD9+6PRwvpCC6t1Jc3n80IcIsbrTuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVMSWxz5; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVMSWxz5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784007550; x=1815543550;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DDgmMAzaOA7vlAs5p5Sb7JvLQZYM5U/z5Cev6/sFrC4=;
  b=mVMSWxz5QwWDBb6mvLLnEJC1REEpxQKAr5kmzFc+IFJIfhVyMkmly0dF
   pBsJJgBKrsaKqxW1IDk50QwV+Fn40HWLgonPgmro1kPW+jipWrqm2VdxK
   pHEGzWs9Vv/zv1xDVz/8TPWEDDawqOOE5UC1ntKb+H8KBKaU4bX4RWIAn
   3lA0j5NdSIRCnMXpfa4gpu4FcRmvuCDaWRqaaYHjOOalWZ83QLQpPxllg
   BR4Umg348QePa11lu0nDpm4mO82gKsd7DY4KgvlOMCLR1Xr+lCV2ul7Ra
   f8YxdDwUK5D7kbaIR/IyyC8byjOCV6+DEkPGtcRuK26SVPa9K9NjJ2uM7
   Q==;
X-CSE-ConnectionGUID: mY9AZURlQnWmSDzYB77T+w==
X-CSE-MsgGUID: najpQGyEQVq4MiXyNzXZAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="72145964"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="72145964"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 22:39:09 -0700
X-CSE-ConnectionGUID: 32GHByqvR36AboQk16xFlA==
X-CSE-MsgGUID: wFvFQbWtQcCAFaMEVQ+cMQ==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 22:39:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 22:39:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 22:39:07 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 22:39:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TSH90K5CcBOHl1yoU+QFmziVXKBjqC22x81dY5F18hq6SINfHDFoWlWwnsjbzUMb9XR7D83niYjLYrn3QB3KWKpU3qTpYotGQ7fSOtp92XgjxxQWezrLuPH3vhIL6rtXIx9mbZMICh6CK990MR0KInzbPLHq4Wq9Sa8SBmW72tKoB9IWsn7jWrr59EA8uLjfqMRtWOFP5uo7fW1HdVeWmUy24QBYuKO4UEo0TlxGagukoLezAEWkPTMiCmJbg6Wc2fTDFzElu1nAVSo/34QBpuGz1xlc30FglL6J3UCDw2nNIpHThNrSaTARmsSqXMNRM/y3d8v38IsaXuijy87eTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12ZpddpDyh+cPmgZdgM43s6BBJ1NyXLYOgaEYDqQEXc=;
 b=Xm9QN2jCPj/Qu0zi6b7xHCpWxUPfe2UEm1LSlb5zvX2qx3BOb2BAOI3sto3sKoZ1OORQGZkieDV7Idqhp5hqw4UU/pV68DCw6Z0KX3QDaFWb/Xr3nRWW9AbJx1wL3dzzH/J+co8PtL5Ow4G7rrO8x4cgJUfeUtss3iLWtApm318CNeL8Q0TTneQVoRYfyb+hPbe+yYkTIQUmHPxyLUqOtO6WLM/Q29/wK0nEOVcIrwu2LxgugwwuosmUQgnY84rbatBno8VJYhEn5Ced1TGEdM0MfaZ0yNYXqXbxbUDMDprrmm0cyvsDvCNRzNyy/Qt2OUWnO197ssyzS0jSjglkRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8050.namprd11.prod.outlook.com (2603:10b6:8:117::5) by
 CY5PR11MB6260.namprd11.prod.outlook.com (2603:10b6:930:23::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.19; Tue, 14 Jul 2026 05:39:04 +0000
Received: from DS0PR11MB8050.namprd11.prod.outlook.com
 ([fe80::f099:a504:2ad6:1d12]) by DS0PR11MB8050.namprd11.prod.outlook.com
 ([fe80::f099:a504:2ad6:1d12%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 05:39:03 +0000
Message-ID: <7295903c-14f9-4427-9c83-039e70e64cd3@intel.com>
Date: Mon, 13 Jul 2026 22:39:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] KVM: Implement dirty page logging for
 guest_memfd-only memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>, Sean Christopherson
	<seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <david.hildenbrand@arm.com>,
	<maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<fuad.tabba@linux.dev>, <mark.rutland@arm.com>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-3-alexandru.elisei@arm.com>
 <akxWZ1NTX4DHnUzf@google.com> <ak0zdNr1LvuF7gvm@raptor>
Content-Language: en-US
From: Kishen Maloor <kishen.maloor@intel.com>
In-Reply-To: <ak0zdNr1LvuF7gvm@raptor>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To DS0PR11MB8050.namprd11.prod.outlook.com
 (2603:10b6:8:117::5)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8050:EE_|CY5PR11MB6260:EE_
X-MS-Office365-Filtering-Correlation-Id: 85d9e01f-871c-4950-9a14-08dee16a36b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: SK7OlH8OBm6HMboY6FGeGqVdWENQ7wXe7NhQO7hiEfObHH7pc5xS8YsuhUfrJ/gZp+K/xiGnNs2pt4Fs6fMMRh0cFpz29VLwDlpImjvQSxU2Mf7s+EdMXV4BXAxPC/dJTepUpGXiCguGnBl1ojGC2RULxTELXeHbitFbOswAApvF984uhWDq0S/5VqJqdtSTlC5VXUIuWY9FSbWN6evP1RQktQM2U9hZ7r1UY6rSu45iohzPUbaTpXp3lr6e1OySm377/iLti8kHl+MU4GxmhGMFwmJPhbEJZqSn8RwHvYHC/WcF2hwkHk22JQC2AwyhZHrAk1SPwGTeIcb9LnekhB3ednvWwan33YF+Zy6jNVFCa9B8C0GvBWwHBnmZrFQGMzZh86i2GUL3qIIGMFdtsO5JtPVB61F/b02ejggNosWojHF8nFMc1k29y876N8cS71c7EPF1JKHa/ekyUI8RpTonhsm1EQY3IwxjthoMG+F4OKoL3qgwBaIqV5xvRRmSH/02jy0DM0cLQFqmXBWpKwBqoYGG5OQxlB7CuQOfJlxST2hDLH9q4XJXShMzTilEdL77R9aOKA6tmwvmCjY0kzLiTAFtXBVRheojnQQdicpDIbFVU1tdOXK0U2UOHD99JlLsyRKmU4yqOmVMQYXJBvV+Ynj9OSogG0nSTEJTSWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8050.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFdGdHE2ZUdYU1RRUnlaNVBLb05PYTdURkVFcEM0YmFsN1pvTnBBeXIzQVA4?=
 =?utf-8?B?aE9SWmFiTVUxVndlT243RS83cm9PNjJGRUUxbWdVUURaZHJnd0ZQTmRzTS8y?=
 =?utf-8?B?SHVYQUpzMDNnRFdYNWJYN2lJZHdtbjFHYW5xR0NDWjhnd1lvaXpKdzl0SmFR?=
 =?utf-8?B?WlhFWnp3ek8yT1pjMFZ1bS9pbFdibmlsMlZkdlgvZW02WHVDbENzRnZBbVk3?=
 =?utf-8?B?SW1uY3NUSTBmWUYvcGlGeVJHQndVWDBEeXd2NTA1blJ1WnQwTHZ6eTJZcnVk?=
 =?utf-8?B?ZFNaVkFTY2l1OEMxWHQyUUlCS0pUSjVhL1lnNjdOUkZ6NUR5UTh5MU5HRzhB?=
 =?utf-8?B?ekk4RFBabW1WNmVzRXJCRzZWQldsM056TzRFZlhUd3MveWhDRWFDS1Y5Z2pu?=
 =?utf-8?B?djdQUHNPUUxlV29lNnJXc2RHbndsck9UTEwxMThOdXE0dlVTTGxjcXpjeVVj?=
 =?utf-8?B?Z0tXTHZoenM1VUhMdHlQY01oRmtVSzFGM3VnOWZpMmNtZmZHbWZwc0cyT0dw?=
 =?utf-8?B?RFQxbzNHd01pWlhQOU9IOWlTMVVkZzJkM1NXZzRCcXMvblpyeHVwMDJaTDlH?=
 =?utf-8?B?M0sxRDBrSkh2azU4MEt1N0RqWW9TM1oyZkNYSmozU1ovY0x2blp1aXd6N2RS?=
 =?utf-8?B?TXdWanN0QjNhYm9Ba2grSHF6Ym14bzdzbVpGTUFUTm96cUpuQnhOd1FMa20x?=
 =?utf-8?B?YkNWZGhwUHEwY2xRYmF3bDUwVG42QmFHbVRlVGF6L3g4ck14NmY3Zk9vRGFh?=
 =?utf-8?B?YVlGc2lRNmQ3Um9XYWJRMW1LWWVwQzd2RTZ1SXlsZk82Vi9RNy9CRVVHUS9k?=
 =?utf-8?B?dTkvbnQzWjhoY1N5azJqVGZOMjZDbGtrMXdlL0xQSG5Kbjk1UzA0aDhMaE1P?=
 =?utf-8?B?bGtxOFJOa2hYZndpWWNDcTdzaW0weUxXVEt2WnRCRURIcjg5NnN2ckdubVQw?=
 =?utf-8?B?Mkg0LzlyS1k4ZGljWkZJTjRFK0hEa1Z4UElJVlBsTWR1dnB3QXk5YVNTbWw3?=
 =?utf-8?B?dE9sSFR6TFhsaVN6MDYzM3FlS1FUeXdCN3I4TGRiREcvbFpWUUxSY3JSSEJR?=
 =?utf-8?B?WE44aFZEdTA4MW9qUUNqYjI1R0ZLdXZSTUVwQWtQQUlyN2NPSHlSTmVKa0cw?=
 =?utf-8?B?K3ArUzA2QjlXbC8vc0ZmMzRyd3ljWm9WK2kyckxiYU9nallSN3U0UlRaK2Fq?=
 =?utf-8?B?RFcxLzdUVG5wMko4ZnNnQUFIL1pSZ21BZkx0TE1ISXR3UndpTTg1aEpLL2FZ?=
 =?utf-8?B?azA0U2lzVnVVK3RURElqdkh1VFh5Qis3VThXaHd0QnU3azY4UWhEa21SRklH?=
 =?utf-8?B?Yk5wdVQyc3UwSmZYSUtrRlNYZzVGbUxzellpME5sM3pVazdIMlQrR2FFWUl2?=
 =?utf-8?B?SWNqUWRoN0JtdFYxUlFiVWZ3TUxGSjV3T3R4dUdHbkhvNkdvUVN0ZnBKSTVN?=
 =?utf-8?B?UG81Q3VPeGo0bDVvYzNiMWhkeEd3aUZ3Ny8rTHg3VER6bUlqRVVOakY5TEkv?=
 =?utf-8?B?ZkFQd002L0pVeVJCa3VXR2lwR2htY1hDQ0lEOTYxc0dXM0IxNjljZFlHT2p0?=
 =?utf-8?B?OWllSFJnNDhqdGRlWUpMRjhNZXVoZHIybHJiWHNKMkFZQmJXUDFXYkluSXlI?=
 =?utf-8?B?QisxVGRXd3lYbVhrUE04RHlqcVBxYmZ2TXFHTHA4TGgvQVJxYW1NWEMrZkVJ?=
 =?utf-8?B?R09kNHB0L2RrU1hnRVk0ZGpkaGFDL1RsczQ3a1RIR1dZMmkzcU91M1UyT0Uw?=
 =?utf-8?B?Y0RxdGNWcnF0ZHBOakc2WVpqSWtYeGdEWndvbmlPRUNzQzREcmtOK3VXNFJt?=
 =?utf-8?B?UzdHNC9SYzQ3YklEcHg0a2R2bThpeGEzNlRaM2k4QzJDKy9aaElvVFIzVkVw?=
 =?utf-8?B?d3poSTJiUktTZDlIQWdWTTJzU1ovRFR3Mzhtdm4rWGd3QmNHWUUrdnZKRWFI?=
 =?utf-8?B?cnNGMUJNTWtXcVQrVzZGdHE3a1JDQjJCTmVMN1hlQU16N1FPaWhiTktTTVFF?=
 =?utf-8?B?SXMxbmlHYVpYMXhUM2ZUQzlOdGtQSklJOXg3ZWwyR2gxMXpDM1R1SndNQURy?=
 =?utf-8?B?cjhRZHBGbTVPbTNKK0dRb05wWi91RndsbXM3RlJ2c2NibmZYYnc5YnBhbGVF?=
 =?utf-8?B?azdMYW43VW11NE56WmV6L2ZGMysvZ0laeURLQk16cjlzMGhRdkpudDE0L1dC?=
 =?utf-8?B?TEZJMVAzSitadVdpTDdWaHk4VlJwN0REdlNxdnhSaDUzdno1WVBWY1ZmSldN?=
 =?utf-8?B?dCtNRVJTcWxRQ1lOdWdzM1BIbXlnM0FzY2xLTnhobmNkZEttOVB0ZzZyUGZh?=
 =?utf-8?B?UFVKb1l1VUp2RmdhQVNjMFUzc3BXWlMvTjFWcVFPTWN0NzBWaUplZz09?=
X-Exchange-RoutingPolicyChecked: MFxuhZiNub726I1J96GKnhjp2+xUWEz9IJRXwoNzbzDDiLId0bPn5as6CQcSD26MFputfHFa5iwuW9XAPJVB6q6sWiCwZ0mCrWVLzEmq3MaL3UZKaDxV0zb+NbFTeMTTEJcAvWlxr/RFLaRPP8tYWqUgqScmOSGvC/01c30mcFTBYstmtbZjIotQdX7F7auy0lW1e538mzADGOs0MjApgompYypOSbjyEHDuZ+SluqwUceNoTenKWqlJrwvolPgoBKVOGbNFIasELs9Z+crZRG+VQMiKM0IO1FCpSm+KKhcOq/ueYHfWDnaxdr4Ol/U5VtMqIrUrd/hNarV5WGPqsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d9e01f-871c-4950-9a14-08dee16a36b9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8050.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 05:39:03.5834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKBKoanEPMxBAX88RQe6jPGuULlnbYP2sIIsGbAbcp0ieT3wL2OCq95XU0wikuPJp1oREyeSBAOdIyh9tBWYWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6260
X-OriginatorOrg: intel.com

On 7/7/26 10:12 AM, Alexandru Elisei wrote:
> Hi Sean,
> 
> On Mon, Jul 06, 2026 at 06:29:11PM -0700, Sean Christopherson wrote:
>> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
>>> The entire memory represented by guest_memfd-only memslot is shared and
>>> accessible by userspace.
>>
>> ...
>>
>>> +8.48 KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES
>>> +---------------------------------------------
>>> +
>>> +:Architectures: all
>>> +
>>> +The presence of this capability indicates that memslots backed by a guest_memfd
>>> +file descriptor created with the GUEST_MEMFD_FLAG_MMAP flag can have dirty
>>> +page logging enabled.
>>
>> What does mmap() have to do with anything?  Supporting mmap() doesn't guarantee
>> the memory is shared, and I can't think of any dependency on memory actually
>> being mapped into userspace.
> 
> My bad, it should have been GUEST_MEMFD_FLAG_MMAP +
> GUEST_MEMFD_FLAG_INIT_SHARED. I'm not sure what you mean by "dependency on
> memory actually being mapped into userspace".
> 
>  From my point of view, it only makes sense to enable dirty page logging if
> the contents of the memory is accessible to userspace, hence I made dirty
> page logging depend on userspace having the option to access the memory.
> This can only happen if the guest_memfd file is mmap'able and accessible by
> userspace. But it doesn't force userspace to actually have the memory
> mapped to allow the log dirty pages flag to be set for a guest_memfd backed
> memslot. Hm.. now that I think about it, maybe I should have made depend on
> guest_memfd also having been created as shared? 


TDX live migration also needs to toggle KVM_MEM_LOG_DIRTY_PAGES on guest_memfd
memslots to use KVM's dirty logging infrastructure (the actual dirty
tracking for private pages is done out-of-band via SEAMCALLs). So this enabling
is needed, but it would be better to keep any logging eligibility decision in
an arch hook — e.g. gating on mmap/shared wouldn't work for TDX.


> Though I think that can be changed with KVM_SET_MEMORY_ATTRIBUTES on x86.
> 
> Does that answer your question?
> 
>> ...
>>> +			r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
>>> +		} else if (change == KVM_MR_FLAGS_ONLY) {
>>> +			r = kvm_gmem_change_flags(kvm, old, new, mem->guest_memfd,
>>> +						  mem->guest_memfd_offset);
>>> +		}
>>>   		if (r)
>>>   			goto out;
>>>   	}
>>> @@ -2117,7 +2117,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
>>>   	return 0;
>>>   
>>>   out_unbind:
>>> -	if (mem->flags & KVM_MEM_GUEST_MEMFD)
>>> +	if ((mem->flags & KVM_MEM_GUEST_MEMFD) && change == KVM_MR_CREATE)
>>>   		kvm_gmem_unbind(new);
>>
>> This is wrong.  If kvm_set_memslot() failed, the old memslot needs to be bound
>> back to the guest_memfd instance.  Hmm, but KVM can't guarantee success.  So
> 
> The old memslot is still bound to guest_memfd in the sense that f->bindings
> still has the same memslot id+as_id assigned to the memslot's gpa range.


Whichever way it's handled, TDX will need this flags-only gmem update too.
A solution on the generic code path would be helpful.


> There's no rebinding happening when flags are changed because the memslot's
> id + as_id are not changed.
