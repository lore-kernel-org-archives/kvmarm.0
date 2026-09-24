Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6E944607C
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245514; cv=fail; b=mQUq7hox2hiJAjuE6D6jEUn6C4kxJhQEQM/WEDzxL8oswjfNRBjqyrUvnD1ZNS8IySxnmBkEC3qC49SgtpXkhG1Y6vAlfpEySC9zq/X6PDY/In++EtZEnVnDD7omfbCGlqD3S9mCF9ZDtLe3uO9dsoKFg4lijfx1vwA9ZSMlrF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245514; c=relaxed/simple;
	bh=dw082u00VPbCXlAgtZ6tpKq0niDRj1rSgViPZp0A92M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UWg/Kd0pohqdbCGfqIPp7gh2isJIHYOIoHIk8FcNDTZBmna4lJZyEr4rFdba0WFB+PSCmfCO1n16UhpBJAJJ060zSN1LiTRuVHnXLAbrHSunZ03eiu7uHIpsVBqKR+IHoUQ1L2UVVlO5gpP3zpacZZrH68CisumpBIZ/OaxojcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kTUXoJy0; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XphB0iAw; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kTUXoJy0";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XphB0iAw"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5cCtK1163530;
	Thu, 24 Sep 2026 03:24:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dw082u00VPbCXlAgtZ6tpKq0niDRj1rSgViPZp0A9
	2M=; b=kTUXoJy0MNLKuYE2DSRtb/D00VbXy0ZpWR5h3vLdYGElVxurC/XAad21p
	C3TijfXM2B1HDpV7IquLGM7F0djf2a/Ar7VHx9faisH934/A4oibzy3rB7GOFJnJ
	8nIY3jyNaIPCDwGJmPaO4rm3xEePifB59Pwf0eonxi8jDde5QRZAlJjfg1u5u9Im
	l9TC3AxTR9w2+oh+b6c2RARy4ubc7BFvrkDmx4UCjTsmKZF3D80R3aF43wl+8oas
	mGROB13hC7zatkdXlL927+BKrawJfq0j2v6YcVoAMSIHx6i7iaJ056BPfDReoS+3
	SKK2KEdgxtdva/5VQK/2+xTYGlkaw==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021083.outbound.protection.outlook.com [52.101.52.83])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gvvjxgtws-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 03:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DY9n+5S8ON0/eyV7ChKch589MFPF58Bt5745ukZe23BEVGkDBDYx4A33cHQyGF4u82xs77day0x7VX35i7QwImWRsTJU8dgTJByjpNRhela7c28n1C8gflpbj3WiBLK4uL/wLFgWnKMkXyW2HDQxwT3IHx2iIfMFvjNI6O3Va5Zcjq+ipAWG6DBKFi7GDh5PXJW+wNDrpzw1eP+ddhMfoUowVuEqT7DE0NX3W7CEQyuRuLRmDvO9U/UKGVaLBhFUmozYInkW4pPoVPaOmZCzD5bEMThMgwaQ0biFMQ8totpyWU8M6ALAOmJwyxYCKEk5A/9n9QHdYyogXPXi27OKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dw082u00VPbCXlAgtZ6tpKq0niDRj1rSgViPZp0A92M=;
 b=MRiVy44Vk5hJNch53QmvzJV7P7U7lx3ly9RLfzU5Zqb2P/MTjqFdy/WRBuQzNydkIT2sSeAbt3nrx3hwoy8QTDb680FDIkfcKZBQ7uzRASiUyndK0C3gUWm7YJqu4E07uV8rU8yRPHSgvZFI3TeFnv1a0ZsUfLcJ/dtPmnDcVwd+/j7IlnuvFDgUzn6RI4M3jP2ZUq21owMRzhXviBsAYic8GeaEbQMHhj2G6frrSY/l4GmLa1Oxdci62BvGi8SK4C6cEa79mtbNT/BxXIX7Nj84t2KbLZGW0X5ZZ8uul2WPMTu08aLHWjwClYbwc8pLx/1kb78FgRHfXxmo8mYyuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dw082u00VPbCXlAgtZ6tpKq0niDRj1rSgViPZp0A92M=;
 b=XphB0iAwY2WTMoaUgC6NJY4D3WsNKCW4ABoHMasW1sl5bqP+KPUABqtNelrsf+oLvlSKV6MzrazDddSdOsZ8dlBbqAbY2kW6m5fiVHEfjqWDOgCv1JjKAhDGEzU+rctBXmovpcouL0VJb9ZNwSMRrRSgAYJHwGfOBIzOOn/GSNgH2VULjBU4v/9y7wd1YtwpsLEX29lP6Hjon5E0Uhi6KaYuWKur6f9v3wEwo4KCkQ+6edNVwGXG92IelA3934oqDvO6JuODgUztccpjiUQnpNdUy9bOluY6N6cCsBh2Oq62T292Z9py9E+OWBLr446/9h78AI+rN1j3C3SLjCgHqQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA5PR02MB11265.namprd02.prod.outlook.com (2603:10b6:806:476::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 10:24:54 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 10:24:54 +0000
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
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v9 01/26] scripts: introduce
 scripts/update-aarch64-cpu-sysregs-header.py
Thread-Topic: [PATCH v9 01/26] scripts: introduce
 scripts/update-aarch64-cpu-sysregs-header.py
Thread-Index: AQHdTA7wE8DMBHbw6E6+h8PqLfeaWg==
Date: Thu, 24 Sep 2026 10:24:54 +0000
Message-ID: <A01DB50C-7455-4E60-9BF2-6F3C8369B529@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-2-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-2-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA5PR02MB11265:EE_
x-ms-office365-filtering-correlation-id: 0ac36da7-c076-46f4-4a88-08df1a26131c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|13003099007|38070700021|4143699003|6133799003|10067099003|56012099006|5023799004|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info:
 CX7uvAgvUtSwAeqvLx8nY/mITdbCK7yVznz9czN1nSCMuAMFrSCDj9l95ecpTtLLBrAJkqbQNYaBJyzmRP3iZSFgMHRUsL/m3c4Fy3BvIObQyNfTXE1XBVoZevZOFf+Td7tji+97SIZkxfVzpns0sIn8QgWBgerksnbxPTgixhu9pxRuftGEpy71H+gkoLa9wl6ukr2RoeNlHudCdJY1o/vFiFh+Fg/Bya3oOGllPcyyqkzBBTpUQeCekleupgPb/cuJ6HRrYcxVkM+GMGa0aUO4f5Ht/P83EEXO4DG1hZYdMeVDi1KMIUdAx9H/J14K9PSCVmBF85U5r71Km89j0PXvOOrmX1Xja/duziEYiv0aHozKXX7zLhKFZVflvM0My7nBFNv6Jx+bUROgydBeRfFae1QKoXb/BghDVYQXRSYEwERk/C17EDIe4LH1LppJDXI4CVkfoJ8+9MMl06WYMK535Q7njcnEDu3UVYhLJmp8kiiAEiBXpVZbm8LWIlHeF71DkJeXR8NPfNEhYx5cFLbMF2PX7kJHdagjUwvowuvN9wUuTfGgm4UfpApUAdo23itsQxe3efG1EP4BWWYObug7fBgggDmVvUd2HePGHecmHa3w8HeahI3TKQLwhfy0aY3gKdwefWPi8vS/Xzbas8/q+fx/sna8b1IaZkQG4Lk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(13003099007)(38070700021)(4143699003)(6133799003)(10067099003)(56012099006)(5023799004)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUtxSWdIUVduVzNNdzZiSVBOMkRUMFN5WEJ2ZVE4WXprNW44MEgyMGFhRUxE?=
 =?utf-8?B?VkFCTGViSFVvWWxETDQyb054TXhNWkFiVU82Q2lWM1FSSU5wRElrOFNaZ25F?=
 =?utf-8?B?TmNSOXpWNG90YnBzTGE3aVR0SkhNY2hYOUlhb0NxTmZaMHo2SHZZc0VQVC9j?=
 =?utf-8?B?ai81YnZqNHMzakZVa3gyNjgwRUZTOGsxUU9veERydFQ1NVdqRmpUcWxuRUgv?=
 =?utf-8?B?c0N4TW8wS0NkZ2JKQXRYTTZEU3RqVERPVU5BcHdTamNSczdFRG9DM25rbGx6?=
 =?utf-8?B?NDgyaTRpK0grTWJyekNaZEpIL3NlRXYzeno0Y3dCdGNpSzd6L2xXTGVvQUZx?=
 =?utf-8?B?STlpSW5uY3hiRktPY056RnJERGM2Q0t4M2xLZERkaWlBdDVpcmhyVUJBVzlQ?=
 =?utf-8?B?V21nNk40aGEwM1JUVEJ4NVhMMmYyZ3o1WEpYZW41UlF1OHV3SXFkZXJqWng1?=
 =?utf-8?B?Vjl4dzc3TnNmR01aeEdEazBJWjdFbWZEVGR4SCtlUzk4VjQ3Wm9CcUNVUFVm?=
 =?utf-8?B?OFlibEx1aWFWM05SUWRHZUtZVXZTdHM4cmhrZEJna1JURHFXYUFTNmdTZnZq?=
 =?utf-8?B?bE9KMW8yZ1RDZ1c2NnZLOU52cVAvQjFUaXFOQ2JJMW55NUZCTzhuYWNTam9H?=
 =?utf-8?B?N3dmQ3pmZGF3cGxQcy9KVDJyV1dPT2VQdU5lV210Ym1kUVhLaVFZOTRUaXBR?=
 =?utf-8?B?N1oxVUhrcmp1Wm54OGtJZ3M5Z3VqOGlBWlpRdS8renIwK0dqbWZFRkg0c1JB?=
 =?utf-8?B?UUdMZzg5K2tBU2N2cGY3ZU5zOUwwejRsT0ZpaHZDclViYkVYRGxvaEprMndC?=
 =?utf-8?B?STk4SFF4Z0hMUGxJT3loSTYrWHRoMmcyemJtcVhYSUV4Sk44RmdqSEF6eGVo?=
 =?utf-8?B?dDF6b0JOcXVoUENpaU1hdHhHeXdwZDdKQmtKQ1c2QjRnVDZTcnMyamNHR0tz?=
 =?utf-8?B?YVFIVlo5THNFK0UwTENwU3B6aVNTWTVwc2Ewa0QvdmtkVnhJdCtFYjduakZP?=
 =?utf-8?B?cFkyZGZDQ2V1RkFZYjQyZ0JCci9qUlJpb0ZxdUdteHhoUG5OQVd5ZG9OWGxB?=
 =?utf-8?B?NEJSMmx0MjBNSnQ0UWVoNTJieWZ0VXlOUUVNMlFjbDdMdnpSUnRBVHR1UVJM?=
 =?utf-8?B?dkI4Qzl4L1ovcHc5QmJka3VCUFZMT3Vwejc0SFRPNk4zUFNWMUYyZFhVK3F5?=
 =?utf-8?B?aGp3enQ4NUtIYUt3YVBBRzZzbGtGcHJwN2RpOE9qZjRCa2VabUsrckpZRVcw?=
 =?utf-8?B?eUlBcFdERzFHU1E3VlN0azQ5WUZPbklTTlJHQnpqVmtwZXZhelBJRDdTVTJD?=
 =?utf-8?B?UVhvZWpRYkpia3VBMGU3TnFXN2R5MWEwL0MwNHJ3V0JCODdzL0NtNFl0WUNM?=
 =?utf-8?B?amNia1lDdUFVZTZRd3ZiRmNneGFYVytRZjJZQ2xMWFZyWGtwWXFMaGVJRkRj?=
 =?utf-8?B?QzhOR2YrQ2s5SWg1cW1kdXJxTzdERWtpR2EwM3A3Uk1KNDBZT205N0JIWU5S?=
 =?utf-8?B?Zkg3aGVudG9mRE5QcjVyelhmSm1DS1FOT1hoL1o4cUJzYWU4a3paNFMyZmdr?=
 =?utf-8?B?cENid0hyeC90L3NnMVNFUU5hdGh2WGZMREkybS92cXh3cmtFZjBwUXh1TEc0?=
 =?utf-8?B?Q1MxeEFwdVFBVlFqTTg2d3RTclBKU3lPK00wWnpTMGVSWFFGaDl1dXRoTW1h?=
 =?utf-8?B?RUdxalN0V1FkbmJqMm0xcVg2RWxrZUNLTW9BcFNWajVsaUpRK2dMVkIrcDdY?=
 =?utf-8?B?ZzNaZ24wOExkWDRJQnM0Uy9zRG1LZG5hdTU0cGZtaXljMWFFTDdwT2xvckVh?=
 =?utf-8?B?dDdRY0EvUDg5MmtuRjFkUmMwb2QxckxQYVVFdTJUcHF5MjNxWE9GTkRQMSsz?=
 =?utf-8?B?Zjl1c2JZN3RmcjlsVlYyeUZLb0V1UXdkY1Zwd1JYaWZIRmNpdHpMQnJkbHB4?=
 =?utf-8?B?QVBiTTJxTzBuY1hqNHRydkpxVG5qM3NBSjl0TkVXSjdPM2w5UFV4Snd0MGNr?=
 =?utf-8?B?SkI2SEJJZGM1ZGZlU1hVUFZXRFR6RXRjUlJlQVFwRkwvd1NpSyswUHhTVFBv?=
 =?utf-8?B?WE9RY1Byb0JKTG5xT1EvNGMxRWg2SXNIZFFYa09KUlp5RDFua3JhdTRJVFY2?=
 =?utf-8?B?Z3RZM0hIb1p1S1ltYVdxU05wbjN2L0FrMk5aeVA0KzJXeUwxWDlhcE8yS01w?=
 =?utf-8?B?azQzaWJyVTh1TWE4d2RjTThVZ0FYTk9yTDk5ajdLSktMS2R2TlpZREdlQkhM?=
 =?utf-8?B?ZVdxNGJ1TW1iOGdvaDFQNDM4cWZIKzUwMWsrWHQ1dlJxWUkwZFhML2RPaWg5?=
 =?utf-8?B?THNORnJTZnNBcFhsQlVxcW1JRlFjSXhBRlZNbUhRN0F6N0tMd3hBVHdObTB4?=
 =?utf-8?Q?7Kk+wAC+DdegwPxw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9BB13ABF82C1A4DBEC6794E79281BDD@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	HKUpyZxjTWtLi4ECxV9n35P2Tjc9TA60vJ0APXdSCQVyH1U5lEFUHfR2FhqaBxRMy7JH1IqJk1q3ZZy5GcMOE5fD9XKMjYi+6aUsaj+N3u/WN0Am2gkVCY+q1QcxHf8ULlGlm2UI4rk093aAlysdEH51fo6qt5nv8593NIjeV/yDGcDLKU4nLA1mOlMvIyUrbNprg1WAL3Z/0lsAo+FMrt7wPCqI1uEKknIcDk/75G+HMwMHPUtHYHtEQOfxrtgfe/QUqfhjdP+W/Y6wqexJi82th/0/iF58ieaJ1k4+SUvxQbJHNNPbhgKBPHjxsFINh659gREajHh2ToMS8NFSAQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac36da7-c076-46f4-4a88-08df1a26131c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 10:24:54.1398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92acZD+pcg+9465sj4EfnGqtN3bb/Xakq9sgq9jyKLPqHwbJZavRliKa1zl8qCWOpPbGe64nJrvUGM+tCvpizQOKiseM2+iQ0fO5wZLQnB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PR02MB11265
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0MyBTYWx0ZWRfXwkJQgmG1ZXhd
 uN3G9uHuEOQz/m6UuRaUTVCs/nzefiuOdG+aXH84xKuooeikXTaYtqCTDmkzRannY+xFr1o5jeJ
 K+Mz8lH4Vq9O+DQbJ66s9UGMtur5wF0=
X-Proofpoint-ORIG-GUID: JL6MOA1xA5xcjQimOpr0D_hsalMgXzg1
X-Proofpoint-GUID: JL6MOA1xA5xcjQimOpr0D_hsalMgXzg1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0MyBTYWx0ZWRfX4E+DEFYAESN3
 gPg+sQX5AbIJrAE5tQ4qjaMoVvbWrPMMSM0MGy+Vrcxw0ZaN+UZ/v3oecO281q7Qsg703Uz5hLl
 jw0VvNbvoH2lMh9mII5SzydjBTbJq+t13EVWrisUCaUQ7cVrifo4rTREMMlf7+wimt6wxGUlNDU
 KQCM0+0YyY11gojfdJj8tjO9aGRUuQF2bhn4W+QKZevR4Z2QK1dFY2dqK74qz8Y7Q2DdvqPNKwG
 +VqvoAEdqupqEAjpgx7O0QFAWSk9mnQRdgZXZtgOxx8K4n9qKnqbRpIRes+kbtkVbmbAn2Xpfh6
 FkCoQtwoM9WbknIMmL3JnxCQHKqV0cCedjbPgZYCybwPAD6oJa9U4eldjqtigmWH0TnqJqYCq8h
 YAL8MEK827lbbhbLvazMiixwNHx1hPiS1i8x/oor+x/zHxeH1Eh8llvYPZgdyiwGaqufk4puE9l
 SG0leeGDNq7EHYW2+ew==
X-Authority-Analysis: v=2.4 cv=HPxWhYtv c=1 sm=1 tr=0 ts=6ab4fa78 cx=c_pps
 a=X+j8kQviiGxwf3Sz5eWiEw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=kA8ebBLf8YxRsWkrSHoA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW50cm9kdWNlIGEgc2NyaXB0
IHRoYXQgdGFrZXMgYXMgaW5wdXQgdGhlIFJlZ2lzdGVycy5qc29uIGZpbGUNCj4gZGVsaXZlcmVk
IGluIHRoZSBBQVJDSE1SUyBGZWF0dXJlcyBNb2RlbCBkb3dubG9hZGFibGUgZnJvbSB0aGUNCj4g
QXJtIERldmVsb3BlciBBLVByb2ZpbGUgQXJjaGl0ZWN0dXJlIEV4cGxvcmF0aW9uIFRvb2xzIHBh
Z2U6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0z
QV9fZGV2ZWxvcGVyLmFybS5jb21fQXJjaGl0ZWN0dXJlc19BLTJEUHJvZmlsZS0yNTIwQXJjaGl0
ZWN0dXJlLTIzRG93bmxvYWRzJmQ9RHdJREFnJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPVBH
V015aWduQTBOaURtVGx5UDd2T1RIb3pCd3NfVk44NnlyVm1TTWtCcDAmbT1TQWFEU3Fxd21JQzFu
YnJoLTI4a21zNktpRllLdlc4SF9DSU9LV2dXanVjdUFuMzdqNDlnbk5Obk1JcG9QX2JLJnM9c3hP
SUQtMkZuaGNRNTZsMW1taktiWHRYcGNFUms0b09YWWlGMy02ZmVuayZlPSANCj4gYW5kIG91dHB1
dHMgdGhlIGxpc3Qgb2YgSUQgcmVncyBpbiB0YXJnZXQvYXJtL2NwdS1zeXNyZWdzLmguaW5jDQo+
IHVuZGVyIHRoZSBmb3JtIG9mIERFRig8bmFtZT4sIDxvcDA+LCA8b3AxPiwgPGNybj4sIDxjcm0+
LCA8b3AyPikuDQo+IA0KPiBXZSBvbmx5IGNhcmUgYWJvdXQgSURyZWdzIHdpdGggb3Bjb2RlcyBz
YXRpc2Z5aW5nOg0KPiBvcDAgPSAzLCBvcDEgPSB7MCwxLDN9LCBjcm4gPSAwLCBjcm0gd2l0aGlu
IFswLCA3XSwgb3AyIHdpdGhpbiBbMCwgN10NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVn
ZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gW0NIOiBub3RlIGNvcnJlY3Qgb3AxIHJhbmdl
LCBkb24ndCBza2lwIENDU0lEUl0NCj4gU2lnbmVkLW9mZi1ieTogQ29ybmVsaWEgSHVjayA8Y29o
dWNrQHJlZGhhdC5jb20+DQo+IE1lc3NhZ2UtSUQ6IDwyMDI1MTIwODE2Mzc1MS42MTExODYtMi1l
cmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiBzY3JpcHRzL3VwZGF0ZS1hYXJjaDY0LWNw
dS1zeXNyZWdzLWhlYWRlci5weSB8IDE0NiArKysrKysrKysrKysrKysrKysrDQo+IDEgZmlsZSBj
aGFuZ2VkLCAxNDYgaW5zZXJ0aW9ucygrKQ0KPiBjcmVhdGUgbW9kZSAxMDA3NTUgc2NyaXB0cy91
cGRhdGUtYWFyY2g2NC1jcHUtc3lzcmVncy1oZWFkZXIucHkNCj4gDQo+IGRpZmYgLS1naXQgYS9z
Y3JpcHRzL3VwZGF0ZS1hYXJjaDY0LWNwdS1zeXNyZWdzLWhlYWRlci5weSBiL3NjcmlwdHMvdXBk
YXRlLWFhcmNoNjQtY3B1LXN5c3JlZ3MtaGVhZGVyLnB5DQo+IG5ldyBmaWxlIG1vZGUgMTAwNzU1
DQo+IGluZGV4IDAwMDAwMDAwMDAuLmVmMTQ3MWExOTcNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysg
Yi9zY3JpcHRzL3VwZGF0ZS1hYXJjaDY0LWNwdS1zeXNyZWdzLWhlYWRlci5weQ0KPiBAQCAtMCww
ICsxLDE0NiBAQA0KPiArIyEvdXNyL2Jpbi9lbnYgcHl0aG9uMw0KPiArDQo+ICsjIFRoaXMgc2Ny
aXB0IHRha2VzIGFzIGlucHV0IHRoZSBSZWdpc3RlcnMuanNvbiBmaWxlIGRlbGl2ZXJlZCBpbg0K
PiArIyB0aGUgQUFSQ0hNUlMgRmVhdHVyZXMgTW9kZWwgZG93bmxvYWRhYmxlIGZyb20gdGhlIEFy
bSBEZXZlbG9wZXINCj4gKyMgQS1Qcm9maWxlIEFyY2hpdGVjdHVyZSBFeHBsb3JhdGlvbiBUb29s
cyBwYWdlOg0KPiArIyBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9
aHR0cHMtM0FfX2RldmVsb3Blci5hcm0uY29tX0FyY2hpdGVjdHVyZXNfQS0yRFByb2ZpbGUtMjUy
MEFyY2hpdGVjdHVyZS0yM0Rvd25sb2FkcyZkPUR3SURBZyZjPXM4ODNHcFVDT0NoS09IaW9jWXRH
Y2cmcj1QR1dNeWlnbkEwTmlEbVRseVA3dk9USG96QndzX1ZOODZ5clZtU01rQnAwJm09U0FhRFNx
cXdtSUMxbmJyaC0yOGttczZLaUZZS3ZXOEhfQ0lPS1dnV2p1Y3VBbjM3ajQ5Z25OTm5NSXBvUF9i
SyZzPXN4T0lELTJGbmhjUTU2bDFtbWpLYlh0WHBjRVJrNG9PWFlpRjMtNmZlbmsmZT0gDQo+ICsj
IGFuZCBvdXRwdXRzIHRoZSBsaXN0IG9mIElEIHJlZ3MgaW4gdGFyZ2V0L2FybS9jcHUtc3lzcmVn
cy5oLmluYw0KPiArIyB1bmRlciB0aGUgZm9ybSBvZiBERUYoPG5hbWU+LCA8b3AwPiwgPG9wMT4s
IDxjcm4+LCA8Y3JtPiwgPG9wMj4pDQo+ICsjDQo+ICsjIENvcHlyaWdodCAoQykgMjAyNiBSZWQg
SGF0LCBJbmMuDQo+ICsjDQo+ICsjIEF1dGhvcnM6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVk
aGF0LmNvbT4NCj4gKyMNCj4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3It
bGF0ZXINCj4gKw0KPiArDQo+ICtpbXBvcnQganNvbg0KPiAraW1wb3J0IG9zDQo+ICtpbXBvcnQg
c3lzDQo+ICsNCj4gK2RlZiBpc19kZW11eF9yZWdpc3RlcihyKToNCj4gKyAgICBuYW1lID0gci5n
ZXQoJ25hbWUnLCAnJykNCj4gKw0KPiArICAgIGlmIG5hbWUuc3RhcnRzd2l0aCgiQ0NTSURSIik6
DQo+ICsgICAgICAgIHJldHVybiBUcnVlDQo+ICsNCj4gKyAgICByZXR1cm4gRmFsc2UNCj4gKw0K
PiArIyBTb21lIHJlZ3MgaGF2ZSBvcCBjb2RlIHZhbHVlcyBsaWtlIDAwMHgsIDAwMXguIEFueXdh
eSB3ZSBkb24ndCBuZWVkDQo+ICsjIHRoZW0uIEJlc2lkZXMgc29tZSByZWdzIGFyZSB1bmRlc2ly
ZWQgaW4gdGhlIGdlbmVyYXRlZCBmaWxlIHN1Y2ggYXMNCj4gKyMgVk1QSURSX0VMMiBhbmQgVlBJ
RFJfRUwyIHdoaWNoIGFyZSBvdXRzaWRlIG9mIHRoZSBJRHJlZyBzY29wZSB3ZQ0KPiArIyBhcmUg
aW50ZXJlc3RlZCBpbiBhbmQgYXJlIHRyaWNreSB0byBkZWNvZGUgYXMgdGhlaXIgc3lzdGVtIGFj
Y2Vzc29yDQo+ICsjIHJlZmVyIHRvIE1QSURSX0VMMS9NSURSX0VMMSByZXNwZWN0aXZlbHkNCj4g
Kw0KPiArc2tpcGxpc3QgPSBbJ0FMTElOVCcsICdQTScsICdTMV8nLCAnUzNfJywgJ1NWQ1InLCBc
DQo+ICsgICAgICAgICAgICAnVk1QSURSX0VMMicsICdWUElEUl9FTDLigJldDQpJIHNlZSBWTVBJ
RFJfRUwyL1ZQSURSX0VMMiBoYXZlIG9wMT0wMTAwLCB0aGV5IHdpbGwgYXV0b21hdGljYWxseSBn
ZXQgc2tpcHBlZCwgd2h5IGlzIHRoaXMgbmVlZGVkPw0KDQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0
DQo+ICsjIHJldHVybnMgdGhlIGludCB2YWx1ZSBvZiBhIGdpdmVuIEBvcGNvZGUgZm9yIGEgcmVn
IEBlbmNvZGluZw0KPiArZGVmIGdldF9vcGNvZGUoZW5jb2RpbmcsIG9wY29kZSk6DQo+ICsgICAg
ZnZhbHVlID0gZW5jb2RpbmcuZ2V0KG9wY29kZSkNCj4gKyAgICBpZiBmdmFsdWU6DQo+ICsgICAg
ICAgIHZhbHVlID0gZnZhbHVlLmdldCgndmFsdWUnKQ0KPiArICAgICAgICBpZiBpc2luc3RhbmNl
KHZhbHVlLCBzdHIpOg0KPiArICAgICAgICAgICAgdmFsdWUgPSB2YWx1ZS5zdHJpcCgiJyIpDQo+
ICsgICAgICAgICAgICB2YWx1ZSA9IGludCh2YWx1ZSwgMikNCj4gKyAgICAgICAgICAgIHJldHVy
biB2YWx1ZQ0KPiArICAgIHJldHVybiAtMQ0KPiArDQo+ICtkZWYgZXh0cmFjdF9pZHJlZ3NfZnJv
bV9yZWdpc3RlcnNfanNvbihmaWxlbmFtZSk6DQo+ICsgICAgIiIiDQo+ICsgICAgTG9hZCBhIFJl
Z2lzdGVycy5qc29uIGZpbGUgYW5kIGV4dHJhY3QgYWxsIElEIHJlZ2lzdGVycywgZGVjb2RlIHRo
ZWlyDQo+ICsgICAgb3Bjb2RlIGFuZCBkdW1wIHRoZSBpbmZvcm1hdGlvbiBpbiB0YXJnZXQvYXJt
L2NwdS1zeXNyZWdzLmguaW5jDQo+ICsNCj4gKyAgICBBcmdzOg0KPiArICAgICAgICBmaWxlbmFt
ZSAoc3RyKTogVGhlIHBhdGggdG8gdGhlIFJlZ2lzdGVycy5qc29uDQo+ICsgICAgcmV0dXJuczoN
Cj4gKyAgICAgICAgaWRyZWdzOiBsaXN0IG9mIElEIHJlZ3MgYW5kIHRoZWlyIGVuY29kaW5nDQo+
ICsgICAgIiIiDQo+ICsgICAgaWYgbm90IG9zLnBhdGguZXhpc3RzKGZpbGVuYW1lKToNCj4gKyAg
ICAgICAgcHJpbnQoZiJFcnJvcjoge2ZpbGVuYW1lfSBjb3VsZCBub3QgYmUgZm91bmQhIikNCj4g
KyAgICAgICAgcmV0dXJuIHt9DQo+ICsNCj4gKyAgICB0cnk6DQo+ICsgICAgICAgIHdpdGggb3Bl
bihmaWxlbmFtZSwgJ3InKSBhcyBmOg0KPiArICAgICAgICAgICAgcmVnaXN0ZXJfZGF0YSA9IGpz
b24ubG9hZChmKQ0KPiArDQo+ICsgICAgZXhjZXB0IGpzb24uSlNPTkRlY29kZUVycm9yOg0KPiAr
ICAgICAgICBwcmludChmIkNvdWxkIG5vdCBkZWNvZGUganNvbiBmcm9tICd7ZmlsZW5hbWV9JyEi
KQ0KPiArICAgICAgICByZXR1cm4ge30NCj4gKyAgICBleGNlcHQgRXhjZXB0aW9uIGFzIGU6DQo+
ICsgICAgICAgIHByaW50KGYiVW5leHBlY3RlZCBlcnJvciB3aGlsZSByZWFkaW5nIHtmaWxlbmFt
ZX06IHtlfSIpDQo+ICsgICAgICAgIHJldHVybiB7fQ0KPiArDQo+ICsgICAgcmVnaXN0ZXJzID0g
Ww0KPiArICAgICAgICByIGZvciByIGluIHJlZ2lzdGVyX2RhdGENCj4gKyAgICAgICAgaWYgaXNp
bnN0YW5jZShyLCBkaWN0KQ0KPiArICAgICAgICBhbmQgci5nZXQoJ190eXBlJykgPT0gJ1JlZ2lz
dGVyJw0KPiArICAgICAgICBhbmQgbm90IGlzX2RlbXV4X3JlZ2lzdGVyKHIpDQo+ICsgICAgXQ0K
PiArDQo+ICsgICAgaWRyZWdzID0ge30NCj4gKw0KPiArICAgIGZvciByZWdpc3RlciBpbiByZWdp
c3RlcnM6DQo+ICsgICAgICAgIHJlZ19uYW1lID0gcmVnaXN0ZXIuZ2V0KCduYW1lJykNCj4gKw0K
PiArICAgICAgICBpc19za2lwcGVkID0gYW55KHRlcm0gaW4gKHJlZ19uYW1lIG9yICIiKS51cHBl
cigpIGZvciB0ZXJtIGluIHNraXBsaXN0KQ0KPiArDQo+ICsgICAgICAgIGlmIHJlZ19uYW1lIGFu
ZCBub3QgaXNfc2tpcHBlZDoNCj4gKyAgICAgICAgICAgIGFjY2Vzc29ycyA9IHJlZ2lzdGVyLmdl
dCgnYWNjZXNzb3JzJywgW10pDQo+ICsNCj4gKyAgICAgICAgICAgIGZvciBhY2Nlc3NvciBpbiBh
Y2Nlc3NvcnM6DQo+ICsgICAgICAgICAgICAgICAgdHlwZSA9IGFjY2Vzc29yLmdldCgnX3R5cGUn
KQ0KPiArICAgICAgICAgICAgICAgIGlmIHR5cGUgaW4gWydBY2Nlc3NvcnMuU3lzdGVtQWNjZXNz
b3InXToNCj4gKyAgICAgICAgICAgICAgICAgICAgZW5jb2RpbmdfbGlzdCA9IGFjY2Vzc29yLmdl
dCgnZW5jb2RpbmcnKQ0KPiArDQo+ICsgICAgICAgICAgICAgICAgICAgIGlmIGlzaW5zdGFuY2Uo
ZW5jb2RpbmdfbGlzdCwgbGlzdCkgYW5kIGVuY29kaW5nX2xpc3QgYW5kIFwNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgaXNpbnN0YW5jZShlbmNvZGluZ19saXN0WzBdLCBkaWN0KToNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgIGVuY29kaW5nX3dyYXBwZXIgPSBlbmNvZGluZ19saXN0WzBd
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICBlbmNvZGluZ19zb3VyY2UgPSBlbmNvZGluZ193
cmFwcGVyLmdldCgnZW5jb2RpbmdzJywgXA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW5jb2Rpbmdfd3JhcHBlcikNCj4g
Kw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgaWYgaXNpbnN0YW5jZShlbmNvZGluZ19zb3Vy
Y2UsIGRpY3QpOg0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBvcDAgPSBnZXRf
b3Bjb2RlKGVuY29kaW5nX3NvdXJjZSwgJ29wMCcpDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIG9wMSA9IGdldF9vcGNvZGUoZW5jb2Rpbmdfc291cmNlLCAnb3AxJykNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgb3AyID0gZ2V0X29wY29kZShlbmNvZGluZ19z
b3VyY2UsICdvcDInKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcm4gPSBn
ZXRfb3Bjb2RlKGVuY29kaW5nX3NvdXJjZSwgJ0NSbicpDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGNybSA9IGdldF9vcGNvZGUoZW5jb2Rpbmdfc291cmNlLCAnQ1JtJykNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW5jb2Rpbmdfc3RyPWYie29wMH0ge29w
MX0ge2Nybn0ge2NybX0ge29wMn0iDQo+ICsNCj4gKyAgICAgICAgICAgICAgICAjIElEIHJlZ3Mg
YXJlIGFzc3VtZWQgd2l0aGluIHRoaXMgc2NvcGUNCj4gKyAgICAgICAgICAgICAgICBpZiBvcDAg
PT0gMyBhbmQgKG9wMSA9PSAwIG9yIG9wMSA9PSAxIG9yIG9wMSA9PSAzKSBhbmQgXA0KPiArICAg
ICAgICAgICAgICAgICAgIGNybiA9PSAwIGFuZCAoY3JtID49IDAgYW5kIGNybSA8PSA3KSBhbmQg
KG9wMiA+PSAwIGFuZCBvcDIgPD0gNyk6DQo+ICsgICAgICAgICAgICAgICAgICAgIGlkcmVnc1ty
ZWdfbmFtZV0gPSBlbmNvZGluZ19zdHINCj4gKw0KPiArICAgIHJldHVybiBpZHJlZ3MNCj4gKw0K
PiAraWYgX19uYW1lX18gPT0gIl9fbWFpbl9fIjoNCj4gKyAgICAjIFNpbmdsZSBhcmcgZXhwZWN0
ZWQ6IHRoZSBwYXRoIHRvIHRoZSBSZWdpc3RlcnMuanNvbiBmaWxlDQo+ICsgICAgaWYgbGVuKHN5
cy5hcmd2KSA8IDI6DQo+ICsgICAgICAgIHByaW50KCJVc2FnZTogcHl0aG9uIHNjcmlwdHMvdXBk
YXRlLWFhcmNoNjQtY3B1LXN5c3JlZ3MtaGVhZGVyLnB5ICINCj4gKyAgICAgICAgICAgICAgIjxw
YXRoX3RvX3JlZ2lzdGVyc19qc29uPiIpDQo+ICsgICAgICAgIHN5cy5leGl0KDEpDQo+ICsgICAg
ZWxzZToNCj4gKyAgICAgICAganNvbl9maWxlX3BhdGggPSBzeXMuYXJndlsxXQ0KPiArDQo+ICsg
ICAgZXh0cmFjdGVkX3JlZ2lzdGVycyA9IGV4dHJhY3RfaWRyZWdzX2Zyb21fcmVnaXN0ZXJzX2pz
b24oanNvbl9maWxlX3BhdGgpDQo+ICsNCj4gKyAgICBpZiBleHRyYWN0ZWRfcmVnaXN0ZXJzOg0K
PiArICAgICAgICBvdXRwdXRfbGlzdCA9IGV4dHJhY3RlZF9yZWdpc3RlcnMuaXRlbXMoKQ0KPiAr
DQo+ICsgICAgICAgICMgU29ydCBieSByZWdpc3RlciBuYW1lDQo+ICsgICAgICAgIHNvcnRlZF9v
dXRwdXQgPSBzb3J0ZWQob3V0cHV0X2xpc3QsIGtleT1sYW1iZGEgaXRlbTogaXRlbVswXSkNCj4g
Kw0KPiArICAgICAgICAjIGZvcm1hdCBsaW5lcyBhcyBERUYoPG5hbWU+LCA8b3AwPiwgPG9wMT4s
IDxjcm4+LCA8Y3JtPiwgPG9wMj4pDQo+ICsgICAgICAgIGZpbmFsX291dHB1dCA9ICIiDQo+ICsg
ICAgICAgIGZvciByZWdfbmFtZSwgZW5jb2RpbmcgaW4gc29ydGVkX291dHB1dDoNCj4gKyAgICAg
ICAgICAgIHJlZm9ybWF0dGVkX2VuY29kaW5nID0gZW5jb2RpbmcucmVwbGFjZSgiICIsICIsICIp
DQo+ICsgICAgICAgICAgICBmaW5hbF9vdXRwdXQgKz0gZiJERUYoe3JlZ19uYW1lfSwge3JlZm9y
bWF0dGVkX2VuY29kaW5nfSlcbiINCj4gKw0KPiArICAgICAgICB3aXRoIG9wZW4oInRhcmdldC9h
cm0vY3B1LXN5c3JlZ3MuaC5pbmMiLCAndycpIGFzIGY6DQo+ICsgICAgICAgICAgICBmLndyaXRl
KCIvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlciAqL1xuXG4iKQ0K
PiArICAgICAgICAgICAgZi53cml0ZSgiLyogVGhpcyBmaWxlIGlzIGF1dG9nZW5lcmF0ZWQgYnkg
IikNCj4gKyAgICAgICAgICAgIGYud3JpdGUoInNjcmlwdHMvdXBkYXRlLWFhcmNoNjQtY3B1LXN5
c3JlZ3MtaGVhZGVyLnB5ICovXG4iKQ0KPiArICAgICAgICAgICAgZi53cml0ZSgiLyogREVGKDxu
YW1lPiwgPG9wMD4sIDxvcDE+LCA8Y3JuPiwgPGNybT4sIDxvcDI+KSAqL1xuXG4iKQ0KPiArICAg
ICAgICAgICAgZi53cml0ZShmaW5hbF9vdXRwdXQpDQo+ICsgICAgICAgIHByaW50KCJ1cGRhdGVk
IHRhcmdldC9hcm0vY3B1LXN5c3JlZ3MuaC5pbmMiKQ0KPiAtLSANCj4gMi41My4wDQo+IA0KDQo=
