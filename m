Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1764624CEEA
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895012; cv=fail; b=KqTngCa+pdhMGPrMBbyy37f17A4wrGV0x2ZRcZX6wCNeeAy3ac+fjVag8NKtrg5qF8EltOkqEx/Fz0sFq+xHbb8r1tYt0pnPs4OZbPXlKmz4bZ7g5dN4X6beXd0CmZEj8/WEMUI+YLPamZIpEa2toAxWuw+V+uN6cu12wM8xiNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895012; c=relaxed/simple;
	bh=wcLC9SfoksMyCVR8a3yqT7FAv8F4PMgpWBlDcFUp1V4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cfuG/GBsefmsG9Fg6OuM0EwC+B4BE7my/oHHdDX9jXwn4gYnPyrocpUIjtMBWOWFLBF6WtfRk+4E861w2zfrnN6u72Z4Ifca+I4CUjp+/ZT60jg8pf7JteeynUFE1YJuv6T6Ut5tm5wRx5o06Uw9adEj7DmfEGIYUjzptKzN5MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Txfq9Tj1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fvPVa4E5; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Txfq9Tj1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fvPVa4E5"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCrqjQ2685127;
	Wed, 27 May 2026 08:16:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=wcLC9SfoksMyCVR8a3yqT7FAv8F4PMgpWBlDcFUp1
	V4=; b=Txfq9Tj1qrE5lurIAK6VeS3zhcBoMYJC9JeHBLyuVsDQAv4E6q4IF+PYS
	ORh483drE7YKkMtyq1mBepkLnuH5ToQCn7THrlRpOaZt/NsPrS8P17rCTzQJsJGL
	Ebyh1tpVv5eOn2kDRn5K4xjDWk5GNzAAyJNoBQFyZNPMKNZQ8aB+I44iuHgYp+Jj
	hjpRxkD83fKOvZMgBE/dKM1yyxEQjzMQ6WwDMhf1KpxQSEc43KIGECJswg4AbS48
	3RUx/jfQN73KW2ubgec/29zfeXvMyRW4SskFnylub7HSAfywk1Jy11H6P4x5g0ut
	H1tgXYpiT3+gKebHj3Rytpul0ppxA==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022117.outbound.protection.outlook.com [40.107.200.117])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4edg2a2n46-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CU9eyDFdW5NpDDwIjFTo/EBOrAVKVNxDebIXBPB3tnGYayEKDoJ/Ja+F56ZyzoDkrA2MNoyUyP1uz+IBBDk1XtCsg0hSYuLP1dLbQKRzS5cw7hOwMjpYwSYc083kdGah3vx9t62/bRY5nmxFQVYM2YY+Kzeoro49IGJz1QzpjGU170pATzX3OLUsHlnr10S0TJAHq8bPT7dTzH91rJZlb/G6Fxnn40Elk9s7nnjLNb/YnRenwtn1pu9YoejQSQxAM1zdZnzRkXcUKNI5ZBYVyEOjKkmnKN+yQEh/oS0FcIeNMKfuJ0hAOrImVkmhX9iChSqSizO/bMr+NXtFxAFiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcLC9SfoksMyCVR8a3yqT7FAv8F4PMgpWBlDcFUp1V4=;
 b=EoWiNzyGWEJ0i+tWKDd36qGXJFn+HXDQuaPFz6PV6S7KUiCZv0jX4SKTN0wyeH/fv0oHsg/U1kOWk1tjj/WUiHPJcmZiZr9Mp7iqLXF9lQN1Tqcf/yBEiR/3DISjaqyntbj42Cjo9M6iXwzh41bHPKWsPdSaveMrsdljcC6jhEpTbjUGxmpsMuekFfQIJ5AQllLCQz6YNgS/MmYvjibtsIhw0uocbVAL3m+1v4ZZsA2dk64p/oQrF0M8mvF+kOwyLmdMxOObf5BIZAgm0ZDz3PXR4DQNGz9DwhPXolFD3prgFFc2XkwzC16tbpHZpgAEEG+K+36Oz3VglqQDseBwDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcLC9SfoksMyCVR8a3yqT7FAv8F4PMgpWBlDcFUp1V4=;
 b=fvPVa4E5m4Hm9IkQ0mAhw8RvUwhSzNvqKlF9mr6QmcdJmGF2NLHJ4H9ekkK3bOyKDEQSh7ULACLLhBN6/xOZSvssnxiWmwBeVm3zP+2u0dXlHtui3PCIIbuiPunwyB2MS+JDJBxpNnhU7nt7pxbkaXapO00L71O9hIu420+P2HnPKfbHNV8ObK2r6qToXf2O4nh9S/gnhxXMm2xjkvVw6h47pIPJUnDgBdZ7BnU0R6trfcosDqhx9maeug+HLbxFMXZ/N8tbFArsvuBkU+hu7X9JBI+o3pWmcXhQRY4BO7pdA6kWPttM8uKYho8W6aWaXVskAg0JxYuqsUBpR0vU5w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV2PR02MB11105.namprd02.prod.outlook.com (2603:10b6:408:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Wed, 27 May
 2026 15:16:19 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:16:19 +0000
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
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Topic: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Index: AQHc55PDWfKVatqEQkCeq1pFPAd4RbYiCFaA
Date: Wed, 27 May 2026 15:16:19 +0000
Message-ID: <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-17-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV2PR02MB11105:EE_
x-ms-office365-filtering-correlation-id: d8e22581-c29e-46a2-1f55-08debc02e7cb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|6133799003|4143699003|3023799007|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 IxJaXtLdlwjjDqSshO/gFERMPefYm1HjugMSk1oI+frvHPuUsNxDGjTCs+X7bGBzts/KZaR93iVEnyniIuN3wHqqwZBIzdUnLGnBtxHLMUvEdoOs4gw6wgHDRxzDuZr5Uu9RA9uLIUgjrpBTprZ7rxOw6YH7h7p1/SX68fcXS76qbSoUH2cvlyO4w0kz+mWoC20UM6w+bXtaEWfx6oZ45NzpuEL04K3MrX5Xf9iZsXPp7PT095OgIdT3taCWvBcJbh7CYTMKKlqFeOP7ijnRmH/l0qICseCpBm+fDOFb4jNHRYxA29b0fwWEJUBfxT2WV5bQaz+/4J0o4yD0JWd3WbyqtLIw2VStnGD11pr4NYkaqL3Qsv2qjVv2mKDFvAe9ULoEjw/5NbSHgrtOFXrjOM/dnTbKZfBg0vihylrreo23QTpLIXEiBsrkii1BBxGY2WgIjMkkQSpCp2UO38xyKqO5Yih2rY7jJ9S/ba0BpxupT1bl1P+3S1gpZllh7tBI8fMLsgGh8iCumMamaQtjdf2CqzBAG2pc/XtSgeR6pGv/KWTmIQqkyt1JqaCMcLBOR0aqb/OSXBka5yTDxIChVUXTmDZiGOfreDRZsfBr2K3GGHzKXoi+6/75gK2qeqjxsux1POLU+zNtOpy8gP/YbrbXxSgBSwBrs3yK+c94TtSfD2Iy5knl5NsRG7zgCQpP/OMkU8W7punbuKE5QnIEUpFkyVcKoDYP0K6XG5/vO3PR/DstJW7LmGKYiz+l1WpW
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(6133799003)(4143699003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aG5wNFF2VEV0M2VhSEkyN0xreXlhb3phc3VDSW5QcGZJblFza20xVEF4bGNo?=
 =?utf-8?B?MDNrQVd3WEtINDJyeGg5MFFSN2dkL0F3ajgzVjlsSkEvN3Z4Ry9QVDU0ejlI?=
 =?utf-8?B?a1hQN1VxQlN4KzJ1YU5GY2F4cE9iWFRPY3J4cUIwNVZaWG1kZVdvci9aMWg2?=
 =?utf-8?B?eXBVSi9qVHRNSi9yeHpYNUhoY014YXZJb005K1N5L2xwbGZpOXprRDNrMERT?=
 =?utf-8?B?RHp3elR4UXB5ZXdWZy8yUU5JTkdTZGQ0YmZKalg3VUl4TEV2Yjg1alpWa3hv?=
 =?utf-8?B?UXVDM0xidEt3eFNwSFhsRHdMOFdNV0cyYnljVlE4YVZxYXdtVk0rY1EwRmxk?=
 =?utf-8?B?c1BRRm12N0pQYzNTRGFWRUh6QklIRHFOQXAwT1dsUnJUTHJaaUxYVzNLTTA4?=
 =?utf-8?B?ZFN5UkNLbUk0RmRNU1NvUTl0TWZUSUFIaVlya01zRE1NamZWOWdiaUpsZm5x?=
 =?utf-8?B?bFRCWlpPcGdMam1RYzRkQWhkMFZRdzZ1dVpxbWQ0eUp2VWl2MFoxWnZIdDRt?=
 =?utf-8?B?MkU5S05ubHZweFkvcVY5QXZZOXhSZlliRE1VQ0ZmMnlmRlN0YnBVam5uNEx3?=
 =?utf-8?B?bE9lRlQycGc5b0tDa05jVDlwQVpsMk5zWldEK3lDMHpKOWxLRFFGWHdjWi9j?=
 =?utf-8?B?SUhUdFpKMERrTXJpZ09tb0gwR2RaWTFOSTVuc0dxZlJmdTBaaFhONkpkQUdF?=
 =?utf-8?B?Q2tlYkZ4enVZUnhrZnFOeWMxbXpPTktzUkFuVEVNS2VkMjlkc2UxREZheUtP?=
 =?utf-8?B?b2RPUEFWM1JLc2pqc2VreVYxdXpjekE5ZUlFMW5xeHI2L0gvR3BMUDJrVmcx?=
 =?utf-8?B?ZUpkN1o0TUwxbTg0UGhzOU13ZGovQmdicjBtS20vbTdEdUFCa1dvYlh0Q0lN?=
 =?utf-8?B?S25PbGZzY3Naa0w5Zy9FcEJpUzUrZmdWcG1mYTVreHZxVVl4bDVFQlZQOTRo?=
 =?utf-8?B?WjY5V29BVHVmV0RQYVpYQmtwb09uVk1IS2hHM2tLWVY0WHk4Sktwc1Vtb093?=
 =?utf-8?B?K0hwaEV6SzlUaXl4cGl1WDllL0FsQ3pjTXZvZGxlbk5KRFNlYm4zc2F4RVdv?=
 =?utf-8?B?QXJ0MnBQWHhwRzMvLzNsSXNvcjhyQldOZFIyRWtGUGVKdGRxNEhaY2J0YjMw?=
 =?utf-8?B?MHBIamQ4OU05cnQ3V1ZBR0dQZzBZL1hBeUc1V1Z4UCtaeVBLSnVGU2lVdUth?=
 =?utf-8?B?MTdYTXNXOWZKaWNPZWVGTjJDSGNCYURDN2Z2eXFWU0UxWW56aWd5RFBzcTZT?=
 =?utf-8?B?L2VhVWd2SjQvUG94ekplYW1yZk1nekhxNEEvZDdDVnRzQS9VNjRjSTVGNUVs?=
 =?utf-8?B?aDd1bW55Z1pxZEVvcStMNzcyNzhjQ2toWGlRWXFoeWdEOVBXNkt1b3JndTRu?=
 =?utf-8?B?R2t4RmNxcUVmVlgzcVlaYUVnSzc1c2pWN0F5cFJJdDh1SEFCSlFKQjJxZ1JY?=
 =?utf-8?B?NjFUOGRLTUgzUlQ0Q21Kc1VYcC9XUUdUT0hGZXdCdE5rMXFiQUNWbkZ0QitK?=
 =?utf-8?B?UGRvUG1iWTBZeVJ1MHhTQW5lMzRXNHVKS0tuQTdKOWN2VVNoUHdLYW9ZWHRX?=
 =?utf-8?B?cTdUUWVscGlQQ1o1bzl4MWNyODR6Nk9nWXhmbU45NzRtN2cwTXU2WXZNakdV?=
 =?utf-8?B?ZUFadUlwZmF2K0dmMmZDM3FNYXNBVUdOSlZ0V2pSVkIxUjFsbktJTUZxRmNo?=
 =?utf-8?B?dGc0SDVSQ2ZqRnd4T2RhaStGckNQc3NTeG9WZGQ3eUhHMm5hV1YwRmxnNHQx?=
 =?utf-8?B?eVQ4R2V6ZGM2a1RSTENBTWRaNUpNTXF5QW5LZmpjcW5oc1M5a05KWmk3TVla?=
 =?utf-8?B?N1lRTEpkRkxwYTdEQm9GZHJhWElhSGhXb2tKT0oyVjV5bVJIOW5QS0NSbkRa?=
 =?utf-8?B?OFpsYUZJQXlFOXRHMnF1Z1Z3aXpRMDRNTlY1aW9xUlNQZjd2NUZ1anlWK1Rm?=
 =?utf-8?B?T3hmWFQwbVFyS1F4N3ZQcWY5VGt5aVhFWExHWXVIVWFYQStpcWZ0djhmbWs0?=
 =?utf-8?B?cUlLeURBQmdZZ0NEMnNGcTh6SVo1eWRwZGFiNWhiSFlxdE5wV1Ird1BJSFhn?=
 =?utf-8?B?UE9jRTU2MVhFNDNvMVpyb21mOFlZY2JHZzJRTEJOejlkRTl2OTlKN1ZoWlE4?=
 =?utf-8?B?SHJFWWk0c0lGcHpkSWZXZjFwdUNrQXIrb3dsVk9ISXZBMzVzbkdTN3pEM0ww?=
 =?utf-8?B?bktpZC81V3dtOG5XUUFyNkhSeHhwUUtBd1JZd1ZGdlA2KzZvaENuNXgzTUY0?=
 =?utf-8?B?NFZadEpxaXZONEMzNDZ2Nm9sODFZbm5MTnduTDhMT1krWGJYLzFqTG5xRFJD?=
 =?utf-8?B?OS9NeldneEtjTk1VR1lwSElkQ2l2L1RBWmI0bjBidFhmbkFnOE9ockpHSzQz?=
 =?utf-8?Q?eAM4zzEQIWkFQBu0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90AB60A26C96D4EA51FC218EBAE749A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	bmteerHXlywUqi4h4n7Nn5qJI8bVzpMpTj6J/S8jhPCLv+1DjAn2ukJfxYzFaj68DzfT9qIGJyxGk25oltIDbfhW5vkRPdpljGtPlwBYfZMIZfje3EQs8i3DJMWWEHWF7n2oQBG24TiJF+0iSd3MLgeWvoAQXMP9XOqHodbli7GG7Beh+80ejw43hAXMni+qF0KtoqxKDJ32erdLigWhO/6tsGPhl5BV3DfGj1AwlWjIWDLYp1pxFF5ONGSEj98XtxJ4hzpPmKqSc2hsUfXsIMwcSDbcBaesELqGvjQTKirmG/PuhmCo2yD3ZktEgbS8Z/NUK0zYn1LLWb+aqACfXw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e22581-c29e-46a2-1f55-08debc02e7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:16:19.7791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E62ZKFcYQuC+x8taOLFpOu/8XkdK9+JRMJw3IFFSBPOQ86wuG3oUerXa9kX2oyeu/rHgj/z2UI/QK1F1OelmjikIZqGL+CK2zEsdXGAZDDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR02MB11105
X-Proofpoint-ORIG-GUID: u_1pqmKVD0xeezCm_OzqRK_EMF1l3QNH
X-Authority-Analysis: v=2.4 cv=fr7sol4f c=1 sm=1 tr=0 ts=6a170ac7 cx=c_pps
 a=P+x04lzWRrkL6x5keHLAXQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=lLklAzh9S37aI58xW9QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1MCBTYWx0ZWRfX2Iucn/uzulPW
 t5x6y4E2sPBVMVYg6J8+b2E4v5t9V85ETwNVms7nB6UJSkJqe7r2UhRdGf9h4IAhGW/QbJJlPqZ
 VV31rz5ThOCB8yIsI2MM+geg2/Pq/lW2UVHnGRq5og1qVbLztN6NAdA/lb866iHDQU2ZupHmavw
 r5zUgTXDSk1ENPo/EviCqLMpdkvBnmN1gToAI29Yck0S/m53Sh7U1OLVzPxP7qXJwldk9lP+Hgw
 R2myWF9b0/50KGF7Xd4WndBM8gKy7E4ET874VzHbxlgLk/FH5kl9/pYebOr5EDBOQzbxYTmkAuz
 JUOBeCxRSBavPVCuiLcTrI139nWbTY4eWhNY6XEtpalgzZ5zdB9uzpeTjqm6kFlIElxRdPLelfP
 rFTNsdEiH1e8JseAxNNJPyknc+eGAnZ93cx7wVEvyNYFf2YWUEplL2VuTGj7tHW1vNgqs7sU1rp
 90i6ytorBzdrPZ8m64A==
X-Proofpoint-GUID: u_1pqmKVD0xeezCm_OzqRK_EMF1l3QNH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSWYgdGhlIGhvc3Qgc3VwcG9y
dHMgS1ZNX0NBUF9BUk1fU1VQUE9SVEVEX1JFR19NQVNLX1JBTkdFUyBhbmQNCj4gS1ZNX0FSTV9H
RVRfUkVHX1dSSVRBQkxFX01BU0tTIGlvY3RsIHN1Y2Nlc3NmdWxseSByZXRyaWV2ZWQgdGhlIG1h
c2sNCj4gb2Ygd3JpdGFibGUgZmllbGRzIGZvciBhbGwgSUQgcmVncywgZXhwb3NlIHVpbnQ2NCBT
WVNSRUcgcHJvcGVydGllcw0KPiBmb3IgYWxsIHRoZSB3cml0YWJsZSBJRCByZWcgZmllbGRzIGV4
cG9zZWQgYnkgdGhlIGhvc3Qga2VybmVsIHdoaWNoDQo+IGNhbiBiZSBtYXRjaGVkIGluIHRhcmdl
dC9hcm0vY3B1LWlkcmVncy5oLmluYy4NCj4gDQo+IFByb3BlcnRpZXMgYXJlIG5hbWVkICBTWVNS
RUdfPFJFRz5fPEZJRUxEPiB3aXRoIFJFRyBhbmQgRklFTEQNCj4gYmVpbmcgdGhvc2UgdXNlZCBB
UkNITVJTIFJlZ2lzdGVycy5qc29uLg0KPiANCj4gV2hlbiBzdWNoIHByb3BlcnRpZXMgYXJlIHNl
dCwgdGhleSBvdmVycmlkZSB0aGUgZGVmYXVsdCBmaWVsZCB2YWx1ZQ0KPiByZXRyaWV2ZWQgZnJv
bSB0aGUgaG9zdCBhbmQgcmVpbmplY3RlZCBpbnRvIEtWTS4gVGhlbiB0aGUgYWN0dWFsIHZhbHVl
DQo+IGJlaW5nIGFwcGxpZWQgYXQgS1ZNIGRlcGVuZHMgb24gdGhlIHJlZ2lzdGVyLCBpZS4gaXQg
Y2FuIGJlIHNhbml0aXplZC4NCj4gSW4gY2FzZSB0aGUgZmllbGQgdmFsdWUgaXMgcmVqZWN0ZWQg
YnkgS1ZNLCB0aGUgdnBjdSBpbml0IGZhaWxzLg0KPiANCj4gQW55d2F5IHRoZXJlIGlzIGEgZmly
c3QgYXR0ZW1wdCB0byB3cml0ZSBiYWNrIHRoaXMgdmFsdWUgaW50byBLVk0uDQo+IA0KPiBUaGVu
IGxlZ2FjeSBDUFUgb3B0aW9ucyAodmlydHVhbGl6YXRpb24sIHNlY3VyZSwgLi4uKSBjYW4gc3Rp
bGwNCj4gb3ZlcnJpZGUgdGhlIHByZXZpb3VzIHZhbHVlLiBTbyBsb3cgbGV2ZWwgSURSRUcgZmll
bGQgcHJvcGVydGllcw0KPiBhcHBseSBiZWZvcmUgdGhlIGxlZ2FjeSBvbmVzLg0KDQpObyBjb2Rl
IHRvIGhhbmRsZSB0aGlzIHJpZ2h0IG5vdyByaWdodD8gQW55d2F5IEkganVzdCB0aGluayBwYXJz
ZSB0aGUNCnByb3BzIGluIG9yZGVyIHRoZXkgYXJlIHNwZWNpZmllZCBpbiBjb21tYW5kIGxpbmUu
IA0KDQpxbXAgY3B1LW1vZGVsLWV4cGFuc2lvbiBpcyBhIHdlaXJkIGNhc2UsIGl0IGRlZmluZXMg
YW4gb3JkZXIgaW4gd2hpY2gNCnByb3BzIGFyZSBwcm9jZXNzZWQuDQoNCj4gQW4gZXhhbXBsZSBv
ZiBpbnZvY2F0aW9uIGlzOg0KPiAtY3B1IGhvc3QsU1lTUkVHX0lEX0FBNjRNTUZSMF9FTDFfRUNW
PTB4MA0KPiB3aGljaCBzZXRzIEVDViBmaWVsZCBvZiBJRF9BQTY0TU1GUjBfRUwxIHRvIDAgKGVu
aGFuY2VkIGNvdW50ZXINCj4gdmlydHVhbGl6YXRpb24pLg0KDQo+IFNpZ25lZC1vZmYtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ29ybmVs
aWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IA0KPiAtLS0NCj4gdjQgLT4gdjU6DQo+IC0g
Z2V0IHJpZCBvZiByZXQgbG9jYWwgdmFyaWFibGUsIGR5bmFtaWNhbGx5IGFsbG9jYXRlIGFuZCBm
cmVlIHdyaXRhYmxlX21hcA0KPiAgaGVyZQ0KPiAtLS0NCj4gdGFyZ2V0L2FybS9jcHU2NC5jIHwg
MTEgKysrKysrKystLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdTY0LmMgYi90YXJnZXQv
YXJtL2NwdTY0LmMNCj4gaW5kZXggZjJlZGJmYzQzNy4uZTBlMWZmNmNmYiAxMDA2NDQNCj4gLS0t
IGEvdGFyZ2V0L2FybS9jcHU2NC5jDQo+ICsrKyBiL3RhcmdldC9hcm0vY3B1NjQuYw0KPiBAQCAt
MzcsNiArMzcsNyBAQA0KPiAjaW5jbHVkZSAiaHcvY29yZS9xZGV2LXByb3BlcnRpZXMuaCINCj4g
I2luY2x1ZGUgImludGVybmFscy5oIg0KPiAjaW5jbHVkZSAiY3B1LWZlYXR1cmVzLmgiDQo+ICsj
aW5jbHVkZSAiY3B1LWlkcmVncy5oIg0KPiANCj4gLyogY29udmVydCBiZXR3ZWVuIDxyZWdpc3Rl
cj5fSURYIGFuZCBTWVNfPHJlZ2lzdGVyPiAqLw0KPiAjZGVmaW5lIERFRihOQU1FLCBPUDAsIE9Q
MSwgQ1JOLCBDUk0sIE9QMikgICAgICBcDQo+IEBAIC04NTEsNyArODUyLDYgQEAgc3RhdGljIHZv
aWQga3ZtX2FybV9zZXRfY3ByZWdfbWlnX3RvbGVyYW5jZXMoQVJNQ1BVICpjcHUpDQo+IHN0YXRp
YyB2b2lkIGFhcmNoNjRfaG9zdF9pbml0Zm4oT2JqZWN0ICpvYmopDQo+IHsNCj4gICAgIEFSTUNQ
VSAqY3B1ID0gQVJNX0NQVShvYmopOw0KPiAtICAgIGludCByZXQ7DQo+IA0KPiAjaWYgZGVmaW5l
ZChDT05GSUdfTklUUk8pDQo+ICAgICBpZiAobml0cm9fZW5hYmxlZCgpKSB7DQo+IEBAIC04NjUs
MTMgKzg2NSwxOCBAQCBzdGF0aWMgdm9pZCBhYXJjaDY0X2hvc3RfaW5pdGZuKE9iamVjdCAqb2Jq
KQ0KPiANCj4gICAgIGNwdS0+d3JpdGFibGVfbWFwID0gZ19uZXcodWludDY0X3QsIEtWTV9BUk1f
RkVBVFVSRV9JRF9SQU5HRV9TSVpFKTsNCj4gDQo+IC0gICAgcmV0ID0ga3ZtX2FybV9nZXRfd3Jp
dGFibGVfaWRfcmVncyhjcHUtPndyaXRhYmxlX21hcCk7DQo+IC0gICAgaWYgKHJldCkgew0KPiAr
ICAgIGlmIChrdm1fYXJtX2dldF93cml0YWJsZV9pZF9yZWdzKGNwdS0+d3JpdGFibGVfbWFwKSkg
ew0KPiAgICAgICAgIGdfZnJlZShjcHUtPndyaXRhYmxlX21hcCk7DQo+ICAgICAgICAgY3B1LT53
cml0YWJsZV9tYXAgPSBOVUxMOw0KPiAgICAgfQ0KPiAgICAga3ZtX2FybV9zZXRfY3B1X2ZlYXR1
cmVzX2Zyb21faG9zdChjcHUpOw0KPiAgICAgYWFyY2g2NF9hZGRfc3ZlX3Byb3BlcnRpZXMob2Jq
KTsNCj4gKw0KPiArICAgIGlmIChjcHUtPndyaXRhYmxlX21hcCkgew0KPiArICAgICAgICAvKiBn
ZW5lcmF0ZSBTWVNSRUcgcHJvcGVydGllcyBhY2NvcmRpbmcgdG8gd3JpdGFibGUgbWFza3MgKi8N
Cj4gKyAgICAgICAga3ZtX2FybV9leHBvc2VfaWRyZWdfcHJvcGVydGllcyhjcHUsIGFybTY0X2lk
X3JlZ3MpOw0KPiArICAgIH0NCj4gKw0KPiAjZWxpZiBkZWZpbmVkKENPTkZJR19IVkYpDQo+ICAg
ICBodmZfYXJtX3NldF9jcHVfZmVhdHVyZXNfZnJvbV9ob3N0KGNwdSk7DQo+ICNlbGlmIGRlZmlu
ZWQoQ09ORklHX1dIUFgpDQo+IC0tIA0KPiAyLjUzLjANCj4gDQoNCldhcm0gUmVnYXJkcywNCkto
dXNoaXQNCg0K
