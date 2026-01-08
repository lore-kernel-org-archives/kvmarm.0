Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011015.outbound.protection.outlook.com [40.107.74.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9493D7D13
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866805; cv=fail; b=V66Q7VzaJgvLpkYj4qnybQkPXvEq7c9l+2xmP0bNJdzqpT+nCes38nSSzQ9TnTh2SQe1Ht0+ob4R6Bbd1tOc7UJybx8rbwBoSCeS6kj1IJdQLyLuys0judFkFfYlsIKzT3ZOmE2MuOwZF81jeMD8S587UXSAr0cWSagxpMZIFtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866805; c=relaxed/simple;
	bh=RW5Pe0XOUXwZcw40S3yh9eNqw2VoRLaW/rSoQklnohk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bRwjdpB4EcrhGZcWERxmMzQomb8W5t3KMLrwmH0aG9ILp6jUCKY6gTMVDmPrqI8eGdAMjBu3R0z78p0ov2u7bK6gN/erWB6OqI+Fy9ly5S8Tx0YRG9ofVa1+kOPH6bQBF+QprNOgVCv+PXh3GS5bunAoXqF3+W763dwCgyVku2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=LL9TOOrn; arc=fail smtp.client-ip=40.107.74.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="LL9TOOrn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrDM6k7QfeS8fQkLN0MUvhP/EuiQuyNxd8Tu/rhYAULnYpLxGOZiv/oTa2naPj0OVAJgrhhum6lQnp7pqdYTCHM2B5bhqZZFhUCelWxIKA5qM6/iVXQ7nb7wrZn2x0YUUi+qqQQg5XxbTRlFqVmzEUnQCyd7xyIlYO0NrsG5WvLjCv8MvowYUOXWFIY7Q4Nb3JkPPzlTrICFSdv/xQ7x+pkVd7bUfyz0tk9IPpea0fSeaYJgg04QD9fBzxPDWdcf13aUdpMr/CbGE8NWNXDJApC3vg3GVtSGQWL3v1vQR5m7e+zC/wct4dKFtDnGZakgwjbH9Z+9nv8wtskIbrvAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhmuWdDldKpEkZuj+IIlPPNYhgUUy6WffEQ6u3PXw0o=;
 b=a5In+TX+KakDj2WEK9YsjlLTK5P4pr2eKJ8RjEtyXpYqX0A0As5vCWjtSnKVSm7cxKlx3CKhxm33ccbc/S0ZmIj5lnKS8omcq69vxUUD0j/pzZ5uUvhwU3wBc41mN89wxMsBuX5ihxEfIHNCnvYivqLu5dkMlJh98oDKfpddazGhDWxTnQ+Ay/eoU0KYZXmK9th8Op7bx3IVWa2DcZdmpVjfuxF/plYA+u8Z7wlaSDk1Na5RcoR/AA5HnwClsr/oO4at4RbF5SwXa+Mjdbvt5XB1b2WRqznXu8XtyN1E8GApN/rOcX5s8JfyEQqF7SXiBbiNsRjlV23jDWQbT6/r2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhmuWdDldKpEkZuj+IIlPPNYhgUUy6WffEQ6u3PXw0o=;
 b=LL9TOOrnLz4R0GC0xyj9FqL8dQ4Uky+ycHLUWYSBA58dPgwgy3jN38hPmXRBDksKDwlqa5QJN1122TlbTdWacgaJku2aAEkokagtMv9brwNhKCYPmYJGbO11+eKMsNx58jA108BuIkYeUvYDRFVlks10mBllfpEgj2k2wUe4ffRmTnksQbbsdOjZdOVKZFfTOM+Rmb41EKiebdHAMQFQ3WxsM4ZeURRrENSZ1+gsCpzm96Rd7ybC5gAivs96ShnfNq45r9Qe0PL2LwjviHwKEZWJ/2HXsblcVGAfO98vMWMapjkhIyWfiHN82TE5zIaTHxpIuDq6CHIFNIQCj17GXA==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by OSCPR01MB13198.jpnprd01.prod.outlook.com (2603:1096:604:350::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Thu, 8 Jan
 2026 10:06:33 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%6]) with mapi id 15.20.9520.001; Thu, 8 Jan 2026
 10:06:33 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 07/45] arm64: mpam: Context switch the MPAM registers
Thread-Topic: [PATCH v2 07/45] arm64: mpam: Context switch the MPAM registers
Thread-Index: AQHccRMRYC92ZSxNGkuKLdWYe8Oqx7VIKps5
Date: Thu, 8 Jan 2026 10:06:33 +0000
Message-ID:
 <OSZPR01MB87987088A6A033D03458AD188B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-8-ben.horgan@arm.com>
In-Reply-To: <20251219181147.3404071-8-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-08T10:06:33.298Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|OSCPR01MB13198:EE_
x-ms-office365-filtering-correlation-id: 092ad6a0-d20b-403e-7d7b-08de4e9d9a2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?dFFxTzhHUUFUSm9BSm5yM241QTJNUWlSMnhVUkV4Y3dDQlJwNnNjd3Q5?=
 =?iso-2022-jp?B?UmJ5d2VLd21TR2JqZElXYjlwdkpHcTNtZVVIR250T1JXb255YXV4SGZ3?=
 =?iso-2022-jp?B?eDFWcy9UeG9UQU9DamFtSFFTRSs1QXFqc0VwSVZLKytNRi9CaXhpTDFw?=
 =?iso-2022-jp?B?UGswQVRmRG9DRlJyUXlRbVdkYjJ6RkJtelIrekhDR0prc0h4V242RFUv?=
 =?iso-2022-jp?B?bC9qUHA1a2VoQ3V1cWtSTUtpVVNGSGlGeUgzTGZRL3RYdFlXYS9hbWZp?=
 =?iso-2022-jp?B?VU5SdkRJQ3JsT0dVY25VdjYvdEgvSzNSeHJOMjdJbC9uVjg4akQ3N3lz?=
 =?iso-2022-jp?B?NVl5blpSZDdhakxocnMwMXdKWVhhQzhrWnBQN2M2bmVLMW1USTRBU1R2?=
 =?iso-2022-jp?B?QnpJdHRIanBmUlo2d2xhbW9FTjVIU3QyWUExNU9BbVNOek1RVHg4a256?=
 =?iso-2022-jp?B?K1luTFlpVGFBcjZyZ3hIcUhZSmJOZ0JCeVJvVEhxSUtGL0M4M1hFc2Fi?=
 =?iso-2022-jp?B?cVd6K0NSM3NXVG9jdnV2S0kvUTZhUEwvUTJYOEFIQU9Zelh5MXBoL01u?=
 =?iso-2022-jp?B?SndyMFlwUXl6TTZVUUF1THR6LzI3MWNJRElCb0V4OGtuZmo3U1E4a1hv?=
 =?iso-2022-jp?B?YkJPc1VwOHdEaEwzTjNXcC9Rb1lKdk1HMnJza0VGRHg1K1hSYTVXNWtw?=
 =?iso-2022-jp?B?bkpYa3NSb1dlOWdxWEoyUXIxZGJYdlI5KzdpWnlSRmlGaE4wZXk1WEtv?=
 =?iso-2022-jp?B?WHlGNWo2Q2tDUTFlc3doSGFFWjBrU1ZmTkZIcG1Dd1NGbnV1ZDE0dENZ?=
 =?iso-2022-jp?B?MC9hTDNLQW9zT0pZUXk3c2RUUHB2NlAzM3dvQnlDbWNDVzJKV21TRER1?=
 =?iso-2022-jp?B?emc5MXJnblo4dktDam5Ja2taWm1RNjNmTTVQdThMV00yWCs0TWF1Uk04?=
 =?iso-2022-jp?B?M2g4NWN4dklmaldhZllVTkN1RGt0bDJZb0h1bGpCeUZnb1RnV2sydm1x?=
 =?iso-2022-jp?B?cWVBUEZqZll0aDMzQkdLS1RJMTN6dDRybitkNzZFcUVkQzYzWVdrUncx?=
 =?iso-2022-jp?B?YlJBZ1RxdVJsc2svUWNOUndBWHlLSmVvWkNsN1R1QU5INEkrMzlVRXRt?=
 =?iso-2022-jp?B?SWJPUmhXZGFKREpPRll2U0xnTXZ5ckhFMWhrbDB5eEZ6Zzl4VzE3OW9N?=
 =?iso-2022-jp?B?K1c2a2Vxckp1cWN2V1VuM0NXb2ljNkJQOVhma3ptYXhmSU5WZVpNbTVz?=
 =?iso-2022-jp?B?L1J5VGVYc2NrSTdqTE05OWlLQlp0R3RuOHJmbW1yTVhhME9RcWxXZE0v?=
 =?iso-2022-jp?B?QU4zNUY4QWJJaHA4Qys2ZFNGeEQ3OXl2SDkwQnpCNGJrbDREOWNJU0tQ?=
 =?iso-2022-jp?B?UnNudzU5NTlTaHY2V2Y2cnQ3ZlRjUnFBb3VURzY4c2JIUXF5RlF0a3ox?=
 =?iso-2022-jp?B?RFBkbWtBU1B3Si9HNVRLQnB0TlFLTkd5TzF4NXVKd2NSeDgrYUx2dkhm?=
 =?iso-2022-jp?B?cUYxaC9tSFNVMVZDYzVGZlRiQ0tVVUkxckV0VHlIUURLcFNZSTg2SThG?=
 =?iso-2022-jp?B?RDJNeVlOUnNvZnJ4MUpQVnY5Y1RkdHVYUmcvVlVHZnNSMExnWnNiOTB4?=
 =?iso-2022-jp?B?U3NBQi81RmFNT09OZG9kdjlZZGZkNlloM2w3L0gyWjBWcUFSajRyN1Nq?=
 =?iso-2022-jp?B?SlFIbjdZNEhYa1JrTDNmV1FVWUV1RmdWck1qVk9seW5Ta213UmF2THR6?=
 =?iso-2022-jp?B?QWIyNUxkVzBPWGhsQ2Nld3lucXAzM2NFY3ozbVZxb0k3OVZpT3VGTDVC?=
 =?iso-2022-jp?B?cEVsSE1PQXczZDZHQk9jVmUvQnh6TGliYzMwcEo0WlY1cDd3RW10L3M4?=
 =?iso-2022-jp?B?ZU1NTExIVkRMdEUxckxoWEIwNFRXRGlNUDNjL2hIaW5iK3NvdDQ1eUo2?=
 =?iso-2022-jp?B?T0dQVjB5VUpDRUdrcURQZVlqcHdZaWxWd1ZsMWl3bkcwR2QveWtVc0ZX?=
 =?iso-2022-jp?B?aUt4L2lXeDV2SWdFamJ1SDNGV2hxRUNWaHZEQ3NnUHdVQ2RjSkxRdGZI?=
 =?iso-2022-jp?B?VmJONGZHK0xVdElpaUN4ZmFuRGJreE1LcWxKb1dFQTV3Q09yemc5L01v?=
 =?iso-2022-jp?B?RjVMSXRyL2ZmUzdySFdDUjhET00yMDFtaDBhMzJLdmVhRFlDeEdNOVR4?=
 =?iso-2022-jp?B?dGlTTCtFLzRyNXdlYmUweWtnNU93TXNOVW9Vd3V6dFM5Qi82WGx5Wjg2?=
 =?iso-2022-jp?B?QyswUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?WSt2UnIwSGR2bmsvN0VpY3I2K3F3TnZORjlLR05RR3hodENoOC9RNzE1?=
 =?iso-2022-jp?B?UTEyRk5PSkp2SURLbHBkdU05aE0xU0U5S3EzaXBZandVdkNqUkF3cmFp?=
 =?iso-2022-jp?B?TnovWnhVZ0JhYlRseEo5WFRXWFpDc3U5VktEb1A2NWlnVzZPdGlEQXd3?=
 =?iso-2022-jp?B?OGtyM0ZJcERrZlMvMVBFbHRSMm43UEQvWExYTVRHdE9DV203R2dLZDl0?=
 =?iso-2022-jp?B?T3d2VkVjMkpEK1JQa3N1dEJITW5OLzBNNTFudXkxVmRwWjRvV2N5Q2Vq?=
 =?iso-2022-jp?B?TmRSNXpha21XK3c2bUUyWTk3VHlIWVBQNzQwMjFCWXA3aWJnWHkxaEFi?=
 =?iso-2022-jp?B?L240UlNJdmg0V0NlRVFYb2gzRXBiRlBhQktid1JVTGVMVEtrVE51UXhu?=
 =?iso-2022-jp?B?VjRHQ1cvTWxWaXE4dVBQeE8yMXFLdGM0dHRpY2JzaUl4TWZ3WllJVHRu?=
 =?iso-2022-jp?B?eTBDQ0JTbFVxMXBjQmNKQnhtSjFsQ1FCZnFKd0ErOWJTVHlGd20rUEJP?=
 =?iso-2022-jp?B?bDdYdmVGNmFWdDIzWDJWUGoxVE9XTUM4bUY5MFlWTW81Z2MzbStWbTBo?=
 =?iso-2022-jp?B?UzVHa1Y1NEs4NmpZT3pWMjhXQTJhZ3gwYlIyUGg5elJXWlpjcXl0WVdp?=
 =?iso-2022-jp?B?SXBrWU45Sy81T29xZjJaaDRHaklISEVmNFE5M0R4ZXNmOVVsbzdwSURn?=
 =?iso-2022-jp?B?bS9kTWxHY0E2cE1MV0FrcjNZK0s1TmliNU9OMEJNUEliWjd3N2tRdTZv?=
 =?iso-2022-jp?B?QllLaU1PQ1dLMHFkYkZ5T1NvMTZid1Z6dUlOKy9vMVpHelEzRTFLSmp2?=
 =?iso-2022-jp?B?bUJxdzVGYWttTWZoNXp2b1RRU1g2RG16cWxrQi9wbE5BUmI4VEpIZHVL?=
 =?iso-2022-jp?B?ZDNxQ3czb1J5WENvdHFlYklIeVVxWDF2NmhkVjZDUnJlL3lTdFRaNkJh?=
 =?iso-2022-jp?B?bFRpQ2dIcFBWSlV5MkhOY3loV0o3ZzBhNGlmNWloRVFiUjZHTlhiOGFM?=
 =?iso-2022-jp?B?OGZCQzlNTFJjN1kwdGNQYno2U3NoWFpBQzNXd1FHc3RNaXF3dFZSaURN?=
 =?iso-2022-jp?B?MmJjaVBKZzlld2grZzhESzlIdS9HZkVlZ011UDdiVVV0UlVTbDhyOWR5?=
 =?iso-2022-jp?B?enAvSUREUytnS3ViME5lbjZudXhOSDRIWUNwakZycGM0dVowWnliZXpi?=
 =?iso-2022-jp?B?V2YvSHpiL0UvMkZMN2xUMm1xTWpBY2dGVzYyZ2JBTVJ4NkkzTkJPQ1RC?=
 =?iso-2022-jp?B?d0JSOEdpb0dIV0x0K2Z5N0RJUEZzL1lTdEI3eWo4NGlBSWpqWnNQRnBT?=
 =?iso-2022-jp?B?QnVCWk1tb25iUkJ2elNST3FOLzFMbjdFMUt2UEs1OWVZQ0RBeDNwd1Jt?=
 =?iso-2022-jp?B?WnR2dHlVR2xLQUtJM1NqR01WUlFQZ0E5OVJXYTMxcktRVFM0aU9icG9n?=
 =?iso-2022-jp?B?aFdGZ2RDcllBcDdFZ3BzREJVZUV5VXR3YUJ3aHVHN0lTRzBadlJ4R09r?=
 =?iso-2022-jp?B?d3k4YmZ0WmZYajhqU25mbHJwZWVpU0IvN200cGZKK0xWMnpJU1E2VVZQ?=
 =?iso-2022-jp?B?ZUFSUGc0c0FFZEg3OFh5Tk1YRy8yWVZIWGpIMzd2Q3ZCT1ZYd242VXFv?=
 =?iso-2022-jp?B?dDNHRmZ5bTArNGUzbUswVEtVb256Q0wrMDFrdTZBaGEwR01WM1hKRzBl?=
 =?iso-2022-jp?B?ZC9WNXp2YnYwL0ZBMlhCYkc5VkRPaDlPRXBSKzE0aGFCVmpoMGRNYWNL?=
 =?iso-2022-jp?B?NUE4RUQ5ckZkV2dhL2tnMmN2RHZzQ2UrRFQwOXRVYW9VMHRtMEhsZTda?=
 =?iso-2022-jp?B?L2toallpL25MZjl6N3oxNTBLWlh5eEpDbE8vakxwcjV6N1hKb3FjSzEz?=
 =?iso-2022-jp?B?VHlJUDVXUnRsQUk0cjdoWU5TcC96MFZjKzVKWVJ4V2VUb3pVaXZYMjU0?=
 =?iso-2022-jp?B?ZHgrQ1U4cDgvT2xyUmVyTkhVUEpISEtmZC83b0tPZi9Bbi9vTTNZVzZM?=
 =?iso-2022-jp?B?TTF1UDdQZ0tTSGM0eW1WNDdpNldaZkFHZ002U2VYdGVxUmNIbmJobE9p?=
 =?iso-2022-jp?B?cHhoc2RvK0VoenZyNi9CVlBLMlJZc0Y2RW9KWDMxK3FFSHZXQ2Q2Nk9U?=
 =?iso-2022-jp?B?L1Ixa0Npcm1iaGMwaEtEamJlSEZMMWlRaXhKaGxTcVo2eHRlZGVtT3h3?=
 =?iso-2022-jp?B?bDRIT0VOOXQxNERFdzRMZXd4MGNibDZHNW96WXBWMzBxYkExcGlDQ21v?=
 =?iso-2022-jp?B?allQWURBdGt2Y3Z3aWYrYkxQTXRkUnUxRE1Bb3VVR1JjS3QyK04xQWxW?=
 =?iso-2022-jp?B?YWRWQSs2STRDZzFUUGZ3SFJCanJQckZuOWE3Y1hQMDkxS2U5WE9ZZlZB?=
 =?iso-2022-jp?B?TXRaa0picjJ3cnZnNTJ2azlZTXNoYTdvZDJiWUZDbldWVld6Y0tlYVZz?=
 =?iso-2022-jp?B?bWZ4YzgzbVg3WGtVaUFyR3FDU0RTTkdRM3FzQ3YyNjRvVnpNTXlwUkx5?=
 =?iso-2022-jp?B?TjdRZ2VhUzRVcEFVMGJ1V0srV0s3ekxPUjFRdz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092ad6a0-d20b-403e-7d7b-08de4e9d9a2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 10:06:33.6285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCKi4Ag0QJuxRWhlmMwju9MQKp7HBG4XA/Cz1nVOIIXsf5EFSPQkQvIArMAq7DGQH8GxcPXTYTkmclrG1xNqk1SpM1Lw5uxMcxYxhugdt6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB13198

Hello Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> MPAM allows traffic in the SoC to be labeled by the OS, these labels are=
=0A=
> used to apply policy in caches and bandwidth regulators, and to monitor=
=0A=
> traffic in the SoC. The label is made up of a PARTID and PMG value. The x=
86=0A=
> equivalent calls these CLOSID and RMID, but they don't map precisely.=0A=
> =0A=
> MPAM has two CPU system registers that is used to hold the PARTID and PMG=
=0A=
> values that traffic generated at each exception level will use. These can=
=0A=
> be set per-task by the resctrl file system. (resctrl is the defacto=0A=
> interface for controlling this stuff).=0A=
> =0A=
> Add a helper to switch this.=0A=
> =0A=
> struct task_struct's separate CLOSID and RMID fields are insufficient to=
=0A=
> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) a=
nd=0A=
> PMG (sort of like the RMID) separately. On x86, the rmid is an independen=
t=0A=
> number, so a race that writes a mismatched closid and rmid into hardware =
is=0A=
> benign. On arm64, the pmg bits extend the partid.=0A=
> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In=
=0A=
> this case, mismatching the values will 'dirty' a pmg value that resctrl=
=0A=
> believes is clean, and is not tracking with its 'limbo' code.=0A=
> =0A=
> To avoid this, the partid and pmg are always read and written as a pair.=
=0A=
> Instead of making struct task_struct's closid and rmid fields an=0A=
> endian-unsafe union, add the value to struct thread_info and always use=
=0A=
> READ_ONCE()/WRITE_ONCE() when accessing this field.=0A=
> =0A=
> Resctrl allows a per-cpu 'default' value to be set, this overrides the=0A=
> values when scheduling a task in the default control-group, which has=0A=
> PARTID 0. The way 'code data prioritisation' gets emulated means the=0A=
> register value for the default group needs to be a variable.=0A=
> =0A=
> The current system register value is kept in a per-cpu variable to avoid=
=0A=
> writing to the system register if the value isn't going to change.  Write=
s=0A=
> to this register may reset the hardware state for regulating bandwidth.=
=0A=
> =0A=
> Finally, there is no reason to context switch these registers unless ther=
e=0A=
> is a driver changing the values in struct task_struct. Hide the whole thi=
ng=0A=
> behind a static key. This also allows the driver to disable MPAM in=0A=
> response to errors reported by hardware. Move the existing static key to=
=0A=
> belong to the arch code, as in the future the MPAM driver may become a=0A=
> loadable module.=0A=
> =0A=
> All this should depend on whether there is an MPAM driver, hide it behind=
=0A=
> CONFIG_ARM64_MPAM.=0A=
> =0A=
> CC: Amit Singh Tomar <amitsinght@marvell.com>=0A=
> Signed-off-by: James Morse <james.morse@arm.com>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
> CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message=0A=
> Remove extra DECLARE_STATIC_KEY_FALSE=0A=
> Function name in comment, __mpam_sched_in() -> mpam_thread_switch()=0A=
> Remove unused headers=0A=
> Expand comment (Jonathan)=0A=
> ---=0A=
>  arch/arm64/Kconfig                   |  2 +=0A=
>  arch/arm64/include/asm/mpam.h        | 73 ++++++++++++++++++++++++++++=
=0A=
>  arch/arm64/include/asm/thread_info.h |  3 ++=0A=
>  arch/arm64/kernel/Makefile           |  1 +=0A=
>  arch/arm64/kernel/mpam.c             | 13 +++++=0A=
>  arch/arm64/kernel/process.c          |  7 +++=0A=
>  drivers/resctrl/mpam_devices.c       |  2 -=0A=
>  drivers/resctrl/mpam_internal.h      |  4 +-=0A=
>  8 files changed, 101 insertions(+), 4 deletions(-)=0A=
>  create mode 100644 arch/arm64/include/asm/mpam.h=0A=
>  create mode 100644 arch/arm64/kernel/mpam.c=0A=
> =0A=
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig=0A=
> index 93173f0a09c7..cdcc5b76a110 100644=0A=
> --- a/arch/arm64/Kconfig=0A=
> +++ b/arch/arm64/Kconfig=0A=
> @@ -2049,6 +2049,8 @@ config ARM64_MPAM=0A=
>  =0A=
>            MPAM is exposed to user-space via the resctrl pseudo filesyste=
m.=0A=
>  =0A=
> +         This option enables the extra context switch code.=0A=
> +=0A=
>  endmenu # "ARMv8.4 architectural features"=0A=
>  =0A=
>  menu "ARMv8.5 architectural features"=0A=
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.=
h=0A=
> new file mode 100644=0A=
> index 000000000000..2ab3dca6977c=0A=
> --- /dev/null=0A=
> +++ b/arch/arm64/include/asm/mpam.h=0A=
> @@ -0,0 +1,73 @@=0A=
> +/* SPDX-License-Identifier: GPL-2.0 */=0A=
> +/* Copyright (C) 2025 Arm Ltd. */=0A=
> +=0A=
> +#ifndef __ASM__MPAM_H=0A=
> +#define __ASM__MPAM_H=0A=
> +=0A=
> +#include <linux/jump_label.h>=0A=
> +#include <linux/percpu.h>=0A=
> +#include <linux/sched.h>=0A=
> +=0A=
> +#include <asm/sysreg.h>=0A=
> +=0A=
> +DECLARE_STATIC_KEY_FALSE(mpam_enabled);=0A=
> +DECLARE_PER_CPU(u64, arm64_mpam_default);=0A=
> +DECLARE_PER_CPU(u64, arm64_mpam_current);=0A=
> +=0A=
> +/*=0A=
> + * The value of the MPAM0_EL1 sysreg when a task is in resctrl's default=
 group.=0A=
> + * This is used by the context switch code to use the resctrl CPU proper=
ty=0A=
> + * instead. The value is modified when CDP is enabled/disabled by mounti=
ng=0A=
> + * the resctrl filesystem.=0A=
> + */=0A=
> +extern u64 arm64_mpam_global_default;=0A=
> +=0A=
> +/*=0A=
> + * The resctrl filesystem writes to the partid/pmg values for threads an=
d CPUs,=0A=
> + * which may race with reads in mpam_thread_switch(). Ensure only one of=
 the old=0A=
> + * or new values are used. Particular care should be taken with the pmg =
field as=0A=
> + * mpam_thread_switch() may read a partid and pmg that don't match, caus=
ing this=0A=
> + * value to be stored with cache allocations, despite being considered '=
free' by=0A=
> + * resctrl.=0A=
> + *=0A=
> + * A value in struct thread_info is used instead of struct task_struct a=
s the=0A=
> + * cpu's u64 register format is used. In struct task_struct there are tw=
o u32,=0A=
> + * rmid and closid for the x86 case, but as we can't use them here do so=
mething=0A=
> + * else. Creating a union would mean only accesses from the created u64 =
would be=0A=
> + * endian safe and so be less clear.=0A=
> + */=0A=
> +static inline u64 mpam_get_regval(struct task_struct *tsk)=0A=
> +{=0A=
> +#ifdef CONFIG_ARM64_MPAM=0A=
> +       return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);=0A=
> +#else=0A=
> +       return 0;=0A=
> +#endif=0A=
> +}=0A=
> +=0A=
> +static inline void mpam_thread_switch(struct task_struct *tsk)=0A=
> +{=0A=
> +       u64 oldregval;=0A=
> +       int cpu =3D smp_processor_id();=0A=
> +       u64 regval =3D mpam_get_regval(tsk);=0A=
> +=0A=
> +       if (!IS_ENABLED(CONFIG_ARM64_MPAM) ||=0A=
> +           !static_branch_likely(&mpam_enabled))=0A=
> +               return;=0A=
> +=0A=
> +       if (regval =3D=3D READ_ONCE(arm64_mpam_global_default))=0A=
> +               regval =3D READ_ONCE(per_cpu(arm64_mpam_default, cpu));=
=0A=
> +=0A=
> +       oldregval =3D READ_ONCE(per_cpu(arm64_mpam_current, cpu));=0A=
> +       if (oldregval =3D=3D regval)=0A=
> +               return;=0A=
> +=0A=
> +       write_sysreg_s(regval, SYS_MPAM1_EL1);=0A=
> +       isb();=0A=
> +=0A=
> +       /* Synchronising the EL0 write is left until the ERET to EL0 */=
=0A=
> +       write_sysreg_s(regval, SYS_MPAM0_EL1);=0A=
> +=0A=
> +       WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);=0A=
> +}=0A=
=0A=
How about changing the code as follows? (Refer to "mte_thread_switch(next);=
" in "arch/arm64/kernel/process.c")=0A=
=0A=
 static inline u64 mpam_get_regval(struct task_struct *tsk)=0A=
 {=0A=
-#ifdef CONFIG_ARM64_MPAM=0A=
        return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);=0A=
-#else=0A=
-       return 0;=0A=
-#endif=0A=
 }=0A=
=0A=
+#ifdef CONFIG_ARM64_MPAM=0A=
 static inline void mpam_thread_switch(struct task_struct *tsk)=0A=
 {=0A=
        u64 oldregval;=0A=
        int cpu =3D smp_processor_id();=0A=
        u64 regval =3D mpam_get_regval(tsk);=0A=
=0A=
-       if (!IS_ENABLED(CONFIG_ARM64_MPAM) ||=0A=
-           !static_branch_likely(&mpam_enabled))=0A=
+       if (!static_branch_likely(&mpam_enabled))=0A=
                return;=0A=
=0A=
        if (regval =3D=3D READ_ONCE(arm64_mpam_global_default))=0A=
@@ -101,4 +96,8 @@ static inline void mpam_thread_switch(struct task_struct=
 *tsk)=0A=
=0A=
        WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);=0A=
 }=0A=
+#else=0A=
+static inline void mpam_thread_switch(struct task_struct *tsk){}=0A=
+#endif=0A=
+=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
> +#endif /* __ASM__MPAM_H */=0A=
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/as=
m/thread_info.h=0A=
> index a803b887b0b4..fc801a26ff9e 100644=0A=
> --- a/arch/arm64/include/asm/thread_info.h=0A=
> +++ b/arch/arm64/include/asm/thread_info.h=0A=
> @@ -41,6 +41,9 @@ struct thread_info {=0A=
>  #ifdef CONFIG_SHADOW_CALL_STACK=0A=
>          void                    *scs_base;=0A=
>          void                    *scs_sp;=0A=
> +#endif=0A=
> +#ifdef CONFIG_ARM64_MPAM=0A=
> +       u64                     mpam_partid_pmg;=0A=
>  #endif=0A=
>          u32                     cpu;=0A=
>  };=0A=
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile=0A=
> index 76f32e424065..15979f366519 100644=0A=
> --- a/arch/arm64/kernel/Makefile=0A=
> +++ b/arch/arm64/kernel/Makefile=0A=
> @@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)              +=3D crash_dump.o=
=0A=
>  obj-$(CONFIG_VMCORE_INFO)               +=3D vmcore_info.o=0A=
>  obj-$(CONFIG_ARM_SDE_INTERFACE)         +=3D sdei.o=0A=
>  obj-$(CONFIG_ARM64_PTR_AUTH)            +=3D pointer_auth.o=0A=
> +obj-$(CONFIG_ARM64_MPAM)               +=3D mpam.o=0A=
>  obj-$(CONFIG_ARM64_MTE)                 +=3D mte.o=0A=
>  obj-y                                   +=3D vdso-wrap.o=0A=
>  obj-$(CONFIG_COMPAT_VDSO)               +=3D vdso32-wrap.o=0A=
> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c=0A=
> new file mode 100644=0A=
> index 000000000000..9866d2ca0faa=0A=
> --- /dev/null=0A=
> +++ b/arch/arm64/kernel/mpam.c=0A=
> @@ -0,0 +1,13 @@=0A=
> +// SPDX-License-Identifier: GPL-2.0=0A=
> +/* Copyright (C) 2025 Arm Ltd. */=0A=
> +=0A=
> +#include <asm/mpam.h>=0A=
> +=0A=
> +#include <linux/jump_label.h>=0A=
> +#include <linux/percpu.h>=0A=
> +=0A=
> +DEFINE_STATIC_KEY_FALSE(mpam_enabled);=0A=
> +DEFINE_PER_CPU(u64, arm64_mpam_default);=0A=
> +DEFINE_PER_CPU(u64, arm64_mpam_current);=0A=
> +=0A=
> +u64 arm64_mpam_global_default;=0A=
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c=0A=
> index fba7ca102a8c..b510c0699313 100644=0A=
> --- a/arch/arm64/kernel/process.c=0A=
> +++ b/arch/arm64/kernel/process.c=0A=
> @@ -51,6 +51,7 @@=0A=
>  #include <asm/fpsimd.h>=0A=
>  #include <asm/gcs.h>=0A=
>  #include <asm/mmu_context.h>=0A=
> +#include <asm/mpam.h>=0A=
>  #include <asm/mte.h>=0A=
>  #include <asm/processor.h>=0A=
>  #include <asm/pointer_auth.h>=0A=
> @@ -737,6 +738,12 @@ struct task_struct *__switch_to(struct task_struct *=
prev,=0A=
>          if (prev->thread.sctlr_user !=3D next->thread.sctlr_user)=0A=
>                  update_sctlr_el1(next->thread.sctlr_user);=0A=
>  =0A=
> +       /*=0A=
> +        * MPAM thread switch happens after the DSB to ensure prev's acce=
sses=0A=
> +        * use prev's MPAM settings.=0A=
> +        */=0A=
> +       mpam_thread_switch(next);=0A=
> +=0A=
>          /* the actual thread switch */=0A=
>          last =3D cpu_switch_to(prev, next);=0A=
>  =0A=
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_device=
s.c=0A=
> index b495d5291868..860181266b15 100644=0A=
> --- a/drivers/resctrl/mpam_devices.c=0A=
> +++ b/drivers/resctrl/mpam_devices.c=0A=
> @@ -29,8 +29,6 @@=0A=
>  =0A=
>  #include "mpam_internal.h"=0A=
>  =0A=
> -DEFINE_STATIC_KEY_FALSE(mpam_enabled); /* This moves to arch code */=0A=
> -=0A=
>  /*=0A=
>   * mpam_list_lock protects the SRCU lists when writing. Once the=0A=
>   * mpam_enabled key is enabled these lists are read-only,=0A=
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_inter=
nal.h=0A=
> index aaaf31ca9210..e6e7ba4342d6 100644=0A=
> --- a/drivers/resctrl/mpam_internal.h=0A=
> +++ b/drivers/resctrl/mpam_internal.h=0A=
> @@ -16,12 +16,12 @@=0A=
>  #include <linux/srcu.h>=0A=
>  #include <linux/types.h>=0A=
>  =0A=
> +#include <asm/mpam.h>=0A=
> +=0A=
>  #define MPAM_MSC_MAX_NUM_RIS    16=0A=
>  =0A=
>  struct platform_device;=0A=
>  =0A=
> -DECLARE_STATIC_KEY_FALSE(mpam_enabled);=0A=
> -=0A=
>  #ifdef CONFIG_MPAM_KUNIT_TEST=0A=
>  #define PACKED_FOR_KUNIT __packed=0A=
>  #else=0A=
> --=0A=
> 2.43.0=0A=
