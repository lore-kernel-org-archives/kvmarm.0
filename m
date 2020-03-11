Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1498C18E5A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 11:00:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A22421D56
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 11:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fD7+l/xu";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="fFUGlcmY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A22421D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F104A5A8;
	Wed, 11 Mar 2020 07:00:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wiIOQjBKoW6s; Wed, 11 Mar 2020 07:00:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F114A4A7F1;
	Wed, 11 Mar 2020 07:00:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 384084A4CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 04:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WKbTgd9Tcuzm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 04:45:53 -0400 (EDT)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com
 [67.231.148.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 180BF4A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 04:45:53 -0400 (EDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
 by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 02B8f3Cf026325; Wed, 11 Mar 2020 01:45:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pfpt0818; bh=cnV9QvycwqaWX95dBV7YOWzdw+kj8Pu6z4jzlbmATgg=;
 b=fD7+l/xun0KkcmgrJezPz3EBd1CMIojeWB7lNOVhj8PUWTwcmwJ9uSahDTeIZ72pUxWY
 MED3/5wrn2xr2LEDozEZIQd+FvNeDqFtpMdChhv1F5pjlGntBRJx3yrb3COYDqlMWm0+
 tH4Hz6IKeohNfzdI2Ei85aNIyvrLaMyXwEF0sxpHRBw+WQ/gtXIni0UezvWkczahtlRk
 xLtvRhjZ78Nzt6v2uk5DMhDA0QhzWXGTs8s5W0Gd57vYWU87VHbqAWIx/ZQItv5DLaBN
 1XZXFLo4rqIMW1YDatAs1GdUHz+50RiwOEh3UqnUCX44chrVroytRxzb6iyBKvLYESeb 7Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
 by mx0a-0016f401.pphosted.com with ESMTP id 2ypstsh11p-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Wed, 11 Mar 2020 01:45:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 11 Mar 2020 01:45:27 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Wed, 11 Mar 2020 01:45:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 11 Mar 2020 01:45:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfDXRJV7dHhEjGEfoiFrwCxsjODEmIcO4S7MeesMvaCjGNPgQr+ON1sBnC2QbVw0Qzd5NSzfGIZx114g7tTuNhbaHpXlZ1UK21qLZ1vQDWMWSHdlaioOSPvUdGz54y4aj3o43mEiJvx0RXhNjgH1aCwHK5fLHg91vFPp4kFzt0il++1Tr2P+omWvigMTYyMPBK7wxLjFkihFWW8xGLIjaxR+6+K458ZCFvZLPmBJgfs1aS+d5SQahHK0cZmR2dy6RK+Vmgv0D6+nxPhSv5Q0NaNeR7W0r/C3m8p1NV+uVHuk6EF+34zyeWs0xNt1Gzq5vsC/QvYxKztwDSYAiVPhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnV9QvycwqaWX95dBV7YOWzdw+kj8Pu6z4jzlbmATgg=;
 b=KGEsRW/VPmDdEgF3H02VVQhXxkhndP9DNwgzj/zB9qv0q9aKNezViGeuWK5syzj7WKiv/9xZ+26L6yezX+0ipRDjLFbKgxAkMqpOV7Z7tELGwtb/8WVkjPhso6h2Gs7DquL7S0xy2M+c7Erzy4NF5o7d/4EPmHfkekDmVRFgh9PSkpzqVPhyqo3If8Aq0lfoAg7F+1aJoF3qQaD5wBXvYsx+Mk7+5ye9ZpkfmZ9yBS6FYVeI8FdHRO70206KHVNKlEsiaw3yjRI7ySD1F/7YrMctw+zxugExrhpWMtr54GjUGEQ0pQ2vxbZeAI3TyxL4xEs1wKlzq6vSAFgJt53uYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnV9QvycwqaWX95dBV7YOWzdw+kj8Pu6z4jzlbmATgg=;
 b=fFUGlcmYGn1tbwXWH7P2xSzKuLKgQ/QsIV+P/qlgBnqrCOG4FL/GRZXh47cl+IyXaezIKkN3JiaA6PdMt0i2GP1Ez8EiTSZl4z0uE8xOPht67UK8ElxEDYXMoXY+MavsLyGSVwxIi04xCEekIgKT0aU+0NiVdst8CBHUHDK5ITI=
Received: from MN2PR18MB3408.namprd18.prod.outlook.com (2603:10b6:208:165::10)
 by MN2PR18MB3152.namprd18.prod.outlook.com (2603:10b6:208:16d::29)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Wed, 11 Mar
 2020 08:45:25 +0000
Received: from MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff]) by MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 08:45:25 +0000
Date: Wed, 11 Mar 2020 09:45:15 +0100
From: Robert Richter <rrichter@marvell.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 03/32] irqchip/gic-v3: Workaround Cavium TX1 erratum
 when reading GICD_TYPER2
Message-ID: <20200311084515.5vbfudbls3cj2cre@rric.localdomain>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-4-maz@kernel.org>
 <20200309221137.5pjh4vkc62ft3h2a@rric.localdomain>
 <b1b7db1f0e1c47b7d9e2dfbbe3409b77@kernel.org>
Content-Disposition: inline
In-Reply-To: <b1b7db1f0e1c47b7d9e2dfbbe3409b77@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-ClientProxiedBy: HE1PR07CA0020.eurprd07.prod.outlook.com
 (2603:10a6:7:67::30) To MN2PR18MB3408.namprd18.prod.outlook.com
 (2603:10b6:208:165::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rric.localdomain (31.208.96.227) by
 HE1PR07CA0020.eurprd07.prod.outlook.com (2603:10a6:7:67::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.8 via Frontend Transport; Wed, 11 Mar 2020 08:45:22 +0000
X-Originating-IP: [31.208.96.227]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2a17bfe-37d5-40a0-891e-08d7c5988a71
X-MS-TrafficTypeDiagnostic: MN2PR18MB3152:
X-Microsoft-Antispam-PRVS: <MN2PR18MB3152E35704CBFA34993602CDD9FC0@MN2PR18MB3152.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(199004)(66556008)(81166006)(26005)(8936002)(53546011)(66476007)(316002)(6666004)(8676002)(54906003)(66946007)(1076003)(81156014)(6506007)(7416002)(186003)(4326008)(2906002)(55016002)(956004)(478600001)(52116002)(5660300002)(7696005)(16526019)(9686003)(86362001)(6916009);
 DIR:OUT; SFP:1101; SCL:1; SRVR:MN2PR18MB3152;
 H:MN2PR18MB3408.namprd18.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; 
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZrQ9hMrr9LgPSo+M/A0DCjKsC/o47rBt/XDDfTcle9h/c0cTI5BRO0DOh7E12gUfAxBgvTjZCNhX+rPXmfYk+jTXgxjk7JsFxSqnbMalW/NMjUfFhNJ0aOB36pyx8MqVWshanGspMQI23Dm0yBgx0igA8IPPC4mJhNK+v7k9JI9WdZ54wloE6P/LrD2kzRK1347CC7AKuEoRDT2IX/3OdRl0f+yo4PAMlksN5gR14XEHuCxZ+myoD0U5myB6DbYrXp27D1o8KWcCw4Q5nhpvHlOa+4OuoT9ai6e0bCuh7aOLLkdrUtRcUuWrJaOjvUjb2Re5U3JXhF6ymCY0HN9Fp0xuRk7I6sHf1A3dFPhr3t5d1yT4b+2deaT20EU0VLCkdJ9qR5f6jbu7v3A1aew0Zlmh1VrotRBBeEqT5JpOfnjuTTJl8GYseQYGmQWPZwi
X-MS-Exchange-AntiSpam-MessageData: vwIV0hF508p2eZhZZtXjTNHL5AjyXw2PrVeUmlXr3EgCelZFjbzqwBboAkvmRvKpsD9lM4Cpxuf05qxLZcNc2jD6eFCq+yO2ub1mojbJad4kJFsGI9QuXcqgaaoeUnybHMQFlKCDwWnqQe+LRbqtkA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a17bfe-37d5-40a0-891e-08d7c5988a71
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 08:45:24.8749 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrUKzvv9f1Bm7aK7eJam/7g6b6CijeAala1fPhiGDrmHxooxsa/g09tKQ/9tQVVh1xbQHPrFPFX9f8GcqHhO6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3152
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138, 18.0.572
 definitions=2020-03-11_02:2020-03-10,
 2020-03-11 signatures=0
X-Mailman-Approved-At: Wed, 11 Mar 2020 07:00:49 -0400
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Andrew Murray <Andrew.Murray@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
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

On 10.03.20 11:41:09, Marc Zyngier wrote:
> On 2020-03-09 22:11, Robert Richter wrote:
> > On 24.12.19 11:10:26, Marc Zyngier wrote:

> > > @@ -1502,6 +1512,12 @@ static const struct gic_quirk gic_quirks[] = {
> > >  		.mask	= 0xffffffff,
> > >  		.init	= gic_enable_quirk_hip06_07,
> > >  	},
> > > +	{
> > > +		.desc	= "GICv3: Cavium TX1 GICD_TYPER2 erratum",
> > 
> > There is no errata number yet.
> 
> Please let me know when/if you obtain one.

GIC-38539: GIC faults when accessing reserved GICD_TYPER2 register

Applies to (covered with iidr mask below):

 ThunderX: CN88xx
 OCTEON TX: CN83xx, CN81xx
 OCTEON TX2: CN93xx, CN96xx, CN98xx, CNF95xx*

Issue: Access to GIC reserved registers results in an exception.
Notes:
1) This applies to other reserved registers too.
2) The errata number is unique over all IP blocks, so a macro
   CAVIUM_ERRATUM_38539 is ok.

> 
> > 
> > > +		.iidr	= 0xa100034c,
> > > +		.mask	= 0xfff00fff,
> > > +		.init	= gic_enable_quirk_tx1,
> > 
> > All TX1 and OcteonTX parts are affected, which is a0-a7 and b0-b7. So
> > the iidr/mask should be:
> > 
> > 		.iidr   = 0xa000034c,
> > 		.mask   = 0xe8f00fff,
> 
> Thanks, that's pretty helpful. I'll update the patch with these values
> and the corresponding description.
> 
> > > +	},
> > >  	{
> > >  	}
> > >  };

Thank you for addressing this.

-Robert
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
