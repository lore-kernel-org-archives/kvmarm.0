Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011012.outbound.protection.outlook.com [40.107.130.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E9F371CE0
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375021; cv=fail; b=QRA7LaZHCv8YeyeIw8QJ4lFBa9WhABQsHXKDvkKFL6xjWsoG+LWzqxjZlmKIwOpho5W3IAr7NNkydTCQB4l4nXtVYQ8vBb8xuJb5P73TcOGPfSW4aBeqWfSMQGwyotN1jq4Rq6AsN4kRf0j8tvvkYOfU0HfVpZS1E9rWFBC5KoM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375021; c=relaxed/simple;
	bh=r7GGHBeH2LkZGh8W4HrzweJg9jATaxjrkPAbYW6rLBY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=avUJgaxkJySbiBdOBYUa1HMwrqcwbte9hIPNhaQHJpPgMPRo25ukPuilloHE0qMlpUrSA4r1twYMmkWn0cC+KoEw/NrYU9PUHWu9IPe/fhdrkYAuODW8184LbpNKdYtX7XPvtqvjV5u0kZe1MehFotNphIO1FXH7HuPvm2K6Zlw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p7cyDNKx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p7cyDNKx; arc=fail smtp.client-ip=40.107.130.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p7cyDNKx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p7cyDNKx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=k/4+ZJQlQDgba0KgIsyeHrE0lGc5WpO5YCik/s3c+C7pEtEjs8ulsS9u6o4G8ztXH2jVr0Z2zzn9lmFu1XbLuzLCm5mZ3Xryuu3rL8Db+PDdrit3Ldd84/bjdLMNyzz2ze91cB7ytHxopml6IaevPC/cq+wTkYce35RFHOAo9Aug9mvlgCMH88BQ4Hmk8a2OFq9nMi2W3AKnn9Vc+1dRFEBpzRMBA7u3VPBHf9peCxVqfSAFoquAWKdBDKnw0u01dLlPeWRTFZxYkk8GEJCJuUj79zqGg3WIWcSBb5EPYHUKWDj/9MCfrIlJFuaReT/9hqxhfT8UzuU2YG4xzUtqGw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hmYzoE2sBytqysp9hBKlEiOU+PqKM2r5DruGOi/DTI=;
 b=XyWxHPquDMETc5d8Z48cVTvbAnMFNsOWCgSkeFsIe0+tXMZ6BXn2jJtVCbut1M0iP+ke5U3gUKz2dKjE5fO2zSk30a3exWcWhfKbkQjxrNDq28HWlTTD+9P+UqXlN1LJ2ChfCfX4WB09R1P1qEV+Z/bpzaGLkluQfI9mtO0Tq86aiuCuARqUY6OZHkMzXNo0n0CRi3XHCEwmK21yWn8wnHWG0HvVPZ7d2F7vpqJW5dIZ/uXIw2WkQ7OJ1zOaevhXUcZQXWEePztSnjRezy0CGKPA0TIv5eAFkVH6JU4DegEoztZwuY5rfbMCPJxVBbPt/JcLGODkbQ1wJgTmJi8LPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hmYzoE2sBytqysp9hBKlEiOU+PqKM2r5DruGOi/DTI=;
 b=p7cyDNKxefPxzpGWDMyG/gy6nCaVZ+4ZGmW+MZJGQIc0iZqOxYGCeC+P9TWHazlg32RwW6W5bFlU1uvdK16n0ZhlUekV1DKErWL/lE1h0Dyuv3AApBCThAj2nGnPLn2QaTSDFD1tfSEJ3s+q6dqX4edRdo52eAmyDFI2QdVRFDw=
Received: from CWLP265CA0445.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b7::12)
 by AS2PR08MB9689.eurprd08.prod.outlook.com (2603:10a6:20b:607::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:50:10 +0000
Received: from AMS0EPF000001AE.eurprd05.prod.outlook.com
 (2603:10a6:400:1b7:cafe::68) by CWLP265CA0445.outlook.office365.com
 (2603:10a6:400:1b7::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.16 via Frontend Transport; Thu, 21
 May 2026 14:50:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AE.mail.protection.outlook.com (10.167.16.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VY7V1UPtZOuKbRvTJBYrRR5T/if3mjZ16tUZRtFXRQ3awygu3IcaLxEf9AeCYAcJUwQGf7+W3hSBSuEr07W3MZNb9EKNL0VbJWhkFKz9hR6cA9HMSqwVJyGKylc5//mhQW9us6Vtj2F8lUuwjvU9fuf4BgQZp6ZJpQHGtME3GGrMwblVimanqb7ENiwI6V9K3G8kDyPRswR9jmdOsZbDGuaZoSloY3l0zTh5iHcXL0o0qJtTtMtV+18zoX8w06LHxZQJnjcB9pR+Sx+QAfU/lNjXj5EOJMGrGujl6e0IW5ox5O/VxAvt/FJyJlFOcjf2v9TjkzoAAvgTB3rb2LMFXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hmYzoE2sBytqysp9hBKlEiOU+PqKM2r5DruGOi/DTI=;
 b=m6wNhQV+kb/BkXVYByAI4PMU5oMfiiIM2g9jFRUOx5fWU7K21jYM0jUCgFKetY4qz4RI/OdnZ1cm/leKWml1pdcP3nylzmadw3MlYQLm2tWWtZ7kIxYIw2/EVYjE2VF5otF7YZeQZRC6BtdyEehO/yd7cT00gCdipLENPxhyrlynDVRc2i+qxcwEoPzU8oM+I+6eW+rMpTMA+ILALLisQss8yzapq1Ig/RrH+zhk3IJaZgGq7iiJ8RpwvQUSPIMohsI8S14Fm1UeQ965Tuiz7vz7chojyxfwnrbpH6iP0jIxN+yIWguS/OpfRkZdgH3KZYgduRjDUIC9CP9RW5o1+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hmYzoE2sBytqysp9hBKlEiOU+PqKM2r5DruGOi/DTI=;
 b=p7cyDNKxefPxzpGWDMyG/gy6nCaVZ+4ZGmW+MZJGQIc0iZqOxYGCeC+P9TWHazlg32RwW6W5bFlU1uvdK16n0ZhlUekV1DKErWL/lE1h0Dyuv3AApBCThAj2nGnPLn2QaTSDFD1tfSEJ3s+q6dqX4edRdo52eAmyDFI2QdVRFDw=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by AS8PR08MB6599.eurprd08.prod.outlook.com (2603:10a6:20b:332::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:49:07 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:49:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 00/39] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH v2 00/39] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHc6TD5DVqIRmivFEaE6S9O8CSQgQ==
Date: Thu, 21 May 2026 14:49:07 +0000
Message-ID: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|AS8PR08MB6599:EE_|AMS0EPF000001AE:EE_|AS2PR08MB9689:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bf3fcc0-48f7-4093-5f6a-08deb74841e6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|18002099003|56012099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 w3h9uTab+yw8903BVLDuZSOJX5y4loBn3YcuZNXEK5l3rKSqxhto6Ea2Jhg2CX7QWtBV0rSreIr/WiPlTs0Z7GOhp1s95edlrbnb3Jur9JjaF6b1SRriTdW1Yhrxq5HAXM/EDzfdVLkCGKPexnc/OnFGr6dszqT1zFwL0EfhQXom7ccJobBqr5YinJ0hIb7xweVMTi4v4EtzOQmSWATmNM9Bmuv1JU+CBzBIjbX3w9BQUylHIIKLN3grAjWHjUMA3M5tWjQdSpnVR9fYGalQVMqbakLdJG1xnTHMIVhKk0swn+FhhCpK/p17GemPTDndhZYn5AIDfR+xRx2MQ7jBT9yWJ7Fb9/9Q7t5ivGUiw3pwKPkA/rTWx23O2D3XWVv8KXotsHoZRnwqekPg34FYJNGu6uc8w/3wFhC5F8He57g87DxZ3pSPX/Jh2P5Iev/o4woTrv66NNg6ZTQVw7nZD62LiWxf+oCHdncGLdKjY6bVqFlPrY5yD0nnNoeDvQZaLWp9FXqia6dsOZdDWh1W+nZnNaYWSOxPJyke7uZwXBEg53+dTdBVpnq5pXaaTumqgyvlp4Sb/9j28f0NrZRBAcUyUhMptnpV69Obf4ix2nQ0LsizU39K5j3njr/RZ5f3uGpPRZT1b3I1NYOVGB9u8d5pwItwB1IgLyQnmY66LGw78wS7mkhoJMURF55Nwucv2ABTYgqVcO9Gtjx72yi1hrU9JF74af6jubCCq8GSnzDAzh9p1cmtM2K4EYYW69fU
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(18002099003)(56012099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 P6AtjowfRkUglcj3zfBcTrECm5vhPo2fA7syYvgn+M/YeQ7TqynikipVNkWUcoMOc6KfmdgoRNxdOlAylabpyut3BXjqGltP5m4IEy2ug17AjVyhwh0pfCxZvzBwKdGbXwUMXyEerexyf77EAA6sGnC9Nb4S8n0F8rmRSfAZAcDsl5jQkd+puOMAOdrg7yPN/fiUp+a02680NgJRff4kEoGEyi3vyNlMPRFv5TdVqmWMD7icUaQ0qZhFPfNYA7M8nxrL7hwNs8WVJ1pI+lYzugL7e43Lf2fk7Gp+FfBlYKv/4qnr8If3CtlBNvnMfuUAHVJfBnTdythzsspwNA7mFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6599
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3713edf9-8540-4257-8285-08deb7481c70
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|13003099007|56012099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	+v0vn1VMWLN9BhdNn+QUwVlqKXXNBuF6AQeziA62ohGrbM68T8Y9uwQfy070SpYZiCQ0H5p8Yxdh6bpxeGvhvxk57tUf4D5JbDVJqFqycYWlPROwuAvleaA5A7k+yhf627Vi3ttIxxCM0uf0ZMrGWLL08gZ8LpTsVFQHHOXSJ122GLx5mPDTH9rY2E8yPUj0AI+82DR2g8TJdfRe1AkfBScFPptTrFXTGDNdGf3ZbCSzoAMdZB9dodpU4MzsjY91ksJLfE9vWsbcNt5MFTFA9Eu/gW1bimi9fUEmxbqKZ6q2LbtsVjR+kQS1fD1LzDSvzkf8s49l1TPougEwetC7J1hkmHyC+4CQIlEGhcSme4xWEr8VzdcLhTyyKAnGCKklvd8yePN9nwgRi/JCWfN226PDrKkGbInYJ36R2/tMTetOcrDoctnppvWQHq5+6v3s6PrxDG6zKR9ezpsgOu5cT5jhL9FlFyK2ui95AaV4mrMlfhR1olZAhOvODCUSefN0mlBBi/ddM6mCFYNnqNH6v/CjILVA16kx2OXNdf4vRk/cOCRSbgqMhhgAQcA4T8eyY7pZR3uJWFAd2yUOQvjdxOLP+kbRq5ZZ+5jMY0faJlm5xNSwnQprogD9SJ//qm7YRFQKbeJKwMHrLEjaTFFWTroSqjMMffhcnNECpWTllm1nPukxF/Itr6OmuGQrjHi+4yL64J38ZQV+VuHbYc5FmgeRqfp5ccsmdDwlhsV/fG8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(13003099007)(56012099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rUS0J1MK/FVEyt3xo7GZL73RlogTlokSLiElCttjIIfIhHRLriJ8COVeyw8cXeO9im630IcAhGhbD7RjXqwKUMVGB3/evtXFyIQ6VPOhZjAG67oYaGE/cfTWUjwUhFFSIsXIueTzg4aEGQ1QSQHqnPzECItZbpmrLB2HitBulwxo3mnIFa6bvdHyq+NO+64rGeqPv6jN3OI5jPSj3lZuZwgsF3iKxReeae838nJOvlTdJ14nkeFuP/JfyGVhnW4TYMAXv4mnUMfQtdWa/1fe939DdTekv6nMwg75KqLHlRowjHicIDYAK6PS4XXayhAvWP2yBSkzSEhJvkMm3SAYlSTtPcSZc+bfjf0Wccr8Fr0sgJIrsN5bblx/YdwAn3mY+bVEFV6vAiVAJvR1Xu2c5kSGpFIK6YUzjJkGF4BBXv8znJoZQ2Z7xCZhheTpqnB0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:50:10.3358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf3fcc0-48f7-4093-5f6a-08deb74841e6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9689

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can
make use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described
in Lorenzo's GICv5 Linux software enablement guide [4]. In addition,
GICv5 IPIs are typically implemented as LPIs, so LPI support is what
makes guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is not
included here.

The IRS is created as part of the vgic-v5 device, and is not a
separate KVM device. This is because implementing the CPU interface
alone would limit a guest to a single vCPU and PPIs only. Hence, the
IRS is bundled into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE residency,
and VPE doorbells. It also adds an emulated IRS MMIO interface for the
guest, together with the UAPI needed for userspace to configure the IRS
address and to save/restore the IRS and IST state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and guest IST backing storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, SWERR are not supported and are RAZ/WI.

* SPI injection support using GIC VDPEND, together with tracking of
  in-flight SPIs so that deactivation notifiers can still be handled.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

Please pay close attention to the save/restore interface and ordering,
in particular to make sure that no guest state has been omitted.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, and does not add MSI
support. It also does not add GICv5 ITS emulation.

These changes are based on v7.1-rc4. They presume the existence of the
still-under-review changes in [6]. I've pushed the full set of changes
to a branch at [7].

Changes since v1 [8]:

* Added native GICv5 KVM setup without a maintenance IRQ, plus ACPI KVM
  probing for GICv5 hosts.

* Completed and moved IRS MMIO register definitions earlier in the
  series.

* Reworked IRS capability discovery around the irqchip-provided config
  frame.

* Kept GICv5-host vCPU limits per VGIC model: native vGICv5 uses IRS
  VPE capacity, while legacy vGICv3 keeps its fixed limit.

* Consolidated VMTE, VPE, IST, and doorbell lifecycle handling.

* Reworked VPE residency and doorbell programming around WFI and the
  effective priority mask.

* Tightened GICv5 SPI sizing and routing, including the 32-SPI minimum
  and SPI/irqfd validation.

* Hardened in-flight SPI handling, including irqsave IRS MMIO locking
  and allocation-free state foldback.

* Reworked IRS/IST save/restore semantics and documented the migration
  ordering.

Thanks for taking the time to look at these changes. Apologies for the
size of the series, but this is a rather hard set to disentangle and
review separately!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://lore.kernel.org/all/20260520091949.542365-1-maz@kernel.org/
[7] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_=
v2
[8] https://lore.kernel.org/all/20260427160547.3129448-1-sascha.bischoff@ar=
m.com/

Sascha Bischoff (39):
  irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
  irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
  irqchip/gic-v5: Setup gic_kvm_info on ACPI hosts
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create & manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Initialise per-VM IRS state
  KVM: arm64: gic-v5: Register the IRS IODEV
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Introduce SPI AP list
  KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls
  KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
  KVM: arm64: gic: Introduce set_pending_state() to irq_op
  KVM: arm64: gic-v5: Support SPI injection
  Documentation: KVM: Extend VGICv5 docs for KVM_VGIC_V5_ADDR_TYPE_IRS
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vcpu PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences

 .../virt/kvm/devices/arm-vgic-v5.rst          |  237 ++-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_hyp.h              |    4 +
 arch/arm64/include/asm/sysreg.h               |   18 +-
 arch/arm64/include/uapi/asm/kvm.h             |    7 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   34 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   55 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |  112 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   20 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1056 ++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  252 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1831 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  113 +
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1191 ++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   39 +-
 arch/arm64/kvm/vgic/vgic.h                    |   21 +-
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
 drivers/irqchip/irq-gic-v5.c                  |  117 +-
 include/kvm/arm_vgic.h                        |  165 +-
 include/linux/irqchip/arm-gic-v5.h            |  220 +-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |    7 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   |    6 +
 .../selftests/kvm/include/arm64/gic_v5.h      |    3 +
 31 files changed, 5928 insertions(+), 150 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1=
