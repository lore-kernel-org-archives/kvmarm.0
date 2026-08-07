Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011041.outbound.protection.outlook.com [40.107.130.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABA941D4EA
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101964; cv=fail; b=DeGnLu0kCsr6+4kpaVhLc45jngP4N+k8L5+EmpxoZE/on6DbKjg+v5WxMeb+IWQ2QdmMoo93jhU5eN86tEeK0gGMEOF2q3ci6o7Nkxq8j7wzITxG2Mp5gTCGkPtRlxjbXizkc+2kb/bjHRo6pSzgH7cJiaEzxAtbTzHOj5XD1Hw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101964; c=relaxed/simple;
	bh=tg7tcnysi0tAK8V0fqWHRiFGuPrJmNrRlAA9IxQkZAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RibSquQf/r6mAjzh3wgPqH9X14GPn1HAmMZP6BsUXZpm563/qJNDt2h0ZBdWBZnlrSU9N5O2lQjADmq4fFBezNhrlSMCpPi7QJoFsoHxRwKF7NYwTizOcHZ/4fVBCObML0xAHwUCsCpCRNeGEo8DEtS5uYs6kKczMS5AcRnivks=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fnBYwtr3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fnBYwtr3; arc=fail smtp.client-ip=40.107.130.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fnBYwtr3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fnBYwtr3"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QctpSPeLyeN5D+esHiI8RttaQM/IEdW6xsOcf8FVYPGtL0K1cq6buC9GMyWAZw1bLzhhsd2wSarOCH5hffKBpyatHtWZEDHwjUr7sLBKt3q2kZOOoU73PqdvBrGweSAiFeZYjt7ueGOSosZEpkS8O0wEElgaBz9Kk20KdkQm/VRU/4OWB6EHdrQsaVKGj01YFuiXnVLjj8tVtg8zRDelGRev7kY7towegnMvqbEzaK8sRvIehm2V/Ar66LKdGyfoXsn96eXSIZ+/2lMluH9MtiASZYFbFIvpH5E2meFUVMkQjWCZ1kay0GcwWKdJCHP08I+CA4Aspa7xxYCggeZVXQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ezvd7b/EKOoXMUNbqkzd1gcBMCVjiXGkq/jOULrPxWs=;
 b=NAOdf/UWvWg8uDNTef4CnfVFAMaehXT5H6ziScJ6MHI4O4sWEhsi7V2mH0bSNBMRfJSz8ymbv0+HNA6/PuGnFSZIfr6rzNQt6wfER5Hg+bf+T6Ky+PLrS2PZeMYHTDhd8s0Yy1bFLk3ub6QmRHfpj4Y1HCfAIBwefZY55wzt4oyWBIqOzgXZMYSqrXrgKTWeF9Y6NbwYp9qNrifVOIgm+1SzXMRg2GpU9Gj2JGzUCJ9FHg5BmopZqmrYkXG6Lp3imge0SqBnfnmUnr3xVkDSRGyLF0RoqlJVBWvTskReo7Km+JYxbOr9ksxb4DdwNIj8orGRZ69hKFHG3+ikt8+Zzw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ezvd7b/EKOoXMUNbqkzd1gcBMCVjiXGkq/jOULrPxWs=;
 b=fnBYwtr3myyWq57tJ31cdCSKNgWpeI+MsjXEVlrMD5gTcIWLnHKd302ZhjW32S+VqVAMognI5BO7bY8Kasu6ZCPDE+nnhf46enooDclXxsV1wbFSoaBoeeIpuHoVbBGuZbBzIzMDCQ2YebuCzCGLLmeNyYLjTUuygaQyGICOUAk=
Received: from AS4P190CA0040.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d1::20)
 by DU0PR08MB9370.eurprd08.prod.outlook.com (2603:10a6:10:420::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.22; Fri, 7 Aug
 2026 11:25:55 +0000
Received: from AMS1EPF0000008F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d1:cafe::14) by AS4P190CA0040.outlook.office365.com
 (2603:10a6:20b:5d1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008F.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:25:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YVmbK4P6JcyCDJqI+laXcJVUjaTi9/iwMU1GTpSKmmRzhdSyiBtJcu0Xn4f7/Lp/VKO1XEglRtVm7F9+lVsu+m4rFc8fllWeaLJoDxEy+eapW+QG5lc7JoFR+6HxzCZUmfvceu9VciPgskWQ/zEq+bduAN1EVQb2R8dW7LTPX5QHez7RLu7UKfZ1ZHTzVB1LsRkdKhgxrSsOetETvnfNk8x8NNF3TX/fZoGPEhfq7J0sdIJy8ulQaYCj+mLxO/4srcwwC4xHI8FUyIzpN597h+mn2iM/PP8lFeYUKZQqhnkEsl9fQftBJDpckwnXQg/15qTTj6vF7w31HPzmGMYayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ezvd7b/EKOoXMUNbqkzd1gcBMCVjiXGkq/jOULrPxWs=;
 b=kcG0w8cDL0mL2Lr0FTHjRe1f6vp17ZhPjDm8WOR13P/iBtKyb8EI/AEG+616EGXrZbq9iAWadHm3gJ8pBuXgUfyQ9QucsZxFT3xzxonWjxZyBeXQU9AW9vBAAu23OSsp3Uy3rOX6xTlRqCIr3Ijokm5+89kz2GcsSbWAAqT4vJsqXWqT9E5KVxRhQMlFqhE18RB6e1IfpuVmOcoQOcCwOPX70Huq0ix7/RNhBtGZzSRYDXoszkzBZQt9QqtDL3p4dLI1qcnvqFLJuc4IAT/n+ptA/miK/71fyvrpCEZAulBf2yCmUu1eJIISINVxFsrfvsIDL7hqyEatJW2hZf4Xmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ezvd7b/EKOoXMUNbqkzd1gcBMCVjiXGkq/jOULrPxWs=;
 b=fnBYwtr3myyWq57tJ31cdCSKNgWpeI+MsjXEVlrMD5gTcIWLnHKd302ZhjW32S+VqVAMognI5BO7bY8Kasu6ZCPDE+nnhf46enooDclXxsV1wbFSoaBoeeIpuHoVbBGuZbBzIzMDCQ2YebuCzCGLLmeNyYLjTUuygaQyGICOUAk=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:25:19 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:25:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 25/49] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Topic: [PATCH v5 25/49] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Index: AQHdJl9tdIqNUX36A0CEHwcxOIXcYg==
Date: Fri, 7 Aug 2026 11:25:19 +0000
Message-ID: <20260807111159.429128-26-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|AMS1EPF0000008F:EE_|DU0PR08MB9370:EE_
X-MS-Office365-Filtering-Correlation-Id: ed75c006-04c8-47ba-2fad-08def476a567
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|6133799003|3023799007|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 46UZ7BBAPhR4e8G04YcfMuk4gV8jBik/usk1Jje9SfZRo7vv8B8+SUB3SABk21Byh7IdsqDMkKewKwxJZaCpVAmxJA6MEMjZWPOduYQcWXHo+3ni0KW8GEP7+Xl/Kx9UcM7VEBr0lRiMPu7N7cNbdd6AYf8eMNIhYM3fY7EZk3iv1YRtKDheKx+JchkA2x1QxDEg4+Av+/PwdoiHz9Y/1L062UwEjxrvAVN7T/ON92cWPj5f3dAT0Kkt5MXhbEvrRH9dwnJ0x7uq/sqojNc6eJ81acPnFviaVgE5NL0wT3agT44XENzw0xY+VpmpOa9C5X3w5q5pkl1Hk79l0ndpNJSu6djg5CicE3VbGlK23eJgDHQfQ4z6dwIUz8niiCK/haY+PBCqScNw7g+K3SOFL2sOABubVC7nD1J6iSB8lQB4Al1yLtkg5AgTA8sXfDWAQQ0erY48XPqSTu9wTn+q88xusekllF3ZvD972Q8eVHcN60dsAWEhfGbyWD6vqSgyEBLT/IDTQN/OR9KI7+7slLJRthIm6Q+CQED3G2f5OIH/wvkSw7KwzCtPhxOVfMkCSCHHMVreH5INoUjHbjJafAL3HOW2ENyP91UoDM65fHyYvNw6bItkRtK6h8D1749AlKPc7XPEqiKKuoOJ/6zSfSNoDftpjr5fSfHnZTnGxk3F7ZFz4y0B0inr7tVWI+T8joNJsNT9eODDoVPf7h2TP3/AvPlXsQPNAYd7uTTM+3Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YXeNV245BAGZs5SyhpskoOmoAjbbGMTutJq9RchJytqJTwFCi8k2UtTVOnqx7hfoVKh/nFeHx3SMneKY/BJFJlvBfjp5e5mle1fIzghCbPBfD8Yg/v9pLFqI59kyHCDw6xYPB7Ibbg8O8ElmLnIIuy+CktPyJvt90N0QItk7J0P0YIIxsapUhNa35WtQwEjIAydGaOUjqmSV3QU6wlbp3yMilXPVzQAw14J5qJrijsLvXuE1lzrDCrRwqCV/DZUkn+1Na+ZMf92Q7/VS5xDGay2C4eTLFBBIGd3vNiZ9i2lYG3xnFy7h1NmeG4Pwu0bhjLlrOrfo9GvG0kJv7MjFOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1b9d9c65-7e3f-4a96-b2c5-08def4769053
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|35042699022|14060799003|6133799003|3023799007|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Btho+avwTJ3NlxBa8S6hEnPE5K7UkszlWe8qsy+2smo2DFNL30AOhaNVO9SGs3sYj39VUgapb6Al+ZAIYZukJuUwWXDjyPD84FktJYOH7isNwFaq79uqvvwCUYTSyc2loAktFM01CdS2Xp8njjWxdwd8+LgrJ8BT3tHaoPh1sgarVk1+bQ9wK0i8Irr7Ubtc9poQrPQ8Pa1WrOaDz/czebjYkCQ15PJO1Iayk/5XpyuvNQ45f43zQby5zUV7Op3JONUbxlcR+fB+5eJ/WL7s8PmO5YL3D87UfQTMCoFi1c2me7EDF9dY4J0/2ojmdJmQ57KHx2SSeDNZnywj69o/4NO/Y3d/V4K2bzGnkUSUVGpmtHoczvP58cXXxrsCW2mU6NDm93mzCJmIsw6zTjBJnKbc7vF3hDJ/5v+Y+FR7TAZIe1WprWjkOWHhV/hHQY1NnHgDGPgU24mLAy9S8hRs6xwx+A7OpatbViFMiuYCrNF9XmnTQNp+GIDCM8o8uouu13sw26ReQgJNQvmBTDsT49xnsXB2tOhwcsyQqD/c44B5ce8mEdExKrUbQK0ir4r3Pjh+8cI8KHRR+2gbIEyzzl3/zCf73+nc4bTS1OABhNSQAOUdRhZXETgbW+Kg81e8HcLw3BXNu6KAfRZPpVBoJX21ze+6Fs8tz9S56Y3Rsa3MXjc85lDInKHO1XurQQa80Q/AAqRJo/Jm4I5Me53IPg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(35042699022)(14060799003)(6133799003)(3023799007)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rMpPh5MVnwv9Li6MPQZu9ffRF1s3zMA5j5ptZBP3tRJ3hCuAWd+Nu0diB+hkCZuTOT+coZY8CA1HMzAXsVOltrd1Q9Jo9USKknSaBQP1xdNL7Ytu0H1C0seUonVBCTnMY8GFx1AqXHTaiTa4SeOO1hy6xzZn0Ahfabp4bx0PYUrb1cM8ZZeeqQngcZRslNI+lz5q9WwwMrGX+IwoLTQ2rZVLCRi560odVxyi3Sv9RbTX1WnKYlqVvY60WjJHfbi6DSOKofdL+nNzA+sGs4q1h0+OKTL2aqBYkbaqtsqVPYI7x+a+nIYgFVzuLsbb4BE+nSy44JcGkgsCVfP0v+yf2vtSCXZ81nOz3Pr4TCXzNwBSwZTxQbYZnXBW2POTtlTxr5mWrbLQupk146DlbDLEntVphkayZMuZ+UQmYVvNhI6/q0TWH0r8RPhwGXpaS7YV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:25:55.0567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed75c006-04c8-47ba-2fad-08def476a567
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9370

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these
would limit the number of interrupts significantly. Instead, SPI and
LPI pending state can be managed from the hypervisor using the GIC
VDPEND instruction. This provides a way to set an SPI or LPI for a VM
as pending or non-pending, i.e., to inject interrupts into a guest.

This system instruction is only executable from EL2, and therefore
must be wrapped in a hypercall for NVHE/hVHE configurations.

With pKVM this hypercall is explicitly a no-op as we currently don't
support the combination of GICv5 and pKVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 13 +++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 10 ++++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index d9ff9c2999aa7..36808ed0e9afe 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 8fcbbff719cce..8e2f0280c0cc5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,7 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 7fdcc6bb6f594..a372702aaf5a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -725,6 +725,18 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -760,6 +772,7 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 46992a6c2cacb..94746317ca79f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -149,3 +149,13 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
--=20
2.34.1
