Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011001.outbound.protection.outlook.com [52.101.70.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F0326923
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 07:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783322184; cv=fail; b=gUHvWff999vrHScNj8jI5OMXGJaKbJYrnV5irvcihNN/O6nqNIImEX0WSsS4wcC9O8JxTKukYha4HvqkNimSqhyya3AlMhI0vuTyZHL6fRDN/vEoD8VtZ+pnfgRyeW2/jB+lSxk1jiWK3RmOECO1dgYL+sYOIOidrl0+GDCmQkI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783322184; c=relaxed/simple;
	bh=0K03DReGYD3Ds7snzacqTHIMgN7/lCR/D26euE9DTTc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qAJ+CNEX9xRVxX6vFwi6cj7hk6B3K/zzri9khe4vG+DqbXyaBA8Utf1f8XtbQ+MPe3uI6D1r/ARYCUX0i0cGlSMsJILx1RYnJNMQUizCoyTubuP0E2rizlZ6WMHEiDHdkErsATrvpYA3MK64ZvMLVLWrYmCYCIXc/YAbK4S1KsA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OMd+yqJ1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OMd+yqJ1; arc=fail smtp.client-ip=52.101.70.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OMd+yqJ1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OMd+yqJ1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kykbAErlXeW85IIFTUosS06x+junFQO4gnrucUByBsxRp1oRN9e0a3cKks6c03q2hghlDDNbNzXusLQjwmpmQu/YDHCJuuZbIQjoUQmI1cypzeoxfJz9oMuViMSvsmqp+vXeDzi6hUhrU5GKeM0HxGb0TkqH8covWvNuwo5StutUmxNwY1/rQe7b+0kpu8dTs3EwtHoE1q7f4nesJPTaVoldGEY7OHG+lfQPnecGgTWHhSSnxLAP1myWtnRmR++2/9+IMf56fhYd2siUzE70Xpz+Yc0q5IC+NmAoPrzLg8TZReeN66jfg4wfHSum8jFaGHiXhj5K/xtq2dQ34mD94Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GefSnuI5k3vJrzNZcN7nrOZI3n4CSX9ioswozsxaBY=;
 b=Id4cMP5K0dDpibnR+0gtMeEIGLq86P20pmzSYVD48xTA21iqF9KwAdfyLWbYQdhC3mS+axCKfhH7zMjPzDobOJaOzKuhzZBFlJ/d9vuuHUlRSjH2w8OA1CQ9wiDE8M3PMVDtJK+8V0E/u4jZMUywojWdmMIM0drL601UldPSEOrbpw0FII4gmFlU0dPB87wuyATFRRix7tL2V6lHg1prxmqZgdeYwIyhuQ4Ge0Wbj92XAXMkOpxrA7P7YztODGz7atHtAUUgDZHZNVDVsmjyD0Xg/S9Ra429feIyI3CaHOcfdgIK3rqH6hKQ4QprcWIPp/7bLTnEEeqLlglgLxfcYg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GefSnuI5k3vJrzNZcN7nrOZI3n4CSX9ioswozsxaBY=;
 b=OMd+yqJ1SozQHeTsRcA6gZB2F8NV1RlqGugTQ+dR06vPL+tdqMZmesOzIhXBNUeucXxSQ1X030+OUFX7vS2zqB+trZe4AUR2kAhZEKrAGtg2df/jAY1Pv4OvBM+7o0kJA36wq7SmBB5Toq9uCjjPCm74/CWvMQApLBJk2q9F5SM=
Received: from DU6P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::17)
 by DU4PR08MB10912.eurprd08.prod.outlook.com (2603:10a6:10:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 07:16:06 +0000
Received: from DB1PEPF000509E6.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::ad) by DU6P191CA0023.outlook.office365.com
 (2603:10a6:10:540::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 07:16:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E6.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 07:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snGCs5lVVKh/USC5af7TiJoDpjwPQ62/XnQrIqxsjnuU33Qf0uFPA805mBPiCS/3KDz+5cvukya0F7Xyr/BUW2BKNqkkvRDUyVizwhbTdPlSakmL9EizppP9NYw40b/HFsfAQFt/o8de+SjyoXUpvm215ToF9z6SIkji3Maqk8bPDASVpzXTe5BHjegfYQOj9fuE5Ew/NHGs5mCwA+RooOAOgJdBOdaDrxAIxm/zmOq+6dN8rvONJj1rlBSWw6+KmJENUEmmCO+DR40l03fKsBXLg+S8AsgpUFgOHiWWyWRcOCpKMdzZNHZDrEMtf1t9UaTuEixrYzCHLZ8liFHPUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GefSnuI5k3vJrzNZcN7nrOZI3n4CSX9ioswozsxaBY=;
 b=ZaoHbwU5U8zMj+WKBM/NPilWxPW5SQpIJsLkZwSBp7pDzdScru/vKW8RnAHLY26GGTYsAh8T19+GCoOhVaBS/Z8cirCCJ4R6hUSy/5lekWyMhvG8I6vOIqCCBjHBdBOvdZvw7o1rPkkLKj1EO1p3zQN9sGFDEAU2flFUY8+ICH3Qg937KbbMSnola5hX9h3zertqtLjOSywLMrLBuCmSZqaaEJKxmRix/4SWJ5cPNNp3SA5B4FqD3JaNXEyDWH15+wFFcz7rilWrQTsfq4Ppl9p+K2V95+zEeYE0wyC1Fcf0EhzZx2oDau7LBWYKyAuoybFNSYYOeiRTFB1eR08MAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GefSnuI5k3vJrzNZcN7nrOZI3n4CSX9ioswozsxaBY=;
 b=OMd+yqJ1SozQHeTsRcA6gZB2F8NV1RlqGugTQ+dR06vPL+tdqMZmesOzIhXBNUeucXxSQ1X030+OUFX7vS2zqB+trZe4AUR2kAhZEKrAGtg2df/jAY1Pv4OvBM+7o0kJA36wq7SmBB5Toq9uCjjPCm74/CWvMQApLBJk2q9F5SM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by DU5PR08MB10850.eurprd08.prod.outlook.com (2603:10a6:10:522::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 07:15:02 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%3]) with mapi id 15.21.0181.010; Mon, 6 Jul 2026
 07:15:01 +0000
Message-ID: <8a24f016-6f0f-4322-b646-d843f6fa481e@arm.com>
Date: Mon, 6 Jul 2026 09:14:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, seanjc@google.com, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, fuad.tabba@linux.dev, mark.rutland@arm.com
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <20260702142912.6395-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::11) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|DU5PR08MB10850:EE_|DB1PEPF000509E6:EE_|DU4PR08MB10912:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f24dc41-480a-41df-5445-08dedb2e7231
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|23010399003|376014|4143699003|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info-Original:
 P1AV/2ZS6xTdSZBzxBK02wQlpgtbEOgRYf9XGLwuuxmc1R9PV9kMfpPdLY4S0vB5SrayMoN4sA2Jx5ybg0IX+IGfH03oieXH2US0GEWd4oP5mD7K5H9Cl5Dcd6EfBJtDMgkdab/g8RxdPu8RB448LSO1ThKHYMkpL8msfHyH6Mp6ELs6mh0v29EZusC0hJS2OqnVFhyyN9uuhW7AJEGBwPJ0ilhHCVG7wj5KhKPXkYAXP363m4gFQnUdYvoCbCEGJDmUdjcP45yQ+4MDd7ENWeVazwWz6CVQue6Y9dXZoEMW3D8VovEUX1D5Gskw4mmW4ZTIaBRya5Gy3cG5tSlL5k6a+EEwIMYgFoU0qlK3CUC86BXmoUYJmiFV5hTlJuC/b22NPiiO0tdnShDJ6MM0U2wqHSaM1XlRkhPK6o8cr2YOC4R7q+J0WYJH3r5QNLGNfe/DkTBin/ryN2z42QK08Z0WP8VkGJjnRm0KYiecLjQM7ORuGMqhC8sCC717Uyl1EIYsqp3bnTTPUIyJ6kOodEDEYM8JmTH40lxGZxIp8thXNxqrmxCRKe0ks+B+wjYPAyj4QcEz7BgsQPHAtJ0VXEDEVC+kWWnQBRAwJ1zaC2LXA6EHXYNnSsF2YUWiHPs1uRSqnla9sTU7y8R/CKiWtvNloJmTGdNrvfoMqyoG1VYqZsCP1L0MnvSMPcnbrs2oVQLqd+KuiCSUPzH92FIb6g==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(23010399003)(376014)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 E074nzhqonOpShVLaqNNKjSITNoTbZMd8KZUlwCk4s21Z/+pAj94CzhbeVBgJ+HqsfdT3zMOH2wZM48iRC/gh/oMvPxQuQPER7Fd5E04BjmkeyWQPgvIMgMChhj/ovM15MAixUX+ecG2KI1gZkFayd2chK5mBjBdNawOugHfzDtT8easCTrLUMn2uuHscxXJNUYr1Nvja1KcN4xyliIRKiVBWhTu6ZcUSVeUz1WvcijZ2djwk210lOburfETVnne2E9B7ilSOHWD0mP7gtcF67KGdlLcLGNJIRtdsSu76qv+oucDiXwSllkNJpARk09XSigN+YtG61hS7RcEc4qwaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10850
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	28c8efe2-f378-4421-3d0d-08dedb2e4b71
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|35042699022|36860700016|14060799003|23010399003|7416014|22082099003|56012099006|18002099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	EiBENqBnFs0tkpfBJj3AFUR9IvAgmkIkK1O2yr/sfU5JGqzQONLNkR1TheqpcUPCzDN783HgTbW2mD46mFvA2axLug/dXR5pQdYsBtgH0aImkIVjzWYmiU+4erEFNvFX5lOQ/3RGqRk4ocim4XKT1+dXotlfUTKIZTSYJQM0EEW/B4OUxgHJPWle0axeqdr7uHKlJuG3wGwLdMir+ZXr6uT4FINGlm5BhP4mziuj4vhvCgATtAL2bX+627xyrRDMypW0W+BaasBiNDIRL80lhsAlcK1k7vSDKwUxMRtBc7X5ijsVyYvv320S8MKT4WsoOOKDjKcadyJuZfIHK4DQnh5VbsWne4lt6KnRpL3yAtPZ1EBQ9+2vxaNcR2uORo0xhZeiwX8TWglIt76CXMRlBQmJVo9afsNOWX15z0tIbIVbE9pkFxSudVykKHrVdFOn9mJRkMo/AhmKCD5lTPeDfg2RS9qsMfg2l6BKya7CXZUXuL9DfbzKCTtBjQ7fnZptnRdIVX7VauNjawXdnbPY+GPLEBs31wQqnXKPSp/6zgO7/avq837YLUNfrMgIb13nRyle8sWNdQRluuSaqE5FFJyQj8xcdZikscO1FJoDTglc+ruRWpK7A4uL8mNuCb168cZoPne6zgiUe8SWiYs2DwBxFIYy0NezdTR8SlH6szTI57C+LAkyKs/miywo/rcEmWzZ5xow3qPclPSFGzf3/7rBWbHm+8R383LUL9go3SHB2VRfcrItwmM7O+/He1WJ
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(35042699022)(36860700016)(14060799003)(23010399003)(7416014)(22082099003)(56012099006)(18002099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zvegiT4nzmW41o4arWkX8L1QCU8pHLPNLQGJ7MVXJbdHw88mP7qkocwWsUY0AN0vtTOwuU0KPmRJfwhyOrRN2doycPTBoEeKvltAlkMs1ekmWSplCefeLhrFekcjBRuW+s9SHAsgwbeAdZkMYy5gJDAZOY88S5RCUpLUFpks2esplhCVZBiB1frfn0novLQbaY625uUZXdALgzCg+tgwjwlw9StDztustMSgbBVvz+ELeWm1HLNVvUMMlQT1TBs4X9nDLqyYJFhxEHi5QiS/zKHtd1sASnnB3vvqfIC55I+3dDkh8c7YFMuDWAI0t/81WH0eIEcyX+uxk7m5exgwM26MpWnLOABHV/67g6NJUaLX17hUAB9tJFrgMlpeGheRTecOyeVTgP7Jp+Qz0fC24rjMxQDQs44+nZ+KjKBV3a2/W0lxCORi3i3twAOtJK52
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 07:16:06.2911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f24dc41-480a-41df-5445-08dedb2e7231
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB10912

On 7/2/26 16:29, Alexandru Elisei wrote:
> To enable memslot operations, KVM maintains two arrays of memslots, and an
> RCU pointer to the active (in use) array. Changes are made first to the
> inactive array, and the RCU pointer is updated to point to the inactive
> array, which becomes active.
> 
> The guest_memfd file maintains an xarray of pointers to memslots that use
> it as the memory provider. After the RCU pointer to the active memslots is
> updated and until SRCU is synchronized, readers can observe the old or the
> new value for the active array, and therefore the old or the new pointer
> for a given memslot.  For memslot creation or deletion that is not an issue
> for guest_memfd, as readers will either read the same memslot pointer saved
> by the guest_memfd file, or a non-existing memslot.
> 
> But when changing the flags for a memslot, readers can read two different
> and non-NULL memslot pointers. Since there is no easy way to ensure that
> the memslot pointer that the guest_memfd stores is consistent with both
> views at the same time, modify how the guest_memfd file keeps track of the
> associated memslots: instead of storing the pointer directly, store the
> memslot id and address space id (as_id), and use that to reach the memslot
> in the active list of memslots.
> 
> This only changes how guest_memfd keeps track of memslots, userspace is not
> allowed to make changes to a memslot yet.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  virt/kvm/guest_memfd.c | 95 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 80 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..43ef8e908aaf 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -25,6 +25,7 @@ struct gmem_file {
>  	struct kvm *kvm;
>  	struct xarray bindings;
>  	struct list_head entry;
> +	bool found_memslot;	/* Used for balancing invalidations when punching a hole */

Probabably best to document what it means, not only what it is used for (and
maybe document above the member if you end up with more text).

>  };
>  
>  struct gmem_inode {
> @@ -43,6 +44,29 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
>  #define kvm_gmem_for_each_file(f, inode) \
>  	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
>  
> +static void *memslot_to_xa_value(struct kvm_memory_slot *slot)
> +{
> +	WARN_ON_ONCE(sizeof(slot->as_id) > 16);
> +	WARN_ON_ONCE(sizeof(slot->id) > 16);
> +	WARN_ON_ONCE(sizeof(slot->as_id) + sizeof(slot->id) > sizeof(unsigned long));

These can just be BUILD_BUG_ON() I suppose.

> +
> +	return xa_mk_value(((unsigned long)slot->as_id) << 16 | (unsigned long)slot->id);

The latter "(unsigned long)" should not be required.

> +}
> +
> +static struct kvm_memory_slot *xa_value_to_memslot(struct kvm *kvm, const void *entry)
> +{

The following can all be const.

> +	unsigned long full_id = xa_to_value(entry);
> +	u16 as_id = (full_id >> 16) & U16_MAX;

Why the "& U16_MAX" here?

(1) It's an u16

(2) memslot_to_xa_value() never stores anything in there.

> +	short id = full_id & U16_MAX;

Same here. And I wonder why you are not also using an u16 here.

> +
> +	/*
> +	 * Do not ignore KVM_MEMSLOT_INVALID memslots, as we want
> +	 * ->error_remove_folio(), when it races with memslot deletion, to have
> +	 *  unmapped the memory upon completion.
> +	 */
> +	return id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +}
> +
>  /**
>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -157,7 +181,7 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *in
>  	return KVM_FILTER_PRIVATE;
>  }
>  
> -static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
> +static bool __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  					pgoff_t end,
>  					enum kvm_gfn_range_filter attr_filter)
>  {
> @@ -165,9 +189,15 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  	struct kvm_memory_slot *slot;
>  	struct kvm *kvm = f->kvm;
>  	unsigned long index;
> +	void *entry;
> +
> +	xa_for_each_range(&f->bindings, index, entry, start, end - 1) {
> +		pgoff_t pgoff;
>  
> -	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
> -		pgoff_t pgoff = slot->gmem.pgoff;
> +		slot = xa_value_to_memslot(kvm, entry);

That now gets more expensive. id_to_memslot() uses a hashtable, but there is
certainly more pointer chasing going on now.

> +		if (!slot)
> +			continue;
> +		pgoff = slot->gmem.pgoff;
>  
>  		struct kvm_gfn_range gfn_range = {
>  			.start = slot->base_gfn + max(pgoff, start) - pgoff,
> @@ -192,6 +222,8 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  
>  	if (found_memslot)
>  		KVM_MMU_UNLOCK(kvm);
> +
> +	return found_memslot;
>  }
-- 
Cheers,

David
