Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89472EAB82
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861128; cv=fail; b=d6itTDMQxkfD0VLT8jSY9j912UQQ0XgevBW9jTeP4tn+s78nGU26bfcT9/Vcrh+1hKseZ3R6v3TrPcn+I/d/R3rfMx7+m5tOyJM8yo8c2TbfZEb1O5gG6OA9g9hSthkJZLX8KmgNni//dMs/wB1ONBqv0Fx4h/JDSOR3zhu+CwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861128; c=relaxed/simple;
	bh=3UJdtrx1dvgefFj5g9DKXrKlyfVcU5t+SWPhBzASEf8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JNTusPQDsFqKyNC6XBgaG/kdVeyWB1ESkPScnoWdQejIwtKnOWYYdDvv7TGJWJFIVrMwzjJv3sBHtGHcGVIuXG9+f0WH8lHXE4UtplzO4QIvox4ukZM/Izg1muxq9sqxv/4f8JdVdlQT3qzSP6FwKGtVGb5pqtZU162aIQnvg0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WeCjCE42; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GO4flWTC; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WeCjCE42";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GO4flWTC"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F9QpfW1209574;
	Fri, 15 May 2026 09:04:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=3UJdtrx1dvgefFj5g9DKXrKlyfVcU5t+SWPhBzASE
	f8=; b=WeCjCE427650Iv2QRLU+Eyy4eY4fctvvBi5uCm1h93gVwcmJLQJwTn4bD
	WarlZP3RSN/F0v1MSRk/Z7fHexR60J4mR2YZi6eMOPKMySGFwJeEQ2YNJlXaN1ex
	g6Ogy0py9HIswukJnq0+aJTJW6JkKioAheK7cZxkJV+/p/q6V3IeUBb9W8xZUOor
	2HHa5vwNfl8xMLl5IoWcG5Kj4bKNijXmqBFR/QfHW1cQzVx/T0a0ReWWHWcLVxo9
	SVYuK1ZY5qeQIJRUYtYB0TJF6bMA3CI+WABDGH8U73IwYIiGqx4H20VGZ/RQHatw
	Z2Z2h6PhEW29egwLEAVoY5G1S3JVA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020096.outbound.protection.outlook.com [52.101.46.96])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m22afjy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 09:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UCs359nLbPsith527IWXTCwB8DYuSP8wl8s6vat2qCGgntuHI6rotzydxscWA6V67HNWPfXqQJwzz3gOYa7fiErBN1R+jVCfKrQJ0dK1Bs78GeeF8Htny2ZIJmXE7KQvDqnqx1lsg/sSJjnvNcnm4f2geU0kpNGBx8QQ/0TPSC2Ebam/8Sb2Yx6oN2sgTPmbkaAL47z4a1g3udYyJTE6d3C6f4SmFhtRabH1WWnqkrtMqOyixlQaam3ZBDkJ2ptY1PAsShJOaY/+yfY+oHkjuvSwwkDL1VrlGLyYRzQvb1S3ri3Drrc1HsqtdRO4dbzX1l5nbpE8zkkPM/y+YqtKqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UJdtrx1dvgefFj5g9DKXrKlyfVcU5t+SWPhBzASEf8=;
 b=jNbQU7DCXIvOWYld2SQZXnxy0ajcB8KbqBDrG9h3BelpFP5yAwrqKreWngjM25mcw6Y7VxezAjmcjJR/A64rWBYpNlOa59ZEwbFGctZ2MQ42zvTpT38y01UbqxSxAV3U0HLzpIe3xzwTMWKitnSdvvA47Nf5glYxnTbg/Y8QR92nXwCRysqFos6SbGLqi3MgQGLw2/+HwbNcfRvtLYVLaJCXWrGEZeJR2KEzJqZDicQ10OMSccmqfMgHaf2XyjMFGXtZpqU7XN5GMZY63WY8oAnWoPhhSAK8u/D/IrV3mG2yLfa5sMhwKvhixS5LVz6zjXCMMeAVTWE8n652Vajo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UJdtrx1dvgefFj5g9DKXrKlyfVcU5t+SWPhBzASEf8=;
 b=GO4flWTCC/iAwJb5v2uNQuP09WZFZCthYPDPSTJwVGSmciUeZfwUU/gRii3WUUxePtzDGhLvuetiOeMaiwuEwwLYT4beawhi/cMHVG/c9LNUdkC+FAv3TTABw8+n5L41DaKDtHc5byOqcGNM09xaRMkeRYCmntJDsS4po7yLTss0kqsWGl6DMtPdF0FyTmI8iJSbx5U3Ld8fugLK4vrF5/Y5P79ZA5yBXUslmEjqRZQdFbCg3Itco3yM6DmpSKX5J8V0/dagYUQFxgXViMqfnrchZ93prWP3T0HRgCAP0JcDBebn+Ac1PwJZ+w1QedFShhSIva9njqaJtTBg1sg/ZQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MN2PR02MB6605.namprd02.prod.outlook.com (2603:10b6:208:15f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 16:04:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 16:04:42 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Shaju Abraham <shaju.abraham@nutanix.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Prerna
 Saxena <prerna.saxena@nutanix.com>,
        Jon Kohler <jon@nutanix.com>, Jonathan
 Davies <jond@nutanix.com>
Subject: Re: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD
 macro with IDREG_FIELD
Thread-Topic: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD
 macro with IDREG_FIELD
Thread-Index: AQHc4vZXBdvgQOyd40yTWebWLHE5Y7YPOSWAgAACA4CAAAL+gIAABN0A
Date: Fri, 15 May 2026 16:04:42 +0000
Message-ID: <C3B934AE-E66E-448B-9241-07A82610E7FE@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-6-shaju.abraham@nutanix.com>
 <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
 <A84C8759-6EF8-4DFA-B5C5-A4381022F81C@nutanix.com>
 <338ec6f3-499f-4232-9049-17118209c05f@redhat.com>
In-Reply-To: <338ec6f3-499f-4232-9049-17118209c05f@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MN2PR02MB6605:EE_
x-ms-office365-filtering-correlation-id: 631b18da-89d4-43a6-a6dc-08deb29bad1f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014|38070700021|22082099003|56012099003|18002099003|4143699003;
x-microsoft-antispam-message-info:
 ZKaRxUrUOLMowW1spWWM8/0nvFQKzM4ANAcoLBd2R0CGuU0xHmSEAMWX6YJ650hGEFZZ2LCS7+CvrhmIW9V0E8I4pLCGlZtomhZeBjlLdnvDYUh2YEGRlnHraKOqOQjCWxe2Px75b4aildJ8KsOHmBhIRYcAMlYMEmJh0h5StNZYYJN4sTjnIZPAelMhy/w0tM94wqEH+WRXsCEUonzxye2nIMYG4TGFik/6m5d9gmpAj2ISC6cvCufalhfiYYYteVap3nGZtYRTppjglEA3ikoY/iqVL/XlMh/ZbSrq2TI23d+mrWOhDHejVUGqIzqYHgCazzBTBE5ZZGboBen+RGPLLa/lnTLWRQ69Wgc/0wnz3xAjD2WL2PNTOjqbUAGp79zbx77sPDtm6DLCK4HO5mKVngrnVM6EIcJMjcTA6T4o7YZZfod5hRyck2oI1yk6mRh8qDM9znGaTekdjdNkaTPCn3c0X37mcSf5LcnqUSFcpzAuN85wcH+RSgUAn8EbynFbofVs0xlIIDX8VasF4KnqQkCckZTOf5WgL4/B+WEtL6B6TVN58NmzfQ28kXtkDnO2McMo/xeBnrm39y2ZVIxo0wVdaBeEJUmid2UAHh53pvqb5qjCYWBfShISm+779Q2fFD+W4pAVxlLmNrcLWINJMfs9wHKR3UVOkHlCahqdRpVD0JDd5hCaEOw+7lP4BefwRoIwRp9AM7b957FIxLD3zaWflxPLUr+CAr4SJ1XsDCZe6hwRCoTW3KDcXEjI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014)(38070700021)(22082099003)(56012099003)(18002099003)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjBRU1NoQmQrYTNvRm5XU2EzaDErZktUSi95aDl0ZVZucGJwVHZyN0RqeGt1?=
 =?utf-8?B?L2xGM244N3A3eEtNb0tOeTdZZHR5Y2lPODhlN2Z2L3dvTlFHYW0wVXJwaDQ3?=
 =?utf-8?B?djV4Tm81cm11bGtqcHM2YXh0Z0hXMFZJYzFLbzlPQlhUak9HM1FtcC9UQjBp?=
 =?utf-8?B?TW5Xb0E5c1VwWlJXMmtDblBqUmRzeDFOVnM3akR6UThDVzVVTXB6U05QQzZF?=
 =?utf-8?B?am9BT0dUdUNLMzdYWFVMaTFtS1JzWWJhRmw2K0p6cFREbEJzNjNuUHppOGV1?=
 =?utf-8?B?bTl1UGR5bTM2dTZOb0xMRElZbWlUUnhDNkFqcEJnd3RhbXcvV1NuekMvMHRi?=
 =?utf-8?B?NERjckRIRis1UGl4NGlHNUtVRFh1OVY5UkJSK1FXbmNkOENRZ0R1Vk5mclA4?=
 =?utf-8?B?aXJsU1FQSm9DUEVWdFlJL1d1dElEWkxQQnVoQjk3a2ZmY2NmUWEwQmlxRGJY?=
 =?utf-8?B?VEpMZ0RWYndYSVplcW5HS2VXK24wMk5MbFlWSDI4RFFNMlpaLzBKVElnbTJ6?=
 =?utf-8?B?U2tnZlVodU1QREJ6T2dVZFdWUGVFOFZrd2ZLZThxRE0wUlJjVkpyb25PZVVJ?=
 =?utf-8?B?QldvRnFYcE9vVDZqdE92b3pXOW1uemVEUDJ3UDRvVDUwbEFBbGpFQ2wrVldP?=
 =?utf-8?B?KzhGVTNILzdLSERvakQvazJ6elZYRFZyMSttZHBIY05tNDJQTUtzS2hEZFZG?=
 =?utf-8?B?eVN2c1QxcjZ4OXpnQU15Y0loNzcyWnVyNmViamlUNUh4cTRsdFoxSTcyVlV3?=
 =?utf-8?B?bCtpSVROUGFJR2diL3pJRGF3MUZkNll4SlRJcy82c093WHJMenhVSWhyRmFT?=
 =?utf-8?B?bUJXaEh1bS80Q1FMQzVVR2g3UXJVbEppb3FPYkJxUkFrc2RkZTZUbUExUDFs?=
 =?utf-8?B?OG1SNlAyRFN4bE5lQ3BNTzM4Q3JhVzM2Q3cxKzhRemJTUkJwbzFMUnBld0ZM?=
 =?utf-8?B?bDFLREJ1MjZBbGF5YVF1aVNIUzFHRkQ5b2x6VktIdTNPbGQva2RwK0grMlZT?=
 =?utf-8?B?L24wZ3B6MjRybU5aVG5FWU1leVp2RVYyZStuRTArVHZITXIyNlpxSlpYV2VG?=
 =?utf-8?B?L1lYMU1TaWtYRktSTXh6SXZ4bGpMSmI1bVdxdXZONzNlR1kyRjJPaEI3dUlw?=
 =?utf-8?B?TFNaaVlwSFh6QTQyd1dmQkp4QjI3emZQelRxOFBsVVFOSWVoWXFWdXNiTmZ6?=
 =?utf-8?B?TjRNT2VtTllQZ0V3TUFndndxMHBPMjFZN2NNTmFGM0FMLy82VTdmV2dxR2hr?=
 =?utf-8?B?TDRNV28zZ3diRU9iMThncktreTFBSCtkMDVIOTFwNm41WER4NllQM2FwWHF2?=
 =?utf-8?B?MTlMUUhCRGtsbm8zN2FHZ1pJdnZMZlVoRndCOVh1TTYrUThocjlPNUloS3ox?=
 =?utf-8?B?REN6dW1uN2tPc2pmM2lHekRoL1NVcVBHcEczWllvN3ZwLzlaczB0Y1A5eDZS?=
 =?utf-8?B?V0Zqb3ZiTmpLcnRsSWZPUHdHME1QK3pYTyt4OVBmdWtkUWlZRlI3MU90RC9E?=
 =?utf-8?B?QzdHc1FYY256R3dYVnkraHp6ZmlPbTd0alNnbVBOMFoxbjROdS9JRTlSTVRl?=
 =?utf-8?B?QjBDOWZIb0x5Zlk0MjFRQmt2akwzMm9qSnk0aCtjcFloNXJmdC9pdXQzaE44?=
 =?utf-8?B?NEJBWWJXZkR2R3Urd0tYV3dsL296elNiRUpUcEZwVG1VUm1vYzl4a2Q4aHgr?=
 =?utf-8?B?YlRyNFh6RHJNVkpiQUdzajRKTTBJUG5kRnc3Q3JYclJJOENVRnZneER3cHZ4?=
 =?utf-8?B?TTVpZDdJR3BjUzN1WGthbTRxUXk4VG5vVmRTRUUyY0xtS3FZVTBCN3pGODNK?=
 =?utf-8?B?aWNubUQvTEUxRlJXMm5odWxuWmc1bFNsc3hVejBOaHdoYk53NWYranI2dXlQ?=
 =?utf-8?B?TGQvRzBTVVhSdElGbHF3KzJXZnl2aHpFZEZ4RnN5SUhVQ1RFSTk0RDZsZW5m?=
 =?utf-8?B?VGtFL0pCMkJkdkZkTjZTMTVHa25Ga1dIWENKVVZwSmY1T2x2R005ci81b09F?=
 =?utf-8?B?Ym53V2dMRmhjVFp3UTF2N05NU1JSWmpmdWJqZjRsYzhsSUcvbGgvNkRSNU94?=
 =?utf-8?B?aldvTU9zcE54Q3FIM0dSMk43ZHVlL1U2elc2ZDJ1bGk3ZHU1RnN2b2RSTHVS?=
 =?utf-8?B?T3ZrZEtHems4MnNEMitZdmdZcElhcE92dGdPZ2hZZDY2QzY0a0t5TTVDY3Rm?=
 =?utf-8?B?SWxkYkdMVGl2MjJIMGhINi9TQ1l3cE9mMXAyeG4wck1UVllOMTVvdU9LWXh5?=
 =?utf-8?B?dVluN2h2OFVCMCt1VHZyV2p1TVU5d25YaGJmY3ZhR3h6YUFhYkZWVlhOdTI1?=
 =?utf-8?B?MktPU1Fod2gwb0RpWDBwU0lXSmZuOVIyandHNEVhcFdaT2pwOWJpSFA3RE9M?=
 =?utf-8?Q?L+HIdyrbvp6j+wLibr1Vx3n5YCJSvXO2VjGgs2cyJ1vGC?=
x-ms-exchange-antispam-messagedata-1: lK+VGVdmXbprX5mdx8wda5UHKpIPOkg031Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0861662D81EDDC4FB3965FEA92CEC2B7@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	IJnQK74zGgQkvwQYVbBB5DmnoOWXJW3OjCw8GSGxVYq1S2oxgayjDIhYAXTH/SpeMNi23jaQcFjD15vyLFNeC2ZgIONc4/Q2psQAwq5xK/cSnr6iyOtM0BoZFGyz7jQCmjQutRQBR8y/iq4zI+QocTWYqHQK4JaZqDx0gxtHfUgq0e3d0snaCllDWWeIs3QfBdfrmik5jy8Mi+s+03wlkwxqQzqgrP7uVKzRCgrAi3pO0+PISELVdw9KcvsoegvNqlXYLcI4VViucivffmogoLZ7tYDz7G7ENrLjWP9t1Hm8ZnD8/Pk9oHXIwZ5hZcYSjnjCDOGB/xa+cg3ckA60ng==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631b18da-89d4-43a6-a6dc-08deb29bad1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 16:04:42.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyfEF18m4xw3x9kswHix4+QyBntHz0FPrShPaNcdpqVIRB7xwrtJAumVGl8saioB1GWs0px7a5Tj9bBL5FeNuo6hfgW70vc+bq2HJzsiS6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6605
X-Authority-Analysis: v=2.4 cv=Rtb16imK c=1 sm=1 tr=0 ts=6a07441c cx=c_pps
 a=Xk0cAt2nCKMrkR9Vo+L1ow==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=20KFwNOVAAAA:8
 a=ShDmZdVUfG7688mW_gUA:9 a=QEXdDO2ut3YA:10 a=QbcjlK4JNLEA:10
X-Proofpoint-GUID: 5L0iV5HBCqI89qlimhCuUH_AuVJAnzjE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE2NCBTYWx0ZWRfX7q1q00zG77a+
 58f4jlW1V3GPGq9CJaNq6+ZCBEqUsR95/MTwJ6sb9tt3XYGmfZSRwGmY+63UF+UibmJa0X1EpkX
 M+8b7fiGjpRQguqJt47X9RyEf/BaQvpqYKpFgAu/wQMxFEKomj5eGPsUF0ach0pqjNK8+r4OxSj
 t6keMZMRNjDwKYMX97NBbXTHa7pXon7Vk1/HzQCa/r3e0kr0uDOKqR82cEdPDCTgnTaOpvm5WZK
 Y6oYeXwcGyP9sxRfpPPoajanNAo/wakIsdSjb0eGhfYiiaR2DO14syV+kAlt81NYv5goDh9lo4N
 OBxy4AWdQlwXClN/RhBoQZMI9OwSKSQLHmncuyEabta3ts/SJ1SfG/sI+5qJF0JOkqn9iawzQMq
 CVDUIAmphy2i1KU7ri/Hk2q8aDWkdQxJ1IHT4FLMGE3NoHRvrMacDdYUpl3nBRAI9lnN1BEEQc7
 /Kj9sCOYHgOVQSGPPOA==
X-Proofpoint-ORIG-GUID: 5L0iV5HBCqI89qlimhCuUH_AuVJAnzjE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_04,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgTWF5IDIwMjYsIGF0IDk6MTbigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IGl0IGlzIGRlZmluZWQgaW4gY3B1LWZlYXR1cmVz
LmgganVzdCBhZnRlciBDVFJfRUwwDQo+IA0KPiBFcmljDQoNCg0KT29wcywgb2theSB3aWxsIHJl
bW92ZS4NCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA==
