Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE73C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 10:42:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF7C4B1F7;
	Thu, 14 Apr 2022 06:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LM3Cz-cSS2Jd; Thu, 14 Apr 2022 06:42:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A5CF4B232;
	Thu, 14 Apr 2022 06:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A08244B1D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 07:37:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y9vZpbvc1INF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 07:37:42 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0890A40F93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 07:37:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4enZSwqNhwTxHsLie7ZmWUze5Qe1BpZvPVqbRLt0tgU=;
 b=dKR1jzy8VQf4n4zmusqHtbqVK12dsDX13vVFgROXfDvZ3wa7dxPm9tUQ69EZEjzVv1Eir2+8yQFzP85tJsRMwEFIpj6zpQ2eQozEbLmccGKxU0WnhDVDte8qeyqNSiAegGo8TYAPYVE+97IQSTCaIh41ZxYBovb06Q+1WqMF7S8=
Received: from AM6P194CA0083.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::24)
 by DBBPR08MB6025.eurprd08.prod.outlook.com (2603:10a6:10:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.19; Wed, 13 Apr
 2022 11:37:39 +0000
Received: from VE1EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8f:cafe::c3) by AM6P194CA0083.outlook.office365.com
 (2603:10a6:209:8f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 11:37:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT054.mail.protection.outlook.com (10.152.19.64) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:37:38 +0000
Received: ("Tessian outbound 78191104f1b7:v118");
 Wed, 13 Apr 2022 11:37:37 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: e84ed03953c7f569
X-CR-MTA-TID: 64aa7808
Received: from 3b68f25e24d5.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 25DD3129-2BDF-4CBE-BDB1-9095ABE710B5.1; 
 Wed, 13 Apr 2022 11:37:31 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3b68f25e24d5.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 13 Apr 2022 11:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOB6Mn1jV8v5V8/FgbtqUtoo98Hi6tn5aVKh5YxmPZnMdA5rIq881a2/8/F/ZYiJ6hoeeGWeIcFwmt9rgV+uaNLiUUkVkyU5cO2GzwhdlLvpHTLXJvAV5VSn382NoaXDLXn7dmy7+oWoQKjmx40Hq2EZ8xLein6myR5s9Ld3QaQcQWf1jrHFAxdqrQVMgvgPrkKKT5NavduE73p3YfUF7htA5PYu8rnnuggyE/ZcuAfyeMFzLE9UvNGGayKH5RdmzS0A6if8UuxbsKIdW8iTlCYbifmDE2x+EV48nzw05hICaqb2+kxAlQX14p7iqHSq6uCViFdm+Y4ToGJob1roDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4enZSwqNhwTxHsLie7ZmWUze5Qe1BpZvPVqbRLt0tgU=;
 b=Rd4r0qGtbOn/fB0gf2EW2pCxyjXYA5XQcBmdZ5yZQQd4njg/U7DR2GRYKPED+/l/TPy0YYz7vxWInSdtyaDKH9d4fymOS3iSE/X0c2QvcshCWfxsUo0VXez4fcJJsBdR+jYW4YvX7cqN3Z9i3QUqpZ58UMWy6yRpNjbj8gnT8Yysb3DWMa2fbhIk6by6KzD1XsdFbmDupOQiZxXbYbSeLAy9VpiweBf+4sh/zz2Cs3iucLltRc91eTJDaUzLOqmoYgR6ABIJWvrB71iHi8iRLsIxBNq52RMCBG6r2t5zmsJo6ATwLPemdMjgFPhdpW/6Lshk1pPUU5C3LpyoQH6aXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4enZSwqNhwTxHsLie7ZmWUze5Qe1BpZvPVqbRLt0tgU=;
 b=dKR1jzy8VQf4n4zmusqHtbqVK12dsDX13vVFgROXfDvZ3wa7dxPm9tUQ69EZEjzVv1Eir2+8yQFzP85tJsRMwEFIpj6zpQ2eQozEbLmccGKxU0WnhDVDte8qeyqNSiAegGo8TYAPYVE+97IQSTCaIh41ZxYBovb06Q+1WqMF7S8=
Received: from AS9PR06CA0116.eurprd06.prod.outlook.com (2603:10a6:20b:465::26)
 by AS8PR08MB5992.eurprd08.prod.outlook.com (2603:10a6:20b:292::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:37:29 +0000
Received: from VE1EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:465:cafe::c) by AS9PR06CA0116.outlook.office365.com
 (2603:10a6:20b:465::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 11:37:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com;
Received: from nebula.arm.com (40.67.248.234) by
 VE1EUR03FT052.mail.protection.outlook.com (10.152.19.173) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:37:29 +0000
Received: from AZ-NEU-EX01.Emea.Arm.com (10.251.26.4) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.27; Wed, 13 Apr
 2022 11:37:36 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX01.Emea.Arm.com
 (10.251.26.4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.27; Wed, 13
 Apr 2022 11:37:27 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.27 via Frontend
 Transport; Wed, 13 Apr 2022 11:37:35 +0000
Date: Wed, 13 Apr 2022 12:37:26 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 06/10] KVM: arm64: Offer early resume for non-blocking
 WFxT instructions
Message-ID: <20220413113726.GA35565@e124191.cambridge.arm.com>
References: <20220412131303.504690-1-maz@kernel.org>
 <20220412131303.504690-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220412131303.504690-7-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: bdcc913b-70c6-4334-5608-08da1d420323
X-MS-TrafficTypeDiagnostic: AS8PR08MB5992:EE_|VE1EUR03FT054:EE_|DBBPR08MB6025:EE_
X-Microsoft-Antispam-PRVS: <DBBPR08MB602505A14D4291E6B3AFA66394EC9@DBBPR08MB6025.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cdyLBiKHDhnClbT8Ao+qTd5SW8N9O9DNSJuMzzWEwqJcNQvgy7h2TCiHknQ5iaKQB05KCT2k70BdHMYE1Qwxt3C9odagClpyHKXWNGMUYBFJVZWYiEgUTMg9UTMoLc8L1zijiuPZDuhMSDwWLBZFDhkyWN/jjD5wCfUuf9RLRy/jK0tCe2u5PAOWxf7PqpyD6Xp/1R+FccPRWyKpGmZ+kcaQ43ij2flCR61msilDaOajitDe6paZcJcf8A6gyFGXsfbCEq70Y0p6tZnx3MdXJulB8bd384xZwo3v5huWfZOR1EijTQDaazvpXAeNQdL79RtqZUGOj0sK/wEhG3q31LU74nDUh4anbXYfVQjgCVjtlNjbX0Pp1PXwzpTMOxV7j0FZl2PQppSA09PXrGkkASHbtwo/7ur6ISFglbx8nwQte0ghvWrrbAuabj9CgTa2xB2FLwZTBNuNuX/RGQWapPdY+knx+j3nAG5rlSxcUOnqqKR1iII/vOlnuklX1BJbwUna1ajaECf2ccV+d7NObK7zF7LM13MhzYUeggBzmS3WRWkoZM/brJ7kl1JzoqrDQYUcbZI559vCBWSQdfiZL5XxMhXtEzOUghckNz9clK6vTX+Y51RLrl4u+1IgGZFwHpvd7WExJYJwkIHV7OGSTYLyCdgftozYbs7R7S9c6uvHOM45lCUYEF3/zP+GZBoMQsRnUSqpZhFYNTcDq6ClWA==
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234; CTRY:IE; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:nebula.arm.com; PTR:InfoDomainNonexistent;
 CAT:NONE;
 SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(86362001)(426003)(6916009)(186003)(26005)(336012)(6666004)(2906002)(316002)(44832011)(47076005)(5660300002)(82310400005)(33656002)(36860700001)(70206006)(70586007)(8676002)(8936002)(1076003)(7696005)(4326008)(81166007)(356005)(54906003)(55016003)(83380400001)(40460700003)(508600001)(36900700001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5992
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0e6c589e-2254-46e2-e725-08da1d41fdb7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSmjSFk9or7jva5i+Ebq01awpxMaXPX7ELBnrm1nsp0Xw9I2XOTDYmTM5ZGrAJuBGhT1clFWjFhWTlts0NQmqsp8MAmcRC6XJm1lqgZDcAGUd/wXp4onQ9vUf4Ct2/S/z+6JKdS3aysFA0bGAnfIa1l54q4SWscSzstU67vwVHYaDN+Du+lnBIO4DTS1YjUkqn148dy/zVF/3FtHxNd4fQ169AqNrvT7Jfe/Rrz0C0rFp25cHEkQcp/y22/UIoCAhIL0v+jq70pDQBe2Tq+UdQPcGQXqKqUgwRxUK6sY9DzJIocbWXcDGGqRCJBrIEg/+Lupn9Io7NYJNtoWK4rUcawuoxq0NYVMLeg9sOIpGFl/7v5XPCiN+c4pkra76es4hQi5kVybiulteZ6hdV+mv5KuTtjgvkiVAYxk08Le7ulQvGQurZHkC7luHY3nKNccwTucLMLaMDc9qvhEu0Y0y7ljNDv0sEqRdOaUYfX4M3TS8MhEhVojydkNI3PWlSQKqLt6wllPiw6wvIkf00Ae6Lb3QNCkG2ZCH8kF4NRHwNmw/AxLR7TBfL12znjsdBs2mLzUudzOM1TxT03BCcYpQH2lFf/fbBDVe9qasjfDvj84jqfUQJx29ZM1FbyIhyt15ONz/g2huuxb4B99w5HXYl9lEHF7LngzXuNXywVI3ggcj0yzRIknUT1/NMS9zY5K
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(40460700003)(81166007)(55016003)(36860700001)(70586007)(508600001)(83380400001)(2906002)(82310400005)(44832011)(426003)(47076005)(336012)(5660300002)(26005)(186003)(33656002)(6666004)(316002)(6862004)(4326008)(7696005)(70206006)(8676002)(54906003)(1076003)(86362001)(8936002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 11:37:38.3017 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdcc913b-70c6-4334-5608-08da1d420323
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6025
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

Hi Marc,

On Tue, Apr 12, 2022 at 02:12:59PM +0100, Marc Zyngier wrote:
> For WFxT instructions used with very small delays, it is not
> unlikely that the deadling is already expired by the time we

typo: deadline

> reach the WFx handling code.
> 
> Check for this condition as soon as possible, and return to the
> guest immediately if we can.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 4260f2cd1971..87d9a36de860 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -80,17 +80,34 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
>   *
>   * @vcpu:	the vcpu pointer
>   *
> - * WFE: Yield the CPU and come back to this vcpu when the scheduler
> + * WFE[T]: Yield the CPU and come back to this vcpu when the scheduler
>   * decides to.
>   * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
>   * world-switches and schedule other host processes until there is an
>   * incoming IRQ or FIQ to the VM.
>   * WFIT: Same as WFI, with a timed wakeup implemented as a background timer
> + *
> + * WF{I,E}T can immediately return if the deadline has already expired.
>   */
>  static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>  {
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  
> +	if (esr & ESR_ELx_WFx_ISS_WFxT) {
> +		if (esr & ESR_ELx_WFx_ISS_RV) {
> +			u64 val, now;
> +
> +			now = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_TIMER_CNT);
> +			val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
> +
> +			if (now >= val)
> +				goto out;

If this returns early, the trace_kvm_wfx and wfx_exit_stats below will not be
called / updated. Is this intentional?

> +		} else {
> +			/* Treat WFxT as WFx if RN is invalid */
> +			esr &= ~ESR_ELx_WFx_ISS_WFxT;
> +		}
> +	}
> +
>  	if (esr & ESR_ELx_WFx_ISS_WFE) {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
>  		vcpu->stat.wfe_exit_stat++;
> @@ -98,11 +115,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>  	} else {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
> -		if ((esr & (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT)) == (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT))
> +
> +		if (esr & ESR_ELx_WFx_ISS_WFxT)
>  			vcpu->arch.flags |= KVM_ARM64_WFIT;
> +
>  		kvm_vcpu_wfi(vcpu);
>  	}
> -
> +out:
>  	kvm_incr_pc(vcpu);
>  
>  	return 1;

Thanks,
Joey
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
