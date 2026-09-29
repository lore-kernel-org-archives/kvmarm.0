Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A33D88F2
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696260; cv=fail; b=ba9ZBLE9KbetYf2RrcTzsSTBgnJV24Xu40v0HW07tiWfspjZwelIiOAfIaAKifliASKBZp6mTo94dCNEFnFC1e2Ec4Aor8CoDgcB61/kF/q3hdsoSGSoPgvnJp0eGvNhBZIuZwmGqEcRGRxdZ6y16dRcnEHYCWRuKQp/t5LYyFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696260; c=relaxed/simple;
	bh=pWq0J7283FiYijXAIc+2HLYTkjWkZY4tGX50iQ0zCgA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hOOmis79ExE++Urvk6GsG0T9VzXf0HmQJCYMl/994tdjQQbADHXvEASfqp8ljA6W7NgWK+vtiuik7i2TtFxUwhipj9xWegFPT99aa8H2XhDyuPreawOJlOxtBXqRSVd+iqEO/hvmIpT9EgAEi4cy8/5fdPRTGIRwWykvipRGp3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OD7pb5fD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Lpof+iEo; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OD7pb5fD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Lpof+iEo"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAln2e170260;
	Tue, 29 Sep 2026 08:37:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pWq0J7283FiYijXAIc+2HLYTkjWkZY4tGX50iQ0zC
	gA=; b=OD7pb5fDRYvFQ/TOaZRE2qqOMvzOHlxrXMhfNTZiLnhk2eeKsbCj8L2EC
	G8JXF3nV6EMkEaHZKPbSN6t1ROZB3OkfCHR4ELT3KaTwoec7jZbORatBPYFaxPdd
	U0qlkJCoSAxyARvCXKV+4zMibQ4pqVi7mPCDO2N4XAnhtJpixVLzqGk3WIJVc7is
	oPsTjUzInMkJ3Q5ZrwYi/1lzIfxmpcyj4VxZ+o2/y6CPvqpeN/YveoADmUa/NLc1
	HuPF6+yEMvGHIBC3xuQQ3kZ6xF/nh1zTlbi48D03sKELRQs08gqeO3AZKO048Dro
	sruHqMuu1mSi2yHm93aauDeOrW3rQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023112.outbound.protection.outlook.com [40.107.201.112])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gyyxq2m3b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 08:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPnbbI/9TTNowFvIuwV5G/Ke34iAWTbNUqQ07W2En3jfSkSSgaVe83KIHPbtmXiC/GKuXG8uutQtZTHI0N9GY6Tk+0nmC/HX4rQk1Btnb5a3t0B6u5neRLhuxvVl0iy/DUZe1MAu44zV5x72/uXE+Dgt7QaAFUBLkpUyWt6+aSRZ8hw9yc7qWRamm2H/fDtSRlhNB1h+DhigJmUw9pb916nq4tPgg0hxWo+5Fuz4ZdDLinJG0MenWOSGi76iBFycLHxVQ+DDfvlhNO4uu27huprFAUpEz1iB/U3bEdb6hYLVxY6B/XtgBX0kq1q0sL14RNTWiuqAg/pCNikoEBIZBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWq0J7283FiYijXAIc+2HLYTkjWkZY4tGX50iQ0zCgA=;
 b=ky8XJ/YMndXXZ8nwKz1Xn+pdOBDHEQ6evFwF6zbvYLRjx51lQivhaf+VT2AwDYLaGlzz3HBMqg8sKQU6u1VUFBWq4ENgCh41eTsLwxjz54lV8L71HkdQlc9dWokMOtkMaRrZ5soLjYQor4tP/rSCOkWaBmWyfR4ZQIGnvr6eLRh2OUSTBbY1KUjrYUAMvMnq/cP5uCOToeUtzYn2kmrdnYOxQLTmpNajyD8R+ILKfdn32oQy8isxNm5ppqfS5z7A6JsLsxq4XJu302e12AsbrGsAop7udWzeA0AYf/cOFLSxGiE3Q3ruhAPf6lISIjz1rqr+a7Sk95i2cBlQJQS2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWq0J7283FiYijXAIc+2HLYTkjWkZY4tGX50iQ0zCgA=;
 b=Lpof+iEo7Uj29SuZaQ+2JgSphRRC+PRQDOzW2MhiFdcoERUD4guwSxDEDF9NxLHFf6XaILinDZPNbAK3IEgtrPoB/u4NIR24pAXBrXkUbLFagusqc7AS0S0zUb12wQf/46DSJrTVwg/YMOkqbIzxJUasvpew5KkMi7HXeZ+9tnW6YcNdoDQFJbn+HnKmq9um0uu+/kAvaiqhsxlxtqZoYETv98NtO1pmR824FhgdJ1jo4rvUbQH0L38liN7TO8jGGT/bFGXIkQrZCfyqbFD87S67ZAhsE9h4PwLbpbnudXTr1Qxca252jHe60fRuFJxR5WIerCEbxlSEJsH8hN3Hrg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB11588.namprd02.prod.outlook.com (2603:10b6:8:394::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Tue, 29 Sep
 2026 15:37:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 15:37:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@oss.qualcomm.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark
 Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com"
	<ping@khushitshah.com>,
        Sandesh Patel <sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 18/25] target/arm: add cpu-models-stub.c
Thread-Topic: [RFC PATCH v4 18/25] target/arm: add cpu-models-stub.c
Thread-Index: AQHdScVsAfRKbA/nJkOBM7iH8LvDw7blst8AgAAKYAA=
Date: Tue, 29 Sep 2026 15:37:23 +0000
Message-ID: <3FCBE48E-258D-4408-B1D2-29F2D1B7E341@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-19-khushit.shah@nutanix.com>
 <1391eb6b-b4e9-417e-a634-115fc1751166@oss.qualcomm.com>
In-Reply-To: <1391eb6b-b4e9-417e-a634-115fc1751166@oss.qualcomm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB11588:EE_
x-ms-office365-filtering-correlation-id: a5c5d5fc-f102-4654-fa7c-08df1e3f8e8e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|10067099003|56012099006|4143699003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 ZlV2rZ5JGqEZ9SGBqhcaCThDE81/sHLP1+cznoDfen/7u1fsAVSq3k7sxk3AWyI7Guj5aqyB3U+2F5w3eup/JUXAiF9snCwNpnQnuTbz5sibMUYfXIS+PShQ0MSj/Ww/3EHm4Ml8kNBiMKmiDVjLuQR3vxb3MGaVjRXVQzwkUOmFsU9vKRhJLFqWsIwzMGhKWw8BMky0RyP6o3ujH+0FlkBiDrgxpJ1x/bo7Pgur5AzetwlD3DfNlRfEXq79GAiTRWVnIB49tdO5DlvpyFp/k0k0ok/yvojjf0uwRZaSOL49eILlaek8sAGbhaNzFfzYEyQ0CC1C9TQ16JIHmU8V7uCxBgZtQtxEQb1MO/P4UcshM211i52tH9Hfswft4Df8EUVtOClTWz0llg7jb33KDzpwDsHThzxLl9bQA+70rHi/AGjOFD1dxRJqkjvJCN/CN1lQUMYtKLavY4EfBP7rbTFUlcHRMNqCwDbqz6Uc6QWBhYXmvVmFTG0y1TnbJw8VjWQeX97TSFxAvqIEiOqcmaZSOyHQCKKOFdUyi7NVM9/fKyGwQi3VYtIDOJXu3sfTOi+6zkY+7zdcUz8SUXoB1PXhQ2Ksep3qg7ECC6Amshx+ln+KDPlgFE2+ElFHWIONeACZHCoKKNRWN7rrivzOsoFNQ/A8GUR74MRfmJb33yDJlgJTugWnlBr+qUF590H6EI/a8G9kCnH9AsqydwIO1YVA0GtVkFtwb+G3iHyZa4w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q1JBTEwyU3Z2azc1TzlqVVorK09XUE80YTliRktrQncxQmYvTE5GSFBGT0pT?=
 =?utf-8?B?d2lvdXpvd1RVNEt5V2RMOUxQN2hYVjVxYzZDSzR0SEwwUjY0UHpXVWxXckho?=
 =?utf-8?B?NVpYa3c2ek9ZeGhVdVNMM2VMbjA1azVoMTN3dVZpZ01sd1dFSTQzUzV2T1Iw?=
 =?utf-8?B?TEVQT0Z3N3B6QmFBU29pMkYrTFNEbkxWcU1CcFJZd3pPSGxmTkxNTk5HejJz?=
 =?utf-8?B?UXgzczNwQnRpQ2llZzJxZTh3ZlR6akFhSHQ3RFErYXVrczMzc0M4TW5xcXF5?=
 =?utf-8?B?UVMvSmNVdWpxcWNOR3hoeGUxcUJFV081V1M5OVlUZVFEVFBBZzI3aEVYZTlo?=
 =?utf-8?B?UmM4bmFxaW1TZU9FNzBCOGV1ZUlldUN0TGNpOUdQYUsvMC9odkM4VjBSZkly?=
 =?utf-8?B?SHdBcUhlaHZzQnlGa2o4cnVTVXpUSUkyT3AwSEpCbzBoOHhzRjBNSC8xTzlV?=
 =?utf-8?B?TTI5Yk83MVQ1WmpyOStaQnhid3VzdEFNdmU5OG5qMFJ6QnA4bVlYQTI4TnJm?=
 =?utf-8?B?VzJCQ3NPM3pZbzhzaHB5MnZFWkZWMU1RY2JWMUN4cHBoK1ZPUG5UaWdWNFFM?=
 =?utf-8?B?ZWpRZFpmMFVFOXQxOXgyOTJQUjRuQTZsMEIxSDZMK0FaRTBJZHMvYWJKZTl6?=
 =?utf-8?B?TXdNSTQyTG1Kand2eW1lQXZ2S0VoY1R2Y3NUcWNzdWlpSjV0V3JPY2FGOVNa?=
 =?utf-8?B?NWZlcWxrTU11Mm1IMUFSV0NnWWdib0VXQzJaUlk0cU5QYW1TN0VNbmxSVG51?=
 =?utf-8?B?NHRYTDlETTc2RHdMQmJJK1pKOFVjSXcyM25IUW1Sd2R2VUNDODF2UStKbUlW?=
 =?utf-8?B?OGNOZnNKalN1SHR1QURtcXN2RlpEa3V2YjIyOHRuV0NzbmlyRWRHVGg2YU9j?=
 =?utf-8?B?cVV2ZlFlQlkrdm1mNk53Qk1hdHNJWkpVYStpanpzaUwvL2Y3S05NRzRuY2pj?=
 =?utf-8?B?aXJLc01ZQTB4N0p6RkQyT3MvTU5uSlZXSGkyNUw1MTUyc2lWckJ6SEY5K1py?=
 =?utf-8?B?RHc4T1djWExlWHFhSzJDMmNDVnFITnVid0NIN2Z3T3YwRVpDV0xSQU85Um5k?=
 =?utf-8?B?QW93azIyRFBJY2Q4ZENneHc5OVl0MXQ0SzdBSHVnamlyZHp2VWNTUlVveVAx?=
 =?utf-8?B?Q3RzaXhBVzJ2Mmc1VWJnTWMxK094U0pVbHFrdVhXa0l3MzROV2JJL1VVZU05?=
 =?utf-8?B?YllQcHUwL3J5NUtqSndxdVNhUSs0OVdwTHliY1BxMG9OTlYwVDlqWXR3ODd3?=
 =?utf-8?B?U3BHSXA5Y2QrRnFLekZ5dVFkRnA4djUrTzNsc0JNWW43aU1xTjNUWVlaam5D?=
 =?utf-8?B?ZTJUQW5rM2swQnRPaVpDYlRkcEZGUVJ5RjZ2b3dRUU43Z1krcVdSWWtCSXVy?=
 =?utf-8?B?YnFvQ1FVaVZONUZzMjg4eG95dlFGaDN3Rk9mU2FCemFuOXFKQnIxOEt5RVkv?=
 =?utf-8?B?UkVWZkI2SXA3K0ZhalBQMmhjbm1hTW5UMm4rYkYvejBxTzh5SU1YSUdTMEdJ?=
 =?utf-8?B?SnNEL1Zlelh1REhOS1VHSmJnMTVrcEtWK0kzMnB1Z1lRUGdEaHFPalAwSnRR?=
 =?utf-8?B?OXlWdTRCV3BHdGxJYWRpeUcyY0VRd3djc2daVmtDVlltYyt5bW44QVprVnhD?=
 =?utf-8?B?a2UvS2dQVndUc0sydUR0cFRnTVdkbk56TlhDSUFmdmt6SHcwdXBvSmduTXhC?=
 =?utf-8?B?V2hydWU4M3hWOFFwT0tRc2FWL3VIOVF3WVFRUmpYbE44VmVCK2ZlTjc5MTRz?=
 =?utf-8?B?VXRPcDZsL3V4RFF3VlFuaWF1K0xMd09zdVF5VmdJUk5EekZJZFVGN1BZSDho?=
 =?utf-8?B?dGRLT2ZqN04vVndLUDV2ODhyUjEvYnliZkFQaVQ2UGpra29WQVRxSllrNDdE?=
 =?utf-8?B?bTZnZEFTTGhuaGpwakNVZDJpRTBJU3hoWUZLZFFIZG8rMzVQamFjUXQ2ZFVo?=
 =?utf-8?B?RGd3ajJBZSsvdDcwdXQzQmlvOTFqOW1qV2ZKMXJLZzdwUElaOGFHTENiMWZl?=
 =?utf-8?B?bzRVYUlFb0xmL3k5aVJrOGRkdG1saXZWWi83c3JEOVRCZGRVdjNJYit2cW90?=
 =?utf-8?B?YlVOMyt1bzU0cjVRUE9heC96aXJ4ZnVhd1Q3Nml2cDEzaUFmYkJxVHlvaGJm?=
 =?utf-8?B?Mm90cEZDYkZvYUk0b3NrUm5wb2RlbHFjWWxuWVptc0o3MWxRTlRmUGdWczRx?=
 =?utf-8?B?VmhpRWxpRWxxWWlaTU82eXdLdUxNMTlMemxjcXJvV0NGc0VlMjZoOGF6WkM4?=
 =?utf-8?B?QzhQckVMMEhUbFdjYUR6RTRucTNHUndRdFJMNDY5ejIyOFlQVXpvVTVkTG1H?=
 =?utf-8?B?WlZ2TWpqMXRiNVZLNS9BSDluM04vVVlkVUFYSnZHQ29wT0ZrY0Q0L3RqQTBl?=
 =?utf-8?Q?5Ezb2Gw2o3Ws+DZQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A21F991B2AC59D4CA7E1D647028B24BB@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	XwPS6hNOxljFXK+eDfhTAjvJDUYrgYAcUU46QX91b4vdccbX6ReIV/U0iWFaAqzmLGXukFHqoTx0UTDpoPcTj2uenT4nVC4XPq180ulEs9ePNTaVkcgt6WtSVXsN1MMs8XA2oQH4D8Swsa5o2i7i5lUtAr7nCE8QEUFAqs/h8qXhhKam0Dri5Pd6Av+F3n3mPKNlVPo4cQO43ARWe5mDs5PnhXAaJC59MHXwOdkMWUJOhGkVIk/30Vz8nNYmH5fT4UezGkbstY0yUbnUItxc3z8938gBFzazFOW0ZwwhgLtYV5HFvt+7HGDsYPlOgUGXUDIGg/cWBh7I0w4PDWpYTQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c5d5fc-f102-4654-fa7c-08df1e3f8e8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 15:37:23.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLfrCK0PSQ1i3CiXBtaeCfkFAbihvIdb1wO25R1As3vQRHhHK5EVbCjog18eK2K3Qhui4cZO77XEv2/mLoOcwcEWyWWbFSmxfBk8Xl4/hzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB11588
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfX5aypedht4oBa
 JgO+ir9HJ6NWG4Vgw5kWZcIccxbPK+kdS3eTWlTxk3JL4VIaa5bPqak5iYSwVPZHqPqV1eeotWs
 Eew20eWO88ioffYHqw+AXQcBzh8OGEg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfX2G/3b8x+DqRi
 2EyGQB6ZqFTnQFxMqcA5w8dqb2fDRmLOe9E2t0jIPO7tAbys/+mKEsPYCIjKX7AjPfwG+/Jqd6e
 697rJHzlsdsjwcL0hFRBt7DW8UH0oGyHiRhFUyJmVh8OyH6qvpgXWMFt1l/Hamsl3CIH2VkXJAw
 ITX+zMxePgqZcimKKrOiWBD8IBZ12L8u0xPrQp2ctO3SOoRpehxYMCBWi/kahfTCKz8MqDmcI5k
 GkjvEYrwYULSj9nvfJnI+m3yJwdkpuXQvMMIFW4XiNlm6mrjQqeFe7tX1hitMoMWbObvXisfb4t
 XhZxWkkMzZ//vuGZSh21r4twSBhl8FwvKzByR1XHAnIDT5VlD7YH1F1LcBGO4G7R72KUy1NK/Ey
 1iGmACF5uRy5tJazkjYV1HdnFdFViO2P15ZNBlvaXBlE29sWIE8zcyxJcDx2eHSVoGBL3CYrFiO
 x+fW4Qnmg2SvSN14leg==
X-Proofpoint-ORIG-GUID: gG9kU9fz16js1mrKiW9MnsKlPdVxfUMR
X-Proofpoint-GUID: gG9kU9fz16js1mrKiW9MnsKlPdVxfUMR
X-Authority-Analysis: v=2.4 cv=KPfPn1Fo c=1 sm=1 tr=0 ts=6abbdb36 cx=c_pps
 a=D36mN1iAOhB4wCSKYjc05A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=EUspDBNiAAAA:8
 a=64Cc0HZtAAAA:8 a=yJgOITKhmeq8zAOeZ54A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjkgU2VwIDIwMjYsIGF0IDg6MzDigK9QTSwgUGhpbGlwcGUgTWF0aGlldS1EYXVk
w6kgPHBoaWxtZEBvc3MucXVhbGNvbW0uY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0K
PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiAy
MS85LzI2IDE0OjMyLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiBBZGQgY3B1LW1vZGVscy1zdHVi
LmMsIHdoaWNoIHdpbGwgYmUgcmVxdWlyZWQgdG8gYWRkIFFNUCBzdXBwb3J0Lg0KPj4gU2lnbmVk
LW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAtLS0N
Cj4+ICB0YXJnZXQvYXJtL2NwdS1tb2RlbHMtc3R1Yi5jIHwgMTMgKysrKysrKysrKysrKw0KPj4g
IHRhcmdldC9hcm0vbWVzb24uYnVpbGQgICAgICAgfCAgMSArDQo+PiAgMiBmaWxlcyBjaGFuZ2Vk
LCAxNCBpbnNlcnRpb25zKCspDQo+PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9hcm0vY3B1
LW1vZGVscy1zdHViLmMNCj4gDQo+IFNob3VsZG4ndCBiZSBuZWVkZWQgaWYgZ3VhcmRlZCBpbiBx
bXBfcXVlcnlfY3B1X21vZGVsX2V4cGFuc2lvbigpIGFzOg0KPiANCj4gICAgYm9vbCBuYW1lZF9t
b2RlbCA9IGZhbHNlOw0KPiANCj4gICAgaWYgKGt2bV9lbmFibGVkKCkpIHsNCj4gICAgICAgIG5h
bWVkX21vZGVsID0gYXJtX2ZpbmRfbW9kZWwobW9kZWwtPm5hbWUpICE9IE5VTEw7DQo+ICAgIH0N
Cg0KSGkgUGhpbGlwcGUsDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHRha2luZyBhIGxvb2sh
DQoNCkkgdHJpZWQgYWJvdmUgb24gcWVtdSBtYXN0ZXIgKyBzZXJpZXM7IFRoaXMgcmVzdWx0cyBp
bnRvOg0KDQpbMTAxLzExNV0gTGlua2luZyB0YXJnZXQgcWVtdS1zeXN0ZW0tYXJtDQpGQUlMRUQ6
IHFlbXUtc3lzdGVtLWFybSANCmNjIEBxZW11LXN5c3RlbS1hcm0ucnNwDQovdXNyL2Jpbi9sZDog
bGlic3lzdGVtX2FybS5hLnAvdGFyZ2V0X2FybV9hcm0tcW1wLWNtZHMuYy5vOiBpbiBmdW5jdGlv
biBgYXJtX2NwdV9hZGRfZGVmaW5pdGlvbic6DQovaG9tZS9haHYvcWVtdS11cHN0cmVhbS9idWls
ZC8uLi90YXJnZXQvYXJtL2FybS1xbXAtY21kcy5jOjM5MTooLnRleHQrMHhjOCk6IHVuZGVmaW5l
ZCByZWZlcmVuY2UgdG8gYGFybV9maW5kX21vZGVsJw0KL3Vzci9iaW4vbGQ6IGxpYnN5c3RlbV9h
cm0uYS5wL3RhcmdldF9hcm1fYXJtLXFtcC1jbWRzLmMubzogaW4gZnVuY3Rpb24gYHFtcF9xdWVy
eV9jcHVfbW9kZWxfZXhwYW5zaW9uJzoNCi9ob21lL2Fodi9xZW11LXVwc3RyZWFtL2J1aWxkLy4u
L3RhcmdldC9hcm0vYXJtLXFtcC1jbWRzLmM6MTg2OigudGV4dCsweGE1NCk6IHVuZGVmaW5lZCBy
ZWZlcmVuY2UgdG8gYGFybV9maW5kX21vZGVsJw0KY29sbGVjdDI6IGVycm9yOiBsZCByZXR1cm5l
ZCAxIGV4aXQgc3RhdHVzDQoNCklJVUMsIGt2bV9lbmFibGVkKCkgaXMgZXhwYW5kaW5nIHRvICAo
a3ZtX2FsbG93ZWQpIGhlcmUgc28gdGhlIGNhbGwgaXMgbm90IGVsaW1pbmF0ZWQuDQoNClRoYW5r
cywNCktodXNoaXQNCg0KDQo=
