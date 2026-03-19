Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013010.outbound.protection.outlook.com [40.107.159.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E401340A62
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936045; cv=fail; b=FMr7OocCpUWnCMWPDVZvRJxZx+4ap93zN/R3LpW6iQi6MCxy+sfoVIgIV0J9OsJHta2BGd/8vw+m6OSmT9ph0kHkBc7JGhgMjg/fir17tvSJRUTHqCFZ0Im8xlXJ1YhpoiY3ea4grHs0o5X/m588odQhnuwlL3cnNVC7avll90k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936045; c=relaxed/simple;
	bh=q5gy2AaVDs8MCE7rhPEQzIRf/wVd58xdLeoqYlYvpO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=di43M26uNUujISGzw+om71qrCP5LSaO56s3H5/a7gtL1iHiuMqnuN3t6+8dSDmn3q8fTgow6zc2xK1LgSCNWtvCC1rl5ib0rvLAAC379hkzJM7x0Eyxq2sW2nVA+uWhffszgBJbDwmETsGZ05R+NJp0356hU1mZGPhCCvkAxA7k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q4MwWdxN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q4MwWdxN; arc=fail smtp.client-ip=40.107.159.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q4MwWdxN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q4MwWdxN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WVF6s8aPjMKW3EVWiQfrWmFHYo7FieTwt1ZxHGKgJwCJaj01vJZNlYVlPwNXn+ZirEuyQuUs/ga0ZAcgQv/cu5/mDR31Eh/6mWz3DaZDeZD+nPhMM1CPJfmQCD51NV7EmPt3y4dHvqkkFXAs5Dff9yrIVUA1YpvX3iWME8mbThPMEiWHbwZo7vXhavQHHJEiQ/kbaS6lmkrd4ybjQUkg6CbVUFUExnEXPgqbDSsElCoTYET1laT7IGtXr3TEP8eiIA1ECeAcoFVuynoZ1xCF0SNhv76M9F/n82911n7wj3qdJbXds6Z3/IX39bN0VCqE+S7bBcFoksYjbQZ02boJVA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=e6tosl2o2J3MnrH0BZr8IRugxNAvYojtXbuxx0iq9PU13CYCpT8YZfOU7H2QOsQxtVFKqdXv2oGlPqS/Bm0/b+Os6lLzUV2+SBaTgJpHPja99r4L6gszmmadQinDcL0aOjVfci15giOKPPjHV6RePv/R/y+9A2cy9prEWcNBwJKK4g1rhcwMqey2nFn7kOvKBZanHZYTI7rVdIaCB98WRPVsOtt/BgPjOZwzHLDJmIWQCx55da7Oxp1TZX+tZRKvMezCzBRPJn2idDqEi2HTqXV90PWJsUoycxO4ZOcWa48DSQK03HstYWPbExteBDr4SDiYUgFlM1VG57mFMeWFQA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=q4MwWdxNpnUrAg7Uruo2johavUVNB770jJx4B0qXXFwJ4xNnTBhKa9O1Ej7PDOLe6tNy9i+I6GfXrZVK+/5LQmEyTuQnnlmF41oETgUzxFq1wG/2HpYTYXsbPegVzFHhgPPeP7zZbDr/jI2EusWr9XIiF59BHDgkxrQG2uskouQ=
Received: from PA7P264CA0395.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:399::26)
 by DB5PR08MB9971.eurprd08.prod.outlook.com (2603:10a6:10:488::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:00:38 +0000
Received: from AM4PEPF00025F96.EURPRD83.prod.outlook.com
 (2603:10a6:102:399:cafe::21) by PA7P264CA0395.outlook.office365.com
 (2603:10a6:102:399::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 16:00:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F96.mail.protection.outlook.com (10.167.16.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Thu, 19 Mar 2026 16:00:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNPz3XYfJ4AJb78fKmnW5guXIJO6mgT9ad0OIyW4z/g+MkOXl6a5UnGD8nn+IoqkRDtESCcLDlDZIAe0aRksu8ZhwhAHftaIlhlL3xIv0d2XmJ8HoWoRYoH3FFpaZs2K2P6sMAh8Fjpv0wuUUMQiCvKPFTDrIpDMopkI2Lwx5iqKx/F8O+fbwBbys7OchY2IKVgg3MEple4N1r5A2lRUzqx2A8CQh32054uyjx15RJYdFBjHji9cf3crOC4EbXiJxFummlPhBFFyOd03aBTIhpdzx8r5lknBWygec571PQDUNENuDQN30mTJ9XL6bJalbRuRcXlpN5BSn91W5Q7pxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=B4BZbgj8+pF4OG1kumD/W3YxFGyX1lFNDXb9F4eq3CQpe2vdmmBLYMkNcC2a4ow0epF3vUVPPeOj0xTVdsMARJNsLVW0TlZm5Kn3t2ABfo080KF/48dI2SXcicl1oK5y9QHRmoYuTcaGxBIlQ5296mMJNo2ljZwvkwQodvbf4sJno4si/9mY1os2yP5S4N6jvRIiiqUEuBV0g2+zpaonHofs5T9JPQfIfV648xioFoWs8Zl+/yc3hk0jFTKhuwNEb6RlOY/AFFkMcN5UI6NKcPCZXG7/rzsIdreYFAAxa6z9nudgSKoQM2KfsNQCsaqUGFkktmnoTjbp/Q9X7/4vDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=q4MwWdxNpnUrAg7Uruo2johavUVNB770jJx4B0qXXFwJ4xNnTBhKa9O1Ej7PDOLe6tNy9i+I6GfXrZVK+/5LQmEyTuQnnlmF41oETgUzxFq1wG/2HpYTYXsbPegVzFHhgPPeP7zZbDr/jI2EusWr9XIiF59BHDgkxrQG2uskouQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 15:59:35 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:59:35 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 38/41] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v7 38/41] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHct7lhU0KBFEr+LEK+JVEf2F+16g==
Date: Thu, 19 Mar 2026 15:59:35 +0000
Message-ID: <20260319154937.3619520-39-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|AM4PEPF00025F96:EE_|DB5PR08MB9971:EE_
X-MS-Office365-Filtering-Correlation-Id: f51b6f50-3926-4825-43a4-08de85d0a9cc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 v3kLQLurF1ZdxP+6U6bc2/9U4Cmn8TejAi0d6mwAhQ3T6KP9GR4x1QTNChYpsY+eU+N+X/RaYdQjPOsZnJbGB8gPZpZb1RuV5jpfXm1s9dnhuhUnxt+V9W8Cs+C4w/ay1Wln6EF4YJUO2xq2tsJ56BgIyEgg4IuCNsl6xQ3tVsDbVnJauOFzy3ueICWRxDmgFj+wc/I96cEl/yFIm7t220S1TWHEJBlxV65ifqHZQXX1UPfmIFfHhbMG+IlMTodCrdwGI8IF3QjxeOrB+hJKdn5xq4DVMlYHOYr0ZFa9IledKf9YvUa1lNaoTkSDO25RmvSglzpT0xiykR7PMdcjT3QydSd5t2S7/BDNndtEUa7kbepLh4otHmyLZZk9lnjZReLKc4wgKPR/Gik1VFlAXB1MmZw3jWSiEKEfEbJ0zGIHYjHXFAAkwouS6e1jqFPNc9G4uqk3FRt34E+nH5ZGeHRIkuYWlWN1Bcn4g82kZic5MhhDWq4WHeiY+HSpEccK5jcZ+B1KxmY0iv6UccpPQHXkKH/x6h0nOcVnMoebN1jQpPS9Wp9vDMd62vEIemWtLOWxAheYsyWpSgPjN5H1zzo0RGgBGhQTkkNvUQZogkc0+JJyi9LPnfzWJp4OPlclVaL4nXUBEsQthSVd5yC2Y2sxFkgfLrOMABsese49FHSPZGJ+MMqj7uFJ0CxNoIa3G83hozg8EHVaEJg/yNYF5fLuMR31LwFm7HA6rX8Mb+VBJBK7tXnEusY0DQediS0lGKia3/4lKWs49b5DPwyoN9Ds30P7LZG0+q4TheWt1mE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HLHfdL3/xb4l0Oq/gK3D30f8FNgllSdyj7hCPivjfbxpvIBhQ8OGV75aAu25J60q9PEgvdaQPzwXU5Vvr2Jf+g7RaCVvsM4YuJlXaOqIzk60wwpD6No+r7iMrfeOqAEH+TkF7oVMz2/7icho2URttevhIQzuCwrPqO8vcG4SJ1Xi5OhZ2MsSwvHh2qy2JmD3/WOWCiXCYoxNgCR6DeR7I2dG+NDNrLtGNneb1qHGvNQvenez1woeZ830PJsvT1tOqvkpQnrIqUAIqaCdxWIOKIa/xGCHCvvrAfZEji3pCiO2UpjjGUSW26cYE8BMAwSSbCXngJEA+VJcupYYVmJGcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5a8ce874-7aa8-465a-1459-08de85d08451
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|30052699003|1800799024|376014|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rLOMLGlVVRnU4T4n2wJjvGklncQlr5abNjXGEqoslf00i8TdO2DF7aW6LYqS73YVQDW8icBRT0rfBpkQHZRNsyb7+yTI7/Uwkoku3T6cLiH7g22Yizhjw56AD/CxMmTEdHBhjMTs2m3YiH5WfurB0Add3/Z55eDlnqwZ1nPSufuCC88nkCTLHoD+M8FnYc8qSh3E6hqLy7AvOUfscPCc4Uga9F0m5NinLcG49jor8QA6zfoO1C8keilVHITrRO7b0wG2/bQmofIT7IDUyV5A5JYRD0IghH69MMEImPueF9YL/HjpeARJlM1T1CNnJaXoq4p4dnugExX+NW6AWTuzASwFcP26mBWG9Jgc7TqSr5Zuu9+u4ksfC83lM4YUjcWg/ufDy8yRjdhGYAnhOvA1KHJdA990KlJfRfZW82j/JYKfgBjrYiiCIRDEhfHOsEPBY46Z6BKUsU/JnDqKhc6Kp7IWO1MUi/AJuRa9s/8nrP3xVf5Eyqr3ndGWY8cqHalYfriaMAC6lGaSdMexXUJh7wzOtgR6rp0uChWQydjEAt776DjuP19O+UOFvzIY6vr8U2lHEPC5S0dnq0sSstrDHD3+Spn21sDFNt/3wrqTenhnmK1Xre1e77M2RJh7ROmiMAbJ7aedjMM4ebqc8WPRTbDiI4JaxFMW/pchE+PgcY37oWk3JZSTGcMqOSGIDiWI+eGJf+XcM8paoOO10uoFbZdF0LvErY86gXaK3MrwMlkyG2iZPs5vAWqRhYp88m0vrUf1NKU3J5iG5tJ044eBag==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(30052699003)(1800799024)(376014)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cWGgrKttXhymWnemZhGQBIGt2AuapT9DYHOtmdY1S02Wv/VjwJ4K1ZgRvjy0bWh67Nj4UeXb4hXsSxtBZsWOm/lEU1Oy/QuYf2Il8KpSzgpXZF3AkbIM4R/3HlycyYy1Xno7tiH0Wk3/KJvyVqLtNJuhlF/gEA8xL6hsSLcmm1IzAVsGQiIv9uF/C8NXSmArm2XDy305secQ7gCDxXT0oHLsqXRBNHpfDWE4bocZltTulQy8qvHVitbJnQMxStLwHG7a7+c6mErwWqNZ2vThWdQVxyZT1pEmhd9+DYoxMM42GBCFcBLMgK8gtFf3JlXcjNPCKR+PDeEK4meYLEqDR/z8ljABguONh9em8/YNZbfjD1cIvb2kpFlvLnXbgKNiRtAUYVkF3zHET+Ppi7czD/SDG1KJkLJB9ewoCDy8TMkizSAyS6Vqm93DLv276Fem
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:00:38.0427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f51b6f50-3926-4825-43a4-08de85d0a9cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB9971

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 0000000000000..9904cb888277d
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c84..70845aba38f45 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1
