Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF07C13D531
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159298; cv=fail; b=sAsyaYekCEKit3hWYNSMfCcjnywLAKEpAtVb2ms1VyJ5PZWxnd8KfonFxFRNKNQsuNzQVJtQVcARhHxRguc2o3ubHRAWLcNwH/LU3u1rFEHsmlzLp8MUFXLRDmOUQjja8gncCM7oqxG/B8ebgPNBtbZPfk/QTBe2gXWoB3vSAq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159298; c=relaxed/simple;
	bh=lZ1lp3ySlVij7JeEyo3KCTEPRKuixkJMAyaxfZJn2Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zj0vhKScSXuQQoCnyM5fqjP0JcvBYRFvYkySfTyhtz45HRA3FvpmD/930gLLMVodPAn+zD5GEXCMnEfTFB+WCWJGIpC+m6MJ2uouDV3lLHQLkIPuMTNHeS/nMX/xPibyVu/18Cs3AH5wOA4IZcsES+qco6bTlADU+myiudrEHV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y7wTCBcZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mGxeToVx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y7wTCBcZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mGxeToVx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtWvC016514;
	Thu, 12 Sep 2024 16:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=MCdr8kIfFgI1yqN
	GCYAP3ERAvx+9rzvAv1RqIeRh8cQ=; b=Y7wTCBcZe+egNjlodp1MLxckFBthzmr
	MLn7mdV2pYz9DVORUiyLiAccdSNqZ4TDVqECfiinQy7faa4vg0yYbj/cUFmPUs8V
	XI6k6WYFtu8prnQUk2L9x9/qQpkPwHm+BkcahkWDsPtxQHjSOOVu5qSxnyh1wC8F
	f9aclojOK7DGMhK8pRKOKffeEXGlqUAYktaeSKcM7k+Ydhrrq+uwu0tQQC2CYbos
	QTEUOmWaBu+G9S3By4ZM8SYyFFX3ddgELMcqVMaKv4Qw9UPmWq+VO2oNKoyqSrYm
	Ok+xkSvFhUTV0OkKILKOZ3TRdXqlwBGXpr3Hao9+g+ekjm18WTGlLcQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbuu5ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 16:40:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CFZA9p004196;
	Thu, 12 Sep 2024 16:40:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9bjmac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 16:40:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ob5xAQhsgaK+VlIRjV6AQbjBUggt+ahC3RB9CBBDz/d7rJ/Su0SbIVzn5TgRajPH2JVXVLPEJBBAmzB1ZfUvF5WIUwjqgnGtWZQ04Wo0ZFJTv0pqHh93v1LEb4TBEMDl3WeC3dmJ5Z6QdVXcxLjqkq7Ln5WnIVfEDglynU/OjtSuulz8q7uI7pShjihzgRabNGcdclclcnK2aNNnfVTBgEdswP5PP2Grqoi2YUNLPI/6M90xA9dcTWSZUS1gJZU8n3EGODe1zh8/ySL/Hbbqc92ZCaXJ6OYshmKWWbxk9O/i+CgCMdsctHRXgBLG3znGAvHace4bu66vzwx9eO0NsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCdr8kIfFgI1yqNGCYAP3ERAvx+9rzvAv1RqIeRh8cQ=;
 b=Vcisz3uj2XLhHuJ8Bsww+6RwRzY135CXn9DTRLQu/lZJge57+ctgiRma9FIn21HaLTyMqdbS41JbcO5CQ27y9jQ9/ds1VKDEzXFvpvIJMBtC6bHN4rR9xBKXqnF8KWzN9qa023jUXtSzIi0dU/vFlx4gx6SZzC/YNTd7mOMunBDB/MElSYnbF5hHYoidUX5OJlc6E1Ka3ne3wnqevt3G+8/g4ufcxkQIgG04El6shttdj/15dnjKPOYx1ayg49AasxdAh4Rjm6yyQ+DT1jb+5uMuS5FkR3rJHr9jqocTTw0SVHjdbcmDwz/3XgJY5ixvUUYGZZLG7Dwj8fG2sJ7zEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCdr8kIfFgI1yqNGCYAP3ERAvx+9rzvAv1RqIeRh8cQ=;
 b=mGxeToVxoGAZcaiHXhYybRZdxmY1jw0P+guC0IQuuJvUVNBYl305pyjq2oA3uXGaPYQx2JFWin+teoFcmXRARPYL7SHiCXNl39MAAsRfN7hQ/s2SMHejnxF5+esGxHsshI2Z3DI8B2ut75ozmaQEQ3tM1MvqHR1Ap/8+t5WNiYI=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by IA1PR10MB6686.namprd10.prod.outlook.com (2603:10b6:208:41a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 16:40:36 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%3]) with mapi id 15.20.7918.024; Thu, 12 Sep 2024
 16:40:36 +0000
Date: Thu, 12 Sep 2024 12:40:33 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Fares Mehanna <faresx@amazon.de>
Cc: nh-open-source@amazon.com, Roman Kagan <rkagan@amazon.de>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>,
        Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Fuad Tabba <tabba@google.com>,
        Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Mike Rapoport (IBM)" <rppt@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/7] mseal: expose interface to seal / unseal user
 memory ranges
Message-ID: <zghnfw2vvrvlxenzx3oi55hzznxbx2nhcuwfk5zpe42bm4dxzv@zknjtfa2fu7n>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Fares Mehanna <faresx@amazon.de>, nh-open-source@amazon.com, Roman Kagan <rkagan@amazon.de>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Javier Martinez Canillas <javierm@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, 
	Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Kristina Martsenko <kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, David Hildenbrand <david@redhat.com>, 
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
References: <20240911143421.85612-1-faresx@amazon.de>
 <20240911143421.85612-2-faresx@amazon.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911143421.85612-2-faresx@amazon.de>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT3PR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::23) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|IA1PR10MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 59880bce-9f2e-4d26-d6e6-08dcd349a102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bGVG5GbVoIdgzm1hRgc7choDwkt82S+oOy8C8d78NOB52xE1Um1ytNNaT6YV?=
 =?us-ascii?Q?DNb3ry09wHeMLsyfDH8m9+FeKhpaRJ/oi0eEtyHm9UIq4J6SKS2YUmQO33fG?=
 =?us-ascii?Q?7LQSFuXZSXZdvb/ncUoT3cj5DG1psKEHswy6rvEseUM5n8tKisIm/ZIOkmPn?=
 =?us-ascii?Q?AbQmo9AZUy+MIj/agWy1XRajgnE5je3g5G1YAVtHkYK1MS5M+iph83kRkcni?=
 =?us-ascii?Q?IQAIkyD0KdejmXsy81AAztYuHeFWGRN8stiWq7/9cIBpDO6u/wiNqLyifoLo?=
 =?us-ascii?Q?hsdkCVHu+04Vpdher7AY0FJNUln2rtlMF4jmZLPQPZPgIvukDUfEa1hDpe8U?=
 =?us-ascii?Q?dJkQ6xq/cF5SEYf7HN8IGxJv3otholtvenkaSv1aRq7cbPdPumHenBmiA9F3?=
 =?us-ascii?Q?m7bZW15rf9H77CieREnid7BXwyG5dKdSEw4ulY6prIUyHWv8rqN45ww30QQm?=
 =?us-ascii?Q?TMYEA6CeEJbDvc43NnQSukdLpiVhH/+1s6qu4e1NlGB9m3xU1l7i6O0NMO7e?=
 =?us-ascii?Q?PVrlp5Sy1r1CVBBHXP8vWamOmQmvrZuxvJ9jZ5I9CR9/n0BOVYPSmU+XiIvD?=
 =?us-ascii?Q?n3Hd2yj73CJ70Z04Uv8cEWFpft1rHsqR/ZvBNmSVQDpM9NEEhi4QWDVEMb7e?=
 =?us-ascii?Q?o0My/f75Z7NmKZJSYVdJHKHodcH09Cm8E2zFMDxHEJ5/1WCk0H9/NQOQivqk?=
 =?us-ascii?Q?rkK1C4hZHsM7206DPkD+0tJcndon1M2uZF96BooLQCwjDfXY/KFzLkNiXQup?=
 =?us-ascii?Q?dAFWYNTXtn+Czr0mM16maSWMna0yLD9vMOEQTS4+asP60XjnGPDyWIQfsdV1?=
 =?us-ascii?Q?+D3PvMzGfMJMaAPAXyd9bMZcCKwTQjJQMK52Rbhz3AvMmu+4KpyKsnoViJFO?=
 =?us-ascii?Q?rUqTHVsDVRcvZtDdrRrH5psM63Ns+dt9kX9PAdmqEDpAQ6BmChzmk1MYgE1a?=
 =?us-ascii?Q?hEuJel7bqox9mNEfANDqGb/JxLGB/jTXXLK5xNVxjhkCEeddJH7wlqzl7GCw?=
 =?us-ascii?Q?dTxwhsygf9k9vu7+SJCOA8VYBJiEqbmOlFXcE5zpg+THSZNOX7f0U9MGWdLS?=
 =?us-ascii?Q?d91MrsWCq4Ou4l2GKMVb/S1tDQ8c5zHQPV90PafxgP/Ku8dXTQbeZ//s+Rjr?=
 =?us-ascii?Q?1sI7ImujfLQpjVPfCBC7ocrVJyXyWoD7NVZ8YVs8uUqF3FYhy68XjNy8nrKk?=
 =?us-ascii?Q?ej+LeyxwodIPAEt27DJrItWRCrorjwOIbCsbUYZZVyNLLWn2KgdmsQ0bO4gN?=
 =?us-ascii?Q?gI/OP3Te3EhUaXU9+k3DiMxJMPxR7Jywd9DD3uX757ogA5avtZHkWTPNFoxa?=
 =?us-ascii?Q?I6A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MIbGCeRk6rYv0UJjvjgXCYxJuhULBp176WY5huPGvOqMON2BbRnB5lRh0Sc8?=
 =?us-ascii?Q?yOY72RlIXgrjL15UBoyspfsUXLhRdSkcd3wg5GTVKBNo6p+CuSaHcELtCFJI?=
 =?us-ascii?Q?7APXFwLMBLeP1L8eE4UqX5FqnjsDqSzNSv4RogddJIiw1PbAya2Vt8YfvtaT?=
 =?us-ascii?Q?xXtq1wDFAhL67zyqorWRaxn14ZUcDfBlwhQWPbE+QC46o3PSNgwXJb12cYNr?=
 =?us-ascii?Q?c0FWe30WjRvNYamdK6WdLKHv2LDOKEI768IEnqhizmY2TWqz80vTqkctd/Aa?=
 =?us-ascii?Q?yemKeJ/0cn9VOoUykGOc806Qnce67+TIHKDL2HLZEIRYGA7114+u572KP1LU?=
 =?us-ascii?Q?EYNVemMi0Ah5lzShntfa7Ur5DzQe+BTRG6q1F2Db5EHZw8t6qS13Zv/chm7u?=
 =?us-ascii?Q?Hz2P4wNGKZR2B8ZUgTZnij35JprZenM6D5+Tbwsv48VUtpS689ipOV+i4LKQ?=
 =?us-ascii?Q?GsH+1oRZ+H5KWOhrLztdg3t5OIhCztrJqjMPG8/cYxTtv10/TeqqyeCphGiA?=
 =?us-ascii?Q?x3ULZRVxd9AUkitQjuQwCh+QchMgQXVFs6PyPey4mgF/9f7/OcbE9XODZlNo?=
 =?us-ascii?Q?vZap1Zac3nVWFmT4hFxiAGbzuHZbVZQtuuoOeGPqm31nEZptcsXu9b/j2wUy?=
 =?us-ascii?Q?Yg6t/V8d3qBgaUbxRTkbs4szJjK0+KVoFZBgZ4f+hR2br6A1VPZtjwxJ/sI+?=
 =?us-ascii?Q?wMn2ysfwXmDYJWmLc3sdkyy3rULoR5Ww+/MgWyX4hS0gXI+w0+Lmj2xmwCp0?=
 =?us-ascii?Q?VcNDWls7+8yraYE77g8jg1SkJ4OOHahzq/wdaq9bppNmxMrsbIZeIjCNNC76?=
 =?us-ascii?Q?rfXqgmC7PFZyjTqy2splvDDTf72Uk/50LFrJ93zjD/84XiuLLQMTBfyPwVE5?=
 =?us-ascii?Q?xdRUa6fKGYP/XFgZL3zadjGYL393UQwIWdZhUYbKflMk9S1s154BSA+fDpxe?=
 =?us-ascii?Q?RVhCbo5GccoKeogDRIXEkjIqlsQCXXwL3AAh42k8Ap7x6Y6HFEEAaP/rhda1?=
 =?us-ascii?Q?X4UlGvBXIDqij+G1veXZfgUwWEcr5MFnHbbO8QHz+BoJFbrrDSBiOY/C8UW2?=
 =?us-ascii?Q?UWtugwezv3Y9Pnmz68SrfBsuLby+Oyijhrg8pMBhQZskpT2viGJ9CSHN7eKH?=
 =?us-ascii?Q?ZGXXmQadBn/eZeoBarY32wMrcGsftqQOq7pYjF7lPFX1HEr19+mlDWmHcw+f?=
 =?us-ascii?Q?HZJXcumusVm1aDlmhwYO34L1m0lM4MtzJORFcfUENzKhV3h7a1gkWgtnGCh+?=
 =?us-ascii?Q?XTYl6yQVmyg2G4F8S+mZfl8Rps5KD6wSHxIu6VSEre+J39JjXdLn+VkMb89M?=
 =?us-ascii?Q?U6rJuCNWo+F3Q4l2qmd+HdmMxzscYQokMy1QeFyZ8JsPvB1YPRFshmC0VwGD?=
 =?us-ascii?Q?gRzg2uuja3WZ6PvL5M/8j8OwURTq/YEH1A0ZQy0iUdA0SiJmFg7xfvpp023u?=
 =?us-ascii?Q?WeOoofZ16kChL4z2k2g+PyoWtexkO2sKD5Xoutr3yQmsBa07c8Mf4ZuAjwMm?=
 =?us-ascii?Q?bMn67Yd46Qv19Lq4Nyic+MMABffwaYRNims6FG8XbmHwFHlB0LYb92HyprIw?=
 =?us-ascii?Q?4tAESjenDU04pegon6MobIPQRe5iuQA3uHq8Urox?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5QuJixcx+/R4FQjvwmySHQkjC/0h7nSxOWq1aa6jI56pby+aYv+6yT8vm9cuD2f/xIT/9DOPZ+3/taAQSW2Ns8fr0hxKIU6cPJlwv9OngEDkXsVFGd3oRqyyBn/aGQkTL8+qymkCT06pebXhW/WJtMIDCS+rQX9Y5XrLyljl3KjgBSQwOtoAcC7YscG70t8Yji2kuyGJMMXBWqj0O7kz8nMUeaIznrk2TVl/u3x+sz28Wv9vi0l4qhY8FjAVTeGp27b+qaUjcfzdod7tNAkr5PKqugo9RyRp0GSGtAGCGej+RQs30DHbqSxv1/V2CveHiHy5kCxTxcSIfaGQKb8EIfUz/MNld5gpuzcpPd2Lk4n1Vb+kQ+m/8Ir3X3RWPlPchd8YYghbzFjgrGHZC6cM8yAxfAuIj1IJ86O6pNBLvaL4xaqlMy1XijJFKrHkPyzp1JcVaeWW42a/DrZ+0gQqo6Px8eS4OctudYhfbeISmaFAay0MFE7Gg+VUmoAMDrLyq3WA9RkmKJc0Kis/jNE68bAAIZ84CfcikLJ3+NRMqGiBxbJiay6sOw2MwHgcGtdW21BGy8AOzIK0D9mnKRcBYE8G2WCSc1VcYU4KcYG1ANQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59880bce-9f2e-4d26-d6e6-08dcd349a102
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 16:40:36.8741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKzUXXIc8OXOwfsKu1De1EDA7HRrWMnD/J+7miuWnVyKbRQHBGOsUbtzPvGQcdxAeWcdkGft0hHl+cK+wdDnXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120123
X-Proofpoint-GUID: VRHdCGhaRk8WYliaa6pJUKXmPKY0wxCV
X-Proofpoint-ORIG-GUID: VRHdCGhaRk8WYliaa6pJUKXmPKY0wxCV

* Fares Mehanna <faresx@amazon.de> [240911 10:36]:
> To make sure the kernel mm-local mapping is untouched by the user, we will seal
> the VMA before changing the protection to be used by the kernel.
> 
> This will guarantee that userspace can't unmap or alter this VMA while it is
> being used by the kernel.
> 
> After the kernel is done with the secret memory, it will unseal the VMA to be
> able to unmap and free it.
> 
> Unseal operation is not exposed to userspace.

We can't use the mseal feature for this; it is supposed to be a one way
transition.

Willy describes the feature best here [1].

It is not clear from the change log above or the cover letter as to why
you need to go this route instead of using the mmap lock.


[1] https://lore.kernel.org/lkml/ZS%2F3GCKvNn5qzhC4@casper.infradead.org/

> 
> Signed-off-by: Fares Mehanna <faresx@amazon.de>
> Signed-off-by: Roman Kagan <rkagan@amazon.de>
> ---
>  mm/internal.h |  7 +++++
>  mm/mseal.c    | 81 ++++++++++++++++++++++++++++++++-------------------
>  2 files changed, 58 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index b4d86436565b..cf7280d101e9 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1501,6 +1501,8 @@ bool can_modify_mm(struct mm_struct *mm, unsigned long start,
>  		unsigned long end);
>  bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
>  		unsigned long end, int behavior);
> +/* mm's mmap write lock must be taken before seal/unseal operation */
> +int do_mseal(unsigned long start, unsigned long end, bool seal);
>  #else
>  static inline int can_do_mseal(unsigned long flags)
>  {
> @@ -1518,6 +1520,11 @@ static inline bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
>  {
>  	return true;
>  }
> +
> +static inline int do_mseal(unsigned long start, unsigned long end, bool seal)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #ifdef CONFIG_SHRINKER_DEBUG
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 15bba28acc00..aac9399ffd5d 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -26,6 +26,11 @@ static inline void set_vma_sealed(struct vm_area_struct *vma)
>  	vm_flags_set(vma, VM_SEALED);
>  }
>  
> +static inline void clear_vma_sealed(struct vm_area_struct *vma)
> +{
> +	vm_flags_clear(vma, VM_SEALED);
> +}
> +
>  /*
>   * check if a vma is sealed for modification.
>   * return true, if modification is allowed.
> @@ -117,7 +122,7 @@ bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start, unsigned long
>  
>  static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		struct vm_area_struct **prev, unsigned long start,
> -		unsigned long end, vm_flags_t newflags)
> +		unsigned long end, vm_flags_t newflags, bool seal)
>  {
>  	int ret = 0;
>  	vm_flags_t oldflags = vma->vm_flags;
> @@ -131,7 +136,10 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		goto out;
>  	}
>  
> -	set_vma_sealed(vma);
> +	if (seal)
> +		set_vma_sealed(vma);
> +	else
> +		clear_vma_sealed(vma);
>  out:
>  	*prev = vma;
>  	return ret;
> @@ -167,9 +175,9 @@ static int check_mm_seal(unsigned long start, unsigned long end)
>  }
>  
>  /*
> - * Apply sealing.
> + * Apply sealing / unsealing.
>   */
> -static int apply_mm_seal(unsigned long start, unsigned long end)
> +static int apply_mm_seal(unsigned long start, unsigned long end, bool seal)
>  {
>  	unsigned long nstart;
>  	struct vm_area_struct *vma, *prev;
> @@ -191,11 +199,14 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
>  		unsigned long tmp;
>  		vm_flags_t newflags;
>  
> -		newflags = vma->vm_flags | VM_SEALED;
> +		if (seal)
> +			newflags = vma->vm_flags | VM_SEALED;
> +		else
> +			newflags = vma->vm_flags & ~(VM_SEALED);
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> -		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
> +		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags, seal);
>  		if (error)
>  			return error;
>  		nstart = vma_iter_end(&vmi);
> @@ -204,6 +215,37 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
>  	return 0;
>  }
>  
> +int do_mseal(unsigned long start, unsigned long end, bool seal)
> +{
> +	int ret;
> +
> +	if (end < start)
> +		return -EINVAL;
> +
> +	if (end == start)
> +		return 0;
> +
> +	/*
> +	 * First pass, this helps to avoid
> +	 * partial sealing in case of error in input address range,
> +	 * e.g. ENOMEM error.
> +	 */
> +	ret = check_mm_seal(start, end);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * Second pass, this should success, unless there are errors
> +	 * from vma_modify_flags, e.g. merge/split error, or process
> +	 * reaching the max supported VMAs, however, those cases shall
> +	 * be rare.
> +	 */
> +	ret = apply_mm_seal(start, end, seal);
> +
> +out:
> +	return ret;
> +}
> +
>  /*
>   * mseal(2) seals the VM's meta data from
>   * selected syscalls.
> @@ -256,7 +298,7 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
>   *
>   *  unseal() is not supported.
>   */
> -static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
> +static int __do_mseal(unsigned long start, size_t len_in, unsigned long flags)
>  {
>  	size_t len;
>  	int ret = 0;
> @@ -277,33 +319,12 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
>  		return -EINVAL;
>  
>  	end = start + len;
> -	if (end < start)
> -		return -EINVAL;
> -
> -	if (end == start)
> -		return 0;
>  
>  	if (mmap_write_lock_killable(mm))
>  		return -EINTR;
>  
> -	/*
> -	 * First pass, this helps to avoid
> -	 * partial sealing in case of error in input address range,
> -	 * e.g. ENOMEM error.
> -	 */
> -	ret = check_mm_seal(start, end);
> -	if (ret)
> -		goto out;
> -
> -	/*
> -	 * Second pass, this should success, unless there are errors
> -	 * from vma_modify_flags, e.g. merge/split error, or process
> -	 * reaching the max supported VMAs, however, those cases shall
> -	 * be rare.
> -	 */
> -	ret = apply_mm_seal(start, end);
> +	ret = do_mseal(start, end, true);
>  
> -out:
>  	mmap_write_unlock(current->mm);
>  	return ret;
>  }
> @@ -311,5 +332,5 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
>  SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
>  		flags)
>  {
> -	return do_mseal(start, len, flags);
> +	return __do_mseal(start, len, flags);
>  }
> -- 
> 2.40.1
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 
> 
