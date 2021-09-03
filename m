Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BFAC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 09:19:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 547B261058
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 09:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 547B261058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9D54B16F;
	Fri,  3 Sep 2021 05:19:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id potA4+Qsx9uE; Fri,  3 Sep 2021 05:19:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 775BB4B0F7;
	Fri,  3 Sep 2021 05:19:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A67B94B0F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 05:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hEhElk45zISp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 05:19:18 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96CE24B0ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 05:19:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5F5yrhjrdcsIYa9Iga5g9uAAX3aHCsf3AZTameCORmw=;
 b=ciUjakbuDBbbloQtYP5+99pxVVukURcAjdKMCy+3JpvHVcK4Xb9WOnSjB7n+WNv9OkiREiNEh/LlFIy17dX5/viDZ8gujgJLlQBRg0fGX1jh7f40Ft6pFKq13ERClNrJ2iPhUOuyQgnIbk1bFOlEQYd3FrDzpRgeBU9DLHQPQT8=
Received: from AM6PR0202CA0062.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::39) by AS8PR08MB6598.eurprd08.prod.outlook.com
 (2603:10a6:20b:336::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Fri, 3 Sep
 2021 09:19:15 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:3a:cafe::92) by AM6PR0202CA0062.outlook.office365.com
 (2603:10a6:20b:3a::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Fri, 3 Sep 2021 09:19:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 09:19:14 +0000
Received: ("Tessian outbound 56612e04f172:v103");
 Fri, 03 Sep 2021 09:19:14 +0000
X-CR-MTA-TID: 64aa7808
Received: from af2d9f4ec51f.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 FD5D80FD-B9BE-48ED-B195-4525B2FE05BF.1; 
 Fri, 03 Sep 2021 09:19:08 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id af2d9f4ec51f.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 03 Sep 2021 09:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njI7RA45v6B9kP7AnNGKjlCT5zA4rTA2NNMWrqCsLcdWoBz8f7Wg4VWrCqRh1Dc+5uO19OKYD8DkUFj8vKeby2aqbvK8kjCbXyqENKTAPsd1ccPlIU0iB1mZbTVtlnlmSDZrxl9Y7EQWtoq68q1gXhwv46IABViAb57MYMo+9LVH7L8a81J3qEI1El6P6UD/mcYH6ITymr/W8xLBbJJrDqrga7h6ykb6xE1EXCgJEei5KeE0KRnO0L3w6DeP+eN5gsTTu5fbKUBFyfN+eUC3UbxRXJt3wGDjt3X0MLAjZBjnAFoy/EFX+QTizsXclr002OkzMN/vG3gFj+prjCbXTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
 bh=5F5yrhjrdcsIYa9Iga5g9uAAX3aHCsf3AZTameCORmw=;
 b=kGH7tQvFF0fkItjMZpARqTN/f3G1RsqHyk1cSdzqWMKBmas8vUHsFM14U9/jo2iEul0ZQmL3Wmhl4cQY9dEAA7S+9zAcrxj9jEPQDY9TzHzMslQQxjmeB4rYO46HLznBS9ZHN3fTh3TNHjjt+0hTnsJ6IEm/sjvNzzMPylAjB93Q50SefkFjAuQGhhem9jrbNB0k2ngP6rdYJTQgPqteeYUG4BgGrVfNTS+btIG4izqLeAaYaBHAh4jW7ML+JXgSUkKBOFVFTJI6hgunn6gxi10Q3O3K4kzxux84S0Z0IgLiaM56ln2Ej6OT+BoD7o4488R2usz+fxe8GmV27Tu6FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5F5yrhjrdcsIYa9Iga5g9uAAX3aHCsf3AZTameCORmw=;
 b=ciUjakbuDBbbloQtYP5+99pxVVukURcAjdKMCy+3JpvHVcK4Xb9WOnSjB7n+WNv9OkiREiNEh/LlFIy17dX5/viDZ8gujgJLlQBRg0fGX1jh7f40Ft6pFKq13ERClNrJ2iPhUOuyQgnIbk1bFOlEQYd3FrDzpRgeBU9DLHQPQT8=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM7PR08MB5477.eurprd08.prod.outlook.com (2603:10a6:20b:10f::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 09:18:55 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::a443:3fd9:42c2:4b85]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::a443:3fd9:42c2:4b85%5]) with mapi id 15.20.4478.021; Fri, 3 Sep 2021
 09:18:55 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH 1/2] KVM: arm64: vgic: Add memcg accounting to vgic
 allocations
Thread-Topic: [PATCH 1/2] KVM: arm64: vgic: Add memcg accounting to vgic
 allocations
Thread-Index: AQHXn5F7FYSWF48R9Ey6xBuf+xK+E6uRCosAgAD/d4A=
Date: Fri, 3 Sep 2021 09:18:55 +0000
Message-ID: <AM6PR08MB4376BC9B6EF50A1B17A4E106F7CF9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210902002801.32618-1-justin.he@arm.com>
 <877dfyx3bf.wl-maz@kernel.org>
In-Reply-To: <877dfyx3bf.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7BC161EBBC1FF8418BB6D3C1777279FF.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 844f5a21-0546-489c-61ae-08d96ebbe62b
x-ms-traffictypediagnostic: AM7PR08MB5477:|AS8PR08MB6598:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB659817CEE133EB4C54747085F7CF9@AS8PR08MB6598.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4502;OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9zSovdHcNr88cgNS2JmfwQy0D0/C8B8AeEVfO336DZgwfs9BmIaBYIKDcDD/fvRR9uUswC3IBC+8VPMok2T8haxXr+cV7fAceLU/txH5+SQD/k+tGfVqrfIoZLX5v4KLS4RlA3tgCMwt/Mf5JhAaDpnN+nuSJBgqXhf0eIRyW+bBWKOT9Evso0Pthkp0hEY+gDRItc4Qy+3gJ0WV9Mk9fH9OrA9H3MgFFAvOq3qOZOaW9vBqnOX2ucIgJJ3au2dP7S/LlFJI3CHl+gRH4teiKTzXDf3lKNM9g0dQNW6Pg1gpgsz1O8NVdlSFtrG31WvbWO2q+0IZAlq5sN9IvugWiVB00OUtqVqR3izztZUbHM1XPqMZAby/0Uh2bq8CQWjY7zmGqEUe8ggfimrSQITkDAD2JxIzaWcRIDSVYej2feUziZEtmV9KX/0q6U/YYstgY6+WzAXC5wzVEcvMKPoGIuB9RW2qpw6zj2MugDxulSI5/nJyVG3iW5+FROQF3Lks7CSSSuD66rVt404z40aTSjdZEKLHTz1AOhj6GQcm0BW3tsTl26ZY/VS24cWEcBh2BSXsYW62/0dTsNAdntfgHGsxKT1w1eJUmgtTrM/v/EJ5OOAzVmFqAET/CSBJg19VSq3ijl9aBPrGK0JGwEavh2Vy0TQnsPNFuUz3LjsAN2KajsXDot2wwVGIhN/O+v6vEb9nE3KVmdFi/cr/CA/oPA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM6PR08MB4376.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(26005)(66446008)(186003)(4326008)(64756008)(15650500001)(66556008)(7416002)(86362001)(76116006)(478600001)(38070700005)(8936002)(122000001)(66946007)(8676002)(71200400001)(66476007)(38100700002)(5660300002)(53546011)(7696005)(52536014)(6916009)(6506007)(9686003)(2906002)(83380400001)(33656002)(54906003)(55016002)(316002);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5477
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5012f825-7aee-4f4e-8235-08d96ebbdade
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eQAsQl5ZLZEV1s444G3fg+Bczu5b2/azjhhLna28BfZXjPyVI5MU8d0pu0d11JX3gH4wALUpLS3vFQtTPNk3qWtOLNVzMbYSmTOSyCVf+cyhVC7gtW1/hdgt8jW7br2735Y5jBwsiJAYpQZ0Vmp9neg35kEDZq3uKL1iJ020qyL/qPsiBN1/Y3ob1593PPBtxypP3iU0we9fYbzwHo4lzzmvTxMuccd8zfKbbbbKYte2wmt1vnHD8DGuzR0WxRqfknrx6I2OF8dOda3mNze+ktvJXxozCHTTkaY4dVjgUGDcy0cmxLObGTLD5RO+yQUx9j3WEcwEfl7jyBm3GLMhj6/chyCbJERg1rOAL9HPtc5stiKkQLrWyrF1ryAd/mmk0cEjiuhVfN4c0/ovP/qOpUWCiX8l/xgZ3I4mGtdIXcPRUL2tjCO8SHtMW4vlP+cpVKp79TH6RZ+b1rfuGXCZBQgYOVORnW9QjCnIE1Hikhnp2oqgjXgxsImsaZy4cZhdENIlyOVe8DM7c4JfTclqbOk+nZiAyF5UjivdSkL6GDzFWVutCk3I6lDbDsne4OPwivturgDmb2jsnRBZm8nSjcpW2mJm0jO534W2AZb8wQlhCTv+/8t8sGDyrw4E9aWcom44HEwKMebtXerdHC45kE9rpU8VkOqtIztEhU3eJNYG3ivMJUAs2lf+xvaa72EvosmCeeTvud0B5TuFUBelw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(39850400004)(346002)(376002)(136003)(36840700001)(46966006)(33656002)(6862004)(54906003)(9686003)(2906002)(82740400003)(8676002)(55016002)(186003)(107886003)(83380400001)(316002)(81166007)(82310400003)(4326008)(7696005)(15650500001)(36860700001)(478600001)(5660300002)(356005)(8936002)(47076005)(6506007)(53546011)(70206006)(70586007)(26005)(336012)(86362001)(52536014);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 09:19:14.8558 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844f5a21-0546-489c-61ae-08d96ebbe62b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6598
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

Hi Marc

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Friday, September 3, 2021 2:04 AM
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
> Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Add memcg accounting to vgic
> allocations
> 
> Jia,
> 
> Once again: please add a cover letter when you have a patch
> series. It isn't rocket science, and Git will do it for you.
> 

Okay
> On Thu, 02 Sep 2021 01:28:00 +0100,
> Jia He <justin.he@arm.com> wrote:
> >
> > Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
> > allocations"), it would be better to make arm64 vgic consistent with
> > common kvm codes.
> >
> > The memory allocations of VM scope should be charged into VM process
> > cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.
> >
> > There remained a case in vgic_set_kvm_info() since this allocation is
> > global, not in VM scope.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-debug.c   |  2 +-
> >  arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
> >  arch/arm64/kvm/vgic/vgic-irqfd.c   |  2 +-
> >  arch/arm64/kvm/vgic/vgic-its.c     | 14 +++++++-------
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
> >  arch/arm64/kvm/vgic/vgic-v4.c      |  2 +-
> >  6 files changed, 12 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-
> debug.c
> > index f38c40a76251..e6a01f210df9 100644
> > --- a/arch/arm64/kvm/vgic/vgic-debug.c
> > +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> > @@ -92,7 +92,7 @@ static void *vgic_debug_start(struct seq_file *s,
> loff_t *pos)
> >  		goto out;
> >  	}
> >
> > -	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> > +	iter = kmalloc(sizeof(*iter), GFP_KERNEL_ACCOUNT);
> 
> This really isn't an allocation made in the context of a VM. I don't
> think this hunk belongs here.

Yes, indeed


--
Cheers,
Justin (Jia He)


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
