Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439D0517BD4;
	Fri,  4 Sep 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788553399; cv=fail; b=WfTvOOaf3Qhs/YvzwPjmr82UCskHZoJxYa4x5GukqwmrJ7YhCvpN5Fi+Wr3aDtWKut5N8sKnruPnlSd3g7S7i/fumMtMzYedDExY1qXR+QI8XCmVa1kC33ewBlyB8s3pSzOm8Ask/DwfzO4UREWrRwDlIcTJsJxoqtI0CvasTBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788553399; c=relaxed/simple;
	bh=OWpQR5k3W3EOJJgRsx33e1z6moPbCTLLtYgJoTy9waI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rJBRsWQqIPsJWLVZhgUkw8c+v3KgsrJL5jFjEvQoOsE7KtGiJFRsEnsTnsHobiNLtdaoya2csmZFMMGArz1M4kUJg8nZ5v159ZjV01qkBuPNh95LTjLwTA51AYTV82y5SLGCn6rUPoDdUaMX3RbqvH3L9Wq9ZR20EEiCux44xOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ClYDhHiN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P45AGGkf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ClYDhHiN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P45AGGkf"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KN84O3548185;
	Fri, 4 Sep 2026 20:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FB+XofAgvq5IGYFbvi2slBGU1hjWQtmpjDXaLoS5ku8=; b=
	ClYDhHiNDJ3taUqFVbJZ91vfdEWWSEOhI75u2LQL95Y/SIYoxVUMqahUVN4fs8qq
	exD09fqc1AyhadI6rWiKLWtP3YKiLnF3T9bDHRw0Zxw9w+n4kX9FerlAbxYAniRq
	xkR4VVfTouTNNi9nyciPRUy0tblViRX12Y9jPERlnRJTGXvTgFVCgyZdRcqQaTei
	N0Srcwiu1PmPR+z7sAe4BZuudV/P0QdlLDKCf5ZiaxjgWiclEIxSbYeV0l84SH2D
	s5zndUOB0HTISXz4xrz2JdKkdnAZZ5hs+oA2wJFPwkZaBe0d2njDApjRICZ6pOjS
	SutkE9GFezuc9+r1LdKWAA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0y3eb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 20:23:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684KKWWW006787;
	Fri, 4 Sep 2026 20:23:06 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gdymxgvpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 04 Sep 2026 20:23:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AeX6axHctMGJOvH2/B2McMgT4ypBMsDwvf4wqWp5gM2p6clzvX4xZZvhC7YBX9pSse/JAMDl6f6RwAq/BTqlXHckht7h7v4itTg5UWTsewTcSuGAkHKsl73HGUYR5vTvwx7xQMVcb+axnR0k519+bA+fTaG2agqH/F3+y+hs4lwQph27hYKD29iuvZBCQ4Zb+nM4RjqpZOs4vsaOgYOH3CEU0rChD7l2l91P/yoEravqpeRr1IPSCcb359R/QeRdmmdogx/4+OdtemNv5OQ6DV1o773I/I/2puov7KfR8rZGOdM8+l9n0eYw6SvNOcsTyKrzXd5CktvFYIYTafmNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FB+XofAgvq5IGYFbvi2slBGU1hjWQtmpjDXaLoS5ku8=;
 b=JSzt7MEB6M3h5YVWbfU2SOU5TBLFcY4GdkN0zpl47W7DLmh63C1jymNEXcvY3vaEPsITLH7xT9S7K8Ulww2hJZki3hj85JtTKME35pCiQ8KOX+wPb4IfsIpCRIaEQZFIunYYH6g8BHQr7f7KqJsfsd1+32MoVZwir2meljOwVVyW2cjiqA09nlTk89u0pWD3UramDTD/qyVmqH783l8SvYNBLxqOhwN1u/ZqqfvNot48hZtMKCJyUudDHVDvzGxQdaQEtk8fzuogFpCxkIm4cx4CQi6q0nZ5802TuBYv6D9QXNmuX5bxwlFq9nvVo+Z+va5SJYIs/Uj+EZigfzZoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB+XofAgvq5IGYFbvi2slBGU1hjWQtmpjDXaLoS5ku8=;
 b=P45AGGkfhCNy1R0JmNXe5gTA3CB8sp4vI5bsT2Wk4+ISUVmQ3QQBElFc7zE7p844iZSzmZLzcXbdDvm5LCyQ2ZdMdVWoeCCFSdJKwktWpyRp/TGa1T3yYT6zOiyb2gpyFGiA5xG1Bs5nFKeKzl6jZX2XayK4QcM7ryFnwxkXRDc=
Received: from SA1PR10MB5510.namprd10.prod.outlook.com (2603:10b6:806:1e5::6)
 by LV8PR10MB7799.namprd10.prod.outlook.com (2603:10b6:408:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 20:23:02 +0000
Received: from SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96]) by SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96%6]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 20:22:58 +0000
Message-ID: <1dabaf16-f5e6-4a84-8339-742764f879c3@oracle.com>
Date: Fri, 4 Sep 2026 13:22:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] KVM: Move last_steal to common struct kvm_vcpu
To: sashiko-reviews@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
 <20260904175550.430266-2-dongli.zhang@oracle.com>
 <20260904180715.E5CD51F00A3E@smtp.kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260904180715.E5CD51F00A3E@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::6) To SA1PR10MB5510.namprd10.prod.outlook.com
 (2603:10b6:806:1e5::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5510:EE_|LV8PR10MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4b86dd-5d2a-4636-e906-08df0ac24f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|6133799003|22082099003|4143699003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	5q+4ZTGRqt2tGpzrVLJszEs4uSLPhsYpbD1II85o3+hNqiRPnFWW4qQaKhLvG83TI07GzyO0D/nUP5dEsXHBk1jaibWptvLgpF9FxYcMKddAAkdb5BV/5CFnpTh1ghDs2AngtG3Y4nfFF6gTzkn59kN31vg/kC8MSEOHcMSGo7jfwRML6CjB2zxxikcPEzb0edLsFmpRcfMFhWS9x3nY7WkpUfVnn+iBJCKcVsn19U4ZY8XT9cS4+b/UaeR2188r5FGMYLYCr1JEgGgSDX/UauZe5bRitNDZntFf1i5fibEMC93ftGXmuThY599rQvXskEdrDcmkpckSzgYATvjioTYgem5SyIHx8f6UqLwV5Qgi0CdNmk6JA8ZpfTe5jZMqLqvZkkIvD4K6YlKouLHSGB+L5JD83QOOLmxMgMh4ciDHA1NHyNXJip4hETgmOwXoilqcYenTdG882Rd4yjJb+KJBeJPnHbAngI410PNyE7aEWthVnAM1qQ80HDJBn28IZcydhbTKTw76vCEoudjs6A1zvWVMBQPSEQSPcQf0go9zx+DjSRySkcnXYyBdaJk09+3H3aa5Qko6nOkgtVL13DjvW1/5I9L5UP9ETN/QpPooBW4KKQk46l0f2eWwICXNLeOw0eUulmMTxk8n3Vxu3wB5OMcJIVuImFjMhmC6l2A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5510.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(4143699003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGNVYW9IZW43UTFWS0REMnpWd0dudjNMYnhpWm41ckZEamJpTGozOU9VVkVH?=
 =?utf-8?B?NWdaNjRqSDZQajE2LzV5WFJ0VjdVOWxvbmZONlBDY1l1dDdoZnFkSUpNdnRP?=
 =?utf-8?B?SFlndmdnQkJEeUNabDc5K1Q4OFptdlpPdHMyMThWV1FCZitxNTZkZFJwMkRI?=
 =?utf-8?B?MDVQR21HS2FNUkszUU1ES3dWSCtTdlNtZjQ4b3VsUVVzRE0yMGQ1Tmc3UlR5?=
 =?utf-8?B?Sld6eGVmSkR1eVNGdVdnRnFZaVZYNVk5SXljeTNzcjdJMXhWTGRQa0RMVHBz?=
 =?utf-8?B?eFlSRExSWDFjZHpmSW9VQXpicW5kbUozZFljN3pVa1Y2LzNWTDhadURCbE1D?=
 =?utf-8?B?TG13T001dXIxbEZQelRLb2Z3YmlqaVp1bXhpbGpBZHBXdDVpT3R4NldsU29w?=
 =?utf-8?B?Z29xc0tVeFhySTA1bE1kV29NVFVFcUViOVZEdjhrcCtrRmU4RDR0YjJpRzY2?=
 =?utf-8?B?VFZYZ0I0ZmNKRFVMNEFrQWE3eFdCZitrT2xTdWR5YjgrY0tLNVp0NnR5emdw?=
 =?utf-8?B?RDlNSXBVZ1VHaFpta3hlOTRUVkR2MFhPL3ZIV2lnV0NYb1lKWHl2WUhWV0hu?=
 =?utf-8?B?OXVNQVBGV1ZaNTl2ckg4MlhWa0pVeHBqaHFWRnhOQ2JRY3VhSmVERzNsdFUr?=
 =?utf-8?B?L0tBMXZ6dnpPWkRxWHh1cmpXTXE1NUNwQlUrR3JvSWRpemRuTk1zN2dmWFB1?=
 =?utf-8?B?MGFiNk16dVZlN1prbmtrTlhqR2luVmdmanNYN1V3aGFPWXVtMm91dEZaaisr?=
 =?utf-8?B?STI2NVNHOEY3K1BhcHFZN2V4TEhIUXBIYTVaRE82Q01UVzkzZldYN2s2NXV1?=
 =?utf-8?B?M0cvQ3V0ZXBSK0FLdEVmc0ZFOHIzbW1MQTRFVXRpNkg2MFUybGc0UXRFUHBp?=
 =?utf-8?B?L1RvUmtjYnJId21iNTdGakdERVk3eWhjdHZuN2lNQ1pzZ0w1aC9JRDhZTjZF?=
 =?utf-8?B?VlhNTitvd2NIbDYwczRKMmFJdDFMaW5pS05OK0x5cm0yVzZWT0RPaEgvRVNE?=
 =?utf-8?B?SlRRRTFKZ3J5bzhlanpkY0VaY2pYY3QxUXJoRE9LRVFuUm9VbzIvekthcHBI?=
 =?utf-8?B?UEZhc1ZEQnRmNFg5elpJMU5ydE8vN2l0UExWTHdRbFN5cFR3TEo0bnA4eXVt?=
 =?utf-8?B?MG9FMndKbUMxVTQxMnNnaVQzcjdOd0VwdGI4LzBmS3ZlL0RJL2QwV1c5cWFs?=
 =?utf-8?B?TDVPMTdkUnYrb09tOG1kOEFkc3dqdG51OGwzZDVTRDFwWnphQlYwRTJtVG9i?=
 =?utf-8?B?bnpTMjBuKzR6a2NoczVZRy9SYmxYSnAyQlpka2F2bUYzL0EyKy9hZ2p3SFhR?=
 =?utf-8?B?bXg2aFhyMGFqWWVkcEtSbHJTQ3hmTXpPR3QrbDB4MHFkRFZ1Z2hqWDUrMUE2?=
 =?utf-8?B?L01ZNjN4cG5zM2lmT2NxbldpNzdMT2NIeEdlOWdrQS92VmQ5QW10dlFFMElI?=
 =?utf-8?B?Q2U0dzVrSWxyQjgrMmo3Yjc2SlBuV1FlYVFLZk83Rk5vVG1NbVI0N2ViclZp?=
 =?utf-8?B?cnBSRlExQmtpd1VsQjB4emFNZ0gzRlNmM0s0RWdaREhRRE80U2p4L1V1UUNE?=
 =?utf-8?B?bGxla1pRejhpdDdmN2VzajhSUFdHY1dURTBGZXprOERPdHlDR0VMeVJVd0o1?=
 =?utf-8?B?UmZ3YVpWaStEaklFT1lZRkdpSkxJdWlhUDZJZ2R3ZFlCMVZjQjVOdXE4REhW?=
 =?utf-8?B?Z3RCOFQwWXBjRVF2MWk4UXdFWW05TzMzVzlmVnlTMmdMQXdpdlpWSzBaUTJi?=
 =?utf-8?B?ejBqQkVVcUZFOUNVbFdUOWhPRU9KNXZRbkVqbmErV1ZBM3E4SjQ0N2FuQ3Jo?=
 =?utf-8?B?V0QxRTJQd1FFVUZIVlFqQnVYVlE2Ujkzd1FORy8rQk56dE5qdmVFUnl3M3pr?=
 =?utf-8?B?STN4SHlxUDNnL0lUckZpMlRuUEpUWWlURitJZGgzd01vc0JWZ1ArNGsvWEJt?=
 =?utf-8?B?RS9SRGtZWTNmc2VQUHNFelVQcXZyeUhTM01zb0VXdCtsaVJGYTVoTTFGdGtu?=
 =?utf-8?B?S1lKTmVnVnJsd3ozN0cvVkNJVit5TkRTaWtoWGxpbHhnZFNmYVlrcERMS2xQ?=
 =?utf-8?B?YURaQWVXZVJEZ2VhckhXWG13VkpwWUNBa1g2VFROT0M4WGY1aTM3WGhLTVAy?=
 =?utf-8?B?MHlLcllFYjNnMUZFTm5rMjA4anBMTFB0YzBJRit1N1dnYnp3cHFUZTNTKzU2?=
 =?utf-8?B?SmdpQS9QUWFpV0FrNWhFM0JoYlVIQ0FUMDVQeVZsdG1aSXFWMjZRS2NNL0lp?=
 =?utf-8?B?SW1VK1VYeHR0eW12d2FKWlN2RVJYTHFYc054bVdnTWFrRW5jQmt4ZUxucE5w?=
 =?utf-8?B?anF3VHVtdlY2QnJKWG5tVGZGb3pYSXNRTjdmbEx3K2pVVnB2bjQ0RGdITFZu?=
 =?utf-8?Q?iCDoC2TuLtzl/lSc=3D?=
X-Exchange-RoutingPolicyChecked:
	CtTOUsKS12z7H3EJwBROvfAWdW18Scnk1SIyNBiTWO7QMhO0BsXIHaBXkVZcV8Wkq4TtRyOYD7SvzQxFFGZn7NY4SNYtKlFqc2OgWVidNDZdpOomKqcFXaNUNmgSSbjJe3dz7uDrRszuQTspmj55jtGyu2wwPk/hfQjSfS0bOaKmv4KCER2+DZzUx882JRuMKKF/wizSOMEyQEg8X11XJMxgCCqrNsIL1qY2uCzAqCliY4jFLFtbskpj8wrbHsLuze5+GAQWUvjmtNsxmorJ8+jY/mFiYtmjyo0n8Srf9WomfPlipPiiLIRRmrk71S8v5zC+oyHOfLJFjmOan1Vc9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fB4l9+hsDDQhUXuNNktQ663Z6sP2k0aFpQkknb0tWaCKQYytO7zB5Y40auAUCQZGx7q0iyfCP3eJAZQzhEZopePVqwHYJ36zD3DGAQIfnCebMjwAyCYMSit9pFH2Oa/11DJetaoAOh3Oa+UDA273gSZe20+lHkP6gXqfSo/kJe4OBsP6kNFeROZxlYPLvndhVCvq0sRq/KafDaau3rPsWIXAWQepT+sSCITl5QrGFT/YUT9BLVEqwLwu5eF69WkoK4FVbEZZ5Y4Yr/ATUNdMyoJ8PYCtLRa9DLfnQWMoCNMlUol+RO4Jnf74LYxZFtzmGkr/5osGA7/nCa7l6C2FtwBiPI2jEpIwiC5OuRqOcmLAwWkSF1DiSHU1tBxixbBXUkouPduXCxNuv/+q2yXUZwEVnIDLPo9tWw5jhv0RywH8nZKCpYU5rmcngXkXctmr2Ri07bEJD1Q3vm0xnoiwRP4K4XeoNe2wX7Pugf7pcfCSu93VQbRNO2A+3i3Ft48d+ONOWkvqK1+C4++/43VKomQoYpGly/NOuQ3F79VcDnVRz3AEseGkw1mGPKSsO2lrMvVAglbTu69XxIuecL19gazdcmRnzl+pHGcQaZLAbWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4b86dd-5d2a-4636-e906-08df0ac24f37
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5510.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 20:22:58.0324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PIlhXIur5G3kaAnSleTqQiMfceUfgMF67E/A7okQuVYLhRXhGeJ2c6jNscQobXp0pADc1twM4yZWYGXTKKltg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609040187
X-Proofpoint-ORIG-GUID: rm9W7CVWO-9UHgdZPKemu5C5oq_awQXX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE4OCBTYWx0ZWRfX0jS2Y7wc/7an
 FFjs5VwnXxo6dax7mx+gGzH+ur43RifcybKRfuYlm5yXV7k1Pyz+LAG39NOf4S9cdOYS+JfEllU
 KxN6MvrsFohjQFvEpkmGhfQbxLVnK/jQY756sLKRZHs4k01DUYxTnJ9HsdvzLPz3uYP8BR1VrNv
 HP9lhTQFALNN7vecQm8EcufYkWSlKMQUU4quWEoOe0pvQING2bwGAgi23EaZddmJXVDfKDOGltM
 WW3qmnO3OnUZuCX4yNGKpLRC+xsLiC+U9zlICcuN1BwvqIH8K2z3a1ARG38EOVqAaeAq/rbfnma
 1Xzav33V8icoddrb0J8+TI/MLPIn6JiMQNxM8YTfxgDS+Ow79F1aBuY9yIeJA8hN7e4oUx9uJvA
 KzHUR0YMqrX3zdPXtERrP+t8cBjJZPtgtCoiawVwFB+9gfcEkoP7sXJYqMOsrrjWkMLlnFj8kbv
 4qLPD1UePQR5hxoRurHBw74w+9usBbUdK4YINbxU=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a9b28ab b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=JfrnYn6hAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=7dML8BQ_qRT_jEr4EVoA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13521
X-Proofpoint-GUID: rm9W7CVWO-9UHgdZPKemu5C5oq_awQXX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE4OCBTYWx0ZWRfX0oshIGhcpvQo
 ByHqdEGR9bSCFjkNwwgxbztusq7BV+6abRfQuly7kUcDYkIfeijipr6cIWxNo+Y8Cnl5Ht54lZU
 55QaV3H+M5SdtgnDJzM8nMUlosm77Mxmny0ZBYInm1r84PYcThtD

+ kvm-riscv@lists.infradead.org

The issue reported by sashiko isn't relevant to the patchset.

I don't have risc-v KVM host to reproduce this issue. It looks can be reproduced
on purpose.

Thank you very much!

Dongli Zhang

On Fri, Sep 4, 2026 11:07:15AM -0700, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Host-userspace reachable WARN_ON can cause a host crash when updating guest steal time.
> --
> 
> commit 8f2f1662b1b75cda859eddacb4ef288871960d3d
> Author: Dongli Zhang <dongli.zhang@oracle.com>
> 
> KVM: Move last_steal to common struct kvm_vcpu
> 
> This commit moves the last_steal cache field for the per-vCPU host task's
> run_delay from architecture-specific structures into the common struct
> kvm_vcpu. It updates x86, arm64, riscv, and loongarch to use this unified
> field and introduces the HAVE_KVM_PV_STEAL_TIME config option.
> 
> [ ... ]
> 
>> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
>> index 60e50296a0085..9a77d3bde7c72 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> [ ... ]
>> @@ -67,8 +67,8 @@ void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
>>  
>>  	if (!WARN_ON(get_user(steal_le, steal_ptr))) {
>>  		steal = le64_to_cpu(steal_le);
>> -		vcpu->arch.sta.last_steal = READ_ONCE(current->sched_info.run_delay);
>> -		steal += vcpu->arch.sta.last_steal - last_steal;
>> +		vcpu->last_steal = READ_ONCE(current->sched_info.run_delay);
>> +		steal += vcpu->last_steal - last_steal;
>>  		WARN_ON(put_user(cpu_to_le64(steal), steal_ptr));
>>  	}
>>  
> 
> [Severity: High]
> This is a pre-existing issue, but I noticed these WARN_ON() macros wrapping
> get_user() and put_user() accesses to host-userspace memory in 
> kvm_riscv_vcpu_record_steal_time() (as well as the sequence_ptr accesses
> just above this block).
> 
> Could a malicious host-userspace process trigger these kernel warnings by
> unmapping the shared memory area or protecting it with mprotect(PROT_NONE)
> before this function runs?
> 
> If the virtual memory area is made inaccessible, get_user() or put_user()
> will fail with -EFAULT, causing the WARN_ON() to fire. This allows
> unprivileged host userspace to trigger a host kernel panic if panic_on_warn
> is enabled.
> 
> Would it be better to handle these user-memory access checks as normal error
> paths without the WARN_ON() wrappers?
> 

