Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9B1C432C3
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 08:15:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52F07222A2
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 08:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="pcVJVbJH";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ktXezgO8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52F07222A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2DF34A7E4;
	Wed, 20 Nov 2019 03:15:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n7TtF4sasiwb; Wed, 20 Nov 2019 03:15:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A0D4AEA1;
	Wed, 20 Nov 2019 03:15:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD96E4AE87
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 03:15:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUUn7fyfVn9x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 03:15:33 -0500 (EST)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com
 [67.231.148.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E1394A5C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 03:15:33 -0500 (EST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
 by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 xAK85svL009739; Wed, 20 Nov 2019 00:15:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=pcVJVbJHR00NIO1/qMoawgWEZMAQ3hHmN2t0QeweNEgfimFQkV5WLNmOcZcvfFUZ+8mq
 Krdlt13aCnDYuowkfvVUvtIJrtPNR01aZWJfUaZ7UKgS1kV2vVKGang0Nm8q636LMwFF
 73vrGeihIe0K2WefCLkUpJ/NUt4QVrwg0H7lAu60mIupe86qE7rKJ7YsLU5sdEOfS4IY
 gD2PVZxw7jReb446dMHB/zBVTBb1OKAaQ10p5Yvm9CMt6ZO8FFVJzum/17+vv5tK7w0J
 C4qZTv8adRwxuJX2KSUSppNA7rz2Ds1o3G5Cn8/e9w9Rm6V+6WQRplrLLw1qfTXtP0LN Wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
 by mx0a-0016f401.pphosted.com with ESMTP id 2wc8426q8a-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Wed, 20 Nov 2019 00:15:23 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 00:15:21 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server
 (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 00:15:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGT3MWsudxRjOGISj/k9T7o7gkcRQgFEYg2L5A63yNi+buNFI9JoQLzQOLL56c/jUu4WpKV72vsHARHPL7Mod5wmhPVx0tBtNfBM5yOHqaXUgBUqRfrH1szU3tbAVfA7aGUjeZkyXRZtnzTj20sSB1JEkgxylYvhvGaOG9x7vrpm+Kk9YD4gJV3JKOAzNeRmEGy/pTSyTtAIVJk1G5PxrUYstwxePZlQ+7n9ozKwexDGSUeASBhywA/ZlkR09KvzmYEJIAn14FRXJsJefBXaV+03XXOvLM2VTHa+GEANYhOHwZ6H5cNgTwjir8T8loUTdQnek/X4uo2j36W1iTDgrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=Wk4ABorT4iqmrYARRa73BhfiRu8T0Aj4G7hQLIHumvJJv70x9SGQZEYrmOdrgBzAIfifrvbTRjVhweqzqTn7SIQ5ZrXLSt3KEalkD3XBQW0efA6CH4QFRdb5n6AB2uiLfB94LcFyLQkFqqMyefTjh485/41WA/1sJ+vCs10VJPRlA+BDojgOONIl5sQ2bx+ZqvOIZQPk+93N+cLOaZbDSnQIXKKH65F06uSyvFdj6+/i7q6hwlCfzpC7eSBriB8JcNWNc/e/XlVaaRm+Im7C636HLQtCFxiiXw2Cx35CHDes6dOLzsrT3/A44fqk4QgxvJHoXZ1CUoDrAgtcC+UqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXccrDU4jUg8Cth88saDCvqjzfq1z2Cdv4jy/cqZRCk=;
 b=ktXezgO83w4oXl9++xzm1DPIDu8m/qr0eWO6oDgXp4t0jfWQCIOXIKWhwGSvOiKqT4j+bQDh2NljIa8oUZfpW8cChjvvUTl7F6U5BARyTkqiBBKxyOCI/SOBZey8nPZe2Rn8c5VJMVxNYJemoVFA7FZlJ0dCCTd+Ovi9eSapyI4=
Received: from DM6PR18MB2969.namprd18.prod.outlook.com (20.179.52.17) by
 DM6PR18MB2730.namprd18.prod.outlook.com (20.179.52.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Wed, 20 Nov 2019 08:15:18 +0000
Received: from DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::f5f0:40c:87ca:4b84]) by DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::f5f0:40c:87ca:4b84%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 08:15:18 +0000
From: Tomasz Nowicki <tnowicki@marvell.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
 <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org"
 <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com"
 <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com"
 <jacob.jun.pan@linux.intel.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
 "will.deacon@arm.com" <will.deacon@arm.com>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Topic: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Index: AQHVn3qlKxoei5IlH0+Ji9e5qHWChQ==
Date: Wed, 20 Nov 2019 08:15:18 +0000
Message-ID: <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
In-Reply-To: <20190711135625.20684-1-eric.auger@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To DM6PR18MB2969.namprd18.prod.outlook.com
 (2603:10b6:5:170::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [31.172.191.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 511b3813-700b-4929-8dd0-08d76d91c78a
x-ms-traffictypediagnostic: DM6PR18MB2730:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <DM6PR18MB27304A6E59439019CB8BE753D24F0@DM6PR18MB2730.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(2171002)(81166006)(81156014)(2616005)(5660300002)(478600001)(7736002)(31696002)(966005)(86362001)(229853002)(476003)(14444005)(8936002)(256004)(25786009)(99286004)(446003)(31686004)(11346002)(6512007)(2201001)(8676002)(6306002)(66066001)(71200400001)(71190400001)(66946007)(66476007)(66556008)(64756008)(66446008)(6486002)(26005)(36756003)(186003)(6436002)(2906002)(2501003)(7416002)(54906003)(316002)(110136005)(4326008)(6506007)(6246003)(305945005)(386003)(53546011)(52116002)(486006)(14454004)(3846002)(6116002)(76176011)(102836004)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DM6PR18MB2730;
 H:DM6PR18MB2969.namprd18.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5XU6CdYtVWDSLeSFMlnH3VfJ5byiDBsDVDvIxv/Bl5Zh/RBdTUTx9owzLNIm3VBcBpaIim3wcYPjWdlEA/x8K0Ckro4a34b8oaalE2cy1W9H2WQidCpc1JwNYbTpSFG5hnfPRLzWNHfrVzVRUnDqWg4pSKMOjr3tm69EZHgn9FIgNI5NxQXStMjCOXKZl4tIqEJr9uiCW9wMzNgyHHYEkNLDxqxwFvqghtTJ4T9t6Q3xC1O0aVXDhbIaKVyVXlluLAOvy9ikPW6jD70je+C1bFKI7ZR1aJ+XbCPOaIxGHooAmkvwMwxrNRJBRSlY/irwbKddg8ThNzd9bAIgjxOAucxoT032QTbk/LQDnZ3d0gP2PqHRQXWDny5IukUbuFx463Ig0FDXD03T4gtGFyjzcMbbFLaXbWLpG/47yKfDwSPW2q+Sd12e4iVTIKhIvyYQ73av4juht5SyAqcJCBxgcTqONa7nxzUth97b/wWVno=
x-ms-exchange-transport-forked: True
Content-ID: <2B66C25518CA4B489527FA76BDF3EB82@namprd18.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 511b3813-700b-4929-8dd0-08d76d91c78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 08:15:18.5304 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ziiaiol5YSefcNdInRscD0CJCZxVGCSEHe8U1BkQrQMi7BUfCGIiMBMjbphR1ZIiRnJS+QB9eRpDyjbU3yJm7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2730
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_01:2019-11-15,2019-11-20 signatures=0
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
 "tina.zhang@intel.com" <tina.zhang@intel.com>
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

Hi Eric,

On 11.07.2019 15:56, Eric Auger wrote:
> This series brings the VFIO part of HW nested paging support
> in the SMMUv3.
> 
> The series depends on:
> [PATCH v9 00/14] SMMUv3 Nested Stage Setup (IOMMU part)
> (https://www.spinics.net/lists/kernel/msg3187714.html)
> 
> 3 new IOCTLs are introduced that allow the userspace to
> 1) pass the guest stage 1 configuration
> 2) pass stage 1 MSI bindings
> 3) invalidate stage 1 related caches
> 
> They map onto the related new IOMMU API functions.
> 
> We introduce the capability to register specific interrupt
> indexes (see [1]). A new DMA_FAULT interrupt index allows to register
> an eventfd to be signaled whenever a stage 1 related fault
> is detected at physical level. Also a specific region allows
> to expose the fault records to the user space.
> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9

I think you have already tested on ThunderX2, but as a formality, for 
the whole series:

Tested-by: Tomasz Nowicki <tnowicki@marvell.com>
qemu: https://github.com/eauger/qemu/tree/v4.1.0-rc0-2stage-rfcv5
kernel: https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9 + 
Shameer's fix patch

In my test I assigned Intel 82574L NIC and perform iperf tests.

Other folks from Marvell claimed this to be important feature so I asked 
them to review and speak up on mailing list.

Thanks,
Tomasz
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
