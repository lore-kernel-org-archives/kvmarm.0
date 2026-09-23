Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7923E5EF7;
	Wed, 23 Sep 2026 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153206; cv=fail; b=ATczafvnl02VMAcp+Jv7YrwcevlaM5etPfHNgHAENpwsBSLCpZkzEbYLfPNSs+QxG1ok3jOqhy93WtdqGnsa9HI4+5sWLM3Caq8SKahvqp+Vmh1QZ/xcUZNfcKs+hiuy04pudX63VAul8Xq32xL/MlUar6WNngSgRTU/M+80H/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153206; c=relaxed/simple;
	bh=WBnkc3I2Dq3M9b/MsYdOXnI67TtUXIQEZIXKu+IzDOk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iQphSl6xMy4vCO5LCz//1r3fNgDyma6l/KYzKNAhmHSXQHj75n5EE6JQNhCNc5TTJXsU14ny3f67OZZ7tDjAXMF+Nlbnc/v1em1RVPnpe7eIkbmzhwHcbWxraG6rVyqbRHsBGrXXO9WAFHzcmnw1nWvfhkZrLQrRTbD/z66EkFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xm7Jh6uB; arc=fail smtp.client-ip=40.93.196.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xm7Jh6uB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmIL/kfewwa5UuftoxGSs9ynNz8hNKt2U2yp10JOLA/vq32Bvt7yfRJSXZA3WOEEP9zlMHBIR/jcNfQkAAfWWO2wENHZs45ypF4Bem67HVgmqj/kusze900P/suiNreqNCpa0LDARUwX8zTblEQzCfI/SwFt940Eo4NSBN4hWjYSmyc9nt0cLJt2osSgkXOlJYVKLtoeEimVAGXnd0oTCIXzGqrrY9xyqFhTWNcOkiYynRzOF0xeMZm0DRWJygdCSpjE8NHZyR01Xmitcoq31iS5wP319ohqJdyCml7fLMWFMBGsqbh8abmMzuftOgcoLW66QCWGcfNbukumh9cP4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7q1PdpA2HlwCEscT7LtbV1Ih1mHhPfyNO2+wAWI7imM=;
 b=bzG+aDG7TCYr+c5emkYmHuvTYz3jQ5D04em60nbewtGapUfUmRqraK/sV+tQWHauF6CzR+/FmNBENAndudJSnNXXSmbpkkXLvGntsf6LruWHPU86l4kbMtKkeBuUVQA0ITt0a6cBZ/Er6534AbBAkD7YCSU/nH5EKzCCnmyyfwVyypoqFNvLb8IHXSH4fU0zWC+OQFWusqqRdv40vzkKEX5w/pSM6aPue86GAJ8G5YVMANAH+glokHG5oSmkvmWfzhcopk7QMfuBhdWc1wv85FkUmWT2oeeBSdPizbM2sSNylgp//TBxhcnvwU3H0DnRZNnEkQQoby4XSug21x0VUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q1PdpA2HlwCEscT7LtbV1Ih1mHhPfyNO2+wAWI7imM=;
 b=Xm7Jh6uBK3OKDP0anxHpQ+lUazyb5gASPryoG5Je79nMfaQwRVyqMYz6A7BUlQPjOCZZI5AyxwfoCXfcHdAV9Z0Otbz+fe7CDzFquv2PB5fKOFqf5KkS4DtozdGOXfj3zvYV35eX3SUfUnBfOMNZ77puPOlL5lFEy+h9jnpkW5M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Wed, 23 Sep
 2026 08:46:40 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 08:46:40 +0000
Message-ID: <60934676-6279-4aa8-a946-f2df9ab5990c@amd.com>
Date: Wed, 23 Sep 2026 10:46:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org> <arKvKME-_wNeW7ea@arm.com>
 <yq5acxu42wrk.fsf@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <yq5acxu42wrk.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::15) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 88271104-831d-42ca-881c-08df194f2f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|3023799007|11063799006|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	s5ZrUTX5aW4VdbuEPlf9SMnNtqfSJrqqkTXSoYQxKX6UlIV/GGCXyjI7VEd0sQmDNMopAHEhcpJ6tjdjKj7AcdjIV0F6S/kIvCmBAX79dVrBshKuKe+CkZE+4BFVkId1ppthpdhdIqMGNNObG2HLIrfk85BlxNZZN5dgiIhiqpm40J59zZ0rRNZNWlmLYia69QpipMULawEZC8G3nlpBoErhY+tnbXAb/67TN87e3OOS1QYigD1o8lzw2sAzcZs9+WeFSgJB/B1WQjlVJHId3jJIlxJVW9UsjaCpSDPV+3NJV0OF/vplTBWv/kXWNj5XL6Pno1zK3MrkGylNHoc5geetUgnKWdT/m9ND0IbIrTQ5MZarDlSvgjEJxUbOlwxXBGlR5WgYQXYJnXBcYxBCegQFTXEiNVDTdll55DWQkwFk+JU+37/+P/OBMKwe3b1SBCuGtVE9lBFlhzp3RTCFCTjNAfyEkq30ZYGWM/hFNPQ9bs5w4S3pyydKHod86YP4WypjD5GgEGaHPSX/m/xtPv5ndadPTXtRe5Oz7Pw3V7peKBD06tuNnjCpbVtoHIm/G9PhRc8q++tv0rE0Cs9ad/wkJDaeOCDc/YTnmGLhw4B+mxNL3U3eLyuXCVptYxhJ5c5y7h5vC627HRJcGUmGVvG+cl8L0PRUnqRE7TikZ2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(3023799007)(11063799006)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1hxQ1NIdUx2UmhnbzdnK2JkaFNldjVNWGsveDFlVlpxR1RVcEFwUmZ2OHN0?=
 =?utf-8?B?QXJMOGRmUEZqTXdvTUZQRUZId0szb2svNVJpMk5vN2w1RUhjVUxHbEw0N2Zl?=
 =?utf-8?B?TFdRZDFSTFlaUnhZdmFtYkY3eWs0N0wwczQ2UnkrQ3ZIMUo3Zjd1T0xXeHZ4?=
 =?utf-8?B?WUFsSVdPNnROWWMwS284L0VaU1NKQWVaaFloMXZ3dFBGU1IrWm4zb1lLbExX?=
 =?utf-8?B?bWxYdnUvTFNFdGpwS21hcTFNUkVWUTFQVElYUnh5Qlcra002NXJjOFhlazhZ?=
 =?utf-8?B?VHo5VWlYakdWUHhINmYxUmd0cU5xamc4aEJsMmMyQ2RNSEZmM3FFUlhiVTVQ?=
 =?utf-8?B?Q3FaQnBtVjhyYTdXUGpia2FEdE92VjlIN3ZPbzZnRFlwbERIN0lJNE1IY25v?=
 =?utf-8?B?MDhjN2FkUWRMS1Vtd1E0WW93dm4va1QrMW5Ud3hIYURqY1dMYk5Xb2x3WmtO?=
 =?utf-8?B?dUdaVllzWkVPS0FJSHZUVUlJZGJ2SEMxbVVvUXUwQnZWL2lWbHVBVStzME1P?=
 =?utf-8?B?akFFNUV0U2p6YXlBTVhRVS9vM2NaU296Q21SM0VEdFIzNlM3c05iY2hXTlo2?=
 =?utf-8?B?aXZpejZjMDc0N3FqNnBRZTZwRVdiMlh4dXhQRkhqQ0dva090WGt2dnJrdWZ5?=
 =?utf-8?B?VmdLc3pKTVFOQkYzT0NWb3JXTXBqa1c2K0FDS0dJUEdIQWNWSGZ3bXd6VDc5?=
 =?utf-8?B?SUpJblhsbnI3ck1FeC9TYVZGNk1GUWluQStKSWhFUVpXSmZONlJwSWVjd3V3?=
 =?utf-8?B?eDFaODMydnpkM2JqZjlwRGo0TVZJa3lDbkVRaitvQ3V1N1dFY3crQ0RQNmZJ?=
 =?utf-8?B?eHZjMmJ6ZHd5SlpwYUNheUFmdFFrNys3dGFxMzZJRmpqVlFhUDlWOVNkS0ps?=
 =?utf-8?B?NjRIZi9VQ1JhdnZTVGxQamg1RXlyZVJHQzFMV2dacDRNWFpRMHFPYTl6Wk40?=
 =?utf-8?B?Y0xUdU5JVnBmSE1MMkxtM2lLQmNVdmFRSmh6MjdxOTlJdUJQRlVpdUJJejNu?=
 =?utf-8?B?TjFYU2l2MTkxS1JWQXNjRmt2V1h4eWxqaEtzZmRLVVF4dGlvaDA2RTFFUnpu?=
 =?utf-8?B?ajlucW9sZW8zbkdNOThHN0ZWNXliZ3kvSmNyYmRvcEY2WWdVVUpCMmJJUHlO?=
 =?utf-8?B?bElXcys5NDg5NWRRa2Y1cW40eTU1TDJDNlBqZklRU1lTWjUxNmtFVFdqK0FG?=
 =?utf-8?B?c2xiNzVsSFhUTXF1SXE1ak0wUE54c2RnSW9iQ0dzb01FTDg3Qk5MQUVxOHdo?=
 =?utf-8?B?OGl5YVNhV0laWTVVYnVNVDdhai9UdmhxdHNKalFxQXM4Z1dWNFd6Y0FUdTYx?=
 =?utf-8?B?NWVieXFzNkMyT1YyeC81NTlHOVcvNmZCd2drVzFKSE9DVG5MMmhJNXk4UlFu?=
 =?utf-8?B?eW1Sa3NsUGhxNSs1RWxkNlB1ZzhtTGZPanVsS3hWaDVyN0FXSU1zZnl2M2J6?=
 =?utf-8?B?cjV2SEczdjUxRHh2Uk5LbEd3YmQxU1hGTzFCTkIvT0YzQlREaVpOYURqbjVG?=
 =?utf-8?B?QnJnd3Z0YWpRVy9YRHNEc2ZUVkVCang5cmI4QWtxSkcxb0xDbUdhL1NKMWd2?=
 =?utf-8?B?RklnOWIxZDN3TVZnQmlFZExvOVE4emhVZEFmd0sweVgrQkIrTUxoZmkycTVS?=
 =?utf-8?B?ZEVoanRkelZGR2hwVjF1TTZ0R0g4QkxkTnhEUmFXbTFtZkF5ODAyQ2UxY1FB?=
 =?utf-8?B?Z2daekVOK0ZNVG1DMElqVDA5S25DeDIzcDFXTnNOWlhqWFRobWNmK3dELytr?=
 =?utf-8?B?Vm11MWplVjFGdjUzOG5yWW9TUzgvdXFrSThlSEJPZTI0dENIUmtid0laR3dp?=
 =?utf-8?B?NTI1WHdLZVQ5bDd2dzZpRndONXFXRTJsSGdxRENZK3JIcXNVUzIzRVdXSTZ2?=
 =?utf-8?B?VTk1NDc0RHJpSlNTcFlzNGsvUmh1S0RkQkd5SWpIa0ZWaTBiZU54QWVpak14?=
 =?utf-8?B?b3huUFhJNDlIQUV4U1o1Y2lqaDJRdkxwWGJaME94eUZtVVJGbU02c3NKYUJa?=
 =?utf-8?B?aXVSVU9oOGtmVnpQRU0rdVppeXcxUkIyWTkyQ1J5TVV0dUo1Q0FZb2JueFdI?=
 =?utf-8?B?NGZIZk9OeEdDZ2tqRVh1WkpZeDJZVDZvcEsyMklTZ0U4QVlDTnRkYlhFU2Q3?=
 =?utf-8?B?dlFZOWJ4ZEpvcDA1OXZ3dWpPRUo3SUJpUkRqVjAxNUtXZnNkY2JHTVlkQlhT?=
 =?utf-8?B?azhDbXVoVmhUTVBwODJpSmtaWlRuVHFDcGdHQWhSSzZCQ3N0dnR5MStDM09X?=
 =?utf-8?B?QXNMbVI0Y1pXUWl5bitwdFU5V3BoZnBJTDlFdGtDSDY2L3kzNlVpSTZ2ZHR3?=
 =?utf-8?Q?zOekEnmZZ4UHEI0QGN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88271104-831d-42ca-881c-08df194f2f73
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 08:46:40.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSV7X9T9/wrrZP6OXkgzkAZcL54qbeS/MtUbw3lrx1eYaGlPITvtaRG02ojN+oNk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929

On 9/23/26 10:32, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> 
>> On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>  {
>>>  	struct system_heap_buffer *buffer;
>>>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>>> +	struct cc_shared_layout layout;
>>>  	unsigned long size_remaining = len;
>>>  	unsigned long sg_remaining = len;
>>>  	unsigned int max_order = orders[0];
>>> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>  	struct page *page, *tmp_page;
>>>  	int i, ret = -ENOMEM;
>>>  
>>> +	if (cc_shared) {
>>> +		ret = cc_shared_calc_layout(len, &layout);
>>
>> You should not override 'ret' here, it was set to -ENOMEM for a reason.
>> cc_shared_calc_layout() succeeds resetting 'ret' and some further down
>> allocation failure, goto free will return ERR_PTR(0).
> 
> 
> Agreed. I’ll fix this in the next revision.

Please CC me on that as well, I will try to find time to take a look.

Regards,
Christian.

> 
> -aneesh

