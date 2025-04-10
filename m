Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022075.outbound.protection.outlook.com [40.107.200.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87FB280CC5
	for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744280436; cv=fail; b=Z8XOr1SkWKqKdKxpqDEL88xWfraNFqgWNARDr3jwk/A3s8uwhXkwuO6B0tl7VSGno/nEMQwcNnCHyzYOz9hGECdunb/DUU6DDHMtiAUslgQrRdbzeLuZSxBm7g9VuiO2cXR8QB5Pcs0GKjX07tuID87HhLAKFneUH1Y44iTD0u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744280436; c=relaxed/simple;
	bh=7useiR1cNR10K5rhoccBhXsmPeaYxFRjjFzL+EKwaGA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HDLSLC4KIiMyFo6tMKaGOkQIvYaUYxxVxysAqp45LsEVSV7qo9TKkilsHyiQ/c28Z5z3Ejq3D0hD86uasIuoJ1KLSnhCs1XF6cQdOe03VJNgRegE9xPnf8IVnfxXn71luu7YOuq49aLS4qrvA20WO14bvpwG6PPXlGkM0YJ8xT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Jsiwc4hJ; arc=fail smtp.client-ip=40.107.200.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Jsiwc4hJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgOnj9KCY/8QJFwdFOWyVdbgOu9OWn49cGvpcJh36PjMDVtVCNrCnJMwaW7kj0LO/EMymKMmRH7+mf8LLeBIYT/ZXD7X1SGAHy9tMngXbLaFQkX5g6c2P66PZJC9y3lygDBhOQQX79IFcf9QGhEhPd1OpLfaMQ4jgEmVRQV+oEzTV4p96UqRuKHN0c5rqVQ8bHF6Fw5a3+PwA+doEUp/2cf2z1Oci5l7SRjApQCHsEbIKfweSGxb1V+na7c+yfxBdNi57ixt7ljFKeerIg5qu3tTa40PELyKLD9TPzzkK1GDsTfU83CiTE3B//DhPz9DVY4LfGlX2KZwa6ztfITXdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KqeieDg+BW2dZtXfWsXbnC5UqYZA7jIz7y5IK/Qyso=;
 b=f5/53UMV14+JDirN+HcI8r479WCVLF3jActbbvEz713b4qU6mCNV7s+h+aWAjPX3r1eQHYCUoMUsCYHYqIK7SgG9wYGQBDX3GJTQk5ZU1VzIOX9NtIvqpIARniAY6ibm2elTWELKKmZ9vo3jKWirWZ9NkXm8U9BLeoFhq0LTxmjDQpM9lAsmtV50daeseYW4eZJ88Y82q20S0vGcDbg2q3h3b+bXfaxtwNwg4wcXBzzNvXBlt+zORWKSPwCP0WgHMV74pYOWfVI9CgfCvWDWwSw+XGwYgixMwyzSaBu8A9WQE5NalCW6wdJADsFZAHGmC4UyePrDYXNAe8wboq+2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KqeieDg+BW2dZtXfWsXbnC5UqYZA7jIz7y5IK/Qyso=;
 b=Jsiwc4hJqIabJvuOOqWQondj4KQ0kpleCUEiUuYkoUdkItB4lIziJczJ3BzVMN07cdWZH104onSk13kyGIG5H+J9vE3JH/7Q+F2t8TmMQ+0Lt3N6glhR6ZIF/BmcFoPzU0eifHXsW0ekhYabXpKUIBQfZUR00an7iEZJHzD1zUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BY3PR01MB6530.prod.exchangelabs.com (2603:10b6:a03:368::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.34; Thu, 10 Apr 2025 10:20:32 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8632.024; Thu, 10 Apr 2025
 10:20:31 +0000
Message-ID: <4d1bdea5-43c3-4ca9-9275-feadf158e86e@os.amperecomputing.com>
Date: Thu, 10 Apr 2025 15:50:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Forward hvc traps if originated from
 nested VM
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, darren@os.amperecomputing.com
References: <20250410070743.1072583-1-gankulkarni@os.amperecomputing.com>
 <86mscolc0b.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86mscolc0b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0100.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::9) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BY3PR01MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fde5b00-7e25-40a0-a863-08dd7819528e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXh1Y2VRWDFlWE1qRkkxekoxclFmNWJudGg2YnovaGpLd3R3RCtKZTBmREQ1?=
 =?utf-8?B?aStxZ0tveCtiYzhLVVZ3TDU4bFFCT0xkYklHQUo3YWJPdDdpRjlXcXdQWEly?=
 =?utf-8?B?cHdSSUNQVUdNdXpWdnlGM3UwdTBGaFVOem9UQ2FjbXcrVEZMOWcyYlZJYnJM?=
 =?utf-8?B?T3B4NXJKS1BhKzhqcG14WVBGOU9TNjdDRXlCMkdwSE9JWGJxdHpQbVpITXJB?=
 =?utf-8?B?cmVRMlpCNHFKdGlMUjlDOURrT01GNGZZcUJ3UVNmQ0MxUzZwRmhjd0xiSEkw?=
 =?utf-8?B?S0JlOUtYUG1OMG9ja3lsc08wQTBpWmg3OVp2bjVtWnk0SERDdzlFWW5uQzNx?=
 =?utf-8?B?STQvbXEwRXhBS25WYVdGUCtGNmdBZHgwdlR4a1dpTG1KREkyeUlOUko2NGRS?=
 =?utf-8?B?NnhWbUJWMU5iTVBqOFhPZjhCbnJWWnNJcDZBTXVUaE5GSGprOGFkQWtsdzZh?=
 =?utf-8?B?L3ZEeUpmVk4vVWhVR01ZM3N6UWpqSjk2cnE3RGxMSjBKNDd2R3ExWllhaTI1?=
 =?utf-8?B?Vy91OW5HRmoxblhqS0NmNFBHZG10NWR5RVlIeXdzZXlaMHdDVkVDTk5wemFv?=
 =?utf-8?B?TjVrbzJrTjBhZnFCWVQwRlZTRHNpOWxBSElnWnFaNkdKTjF2NjlYNG5wOUJa?=
 =?utf-8?B?ZU8xWGwra0ZlV29CQXpCblpKNTBuNW1TbElscG5VWWZUNE5TeHRSQmVhYkdW?=
 =?utf-8?B?MlZnZUY3MmJ1RUhRRlBBU25xNHdJb05VOVdDYk1xZU1QQmZaSzViY1dhRUZu?=
 =?utf-8?B?Y1VMNHVxZTZXeUdOeE9NL3JrbWo3ODRTQTBMOVJ6NHVVRjhrWjR2dEQ4OWZp?=
 =?utf-8?B?bElEMEpnM1hzcmZ3UHoxdTVUTUpXRFUvZCtFOVkyK2tadkFnSW16SmdHWnZx?=
 =?utf-8?B?UTVlRVdhcjl0SFZGUzh3bUhKRUc3YklVaXhTRlhGOWplSEN4OUdlOHo3aHNv?=
 =?utf-8?B?WmU0Q2VUSERvT1J4SHRsNHRiUVdFcE10Q0QvTjlCcXo3TWlmWk5sTnJDRkc0?=
 =?utf-8?B?R3kxVUs4K2syZFhxTllncDdzMUJoNU1neXpsd1UzRktocHRpM3Q3bGJjc09a?=
 =?utf-8?B?ZHlOMnp1UUc2eW1LdzNhNGtSb3NvYjNUS2VjVk15UWdDcmhZR3RsaFE2S1VR?=
 =?utf-8?B?dXp3akZ3cldpRzZQSWptRXh0QkxNZEZIZ3gzWmREVDdGdm5TNmg4RTBBcUpG?=
 =?utf-8?B?RC95djlWSkxhUlphOXJtcXRsNEhwcUtNUFhOUlcxMFczeE91TVN5T1FmaUpR?=
 =?utf-8?B?cnJ4ajg5OG1HK0dpVkRHczA0RlF5bUZpKzRxTDZabkpPeWRJRTJkOUg0Wis0?=
 =?utf-8?B?U2lnN0hvdTA4ZGZ1c3Zya214VHJoWlNDOWc0dzQ4Y1ZwdVdCVVBYbGVVZERX?=
 =?utf-8?B?Si8wVXdOMitqSWhzcm1xTHpKajk4cWVtaUh0SUdoSnpzMlM4VU9COWNkSCsr?=
 =?utf-8?B?T3B2UEhEQ0NZL3pGNnhTR3Fzb090ZDU3VDc4VTYwYWdWb2VTcE1oVVRXaS9p?=
 =?utf-8?B?YkhCUHVraTBYZ3NhSlp0WHBlWXlrdGN1NnB2MURDNXZOcnlXaHNUK0d2MDRt?=
 =?utf-8?B?d0xoWGNrWEMwclRvM0kvYWxkS3UxMjR0LzBiWmxWQW40RUIzcis1R0pleTdD?=
 =?utf-8?B?MTErS2tSTHloaU5nZndBTUhaNXVsOUdBa2FrcSs1SnlRQ1FNc282UzhBd2Ry?=
 =?utf-8?B?K2NlNDQwdlBBcGtKYXJvTzJZV24zUDByNCtFZ1BtVkdMZmw2KzZaU1l1bFRH?=
 =?utf-8?B?ckNZcGdaVmd0d3pOVGIxdzIwK2RNdlkwc082TXlxUk10Q0JTRlduQUNxTzVC?=
 =?utf-8?B?eXhwQTUwTXhaZm9xQTl0SjV5R2wyZVNsTmYzNmFoL2poeG16U0ZEMXYyT3po?=
 =?utf-8?Q?avFJAUvxquSFz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFFGMkl0cTZJZ0paa3NtdnpTSXVXcTFuaStzUkVmTXk3eVdySjRoQ3l0dHpC?=
 =?utf-8?B?YzZYTFdKYjN0TW1pSWRHUWFnbisxbE42d1ptZ0tyYVUwcnc3aU4zV3VTNUN0?=
 =?utf-8?B?Vi9qQUtBYmp4NnE1Ym9zSGlLNWRHVFhSb2ZrR1dxdzQvMXY4WEd0RklteUV0?=
 =?utf-8?B?YTlvaWdnWGZhNWxKOXJLU2dBWkxiejAyV1BQaDltOTNrWUMyRTJLdFVQbVY5?=
 =?utf-8?B?VzRQVnZicDlKQXNLYjJvcXQ0NTRyYkRScllzbWhRejRFU0t3UDVIOFVEY3RP?=
 =?utf-8?B?S1dyN1JWYTFuSUFVWWxQUWdhdlBLdFhjVS8vUG8xU2NTRmFzS1VwVk9lL1I3?=
 =?utf-8?B?R0F2Q0pLbEFiSEtqRURKOUw1WXhQTEtndEh0VGJ3MmhUeTFDSHRWdU91OWgr?=
 =?utf-8?B?aUlURjBuUEVVR1VBQzFrcGxlWnMrdjUxbVRoSFQ2VXY0N2VVQmZiYlVrVG9t?=
 =?utf-8?B?ZUhkaHRhV1NBSG9YRTcvc0FwUXZtUlRsaDNyb2tuYWRlb0RXQXhEVFJSQjlv?=
 =?utf-8?B?NUlKWkRQd25VMHVhbkl0MmtJMVR4cGlCczlvZGFEbUxqSlluVUZIcmYzVGpy?=
 =?utf-8?B?clU5bDBDUTZnYXd1WUFrQWZ3WWVidW02TTVJb1RXWTRaaGdZRWo0ZHdOdXBH?=
 =?utf-8?B?VXVTaTl6bHU4dTNaSFNvMXZ4eS9IUjFHN1dVbWEwZ00wcVFUR3o1ZUNJbjJJ?=
 =?utf-8?B?clpQRG9oMGtGNUdnNVZ3OUd3aVprbVltZDBqZzlqMEJNdWtyWEpJMmYzdUNy?=
 =?utf-8?B?UEY5RXZRM1hPZzNqR1h5K0EvYVJTeGxLL1JyaTViRE90NFh1YTZhUnNOU0FS?=
 =?utf-8?B?N1V5TWQyN21mcEQvckdxakJhdmZiUDFJenVCNUJ4SUZQRkRHYUJrZ1NQenpD?=
 =?utf-8?B?VFhzSUNIL3BjTmhjRlJSZloyYTBsRU5kcXU2ZFd2eWJUNVNrRHZGNE5YcHE4?=
 =?utf-8?B?Yi9WMHR4c3FoMGFkQVNwenU0U3NPWXBsaFUydk8ycjU5U2t2NVZxOU1MODdj?=
 =?utf-8?B?TVBoT3B6ekp0c3hMeTRZcW55c1BQZnhqL09HcFJ3NW9nWHpQL2NDajF1bUg4?=
 =?utf-8?B?UHFaVlBybDJKSHMyQnNrTzhlN3QxUlFBazVVWVV0b1B3clZJRC82ZlpTWHpJ?=
 =?utf-8?B?cEIxY08yVElCUHBXalZUaUVYdXh6K3huZXF3NEN2OCtOM251RWZMVmF4aHJq?=
 =?utf-8?B?OFZacjFVMlRCTWZHQUZHQ3BTTUJ0WTAyRkl4MDdHNTZtR3pKRWRYRWpPL0Ns?=
 =?utf-8?B?MnM4Y2NtaEU3eVB0UTV2OWZjZnErcXZvakRzc3p3S2xWOVYxMmIwYmVBYmRK?=
 =?utf-8?B?M0VyVU1yMUdwZjRwOGdlOWUvMTJ2bTFVVXZnS25qZ1BqaE5KZllvZ3FYMTIx?=
 =?utf-8?B?VUVLL3BMNExCOHYveWlZRjRrcXpDTE5za3l4eGhaOFRhZ0dROS9PemF3NklE?=
 =?utf-8?B?WXQxd3N6RVB5cUNuOGoxVERTcmE1Sjk4L1lqTWQyZkZHYlFUVVhpb3lXdWk3?=
 =?utf-8?B?VlBzQzFLLzAvUHJoNXpTZUZweWljTEdTYWNES1JxSGRVQXRuL2JjdmVaSnQy?=
 =?utf-8?B?aU0wRzk1MW0zUkg4Tnd0MGo4dHE5Wm5iTE5OWGdIV2dCNnZST0hpVTd2TnRR?=
 =?utf-8?B?d0JHQ1Fmd3F0SkVHN2RHc1BiUFR5ZUhVWU42L1o3YVMrN3Fzb241M3JuTlQy?=
 =?utf-8?B?Z2toUytFTHMrV09XOW93R2FNdDJwcG5Bb0gxZitzNmFOVFNhVkxzbEo5Nk5h?=
 =?utf-8?B?RFlIOUJJSWtiODVUNVhkN2pYc2h0amt0QTlFNUJ3alhBWVhPUWFwbkFXZGVN?=
 =?utf-8?B?UXdVZk9WZ0xic1JPcEdTZ1JncEVWRVgzc2tzQmdlTDNmYUx1T3NxU2NMYkJa?=
 =?utf-8?B?THhRM3Nha2JoKzc5dTlzTFNkV1JSdXFhRXlSUXV6b1FkZFcvTTRSR1p5VDhI?=
 =?utf-8?B?MytHZWVVMTJKN2xoNUdRVDUxdmdUVkVNdU5UbUJodFJZbnYrRGxlVmVmdEhB?=
 =?utf-8?B?dzA0SjI3M1dnZ25CUWFYRkpTcVJnbVhMaUpHTE96WWVvWmdUUzkwQXFtREds?=
 =?utf-8?B?ZGtudDBEaGI0TWlSQ2JkYjhKdVZGQWh5dlVUc25rYXRZMWxYODR5UEFPQW51?=
 =?utf-8?B?SlRsSUloNlpCZzR0K0l2UUNtSjBBNStGMWtENi9pUDZDM2oySkU1cUV5TWRS?=
 =?utf-8?Q?Nx6S4R+YU1Bdq5GsTyU96Lw=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fde5b00-7e25-40a0-a863-08dd7819528e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 10:20:31.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hnAiOoK7Y+rm8sHaICPAK0myUNziXDuBE9yCzOuR6uNDwOA7hHRF3W84Rx7FxUj1Kjs4Vijaqy4F/TDozRMkKp6rth8Pob1U8fbV2ojeN3pc/jfWkKhYDcA5pcFQFJ17
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6530



On 10-04-2025 12:49 pm, Marc Zyngier wrote:
> On Thu, 10 Apr 2025 08:07:43 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> It was discovered while trying selftest(smccc_filter) that the
>> hvc trap is getting forwarded to guest hypervisor even if it is
>> originated from itself.
>>
>> HVC traps from guest hypervisor should be handled by the host
>> hypervisor and traps originating from nested VM should be
>> forwarded. Adding check to forward only if the hvc is trapped
>> from the nested VM.
> 
> I disagree. HVC from EL2 must be routed to the same EL2. HVC from EL1
> must be routed to the EL2 controlling EL1.

Thanks, Understood, In NV case, hvc has to be forwarded to L1 
irrespective of it origin (L1 or L2). Need to add hvc handler in the 
smccc_filter.c for the vm (when run as L1), so that it is handled and 
returns with required args set.


-- 
Thanks,
Ganapat/GK

