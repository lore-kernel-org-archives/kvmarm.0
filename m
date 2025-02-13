Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8552AD21;
	Thu, 13 Feb 2025 07:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739431541; cv=fail; b=bTgHmeR1yUqkwIC/J7ljTZ0PLg4MzhYwj/0TibuH/gBQCNJjJ1/jSmAQk2+tXcPFA5qz0lV+Qobn7bE+8d+f6LAFz0ZZmqH0cFiUc8VK1o7QdB2GjHpEFQtRDAPkMSFu51uuIELpCz3LKuHc1FeEaGOtDJnyL9wZMEGWAgt+Oo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739431541; c=relaxed/simple;
	bh=p6G1GWuiZabsVvEVeAeLFNSr80S374kIW8YKve2TeR8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dpKBT8XRWHGsHSXbGll8umrPpzs3h4nSQizXVqmhFcVfnSCuHpuYA+aZaVD7moBtpxN9KMI9Co3GtGsh+WYd/IrUTbn4GjywC2JsvJbhAOM1F5fMY4tmjvXBlBOdW1+RT8Xp+JLZIDkoZhMzG6n1bfY3OkoaagcI2hs6LQTrNJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jrCC3BEv; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jrCC3BEv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739431539; x=1770967539;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p6G1GWuiZabsVvEVeAeLFNSr80S374kIW8YKve2TeR8=;
  b=jrCC3BEvUKOmv4mUM9QDsH/oJkVeIMOoCA7yO54JKXAcz6xp5V+fSxcq
   z3gcibM96XYzbFrtBDKTox3QZ89BfG0CSoFe0hhya8gqBK073SOsCvBv7
   bZMKy4zFVoh+IsPQoM5notvGDZzxsJxzfZ8Rt6aToGcYOvTm+H1soDLDS
   A2G4B6mdm9rHrvTofNv3Kdusjya/F510Vkzn1ac3VWQLtKprOt/KgDQ+L
   Rj+BDu5LHgY5eyF2SaRaHsc4iFgB3v06PMpnaAaAvXDP2sr0jlasFLBsN
   WJUioDCEtGPZpOcesCIXqt2if9NaGRwdFVo5hVN2XW6p3BlCiOCNJagk+
   Q==;
X-CSE-ConnectionGUID: avtXSGfZTm+d44/YjQWieA==
X-CSE-MsgGUID: ImeuNRJyThCCZhlXght/rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="40382075"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="40382075"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:25:38 -0800
X-CSE-ConnectionGUID: a3HdPm1YQienI7+pPHWPIg==
X-CSE-MsgGUID: 73vpiFqUTt2FVNZEacBcHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113588529"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:25:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Feb 2025 23:25:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 12 Feb 2025 23:25:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 23:25:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXziv2xwLLtqY9cVQRSrWAmkO0HphBwcpsgkwlsHUpLBFqMpBuTCQJd6UOyPsOzHXz821STh9hcBwfGRMTdRE/PVCHtNb7Y/C7x9xTvcfdK6HWoH/08SiYwOMv3+UlLP5ZSVTDrhY1Gbm8nqi4VqIhhBSEO9R8TeeFpHzTN/uEDP3nzjjdh2HDvHOqHDDkLdgXVBdDY/rRhvmdoZ2wRTu4zr9aE0HrXkAE7/3stSo0UbOEvXKb8X8U70T9Kr4dPHBuqyaX3VQ7R6ho0DejC4GvM+SpU8KnDGp1g3OUcTFFonsgrH7oZt7stZ7m88RKqytQTCcrWv4fp633LeZMRcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmyBNKJBQurbNJPX/JWzRj+GeIBmTxZ8GFD25wyZlBs=;
 b=XAd0ixFmE4uXf0mkhDLzaxAmJvKINmk5+u+Nzhf8KLwsWa4jp0l72ObzUUb0AVmBXx8upCCQmceviAFSAoszFeac8UyIxBFYNAFQ+HSSWD21KA8tYpiGR1o5p2lIWKmOCO5A/DYiWkMcMRrfHXXlPIIGgC3c0/jhTfstqRMqmgarCEl21Ry41P/hHzmfeh75KntLvP/j/6Cw4dh4n25STl2RWtZMLD3IpnRU3+GW4d7SUmOcAGUsvQ5ky7WXjANtjrRFqXm6s+3xaQTcN5CbJ8AxtOYH3bo1zVfD2M43u+IqkViA/qQiFWxxQ4YhzRdW6pwLGk4AXctCNpRPfaka6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
 by DS7PR11MB7950.namprd11.prod.outlook.com (2603:10b6:8:e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Thu, 13 Feb
 2025 07:25:25 +0000
Received: from DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e]) by DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e%6]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 07:25:25 +0000
Date: Thu, 13 Feb 2025 15:25:15 +0800
From: Philip Li <philip.li@intel.com>
To: Marc Zyngier <maz@kernel.org>
CC: Quentin Perret <qperret@google.com>, kernel test robot <lkp@intel.com>,
	<llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvmarm:fixes 18/18]
 arch/arm64/kvm/hyp/nvhe/mem_protect.c:1086:9: warning: variable 'ret' is
 uninitialized when used here
Message-ID: <Z62eW4gRfqmg8pzi@rli9-mobl>
References: <202502100911.8c9DbtKD-lkp@intel.com>
 <868qqetasm.wl-maz@kernel.org>
 <Z6nKYtyJO2bNycJw@google.com>
 <867c5yt7ao.wl-maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <867c5yt7ao.wl-maz@kernel.org>
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5423:EE_|DS7PR11MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: f364c2ba-3365-4fc8-3d7b-08dd4bff9527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WYAvcU4NEfOE0R1Xt3EpKgjOqQ5wr4GbaFCarEiSBQGKs153RqAd3yLiZal6?=
 =?us-ascii?Q?QT5KUASfjEb4MBTz/b5amO09oKgtiGhBDDV05aA91jbcdKEik19LXedJ/e2e?=
 =?us-ascii?Q?JJ28vrW9XddwIr9J2WhrxVUl3qZR5r9lR3fTKZA8wayrxLZE8i/a5ntzvC4N?=
 =?us-ascii?Q?6fXHf97lNSZ6tvDXbrbxoiWJzrlrCVVK1gCoTgvuraUZU7WyU8pv8WNFzvua?=
 =?us-ascii?Q?0JVNhVdFpzK/7EcGypPH17Ja9EKWk87XgO1Z74SuH6E164Z1xkUaJb9i5bun?=
 =?us-ascii?Q?WPvlyPLISKmaOk4QDSNUKkJINIQmKp7UX4Ylk66e0dOwFkvSnXEzW/3r71Vy?=
 =?us-ascii?Q?TGv9xuXgwx//z/NGgsF7HiNvuLwHn99HFiCK0Cw3LVY0w8Zu1EGTeE8HseBl?=
 =?us-ascii?Q?folcqsGEwPpno1qIFUlByPFquUzTbkEjYhPOgHZXiKDu2jLWzH76uwNZrUNP?=
 =?us-ascii?Q?F9xR3NtdyJzflZbi2p2O5BFM8Z5hMpENxewYoURxb4peyNzg1pqGtJl5vfuJ?=
 =?us-ascii?Q?+Jx7C8Mx1C4G/nWIDyGXO0kfA47BhOtEQIRIYR0dEq4RAukq5Iac4asPwyz5?=
 =?us-ascii?Q?k8SFBsU3E/A3MSoSiIfhJ6fXwG9rS1oRuArBQSZ4BpcAW/v21BPQE2Jlk9a+?=
 =?us-ascii?Q?mBV94wDESUrRsW3Jt4yPEfgwcHaGTM/qMx1Mp7Yy/j3PI+muKj8CwahhXBd8?=
 =?us-ascii?Q?8gxyFXR9Tc7rx3Be/Pg9858T4Y50aJyoDr0CezPbiyEhE458dTpXq2xB8LXz?=
 =?us-ascii?Q?WhAQft5zcSZiMNkJanEYR9FCyAiwAl+tYCKCaf/9do54Sed8K76dJRngTqs3?=
 =?us-ascii?Q?oqInG+xl14OgMgav+FCzIxyXPdZRPhnRiZ6UUEB91y0OR+q9ySZmslhNQhTc?=
 =?us-ascii?Q?I8g08wavFGWcAHw+OMFyTzhgqDuBAnON1J6xqoCWPaFDHSuZ6h9uJ6OBOyf9?=
 =?us-ascii?Q?a2l2BN60goJZU3xEOdnQVTgzWTQl/VIqLJONfDyGv9J3P8xM8IcYasci+Uaw?=
 =?us-ascii?Q?z4Ty1DrqjFIvLoYIY7CDMXXASPVeWvcALwAb1YDAG7Cjt6cx/bnw6gmGP/BK?=
 =?us-ascii?Q?io1OyiAvuqMXnGXM0IDFo1s2Leh/VVfJ0QCUfT7Vjv9uuHrJkuV0KPaLbba5?=
 =?us-ascii?Q?y2zMMaS+8AGB1dHi1SvDnw3POuzHAkZ02FBMJkZDKi7dESmzD9ON1mR2zJ4/?=
 =?us-ascii?Q?F3YeAQkcYlBr/plw1vuqj3Nenp9dZRqhF5dY7RxUmVgfEAv55P6ggWsAIwbP?=
 =?us-ascii?Q?OqIDQsd09P+xDstkXxPOBKGY90MKECCUvBlAVlHXsym9/tyerkJxFjpBvm0+?=
 =?us-ascii?Q?xXlHOSkVkjSD8iDrecoM/kKT0JP89ZBoiHB3xZmyNEPf1U36aeRqP9j+zC89?=
 =?us-ascii?Q?U/PjeiQK4Nzm3gcMcw/hPchYoJSp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5423.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oNysO/GrgnsKQSY69EWKmg/CxiOqXN6/L2c8jCt3I/MnHcJldawWaxCwYKQu?=
 =?us-ascii?Q?iLbAc4xVSiQ2YrRXC7ns6rMjpgvYjnBlIwlQUjKpzHuf7EpTiMd2S5XhY1AY?=
 =?us-ascii?Q?7LPdGrvWu2M55Tm20I0Sv4xSezkz2k5XdU8gVjGi2JigMUODyx594EF0kpSn?=
 =?us-ascii?Q?nq6wS+B6+2nVDD/xdhuQrWSBd2+k4gZulc5tQia/9VG4U5hennylblYFILk/?=
 =?us-ascii?Q?he6xFQlGT+jt8h0fDPhF7QVYAtyuayodVfJjd6/WvPrn2qu2VaSkbJ3e1ZAd?=
 =?us-ascii?Q?3QKpMudowpllLl4HDQXOSWe3LeeWz+9jvMp1WqfCHN6BLECQxFgo8NMk+yZH?=
 =?us-ascii?Q?MSwue7Q/IoUq57OTVt0r2Mbu/g3bgzLHkXlF7EI/N6Dtx6q3W+mk2kRwQYjk?=
 =?us-ascii?Q?T1w73NJ0RLUKUdLbnfZ8pNFhr1ToWpd6ApgxQaHCFeqWem86mrpV6MAlfVX/?=
 =?us-ascii?Q?jUydEfnAbU8ohltMbG9flIDnU8eX5bvrW1hzKmIonJG7/NX9S8jcFJvAGX9I?=
 =?us-ascii?Q?eYe8sNNPUUXvpNe2sR/lUVF/UvOBurbSl6rTP7imLK2OXbIV8onpytIfBJ+k?=
 =?us-ascii?Q?uvJUJP2+rRD0FcMJo3jwsf86zZBv8VKQnrcs3hjIz7/Cgxizys7hlkDTqCW0?=
 =?us-ascii?Q?X2QuDihFXG2VYboJmmGTruMLauPNUT07PMXpOfKxPBUkX7wdXJiipNBZYIT5?=
 =?us-ascii?Q?bLeiP/A2pnJKJj9uFJy1CZm+IgxsbNMN917+Lx/i0NMM0md3sjVTDqHtU72l?=
 =?us-ascii?Q?/3AVxiBuX9mngBHhoqy72XK2TuOnqlCLr0GttefJ37s/PxrJGxzZ4D6NDDGp?=
 =?us-ascii?Q?kZ1qslorLxCupie04NgwCiQXHt3yJiMb9OYWNOCmUhJG7fPeyDxezLjkkBzA?=
 =?us-ascii?Q?ZCQ5m7C99iJ/3VzX1/FhfqOGCHrm6wLWbsAWd3q8pPzoRg26A/AT1U/KO0DO?=
 =?us-ascii?Q?HYNbYZ1DenPCEVO7TUFJaN9P1K/7hthycic4F3s+pkGla8Ge2VuS35/HoYh/?=
 =?us-ascii?Q?QjRV6Z6Kni0x2Cz9cAXKC4rvm2AwPTbaiqDYbk7X3FHvQQ/hKb98S74M/Lu4?=
 =?us-ascii?Q?WIXO67aTPd+7S8vG9+RPsrrjutpX4FMqlwesiV9vuhzzZ5Tyo3qLJ9lTkrBd?=
 =?us-ascii?Q?Vagokq17UDgVRVAQK7x141wWh//v/3N5rINQR4wVZR9VLsi19S9Z28lwzqLp?=
 =?us-ascii?Q?tiwmoXHO274Qo+4kqn4CtD5saNjD1yM890//dXIq5iITQteidLPi+fF9Qkmb?=
 =?us-ascii?Q?MoBgw+dZN1E0NvBhim6SeJxtUnptl7YPb1TXGjODaJvEu9v9kOAmZf1R7fPe?=
 =?us-ascii?Q?kVgZW4dXwlQ0Gj3ltR5+zojIN6/3Ep+LT8yQsNPDc82nr0OY78YF6tCUQs6u?=
 =?us-ascii?Q?Ai9pc3J4CL+DGc6uM3YXDaXI6DihNPWlaGlpH365AQSE/lk7W0pEvPsCxpZs?=
 =?us-ascii?Q?92cq/AAdCt7H8M8yG6CwIhsrClsJWe/TpD3R9HybnVc3dArTsb9S2Fwh8Q1T?=
 =?us-ascii?Q?TUFEkJDkpfusLfpGQViJXuzu55DQ/ODKFqFCzsh2ZGJbgg/ZX9dwZGrfZj3p?=
 =?us-ascii?Q?rEDljAkyhqv9EL5qJRFEg+IuHTnLYfDB2dxZRXa6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f364c2ba-3365-4fc8-3d7b-08dd4bff9527
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5423.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 07:25:24.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GP5FNfA0dKPEEG5Vb41PYiLir/A27ypdXbhwqeuXJIFl4x82WtTwNwe6yNoTEIUp16qLfpJU+BhT86lthhW8rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7950
X-OriginatorOrg: intel.com

On Mon, Feb 10, 2025 at 10:37:03AM +0000, Marc Zyngier wrote:
> On Mon, 10 Feb 2025 09:44:02 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Monday 10 Feb 2025 at 09:21:29 (+0000), Marc Zyngier wrote:
> > > On Mon, 10 Feb 2025 01:39:04 +0000,
> > > kernel test robot <lkp@intel.com> wrote:

[...]

> 
> Now queued and pushed out.
> 
> LKP people: please fix the mailing address you are using, as it
> changed over two years ago, and you're still using the old one.

Got it, thanks for reminding this, we will update to use kvmarm@lists.linux.dev.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
