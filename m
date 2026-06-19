Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B192DB788
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870668; cv=fail; b=m08ButPjCMj+EckpmHpv8RjWeOKjxR09a1NHERw6ZEeNETj5ZgKqNvpfZ2GvAJmW9nH9ioFqjyCkFWh30V92bStR76CcUT+lbhdo/ElMNGOrdu5d/kbbvAXjHFjWK+NIX1pDWNbesWriA4RtBA/QTyrvVwmMLe9o2fJx1NLFT8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870668; c=relaxed/simple;
	bh=tWvamo4ET/F27ezdF6SeXJqChMpnw+QnMzJawGaC2G4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cGEeASdqZOU52naxQaTZLIrd5Tp7RZfoRkKiKgEx5CXSz6HH4JOKtWZhJvsSBVLAJmLM0c2u7Cqqc82lPPgZMS7mm1+ZkBBDPB2Q5EROLCul2t0XmQpuEbtn7LNwAiBhsQndzBxwl/pMyULq9VT1jc7Wg8SQ+B4OaXwvecCaO9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fOJRm/Or; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cAEWnUoU; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fOJRm/Or";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cAEWnUoU"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J7QYp92846305;
	Fri, 19 Jun 2026 05:04:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tWvamo4ET/F27ezdF6SeXJqChMpnw+QnMzJawGaC2
	G4=; b=fOJRm/OrHvrFeKxE0Gwi98t43kGlH8/s0C9vu8RfJWO79p3vtMe8vGGuj
	iIOWtvnzAvvJOEgUCdLQgJ2bWLOMINhpjqrs2gk38wvgmX1YiM+FXNXl13u6Mdbk
	VGf0i1HM9Vfd8BDIWVYkAJu0uggqHsROqtGtOiSxHNpR8JnCfO1HpWOIuf7PrzLk
	8xT4L8fVdStRn8llwYbpxoOpnVqXEdq58gfR8QRKtD84kW0cqSR5JAhxczBgDrUz
	r7zptXl9oVaRaKha9Fj0eGhp6dw3pWO8K+sdruYCtHU/u30hzbWPHTB9VQwbEQ03
	lpp3kRvoX2xDcToMKbAAA01CBp0DQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022143.outbound.protection.outlook.com [52.101.48.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ew0w2rpfk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jun 2026 05:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irdkhv+YJLvjf9eaC8oj83jlzkp8RMshiD2KRigAc1GpO2Y+Tv76yl0iAir95RsE/sTKjOBLR3mjshfTM1mElEg0K4VDgEpEKi5F5j3vgrMG7CFOTwOAAm35pf5u1p3fRwFZ2/K7nRRz2pjN6DMOYv3JdCQ15saSs0uClu3TRIsQ3SVfV1jLcZOUbC7CiuDRrJwbHR04H17ejYg1aV8ukuTuDAe2kYFYE3qiQQ/TtyyHL762Ty6xEDqojTARKHhLezW1gNxJfrlzozo4Sd+t0nJDR++DKQe0fzkqiIsrrlCciPVtmN6bhvBOXmc4WGLGWSiZbUBy9ZrzVDOh4Z1gWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWvamo4ET/F27ezdF6SeXJqChMpnw+QnMzJawGaC2G4=;
 b=G1oeZQ1vniFJl+ekqnGUQSKuU045Awd8XpZNZox9BxhNgHUjMPxjFQTI1dGzD6RH8uOtqMgh1Fu7sQpEbi+TstFXXAReJptOgI5GW+qtod4qR4mSFxnIzjv6h8ZNnEuOe7jmiE0QDjfn9sjgmBlX00mdRwUYGAoVgBfk/yIIdVFEj8hnhtMu2FopY6PW4gyFeIs/k0iM5NLY0bwf74uw7qsYHhFuehr8mkJ2eHaYDcjsoLSM0rTFBP0Ih57oGo4AAsUJZbqOpD7KNXzo7Dcm0aHx8iU4KImGh/XHgyDpxi1a8vpgBCpHzlStoE+4klmJxMK3kmr+rPvLdobE14n6Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWvamo4ET/F27ezdF6SeXJqChMpnw+QnMzJawGaC2G4=;
 b=cAEWnUoURJl3SsCN2kqH8O5jgPXhwPMYQ2bujuViCMXPaVQf7KzxdQIg1rxX+SrBhxfJChqrIMvbjDmHXw/xy9zXXDs7gywElusEFV6uDF6sF2yzVrd8WovhttrRFYAnz3u/qR9ofLz83fO4beCOB32+QNWvEQnFilSnQ2moXK9DcYSBJnx4y3qZaKtzMjo8JV1djLv0l7kyZrgZ6Ukp2ELAdIDVZDOsyBmu9fnMUkeADiehYTK53vfVvQN34ssCQJkfiTCg7WVQKjwA+jHkqyTNzPc+YJjKCikzi3NXqRmHY3pHRlSJ6AFjrDhnTDEwp0UQkmdDaJavTgtzJEFQrg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6881.namprd02.prod.outlook.com (2603:10b6:a03:21d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 12:04:07 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 12:04:07 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Eric Auger <eric.auger@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Peter
 Maydell <peter.maydell@linaro.org>,
        Richard Henderson
	<richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri
 Denemark <jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer
 Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus
 Armbruster <armbru@redhat.com>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?=
	<philmd@linaro.org>,
        Jinqian Yang <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
Thread-Topic: [RFC PATCH v2 23/29] target/arm/qmp: add
 query-arm-cpu-props-info
Thread-Index: AQHc9Mdan99yrqTo5UaDF54gmxsAAbZFuLoAgAAlHwA=
Date: Fri, 19 Jun 2026 12:04:07 +0000
Message-ID: <C6C62DCC-68A3-4805-AF9B-79E7302797D7@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <20260605083358.1320563-24-khushit.shah@nutanix.com>
 <ajURCGaS94gwV_px@redhat.com>
In-Reply-To: <ajURCGaS94gwV_px@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6881:EE_
x-ms-office365-filtering-correlation-id: 9b09268d-5aa9-44c2-3fbf-08decdfadd65
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|4143699003|4133799003|3023799007|5023799004|56012099006|6133799003|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info:
 ljh/2Uel2D3HH5g5++8acUZ4CLAVY65b3GI+EWa71x59dYfFJIJmkarLiZDuFCBVot+cOMQ1zA90ynK9NP0oU/G0yUPILl3U++T/+Ixz1MifYxI0IHyqsqn03M+9GIqs5Pl6nRmg52KaF1yf5PZPmlTY772R/sevJOF6ffQlysW84iwEdpcG3vafbMaKk5xwyZ2wCOuhFuOG58zxMvFordOpS3HMqy0+NQzXIoty/qZDALQtPgO2Vp6fMTA5XvT7aKYkN+N+vZaf0m1SvCvrafrpgp7V4AtZQdiofyZwBapf8tCXXa7N9DrMFu1F0URE/aHX2v1KaUBS6nQmakETVKquYJobPatiRQ0L4KG5zup6+pwYpXF8VRvBUlCbkrFqiOKdJPE6oivgHS1byLTPOu+kdh41zs+jkRKfWlL2unwew3alPvDTQZ5pXUtQxx/2mHkV98q8Ccahza48esQHciPx9DfEkNyIcnIkCOZykHAIJZp8u0AfrgboxScHSGbbAbz8WhUfdK8jUDERCp3owdOSpwAY57b4conjpQA2UNzmOKs9sT+SpA5mkCnt6II4JpydNeovPdhMvIf5dM08Weqd+jPx7veIz/dwlkmwa0V+dIzZoCSR9pggAxpc+YSpGCigwJi0MbSMBXk9YHR+Ii+h4zf9Jq/YKwo8pToHfbI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(4143699003)(4133799003)(3023799007)(5023799004)(56012099006)(6133799003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VEFRTk1FYyttSHUxemQzL2xjTFUvbUVqUDMxeUpGdEpQR0F2SEFySjJCN3Za?=
 =?utf-8?B?WXFidVloK2FaWE5Bb1IwaDA2Yi91ckdmUHZualA4cFg2QUIxZFd0bHRxb1d4?=
 =?utf-8?B?OEZrenJ0UDNiSW9YU1E1MlVWY1FiaklzWFE1L05PRU1XNnk2clRUK1hzdGFh?=
 =?utf-8?B?TDdHV3h0QVhPWnVZTjVCQy9jOVpVWkJHcUovbjlCOWVDLy8xODVUdWZ3bWFt?=
 =?utf-8?B?NHM4VXBBeGpZMnoyZEZJT1FUV2REaFdLVlJtblhTTkc5dGVCRnZ6MjBXRnpZ?=
 =?utf-8?B?YTI4ekdTQXF2NCtDeVNZZzlHWG80SEFwNmd4OHYxdnpXSXBHRGkrVGtlVWZ6?=
 =?utf-8?B?c3BKZll6VGczTkpsTGdreXlRMTNWWm9zWk1hOHJ1Vk9iTXd6emlhK1l3RURT?=
 =?utf-8?B?ayt3VkIwczhRWHZCMWpuL2NsWTlPVndVMDJoeks0cGpyanBoZjRsVDZHZkg5?=
 =?utf-8?B?Q3c0Q04ydnltVU9YT252SXBsYmJDdHN6YlhKeWhJc3B3dHBTZ205UndsYStU?=
 =?utf-8?B?MWl1QTZWalJ1Z25taXYvWGpjY0RHQjIxWkRIVGdGZGlSUXJWV1ovVktjbnRk?=
 =?utf-8?B?TzQ0WWdnZjlLTVpwZDFxMmZ1dzExWjVoekQyTk9tUWhjNXJNL2dVSCtJK3hL?=
 =?utf-8?B?b0lRcTFSMzIrQTJYSElSOFdqci9CSHk2bjR2a1RVOHFKOXlVOWkvY2xzQSs0?=
 =?utf-8?B?REI1bi80UFRvc1dpRmgyM05KeW9XQmMvRHlUdDQyeFJzRnY3eExCOVZyM01r?=
 =?utf-8?B?LzEyS3JaUE8zY1ZXWGgxc0RNVjQ1OFVKUTNZaHZ0NHRmeng4dTYwTEhyYnNm?=
 =?utf-8?B?RkRvOEN1UGdFWWdmNDdJZVZuanBHQXI1dzRYOHZ0N3hYSytDSWR4V2dSa210?=
 =?utf-8?B?MEZzdWdUVkpWSzBBVHlEcXFmUHZyNVJaYXN2OWlxdWpVdGdzdlBSREF0RDBx?=
 =?utf-8?B?VGdhaVJ2TjFWeDBCR0xvSnhRNmZQMDhIdzR6L1VkVmM2L0hoeDJjTjNCaVRm?=
 =?utf-8?B?RmhaRG1pNnFGN2JiMnRhOEh0RzJhbGNrZm4wS0RNeGFUOWxnZ0tLd0xEL2Nr?=
 =?utf-8?B?eUpPbC9qZCt4dm8vcmN2YUQvUVR5Y3RpZzlZMUVISmJFSmNjck1Va0VTZE9z?=
 =?utf-8?B?azFRRkNWMndpZys4QW5nMUdFVktsUGZ5bWNFblNEUi9IRzEzMjl3MnlrK0Uy?=
 =?utf-8?B?RHlPZDdFSS9XbGVwajUrSytwZTdyMkhTdm5udndXTzVHdUpkTUVucWlLUU42?=
 =?utf-8?B?L0JleWhYOWFDaCtQazNJb09xd2lIY2hLNW9hb0RuekFXZHRJSHpTWkM3UEE3?=
 =?utf-8?B?TEswVm1mL0RkcnhncHdDSFNkUGZTc2NCNkFGaUFyUHA5a1NxMURaazhieG5D?=
 =?utf-8?B?Q211TUVieGloZDQzbjdzUUVkUjZGWXdaUUsvdWpwcml2Y2NTVXVXZ1A2OGJz?=
 =?utf-8?B?R05TZTd4OWo2VExNQWlnVExzTHZMZ2phUTlYVTcxWmNvZFJTL1dEMDdiN0J1?=
 =?utf-8?B?Nm9uMG9HVDdTaHBZdkkwYTlOQVhzMEZ1VkZMUE1DNWdNbUt1dnRtVG9IVzdZ?=
 =?utf-8?B?NmJEeDR0cnU3WlA5d3lyUFg3aXNpNW53NW9hcElNd0RoTkVTSS9sdXR1WnN6?=
 =?utf-8?B?Zi9HeTNOcVBTempOa3NEQXF3QkRFT3ZSbHlWZUo1MWpQelNoYkhlSkJSZ1hQ?=
 =?utf-8?B?STFXaXlhYWhFazAwZmVmWE10cWxaS0V4eDdYT3phY2RDOVEwUFM4NmZvVkVo?=
 =?utf-8?B?amhUcTRCZDBSaE9hY3E0UllYVnFGYjJ4bklZcXdzM2hOYTlRYXVJK3lEVUVs?=
 =?utf-8?B?bWJUTHg4UGw0QTZocUlUbVpVWDR4cXplektmanUxeHIwbG42S2cxSkU5M05Q?=
 =?utf-8?B?akVtVG5rYm1NL0pjZUp2NkJCZW9nYXhwcHRkYWNQVCtqMCtYTWlnYWNnMmM5?=
 =?utf-8?B?T0NyWTlKRVdDUHJSbUoyVkRCaHpEMFRSZzlQYXJJUTlKL0RwYkh1K2hzNkJV?=
 =?utf-8?B?RVltZFJYSFJMZWpRWXYvVjJmdEtZaHhueFBGYi9oOUZwSVZ2RHZwbGJMRVpQ?=
 =?utf-8?B?K292RmowUEpEMWNhdHBBaEVwYmh5Nzkxc2dyYXNlZlh4K0xSU2xRaHhaZmI2?=
 =?utf-8?B?RjRlYldlWFFCclBiZnM1dEU4cVM1Z3BXKzdCN3JscjZYUTg4N1BCOGJxTkNt?=
 =?utf-8?B?REhWSlZkVWpXalBXdy9uK2lxVUhXVGVQc2FtOU9vd2U3eDFxazE1ZWJkNnBG?=
 =?utf-8?B?SmJ0SDdtdFRGT0FPdWhhSUhjRHcwMUJTZ3RDL3d4M2xzUEpFNWNuK1lINGVw?=
 =?utf-8?B?b0RMb3l5TEVXUW1ya1ZuRVhMRVpTbU5wZDZXTFZMTk1CU0wwc3ByYlBLRnA5?=
 =?utf-8?Q?WgBmzCHBXX3spsok=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F06E692ABEF6B4A9C5A34866D1AC421@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	FhqgG6tOsVhpMVXlAyqZecHDBZs/krmxiyUBSCwFmOo7SX65fHaOSFh0AGtDfJqZrfBmrIE6p5/4eqb1qNTJJj5Qx+TZJBCLNGqRryehusX4uW8f2rcZ2vTmDlTLp/MZYoV0SMYmly273kg69AIIDzQfPHacYU76BtNZsdu4U5vcpUmsGmM9UIzpIHVffjTZ3bBtKoIiduWYeR4jBzHk4LMevo8NlZsbFqYvwBdeR7sdrwCSIyZF75MasZ3Ojt3zb0Qbc2BxEnSZEdbRxvxux+HZB/6LyJCPcg+MnuGE4eADGCVVBzpi6tMU6qlgM1Yz/3ca6yr5eYFEo45Gl31w3g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b09268d-5aa9-44c2-3fbf-08decdfadd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 12:04:07.2921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8HRT/N5knB6hEeWcc/EEgFBcEdOoZ0rqjZNvUYw21c3h+zFymU8QVbtR2d6MqIgiZpb48uhM2ZqWD2Z76GZ1Wm8rPH5qsi3zlAI0htdKCIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6881
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDExMyBTYWx0ZWRfX6alZCC4mdF3i
 7wpR51f+UsYQKj15hGFY47sbq9lgGBGUSoU9GFoElGNw+/83Dd2TuoYJd8FioaJa0D013xOvWLX
 YOT6a8JUUFvYgx2TdXoTPNsrB/sok8A=
X-Authority-Analysis: v=2.4 cv=ccHiaHDM c=1 sm=1 tr=0 ts=6a35303c cx=c_pps
 a=5hlTapE2LkzBXMJ5nTapMw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=E2OFlpCjAAAA:8
 a=vqL-DJG3AAAA:8 a=SqMvC5kiAAAA:8 a=J7Vs0gARAAAA:8 a=iXcLlBOuAAAA:8
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=h1ob84-xlcN3QfYJTiEA:9 a=QEXdDO2ut3YA:10
 a=l0t8tTNIJzRGstKQVvrs:22 a=N5whb6oI2XAsh5LpMrx1:22 a=_o8VnCo6Hb5Oqlm6Mk7M:22
 a=GK7RtA2AnwkbbjW1WRsD:22 a=U82d2PgYpd_3u6iqMSvn:22
X-Proofpoint-GUID: sPxKJBjBNaT6lhmN2QSFiXQ6Jmy5qpLP
X-Proofpoint-ORIG-GUID: sPxKJBjBNaT6lhmN2QSFiXQ6Jmy5qpLP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDExMyBTYWx0ZWRfX8A01oV90+W35
 kZx0dAXu+36IfnYTyFXXN73iftA6AgLUl8qNFZfMRekXETBVO7092pBPCc+L0BFkXPleD5RSJP2
 uRCDoGACkPiQYjF7MoFhmnkVuG8e/3GkfGJ1v/DQxuS37Ohzw5VXLSgKDkl978W3nAcNSKW870L
 hmQ3e3IV7+YMVNR4vRrDsyCCubL4RfBqxsB4jgnU+G0EYySR9rTR4ueMDvYeNWZpd8iMzbt9dID
 I6jholMs0I9eiIfJ8r4WKvJyUcC9VluhOFVF4C337LV0/mr8xIhKreBX2b2dETrpMLJlURVyjzP
 XAkTQBiN3xyVyMBZuzbND+Nemz3islcYCfqhBEAlkwB1VlghoIo7sPT7rgU3AAONu4iBJtlFx7N
 xdzZ+YvsdDaT2TL311ME+hs1FGW1mRaQg9CCKtR/8xnmXgbiHdzEt0vsHy/tulgeBNg0b/ArfiJ
 ycBEa4mP+tHzFBpu4XA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgSnVuIDIwMjYsIGF0IDM6MjHigK9QTSwgRGFuaWVsIFAuIEJlcnJhbmfDqSA8
YmVycmFuZ2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJ
T046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIEZyaSwgSnVu
IDA1LCAyMDI2IGF0IDA4OjMzOjUyQU0gKzAwMDAsIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IElu
dHJvZHVjZSAncXVlcnktYXJtLWNwdS1wcm9wcy1pbmZvJyBRTVAgY29tbWFuZC4gVGhpcyBjb21t
YW5kIHJldHVybnMNCj4+IGluZm9ybWF0aW9uIGFib3V0IEFSTSBDUFUgbW9kZWwgcHJvcGVydGll
cywgaW5jbHVkaW5nIHRoZWlyIG5hbWUsIHR5cGUsDQo+PiBzdXBwb3J0ZWQgdmFsdWVzIG9uIHRo
ZSBnaXZlbiBob3N0LCBhbmQgY29tcG9zaXRlIHBhcmVudCBpZiBhbnkuDQo+IA0KPiBEbyB3ZSBo
YXZlIHRvIG1ha2UgdGhpcyBBUk0gb25seSA/DQoNCg0KTm9wZS4gTm90aGluZyBpbiBzY2hlbWEg
c3BlY2lmaWMgdG8gQVJNLCBtYXliZSBvdGhlciBhcmNocw0KZG9lcyBoYXZlIGEgY29uY2VwdCBv
ZiBjb21wb3NpdGVzLg0KDQo+IHg4NiBoYXMgbmFtZWQgQ1BVIHByb3BlcnRpZXMgdG9vLiBUaGV5
IGFyZSBhbGwgYmFzaWNhbGx5DQo+IGJvb2xlYW5zIHNvIHRoaXMgQVBJIG9mZmVycyBhIHN1cGVy
c2V0IG9mIGZ1bmN0aW9uYWxpdHkNCj4gbmVlZGVkIGZvciB4ODYsIGFuZCB0aHVzIEknZCBleHBl
Y3QgeDg2IHRvIGJlIGZvbGRlZCBpbnRvDQo+IHRoaXMgbmV3IEFQSSB0b28uDQoNCg0KQ2VydGFp
bmx5LCBXaWxsIHJlbmFtZSBpdCB0byBxdWVyeS1jcHUtcHJvcHMtaW5mbyBhbmQgbW92ZQ0KdGhl
IGRlY2xhcmF0aW9uIHRvIG1hY2hpbmUuanNvbi4gDQoNCj4+IFRoaXMgcHJvdmlkZXMgbWFuYWdl
bWVudCBsYXllciBuZWNlc3NhcnkgaW5mb3JtYXRpb24gdG8gZGV0ZXJtaW5lDQo+PiBtaWdyYXRp
b24gY29tcGF0aWJpbGl0eSBvZmYgYSBWTSBvbiBkaWZmZXJlbnQgaG9zdC4NCj4+IA0KPj4gU2ln
bmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAt
LS0NCj4+IHFhcGkvbWlzYy1hcm0uanNvbiAgICAgICAgICAgICAgfCA0MSArKysrKysrKysrKysr
KysrDQo+PiBzdHVicy9xbXAtYXJtLWdpYy5jICAgICAgICAgICAgIHwgIDYgKysrDQo+PiB0YXJn
ZXQvYXJtL2FybS1jcHUtcHJvcHMtc3R1Yi5jIHwgMTMgKysrKysNCj4+IHRhcmdldC9hcm0vYXJt
LWNwdS1wcm9wcy5jICAgICAgfCA4NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4+IHRhcmdldC9hcm0vYXJtLWNwdS1wcm9wcy5oICAgICAgfCAgNSArKw0KPj4gdGFyZ2V0L2Fy
bS9hcm0tcW1wLWNtZHMuYyAgICAgICB8IDQ0ICsrKysrKysrKysrKysrKysrDQo+PiB0YXJnZXQv
YXJtL2NwdS1pZHJlZ3MuYyAgICAgICAgIHwgNzEgKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+PiB0YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaCAgICAgICAgIHwgIDggKysrKw0KPj4gOCBmaWxl
cyBjaGFuZ2VkLCAyNzMgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvcWFwaS9t
aXNjLWFybS5qc29uIGIvcWFwaS9taXNjLWFybS5qc29uDQo+PiBpbmRleCA0ZGM2NmQwMGU1Li4x
YTNmYjE0MGM0IDEwMDY0NA0KPj4gLS0tIGEvcWFwaS9taXNjLWFybS5qc29uDQo+PiArKysgYi9x
YXBpL21pc2MtYXJtLmpzb24NCj4+IEBAIC00Niw2ICs0Niw0NyBAQA0KPj4gIyMNCj4+IHsgJ2Nv
bW1hbmQnOiAncXVlcnktZ2ljLWNhcGFiaWxpdGllcycsICdyZXR1cm5zJzogWydHSUNDYXBhYmls
aXR5J10gfQ0KPj4gDQo+PiArIyMNCj4+ICsjIEBDcHVQcm9wSW5mbzoNCj4+ICsjDQo+PiArIyBJ
bmZvcm1hdGlvbiBhYm91dCBhIHNwZWNpZmljIEFSTSBDUFUgbW9kZWwgcHJvcGVydHkuDQo+PiAr
Iw0KPj4gKyMgQG5hbWU6IHRoZSBuYW1lIG9mIHRoZSBwcm9wZXJ0eQ0KPj4gKyMNCj4+ICsjIEB0
eXBlOiB0aGUgdHlwZSBvZiB0aGUgcHJvcGVydHksIGFueSBvZiAoJ3N0cmluZycsICdib29sZWFu
JywNCj4+ICsjICAgICAnbnVtYmVyJykuDQo+PiArIw0KPj4gKyMgQHN1cHBvcnRlZC12YWx1ZXM6
IHRoZSBzZXQgb2YgdmFsdWVzIHRoZSBob3N0IGhhcmR3YXJlIHN1cHBvcnRzDQo+PiArIyAgICAg
Zm9yIHRoZSBwcm9wZXJ0eSwgYSBsaXN0IG9mIHN0cmluZ3MuDQo+PiArIw0KPj4gKyMgQGNvbXBv
c2l0ZTogbmFtZSBvZiB0aGUgZW5jYXBzdWxhdGluZyBjb21wb3NpdGUgcHJvcGVydHkgaWYgYW55
Lg0KPj4gKyMNCj4+ICsjIFNpbmNlOiAxMS4xDQo+PiArIyMNCj4+ICt7ICdzdHJ1Y3QnOiAnQ3B1
UHJvcEluZm8nLA0KPj4gKyAgJ2RhdGEnOiB7ICduYW1lJzogJ3N0cicsDQo+PiArICAgICAgICAg
ICAgJ3R5cGUnOiAnc3RyJywNCj4gDQo+IFRoaXMgc2hvdWxkIGJlIGFuIGVudW1lcmF0ZWQgdHlw
ZSwgbm90IGEgc3RyaW5nLg0KPiANCj4+ICsgICAgICAgICAgICAnc3VwcG9ydGVkLXZhbHVlcyc6
ICdhbnknLA0KPiANCj4gSWYgdGhlc2UgdmFsdWVzIHZhcnkgYmFzZWQgb24gQHR5cGUsIHRoZW4g
dGhpcyBzaG91bGQNCj4gYmUgYSBkaXNjcmltaW5hdGVkIHVuaW9uLg0KPiANCj4+ICsgICAgICAg
ICAgICAnKmNvbXBvc2l0ZSc6ICdzdHInIH0gfQ0KPj4gKw0KPiANCg0KQWNrIHRvIGFsbCENCg0K
V2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KPiBXaXRoIHJlZ2FyZHMsDQo+IERhbmllbA0KPiAtLSAN
Cj4gfDogaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNB
X19iZXJyYW5nZS5jb20mZD1Ed0lCYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9UEdXTXlp
Z25BME5pRG1UbHlQN3ZPVEhvekJ3c19WTjg2eXJWbVNNa0JwMCZtPUZYaEMzcDBxVzhOM2NJWUJa
RmRHOXBGOFFmUXpsMjFDUWVjSnpkM0xtTnoxS3JQQ24ycGNrdVVFNEJFZjltQUwmcz1PTHBGX1VZ
VmtMMWJINzFQV0luRXM5anFDa29TRkhVdmtBZGE2emxleXZ3JmU9ICAgICAgICB+fiAgICAgICAg
aHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19oYWNo
eWRlcm0uaW9fLTQwYmVycmFuZ2UmZD1Ed0lCYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9
UEdXTXlpZ25BME5pRG1UbHlQN3ZPVEhvekJ3c19WTjg2eXJWbVNNa0JwMCZtPUZYaEMzcDBxVzhO
M2NJWUJaRmRHOXBGOFFmUXpsMjFDUWVjSnpkM0xtTnoxS3JQQ24ycGNrdVVFNEJFZjltQUwmcz0w
a3RPdy1sMmprWFp6UkJTYzVfWkVIcXQ4UjNvc0VzX0pBcWFfSXF2bFF3JmU9ICA6fA0KPiB8OiBo
dHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xpYnZp
cnQub3JnJmQ9RHdJQmFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPVBHV015aWduQTBOaURt
VGx5UDd2T1RIb3pCd3NfVk44NnlyVm1TTWtCcDAmbT1GWGhDM3AwcVc4TjNjSVlCWkZkRzlwRjhR
ZlF6bDIxQ1FlY0p6ZDNMbU56MUtyUENuMnBja3VVRTRCRWY5bUFMJnM9V0o0bnRTZGFfTklBSS1o
WlE5ZTNnNU53a1ZsSjJ6d21RU2JBQW1MOVJHRSZlPSAgICAgICAgICAgfn4gICAgICAgICAgaHR0
cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19lbnRhbmds
ZS0yRHBob3RvLm9yZyZkPUR3SUJhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1QR1dNeWln
bkEwTmlEbVRseVA3dk9USG96QndzX1ZOODZ5clZtU01rQnAwJm09RlhoQzNwMHFXOE4zY0lZQlpG
ZEc5cEY4UWZRemwyMUNRZWNKemQzTG1OejFLclBDbjJwY2t1VUU0QkVmOW1BTCZzPVpDX0dqWE9v
OFdOZ3FoRm85U202Vm5qZWdFanpDbE1ybllNUUxiMmRFbU0mZT0gIDp8DQo+IHw6IGh0dHBzOi8v
dXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGl4ZWxmZWQuYXJ0
X2JlcnJhbmdlJmQ9RHdJQmFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPVBHV015aWduQTBO
aURtVGx5UDd2T1RIb3pCd3NfVk44NnlyVm1TTWtCcDAmbT1GWGhDM3AwcVc4TjNjSVlCWkZkRzlw
RjhRZlF6bDIxQ1FlY0p6ZDNMbU56MUtyUENuMnBja3VVRTRCRWY5bUFMJnM9VUliZEZpZVRBREhz
bUF0TFl1eVB1RlFRSFh5MXBRUjZmajItWUU3cGdVWSZlPSAgICB+fiAgICBodHRwczovL3VybGRl
ZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2ZzdG9wMTM4LmJlcnJhbmdl
LmNvbSZkPUR3SUJhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1QR1dNeWlnbkEwTmlEbVRs
eVA3dk9USG96QndzX1ZOODZ5clZtU01rQnAwJm09RlhoQzNwMHFXOE4zY0lZQlpGZEc5cEY4UWZR
emwyMUNRZWNKemQzTG1OejFLclBDbjJwY2t1VUU0QkVmOW1BTCZzPWhQcXkyT0Y5aFlSdlFpbDhi
bFMxeEhrRUxUbC04eHZncXVOUFlhb3BhNG8mZT0gIDp8DQoNCg0K
