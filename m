Return-Path: <SRS0=lk6S=OW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2997C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  2 Oct 2021 09:05:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E7A561AFD
	for <kvmarm@archiver.kernel.org>; Sat,  2 Oct 2021 09:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E7A561AFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 976D14B12F;
	Sat,  2 Oct 2021 05:05:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P2p81yvDOeU8; Sat,  2 Oct 2021 05:04:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A2D4B104;
	Sat,  2 Oct 2021 05:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29EF24B08B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 17:44:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ni3RlZDeFAp3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 17:44:11 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50062.outbound.protection.outlook.com [40.107.5.62])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 755564B08E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 17:44:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU6iSSeeoPY+34sZ8zHH6m/oy71KNah4id1m4fa9vR4=;
 b=+Ch9gPhZRuzaKhhzB4M75dIo6bytPysiTKnp5vSBhqNufEr7ZSKqSqPyxbGB8L2l+toXX7m63xQALGg6I6ca8Xk5IF9r4AWupz0kPt6Zl8bAHfk3c4gZKKH1vr3qgUQdedvuFaYhAnYvAJcDJLGUUc5WgrhlyeC4fUWL1XtUB3c=
Received: from AS8PR04CA0080.eurprd04.prod.outlook.com (2603:10a6:20b:313::25)
 by AM0PR08MB5378.eurprd08.prod.outlook.com (2603:10a6:208:18a::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 21:43:58 +0000
Received: from VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:313:cafe::b0) by AS8PR04CA0080.outlook.office365.com
 (2603:10a6:20b:313::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Fri, 1 Oct 2021 21:43:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.33.187.114)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.33.187.114 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.33.187.114; helo=64aa7808-outbound-2.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-2.mta.getcheckrecipient.com (63.33.187.114)
 by VE1EUR03FT031.mail.protection.outlook.com (10.152.18.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 21:43:57 +0000
Received: ("Tessian outbound 3c48586a377f:v103");
 Fri, 01 Oct 2021 21:43:56 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8e07afe68617a533
X-CR-MTA-TID: 64aa7808
Received: from 853684381772.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 60198578-2B77-4A4B-9B17-DDDB240751E5.1; 
 Fri, 01 Oct 2021 21:43:44 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 853684381772.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 01 Oct 2021 21:43:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUMU1pyfOG+sNn463PyvoElPpo4LGq8H9y5NMMIGtnWo81XQNmo3VqSFDFIcbOiZGTkgv2Kt99ULHy9EsM/rPAwV43g8TsWk3uicyu2ScXAEJb9hgg555gr28Xk2bs0uZcbi6NgaA213XMFV58mLtn9XI5DJ96raVH63/0U5sfABlaBZmskimsD4+p2N7eI5LWb0HzpH64X2qeVhZFJ6L80BtzTv+d1a7FD40P7pBcZkFsd56SdX1pPwmEEg+XTvgsIzG29io/m+52HH3pS4KCvM9oxk1GZq/wHae/6/Qe+2vq53aWgojgjH8nF4i5D3+k5zFdmhE9iLZpAv2VpNJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NU6iSSeeoPY+34sZ8zHH6m/oy71KNah4id1m4fa9vR4=;
 b=h82FwssSGsDdIy5CNfbQg0z+UThr6st1ZpPlWN0c9GB4n0lezvnESIR1CW2wh44cLFYnu+VO6GTvvesgUyq9bx0DpbHt3HAVR9b2fFz0k3vClhHmgrgvHB81C6Swpd7xHK/LNUU1+bEK5Xoangh3zATk1gtdPIwWgI27BBKliSObEt+TcUugneM0qu7a9eUK5z0aY4W5FccCKm4vqyjzcHPp7T1nuLwqU7Az+tyEzi0vmh1URKeazzzEZ+ZNiPKiGf7Jl0+1i9WTzqmBtzGnDxJqIr4Iu4g//m1/LWvUkvE++4FJUUVq/mSWm+hy+x1TSk9IGQRgU1D+Kc/MhNj+bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU6iSSeeoPY+34sZ8zHH6m/oy71KNah4id1m4fa9vR4=;
 b=+Ch9gPhZRuzaKhhzB4M75dIo6bytPysiTKnp5vSBhqNufEr7ZSKqSqPyxbGB8L2l+toXX7m63xQALGg6I6ca8Xk5IF9r4AWupz0kPt6Zl8bAHfk3c4gZKKH1vr3qgUQdedvuFaYhAnYvAJcDJLGUUc5WgrhlyeC4fUWL1XtUB3c=
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB5433.eurprd08.prod.outlook.com (2603:10a6:10:118::13)
 by DB7PR08MB3419.eurprd08.prod.outlook.com (2603:10a6:10:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Fri, 1 Oct
 2021 21:43:43 +0000
Received: from DB8PR08MB5433.eurprd08.prod.outlook.com
 ([fe80::951e:f504:6b46:28a3]) by DB8PR08MB5433.eurprd08.prod.outlook.com
 ([fe80::951e:f504:6b46:28a3%9]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 21:43:43 +0000
Date: Fri, 1 Oct 2021 22:43:40 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/5] KVM: arm64: Work around GICv3 locally generated
 SErrors
Message-ID: <20211001214340.GA35802@e124191.cambridge.arm.com>
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-3-maz@kernel.org>
Content-Disposition: inline
In-Reply-To: <20210924082542.2766170-3-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: LO4P123CA0034.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::21) To DB8PR08MB5433.eurprd08.prod.outlook.com
 (2603:10a6:10:118::13)
MIME-Version: 1.0
Received: from e124191.cambridge.arm.com (217.140.106.50) by
 LO4P123CA0034.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:151::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 21:43:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ead1035-bfa8-414b-28ad-08d985249269
X-MS-TrafficTypeDiagnostic: DB7PR08MB3419:|AM0PR08MB5378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB53783E989C029B5B7A7EDD9A94AB9@AM0PR08MB5378.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: edCaCXFCg5TH0BpyHcLRfFxyRsd238B1vOYA6HYY6NKkJyBezBfKN9eqq5Ly7+VNlDUT73McKCigPatgb+/Ak0mT11jpHrVDTx8uF6pNge1+tl/ZVWIC0zoHOgjTOExNNXmF8Z1xg+C5Cx6FI9fROCGm1PGdBCTix1jTSYD/br1ZaqG4CIIk6tTtg6Enk99gQdHTRUEbvDw9J5+c/E5ruvZNyQTfsRmfSLckqXWvML0qlhuQtVBUFOCQfQ169TovKPvr2jH0bJh8++lcvZpwLdmYk9xK+qtSp23MXXbOBQHOli/twrBDX+63YHWUqPmQ5Cg1Wk0W/o3wPtbgS11l4oNCHbh26T4Lfc221Ehne7P4+khcb0DkPMhOFjV8z47Kqaq3nE03LTNo89cmvpoWlwv1aemG1npaRj/ggDUCBAAIbSJjWY3wX/UWq+8aW4zwBx33uJFpBW2lIJIDiSB02nVKKo1KDM1x0/in5ibPkO75ZG9I/98tEYFHc2ZY0lJ0iA6hHWP0OhXtdH40uwrNQ7FkO2JGd3MKKlkTuyRw9QCDn+rD5d/JDHttJW3oNtQwYUaBtstMvJ5GBzXyLCfi3ib06NU30jYy5tE+MqxT+o/7oijSp0I7uzgw5MyzJDxMdnZClTJHs140SYUJLTd0pkc7PgP8kDD47E5HkzdsJHRkoNNi4PM2fhoV6FWlouia6SFagJeIl9L1KtSk0cBVaQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB8PR08MB5433.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(956004)(86362001)(54906003)(4326008)(316002)(8936002)(8676002)(66476007)(66556008)(66946007)(6916009)(1076003)(186003)(83380400001)(508600001)(55016002)(2906002)(5660300002)(26005)(7696005)(52116002)(38100700002)(38350700002)(33656002)(44832011);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3419
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3825c291-84c9-4806-7656-08d9852489a8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNz/FRKfzo2wZRjyHSaunfGyHr0gCV7H/fgJtYLJPG5Xepxp5XKVpunAxuessZCZOya7KSK+Bzk1XVDpZaxG6vjv8goJhluRPyHx3jENEtw81T+ywWmeN58wh30/lmS96itCuiiUkuK+uwiulz+65Ixljc0AcZYOASSr3fFv6N8V1eGCDyrVqWcRwvhQ64ygFlB88azQy08Z2DqZ1ZHKX77Tt3AWujHsfDv3A7BWcEJqzvwCLqpP/ibWAXt6b3CByu3Gzvla6qJ0Y4ij5f8q51kYfjcsOzVw17S3OwWQ6glNCp+4j99B0DfOaMNljxd4472ml88kscNSunzaZd+wvnU4ADdT6R5qcPcE7N66740U3fWAqZXWvM9jui2f7oK7aLOYaVdfsL7KuUVSWcbpcvWqoRruUX5Qwr6wLECjsjzZQDzbgzOH+T17I0Gd8IppoA1hliaTkjXN1gBWTIp5Pjes0N0htC2gzmjedncum0FXqugF0qTN3JIRtN0mUSgghMqxylU+6Jj13lY2kawOxKuAyBR9sVjsLlh8k671pTU0snM3H+hNCdSuMoavgBHqho2pxRhNgcvmF/39U5cPCRpcaRhU/1YMnB9OIjORWsQzBGRggrH2Orx60AmFGd3XTVp5S5AW+BBcSD/GoJofYKhMlCs1ZHqCRdM5XkU9j7s633bWnJ8IiHqVXuJB0dVV3yQT7rLto3SFf9f0JEMM/A==
X-Forefront-Antispam-Report: CIP:63.33.187.114; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-2.mta.getcheckrecipient.com;
 PTR:ec2-63-33-187-114.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(36840700001)(46966006)(36860700001)(2906002)(33656002)(6862004)(47076005)(4326008)(70586007)(82310400003)(86362001)(5660300002)(186003)(54906003)(336012)(356005)(7696005)(70206006)(81166007)(8936002)(26005)(508600001)(8676002)(55016002)(83380400001)(1076003)(44832011)(316002)(956004);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 21:43:57.0258 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ead1035-bfa8-414b-28ad-08d985249269
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.33.187.114];
 Helo=[64aa7808-outbound-2.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5378
X-Mailman-Approved-At: Sat, 02 Oct 2021 05:04:57 -0400
Cc: kvm@vger.kernel.org, kernel-team@android.com, nd@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Sep 24, 2021 at 09:25:39AM +0100, Marc Zyngier wrote:
> The infamous M1 has a feature nobody else ever implemented,
> in the form of the "GIC locally generated SError interrupts",
> also known as SEIS for short.
> 
> These SErrors are generated when a guest does something that violates
> the GIC state machine. It would have been simpler to just *ignore*
> the damned thing, but that's not what this HW does. Oh well.
> 
> This part of of the architecture is also amazingly under-specified.
> There is a whole 10 lines that describe the feature in a spec that
> is 930 pages long, and some of these lines are factually wrong.
> Oh, and it is deprecated, so the insentive to clarify it is low.
> 
> Now, the spec says that this should be a *virtual* SError when
> HCR_EL2.AMO is set. As it turns out, that's not always the case
> on this CPU, and the SError sometimes fires on the host as a
> physical SError. Goodbye, cruel world. This clearly is a HW bug,
> and it means that a guest can easily take the host down, on demand.
> 
> Thankfully, we have seen systems that were just as broken in the
> past, and we have the perfect vaccine for it.
> 
> Apple M1, please meet the Cavium ThunderX workaround. All your
> GIC accesses will be trapped, sanitised, and emulated. Only the
> signalling aspect of the HW will be used. It won't be super speedy,
> but it will at least be safe. You're most welcome.
> 
> Given that this has only ever been seen on this single implementation,
> that the spec is unclear at best and that we cannot trust it to ever
> be implemented correctly, gate the workaround solely on ICH_VTR_EL2.SEIS
> being set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

I reproduced this issue on my M1 by using kvmtool and EDKII [1], and
have confirmed that this fixes it.

Tested-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

[1] It is fixed in EDKII now, but I reverted Ard's EDKII commit locally:
  a82bad9730178a1e3a67c9bfc83412b87a8ad734
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
