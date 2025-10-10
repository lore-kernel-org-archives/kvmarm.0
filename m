Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9F1220698
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 10:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760093995; cv=fail; b=VRqVM3ewYegnNke7LKbxvieZpg/V28y0VnzpzUtk8buLPTsBjSctjPPnNPAucFCAePTfudJV86KCFK3sOKr8UUN5YATRH1TMUZH9U+MQ36gqP6ZwfHCl5LVuW2ZF1NPMjqzTS+okw1B/P8kIL5zt6q7bnWtsgsDAxd/jOaY7Kl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760093995; c=relaxed/simple;
	bh=ut3QhycAM+FIqL9ioq3Q1q83flce6Jjlsq3Lk3AI7I4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H28jpGpdKhp+xwTqmfvJCFxv5h6NqgxsLEuXtKxDEjJB+t/KbYdoT7oJxm78OpG9slMoyljB4Xwdgb02E2B9QSq6bB5/8sgLuaH0lkoU9YYfuHV9Et3e9C827J82dlv7CobbSN6I+ZBTrcFCuDeJIv/TnY+UtJpw2V2Shz8SHrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=knW5NFBQ; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=o4ONzfVj; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="knW5NFBQ";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="o4ONzfVj"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59AA7K0M004796;
	Fri, 10 Oct 2025 03:59:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=ut3QhycAM+FIqL9ioq3Q1q83flce6Jjlsq3Lk3AI7I4=; b=k
	nW5NFBQdbIuXGxR4Fh96Dbhjc4PHJtIt3gTNLl6Nj8NxPYsX8Y31J3Z/dyXwfRkQ
	Xhgbgwxg6B2DY79uqDdG31ceCyKfCvNtI3xmA8b5dfGSwWGIYGZxK0zFs/XZ0dol
	IU5ddG00f1oZD05m2Pe8P1ajn1FEyLqvKLljX/M09P7n0i8tdqI0EkMrzZUDYHxg
	uP2YdGv+yZDdd0LmE/jlARTHEGCvyZFUW7tNwTW+CDVC4XWF5OvH7qY2BMDgp5x4
	S85KYTs+vNF6GJK5KJTY0UdAYsfpqGZCSEVKsHyPr9eqf6412B/urSjSeKxQ8ytv
	7ijpqH6FQ0/fGJZGel0Zg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023132.outbound.protection.outlook.com [40.93.196.132])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv62stu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 03:59:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBQ9GQjHIrFv+LVqKFFbxREqG7pqmxHj6g6L493uZ4lHOnAjqe68kxDzXXZ+SPxkS/EjU9ssMsPNBO4NyReAYT+VBGnPfsu2SjY3+12vn2M7NiueSNo2nHbefBeyrQGV/vGE8aVCmIAJQO/dbbR7jKNth95lwi5qA/cFQZ2eh92rPeQV6sVuqfzbB1fy1J36MIK8KglggI0ySfjsQXjhbN9XxJsr8ptqhoT3FumuCloTsqPPW7MgNo83wcnD5lbn4PAP5k5gEegvfmh92S2Ae/p2ggtQWQh0iNpzCfms/8DiuSQelKEPrsRL7Sfs5W9k7HZQHczEuEMyb5/qM9KwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ut3QhycAM+FIqL9ioq3Q1q83flce6Jjlsq3Lk3AI7I4=;
 b=VzzNbuobZAQ35fhyEGIoQk86jVrlwsz0UyHg8p/pHHr/ErFH0+JzlxehazP1hRBGRgq58b30sU4Ch54ixROXTovryjqj7GdB2zNDCxDyJDFXQhpztkSI/DQ5mNQECUWUhJ0IP6KqGWnpr4q921pyeEPbWM1Gp8CKKh3HcIYsVfSlR2i78lU2u8oh7mEGT50JTOh4Xb7V3FK8KP9q++qeyi0kf5LG/GZAp+kaBwQwj5aAgpcyoQ8xamnRhVqKjBIw8xl7BIxwSJshBh4leNwou9jOUubKaNLjBaPd+jX9e/v5LUbdg3kfiZkoYjfukCH+MAjPs2bmx0MuUpOtZv45OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ut3QhycAM+FIqL9ioq3Q1q83flce6Jjlsq3Lk3AI7I4=;
 b=o4ONzfVj+2fVrAfMOmITced1JD9f8IOd8O5rai+paiK1MlgmOnq6lBREcMKH4T4CxKaG+kB8VDSMk6QHlHwZ+szmXmh/3H6UySCqXcp+kECuZ2pZ7R+A/XUXwVPmp1acjXTw/4gRNhBpSIAAhnOAM5DVZ7RCOaOBV4Q2ghqzvpo=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by SA6PR07MB10642.namprd07.prod.outlook.com (2603:10b6:806:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 10:59:45 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 10:59:45 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: HCR_EL2 GET_ONE_REG value difference
Thread-Topic: HCR_EL2 GET_ONE_REG value difference
Thread-Index: AQHcOcAYVqsE1KhNtkOoBBTRbaAYVLS7H3+AgAAD9YCAAAsygIAAB8YA
Date: Fri, 10 Oct 2025 10:59:45 +0000
Message-ID: <3E1DF662-DD3A-49B4-A67E-55E9658BAF52@global.cadence.com>
References: <47FBDCE7-F8D8-4071-93D8-E4E494D41F34@global.cadence.com>
 <86ikgnxfl0.wl-maz@kernel.org>
 <2268E166-0EA0-4C9D-B1AF-EEECB48B926B@global.cadence.com>
 <86frbrxd2m.wl-maz@kernel.org>
In-Reply-To: <86frbrxd2m.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|SA6PR07MB10642:EE_
x-ms-office365-filtering-correlation-id: 7ca397ab-2b9c-4d6a-65b3-08de07ec1f97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eGFuR3oveFFLdXlpalRMcnlpeFVQT2Z5N0ZTTjI4QTRLbS9uc2EzSWlWYlRw?=
 =?utf-8?B?dy9GUW5MYzg2K1d0NlBWbUFzTjNpeWlJYWVsNXJ3Y3RvcXBiYnFHVyt2N2ho?=
 =?utf-8?B?RzMzU09GQ1lsbWhyakhTOGhqNFZPc1llZHhOZkNmTno4WjJVYmphRXBSR1BW?=
 =?utf-8?B?QUY1Vlc2WE0zb3lZL2FSeElMc2dieUgyb3BvNHk4K1dLeHlZdWl6cm1rMW1U?=
 =?utf-8?B?akNjM3ZzUzJWWVpKOStPSnVPdUpWNnZ4SXVYdm9vQldaRHplNWhoK29Id0h5?=
 =?utf-8?B?WEUxVzlvWW0vM1p1Z29ndFBNUEJMSWVBTS9zWnhHWGZxWnpwTkdlNVdPWUs1?=
 =?utf-8?B?Y1NmSXBtcXVpS1Y5bVE2T1pJRVFTRWQ3M0wwMkJEWGN2ZFBBYzVkM0FzQUpH?=
 =?utf-8?B?a1BlVzdpUk0wNGFkbXBKeE9QalROT1YreGV0MWlTdzhVWExXRGpnbUFQbllO?=
 =?utf-8?B?aEt1b3RCbmtPM3JCUGRoblZqZXM1WXVjZy9OcVg5eGxQVHVYdEQzbDduakk2?=
 =?utf-8?B?UlNnRlNwQ3NvSGY4V1FzNVFJZ3hPdForOEJ5TDRWWm1Ib0ExcFd5b2ZLaHBY?=
 =?utf-8?B?WGFWVEpSajNrYmJEZHhjRTJ3SEJyQ2J6bTRGNFIrWkEwbGlGc0ZPSVNrWkZI?=
 =?utf-8?B?cU1zV3NtVTA3MmhmRlZqYUtMbUhlVG9HNzRiUmNxS1VjZlZHTDA4K3loeVRh?=
 =?utf-8?B?OG9QalVqcmRLMmZ6aWFYYTVqdTB3UmFLQ1g4dDFaUTJMODMzSVcvVjZTa0V5?=
 =?utf-8?B?OTJnZDhZa29ZWEJoVnp4aXBDWFZYY0h2VUoxdzRvOUZzVHE4UUZRWnZRYlgx?=
 =?utf-8?B?aWcyK09URTdHVUVvNEp1Sk4wUkFnVUlYSEY2b21PVmUxcWVwMEV3L3dOc1lQ?=
 =?utf-8?B?OHBuTW53UzV3NkZnMjl6M0RpS0txSGVrcGVVVjhkT3VvWTNPNDdFSXNtVTNy?=
 =?utf-8?B?RUEvOExwM1VrWFhLcjZyY2FHTDRSZDBYdUxHb3dWWC8wVkFXVkRQR1ZNbFUz?=
 =?utf-8?B?aDJybHdHdnVIODNnejFBOEd0MllFdzZuTmt4bEI2MWEydlNGQStpZW5IMWI4?=
 =?utf-8?B?Z0FyeEtoVlY2RnpxczVGSW1HOHNXM1B5a0Q5VURPR3U4ZFVrYXVSUVBRZ3Vn?=
 =?utf-8?B?c2JnY3BBZnlnTWo4NFpuZlVIZXQvaVFHM3pMSmdmMC9xZ3QwVi9kQTFiOFU2?=
 =?utf-8?B?RW1iVkZoc2JtTm5nZ0pHeDNGNi8wMTVHYjVGQ05UbU5xaTFvTFR3YXNQUERM?=
 =?utf-8?B?OXJOL0lrNzkwbU9yVFk4NUdIWUdqZjZTSVdCdmZSMU1aMER3WG5RWGVkQnU2?=
 =?utf-8?B?dkhMVzBsMmh0Mm5JS1VQOUp5c1NQN2hrQlV0ZU1iZkdFY2l4d1c4RHVhU1FY?=
 =?utf-8?B?c0RYbjNnZzc1ZzljQ255TFBtS2IzaTA3ZVJPdHB2c29EdDU1ZVkxVTNoNkxy?=
 =?utf-8?B?aTkzd1VmRXlYbkRiYjVqejZ2WFQ2VmYvanJvR3liajQwUEZ4YnBpSFYxWnl3?=
 =?utf-8?B?Zjd5ZTBrM05wVUMreFVLdkFQRnVVWkdqNCtGdjkrZG1odWNrZDBnRHpGZkN4?=
 =?utf-8?B?bTdLODRIeGJwT3Yxa2xqdThnS2R6OGhKbkExSlNKWHNWVGdSc1FpNFcxeXpY?=
 =?utf-8?B?S1FNalJEeUJpUXhDa3FuWkxUbUNTWERPdHB4T3Fpa05VQXJ2aC9PL2hsd1lQ?=
 =?utf-8?B?dXBrbWtTWmwxSmZqS0pidWdZNTVRMW5WdEVYc3k1NTJBZjU0NWpCV2MxQjZp?=
 =?utf-8?B?c2lVZUZRc3M1R0RvekEwU0hLZEovdng4RE1rdzBHaTIxc2hlMmIxVWhINUZJ?=
 =?utf-8?B?bGF0QWFLY3pyY01PeWNSYnhLcmRKUUc1VDJxV0E0VlJITDBqSkFtekYyektU?=
 =?utf-8?B?Wkw2WDU0dzJVS2N1cTEyc3IvUHlGSmZoVWJmdVFjVlkvSUJEMUVaQWx0c1Jp?=
 =?utf-8?B?M2JjY01ucXJTR2lpOXJaUXNzNUdNaVg1VzNtQlhoTkFuc1plL250MHplOXBE?=
 =?utf-8?B?TTJUd09lNXdVakZIcE5Bc01CTXNqYjFtdktpZEgvL2FUUW1DV2ErN1p0Skhj?=
 =?utf-8?Q?SOAxwZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VExadUdPMytTb1NsU2NmeU5lU3hpOEhWbVRZdGVRcUthTnJGck40ODI0Nzl4?=
 =?utf-8?B?b000L3h2UHZmV3NRL0V3dmZvZllyTnh1azh1cEhCa05RMzN2WllQOWpOVWdO?=
 =?utf-8?B?VGJ5L3FBTklhQmJxNkhYTXlKd1ExQkU5djAzYUlrT1M0cWMzSEtQQ0tCRG5r?=
 =?utf-8?B?c3FsWFFIYkZwek4rbXRWWTRYeFJKMmRsTXExRWpUcm1xME1ZRTQxejB1ZHM4?=
 =?utf-8?B?dElGMnRjM0VnSmpodDdmazRWZk5LMlpidXVFWFg3cEtkS0xDaXpReDBQVDho?=
 =?utf-8?B?NWlEM080UnRIRGJscGRMTXl3YlhHcnIza0VybW9CRHVWdXh0L2RBVm82ZG9F?=
 =?utf-8?B?cGZIUmk2b0J6d1JJdUxaZ3VDMEJ2Y084bjRyMEhmNVdiL1lDWW1MU0pZK2kw?=
 =?utf-8?B?YjQ5R0VvZXIvTU9XV1NtMmc5clM3QmM1UmcyZjBuTloyeGc2RUlkNWV5WmtF?=
 =?utf-8?B?ejN3UUFiN1E4eHNVVEdSSVVrRmQrU2JvRTRnSWREYTUzZUJxTGM1dGJJRlFr?=
 =?utf-8?B?RUNpcHZsMCtxNUtuZjF5QXhzZU1vRFg5alNGQUJGMXFYcVNVbERwSHJHZ3Nn?=
 =?utf-8?B?ZFcrVGkvVlVUZTVKZW9VTlNpT3lDUE5tLythKzFIc2lhV3hlR1pJSnA3VEdC?=
 =?utf-8?B?alNoUEk2TnpESDRqTmpKTVRDUU1CS056Mk1lQ2Q4c2Z2dkh2MXN1eFIwdVVj?=
 =?utf-8?B?czQ2L0xTUmV2ck9vVHNmbjVjQVYrbWhLQlA5NzhlV2ZBYTBSLzI1bGpPSkpy?=
 =?utf-8?B?YzBlWEw1WFBjM1NsOVhsakdpTTBKOFhJMngyTUkvUUx4QWhDQXQ0UWJReUlG?=
 =?utf-8?B?Ymhld0tsMHhTUURIMUtuVDJidGtxZnNJQ1R0c1NES3F0eDQ3eGUyMDJnOUxq?=
 =?utf-8?B?TEYzTjRMMktyQkRnYjUzQks2U2NBYVJyWC9hbi9lazR5VGxtaUk2di9RUlFH?=
 =?utf-8?B?NjB4SENYY2p2dXZFTXF3b0syWlU1ZHdjRENubGNWRkNoQ2JvVzBsNDl1SlNy?=
 =?utf-8?B?QlVIMUFxUXArSFI0aVpsdGFTSjJXN0dTbnBvQmZzT3BjejJ5SVZtb2JJWkdO?=
 =?utf-8?B?WklweXhBUHRTaGszeDFhTkpJZ0FZdFBaSXZ5bDV6UVpQV28vZVExMHp0cnBo?=
 =?utf-8?B?dnBGUXBYQUNNd1N1TGJJdklIdWpXM1NLY2VPQnBMNVVYVE82UXV3OEt6ZWg4?=
 =?utf-8?B?clZiUDcyclJkWS9DR2x6SkNHVllrVVljL2pxZWNHM0JMUStqbzVScXVLc2xE?=
 =?utf-8?B?WkVyQlVIa1ZUK3IyVE0zVFlEUFVlamw5eVQ0L2hnazkrTjk5ZEp5eWI4V20r?=
 =?utf-8?B?ZUNKZ21BaXltTFRkL2pvRWRCQXlRcGM1ZDNTaVozMjJ5WFQwMkR5K2JlTlRH?=
 =?utf-8?B?ZDhwZHJiK3VaZTFIQWtQMUlKLzh0WDJJblhadjUvTzd5bmZHSGlrNTJEbkg5?=
 =?utf-8?B?cVc0QU5QRDIxWUhRd3lua3FvZnEwOFZEOEZjdnRyTW9RY2V2ZkQwcHZwbWty?=
 =?utf-8?B?UGpqUkhkWFoxdFZBcHBPQzZPaXNIQXVQcXFPdE9idk90cGRQdVZqZEZheXI4?=
 =?utf-8?B?SFhIcHhjSjRRdm4xc01Cd1djbG9hVWRIejNZV2V2cWVzOThjaElJOGlLTFdw?=
 =?utf-8?B?bHJQMWtiMnZtZnp2eE43SGlhN25jTFEvTjVabUhFWGE2Z2M5VFVqbHNlNDVL?=
 =?utf-8?B?SDBFMGpIcDY2V1J6WkQrQWc3am00SGJaLzBvWklmdUVhc0xsamJpTUNiQnJi?=
 =?utf-8?B?aUJGVi80RHVrbG01WjJlRHBmSGR2MUVUaDZNbjVXRFhia2NOVnhnZVlQcFFq?=
 =?utf-8?B?K2dTdjRVSHdYNjFYdjFBb1h5ZTZSOUtqWDB4d1RUdWtocmdTeThHaWpMUXg5?=
 =?utf-8?B?VEl6cjV4V3kvQ29VdDQ5cFQ0ZStZbmtwV0htNzliQ1QzZVEwc01vTSt4Wmxt?=
 =?utf-8?B?NS9mZ0FvTmIwVVUrOG5haHNWd1M3eUpETFYyQkpFZ2ZGVkdEbzRSWXBldVJG?=
 =?utf-8?B?Tng5NmhyS3pjYkp2amZsaDlkK0FQeUc4Q2l0SGFVTmRpS3cwOTl2UFdMVXgv?=
 =?utf-8?B?Wmc4WngzRDR4ajVFZW40R3A1SzAyMGRCK25XeTdQRUxNeE9HYXJ6M1htaU1L?=
 =?utf-8?B?aUE5SFZqZWgyWWZPVXU0bHVDSlhrRUFySHZ0WFluK2Q3NHoxd29NNjBpMjY5?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <645001A372A64044AE11AC4CA548458D@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca397ab-2b9c-4d6a-65b3-08de07ec1f97
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2025 10:59:45.6486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OOGrFDJW3i/a6iVqMB+SVZSMp3rzxFzXJyt6YLwd8Y/eNuxWB3ySwYxoGXXAPKWsq9Nag5b5Ibxwra+jNtnnRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR07MB10642
X-Authority-Analysis: v=2.4 cv=aom/yCZV c=1 sm=1 tr=0 ts=68e8e723 cx=c_pps
 a=LH/tFbq2k+kQ3xVriB62Mw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=RjzUmbWNKJmulKMzdUYA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-ORIG-GUID: gp2A005XygAkWsslYQfAB2WUEHoR3oPo
X-Proofpoint-GUID: gp2A005XygAkWsslYQfAB2WUEHoR3oPo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXwFYjBMrgpO0m
 sVpU+xnacYmBwrc7u4Uo1/RSlq6CAT/WrKvOqfRqm0qbSMZt/1ojac73tJ1OFX8TCYNke2PvPwA
 d8KEsgefwtkuZIXcBYxDbF4lm7jRvZX19ri29ZUkqK+0I6TXqtoB0vyjs5A3c+SC0/wB1vvZoi5
 3s+ai39AY0Y/wqj5Mrh8MJOcPACsylhMJ7Vd5qeb9XNfKjIqROO3we7ezUL0M45FDklh71dl6jr
 8PjjVDaPVkf7/FK4meGuZlN9bHgR7H4rFg+lST0KTNWbyrOmP8MpJAXhh0B5k56vV20N4x4r+US
 7LM6zr2d1RApjLXwGANM026Qi4M+tQRxlPP7yFOxEDpX/h4FrLGockRdzKQuNCMroZQ5cL1gbED
 1fyV/5jXeMYodDMuCb5i1d8jZzJrbw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

DQo+IE9uIDEwIE9jdCAyMDI1LCBhdCAxMjozMSwgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+IA0KPiBFWFRFUk5BTCBNQUlMDQo+IA0KPiANCj4gT24gRnJpLCAxMCBPY3Qg
MjAyNSAxMDo1MTo1MiArMDEwMCwNCj4gSmFuIEtvdGFzIDxqYW5rQGNhZGVuY2UuY29tPiB3cm90
ZToNCj4+IA0KPj4gDQo+Pj4gT24gMTAgT2N0IDIwMjUsIGF0IDExOjM3LCBNYXJjIFp5bmdpZXIg
PG1hekBrZXJuZWwub3JnPiB3cm90ZToNCj4+PiANCj4+PiBFWFRFUk5BTCBNQUlMDQo+Pj4gDQo+
Pj4gDQo+Pj4gT24gRnJpLCAxMCBPY3QgMjAyNSAwOTozMDoxMiArMDEwMCwNCj4+PiBKYW4gS290
YXMgPGphbmtAY2FkZW5jZS5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gSGVsbG8sDQo+Pj4+IA0K
Pj4+PiBEdXJpbmcgTlYgZGVidWdnaW5nIEkgbm90aWNlZCBhIGRpZmZlcmVuY2UgaW4gSENSX0VM
MiB2YWx1ZS4NCj4+Pj4gDQo+Pj4+IFRoZSB2YWx1ZSBJIGdldCBmcm9tIGFjY2Vzc2luZyB0aGlz
IHJlZ2lzdGVyLCB1c2luZyBLVk1fR0VUX09ORV9SRUc6DQo+Pj4+IDB4MzA0ODAwMDAwMDANCj4+
PiANCj4+PiBUaGVzZSBiaXRzIGFyZSBBUEksIEFQSywgRTJILCBSVy4NCj4+PiANCj4+PiBXaGVu
IGRpZCB5b3UgYWNjZXNzIHRoaXM/IEFmdGVyIHRoZSB2Y3B1IGhhcyBydW4/IEJlZm9yZSBpdCBo
YXMgcnVuPw0KPj4+IFdoYXQgTlYgY29uZmlndXJhdGlvbiBkaWQgeW91IHVzZT8NCj4+IA0KPj4g
SGkgTWFyYywNCj4+IA0KPj4gSSB3YW50ZWQgdG8gcmVwcm9kdWNlIHRoZSBjb25kaXRpb25zIHdo
ZW4gSSBvYnNlcnZlZCBpdC4NCj4+IA0KPj4gSSBydW4gdGhlIGd1ZXN0IHdpdGhvdXQgdGhlIGlt
cHJvdmVkIEVMMiBkZXRlY3Rpb24sDQo+PiB3aGljaCB3YXMgcG9zdGVkIHllc3RlcmRheSwgaW4g
VkhFIG1vZGUuIA0KPj4gSeKAmW0gaW52ZXN0aWdhdGluZyB0aGUgcGxhY2UgYXQgd2hpY2ggRTJI
IGRldGVjdGlvbiBoYXBwZW5zLA0KPj4ganVzdCBiZWZvcmUgYW4gZXhjZXB0aW9uIG9uIFpDUl9F
TDIuDQo+PiANCj4+PiANCj4+Pj4gDQo+Pj4+IEhvd2V2ZXIsIFgxIHZhbHVlIGFmdGVyIGV4ZWN1
dGluZyBtcnMgeDEsIGhjcl9lbDIgaW4gZ3Vlc3Q6DQo+Pj4+IDB4MTAwMDMwMDgwMDAwMDAwDQo+
Pj4gDQo+Pj4gWW91IGhhdmUgQVRBLCBBUEksIEFQSywgUlcuIElzIHRoYXQgdGhlICpvbmx5KiB0
aGluZyB0aGF0IGhhcyBydW4gaW4NCj4+PiB5b3VyIGd1ZXN0Pw0KPj4gDQo+PiBJIGp1c3QgYm9v
dGVkIHRoZSBrZXJuZWwgZGlyZWN0bHkgd2l0aG91dCBFMkgwLg0KPj4gDQo+Pj4gDQo+Pj4+IEkg
YWNjZXNzIGJvdGggb2YgdGhlc2UgYXQgdGhlIHNhbWUgcGxhY2UuDQo+Pj4gDQo+Pj4gImF0IHRo
ZSBzYW1lIHBsYWNlIj8gV2hhdCBkbyB5b3UgbWVhbj8gT25lIGlzIGFjY2Vzc2VkIGZyb20gaG9z
dA0KPj4+IHVzZXJzcGFjZSwgYW5kIHRoZSBvdGhlciBmcm9tIHRoZSBndWVzdC4gSG93IGNhbiB0
aGF0IGJlIHRoZSBzYW1lDQo+Pj4gcGxhY2U/DQo+PiANCj4+IEJ5IHRoZSBzYW1lIHBsYWNlIEkg
bWVhbiB0aGUgc2FtZSBLVk1fRVhJVC4NCj4+IFdpdGhvdXQgcmVzdW1pbmcgdkNQVXMsIGF0IHRo
ZSBzYW1lIFBDLg0KPj4gDQo+Pj4gDQo+Pj4+IEkgZ2V0IHRoZSBsaXN0IG9mIGF2YWlsYWJsZSBy
ZWdpc3RlcnMgZnJvbSBLVk1fR0VUX1JFR19MSVNULg0KPj4+PiANCj4+Pj4gSSBkb3VibGUgY2hl
Y2tlZCBteSBlbmNvZGluZywgYW5kIGl0IHNlZW1zIHRvIGJlIGNvcnJlY3QuDQo+Pj4+IEhDUl9F
TDIgMywgNCwgMSwgMSwgMA0KPj4+PiANCj4+Pj4gSSBjYW4gY2hlY2sgb3RoZXIgcmVnaXN0ZXJz
LCBidXQgSSBmaXJzdCB3YW50ZWQgdG8gY2hlY2ssIGlmIHRoaXMgZXhwZWN0ZWQ/DQo+Pj4+IElz
IHRoZXJlIHNvbWV0aGluZyBJ4oCZbSBtaXNzaW5nLCB3aGVuIGFjY2Vzc2luZyBlbXVsYXRlZCBy
ZWdpc3RlcnM/DQo+Pj4gDQo+Pj4gQ291bGQgeW91IHBsZWFzZSBzdGFydCBieSBjbGFyaWZ5aW5n
IHdoYXQgeW91IGFyZSBkb2luZz8NCj4+IA0KPj4gSSBwbGFjZWQgYSBIVyBicmVha3BvaW50IGF0
IHRoZSBNUlMgaW5zdHJ1Y3Rpb24uDQo+PiBJIGRpZCBhIHNpbmdsZSBzdGVwLCBhbmQgdGhlbiBJ
IGNoZWNrZWQgWDEgYW5kIEhDUl9FTDIgdmFsdWVzLg0KPj4gQnkgY2FsbGluZyBHRVRfT05FX1JF
RyBvbiBib3RoLCBJIHNlZSBkaWZmZXJlbnQgdmFsdWVzLg0KPiANCj4gSSdtIHZlcnkgc3VycHJp
c2VkIHRoYXQgZGVidWcgYWN0dWFsbHkgd29ya3MsIGJ1dCBoZXksIG1heWJlIEkgc2hvdWxkDQo+
IGFkbWl0IHRoYXQgbWlyYWNsZXMgY2FuIGhhcHBlbi4uLiA7LSkNCg0KR3JlYXQsIEkgZ2F2ZSBz
b21lIHBvc2l0aXZlIGZlZWRiYWNrIGZvciBvbmNlLiA6KQ0KDQo+IFRoZSBndWVzdCBjYW4gd3Jp
dGUgd2hhdGV2ZXIgaXQgd2FudHMgdG8gdGhlIEhDUl9FTDIgcmVnaXN0ZXIuIFRoYXQncw0KPiBq
dXN0IGEgNjRiaXQgY2h1bmsgb2YgbWVtb3J5LCBhbmQgaWYgaXQgd2FudHMgdG8gd3JpdGUgUGkg
dG8gaXQsIGl0DQo+IGNhbi4gTm90aGluZyB0aGUgZ3Vlc3Qgd3JpdGVzIHRoZXJlIHdpbGwgaGF2
ZSBhbnkgZWZmZWN0IGFzIGxvbmcgYXMgaXQNCj4gZG9lc24ndCBFUkVUIHRvIEVMMSBhbnl3YXku
DQo+IA0KPiBXaGF0IEdFVF9PTkVfUkVHIHJldHVybnMgaXMgdGhlICpzYW5pdGlzZWQqIHZpZXcg
b2YgdGhhdCByZWdpc3RlciwNCj4gYWZ0ZXIgaGF2aW5nIGFwcGxpZWQgUkVTMCBhbmQgUkVTMSBt
YXNrcywgYXMgd2VsbCBhcyB0aGUgY29uc3RyYWludHMNCj4gdGhhdCBhcmUgc3BlY2lmaWMgdG8g
eW91ciBleGFjdCBjb25maWd1cmF0aW9uLg0KPiANCj4gU2luY2UgeW91IGFyZSBydW5uaW5nIHdp
dGhvdXQgdGhlIHBhdGNoIHRoYXQgbWFrZXMgdGhlIHR3byB2aWV3cw0KPiBjb25zaXN0ZW50LCB5
b3VyIGtlcm5lbCBpcyBwcm9iYWJseSB0YWtpbmcgdGhlIHdyb25nIHBhdGgsIGFuZA0KPiBjb25m
aWd1cmluZyBiaXRzIHRoYXQgaGF2ZSBubyBtZWFuaW5nIGluIHRoYXQgY29uZmlndXJhdGlvbiBh
bmQNCj4gcmVzdWx0aW5nIGluLCBhbW9uZ3N0IG90aGVyIHRoaW5ncywgRTJIIGFwcGVhcmluZyB0
byBiZSAwIHdoaWxlDQo+IEdFVF9PTkVfUkVHIGNsZWFybHkgdGVsbHMgeW91IGl0IGlzIDEuDQoN
CkkgZ290IGEgZmVlbGluZyBpdCB3aWxsIGJlIHNvbWV0aGluZyBsaWtlIHRoaXMuDQoNCk1heWJl
IGl0IHdvdWxkIGJlIHVzZWZ1bCB0byBoYXZlIGEgY2FwYWJpbGl0eS9mbGFnDQpmb3IgR0VUX09O
RV9SRUcgdG8gZ2V0IG5vbi1zYW5pdGl6ZWQgdmFsdWVzPw0KT3IgYSB3YXkgZm9yIGEgVk1NIHRv
IGFjY2VzcyB0aGUgcmF3IE5WMiBtZW1vcnk/DQoNCknigJltIGp1c3Qgd29uZGVyaW5nLCBpZiBH
dWVzdCBkb2VzIHNvbWV0aGluZyB1bmV4cGVjdGVkLA0KZGVidWdnaW5nIGl0LCBtYXkgYmUgaGFy
ZGVyLCBpZiBhIHVzZXIgc2VlcyBkaWZmZXJlbnQgc3R1ZmYgdGhhbiBTVy4NCg0KUmVnYXJkcywN
Ckphbg0KDQo+IA0KPiBNLg0KPiANCj4gLS0gDQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhl
IG5vcm0sIHByb2dyZXNzIGlzIG5vdCBwb3NzaWJsZS4NCg0KDQo=
