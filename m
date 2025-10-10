Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0F634BA44
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 08:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760085040; cv=fail; b=kIK6X96xUYCo/ftqI/2iA+o5WF944SsluyF2yQ/mhYNe2wcogtWnvXCcckTgtxrkjcYBJ/iK1vbPlrQ29ximxX6iauIRRftTirhN8jFbuoZ4evw/JtqhEPPtlLjf8cJHNgczcGJERKHSz4UfmLnYs8FlAiMy4kYlaFTs1osklX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760085040; c=relaxed/simple;
	bh=jlopoCzN5s2VKIAXYuEfoqoyTrrEcoRneWy6gpRkeyI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kAlJvzMV01t4tbdCEgJMqYEYpUgoF7SITJDBQYk244JnLa05ht+Fe4Ids68hAyAmMqO0tbmO6Zh4I7aqcerZOV0YztdrD7OqSNIj8AuSQt0JkFvjXLDTTvGhj9DwFzvnBjxavxIlxtCQhRgECawqa8tu3+FCxx1WKTIUF3mBPaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=lpQlTMjj; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=RniZm/b7; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="lpQlTMjj";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="RniZm/b7"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A5SFmA004713;
	Fri, 10 Oct 2025 01:30:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=proofpoint; bh=jlopoCzN5s
	2VKIAXYuEfoqoyTrrEcoRneWy6gpRkeyI=; b=lpQlTMjjKgF58VCy7h5hYeZEah
	YHy4Itvvpk/VrflsFjfrDOe914Z9VYWlBt3juS8hyvwzdYF46TlNUi8kvbMsmAQH
	U2nLvClKu131ihntuoTGwmiysAolhSp/YOsmRpErAHtSOJLjdJv4g1VagejDRihy
	xSUBWodhWf9OulDLqyHFPkjJ7lEO+pQh1h4CtCbPNMyu4S+bfhd5P6VZmNQnOuEh
	J1CjMzhsER14J/4KSPomnCUUUkOlG5ooWmCYJzVNplQlPGoPYfRTnaLFUtRYw6DY
	ZGVJae5Cla+oXBqxM2hqtitcA0BH9Z0xtD4hSHVKWdHRyd5QlbkuoxxW2u/w==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023130.outbound.protection.outlook.com [40.107.201.130])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv62s90d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 01:30:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nNmGhS6NF+icNdK0aWQJsZCLtBI5PQcg4UrjKj9SC5h3GJKuZ62fL6ihHnMp04HChzycOZGg9bh9+2cL8Qgdh19XaX1vzJ4OPLlCv/KraLCNXRfKL8GKO0nxZbwy6jP4myV5kRh4N39p+mWJugi61gtE0vI05Brcbuq7I1NRCjBxSJ89aCa0awZc8CmqgM+P+0I+aSRTdFB8ITu629ObIk1UjpSjlIMAdPGUqRTPj6senG2SyT1wAZqCdDr2K0EY4dsaEgHu4Qdr0dB8vn6MzT1WtJm43gtW8GyZQiAbGeyVi43+5mya4CgawJDJbZ0D9WqIfWgY10IIyfDOSGYo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlopoCzN5s2VKIAXYuEfoqoyTrrEcoRneWy6gpRkeyI=;
 b=SQSJ8e1IfmBsHCf/kGh+/aH5vkvJ+qdD3QTjHRID6ShScTi7vpFj5zr2ito8yjTl5wdQQ71s+cVLbkqoIqt+W/6VezMOiXf/ceKHTG9lVBQkfh3dIhZ2a8O4zb+P7F1EdYT9e6A/CqxJxODC9IqtV+YVdF4eAZ8OUhvMZJ03JZfkQXc8J49B1Bk2w8FRENjxgWi6XMqEgL4JjcoNXfUJIJ4OkMEj77dQchBbwy2oiXzoIZq6ukiHbFDe0+/CYeGL3rT24T07VKVj2yCzbOkCyEf7mBiUJvkLXfr7gkge9TIvrTuULy5f05DX9WkVAXrwQrOpp0MjTO8m+mxcydIHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlopoCzN5s2VKIAXYuEfoqoyTrrEcoRneWy6gpRkeyI=;
 b=RniZm/b7rEIHATt2hJ/mOLZ7nbduc1Fvjy0HjI7gULMjCUpfUxHWrzJI50EEvgj7NdWXxdMnL77efKZT+nopLdbN1JeXcIvDyR4DNXdDmnfVvnhPg+taWeOMmHmUtoNrGD9CzJlAQFwSApFXzKfwQ4WRk3F0kT0GttE22J5h8LU=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by PH0PR07MB9143.namprd07.prod.outlook.com (2603:10b6:510:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 08:30:12 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 08:30:12 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, Jan Kotas <jank@cadence.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: HCR_EL2 GET_ONE_REG value difference
Thread-Topic: HCR_EL2 GET_ONE_REG value difference
Thread-Index: AQHcOcAYD/BmRw/jTUWRYmwaTJOa7w==
Date: Fri, 10 Oct 2025 08:30:12 +0000
Message-ID: <47FBDCE7-F8D8-4071-93D8-E4E494D41F34@global.cadence.com>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|PH0PR07MB9143:EE_
x-ms-office365-filtering-correlation-id: bc6e16a1-92ea-481a-a235-08de07d73afe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?S1JVNXl0ME5WSGUvUlBZOU54L1kvOTJ3VGp4TmRZRkE2UGRxVDNTbVcvNnlE?=
 =?utf-8?B?VWdlUk03UlVoUTZKV1A5ZlRrUWZMRmpnUUhsemhaSmlicWdFV3hNcGNDeis0?=
 =?utf-8?B?VXVxQlAwei9jaUtmSUtTR0NTNFdSQlhKa29ZQVA2aitFeS8wN2E3K3NBU0Nw?=
 =?utf-8?B?THdTaEV1OWg3RjY2R1BENkdTRzFOeSt0amVIdWRxRFBJTVBpYkJBZW5wdm11?=
 =?utf-8?B?MW9JRm1pUkxuVnFMb2NTcHl6OUIyZXdGMkFLS2Y1WTJkeTRpc1daTERCSlMy?=
 =?utf-8?B?R1I2Rkp5RTdvVm5SWllCWnFiZEdOdWZmd2M1cmgxYkVvNG04T1hzODAvU2Jn?=
 =?utf-8?B?d3JlNVR0VExmZWtYRFhUek9YLzY3M1Vld2xLYkxzdUNIUjZEblZtdTRXL2hq?=
 =?utf-8?B?NnNiRGtLbUtpVkpDc0s3OUpzK2pOKzU3cFN1cE9qZVJiQjlrQzE3ZjFSREhE?=
 =?utf-8?B?SzIxV21QbERUMzF5aFVxT1prZ0NSSGNHVThoR0lUMjM1bEsxVXVKcjVRVDgw?=
 =?utf-8?B?Z2hmdTI3VGVKUWxTd2wyMmRLSitRUkxKL2twanIrb3hMcHRIeEo1UHRJUzE5?=
 =?utf-8?B?ZE44SEhTbWxiOHhpRmVEWHRPNnM4YmIxYnJjei8zRDRhRmZkbnlpaEU2SHdW?=
 =?utf-8?B?USswNmRrMGhpQ2pka0RsZm9WOGdoZFhaWFFtandLcFBTYXFNNVBQVytxUE5z?=
 =?utf-8?B?NzBGRE1PanlDNjdLeXB4eHNNR1pEZVp3MGhIZ1d3MzR5QllNaG1VRTRmU0E3?=
 =?utf-8?B?WFpsUzE0NkRRQlY5QjI2dlU0TWt4RTRrZ2JmcXdGNUtRaTZLNXhxQjJqZnVo?=
 =?utf-8?B?TzFZL2RVYk55TGFtd1ZMb3ZQMHdtSzBURzJiaXJOSXR4eks3Nm1zM3NZQjdu?=
 =?utf-8?B?UWxsRllreWRybml2Wmx0Wm5FV1hCcEZ1ZGJZVHJKVyt1TEdHZGJncDA1T2lT?=
 =?utf-8?B?M0lpWjFqZWRLQ2huL2NpYkhUSEZXVS9VMUZRcktTcCtlUG51eHpVdW0zcnZ3?=
 =?utf-8?B?SUcyNHBzQ0JXY2lmVHBSd0xTdFBCR0tzTGM4ZGdnMXlvN3RsV0tPTUs4ZjJW?=
 =?utf-8?B?Q0Z2L01RZVpTM2d5Ky9tZ25VTTdOTk1UUStNbGtwaE1YZXhuYVMxK2ZJSDFH?=
 =?utf-8?B?dE1PZi84ZXBLTk1CTGkxZWl6TnI4NExZd1ovMHlYclQyZ05ZdkNnY2RtOXhS?=
 =?utf-8?B?NXhRM3pkVlhpVWNaQ0lFd2k5b1QveWZnN2VRZzFZUUdkU05KUXdOZWxSNHZL?=
 =?utf-8?B?TmZqYndaSXNUYU53VGh4WWhNSXZPQWZXeGJqa1RmVjUrMDYxdmRjNDc4TENN?=
 =?utf-8?B?ck44RUUybWZoc3FlTFlLTFNodkladWw3MTBEVHFraXBBcFdKMlk1R0dLL3o4?=
 =?utf-8?B?WHNmak1maThhWXM4MHYxQjRsRjVKTlhWTlhlOHkwWXd1NGtjWURLVlpHeHZx?=
 =?utf-8?B?a3dwQm9ISlpXeERuNksvdGsydHd0RWpKNHRlVVVhQXYvQ25selkvUHRaM0pw?=
 =?utf-8?B?d0hnQzRTTGVpcThDUWR4eTkrTHMvdlFSdFQwNFJndFFLRytGbTNKTkx0T014?=
 =?utf-8?B?UVpIK1J1R1BDbVA5djZMQitOenBhVEtiSG9CdHg3YnZST0N2eUc0TWUwWUR5?=
 =?utf-8?B?RHRiVlpVZnRQeW01MnNpTVBHWkkwUm9oMU5rV3ZQbnZCODczdlhnbVM1MEFH?=
 =?utf-8?B?MXhxYXdWRk1YOVMydG4rOVNYMEdyK1pIWURzMFY1QmYzMVpITkFIdWFXSUFa?=
 =?utf-8?B?U3JKbzVSZ3c1OURSSFR2dTlVSFIwRFVlN3B6U3hXSDVqSHZEaGFQRkdHeUNu?=
 =?utf-8?B?WVFQWEVyRHM0WWkrd0FsRWZSaDV1VXU4NEdEN0wzVnpyczJsUGZRaFBEazhp?=
 =?utf-8?B?MitEVlVpdUlFTTlXZGMxWjEvaEpaK1h6MkNYdmhLQjM1SWZLbW53cVRGSy9X?=
 =?utf-8?B?amN5SGxFV01DZ0pTQmF3QzNZcGtESmhUWHlJQmIvTzFUcmdkVHkxT1dSMFVJ?=
 =?utf-8?B?ZXRsMW90YStSdXpnSGtaOVhzbHdFa0dGeHIzNGVMYUoza2xjMmxLQ05USjZw?=
 =?utf-8?Q?yUt8Zd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TTV5WHIyMHVqWTY3L0owSDNJOVJ6SVU1NS9OcWprVUwrU1lwczdmK3ptcTNZ?=
 =?utf-8?B?NHR1K0hraUR2Wk9lazVzcDZvcUpNWmNtNjNSQUdWTXp0aW1SVHlyckh5eWk2?=
 =?utf-8?B?UzgzM01SQmovNW91b0VNK3dNQnhMc1M0OWdHeXVXYnNydmNWYkhjVnV3aU92?=
 =?utf-8?B?RURQL3pLRmtqZ1l0VGJscVJiOGxnd0xCbEtzUk1HVmd4ZjVPWFEweTV0L3ha?=
 =?utf-8?B?c0ZUYmwxajljWFpuK1VGMjJZSXNFQ2JoTzhkd3lCNzNtdVdja0xUSzNyTEJj?=
 =?utf-8?B?a1Fxb1MyVlR5RG1rNTlBRmc4WEhKejNQVVRkT2N4UlllVENoWElvc3dFNmVY?=
 =?utf-8?B?dURzamQ3UmM0TG9GbUpnbHlPTzMva21pRGdRQ2MzZyticlRCKzFZR1p5b3pD?=
 =?utf-8?B?RVM5bWJ4TkFpOGVaK20zVk1NRlNuUkFNKzBPdW1nOFlQMDIrdE4ybDJKakxD?=
 =?utf-8?B?cHl6VGVGRlpGUmR0VSt1UmFNRjkySVZzRGRTaSs5bXh2RHJmM09qZllOSXBv?=
 =?utf-8?B?Q1FxWElTTzZQR1ozVHJvS211dWkxVVFIenp4MGJBcHdMS2Rvb1F5MDVyWGcr?=
 =?utf-8?B?S080ZnVQajNBQ3RETG4vdHVxSTEyQ01WTzFzR01BZkFtTnAxSXV2Y1FVM3VQ?=
 =?utf-8?B?SE1PZGl5Y3BGbzdDWDh3eFNOT2U4NGJXNXVOV1dxZ0dxT2IwcnRQSk44TmlW?=
 =?utf-8?B?NkRlUzJyUXZIWTdoRzZBYlpCdlNGR0ROSFE4NGlxMlpaQkdEQXVJcHhVM3ZK?=
 =?utf-8?B?aytRQXFvSnRsZ01MWW1idlZNbmhTb3NVeG1Za0lCNEgyYVZZSWtER3RQaEd3?=
 =?utf-8?B?YlVjZUxLVk52bDljWnB2ZExnSmhyeml0K3EzbkJrMDBjRi8yNjhzV1E0Zjg5?=
 =?utf-8?B?R3RiUjIrc3ZxWTFCMWZzZ1I0ZFBqdDBpUzlqUFhwem1jblVTMG9hVms1WmJl?=
 =?utf-8?B?ZUVma3Q4ME5lL2E1WTJ0NlFTTisvOGJWbHI5TlJteHM4cStsOUs5djlnMTBI?=
 =?utf-8?B?Q29TdUdzU0dmS2JxaWt1L21YMjJUSVBRUmdWNTFvSHJjclk2MCtTeUFHNVV5?=
 =?utf-8?B?WE1tVGRsSDdxR0FPSEJEQXpjemNtL1d2K1J6S0ZNSkEvc2tqQ0MyUU1XU2Ev?=
 =?utf-8?B?OWJvOUNmMjdmb2Myd3M1RERrZ09zTVI0ZURJcm05R25oaElIL3RuZFVCQy9t?=
 =?utf-8?B?cC9XSkFjNEowVkJOZjFNM0Q0dFJseWRDakJzSzhkSFlKRGh2aVVINkpPaCt2?=
 =?utf-8?B?RnpRSGw3WWtFYlZTRjNydGNoeU1zdi9RRkxDUml5ZFoyVEdXUDVTNTJaYVJQ?=
 =?utf-8?B?NFozaGVPM24yWUtrUjhScFcxM1NkT0ZKWW8rQ3pRZVJvODN3ZlJGQU5mMExL?=
 =?utf-8?B?RnAvNGNCMWlwVlB3ejBjb2lPNzl5c0lIWDdlb1BiTzJkRktJdDZocmZNR2hU?=
 =?utf-8?B?OXRHWGdLd3VBeW5jOWpzOWRPcGtqeWt5Z1g5VjJOVzk0c0p6ZGdFS3VKTFJZ?=
 =?utf-8?B?L29mWDZPVFlKc3JEbDRrTTBmZDdML1lBMzNFREhnUFYrV3I3ODVXRnBXajBq?=
 =?utf-8?B?dHVOdklUTm1CSGc5bE9tdXRCS2x5cmw0NkZ0ZTVDaUhIaWR5MlhJUmRUZU5J?=
 =?utf-8?B?YWNHTW91V1hHRDV1eUZkRVpQYk9PdXQvcDZOYkdkYlNoOFVyR3dicldWaUxR?=
 =?utf-8?B?bVY3TVM2MU91dmxxRjNBaE9EZkZ6MnlOQjVtUm1UKzBjbUxwS0ErK29OVlMy?=
 =?utf-8?B?em5qNnlYdTNOR05RZVJXRmw3SkFwVmpzR09RTGp3WGJDYlZoSEFPaEI2a3Vl?=
 =?utf-8?B?UXNSSnBkTVZtV24xQ1doTURZbW1sTG9UYWlvZ0tvVHE1UHBEWktJVytMUmR3?=
 =?utf-8?B?dkhQTzZjTnpGbVJsZ2JtdUhybUt6TTZNRkM3em5GWFlPZmMxVXpCMVA3K20w?=
 =?utf-8?B?Tjk5WGNXTTZlQ242elY2aHl6eE5FMjUyckgxWklxVXBmSTRwZlZEc2ZuNUMv?=
 =?utf-8?B?VUZnNyt1MWVWYmRLZzAxbzNIZms4N09keTdDYzhpZ1NqbUJMZE5hS0lCT0JM?=
 =?utf-8?B?b1hRZytnTWdTV2ZvL3B6YUhSSTErSjl1Nm91WkM0RW1JZVducHJWLzF0RUpW?=
 =?utf-8?B?ZEc5US9PNHVVUjVYMVpIR21QSVc5dTUvYktvbHg5QWJSaTJvV0c3MUdLd282?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A71F7A406FA2742BA7323ABF5A93ECD@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6e16a1-92ea-481a-a235-08de07d73afe
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2025 08:30:12.2007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FL0QcEzFbHyVbFOD20YF5+5p1rcU3QnSGtwquD/0FFKaWBWI0H8nMKXhFu6nsq5lyppHfu39DDwNTO+jF22W/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR07MB9143
X-Authority-Analysis: v=2.4 cv=aom/yCZV c=1 sm=1 tr=0 ts=68e8c416 cx=c_pps
 a=nEDKMBs7eiJgagyIvhaA9g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=_bkkO-G9H5NnP2_CC9AA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-ORIG-GUID: ppJ3IJj9CQhUnGM80BMPU10J-3rtSrtn
X-Proofpoint-GUID: ppJ3IJj9CQhUnGM80BMPU10J-3rtSrtn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX7bRdzr7HcVL2
 1v2ZpjD7qpkTYiARlNwrlFpRfipGLrANtYP4wdDb0M2u4W5R1hs/T/6flTogWYMM2b/dhV16+Fv
 E8uGueTpUm4S7sCBjTOQbnwGt6MruhJxKtPflOsUJzIwPPgnwdOm0kQy8SrEzPk8dbTBPJlGgi/
 YSKLVlZRvnSFqwjFJ197YdEIWn0xFZmjOHZCtfsMQ71CvJ0I/oSnVYa3F983Km+D5bbVsiXU4ha
 tvqGvjLO154/5V+H2NrdUUV/FF38Itkox2S8bNHDbTaJK62sh7FBmojQcqU7oSdtwjvizNMxHUU
 wwpMd8xV3RGLQxSpHYxsaLK0tvUdWaZ9bTm0sF7p+nkivHqim+pL18vWHac2kkoYJS15n2+gCsY
 M1UcvmMBzpvk77Irixg2b2PztTK9ZQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

SGVsbG8sDQoNCkR1cmluZyBOViBkZWJ1Z2dpbmcgSSBub3RpY2VkIGEgZGlmZmVyZW5jZSBpbiBI
Q1JfRUwyIHZhbHVlLg0KDQpUaGUgdmFsdWUgSSBnZXQgZnJvbSBhY2Nlc3NpbmcgdGhpcyByZWdp
c3RlciwgdXNpbmcgS1ZNX0dFVF9PTkVfUkVHOg0KMHgzMDQ4MDAwMDAwMA0KDQpIb3dldmVyLCBY
MSB2YWx1ZSBhZnRlciBleGVjdXRpbmcgbXJzIHgxLCBoY3JfZWwyIGluIGd1ZXN0Og0KMHgxMDAw
MzAwODAwMDAwMDANCg0KSSBhY2Nlc3MgYm90aCBvZiB0aGVzZSBhdCB0aGUgc2FtZSBwbGFjZS4N
CkkgZ2V0IHRoZSBsaXN0IG9mIGF2YWlsYWJsZSByZWdpc3RlcnMgZnJvbSBLVk1fR0VUX1JFR19M
SVNULg0KDQpJIGRvdWJsZSBjaGVja2VkIG15IGVuY29kaW5nLCBhbmQgaXQgc2VlbXMgdG8gYmUg
Y29ycmVjdC4NCkhDUl9FTDIgMywgNCwgMSwgMSwgMA0KDQpJIGNhbiBjaGVjayBvdGhlciByZWdp
c3RlcnMsIGJ1dCBJIGZpcnN0IHdhbnRlZCB0byBjaGVjaywgaWYgdGhpcyBleHBlY3RlZD8NCklz
IHRoZXJlIHNvbWV0aGluZyBJ4oCZbSBtaXNzaW5nLCB3aGVuIGFjY2Vzc2luZyBlbXVsYXRlZCBy
ZWdpc3RlcnM/DQoNClJlZ2FyZHMsDQpKYW4NCg0K
