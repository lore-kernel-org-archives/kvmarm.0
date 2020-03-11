Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4B7C18E5A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 11:01:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A801821655
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 11:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DXUwmDsa";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="E0of12/4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A801821655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A324A3A5;
	Wed, 11 Mar 2020 07:01:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tqrlQeEBiaKf; Wed, 11 Mar 2020 07:00:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5D64A7FE;
	Wed, 11 Mar 2020 07:00:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8ECC4A418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aMAICywhRX17 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 05:18:46 -0400 (EDT)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com
 [67.231.156.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A56BD4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:18:46 -0400 (EDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
 by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 02B96GAF029149; Wed, 11 Mar 2020 02:18:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pfpt0818; bh=QzLOescWEVxZpG3gRQKush8+1AsCO0Y0iAOQCv12VG4=;
 b=DXUwmDsaBfNUsTTF2Z8Kk580bBUFiyPDSVkfHp1bC4gHDhW+lOZK33lhmZdifULmfVWB
 CrvZY+v5QVqJIE/x/5pEgLXrz+mKWRbhNBfWyyHEKN1UeQr8inRQ65g9Z7wzWRA9Kc95
 f/CoAxXD7j2WnEURg/fmUe53EuBVmAuKB9h/Is9WrHX3BqnpxX0gLAPdQuINH+RwdGJ1
 Mz3j+Pelyj/CdAC/G9JvEPzZdYV5i3eqEWodevxQd0oOe+lzC16CW51+lGrTTdawC7SV
 uqvP2Cssmr7eCNWXSrdbVQc0zH6hIZqV4QkUNFiTvDPLNjbzSowVP3i6rmptrlIv1loD iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
 by mx0b-0016f401.pphosted.com with ESMTP id 2yp04ft313-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Wed, 11 Mar 2020 02:18:27 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Mar
 2020 02:18:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 11 Mar 2020 02:18:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcwuSWso4AxZwJZNEpfgl2ROM2wrNf144kPeDFSgiEH44PsIib+zoKrJePE8kRMpdDUIPvAAslh2oFq5ukyt6NXAvEtDrBTi4KBONIvZJsfSQ4GhTbFQYfb2/CyIa22HWoWfLEZAEqK4JBb6z302GHCwGRcoOuUz88vPViUzWP3zyQha+OJaJLvNOjVq3c3znZNTuPBa8M/q0OiqDosMZjGJiiNA+2WhmKFdanlz4Xmgt+chkOCVW0ev2rubcZJ7EMk7bkrgtlrNWabtAvOMZgMUkn0yzhXrYK94ccXwi2FaD8OJDyLAnfhd1pnWZN/DCKq7PUB+oIR1W9I1063ycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzLOescWEVxZpG3gRQKush8+1AsCO0Y0iAOQCv12VG4=;
 b=Rxe4QZ+KMb4xCB6qD7YfSewnLVO6PRTNEBwmedR1U46OP3FPUmmEOcUBx7b3v0W4XFd0FeKCt+GqIDAM3/eUazxMqSsdSPKYWPWmPyTB6hMxvgmbXrV6LOuhh/hfrL4vZqSWjnz3XX0Aew1iPPwQbyuPcREygOHqseD+3f1xv6C0A0ExB2tuiRVGVbBAqsMztbtTXwVzplax0J8jeE8yvQkIS/E0IDx7OjWLimAhFnEJ7bOLwGXO4KBBmbe699wDr9G2qGI7Tw01EXy51uA7ysCCv44PMPk++Z5pp27ZPkWhxt2Hr8Qai7Czode417Fka7ABYeIscPExvYGPieDYOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzLOescWEVxZpG3gRQKush8+1AsCO0Y0iAOQCv12VG4=;
 b=E0of12/4FqgrF00gueL4jilerXgQw+F3/zW0IcqmItlXzFf3S7OsMDm3ixz6R5ML1UULzxSoWve6PjuS3ivaK/jynenSeMd7bA26NwEtDL/yHpZqAPgZzxjl+eQBp9Xpyy7A4NH4dI7d416bxjR8iMmlyGvPqffxPr3G/plpmHo=
Received: from MN2PR18MB3408.namprd18.prod.outlook.com (2603:10b6:208:165::10)
 by MN2PR18MB3688.namprd18.prod.outlook.com (2603:10b6:208:260::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Wed, 11 Mar
 2020 09:18:24 +0000
Received: from MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff]) by MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 09:18:24 +0000
Date: Wed, 11 Mar 2020 10:18:15 +0100
From: Robert Richter <rrichter@marvell.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 03/32] irqchip/gic-v3: Workaround Cavium TX1 erratum
 when reading GICD_TYPER2
Message-ID: <20200311091814.kp4xfsofalutlbv6@rric.localdomain>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-4-maz@kernel.org>
 <20200309221137.5pjh4vkc62ft3h2a@rric.localdomain>
 <b1b7db1f0e1c47b7d9e2dfbbe3409b77@kernel.org>
 <20200311084515.5vbfudbls3cj2cre@rric.localdomain>
 <74682a83c75bc8e517462d181e6c24c7@kernel.org>
Content-Disposition: inline
In-Reply-To: <74682a83c75bc8e517462d181e6c24c7@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-ClientProxiedBy: HE1PR0102CA0063.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:7d::40) To MN2PR18MB3408.namprd18.prod.outlook.com
 (2603:10b6:208:165::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rric.localdomain (31.208.96.227) by
 HE1PR0102CA0063.eurprd01.prod.exchangelabs.com (2603:10a6:7:7d::40) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend
 Transport; Wed, 11 Mar 2020 09:18:21 +0000
X-Originating-IP: [31.208.96.227]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10614f1-e795-4184-8ec5-08d7c59d264a
X-MS-TrafficTypeDiagnostic: MN2PR18MB3688:
X-Microsoft-Antispam-PRVS: <MN2PR18MB3688495E4FA0DBBB0B1B0953D9FC0@MN2PR18MB3688.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(39850400004)(396003)(376002)(366004)(136003)(199004)(5660300002)(4326008)(86362001)(66946007)(66556008)(66476007)(26005)(956004)(9686003)(316002)(8676002)(8936002)(478600001)(81166006)(81156014)(55016002)(16526019)(7416002)(186003)(2906002)(7696005)(1076003)(52116002)(54906003)(6666004)(53546011)(6506007)(6916009);
 DIR:OUT; SFP:1101; SCL:1; SRVR:MN2PR18MB3688;
 H:MN2PR18MB3408.namprd18.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; 
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQWrEsPg95/beV1ooE8BhYf1rSkMcMGKiJtUfKn4P0yUs8mzlD8u7oVh7Wnovp9NLl5PT8lCGsBv7aza1rpwn+R+MHnHSxphwt1n9KFd2koT/IntxuDsSkGjPV2ihjBozloJXpJ3SwcyY54XtARDqJBHjB0kUO1J65AEXqp/emEpZ0leDPjw7Elin5lEPWh911PoMkY8SapUlTcp/zom7m7d3LyUia4bG8SywnbANCTIUpECyrY0KPktZrmsprIHbAyl5QBbbo+APQZZZ5gx6CZjW3HyWasee45k7FGaaXmfo/w1Jr0M1bAP4SgnTcz8FR+Zqz3fXALexrRO6UtcO1FFa5DbHns2moQwtrIjVF6ytoPeCMGtipsG4S7ln8aqQ/6cluHGSvhxRcIQjtf/nmormyjGV8uwbkHkky6+z1knafuhg0K5odQfFGBk5cMw
X-MS-Exchange-AntiSpam-MessageData: 7WtyD512l4kCxqX5B7gVk485urlzTIX96HblqGjh9sdRB7xNYCzNBMWP6CI5XFGNjaIQ8dHGCeeu/qLVeHDEsXsEppTRxAJbFib3ihY0qdNv8VqxXv+7eOpC00QS0F16NOI3IdnZjBWwBJl8F3Tt7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: b10614f1-e795-4184-8ec5-08d7c59d264a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 09:18:24.0251 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpaoQNTNd0N+8QwjBvxH8XSFZ4gUlny0ykYjd5o7M4LrLKnanyvk988m3dNa1Em0IKuanA8uwQfvCeORVK6Y9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3688
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

On 11.03.20 09:03:48, Marc Zyngier wrote:
> Hi Robert,
> 
> On 2020-03-11 08:45, Robert Richter wrote:
> > Hi Marc,
> > 
> > On 10.03.20 11:41:09, Marc Zyngier wrote:
> > > On 2020-03-09 22:11, Robert Richter wrote:
> > > > On 24.12.19 11:10:26, Marc Zyngier wrote:
> > 
> > > > > @@ -1502,6 +1512,12 @@ static const struct gic_quirk gic_quirks[] = {
> > > > >  		.mask	= 0xffffffff,
> > > > >  		.init	= gic_enable_quirk_hip06_07,
> > > > >  	},
> > > > > +	{
> > > > > +		.desc	= "GICv3: Cavium TX1 GICD_TYPER2 erratum",
> > > >
> > > > There is no errata number yet.
> > > 
> > > Please let me know when/if you obtain one.
> > 
> > GIC-38539: GIC faults when accessing reserved GICD_TYPER2 register
> > 
> > Applies to (covered with iidr mask below):
> > 
> >  ThunderX: CN88xx
> >  OCTEON TX: CN83xx, CN81xx
> >  OCTEON TX2: CN93xx, CN96xx, CN98xx, CNF95xx*
> > 
> > Issue: Access to GIC reserved registers results in an exception.
> > Notes:
> > 1) This applies to other reserved registers too.
> > 2) The errata number is unique over all IP blocks, so a macro
> >    CAVIUM_ERRATUM_38539 is ok.
> 
> Great, thanks a lot for chasing this. One question though: does this
> apply to the distributor only? Or to all reserved registers regardless
> of the architectural block they are in?

It is the whole GIC IP block covered by GICv3 spec. It was implemented
during a very early state of the spec and the RES0 requirement was
added later to reserved registers. CN8xxx GIC CSR access checking is
stricter implemented, so if no register is present, an access results
in a fault other than simply returning a RAZ/WI.

Thanks,

-Robert

> 
> It won't change the workaround for now, but knowing the scope of the
> erratum will help future developments.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
