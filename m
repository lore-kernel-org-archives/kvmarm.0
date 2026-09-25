Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC52E03E4
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790342875; cv=fail; b=LSgL5A30BU9gW3FNay+dyyq5Na2SjzI2zxVJ8oo8lYzev4T/7BPRQQxfBMteMeTHVSyrJexrQaoiNzE7rHT/KryvrsW4o42W2j4sQO9fOrUPdI3zV9N8Vdzle8FAvcCt08F0n2XDoHVbfKClstAZyp0aw/0BH6WkBbd1XSRYh0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790342875; c=relaxed/simple;
	bh=TtVKAZi/+XvtkhRlywnbvSVQxmOmozykIpMwtrCe9X0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=crI8dQMBMyNDCvCQxk5fjvkhxxZCKqpb92Ars2mzRJQ1EpoxEha+qjMAEJvU2QHuHAKasNuc4FXgiSUx0lMW5t6th7RiqZT6UpFp6d445ZgE8DWMnXeTvoVRHZNiY2O+m7Rxld0STkHaxosDqnIK43ku+MSkZpnb9ooumWSiM6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AgWn8bIe; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IHkPAGWX; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AgWn8bIe";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IHkPAGWX"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4cHvp3801817;
	Fri, 25 Sep 2026 06:27:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=TtVKAZi/+XvtkhRlywnbvSVQxmOmozykIpMwtrCe9
	X0=; b=AgWn8bIeuPMGj7bNhLu/5Z1OQguh3Ka64L5zD4L2lL2t5427dKkjxcQTn
	AM8IIVMKFn3SQSOX6IOSwkocyovKwlgSKi6FQVMSb8HhJYZCqElVcecs1bg2y2Nb
	9VME+McutU3HrdcWhsVuzuQ0I7UlESoot9HoRFJ0AQ60bdc9u5QeAVfUBUObrUyT
	GSqa3ry2vecZyz9/7h1p6+0elNdvP5gIVHY9fWyI/cyHo0KUS2FoA+ZIAGHBmMBE
	nG56tD99axPITG0Ij8RbqBkScwfxkAM4mCrPSrzWyLhZcXJ46QGmvKJN7fUB2JVt
	GuZqWE3D2gFqjDHAGxlc3BMwB0TvA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023073.outbound.protection.outlook.com [40.93.196.73])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gw9xv243h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 06:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMHBV79CGFeQvy01SAJ+D/m5Wqt724yhGUwfOXXDIdDRfYrSlk45XWAStPGP/tFKJWs1Y/rZ8LU1Zo9YhbNCdE8JrgAWsS0ahZW0XrcaLfXZoG2RJd8y7OCmZkXEozBacTLni1oBmHx4bU02cUdJs5PJsU/Gza0OA9aO9YIkom/b7RH4q2zFg6stsMtxLCfiz8HZFuLrNeFph5tYAt+Qswrl0LAdyVqvmJxlFUVD8k7uxxrltA3/ziiFWPBroF8rPVpA+6295MjrQcYCG2A2UqDjHvMMbvUQzwM8vJRrySXOo19Gc6yfL5IICiEWEg2fxYl3nGpepbmEq9HIp+Ojcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TtVKAZi/+XvtkhRlywnbvSVQxmOmozykIpMwtrCe9X0=;
 b=Mvut28t00QNf1VrmrBzwpNFhkvrXF1t+WEH2+G8iR7CRb1YqYCvYgh/cj3HZe3RrkEaXPzJFondfKObDyZGUtdWWI9jhCmkG6lR3RPdOJ4Q8PiGbO5hDmInBcN41he8qFkYV6b8XtCg+2FFbmRFwpvfdZu5N/Poa+Eg7L/fu3eLxg/rjdxJMb++ds/wT0Teuz3ncPoVS8QvQaqSYviOXMIAabkA5LVbMlbnEcsdXH4AMMSRCXYLve51Ho/ixnoZEMagT/yz884i2zeu2gEAonQBXQzS95PECgV2d5qP4qsCX44V3aSGoQxKOxOp5Oum3wxRKKCovVVsqwLHSbkU4cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtVKAZi/+XvtkhRlywnbvSVQxmOmozykIpMwtrCe9X0=;
 b=IHkPAGWXIzsWM9UTZPtY06d2nQf4RzTcsod2rs9R4l8qqHCEPO41GKIOmm50atScdkuhItJgYXER4lJ/TO2FLxq4a26gF1v8mWEo3eJ0YJezJdN2vhgd+W8zsI3BuXDs1BE/RoNIeZ3EN4Nnfi4Gr7z9qSs/denu6OkLlg3oVlueSQnnW9l3/1Jr2O4mHRKLgXKfXFZC8++ZoJJw+b37H0+55fWrAplw8aCG2eA2LWz7Ez8JlhEABkbOS5nGfcbJ9oK+0Bud7Oy7aMAig1lrFdT9FaVMilVFX3yzY/BtQTp3LVCyQvJH6SKaJEw860hwg//rZzrREt7wAdPmpV6rBQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB10758.namprd02.prod.outlook.com (2603:10b6:8:1f2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 13:27:39 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 13:27:39 +0000
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
Subject: Re: [PATCH v9 12/26] arm/kvm: Initialize isar.idregs[] with all
 writable host ID regs
Thread-Topic: [PATCH v9 12/26] arm/kvm: Initialize isar.idregs[] with all
 writable host ID regs
Thread-Index: AQHdTPGiuEC0SUB48UuYtqXS+FVeZw==
Date: Fri, 25 Sep 2026 13:27:39 +0000
Message-ID: <8C1A034C-C3E7-4EC3-89CF-6E3AD99AE90C@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-13-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-13-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB10758:EE_
x-ms-office365-filtering-correlation-id: 1345567e-4006-4563-673a-08df1b08c530
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 jHbFNl7v6DgpYNlw9Ewhz7RxTlIeYmWrvygNugYUZtsGn0hGu/ZA4thvCW6tivIXfu3f1Qlp8UP9u4XlXHv7QAwt0V2o+1nqyztw4GloFYTk5BiMPXfEtKNe9RLPl0hSb3cZlX0QBoPmmbu7AvMgE/+mBkVypL/4KbCYVIGUN5dzVDRNtzGTokugyGC7mYTRP6h4t4mKNFerxntaSqzE0HB9eanYQH+M0/Upfm+fdwH07fnUUTtDOALPu43huVB5C79f/Y1DHBPQbtr4xiCZkUFaKPaU8AkhhT/fo5yaT0B1NaUGpEvm7yyoqlQ0xGejXWpJokSNJU/aBaO4rJjrbkvqpONcdq64ZQB4QCIlvB9hIUWocpLmo2oom+rAPIjueIouZfh7Hwg5trBB23fhe4zds1MoAmtyOkImrxcatifn8xnl4rEKqRe/pyx/LFe7KUd/4kLAtiXHa2yZxs0HQsy8nQ/tsqjdi/+g7GHsPrJD8jfkmEloRO2KxBrNtcIYEw4HXnxXtjGND6TQQ4T+yS8iBuNHtjk0wtoW0aya6spkrm7nJIAYWf32u1lmA1cLpiq7Rb6chur0M/xwKnTC7qbgqPLkP5Ka36clrv+AU5ozYdgLraxLEvobj6N7vCdpnSskpT1xOccYDbvZG0CemT/WzYeSdTOQdOoBbWMSP8ldO0JjUvQoce7om7pqFEmV44yTdXRKc4HL5ZnhNeagpQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3BDeURkUkJtKyswK0VFZ3NibUs4cnpTNGxBb09EWmpjTHliTTJ3NUZKbklI?=
 =?utf-8?B?S3lRU3N0L1VEU09pU0EyZFlrZ2hQZEQ2NlY3Wlh2azZNWnVibzZsRVFIRHlG?=
 =?utf-8?B?ditkS1BWeG02b0tVcktNeDBUc0NiYWMrWGhpaXJEVDJDcElzMUg2UkFwUVFU?=
 =?utf-8?B?Y3cvamZwSlJEMjJ2ZzAxdnBFNlpFSEdoVDBYb25pVkdNMHVqNWhtU3h2THcy?=
 =?utf-8?B?N0hhVmxnLzMxbVRMUmlIcFZwTVJoaDRNckVsTEVvVjJaa085dXNyYWJYUWd4?=
 =?utf-8?B?cGozUWl4aWVFaExkRUJXeWlVYTlvNmNNclV1S1pEdjJtcHBHK0llRXlhSWhQ?=
 =?utf-8?B?VlhNSS9GdXl2S05UYkh4QzFUWmFvUFVsVlIvSGlNdm1vM20zdmErenozZDNv?=
 =?utf-8?B?dWVvaWxSdlJkN1hmRE5oY3BFeWxNcjNyT1VjeStwWUNybi9DeVlUZlcvcGFJ?=
 =?utf-8?B?M0RIeDBuVVFxZU9hUHd4ZDh4RlVkbXBKanhqa3oxV1c1U1V4aE15QWo2a0Uy?=
 =?utf-8?B?dmJ0VjhMcCtrTDNNWEtBc2FwNURsYWxNWnA3WXJ5L0UzMjRUcTlweWd6SmVL?=
 =?utf-8?B?Y1ZvNnJHUkpMcWY2ZXYzSGZJcDM2c25tK1VZK2lqRWtaNFhWNytPbytFaDVD?=
 =?utf-8?B?TGt2dENHRlV4YVlRbjJWUnF3bmVGcUdXb0lkb0FCajRrVWtpNEt4Y21pVTcw?=
 =?utf-8?B?ZVFZNENJS0FwSHpXWkFFMW9PS0ZDNFhqZHlGeFFobkV2cGRHRmZkK2Y3TlNi?=
 =?utf-8?B?UW9DaDJJemxwZ0R5S3FaaEJJeGxaQ1ZWWVZpYitpVWdMRU9OL3ZTNlg3b2Iv?=
 =?utf-8?B?d3BnY1BIaTBYZm9Md3Z5cnlnZnZ5VkJ2NkEralJpazRZajNvL01xVjR1emNJ?=
 =?utf-8?B?Yjk1azFoblBGRzdCZ2IwblR5R0kvWUo0eHIyTWxHdzgzWG9MNWdNZ21DY0Rr?=
 =?utf-8?B?bSs3QjJZd2I0UE1MdG1LUE9ZcjNiMGUrTEFQODRoZ0w1WUpxZGlQM0t4Q2hP?=
 =?utf-8?B?Q1VZc1FOZDg5alNLRytZam9TdEtTdjVCRlk4RG1scHNrZ1BOaGFCNzFWK3Vj?=
 =?utf-8?B?T2F5bWpZYzNSSnZ6UEN1TzYxcVF0a3JheXgzSkxJSzlyeVVqdnU2LzNTdXFZ?=
 =?utf-8?B?RGVwNCs1MnFjRXhOVkJVdlBVTFZ2cnMya1JiT05EMGhxalpsQWxRREhXWW90?=
 =?utf-8?B?YjV5YnBXQ1p2cUtobStBWTZiNmdPOUZVZlRIb2lyWkZ5ZXlDTG1US3RkRVFQ?=
 =?utf-8?B?VENGckc4eDlZOUg1T0R1OHVSR29vQlJFUmFOb2ZVbDltTC9iQlIyU0tLTlVR?=
 =?utf-8?B?cmlkMG05OXR1R0F6Umh3RUIvM2JGdS9GbW5zYTdVQi9SKzNvMWxNY0V2SU51?=
 =?utf-8?B?VG5ibGpOQyt1MGNFeGpsaXFOTzVQNmNDbERpci95cHBlb1dJMzZPdDVKYXhJ?=
 =?utf-8?B?NnppQituMCt3YUN3Ui9VNmo2Sy9Dd3VpR2NiNlhMUFJxbUVCY1hadzh1NUs2?=
 =?utf-8?B?NDlGS1BYRUE4WXFodE5BNDduQmtuc3QrcWYrZDhtcE9Kc0xlNGpXdHhPb016?=
 =?utf-8?B?ODV1MkhmbVI5M2NIb1l1WVZ4d3RoeUdUclN1MTlHa24yYWk5MUtDemNoemxa?=
 =?utf-8?B?bHhDdTlOUGg0eTllOVYwV1phSkp6bzVhTCtmaDA5eDh5TUtHNFBsRzhsS1BM?=
 =?utf-8?B?V0JxNmxjY0Y0dURyelFUbkFsU2k0S1V1VGtDTGwveTJRNThGbXdKMmFiWFp2?=
 =?utf-8?B?ZjQ4N1hPbUZVVTdwU2F2WXJBV3JXRzJaako5emk3bXpMa3lVT2xHR1ZYeWZi?=
 =?utf-8?B?eEtLODlyQ0RvMk1GdzNXRElrNVpRUUlOQ0xMY0xtSlkyQmllZFhWYzZ3U3NT?=
 =?utf-8?B?T2RTWDY3YmxhbGZBakZjT0p5TTJwdXF5SjFvM1JGMXE2TEkxa0cwMlYxQ2o5?=
 =?utf-8?B?RDVwaFJEQlovWG1LSTBHZzVKLy9lZFh5eGlSR09PcFhlOHd1Z25YMmhJbkFa?=
 =?utf-8?B?VG1tRmtnbml4bXFBOE5hTkc2akdkb2JFOHNFSE5GV3lqZnp1MndsN0ttSGhW?=
 =?utf-8?B?VVQ3ZHk3TnoxeWYxQ0xyWkF0U3psZVRacnE2OWRzaVVhOVZ4OE83ZURoMzNh?=
 =?utf-8?B?bUVQTlBheFUwM0JiUHM0bHpwcVBiWnpGSlFZN1JZYkJ3d2gxL1hwNjBrbFdF?=
 =?utf-8?B?cjJITFcwWVVvSnp1YWt2MXIvVGZHV29pMjdrcEpJeGdweVhxTll5M2lTWlBY?=
 =?utf-8?B?RjZDam94WjJKL0JidnV6NHpBUnpJZXVTNHFWY2gyNDlod3BzUHhya3l6V1o1?=
 =?utf-8?B?WVkycmdldW9nemJXN0RQdTZ0WDlCQlFoNVFkRWkzZS9pb3FWY3pOOHZCQzU4?=
 =?utf-8?Q?b/yxn3BrTZ7B2Dow=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF81B04238FE074E8EA67AC681041F14@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	qCjkWT+Whtrny/2XBd5fYNqIIwXylO5CnLSF+l/diWBnmQ+KGqf0vojyvZ1CIyDdnyGFrHjUv/W6uIsaHf+OOAfxi36u/m8yvYxRtL9iS4CaOVw+DaNXuAxLks16Z1uJobIsObCSeuippHCJZ3HZydtObHabQ3FPzbYm47VyROp6WMUA8MRDYxQs6oO4yx/4Hl6dEnLi5FbbGJ/ww0ViP6Yh6pRFBAH3hMVcRPCHxPPyxyTjz77kC5y0sODg9qnCeh+9rjN6h42rh19KZmrARFdKPAxDXPIcIuXEShFCCLdm+OUPZ5eB/tSEBSN+Zbl+aVrT2RxoRVVWCp4oCi/myw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1345567e-4006-4563-673a-08df1b08c530
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2026 13:27:39.1316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3DTBZYEt/98SXwVrU0Ybh3yQGf04mkIyDMCyt/CbJMtaVXtAhP831JXQLuqynwkvVXeg3IXmoUfEwCVOqxq2QWDk/MtWbi+897u2AizP8eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10758
X-Authority-Analysis: v=2.4 cv=YoCa1IYX c=1 sm=1 tr=0 ts=6ab676cf cx=c_pps
 a=z3Dl+KlN2KZ3OO0ZkS+3EA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=76DONOJ-3wu2KbdviDsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xfKeTLQMxnUuRQjQhi26YJMFQpKuuIZd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA1MyBTYWx0ZWRfXzvN3Oj8HkoDE
 zYYvhC+cSZjJNDmCfR/wTvp1x8lMPNpVUTtvWnzpHM+kTScfBK4Z0iNDJncWAxzLlknwVfarXq6
 o3v1AK4eULHJ1cCWfxChyN5dL8LxaXpMTUJ0fmey+Da+mc4/bdzdC7M+DDDmySzHTDOmczziPxx
 IXUvPM6Q2qZkJzQyal+THsK25TUQh3NLi3i206nUdS8sTnjuYUbFUh1l3oH57/cMuFMo0jx3kes
 PfUnVqtjX+piHGW2ScZemuZnfvTj4XxhMYQY2MrNNeBryQuxauwZ8Y8/4n9GIQ7kwwfK1IHhAoa
 7FQ5nHs+lwxXk0nlMqTHpK7yXYRNfUv781MQ7UI3XpzU/y4u59Yiq93zhXDbLjYqs2A9dIoKBVL
 4OgH82Q0YMnA0OYRBONIah5yf93t3tnGJ/6BwRWgNNyCRBRCd3LwUQfQ1PkOwSA9Lwl/MIM9Bei
 R4QefERN2rYZdn4gk6Q==
X-Proofpoint-GUID: xfKeTLQMxnUuRQjQhi26YJMFQpKuuIZd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA1MyBTYWx0ZWRfX1vH0EDbSBWje
 LFAMlXHU8DwgMpiMy5rZ+aaGJEr2Y+U5oNnXmdi3JW7AGdL+2dMUaiKD5sQmq4bk4LYMc+PmYwp
 bRUr3SfSwHACVFCg0ogRX+sMljqG++k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4ga3ZtX2FybV9nZXRfaG9zdF9j
cHVfZmVhdHVyZXMoKSBhbHJlYWR5IHJldHJpZXZlcyB0aGUgdmFsdWVzIG9mIHNvbWUNCj4gaG9z
dCBpZCByZWdpc3RlcnMgdG8gYW5hbHl6ZSB0aGUgYXZhaWxhYmxlIHZjcHUgZmVhdHVyZXMuDQo+
IA0KPiBFdmVudHVhbGx5IHdlIHdhbnQgdG8gYmUgYWJsZSB0byBhbGxvdyB0aGUgdXNlciB0byBj
aGFuZ2UgdGhlIHZhbHVlDQo+IG9mIHdyaXRhYmxlIElEIHJlZyBmaWVsZHMuIFNvIHdlIG5lZWQg
dG8gc3RvcmUgdGhlIGluaXRpYWwgdmFsdWUgb2YgYWxsDQo+IHdyaXRhYmxlIElEIHJlZ3MgaW50
byBpc2FyLmlkcmVnc1tdLg0KPiANCj4gSW50cm9kdWNlIGEgbmV3IGdldF9ob3N0X2NwdV9pZHJl
Z3MoKSBoZWxwZXIgdGhhdCBwb3B1bGF0ZXMgaXNhci5pZHJlZ3NbXQ0KPiBhbmQgY2FsbCBpdCBm
cm9tIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzLg0KPiANCj4gVGhpcyBwYXRjaCBoYXMg
bm8gaW1wYWN0IG9uIGNwcmVnIHZhbHVlcy4gaXNhci5pZHJlZ3NbXSBpcyBvbmx5DQo+IHVzZWQg
YXMgYSB0ZW1wb3Jhcnkgc3RvcmFnZSBmb3IgcmVnaXN0ZXIgdmFsdWVzIHRvIGJlIHVwZGF0ZWQg
aW4gcGxhY2UNCj4gbGF0ZXIuICBBbHNvIGl0IGRvZXMgbm90IGhhbmRsZSB0aGUgd3JpdGViYWNr
IG9mIGlzYXIuaWRyZWdzW10gaW50byBjcHJlZw0KPiB2YWx1ZSBsaXN0IGFmdGVyIHVzZXIgdXBk
YXRlLiBUaGlzIHdpbGwgYmUgaGFuZGxlZCBzZXBhcmF0ZWx5Lg0KPiANCj4gTm90ZSB0aGUgaG9z
dCB2YWx1ZXMgYXJlIHJldHJpZXZlZCBmcm9tIHRoZSBzY3JhdGNoIHZjcHUgaW5pdGlhbGl6ZWQg
d2l0aA0KPiBhbGwgdGhlIGF2YWlsYWJsZSBjYXBhYmlsaXRpZXMgZXhwb3NlZCBieSBLVk0sIGlu
ZGVwZW5kZW50bHkgb24gdGhlDQo+IGZpbmFsIGNob2ljZSBtYWRlIGJ5IHRoZSBzdWVyLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT4NCkhpIEVyaWMs
DQoNCkFzIHdlIGRpc2N1c3NlZCwgaW4gdjEwLCB0aGVyZSB3aWxsIGJlIGFuIG9wdGlvbiB0byBh
bHNvIHJlYWQgYWxsIHRoZSBJRCByZWdpc3RlcnMsIG5vdCBvbmx5IHdyaXRhYmxlLg0KPiAtLS0N
Cj4gdjggLT4gdjk6DQo+IC0gaW1wcm92ZSB0aGUgY29tbWl0IG1zZy4gT25seSBpbml0aWFsaXpl
IGluIHRoaXMgcGF0Y2ggYW5kIG1vdmUgdGhlDQo+ICB3cml0ZSBiYWNrIHRvIGNwcmVnIHZhbHVl
IGxpc3QgaW4gYSBkaWZmZXJlbnQgcGF0Y2guDQo+IC0gRG8gbm90IGhhY2sgQ0xJRFIgaGVyZS4g
VGhlIGNvcnJlY3Qgd2F5IHRvIGZpeCB0aGF0IHRlbXBvcmFyaWx5IGlzIHRvDQo+ICBkbyB0aGF0
IGluIHRoZSBtYWNoaW5lIGluc3RlYWQuDQo+IA0KPiB2NyAtPiB2OA0KPiAtIGZpeCBpbmRlbnQg
YW5kIGFkZGVkIEtodXNoaXQncyBSLWINCj4gDQo+IHY2IC0+IHY3DQo+IC0gcmVtb3ZlIHZjcHUg
ZnJvbSBwcm90b3R5cGVzIChLaHVzaGl0KQ0KPiANCj4gdjUgLT4gdjYNCj4gLSBkbyBub3QgY2hl
Y2sgd3JpdGFibGVfbWFwIGFueW1vcmUNCj4gLS0tDQo+IHRhcmdldC9hcm0va3ZtLmMgICAgICAg
IHwgNDMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gdGFyZ2V0
L2FybS90cmFjZS1ldmVudHMgfCAgMiArKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5j
IGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBpbmRleCBjNmVhYzQxOTkxLi45NThiMjVlNTUwIDEwMDY0
NA0KPiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4g
QEAgLTQzLDYgKzQzLDcgQEANCj4gI2luY2x1ZGUgImh3L2FjcGkvZ2hlcy5oIg0KPiAjaW5jbHVk
ZSAidGFyZ2V0L2FybS9ndGltZXIuaCINCj4gI2luY2x1ZGUgIm1pZ3JhdGlvbi9ibG9ja2VyLmgi
DQo+ICsjaW5jbHVkZSAiY3B1LWlkcmVncy5oIg0KPiANCj4gY29uc3QgS1ZNQ2FwYWJpbGl0eUlu
Zm8ga3ZtX2FyY2hfcmVxdWlyZWRfY2FwYWJpbGl0aWVzW10gPSB7DQo+ICAgICBLVk1fQ0FQX0lO
Rk8oREVWSUNFX0NUUkwpLA0KPiBAQCAtMjkwLDcgKzI5MSw0NCBAQCBzdGF0aWMgaW50IGt2bV9m
ZWF0dXJlX2lkeF90b19pZHJlZ3NfaWR4KGludCBraWR4KQ0KPiAgICAgcmV0dXJuIGdldF9zeXNy
ZWdfaWR4KHN5c3JlZyk7DQo+IH0NCj4gDQo+IC1zdGF0aWMgdm9pZCBrdm1fYXJtX2dldF9ob3N0
X2NwdV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+ICsvKg0KPiArICogZ2V0
X2hvc3RfY3B1X2lkcmVnczogUmVhZCBhbGwgdGhlIHdyaXRhYmxlIElEIHJlZyBob3N0IHZhbHVl
cw0KPiArICoNCj4gKyAqIE5lZWQgdG8gYmUgY2FsbGVkIG9uY2UgdGhlIHdyaXRhYmxlIG1hc2sg
aGFzIGJlZW4gcG9wdWxhdGVkDQo+ICsgKiBOb3RlIHdlIG1heSB3YW50IHRvIHJlYWQgYWxsIHRo
ZSBrbm93biBpZCByZWdzIGJ1dCBzb21lIG9mIHRoZW0gYXJlIG5vdA0KPiArICogd3JpdGFibGUg
YW5kIHJldHVybiBhbiBlcnJvciwgaGVuY2UgdGhlIGNob2ljZSBvZiByZWFkaW5nIG9ubHkgdGhv
c2Ugd2hpY2gNCj4gKyAqIGFyZSB3cml0YWJsZS4gVGhvc2UgYXJlIGFsc28gcmVhZGFibGUhDQo+
ICsgKi8NCj4gK3N0YXRpYyBpbnQgZ2V0X2hvc3RfY3B1X2lkcmVncyhpbnQgZmQsIEFSTUhvc3RD
UFVGZWF0dXJlcyAqYWhjZikNCj4gK3sNCj4gKyAgICBpbnQgZXJyID0gMDsNCj4gKyAgICBpbnQg
aTsNCj4gKw0KPiArICAgIGZvciAoaSA9IDA7IGkgPCBOVU1fSURfSURYOyBpKyspIHsNCj4gKyAg
ICAgICAgQVJNNjRTeXNSZWcgKnN5c3JlZ2Rlc2MgPSAmYXJtNjRfaWRfcmVnc1tpXTsNCj4gKyAg
ICAgICAgQVJNU3lzUmVncyBzeXNyZWcgPSBpZF9yZWdpc3Rlcl9zeXNyZWdbaV07DQo+ICsgICAg
ICAgIHVpbnQ2NF90ICpyZWc7DQo+ICsgICAgICAgIGludCByZXQ7DQo+ICsNCj4gKyAgICAgICAg
aWYgKCFzeXNyZWdkZXNjLT53cml0YWJsZV9tYXNrKSB7DQo+ICsgICAgICAgICAgICBjb250aW51
ZTsNCj4gKyAgICAgICAgfQ0KPiArDQo+ICsgICAgICAgIHJlZyA9ICZhaGNmLT5pc2FyLmlkcmVn
c1tpXTsNCj4gKyAgICAgICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoZmQsIHJlZywgaWRyZWdzX3N5
c3JlZ190b19rdm1fcmVnKHN5c3JlZykpOw0KPiArICAgICAgICB0cmFjZV9nZXRfaG9zdF9jcHVf
aWRyZWdzKHN5c3JlZ2Rlc2MtPm5hbWUsICpyZWcpOw0KPiArICAgICAgICBpZiAocmV0KSB7DQo+
ICsgICAgICAgICAgICBlcnJvcl9yZXBvcnQoIiVzIGVycm9yIHJlYWRpbmcgdmFsdWUgb2YgaG9z
dCAlcyByZWdpc3RlciAoJW0pIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNf
Xywgc3lzcmVnZGVzYy0+bmFtZSk7DQo+ICsNCj4gKyAgICAgICAgICAgIGVyciA9IHJldDsNCj4g
KyAgICAgICAgfQ0KPiArICAgIH0NCj4gKyAgICByZXR1cm4gZXJyOw0KPiArfQ0KPiArDQo+ICtz
dGF0aWMgdm9pZA0KPiAra3ZtX2FybV9nZXRfaG9zdF9jcHVfZmVhdHVyZXMoQVJNSG9zdENQVUZl
YXR1cmVzICphaGNmKQ0KPiB7DQo+ICAgICAvKiBJZGVudGlmeSB0aGUgZmVhdHVyZSBiaXRzIGNv
cnJlc3BvbmRpbmcgdG8gdGhlIGhvc3QgQ1BVLCBhbmQNCj4gICAgICAqIGZpbGwgb3V0IHRoZSBB
Uk1Ib3N0Q1BVQ2xhc3MgZmllbGRzIGFjY29yZGluZ2x5LiBUbyBkbyB0aGlzDQo+IEBAIC0zNzYs
NiArNDE0LDkgQEAgc3RhdGljIHZvaWQga3ZtX2FybV9nZXRfaG9zdF9jcHVfZmVhdHVyZXMoQVJN
SG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPiAgICAgICAgIFNFVF9JRFJFRygmYWhjZi0+aXNhciwg
SURfQUE2NFBGUjAsIDB4MDAwMDAwMTEpOyAvKiBFTDEmMCwgQUFyY2g2NCBvbmx5ICovDQo+ICAg
ICAgICAgZXJyID0gMDsNCj4gICAgIH0gZWxzZSB7DQo+ICsgICAgICAgIC8qIE1ha2Ugc3VyZSBh
bGwgd3JpdGFibGUgSUQgcmVnIHZhbHVlcyBhcmUgaW5pdGlhbGl6ZWQgKi8NCj4gKyAgICAgICAg
ZXJyIHw9IGdldF9ob3N0X2NwdV9pZHJlZ3MoZmQsIGFoY2YpOw0KPiArDQpQZXJoYXBzIGlmIHdl
IHJlYWQg4oCcYWxs4oCdIHRoZSBJRCByZWdpc3RlcnMsIHdlIHNob3VsZCBiZSBhYmxlIHRvIGdl
dCByaWQgb2YgYWxsIHRoZSBtYW51YWwgcmVhZHMgYmVsb3cuDQoNCj4gICAgICAgICBlcnIgfD0g
Z2V0X2hvc3RfY3B1X3JlZyhmZCwgYWhjZiwgSURfQUE2NFBGUjFfRUwxX0lEWCk7DQo+ICAgICAg
ICAgZXJyIHw9IGdldF9ob3N0X2NwdV9yZWcoZmQsIGFoY2YsIElEX0FBNjRQRlIyX0VMMV9JRFgp
Ow0KPiAgICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfcmVnKGZkLCBhaGNmLCBJRF9BQTY0U01G
UjBfRUwxX0lEWCk7DQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cyBiL3Rh
cmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+IGluZGV4IDg1MDJmYjMyNjUuLmMyNWQyYTExOTEgMTAw
NjQ0DQo+IC0tLSBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+ICsrKyBiL3RhcmdldC9hcm0v
dHJhY2UtZXZlbnRzDQo+IEBAIC0xMyw2ICsxMyw4IEBAIGFybV9ndF91cGRhdGVfaXJxKGludCB0
aW1lciwgaW50IGlycXN0YXRlKSAiZ3RfdXBkYXRlX2lycTogdGltZXIgJWQgaXJxc3RhdGUgJWQi
DQo+IA0KPiAjIGt2bS5jDQo+IGt2bV9hcm1fZml4dXBfbXNpX3JvdXRlKHVpbnQ2NF90IGlvdmEs
IHVpbnQ2NF90IGdwYSkgIk1TSSBpb3ZhID0gMHglIlBSSXg2NCIgaXMgdHJhbnNsYXRlZCBpbnRv
IDB4JSJQUkl4NjQNCj4gK2dldF9ob3N0X2NwdV9pZHJlZ3MoY29uc3QgY2hhciAqbmFtZSwgdWlu
dDY0X3QgdmFsdWUpICJzY3JhdGNoIHZjcHUgaG9zdCB2YWx1ZSBmb3IgJXMgaXMgMHglIlBSSXg2
NA0KPiAra3ZtX2FybV93cml0YWJsZV9pZHJlZ3NfdG9fY3ByZWdfbGlzdChjb25zdCBjaGFyICpu
YW1lLCB1aW50NjRfdCBwcmV2aW91cywgdWludDY0X3QgbmV3KSAiJXMgb3ZlcndyaXRlIGRlZmF1
bHQgMHglIlBSSXg2NCIgd2l0aCAweCXigJ1QUkl4NjQNCl5eIGxlYWtlZCBpbnRvIHRoaXMgY29t
bWl0Lg0KDQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0DQoNCj4gDQo+ICMgY3B1LmMNCj4gYXJtX2Nw
dV9yZXNldCh1aW50NjRfdCBtcF9hZmYpICJjcHUgJSIgUFJJdTY0DQo+IC0tIA0KPiAyLjUzLjAN
Cj4gDQoNCg==
