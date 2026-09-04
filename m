Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4151FCC6;
	Fri,  4 Sep 2026 20:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788553660; cv=fail; b=MDOghRxcchrDdDpRviDiaWRUO4dzwNLrzbazC3zmFdY9yJQbDel7z+p4cPYnE09oXcUBELlqIOhTHFlFBsfxyeNsyINDGqnxtUAg4rTYKhdxzmKvPO6jYILO1YhSC7dHdjSdeMFz0hQ/T1eEJllWcvjyrY9paPyQ/B3rR7kRNog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788553660; c=relaxed/simple;
	bh=x40rtokeGbQVuhGXzc36rCsP06uN0tL4U4Pf7XAVoQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DEl2SuYOI9AX2gx8aH1zyjGqoZ58oFi0WR5SmXHcgoB0txNXaJAbyc7sNsMLe7ArpO7sQb2LWQGOQj5jHqYJXM/ZuMwlFmqmP+CdIQmAri7ysihMksv+j0t++M7h5R9RMc2S6f5wpLryytLfk7Z6B0ZOyPxpLzZBK+VPYT6fDaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dNUG4s5O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sEaY9AeK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dNUG4s5O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sEaY9AeK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KMeLv3490572;
	Fri, 4 Sep 2026 20:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LJpKZx4hKoVtQw6nDWiZk1lvSMhpA6J0gWbn73n4ANw=; b=
	dNUG4s5O4R+q91TFrL/l5PUNEHZzk1A3clzN9QNJTt17jXBy167LAaZv+0AAyfeM
	3dDTckLXD3RqCX9EtDr83+Qk9nYBOWSSGWscMkyKCb0nIgTZAjG0Sx3zYeBthgus
	mJT8nG74WBVAmOTh9RwriBQExSNUnfJwNJSRh8P5Jk0xietN4qnHEJefFGZiFMAY
	DQP72WuMroDy+PUkwsPaHgoGeGeY9hlpyoQ8u6Rcy3fYFcvPrMI9+KEKvLgA4Urp
	Q4I4KN4P+FctRlYWZzbAly6o7LR7kGWHkRMm/Ohvysl+C4C6Qu+gc7wuk0AmckUX
	PGlbXEyWCvs6XmdRrsl57Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqys3cxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 20:27:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684KPV4V022775;
	Fri, 4 Sep 2026 20:27:32 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012018.outbound.protection.outlook.com [52.101.53.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gdymxh4g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 04 Sep 2026 20:27:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbntPFRLieL54fHYbeyxy59dBBsgZtHISlqmsBJZ949sWwjCvCLtGfvgIBZAftTdyau+LptnLTx6nvwURVH95Ld0usgRyFkadCR8sFWVfxdNES43BozIW3EBw+xD993UBFnOUBOy2uoHf30Ka0WdViP0v+yurJteTBKyvYFS09HoJiQpgV39hU8Y/Brp88nZJEA38azNBJWSx7URfn3ruB5YiDkLbk7hBvSn0xFBDMCy3kqLSkHJHu9hpqJERcWIe5yUxTxK+lbn+b9E0DjpBm06UJ+LedINg1bOoSiwkNSWSJBwXHtnqnAQrknlOvqAidyWSGQW96hwcsLDJSx5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJpKZx4hKoVtQw6nDWiZk1lvSMhpA6J0gWbn73n4ANw=;
 b=LL1aqJHJAiDPsxxoOnoI+nqjc3NET0F+vidW2O4HaYjj3DXTDhyZOTAlrF2ezYbpDi8r+Xb18I1e8P8mUKbt81GbpmY/bn6oIDh32LCLLLjoaaF4p1WpXklSg3AT2RDD8ypvbHDhGq/W6KkaFuwqpbjHI0PVGKZonM7TzPj5Bf6vYl+El0tZFOJXK01FgtUZGb4VGg72/Io94fPXUK2krd7LKA2Od0tJYhIY4Qye0isCOyF996KusurnGv1oCtNVvngGN3YHRtpfM3qC848W7p7eZ6JToexAjShTdClgb75CIgmuHJxsJA7QchKFP15LDwaKWRdVuNtf41G6dyOaKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJpKZx4hKoVtQw6nDWiZk1lvSMhpA6J0gWbn73n4ANw=;
 b=sEaY9AeK9gf/O+yCEugbNMuzbL9vx+6J2xJkXSnT7uzUlj3tNy9J2I8HAlnOAQJ86QNVNcfN+2J+SE1S5Hh+M7k7YF2XJpaxBjIqnX6s4IFbabm6tFnd7T1R2ayFu/BzYhu0ASAXJDHILxNdKPbJsMAsU0IuwsT+JM1/S8MFKyY=
Received: from SA1PR10MB5510.namprd10.prod.outlook.com (2603:10b6:806:1e5::6)
 by LV8PR10MB7799.namprd10.prod.outlook.com (2603:10b6:408:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 20:27:24 +0000
Received: from SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96]) by SA1PR10MB5510.namprd10.prod.outlook.com
 ([fe80::a9a8:cb4:1056:5d96%6]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 20:27:23 +0000
Message-ID: <30fe4e94-d88e-4565-ae90-92612362b4a8@oracle.com>
Date: Fri, 4 Sep 2026 13:27:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: selftests: Test steal time across vCPU pid
 changes on x86
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Oliver Upton <oupton@kernel.org>
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
 <20260904175550.430266-4-dongli.zhang@oracle.com>
 <20260904181104.B25871F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260904181104.B25871F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:510:339::18) To SA1PR10MB5510.namprd10.prod.outlook.com
 (2603:10b6:806:1e5::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5510:EE_|LV8PR10MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b4b4ba9-9904-4617-def6-08df0ac2edbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|6133799003|22082099003|4143699003|5023799004|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	M+xhoBLMusTO27plwZC/PVduhxCozshAF2+lcWp5xdukbG9WaQG+1tJN/wvPRdP0UGIbJJz7PW4wzOfZrrgV/6TonzMPhdhXeMu0gXBkIfd899ySvBJyCEFQWsgGWB6AJYoXe9TwApZ2o5QJuow61vEQiOaBC5oTjI8K0nSofb1KGoz+wk0L7xYKiWlfkhdxcY7aD1/VE3flhUjM7xE4wMvUS1ASdp/AHS+il4aA5MiuU3NCVSdMMxBR6rWnGjv+7VSxkFTmx/BEcDVLRpv6MO4eUBQ0le87Hgps2OZKMdJilvUWfQGrhk2WVjQxpBs19409T02OOCIwcPmftgqCFVzQ9ST7FRJ8WnDRczkxNLa1ORhcEMTxLbnqBnQuam/2SsSCC+3CkS8yzklqcKAOZFh8qya8hJcuKJTx9qmWBse9Vh9Q0ZVFibRlCpgUDZ3YyocpT0t0L8c1fmbN1PgC7Qa/5kHEEm7m9jRrldKdc3Rf+6eMbo1/XK7BsH28+d+P8sZa+h0D2vd+WZLq3jaKBkJzGfMM0SgJbWDgCOTVev/JiFREndqfGOpFLqqejDtWfzex5XFJi5TBCLPV6LiIOH9N9YTwgXqV6jMtnI3d9DmlrA5V2t07RDTRFy8l2MDuWf8+jZ2rKTIcahr2bLPPfBJcVup0rCqH7ziW8RMdJXw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5510.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(4143699003)(5023799004)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mjg0Q2RMODB6dElQQ3IvQlV4RFZLaG1lbDBPT0w3L3RyRWdwbHJNeUpSNkVj?=
 =?utf-8?B?bHJ2OENjWERFVWNQTnhtVjVZU3lZRlhWTUh5SUJTNmkrU2RQR1ROZm5yN2VL?=
 =?utf-8?B?TWE0RmZ0Ujh0akFWY1o2bmtGamxEaFcvVGV6U3BYSkI1TlJuUEFrV1Z4bG1l?=
 =?utf-8?B?THBKYk1FdDZxckNpbzZNeEw2bkZwNTVLMkRLYXg2TWFIRDFPM2dORXpXRkFK?=
 =?utf-8?B?Y2xSTDhCTmRDU0gwVUxFWllSNzU0eGQrSktNOFMyNXBZTWtSVjNTSUJiYnpy?=
 =?utf-8?B?L3ZGRDF5TVJQekgwVndXQmJTTE5DV2l2NncvMmtWRHVYWnhGTktwMHl5cCtr?=
 =?utf-8?B?QkNMbWJ2M1BWcGdrT0liSGpLc0lnSzRlSlhpOWQ5Q3pua210V0pQTkFCT2VG?=
 =?utf-8?B?VjdvUjNuRG10YkZ1ZjhJVEhrNzd1TmZFZ054WWFtdlN3bmx5cDBUTGo4VE1Y?=
 =?utf-8?B?RnNMTTNuVmZGWTJTYm9ZRkIvNzZEamg2S1d0TVVQWnRMWHZhWFlycGlNZ1d5?=
 =?utf-8?B?Wk5ySnNackticFJ4WFlzdjlBaS9CWnAzdFNwMEMweW1KR2xUQ1AvMTNUOW9O?=
 =?utf-8?B?V1Via2hsT0dKTVMva1dUT3FsNDBia1c5VFhZZDFXWjNmZ3ZKamhFQmo2NjRj?=
 =?utf-8?B?MGd4U1RuK1hnWElZMXhsazAwYTAyVFVNakRTM2FYbFR1TVc0U1FoNFEvMWUz?=
 =?utf-8?B?TlRQekkrc1pScEhKanpFZHpqUEtMVEFNWnJiZGZHanpXb1pycWpWWXpZZjZS?=
 =?utf-8?B?ZGJuQ01PZGUzNGZoM0VqNGxPUGtXdmJsaUpidTQwMmptUDY2eVh6TVkveXpK?=
 =?utf-8?B?VFNQc0NHN0FqWkdheEl1c1Q1eEh6cW1jVWZDaXVQL01razdqRmRISW1CMVJr?=
 =?utf-8?B?M0tCR2JnaEZsdjhKYUNWZ2k5V2t5OExxbHpvKzI5NFNFbmtObEJRQ2tkQjRj?=
 =?utf-8?B?Tk8wbjdITldjOW81aXVTajZLaGw1RjB4dUhCbHRKMkpZU1ZIUDFrK3U4bnA3?=
 =?utf-8?B?Y2xRa3JvaDNheXFuU3NtQ29YQzFvZEt1MEovd3lyOHkyMWxBTmpoM1Y0eFhP?=
 =?utf-8?B?YjJlYUtKeVJKK1BYN2V0WnAvaXQ2WDFKLzhlRzJvb1BOYVAxb3ZsaEdhdTBY?=
 =?utf-8?B?Vi82RVJzeGRJRmZoQm9GRWZZQ1lqQ1JCZUtuZGIxZGoxRTZyd3JlVGxlQnZQ?=
 =?utf-8?B?dkdkTlp5WUJJWjFKY2VEM3dZWTNITnlJTnVvaTl1UzBIbnM3RTJ1ZExkb1p0?=
 =?utf-8?B?NVBtTCs0cXF3Q1dFN2JvaEFBZGNwVWU0YzhHZzVma2RsbEQzVWx2N1FoY3Z3?=
 =?utf-8?B?ZE00MmErUytKb2pOZWZjaTZkamEzTVJZL0trbWhVb0x6QnNOMTJrU0hTQ204?=
 =?utf-8?B?eDh6QWZDUVVubW52aEtwSXA0Y09TMWtvYUtNVHdsNzN4NjhXWXF6b0p2b2pP?=
 =?utf-8?B?bHgwcWN5SW9uQ1JtTDQ5K0VEakl6S3JRVzZRSUxiZm5jdURKUlV5b2lsSFFV?=
 =?utf-8?B?TGlMdGh1NUJ6SXRkTDFJb0o5d3RCcWFnU2MyT3ZlSkhNWnQvaEQ0bmZSbmZ1?=
 =?utf-8?B?Q1FhQlFSVHk0a1ZQT3RWUUdGM1ZZT3liN0Q5cUZKSnBKdmdkaE9HRG5sdmZW?=
 =?utf-8?B?dFd3T3BmL2dIMklNN013TDA2WDNXTDd3L1BNWFFEQWtvVUFkWXRxZGk1MUFv?=
 =?utf-8?B?dnRyK002QUtmc3g3b3hSUEQxVm5PWFQvVEpzckpEb2VnVDVFTDBrbDhmVkwr?=
 =?utf-8?B?QlNWQktWWUlwNXNzZjBjc1BSVWMwMmNuc0RNelRtUHNNNC83dGhac1lrZWJ0?=
 =?utf-8?B?SHhsc0xMbHh6aGlTZmZVb3VkRkRuVVoydGZKdnFaR3RMM1UvZ1g5eGJzdVU2?=
 =?utf-8?B?d0lpaG5jMzBtZnBiaVg2Z254K1BoRjZCQzVBT2RsdzNWOXk1R2xGcTQrNlZS?=
 =?utf-8?B?SWxsTlArc0k1andkZ1c1REJCbWdvTjF6OVh6eUNRZW1rK3BPS3hlQlpYbXRn?=
 =?utf-8?B?YTQyTDBBaGZYaHpiWFhWYmdHczJiRlhZbzd3UEFDd09rSll0RFFtU2s0T0gy?=
 =?utf-8?B?STg4aEZMd3RGWS9vajNmUTU2YXNxcjRFbmkxVmhudERRc1Y3aHIrcXJVWk13?=
 =?utf-8?B?WHMvbXhVdjBrYjMzV1RYUkp3cUl3QmtidksrMi9LNXBmRnM4YkVkWU1ZMWdo?=
 =?utf-8?B?czN3S0ZxbVVHbkEwVE1NMm1EQ0IxYUhqMzhxdmdZa0wwTHRvSHBmbXV0QUZz?=
 =?utf-8?B?Mm43bmdnT2M5N215VnZxdzhPQkNmdEs5bFVzV3FoZThmcUdlQXZQS2x0WEF3?=
 =?utf-8?B?YS9QdU15V1l5aUFqMTI1akkxR3FWcnFCYjJkNGVRaGFwcVNEaWMwZz09?=
X-Exchange-RoutingPolicyChecked:
	oQBonq+TWIsY8ex3hCeqTC6d6p4eykKSLp5qgr06Y7g7T5a/rzeyEIGkmGXNBIX+4U2baRUzAyRM9ID29Whw0m24OiIZIf+vJ9DLZsqxitS4I4vDHudQox67UIj8Q0bm3LdCAOpkI88NSUluv66RpnlJyxSmX3N/IU0ND9M/AzMovUlq8uPmxgy5Ukh1pR3nqUKSHU6dekgn+VoTr6aua8a2viEHiytg3w5H392dsgGztedr4ismdm0m63H6E27vM2EaiYhg450heHousEDeyqcXRkwklpq0acMDusogFnJq/86RovTXzP4hLAxNv1yNsNCnhoLcUgFkyfXhtj3CMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X34AYKNwG43GJaUBFbeoGsi9EEl7oYNRSJCFeY6WOP+gIYZAZ9fDc0xbrc9J1Moo00DBOb7mWnLp6mAOEbRexWiR4SdPWXRWd5ZkSqG1jGcut4LWjp/sOE6yQM1Mr2Vk0fiNqZ4lwVvYg4AQ2YQeBlbyknib1Le4zVVqszI+o8iWLuVBJD0ZXs1YywemhaWF2eFBtpM8QoigzO91VZu2UymkqPBj9Vu6n5ve8i0EBZYHN78mmXgPDwo/bRpQiOJalZB2NjLA5QZdYs2cxyfzplp8u2L/nqzAgBuAVT+ZiRL3X4MZR/dnbGZ+QxnNMQwjIEq8dTZUGX083q09AR0TnOcxQjguegcFEadgRXu2cfcJ8hyl3/tU9UrIDO+py7V+AGdlqPe8yP1+E49lvUxoi6hUE160egT/2R9Yb1jhpKhOcIVsPvvHJSs3RbDTmnnzVtwAEmcDK34FB1SUFS+72QbLqzL1XfsLDW0KtjzPdbGtoAn5p3dGYt6jRCt4jcFXmhQ5ycm/XLf8ay9bvE8yUNQAo5VhUNBasgMCRq67B7+2oHIlLHzFZ1qW/iE6YT+izx/uhL7JDSp5l6w03iq/x8Sx0aNUOv9zrRVAh6VGt7Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4b4ba9-9904-4617-def6-08df0ac2edbd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5510.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 20:27:23.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYa7CmfZknesEWyyUFhoS8ovHowS6DNbd09fPTJuC7GK4HGfZKytYf0EMCKzeRz4Kdi/l6M+XM5UgeuH20EHwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609040188
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE4OCBTYWx0ZWRfXzH0LUXO294uz
 EvJEHC0i7s/nfcp4+aSovjsuWHIQS9dBDdhURe3M3mRrxoHZu1eutJe5VzM2M6QKkaw/UoOiuMn
 /N+tKDQI5F6rTs1P0Wez6ror8O8VG3+Yyn3qW3Dv/u02x3Vn9mCf3u3Pn0n0AugA5flzTMVgNlS
 a2AYwVKb8wIy+GjCfTJzxl64bkKigVtHu04q6alhj+ebYc7s3oAvS5f/7PjDluS6hcfFoZQNxkN
 /Edj+kmoDUrklJqXjNKuCZ+LB5h/L2UDTubbzF8bnEsFdUkxFRKE0aTZWlXDPkjETJyV9mtSZrF
 2AU4P13Sd0BVp+ixqYLBtirpzW0NCqHKOifIjR8bAjm8LUTZN+m4onJu33L/5Iu0TPAVPGqMdsu
 IMtONVC0Aaj6GROSwk1bP+UMYPAdC1o45lr+dDlHnq0Um8FT8lMJvBBhLffMyjcMzJYujmY3w0u
 7ltWgjB19UqG2CgrIrSpln5wSnbShFmKOqhJmZoI=
X-Proofpoint-ORIG-GUID: Gmq8F13qHLje26p02RjPxiZrzRI2KT7q
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a9b29b5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ahwTrt-TIs81H76UcAYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: Gmq8F13qHLje26p02RjPxiZrzRI2KT7q
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE4OCBTYWx0ZWRfX7QWn+nWTFZe8
 lxr1wgwAffzSvcWTeH0XMQonVPLshlK1cWk4SQ2eg1y3A7iPS/2G/rVkpGmDEjg6epNJxIJnAb3
 PLLbr1HcVKHN0kJIEkzuQhqUjJkgkLceoCriJYJt8RPxwKjQdMAB

The implementation of this selftest program borrows from
tools/testing/selftests/kvm/steal_time.c.

The same concerns also apply to tools/testing/selftests/kvm/steal_time.c.

Based on my understanding, KVM selftests do not require strict error-handling code.

Thank you very much!

Dongli Zhang

On Fri, Sep 4, 2026 11:11:03AM -0700, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] The delay accumulation loop can hang indefinitely because the background thread uses a fixed wall-clock timeout instead of synchronizing with the main thread.
> - [Medium] Unchecked return values from pthread APIs lead to undefined behavior and potential test hangs.
> --
> 
> commit 4093ded4f0187a7d185578eeea38cf167b09f1d2
> Author: Dongli Zhang <dongli.zhang@oracle.com>
> 
> KVM: selftests: Test steal time across vCPU pid changes on x86
> 
> This commit adds a selftest to verify that KVM correctly resets steal-time
> accounting when a vCPU is run from a new host thread. It creates a background
> thread to accumulate run delay and checks if the steal time remains monotonic
> across PID changes.
> 
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/steal_time_change_pid.c
>> @@ -0,0 +1,162 @@
> [ ... ]
>> +static void *do_steal_time(void *arg)
>> +{
>> +	struct timespec ts, stop;
>> +
>> +	clock_gettime(CLOCK_MONOTONIC, &ts);
>> +	stop = timespec_add_ns(ts, MIN_RUN_DELAY_NS);
>> +
>> +	while (timespec_to_ns(timespec_sub(ts, stop)) < 0)
>> +		clock_gettime(CLOCK_MONOTONIC, &ts);
> 
> [Severity: Medium]
> Does this background thread rely on a fixed wall-clock timeout instead of
> synchronizing with the main thread's delay accumulation?
> 
> If scheduler interleaving allows the main thread to run during this window,
> its accumulated run delay will be strictly less than MIN_RUN_DELAY_NS when
> this thread exits. Once this thread exits, CPU 0 becomes uncontended and
> the main thread's delay accumulation loop will hang indefinitely.
> 
>> +
>> +	return NULL;
>> +}
> [ ... ]
>> +int main(void)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;
>> +	pthread_attr_t attr;
>> +	pthread_t thread;
>> +	cpu_set_t cpuset;
>> +	long run_delay;
>> +	long run_delay_delta;
>> +
>> +	ksft_print_header();
>> +	ksft_set_plan(1);
>> +
>> +	CPU_ZERO(&cpuset);
>> +	CPU_SET(0, &cpuset);
>> +	pthread_attr_init(&attr);
>> +	pthread_attr_setaffinity_np(&attr, sizeof(cpuset), &cpuset);
>> +	pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> 
> [Severity: Medium]
> If this pthread_setaffinity_np call fails (for example, if CPU 0 is not in
> the allowed task mask), could the threads run on different CPUs? This would
> prevent the main thread from ever accumulating runqueue wait time, causing it
> to hang forever in the sched_yield loop.
> 
> [ ... ]
>> +	run_delay = get_run_delay();
>> +	pthread_create(&thread, &attr, do_steal_time, NULL);
> 
> [Severity: Medium]
> If pthread_create fails due to resource limits, will the thread variable
> remain uninitialized? 
> 
>> +
>> +	while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS)
>> +		sched_yield();
> 
> [Severity: Medium]
> As mentioned above, if do_steal_time exits before MIN_RUN_DELAY_NS is
> accumulated by the main thread, does this spinloop hang permanently because
> the background thread is no longer consuming CPU time?
> 
>> +
>> +	pthread_join(thread, NULL);
> 
> [Severity: Medium]
> If the thread variable is uninitialized due to a prior pthread_create
> failure, does passing it unconditionally to pthread_join invoke undefined
> behavior?
> 

