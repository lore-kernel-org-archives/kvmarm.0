Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011044.outbound.protection.outlook.com [52.101.65.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D539638B131
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 19:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550545; cv=fail; b=Fke66rS1ukrTAD+r8oJeA6wcLQr+Ak56OWBMxa/Xz9TEhPfpSzgG7brAx3DhEE/xro2VLvRC7oCGlNOgSj3fQbsATsP/S283alQeumhDEHCR5sc2YkobVqPs+2R9BpHzLnphtzagRGM7gEFrajgv6tGCY1mDwofIZ7/Jr0D1Bxo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550545; c=relaxed/simple;
	bh=Jo9Ae/YkdvTH1rY5kWWwih/GLbUPLkVcexEBRdI4jKw=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I91UB9ypKfjVc0SRsQr5zhyhDefzPsx2vwpowy28UoTf3W7hFowGwAIUu9b6PgZnNCfuy5wZ4SshwX3QlPcDxJ5olC0XfQBmPsYFATv0UuTpT50/IDtwiCXUyfn0QBa/XxD0XvfMLV5JEGWgRU8RujumOGXgvUsKfWuONwFgvMc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c6AaSEfF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c6AaSEfF; arc=fail smtp.client-ip=52.101.65.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c6AaSEfF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c6AaSEfF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Jev+5kdkcJ6s3wxbm0oKvsyiRNG7ceGs58LlGWKESqx6qFAqKdmSKopLM1OncS9HC9vHWzRDvx1wNQ1AMta0AQdKL1KSOfmGSYYJN2Of8Ba6NmlXxbDSyKW97Q4uyIjjAiY9ali5sQVEWUF7HsKxewivfV4yEy2YA2LajHaSXP3ArXm+mxKNTaGBjyLXwOWAWUAztDBBLDiyfOGDSbiq1Tqv6vr7qpZYRJ7nolW+7OlpdGbAFi5UC9SNrEr2/YkOdOIBHLx9wwdIPiZbW8JDY7jn5MvRcLoNNXvg3ZYb1MEZpKT7Ts5O/OT21X9PHCFPeX/PkqrrK59TBHXdjfCHeg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiMDfupvmBnKcQDVNJYmXU+4M8mtIit8PGAQ0lTji08=;
 b=Woaoq8XXXEGCdBTbXcsIwT9BT6iUUz0ioDS1Wcw2WeHxJDaAK4GBuyeqCpws9R5zGsl3Yh3PZxtEoqJbky0VfiR/+jf7ztMTa95ORfRAbluvLSgWlCDUbj/Xg3mR51xMAIcGks9ivoxisWlIsT2w3uoSVKErydFhEXVgtCcQC/hDeq/WZC09jRvO1gC7ZyLRZegSp18N/hCeoQVZX6IkOPRMrF95v3w/0d9ecTvnEoikV/RJ97VdnL9yo60QY1zkgjUznL69HgFNwVbxpOrCwk0voe+6cazfH9jlOWK1Dvvnqycj20qKRMkwZP98T8+VQr93/Cg7st1CR1uOu7EvEg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiMDfupvmBnKcQDVNJYmXU+4M8mtIit8PGAQ0lTji08=;
 b=c6AaSEfF0ZbSTPD1qzUhdYQvNAdEkREsWRaRCOE0jEdDdgDap1cusqnz8OmMI8xZQ7UzWe2E+KPSFN+WCPwgDlbUdB0tpc0N0zEpd8/pA/PXhveKm5my+F8IcWKrzDBzV0nKp0KQ80g9QbLXgGFoic2VfobyN3xRQXdQwOyDmPU=
Received: from DU6P191CA0071.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::28)
 by GVXPR08MB11787.eurprd08.prod.outlook.com (2603:10a6:150:316::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:08:57 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::a6) by DU6P191CA0071.outlook.office365.com
 (2603:10a6:10:53e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:08:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.7
 via Frontend Transport; Mon, 15 Jun 2026 19:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVWZZGaEMPdIIrv2jgNEQKpZhqxVAmLnFkUe2EDPzR4+uzZL2ipRzPkrO5pP2pGSs86vue3B73+GlVOFW9FAUiZDEwrwfymKQGu7196CaDuom1QpAul4HidgBYALMwJJc5e728BMbQ1E9KP8gXxIdqSbOrQwgtFMxXxDsjZsE2diYqBQ0Tn/wfOJnz0od+yY0y8fTJ7gs2jn33Gwd3kxJBLERXyuEB+wNBdXDKGZIC9mxkJS+q9IbhrwsHygOFytTQjFDrrOgHNlDy9rv6qBcuOPNI9eHqTOLUUU2K02v0mD3nOkqgGP5HJ9CY1K4GXzfIOehe0ABbqsNl2ABfXISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiMDfupvmBnKcQDVNJYmXU+4M8mtIit8PGAQ0lTji08=;
 b=PlHMhHtOKNk6iHY3PyQW+ICJxi150EGzb2Qg4+VVX76iuS6s5JfxbTEv6jXqwk4OvUq2TS/s66ZGZ4g2f3zAiDYaWJp2O62OzIXqkE3l/04C/QtH7GaOUoszmxPVnat3wVPTIlbdswL90+qPoI1crpRpO0Rx/4EYjpOS6eIZhCySC8hLyZnQoF4rRimM8e61ZYCms6CL6pQtUWc8bJr7EtwvWBmN5WX2nfc8CCOJ/YhLqAcOOschhzH1rnms2ApEaT++ZX/BYWLNT/7tuWZlOpgOSxyDyZlmhpBhQmxyTUcE9vkl7mHI7GdP8Eh2X6MEz0u8SPxz8PIrV7g9tzhPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiMDfupvmBnKcQDVNJYmXU+4M8mtIit8PGAQ0lTji08=;
 b=c6AaSEfF0ZbSTPD1qzUhdYQvNAdEkREsWRaRCOE0jEdDdgDap1cusqnz8OmMI8xZQ7UzWe2E+KPSFN+WCPwgDlbUdB0tpc0N0zEpd8/pA/PXhveKm5my+F8IcWKrzDBzV0nKp0KQ80g9QbLXgGFoic2VfobyN3xRQXdQwOyDmPU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by AS4PR08MB7926.eurprd08.prod.outlook.com (2603:10a6:20b:575::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:07:53 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%3]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 19:07:52 +0000
Message-ID: <42323088-c06e-42e2-b095-136062a8d27c@arm.com>
Date: Mon, 15 Jun 2026 21:07:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org,
 oupton@kernel.org, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com, mark.rutland@arm.com
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <20260615155244.183044-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VIZP296CA0009.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:2a1::9) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|AS4PR08MB7926:EE_|DB1PEPF000509FD:EE_|GVXPR08MB11787:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c187c4d-e4fc-4f16-11ea-08decb118cb7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|23010399003|18002099003|22082099003|921020|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 zeqd8XA+xdJgF/AqkQTs5hsHG+h82h8wxxOUZlDDDmXUAQQjD9KursuQi7iKPJOayhJI1KsAai1UZzY0LAtdtOdsrDbw1intMEh2D8xtE94whbFV0PpPbiDGvC3FZ1VrcdlhG7I5D/u2cU3dOACAmhxMH4lH12q660LoXvwgWHX2z3BVc7FmaoNxYy+w/rz8KKxE3nZGpaWOoykTZOsNyAYFjMeVFLOTo3/b3nSVZkFSQwpP2XqTVf0fBFu4ugvIHvBD7xvpLGLvyEjEuWyolYEFJiSzr3BdaRm7PD8izz8IOP4kruHyMeHPUrI93LogUG815GFSQuGrxXeue8TPDaP/V6X6LdSCOdjnb0GSGsphjWqDOXLlxCeLIdDOLiPuWdcnMsVyPrc53TMuHtUNzlXVJfnvv6b8ZtJvQZRpzl+D7eCrt+eJvU4AVwtpvZI0rWyZkD/leX+hbhxfAphmz/WxIpXhIekhoV1MDlm1k1CmckR/Ac/eQES85Np9XLiXRiLcG10OAFLADMT6+Ogha5PrahKcRxE8ErpTJuZ+r9XYda4zLvWDJKVnMX5aAsuzJwYoG8vVPKUO/KhjBwL7hb0UFSHGhrlc847tlzPQnKBiQEEei1Mr3gIhhxPTjHVZeE5Z6zNkaI3+Ju+hT0NVTnfWlsqJUp7BfFdy8pOyDS1oYr+t1Byet2LRjl/kNqJ53oAvGUBtRHOqreYgxmGzrM3fgR8PYUnoTvqNh3qgfy0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(921020)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 lHiRR/b3ZzXHuy7eK8RDJ5nYxIR03SQlZJPFViYL+Fei1hACCuKFgyOyKTp42nPGB7zAFa9hgpQvn3SSpCfxR/Dp19y/zbZjvyu9WFMg5hGiwvhgVhPtf0OcAllwXEbYueBNP1pk7wt1W8d9hmszklQyKba8cyru5+2M0QYjU5kjileKCLD0Dpqnx6DCcsZwJD4R4+oOs6Y6QxvBibIysfO2Gl2ANHNK7a3A2n/zhY5L/im2/DcKHcJi1T87euK+7rPuTN6cE3NMfU/s0e3l3DO1bWTHNUZ47yjN09Y9QraVojvTMVPq7Pd7Y2VEKa2T0Qzv2imOzAlB+5IjvNmjng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7926
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa7919ea-0956-4f2a-a1b0-08decb1165eb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|14060799003|376014|23010399003|35042699022|18002099003|22082099003|921020|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	TkATu357dyY5R4qltTS1wt0OATaKaxet5Mqm+ku72MJy9Mgi8aX2DTp4wl2CennKc7pt3CD+i2mABJ9Hhkn3XXJJ84Kubbr85UKN5rE8s4/spG+SMhz8Qth3glicDJJ/ulczgJnsVZY3ozKoNbW485hRG6KsHVUCUc/8Tg94Cyc1+KrgxJ0InZ++KOTSSY/nc179NU6vDm75VkUr76T8sZ57vdNsJM01bPpH3/QiCmuVjsKAOsfdPqU1WdnCHOabTv5s/bJCbQn2u9STJ9bICpaJzbFMkSolVb6NFW29bED8bFKXylvk5I0g8oquf3ftNgi7vcpgy0QVDaXly2+7SBn9gYW5axieiiMy2nFjj7SXL1HEnNgkuW2L650J2dwbI8FOCBsLOepGugaFd2H9LKfkkNAyL780CRdLKMY34YVTN/7Z8uCb3gCGDcaAvEHCVYEstS/+aq9vprkKZY5zTjTwiw/qt5Kcj7O96ZULe+xuwo/UeRjFz9UIO5YMkpar7D2dH+pPtxf3LaZM1f3JsZNKQkNO+mrbcWEWlKpvjHNMmp3yYKd9/wU4omeT7m5RbyyKzvvcybmxhPAboowog+5IH3s5NcpIJGeZaaRNKDNSx/kHxfWWiosPUpIrHQHNk7u68MPqLyd0YdWZabe+qmeRwNm+CCOrfCfVqw3FdwvTkw7mnhxek9jvlJCdGBe/0Sl8MIIZ+ezON5RDFulOKlMPGxfxbNg4+XMcYTM78+DG8Gr7bcys+/acHGOn62gTEQ3djA8E2Yv7nhVGGz3koQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(14060799003)(376014)(23010399003)(35042699022)(18002099003)(22082099003)(921020)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ezmmE3vXJ/biG0bWBwq52MCLm2mB0XrJ1YjyoXdXGIXC5d03QYxezoYgaAvcD28j6ipKx9JPm4dIlcXwrD/axal+CIkIML+FMVct+fNb8DUko1crlzI5Tn+jG9F0OiNCDLTvkcw01oNblN0JkBUGlkXDd9qGZ7n/lyUUPEDY/L1XD88IYEoMm90qMFlaegNlG8XKCpInwSOi65Ms6sj7ouWgLkO6W9WhERbPVWBaFoD9NW/qZ7d4y4o0wIenCW5dEyR79G+MJf2KplwcBWC2npRkGWsDVLsCXXUDzc0MTwNd4xRlLAGtJ3gHZ0OwOJrYIkQTfbwkQI5wZtPyi8IITum2dbqvGdgkSZsTfeS+Y8dkm5dnEc1Im9c9VQObXG7W8EElAljYJ34DG+IX1nmTysMEWp+Y1VTcsHOFWyZS9j1feXtP+GxYVQmJcW8LWN4u
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:08:56.7810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c187c4d-e4fc-4f16-11ea-08decb118cb7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11787

On 6/15/26 17:52, Alexandru Elisei wrote:
> For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
> memory provider for the virtual machine is the guest_memfd file, not the
> userspace mapping. Faults are resolved using the guest_memfd page cache,
> and the permissions for the secondary MMU mapping depends exclusively on
> the memslot (i.e, if the memslot is read-only). How userspace happens to
> have the memory mmaped at fault time, or even if the memory is mapped at
> all into userspace, is not taken into consideration.
> 
> guest_memfd memory is not evictable, is not movable and there's no backing
> storage. Once memory is allocated for an offset in guest_memfd file, the
> offset will not change, and that memory is not freed unless userspace
> explicitly punches a hole in the file. As a result, memory reclaim, page
> migration, page aging and dirty page tracking for the userspace mapping
> serve little purpose.

I don't think any of that is relevant for the patch at hand?

The thing is: invalidation (truncation, later migration, for any other reason)
is driven through guest_memfd notifications, not through unrelated page tables.

If we don't lookup pages for the KVM MMU through the page table, then there is
also no need for MMU notifiers. It's all guest_memfd only.

Or am I missing something?

-- 
Cheers,

David
