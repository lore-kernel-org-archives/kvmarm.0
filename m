Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522A3E7BDF
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898351; cv=fail; b=d2ZtElCMyXjjRic/0yWcpuSVnttSZzhu3XPLi80rEuY2wh8VP7flxRfqA67BLRLU4AmKMXTdOfDlxJFv4yAZyd5eb17nOgljtvxhZBcnbpDZdhLbhbDZ50OvYXyYhzaIYaKn24VJSGxn1D1qCfXq/i+t2m+4AeEyFalvyXff1JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898351; c=relaxed/simple;
	bh=+KyW6lfCI2KoF2VMy4YLvEURimKZhBzNtAS/DlLo7HQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cjnAgnLMpoojBbUQlJVHITlvhgaGqJz5f86CvpHeZv5FiJMjGZrszJJYHXHTW6f+QQg14H17uBuhNgmT7qX8qGMg19uyYOMsC4XL15fAgZcWxG6CPrceogd8HffyCs7OCpLiiZ06yBhcXEDeWUhEM4D3gDo+RCNNTPlrb2B3NCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ztqBs87u; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pWndHO7n; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ztqBs87u";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pWndHO7n"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCrkAQ2776333;
	Wed, 27 May 2026 09:11:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+KyW6lfCI2KoF2VMy4YLvEURimKZhBzNtAS/DlLo7
	HQ=; b=ztqBs87uNXaoFC+xS4UsCBrGoHrbH6n2aBxUx+MTASKtVzD/9kc/6waCh
	i9/nywEjyMh8HyukfsjgU+gC9RyoZXquVagL3BpzBtLQu9llajbYkealMJrX2UJU
	G6tzZqZCup1M1kT80s2RT4qkVM9JDEPQQ28CWt4mQzn8ndws1EBOwlySY2RAhsVR
	qRM3/infzJM8fcqAewbZWaB05f/ivLEcqH40xhAow4NX71Iqla4lEQHEOz5XY4JL
	kjeSTb/HEj1BZCKHu4bLsa5y4LicRPM4snCNplwyXZLft1duQjVKFs8/5TODz2g5
	3PegcOWNUTytvj49PJM/W/ixOLw3g==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022123.outbound.protection.outlook.com [52.101.43.123])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edhn7tjkm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 09:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+0LiVgVo4wtHvMAyxKcVTGOspuEVabC3HpM7wEMpRC5poOlddGvbfXeL0fIyp3VWniSfaCAqRqRFk0xQ/xhh+bmSBmDpzt1c3pP6J4MrPXQMaG9Srkhq+LCSI8/r7X1slCADbtyQKC2nmAPIgrSvb3Q7m/uo2GQvQoNbAdQpjimr8geh7GhNinRsbJ8O4nn8yE2/f+01Waz015BCHFNLc/KjOpfkyyHHcQfRhWl4FdYA5dm7QGRzrXSJ8YJXCZoha8HCM7+DwKQ1vrNf1fa0M0DUkWjSYvL0cm/iGxozmnDBJ153Wwxk9iw67jdpkAbWFYsCv1Uvu49gEZeJO/kqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KyW6lfCI2KoF2VMy4YLvEURimKZhBzNtAS/DlLo7HQ=;
 b=ERK5FqMmm+64hfk/OVSzEmtOmeHA4y8P9OXBNcjxqJ3RFWO5KuibHQgElurDduVtriYD3sGVsmRMXGGZb/JqGDSh4cEMyOFoerrS9nhTNjpElM4VEPyTnH431RYxw3zMtAdsnfA5MewtKja8OW1OJa5S7+Boeoj2x9rj4UzMIgpD+1l+8q7wntg7AZxvbp8NFeJ7heG29oCr8cnOleAv8mT2hxZe+tsEqdRHufhT1CnaaijWqY/BncWupLbOv1cfM1KLPdSrPXO7YjpamGKqQYH+R/6osTl5RHrmyz/3YZrUEkKB5V8OQO5r5YQup0KfGyKUqJQFXhGeencWJz/F8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KyW6lfCI2KoF2VMy4YLvEURimKZhBzNtAS/DlLo7HQ=;
 b=pWndHO7nAGiALNblT3GI+qvXO4qlJqGkNANAcrzLpPqjoQ6KX+YsbtILuHxxkpFPRhiLfk61hHRtb0ZjE1QJQYfm+Oh358lDDCM3dP/uFSCYpvFsGFYdHo7XFqM6EtT7ba4zm1TFkprsFMp9Pdj5r1QdZh45no7rqrJtKCKzyUlkWoVWAM8qnqaDXblXT/fDPIwY+v8PqiEhcgkotM6sh9PSTJhcMYnDVFOjuQ70NNFePLX7yfO13vm9q6RrLfihtzVao5M60JIW7DDyC1fXFQR0u1hEElJSgdO7Lv1D2TG8mEACz2inUNbzO4dM9CpkB9Z5xmXqgA61Dz2LALZkkw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9561.namprd02.prod.outlook.com (2603:10b6:610:123::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.19; Wed, 27 May
 2026 16:11:45 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 16:11:45 +0000
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
Thread-Index: AQHc55PDWfKVatqEQkCeq1pFPAd4RbYiCFaAgAAJ0gCAAAFOAIAAAoMAgAAB14A=
Date: Wed, 27 May 2026 16:11:45 +0000
Message-ID: <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
 <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
In-Reply-To: <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9561:EE_
x-ms-office365-filtering-correlation-id: a016bbf8-1c26-4ebc-8094-08debc0aa5e2
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|6133799003|3023799007|4143699003|18002099003|22082099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 ca0unn0j4R0ucoUcDjSUF/gUvXKomnLhP9ew2LLyerNGSsL0zjl2TqRXZRX9x+WHvPoCleWekLx/y7w2X8gwZXFZV6pEGTUHJs5LO2YXFzmtmb2Yh1YjDACEFTy88Jo0e4gyMJ8y2UrOxHU/30Hc3W6G4UUf1cw0MDfbLnRM21rCa6oaS6pfjrsuM1M4tvUy85gjupfu3r8YGof6zzo9d1AajoVpFLwoq78IIncXEuFxVe98jV4KoGy4luDWfHkyxdG3xmYiuBXJEauzOTOZyAYppAG6oetM6AmnqIaVGegNO669JLCs1y38+uLCOLzwrTyB4av3dMb+X4il0tkxrp8+uhVJxIWZx4xJvr6hqGTWL66hwKjrK+Z4k8ZEwmpvt+QkK+crJojbo5Csm3B1X/wCQamhPVzRxtF2FuMyQnKGIdZlodu9EYm3NUZ38KLYckHOePKD9boPrR+NVXj1cxFXAgxsbh2hinmfC5NH7h39G+17ODVMFe+ikQaKizPAt3GXRWrSSbj3Yxh8lEsIdPrK8L9pQNFLOQ7ZkQmt/4MPkevZ9R9JsnbL6fwAQPmNIXfvDVBYmGLirx4gdBXE7G7e36t+NOGz7GMs7ob9OwrosaOIOo1xWeWz/qTGOybs5iZPoglxCXwC1/8FbqIU0WF9VV8Dnll9a55+WrrfOXfCaZTt23kbWJ2oBRuzQO/oeljVN/4VA5vz/Qq0CZefuo5cJQq4eXkRxnJeyl8+nk0nYGqrVzs681dZRVQ3lG+B
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(6133799003)(3023799007)(4143699003)(18002099003)(22082099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WDJLVEN1TWhQY2R4aGNsR04wTWxxMzh6TFhrRFh2bTVBNkt2N0RickZNeGdF?=
 =?utf-8?B?YjExM1V0TkQ3Q0F1cDZKbVZXR0xmeisva1Bwd1FmcG9EOStJN2h4RjFGSUtU?=
 =?utf-8?B?OThwVjVLall4R0VXbTJVcjBLZjNnUjdBbGVTTkRwSXhyU0pvRUdMdU9UNTk1?=
 =?utf-8?B?NE9SR0crcjVhRzhUM0lPYVh0bk1IbmtreG1mbXVudUE5TFdQanEyR2ZKeHJs?=
 =?utf-8?B?ak83TmpFMi9Ndlh6NUJCcURpbTZOc21PdGlZZTRud2lFZlVCMXU1Q0NGZmp0?=
 =?utf-8?B?SWFWVE4zTTlMQWtySlZGWXJWRXBFM2laNG1xZldvZlk1eTgwb05Bcy91b1Rp?=
 =?utf-8?B?WjJZTHJRYndhOFdKOXVvWG90cFRyQlU1SlVBYVZwd0VKNkV3UVV0R29laHpw?=
 =?utf-8?B?V3RsdVZ4SC85TEpaZTd6TUJYSGo1SUo1dmVKTWdNZ3pJS0pXUmF5bkJKcHYz?=
 =?utf-8?B?UmdGeVY3WUlkaGxJV09VaElXQ25NMENLOWp6NmhKTkZIK3hnTytOZERKUm9P?=
 =?utf-8?B?U0pVV3R4bkp6SFVzby9jMER1SzllRVlDR3lFcmY2Mi9RUmFyd1RweVZmZHdI?=
 =?utf-8?B?dVRRRUpGaU9FdmsrY2lYOUkrNXU0UDU3YVBrVDBBaXIxRnEvWDlyOWs4Unlw?=
 =?utf-8?B?UEVERDZWUXpKNERaTUtmMlpnYVJ2VnRERDNnRlRGdHZtM2dlQTV6Zi83aVR3?=
 =?utf-8?B?K1VmcU9YNEc2MWYvQzBuQ0JFTnNrS2JOaGd2RkJPTlh6OFdTOVZqT0RrY3pX?=
 =?utf-8?B?VzEza3pIT1VibGZYdm95QXV3ZjVkd0E3cTdtcXVkY0lQZkp3ODRrVTFGakVY?=
 =?utf-8?B?bHcwZGc4Y1hnSGhFRTVFYXh5V2lCZTlHa1pDMGFWZ1NpQkE0TFNSUXgzYnda?=
 =?utf-8?B?d0RveCtzdStoc01sK0E0Qld5Q2ZEdE5HK1U0d1RtRjdjMlh6Zk9QLzVpVU5h?=
 =?utf-8?B?QTkrRzRoUjBJcVpmbXBTOU5FZWJ5end2aGlDLzdEQXdYTlRaMGh3RnBTUFB0?=
 =?utf-8?B?VG5hVG9kcEczVzMwb2g2Zy9kTUJJRWxYdzI2djA0WGtmQzdrdnVOcVZGazA4?=
 =?utf-8?B?TTJrY21SYldVNW5kM1ZIT1B0ZHdzQTVxQkRvSytGMUhWT1RlUUJXenVWWjVy?=
 =?utf-8?B?UCtJZTNudFcwUlZoSGZYZkpYaFhvVW5ZS3VvZC9ROVR2TmNKWWlPb3BiUGIx?=
 =?utf-8?B?WkxoMllOOXZCVHR0UzMvV0VxcER0SXNzWGNFTTFHTlBkeWR6VHdJWmhNeVdB?=
 =?utf-8?B?amx0Q2hZbnBBQjBsQWZ6em0wUFQ2Nit4SEgzWE03QmxBS3gyUlhLbk9UVXZ4?=
 =?utf-8?B?R1p2a0FOU3BpMXRuQXdTUWdwWE81N2RTSUhvL3FmM2crUUluWWMxRUVoNThM?=
 =?utf-8?B?Mitya0p5YUo0ejc0V0M1K3ZTdTZ5MjVIQmYxZUdtMm9raVozdE1xalVZRzhz?=
 =?utf-8?B?UjhYRzhiSlZpNVZWSHY4SGFKUHFGZnozZHU5Z1R5N0FabnRQVFZBazhEZWMy?=
 =?utf-8?B?UENId0srRU83RUNpeEN3SnFmN1U4Q2U5WnFNR213YTJndTVGQ2F1cXFtQ3NY?=
 =?utf-8?B?N1hiREFkYnVCNmdjaWFzclpZelEydVRudVBKM2E2NFJUVUhZQ1pQbUZsYVhD?=
 =?utf-8?B?L2VsTjVIUVdONFh1ZVVqOFhFckZaU0FvRlRXTXpmMVJwRmlVNHorV1RveXVs?=
 =?utf-8?B?bm5oNWgvTHpQNWY5K2JsUS9BN21obTdmaWxHRnFDbDhMSU1hWUI2T3hFRHVH?=
 =?utf-8?B?Y2FvaUVZM1ZHZ00zTnhzYWdtaTNISzF3ZGUwa2VkTHlqbHJDWVlHanMyeU1n?=
 =?utf-8?B?RHFYUEFZOC9RYjZ6YjB1ZHBBZTJUb1Mwc3NMNHNOQ0JESDFMZWlNVzEwTnhR?=
 =?utf-8?B?NTZWYnBreXFoOWdvNDdiT2pxeSsrZjdEeEVqRElQdTJRSlZLNzZpS2gwYm42?=
 =?utf-8?B?S05ubWlGYnNINlQvLzRmbkpBVERvNTNHajZNNSt3WGUzK2hjSG1wN0d4czJB?=
 =?utf-8?B?eTRvTFRyYW5kSG5YQjljaHV3SHBQaDI5aHlPODY4ZUpnK2JCTEF5Mm95bitQ?=
 =?utf-8?B?VysxOXlBWFBuK3ptYWNxU2pMREhwNkI1dkt0eTNQbzFjTVl5dEFaR241RnJp?=
 =?utf-8?B?RXJ4anZ4Z0lOZ2lzcDhBVTlKcUpxRVNXYVNiK3VPS2JkampWRFNjVVdnYTZn?=
 =?utf-8?B?a3NHRWdYRFBQSEIzbVF5MHF0dWhhS2pqVE9LL3g1Vm4rZHcwNGx1aWk4bjJy?=
 =?utf-8?B?c2dOMkJSS094ZTNGKzl0UWE2MGlWbllZUWlzeG52VlRCY2RnVTBDSzVIVE9x?=
 =?utf-8?B?eEV5dTBMZWtxRUNMVE5nV3RZR2RUWmcwR096N3RxYytoN0Y3blpVNTgyWEw0?=
 =?utf-8?Q?YQ8riqKn1EyJZ0WQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <280814070857E444B8153B34F32D7809@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	CfFBz1TVip1mK5VgfC87WMp5llbB/q8aZOD3s4qo+JOPwwlK3R+b58Z8wGrkR4RdV94eeKH7TB7aS/Vdcc8YT2CtieyM3OEKQRDFYFubIslX1qqcPBttUurnW5UKGh6pN/ZMyfVsrAgIDRbifmDM5s6OWykLjbDuICRKCeVJGlcmZZ834ZtgAGCYiZbKhet5TUD1AnOxHAJ8aC5P04U/EGb1QrxX/DhATRmdrOMlB2YPKFKFWMp485eyDi5xKSrIdY0Oz1jEfWv4jdUJ2AsBqQJY0iIFnx+W4DIyMWhHcxfVey9UfqVCqzD40Dwm0ej4rpB5N/7d8zllTq5fH/wtMg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a016bbf8-1c26-4ebc-8094-08debc0aa5e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 16:11:45.0766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDT/aISb091whQZYz7wUd2lw+0cKgNhDW8yjzApBFITYGEKuCWKi0fmLymLzPtl7mESX1fQDGj/NCP31u876rngtyNDpvJ63vlf3TqNZsqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9561
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE2MiBTYWx0ZWRfX8UBiC3p1AYru
 O31vqZlFT8FEiATgPI7o1msp/1VrKDTyKhjQr7BadD+OHDl243RoJuB/KEcIwIb6mOzJclVaxsk
 jIvqEGFdlg0ShzkMF4227kujF6wJfaYbeMRSM671AkMKdAz/eGfnm3wNBsvxDFvL3CLRKx1epcy
 BnA2BEVl9OiSv2QGB32fGhYt27tfkCpf4u/I2g6rQrCm71oP38YEnGa0fyV6gNhau90CC/MOyFw
 cgRR4vkb6AhqwpNu32TyA0BDxTITIHqgstQYbcbZkJwDEzAuaEaKWCOpgQOj/oSIJXCy7SXzjPl
 sit9slu+K/YV9psTDiIGMNC9wXrUc7XymvDKjh0RtrL8LvBa7Z48U6G3fiDlkR2c1jJ4eexZmd6
 mSQaHR5DeXNv17zzXdvtdrZREyn9niXTNmtbr7BZpvOXkYJ/Sxv0S5vfuh9gGv+zX7Tn3xC9mQ3
 bSW8fVXrNrN8IMhK+9g==
X-Proofpoint-ORIG-GUID: fCMlAFbtw_xmCGr8wreh-nMjLpVwVShw
X-Proofpoint-GUID: fCMlAFbtw_xmCGr8wreh-nMjLpVwVShw
X-Authority-Analysis: v=2.4 cv=f/l4wuyM c=1 sm=1 tr=0 ts=6a1717c7 cx=c_pps
 a=0vj9JdGoO5ZFtW877mlItg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=OkC2HfCMtcJ2oW8yb8UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjcgTWF5IDIwMjYsIGF0IDk6MzTigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDUvMjcvMjYgNTo1NiBQTSwgS2h1c2hpdCBT
aGFoIHdyb3RlOg0KPj4gU28geW91IGFyZSBzYXlpbmcsIGlmIEkgZG8sIA0KPj4gLWNwdSBob3N0
LHN2ZT1vbixTWVNSRUdfSURfQUE2NFBGUjBfU1ZFPTANCj4+IFFFTVUgd2lsbCBzdGlsbCBzaG93
IHN2ZSBjYXBhYmlsaXRpZXMgdG8gdGhlIGd1ZXN0Pw0KPiBZZXMgdGhhdCdzIHdoYXQgSSBleHBl
Y3QuIFJlcXVpcmUgbW9yZSBleHRlbnNpdmUgdGVzdGluZyB0aG91Z2guIFRoYXQNCj4gY291bGQg
YmUgd2F5IHRvIGhhbmRsZSBjb2V4aXN0ZW5jZSBvZiBkaWZmZXJlbnQgbGV2ZWxzIG9mIGdyYW51
bGFpdHkuDQo+IExvd2VzdCBsZXZlbCBhcHBsaWVzIGZpcnN0LCBvdmVycmlkZW4gYnkgbGVnYWN5
IGNvbXBvc2l0aXZlIG9wdGlvbnMuIEkNCj4gZ3Vlc3MgaWYgeW91IHBsYW4gdG8gaW50cm9kdWNl
IG90aGVyIGxheWVycyBvZiBjb21wb3NpdGl2ZSBwcm9wcyB5b3UNCj4gd2lsbCBtb3N0IHByb2Jh
Ymx5IGhhbmRsZSB0aGlzIHNpdHVhdGlvbiB0b28uDQo+IA0KDQpJIGFtIHN1cmUgdGhpcyBhdC1s
ZWFzdCBkb2VzIG5vdCB3b3JrIHdpdGggc3ZlLCANCmJlY2F1c2UgYXJtX2NwdV9zdmVfZmluYWxp
emUoKSBqdXN0IHRha2VzIGxvb2tzIGF0IHRoZSBQRlIwLlNWRSBmaWVsZCBhbmQgSWYgdmFsdWUg
aXMgMCBzdmUgaXMgJ29mZicgb3RoZXJ3aXNlICdvbuKAmS4NCg0KV2hhdCB5b3UgZGVzY3JpYmUg
bWlnaHQgd29yayBmb3IgbGVnYWN5IHByb3BzIGJhY2tlZCBieSBwcm9wXyogYm9vbGVhbiB2YXJp
YWJsZXMgaW4gQVJNQ1BVIGxpa2UgcGF1dGggKGJhY2tlZCBieSBjcHUtPnByb3BfcGF1dGgpLg0K
DQpJIGhhdmUgbm90IHRlc3RlZCB0aGlzLiBJIG1heWJlIHdyb25nIGlmIHNvbWUgcHJvcCBvcmRl
cmluZyBtYWdpYyBoYXBwZW5zIGF0IG1hY2hpbmUgbGV2ZWwuDQoNCk15IHBsYW4gaXMgdG8ganVz
dCBwYXJzZSBwcm9wZXJ0aWVzIGluIG9yZGVyIHRoZXkgYXJyaXZlIGluIGNtZGxpbmUgOikNCg0K
V2FybSBSZWdhcmRzLA0KS2h1c2hpdA==
