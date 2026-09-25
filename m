Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEFA41CB31
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 12:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340404; cv=fail; b=WYuBm6qSMsDlIC2l2TpTloNK8jVAzrXCwzS+zBU5dkF6Rgbycuzi5M7b8POFfcBS4zoL2sD19OfL7VGtmG0Hvvost7nkI1n1As1He0CI/LhfNwx1B6ANMxYHZq5+249P3Gfpq/a2jOd9QqdUw3+39sPRPsmPaoGpCYJnHKchFP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340404; c=relaxed/simple;
	bh=rFyoDsL3jKZut5RSHj7J0ILJvzd42+3me/mhVSfRo00=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V0o633gepaklHTWDPRSNDYS14HQ5AJ34r9RFYQ5Q5cT5/4vRfZqR/lexkDq7FeSeoo8kI/mSWGCDLNky1Kb076jan7wiL3IL+aXO1PKudUiN6j1Q0NT7WWMMgUxquYaDjSDqYCJj5xDgy5U73BK2nMVH8ue/T6PJRrPuSTa+EnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tqU9j0zb; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sz/YsnD2; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tqU9j0zb";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sz/YsnD2"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4cFwi3801799;
	Fri, 25 Sep 2026 05:46:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=rFyoDsL3jKZut5RSHj7J0ILJvzd42+3me/mhVSfRo
	00=; b=tqU9j0zbk/M7hpaX3RhIe3xlX3uFjlyB9bT4ju8cUHD+WaFq0hzjocuvG
	dqozPRYqPOg8BGkpv1fTHsMTfdyJkWNGb9ioSfFLkm/+QPIcS0GCqd48Y10fz2B8
	ZA2rNEZkfPUqbkiyjLyhocMMxxTpMWfulA9SZjjbOM6rXHFs0Oq3dBR/UZdrErWV
	bLMnoqN0gI3WKyJiiMX06zpFWLE2WmCBrYvywzgsTV5f8jeuBRLFfJTeO/C/X4f1
	V9vkYjANSJ299u1cQKK117JWg3IwYfo/qwnBc7IivTtb4IaO7tq5XKkS68nggJMd
	RVV9lmFohfH+X3Uy0JZwVCrlk/J9w==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020122.outbound.protection.outlook.com [52.101.193.122])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gw9xv21cm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 05:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuH30HLFslJcBvk6s1sbUKs863SV0l6dJUdKoFCipUOLaT3PTPhA07BKergD1SqA7MttFW0IpnNa9vzZ0omCxdHUrEvSnm16kkRbzAtvn4gRHQAl7QpmBUs3JxihaI8ROYKxvmvlqFrR7TiZfocIGzUL5N4JMHSAk4dMbs7K7aas4iv8b7vcQ0IQQSwT9fhn1k7QtWoVP1umZ0Y06MgGcYCyhX9aSyvcC1Xnwv46//yhEo1qhhVCSfw+uQvEi903F/tG5Hr8BuHU/ro6hUeJmwR2kBUqAXoWfOCXcZ0ewr0bod9AJlH6PGsITlhqcBCDWa/BDlmDU8NjPA62dnFgkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFyoDsL3jKZut5RSHj7J0ILJvzd42+3me/mhVSfRo00=;
 b=YkQHsRH9WejgHhHIV9inBq8siaGDqkoPPrShnuXeRIS1Tc4PC3mq9Z18LybuevWembSs3sLdnkwnZjBZ80ujHFoNE20XzZ72vYNzDusL69y5lN04E9eieoB3+sLLJndspL+DHefxQjoWzih98HZPiw61F9Faj1teEpVWA97G3wTwCno9dADkVlJg5Rr/sJzE2xxOIsmDIH15kscR7RNNsZ+HzoeIqNmDipnR2JJPCrM8TC5LfczEhLxu73lc5/8ZDc7D490ulPa2A61wklzRNp5eHuKsYHHKusSfCUOZYIGLc5hIyHmITkpJZg2FVAfB6ECorLfu5ZwL+HfvjBxawQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFyoDsL3jKZut5RSHj7J0ILJvzd42+3me/mhVSfRo00=;
 b=sz/YsnD25EINludq3NdWt+uNCc5z7OiZlhOMvkXxVtdfkduxiJn1/VkgUHvc20q8iDGGb4n+epVwrKiqLG+yhwo9GJFgalVG9DEVquldCetLhUWyPd7uFmASL2L3yyQc1pl18yQ9KgbJiuE+AYL8/2pOr8E7fID/BNud5oTWXjqzNn8y8aP2wmOxwe5SQKVG1L4CH1eVEqjHEAxrWVY8xwsCeLZL4RjVAmHQT4mAQDhh3rp74TSrjrNFDfLr8td5AQ4ZFqycorBCdbaHBUNkRMF4JIkzYgGnVDbRkJzIv6SPsB9yHhwiKKeXZwag4371/InBzbbUXmuWn/hk7SZwQw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS2PR02MB794327.namprd02.prod.outlook.com (2603:10b6:8:408::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 12:46:29 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:46:29 +0000
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
Subject: Re: [PATCH v9 11/26] hw/arm/virt: Make sure virt_get_caches() keeps
 on reading CLIDR_EL1 as 0
Thread-Topic: [PATCH v9 11/26] hw/arm/virt: Make sure virt_get_caches() keeps
 on reading CLIDR_EL1 as 0
Thread-Index: AQHdTOvieEqhuFaUA0CmwxUOJBSFZA==
Date: Fri, 25 Sep 2026 12:46:29 +0000
Message-ID: <3A7F2657-223F-4376-824A-A0DE0A7F0528@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-12-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-12-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS2PR02MB794327:EE_
x-ms-office365-filtering-correlation-id: dadbf9ad-7511-43d8-43b4-08df1b03055f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|6133799003|22082099003|18002099003|4143699003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 4olc7AKeAGyUHBxnz45RKr9q50YJQeSrPjShOb7iKSMHHrJBPiPGdJLPR1wZ2c6rHu+vUVNlnMkfJsuXXCTpJrSA9eSB1bF/GgRUZQoFG13tnmgjt8dX6E6GzLwjGM8lIwnagNy0ugfqnmv72h8XxZ/GbbaOrBlRrOXrbQ6BL9qrEkaf1UQfMy50BKIcibX/UKfb/TwXygPdULx2/txQVqDHeShzSmA7eK5NBELNHdGAfiAKdvFNmpfMqRyIJ/2IeUEpZBbVNmX70c9ze7+ZSi8k4gCsvln2jVWpfCOMA2pci8L02oLGyBG55rAtFEaU09suTdZUliT+K3iswMGZ/wSBHttSVX8AixaoINCBXK9PsxvPSjEQogOlHQBxXRyFHG2GLfe5FASFSOLTfY/gBIy+7hoB4OnataLIdruAa/Q+VMn0wtruBlwYPmFsf3IRH6jvHQZ54YAEe+W/wGQPqa2Rypcot0abWcCxYt2PQLTXJauyHzVegVZXh83+ia+n/wb3Y3qXywtRiNyDixCaRmHM+qH4i9RuvyH/reoYuLkFW/GnbiFu9UXblsk0nbUlYO+p7PHW/i6prw5eH5SJiQRaraHi0ew5o6BsURBNvQsDecQQmGIi9VIyik5MVd2CXbgb0jLHUZZxZ9esCZBdnZmMb5cYm1taNmyDWOjGWU28AukAeB+ZFDUtwvSoA7StH0FeBVA+xiti2FeYbOloiibf/x/3q42tdDoBwzN6zpU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akQzUmY1NjY4KzkxdDhXS1NQSmUyYTdCVEN1RVNhQjZLYUVpajg4QkkvdHl0?=
 =?utf-8?B?MElSaEhSQVVwUFlxVEZvNHF3TGY3c3IrL0lvSTEzNTVQRFdzaFdadS9XV0RZ?=
 =?utf-8?B?SnB1ak44K1FRaHJwK1YxUzN6djhCTCtkM1VQWVdXb20vNlEvY3gvTW1tSkxV?=
 =?utf-8?B?UVZKdUFudGFFU0M0azlqR3FsNEl4MVV2SE9mcS8zbU5lOUVNYkhXQzVScXMv?=
 =?utf-8?B?MXhhWDA4OXNrZ0xWWTA2OG80RUxENng5T1A3NTRXK0VaTWVpd2VRd0dROHhl?=
 =?utf-8?B?aVE2TjlMZmk3SWdQN3NzWWcweXE4cU1jQ2pqQ3d2TjY1MlFQMXpQakQ5ZURV?=
 =?utf-8?B?c01SdGg1dWd1dzhvT2s2WVBDQ2xaQ093ZEZwb0YvUEJqNW9wZnAyUkFXQ2xF?=
 =?utf-8?B?cG1WaUFUUks5d2k1L29IU005YlI3d2tIRkgrbmtUSDZDcTZ3UHRRM2VGUjhB?=
 =?utf-8?B?eGxJU2lrWEpFQStnNENpQ1FQeTVhdHpleGpjQ1cwQlowUzJyaGhQUGVPRjRM?=
 =?utf-8?B?Y09VWkh6aFdtNmZiQnJYb3lrd0hWbldldzNqdUY2dE8rd3V2WnJWV2NFYWsr?=
 =?utf-8?B?SVZOYVJTeitNZWYvM2ZNdmlicFdQU1pMOEliWDdBbXdzRDdTKy9WOC9IOFM4?=
 =?utf-8?B?VXVRT0ZMeXVsRm1INHVjeDRPeis4UUp3SndEK0pZb3hQakJnaWRETW03dWVo?=
 =?utf-8?B?NDViN2doa2srSHZlSGZJeDRHYk9YUm92ZlFtajlTTmdRa0M3TmNWdEpKWDd3?=
 =?utf-8?B?VFY3QmM4R1pGTWM5WUp4REswRGZ0ckVuZTcyUUdZdkI3YjhPcjRldzlVblBQ?=
 =?utf-8?B?alp1d09CcnBUbHFrMDRiSkNCbjhKMURMQlVHajdGdXRMc1pmcjRGMWlLNG1r?=
 =?utf-8?B?T3BoZy9FdHR2bmE2UWFKNWJoa00yeHgxdFFJMDdNYmtJUm1mZWgwZ01RU05D?=
 =?utf-8?B?WlhxcTYwTXJBdVlyOWQwTzZIaWlEUWhlZS9LV29CZ3V4SU1kSmdVZG5qdDl2?=
 =?utf-8?B?Qmt0NnVTMHAxM0duMkpNbmNBZWZkM2dIRU9vdFJGeE54T3JKVEZWbEZXQkpy?=
 =?utf-8?B?VmUyNjlYZG5vSGxlYlhPRVZXcFVtSWRmVXVxOENIVmxzYW5uOU5SSUhUT2tw?=
 =?utf-8?B?OU5FVWRuZWp5MmhOY0tzVkZUMTRrekNjbHA1RzQzVldvbHVnZVZwdDVmdmFm?=
 =?utf-8?B?bkNIbUd0bi9IVUlqaWZYT0NjQWl1ZDlFcm0yY2NMenlRRzNLT0ljU09mcWRj?=
 =?utf-8?B?a1VjWnRnL1hmOTY5VXN3ZkQ3S05hdjZRa2kybjFrTHdPZG1YdXRseEpmV0Rv?=
 =?utf-8?B?THQyVktnbmFidjFoSVhxdU1rY3V5SzgyTlA5RmRMdCt4dGdFWlAwK21JenZJ?=
 =?utf-8?B?QXV5T1dUTVUzOHZJWWxTOEp5TlBYZ0RHbG9MQzlpU2swSUQ1aTg4a0JUY2lz?=
 =?utf-8?B?M1l0cm9FOG95WXdQQ3U4aWE2SXF4U1JhMDJSY253Q1JzY0V6ZFYwOWZFT1Fu?=
 =?utf-8?B?clZhMWhjYnVRM3lpZUFPRXpTVjFUZHgyWXVPeEVOMnlNR3RPS0NnVElpZVRl?=
 =?utf-8?B?aE5GbGJreXRyRDRMcjI1OEtoaDczckx5bFQzN2tTK25qbTltNExvZE9LSVNo?=
 =?utf-8?B?UE9zWEU5eUdmVlFleFVuYlIvSmFZdzZYUFpWUm9id2pPR2ZnWFJKT3JGam9L?=
 =?utf-8?B?WjZyb2RzNGZndFl5WE1UL1phNG1aUi9iK3dVaitmVitxMWtSS1BVTFA5cXhK?=
 =?utf-8?B?bVQwdjlydHYyZkRsWk56ZGJYcWUxYzFRUklJWEVQZDViUzdqWHMydWFMOS9r?=
 =?utf-8?B?RUJUTTZhdXA5aVNMSjk3NjQwckZBaW9WYmJkR1gzK0wwRXpGZVY4N0UzY1lw?=
 =?utf-8?B?cmlyZTVqMWZuQ1pKbjVOa0Z1YlpVRkxDeXJUMEIyQ25WOWZEbjIvZmVqcHkr?=
 =?utf-8?B?MEhCckdCbnhoTlJpU1ViL1lrK004Y2o2Ty9KNUdJbHU1Z0ZScENONThzVm5t?=
 =?utf-8?B?RWw5cmF0YU85MTdzUldCREIvd3ppODQ2OWsvU0RveVJWeS9ST21wS3NQU1Fx?=
 =?utf-8?B?R0hrdE9KOTdIdWtPZy9jRDhXd1RiMWhycktuN3FXUTVPQTMyQ1UyWGVqRytL?=
 =?utf-8?B?ckNwM3ZDY0I4UUtKamkrQzI4ekdXb2JKQVBSeTExSnQyTEFWSnVRZzFNRk9r?=
 =?utf-8?B?MWVEZ3JzMXlZdGc0RENqempKME5mM0p1S0FyK3Y1MDJXYWxSVmUrN0VkMEZS?=
 =?utf-8?B?T0NBem9NSGhGOUZXS0k2QzloOHp0OG9ZSGJuNWZFUTNJSzczMlVVelBtYVJi?=
 =?utf-8?B?Y3ZtR21jWjc4ZlQvSVU0bU1ITFdzNlYwK2ljdkpPeXFGVWg3TnlxSG9nRVdP?=
 =?utf-8?Q?zMPv5HHMZg2kjjBw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4741397E4411644B758AD197B9B12C0@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	sAz9qoJKWbL//xqUOv3slzZZ5F4lOAgTyoyTxKgfmmQW8DXeOzgbFdhnFFDhycZfX2SJWRUI9ym2NV6Fv17PemRM22sJ0i8BmpNjwqjJLouWKSEc8qeKXsLKjWT5pmCvBsG0a96LcnlJnqFiVULeTKPKll0k66zON/4I8gA/liDtoiYXvL7VXZJO3iF73JMfl1Y9Og1AEIcmWEZsTO8fEdqmi519/3UsRKPOBX4dHY5fyYBnrodH6S9779gxjv6J1XF0yTuoD1v0Tv6Ij2LvKScY+v/zEIoJVqq2kRkABTTzgn2t8ExLHZ5i1mkTqPwzDKKFhq6ZUs4LqpRcEoDxKg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dadbf9ad-7511-43d8-43b4-08df1b03055f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2026 12:46:29.8631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S7g+ike2taho0dtHOqLjXhsiZ8xmout0ud0bSjdv8D/7zT6GIxeZK+k5OdSKDY7iAHZi4BE+SabHUXve74BAm2YiqBkswUwOEoJZMfoRSrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR02MB794327
X-Authority-Analysis: v=2.4 cv=YoCa1IYX c=1 sm=1 tr=0 ts=6ab66d28 cx=c_pps
 a=PcTxMsyy24f1mGF745e4bA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=64Cc0HZtAAAA:8
 a=20KFwNOVAAAA:8 a=sCcXX3KIBKNNhNa9egwA:9 a=lqcHg5cX4UMA:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: R8XBB6s35HGpHzpo8zLBuUAXQR-xbjgV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfXxLJL4K2nkb6i
 tCJCSTmoc8UVrBPAjhWjffZav50cCJjEnpEfbMCtBQ5Z33gr76dlhwA9InhAYY+HhWcuhUlWh96
 9Vf+ngj6DbCBz/hMYQNoNUO3HC2WCcOqMvVDLl2TDwVMFzbLxUcEbCqxvlud5YROSxtDChqds8g
 ES51ZjmLEaZ9LK0rAHhLZDBnWyHDR6LgxwU1k2KDepDlEr12j3uC6FOEr5uDBYfW7ndDx4iyy5h
 yrCxdjZNLmiuqHpfb43xOhI6CojBgBW5yIqtJ417YRFscAQYd3o9uH73ihB+650KMWT2nfkuSA5
 BCXUHwBThB51okeddNuT54kK2R89sJlX3MXs9b9sPp228VV9kP9mhgf6gHlHPfrXFrNXRtPOPMe
 SM222eWtqCZ5ZCj3Wt3Gn+/RE+Qeja0+pR1PHUZEYOI37LnxUCprEr4DyyMzYx1x6pLcSjG0CK3
 bSMA/rf17xHl9OrWJnQ==
X-Proofpoint-GUID: R8XBB6s35HGpHzpo8zLBuUAXQR-xbjgV
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfX8xeSIM9I76gi
 gkkMMEldn+rhGMQ6Sys9yXYG18runJV6xX64XZ9J/jPWUYJ5rKfARx8T4yrduQNmkbSgSyB+mEJ
 mzeao3gm367oWIcxswRQtdlo11WiaB0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW4gS1ZNIG1vZGUsIHZpcnRf
Z2V0X2NhY2hlcygpIGN1cnJlbnRseSBnZXRzIGEgemVybyB2YWx1ZSBmb3IgdGhlDQo+IENMSURS
X0VMMSByZWdpc3Rlci4gVGhpcyBpcyBkdWUgdG8gdGhlIGZhY3QgQ0xJRFIgaXMgbmV2ZXIgcmVh
ZCBmcm9tDQo+IGhvc3QuIFRoaXMgaXMgYSBidWcuDQo+IA0KPiBTb29uIHdlIHdpbGwgaW5pdGlh
bGl6ZSBhbGwgd3JpdGFibGUgaXNhci5pZHJlZ1tdIGZyb20gaG9zdCBhbmQgdGhpcw0KPiBpbmNs
dWRlcyBDTElEUl9FTDEuIEhvd2V2ZXIgd2UgY2Fubm90IGRpcmVjdGx5IGZpeCB0aGUgaW5pdGlh
bGl6YXRpb24sDQo+IGZpcnN0IGJlY2F1c2UgaXQgd291bGQgY2hhbmdlIHRoZSB3YXkgdGhlIGd1
ZXN0IGlzIGV4cG9zZWQgY2FjaGVzIGluDQo+IERUL0FDUEkgZGVzY3JpcHRpb25zIGFuZCBiZWNh
dXNlIHNvbWUgaG9zdCB2YWx1ZXMgd291bGQgYmUgcmVqZWN0ZWQNCj4gYnkgdGhlIGN1cnJlbnQg
UUVNVSBjb2RlLCBleHBlY2lhbGx5IGluIHRoZSBjYXNlIGhvc3QgaGFzIGEgdW5pZmllZA0KPiBM
MSBjYWNoZSB3aGljaCBpcyBjdXJyZW50bHkgbm90IHN1cHBvcnRlZCBhbmQgdHJpZ2dlcnMgdGhl
IGZvbGxvd2luZw0KPiBlcnJvZDogIlVuaWZpZWQgdHlwZSBpcyBub3QgaW1wbGVtZW50ZWQgYXQg
bGV2ZWwgMSIgZXJyb3IuDQo+IA0KPiBTbyB0aGlzIGlzc3VlIHdpbGwgYmUgZml4ZWQgc2VwYXJh
dGVseS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0
LmNvbT4NClJldmlld2VkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNv
bSA8bWFpbHRvOmtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4+DQo+IC0tLQ0KPiBody9hcm0vdmly
dC5jIHwgNCArKysrDQo+IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9ody9hcm0vdmlydC5jIGIvaHcvYXJtL3ZpcnQuYw0KPiBpbmRleCAwODcxYTM1
ZTExLi42Yzg3YWMxMzNhIDEwMDY0NA0KPiAtLS0gYS9ody9hcm0vdmlydC5jDQo+ICsrKyBiL2h3
L2FybS92aXJ0LmMNCj4gQEAgLTM0Miw2ICszNDIsMTAgQEAgdW5zaWduZWQgaW50IHZpcnRfZ2V0
X2NhY2hlcyhjb25zdCBWaXJ0TWFjaGluZVN0YXRlICp2bXMsIENQVUNvcmVDYWNoZXMgKmNhY2hl
cykNCj4gICAgIEFSTUlTQVJlZ2lzdGVycyAqaXNhciA9ICZhcm1jcHUtPmlzYXI7DQo+ICAgICB1
aW50MzJfdCBjbGlkciA9IEdFVF9JRFJFRyhpc2FyLCBDTElEUik7DQo+IA0KTml0OiBhZGQgYSBz
bWFsbCBjb21tZW50IGhlcmUgZXhwbGFpbmluZyB0aGlzLg0KPiArICAgIGlmIChrdm1fZW5hYmxl
ZCgpKSB7DQo+ICsgICAgICAgIGNsaWRyID0gMDsNCj4gKyAgICB9DQo+ICsNCj4gICAgIGZvciAo
aW50IGNhY2hlX2xldmVsID0gMTsgY2FjaGVfbGV2ZWwgPD0gQ0xJRFJfQ1RZUEVfTUFYX0NBQ0hF
X0xFVkVMOw0KPiAgICAgICAgICBjYWNoZV9sZXZlbCsrKSB7DQo+ICAgICAgICAgdWludDhfdCBj
dHlwZSA9DQo+IC0tIA0KPiAyLjUzLjANCj4gDQoNCg==
