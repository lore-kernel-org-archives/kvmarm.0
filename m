Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCFDC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 10:42:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A5B4B220;
	Thu, 14 Apr 2022 06:42:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DQy5Do342ID1; Thu, 14 Apr 2022 06:42:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A249D4B218;
	Thu, 14 Apr 2022 06:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AADA4B214
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 07:54:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j2sNDj-1K8VO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 07:54:03 -0400 (EDT)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C58234B206
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 07:54:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phgCaaQxoZVrIZspV1QCJOPxXx80L430bT2OfW1001U=;
 b=8qsbr1uC7kYPL7+3Gw4yiRImjM2dHy9BTC1HHioFeA3paKvzQobwb5M+bhf6+Bkk5YkYR6Cy45xO+AFacmxVn70jKLpeM5r7bjbvVqJWSTKj885weARFkLVKvT1KYGrp/DKOJBzJ+KrZl61JQLmaOVbGeWocfv9y4wJ3ZBntfWc=
Received: from AM5PR1001CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:2::22)
 by AM6PR08MB4884.eurprd08.prod.outlook.com (2603:10a6:20b:cd::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:54:00 +0000
Received: from AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:2:cafe::9f) by AM5PR1001CA0009.outlook.office365.com
 (2603:10a6:206:2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.19 via Frontend
 Transport; Wed, 13 Apr 2022 11:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT049.mail.protection.outlook.com (10.152.17.130) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:53:59 +0000
Received: ("Tessian outbound 62985e3c34b6:v118");
 Wed, 13 Apr 2022 11:53:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 90524b228c2d5321
X-CR-MTA-TID: 64aa7808
Received: from ad21ebc9e88c.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 225A67A1-47B5-45EA-8182-FF02B2C09312.1; 
 Wed, 13 Apr 2022 11:53:52 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ad21ebc9e88c.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 13 Apr 2022 11:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDuvJ53jbzRm0RWEcLZd3DFqIYZzZEJsWkV9yQRiXz64coF46DM/B5i9hd5TV8ibXPpR5SuxDoXv06KrFJOoZRcDy7SMgC6GdF9oNead7NXnpcm7xtJvDWtl50saWuVOcbisN2pUehiZz34hfI9yAvqtkdrSf4dD/LTbSyvvOy+u7djrKMJqoolBc90DofAcuShiED9aIjah7OTURPgjuh8ZxnGXlEQphfRn6bSyxrgRWJFSOST2X/8xct0UwAnUt8cATmBZ4ReAanrEiHksc3YoRy/1kZX+vC5DzUJBFDQEIMgIOpQiTmiWVFA2TUeyZspCt5189XQRTOSC31KxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phgCaaQxoZVrIZspV1QCJOPxXx80L430bT2OfW1001U=;
 b=MAAE0HbMVYVy/4mTvGYo+9E4mGOLSAXt2jTOmFc2vz3UOr2mR0gsaBo4Oko8sT9rw5nanF9onF8l0BXoAijySxsOjN2SWpVUFxENQj3nObgvViftvK2Ysj2m1Lh7QVWH2sPBvA/HHNQboGdjnAVPrg9+eCxocbL1UQfD8Ny308HPac4x5GCIlqoOpoIp1W5XMG9BBeF7EHapY2qV6U92bPAQE4N2h2jpXjBOTnvUcVfL116+iSTHktLwMPKEc3V0jsxiokTasNizb0YXZAS6K6J9x2q4rYzXWfbhzWLEPzprhc/0/KdqYKo0l8Kd/+qdBi/h51TBk45NG7KacJEE1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phgCaaQxoZVrIZspV1QCJOPxXx80L430bT2OfW1001U=;
 b=8qsbr1uC7kYPL7+3Gw4yiRImjM2dHy9BTC1HHioFeA3paKvzQobwb5M+bhf6+Bkk5YkYR6Cy45xO+AFacmxVn70jKLpeM5r7bjbvVqJWSTKj885weARFkLVKvT1KYGrp/DKOJBzJ+KrZl61JQLmaOVbGeWocfv9y4wJ3ZBntfWc=
Received: from DB6PR0601CA0036.eurprd06.prod.outlook.com (2603:10a6:4:17::22)
 by AM6PR08MB5093.eurprd08.prod.outlook.com (2603:10a6:20b:d5::24)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:53:49 +0000
Received: from DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:17:cafe::cc) by DB6PR0601CA0036.outlook.office365.com
 (2603:10a6:4:17::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Wed, 13 Apr 2022 11:53:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com;
Received: from nebula.arm.com (40.67.248.234) by
 DB5EUR03FT041.mail.protection.outlook.com (10.152.21.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:53:49 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.27; Wed, 13 Apr
 2022 11:53:56 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.27 via Frontend
 Transport; Wed, 13 Apr 2022 11:53:55 +0000
Date: Wed, 13 Apr 2022 12:53:46 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/10] arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
Message-ID: <20220413115346.GC35565@e124191.cambridge.arm.com>
References: <20220412131303.504690-1-maz@kernel.org>
 <20220412131303.504690-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220412131303.504690-3-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 69e702bc-774b-4d2f-e5e6-08da1d444bdf
X-MS-TrafficTypeDiagnostic: AM6PR08MB5093:EE_|AM5EUR03FT049:EE_|AM6PR08MB4884:EE_
X-Microsoft-Antispam-PRVS: <AM6PR08MB48844E37A2B74477412867FE94EC9@AM6PR08MB4884.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zD/B0Do7/vR1SV3jG0ciB8Kj7LUFrqQW3OmVrOomPkk/u7FfC0WvO7NqBN2pswex70IqRJaM4KfzsgvLOBk4G/rdfZ8lF6WQplo02c35IyBZha4mKeU9hGi9RBwvv2Wz/iaDvpHE+hcyS1UjftLNe/vqF5LvFAE6EX3wUA0Pqr/dn/vStLvYyr47AxqBMdVALnfByMNpnw7Vgu0gftoLsdI7pChL1qEGGBR09oDy3FwNUxlm450SYlgy44jj3S7Lomu++5z7ZRTliBKV6n+ayUB9/rosP17TGVcnf6QPKqDB5nQEHcytuHSjmgm/5EFviDAqxB7YOkS47b6evbTcc2qMH6KtW74FVaWBtt5HCDuGVcQHS6/eoiNrIi0KwzGSKKHRkX7odZTk3Uydp5JxoXx+0G3cres+3j22yrxNlZQxyVudHzVkto0Ngpp/6OvoiuVgHiShQewgjde+cKSP0xLEz/W5y5PuZ4HqhE2jTwTYzl//e3v56dMKWPppCTi40UVQU5/D9Pf+EGKzUmIRb9zq1xtaEwwHKw9gu43dKK7VTsagOKMojhOQMQTrOysQB6xw2SCYdUWPewbkt3enX9bMOp+Pca3/oYOmUbyTccfV+woYLmeqjHhu3hH+nondQm6t2eYvBGWw+i945eUIW90IBcdW+/VIf1exjnsX39KFtj7S7HNOflzp//BLuSqmZ7x9RKa78ZQRPHcaKvUNdQ==
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234; CTRY:IE; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:nebula.arm.com; PTR:InfoDomainNonexistent;
 CAT:NONE;
 SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(1076003)(8676002)(4326008)(7696005)(70206006)(70586007)(40460700003)(508600001)(356005)(54906003)(55016003)(81166007)(426003)(6916009)(336012)(2906002)(86362001)(26005)(186003)(6666004)(316002)(33656002)(82310400005)(5660300002)(44832011)(36860700001)(47076005)(36900700001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5093
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 18d7427c-aa4c-4fd6-c28b-08da1d4445e2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZvuonTXFNJ0Es4e8H2QJn9ebXzHeJ58JqUMR5SFk29xtMdeaYIUUkHv2zFK5INzt3fBTTeEe8O1Ty6kZU6VFbNKt5h/8tjnJBTjjbnaFd2x1BW3OKT2kV5SAXHpqonhdwWiE8ddEHfVDK3HnJ4M2PNB8zdAfkpNmPC0eJnX6LLSfjSf1Q9MCRRsyU+rQOwd/ev4a1QeYgm+sm6ONkGJ7/ZZM8sK7U8Jfjzj54NPNQo5i3MY9JYWnqzMgAwZli/30/4KnqEaVNiRrEyMDC3uuMJnD4dgSOMXFxyY5gXpd54ccK4fkl2gmrlHotL56bAXJk4hcYF9eX0VY6jWJchPw0S0qvSp3CEIBejq2OBHfq6TkzTDqj54XDGvEdtC2k+Fsr+Lr2y+vIJAWtW+aE6DGh3g6V8Ccnyv+NITBnwJRFHJ6WqiZghB9vDx1GOr9IrW3qVjGftpDXAEpWd2VK7X8uMxOhq7qisSOLVkI8/i/2LbcPxUramAgZjmOEQhi4DK1k7/we1/Lg18RBNrBXV5+UvoCDPhcxX/AF2wolcA2ngsXr4ne0W7FKXBc7ZQHJl/GIOYhEKMNfy3Za+Amt9wkBe5glRJjguktaTjnELf0qvqEQw8btUmglN5ecqWVzlYylGdh1ipsb7d/acL5vW644GiVdhM/+WSDD9Ec0nzryG4C2cWJPK8jifzc/joh7qc
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(5660300002)(316002)(40460700003)(186003)(55016003)(6666004)(44832011)(8936002)(426003)(2906002)(336012)(54906003)(26005)(508600001)(82310400005)(1076003)(7696005)(47076005)(36860700001)(81166007)(70206006)(33656002)(70586007)(4326008)(8676002)(6862004);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 11:53:59.3667 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e702bc-774b-4d2f-e5e6-08da1d444bdf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4884
X-Mailman-Approved-At: Thu, 14 Apr 2022 06:42:33 -0400
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, nd@arm.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Apr 12, 2022 at 02:12:55PM +0100, Marc Zyngier wrote:
> The ISS field exposed by ESR_ELx contain two additional subfields
> with FEAT_WFxT:
> 
> - RN, the register number containing the timeout
> - RV, indicating if the register number is valid
> 
> Describe these two fields according to the arch spec.
> 
> No functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 65c2201b11b2..15156c478054 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -133,6 +133,8 @@
>  #define ESR_ELx_CV		(UL(1) << 24)
>  #define ESR_ELx_COND_SHIFT	(20)
>  #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
> +#define ESR_ELx_WFx_ISS_RN	(UL(0x1F) << 5)
> +#define ESR_ELx_WFx_ISS_RV	(UL(1) << 2)
>  #define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
>  #define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
>  #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
