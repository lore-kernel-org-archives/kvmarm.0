Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013046.outbound.protection.outlook.com [40.107.159.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092312EBBA4;
	Mon,  9 Mar 2026 10:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773053514; cv=fail; b=G0OG4FGWtKRBlO4m1U3QT0QBcp70sLdZnlRn0nHE82+S/IRy/jHhM9BPDtt0+BYFzKm7zz0uhO5G2iN48GcB9wy/m7ZORO7BGZWe4Fevag1jPOPxpquUscGtHKJLf0omZs8zNYoUayXw56NryhKaGiIflSOPIeWRRRQzJawhWG0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773053514; c=relaxed/simple;
	bh=zfA+J8QaoShCqyUsJoOhT5tmn7dZLfyfGLZR7oT4X7s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FRShZsbzshzpSVxutLyyqp/mONxemzTiZVRxRG46o5VaHuk82s6RBfVxvR5dHeTPy8MN19RFnmxt/C3UftHwatyURgpfDMWVcJ9cEJwOfRz/H+z1c6gKggYY6uPJtcCw3RsZEuo4KINIczeDduMDhhye798bYdUPZb9/jnPhwug=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qlo6e/ek; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qlo6e/ek; arc=fail smtp.client-ip=40.107.159.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qlo6e/ek";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qlo6e/ek"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v1mwg3MTMBROVsl1kwaem3/LYq5pSFUzQZo7ma320u8Sg9c9h4kXQ0XswZ5aN8+UtuAGMFAUN5PQDiFZSlRhNDI70BK6uaxwCLxjDgEjJ3Ie3YHGQg6r4nR+GYHNLFLmbxa8zSBEPmKtqO11QtTn4kUy9qYD1SDcTeNv5VA78RJVQRUGOCS83VN/TYqdIRVIjLhR6mQSxgVfXHEy2ZRJ+MmHKRY7tUOdf9nwP8N9xrBQm3yYeEUPwXri9wihbWdTnZsnNInJWuprPOhExalNCjrD5Lm11yHnKEXw+u7NfOKgU39iF/1Cwhj0CsWSU6l6JU1Bg3+7os9wdm1Vc/lVzA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSr+ISUjhyY647e53JhkotixEBm++WU/2UZRlXF4DdA=;
 b=lAZq4vI8LD3eu3X3n9bGPUF0vnAKGEwSnGOBlFG/m4a8OuZstoBqEp0dkZTdDgdjw6dqIFmnktKyZBQI8b7qyNmEHVGCpZJlygvIz4nB1jN7uxaFcnqPiCV6C/NBKY6lR6BoTGlEVIzZLV0Hyqf1gTHydREaIy3DImfa8uUBe30boYLxVOo9qV1uLMc9gJ+WbX03UxgZPFFjRfLW1GrbQOGwPYolJl0avbUNbSaaYsVTBRWm5T7lt8XRwfvwd5IrpcuNdhbV+woVWt8DM5ih0JkC/HLo0IQh+7X5SwcL0+ZeFcARcXHPUoxEvTfQUPRp6ULJ5pMGt4S8MKa1L2prFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSr+ISUjhyY647e53JhkotixEBm++WU/2UZRlXF4DdA=;
 b=qlo6e/eksXOzRbnFv4eCps1bZCQWCofFTaw1iulKNOzU7gim1W/fU90vPbGuOi56SCw5joInQQMzHmRw7yEp+1gwIKcAPcmHs7Hs0j1d89HKiIvknNq13Za5VV74VOpQKL2czUcxU6OxE/JiqLiq2eWlXS900snzo1xOhmMamSM=
Received: from DU2P250CA0006.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::11)
 by AS2PR08MB9872.eurprd08.prod.outlook.com (2603:10a6:20b:593::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Mon, 9 Mar
 2026 10:51:47 +0000
Received: from DB5PEPF00014B9D.eurprd02.prod.outlook.com
 (2603:10a6:10:231:cafe::67) by DU2P250CA0006.outlook.office365.com
 (2603:10a6:10:231::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.24 via Frontend Transport; Mon,
 9 Mar 2026 10:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9D.mail.protection.outlook.com (10.167.8.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Mon, 9 Mar 2026 10:51:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhpIGvAn0JthGCPOGdRUaHZx200NNBKGnLNYKLyUCDHcQbl8M/aYScjsOn3tmY55N2ea+kG2NJ901gZ8PDMSTv6GJESeHyHT5moVYUkEi4FMnut5NYXL/Q/+pOQMJ+EA07kXk/I3BWM8Mx2HxnuvmPNfsrqDfaXZmSp0HjXdHGoSLpF9NuPc1N7poHjmHOy3HwzWu39h79ONvZeh2mDMl9yQM6R+X1BN9sYGETv3Fa7Taa+p3l9HAy55IEE6S1veOxbKXWTBTpIL2CsLnZt2Lz+OJ1o232a/K4cTljoiEd3QET17EI7y8qBWBa26BMO8dvr5dnd5EZRxpGvo03dv3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSr+ISUjhyY647e53JhkotixEBm++WU/2UZRlXF4DdA=;
 b=P3uCNB3ssfF7oqGr9gSrcKKRVhhX1icIBIYglMt2eCUk32sUVPwyQ5SYX/CsqdrNtoPJ26sD568ZY421VV/nmvE7HX0LtxNfElcGUVvztMVEDo+7FvHyfBJAECVH3ZZs+8a19u3FLvEgGK06bSWww18oK7POONUa44TaQFFyCpVwt8e1qqr7AjUBFnuSra5AQMJ4YnrFN2SLlVTzb/GHHZMpKMoLtQCmgaxYOQSEV95Lh+kib2HvQE3AsxEmP+qdtbejbhOeFaY6tF/yFL9RtbXpuN2xk2a7WSRHw3DWzJPhXPy026bD9SjMLC0Bpawol0cGxJB8u8eicgxe5CtZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSr+ISUjhyY647e53JhkotixEBm++WU/2UZRlXF4DdA=;
 b=qlo6e/eksXOzRbnFv4eCps1bZCQWCofFTaw1iulKNOzU7gim1W/fU90vPbGuOi56SCw5joInQQMzHmRw7yEp+1gwIKcAPcmHs7Hs0j1d89HKiIvknNq13Za5VV74VOpQKL2czUcxU6OxE/JiqLiq2eWlXS900snzo1xOhmMamSM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by DB9PR08MB6538.eurprd08.prod.outlook.com (2603:10a6:10:23d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 10:50:43 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 10:50:43 +0000
Message-ID: <c25f3615-c835-493d-8262-ff5541dee4e0@arm.com>
Date: Mon, 9 Mar 2026 10:50:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] coco: guest: arm64: Add Realm Host Interface and
 hostconf RHI
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>
References: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
 <20260309102625.2315725-4-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260309102625.2315725-4-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0662.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::18) To AM0PR08MB11754.eurprd08.prod.outlook.com
 (2603:10a6:20b:743::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB11754:EE_|DB9PR08MB6538:EE_|DB5PEPF00014B9D:EE_|AS2PR08MB9872:EE_
X-MS-Office365-Filtering-Correlation-Id: 548e42ac-720c-49bd-ed51-08de7dc9dc1a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 weQkGPxCK7YWzkEobu5oHXByGMkFSVSKUcii6z7+tAMvCDE2Ur75B2KZ2GI2r/V9SjSUHyatmf5lbsmYNizxeEleQXRFTWzVrdDPRdRmQLG8xJicKxRK/thwqK4FpGvNAXa/ngf24Cz71bVSJhFLzw8clS/o2SHmJQsmTK1t42V/bbIY1jY98VZYp1/5Z2G/NB0MgpnnDkMcRNpx70dByQEY7DMvhIqQZKVixbqfFmHs4VTP448gcsCCh37wgIvaQIRS65gYYrqQG7iig1p0/Uv3dlXW7MR7+Zhzy/4lxvwGheySpQNTj2QexEK/HbD2nVM8qxa+ajsHTgumVLKUZ4RHMYx/bDg3dhY+YVXIcBqy+roTl4vXBjsGfAoEkbj5U/dntrvQsPBPxo1ZMJnwuVLRnQgbSvZRlUW9Gp8qgBI9OGn6HWnuj5bqEWZBoGfkCz9KQhd709gJnHVWkta7HSHC3T8A8a8Aj+O9s1ZhoXTsyJdkegRzw0GTzWO1og3YgnaTlihCV87XNjke0SV8+SaW6CEmEL8gLuXiDVMRhqH8TWGpH/I7E3VjmShslS1x1y3KfGgK1uGJBixUwFTJpIbpGelHikkiHkQqA3SSxzSiX/C54FxX4OUW6uerM83067jOqk3C1O1Uyro1+iNsEdNSCDej3FSbO474YeijpNboXp9/BX4abYnWdZa6Npxn30RFlnJRP/533S4qaLZkysSe9lZv7N1rS5U/fbGtFg8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZFVkFXPKpREDKe4NBimosTJITlbQPJrCySKiXOkQZweK8/ZlZ+Fyvfipy0XcuBQFyjXppOXJXJd6KUM4xX31o5I1G2Je2QBs1UscV/8rlFhqWEMbMXMDcawLhRUzNaydV6c5woYa/8l1WQZ+cmFqongkeFmz+Z3m/i7rtRUB3eL56ndpXTgLNZ4jhkS9kTHQTO+VWG9es/Q484R81MssADHjO0DgjMc8g1SocOd5URS/Qg59OAEtFhBazs0z0P2t+c68xSICUeIo0O29Rc8+S3ksG0+cZBQw9U6/UGv1n0dIjeAHGebui4uRK5xiDXdti5zHs/Qs1mFtl1TeNd+vxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6538
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a7194dc9-6204-4512-c8f2-08de7dc9b621
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|14060799003|82310400026|35042699022|36860700016|7053199007;
X-Microsoft-Antispam-Message-Info:
	tV/jK0sA5KTIMAD3lfGlkBC31kggv4JsI25x7qkNac4WsrGsYyldMWwDm3TTLFcM1ShyS6l64eWONmlkbcdO7NavY0+n6NndgPQEKJEFxlQYDbVbocAoa22mtk5l1IpuklZaShp5FL9p/ZKqDV8cPdQRooqL4G3fVRXrt6/VbxCZeztLBtGlQYICnRbiUwzbxvL/N+Wo0VzGw6K03zsqhoOJLCn00mplBYSffgpxR/HlnawAcEabdVVf0Pxwy3lNJhYS75y/bsvS0cF2FJ9L5oiuJryZT19/ORrETYqgViKCQoTmySjKIwGHZcpFwJAgknKJHdoDsbLUoDqLN7D9RwaQB8dAng2v6GKYY0CH8lpg6KnL+142MUS7zkSSxJOJjuzDkFnYLLO9FmZMvHmNyRAvSn0egKsyYVdAfQfB+cm0IAN6cZhNSsYBybUvHtZbGozBEmX+fLkqPttIG8ewpvd/EW5Rh8GljNClT3HGcdkKTzrtOUn/4GdHoc8C0OevmyvCIK2Xx1X7Vc8SfKgk3Wk8CrkrPC0nrtVdNE8xhbEpD99qc14P6YyV9tnTAHFMgHYNtJY7Gn1kfFOjNUVr0l0rHAYmJ454tmT6jHjeuTrFZEjOXhJLwrW3UrNBCedH55AIaAuu4/DZI8pQ5LNUrIPDdKgcoQAid5sIISK6OJBThhKHUBYgBKs+Y3uh22OizBw4pXp+K984HF+BPlZq3zH9uLvIP9ybePtNKCMVPyKnFkKDxOVi74ZprjDsygj6UfZc4GhgkwqBrfAyex0oFA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(14060799003)(82310400026)(35042699022)(36860700016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NF8ShY/43xUKWWY+9iuRHbI4MeySAz4axsbv/dcsJ6RzJWV8TUILw3Q0mhL9FjA5pUY0n1F71wwA2xPsC+bD0KVz0O4SjPHFUCMVVPW+h9tmxrvkEZE34VeCcQUTyUxyOrQYq/nELAztIVKykQGuvwLezFWCguK/uhUqgLpNgpb8sQzbpUYwV6+1h8y6mLfnK7WtqORbfYfFglJeQ3+5Eg/NYdi6A0l0PVfiNeqBVw8URpNZ0Bh6TfvemAVPhxmZp1WNTF5UsVurlvlTTjokY+vQ8EyZNSbtryN0heaanBai6Xv3W0ASLHrobsthcokxUNexfHbK9JowpjxykFXnojEWsIhfBKPwuP51pSB9Gh9em+oBisfp3mOf/4nSoumndCly7ZdRAdnRd11Z6W7lfAgaNcOLvnkM1TM1doplMoPOhIyWJ9ZVkKDLPi4FAPdr
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 10:51:46.6599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548e42ac-720c-49bd-ed51-08de7dc9dc1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9872

Hi Aneesh

On 09/03/2026 10:26, Aneesh Kumar K.V (Arm) wrote:
> - describe the Realm Host Interface SMC IDs and result codes in a new
>    asm/rhi.h header
> - expose struct rsi_host_call plus an rsi_host_call() helper so we can
>    invoke SMC_RSI_HOST_CALL from C code
>   - add RHI hostconf SMC IDs and helper to query version, features, and IPA
>     change alignment
>   - derive the realm hypervisor page size during init and abort realm setup
>     on invalid alignment
> 
> This provides the host page-size discovery needed by previous patch that
> align shared buffer allocation/decryption to host requirements.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   arch/arm64/include/asm/mem_encrypt.h |  3 ++
>   arch/arm64/include/asm/rhi.h         | 24 +++++++++++++
>   arch/arm64/include/asm/rsi.h         |  2 ++
>   arch/arm64/include/asm/rsi_cmds.h    | 10 ++++++
>   arch/arm64/include/asm/rsi_smc.h     |  7 ++++
>   arch/arm64/kernel/Makefile           |  2 +-
>   arch/arm64/kernel/rhi.c              | 53 ++++++++++++++++++++++++++++
>   arch/arm64/kernel/rsi.c              | 13 +++++++
>   arch/arm64/mm/mem_encrypt.c          |  8 +++++
>   9 files changed, 121 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/rhi.h
>   create mode 100644 arch/arm64/kernel/rhi.c
> 
> diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
> index 314b2b52025f..5541911eb028 100644
> --- a/arch/arm64/include/asm/mem_encrypt.h
> +++ b/arch/arm64/include/asm/mem_encrypt.h
> @@ -16,6 +16,9 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
>   int set_memory_encrypted(unsigned long addr, int numpages);
>   int set_memory_decrypted(unsigned long addr, int numpages);
>   
> +#define mem_decrypt_granule_size mem_decrypt_granule_size
> +size_t mem_decrypt_granule_size(void);
> +
>   int realm_register_memory_enc_ops(void);
>   
>   static inline bool force_dma_unencrypted(struct device *dev)
> diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
> new file mode 100644
> index 000000000000..0895dd92ea1d
> --- /dev/null
> +++ b/arch/arm64/include/asm/rhi.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RHI_H_
> +#define __ASM_RHI_H_
> +
> +#include <linux/types.h>
> +
> +#define SMC_RHI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,\
> +			   (func))
> +
> +unsigned long rhi_get_ipa_change_alignment(void);
> +#define RHI_HOSTCONF_VER_1_0		0x10000
> +#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
> +
> +#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
> +#define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
> +#define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)
> +#endif
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> index 88b50d660e85..ae54fb3b1429 100644
> --- a/arch/arm64/include/asm/rsi.h
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -67,4 +67,6 @@ static inline int rsi_set_memory_range_shared(phys_addr_t start,
>   	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
>   				    RSI_CHANGE_DESTROYED);
>   }
> +
> +unsigned long realm_get_hyp_pagesize(void);
>   #endif /* __ASM_RSI_H_ */
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index 2c8763876dfb..a341ce0eeda1 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -159,4 +159,14 @@ static inline unsigned long rsi_attestation_token_continue(phys_addr_t granule,
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
> +{
> +	phys_addr_t addr = virt_to_phys(rhi_call);
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
> +
> +	return res.a0;
> +}
> +
>   #endif /* __ASM_RSI_CMDS_H */
> diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
> index e19253f96c94..9ee8b5c7612e 100644
> --- a/arch/arm64/include/asm/rsi_smc.h
> +++ b/arch/arm64/include/asm/rsi_smc.h
> @@ -182,6 +182,13 @@ struct realm_config {
>    */
>   #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
>   
> +struct rsi_host_call {
> +	union {
> +		u16 imm;
> +		u64 padding0;
> +	};
> +	u64 gprs[31];
> +} __aligned(0x100);
>   /*
>    * Make a Host call.
>    *
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 76f32e424065..fcb67f50ea89 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -34,7 +34,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>   			   cpufeature.o alternative.o cacheinfo.o		\
>   			   smp.o smp_spin_table.o topology.o smccc-call.o	\
>   			   syscall.o proton-pack.o idle.o patching.o pi/	\
> -			   rsi.o jump_label.o
> +			   rsi.o jump_label.o rhi.o
>   
>   obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
>   					   sys_compat.o
> diff --git a/arch/arm64/kernel/rhi.c b/arch/arm64/kernel/rhi.c
> new file mode 100644
> index 000000000000..d2141b5283e1
> --- /dev/null
> +++ b/arch/arm64/kernel/rhi.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#include <asm/rsi.h>
> +#include <asm/rhi.h>
> +
> +/* we need an aligned rhicall for rsi_host_call. slab is not yet ready */
> +static struct rsi_host_call hyp_pagesize_rhicall;
> +unsigned long rhi_get_ipa_change_alignment(void)
> +{
> +	long ret;
> +	unsigned long ipa_change_align;
> +
> +	hyp_pagesize_rhicall.imm = 0;
> +	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_VERSION;
> +	ret = rsi_host_call(&hyp_pagesize_rhicall);
> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	if (hyp_pagesize_rhicall.gprs[0] != RHI_HOSTCONF_VER_1_0)
> +		goto err_out;
> +
> +	hyp_pagesize_rhicall.imm = 0;
> +	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_FEATURES;
> +	ret = rsi_host_call(&hyp_pagesize_rhicall);
> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	if (!(hyp_pagesize_rhicall.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT))
> +		goto err_out;
> +
> +	hyp_pagesize_rhicall.imm = 0;
> +	hyp_pagesize_rhicall.gprs[0] = RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT;
> +	ret = rsi_host_call(&hyp_pagesize_rhicall);
> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	ipa_change_align = hyp_pagesize_rhicall.gprs[0];
> +	/* This error needs special handling in the caller */
> +	if (ipa_change_align & (SZ_4K - 1))
> +		return 0;
> +
> +	return ipa_change_align;
> +
> +err_out:
> +	/*
> +	 * For failure condition assume host is built with 4K page size
> +	 * and hence ipa change alignment can be guest PAGE_SIZE.
> +	 */
> +	return PAGE_SIZE;
> +}
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index c64a06f58c0b..6e35cb947745 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -13,8 +13,10 @@
>   #include <asm/io.h>
>   #include <asm/mem_encrypt.h>
>   #include <asm/rsi.h>
> +#include <asm/rhi.h>
>   
>   static struct realm_config config;
> +static unsigned long ipa_change_alignment = PAGE_SIZE;
>   
>   unsigned long prot_ns_shared;
>   EXPORT_SYMBOL(prot_ns_shared);
> @@ -138,6 +140,11 @@ static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
>   	return 0;
>   }
>   
> +unsigned long realm_get_hyp_pagesize(void)
> +{
> +	return ipa_change_alignment;
> +}
> +
>   void __init arm64_rsi_init(void)
>   {
>   	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
> @@ -146,6 +153,12 @@ void __init arm64_rsi_init(void)
>   		return;
>   	if (WARN_ON(rsi_get_realm_config(&config)))
>   		return;
> +
> +	ipa_change_alignment = rhi_get_ipa_change_alignment();

minor nit: We reset the alignment to 0 if this fails. see below.

> +	/* If we don't get a correct alignment response, don't enable realm */

Do we need to enforce this ? If the Host doesn't implement this, we 
could proceed and the guest might encounter failures in "sharing" in
the worst case. Otherwise, it could proceed. Eitherway, RMM guarantees
that the "state" of the PFNs are stable as reported by the RSI
calls and the Guest knows exactly what has happened.

Suzuki


> +	if (!ipa_change_alignment)
> +		return;
> +



>   	prot_ns_shared = BIT(config.ipa_bits - 1);
>   
>   	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
> index 38c62c9e4e74..f5d64bc29c20 100644
> --- a/arch/arm64/mm/mem_encrypt.c
> +++ b/arch/arm64/mm/mem_encrypt.c
> @@ -59,3 +59,11 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>   	return crypt_ops->decrypt(addr, numpages);
>   }
>   EXPORT_SYMBOL_GPL(set_memory_decrypted);
> +
> +size_t mem_decrypt_granule_size(void)
> +{
> +	if (is_realm_world())
> +		return max(PAGE_SIZE, realm_get_hyp_pagesize());
> +	return PAGE_SIZE;
> +}
> +EXPORT_SYMBOL_GPL(mem_decrypt_granule_size);

