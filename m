Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD3127E1DC
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770764262; cv=fail; b=aAvrQut8FnxJXDdXnV2XuiH1xzzDgaHn/ADgidP3zt2ryYUA7WPlraC8OoFaM6kPGgicp174FJdE/ksvZ2moYeEiN180jQzPGIlDJ7PPIUeDJuubhb2DgWFjAe2IXy0P8cnPGL0bfZ56VmpZTRz5Bh6PNSQUklWh5Ssxc91Vleo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770764262; c=relaxed/simple;
	bh=QcSFS8ownbd1DjGoY2Vd6ClSvgrBP4vpQ9bVoenF+KE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e7TNdGPlNreqLMl9ubjeGDCHOCsCDgq5kfYwjHW8+cXj1VlTHvS0UR1cHp6y0LNoBUX6Rdb6Tw1Nnw+jX5WE2oIGeEM4M2E0Z2pBoN/KGHmoH805C0lSMAN0rrLIfaz2fgUvdo4RJ65UusRhvNzVcNkxnPi2U1H8BNk1b1KflOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LiDwqPMv; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LiDwqPMv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770764261; x=1802300261;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QcSFS8ownbd1DjGoY2Vd6ClSvgrBP4vpQ9bVoenF+KE=;
  b=LiDwqPMvKHRBYt8CUHKrL/XRf0qsvtFfnK9m+03O3wF+iM/jxvblQkPr
   IvQDvwN1YEdCJMPh306Ys1FeWLXyU114bgcDp3eGVsohlHz09WRmu1BxS
   TCQtsWZokNiblwWot0jl8xwVmGBoL1xN3a2FFXCWTJlzg7+hrz2ksEHXu
   2OeneICK5xjgjV5yiKwCJRWPMCAhtriudC7dTf0ZfPos7wKSCVFaZiMIl
   4jXvgS3XJowv0zepk1C85bpYXvYgmbDiF4RJYvcEITnYw0n+PK3AJMoyP
   BwBP4frpYOAb4aMSce9gkVqzjf1CKd512TFOZjEKzD3zEBFmBVdpxUbSB
   g==;
X-CSE-ConnectionGUID: FtUpbMuKSGuaDP982X9Ttw==
X-CSE-MsgGUID: I/x9B2ndRa2m5MWwa36jtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="97362054"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="97362054"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:57:40 -0800
X-CSE-ConnectionGUID: WqDsM5mcTnaftppYMBGqHQ==
X-CSE-MsgGUID: UE+A0ctlQPWfUrAFJ3dsiA==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 14:57:39 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:57:39 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 14:57:39 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 14:57:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NwrR/nVYmxewYidmyY0WVZAZ/CA9oFQH1H32LqwWmrrJfOr0E1tT/dXOSMsL79g1E0V7BrSMkYYk4MUhUU0Xd/9dE50H6rJDiK13yBsttb3XNThxVObsTSLnBWBpkCbf/63AKzwFr1sCwEdHHyz9YT+2soglkTLiE8qpomIqNJIKhnARyqVty2nhVYv4BjXayCnsOhhlLbujhbpnpgx0uZe+nWkPGqwTr+UvCaNrWZEjDNbJg+SUzkaYpGh0TtC323LFHcMv5ePxVIgE27v2iomr5mwXJnm5HJcZrOTwYiMmnnZOWrQNYfyTNiHbAV14gwC5AsDuCOrzqlxCzpCaSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukxXm9pI4GFKzAntbf462BIcN3HnYBHiWeiAAtpmlCA=;
 b=Sus/gR15tNCyjg01KhvQKfJqFfcAUkr8NqWCdPe9yNC89W22wOwDLr0BOLaBapC+Ak2MTdomx9dqlRB9xOC0aWTblqRKnw8HMJCiTN6uv0IWK2I9sTOb69iT+IAhJ6W0wC8OuEYqpARzToZp7DEFlq7fsVzBJ5vKa90Apf2cGViiAI20wh8oiDqddQ9NvD3nElxtRNhdWfF5hw/3rS6qaAiP2oRTl72KAK45EJqq7hyqVRsDdoJRuA5JI0Vy50nkh/tnjemQwVakM0f3b7zy8+kC+nSHHYcEaod5EgqPTN+cizPmQ5uWByF8hNeNzvbSq+xycAmAyR9gyH9CVChkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7439.namprd11.prod.outlook.com (2603:10b6:806:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 22:57:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 22:57:33 +0000
Message-ID: <f2951303-6fe9-4674-bd16-0dbef39cc1d4@intel.com>
Date: Tue, 10 Feb 2026 14:57:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/41] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <rohit.mathew@arm.com>,
	<scott@os.amperecomputing.com>, <sdonthineni@nvidia.com>,
	<tan.shaopeng@fujitsu.com>, <xhao@linux.alibaba.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>, <zengheng4@huawei.com>,
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-14-ben.horgan@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260203214342.584712-14-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0366.namprd04.prod.outlook.com
 (2603:10b6:303:81::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7439:EE_
X-MS-Office365-Filtering-Correlation-Id: f4cf65e5-21e2-4f52-20fa-08de68f7c69b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUZPME9YRFdLR090VVV5MHQ0amlHYzB4YStWSmI5K1NIb0hnUzRhcENNdVd0?=
 =?utf-8?B?MnhyV2Vyck5GWTJvSUltMVBLTGJYN0gyWUtONlRtOFRjL2ZxaTQxVGJQdkdr?=
 =?utf-8?B?ODkzT3ZQNzd3NXNxZ2FRYm14QWpncUF2SUc1ckJ6S09BNis3djQ5ei9reWZR?=
 =?utf-8?B?Yjdxa2JmSFVkbm51bjJ6QURTdlY1aWhtT3hpSmxHYkZoZ0dDUEE1WHlUL2Z4?=
 =?utf-8?B?a1o0SnFTNnh6N3IveVRIVlE5dmllY2tSWWR0N2pxZGIxUG5va3RFNS9uTGI0?=
 =?utf-8?B?amZNRVFtekdZczl1WjVaTHFWNE5xWVNLd2YvUG9waXV1NHlCYWZlYUNycjIz?=
 =?utf-8?B?SmxFM3ZwSUhVVlN1Mnk5MXJ0SDdKYzJ1SlhoekRQaUsyNlo3VU1rdFdGTkVT?=
 =?utf-8?B?bUNwVndCVE1FV0ROMmRXTHhLVHBrZnc1U09saEVzR2M2eVF1TlB3OFZnd1hi?=
 =?utf-8?B?WWJaM1l4bHpyZ3dmMytoSGIvc1JOT2g2bWVmQ2xha0k0a2RsVjd5SllaaTFz?=
 =?utf-8?B?cXZ5b2xVckVXUVJaVVBqY2o4MytET1FlclEwbWFUNTZUUkZjN0trdndNZE5O?=
 =?utf-8?B?TWwvVkYzTXY1d2QzU1N2UHBpc1p3K0RwSExOM0M2cCtFZXZXdHBZZVFQc0FU?=
 =?utf-8?B?Qk0vZ2gyLzR4dDZZMWZoWkxIc0c1YmlEVUJJS2xWK2NrZjBpUUttZHZQN0hv?=
 =?utf-8?B?MDVJdEZnUHRGZ3BmTFR2Y2NjOVRCZ2FXREllYVlWdWZFR2pQRm9zUG1PRkI2?=
 =?utf-8?B?TmZSVFFnZVJSUC9VNXN3dHJVTWJKZ3RYeXNFSW50WXJKUWoyQVcxVlZSSVM5?=
 =?utf-8?B?aG90N0pCZjZocndSRUNMamlxcEVzaDBQOVR0emxkM2NTcExXNnJSVGZYVDB6?=
 =?utf-8?B?UEZmakthdXA1R0o1amhMU3BXUXlhRGoyc1hrcHl6OW4wYUdqeDV2cWkrUVJt?=
 =?utf-8?B?MER0TzVyODZBMWdCQXkveVkweE1YQ3plV2JlRFZVdHA2M2ZYZGNpeHVVZ2RO?=
 =?utf-8?B?aHRYTDdwL3lrTTRIbDQ2Tk1TNVNPUmhZL2hLVnRRdEE2dkE2UUtiMVNnRExz?=
 =?utf-8?B?QUlpd2RuejFzUjVpRUxOT3M2WmJISTh3aVJiMmdhYTluSWNnUGtSMDFUV1l5?=
 =?utf-8?B?Y1BEVXhWTUx1VzRjN09ZM0RFWHNUSVJWWldSZUxzTG52cjZtQkdiR3lRZWkz?=
 =?utf-8?B?VXNJME5RblZRUXowcDZFRnFkMFo5RHBUaVUxc3hIbGRTd2FyU3hob0J2Ym1X?=
 =?utf-8?B?eFM5RHNScmRHd04zeTJpdHhlMUpsMm9UdUZYWjBJdlVSVzN1YXo5Y0c5R2hl?=
 =?utf-8?B?Sjhkb2tRemNKZjlyMmZLdlNsbmU2am9qWkpVQXgwTGxmN3N3RWVZL25FSjRh?=
 =?utf-8?B?Rk9yK2lUL3VoT0dQcy9tUUJMQ0FKemFHbVFPYzFHZEREa3NiY1oxZUt6Rmw5?=
 =?utf-8?B?dy9xc3FDSnZrdWlZaUMvSVQ4MG40S0l5Z0ZvRFdmUHowTHJmdVBVYnpWbFFr?=
 =?utf-8?B?MHFRKy9oVE5kRUZQN1M3cjNYVWtIWEdTVlltZXlvV3VIUTZjb3I5cU1RcHUx?=
 =?utf-8?B?S3dRM2szdDdIVnVPdkExY2RLdkJHUHZKVEhHdUlmenNqSkhMK2tQN2sxNUd0?=
 =?utf-8?B?QklweGR6TU5hdnB5QnRjT0hqL1hnUmdNdHc0SmtoVEVQYkFxZDlxb3djcTVZ?=
 =?utf-8?B?SmtramdYZjBYMmtXeC8yNGp6TGZQTHdVbXhvNzJSMjlOeG5rN2ZTS0FFYSsr?=
 =?utf-8?B?TkZuWTVBSWZtTThuTG9HeEFqYmw1M2F4NGdTc2h1RmZrN1VrSC8wS1VaOVBD?=
 =?utf-8?B?UjJrb08vV1phLzUzWUtFZzdaVTVpOXg1R2Q4QmNFNW1yVGhkWlJWUW9MWjJK?=
 =?utf-8?B?U1d1MCtpTEpyRFZ1b0xKTlJpVkZzdGVKeklrd0cvc2hRbzJPZkJoc0o2TkVN?=
 =?utf-8?B?MlIrdG5CeC9Od2Q5YWR0SDNnd0FrZllnck5QQjRHV0ZvZjFmRmV2OUk2VkFx?=
 =?utf-8?B?blFtMTlvaStKVUJUYlNza0tyWW03ZzM0dFljaVNPc1hFMGlKTndwZFpkR3pP?=
 =?utf-8?B?aXBUQTUzc0FCaHp1TFhUR1dTRnlJVU9TVEJyaW1LWnFmSElQOVlZbmlnUSty?=
 =?utf-8?Q?pY2o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RCtpY1lCQk1kejFDQU1jL25ORmV2Ymk3M0xVZGw3ejVyakIybVA5d0t1SER0?=
 =?utf-8?B?alRvbXNsT2gwbFZlRU5uVmlyRkhsSXZmUkpZV0s3cHMxVWpXVlRrU0RpVnFP?=
 =?utf-8?B?ZjcyZ1IxUGo2UERSR1JLY1gxakhUMTdqbWVHNk5VR0xrY1lTVUZramx0R0xv?=
 =?utf-8?B?VllHT0RmTkxkZjhRYlJtVnJUckpmUUM2TEw4UU0zUHFvUDJXdXNTOStxTW5a?=
 =?utf-8?B?cnVjTjJ3aW4zMHJoUXZoOTFxdS9XMWU5Y1dFSGdjMno0aWpWNXRkc0c0cExC?=
 =?utf-8?B?MytDSUV3UUhsNlpzU1RyMGhtaUFRYW4vQXN4RGZjRGkxTDUyMmxuQ3RJSUVI?=
 =?utf-8?B?aWZuUlB5Nkd0cTFKcjN2Z0FuaXZRVjRJbmM2c0p1TktwTHVnc09SWnhhZFlk?=
 =?utf-8?B?RVFmWm5tcXc3YVUyNEU2K0ZZblE5cERSbFdnWDBFakMzZlFNVEw2RkFlVHV1?=
 =?utf-8?B?dEtKY3FXaWpkQjhmVnBCOWw0bkRaOTVaSG9UWTd5NlcyeXNtcGFESTBsNW1n?=
 =?utf-8?B?Zm0zeG5JNVV0NXBIMFVTbDQ1cElMUnVwVFdaSjAvYWhhNzkrMGJzVDJZMjhZ?=
 =?utf-8?B?NU1jak55Mmg3QWFHUU9UYUpoSUZveWthT3d0MUFFRnBHMWo3MDVwb3FTN2t5?=
 =?utf-8?B?SEp1T3V4UXJ1cHJLNUNPRm9WbXNpa3ViOUdyYlZiUHFQc09aamdWaGlLeWRl?=
 =?utf-8?B?N0dHL1g4ZGdMNGdJaFF1MjJ4S0tXT3l1dFJJT3JMSjBUcy85VkpDS0hiSEVp?=
 =?utf-8?B?a3NodjRkSXNBZmluMDQ2a0N3TTl3WnhnNnZpN216VWRSUmFaRk1heGQ0cFBw?=
 =?utf-8?B?NzlwMDVVN3cvSHBkWG1mN2NsUVR5Zk1lZlkwNXZaNzF5cEhLSlh0czVaMTFy?=
 =?utf-8?B?V3k0THdFSHZiajEyN2RvWDhBSnFaZE5NdDhaUkhoQnMwVTFuZmNScUtTQlFv?=
 =?utf-8?B?amtrcU4zYzlKRlRYQnE0MTlkZ1lJRDJYK0NKM0daMzBldHl0K3NRTnlXVnl0?=
 =?utf-8?B?WXdZODRFZHB4aXA5Z3VaUjltSHgvTzM1TUFWbzVhdnJwNjhSaGtab2MvWkVJ?=
 =?utf-8?B?cTZ4OWRRSDZyZGFSNHNLL1k0Wjh4SDZZdDN3bkdNQmoxdmhueFFFcTYzd3Bz?=
 =?utf-8?B?aHBqREdJUWlUZmlWd2VQL0hQL1I5elMwa1RxMENHNDFvTlU1UDYyQVlHckJu?=
 =?utf-8?B?Y3JPdFBKaUw3Vnd2ZnN5UkZzVTRjY0dCeHhJSFMxSXFtNElJUnRmWm96R2pr?=
 =?utf-8?B?Q0FWQ05RckVVUjdUR1VIakNiVm1hRC83VWxBOW1FNVVmS0FVUnBHeU5MTWRT?=
 =?utf-8?B?YnhBbXpKd3lKK2tKMWRtRmdzNG4yRG1WNnJZc3pUODl5UUVZTE4zSkFoK1hz?=
 =?utf-8?B?T2JwZE9lNmc5d0NOL0EwaUtSekhXdkFmVVBLamVpWTdsNDhjVDl6dWZac1gv?=
 =?utf-8?B?ZkVSY1dFL2YrWUtZcHRNNTJUZVNOMndSbytWbC9UN1dZeVlNQkxBVUQwekpq?=
 =?utf-8?B?eUdTUk9xT1FMWDlSa0lsSjdWR1MxeFNmemJvYTM4YnhkbkZtMzFndGJHZW9t?=
 =?utf-8?B?ZUMzQVlMRHdWZ1ZDSS9iSTQ5L0lDT2tkWW96U3RWaFJpQ2lOaFdLNWpJL2dr?=
 =?utf-8?B?TitpR25qNkZjblhvdC9JQVo0UFIwdkVCWnhYMTZZVHVNQ3dsRGJNcHI5Wjl4?=
 =?utf-8?B?UWpQK01rZitpTFg0TG1oRXp3azdmYnhxaDBQeU45OC9iZzh1MFZUUnl3aExY?=
 =?utf-8?B?cE8vR3JVcEkxRU0yUDB3OWdsM1lmUStORTNmUHJnRE5ua3FycmVqQzJRNERx?=
 =?utf-8?B?aGxIT0VKUjA5NGJHVmNjLytOOWF1Nndib3VtbHgweG1TL2hLQ21YV3psb1hk?=
 =?utf-8?B?R09QcUJCN0lTcWJpejhVVHdRVm0zZG9qNzVJMW5teXora2xQNWkvd0Y5aTlp?=
 =?utf-8?B?Z2d2U2ZyeEJ5bHRCdTMyQ21TNmlFQU1sWldyWkNSWDhuSktMWkdTV0hJQWtx?=
 =?utf-8?B?Tnpsd0tQYkZVdmh3VmRtRnBVa3NpQ1M1R0pzeVR0NHNIYUh0Vlh4NndmZEYv?=
 =?utf-8?B?NnRxaXdtSEZwWVpPM1BvbGo2ZEU0T1pDaW9FQ2hnWUpWWUUwcENRZU40OStl?=
 =?utf-8?B?UG5SbXN4OW8vRFVtM3djeEVEUzU3RkZabi8vUFI4cG44dlgzc1ZydFhPZXFS?=
 =?utf-8?B?bHg0VDAwSkU1a0xSUHp3RmlBTmVYR0FBbHMvTGJKQzNXZTl0SzR1ZEVHbHV1?=
 =?utf-8?B?RGlrc1loL1lGczVnNnRCZ21Zcmp3VWlPcGtwUkpwQi9yekQ1YjBWdEprbXpN?=
 =?utf-8?B?dnJyVkFaTWErMnJRUWN2dDk4d0FzY0xMYU55c3c1QzltVGg2L0t1ZUQzOWha?=
 =?utf-8?Q?myw/vJ4QyZGrhgoM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cf65e5-21e2-4f52-20fa-08de68f7c69b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 22:57:33.5265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UwmMy3kI+0zUOdY8H8OiSCvJECEB1ssrWpLdkg31X3v95Z7////4r3f08QQ/A4cNVvdWLcp179gXhupK4WAHqhZfsVLAxXiJEYlf4aCzv9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7439
X-OriginatorOrg: intel.com

Hi Ben,

On 2/3/26 1:43 PM, Ben Horgan wrote:
...
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> new file mode 100644
> index 000000000000..4c2248c92955
> --- /dev/null
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -0,0 +1,343 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2025 Arm Ltd.
> +
> +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
> +
> +#include <linux/arm_mpam.h>
> +#include <linux/cacheinfo.h>
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/printk.h>
> +#include <linux/rculist.h>
> +#include <linux/resctrl.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include <asm/mpam.h>
> +
> +#include "mpam_internal.h"
> +
> +/*
> + * The classes we've picked to map to resctrl resources, wrapped
> + * in with their resctrl structure.
> + * Class pointer may be NULL.
> + */
> +static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
> +
> +#define for_each_mpam_resctrl_control(res, rid)					\
> +	for (rid = 0, res = &mpam_resctrl_controls[rid];			\
> +	     rid < RDT_NUM_RESOURCES;						\
> +	     rid++, res = &mpam_resctrl_controls[rid])
> +
> +/* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
> +static DEFINE_MUTEX(domain_list_lock);
> +
> +static bool exposed_alloc_capable;
> +static bool exposed_mon_capable;
> +
> +bool resctrl_arch_alloc_capable(void)
> +{
> +	return exposed_alloc_capable;
> +}
> +
> +bool resctrl_arch_mon_capable(void)
> +{
> +	return exposed_mon_capable;
> +}
> +
> +/*
> + * MSC may raise an error interrupt if it sees an out or range partid/pmg,
> + * and go on to truncate the value. Regardless of what the hardware supports,
> + * only the system wide safe value is safe to use.
> + */
> +u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
> +{
> +	return mpam_partid_max + 1;
> +}
> +
> +struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> +{
> +	if (l >= RDT_NUM_RESOURCES)
> +		return NULL;
> +
> +	return &mpam_resctrl_controls[l].resctrl_res;
> +}
> +
> +static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
> +{
> +	/* TODO: initialise the resctrl resources */
> +
> +	return 0;
> +}
> +
> +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
> +{
> +	struct mpam_class *class = comp->class;
> +
> +	if (class->type == MPAM_CLASS_CACHE)
> +		return comp->comp_id;
> +
> +	/* TODO: repaint domain ids to match the L3 domain ids */
> +	/* Otherwise, expose the ID used by the firmware table code. */
> +	return comp->comp_id;
> +}
> +
> +static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component *comp,
> +					 struct rdt_domain_hdr *hdr)
> +{
> +	lockdep_assert_cpus_held();
> +
> +	INIT_LIST_HEAD(&hdr->list);
> +	hdr->id = mpam_resctrl_pick_domain_id(cpu, comp);
> +	cpumask_set_cpu(cpu, &hdr->cpu_mask);

One addition via the resctrl telemetry enabling is a new rdt_domain_hdr::rid
used for some additional checks on the header.
https://lore.kernel.org/all/20251217172121.12030-2-tony.luck@intel.com/
I may be missing something here though since the additional checking that this
new field supports should have complained loudly ... unless this was tested with
only the L3 resource that happens to be 0.

...

> +static struct mpam_resctrl_dom *
> +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
> +{
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	lockdep_assert_cpus_held();
> +
> +	list_for_each_entry_rcu(dom, &r->ctrl_domains, resctrl_ctrl_dom.hdr.list) {
> +		if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))
> +			return dom;
> +	}

I notice here that that only the ctrl_domains list is searched ...

> +
> +	return NULL;
> +}
> +
> +int mpam_resctrl_online_cpu(unsigned int cpu)
> +{
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	guard(mutex)(&domain_list_lock);
> +	for_each_mpam_resctrl_control(res, rid) {
> +		struct mpam_resctrl_dom *dom;
> +
> +		if (!res->class)
> +			continue;	// dummy_resource;
> +
> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);

Consider a system that only supports monitoring (exposed_alloc_capable == false,
exposed_mon_capable == true). Since mpam_resctrl_get_domain_from_cpu() only
searches control domains then it looks to me as though dom will always be false
here?

> +		if (!dom) {
> +			dom = mpam_resctrl_alloc_domain(cpu, res);

Would this (on hypothetical exposed_alloc_capable == false, exposed_mon_capable == true system)
then cause a new domain to be allocated for each CPU with a single CPU in its cpumask
instead of allocating a single monitoring domain with multiple CPUs in its mask?

> +		} else {
> +			if (exposed_alloc_capable) {
> +				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
> +
> +				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
> +			}
> +			if (exposed_mon_capable) {
> +				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
> +
> +				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
> +			}
> +		}
> +		if (IS_ERR(dom))
> +			return PTR_ERR(dom);
> +	}
> +
> +	resctrl_online_cpu(cpu);
> +
> +	return 0;
> +}
> +
> +void mpam_resctrl_offline_cpu(unsigned int cpu)
> +{
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	resctrl_offline_cpu(cpu);
> +
> +	guard(mutex)(&domain_list_lock);
> +	for_each_mpam_resctrl_control(res, rid) {
> +		struct mpam_resctrl_dom *dom;
> +		struct rdt_l3_mon_domain *mon_d;
> +		struct rdt_ctrl_domain *ctrl_d;
> +		bool ctrl_dom_empty, mon_dom_empty;
> +
> +		if (!res->class)
> +			continue;	// dummy resource
> +
> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> +		if (WARN_ON_ONCE(!dom))

Similar to above ... it looks to me as though this WARN may always be
encountered on a system that only supports monitoring.

> +			continue;
> +
> +		if (exposed_alloc_capable) {
> +			ctrl_d = &dom->resctrl_ctrl_dom;
> +			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> +			if (ctrl_dom_empty)
> +				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
> +		} else {
> +			ctrl_dom_empty = true;
> +		}
> +
> +		if (exposed_mon_capable) {
> +			mon_d = &dom->resctrl_mon_dom;
> +			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> +			if (mon_dom_empty)
> +				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
> +		} else {
> +			mon_dom_empty = true;
> +		}
> +
> +		if (ctrl_dom_empty && mon_dom_empty)
> +			kfree(dom);
> +	}
> +}
> +

Reinette

