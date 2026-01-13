Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8034D911
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768322988; cv=fail; b=WzwL/saV1cs7rjeFJSkE3kvJuxiiWNH8BdwN2LZDB2wwQXYfZfLKDfn/JpkVoRr5PEzhtiMiPOvt+PFxCQ99W8qwQNOErDixEvnDm57aCiOTkX5RdwsfZK4m+vdk721Ij7B+vrUwmqkFuhoQTsPKuJLsfCLuVM6UeTDR8SEq60w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768322988; c=relaxed/simple;
	bh=vrF5eZXx2tKRf3EjFKJl+qt5Enw/T9M5nK0Oy6H3rOE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BTfgpInMJp8Sm7j69ZokOWtVvTTDUpKWVuWHjXBXn7/D/aS6qX0cxUaWmtfPFYFmvKOlRXRxowSbX/lgemYu/aY31wEI+SNgJeA3MfWSJuuVCo3nGI85GES4UVoOKKLs5qOur3kxjVZnHckxKXe+DeuZ163B6wEG6P26BlqmTEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eqnueu16; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eqnueu16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768322987; x=1799858987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vrF5eZXx2tKRf3EjFKJl+qt5Enw/T9M5nK0Oy6H3rOE=;
  b=eqnueu16AwNwmu0BnpZIyxhpU3Au+lLT/oP70kN7PYgAR2iDZMCbYvE8
   zkoCGf7B1o4Yd5erlAlllJc0H1hhvVXwefHkGD55utB5nnXT/5xTfvPxY
   +Uy8elIGKea+1a8h8gRYmK8GrOs8vlouOVXqPbC2/apEx10GoicwNjGy5
   +KDTlYRSNYJ4cyL29vKpNAmqxii64wDBkmUqCsZinhfWjgNIbNmzmTIQQ
   TxI4zMj5ZSNaspg2kFIpE6FRV2bsB5dDrR64RFD05y4ItPVlRi22Bg1Hs
   JNPSljCY92y74TuQ9w89dCdYrd/z067e7d73Hu8Vl+NG6MKqgvDLeZI4O
   Q==;
X-CSE-ConnectionGUID: kuNF7jlTRZKMm2DY84JMAg==
X-CSE-MsgGUID: oc3MK8RFSZqBW3skhzyyUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69693430"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69693430"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 08:49:46 -0800
X-CSE-ConnectionGUID: y+z+wB84ScSvC5stssyd9g==
X-CSE-MsgGUID: Yqsu6u9tRTSNcLgo8aBfNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="209485123"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 08:49:46 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 08:49:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 08:49:45 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.40)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 08:49:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rq3aaw05g/fGf3NbNHQsOmM9fkKBLlU1vSTfeqxTfA8eKZtCRaoU1GB/oRRw3wJKDoMbQF4wbMG702gxPAvzB81RV2dUiH114UWpQUYLbfJk9LVltfgmgZWJVWRmAh5g59c3F+JKN3VyYH2qaPHKZNLIcfDWCa1OiWdGaR5yx2AmrwnaaNmRj2ajnrejiX/nBYQi9kojOrJ5yQUnseS2DBl+k+ELyMZ3ca6wtZobJXwB5358MWqPHYphxbnegE1VwbC4NtC8bxXEqPLZsqKsk2+crxnuK1vhgHpTFRlFu/8wqvi0I2b5a4KK9j80mX7n/aFROYnU3I4FENJ807Oi0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqvwfL1uvAQT2xdFeoWAwVwWV1kBcVjAP5GNF5gINEI=;
 b=q58s2/v2f6xmfEPnfbzD95YYxEgnAyvasWEBZB2C3FYwyqiLVPQOmPKi3y7NMy8MQdn451xSkMu68/dBNTO2eaEwYI1L2YuODfboinwPX9+beB1olcBo6aA1opLe2DYiRymde43PuMuFKaBEk6hmgsiAJcJqCjwX2dPT2NbqjddkvtzjnwZQhL4FTNznE1PIfERF9rEkLblYRls6lbIhOMi0s5GXmpvi7OOcFqpRitsTAq3zHmkifd7oQ5OG5I3CjGVcC0W6xJa+qoV80ufa3kA4GREj1lxnik8mRWWe1bZo+8NXbcvddzbSsp4xatHdw7MXrR/Rc7Jg462B9WLx2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB8272.namprd11.prod.outlook.com (2603:10b6:a03:47d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 16:49:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 16:49:39 +0000
Message-ID: <2851b4cd-fffe-4dbb-8094-60c2d4bc208d@intel.com>
Date: Tue, 13 Jan 2026 08:49:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/47] arm_mpam: resctrl: Add boilerplate cpuhp and
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
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-15-ben.horgan@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260112165914.4086692-15-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB8272:EE_
X-MS-Office365-Filtering-Correlation-Id: 0206c7c4-e069-4914-b276-08de52c3be35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b21McHFoajBWNCszbS94SmJjYm12dFVaYlB6anR3VGVXb21iODQrWHV1TGQ0?=
 =?utf-8?B?UENsYTAzUitIQ1IrT2VpQnpGUTJPOWF6SmtVN3d4YUpGbkRTa3k4T21EQXpJ?=
 =?utf-8?B?dTZpN1Fsd1dUSUtnMDRNVmkxaTF3OGZuM3JPOWpLT081MEk3RWpqUVI3VllM?=
 =?utf-8?B?TjRyemlaUlZqMDZNQVdJN3dTNkZ4SEFKenhFT0s0djZVa2lRRFB2TDI5N29M?=
 =?utf-8?B?cUFubStibGordWFxN3JkcjdWWmhReXBzanBJNjFIdWRod0FPTkRMNXp2Q1VS?=
 =?utf-8?B?MmJvaXAwbnlNNldpeUJzRUJ3cGVrVnFQUzhLNmhraGlZNDFWWTRvTk1qb1pC?=
 =?utf-8?B?ZFdBQWVJMTdyR29Lb2FkQ3g0MjBJV0pVTVpma1VaclJjMmh6bGg3b2ZqSEE0?=
 =?utf-8?B?NjM3MCtmb0Q0TS80Ry9sb3Z0cjZDdGVJc2pwN1FyUHUwcFJsTTIxV0d6WlVX?=
 =?utf-8?B?RjlTMXVWT0xkaGYvZnRlQ1EybDgyQ1I1NldVd2t6Smp1ZFh5QVZaOHpuRFNM?=
 =?utf-8?B?RExPbU5zdUFDV2FQWW5wNmtmZmZsVHBMMUV2SHNVbVZ2bEhIL3E5YzlFc00x?=
 =?utf-8?B?b3JGSHZRSWZMSVFhUjlocFA3dXQvemhXdHBQSEJJNUJqYU1HcWh1L25kSGxa?=
 =?utf-8?B?ejRyTlI4K0UvU3l3Yk1OK0tIaUY1cnNJMnF3Y08xRXJZbzZTZUJLeE1ZalRh?=
 =?utf-8?B?NWVWd2NQR3JKSjJrSlg3S3Fjc3NsUkFwTHJXR0J4M3MxNGgycml2MGR3OGNz?=
 =?utf-8?B?Mm9BakNwOTQra0NxUURUYWYrc2k4SVJhWThiU2RjMUpnVFNVRG1pN0ZWekh3?=
 =?utf-8?B?SWM1RkpTVWd3ZmoycEMrVkZ3WUEraHo4ZFBWMTZNK3M4NDcrM1BWMEdvTkhu?=
 =?utf-8?B?WFFRc3dYekVadVV1Mk9HdlRXL1RhaTZrVFJrTzlIdjZWNDh4NmpFRzY5TEtp?=
 =?utf-8?B?R1RETHU2S2JmUHVrbC9uS0VRMVd2bzJRR0NVNXJ4VTNHRnJmZVgrbStDY2ha?=
 =?utf-8?B?STZ3UmdKVGVpZFRFVWhPd284QlhVdGZ5ckFwTkhheE5HeldNa0RrWE1RaGdD?=
 =?utf-8?B?NS9JQXFhVEthUzk4ak1oUExkbG9rUmVjNGw0YVczUlJNSWxoOGZ0RTk1bUlD?=
 =?utf-8?B?c3M4L2o2ajdjanF5RVI2em95NFphYWZiV2JEVmhkKzd3K0t3OUNmOHpnTS9T?=
 =?utf-8?B?NTMxL0R2SjRhNzUvWVF5M2xjbE05clRZRlBXNHd2WHZRcjhNeFFnZU5zb2ZN?=
 =?utf-8?B?UE1XY0dMOTJyK091bExQR3g5V0ZUMEVZT0tob3FFNndPUjJ2RmpiMUJVUHRO?=
 =?utf-8?B?VjZCMTEwNkZYczR4YnJ0MU1UM0hOY1B5cTNhU25ObUFxL1RXeHJLL0dNTlVF?=
 =?utf-8?B?TGpHcGFsM05CWlhXOWlmSklBL3ZCOHZCSUVZNWpqSFFMejcvMWZaUm15YS9M?=
 =?utf-8?B?OElYL09mT2o5ZjBpcE11cHl0SjRDN01VczdEK0FXQUl1bEdBU1JrdTE2L3o5?=
 =?utf-8?B?eC9veVE0SGFSaUJPT2t2SDJyVjNjbXN4SVNOeU5nTzFkbTdrQmlXQzd6WmpC?=
 =?utf-8?B?TFhTZTRTYUE0aWlPc1VtangybDlaRTd4dm02akNZVm9xejgyeEVzUEJLYmVu?=
 =?utf-8?B?a3NiZ1Q3STZOWUxpQW1ETWtSTXd5K0xUdTBhM0V3dVBYU252bkRGOW1FUGVB?=
 =?utf-8?B?SytkOW84amY5M3JLakEwbkRTOTAzRDJuK2V0ZHN3YzJpQjFPS2I2WWhHQWli?=
 =?utf-8?B?RnJXKy8rWWhRSWdJcFkwRXNnNXNEUDVmSzF3bDNMTkpGYjlkRFFlVDZCVXlO?=
 =?utf-8?B?MHM3MGVVclM5bEh3Zi9pZGpPRHlMd2Y5Rmk2Z2pXYnZxYy82UmFUblpGRTlS?=
 =?utf-8?B?YlBwbXN1ODNNVTF6R1oxRnl0dXJDTTdsVCtqQmd2MkUvdklwd2JsM2tlSGhW?=
 =?utf-8?Q?9BNd4Lag0O4HW9HM6yHr5rwosAWVQ+7y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0hJUW5tdVMrZE53NE82TjlhTDBWYUQveDBqR0twdURqOVlrVTh4eldvU2kv?=
 =?utf-8?B?VzRKRnhyZVFDc0xaM3IxRHZyOUVHRi91T1hyNFg2aStFcXZ0dlBmbmFheitN?=
 =?utf-8?B?a01uT1lSTHZJajZVVXM1ZjA5Q0FiUWVUNlQ4dGYyc2lBZjIwZGhieTQrSmdk?=
 =?utf-8?B?OWhncTRCaFR0b2t3ZktMK3QvTE81Z2RsWkJSTDcvTndLNVFRQ2NrU25XbGlq?=
 =?utf-8?B?R2E2YnRwNHh6a3orWXlJbkdja3p6cmpYOUhnbDdEcGVLTUYzMG5SL01IWHBM?=
 =?utf-8?B?YzZyTXB2QlJDamFxYlNmWmZHRHpLNWlxKzdEWkZ0YkNocTY3ZTY4dDFKd3o1?=
 =?utf-8?B?YjAyUHp3SG1KNUZvS21hQ01RRllzZWd1ZHN1RkVtREF5ODloNVNIS1k1MGsr?=
 =?utf-8?B?amh2R1Vvb24vQ1h2NFhoUXdlTWphT2JQYllQVjcyRnM3M09JWTl2cHhkRlNY?=
 =?utf-8?B?MXZxYWpKU0kySG92T21tR2pkSXpQR2dUN0tMSERLOTkrK0xhSGpQNjhGTzlx?=
 =?utf-8?B?RzVDSHQxNm5aU2ZiS3pWWGwzcjlvNnM3T1VGcU8vRHB0RDNCTlFMZm9CZnJz?=
 =?utf-8?B?bXphM2c2TjlYOWdxZ2VPcmhmTVhZREViZGN0aEUxUlhPVzByMlFDM1VkcjJX?=
 =?utf-8?B?SFk2Z0I1b0ZPdklyMUVtSmVWYm5uSVk1K1hEcWJTSWNyVEFOdU9XUE1odDA5?=
 =?utf-8?B?d2FpaDhnUG5WNjhMN0ZKR2FrMlBWOEZBbUsxZ0UzeUpkYjEwOGcvNUVnWGhx?=
 =?utf-8?B?NzlHYW9aOG5pclNDTjdRTHlwSkZhSlA1dkprdytGaG9mYWp2Y05TMUk4bUZS?=
 =?utf-8?B?VkRvZ1F1K1p3YUJQVFY4QjZKdXdRVHE1MFlZQVAzQUgwUTYxZU1WeDI0MDJB?=
 =?utf-8?B?N3VWSzZybkVIa3N5MmdwSUxwVDE2R3czNndGK3I2OGZXRTF1a0M3NlhVQUk2?=
 =?utf-8?B?cTY2Tm14a0t3aksxdmlqTWZDTDgzVytUZ0twaHRCcXV5OC9MZ2ZlRWIxZVdw?=
 =?utf-8?B?R0E0eXI1SkhUMjRYQ014RkV1cEtOYlNoT2J4YllEZklSdjJlckVWbzNsWlF5?=
 =?utf-8?B?S0NBRVRWbktqRUQwNkdBN0JyNXo5Zk4walhkbGVBVE9GQ0EvMTQwRGxtclZi?=
 =?utf-8?B?UjNsMmNOZk5OeVl5aUd2QXM0b1ZPLzQyZjd5YW1aWjhaTEQ3QUExKy9ZVG1N?=
 =?utf-8?B?VnBOZFFQck81Y1E2dWVMdUtRb2U5bURQanZtMDViRUEyYmFGbnlkL05yeEJT?=
 =?utf-8?B?MytYOUNWQVN1VFh4dFJ6TWpaTDIwclpMdXI5Wm9IN0ppQnlhSkFkRnJHaS91?=
 =?utf-8?B?N2VOSjR0RUk3ZFhabXBIc3ZWSCtWZWhVLzRxUFlEOWpjU09QazlnazJKNlY4?=
 =?utf-8?B?cG02dy82YXZFQ2R2OEcxdDJBMzF6QWtlckxMNHJuWVhGY0JXT002WjBRVmto?=
 =?utf-8?B?SGQ3dzRTNXlwTTBnRGl2R2FJQng4aVg2TjMzdy9LVloyVzcxUDMvWkkzN2lN?=
 =?utf-8?B?TENxUjhvcWhqRGJhVldzb1YySFI2eENwdVBjdTJaZERlU2ltaVpaNTdCak1i?=
 =?utf-8?B?MFFOQi9pRGp1Z01jQk9TQzBpQVRzd1ArY1JMMWdyazFWN0I1cEgybFhUYjBL?=
 =?utf-8?B?bzhkT0RRdVhCUGRyNU9nVTBIZFF3SHhsUjVqeFNDSVVPQkIreGlVSGR2ZGxo?=
 =?utf-8?B?MG9DcUc4MGZIMmI1ZUdGVUtxYStLdVNzdkV4UWpYMjQxaVpLejJveVNkUWxy?=
 =?utf-8?B?eWxVSFRSTUtLdkMwNzNzNmJUNDVkUG1tNFlnUTAxcmdQS1BsVFFYZmVsL2Vv?=
 =?utf-8?B?SHBhUTZKa3Vod0VMTnRqU2t3bElkVTZqVGpmSjI3bTA2aTZwZTNWODhMbTlU?=
 =?utf-8?B?NjBCamVqbnlxQmZaWjlqYnVIN1JuVVBLQzJMWjI5RGVLQ3BOTTZHLy9HVGJV?=
 =?utf-8?B?OVlJdnFrWW9XWnlYekN4bVBEcGNsa0lkZC9iZGs2T0dJYWxqSDdjYytvSUNl?=
 =?utf-8?B?NDN2d1A1alFDaG8wcnN5TXZuekZhaFBxcEF0QVNJdUNJNlBMWm1hZnRZUHJJ?=
 =?utf-8?B?L3ZJcFRSWUdhUzFFUlk3QW13Y3RjTWcwZFZrOFZHUDNUenRjT3lTMUpERkwz?=
 =?utf-8?B?cDRMUnZsWDhMTTZ5ekJuY3dUQkpxL0tsNmo1SG9GU2tlQTErNnNYUEoxQVkz?=
 =?utf-8?B?bVd0bXJxZHA4M2ZxenlpV3Q2SHFFd1NBT0FIekcvNXRWRVovQnpjRm1ydG1n?=
 =?utf-8?B?dElVcUhjRSsrckFkbmQ2OGcyVGhCOU5wNGowUXY3VTNscHNtRnZ4MGpTbkdS?=
 =?utf-8?B?ZVpDMEFsMGpGUDZzN0hHcmhmZUdSeXQyRS9DeG9TNTdkb0pUYlpwS0s1UTV1?=
 =?utf-8?Q?vqXByLKS5CysP+lU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0206c7c4-e069-4914-b276-08de52c3be35
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 16:49:39.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rlDkhoGuBKjaI+G2E/NfqfxbjqvuGjTyqblKWXbAW4xsmH2YvRnEIxaCKclDqkfwoQJpDU93c0hxFwuXG69SVKKktpGCGPhdmBDburf1oI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8272
X-OriginatorOrg: intel.com

Hi Ben,

(Please note I am unfamiliar with this code so missing some context.)

On 1/12/26 8:58 AM, Ben Horgan wrote:
> +
> +static struct mpam_resctrl_dom *
> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
> +{
> +	int err;
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_mon_domain *mon_d;
> +	struct rdt_ctrl_domain *ctrl_d;
> +	struct mpam_class *class = res->class;
> +	struct mpam_component *comp_iter, *ctrl_comp;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	ctrl_comp = NULL;
> +	guard(srcu)(&mpam_srcu);
> +	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> +				 srcu_read_lock_held(&mpam_srcu)) {
> +		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
> +			ctrl_comp = comp_iter;
> +			break;
> +		}
> +	}
> +
> +	/* class has no component for this CPU */
> +	if (WARN_ON_ONCE(!ctrl_comp))
> +		return ERR_PTR(-EINVAL);
> +
> +	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!dom)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (exposed_alloc_capable) {
> +		dom->ctrl_comp = ctrl_comp;
> +
> +		ctrl_d = &dom->resctrl_ctrl_dom;
> +		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &ctrl_d->hdr);
> +		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> +		/* TODO: this list should be sorted */
> +		list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);
> +		err = resctrl_online_ctrl_domain(r, ctrl_d);
> +		if (err) {
> +			dom = ERR_PTR(err);
> +			goto offline_ctrl_domain;

It should not be necessary to offline the control domain if attempt to
online it failed but removing it from the ctrl_domains list is necessary. What
happens to memory dom points to?

> +		}
> +	} else {
> +		pr_debug("Skipped control domain online - no controls\n");
> +	}
> +
> +	if (exposed_mon_capable) {
> +		mon_d = &dom->resctrl_mon_dom;
> +		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
> +		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> +		/* TODO: this list should be sorted */
> +		list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);
> +		err = resctrl_online_mon_domain(r, mon_d);
> +		if (err) {
> +			dom = ERR_PTR(err);
> +			goto offline_mon_hdr;
> +		}
> +	} else {
> +		pr_debug("Skipped monitor domain online - no monitors\n");
> +	}
> +
> +	return dom;
> +
> +offline_mon_hdr:
> +	mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> +offline_ctrl_domain:
> +	resctrl_offline_ctrl_domain(r, ctrl_d);
> +
> +	return dom;

This error path is unexpected to me. From what I can tell, if there is a problem
initializing the monitor domain this flow will undo both monitor and control domain,
even if initialization of control domain was successful. In this case:
- Flow jumps to error path from within the if (exposed_mon_capable) block and proceeds
  to do control domain cleanup without considering whether control domain was initialized
  or not. That is, does not take exposed_alloc_capable into account
- Control domain cleanup seems to be partial, for example, should it remove domain from ctrl_domains list?
- On failure there is dom = ERR_PTR(err) but I cannot see where this memory is freed in both
  the monitor and control domain error paths.


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

On success, should cpu be added to the respective headers' cpumask?

> +		if (!dom)
> +			dom = mpam_resctrl_alloc_domain(cpu, res);
> +		if (IS_ERR(dom))
> +			return PTR_ERR(dom);
> +	}
> +
> +	resctrl_online_cpu(cpu);
> +
> +	return 0;
> +}


Reinette
