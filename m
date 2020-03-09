Return-Path: <SRS0=Utlv=43=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5F5C10F27
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 10:29:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5232624680
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 10:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dON+NzP4";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="eypv9d/Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5232624680
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C598F4A523;
	Tue, 10 Mar 2020 06:29:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fH7a7ieWa3SM; Tue, 10 Mar 2020 06:29:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 683224A4A9;
	Tue, 10 Mar 2020 06:29:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B25E4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 18:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A8DM1oTsuWxq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2020 18:12:09 -0400 (EDT)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com
 [67.231.148.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC2874A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 18:12:09 -0400 (EDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
 by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 029M4tRA018885; Mon, 9 Mar 2020 15:11:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pfpt0818; bh=7l5Ki506dw3DtLR0mKDYMwyIWifxjwloNRbDO0VMy28=;
 b=dON+NzP4/u+1gkQGmW8tDqxk/wCWG3rpfcd6JUStk42qBgwHjzPE68eeK5hL7gdoHPwF
 O0RvOzsM+6L+KwipHWrTXwqVCBkmporgJIZLxXd8V3AlNDnRmnKaXfFtqBJ9aNzhiKay
 ULyKndMgMNX4Q+SQeQ/dXpZU7V8w8ekLxXUKLjST8iJmlYmoH3rESOLWqL7X0EZw/cG8
 HGsnur+6ZX4nUOSEDi54SMgZkt8w2Y7W+UckhcBPeN3Je1lZCD0kv7DXeCTG7CMV9xGo
 AYvycuv1ub/B/QnKe4g/YOmDEyquoV/ntkgU3SZQiMQOL53lqs+szp4ZFNifPXIaPR86 jQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
 by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwj0p4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Mon, 09 Mar 2020 15:11:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 9 Mar 2020 15:11:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 9 Mar 2020 15:11:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 9 Mar 2020 15:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4M3d/bb9u/NM9tajFXMmbUqOTTqDfJMZ0TQF3iYpDKNHw1j+eZQlRXIZW6W3KaJs6IlN7Za4LcHMwnK6Fcf1tFhSw1OziIbDpOql3v1UIn4WxfzgQXUqXiPtFEPP+coFmQWAgyCYlViRCrLbDAO3hrBlSJc1fvnw+kXum8h7kCaN2i73NLA4S83CBaXJxWpbgGLZb4gpnZiU0a/E34uurXbCAeBpdTiE9vr61gCmxRs+bw9Of6gLTOMcdiqQS+xJoK9HVm/LE04S0WcL8tuSUW2IBKD/f0OgK7bT6DQKNJvCRubV/nLu5lQWkCpVfEQefRCQXNajxPMvwOWKWESPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7l5Ki506dw3DtLR0mKDYMwyIWifxjwloNRbDO0VMy28=;
 b=HR/KvrO8KHDuvFGYWKMhh7Q8fqG7xQm71HqgKaJQnINOH4gDZ+C0RaDS3P1qZFprIriyugVg//xJe2ESOdM6wOWqMpidezSdOYn2ggwKuKYSQJEBHqTT72/LsXDWzVHOzJxIzRmCLmwUkEABjehZv/ZxML/br3OUM1Uo2jG3n24MR5x6v99YsiuuqJWP2NNEGwEMdGSQd1Wx/9Eib1VfIH6w5LilZaLqMZCfwZDD4By2si4+BX8Ol4CZTkogZPNKy+ikkV0Y0WAMTLD+XcXZC6A6hJphjQ9jYRRoVyzKUa6DgLMpFBQdfakA4NhnOuz/oiTzY4ATNPKqRbhvPa5wDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7l5Ki506dw3DtLR0mKDYMwyIWifxjwloNRbDO0VMy28=;
 b=eypv9d/YlOpJfwvuBGFu3v8L9HSU4JGf/Xb5i+8ehVnCv7k92SL7Ras1LY7aq7fFVxVBa3PLuNAQiRkWeyjVqUW0hmQ5ca8pKAubP0PdFQ7zjsJQkYs83EtQbeYwzSx3v/tdHKfWwZid2QIyjZSyhzVfKHPvIJ3u/w0d3a7JnYA=
Received: from MN2PR18MB3408.namprd18.prod.outlook.com (2603:10b6:208:165::10)
 by MN2PR18MB3390.namprd18.prod.outlook.com (2603:10b6:208:161::32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Mon, 9 Mar
 2020 22:11:46 +0000
Received: from MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff]) by MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 22:11:46 +0000
Date: Mon, 9 Mar 2020 23:11:38 +0100
From: Robert Richter <rrichter@marvell.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 03/32] irqchip/gic-v3: Workaround Cavium TX1 erratum
 when reading GICD_TYPER2
Message-ID: <20200309221137.5pjh4vkc62ft3h2a@rric.localdomain>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-4-maz@kernel.org>
Content-Disposition: inline
In-Reply-To: <20191224111055.11836-4-maz@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-ClientProxiedBy: HE1PR08CA0077.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::48) To MN2PR18MB3408.namprd18.prod.outlook.com
 (2603:10b6:208:165::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rric.localdomain (31.208.96.227) by
 HE1PR08CA0077.eurprd08.prod.outlook.com (2603:10a6:7:2a::48) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 22:11:44 +0000
X-Originating-IP: [31.208.96.227]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4af0b874-6dfa-4178-e01b-08d7c476db30
X-MS-TrafficTypeDiagnostic: MN2PR18MB3390:
X-Microsoft-Antispam-PRVS: <MN2PR18MB33906A6A947423C0D0F6A47ED9FE0@MN2PR18MB3390.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(45080400002)(66556008)(66946007)(86362001)(66476007)(6506007)(2906002)(6916009)(478600001)(53546011)(7416002)(8936002)(81166006)(186003)(81156014)(8676002)(26005)(16526019)(956004)(1076003)(6666004)(316002)(54906003)(5660300002)(52116002)(7696005)(9686003)(55016002)(4326008);
 DIR:OUT; SFP:1101; SCL:1; SRVR:MN2PR18MB3390;
 H:MN2PR18MB3408.namprd18.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVG6aBidd19vK9NIEuCCb9/P2zVNLNN2Sv57nEeYkDcVSOjkCyA1MSOYmIyc68v+k3ux7dENIONZI4WW0v63UTEvJQ8Ix10w26GmahsN2+WZPh7uwafpboDnmmm2IdNnNZNpXSbzBigYtvtndjnykLajSsvHBGusYX+dsbxP4J8G6xpIULJadD7RK786FLCpuLQXm44pzt+N8BPbwpsGlAm8ah1Wd2zp/QKMNOpXjfZfwmxAK28XfuKZMZDZScOxyYCcN9zLtEvV3ovo8S/O+73/yHTOZy/LW5v+nGrLZ1p4nR9SVQFMkI1CBGB7bEivI+nuxMB1LrTpmLWjPobeGlPk6S7hOjRgKSTrow9uFCFet8dRnp42cGt8AITPuSG1VJ5ncKhbbVV3TfXr4C09fU3Go0hBCQNvisWZqM/7noqbaMIY3gEuQQyvkk6818lW
X-MS-Exchange-AntiSpam-MessageData: 4gVS9hHtvutLD+fZPlbbMwiih2S52juhTm7V+HsPc99i4F6a9RSMQAZPeP/qccOJln5tuEfTuS2qMQgflIJ+C9YSl55h7HAG+ZUhM7WEfFVw1N0719AOVRGt8d8J+avAPAb5TrdHXNrXRjwyvf4O3Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af0b874-6dfa-4178-e01b-08d7c476db30
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 22:11:46.0402 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tv8piyVM8lcChJSfpLVtfusdpqRv1ZiLcAJF/pSieEJtwAP/6HHIDjNDp5pRhE+O9cj/ODCI8+4yFYyD1K9giQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3390
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138, 18.0.572
 definitions=2020-03-09_11:2020-03-09,
 2020-03-09 signatures=0
X-Mailman-Approved-At: Tue, 10 Mar 2020 06:29:28 -0400
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

On 24.12.19 11:10:26, Marc Zyngier wrote:
> Despite the architecture spec being extremely clear about the fact
> that reserved registers in the GIC distributor memory map are RES0
> (and thus are not allowed to generate an exception), the Cavium
> ThunderX (aka TX1) SoC explodes as such:
> 
> [    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: 128 SPIs implemented
> [    0.000000] GICv3: 0 Extended SPIs implemented
> [    0.000000] Internal error: synchronous external abort: 96000210 [#1] SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc4-00035-g3cf6a3d5725f #7956
> [    0.000000] Hardware name: cavium,thunder-88xx (DT)
> [    0.000000] pstate: 60000085 (nZCv daIf -PAN -UAO)
> [    0.000000] pc : __raw_readl+0x0/0x8
> [    0.000000] lr : gic_init_bases+0x110/0x560
> [    0.000000] sp : ffff800011243d90
> [    0.000000] x29: ffff800011243d90 x28: 0000000000000000
> [    0.000000] x27: 0000000000000018 x26: 0000000000000002
> [    0.000000] x25: ffff8000116f0000 x24: ffff000fbe6a2c80
> [    0.000000] x23: 0000000000000000 x22: ffff010fdc322b68
> [    0.000000] x21: ffff800010a7a208 x20: 00000000009b0404
> [    0.000000] x19: ffff80001124dad0 x18: 0000000000000010
> [    0.000000] x17: 000000004d8d492b x16: 00000000f67eb9af
> [    0.000000] x15: ffffffffffffffff x14: ffff800011249908
> [    0.000000] x13: ffff800091243ae7 x12: ffff800011243af4
> [    0.000000] x11: ffff80001126e000 x10: ffff800011243a70
> [    0.000000] x9 : 00000000ffffffd0 x8 : ffff80001069c828
> [    0.000000] x7 : 0000000000000059 x6 : ffff8000113fb4d1
> [    0.000000] x5 : 0000000000000001 x4 : 0000000000000000
> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000000
> [    0.000000] x1 : 0000000000000000 x0 : ffff8000116f000c
> [    0.000000] Call trace:
> [    0.000000]  __raw_readl+0x0/0x8
> [    0.000000]  gic_of_init+0x188/0x224
> [    0.000000]  of_irq_init+0x200/0x3cc
> [    0.000000]  irqchip_init+0x1c/0x40
> [    0.000000]  init_IRQ+0x160/0x1d0
> [    0.000000]  start_kernel+0x2ec/0x4b8
> [    0.000000] Code: a8c47bfd d65f03c0 d538d080 d65f03c0 (b9400000)
> 
> when reading the GICv4.1 GICD_TYPER2 register, which is unexpected...
> 
> Work around it by adding a new quirk flagging all the A1 revisions
> of the distributor, but it remains unknown whether this could affect
> other revisions of this SoC (or even other SoCs from the same silicon
> vendor).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 286f98222878..640d4db65b78 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -34,6 +34,7 @@
>  #define GICD_INT_NMI_PRI	(GICD_INT_DEF_PRI & ~0x80)
>  
>  #define FLAGS_WORKAROUND_GICR_WAKER_MSM8996	(1ULL << 0)
> +#define FLAGS_WORKAROUND_GICD_TYPER2_TX1	(1ULL << 1)
>  
>  struct redist_region {
>  	void __iomem		*redist_base;
> @@ -1464,6 +1465,15 @@ static bool gic_enable_quirk_msm8996(void *data)
>  	return true;
>  }
>  
> +static bool gic_enable_quirk_tx1(void *data)
> +{
> +	struct gic_chip_data *d = data;
> +
> +	d->flags |= FLAGS_WORKAROUND_GICD_TYPER2_TX1;
> +
> +	return true;
> +}
> +
>  static bool gic_enable_quirk_hip06_07(void *data)
>  {
>  	struct gic_chip_data *d = data;
> @@ -1502,6 +1512,12 @@ static const struct gic_quirk gic_quirks[] = {
>  		.mask	= 0xffffffff,
>  		.init	= gic_enable_quirk_hip06_07,
>  	},
> +	{
> +		.desc	= "GICv3: Cavium TX1 GICD_TYPER2 erratum",

There is no errata number yet.

> +		.iidr	= 0xa100034c,
> +		.mask	= 0xfff00fff,
> +		.init	= gic_enable_quirk_tx1,

All TX1 and OcteonTX parts are affected, which is a0-a7 and b0-b7. So
the iidr/mask should be:

		.iidr   = 0xa000034c,
		.mask   = 0xe8f00fff,

> +	},
>  	{
>  	}
>  };
> @@ -1577,7 +1593,12 @@ static int __init gic_init_bases(void __iomem *dist_base,
>  	pr_info("%d SPIs implemented\n", GIC_LINE_NR - 32);
>  	pr_info("%d Extended SPIs implemented\n", GIC_ESPI_NR);
>  
> -	gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
> +	/*
> +	 * ThunderX1 explodes on reading GICD_TYPER2, in total violation
> +	 * of the spec (which says that reserved addresses are RES0).
> +	 */
> +	if (!(gic_data.flags & FLAGS_WORKAROUND_GICD_TYPER2_TX1))
> +		gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);

You already said that checking for ArchRev of GICD_PIDR2 isn't an
option here. Though, it could...

Thanks,

-Robert

>  
>  	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
>  						 &gic_data);
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
