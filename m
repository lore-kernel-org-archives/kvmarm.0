Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013012.outbound.protection.outlook.com [52.101.83.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1D41DFFD
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 09:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489146; cv=fail; b=nDVhkoxApTPhxJVhBYrrZIOyMFdXb77aNUXikuifOkCuSvs/vh6+jvXo5jungLSpFIZKWPpQkX29eXqsuu1W388WiwER/sX/8ctR1X6zfeLaYYUF5xv2AUhYmna9+MQHtqUeJ+5LZqjtSQ4yqIQpkSy+AJmnfONN0iFE9Eon18M=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489146; c=relaxed/simple;
	bh=S/9Z8/oiJBMumbivNDb8zZR8z50lnnECa9ZdLLfFpJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YG1eEYlSBGbpG+caDF0imJ4rifcJtOzOHXXI0Z8wDIdfuGht4oMgW+p7k2285DyQ8mDzMqoh+8KnrGk+hnmUz6l7hNhwUReZ3IlEf7ipVRXxZ4O2nyil8TbSdz6UvZGZOxcXXW8a2gqZwITTxEVzt6u53OGCZKblimRir3J+eJ0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mWc+oGka; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mWc+oGka; arc=fail smtp.client-ip=52.101.83.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mWc+oGka";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mWc+oGka"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UcxfFwjaYCcZlTOnwqhn4fp+UQhRnAjKsDxGK+EpfWBjFbLGS+hIGIBLRot3Y1XFGHp29DveRc3zRBvpF7aRprz3/u1jVIZ2NL/ZkVlXvL3kHaen5ynUgabrMB4FSGjxbxKx6p0hS+TeS+BPWLkUUITlkHL1zdOzzrvQXbExa5m0Rq2aGKElE31ZsdMlMw7ko+/HL0JPIyILFbPDaiyA4zK1+fQfS2aSIuaiYkvkafxXL8oj1/MXcv2w0RiWK0u0ZT5/k2UHeAHWpn2uPRg0TGNcooxSgdhNlaheL+grBOVEP0DY3Vng/5uvqxLip50Jur/eXssczzAMqrVjh+P2cA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/9Z8/oiJBMumbivNDb8zZR8z50lnnECa9ZdLLfFpJE=;
 b=sD1qnGtjy7gBlRZahpsAiX6aceG3HpOnlHCCbTfm52d4Mxz/MGeU6wY/UCX6oeOA26CwKBqUG0+BZOKvF7XgTHV3uVMy/ZdRH4mq0asc64UUpxuwbo2kMppwWZuPlCsuIATmx2ZOWDpSbM9Nc74uZYgGqM0uV8axp0vc6yVG0nO4/HoMKl7bV89F+hloD9TvTEFQHMaEVLiZ6M5Ko+cPRnaj3L3H7YiI9bhGPC2GD5mk3gWhIyomaAdK3owo296XjSa/9iBpl62gPoHW8YA+yu9oepOaHyYWv3aQUe0CXgOMTdGU7VkSq4WOJInaBH+KZQcidlNLJH0SQAqsgYJXTg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/9Z8/oiJBMumbivNDb8zZR8z50lnnECa9ZdLLfFpJE=;
 b=mWc+oGkavrlGMDBPeSL3RiaF+eci/FiodWdXAFqCk54Omm8r1UmVx7fYOr3c7km4VAmo9P/JNnwFn1xbaAg5nW8RYyzfhYYV3MBHDMrB/VIf8s9S/THQrUYW7uNK6EgDOrrFvhZBWyvzdGgNbiDmfdEGlep34TBTi3S2B/lGfnI=
Received: from DU7PR01CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::17) by AS8PR08MB8568.eurprd08.prod.outlook.com
 (2603:10a6:20b:565::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:12:15 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::1) by DU7PR01CA0048.outlook.office365.com
 (2603:10a6:10:50e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 09:12:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:12:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LgZM4L30lb/WrtYNeV1doR3o07aFh0qvzCRDvJikrrwyHxPYxnjXfrQRlzE/EzgNt/GdC5/ER7OgehZsbaKC3QVscrjdX49oXM3b5HSG9+kv1BZzbAHgNS1tcDZC6GBOw392wd1AB8Pjjv6gF375g/8giDfHyPctis0oICViqFn53V5fceq23xFShwOYdQnU0FEqpJwdCvrscPHWNAxQfxWJqCkZ9cZTO6VB5pz/FN89HFv8sg/C5GOCnP7Do5/8+4Zf38xS4TTSIWPKFrh8A4uopBvpL2vDFte5L+GksEVQNqpvdfIj3OOaGaCU3iN4+DN/wVYYJzScJqDEvkOQnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/9Z8/oiJBMumbivNDb8zZR8z50lnnECa9ZdLLfFpJE=;
 b=SYVfGIT28YiR7s6Ph2NAvg3hdJ+VRkAr3uguQlKcEnTAnEepVhQ5m1E85d3aQiUrEldPnANsY+Vh5I6o8KqDZaaZJ7aF2QFTDmmsu4IR0J/xfcaztotFA6UsivceqHYeBE9a+gWKqTlzHqCklAvsUcc2EL41dIUlopGTJx+ndUZZ+1Q+RmMmnOYuE8oXq4TU/UzpfkyZcLa0M8xAL+A3j77FbIWtSMNAdbmUbk240+i4fOFPaeOF68hf6NJhZMu6VqdIURzwx6O3seeLeHyFSpg92LIsi+UnJSFVkuKI5o+Q4myqmeTgK/lm4Sr7DG/vjMYr6DhVrMIUr9px//oL/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/9Z8/oiJBMumbivNDb8zZR8z50lnnECa9ZdLLfFpJE=;
 b=mWc+oGkavrlGMDBPeSL3RiaF+eci/FiodWdXAFqCk54Omm8r1UmVx7fYOr3c7km4VAmo9P/JNnwFn1xbaAg5nW8RYyzfhYYV3MBHDMrB/VIf8s9S/THQrUYW7uNK6EgDOrrFvhZBWyvzdGgNbiDmfdEGlep34TBTi3S2B/lGfnI=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM9PR08MB5908.eurprd08.prod.outlook.com (2603:10a6:20b:283::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:11:12 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:11:12 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Topic: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHdG1pP7ycmpHFnI0y4bfkBKKuLtraBq4iAgAW20oA=
Date: Fri, 31 Jul 2026 09:11:12 +0000
Message-ID: <ceff3d0d3af601df0f63e8860adcb02e5d6c7473.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-11-sascha.bischoff@arm.com>
	 <CA+EHjTz+msYV6L0ydQR7Qw6LA8ASucpkumAqxrO36KUhvRDW2A@mail.gmail.com>
In-Reply-To:
 <CA+EHjTz+msYV6L0ydQR7Qw6LA8ASucpkumAqxrO36KUhvRDW2A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM9PR08MB5908:EE_|DB5PEPF00014B94:EE_|AS8PR08MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 43bee7ee-fa91-4566-c01a-08deeee3d055
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Pejwh7ympwxJNebeC8Cxrr0r27jQx8uDMRTCAfxZ67Ad/73xaNqP7Av6lm/hCgTKjEwRxTNjKeqRRRe1TrksGYImOc/mz75SudWeJXdI6+STa8WjI/vkH81j5miAsZzPNEC5tIot/KtnZejx8Atsl4iey4vX76IsUh43F9kmYtCfEAfXzEJoTV3g04Q8hf2oOdgNDi7ZBqY8bVzCCWDxvBdomc/042jywCtOkqix/zuYxhplp3JyML5s6rFpcFpIFRX+Fa71iC/RQakp77bQdc0pIoNpeBwFSABZAGNTOBHIiqXZldTfX/WQiJdwg6X8BnAYXVITNusDw0i0U/GR7VPbME0D7oM87hw6vt+uK+yejp2//8jbpbgh6HLE0W7CDMtj/0Q7TsuHql/NhdAEdP7emiJylNSagNAGO653By+N4Bm4DQCHxDnZmfpjp6Cn8G4ATbz8Q6hS7PAeyly3ZcWicwXIiSZoOkQoSvi7T+GX0Hfqz4dpixgRSt9vgr3OPfIkYsY+6+2vf+VyURMJabEr4U/Bz3BNAJ6WdkQp552qlaxoApkYjY7rijNxq+PdRJmsHzo9Y+vwDeRWHVluDPBGSRh7WnuIvLeQG9oKPJEUYEpftBaxg7aP/QxEiYy8YdVd8DYgzkWdVelNvw4ZD5fAJ6MwNTIqQRi/axtJHQ3oKRjMtoX1F9YLL+1PMZA1Ro7zi2h/2CSw4ArwDqEqUef4A5YlzC4vuw1mwO5y95M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C539D3828B6D944B6075090E8FFCEB5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 otzf1txDx8YUUu/OjQGbK/axqGnEKZQ1056vGJWeGiTyj4QeqzxDLvHVYB8p4mgNtAxDKO7a9sgwnx7JshLnpWEE/TE8W/24qhAEBMOB9JnrvxgjDqwwgfT2SzxGP2E3MxtKord8C13mGyQMyWJn7F9XxsAB5QQgMyB1IOnlaEw4Hg1jhBSkXGgU+KCJ+00Etw2hiutLdWyoUdpG1kaOkhjEsT5dhFGXG5uGEQiIKvEJmND/rQ5vpT+vokoSEGQYr/ky2cHNL9+RMUlYJFKM1D8NDfaoCmjyOkeIJPFqT/e+t2sHWa/Rz73mMuydYa5tRLS4VuGbGsdEt//kk01yWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5908
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5bb306de-a24b-4863-74a8-08deeee3aaf9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|35042699022|36860700016|23010399003|376014|4143699003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6eWEaCgk26ssygDQquGK+Eph9CRWcbPT9HDgVD9PYBmp+YPzYRQ3K55D53B0qjHiDdwF/4sduZRuh8s+JH1rkRN7QrvFwNuVCdgZp37N7gBh1DRmCamlnQqJKvi3brp2FOFrMA5r82gDYyxK+cB+Wsd6bQDZ+eVS8ZOMusuIA/Vq9V5hVYIKlvSkhg7kkrY6gHUEna+cvD+Wi1dhlDIRJ3i0BUA4ea7qICw9gbguW+Db/lBji8ilfFvR5DOFzKY7ESi1xC9nwr9nCfY7R2GgyCPPhgs36z+TC2o3ZjQHVimasRl9w1gR5VFM1yPZFGnUIMsAWI/oz8jIENm3zuS8reWQf8c356kEq50H905DTYW4ZS3B6+mfPl91WBH+4MAzp8T/FQ3GYgsctJlsAP6jyMUjAF3J2m9tlw6VgH+VdfPlA/mjP0GXZ9GYctaA5s9lypDuJMmxhq4PXUYnqPRpzldqq5ZRP1F383gv388h2Wt2KUdsNLvN1FP6Eogt/ofBTdA+l0tCtMsdM+/RFqoj1rGwE0+DQqRKYYaQdm7Fw95OvvUCHg8JF7xYuMc/HjfRDVx3HhwComy+GgdmbYDnjoNOJpzMVYC/57X4omxayJ2RIo3r86ucHXGWmEgGkC8bRUNXi/7rQBO7r8N83TPte+qc6omLPomu93B8vskPflAIIna8h7tlpkK/aA+DMlG9AYKRuCapimFREoXEs5KDkQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(35042699022)(36860700016)(23010399003)(376014)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KAcri2yto9tSsOhWCxOUEF+VCu49HCEpdGPXe1GEJDCvT8TYFOG0TzZq4zbn3SQxeGsGZINmobrrhRk2lpuw+TycT3St1I/hM0futarBJOqGA31lB0wzFd80xGGTqhxa6VWrtpeIUVK404b9ng4ODJ/g2H0mF5ON7f3V60o5Lt9Ha9ajWmHO2a/SOCiw6o6YylQW8wbCjKgpbj0NHGfVcTjodfKf/LMRAGoyh+coVjLti0pDF4DdCJvqWE4iH+laFXltw/OOzy/RLYA6OTa8SgEmsggsA+S9t3VUxIWJ6zbI2tnuSjn4+CrB8Znv5rTcr7Mp1JMQrh3C1FYHgEeyNjCFPHAHPl8IMTLys8qSXEJf7Pzty19lb/rJyMAECqrPRu2+OX7zG0Y4jYAjsC3NcOvjAQ9IXUQmsXyUH/Divi85XpUR9b+zAFfnI2rXc/pT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:12:15.2470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bee7ee-fa91-4566-c01a-08deeee3d055
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8568

SGkgRnVhZCwNCg0KT24gTW9uLCAyMDI2LTA3LTI3IGF0IDE4OjU1ICswMTAwLCBGdWFkIFRhYmJh
IHdyb3RlOg0KPiBIaSBTYXNjaGEsDQo+IA0KPiBPbiBGcmksIDI0IEp1bCAyMDI2IGF0IDExOjUy
LCBTYXNjaGEgQmlzY2hvZmYNCj4gPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPiB3cm90ZToNCj4g
Li4uDQo+ID4gK3N0YXRpYyBpbnQgdmdpY192NV9hbGxvY19saW5lYXJfaXN0KHN0cnVjdCBrdm0g
Kmt2bSwgYm9vbCBzcGlfaXN0LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaWRfYml0
cywgdW5zaWduZWQNCj4gPiBpbnQgaXN0c3opDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgIGNv
bnN0IHNpemVfdCBuID0gaWRfYml0cyArIDEgKyBpc3RzejsNCj4gLi4uDQo+ID4gK8KgwqDCoMKg
wqDCoCBsMXN6ID0gQklUKG4gKyAxKTsNCj4gPiArwqDCoMKgwqDCoMKgIGlzdCA9IGt6YWxsb2Mo
bDFzeiwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gLi4uDQo+ID4gK3N0YXRpYyBpbnQgdmdpY192
NV9hbGxvY19sMV9pc3Qoc3RydWN0IGt2bSAqa3ZtLCB1bnNpZ25lZCBpbnQNCj4gPiBpZF9iaXRz
LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IGlzdHN6LCB1bnNpZ25lZCBpbnQNCj4gPiBsMnN6KQ0K
PiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoCBjb25zdCBzaXplX3QgbiA9wqAgbWF4KDUsIGlkX2Jp
dHMgLSAoKDEwIC0gaXN0c3opICsgKDIgKg0KPiA+IGwyc3opKSArIDMgLSAxKTsNCj4gPiArwqDC
oMKgwqDCoMKgIHUzMiB2bV9pZCA9IHZnaWNfdjVfdm1faWQoa3ZtKTsNCj4gPiArwqDCoMKgwqDC
oMKgIGNvbnN0IHUzMiBsMV9zaXplID0gQklUKG4gKyAxKTsNCj4gDQo+IEkgdGhpbmsgdGhlIGxp
bmVhciBwYXRoIG1pZ2h0IGJlIG1pc3NpbmcgdGhlIGZsb29yIHRoYXQgdGhpcyBvbmUNCj4gYXBw
bGllcy4gVGhlIGhvc3QgZHJpdmVyIGtlZXBzIGl0IG9uIGl0cyBvd24gbGluZWFyIHBhdGggdG9v
Og0KPiBgZ2ljdjVfaXJzX2luaXRfaXN0X2xpbmVhcigpYCB1c2VzIGBuID0gbWF4KDUsIGxwaV9p
ZF9iaXRzICsgMSArDQo+IGlzdHN6KWAuDQoNCkFoLCB5ZXMuIFJpZ2h0IHlvdSBhcmUhIFRoYW5r
cyBmb3IgY2F0Y2hpbmcgdGhhdCBvbmUuIEkndmUgYWRkZWQgaW4gdGhlDQpzYW1lIGxvd2VyIGxp
bWl0Lg0KDQo+IA0KPiBXaXRob3V0IHRoZSBmbG9vciB0aGUgYWxsb2NhdGlvbiBpcyB1bmRlciA2
NCBieXRlcyB3aGVuZXZlciBgaWRfYml0cw0KPiArDQo+IDEgKyBpc3RzeiA8IDVgLCBhbmQgYHZn
aWNfdjVfaXN0X2lzdHN6KClgIGdpdmVzIGFuIGBpc3RzemAgb2YgMCBvbiBhDQo+IGhvc3Qgd2l0
aG91dCBtZXRhZGF0YSBzdXBwb3J0LiBgQVJDSF9LTUFMTE9DX01JTkFMSUdOYCBpcyA4IG9uIGFy
bTY0LA0KPiBzbyBhIDQgdG8gMzIgYnl0ZSBhbGxvY2F0aW9uIGlzIG5vdCBuZWNlc3NhcmlseSA2
NC1ieXRlIGFsaWduZWQsIGFuZA0KPiBgdmdpY192NV92bXRlX2Fzc2lnbl9pc3QoKWAgcmVqZWN0
cyB0aGF0IGFnYWluc3QNCj4gYEdJQ1Y1X1ZNVEVMMkVfSVNUX0FERFJgLiBJdCBkZXBlbmRzIG9u
IHdoZXJlIHRoZSBzbGFiIHBsYWNlcyB0aGUNCj4gYWxsb2NhdGlvbiwgc28gaXQgaXMgaW50ZXJt
aXR0ZW50IHJhdGhlciB0aGFuIHJlbGlhYmxlLg0KDQpXaGljaCwgZnJhbmtseSwgaXMgd29yc2Ug
dGhhbiBpdCBjb25zaXN0ZW50bHkgZmFpbGluZyBJTU8sIHNvIHRoYW5rcw0KYWdhaW4gZm9yIHNw
b3R0aW5nIHRoYXQgb25lLg0KDQo+IA0KPiBUaGUgcmVqZWN0aW9uIGFsc28gbG9ncyB3aXRoIGFu
IHVucmF0ZWxpbWl0ZWQgYGt2bV9lcnIoKWAsIG9uIGEgcGF0aA0KPiB0aGUgZ3Vlc3QgY2FuIGRy
aXZlIHJlcGVhdGVkbHkuDQoNClllYWgsIHRoYXQncyBub3QgaWRlYWwuIEkndmUga2VwdCB0aGUg
ZXJyb3IgaW4gYXMgdGhpbmdzIHJlYWxseSBoYXZlDQpicm9rZW4gaW4gdGhpcyBjYXNlLCBidXQg
SSd2ZSBtYWRlIGl0IGEgcHJfZXJyX3JhdGVsaW1pdGVkKCkgaW5zdGVhZC4NCg0KPiANCj4gVGhp
cyBuZWVkcyB0aGUgaG9zdCBJUlMgdG8gcmVwb3J0IGEgYE1JTl9MUElfSURfQklUU2AgbG93IGVu
b3VnaCB0bw0KPiByZWFjaCBpdCwgc2luY2UgYHZnaWNfdjVfaXN0X2NmZ3JfdmFsaWQoKWAgcmVq
ZWN0cyBhbiBgbHBpX2lkX2JpdHNgDQo+IGJlbG93IGBpcnMtPmlkcjIubWluX2xwaV9pZF9iaXRz
YC4NCg0KR2l2ZW4gdGhhdCB0aGVyZSdzIG5vdCBhIGxvd2VyIGxpbWl0IGZvciB0aGUgZmllbGQs
IGl0IGlzIHdvcnRoDQpndWFyZGluZyBhZ2FpbnN0LiBKdXN0IGluIGNhc2UuDQoNCj4gDQo+IENo
ZWVycywNCj4gL2Z1YWQNCg0KVGhhbmtzLA0KU2FzY2hhDQo=
