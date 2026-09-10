Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011020.outbound.protection.outlook.com [52.101.57.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386E249E14A;
	Thu, 10 Sep 2026 22:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081058; cv=fail; b=bewmlLVrUw/4wZnHjO4krS6Np/vaYogGJ5wzloEXs4589CY8zHrEy2ZuTYi4MSpOKKzSyXb1XmaausnReNF/8gHteu2oRY2fdGF4yReaLqI+Vmf33gsto3uRBdvkvXBRZbfJiM59E3XbujCAvaXoPJj5uBsF3Kw64ca9sX2Ppt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081058; c=relaxed/simple;
	bh=0ZbClFGgCSL0JRWvHxN5K3htcBHprUnmii+Nb2DrAmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hjRHsBskNI1sZo5GLDVQNrR86pYmvAtbnkwb0B89hYH3UHHuK/LOYIXcnzlSUH0gvwMtgFXRrtHoOLuLT+miGPauYVZ5FYgzLYJ0lroBeU4HXZ4lUV0c2flKU4o5gl3NoaVXaIiqeh8L6cYAPLJdM4CcaL7r/WzaXpnXbjGwVGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oyjwQlTw; arc=fail smtp.client-ip=52.101.57.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oyjwQlTw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQjj39L4OIymJtFEXdkNgxI0nQkcHpiWHcZUTvuTVPN17ZKrKPXbIFG/WvFT3dxXkKgv9nSbW4jRBTGS+NZZbxi+UKL2fY2qM6GknC/Cd21scJoGi6REb6uLyuvQPPYx510fRjjX9vBUfm8PGDoG8z/CiVqC6pYVo03jGndUCRVWjkxtfpzlK1q4uoI8qWdFSzebqX8sNz9+hZIJRJdMEMEUZRsbGx3aUBB3TB+PHpkqvXxdI18EF+WDx8plAYLGG1B8hTkjrzLh/UzqdYnHQRHnrOuKjWUlDmCS0J+cMtw8SbpB3luJfwwz6GJzXKLMIvIASYkoO7pxezpU99oCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ag53OsvdHGBUIgQF6RYGdy69fiQDTevZ1Y5ABCjO8N8=;
 b=EBemnTOgD/yaoe/Uzb59KN23nGkJf9/vxz+q/2T5Cx1sGcgzfNTqhFx7JIUe4EBf6nmk+K3A45AUMaOcJSYsuwAyXnvqDZaGKIE0LLrSVxmJYn1EIPwNxdp8fk77/gZ7neWRGUlqhngspeV89m5ztNZ+hxtBb3qGXbcik4shNwFaV4RB82+4HoxRxBJ8IkPDtmVUJ00Or8IvH2QeBJUEUEt9j6LXAzz2/xdmhLBsNxMAZyNKJ06147usRwUYR8M5ISr445NL0q19udIsfEuZD+reRlGw1nl8nMAHvrBMR1GAjiz4vHHc2YzKLIGQBOKmXBFa1q0CJiHVC036FsM6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag53OsvdHGBUIgQF6RYGdy69fiQDTevZ1Y5ABCjO8N8=;
 b=oyjwQlTwUYrjKykJRsKa8sqhPd+EXg8rm16AloxZ+BPzbwqE9KLWm1u9ZIbGzMImqeTIQNoi+wEPPGJuwIE1BqlGC9U/xCtaGV68YnfJm3N1eslRHmfn+G/LGJqa9jF3q2n7kB6MqQhE47B4iPYVhYsvv2rxHAOfDWYCLRttCWbo4pJwXMJN+8yR6r5eB+1dHJVaNoLU1HsKSDjHLLpRVXC+jGty0KOfQaPkJJIgu7z3dvcU0eY/pXmnRxqOYxZANAq0fTt/qP+jZVLWcMDRNhlR0Gh4zm3o9Iyh1q9t0ZmDr1w2m24MRbiVeRK5zf1TQfDPBQHBnJkBJ5g/3CismA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB7912.namprd12.prod.outlook.com
 (2603:10b6:806:341::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 22:57:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 22:57:29 +0000
Date: Thu, 10 Sep 2026 19:57:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, kevin.tian@intel.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <20260910225728.GB857650@nvidia.com>
References: <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
 <aqMgjXfTJ8u3n7Kj@google.com>
 <20260910221832.GH3968357@nvidia.com>
 <aqMyXE-fD-UN6w5L@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqMyXE-fD-UN6w5L@google.com>
X-ClientProxiedBy: YT4P288CA0049.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::6) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB7912:EE_
X-MS-Office365-Filtering-Correlation-Id: ce92fa94-ed34-4200-3035-08df0f8ee425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|10067099003|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	QA5RbieWk9Ug+h6zWar2Mc7zFSemvkKfp7HRhyfGIrPhb9Swufb/L5VxDNe9UnBlPG7C4zaO7N77kov1G2MXp/BQD0gB8YM6lERETqN5AmHywB/xQiXIF0DI8rxKyxziXW3cLYQRJjPZJcByoxMI82d+LUmb98IuWR7pJH6CZhK6ccah6go2otxB4In2Nm6QmaOQloA5TU0VNW1G9yGJdH9SyHSrogOIABj2ReLMnRzdBj3an4ef5YruBjK0WCWaG26hFOOsjFZXknmQCT/pdCI+WU0WndryKHq1tnmAoAHy+BBADwReJdop24LlNvCwInWA2ofHd92waGuXSMfLyxxHiLl0AkQevAyPusMYOwF67/DIWdiI3Cda3RzSwRjzyZCimuI1f7StdHHVXtZcziB68D8c6SwSJpFC9qHpusn4mFjRFEH9unYStnmPXhpzZxEGcFUAd4X9a9abKN1sffNMILcICPATwYB1eCXmmzfHlk78izHDM2grnaRWeyt710IuGJrQTL8YPwmEn4hFwI97J3+LTqAomlP1cLd+A1pyEc4cWO3kRhJPoqQW1Xw2f0b9fh97PmW3+Qy9qsZ+sT3ShqUNNoAWfPiB0+8gEcRcwG1MqNtjTl/8vuqehDFgILU3qds9xCdYcviy2yWZKQ6xsSFwjTJGoWUTowkf/KY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xKifFiTJRwDydIcyBACTq2CVlVVavCLWXlYEMG5cDpfXg+uZLvtv8DgCFQyu?=
 =?us-ascii?Q?stwFGtikYizqj53H+XhXC5iby3knbe0TPa+XDnrC0qhY78BxXLQGbHjGU88l?=
 =?us-ascii?Q?lnM/R/ICjDBginJNOm1YcIk8uOGGvGz88oj8EkuMGlhAicMc83dZcVzfVYLa?=
 =?us-ascii?Q?RkTJgp25VXB7bg08TbQnYGc5QlKh/LkhUs+8Jto2EynWM7dNY9ksvPi1aVey?=
 =?us-ascii?Q?PV81xV4MAPCZRa64EXIe/unhXQ8u6/SVbjLP+b9OtFprOWofRlDK8jBTfnaq?=
 =?us-ascii?Q?1syBxj9RRhp5suR3SnBKFKw0Mhx2zB3m6HyCVAD5t+aE62gbbxE25ytDI7AJ?=
 =?us-ascii?Q?1QC5Y2Dao7z/hqJZmSePELPCel3w5lU7p5X/OMfUERxSRHWh+USZZE3xJGKb?=
 =?us-ascii?Q?U/hxlmfmrUOegjaIZCDy0R/a3Yseg+SxFBNXN9LGekVGqjwBkSSCbOQ3hAFU?=
 =?us-ascii?Q?GWjYPWkxNbjbV9raHxQmd9gN8bdPZ8xy+EKjDQCjIW2APjiRMzHQMkW+eGUW?=
 =?us-ascii?Q?WF09yhOEhxlQvLhASHwwRoshyQjaahWBCANyG6lloaLcb15LPFaRchKOTSrC?=
 =?us-ascii?Q?rSSrjs2D4d0TMyue2IxDiHbq2XL+E5pd5HQ//MMehfQvf6dhli/EhomZkwwH?=
 =?us-ascii?Q?Q3kWh8oXj7uEraVAIZDVLiZD2znKam2r5E63t/xpAIqtmTNuP86ITWjUUR8J?=
 =?us-ascii?Q?TAECWin57jZHBw/a1+dxddv9NNOoxebQVk3Zorfk58XPjqH6QOEbLaqra1Jw?=
 =?us-ascii?Q?rgO0PuxSM1w28zFiMjt3RHDXZyCYwBKQYyVKNar2V5HYzBq2vOMbWUd0f/Yc?=
 =?us-ascii?Q?rc18xxd8T88hpL9I6rEx0m2SXeU74uJB4COS0fij4qPS2yZAyH2zJpaPGmtM?=
 =?us-ascii?Q?YdMFLVauX9fjhHbKiKzC/E68pWrbUIw49vzYUqzJCq4MuW0aPna3+1YEiw/n?=
 =?us-ascii?Q?JteQMFsTi2pJkl6rsTVnSjEcpx+3IfNuHw7x4DxlHTlAEbdydD3Zrr1mCnRO?=
 =?us-ascii?Q?YH1wXAJIXO2Csvzg3TtcFZeuQozbcXeo/V0ePGwjr4SQZlpaRA4DfN4XyHyt?=
 =?us-ascii?Q?EryXaStlowlthfZWrcM2ydc6Zh+5hoWspUQSxu+4TWj4gtQNAMOfVzVHvL0t?=
 =?us-ascii?Q?H+qqelTGH30cYyDW893uGtKr+futVavzQwhPpsc1EPlrkz1z/ny3zdsgZVfP?=
 =?us-ascii?Q?NZEaqz5PUeRARySqOQ0v3BZBEFlyL1LaVO+CZuiUDFH/7Ip+1E/KIBPJyONh?=
 =?us-ascii?Q?Azj2MUr1ykkUO7JVnLsbYOg78IkBquukFrHiWmZlZMwAxcsxoyVacwUq48nY?=
 =?us-ascii?Q?1Jf13ana/1AXX5Gg1mfS5aVrMkiY7ATcWRtMskN49LeVoKP2k4ROAlnr5JWn?=
 =?us-ascii?Q?CG3zbuVf2/w6kmOM280wgBUrsrbtWUi+jhXa44qFcuhW8zWpRodZI3s2BIOs?=
 =?us-ascii?Q?tCGXF0B7zQ5QzZGD2t6WNhI0ymASqCz9SdThPoayyj5WzPualijIG7pmyVya?=
 =?us-ascii?Q?HcQxHlwmtxGLDj6pwCifqQeaOeypzf+hs7CqnNdV4QgHf1B1J/wG7KoeMg5t?=
 =?us-ascii?Q?nb8JVFrdsxTSC+6Smf+WxcROG+JD3vNRvTApd344LzsztgVQDtlBqqeBjPfe?=
 =?us-ascii?Q?uv6wZSgV9nPnTJuX2ck5JqtZNCQLfJ+o5WuEdkm74iXgHzODji/76f6MYfzk?=
 =?us-ascii?Q?yQXq6MzWFenULbiHkrhioxId20iiE9v1e6HnSwdOKyQx2lVB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce92fa94-ed34-4200-3035-08df0f8ee425
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 22:57:29.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUtyDIBMFosI+6EJYNaCdR9Y6eTdR2zGFy6vAHrPkLLhm+Ol8YVTdvcRoaSmMQJb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7912

On Thu, Sep 10, 2026 at 03:42:36PM -0700, Sean Christopherson wrote:
> On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > Sean's initial email was asking for strict never-break ABI compatability
> > rules on top, and that is what I've been reacting to.
> 
> No, I was never asking for that.  I think we just have a different interpretation
> of ABI, or rather are talking about different pieces of ABI.
> 
> I am still asking for never-break serialization format compatibility, i.e. the
> more literal save/restore ABI.  I'm not asking for full backwards/forwards
> compatibility across all kernels version, i.e. the higher level "kernel" ABI.
> 
> To phrase things differently: I am a-ok if kernels are inherently incompatible
> because they fundamentally operate differently and/or support different features.
> I am not ok if we end up with incompatible kernels because the save/restore
> interfaces and payloads are poorly designed, lack abstraction, etc.  

I can more agree with this, it is mostly what I thought we'd end up
doing anyhow with version numbers and growing the structs not
replacing them.

So you still end up with a version label (string I guess?) because we
can break it from time to time, just the version should have the
feature mechanism layered under it? I'm fine with that

Jason
