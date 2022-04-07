Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6338DC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 15:27:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A92949EE9;
	Thu,  7 Apr 2022 11:27:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UTmuYS4pCZr2; Thu,  7 Apr 2022 11:27:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27AF249F1F;
	Thu,  7 Apr 2022 11:27:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A98D49EE9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 11:27:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DzwWPdjq1iVO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 11:27:29 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70047.outbound.protection.outlook.com [40.107.7.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7953749EB3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 11:27:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DYJPbqbMTefh4/EV7Psv9Uvm0xo4FxgF5ec81JkoQY=;
 b=NrAPQpGIrEsGN1nNJQ0Bfsdkn8zlMygJES1d7/GxzQ/i3YvU5P+NYn5+NqFRH8l8UVF9/g2amJY/jBDic9p+UwgeRyUmOSg15uKfp+Kk8As4QZHKohteO0PJz20XcmzF9Q68zP/B2D37mxU9Q8r/Cc6hdcZjA0owK4NUpYY5Hv4=
Received: from DU2PR04CA0080.eurprd04.prod.outlook.com (2603:10a6:10:232::25)
 by AM6PR08MB3352.eurprd08.prod.outlook.com (2603:10a6:209:4c::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 15:27:25 +0000
Received: from DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:232:cafe::7c) by DU2PR04CA0080.outlook.office365.com
 (2603:10a6:10:232::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22 via Frontend
 Transport; Thu, 7 Apr 2022 15:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT046.mail.protection.outlook.com (10.152.21.230) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.21 via Frontend Transport; Thu, 7 Apr 2022 15:27:25 +0000
Received: ("Tessian outbound ab7864ef57f2:v118");
 Thu, 07 Apr 2022 15:27:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: e349379e7b40d365
X-CR-MTA-TID: 64aa7808
Received: from 06199e09e2a3.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 CBB03ABE-EB92-458A-9E42-34B7390FA3C7.1; 
 Thu, 07 Apr 2022 15:27:14 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 06199e09e2a3.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 07 Apr 2022 15:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IojUGaNG2EMdkTfOSKQLPfo5JYUWdHoxm+e1jJMn3mAbV4/oKYH7rWMb0YQt+O1TvgiZluMSu/OzxfUudTsjo5kHNDnh2xZw6tiHjxugf7pF9kNNcIRUcNumN5CgCIIWumRtkeVcTYkkX3aCN4JUbkmO4DWnD6/qa0JXaHqbye9vliJPn9utrX9qmzoWqmw94Ixdzi/cgfD5xl3XOLn7uhoqgfVGurFeTgiZVKe3jq3UFc5FBW183HgAEoFguMa7d/YWNnHA05dFiKHFo7HYhCArkBQ6s4WLyTMgcohAshlTDNb1TFi7dyCy7zt/NiXOyHxrht90EmehkXAtRT1t7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DYJPbqbMTefh4/EV7Psv9Uvm0xo4FxgF5ec81JkoQY=;
 b=SXOAiw++aybq//J+MDz0OmAPTDOZftAnvt03tMd6gAoCnlTSgx7YTSOxwZppSvcjWZfMjJpR6NiQkZEIsxX6Ki1TCq1tjYOvbr6KiEYlx8bF4qQEhiW9wZSZ/fDnSUmAmIzjf2sKDZBaqA5RgOzDb/WhDYYCO6nZdyqPz36fvqn0e+5IX6piXeuCl1UoDh0sT0+laI/QA4HtJ/xsDtELW0SUpFI7gmI2r39uu8kTv5Ng3bIlmdwPuWsDp4BIaQuzSAkd+HXzvW3EU6RsFn97sdgv/w7uXoh4X27QWsPDiK0LQtyezKTIuUUhPmySwb/E6agZ5cPb7mje5kyRv8jB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DYJPbqbMTefh4/EV7Psv9Uvm0xo4FxgF5ec81JkoQY=;
 b=NrAPQpGIrEsGN1nNJQ0Bfsdkn8zlMygJES1d7/GxzQ/i3YvU5P+NYn5+NqFRH8l8UVF9/g2amJY/jBDic9p+UwgeRyUmOSg15uKfp+Kk8As4QZHKohteO0PJz20XcmzF9Q68zP/B2D37mxU9Q8r/Cc6hdcZjA0owK4NUpYY5Hv4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM6PR08MB4769.eurprd08.prod.outlook.com (2603:10a6:20b:d0::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Thu, 7 Apr
 2022 15:27:08 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::cb9:d4f8:1295:a076]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::cb9:d4f8:1295:a076%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:27:08 +0000
Date: Thu, 7 Apr 2022 15:26:54 +0000
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <Yk8CvtqrRR4cV6/v@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-7-broonie@kernel.org>
 <20220311172051.GA257833@arm.com> <YiuYMcR8zk73eBLo@sirena.org.uk>
 <YkXRUlaoyDKQqndc@arm.com> <Yk3hDLe8Cce8zkvI@sirena.org.uk>
Content-Disposition: inline
In-Reply-To: <Yk3hDLe8Cce8zkvI@sirena.org.uk>
X-ClientProxiedBy: LO4P265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::23) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: e6ffac93-63b3-4adc-b4e5-08da18ab1e3c
X-MS-TrafficTypeDiagnostic: AM6PR08MB4769:EE_|DB5EUR03FT046:EE_|AM6PR08MB3352:EE_
X-Microsoft-Antispam-PRVS: <AM6PR08MB3352D6E23104FC1944559038EDE69@AM6PR08MB3352.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: kbHEv98nDAK/8Co1uwg63suWEZGNOK/ekrLOreHWVyvzx9sxO1cBNH9k9xI9d6505sHn1Q1GZj8hpgG3QSCpakZu3/Vt6/0t/p3MZUHrMvQ4w0YISMAgBmiXA6lAVMk7fiEUiECuOxmTlH3ZWFQWJgwsbSjxg/FkFZzfevKhbrZdQhmpnNJ1bFdoOWwP+iCuFGPmfVzEPRK+ZGg87mLsVdoqAVdJMhpHGULIS4vhbmkrzTkIYaN0qPjipA63BCjrx8Ibf0H69nYRzqWNPmCiMyMbY5IoFJGjmm6UzU+9gR8HIKHf0YgWi5dpNc+9YfQ2ND5UD2wvqgqUbys2XFNYcckPBAm0Aq7Kg4AyakzU4+8YVtQWsy6QbRy2I3RcAVO1iRzfvdqMjmPjEN+yhmFU91SJmCJrtwbAYG+owEOFqETWAQWd/0Jg1Dm2fMMo2h+Hgc90MTBryT4oYP7RC78lWzuRVb5/slTtsSAf9nzwosjeaTRnVSDRP+SOUVwj0PHKO7YTu6Sypho8cNBsh6h4cw2fVkrGMwX4U5OavMPWNu3r1uwPsMxWAcmcaUQ0iHYydT/4XD74bLFvCO62RoQ4inmr9iXBC+dpmR004mIwYidQuj9k7W379vhw1v0uX9dKdO/NjLdrWcn9uoUa68G6qw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB9PR08MB7179.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8676002)(66946007)(2906002)(86362001)(4326008)(4744005)(66556008)(66476007)(8936002)(6666004)(6512007)(2616005)(26005)(6916009)(6486002)(54906003)(508600001)(316002)(6506007)(36756003)(186003);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4769
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1c3180ae-f5d3-4d76-137a-08da18ab13c9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvwZ3CN6jD/ZgzWIWeOL5OnUn8nbuakBjk0yR3+j9F6rLmYDIuLZQC7mxfYezIOJPoQN57RsskO9Vm63Jg553rFxBQj577WURfX+N6arobF4xsKuxoOQTfEwamkuxp0HZAIacHD/7/HOx1PZ20bclNnwnoBfXsaBfZqd+7/Fv0MmFqpEVQ0V5f1VtF81RvDJdyA20C/ofBPclKwZ5/fHMw+PYUib+p4i2W59+yxKT7NHzj+pYxiM6znMwxqMW5AKqSlHJ7gtAKRmFc7CKgW4pGCcOBD79Kcg0mSx8n5dfvXvlCjd/NPsvE54V2cKz8JHDPwtbV67x4Qby7MQ+G7RoSgSR2HWaZfDBwQ7EoEX3KvUiSmctliulH//xDUvPGhfYZpJWsmYDgPICTY1fvHe87rg+BaNCbS9B7NV9MyLVbRpVg1XzOpGhhsT7ygPDOTvyASpBHZIWPrTxm3CPYmvseEaVL7KCJXYv9HEM2HYXojVY804jSIdRi8z9nE4zmLKZ2PeRM5fU0SDcy+vX+aQtXnN6NoV3DvJ8Go0uheRhURutgTlhWpUriczcKa9bS6BBz2whqad1dtDZreffxlbuVXrfHBeAclav6bfEnB/stEsw8c2ywHfhRDajUATjPBSVEPL1ZTi5x1eL8EfOKOKpAKhHXR3eFp2iNz+SlB1asFso7cxNPJdYyVXnUvELQLP
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(54906003)(70206006)(36756003)(6486002)(6862004)(40460700003)(2906002)(86362001)(6512007)(47076005)(6506007)(186003)(26005)(8936002)(70586007)(356005)(36860700001)(8676002)(4326008)(508600001)(4744005)(316002)(82310400005)(5660300002)(6666004)(336012)(2616005)(81166007);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:27:25.2115 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ffac93-63b3-4adc-b4e5-08da18ab1e3c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3352
Cc: Marc Zyngier <maz@kernel.org>,
 Basant KumarDwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <Luis.Machado@arm.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, Alan Hayward <Alan.Hayward@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

The 04/06/2022 19:50, Mark Brown wrote:
> On Thu, Mar 31, 2022 at 04:05:38PM +0000, Szabolcs Nagy wrote:
> 
> > i think it's slightly better to treat ZA like TPIDR2,
> > so only clear if CLONE_SETTLS is set.
> 
> > otherwise in principle the child can return to the frame
> > where ZA was used and expect it to work (it's hard to
> > come up with a reason why would some code do that, but
> > this is valid in a single-threaded fork child).
> 
> From an implementation point of view it's a bit clearer if we just
> always preserve PSTATE.ZA and ZA contents on clone() and clear them on
> exec.  Do you see a problem with that?

i think that's ok too.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
