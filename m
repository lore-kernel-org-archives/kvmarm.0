Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010037.outbound.protection.outlook.com [52.101.84.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F48E37AA99;
	Thu, 19 Mar 2026 10:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773916365; cv=fail; b=nQLMiArMAb1FTLvf15ojVgO7JmVeSYQTPjKr14I9SK1IiKncTmHR4Cif/KX74m6kCKNaxZpVey2odAk0vbuUoN2DQPpaUUQEX+XwDJTd8aCOAo0UMUA3Tv+AnizZc3bXlFGglMdKDI8rZZeO1jyBXHe7dSwY+VEDv0k3hgMB54k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773916365; c=relaxed/simple;
	bh=GiEg97SfKk4y27UPrHPnWjMyQHOcbtV3JWc3YoBZj7M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dCcO0s4YGbEWfo3EWHSYDOjyn2xrJBrB//ClpWx9YualP5OJ/I4lsxe053bKLVWg+IhSqwMQg+g0HbpcK1kOjzAqjcdJMBfgFN+cjglxQLjg1W6mAlCqJ2cmTi+OG6FZrSXyh9dsGtI1VWiNdsTYJ3KUMTN4bQ3ra1WSVHi3Fzk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GfN41Jyo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GfN41Jyo; arc=fail smtp.client-ip=52.101.84.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GfN41Jyo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GfN41Jyo"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=my9B7Wd0/G7H7Fju/h7+stn9v4CGIC+fI8BoLtOQIxsVBSbFQPDgoYvPb7GpBnxPnUzwVOA2upzyM6ASoRL0KFGjSP26rGelkBOJOoBOl1uk5tGLOIAypnjXethUuNk8AJQkmSa+wFzomHeepqPNtreqm7rZEjcVjA/s8Wheaw48000FnSTqSdB1nzWuqDmdwSKkJgQey7pnf3lqUK3jduaqx5qVfOrJpwZl8MF7pTlme0iau0F3AjYxg/D1e4MC7Bo4oIoBcFen0RZbej26YZIvnjZwJw6kcULYxFEMNt7xmCX9YGmWPy2RV0TR7JrZvGjhXI64JCNnkdjW6KA3vQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DyXjqbgaOSMpFYbEabsQrw+iVoF/+Hpowo1MyHNJEg=;
 b=Eoc9ywqiiY/Lm1o2M3gr+QGuErcpl2qPo74ho+gbDGbyxxQi45NvkfoaSWRmwPocGdUEvszOtR1NMTlTK2iIX7d17rBUo58d4uhTgBgQlE7Oy7zLi0KJAE0E3zGlT/btmankVSPQcOiOtgn2UeKdUWtnY/xyc9iAY3hfmDmzjxta9iQ1Qp33fQsOJl8lk/wMuSaV7267hd6SXMtYRZfZCsohSCOPEtT1SMVjNMLDS2Dd3ljY5bfOPGzvldjTLJQp6l3hfObVZmHaa7NtuCQZLevNzp7rDif9Xvk+5YYbzxR0uSQebULlWC6uSobsi/CvxQGVXJ5xqQHjwsOvc/T40A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DyXjqbgaOSMpFYbEabsQrw+iVoF/+Hpowo1MyHNJEg=;
 b=GfN41JyoBT7uiTCvVgf+4IGDj0C0S8CjCzeN0tDw106WA57zfXH2H/LmSP3F3mKmu0ZodueHxuOg1mPSTo/1sOehzNJ/X5Fw2QTNus1v3ORISsERe8nL9LUKHzn9P0pl/p2xvyRbgIoJ01IjWgJdmU0Rw5kabbrVHf18dzJA/Hw=
Received: from DU7P191CA0010.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::35)
 by GVXPR08MB10497.eurprd08.prod.outlook.com (2603:10a6:150:156::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 10:32:34 +0000
Received: from DB5PEPF00014B93.eurprd02.prod.outlook.com
 (2603:10a6:10:54e:cafe::c6) by DU7P191CA0010.outlook.office365.com
 (2603:10a6:10:54e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 10:32:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B93.mail.protection.outlook.com (10.167.8.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 10:32:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c//YHMBo6WvXMkaG86Y1SFpT1jy1kUbgKSPRiLEuDhwXRDgWbia3R34YtF8rPLcYFHm50GytE9WYrguWxx/U+avLpwNZ5uiwJK/31s/EYsYSvu4gFmrpyMVec1bX7JaI/oDJ+JsrQuSgLkVMty+mpGo51dahneZzXVTkB9T/zDnMYcwpr3wl6aoL4VFyqDgWdvU2VK63s9KVQdHQvgGX7pALnusgLMvclpGO5lBZ00wsWKNz6iw2SIyE39tFwQ2+pnzbz3T8ITRwChL6qPxCkRFMrWlhdjBt6pf8lF2kWaTJ/9GDFFcSZ5uJ/Fb4o6RcMHYgVq6iORQdrnd9sJwrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DyXjqbgaOSMpFYbEabsQrw+iVoF/+Hpowo1MyHNJEg=;
 b=byocRSNDpa3LBKvFqxO+cUiYYXPHrZWmtLnaqYuMdpZKaVSuxjEBSH4QicmMAKXRoy+jbydDqUS0e2z4B9a1GqsIJrFEUyAN4pafLDLPsBGFxLYf97M12KqsOxmp503eg75SGCNtVE51mUV9tsjIVQfuzsMDv1Xj+giHhB0SF8YQCA2J4nAiQ2Y6tY9eTzfoXaa5ERmq5PPOefePK+PTg38ooo7FYlEB8/kQoSDO2kp4Oit7FO6JF9XvwR1z4q8NJ8x8tf9FFHA8753Mygyy6zw3ORKpV864qGcj3kIuuFNRK/rU9/LlZ56sI7v2PIhJqZ+T5KrBxFfFUsNzHE0TVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DyXjqbgaOSMpFYbEabsQrw+iVoF/+Hpowo1MyHNJEg=;
 b=GfN41JyoBT7uiTCvVgf+4IGDj0C0S8CjCzeN0tDw106WA57zfXH2H/LmSP3F3mKmu0ZodueHxuOg1mPSTo/1sOehzNJ/X5Fw2QTNus1v3ORISsERe8nL9LUKHzn9P0pl/p2xvyRbgIoJ01IjWgJdmU0Rw5kabbrVHf18dzJA/Hw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AM8PR08MB6500.eurprd08.prod.outlook.com (2603:10a6:20b:361::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 10:31:30 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 10:31:29 +0000
Message-ID: <b83d601c-c4a0-4e6b-aae0-e49f02e67e30@arm.com>
Date: Thu, 19 Mar 2026 10:31:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-11-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0187.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34d::16) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AM8PR08MB6500:EE_|DB5PEPF00014B93:EE_|GVXPR08MB10497:EE_
X-MS-Office365-Filtering-Correlation-Id: baaa154a-684f-48f7-d165-08de85a2d545
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 oksYoeqgRKY9m61PgjY6TNe41WdBK0o2kksnXVcksOKlgLLuN+4QtbGFDGTTDV7iLDTldPUPWcXIn+uTcQ/SWZhauYmT26evLvlBjpttSrvS0x62ic04LIZliHTqtgyNCuiChmXtR/KLyqcHKaDUImIoofeMB4PVgst5g0N5PrrPmwKhJ6lr99R91/CI7TPqJeaPNFVKnbn6L/5GGv/Ttsd3cksW3PDkhBgzT1B99jBQmK8u7YfOxdOQLsr0RnmKQAZrKhiNgttOlT9ryIcSlQap5CcNUS2NPPq1Vb4irTJWC2mFkLdmv29vTTDfY0V+tf7vbEj68ytI2rL6lcxlTdIHzNRBe2gvgEmFTDbjzflhmYny5JkizzaobVl3Jq7ZdHproXL08ebpWoKbLgY4MaA3/i4sRYuBXJQOkGNfFv1Am5KT8l0byHMVSm4EsnNjty/PKoxH+kfXMDouhWqJnfSbL8UaOOBz2sfzgPgk23rDD6i4+Eh8hyMlwgMaRkdyPUIUW8GGGg7SRpgrvjqLZoFzHDzTuEiFwNdslN1aZ6OTu899/zXC2B3JP9JwJjpFWlIF1iY6jykygnQ9DMwydQxLG4eaGWlyt5Xd31RQTjvsqw9Cw+pyo7EAqQIXGJUIgzcSgb5KxJIa67F0xWAmMLWhU0Sq0ecgr53E37pAiP+UbesmpBYnadAsD+qpPZ6HJ2cS3t2HcB2CSjs+P1wjBYetw/RXoYdy0ZjJ6OV0iSA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Dbtn4jGHnBqOk58j5yQWYv3D+46VOdkQhQIfEJVHYPEE3eoFYPwhLBup9nsO0H7IHO5MZgw1k3VS6iEUtwVgAG39oJqqbQb9cG0nXzp7nv4si7qqksIuk5qNxf1M8Pnivs/r/u2+VyYAblDbEQmkU6txj1DYmfChOwJMSg7oAduSzE0zB+XFYohfhow5A+hTtlrOWPReRs1jhCpi80Q8mg9c1dHftuB/6xk15RVR+NksyG+xzEMP7misB0DvxIb3NYBfMDS43z/rQ1xs4f7/mqKYCHCqUeJT27IDOdsIH8qaZtSN2geFL3m7u6nlEPhGXJTUpdPVFVn/1dnwnmaa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6500
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9abe1695-0077-4884-64cb-08de85a2aebc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700016|14060799003|35042699022|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	khiZCl4rvNQ36740eRBkvZk4yr38D5Shx0c8sahig0VouWCDFSBPKgk1mUlFRC4tJRn33oiAObmFKL68iGSTOQfqq93hE6VyReo2igaHkAPWsRcwYTxStPpZgG2Di4yRrsmdX4A5IZU5/D+EgHBxSI411quyJr5Misu2SkeTGFl1O80PQQy8yT2bzkxt+DV7DRgE4Lu8jdGduNPaPPlH6rTnnybQdgJ+IAW17pQNOoJBpQ8XZ4VpqZAYeMIcjic938Y8IKoYHnvwLA5sXTt9/682siCcOcKlNWKVGA5syKO45xJdiX7Hcp1t7dVj070XHSOynCt+D5q3tpDVWAlnMfEOjvI91h/qz8TdcjULJxXtGEnsTLz9dLkYh8sm7iHeryt6vT/fsqR4TBGOP6TsNPyOG8CxQsAJxnEia0p5F0PbdiQMIAi8pXtZ90aibnwth4k6ABp1RUeFFgzHSs8tcdTxKYmIe9f9HqQD0Cs6M9BfsNfImDrh+a+yQLJLUMIduQotzGXFtkEx0WjW0nybA90KgQyjV0dH9AafwPr/Bvhbc7D3eZFRcysvOxvpZA/95//U37X7/o2DL3aMQtremsW9UEAhc+gbQCxh02IqL2lnu53aCYm98+NcJamd16a0QZB8yHzeyCEnnvTOGNJFfv7DV9u5Nwuc1FIaVxmT56MIz3+KzhgoyZXXwWyJ2Rb/phF5/CWcNnWjZI1zfmSxo9YMmgaiv/MrKEVoQ3flDMQHvK4dl8g6U8Newkp/IjnQC1vMARXlp2Pu7n+F9NkVgg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700016)(14060799003)(35042699022)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3O3zeu//JUYuH2OkZs/Dn5drTzOvC5iWmrZg/Kl1boi2GIvUbNzG77CLLr+rfxPzE3iEu2gaCGoLjFnJp3cNCks9L/1sM3pJiADsPfht+RXpdhvedWTFyZjnygw96VSz7iXJi+JKPrYH4GLo7ZhyC3kZrYwrCJ37Fy7PWW8awSO3zAWPIZHR/WFWHa3lyGE+710ovIfqi7ZllAAZJspyyqfFo3RWzEjOFpvMHuF62V9yOYMImpmD4a2g9aCJF7EWa0ZkAJcwlzmToP7+81LSuCQS9Wdt6FfBpRv6urZjjG+5kJvohLxF6rZ82G7O86IXPfOyoF3iv3LwPZ8AGBcwSEhpqiRVLFyE9lBYB0hiGm7f4ay0eeBj86OybdiaWlpQiBh0OpFIEFO4XXVGVfhr8HVXez4teSlPcL4ebz8+Wj0ESDrTg+sg1K3SkkDKM3VF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 10:32:34.1283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baaa154a-684f-48f7-d165-08de85a2d545
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10497

Hi Steven

On 18/03/2026 15:53, Steven Price wrote:
> The RMM may not be tracking all the memory of the system at boot. Create

Looks good to me. Please find some suggestions below.


May be add a bit more context here :

RMM maintains the state of all the granules in the System to make sure
that the host is abiding by the rules. This state can be maintained at
different granularity - per PAGE (TRACKING_FINE) or per region (COARSE),
where the "region size" depends on the underlying "RMI_GRANULE_SIZE".
The state of the "tracked area" must be the same. This implies, we may
need to have "FINE" tracking for DRAM, so that we can start delegating
PAGEs. For now, we only support RMM with statically carved out memory
for tracking FINE granularity for the tracking regions. We will extend
the support for modifying the TRACKING region in the future.

Similarly, the firmware may create L0 GPT entries describing the total
address space (think of this as Block mappings in the page tables). But
if we change the "PAS" of a granule in the block mapping, we may need
to create L1 tables to track the PAS at the finer granularity. For now
we only support a system where the L1 GPTs are created at boot time
and dynamic GPT support will be added later.



> the necessary tracking state and GPTs within the RMM so that all boot
> memory can be delegated to the RMM as needed during runtime.
> 
> Note: support is currently missing for SROs which means that if the RMM
> needs memory donating this will fail (and render CCA unusable in Linux).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v13
> ---
>   arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 89 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 9590dff9a2c1..80aedc85e94a 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include <linux/kvm_host.h>
> +#include <linux/memblock.h>
>   
>   #include <asm/kvm_pgtable.h>
>   #include <asm/rmi_cmds.h>
> @@ -56,6 +57,18 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +/*
> + * These are the 'default' sizes when passing 0 as the tracking_region_size.
> + * TODO: Support other granule sizes
> + */
> +#ifdef CONFIG_PAGE_SIZE_4KB
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
> +#elif defined(CONFIG_PAGE_SIZE_16KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
> +#elif defined(CONFIG_PAGE_SIZE_64KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
> +#endif
> +

Probably this should be made a Kconfig option, like the VA_BITS we have 
today for each page size.

>   static int rmi_configure(void)
>   {
>   	struct rmm_config *config __free(free_page) = NULL;
> @@ -95,6 +108,80 @@ static int rmi_configure(void)
>   	return 0;
>   }
>   
> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)

Could we add a comment what we are trying to do here ?

/*
  * Make sure the area is tracked by RMM at FINE granularity.
  * We do not support changing the TRACKING yet. This will
  * be added in the future.
  */


> +{
> +	start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> +	end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
> +
> +	while (start < end) {
> +		unsigned long ret, category, state;
> +
> +		ret = rmi_granule_tracking_get(start, &category, &state);
> +		if (ret != RMI_SUCCESS ||
> +		    state != RMI_TRACKING_FINE ||
> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			kvm_err("Granule tracking for region isn't fine/conventional: %llx",
> +				start);
> +			return -ENODEV;
> +		}
> +		start += RMM_GRANULE_TRACKING_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long rmi_l0gpt_size(void)
> +{
> +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +				      rmm_feat_reg1));
> +}
> +
> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> +{
> +	unsigned long l0gpt_sz = rmi_l0gpt_size();
> +
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		int ret = rmi_gpt_l1_create(start);

How about adding a comment here explaining why we look for RMI_ERROR_GPT ?


>
		/*
		 * Make sure the L1 GPT tables are created for the region.
		 * RMI_ERROR_GPT indicates the L1 table exists.
		 */
  +
> +		if (ret && ret != RMI_ERROR_GPT) {


> +			/*
> +			 * FIXME: Handle SRO so that memory can be donated for
> +			 * the tables.
> +			 */
> +			kvm_err("GPT Level1 table missing for %llx\n", start);
> +			return -ENOMEM;
> +		}
> +		start += l0gpt_sz;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_init_metadata(void)
> +{
> +	phys_addr_t start, end;
> +	const struct memblock_region *r;
> +
> +	for_each_mem_region(r) {
> +		int ret;
> +
> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
> +		ret = rmi_verify_memory_tracking(start, end);
> +		if (ret)
> +			return ret;
> +		ret = rmi_create_gpts(start, end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   static int rmm_check_features(void)
>   {
>   	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
> @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
>   		return;
>   	if (rmi_configure())
>   		return;
> +	if (rmi_init_metadata())
> +		return;
>   
>   	/* Future patch will enable static branch kvm_rmi_is_available */
>   }

