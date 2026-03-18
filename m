Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010059.outbound.protection.outlook.com [52.101.229.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3736C0B0
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821364; cv=fail; b=HCI5+bea8xK5pm/03eHE50S+1YNnrU0qbtXh0mZHlnA5rdoq3+6Q66myBa/3F/9OL/DnyBsehx2paNXxyqdhGNtPQzNzl7jxzitAAg7jPQ6DAGiJKEd9oCzaQoCbDREfqQWJ3Jk/FS2sA1Em2NSBn062uu7ObatatWt7W7Fnh4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821364; c=relaxed/simple;
	bh=ySD6w9flWBgpOdOMOyfkn5RxD46rES6jGEwA5pljmac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TjAaIypxK7l+Mx0WeuCiV9qnKAFUnpzfcZMRLmyXqClp9zdw6HtOWe92D273Orh+UqB8umE6UCZkS0C4c4KJUdDxQILDvSdkzJF2k40d4hRIhzyfqLb3iMS4bGiIophDKUtf8kxW3QW10zNTIR5AcoKMgWeg/tpIpJhJeoTAhds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=CexRY9z0; arc=fail smtp.client-ip=52.101.229.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="CexRY9z0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTO1ZiZ2M+lK9FjneGBOCyHPnQiPDWwQulgXlCeCxdeazt5wpvDyKiRXcj1L3yT7AuNkCT+4W3946FUC7rNqKQ4pYdebniPoZHXyZOT5+73WXDst1LEaVP0UEOS3j6+vNLdLIuiG+xh0uH5eOTSwDOP7dccZK0WzHRp3cOyGllSwkEkpEtp8j0hTihlNYLH7zTNc/Ampfqq3B2C8IVcnoW+B/ppl8T/eeRHyqZF1qxNW5KL7Kw8GElc7E03bm4e76xMkcLQwGqP+f0LYc92TnEPR1Abx41086qcY4bUk45j+Ri7BR6gJHBl9pXbpjoLbMpm6l2aTQ2Xdo9zYsdIOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySD6w9flWBgpOdOMOyfkn5RxD46rES6jGEwA5pljmac=;
 b=s3bERxSC31p3hxTCnFrPCXS95zCY+NGagxPueD8bdxAhCx5EDhsWpX2Gk66/Els9BD4c3z7pcfcpgfUhaO6mBQWBI8UbyQHLGoo4nKbnFVL8GGX2hSnPrYTracfFoXZ9CRBiJAtGHWFq6DPzqtqat2NJjn+Enw1vm91af7nAg5toT6sNoc6HLwhW21ZdO0ijYD9fcC52E2suz9gQaFm+EHhrpZ9+1DZAvTHoEo/dtjlPXA93a+1SyGMQ7HG2WCS37PMovQj1ipmkagMiw1V5GN/ObadMrX+bYhqMnbJC1y8wAQ7RvLW/v184miOuUUkYy+vMzXedU6vvGIbMTbWQPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySD6w9flWBgpOdOMOyfkn5RxD46rES6jGEwA5pljmac=;
 b=CexRY9z03fhnjB6xGdEIyhkxCQPIlDoN83jz1bAs1wz7Uk/gy00kKOwCkhlqONjuZVbLQEg8WHbelyS646lsNZKObRs8gAMD6dg/mM0Ab+ZJZcsVxkUQ512D+pSoTTN6E52JU78hh1aYnxrUR8FD/Zxs6fULI5aAMJev/OzDgce9JxSe+Th6gaTdNKFhcsKkG6vt2QeBmyo39NspVzZxnP+/O4pr4OHUcfIvIrKvMFbqUZvVsghYf+f081/Hmz7WjuyDhZoenYk3xa2V7z45ebgEEFrdm8WHX3R6aw9PxgZvhvAdYdAZuSZaUpa4QaQqChT15xa85+kXKH1CfqxxfQ==
Received: from TY4PR01MB16930.jpnprd01.prod.outlook.com
 (2603:1096:405:338::19) by OS3PR01MB8367.jpnprd01.prod.outlook.com
 (2603:1096:604:192::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:09:19 +0000
Received: from TY4PR01MB16930.jpnprd01.prod.outlook.com
 ([fe80::38bc:7870:6f23:a957]) by TY4PR01MB16930.jpnprd01.prod.outlook.com
 ([fe80::38bc:7870:6f23:a957%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 08:09:19 +0000
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "zengheng4@huawei.com"
	<zengheng4@huawei.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Topic: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Index: AQHcsvgyBK18AGI8hEGSs1O3IzqQF7Wz9jdj
Date: Wed, 18 Mar 2026 08:09:19 +0000
Message-ID:
 <TY4PR01MB1693015592F173098A0C5A2A48B4EA@TY4PR01MB16930.jpnprd01.prod.outlook.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-03-18T08:09:19.334Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY4PR01MB16930:EE_|OS3PR01MB8367:EE_
x-ms-office365-filtering-correlation-id: c2dedd93-0f03-4a4b-e2a1-08de84c5a825
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|18002099003|56012099003|22082099003|1580799027;
x-microsoft-antispam-message-info:
 c6Qk0KjaLggL/J4hZEw+S9ot/j58cf2ysUKhyLjoElELo+j+1ypegQ7RVgcnJkSZHV0tdP/V7rF5crFIT3aYs3qxBykVVaWW3j283VRV+nN10HMXc5H2j1EDtZ5GvmxjkI9ewf1PGi1WA/y6v90z4O0Ln6OK8zNJs56ZrS7aHSGg/+wZon4FKr+TIz0rNFNMN+ClJkI6bxIqakpJu9Wh6hR1M11NmBQmuwHKkROxoq6IWUZH64Oc0bwdiPasouz+p7eSe+Gk9OmofEuU9YStoEy48I7L3zd3mYYMOJx990dYrKn+8QF3PQpGKmWiVceVmIe7ln51Ok6SSWm58OiErcbqo5TacDIzecmGeuTtfgK/fkl/riiP/MEPA9LmjU4+UEwhTm8zZnT55/RnlEag6CJa7SkSNU+flC2DPLKhtxp0SrlcC8xtgfkdiF32Sfs86irzNb4oqtrRi5VRow4cylfKts7TghkJjfVgHpDOogadAfPO/0OO1I8IpDRZ7ni/ce98ZYAt9w3mZrI4dT2s03ZZ6RYc09dO2Np/cSXF2Bpv/2x5nzjWRFS70xaJKyooZrV9F1aueRxdQSIRlOaub3p8SgczRtXK07Jn4F36pf6KEsyVOU9MK/64fIM14tZspdmPKfKb7P+Rqr6qGqPOdu2dOtjNi9EdhD4GMrNh1Edj/rrwnawgXTBofBAa5ZxjrJpSkkReF4oq/tGfWsr2dcfEFuPgwL/PfXsFa8gij8upFtNNwzrP6ecNBMzp+DQiDOUt6BEwlinheI6TiRZnOi6GnO4qhYHxdFDDRPvZ58DY4SBX4Z3mKyfI91FGQbc1
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY4PR01MB16930.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?VnFEdmVlRXpQbnBvZkhxTDVQMFU4K012cTh4ZGN1dVFUZ05mY2h5OTBR?=
 =?iso-2022-jp?B?cFBuaWVTenJwL2dBd3AySnFaV2NUZXpXNkNJdWtNNnJqT3ZKdzc0b2x0?=
 =?iso-2022-jp?B?aVV5Yjh3cTRkQXh2eUsvOTFTYkVZUTFYUVRLdSsvQ2xpaHJMS2d2Q29J?=
 =?iso-2022-jp?B?ejkvZnZZczVzNTVuSEtTOXB2dnJDWTFXb0xmZXN0UHBQR2w0L3ZRRjhT?=
 =?iso-2022-jp?B?RUpPNFBNcy8rTGNYZGQ5Y2RiV1A1M2tWSVIyTDRFZlREbXFjWkhxbXRT?=
 =?iso-2022-jp?B?QnF3Y0NJTGdvOE9lcGxBSWZFaWpLTnRwM3NISklvSGNyQVJCZnoySmlZ?=
 =?iso-2022-jp?B?MDFWRXB0RDQrVVBwWjNqRFBBYytqWlRlMGRuUHJkdkEvL3JmeFRTQjBO?=
 =?iso-2022-jp?B?MnpzeGJQZGozem1DdjBaRGpQc0lhTnNHYVd1N0xDY0JZMzZsbVhEamRq?=
 =?iso-2022-jp?B?K21sV0JpRDU1bXUwU2N1cUFhWHZQcXJ0WlU3ckViUXpySE81ck1HamFx?=
 =?iso-2022-jp?B?WlBYRFBQMDN0QnNSSDg0ZFBtOVZLU3F1V3l1cUk4N2xMZy9ZVkpHd1Qv?=
 =?iso-2022-jp?B?ZkxSL3RVa0JPcDRSZWxZcmFrbzdFc1QxUFIzUU94SWZjYWZZbW03NnNW?=
 =?iso-2022-jp?B?MjZnMEl2Q2V2dUFDVU4vbFF5Q3Juc0dYMDFkdHE2bUZVUnhOWm9pdEZ1?=
 =?iso-2022-jp?B?Nnh4RjQ1MENzMlJXdDVhTVNMa1FkditoTk41Nnhza2pqbzVCRStoQ1A2?=
 =?iso-2022-jp?B?SlZHVDk1aENxNld4SGZZQUpLTTJ6b2FrbDZpM1oyT3NrdkhGdXFGVWJw?=
 =?iso-2022-jp?B?bFJhclBIdTZDOTZSaVpzL1R6bFpXTjhhSXhmb2RvK1RmWTNxQTFlbndv?=
 =?iso-2022-jp?B?S2NjUDlFT1dScmZZOEtTQUpPbTZRR1B1dWpTQ0dzTVhPTDdyS3U3T0Q4?=
 =?iso-2022-jp?B?d2VzcDJZUlF5VUgyWllkOVpScjYwWFUzSHRTYTJkZXNGQzZvcG9tc0JM?=
 =?iso-2022-jp?B?Sk54K0dncXJLVVhIVUVkSVFiWTM5cUZZd3FBMXhqQVVQbkR6ZnRQdmdJ?=
 =?iso-2022-jp?B?K2x3eHdzT1poamU1dnlYNW5aUHAxamh2S3FYOStSdUhVUkg0WS9zcDdz?=
 =?iso-2022-jp?B?N3d0cUV1WlEwNEQ5SFQvYlhTTEFBS21sRmVpVUVaY211ZVYySkUyZ0ZU?=
 =?iso-2022-jp?B?cklqWkJ6L3Zud3ZHM1dGc1BEc2ZsdFFUaU1GRUNneHNaMU5xcEtQU0Nt?=
 =?iso-2022-jp?B?SDdWeTI0UVZuVVQ5OTJNVnFzUU9sQ0RPVEVQSFlLK1FSQlRrSUlFSmVj?=
 =?iso-2022-jp?B?VHM3MkJnVktKTjdkaDFGck5Uczh3VGdqeEJ0MW1hWERhQWthSTFmVzlT?=
 =?iso-2022-jp?B?Sm02eVFQNVZReGlPMkl6OTVzVThieE1YZCtmTWo2LzZuSGtjQUZZby96?=
 =?iso-2022-jp?B?RjhYbTRMM2oxQW8xcHhBQm8rTkdQL0toZGh1THRJTVVsUzdOYjZCOGti?=
 =?iso-2022-jp?B?d2UzTGw4S1BheTg4c2pBZlNKRDlVajV6OUF6MUlvZk90VFlwSE52OUhJ?=
 =?iso-2022-jp?B?OGNCY2I2SDZoTGo0NWM2bG1FWkZrVkVxY1EzcEFFY1lTeUxoR1J2MTZJ?=
 =?iso-2022-jp?B?ZTFzUDVUMG9KaFh6enVFQytqbng0S0dZSXR6Q21McDhSOThrVlFTRURm?=
 =?iso-2022-jp?B?Zkcxd1NPTjZ5VWJLTjhmVk1HTUVVVjVzUWEvN2wwQiszdVB4YWY5R3cr?=
 =?iso-2022-jp?B?bXRRZ2JhSG1MZXplZGp1Tm94ZXdIMzM2aGtPK0Rwd2s4dk1QSXoxbTJN?=
 =?iso-2022-jp?B?SWJ4NjB6VU15MitTR0Ywd3VtRnhrNEZyblVoKzk2MjJmKy9xUFFxdVBF?=
 =?iso-2022-jp?B?T0tmK3dLSGdUV25rSFpBWjVOUTNrbHZlOGdHMTdGdUhiTkZBOFFkMnlz?=
 =?iso-2022-jp?B?c0l5UklsWi9mbWUzWFZ6amZtaWQ4SDNqVW42UzZteHZqNHRaWXg5bG4x?=
 =?iso-2022-jp?B?RnFySG1NekY4aXBQY2JhQ0d4VFlWb2prR2R0MWRrY3lWZFl5Si9JR01a?=
 =?iso-2022-jp?B?WUtFVkdZKzNBQk9vVnhDbTZXY1hSWVd2R1dqbHIrYi93bDBETEtZbWJZ?=
 =?iso-2022-jp?B?ZkZ5Vi94UlpvWjhsOEpNeFl6dFNkVUxTY2NGL29VeFNna0V6aXNqUGEz?=
 =?iso-2022-jp?B?clJUZjdSRnFwRHV0TENQeVhlWHFzMmt6S2Mrb1JHN2QxTEw2RHVtZ1hV?=
 =?iso-2022-jp?B?YysySWpURW9ycnpqV2p1NXI4eVFnblltb0dnVVQrbTV3TWQrazRaczB1?=
 =?iso-2022-jp?B?Z0M4bHhpNURHVVdSSlBqWkRGRWdlUGdIYWhGMitYQUxVNnRoSFFlbjFB?=
 =?iso-2022-jp?B?U21SaGRGTEs0R1pPQXYwUHlwUFpxQTROMlhMZzRSUVlUYUtqeElZZ2ZQ?=
 =?iso-2022-jp?B?alZhRUtJU0tsRmNPdHNaM292QVk3L3Z0NW9qTWpSdWFUUjVTY09WeTJo?=
 =?iso-2022-jp?B?TXRScjlqa2srMDFnRVEyN2JPZ1RSbGluTW1tUT09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	grKWs2WVweaSJh2tZUO/SzZism6eiQZBLzPlZZnthzMG2uCtN4Ivrbtg0yZfKgr5RzR5SRU8WFyLQHibRcMoQmyb2u5H6vMmozCjAyTpjZmRkE5fC4PvUJsmV5iz9PZxADx4ZEhrf/fx7N/t2TpEGtKDy8/ZCMpONtzmFb87ihVm0EJc+BUYynredtgKXjRmSIEKO1nSwrfb+yxMlTGsa5Uilp539XY9dC5VeX+Wx3hANM9qmlJyZgw0eKYN64N9ix1XJPqUPF+Uihx9TQ84q4gDa4lDfVXawkzCgpzELJPM5mU7ZhJdeCCHQ8YOJbxdJtwJspBa5BmlODgWq3kuSQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY4PR01MB16930.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dedd93-0f03-4a4b-e2a1-08de84c5a825
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 08:09:19.7190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eikBeSwZoG1p/eS7lndyXiqXn/DL0seZ+a/HAI57EYHhD3wgA1Syo5PoLViRMqUJj73LWqXBpXOGDMA18kDo9s68D6x+kuX6Y1j8C5FS4fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8367

Hello Ben,=0A=
=0A=
I retested this patch series and there is no problem.=0A=
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=
