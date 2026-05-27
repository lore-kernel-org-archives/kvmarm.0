Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85353421EFB
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892961; cv=fail; b=CNoMHxmSi0Hui+aInUiQbqVZgNQdqXszl5ZCnRv5huqEv3LYttU4g7TQ5mBTNppVX/P/5sQdVHKPeJug2BnOd+M9QQgrn8joxTT1gzVXjkd5dDq48zrw9UuIVYy/pCm2LvDIOdiqeV/xxHGoGwww7Vt4cLNqtRT/rMmqnG+g3r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892961; c=relaxed/simple;
	bh=Fjr3R/dobwomoWbu9MzkS0f0fFfzC/tHzzlnKccIwAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JJYstdkGHqrvXLNlJxd0KjQfJOwEmXvJ968WF91OTid2dKNvpmzoC6Z+hsBevghbSoegW5ETdfb0P9VW0zDpuPmLV43b5D8qwit7uFsIJCQkOJoC58x5Q3iMAI7XRgWXCYkmcYNeylLNIsf4PeolXyZe+SynZhqZBqd7MyLiQV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EvAK9XBj; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pEgWlRBf; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EvAK9XBj";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pEgWlRBf"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCsVAB2543364;
	Wed, 27 May 2026 07:42:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Fjr3R/dobwomoWbu9MzkS0f0fFfzC/tHzzlnKccIw
	Ao=; b=EvAK9XBjrU2++mTQhlfGxWLdfAS1lgcpcuwLz26B1Q9paVKPgp/V0/X0Q
	bxECkOu4HaJlEoKOkFlFXieyO6hJ1QuL+C+GDgZn3Qq/Lki3m+OgSmfVt1b9e0KU
	9HMJ7cBZaoYMOUvtTg4Dxoyp5aXHXd1Yq2vmtBViKrsOETkypO9m+wl0eYCLw5SW
	gssOqytV9LBDoCUCBi8zfU9H5QaNIWmJIe2D4QyTMhy75qCIPNUsN7aH7g32eCju
	b5D8LasTJ4T5N5394WMCwo0RuhKCgy7fZj8GE5/scmnAVYwX3/ifZOYhKaCVPgCU
	Ch6J0HjxkPGglAmwjXB1yn8EUqL3w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021139.outbound.protection.outlook.com [52.101.62.139])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edg3mah2y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 07:42:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eX64jBETHlejM7/ZFHWWE9twaw7BdELqKZIEwZKAvEwUzZZWrsegriplMVmfxn5fyCQSeOg7/15EPJInORQSAM/ffXl9KQobNSKpx/74LweppIHoW9NY8lflgJLfTBsvFhHa5GFKnccDEYEgtjEx5LLc4gwlyz/YGdr3xPaW+CFbIJCwBZUrHwgPBivySFSNDaj14dcdu3rmW6kWpNkN37Nn0wBiLN5Yl2ZHYOasNxi80wSO/nD23LCQHPenKxFGbhZBa6wpNNK/uGa7P4NchVzgmuZHjoCUx3sv/NAHiP31b9wb+7HLt0ZM1k5dBINFszFMAxLvlXXZGTy+U4i9LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fjr3R/dobwomoWbu9MzkS0f0fFfzC/tHzzlnKccIwAo=;
 b=chyGaWfgyA8tM3zlDRgtv4TjPEhveO3P7OUfTVawF8UAEMSX9ZghFj6vaPGVKO1vizpAechS8QRgIb7xF/sJ9bux//+x7tCv9jGgs2Io/ssb2AlsfbRJp5UlFZCkhmtJNKsZw9Q0b1xbxG1+mPULNoOBcoeu33xLuPSaU9ePczf2hF54irC/OH0JcutMIgHILZZiCvzdjrofY1y652AwJd8oyuPOtbl5YTNz03SGbXyjRY+h+qjBZvL6HYd+9gShTFbYcK4bBUJuJKOl8HzoPOtzHgCOxJcdcVFlGa27DJzFrwXt2CJogHXRR4CA1Vx0Daq2RLE8EsT/Mx8Ir845WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fjr3R/dobwomoWbu9MzkS0f0fFfzC/tHzzlnKccIwAo=;
 b=pEgWlRBfw9kh8qBXhpHpR3TBh8kRXPhIx0Zs14TCZkw2GozHrNd0BRkzRl0AI6FRBHfIqmEkdGtSHarCfWQZAupAcAcuQealo6MwVQr6brEVIJQ3KWkL8FKZsXjkwSbhgCz9C3+nEnyGiokx2SE4kTcbLox4vxO2Ibi388WcVqK6QrGG9xWNNoEGdFraYPU0g53fNy7MSd0ZwssXh0as0GWJqHm1mOLavcEunMzzBafMaDFjNzWBuiBYwlyD7gID2BQamZaEPXvdZrnmFFkTKPK0yrwPwkQR2ESg1ehNA5teb/wfZNASetnpeaZxW4i16ak4ZA0aLfoW3NGJ1WLJLA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ2PR02MB9368.namprd02.prod.outlook.com (2603:10b6:a03:4cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 14:42:01 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 14:42:00 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
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
Subject: Re: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Topic: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Index: AQHc55O3Z83/o4B/sUidnhGgkCnOE7Yh/r8A
Date: Wed, 27 May 2026 14:42:00 +0000
Message-ID: <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-13-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-13-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SJ2PR02MB9368:EE_
x-ms-office365-filtering-correlation-id: 5c768f2f-6e57-4453-8ef2-08debbfe1c76
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|4143699003|56012099006|3023799007|6133799003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 Kli5Iqt1fBGguXcH+hps9zNQH3arhvMroJQ2caZe2xOo5WGya09Cu8xKr7GMidMz/gghy2Gz9WSHkz3lMsKUv9nqk9FFDWbdcgsWAFtCRO6G1AhMudykSETFarerIA940pA2iGGhh6CxOq322IOou1pQ3CyPstJvyY4fMa7lCKotOJwRhV5logg9BOtv/RN4wFR2G981jB+dfpkUULhj91Oxp4BPd+Uhu2avu1NF0/q0ciLRyqI2pc0dsOc0VbNvX8ZUP5uwk6srKtkA1ZXwChVS1yrqYl1HKo1KC+hRv1+ZSPeQiaTPu8vBtKcJUZBbgSbV3hSTN5bOCnSJyqh2U7z/blbvUIoRzE9GlqvASzDvHwgIaFT0LBtRqb1mLjldkcKe91kHdDhbOrFXDkzudgbVF1GQUyjFHf4Etx4Ek9JEWuUfhiG7m4YRHafogQsAHtQlI1Mw8Oe8mYL2jXos8yQtBPFkAukS7+a0I9vZpTKUu33xgBHMjWJG+7Qddwy30l5scUPgLuA/yB9gZfi9yqALQ0DZ4sIxXEa5H7k+/je2mZeJjWk5vtvOdtYoLIqecxbbTOyoQ2i69n7MO9ZFWG2M4ZHtgGzgzN6OBvLmp6s4f8EJXnMHD/bTu1rzDF9JvfECCTJvUCf+KXU+rKKGl7X+PGURLNvZlsNjbPGtSZvPuH244iEO1419mTxvg1ORlqk+IkM+ZaxzTii/jBbEEjLqfENiV6TtcBHpCFqmoWecD1XzZFbXA7gaFiAVXG9e
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(4143699003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eHVXTUFUazg0UkFLZUFDZWhrazhicGhXQTQvK1pUdWtVNWtXUkpyd2wvSzJQ?=
 =?utf-8?B?dEJGYlpQRUtHUDRHOWxoTHVhQWwyWnBhU2MremczcUgvQTl3c3lVcXEzWlBo?=
 =?utf-8?B?SExFUURBRVlROTkxRjFoSk9lSWN4c1NXbjlybmh1ai9wbHhtV2VxTUFNRjF4?=
 =?utf-8?B?azF1aTY3ZjBYcXVRUkd6b3F3MTBZVHoxbDJTZlQrQkU2MlNsZk45Z0JNYk9J?=
 =?utf-8?B?bVIyajUrMXFvV2xqRktzM1hPYWVFTk9WQmVnZTcrU1AzL3krdlU3elFXaEw5?=
 =?utf-8?B?a0hCajFGWm5zaEVxd092VkkyK1VMVVBHSGE0WGsvaUlaSDdmSGNMbUtvVDlB?=
 =?utf-8?B?bW9tRVlDNkczRXRrK3FJU3lWSHk2c2Y0Wlhob2pmMU01TlBrOW9YcTlPbVp4?=
 =?utf-8?B?NnZ3Q0Z4blgzdzlWYWE3OXFrUHFQWHhIM0FIcDNwZUc3c094c3lySitzQjF4?=
 =?utf-8?B?ZWRoczVzZU5zYW1GYTlqbkpjZkJFRlFaNWx3ZitjU0x5WnRJM0hUVk9iY2t0?=
 =?utf-8?B?UnNubVJ6RWpNNlJ4dHozSXZRNUxwNUM4czRkNjVDK0dkV1pXNHc1bWpMbzhj?=
 =?utf-8?B?WU5WMVplSEZoeW0xbDJvZ0MvWHBpbFI4dWhHemE5SU9EWHRIVFhEK2xBa2xO?=
 =?utf-8?B?RkJITkFKaXJBMjBEcWhoYThrNEh4OUFnM00rUEJWcHA3YzNRQ241SHNGV25E?=
 =?utf-8?B?VFhHakVaK3Zzb21sWlFRM0ZHSHl3QjFJNEhvS0dLWEhsR09FM2ttYU4wVlQr?=
 =?utf-8?B?Q1RQR3BucW42R1UwUzlwY3ZPWGpKOGp6YlgxTUhjK3RCZEU5MXhNeFNXTGdS?=
 =?utf-8?B?TDVSRlc5Z0Z6RVZQTks5UWlHTmlPOWZpSzhWcDV0NnhFSzZwa1cxWWo3cUU3?=
 =?utf-8?B?UnROYzVmNjVjZzlVSGk0SkJ3b0tWU0VsTXZLUUFRUGkxaHVWczJNUjdWb1Zm?=
 =?utf-8?B?TG4wSld3U0IyU3hlSTQzSGNxdFU0cDkrd1ZCQXRLdmNBbHVvNTA5cWNPc0Zy?=
 =?utf-8?B?TFdwR3VqTXFKVGNobkxvTFQvUThxT3MrSk5yV05CbXQwSldyWkpxNDNaVzNT?=
 =?utf-8?B?TzIxdHVsRE5xMU1mTWxaVHl5SnhrOU9wSFRWMzJOTjkyNUtYc3MranZ2RkE3?=
 =?utf-8?B?bFZOTFVnUjR6elJ2TGJSRGVnbFhieE1mZFZrclo4MFlTUGlSd05qdnJ0T2Nq?=
 =?utf-8?B?RkFIbENvbjJDbkRGemJnNjhWVDZVM0U2NFJKL1Qwdi9yTVpnNjNyZGFwbVhk?=
 =?utf-8?B?NHVwK2dQc2pLaFdTRC9aeFdLcFF5dHJSWFk2SDBvcEc4NWNLS1EzNHcrbkUy?=
 =?utf-8?B?ZlZXMjlMdHFZOUd5Mk5wK001REZHOWRjcDA5L3NXRm5aNWtWZ256NjNaUGds?=
 =?utf-8?B?UzFYK2RVSzZBazVmc3lReXY5d2R4WHJTdWVQRFA0Qjl5RnFIemgvekt1cG4z?=
 =?utf-8?B?dFNBd2JYSnJ2SGVTZUlaY1IyYkN1QUJ3bTNxODdueTNCdVBtdDlUM0doQ2RN?=
 =?utf-8?B?a1ZzeUwvWkNlcUxsdTVSQTZTenBHWm5WRkEzWWl3VXpiT2d0bk5nZTBZSXcv?=
 =?utf-8?B?c2RkdHZsMDdIRFk4ZWJQTThQMkt2ZFovVmlXWEhpb0hQTUNqZVdBWDBkZzJS?=
 =?utf-8?B?eU40UG5xeXRLSkQ3RUJTSUYxdmZLVFo4QS9BaHlFL0ZyYlA1WVhEVC9LR1cx?=
 =?utf-8?B?OW05LzVocnRqY3YzeE5BQ3FNZWIvUm1FMGlHZTd0UmVMWFArMG9HQktsejZP?=
 =?utf-8?B?R2dGc3lkUWx4YWFFb040R3NMeGZYSHFMT1Z1dHRweW9ub1BEbHNQM05vOUN5?=
 =?utf-8?B?N2xMZkJyWXJGd0JnWFp0cGtHb25BYUVHSXNObENXRnZWc1BKRHBpYUdOUG42?=
 =?utf-8?B?eTJNRnFzQURGaHI3NHZIODNSSWxJTmRnRHVUMGFXQmFTbytKaFlLd1liUW1y?=
 =?utf-8?B?bElXQ1JOSmJ5TFZiTEZVRWlrRnBCU1dyNkVVM0tmL0Jpd3NJbTdQVHZaT1pC?=
 =?utf-8?B?QXdMZEt1N1hZbnJMK09xSzdDbFQ1WHBrRHkwNXJZeksrMjhNT3R2RFJiMGZW?=
 =?utf-8?B?ejFEcGYrcVAxV2YxSFB4QzAxZFBuSy96U3VwZ2FEWDVrdFp5a1NIMlNtWEla?=
 =?utf-8?B?aHM2eDM4MStobGtxVDV6K3FNeUdIeGxNOG5KR1JpdjlxTi9KV2xaVmwxbW9Z?=
 =?utf-8?B?NDZGTXRFS0ljbDFQeVlJOE5YTXM1cG1nbXUwMzNvUnRwS3dpWUx2bFlnK0xV?=
 =?utf-8?B?aGtjaVRHQkZUNWp0cW0zQXExYndSUDhVVGJCd0N4cVhSUnQ2NHVkOXovZkwz?=
 =?utf-8?B?bGdGK1N4Z2MvOWlJSVl2a3V4MVJMZTdLcFBpNjRVNzF2NWxYTmpvcDRoNnJV?=
 =?utf-8?Q?7M6+RMP8tnDZJMf8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1EA8CEE1C83274B97C8692B50AE2F11@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fhObaqybFt50cKdi8fe4wimYx4Gdql7L0IxrjVyby9/VY/+JupfIcT1vmyjj6L8n339NJTsRlB1+3oXoRt7kUM7g7ATd0ofWihnkt4yD/kG9tQv46/VWG0bB7JpGZa35+AYn7ylXtOmFHTO3ErAu3E+GlYURSmrpKCtMqVAQff+xL9SwzR4OLPDdmYkP5DUh5xFFvcOzG0t2D7foX855JVFT8sMGX3gsKg67AwscQ1M2pEP9mqOEe98auui9GzMph42uHj07zafiQM3A4hw7vTecbnj4t8s7mAV6tYIDgyHKOSji5N50+IdVT/4yT0tMK602gzNmooMQd1rEs5ByTA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c768f2f-6e57-4453-8ef2-08debbfe1c76
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 14:42:00.6665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6IFnx2g3UvFictnvwEUYjFJ9ZMNYhHhofLcbWTdrKn7r9lrdoy0wbl3pA6I9DtlQXaevqMJecKNHn7gDdy68vRlzA02ibviJjwBvI6vJNCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9368
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NSBTYWx0ZWRfXwTsW6zvim/26
 Vb5eN+pr4zGS5cxVnI5uoJ8udiYTp+dJ29GYSjZlo+KH912VUffgmIsdUE4WsEfOfXbSWfTNny9
 5IfqDxY8jdNDobpjzgwJV3dhB2qJkDEWdKPSIisinp0vyhqclDzVIJo7zdwtd5aj6USAe4tGtBl
 IptFM9p3RfNB/5r2DAR6TeQ93h+tNszOE0/aNse3asuSfmUWnvAFRL5xhuQWsRBjCvp0EuwHV+2
 aHLS8xM4zsYIYmxpYsj67gejJY52CCofMb9XrrxvL6W7xiixe6NMubGWsNFfdQjZRiUjWYNwFf0
 aRm038UbX6DU/w8abPbljMgMmX+cNYhg8ZEOOMg+4O1eUKwwvx/Za5m0HYGdfnjNmWPp+Nsqefk
 l5rNtGaT6Af9CLnEnuOxOOli/7RJMjMqzjvOMH5Isa9jWxknrxMSgFdqZ9vxGm2QGU86UNN4AWH
 muYsm1j+SBEMvTgfnxQ==
X-Authority-Analysis: v=2.4 cv=UZVhjqSN c=1 sm=1 tr=0 ts=6a1702bc cx=c_pps
 a=KLoCFcM1m9TCm4209S5ttA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=aH_s0YqkBfblIiOQpVEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: hmhqThxxLjgn_Je3K1iXXrd4nBVh8itm
X-Proofpoint-GUID: hmhqThxxLjgn_Je3K1iXXrd4nBVh8itm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW4gY2FzZSBzb21lIElEIHJl
ZyB2YWx1ZXMgd2VyZSBvdmVycmlkZW4gYWZ0ZXIgdGhlaXINCj4gaW5pdGlhbGl6YXRpb24gaW4g
a3ZtX2FybV9nZXRfaG9zdF9jcHVfZmVhdHVyZXMoKSB3ZSBuZWVkIHRvDQo+IGNvcHkgdGhlIG5l
dyB2YWx1ZSBzdG9yZWQgaW4gaXNhci5pZHJlZ3MgYXJyYXkgYmFjayB0byB0aGUNCj4gY3ByZWdf
bGlzdCBhbmQgdGhlbiBzeW5jIHRoZSBjcHJlZ19saXN0IHRvIEtWTS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IA0KPiAtLS0NCj4gDQo+IHY0
IC0+IHY1Og0KPiAtIG9ubHkgY2FsbCBrdm1fYXJtX3dyaXRhYmxlX2lkcmVnc190b19jcHJlZ19s
aXN0IGFuZA0KPiAgd3JpdGVfbGlzdF90b19rdm1zdGF0ZSBpZiB3cml0YWJsZV9tYXAgaXMgYWxs
b2NhdGVkDQo+IC0gcmVpbml0aWFsaXplIHRoZSBjcHJlZyBsaXN0IGFmdGVyIHN5bmMgKEppbnFp
YW4pDQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2t2bS5jICAgICAgICB8IDY5ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystDQo+IHRhcmdldC9hcm0vdHJhY2UtZXZlbnRzIHwg
IDEgKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDY5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0K
PiBpbmRleCA5MjIxOWVlNjJlLi4zMGM1MTc1YzY4IDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJt
L2t2bS5jDQo+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gQEAgLTI3NCw2ICsyNzQsMjEgQEAg
c3RhdGljIHVpbnQzMl90IGt2bV9hcm1fc3ZlX2dldF92bHMoaW50IGZkKQ0KPiAgICAgcmV0dXJu
IHZsc1swXSAmIE1BS0VfNjRCSVRfTUFTSygwLCBBUk1fTUFYX1ZRKTsNCj4gfQ0KPiANCj4gK3N0
YXRpYyBpbnQga3ZtX2ZlYXR1cmVfaWR4X3RvX2lkcmVnc19pZHgoaW50IGtpZHgpDQo+ICt7DQo+
ICsgICAgaW50IG9wMSwgY3JtLCBvcDI7DQo+ICsgICAgQVJNU3lzUmVncyBzeXNyZWc7DQo+ICsN
Cj4gKyAgICBvcDEgPSBraWR4IC8gNjQ7DQo+ICsgICAgaWYgKG9wMSA9PSAyKSB7DQo+ICsgICAg
ICAgIG9wMSA9IDM7DQo+ICsgICAgfQ0KPiArICAgIGNybSA9IChraWR4ICUgNjQpIC8gODsNCj4g
KyAgICBvcDIgPSBraWR4ICUgODsNCj4gKyAgICBzeXNyZWcgPSBFTkNPREVfSURfUkVHKDMsIG9w
MSwgMCwgY3JtLCBvcDIpOw0KPiArICAgIHJldHVybiBnZXRfc3lzcmVnX2lkeChzeXNyZWcpOw0K
PiArfQ0KPiArDQo+IHN0YXRpYyBpbnQgaWRyZWdzX2lkeF90b19rdm1fZmVhdHVyZV9pZHgoQVJN
SURSZWdpc3RlcklkeCBpZHgpDQo+IHsNCj4gICAgIEFSTVN5c1JlZ3Mgc3lzcmVnID0gaWRfcmVn
aXN0ZXJfc3lzcmVnW2lkeF07DQo+IEBAIC0xMTg5LDYgKzEyMDQsNDAgQEAgYm9vbCBrdm1fYXJt
X2NwdV9wb3N0X2xvYWQoQVJNQ1BVICpjcHUpDQo+ICAgICByZXR1cm4gdHJ1ZTsNCj4gfQ0KPiAN
Cj4gKy8qDQo+ICsgKiBDb3B5IHdyaXRhYmxlIElEIHJlZ3MgZnJvbSBpc2FyLmlkcmVnc1tdIHRv
IGNwcmVnX2xpc3QNCj4gKyAqIGluIGNhc2UgdGhlaXIgdmFsdWUgZGlmZmVycyBmcm9tIHRoZSBv
cmlnaW5hbCBpbml0IGNwcmVnIHZhbHVlDQo+ICsgKi8NCj4gK3N0YXRpYyB2b2lkIGt2bV9hcm1f
d3JpdGFibGVfaWRyZWdzX3RvX2NwcmVnX2xpc3QoQVJNQ1BVICpjcHUpDQo+ICt7DQo+ICsgICAg
Zm9yIChpbnQgaSA9IDA7IGkgPCBLVk1fQVJNX0ZFQVRVUkVfSURfUkFOR0VfU0laRTsgaSsrKSB7
DQo+ICsgICAgICAgIHVpbnQ2NF90IHdyaXRhYmxlX21hc2sgPSBjcHUtPndyaXRhYmxlX21hcFtp
XTsNCj4gKw0KPiArICAgICAgICBpZiAod3JpdGFibGVfbWFzaykgew0KPiArICAgICAgICAgICAg
aW50IGlkeCA9IGt2bV9mZWF0dXJlX2lkeF90b19pZHJlZ3NfaWR4KGkpOw0KPiArICAgICAgICAg
ICAgQVJNNjRTeXNSZWcgKnN5c3JlZ2Rlc2M7DQo+ICsgICAgICAgICAgICB1aW50NjRfdCBwcmV2
aW91cywgbmV3Ow0KPiArICAgICAgICAgICAgdWludDY0X3QgKmNwcmVnOw0KPiArICAgICAgICAg
ICAgdWludDMyX3Qgc3lzcmVnOw0KPiArDQo+ICsgICAgICAgICAgICBpZiAoaWR4ID09IC0xKSB7
DQo+ICsgICAgICAgICAgICAgICAgLyogc3lzcmVnIHdyaXRhYmxlLCBidXQgd2UgZG9uJ3Qga25v
dyBpdCAqLw0KPiArICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiArICAgICAgICAgICAgfQ0K
PiArICAgICAgICAgICAgc3lzcmVnZGVzYyA9ICZhcm02NF9pZF9yZWdzW2lkeF07DQo+ICsgICAg
ICAgICAgICBzeXNyZWcgPSBpZF9yZWdpc3Rlcl9zeXNyZWdbaWR4XTsNCj4gKyAgICAgICAgICAg
IGNwcmVnID0ga3ZtX2FybV9nZXRfY3ByZWdfcHRyKGNwdSwgaWRyZWdzX3N5c3JlZ190b19rdm1f
cmVnKHN5c3JlZykpOw0KPiArICAgICAgICAgICAgcHJldmlvdXMgPSAqY3ByZWc7DQo+ICsgICAg
ICAgICAgICBuZXcgPSBjcHUtPmlzYXIuaWRyZWdzW2lkeF07DQo+ICsgICAgICAgICAgICBpZiAo
cHJldmlvdXMgIT0gbmV3KSB7DQo+ICsgICAgICAgICAgICAgICAgKmNwcmVnID0gbmV3Ow0KPiAr
ICAgICAgICAgICAgICAgIHRyYWNlX2t2bV9hcm1fd3JpdGFibGVfaWRyZWdzX3RvX2NwcmVnX2xp
c3Qoc3lzcmVnZGVzYy0+bmFtZSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZXZpb3VzLCBuZXcpOw0KPiArICAgICAgICAg
ICAgfQ0KPiArICAgICAgICB9DQo+ICsgICAgfQ0KPiArfQ0KPiArDQo+IHZvaWQga3ZtX2FybV9y
ZXNldF92Y3B1KEFSTUNQVSAqY3B1KQ0KPiB7DQo+ICAgICBpbnQgcmV0Ow0KPiBAQCAtMjE0MCw3
ICsyMTg5LDI1IEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzKQ0KPiAgICAg
fQ0KPiAgICAgY3B1LT5tcF9hZmZpbml0eSA9IG1waWRyICYgQVJNNjRfQUZGSU5JVFlfTUFTSzsN
Cj4gDQo+IC0gICAgcmV0dXJuIGt2bV9hcm1faW5pdF9jcHJlZ19saXN0KGNwdSk7DQo+ICsgICAg
cmV0ID0ga3ZtX2FybV9pbml0X2NwcmVnX2xpc3QoY3B1KTsNCj4gKyAgICBpZiAocmV0KSB7DQo+
ICsgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAgfQ0KPiArICAgIC8qIG92ZXJ3cml0ZSB3cml0
YWJsZSBJRCByZWdzIHdpdGggdGhlaXIgdXBkYXRlZCBwcm9wZXJ0eSB2YWx1ZXMgKi8NCj4gKyAg
ICBpZiAoY3B1LT53cml0YWJsZV9tYXApIHsNCj4gKyAgICAgICAga3ZtX2FybV93cml0YWJsZV9p
ZHJlZ3NfdG9fY3ByZWdfbGlzdChjcHUpOw0KPiArICAgICAgICByZXQgPSB3cml0ZV9saXN0X3Rv
X2t2bXN0YXRlKGNwdSwgS1ZNX1BVVF9GVUxMX1NUQVRFKTsNCj4gKyAgICAgICAgaWYgKCFyZXQp
IHsNCj4gKyAgICAgICAgICAgIHJldHVybiAtMTsNCj4gKyAgICAgICAgfQ0KPiArICAgICAgICAv
Kg0KPiArICAgICAgICAgKiBtb2RpZmllZCB2YWx1ZXMgbWF5IGhhdmUgY2hhbmdlZCB0aGUgdmlz
aWJpbGl0eSBvZiBzb21lIHJlZ3MsDQo+ICsgICAgICAgICAqIHJlaW5pdGlhbGl6ZSB0aGUgY3By
ZWdfbGlzdCBhY2NvcmRpbmdseQ0KPiArICAgICAgICAgKi8NCj4gKyAgICAgICAgIHJldCA9IGt2
bV9hcm1faW5pdF9jcHJlZ19saXN0KGNwdSk7DQo+ICsgICAgfQ0KPiArDQo+ICsgICAgcmV0dXJu
IHJldDsNCj4gfQ0KPiANCj4gaW50IGt2bV9hcmNoX2Rlc3Ryb3lfdmNwdShDUFVTdGF0ZSAqY3Mp
DQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cyBiL3RhcmdldC9hcm0vdHJh
Y2UtZXZlbnRzDQo+IGluZGV4IDhjN2ZhZjU3YzcuLmMyNWQyYTExOTEgMTAwNjQ0DQo+IC0tLSBh
L3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+ICsrKyBiL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRz
DQo+IEBAIC0xNCw2ICsxNCw3IEBAIGFybV9ndF91cGRhdGVfaXJxKGludCB0aW1lciwgaW50IGly
cXN0YXRlKSAiZ3RfdXBkYXRlX2lycTogdGltZXIgJWQgaXJxc3RhdGUgJWQiDQo+ICMga3ZtLmMN
Cj4ga3ZtX2FybV9maXh1cF9tc2lfcm91dGUodWludDY0X3QgaW92YSwgdWludDY0X3QgZ3BhKSAi
TVNJIGlvdmEgPSAweCUiUFJJeDY0IiBpcyB0cmFuc2xhdGVkIGludG8gMHglIlBSSXg2NA0KPiBn
ZXRfaG9zdF9jcHVfaWRyZWdzKGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2NF90IHZhbHVlKSAic2Ny
YXRjaCB2Y3B1IGhvc3QgdmFsdWUgZm9yICVzIGlzIDB4JSJQUkl4NjQNCj4gK2t2bV9hcm1fd3Jp
dGFibGVfaWRyZWdzX3RvX2NwcmVnX2xpc3QoY29uc3QgY2hhciAqbmFtZSwgdWludDY0X3QgcHJl
dmlvdXMsIHVpbnQ2NF90IG5ldykgIiVzIG92ZXJ3cml0ZSBkZWZhdWx0IDB4JSJQUkl4NjQiIHdp
dGggMHglIlBSSXg2NA0KPiANCj4gIyBjcHUuYw0KPiBhcm1fY3B1X3Jlc2V0KHVpbnQ2NF90IG1w
X2FmZikgImNwdSAlIiBQUkl1NjQNCj4gLS0gDQo+IDIuNTMuMA0KPiANCg0KSGkgRXJpYywgDQoN
CldlIGNhbiBub3Qgc2FmZWx5IHJlbHkgb24gYWhjZiBvbiBhbGwgY29uZmlndXJhdGlvbnMuIFRo
aXMgd2lsbCBub3Qgd29yayBmb3IgYSBob3N0IGtlcm5lbCB0aGF0IGlzIGJvb3RlZCB3aXRoIG5l
c3RlZCB2aXJ0dWFsaXNhdGlvbiBzdXBwb3J0IGJ1dCBxZW11IHN0YXJ0ZWQgd2l0aG91dCB2aXJ0
dWFsaXNhdGlvbiAgKGkuZS4gLW1hY2hpbmUgdmlydCAobm8gdmlydHVhbGlzYXRpb249b24pKS4N
CiBUaGlzIGhhcHBlbnMgYmVjYXVzZSBzY3JhdGNoIHZDUFUgYWx3YXlzIGVuYWJsZXMgRUwyIHN1
cHBvcnQgaWYgc3VwcG9ydGVkDQpieSB0aGUgaG9zdCBrZXJuZWwuIFdoeSBsaW1pdHMgYWxvdCBv
ZiBJRCByZWdpc3RlciBmaWVsZHMgKHNlZSBsaW1pdF9udl9pZF9yZWcoKSBpbg0Ka2VybmVsKS4g
VGhlbiB0aGUgYWN0dWFsIHZDUFUgaXMgaW5pdGlhbGlzZWQgd2l0aCBhaGNmLT5pc2FyLmlkcmVn
c1tdICh3aXRoIEVMMiBzdXBwb3J0KS4gV2hlbiB0cnlpbmcgdG8gd3JpdGUgYmFjayB0aGlzIHdp
bGwgcmVzdWx0IGluIGVycm9yLg0KDQpXaWxsIGF0dGFjaCBob3cgd2Ugc29sdmVkIHRoaXMgaXMg
c2VwYXJhdGUgbWFpbC9yZXBseS4NCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdC4g
