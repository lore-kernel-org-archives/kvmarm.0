Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023085.outbound.protection.outlook.com [40.93.196.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFB82F619D
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 13:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123721; cv=fail; b=QYJmru7caAZpPvWcxN0zzu8GjbqvrsPYJMOuFqBH8lO9kmDX3TNI4UxkrGtXvZIrENhtEO6L19YlsOtn9bmDDxgfm4T6WIKQiTC6cJJ/cz2+u9J/5P+WoGCPUdptrCmWzZe5v0Tm+V4d+2dU/zYd/Xp0DcT1U+kvGWdZn36/CTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123721; c=relaxed/simple;
	bh=YF9LBUCx1FLsvxFG1Rx2tJwuuVBcGhwtNZshZqzn+h0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=YuJKlBc6BYnyXy7cvFiFKZF16T9akthqVne7shvbs9si2d3j0UVhb9exjvI1+OICtzfKfA52ck6BLmBHTPJPuCOMmGRgJbOH8LyR6WJHT8tL5OIVWiMqvHbc2+dJpHzbjLC37xSP6+LI3lqqHWjMYPvatHFSUf3cJ0n0EmmQNq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=L266C5rd; arc=fail smtp.client-ip=40.93.196.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="L266C5rd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xwWdQAd13oB66ag0nT67Xa9gzT+GpDKfcHOqM2clr8APf1HChT5l6LZ1jq2d87L+L7JvnOA6gden2tVukZEikbcDpKWG8YsUObHv3E4EObaO5zVru3quFmjq+qNenJIFsU9Bh5nwr9SEKeqLxAjcOjLyVnqQCkabQxUjzxF6eRc7sc8si1Yvy5B4kdCP6A57/jIw7yOstYJdpWCViCWXTvop2VDG1jjxSozIKPL2WGwUplIOKM8qAwS7IS2cKZstOlzMppcCbmWun8Kw3lUeAKbGxLyvE8On9Nc4z3HRV+aWIKqvVSZPdPmmRcjcmw9ksMIfnb1sRS2mocE8q7Bu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0lavJMDRzh03hmhWzKL3UsDeEWGNzJ/rNkAa57IFNM=;
 b=MlK33UIWl2UKQEN/pK4a//3jCEn2LlAibc8wXMtj0EPnnMFfMAaCj+3+Rw3TpmGIomSrlRFbFkuLZg4MWIX1ThaJ5ReQLd4DNW/k93QH9swy4sfN600OcrCCf4MpPucLt3jJOE6dv+W2cxVdjeEonrBDXyn/0wp1BPa0R6hbvNhaJ1MoVkzMHcXUUMmT7xe5w+UF3bBSul3EPl3djBTAw3yoOd0LFvPSmfH6eoPg2bDL2fO1xdU9aks5F91CwuPYNtbo92/tSEeJ3mX0pY2BCOlL3HSAMjULwzpQk/Sjzoi2wcFXdxUfYlpp3b6QfF83cT1jROZqeYtELFnmgBshoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0lavJMDRzh03hmhWzKL3UsDeEWGNzJ/rNkAa57IFNM=;
 b=L266C5rd7OMNF67rwcuOab7Gq10OoCw7pqw7/5V+lmhU5HrXuaWvaxPZhupHaSW5vXeLcxzGwneh/jLQ5o1xzounRpaWN07s7myVAuXcwReFNa1or/+z5tq6c4AMxY/fMEDgJZrwHFm4Wv3wakAwTP8mt+LetAqMa3kyZ4Gl/Tg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 MW4PR01MB6290.prod.exchangelabs.com (2603:10b6:303:70::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Wed, 15 Jul 2026 13:55:13 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::3ee4:7b7c:ee84:7c1a]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::3ee4:7b7c:ee84:7c1a%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 13:55:12 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Joey Gouly
 <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Mark
 Rutland <mark.rutland@arm.com>, Zeng Heng <zengheng4@huawei.com>, Wei Xu
 <xuwei5@hisilicon.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Lucas
 Wei <lucaswei@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Sascha Bischoff
 <Sascha.Bischoff@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, Yeoreum
 Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: errata: Mitigate AmpereOne erratum AC03_CPU_57
 and AC04_CPU_29
In-Reply-To: <86a4rso2qs.wl-maz@kernel.org>
References: <20260710222128.416581-1-scott@os.amperecomputing.com>
 <87mrvy5640.wl-maz@kernel.org>
 <86jyqx189z.fsf@scott-ph-mail.amperecomputing.com>
 <86a4rso2qs.wl-maz@kernel.org>
Date: Wed, 15 Jul 2026 06:55:08 -0700
Message-ID: <86h5m01hoj.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:303:86::23) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|MW4PR01MB6290:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f4ef272-7d89-49cf-d5ba-08dee278b0d9
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|55112099003|18002099003|22082099003|10067099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	P9wOz9yblJ9a/DbN+eYwgzCrTeh/QmF6MbSl0ZW+ZtA2Z1pwwf+qAlyRcirlIdE6XWZmUzKYpOam6wIKGDbInUxSlp6r7qJotsFFL9y3nD+qLMC4QTPIrCnW0RJ2sKfsPn85/6CsmD3qPso34pd1Tr2ZvPz9+NXS8WhiSc2W4br45jBeiw+OxE6/2jmEYIu+TLtxR/Ucw6FVr/OMyKdb7/C72kJ6CAsjxgbudpeLblDLDsT+WRJuRdCWeC4IgaAMvf8ar6BXEz9FaQMccsY/CCAjP/AUdhm6L/+3+08P5L/xm2fr3oQ7GPe6Vi+7GsifNUB7T02a99xau5uUTFaqaaJZ/eh+j3ejJ49LK9eydYiux4dydgSDGlwpeukTTBjUZA9pT9owpEbeTKzFhUfHpT/c7S0XFOO8lCvYsh+pxE128B6MhzHhjKgYmaVxLtpNTd5nqmPPG1+OJP4o5oURlzRZXKDlMAe30kiOAr2Z3ETffotw+tibsYrvzDMXB7rRmjl+i4zJN91XAosNCvuze4UB+154rHDGSkevYFkF3c820NCAL8ScQFAo+OgbmyYDKdU7FSGFAEuFS7AejkOBMTdatfOWcyO61ryKYbDZQ9SkSwQsHl2/j2vvJqcczzojPSiDvYDHMVgtKGjsNoqKUmmpfxnzW75KQl3fe6Q0WjY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(55112099003)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IrsuWdWrIy64EXcSEc12HFyMrbhMokKftPIIq8SoVzlN+kwg0qbeNkrioKR3?=
 =?us-ascii?Q?p8rwzXBBOfTIezSbK9xpLFzNOkJ8ZCP7eY7XFGwm37qNbmNOg9vCtpCe1wrn?=
 =?us-ascii?Q?f+yDolVMnHxXki9ut8lYloevHHvvC/o6qq+2gdhUEv4lldcOwG7eYzIzOJyh?=
 =?us-ascii?Q?DcY9IkZT+CFBQTetzs/PDC07VTuGTUdI3TwYYqWeSCRwLifdgLrb3mADiuX+?=
 =?us-ascii?Q?n+UJOprGrNBwGlgqspfGfcElD0LHmAlCag++zUniJEtslDpQYgOQf1E+2L5H?=
 =?us-ascii?Q?PqzoCPUDxZ7mlucTXlyNmhgtERdcRvicEsairB/H7HoK8IlvLoZ228ZJjO25?=
 =?us-ascii?Q?exW37CIh8rVOX3VCKoaTAgOvo8eTistinttFVWXw/SD4B+4oEK6PTEd6V4Bf?=
 =?us-ascii?Q?gahEtpUVM3vIjIgNHWPGe4Om3u0E0076wRrsOUNGzxcjrnietJfhqXQwKjGZ?=
 =?us-ascii?Q?RstAWaov+HOkQ6X3KwOrYU27k6W0U5cjsuc6kmeZJ6RzEdZyzG6RRLiktBfj?=
 =?us-ascii?Q?fUCDlvT13cRASDIwGFLxxWs6C5e1NK09zI6YqsK4IRTCNcrrusLHLmpfJL5k?=
 =?us-ascii?Q?a7b/vOKtm5Gn749UxqVkSRFYVMlgi5O/3zFgkN6YoykK9iBPmg98g5B4/7S6?=
 =?us-ascii?Q?RLnKYhlp+v34Oj+BR8JhtD/x5AwkXLKVYBNi1TYvrvZBdJK3B9l7/kppWC6f?=
 =?us-ascii?Q?+dhgmA48TlZ/Zu1KAc/cfvQ43JaSg0MMXRscVzub+yROEEGR6uiYhB1wYQSW?=
 =?us-ascii?Q?V0+LZQpPKr0Bpc5I6bhSd+/5VDg0ukU21e0AO+Dc0ONPOBk9uFoKl5UtfxN7?=
 =?us-ascii?Q?oq2Uaqeme5YI/KJGBvGM96tBquYCKC3Qlivnkk7N4ll6kXDq2fKie/tETGxg?=
 =?us-ascii?Q?og45uunj/aDJPBl3NyK74ZW8Kt13nnCp3ZyiAxlH6Zn33MXgbnVSejVF8Hv0?=
 =?us-ascii?Q?FhylqmrbtujT66XE53gIWNqC/4XJkFfJbKNWHRkqCfHDgkW+qpLr4TYxiH8R?=
 =?us-ascii?Q?VbDNULBtRytJ/HDwmDycEA/hRg2qUrtgOoJTUOvWwzsUCsPmQE/0vzRNwVuF?=
 =?us-ascii?Q?h8dP0zzmUt0P5X7kf8XRv7Ftzt/acj5H0LneofTFnstCt0I3RqoM5ulOLrmq?=
 =?us-ascii?Q?DtXIyQVwYwLsBLWzIkAnq5wKY1R3x6ri3EE7Y1Ibmi9i1p0JQp7RdarwInKD?=
 =?us-ascii?Q?67Ef2GcSVId5JQwWI9+9OUSeVRQ9EAlDVUaTTeLMa/KTUwfO0Eoat8Kaq7M9?=
 =?us-ascii?Q?dsNqLrPfN5Do8fkuSgiE79L0x5+6YWMrLxnSETwvK0Xw+QIj2P82E5kX8r6+?=
 =?us-ascii?Q?w6YZW9subZTcY5j5DmHbZt4HWja4l2RmR3hxvdT8c7FyHiPkeLTHdxBN4clC?=
 =?us-ascii?Q?aMGhcfLYXQLY7xlh5X4hWAysZFbE0SRdn12cFDioBC4OIpJ5MyEPU3xN1XWA?=
 =?us-ascii?Q?xyvo1KzoyCNbcudQbmloJXzrsbQjGJMtr+xiFdzDY4urdab5Dqd1uCaysU16?=
 =?us-ascii?Q?3iTe24BN3f+8sreMc5XL76xlDATB7HdlnaDOFu/9UeJbgRbMr36gjDlUFURx?=
 =?us-ascii?Q?zXKzdR1pFglcNSBm/ijmfjtcMm1yLpylO0WBEDgqWpRevBN/9Cx/6BOTF41R?=
 =?us-ascii?Q?zgwErPvSx8lqhpewi/foV3abPN161d8ZJdifkHoqggmhdID/bYSq1oD2R6yC?=
 =?us-ascii?Q?yc4uxvewmu4iLGSwvJjTeJTc4qYTJFN8RtQ4HaqoCnicP/xcdei5bSGdfUaA?=
 =?us-ascii?Q?88iJo5VWmQtKDHFwCNYNFhUk3VU7f3g=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4ef272-7d89-49cf-d5ba-08dee278b0d9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 13:55:12.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBO7ei6ljzHkRK0xjyCxWbngRJHC1OQKObfj5GcVGauOxf2GRJRmMyICKQ44m1TulfAJYRFIuUzZG+xbr0bsVwOo6clWXTnWteENj+O7n2m5JiKCtxVZqPdyyv8fvWnb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6290

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 15 Jul 2026 00:06:00 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> > OK, that's pretty good news. Can I safely assume that your HW doesn't
>> > support VLPIs/VSGIs in any form (no GICv4+)?
>> 
>> AmpereOne AC04 does have gicv4.1 with vlpis/vsgis. Those take a
>> different enough path in the core that a deactivation of a pending
>> vlpi/vsgi won't cause the issue. The wording about "physical interrupt"
>> is meant to exclude vlpis/vsgis, sorry that it didn't come out clearly.
>
> Given that the write-up didn't mention direct injection at all, it
> wasn't totally obvious whether this was taken into account or not.
> Might be worth adding to the errata document for clarity.

Yep, makes sense. I'll work on getting that clarification added.
