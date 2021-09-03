Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAEBC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 09:22:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F30B6101A
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 09:22:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F30B6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D68B4B16C;
	Fri,  3 Sep 2021 05:22:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7MVtg3Od60gQ; Fri,  3 Sep 2021 05:22:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C924B172;
	Fri,  3 Sep 2021 05:22:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D6C4B15A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 05:22:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ChF1y+VEKZM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 05:22:07 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150050.outbound.protection.outlook.com [40.107.15.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A0F04B159
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 05:22:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/yaBI3RKlaFS20UZZEYLCRMlUoUmfuwOXEC6ImRzY=;
 b=wvBU7qgSaVSv+Y+A4nCvSgWlBFRRDOrR9yfu+B0ogxNNn2VUbceX+lLMmuOf01EtIcw6QIMVSvZ9nxYhpFYxWxnx+uvzVeA9r8P6SGe6utLP6KZeeKxRBCCtSchwFwhJH9tSq8Yv+CpciJN/ruse2Yp5Ziq5r1aGF1QtWBKLIwo=
Received: from DB9PR01CA0018.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::23) by AS8PR08MB7268.eurprd08.prod.outlook.com
 (2603:10a6:20b:423::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 09:22:03 +0000
Received: from DB5EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1d8:cafe::ee) by DB9PR01CA0018.outlook.office365.com
 (2603:10a6:10:1d8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Fri, 3 Sep 2021 09:22:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT027.mail.protection.outlook.com (10.152.20.121) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 09:22:03 +0000
Received: ("Tessian outbound f11f34576ce3:v103");
 Fri, 03 Sep 2021 09:22:03 +0000
X-CR-MTA-TID: 64aa7808
Received: from 40d249bcf2ef.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 01FDF230-551D-4AED-94FA-2F11ED832E00.1; 
 Fri, 03 Sep 2021 09:21:52 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 40d249bcf2ef.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 03 Sep 2021 09:21:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhPanh0CHibkqpeJBTvnulOyvhPZojjFcyQEs8owo01X+R4kRXH/acNOKWGt8EZFFP0wiCeI9IdEl51rU+tGxlOrc+z0fWGL0Tu/tb9hP1phq0AofK3eUL+8fCrvvwBo3hZuOL1AHIm6RXy0jCJaPC0eyd9J+wTqDJkIh1Uuzs9iLjtpOAl8bN1Cmhj6pR7avKYGEpflGLWKmZiGIU/dq3NhoJ+Up3o+MR5OaQjACgi2K4o+A7FSsY6/XDnFIeFJx+tWKtaCPHsiggd2ELxV9dijHYJB3Ese1PDjMmgxaWJmuDN+COlcaZPTDJ3yBJ8LXJlDkzA+7I4mssMhqDf1NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
 bh=IF/yaBI3RKlaFS20UZZEYLCRMlUoUmfuwOXEC6ImRzY=;
 b=JFjZx67Ui+hdK4Rez7VJ/QmeugkvfrK/tuRdgpBvHEm8XxuS0fkB8NMr/JA9qDfrPkmvQzO2La4DYaqiB+IOx6qBHc7F4iGlTTASTH31cKNZWsFp5XZjCUrigIB+trHhOiRqcis9hK4aNP/U3ykmfgkDwY+LZVrBbCFH7Ri6xSrj0Qf1TwsQL+v8xs3145muVm2Eh/7Yzg5knl9kPJRCs6zCibcdDYoSzMdhVADOc8JzYuOF5F3IfMAwfYXomsmu6/sPuktG38BsRlxMQdzTxMZduY5J+PE+mBDIgGY8Jx2UrYsOpEsgIc9QJW5/iy6dmTV0CrOdKtsdav1lWSxgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/yaBI3RKlaFS20UZZEYLCRMlUoUmfuwOXEC6ImRzY=;
 b=wvBU7qgSaVSv+Y+A4nCvSgWlBFRRDOrR9yfu+B0ogxNNn2VUbceX+lLMmuOf01EtIcw6QIMVSvZ9nxYhpFYxWxnx+uvzVeA9r8P6SGe6utLP6KZeeKxRBCCtSchwFwhJH9tSq8Yv+CpciJN/ruse2Yp5Ziq5r1aGF1QtWBKLIwo=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB5016.eurprd08.prod.outlook.com (2603:10a6:20b:e9::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Fri, 3 Sep
 2021 09:21:48 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::a443:3fd9:42c2:4b85]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::a443:3fd9:42c2:4b85%5]) with mapi id 15.20.4478.021; Fri, 3 Sep 2021
 09:21:48 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH 2/2] KVM: arm64: Add memcg accounting to KVM allocations
Thread-Topic: [PATCH 2/2] KVM: arm64: Add memcg accounting to KVM allocations
Thread-Index: AQHXn5F5LaBhMNeZaUatlmkgbJxAuKuRDNoAgAD+FKA=
Date: Fri, 3 Sep 2021 09:21:48 +0000
Message-ID: <AM6PR08MB437698F3753375F73F8748ECF7CF9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210902002801.32618-1-justin.he@arm.com>
 <20210902002801.32618-2-justin.he@arm.com> <875yvix2xn.wl-maz@kernel.org>
In-Reply-To: <875yvix2xn.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: EC71F66BF124C5409252E24E66C875BC.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 3c4acfb3-11bf-416d-fa7a-08d96ebc4a79
x-ms-traffictypediagnostic: AM6PR08MB5016:|AS8PR08MB7268:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB7268230192662F8E4E94C735F7CF9@AS8PR08MB7268.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4941;OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: DDrs5rYvc3zeVI7NrXkA92hKeBaKYTikoY0ZlKtG55IgOvJTf3T4A1SrhadnTbWmiccAQ9v1YjWiuphdntvyf+WYYJidZNM7HM4NuGdC/bg5jeaYpH8JOt6wW6X20xaQuX0lJbuSb4sX2INbqQtUq2OAHZburxTSXhFUUH1PtTAHWQHjER2aC6hxxiqVhiAGJC/ooHcWBF6bWJbm+BdLaB7QqrZD5j+3kk3UeBONpD7CuCk1KJs2OLUZMyNdSbd54JEQ9hPG01t8fzqB5SjJNeutpzbg4EWOcKBBqenh0PZHX3T9PvpPb1o88WjIko/R3+5WE5EwcKAkEAo4LIlPAXIm3Ju2Jk8aZAhU20y47smKZnDFORRqkBKAAIpZt95RhF/Qgh3s5fW37iWC4PdS1tCwRqiJjzONyDPDShhw/TUGb8ZCmHR4CrEyLfXnIy7mSj+TvTZpNpv3hF3U6xTB7+WL5rHt3kKMZz292JIDYexUDixLdgTWwh41I4etp15cdkQq0EL1GieEwa9YDR5WxKsZmFQzav2rkbwZChgzmyiYi5mExtgu/l98at7ff36Gl6In9c7JL1Fph9sCYsh0q4hW36uV+SPE7EWHDpPNNHKGY4/zuqEDyBbT3AGJaaNzmx+6MnjTMaffQ0/LlDyZEZkIMJpa5tcdd6YmuSTa9VBbTVwTirbqkmGxpON90JTvW5T1/ZL7rPytFX6FXH7NNA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM6PR08MB4376.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(39850400004)(376002)(396003)(136003)(366004)(4326008)(52536014)(71200400001)(122000001)(316002)(7696005)(15650500001)(5660300002)(38100700002)(7416002)(86362001)(8676002)(55016002)(8936002)(9686003)(76116006)(6916009)(33656002)(54906003)(53546011)(478600001)(66476007)(66446008)(66946007)(66556008)(64756008)(38070700005)(83380400001)(26005)(186003)(6506007)(2906002);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5016
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: fb3172c8-7ed8-480d-2990-08d96ebc4194
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNscvbNjBGMxu3W4L+YoRLxt3WjzHU2wdRKGxpKLrkfwurDSAZq7lOtLLTSkTu3zGA8Vy43w23sqikuWp2XiLsAZvUNQMrH2a+j0+PML9QsKfggp90w2TmrNvXQTGofI86fXkTqzUXxxwcKyCUAzhqIAgHUre43ACtblGJXrkZZlwlO+R4lHd4++i/a2tPcSRglTWE5rRkUWL0F6rqJ6FPPYj3qUrfLawJ/M3uiUJ85X1FMzCFiiomN92+al+o0/dXm/yFt4gMSSIuJSTF5n32rGHnqbgOcPYjcAWP15Gy481+UN1zz03xOqGzozoAJQKZrn5wvSmGjO4ukiDbEk4y8TAbPe1YsVAH8Sa4tJJDrmazdwJoYzchcSxwQzlEv7mkyxX7onziK9LPru1qSWJXFksz7EtlJg35kVZLGzGJnmBgM+oa+2ayJotqIwZAMKAlZjoVAr/icOnC5ZEQ9xhmARJIhiET8MrXj7E8GY0X4gOKYHD1dAKSbvStX3mx1gWjqFYgD7lDvrWZMSCqmv6Z7KTzbtsz1HHHkboZHrL238HtQrTk8hYV0Xs8/xDEkXhbqEPNEr/zsyyZbtvmN1HJygA6ILiE/Z4kNUSpGOYGpoLpIQnzhvlbQOLS9JBNUpJeiYinpsrx+OznFVDDIKyws7+Jb6Vxt/TXBTCJHo8pB4vE4ho+94akTNCC7BSqIs7dGNY0zOB+W8MfCNlqGoWw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966006)(36840700001)(55016002)(5660300002)(54906003)(356005)(86362001)(81166007)(52536014)(15650500001)(478600001)(7696005)(53546011)(82740400003)(33656002)(9686003)(6506007)(316002)(336012)(26005)(8676002)(83380400001)(82310400003)(2906002)(36860700001)(107886003)(8936002)(47076005)(70586007)(4326008)(70206006)(6862004)(186003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 09:22:03.1990 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4acfb3-11bf-416d-fa7a-08d96ebc4a79
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7268
Cc: Xiaoming Ni <nixiaoming@huawei.com>, Shenming Lu <lushenming@huawei.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <Catalin.Marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Liu Shixin <liushixin2@huawei.com>,
 Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Friday, September 3, 2021 2:12 AM
> To: Justin He <Justin.He@arm.com>
> Cc: James Morse <James.Morse@arm.com>; Alexandru Elisei
> <Alexandru.Elisei@arm.com>; Suzuki Poulose <Suzuki.Poulose@arm.com>;
> Catalin Marinas <Catalin.Marinas@arm.com>; Will Deacon <will@kernel.org>;
> Liu Shixin <liushixin2@huawei.com>; Eric Auger <eric.auger@redhat.com>;
> Kees Cook <keescook@chromium.org>; Nick Desaulniers
> <ndesaulniers@google.com>; Shenming Lu <lushenming@huawei.com>; Sami
> Tolvanen <samitolvanen@google.com>; Lorenzo Pieralisi
> <Lorenzo.Pieralisi@arm.com>; Xiaoming Ni <nixiaoming@huawei.com>; Zenghui
> Yu <yuzenghui@huawei.com>; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] KVM: arm64: Add memcg accounting to KVM
> allocations
> 
> On Thu, 02 Sep 2021 01:28:01 +0100,
> Jia He <justin.he@arm.com> wrote:
> >
> > Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
> > allocations"), it would be better to make arm64 KVM consistent with
> > common kvm codes.
> >
> > The memory allocations of VM scope should be charged into VM process
> > cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.
> >
> > There remained a few cases since these allocations are global, not in VM
> > scope.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  arch/arm64/kvm/arm.c      | 6 ++++--
> >  arch/arm64/kvm/mmu.c      | 2 +-
> >  arch/arm64/kvm/pmu-emul.c | 2 +-
> >  arch/arm64/kvm/reset.c    | 2 +-
> >  4 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e9a2b8f27792..9d6f5bcaddef 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -289,10 +289,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
> >
> >  struct kvm *kvm_arch_alloc_vm(void)
> >  {
> > +	unsigned long sz = sizeof(struct kvm);
> 
> If you are going to introduce an extra variable, please use the
> correct type (size_t).

Okay
> 
> > +
> >  	if (!has_vhe())
> > -		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
> > +		return kzalloc(sz, GFP_KERNEL | GFP_KERNEL_ACCOUNT);
> 
> Why both GFP_KERNEL and GFP_KERNEL_ACCOUNT?
Urgh, sorry for the mistake.

--
Cheers,
Justin (Jia He)


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
