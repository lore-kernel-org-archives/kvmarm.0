Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2054.outbound.protection.outlook.com [40.107.104.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D8E1B7F8
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 09:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543029; cv=fail; b=MDkTlcf1hXO41uELwZdwsh+QqIp0IXhlfAXut6L6nFBi9d15FI8E2MVJ/dCuLOnLeBH1A/Kkyh31MURGiTgk0mgc9d0M1qwD9ekUwzhTUy/zR2ehdlKL9l5GX8hc2tHJWmgFd1zRC4ZbdkcpJqC2G5ZSjxR285XfuEWtR7ZkHxo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543029; c=relaxed/simple;
	bh=bZ3e08MSnIM3ZMxY2TWPZHPXRpFtdt3ecK5c9M9144M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EQEzaEbjC5wJAkFpa7BOAxX/YnuhDyx5rGsPWSlW1Ksy4wt69uvO3hZOCtmK2JbGX7N73SVwhAoLr6BQmqmOqR37fuBC187rd84uTXc+N4iB3F/DMPLxBwU7IiPxiwVgP+4oNoOd9Uh2ucZiqZQoikfphLM4Oc+hcK2SPs35GlY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=3WXoNXM3; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=3WXoNXM3; arc=fail smtp.client-ip=40.107.104.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3WXoNXM3";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3WXoNXM3"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=eaO5YfRcbO7UwTEC6NEniFtLmafAUBrnvb+FGotJsPwU1kGJ9MfLZbSA4Y0casFooXKPxd/r1BEqjm/4zxU3r/zSDFek2+2KNK8RDm3I6B7uyPlrJVQBd4bs/8yoxnxTgFzx1q4a/ZVhmwWvwxjjUxMvv1/jbkhknD3wXwoZL1oVtv0pyLcl96AxxOf73oRVUD6DJVBzXoDoJelPhV8xGL9eFn0CU1W3JadqQEiOUl03nZGtUD/fb5X39sTn7kK0Mr9xVFYP6QSNux9quIU6bE39SdVWKafPPOkm4WPggwT5RtudcRZ6O6zP2czjWGZqY3xGH2+OVq9QfiD5WJ225g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cfulh+mKSAw/ZCleVLO45eEFse/iDvqQV2ElzdFoMbY=;
 b=i5+FpRFnwQHk+4FobMBRzNjCB6iJTXPpcp96Kqf6gojRFL/2qeETOpukyXwLVY8R0sZA7MHde7abCKKAWgK0pL67IV2WDM/C9rWAqT2wnYoIgCHS6hWRLf2Jo9LWHWFOT9hd+RaOOoH2QZ73kjTgawAzlp1uACBdKlBtqvPjVRTEHOO5yZC1rJFVI3IyPkRZrDNJNExnHUsC6qNfz2sih6t5ipM9OqLq+axy2MSbP+WSd/6YFbiPEvF7K4qz9OOSnDwBKpH5xWn2hhc9seuerUqQeYNZNWR7bNpmKtzUEBpKoQeKXI49JAUgDlR/wsg2QIEXk8jAbq/bwR5i6zqrew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cfulh+mKSAw/ZCleVLO45eEFse/iDvqQV2ElzdFoMbY=;
 b=3WXoNXM381XCnvFrUEeqRyCm5VhsnP0x7cm/8QpFQjQYcBSX9OFkgcgPSEsVb3xpvWzK5vQUvGvR1fAXlXueW4suIFaFoQ0NYzH4HXWFyk2Z4p8cgRZg1TDvhvkSMNvbsi0ao8tRJLGqEMYrdVLWH6Fbn2F1/Zx3wGlHNn4shwQ=
Received: from DU2PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:10:3b::8) by
 VI1PR08MB5376.eurprd08.prod.outlook.com (2603:10a6:803:13e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 09:03:34 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:3b:cafe::75) by DU2PR04CA0003.outlook.office365.com
 (2603:10a6:10:3b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39 via Frontend
 Transport; Mon, 4 Mar 2024 09:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Mon, 4 Mar 2024 09:03:34 +0000
Received: ("Tessian outbound a6e56d06a0e4:v228"); Mon, 04 Mar 2024 09:03:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 34b4c04fc35d6822
X-CR-MTA-TID: 64aa7808
Received: from f9d5ef88e057.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B2BE33D7-54A2-4D72-A68F-F52F23071B26.1;
	Mon, 04 Mar 2024 09:03:27 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f9d5ef88e057.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 04 Mar 2024 09:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwUFjCMuYmESx/Koq2554fArRjUAehvC0IU3o8haijhuRXnTVZpeYTRPDbUewAM3krlNnVLYgEoMTMGmXPHwRQ9stn7huWEg4linvRFLqs6s0BXFMm7ZjICGphMfEyGBiNgo7UEGO4dw7Y3BJ740X+paDJeZAikSNeFV7Z/6cuHY5WNMgMMUJ9vAumzs0M0YS9o7Ovs/UM7j10X25MB6m7LqBDbdJx82kNirs3YMQuBI4XlGITSGo3F2k4d1qSsBrMMbv7gn9QWO5WtVBpKCQeTPYzitK1nzq6j8CkxtJverm4mB761rFk7xBt0/XjszXkQYRo6+CRpvpmhRGpKnnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cfulh+mKSAw/ZCleVLO45eEFse/iDvqQV2ElzdFoMbY=;
 b=N5CoAfvpbF1y3aCvoSYGIOp6cC0tPw845zdgf+lAvGUF82E13aZyvX/uwBcnC4M7QMDmpYWQsakM8zAQpPOdvqza/m49zQgMiTeWcJjzApnmS3w5PgCIjHxHBpy6sPft5YJIqu8qbobBpmhZSCgny9YGupJm4X37LEgUmaKu/oUC5wKjfv7FgIIwYqVcX2kFAsMh3pLogZx7ushXP+KxP6LVQJYuonV8lA4TBTmlIOF5gwRJT49rjg6C91LC0BgeHsvqHiLSQcUZDtNNcuiBC/4m+HLekmrZjexNeqk98bLxE2rghWVM8zGdsuv/JdpzMPqgujVwMcwEuWC+dt6L/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cfulh+mKSAw/ZCleVLO45eEFse/iDvqQV2ElzdFoMbY=;
 b=3WXoNXM381XCnvFrUEeqRyCm5VhsnP0x7cm/8QpFQjQYcBSX9OFkgcgPSEsVb3xpvWzK5vQUvGvR1fAXlXueW4suIFaFoQ0NYzH4HXWFyk2Z4p8cgRZg1TDvhvkSMNvbsi0ao8tRJLGqEMYrdVLWH6Fbn2F1/Zx3wGlHNn4shwQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by DB9PR08MB8628.eurprd08.prod.outlook.com (2603:10a6:10:3d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 09:03:24 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd%4]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 09:03:24 +0000
Message-ID: <61fa9d38-e7e0-4cba-abbe-35833da5cec3@arm.com>
Date: Mon, 4 Mar 2024 09:03:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 17/18] arm64: efi: Switch to our own
 stack
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-37-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-37-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0272.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::20) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAXPR08MB7017:EE_|DB9PR08MB8628:EE_|DB1PEPF000509F3:EE_|VI1PR08MB5376:EE_
X-MS-Office365-Filtering-Correlation-Id: 532c5357-14a1-4f41-e57f-08dc3c29f885
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 aaNz1xzvljB8jxKEhijakDSZd5pSjfTZ52Nk9F9EswuPhi6YIk1RUOM3hb9oLWL6bmxkkcvlxc7HoJkJ4pJIBKeKEYQfEBlO+mjLwF/IYYd+1wI+BfoQfv8PQA/XAW2HhAHuZtJtqtBCUuJKmWNjh1dDfo7px2vk15SBiyBsDxsg87ZTtFs63AlKMjOiqzBDYMjBeFXdbYJFbSSbPQTH6rOe4zCNIbdT2LypY1n5J+MNIknCG6q5qONFCW9j4xVK8MfCV6RQ8p2el2jpKdYMlYKaaeyapi40LztNDa1U/5jz4A8VC5E66/j7j7+ttpvyPPPdPOuHOLs3wsEiRP5EXYL1enb00SaNQwHgZsqjEYARf/EqgInAgmuj3TfyJUg8eIKQ4JjIUhIMEDZv4CwdrizrkSEf/FBtLnW9NbIcxQh+X5M0mlIKlklZt8R3CJIGhrypO8Boz9SUS3Mby7p8jvdAMQbiIQ72c+X1D9OjXaBYvJUeTy3vZcd/si0FRKNMzNnWiQ5tscpmXokmFhNdoEX2BU8V0vJJeIhAod5ss9ZZE5vNp9YDAJ8et0y1E9px8XH6g4ij3qIlb+bXH8R+PHgvChSb/e0Qjj5JpiiEVW4QOQbVTGc7Fmxj+UozmlSkArv2rXBAqtaFO9ofg0pYIYv3febraNzzfd4xn8n4UHg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8628
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	18553aca-61d1-48c7-f131-08dc3c29f290
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n5niOMBvJWCRudwy4yvDMOptP/TEtbDx6IL/xLPoOIvzA8oZwfQJG1uO/lBm2h8mQyYYrV0uLbWM/mu3lIWSQmAGCHlYAuSmK996hscClzM8+mALdPai4e8S26oQHrugLEhooxrRAvtq8U0x/k+OaERX9wQ6xzMl0LPiEDTrRty4t6qGjOWZSbUFHHaFFeA6SDg479irkxNoBg/r1PcxGv6a3w3eK7wECKnjQF7ZN52maCslFPJuWAlsPZ3pcaCTlzURBWPvA7OxoV9WBfYVNyPCPqmCDEL/XyxRiLEQ03hnGGHRBVHiwilrQTmqfeH0yTtvIME053qUPGyOBFDjilBWB4hjbUz5JGxRgydxpP8SH6rt+2BQ595uH9Gu3Ss60Sm2WUn5vOqW7Hjz/950N8VcxM9MEUAyUchm93cT3P/P9xmBFZ7lyOw7+23lz2eGfYYlf/bhSIZD1x/2G5QCcxGDomvFt5dtL5HP7oQYDO7nJcWFZA0m8GHokhvHQWhio2+nY4N8KHtw93sv4t8iFgPmHiKaZdBRFOANqlcvJkxSGfaFAKXGEOBUtnDPkdExzoKe9jhXEJLUiIerhBi49MeS//+VQ1d6gghLscfVD62BvkLf0Htgp3DGfLNpQow9XfO9oZI1yM/FY1cNVx/uCTSu4thuD8XraZRIPoGcl6nZupYEwojDrdNmaqkLLGsIELh+TMw5e3Lcm0/PmpYGzoObrpZwCINdDhZp6UEQyIyz0Ap3gKLqBS9hI8dlaDrK
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 09:03:34.0618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 532c5357-14a1-4f41-e57f-08dc3c29f885
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5376

On 27/02/2024 19:21, Andrew Jones wrote:
> We don't want to map EFI_BOOT_SERVICES_DATA regions, so move the
> stack from its EFI_BOOT_SERVICES_DATA region to EFI_LOADER_CODE,
> which we always map. We'll still map the stack as R/W instead of
> R/X because we split EFI_LOADER_CODE regions on the _etext boundary
> and map addresses before _etext as R/X and the rest as R/W.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/crt0-efi-aarch64.S | 22 +++++++++++++++++-----
>   lib/arm/setup.c            |  4 ----
>   lib/memregions.c           |  6 ------
>   3 files changed, 17 insertions(+), 15 deletions(-)
>
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> index 5fd3dc94dae8..71ce2794f059 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -125,12 +125,18 @@ _start:
>
>       ldp             x0, x1, [sp, #16]
>
> -     /* Align sp; this is necessary due to way we store cpu0's thread_in=
fo */
> +     /*
> +      * Switch to our own stack and align sp; this is necessary due
> +      * to way we store cpu0's thread_info
> +      */
> +     adrp            x2, stacktop
> +     add             x2, x2, :lo12:stacktop
> +     and             x2, x2, #THREAD_MASK
> +     mov             x3, sp
> +     mov             sp, x2
> +     stp             xzr, xzr, [sp, #-16]!
>       mov             x29, sp
> -     mov             x30, sp
> -     and             x30, x30, #THREAD_MASK
> -     mov             sp, x30
> -     str             x29, [sp, #-16]!
> +     str             x3, [sp, #-16]!
>
>       bl              efi_main
>
> @@ -140,3 +146,9 @@ _start:
>
>   0:  ldp             x29, x30, [sp], #32
>       ret
> +
> +     .section        .data
> +
> +.balign 65536
> +.space 65536
> +stacktop:
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 08658b9a222b..d535cec88709 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -340,10 +340,6 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>   {
>       efi_status_t status;
>
> -     struct thread_info *ti =3D current_thread_info();
> -
> -     memset(ti, 0, sizeof(*ti));
> -
>       exceptions_init();
>
>       memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> diff --git a/lib/memregions.c b/lib/memregions.c
> index 3c6f751eb4f2..53fc0c7cfc58 100644
> --- a/lib/memregions.c
> +++ b/lib/memregions.c
> @@ -114,12 +114,6 @@ void memregions_efi_init(struct efi_boot_memmap *mem=
_map,
>                       break;
>               case EFI_LOADER_DATA:
>                       break;
> -             case EFI_BOOT_SERVICES_DATA:
> -                     /*
> -                      * FIXME: This would ideally be MR_F_RESERVED, but =
the
> -                      * primary stack is in a region of this EFI type.
> -                      */
> -                     break;
>               case EFI_PERSISTENT_MEMORY:
>                       r.flags =3D MR_F_PERSISTENT;
>                       break;
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
