Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013006.outbound.protection.outlook.com [52.101.83.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55BA3921E9
	for <kvmarm@lists.linux.dev>; Fri, 20 Mar 2026 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003294; cv=fail; b=qXsSd5F5/GbQvQuhwrWmtZJVV1sfmNk3tcUXLlYE6rwnFpdrZTRCr2pGJPorn9c5zPwAQ9YRiiJajGKg5RAU3DIw+NeUuCA/jUnOna4786/zhffQ9rdr/j+8qS3fluZil6B/ccrlxHwHFZtmA5mN9NhYEUR3LXt45fsdPwsWCAs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003294; c=relaxed/simple;
	bh=ACdLe8Jl43WW1iYH/43aN8Cyrih3tzqdBt4xb8pyMXU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JB6hv/9v5phKA7iYoCi/LI+bBCQASjiD588kkjz2kKZvG2coWeFrhVMQErzJF5E02DmKxDMuXl/UkC31aeUyqwmWVXdE3UPWoGFpnsmschkHr4ZY/jZgolQXnJKBg9Lx2Bx9UU3n17rxHtxNRtDu0XeQria9hlhrNA7tuYdTiTI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EjPn7qEr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EjPn7qEr; arc=fail smtp.client-ip=52.101.83.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EjPn7qEr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EjPn7qEr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=euWvjy6Rq2EemTEeXkgRB8PITZqN7clwEYwJ+BwnnhCAbfKd0jatfMdCvC2QwnylJOklHWku3RuKGQe7Kw5J0Mu26czzicqnFTwju4Ake0SCUt/xj1Ms6733Gi1KKW0DNIIrS2oki9emJCUQSEANTouOgPu/0fDM20PwzhN/dISwN7aNFqxC9bmCIuLH3x3z/RPJlLILg46liRGWTnCz9GSRFzFVTloxxplr5oSwF4mZtNn+2axQ8wqAhKpLp/C/Wi8MelXgerIw/G51P20ybWGZzf0xyjslpfgihIzjspx0+cWGVCZz+nwwjmzePNBZdf/2/dWzNcSTb+ooDnF9fw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7/iaDj+68hTAwYfPyytYYnPIGiyQw/RNNb8std7zUA=;
 b=BdWhOjsPWI4UXXb7UAvHaScPEJrDvSPXBb+R49Fn8lua2Qxs5JYD8v6u7ld9bWz1e0BYOv0DJMeVzGcpNx1ZvbQ/xLP0/CrZmGOueV4sysPEs+RA4SGW3IN8dw2WrSE7zXM6gSRg3Bqhz5yi/qkoGp9TnoxE+5SgdH2odG3OY42IzDBu8fsBf2DqitaXtNyk4c/OXC+4duMHXJijI5BpojdcrAHu0hMsOIRUyJuR1TA3D4CvmRukAP4T1e+Ggo+jyAvqWfSSQtODAPx89YK9o6Jr8L3rXfi6CBKrXsuT6nB3STaZxmipWXEzAmqvgIHvdaykt+49hHwAh81Iq09NUg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7/iaDj+68hTAwYfPyytYYnPIGiyQw/RNNb8std7zUA=;
 b=EjPn7qErZdCbubpPn8n5U6qTTxcFPGplUNNReQS68sZhzTcX1lBaB4dPLoI7YPChq34C6ICmVCJusDuWNb3TsRxkVkeFyx2ycPAdBBTfns/HKvip6Qe4RrKWb3hRfMYzuinKLHpzZCnpjOlxIOBpUr44PAcljmWcUlFJ2dYxZws=
Received: from DU7P194CA0007.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::30)
 by DB9PR08MB8625.eurprd08.prod.outlook.com (2603:10a6:10:3d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 10:41:23 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::d) by DU7P194CA0007.outlook.office365.com
 (2603:10a6:10:553::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.23 via Frontend Transport; Fri,
 20 Mar 2026 10:41:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Fri, 20 Mar 2026 10:41:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P196PTTU9IgXD0G+hiHPwE7WmWyM5/QU64BbZNbrX0NOZJFn0iKiu07V7dUXKR+Bp8vrJEo7EIM/gyE8Cm6x1gjHFif5w2FXUeqI010dWhep80f6kmX3/y3JhYHw5Bh0ZrS2ABTVfvDhALtdADBOylh3hB24wxPADk2pHQj7aO0yjnNATYP+viApMzJ20XMm8GAJyoB1aPQWTejeulRjk+dEdTPs/TZE4/N8g8TNL10SC/yfUhdElhC2N4bHuiQFK+udKDkuOOWToTxsBxYBBGIWUA8EecMsNEDkr07X8aV7dZP2hYKRx8Mbs3qZegzuoD2LvNivzGNQ6hj4NQpIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7/iaDj+68hTAwYfPyytYYnPIGiyQw/RNNb8std7zUA=;
 b=hk+S1qSEUwL/TixgFiPT6Wbop2rcA8/fpkKHdskEqhvAoBzhlRJRQXNIzTUQRt1kGTo0JEyFX9r0U4JFpHE9mw2nlYqjuYcJtOyMszi7rG3Kl2EJtbyoKBHGr9PnKtC34SwQlBwI187miDzgZkq4FAsDrTUXIfn/rx5Uf7Xi/sU+3Et71vOIKvHn9VdDMRuXRq6ifdUFbhpGSKnNeUXQDC8DTMFVSXWJ31X3kPJfhgWUPNusqjC7djK6/34suDPXM2FWZBSYvUybYJExAEqt3c/5YRJgFUKefEmq/LyeM8PKTW5tneXXX0NRg+ZIjmUlUNzZOLEvP7dXVnph8wznig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7/iaDj+68hTAwYfPyytYYnPIGiyQw/RNNb8std7zUA=;
 b=EjPn7qErZdCbubpPn8n5U6qTTxcFPGplUNNReQS68sZhzTcX1lBaB4dPLoI7YPChq34C6ICmVCJusDuWNb3TsRxkVkeFyx2ycPAdBBTfns/HKvip6Qe4RrKWb3hRfMYzuinKLHpzZCnpjOlxIOBpUr44PAcljmWcUlFJ2dYxZws=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PA6PR08MB10663.eurprd08.prod.outlook.com (2603:10a6:102:3c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 10:40:18 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 10:40:18 +0000
Message-ID: <50c301e4-11b9-4e68-9159-e0eaf5f61c94@arm.com>
Date: Fri, 20 Mar 2026 10:40:17 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [kvmtool PATCH v6 01/17] util/update_headers: Update
 linux/const.h from linux sources
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 tabba@google.com, steven.price@arm.com, aneesh.kumar@kernel.org,
 alexandru.elisei@arm.com, oupton@kernel.org,
 Anup Patel <apatel@ventanamicro.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
 <20260227165624.1519865-2-suzuki.poulose@arm.com>
 <abwVhsU06OQOEdoD@willie-the-truck>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <abwVhsU06OQOEdoD@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::11) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PA6PR08MB10663:EE_|DB1PEPF000509FC:EE_|DB9PR08MB8625:EE_
X-MS-Office365-Filtering-Correlation-Id: 98faec45-7e2c-4aa3-357c-08de866d3a3e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 WFhWAo0mZKX99MlU/PNkR2hqEfL2mqz8u9OcUCUe1FXh1Ai/kII/4bNP3j2CruuhbjNWcQAFL296bDJRhZr4rkTKNqQkK5ZVNW4lB3r6Gun6rEwxILEuS9va8qMD6XN0VteZcE07TQkpoAld4sIv66AMiDpP32B2jkILLnry1CHv8yLCrofEQeohbLdJ7m9TwDseQcGwJTTUWFlE+L05qD9feeV2HBIMr3sS/1uHdq6zCWCQ2VXy7IADjdaE1bKYaWeRnqn2wajpuAR+CLR+RLcneU36VFIV+PLZtUm0letu83Hm0nyqLCBlkV4Ukg0hYf1Jk1fZjkSFzH/RiPcCD0BHIcEytnaBHtcNFVHxs9ASLnc+s3MCbXWCqDTfLyDa/d2Afso8JYOCaW9zzXYbYNWeTZakBq9nOkTs26i0gSm1JQP2ru51goxI1utI6BazLG1u+0LOHul+K6OysDNGDabtOOxbikrhobKK/v2r0tK6NnhE5NmU5lkWXpZJOxXnthnNrnkyhM1bh7i+DKzJJTe4Cuy8Jj0ck5cDip3rLm9PgCIQGiibvCIzpEr6jzvYIU5e+ug2CplJWkjM7ojuiSPt4AK+1QhneqosTVDSV2bysN+nv+YB3VzIs7IZDrSlyTSYv5IQOfix/wwrGLI/Ce9BcFTqK30taVSAHoVpB6i8sLZy9xD00BLF9723q5wvWiCYLVKZx8EekKhJNJOMUhh8Z/4j+kb2P11TxTm89oo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 kbM4UOygU4eLuJbRlkzAwOnrS3bB0oFEymD7QK4h0q4edQYhcAY+jU8pDqZ9/w7Vq+dqgV/K/QQEV5b89Nw94btcwxgY++mHFJSJEPuOVv2Dar42SNBwJsCSP2EKD7IC4TkgeL2T2ZNnhIUZVtp6v8fr5+Smk6B8nhUDy4P8JIF9hCxHU5hZ2+Bjg9wGkrJ/iOxsQV235BbM4GTqn9lsBjrQWFFUAm4xU9lIE3PYhbkww9gVtEF8vpRPzd+XmzbqvBrw0QAFfbvYly0quFOq/m/I8FJhdOIahD4d1iB3Ng+u8gMzHdCvi3OqfDZSNiBP8c2JC8cJgeIupkhY8GfZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10663
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1853d50f-27d5-41fd-dab3-08de866d1421
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|376014|35042699022|36860700016|1800799024|13003099007|7053199007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZYE6bWjQYNe71Pi8Q2TN07qj9ux/6sDZ1TLtUEdVuE0J5LpJ/Nn+DcDQCb3pYhjxTJelnsNLg3YtLiR+MZCvGLw3mrdEn0HmvE7RmzKbJsbsRMTtlR/a0ftw/JCmshH7sKWX0lLfyBuQT30M1nRxToqF8xhOMxEmwiE3CUsmuo2rr3u6DhWmTHbKVk8HkkezLMkdad8QeQNIQt3Gh6Jx0x28n0fP1eZBTVC9SuY5fACoaj+jZq245y5CK/XJtn6+AS0fOXa2TfT7uqqwKcKu9XMiseV3NEuyt4Hc9f9PS5uMO9TXZPoWt3UFmCMrU1gH9O5KKJWYO47OyfGr1vuetjHhIA4BttjRmB4AObihTrFCHtOzcDjdjFKzIOAe5gdVQz69Ba2W6lzhNFrM+gAs57Ke+gyNw2vvHN9JrxIydtgd/bVmZFzhTVhQvCqBBN9M9M8H8sno3PWNnsUuE2yY6DxFwoJABPmAygeWV3R64wvIvQ7VoyGus3B2dI3YhFrTy5F3R5Erq/Av/4EqnEgAhqnQP1nN3zJ0YkudMyZKgxjGtez4jlRc3LxUcRIx9aPzEsx8Dh0jAerM95guxT61TlpCKlwuE3Zf8R3KzV9ahI5HrbESL0xoZHAUHgXNYCAQK2XYn2D+6Qi+FRYL53eoiM1rsHE98CCn9GrJx8HkBYdC32ZNozz4BzmWYRMubyMeuHAJbauL1Mv8C1ezhgmatR3STvevebQP5f7SUhXj7KdRY9l89biygTart4VfTVlBOaU20TjytuEibbZMaEWVUA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(376014)(35042699022)(36860700016)(1800799024)(13003099007)(7053199007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ydT4MZ7ci9PvnVzlstSAuxglNaJrJdgM5ymlD2CUKLyonBLSjjw4FvB/C2KBWiBhCmWgpEYWegik+Bp01oWtiQuiUMt3N499Jprr2xjgPZRraJpF9npvcKa/Skrm+cocX9RHBeS0BwBPsuFNdqS1o+tzhiHgUaHaQGJHx5fcLk/9PA2l0AXMkXSKIROErmFha8CtEpwLsrElbggR/qB27NGe78K62qKbkj0fK+pEwLkoOxGoQMECkksJxMk55/6qCKEq8tIpkhQBsFQFG7qAwESHzWUYO/XtLaqI9rNds6P0R00dHv0zGmHWJAI8CmBnDv0MUoq56pZ77h15XnNn1onkQLit8oh6ZMbOrFW3ne0OmaY6bNcI0Mw05LaqoEQTgR87DNEDRC7jrd3w1iZbdxcdGBvn3vE8e+UQAfTVfQUerQAMtC+NxOFvifiKnEfi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 10:41:21.8789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98faec45-7e2c-4aa3-357c-08de866d3a3e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8625

On 19/03/2026 15:25, Will Deacon wrote:
> On Fri, Feb 27, 2026 at 04:56:08PM +0000, Suzuki K Poulose wrote:
>> Building kvmtool from scratch gives me the following errors with buildro=
ot:
>>
>> In file included from include/kvm/pci.h:7,
>>                   from include/kvm/vfio.h:6,
>>                   from include/kvm/kvm-config.h:5,
>>                   from include/kvm/kvm.h:6,
>>                   from builtin-version.c:4:
>> include/linux/virtio_pci.h:323:20: warning: implicit declaration of func=
tion =E2=80=98__KERNEL_DIV_ROUND_UP=E2=80=99 [-Wimplicit-function-declarati=
on]
>>    323 | #define MAX_CAP_ID __KERNEL_DIV_ROUND_UP(VIRTIO_DEV_PARTS_CAP +=
 1, 64)
>>        |                    ^~~~~~~~~~~~~~~~~~~~~
>> include/linux/virtio_pci.h:326:24: note: in expansion of macro =E2=80=98=
MAX_CAP_ID=E2=80=99
>>    326 |  __le64 supported_caps[MAX_CAP_ID];
>>        |                        ^~~~~~~~~~
>> include/linux/virtio_pci.h:326:9: error: variably modified =E2=80=98supp=
orted_caps=E2=80=99 at file scope
>>    326 |  __le64 supported_caps[MAX_CAP_ID];
>>
>> We inherit linux/virtio_pci.h from the kernel sources and won't be good =
to fix
>> it by including linux/kernel.h. Instead, pick up up uapi/linux/const.h f=
rom the
>> kernel tree. This also removes the ifdefery linux/kernel.h
>>
>> To prevent a build warning for redefinition, update the headers from v6.=
19,
>> remove the hack from linux.kernel.h in one shot. This was also discussed=
 in
>> the Link, in another context.
>>
>> Cc: Anup Patel <apatel@ventanamicro.com>
>> Cc: Will Deacon <will@kernel.org>
>> Link: https://lore.kernel.org/all/20250211114018.GB8965@willie-the-truck=
/
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   include/linux/const.h  | 53 ++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/kernel.h |  3 ---
>>   util/update_headers.sh |  1 +
>>   3 files changed, 54 insertions(+), 3 deletions(-)
>>   create mode 100644 include/linux/const.h
>>
>> diff --git a/include/linux/const.h b/include/linux/const.h
>> new file mode 100644
>> index 00000000..b8f629ef
>> --- /dev/null
>> +++ b/include/linux/const.h
>> @@ -0,0 +1,53 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/* const.h: Macros for dealing with constants.  */
>> +
>> +#ifndef _UAPI_LINUX_CONST_H
>> +#define _UAPI_LINUX_CONST_H
>> +
>> +/* Some constant macros are used in both assembler and
>> + * C code.  Therefore we cannot annotate them always with
>> + * 'UL' and other type specifiers unilaterally.  We
>> + * use the following macros to deal with this.
>> + *
>> + * Similarly, _AT() will cast an expression with a type in C, but
>> + * leave it unchanged in asm.
>> + */
>> +
>> +#ifdef __ASSEMBLY__
>> +#define _AC(X,Y)    X
>> +#define _AT(T,X)    X
>> +#else
>> +#define __AC(X,Y)   (X##Y)
>> +#define _AC(X,Y)    __AC(X,Y)
>> +#define _AT(T,X)    ((T)(X))
>> +#endif
>> +
>> +#define _UL(x)              (_AC(x, UL))
>> +#define _ULL(x)             (_AC(x, ULL))
>> +
>> +#define _BITUL(x)   (_UL(1) << (x))
>> +#define _BITULL(x)  (_ULL(1) << (x))
>> +
>> +#if !defined(__ASSEMBLY__)
>> +/*
>> + * Missing asm support
>> + *
>> + * __BIT128() would not work in the asm code, as it shifts an
>> + * 'unsigned __int128' data type as direct representation of
>> + * 128 bit constants is not supported in the gcc compiler, as
>> + * they get silently truncated.
>> + *
>> + * TODO: Please revisit this implementation when gcc compiler
>> + * starts representing 128 bit constants directly like long
>> + * and unsigned long etc. Subsequently drop the comment for
>> + * GENMASK_U128() which would then start supporting asm code.
>> + */
>> +#define _BIT128(x)  ((unsigned __int128)(1) << (x))
>> +#endif
>> +
>> +#define __ALIGN_KERNEL(x, a)                __ALIGN_KERNEL_MASK(x, (__t=
ypeof__(x))(a) - 1)
>> +#define __ALIGN_KERNEL_MASK(x, mask)        (((x) + (mask)) & ~(mask))
>> +
>> +#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
>> +
>> +#endif /* _UAPI_LINUX_CONST_H */
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index df42d63a..6c22f1c0 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -8,9 +8,6 @@
>>   #define round_down(x, y)   ((x) & ~__round_mask(x, y))
>>
>>   #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>> -#ifndef __KERNEL_DIV_ROUND_UP
>> -#define __KERNEL_DIV_ROUND_UP(n,d)  DIV_ROUND_UP(n,d)
>> -#endif
>>
>>   #define ALIGN(x,a)         __ALIGN_MASK(x,(typeof(x))(a)-1)
>>   #define __ALIGN_MASK(x,mask)       (((x)+(mask))&~(mask))
>> diff --git a/util/update_headers.sh b/util/update_headers.sh
>> index af75ca36..105bfc1d 100755
>> --- a/util/update_headers.sh
>> +++ b/util/update_headers.sh
>> @@ -29,6 +29,7 @@ then
>>   fi
>>
>>   cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
>> +cp -- "$LINUX_ROOT/include/uap/linux/const.h" include/linux
>
> Typo ^^^
>

Yikes ! Sorry about that, the next patch restructures this hunk
and missed in my test runs.

> but, tbh, I don't think we need to add const.h to this list. Unlike
> the virtio and kvm headers, we're probably fine sticking with a static
> version. So you can just drop this hunk imo.

Fair enough, I will drop it.

Cheers
Suzuki
>
> Will

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
