Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011046.outbound.protection.outlook.com [52.101.65.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3735E34D91F
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306342; cv=fail; b=rpQ/nOVI4AR/YWKZcCFdzcKE/bFIMzh7gapQPe95mCuu33nzbU/M50SLH8tw04gPSESoiBWQFCOF3Tfo/Rsnp6t2ZjAoBzGXsj3c2iIs9gnOxtZyB/YnOjTZe2KAYo6G/fzjQ4uq0DF0bejHoX6ES5HX1DTDGSIeZB8STlmkcBA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306342; c=relaxed/simple;
	bh=jcab9b7zEM1tzxkM9+PCOshfidwLT2NlF7zbsnvZyCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Di1U1hSmB1yivwm5YbEsRRJw1XY2LCM1emlrlWdUZvBk8HpGja4Y+9RCeUpkPBNv45LhhuADTgZrQQ0U+c2FLbt6i4gxm89dhr+hl/Qmc6gQCPgWgA63yrA2lFpCHv7/t0/NoIfh16HzJiDw477kqqAyXJyF6hdsBxnILV6YzLk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WIQE2JPc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WIQE2JPc; arc=fail smtp.client-ip=52.101.65.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WIQE2JPc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WIQE2JPc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XYYfdcEZ3koJYGcKjjCgpGZ2XKWijP4YpQTBsnTJibgTZzA6RaZQ2pnvHW7wBu+y9EsO+Q6xZ6SBzlbP7nOksuhf5TTAFgS/gz8221dhBqTaAgCGtiiQUhIJ+A2HwSnDjzc1jk/gboIdyxfUG2zog4IM+dX+LxruA8+Ky1Xgim09pUxjB09148d2b9DDLEMxG9OWZgRJe3DfECiSWuEEmsOpXWtL4l4vjwP+q4sj7Ky8hVWJ5B+XbSpHKgntcbzsDkeOSTBGhWl1XsDeufAZbOdsbogWSoGHIIJrNc+xCYtpK/FdVPam8ENkV0SbVZquUjFTVu6MCgDQ6uKebGeBog==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LKh1bGtU/BBiB64rJzuMHZENRDGrJSjWs8aY0eUIKQ=;
 b=ifvHMHpL8Xwu/0UogMHLbeOE65gsN4yt+d50TyVMwcE+2NL9tRCOsLzZxYtVxCqPsHpP/j0YvRQOx1wfexMqfaK4TDg7rAkbPfrXIOegA7WUSQGc3+bHL2+fpUmXmrCyFTD+IKgFqvr94gxfY21ld/jly6Fk+jsplv6wKrh09hVHaGB6x1R3ewzJABGfqBoyZ4eWWLAHGJWKQZs873g1l/YPcr2uuyj8OC3AshAkD/c3xlAC9T+MniqxOJaOky1rsX5iwmf2jwI57jTVcxOMKxkaxE6Noe82w5YTmEdomX31oYjrIMn9TOCB7LrtW075BpJsVXN3ePdYRNpE+S+ANQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LKh1bGtU/BBiB64rJzuMHZENRDGrJSjWs8aY0eUIKQ=;
 b=WIQE2JPcUFFZOlNHIiTum51Zfd4n/nGBAOqFEpGHtVeTsDNGqASA7/PXO2uCr9ShPg5ZK8eBDwenfMf36JMbCLxT8l0ytZVMi2sSqWj+JNtye+6guXF8EcKSGOuCm7I3KyZ+BAY4W9DeHgs4aBYcE5fcGl8JRrhdc8JyJarc6Sk=
Received: from CWLP265CA0417.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b6::7)
 by GV1PR08MB10370.eurprd08.prod.outlook.com (2603:10a6:150:a7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:13 +0000
Received: from AMS1EPF00000094.eurprd05.prod.outlook.com
 (2603:10a6:400:1b6:cafe::9c) by CWLP265CA0417.outlook.office365.com
 (2603:10a6:400:1b6::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:12:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000094.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:12:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2Yvy3I1nfeEtppZ6azc8609UOp+nutmiIkKcKt0SRyxfbQqe8lJM+yb/BX6/N0uBsM+iQWEizE+Zb4d0NJfndjN3tPvE1keO03oZH8Si2L0pzYP9sk127ITljpBBK/NjxYXS4xzfiEjywCB+/Aoqa0ojLFaR1b3FIP70qltq5fiEXPTvd4VKFjPJMhXBM4iPT/DGcJULkxt9zAj9dl0REOOrTpSvTCWHx3qobLrJIUgKd1CMHP6oEHBIhJ/Jol+PHW6dHuA5uFAjFngzaaSMGAjWAA5gKHj2MEu64+XFwHlai0jQzku5lXJNuZQT/P28r5mE2F9bIiZWV/BBG3B6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LKh1bGtU/BBiB64rJzuMHZENRDGrJSjWs8aY0eUIKQ=;
 b=pnlgYHJjsxfUqfq3fo27j5pKc1qdibkGECXlBZlGCq9ijecJAtT0W6jP9oouRIzk5Dtb6huHCcXJO5rGuWIeSZyzyuDXpYT1jrALiiH45HMkUCyiHxuI4xZOBgILQJSeC9QnlfJKxl+PSYPZ1JFhoRO/QsUak2Z5ARGEd/YIjmhCNTVU2s92Rhevgv4wq3353sS4AsQgVspsXlwM5WfcI03LYcgRlsEmuowZa/qGx81s9hxwm1B4zxbxizF2sKE2tEPQeP2z5Vv9qlDwpoBwfCetZ0K7LQFDhV95ssWDBs3j/VlQJwKkcaV4FpCRa0soHWYSE6O1J6tTm5Rm1njacw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LKh1bGtU/BBiB64rJzuMHZENRDGrJSjWs8aY0eUIKQ=;
 b=WIQE2JPcUFFZOlNHIiTum51Zfd4n/nGBAOqFEpGHtVeTsDNGqASA7/PXO2uCr9ShPg5ZK8eBDwenfMf36JMbCLxT8l0ytZVMi2sSqWj+JNtye+6guXF8EcKSGOuCm7I3KyZ+BAY4W9DeHgs4aBYcE5fcGl8JRrhdc8JyJarc6Sk=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:11:10 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:11:09 +0000
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
Subject: [PATCH 15/43] KVM: arm64: gic-v5: Handle doorbells in
 kvm_vgic_vcpu_pending_irq()
Thread-Topic: [PATCH 15/43] KVM: arm64: gic-v5: Handle doorbells in
 kvm_vgic_vcpu_pending_irq()
Thread-Index: AQHc1mB1SmIgppkDR0KLoaq/rUCwsw==
Date: Mon, 27 Apr 2026 16:11:09 +0000
Message-ID: <20260427160547.3129448-16-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AMS1EPF00000094:EE_|GV1PR08MB10370:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c27cf55-d73f-4894-3a2c-08dea477bdec
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 q49ixBWQFtaWnQbbfY114374dxixg28LHdM/zZgvPHSB96wT3BJe6U/DOEOiOkDNcpRDHRgbuiJvaOktOrWP/B3xp/OOywV5HRktsVPMgAPaWX8jxjyQybvjO0RUf/a00Qo3EXjZQMg6ys1o2FMY4XQ2SXAkQ2dDA/aLLH3fI/7fCYNlUahcZxazgZk29OukywYbEs0efDS2fRsx83vY6udRbwfeD5ffPPrubKes1l7f0MUd3hkGT4Q+lEijP6BeEnLqj17rD4FF8hnrGMcoITT5c0PseGTyayzVcr2K4qbvHzVKslC+7rRAc92sd0Smqqtwx/xfVNtQSCIgIePAVBzWkQXxV5eyauEzKAjU+E4q79OybfLnfamYOeZUshB5tf+OQsJjLeQHDaZZ5rVmDBJeO5WDgDIV73gFXZXyXyKdD+u+/DqZ1nC+e4C9qcHm4NVFR8dg0MEPs/ejIACnv+Ix1iybSwkC1opXDt+ljuw1scKQwUrm4GWNjojqGB5tZMRjymrhCHAJwoWy25GxmNuo5VD+85flz6lmSaDU5ozR5IjUS0zCpuqMtx9A2lq/xDrhpU/TVPHkGpGPl8ZBrVGnyXS13pqcEG6UlmVjIc6mUhGOX8HSMb60RY4oOAPmVApyW8MZ07NHMm/gM6vmEXP5Pt2K73o3iH4awWIznCGyU5sEROm7/osFxTshY3FzAgYjWZtwQ4uQQoTdIi8Fp/ruZZGCsxYdtvWR+Qb7WyoKHn5zNcPENQMFCw2LX27jAfK7oSBYNa9t34FcDtwjxX1/oB4/phBYbrNXZ7GnZxY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MHFD0ey040xsf1tVJv9U6pkV9IialQYZ4kNHRGhj3Z1ksBL76V/jdOG9rh87FwTleI74RyIs/BVgGhG5kA7MgmHjzL2x4T+OMypOAz27TRlY2jl9W6M0p0eue9iWt7y3UT35StvEwEZD0ZY79p38w1t6CcMJBA33JukSJnqxgK5iaf+ILd+oWslIdXuEzQGn81305ZAKidWLCLq4FizhUskceTktJCYeGXYTl3rOhy0m4whXFnH9cU/mJnvLTld3vqQ6UZqHD6vcTAstPlh/7fwjCMgCSkgr5X93GpS+sWwSRc1fxJkWEZ/k9GFLy0t1dmJI8ZutvWaovRsYZm4LRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b922b1b8-f58c-427f-8e4a-08dea477987c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BlJWN40fiELWiuxZnmZAjoToQr4BB2fHN6n9HxL7zMk/HLwS6OfqyjkruCDbawN1LBl7eFG6jp52FcuPM1E9dItrjILwRu1JjVmy/kpeHqMu2VI1e3tFL+bPuffInvmR14rhoQmNR51j+XVbfD+/eZNoDGbx43kv7Dv/zj4QPf6fFGl0kNnvPvJZyQ+IWJfzzteTBa4Zj5NZEZP+pOaAS6aBevf9zEt+3JvsufnPQ+9/5WyD3oB7PDe8Ol72dpqq54gx07M9CpKvngvZNEeyorxRYOxLEABicvDJdhtNlW9i68/ELNDzlEZRhn7y+l6bLKJOFEWzFoo6NB7i9pi1ysMqWSbqg8uNcQoJpqGWWr8ISWf6J4V0W/T2KKg6ZmCV7IqDLgaNanHbTzQ1hh7BRY9b/+KKGSuAVRrImAPP2kO3nU/w8+XusmRgg9YpmVHSxfCsOEBKg3npwyX1FZSLGPQcjFfUDUHbbMM0qHw5LBqGKnvL7t+//jo12M5l05+P1HaJIJQqWtq4LzsFxCDefMNVCAT5JQABjasvA0lec/FvxGk30iShvZmMeG+bSQFdipKOCCpxslcl5hNk7gc8Y7QERidY23qU9NjpDNEIGQLdT0zeCnG63/MHxHImnsbdcfPHfsun9zJP4fnXeea1wHvZnBpdTtsfo+FisGPoj2bP4rh0W19JtW7tDRhS3/W+5w89QdAe7ca7nxscamCro4k9Qs3MZIXkyzrfkjTYSkaSqVlB9315mDnE9f4vN/ZN1PRef8okL6kJ44DWwgf7pA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9/LAR9OrsvTlfByZCDey48WYPw15OEIc7XHIvOXXl7ADI36D+KjjedGmZ39eGQXhQ706GqdBpkQEbecobpQ8ms322ReXF1hi8vLsDs6ZjPD/5y9Vr+CWnBojbavPRRtDaydUfhJY++7paaYSDdmGSpEJENMSx2dbit4of3FNwZkIt2HReLG8EPDjyDxpH9WMBI5LypU6eHSqMxsOZVds+tudkbdMrGKWysXjNMU/bZ3yf2qxIDxnZ0bGCZ344qHdxTQ953ggSACmOLFTSbcs4dZzvD266pIRVeGHs98jyW+QcEpAtLKCUXUUixvrGVF8rqsCxpTsnU15oD4JsWlpevnNbq9Qu+NWW6EViX7x3Ue++Ts7MuBPkFD7CLjDc4bv+p3N+ZOJER1po7SkIO1/qISWvga6VNBKeKlDb/e967UgLRX1VwRpJv7GAriv1D6p
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:12:12.6720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c27cf55-d73f-4894-3a2c-08dea477bdec
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10370

Extend the GICv5 check in kvm_vgic_vcpu_pending_irq() to treat a vcpu
as having pending interrupts if the doorbell has fired. The hardware
itself knows which vcpu the incoming interrupt is targeting, and
therefore it is immediately known which vcpu thread needs to be
scheduled to process the interrupt.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b697678d68b01..d56e87a0d2acc 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1229,8 +1229,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (vgic_is_v5(vcpu->kvm))
+	if (vgic_is_v5(vcpu->kvm)) {
+		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
+			return true;
+
 		return vgic_v5_has_pending_ppi(vcpu);
+	}
=20
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
--=20
2.34.1
