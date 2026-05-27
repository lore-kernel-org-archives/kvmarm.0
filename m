Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E694B4266AA
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895141; cv=fail; b=OlelJEu9o8/nIn+1kMzZ0Xx5R5JoD0ptfnZfY+oN9uFD4MqZGBwOoiq6Luws7b/0ARDPOdJl2Wwx+TW3TRBhiAeJc7jJgY8onjbnusIZKQWqqjy58T19NwKngxonmPD4rJhjjqZvFdfYrqLUTvgUdclczTVPCYPKK+EcCiFTHm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895141; c=relaxed/simple;
	bh=qaXg+8Lqs33UfNqQR4dZ+GreeM+f9zY0ptKVlIZYlh0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QQuMJYSX/ik1SrbExX2HlRT5kUE0dOrodhgbeb9F0uiZ+XUz2NO3dY6ralXPwlN0kWsHwf+k/v7qgrZ1RKzDS+kBHQp4tFLQsrRaTz9IyyPEhWxoB6ipiEQNJ0oSSjjPqzhufXkhpP2xSWV2qmFxxx7NkvEVlAjQyNXJkWe2P/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jwKXWUxB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xvwf2+U5; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jwKXWUxB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xvwf2+U5"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCt45k2705596;
	Wed, 27 May 2026 08:18:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=qaXg+8Lqs33UfNqQR4dZ+GreeM+f9zY0ptKVlIZYl
	h0=; b=jwKXWUxB8/O8zj3ia8t3DmG9Xam9zDoHEjMhBssQMR2AYrbxCtPrPMggk
	SE9ZddNeJrciJRpon85t8w2G5P4UNf51GKwiSPaByMVS5IJV9MIUMfhRvxQF/FM2
	MdIMJvSoA2lLMnY/Vts5kY3s95jVRAT7DQbarISQW57vOks2kGwY3exjYNtFmx6J
	hufEovlG6s5C1qY8dQ9UW0Lr5fVUMxcFkyrESEtU1QiPCdREAHZEO9KJxvvYWMyd
	WoLdHPkU10KSR53zcoErPn3ZZpNKfwJNnc2UwC7LwbOY6Dwj1zlqPvYv1Ms3y+Jf
	f8ZLEzjsUcFHOXMOg7VvR+iioqHGQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022092.outbound.protection.outlook.com [40.107.200.92])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ed82b42m6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkZc5FoR/8moN+NDABDRbx2s3o+uoW+wQwSgGImWmAFy2nsPN3rdrTh1OnOPgyCBJJqP2sdwqHv/pb8qeBy5rFl5P/woIF6Y52mef4VQBcCRPcF2y9Ux6p+EVWMlDNklzbpFwEUFpkWsfZAiiHL2iSG4kUmeqW5LtXw/oUANXFccKMD8VFFjTsjoTcVRwd7xjVoLsY/1RLAxUnDzydgXwTSx8xw117unKDqQUM7wiRaxia6L7LKZwqN7aU6PBIe/kKLGy62LGaRVrPrqK/+EwO6IM0kERp7D1B9sBWDZfakA9vvPZmMve+nTfZc2zmX3gTCR8P2qqz7rAQ6quebwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaXg+8Lqs33UfNqQR4dZ+GreeM+f9zY0ptKVlIZYlh0=;
 b=pnwaew/8LGTd4FaMs/yIa9oAZCmxbf+osFvWDBC98C9v0dbAppgX13ccvAw+4mT0B3/WrQziHeyxOD3KyyIdka0a97t/3t8DfV2Sx3fCn3+We3iVv0v5C6L5NS7Y6rAik9do7Q30kw1iPyR40s95J2ZYlOQVmpPuIXyRjJDiY6RDOBDMPOltiTvj1XxwKjzH4uMc/UhG6d5WvxUIEw0ATZ/VCZcy245m/SF0pLLKVd/BZUMBbh/WGsATxPCqfFCpzVj/l6hYvd3tlhEJJ0iftdIQNcBh1kQO4S7UAYIpF0VBPe4q1h9mYHdKL114KXaPN5uvylQU2/1fZLQLY2TV1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaXg+8Lqs33UfNqQR4dZ+GreeM+f9zY0ptKVlIZYlh0=;
 b=xvwf2+U5HgK8DwH054OtHssC9/GQHy5speHlPaTe38Y8678hQDGcJRy3vSF9Y5uSctNPYzZ1MbqgKJXam09BAegtuRcK7hNaHxFt1l5YyJKivw7nBiH+WDpQcfnAUluS+gv4fYKg62IfxCwo7CJQFf3FXD6HStPUnaSMGte0HHu3TsZZiXravjY6QLVsDVwUwF0Bq5K652zgJ7ic2Ih/KRUbUyRNjpxjWADFi8XW5DrLOV3pZ/XeishoJGkvZHtjoY4v9QIjEDdX9S9NLet+zwDv6izkFNMAn00NlQsUiVBgQO0MhdUtqnh1nqw4Avq/h2u1wDQ/UiC0i48i9dtQ9g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV2PR02MB11105.namprd02.prod.outlook.com (2603:10b6:408:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Wed, 27 May
 2026 15:17:16 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:17:15 +0000
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
Subject: Re: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register
 props
Thread-Topic: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register
 props
Thread-Index: AQHc55PLQUrSn28NvEuSGg7o68up87YiCJiA
Date: Wed, 27 May 2026 15:17:15 +0000
Message-ID: <36063617-EE1B-493A-929F-E8EC8655FC8A@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-18-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-18-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV2PR02MB11105:EE_
x-ms-office365-filtering-correlation-id: abeab2ad-7871-45da-544e-08debc030915
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 9tdzwsQcbr6NFm64h60HVAZnInVYxJUr7geV60MZHrQr3dFEEh78zO8sU/iT/V2xx+Tggj66/Pw8gdFI2C6hg1YQuBAbUf5BZ/NfAQfHWIJhUvUqJGSzrwm7dVxSHex/O5QO94XR2lVbdRX3Fyzpj6hVELmxS42Di5LFqHusc6IbbptQ4yzMkdo2yNDwyEzt2H8K2MOxn3rxSlhnzpqacEvv5jSgHzXPkcqjkXNc4T1fbX/2xDfBRyqK/iovSJ7F8t0sph7/fQTSYbefO+U8iiLd47EN8SoRlMP+pxZiCK5eMeQOoRS+NHu1pM1WAqnzhwFnw94/1MahNmIl7gTvUiCG1UAND1SOD31B6Ydhsgg2M1ZxvwEH+yXswVSg8T+1VgQc1edVqDMEC/gVrfuvfQ8Wa0kxRw1zDBugZM2YJsH2f98cRXba8nFyRB1gjORhPBr7uKYuEF/QnXBg1N1039wBWjc4JjfQj2CYV1q6M1giADbGid5xVIVTeiYIeB/xkgqff9W8H3Ni8dz6grl43FAX2WnFdFrJ4e3ehVzrQ6uj34g0+1CEy8TeeGO+pkNhIchBGBgtLj26is1NDfT71XV7oNH7eHMmRfyIiMk4QDTOGCQZp8kM0bnhoWuRlicrM8AOdD7E/PzrB7dFInTHsO4YvrEKXfU2maUziwdr+gpAdEhUf75jkoeV2mcE/p1KYPR8HUhqvTn6k/CDqFDObUaIU0h0lwJMuR0i+A40b18zMRHzsrKBVP5by//wfomt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjdRN2dVTWRUYm1EbVN0VDhpYXc0VitWenJyZ1FBUjZpNW1PMjg1QytnUVly?=
 =?utf-8?B?REp0NzRJWGUxT2hSMlljTkpHaUZNQmo4YUJEc2psRVllMUpGRi9MYU9aRk1Y?=
 =?utf-8?B?QmtWbUtvVFF5eC9qeUtDWXFLZmdoM1U3SGUrMlNJM1VyTkF5VDZkWi9BaDhm?=
 =?utf-8?B?NWtESWVMaWVWZG5UdFJNdnFvUzJTaVBBaU03M3J3Umlha21vdDcwOTJabmtF?=
 =?utf-8?B?Wi81b2dldktiUTM0ckEydkZYY2FKUW9jUGZXSmJXcG9teSt5TTlzM0M2K2hF?=
 =?utf-8?B?elRVRmpRVU5wTEpzQk1OTTJKZlFBRUk2clNFSGZMZjd0WDByMDYxa3NvL0tq?=
 =?utf-8?B?NThjY3FZdVlGWDcweE9waVR3LzlLczhhdmlIWFJXNG1lVXlOeEZvMzZHMnB0?=
 =?utf-8?B?Q2pXd002Z0IxTlF6SWc1ZkFwNjFnN2IvMmRGSGIyUjNOeUhLdmVqY1A2S2cw?=
 =?utf-8?B?Q0JXZlM5cDdRZTlCYlVlV3FoVnVrQTVVVjNCRGFRWXNUOVNFTzl6OGVpUFJ3?=
 =?utf-8?B?cFBHc05XRHZwTUwvNXRTYU5KL3BNaFlWSVN5MGJBTnNFbFdxWTB3YVZFTUwz?=
 =?utf-8?B?TGs2ZHpBb0RPVTdTOXdoVlczKzRhUkVNQjhTZm5KMkpCQVN3ZjlmWFNJSUlu?=
 =?utf-8?B?eGF1T2U3MXFZZ2NoTXpsVGUzSzVMejk2N3pMei9GcmxaRTZVSnZBTlYzZTRR?=
 =?utf-8?B?STFWSzAyUUFBM2NZcGRJZDV5UkVaMlUyTjhxU0c1L2tRZXlGNU1UN0gzNy9j?=
 =?utf-8?B?anpQa2ljWjBlMHg4anB0QjNTN2lVME1xWWJSYTV1c1hKVkFSbFk2bmxZZkJZ?=
 =?utf-8?B?QTIrOWVXUGtLVXZMQkRPYkp3OXQ2ZkdXcHVueW4zSUMyVGZXRDZyTC9MVllN?=
 =?utf-8?B?Z0FRdCtRNU9teGZSb3UzNVJ3ZEZ6ckVGUTdGL3loYzdxVGV6c1NqL3E0M2Jk?=
 =?utf-8?B?bjhlRjlzNW1aTHc3Tm45aFc1c1NUZGxyVTh1aWJrQWZRRzZOMmZJVDJtdnFw?=
 =?utf-8?B?VjM0MjhpZTNzVU43bkN3UUR0cVo3ektMaFFFNzVpZ3Q5dXl5L2dHempRR253?=
 =?utf-8?B?cTlwT1dvdDlRT011dlN4MHk0WkhvM2xqWDRYWXBIeXdHR2xvbXZJTUtQOHh3?=
 =?utf-8?B?bjlEbDdkeUJxVVpaQTZLYTQ1MFJFVWdNL2QzMXN6bDB4bitVQXZYeFdaTEdk?=
 =?utf-8?B?VkZWc3BOUjI1QTh6N2ovYlVyUXB2UmQ2Z0srRTlqdVllQTlEUmpodVR4MHVO?=
 =?utf-8?B?QXpMeWcyc3RpdHBlVm1PUjRwSzVpVjdUU2I2Q0ZiZEIzbFh5MnlBL2FTcHJ0?=
 =?utf-8?B?ZndyQ1FHVysrYi9ER3REeHc2Nmcwdy9OaGdiM3diS1F2MXZzc2plVTRKM2lq?=
 =?utf-8?B?eFp0TkxUVmZhM3RSekdBS1c4aG1Ia0RoT09IWmlNUE5mOGJzR2N5UzJQL0F3?=
 =?utf-8?B?NjEzdzEvcklBdU5wWG1Lc0tETWMxYnd0dTdEY3dNKzBYSEpyV2xUQ3JYalNi?=
 =?utf-8?B?OTlEOXRYakFRVGdVbld4SXpmMVIraVR1ZkhVREVucWVDb2RWV0xzaDVMUkVk?=
 =?utf-8?B?UjhKd3B5Wng2M0pucS9mYUc5KzdJOWRaNGpwV1I5QkZIM2hsYlZiSGo3RXpY?=
 =?utf-8?B?eWZVU2VuK2QwZXJWTm5iWW5vNXUxVVBVeFpTYTRoaGpmd08zV0NsYVF5Q2dH?=
 =?utf-8?B?ZGhUSW84b0QxVmFML28yZGRoSWxRMmM4UG56MU9qWUxudGV6S1FNZVorZW5p?=
 =?utf-8?B?Y3MwbFpCYmVadmEzdDJ6ZFVVLzEveWpWYTR0M2I0enFnNDBnS1JDZmpsYk1q?=
 =?utf-8?B?YUVqZWVlTG5vUWVmU2g1dWdRQzNsTXRQOS9JbHhneHpzeXo3N3hsa0gya082?=
 =?utf-8?B?UTBlM1NwZW1zZ3VzVEkxeDgxRHFvZDMvRkxxMjkzMUpsQk9wSDdlMTgxMUkz?=
 =?utf-8?B?L2RhRjlHb0JreFgvYVErTHpIY2V6cnR5cDNpSFByNFRJaUJjMVE5WGFkV1BF?=
 =?utf-8?B?VU5YSE8wZEFvQ094UWt1dGRiaFY5MmFkd0F2RXY0dkVFVTNLZG95VXZRWStH?=
 =?utf-8?B?VGdUTjh5NG5MeVBDd0xUaDJLWjFFMzdBeXdPWDVjMHc1cjBvWVJBSnY5Vlp2?=
 =?utf-8?B?dm1NUVRreFlpZmhuSFdTSGRHbi9XcU43V1pSQkNqL3VKL2g0SFdncWJyNDZu?=
 =?utf-8?B?WTVIU2JIcUZkbVhiMTNOeDE3NkVlcVVZVWh5ZkkwS2NYZjZoZlIrVE1kR0li?=
 =?utf-8?B?V1lZbHlYS2xrZ00zYW1VRGluZmlZdll2aGdzbkN4OHN5SlNvckJLK3ZLOGFC?=
 =?utf-8?B?TnZmd3JwczdaUmJ0TGxjSUovQjBoQkRReFlKdTR3eldwempTUUxwK01Fa0c4?=
 =?utf-8?Q?BrmTHLaz1+CZd3jc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC372BB17B68FE4D9D2ACD455BD0EFB5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	eYCen3fWzMVP2eWcYppGchM5ZV7u3UysaBToJRg8Epj3UJoOiYbvuilyaU9TXZRR/4PQL795gpQO7wo9BrtTtmjH+yEU09/6qm1D1pcws4Rg4ODg+TQcp+0hClL3De89QfyXe2aDvbwLveYm6+gw3YSeQiqO8sa/Cp7BEZSfUvo7jCAUwxN216TRfDPXOqWNXhHvJK9/nMOndy3r2JcWFyVLbqUgiyOJ2Q1vBAusGzPD9QLElvDZHcRL3RQqFZEtAM9ADexQJtYUavnbD4xCHRRMkC2mb/YuMBHjonwE/jnNwaVP8Nd/2jr09k8A6i7MUHFRwjoe39c2VviJr7bDQw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abeab2ad-7871-45da-544e-08debc030915
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:17:15.6297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mqn+/ZSZ8MEy5Gohwn1ROqk3OTWBZULM6GK5nZLi6bWilJtmzewAgsPrMgyoajEQo2Mf3XXQWs/m+SgyOpFieeDsy5W7UhlmZkQA0AgqTsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR02MB11105
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1MiBTYWx0ZWRfXx9QXk83IOvmS
 WC/HuR9ARoEvSyLWH+ofcBkBvkp5XX1IVVJjVSr2Z6Pd0m1Q8I1zUbgFUyatdNn4YuTBVHUPMOk
 /yF6wHjZRjpJ5mUGy4GgEraz4ccR05qjJRhaqyosCngc/7DZmxawhQByM3G8aOhPnO3BBWWmMU/
 6W7XlaJQ1tcM0k7+S6qhIVLKGyz4ap7GHez0zUgN9S7aqEIL8EIbriUQQU+PFvTkjHn2YrLoT20
 HTiwue35Z63Qzb2iOCZwasj2SyzGznD+BypQauwCuUdHBi6MuhnN/LH4XekEOun6EYDJg6LwrrM
 vzRuJYLYA0fcSNUPAO8kYkfX5iBeO/FjdLjEsJm1Bs2RWxGw8rHxRcN0iJrJyjBtfPNz3fjJjrI
 crHn4SVyPmoSDOh45FYbfvG+z/kn4QxNJhZYuarK50IYlyvH7L8LN956YR+KX4oXz7HYpsJ04ZM
 dW0oAxAhIO2Owdh498A==
X-Proofpoint-GUID: efud6gLxMz0DGZ5KUV77woRxOGHp8wYB
X-Proofpoint-ORIG-GUID: efud6gLxMz0DGZ5KUV77woRxOGHp8wYB
X-Authority-Analysis: v=2.4 cv=E9j9Y6dl c=1 sm=1 tr=0 ts=6a170b3a cx=c_pps
 a=GQpUduAn5o7mR2pN+hR1ig==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=20KFwNOVAAAA:8
 a=kOO-Ur7PZvrfUd_FJdoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogQ29ybmVsaWEgSHVj
ayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IA0KPiBJbXBsZW1lbnQgdGhlIGNhcGFiaWxpdHkgdG8g
cXVlcnkgYXZhaWxhYmxlIElEIHJlZ2lzdGVyIHZhbHVlcyBieQ0KPiBhZGRpbmcgU1lTUkVHXyog
b3B0aW9ucyBhbmQgdmFsdWVzIHRvIHRoZSBjcHUgbW9kZWwgZXhwYW5zaW9uIGZvciB0aGUNCj4g
aG9zdCBtb2RlbCwgaWYgYXZhaWxhYmxlLg0KPiANCj4gRXhjZXJwdDoNCj4gKFFFTVUpIHF1ZXJ5
LWNwdS1tb2RlbC1leHBhbnNpb24gdHlwZT1mdWxsIG1vZGVsPXsibmFtZSI6Imhvc3QifQ0KPiB7
InJldHVybiI6IHsibW9kZWwiOiB7Im5hbWUiOiAiaG9zdCIsICJwcm9wcyI6DQo+IHsiU1lTUkVH
X0lEX0FBNjRQRlIwX0VMMV9FTDMiOiAxMjI0OTc5MDk4OTMxMTA2MDY2LA0KPiAiU1lTUkVHX0lE
X0FBNjRJU0FSMl9FTDFfQ0xSQkhCIjogMCwNCj4gLi4vLi4NCj4gDQo+IFNvIHRoaXMgYWxsb3dz
IHRoZSB1cHBlciBzdGFjayB0byBkZXRlY3QgYXZhaWxhYmxlIHdyaXRhYmxlIElEDQo+IHJlZ3Mg
YW5kIHRoZSAiaG9zdCBwYXNzdGhyb3VnaCBtb2RlbCIgdmFsdWVzLg0KPiANCj4gW0NIOiBtb3Zl
ZCBTWVNSRUdfKiB2YWx1ZXMgdG8gaG9zdCBtb2RlbF0NCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb3JuZWxpYSBI
dWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT4NCj4gDQo+IC0tLQ0KPiANCj4gVE9ETzogQWRkIHRoZSBt
b21lbnQgdGhlcmUgaXMgbm8gd2F5IHRvIHRlc3QgY2hhbmdpbmcgYSBnaXZlbg0KPiBJRCByZWcg
ZmllbGQgdmFsdWUuIGllOg0KPiANCj4gKFFFTVUpIHF1ZXJ5LWNwdS1tb2RlbC1leHBhbnNpb24g
dHlwZT1mdWxsIG1vZGVsPXsibmFtZSI6Imhvc3QiLCAicHJvcCI6eyJTWVNSRUdfSURfQUE2NElT
QVIwX0VMMV9EUCI6MHgxM319DQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2FybS1xbXAtY21kcy5jIHwg
MTkgKysrKysrKysrKysrKysrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygr
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vYXJtLXFtcC1jbWRzLmMgYi90YXJnZXQv
YXJtL2FybS1xbXAtY21kcy5jDQo+IGluZGV4IDgzZWM5NWMyOTAuLmU2YzcxN2E4NzIgMTAwNjQ0
DQo+IC0tLSBhL3RhcmdldC9hcm0vYXJtLXFtcC1jbWRzLmMNCj4gKysrIGIvdGFyZ2V0L2FybS9h
cm0tcW1wLWNtZHMuYw0KPiBAQCAtMjEsNiArMjEsNyBAQA0KPiAgKi8NCj4gDQo+ICNpbmNsdWRl
ICJxZW11L29zZGVwLmgiDQo+ICsjaW5jbHVkZSAicWVtdS9lcnJvci1yZXBvcnQuaCINCj4gI2lu
Y2x1ZGUgInFlbXUvdGFyZ2V0LWluZm8uaCINCj4gI2luY2x1ZGUgImh3L2NvcmUvYm9hcmRzLmgi
DQo+ICNpbmNsdWRlICJrdm1fYXJtLmgiDQo+IEBAIC0xOTAsNiArMTkxLDI0IEBAIENwdU1vZGVs
RXhwYW5zaW9uSW5mbyAqcW1wX3F1ZXJ5X2NwdV9tb2RlbF9leHBhbnNpb24oQ3B1TW9kZWxFeHBh
bnNpb25UeXBlIHR5cGUsDQo+ICAgICAgICAgfQ0KPiAgICAgfQ0KPiANCj4gKyAgICAvKiBJZiB3
cml0YWJsZSBJRCByZWdzIGFyZSBzdXBwb3J0ZWQsIGFkZCB0aGVtIGFzIHdlbGwgKi8NCj4gKyAg
ICBpZiAoQVJNX0NQVShvYmopLT53cml0YWJsZV9tYXApIHsNCj4gKyAgICAgICAgT2JqZWN0UHJv
cGVydHkgKnByb3A7DQo+ICsgICAgICAgIE9iamVjdFByb3BlcnR5SXRlcmF0b3IgaXRlcjsNCj4g
Kw0KPiArICAgICAgICBvYmplY3RfcHJvcGVydHlfaXRlcl9pbml0KCZpdGVyLCBvYmopOw0KPiAr
DQo+ICsgICAgICAgIHdoaWxlICgocHJvcCA9IG9iamVjdF9wcm9wZXJ0eV9pdGVyX25leHQoJml0
ZXIpKSkgew0KPiArICAgICAgICAgICAgUU9iamVjdCAqdmFsdWU7DQo+ICsNCj4gKyAgICAgICAg
ICAgIGlmICghZ19zdHJfaGFzX3ByZWZpeChwcm9wLT5uYW1lLCAiU1lTUkVHXyIpKSB7DQo+ICsg
ICAgICAgICAgICAgICAgY29udGludWU7DQo+ICsgICAgICAgICAgICB9DQo+ICsgICAgICAgICAg
ICB2YWx1ZSA9IG9iamVjdF9wcm9wZXJ0eV9nZXRfcW9iamVjdChvYmosIHByb3AtPm5hbWUsICZl
cnJvcl9hYm9ydCk7DQo+ICsgICAgICAgICAgICBxZGljdF9wdXRfb2JqKHFkaWN0X291dCwgcHJv
cC0+bmFtZSwgdmFsdWUpOw0KPiArICAgICAgICB9DQo+ICsgICAgfQ0KPiArDQo+ICAgICBpZiAo
IXFkaWN0X3NpemUocWRpY3Rfb3V0KSkgew0KPiAgICAgICAgIHFvYmplY3RfdW5yZWYocWRpY3Rf
b3V0KTsNCj4gICAgIH0gZWxzZSB7DQo+IC0tIA0KPiAyLjUzLjANCj4gDQoNCg0KV2h5IGFsc28g
bm90IGFkZCBzdXBwb3J0IHRvIHNldCB0aGVzZSBwcm9wZXJ0aWVzPyBMaWtlIHRoZSBmdW5jdGlv
biBkb2VzIGZvcg0KbGVnYWN5IHByb3BlcnRpZXM/DQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQN
Cg0K
