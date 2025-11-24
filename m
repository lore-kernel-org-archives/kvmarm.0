Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021114.outbound.protection.outlook.com [40.107.208.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0EE238C1B
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 11:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763982218; cv=fail; b=gCotPkUprQxW5BbvwZvTjH0+NmBqW8M/qUupxMBRChdJHmOSzm9puu9y39pJ4w1CpTR4c+yqMbhHLdigJZVAln36HbdoGLeTHVZy7hn76Gx6L+yLrIIRhK7+o7KCqd8yLXWFA/Q5cdxEdguwIKXiPRC+DXl+clAhZI1Oif/ulPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763982218; c=relaxed/simple;
	bh=OA0jvRD2OFU1CCVXe8tCDBjbfVsMaRlKLa/8dMTyBCI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MJt8stdX3l6jwFavvcRbHuADgU21iqn6cYolYk+Qz+vFQtFSzQvRy1ilwm2FrL0+5ImoX56WeTF7RhweDYIqv3fzOhs2S+FWqz+YFAsLuwSQ9YidxqEIZNiR0Y8tK2cpqrB+hzFhIRSUMlOKSzZb6o7N1hPT9ST0UD6LfPJLckc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=vI3kYEmE; arc=fail smtp.client-ip=40.107.208.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="vI3kYEmE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3UTrZLegiCodAcjl1OjX+us0Uw325QnBqUvfBImxpt8J/NDJkss11ezyojSQUt0c+zCihGx8/bgiOZlGf3quTLDpV8N2LKpzfWz783PIsh1RueV/jaXK7n4X0/cT9G+0G9SacXWM0NqxUS/VNcCDvT6qihQQ/M2gmABRtvb1zYrF+lU+yeTSydh3R3eE0oVTxc6o+3k4Rf+KXiKb8hsjUUZTO3NDzr9D8LpxeEFFch1TmSJfNmoa/0bCU+vUZ/8erAi6aOS20XyQmoIo2XH9kLG609jY78LEoi3lqzTpwWCIAisrdB/vEaxsh4N51bM0+7tNZhZUKdBeE1/f7+f2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFfPjhX46TQIK0nP18xRYa1vlJ+znPsQGHTVO2ttvOg=;
 b=RmlAyifD5LwluLYdi0fPJgIGKsG3isl4SU6luBjbHhV/eM6BUFwa4CT3v4mOg9+UQLtnvClRBRjNjX8u0uUv9zGcXdcjVWSpdicvzCotNBq2FqyKgGlE6WNr7LLjUloqmfkD2BBONEo1HSRl94WpXrXk08so/Va7ORYFLUwg4jWfp8A+ftmBbaPRI0euBQOSdjSNkTNeMxT8FYuz+FX8upfyrvXUNLuAqFSbG21BsHirnyQwfMv7fX3vw8md9QVjvn/DwMKD/2BwEJ4glH7qwi80TFjIXlWUqE6oxUPjJiByoncnZPmGv/HA6nElmB6kWGbr9VzHwESbfnCp5r9yEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFfPjhX46TQIK0nP18xRYa1vlJ+znPsQGHTVO2ttvOg=;
 b=vI3kYEmEdhM8jP2dcx/IyipDdogtnV0eoAbE9oJ32VjaVeW0vJE+S8qtIfg97p8CgsOTgjggykklofWy4X6+lO9A9OwtqzmgZPGJji9CNOZc0COE16aY1W5ZyiBN6npInjC8BGTeaNniu6oheN4f4iZnUSS1uoufywmLzCimE0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA6PR01MB8853.prod.exchangelabs.com (2603:10b6:806:42b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Mon, 24 Nov 2025 11:03:31 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 11:03:31 +0000
Message-ID: <8c5c236c-8753-4738-96ce-e51c9465eeb3@os.amperecomputing.com>
Date: Mon, 24 Nov 2025 16:33:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU
 tables
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, will@kernel.org,
 catalin.marinas@arm.com, suzuki.poulose@arm.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com, cl@gentwo.org,
 scott@os.amperecomputing.com, gklkml16@gmail.com
References: <20251013065125.767779-1-gankulkarni@os.amperecomputing.com>
 <0345c510-5db4-462f-95fb-591e71468aca@os.amperecomputing.com>
 <87v7k53cud.wl-maz@kernel.org>
 <060fe820-85b8-4476-be95-a0d37e53fa12@os.amperecomputing.com>
 <86wm4fus4n.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86wm4fus4n.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:178::8) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA6PR01MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a5fb640-3adc-484e-7783-08de2b491a8a
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2tqTmRGQW9EV0xUUTNPcHRka2tOMkVJSGY1UGVXWXdYWHpDRmFoUG1Mb2du?=
 =?utf-8?B?MmI5T2FPaVhxMWpsRHBvMFVNOGRpQllDRWFGejRXUlNVQ0dORDJuR1UvSVRK?=
 =?utf-8?B?WFR5Qm9MeGR1ejJFYVRFb0UzWEVOVEpZMTFlbzVlQURoS2dleFdRWGNTT3pl?=
 =?utf-8?B?b0djZmxWMHpSOWhTVHQ3a2tSRHVUSFRKZkZpNnZnanIzUklWYUtUTHJTaW5K?=
 =?utf-8?B?Qk01aWlUUmJhMTM2K3BEK2lxZjhjWW4xcGhLRGtGMjdGSTBWaE5zOWFVN3U2?=
 =?utf-8?B?ZjJ6dUFoOWxMZmc5RGIwcm1qcVBpUmdxaGRTZjRpSEQvc1hoMnNVR3R6Q21U?=
 =?utf-8?B?NElCR3R0WGE5aVN4WjRhZko1THpXN3FRc3BSaHc4OHFMeHRDQ0kwZ3dpK1po?=
 =?utf-8?B?S0F1bkpqMkRSRzN1V1RwK3h3cWJXWFRvZzRJT3dNZzh1N2xFWFJDWDEvQVg2?=
 =?utf-8?B?T01weGlJcjY1U2Z6dmE1M0ludklHck5XUmZORStJNGNraGVVa09HZW5JNzBC?=
 =?utf-8?B?TGNlUmRJY255bGpEbUZvNHpySGJ5SklOYlNlVHU0Z2VFVVdzdmlKQmRwMVRx?=
 =?utf-8?B?Yk5ieXRRSmRLbDlETFlSa2puSHE1RmxGUE5IRm1VUkI0QU9uNGJYYUtuZXZl?=
 =?utf-8?B?OFptQ1NaeGhMaXp5MjFEUDJQLzNzZU9ZUmRad0NSRDhLYXppekJBVU9ZMjB1?=
 =?utf-8?B?Z0ZIUGY1aitWUG1jb1lhQmVIZE9iVnp3UlFrZGtIRkpJTklGcG5LUVh5d3Bk?=
 =?utf-8?B?VEtnVkNwNjNtRFI1Y0pKN3E1VjNDbUxsSEpERTQ0R3VIOTRBQUcrSG5Iejlk?=
 =?utf-8?B?VVFUNElRczRRc3FkTmloQ29lSDJHU2FvVDdmb3JnTExPOWxvKzV5bnNzQUJa?=
 =?utf-8?B?MkQySjRVTEYwNjA1K3hFeENLNUU3Qjl3ZHRHdUZ4T29WcldJSnEveENneFUz?=
 =?utf-8?B?UERiQ3ZUeEFHY3dQZWN6T293TWlITFl2RHlQL2IrVlV0akQzQloweGNoeHFk?=
 =?utf-8?B?dE1QczNyS1BCRVpyOTVObzcrQnRVa0VFcFo2Tm85NU5pOWFNTEJmazlsNTR4?=
 =?utf-8?B?RnhYODZjcmRncC8vcjdBR2xJTEVwa01hcnd2L0VobXZ2OGVCTHlCTTRleG5Q?=
 =?utf-8?B?dUl3ZHY5ZGMrZWVtWVY2ZWtvZ3NtZjV4MEYyc0pNRmNtZ0Roa3EvaTA2Rkdy?=
 =?utf-8?B?WElwQTNVU0N4ZUx2SWprWDY3cG5Qa2pjQWVVaUxnU3c0OHhtSTZpZS9xN2pC?=
 =?utf-8?B?VEl0aE54elFJdlRmb0xmdDIvUG93Y242VmVBcGZtMFZ2Z3lnZWlyMGswR2xM?=
 =?utf-8?B?dWRhZ2x3dXNzWVZBLyt6ajN0aC91TGFQZ21BOEFnZGRPWGdYMlhNcXd3TXRn?=
 =?utf-8?B?TTBqVTFzbU0yRmZna2JPRmJzUCsrVWlYUGJkbk5qS3o2dFRLUFJVeTZGN3k1?=
 =?utf-8?B?aTZ3RGcrMkUwME1sVStlaDFGYXk0aU5kM0VPQnlrZzVEWkZjcjZrOTFPbTVF?=
 =?utf-8?B?cGo0VEwvNHZGdCtpZXVOSklLanI5NkxndFhreDdzK2xkVzJURmVDV3lRdEdm?=
 =?utf-8?B?VnB3TlQ2RnliNjdzVHBGdkZtMTRDVGFkT0NkLzJxbU42VlRKd3JPNGZDb002?=
 =?utf-8?B?M09HSE80VUVYbzE4ZjVRSlNIZXVqS0pnaHpNS21yd0lkcDBQVXp3TnNicUpl?=
 =?utf-8?B?N2RxMytqMmJkOXBpMktiRE9JMlJsR3IrTHZQWnBXOTFheXdsWC8zZ2d2THY1?=
 =?utf-8?B?R0NFZ0pYMG9teVd3RHZQVUZSUmpYeTBSN2JQVzg1dDVxMHFYRFdJQ0lhZi9p?=
 =?utf-8?B?aDBZRzROaWtvcTFpMjFnMHloNW9Tdm94Zms0WkExQ1RBNVFCNFl3ZjZIcGhX?=
 =?utf-8?B?NEZKSnhnbDlCMG91d29NdHpWLzdHQUFaUVhSVlRiSjBlREZzcjR0cmpnS0RL?=
 =?utf-8?B?WndEVHlSZlY4VW0xUTlsN1VYbHoybHlINmtDY2E4Z21MV2JuUzFPOW5rK2FW?=
 =?utf-8?B?eWhqbUlSWTh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkIra1JIZ3NIQkszWVFPUUEyVFdtU3FiMEZGbWtlVkNleTduZUk4WDNCUnlq?=
 =?utf-8?B?TVNyZXdoajBMc1F0WHR6Q3NrQ1FyUCt1Y1owYmxJdXAyK2EvZ3I2OE10TFpC?=
 =?utf-8?B?M1BqdURKZENkaXBkc1VjbzF0TUdnOGhaRmNVbDhiRzdMZUlnNzlSbGprR0U2?=
 =?utf-8?B?Q252TjFGeDNybitLc3Q2UUFIVlNZYy9xelprTXgvd3BGcmNNckFtN29WdUkw?=
 =?utf-8?B?bWQ5NkZ4RTlMM1ZPWWNoalVLek9QaXBOVXl2ZFEzZVIvYUV4R2lhN21EM1ph?=
 =?utf-8?B?UVNOODc4S1pIN0JrL2J2eDd4VzZrT29hNExxdE5oTUhKcndadCtNNUZaYXpk?=
 =?utf-8?B?NmNxK25kTkU0YUpVdC94blJHa2dLTWF2U1lQMkZFbElObTBobVlLby93cWI0?=
 =?utf-8?B?SEwvRXRKV2tQSXcxTjBWQlIxQzFUSmhUZXNwbnJhTWtKQlJFVm1xbllaTi8x?=
 =?utf-8?B?K0REQzJZUFdaREo3Nm9hY054U21PWnFiOXFic0l5cUZKTVNzSWhRaTU3V25S?=
 =?utf-8?B?Q1ZIaDhKOGRhREt6SERZVWkvUVlEcERrd1QxNmRodlEzMlpuOXZMOU54Szhy?=
 =?utf-8?B?OW9UUC91UzR0VzViTDBPWEd4UzlLMlBPR3pQbkhlOEFUT1JoZWpEN1JFR0dR?=
 =?utf-8?B?V1g4eDJMNzN6aktnbi9vTWxMT3VyZkxUcDZXZHlvdE1UbFI3WUtyZTVyWTlQ?=
 =?utf-8?B?Vnp2VzBscXl4cHhhZTIyc0xNNkRwVTkvUnZ2NUZuOGI1b3JjbjdpbWhCNWJy?=
 =?utf-8?B?WXhjSS85MC9NbFNJa2lrY1JZay9mZGV5WG1VVSsyZWNaVCtMNFpIMTVVYXov?=
 =?utf-8?B?RVlvZUQyaTMvTnpCS2xYVTkveFI0RHR2bmdDWmZlMWdZaHBCNHdIc0ZpTDli?=
 =?utf-8?B?U2VwbkxqWUd2cVBtRDNQOW1XMFlqRHJnblJkbVN6aFg2VnJFcEo1K2tvKzZK?=
 =?utf-8?B?TzVFK3pCRnRDR2cvYWwySWk3L2tHTTBrTEdIVlF1dUNaK0xLdTNWMkFGTVps?=
 =?utf-8?B?dWpsRnFZa29xbUYrMUMxc1VoMC9VWC96SmpJbHN0dWkrd0tSYmV1ekJHUVpm?=
 =?utf-8?B?Q1kvK2s0Q3JLbGFpSEdkU0w2TXl5RmgwellxOFIwT2xweWdLaXhDazY5am42?=
 =?utf-8?B?VytadURnY3U0Q0NOclFZdmRvTCtzY2NaTmVCN3g5OUNrNFhyRy9ZcXd3aFVD?=
 =?utf-8?B?RFFZbjJkY1ErTXJQem1uRElXdGlYc0tWc1hJOFpacyt1VzdNM2NLa2c5eVE5?=
 =?utf-8?B?dVlwei93TFhIWVZIS1dXZituRzlWVDZRT2FEc1JqZFlMUmQ3R3ZFRElkRE5Z?=
 =?utf-8?B?Njd4aU4wcmNjRThtSmgyNmg4c3Z3aldseU5PNk5pRmFuZ0Z6b2dxSy9hazBV?=
 =?utf-8?B?YmVQcUdHRnZVOE13MVZTWWFVUDZSdEdJUmxSNXh4MU1TTXFTY2NmcHZGMk5X?=
 =?utf-8?B?TUw2K1lBcGRRajVwbE85dTl5OGVhTDZ1NG92TGR3WUNkNVBSY3lKdzZSSE1K?=
 =?utf-8?B?cG1KenpNUm5XSGZlUTNLTnNGRE0rZ0MwUGhjNXZLYnI0bjJibVFUM0grSXF4?=
 =?utf-8?B?L09ramxrNGg3M3RHclllYnVCT2t0RkIzUGw4TjNsNVZuV1BQcUpDcFUrcHpM?=
 =?utf-8?B?Mmhncy9ueko2VWE3Zk0wWnZvL3QzYjFQZHhPQmxXUXVDZkpKS1pGMUN6QmMw?=
 =?utf-8?B?aXhBUTVLZlZUU0ROb2Z5ZklxNm5LcElmdzQ0Vm1GaDVNNCtvbDZNQ2V5dURt?=
 =?utf-8?B?bTBaSTNCUU9TelNmNmdlb3c1YlBrTmxDZ21NM2FHYUgzWE14NDhhU2ZHaGds?=
 =?utf-8?B?azFVaUowaVdxbTI5YW1TejNrNEV4QThEbEZQNlVQcWx5OU5iMEdVSEdMczdw?=
 =?utf-8?B?dnhKaWRIem1zdW9FWXBiYkUxbU43a0RJdytRQmoxNTk3NVk4MmpvOFh6NlhE?=
 =?utf-8?B?SDc0U1dkbjREK001b2h3NkIyZFR1dzlpZDNWMGRaQkl3NkZjY1pKY3NDMVVw?=
 =?utf-8?B?KzFhdHoxVkJrT0RaN0pZdTdmdmE4Qzd3R2FHb2ZCcDRDVkNyV2VyQnUwTFhU?=
 =?utf-8?B?WVZFRG1QQ3ZITmgxMFBhb2E3YzUxSXNBTGRrNVd1THlMcGNLVWhWNklMNHR4?=
 =?utf-8?B?MGhWV1U2a09nWnZFdXVOcXI4dWZnbjRWTTJSZGc5Y3YvOTVLQU9wVnpzNlZm?=
 =?utf-8?Q?XY26SeEcelFoVdqh9shMIm8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5fb640-3adc-484e-7783-08de2b491a8a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:03:31.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBW5woxFOyCZYvLfun23Npqovd3NHPm+A9Eh0NtYQ7k/1EYhk/MqQ5D3kPRUa7AESYxlcDhW5vFORsB98Pa7sjj+3oxpYX2KwXs4uuEp/UYp+aZuve0zPR4Kb/GGx1nL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR01MB8853

On 10/28/2025 5:59 PM, Marc Zyngier wrote:
> On Tue, 28 Oct 2025 06:02:03 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> On 10/23/2025 8:05 PM, Marc Zyngier wrote:
>>> On Thu, 23 Oct 2025 12:11:42 +0100,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>> Hi Marc, Oliver,
>>>>
>>>> On 10/13/2025 12:21 PM, Ganapatrao Kulkarni wrote:
>>>>> As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
>>>>> stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
>>>>> triggers invalidation in L1 S2-MMU and in all active shadow (L2) S2-MMU
>>>>> tables. Because there is no direct mapping to locate the corresponding
>>>>> shadow IPAs, the code falls back to a full S2-MMU page-table walk and
>>>>> invalidation across the entire L1 address space.
>>>>>
>>>>> For 4K pages this causes roughly 256K loop iterations (about 8M for
>>>>> 64K pages) per unmap, which can severely impact performance on large
>>>>> systems and even cause soft lockups during NV (L1/L2) boots with many
>>>>> CPUs and large memory. It also causes long delays during L1 reboot.
>>>>>
>>>>> This patch adds a maple-tree-based lookup that records canonical-IPA to
>>>>> shadow-IPA mappings whenever a page is mapped into any shadow (L2)
>>>>> table. On unmap, the lookup is used to target only those shadow IPAs
>>>>> which are fully or partially mapped in shadow S2-MMU tables, avoiding
>>>>> a full-address-space walk and unnecessary unmap/flush operations.
>>>>>
>>>>> The lookup is updated on map/unmap operations so entries remain
>>>>> consistent with shadow table state. Use it during unmap to invalidate
>>>>> only affected shadow IPAs, avoiding unnecessary CPU work and reducing
>>>>> latency when shadow mappings are sparse.
>>>>>
>>>>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>>>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>>>> ---
>>>>>
>>>>> Changes since v1:
>>>>> 		Rebased to 6.18-rc1.
>>>>> 		Fixed alignment issue while adding the shadow ipa range
>>>>> 		to lookup.	
>>>>>
>>>>> Changes since RFC v1:
>>>>> 		Added maple tree based lookup and updated with review
>>>>> 		comments from [1].
>>>>>
>>>>> [1] https://lkml.indiana.edu/2403.0/03801.html
>>>>>
>>>>>     arch/arm64/include/asm/kvm_host.h   |   3 +
>>>>>     arch/arm64/include/asm/kvm_nested.h |   9 +++
>>>>>     arch/arm64/kvm/mmu.c                |  17 ++--
>>>>>     arch/arm64/kvm/nested.c             | 120 ++++++++++++++++++++++++++--
>>>>>     4 files changed, 138 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>> index b763293281c8..e774681c6ba4 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -227,6 +227,9 @@ struct kvm_s2_mmu {
>>>>>     	 * >0: Somebody is actively using this.
>>>>>     	 */
>>>>>     	atomic_t refcnt;
>>>>> +
>>>>> +	/* For IPA to shadow IPA lookup */
>>>>> +	struct maple_tree nested_mmu_mt;
>>>>>     };
>>>>>       struct kvm_arch_memory_slot {
>>>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>>>> index f7c06a840963..5b7c4e7ed18f 100644
>>>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>>>> @@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
>>>>>     extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>>>>     extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>>>>>     extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
>>>>> +extern int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa, u64 ipa,
>>>>> +		u64 size);
>>>>>       union tlbi_info;
>>>>>     @@ -95,6 +97,12 @@ struct kvm_s2_trans {
>>>>>     	u64 desc;
>>>>>     };
>>>>>     +struct shadow_ipa_map {
>>>>> +	u64 shadow_ipa;
>>>>> +	u64 ipa;
>>>>> +	u64 size;
>>>>> +};
>>>>> +
>>>>>     static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
>>>>>     {
>>>>>     	return trans->output;
>>>>> @@ -132,6 +140,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>>>>>     extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>>>>>     extern void kvm_nested_s2_wp(struct kvm *kvm);
>>>>>     extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
>>>>> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size, bool may_block);
>>>>>     extern void kvm_nested_s2_flush(struct kvm *kvm);
>>>>>       unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu,
>>>>> u64 val);
>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>> index 7cc964af8d30..27c120556e1b 100644
>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>> @@ -1872,6 +1872,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>>     		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>>>>>     					     __pfn_to_phys(pfn), prot,
>>>>>     					     memcache, flags);
>>>>> +
>>>>> +		/* Add to lookup, if canonical IPA range mapped to shadow mmu */
>>>>> +		if (nested)
>>>>> +			add_to_shadow_ipa_lookup(pgt, fault_ipa, ipa, vma_pagesize);
>>>>>     	}
>>>>>       out_unlock:
>>>>> @@ -2094,14 +2098,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>>>>       bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range
>>>>> *range)
>>>>>     {
>>>>> +	gpa_t start = range->start << PAGE_SHIFT;
>>>>> +	gpa_t end = (range->end - range->start) << PAGE_SHIFT;
>>>>> +	bool may_block = range->may_block;
>>>>> +
>>>>>     	if (!kvm->arch.mmu.pgt)
>>>>>     		return false;
>>>>>     -	__unmap_stage2_range(&kvm->arch.mmu, range->start <<
>>>>> PAGE_SHIFT,
>>>>> -			     (range->end - range->start) << PAGE_SHIFT,
>>>>> -			     range->may_block);
>>>>> -
>>>>> -	kvm_nested_s2_unmap(kvm, range->may_block);
>>>>> +	__unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
>>>>> +	kvm_nested_s2_unmap_range(kvm, start, end, may_block);
>>>>>     	return false;
>>>>>     }
>>>>>     @@ -2386,7 +2391,7 @@ void kvm_arch_flush_shadow_memslot(struct
>>>>> kvm *kvm,
>>>>>       	write_lock(&kvm->mmu_lock);
>>>>>     	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>>>>> -	kvm_nested_s2_unmap(kvm, true);
>>>>> +	kvm_nested_s2_unmap_range(kvm, gpa, size, true);
>>>>>     	write_unlock(&kvm->mmu_lock);
>>>>>     }
>>>>>     diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>> index 7a045cad6bdf..3a7035e7526a 100644
>>>>> --- a/arch/arm64/kvm/nested.c
>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>> @@ -7,6 +7,7 @@
>>>>>     #include <linux/bitfield.h>
>>>>>     #include <linux/kvm.h>
>>>>>     #include <linux/kvm_host.h>
>>>>> +#include <linux/maple_tree.h>
>>>>>       #include <asm/fixmap.h>
>>>>>     #include <asm/kvm_arm.h>
>>>>> @@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>>>>>     	mmu->tlb_vttbr = VTTBR_CNP_BIT;
>>>>>     	mmu->nested_stage2_enabled = false;
>>>>>     	atomic_set(&mmu->refcnt, 0);
>>>>> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>>>>     }
>>>>>       void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>>>> @@ -1067,6 +1069,99 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>>>>>     	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
>>>>>     }
>>>>>     +/*
>>>>> + * Store range of canonical IPA mapped to a nested stage 2 mmu table.
>>>>> + * Canonical IPA used as pivot in maple tree for the lookup later
>>>>> + * while IPA unmap/flush.
>>>>> + */
>>>>> +int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa,
>>>>> +		u64 ipa, u64 size)
>>>>> +{
>>>>> +	struct kvm_s2_mmu *mmu;
>>>>> +	struct shadow_ipa_map *entry;
>>>>> +	unsigned long start, end;
>>>>> +	int ret;
>>>>> +
>>>>> +	start = ALIGN_DOWN(ipa, size);
>>>>> +	end = start + size;
>>>>> +	mmu = pgt->mmu;
>>>>> +
>>>>> +	entry = kzalloc(sizeof(struct shadow_ipa_map), GFP_KERNEL_ACCOUNT);
>>>>> +
>>>>> +	if (!entry)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	entry->ipa = start;
>>>>> +	entry->shadow_ipa = ALIGN_DOWN(shadow_ipa, size);
>>>>> +	entry->size = size;
>>>>> +	ret = mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, entry,
>>>>> +			  GFP_KERNEL_ACCOUNT);
>>>>> +	if (ret) {
>>>>> +		kfree(entry);
>>>>> +		WARN_ON(ret);
>>>>> +	}
>>>>> +
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>> +static void nested_mtree_erase(struct maple_tree *mt, unsigned long start,
>>>>> +		unsigned long size)
>>>>> +{
>>>>> +	void *entry = NULL;
>>>>> +
>>>>> +	MA_STATE(mas, mt, start, start + size - 1);
>>>>> +
>>>>> +	mtree_lock(mt);
>>>>> +	entry = mas_erase(&mas);
>>>>> +	mtree_unlock(mt);
>>>>> +	kfree(entry);
>>>>> +}
>>>>> +
>>>>> +static void nested_mtree_erase_and_unmap_all(struct kvm_s2_mmu *mmu,
>>>>> +		unsigned long start, unsigned long end, bool may_block)
>>>>> +{
>>>>> +	struct shadow_ipa_map *entry;
>>>>> +
>>>>> +	mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
>>>>> +		kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
>>>>> +				may_block);
>>>>> +		kfree(entry);
>>>>> +	}
>>>>> +
>>>>> +	mtree_destroy(&mmu->nested_mmu_mt);
>>>>> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>>>> +}
>>>>> +
>>>>> +void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
>>>>> +		bool may_block)
>>>>> +{
>>>>> +	int i;
>>>>> +	struct shadow_ipa_map *entry;
>>>>> +
>>>>> +	lockdep_assert_held_write(&kvm->mmu_lock);
>>>>> +
>>>>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>> +		unsigned long start = ipa;
>>>>> +		unsigned long end = ipa + size;
>>>>> +
>>>>> +		if (!kvm_s2_mmu_valid(mmu))
>>>>> +			continue;
>>>>> +
>>>>> +		do {
>>>>> +			entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
>>>>> +			if (!entry)
>>>>> +				break;
>>>>> +
>>>>> +			kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
>>>>> +							entry->size, may_block);
>>>>> +			start = entry->ipa + entry->size;
>>>>> +			nested_mtree_erase(&mmu->nested_mmu_mt, entry->ipa,
>>>>> +							entry->size);
>>>>> +		} while (start < end);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>     void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>>>>>     {
>>>>>     	int i;
>>>>> @@ -1076,8 +1171,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>>>>>     	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>     		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>     -		if (kvm_s2_mmu_valid(mmu))
>>>>> -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
>>>>> +		if (!kvm_s2_mmu_valid(mmu))
>>>>> +			continue;
>>>>> +
>>>>> +		nested_mtree_erase_and_unmap_all(mmu, 0, kvm_phys_size(mmu), may_block);
>>>>>     	}
>>>>>       	kvm_invalidate_vncr_ipa(kvm, 0,
>>>>> BIT(kvm->arch.mmu.pgt->ia_bits));
>>>>> @@ -1091,9 +1188,14 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>>>>>       	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>     		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>> +		struct shadow_ipa_map *entry;
>>>>> +		unsigned long start = 0;
>>>>>     -		if (kvm_s2_mmu_valid(mmu))
>>>>> -			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
>>>>> +		if (!kvm_s2_mmu_valid(mmu))
>>>>> +			continue;
>>>>> +
>>>>> +		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
>>>>> +			kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry->size);
>>>>>     	}
>>>>>     }
>>>>>     @@ -1104,8 +1206,16 @@ void kvm_arch_flush_shadow_all(struct kvm
>>>>> *kvm)
>>>>>     	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>     		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>     -		if (!WARN_ON(atomic_read(&mmu->refcnt)))
>>>>> +		if (!WARN_ON(atomic_read(&mmu->refcnt))) {
>>>>> +			struct shadow_ipa_map *entry;
>>>>> +			unsigned long start = 0;
>>>>> +
>>>>>     			kvm_free_stage2_pgd(mmu);
>>>>> +
>>>>> +			mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
>>>>> +				kfree(entry);
>>>>> +			mtree_destroy(&mmu->nested_mmu_mt);
>>>>> +		}
>>>>>     	}
>>>>>     	kvfree(kvm->arch.nested_mmus);
>>>>>     	kvm->arch.nested_mmus = NULL;
>>>>
>>>> Any review comments or suggestions for this patch?
>>>
>>> None. This patch is obviously lacking the basic requirements that such
>>> an "optimisation" should handle, such as dealing with multiple
>>> mappings to the same IPA in the shadow S2, hence will happily fail to
>>> correctly unmap stuff. There is no documentation, and no test.
>>>
>> Thanks for the comment.
>> How about adding list of multiple mappings ranges to the maple tree
>> entry/node while adding to the lookup and later unmapping every
>> range present in that list?
> 
> How will that work when the various mappings don't have the same size?

Can we have a merged new pivot?
Say old IPA range is from A to B and the newer range is from C to D (Which are intersecting partially or fully).
Then can we create new pivot (delete old and insert new) with the range MIN(A,C) to MAX(B,D).
The new pivot will have list of entries of both old and new shadow ipa ranges.
This shall be repeated till all intersecting pivots are merged.

While unmapping, on first intersect detection, unmap all listed shadow IPAs.

> 
>> I tested this patch on an AmpereOne system (2 NUMA nodes, 96 CPUs
>> per node, numa balance enabled) with large vCPU counts and large
>> memory to L1 and L2.  The current full-address-space walk caused
>> very large unmap/flush work and significant delays (exacerbated by
>> NUMA balancing / page migration activity).  The targeted unmap using
>> the list per node removes only the affected mappings and reduces the
>> unmap latency substantially in our workloads.
> 
> I really don't care how badly things perform. The important thing is
> that this is architecturally correct, while your approach isn't.
> 
>> I booted multiple L1s, each hosting several L2s, and observed no
>> panics or failures related to missing support for multiple‑IPA
>> mappings.
> 
> I'm sorry, but Linux isn't a validation tool for the architecture. You
> have clearly designed something around Linux's own behaviour, not the
> architectural requirements.
> 
>> If you have any test cases or scenarios that would validate support
>> for multiple IPA mappings, could you please share them?
> 
> The onus is on *you* to provide them, not me.
> 
Using below kvm selftest code, could generate the 2 shadow IPAs, mapping to same canonical IPA (when ran from L1 shell).
This code generates 2 shadow IPA ranges of same size(PAGE SIZE) and mapped to same Canonical IPA.

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <linux/atomic.h>
#include <linux/sizes.h>

#include "kvm_util.h"
#include "test_util.h"
#include "processor.h"
#include "ucall_common.h"

#define PAGE_SIZE  4096

static void guest_code(uint64_t slot1_gpa, uint64_t slot2_gpa, uint64_t size, uint64_t page_size)
{
         uint64_t gpa;

         for (gpa = slot1_gpa; gpa < slot1_gpa + size; gpa += page_size)
                 vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);

         for (gpa = slot2_gpa; gpa < slot2_gpa + size; gpa += page_size)
                 vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);

         /* Write to slot 1 in loop */
         while(1) {
                 for (gpa = slot1_gpa; gpa < slot1_gpa + size; gpa += page_size)
                         vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
         }

         GUEST_PRINTF("Guest DONE\n");
         GUEST_DONE();
}

static void run_vcpu(struct kvm_vcpu *vcpu)
{
         struct ucall uc;

         do {
                 vcpu_run(vcpu);
                 switch (get_ucall(vcpu, &uc)) {
                         case UCALL_ABORT:
                                 REPORT_GUEST_ASSERT(uc);
                                 break;
                         case UCALL_PRINTF:
                                 printf("%s", uc.buffer);
                                 break;
                         case UCALL_DONE:
                                 break;
                         default:
                                 TEST_FAIL("Unknown ucall %lu", uc.cmd);
                         }
         } while (uc.cmd != UCALL_DONE);
}

int main(int argc, char *argv[])
{
         uint64_t gpa, slot_size, slot_stride, i;
         int slot, fd;
         struct kvm_vcpu *vcpu;
         struct kvm_vm *vm;
         void *mem;
         int first_slot, nr_slots;
         uint64_t start_gpa;

         slot_size = SZ_1M * 128;
         slot_stride =  SZ_2G;
         start_gpa = SZ_4G;
         first_slot = 1;
         nr_slots = 2;

         vcpu = malloc(sizeof(vcpu));
         TEST_ASSERT(vcpu, "Failed to allocate vCPU");

         vm = __vm_create_with_vcpus(VM_SHAPE_DEFAULT, 1,
                                     (nr_slots * slot_size) / PAGE_SIZE, guest_code, &vcpu);

         fd = kvm_memfd_alloc(slot_size, false);
         mem = mmap(NULL, slot_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
         TEST_ASSERT(mem != MAP_FAILED, "mmap() failed");

         for (slot = first_slot; slot <= nr_slots; slot++) {
                 gpa = start_gpa + ((slot - first_slot) * slot_stride);

                 vm_set_user_memory_region(vm, slot, 0, gpa, slot_size, mem);
                 for (i = 0; i < slot_size; i += vm->page_size)
                         virt_pg_map(vm, gpa + i, gpa + i);
         }

         vcpu_args_set(vcpu, 4, start_gpa, start_gpa + SZ_2G, slot_size, vm->page_size);
         run_vcpu(vcpu);
}

from host, tried page migration using migratepages command to trigger L1 crash with PATCH v2.
-- 
Thanks,
Gk
