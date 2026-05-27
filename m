Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1353423BCF7
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897401; cv=fail; b=PUT43hYqNA76eNL7Xks6XmDvB925GpgdlWzFlnZhyVXxY8GBH26bxb/W+w2LN6qlv2/4p8IHdqTQ5a7avdWYqVTskm/sSdAqHnPvb0q6K3FWKa3oO3Z3vki53QsQ+Iy5oBzQBativDmOO1LDDcWRIy0QrTcJYD2HH6k0mB3B8cY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897401; c=relaxed/simple;
	bh=yn6qDzYNxzq70dTvcU2JNA2PGFBB6IOJU5PiobLH9PM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i649X9geZhyyiHH9F2mTF0iWXuNBK3vE0/uyCSE6dNAmcDhaaC4FLD4B1GtheXD69r8h7kEmekbgJEkOXRNbsKvq1azXWpAXBwJrRF8ssv5gx8YI2X1AsqLX8ZP4idlTjLTPQJ6cT3o6pVQCdNlJp1FPVWvYpNABTkWfQu6Kg8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CV3MqnXN; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vpJtcEo3; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CV3MqnXN";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vpJtcEo3"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCratP2640878;
	Wed, 27 May 2026 08:56:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=yn6qDzYNxzq70dTvcU2JNA2PGFBB6IOJU5PiobLH9
	PM=; b=CV3MqnXNgzgfXQnzVcEOICmv5YwYfMk8djtq9ff7sQDjciwK4CehrECnV
	iFXrU+qF07g2eddC9P4mvHaNzE69XuZESKREIRbSjb1XJxdGxUObAw8Y2/7M9lVP
	+mCzC3TdSqGhjfq/s3Y+Pz4lqFZ3WoTc/mPxf2j4za67gpYX8v4E5Dy/W446nXdm
	IpB4bn/XX11dcrP6e3FOSdbeSh/mHJjeIdEQhnrN95uB2Bocu/TbNPbauBKj0qf3
	UqNBYuhm1y2YSEe5ptbQINcdIBpXhbROe8YCtGya0ZMWB/FkGQBxJzM0cY/k50MJ
	HnA5ReIdhtJPiA9qZZdcj0IydGy8w==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022100.outbound.protection.outlook.com [40.93.195.100])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edkqt26mr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:56:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G82CYiREu8RUoBny3JNLNm8sb+FCU+tEBPaynxvII8iMLygYuffzAFl/2+5d6jLCX+btNcLxwrKr7q3vcxK89bAxbkqos0r+HAnvzeMnnQKBd4RhBQ61w13J8js1vgkJsz2FBcD222tlu9IDR8X25dbHjnSe7a8vtAKjlcVTo58TCbTPwfVB+kA6jWv+Xq4d4x37xUHOxllIrhqmp4/aa1Ft+fsQORZz3VspyQB2CL0gJRrOz8u/j37TMqzeTRFzhMez/d0iAKfSITnrlXsiHUPMdRMaR4l0dhyyLeENhFOlWGn6rcv6lukg99fwz+tlHChcGEoybAvJM1YT92xJTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yn6qDzYNxzq70dTvcU2JNA2PGFBB6IOJU5PiobLH9PM=;
 b=faYuAI+SwVOTwnUGINwe8AlNyvi1gUqs7hx1WFqBv5aT1oJ8567Cc4vfZf80X/OQRu+IYFAL+CagKVbZ4+DWwbozAiDbF1wBxGGVNvpOs+TUXxBJhbQuPFgNJ10/vEgrwV/qAU3t6LvQHeCBt0/MxoBHPSn8yZWfGF8f49x5bRBEL0YwiC6sczAf1eAkz/0KkOQiLOnxpq2q3IU4Ef2jbfWUf+j5Dyb+OC0M8O5FiDhxSRBSKp6YHJz5qI3tZBcqTJYBYb67RSCqVidWlebXtykWoGgjgI+aIkaplXF83YptI1hEYHP3N8MMJ3n7+8ufNXvJHHWkhJpqw7xlEZuPUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn6qDzYNxzq70dTvcU2JNA2PGFBB6IOJU5PiobLH9PM=;
 b=vpJtcEo3miC/YgY00hadgvghDCEZKUfsjPCSmM51zWFe73hOvkof39o4Z7y2miOTNDpY1FBAUPlF9L82r/b5h8kctUdsUuwtE/WaNDZJRb9RMwdqD5w9sNlX2hIToVLPWmF50x9rbOUvRd2k0KLyhHm2ZjSnYH/f6dtp/Kr7OThf3EsYc5MJVdZVgrGDBF+solWMmJzSEOmIdztYIhFXN1QhOQabZ6lp6khAdBmhMnydPpFX62KegS3XIH0yLKyyxy6oKQESM89Hmg2OZFpb7ybO7rPk2dYQCv3HqNdnjG6NzrVhygBiVKrX2fFLi1Yjz1bcNHEbi6dIeD04VRgvog==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH0PR02MB7865.namprd02.prod.outlook.com (2603:10b6:610:ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 15:56:09 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:56:09 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Topic: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Index: AQHc55PDWfKVatqEQkCeq1pFPAd4RbYiCFaAgAAJ0gCAAAFOAA==
Date: Wed, 27 May 2026 15:56:08 +0000
Message-ID: <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
In-Reply-To: <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH0PR02MB7865:EE_
x-ms-office365-filtering-correlation-id: fbfd4a5f-b16d-4a52-e9cc-08debc0877eb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|6133799003|18002099003|22082099003|4143699003|3023799007|56012099006;
x-microsoft-antispam-message-info:
 mO6TnxGy4KPKdTNTmi03OCYxHM+th+w8PLSPo1seYuiZi0FOfy7RLyznbJWpjneISTGa3zPXsOl+IpxUvAGYudG7o97ogBqYloZJpi8HR62D/belBqPEnieH7M9fvYIBsYsSoEYIk6pHz5yKHi/8G9HHFA58W0nFW8alQXehSjLwKHVIGfdKyEH1cvgQl4JbNp4UeIs1A//mDT767poLVG78gAm7bsU++UBTGyey+8cPg6yZLQvbVtlR48egonoU//9P9ZN/eRli+DsONgKz8JIhG5aD+qyn5bL8vjt8hlJ30/0WSIZ4eF/iNj1lwgoufFZqIejYWXVSdVL5Ysm9kmfH1ynbJR6hwcktctigkqB8rNpCk61E4+4q1HBB04hDtl7DERCthQZFwvRqEcddcb4MHiZ3TiN/0uKeyrKDdlOh7LBvbhUNJI3FiGDOdjk2Brr53Uq29TM64XpETgQ7yB+EeEdTHAYEc12s6ezRfzONOG/ltk7Pjb5ZPRPzhfSao2ZB4OcaCgIEJLa05gLEE5heq/FgskjvOUppIXOU8B8psBhBeQTvuLM9ArH51jcchU28ilUjxT/WFjlZ3euLGNdUEfMlpD2dfJlxCYk57CiGpOiPMYBbYs1TEGGyX0cFLiwfiagVoHTeni5b59w2hzqNFkr3iDU2Dnbgljug0ziWkIypNqr7DZVhWvYAlmQQTipfbdtvB+8ZVTw8/NgbQ5grHR37oeNQN12//xYS4Cx08WP/jwgYcZqgXQUerF/Q
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(6133799003)(18002099003)(22082099003)(4143699003)(3023799007)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VS9Uanh2VkV2MWxwa2l5WTdvOGJrWWRuWnNHVjF2Nm5Ic0tzODJQVjRKaFZ2?=
 =?utf-8?B?OVpHaTRCUEo2T3hFYnV2ZitmbVpPRlVOZlEyMDAzSm5mSXBHdkd3SndNQWs5?=
 =?utf-8?B?R0Z4M1NtcjZpdmNOMU1mcnZLa3V4T0lla3IzWnplWUtwTG9oZVZUVUV1ZmZ0?=
 =?utf-8?B?am1UeXJoMllyNlpaR2luNFpacVJXTHVhc3dLTkJuSHcyaCsrb0FXNXhvdHdB?=
 =?utf-8?B?Y21JRk1hd1lVeVRKZEtHWHk3TGpLQjJzaE1mcysrWVhrMzRBQmNwRmJYTG5E?=
 =?utf-8?B?eFBhOW5BMGpZY2xYVU5qdjRVNmRPWWprbGUzbzRSWXd3V1VxS1hLSDM3OE11?=
 =?utf-8?B?Ri9ETlJ1OU1nMTlkVlB0dk1NWnpQc2oybVJPdUM4c2dWUmE2ajU4MGRJY3lL?=
 =?utf-8?B?UWd0ZTJMemNNQTNVRFRBQWN2alpqYTNCb0xmc2hyUTJla2hjZndhUjBMWndL?=
 =?utf-8?B?dmNRakh0UUdlVzlCYUNra0ZOSGNGcTBXWjBuZ3EwTHJLNk5INkF5eXQ2dEdJ?=
 =?utf-8?B?aFVFcGRsMGFiN2xKRFdFamZhRlBYcFVxN0FvaWxkOXFOOVVScDAxbncrSmI2?=
 =?utf-8?B?Uk9FTkRxdys5M2srZktiM0Z5Vkt1cDV1QnFjMXl5RVZ6Y1graWk5OWFBQ3dM?=
 =?utf-8?B?elNiOFpYbjZkTURrYUI4YiswNXVpVDBDYnRUS1AyUnFITHJPLzhQYm4rL0gw?=
 =?utf-8?B?OGJ6bXNXcExaYThhRVdPS1lTTC9TSjFER2IvL0NtVkI4VDI3QytLUkdMZW10?=
 =?utf-8?B?LytRUzJoV0x4akZkODBMRUhLWHpsVHBjdUJNVUUwdWZuellPSTZZa3lYRUVZ?=
 =?utf-8?B?N1h3MWptS0ZzVStza2tXRmFycVlZaWdpSS9KUkhWWThvZGI1d3o3M3N5Ylg5?=
 =?utf-8?B?aS9ZN2lIQzNEQWpZMFpvUkRNYXNiWW1YSnAwTFliTGFLN281bldXWHZ2UjZz?=
 =?utf-8?B?TmtVcGtIUTFMdk9UTlNSNXd2UkVNWFRMTzVTRTZUdTJReVk2aGdXUlkyUzZr?=
 =?utf-8?B?ekgvRzA5Z0R4a0hYeE1peTBCcGNsMGJUN2NUYWd0bmJwWURuemtTYUd1QmU2?=
 =?utf-8?B?c1RwZTdHQXBmcHRaR3lwbGhVanNNNEVrbEo2bjJxOGxTekR5ZDh0M3pqamJt?=
 =?utf-8?B?S0tiVDRUNERKMzc5bFA0Uzh1emFFU2JnVXcrWVhwbFU5KzJqU2ZsMEwwK3Zw?=
 =?utf-8?B?NzlTRkF3TXdmOW9uYWhyVEhMSUtCY0laZWlDVGdUeURwTStMRVVRZmVqYjBH?=
 =?utf-8?B?Z3RFSlByVmtuVjNnRWM2Slp3SXNoVk5GK2tRZit6dTl1UlpObENMd0p6dFZK?=
 =?utf-8?B?b0lSS3hkcTRUN3FCNi9jWTlsazI4ODhiN1VvMmVta2hMRk5Xek1xUExGemdZ?=
 =?utf-8?B?WVV0NDgvNVdqVDlPeENLVUVlT3hZZDQ4d1RTV3pXOEY3M0JIaGhvRnJlQnha?=
 =?utf-8?B?RDUrS3V6VjNZSEtoWTd4RDRiMFp2Q0lzRnA2OG1PUGVkQmJmZ3IzRmpUZDlH?=
 =?utf-8?B?T3Nvb1RObWJ0Zld4OXdhYWdVRmNCN1BLWFc2MEN5ajFZeVptMVd0QkhSWTZR?=
 =?utf-8?B?VFBhME5TdDB4SXZYckdtVFpTeHgxcjJkZ2wyL0pYcFkvcWErK3RHdzU1M2Z3?=
 =?utf-8?B?ckRqeFRWa3FEeWlXdlkvcjZUNHY3U2tkNmV6QWg0ckFsd2Fod2pPRUtpUlFY?=
 =?utf-8?B?aWVRc1JTcWlMME9VbkpydUtUZkpQSnRaYTIyWTJzL2pXWHloNEVneGpnRWJX?=
 =?utf-8?B?ZnVmUk5EZklkRkZQc3hOVDFWUEwxS0c2ZDR1aVF6cm5DSEdYSHY5SXVPN1dt?=
 =?utf-8?B?WDFXQitOTy9rc1ErRUVGZk1xT2FNSmRFbUU2UGhDL3N6Nk5IOUVLSXJQcjFU?=
 =?utf-8?B?ckN1NVg5ZHFnUk8zTlBXV0ptRjlaWWQvUEJTSUxaSkZsbzVIM3J0em1iSUJZ?=
 =?utf-8?B?OEh1UWZBeFFCV3ErSmsxUklOenp4OUlpeDl3cXVhODNiR21YUGFiUngzOFFL?=
 =?utf-8?B?SmZqTmpZYWpWdDErMzg3dENoTXVIaTl3TXZpazBXVVFXWkNEa0dLcktFOGYy?=
 =?utf-8?B?cXo1NHgrUlVCbDkwa00xaktENmFnYzdFb0JrRlpuMENGY25VYnZEdWlXbzNB?=
 =?utf-8?B?ZXhEKzVISmw2YUk4QXh4ZXpXSytHU0tuUFdJVVVnMmVMWHNobTF2RDYyMVhS?=
 =?utf-8?B?ZjRzKzlXcWFFN0lRTHVnMTFuUUxJT2hhL2VndUNyWDBCbHIwZWo5RWR1WFM4?=
 =?utf-8?B?UVVvNFpEMVBwOTVEZmxlOWJPbURmKytxWTB2Z29DY0ZmR3B3ZGVVcTk2S2Rk?=
 =?utf-8?B?ZmJKN3JrTHc4S2tFaU1MbERRUlBpUW80YlIyeDgrQ0x1L0V1YmFIbGNPZ1ZP?=
 =?utf-8?Q?z8REiWmY+Q5VCLNU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB46659C2E097348B96568D4D59CD092@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	O4Is58Dr3eG+nvFN4H+Cf5+yVDyBFzmU6x6KoBEhsjlYVqneqjZcXMgGe6Gn+cBEVcUt7vl2vgSPtREZXchuERSvGpPL9QcnfphqwLcXTNDcFNTLopHeYeuCMlnG+0jAFdLHsQCg9s3SIcXCRoKkjrSiroPBjpnFUk/eBpSUCppRZL9EEQOhAa5827R5D+0Yxd4wg+j91tjSR8qtTwislUODN0qMOJ+iWNn6jui5b7ZqEKcyG2C6pPYk+W9bxocBsRJKqLdHbVDb71EnMoQX4tHBXJJUrqSdKNhVdxiwgp2nqjqFHuxWQZYF6Ocdwl65pe+rnr7PWQMv9naZ2LGvPg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfd4a5f-b16d-4a52-e9cc-08debc0877eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:56:09.0102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+R/w4BeOgaz/GHY/emRnhnSRIZqJytzlbnlkSIWif7mZzgj8nWqOideTglHbg2a/Xe5Tzn6eb3OlZtL7pp2e8IPjq+di+XwcP/CaW2PcTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7865
X-Authority-Analysis: v=2.4 cv=Z8Tc2nRA c=1 sm=1 tr=0 ts=6a17141c cx=c_pps
 a=NdJUlaw63gEkhoowhPQriw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64WQUjaPE_SJXXZnpz8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: o7P8ScgH2zuHnTqyQ-6YP41rLfuk5DJ_
X-Proofpoint-ORIG-GUID: o7P8ScgH2zuHnTqyQ-6YP41rLfuk5DJ_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1OCBTYWx0ZWRfX/oBtQt+JURqF
 HmW75MzqLary8hDpSG4PfvLW47BBsbXFKSgUHOQkHtDz7Rruxm3gbv0sYtbPdhfZnlWr5Y4hWDN
 vlzB+frcQ+dxgHGvJZI/FjsSq0nN3F7LzsEUl+2enGislXWvNp6MMGOtKDwYvlUfcVgxuUhkOg7
 YielAzKl2FgWfx8t8fe6b/PztUV2nBTDopc+kalKaekaVjFQQoNUjD7+vHijzTtt+YuIFxhh5R6
 g0NGIQaaYPvVSVg7E/JsXN4mqacDTdVIkhWjB2Tvk0DjCfenFLmkeZBg2ADG8UTBGYKHBXxra6N
 lB2gtRIn2lIEqHWAFOXjJrge0EnP/lmhqIJpre1K5t0F2VMifrlzpYB6sebJD4fDBxuPwglsE+1
 Q5w44Hh+ZlpswA4tXb4chozPE7rR0tcTTDHnnnBDGz1+n8tXYh8duUKew7ptBkRsf4EMmFFBghf
 VrAibg/CWyb/eSdQ5Mw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjcgTWF5IDIwMjYsIGF0IDk6MjHigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEFjdHVhbGx5IEkgdGhpbmsgaXQgd29ya3MgdGhh
dCB3YXkgYWxyZWFkeSBiZWNhdXNlIHdlIGZpcnN0IG92ZXJyaWRlIHRoZQ0KPiB2YWx1ZXMgd2l0
aCBJRCByZWcgZmllbGQgcHJvcCB2YWx1ZXMgYW5kIHRoZW4gYXBwbHkgdGhlIGxlZ2FjeSBjb21w
b3NpdGUNCj4gcHJvcHMNCj4gDQoNCg0KU28geW91IGFyZSBzYXlpbmcsIGlmIEkgZG8sIA0KCS1j
cHUgaG9zdCxzdmU9b24sU1lTUkVHX0lEX0FBNjRQRlIwX1NWRT0wDQpRRU1VIHdpbGwgc3RpbGwg
c2hvdyBzdmUgY2FwYWJpbGl0aWVzIHRvIHRoZSBndWVzdD8NCg0KV2FybSByZWdhcmRzLA0KS2h1
c2hpdA==
