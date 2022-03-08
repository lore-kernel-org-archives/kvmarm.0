Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCCBC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 11:16:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F59C40D74;
	Tue,  8 Mar 2022 06:16:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X8-xDI3HGns6; Tue,  8 Mar 2022 06:16:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 725A9403FD;
	Tue,  8 Mar 2022 06:16:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4962640C58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 02:50:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bSLMmpUQaUDu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 02:50:52 -0500 (EST)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1036340BDF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 02:50:52 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrnUN8Tp85/XQNFlXxO3yJQGobrnAtZdR17bAzSzOU9dvn8lm5k/tWYJPKscZBke9HJlJ2oN2U/eko5JCdkO2dwxvSVoYaHjK6abSOIGkYOykyEr9Z2NSqf6JyS/J+eRBxaHbQnnjda0aZs3CCq+t6F2tyovdRas3f8jZf1bUp5drvyRsEz1KPiR5Jea3HbyhOqVImRAUS20C00WR2U7y3hKgx0hqt6lTaYo2h0IYNaFbJSnEYWCkdMS4K+qHM9KnsDxStz5jLsKprSV7MII115ftfPL17SZsWUOu+uvrE5fxTdRtxB7HjzwPWHU/reiJdjO2yoN5HtLqQGd6XSpww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNvwTDeMLdX3uBFm8PQkEpw6RMvbS6JHHZkQPxrscGk=;
 b=eZktn85guNdrryOEZU1SH35ri4qKl6KdFa2XUE/xyrupae38aQkDYjigKFRNXsUb4V1uYgOeQTWRa6ZFmwyy4C8mVqAFj+6sV/NcIC6GZw5kvrEOPJN/yvuMshrw1c+OfzQZtJfJ696c1nqWW6hQZ4/n0ywY4YFtatzLclz6Cxt7Um/gDU+u55JZzXppwXqMzuWXuFOqiJeuKY/Mt93h09uucwLROU6nZGjUn9z0GIYDGRR2ORVKKVWwSr0lIid0MNqYVwn9cPQYRqhuKO3y1s8XupRUMIl7eHyBBslXAsOxQfV7fKl7P1HcPonySsj18CHgtcpgFyUf81T2wQ6tYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNvwTDeMLdX3uBFm8PQkEpw6RMvbS6JHHZkQPxrscGk=;
 b=mIFmt+wIDaGJhupJxS051tdneiaCX+HDrDEaZueHURd5nIAPcFoXvPT8jxzgCwsCn4Hz8dswyQNZ+ODizkTzsyMMczltTx07nk39zuDgrO+jv0hcLYvncfwcsRTQY2hUvWz41GfLYMIuADU0oWDjS/uMufBe7evBSID+0gFi7yklYKEMPMN9BVrfh5yxIZ9AWHONB7oNdRFi40e7uzF8Tzkw8Ew2DZIoVqTB9obgvCUW2nLoclGsTXqgcNKOZzziTDrhRrJSHDBcoW2VzLgD0louPtPymUFsdFNR+5UYWA5a7zouqYUY+xbKYljguR8cfTOQUcUYNCMo4lk0iAgzCw==
Received: from BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 07:50:50 +0000
Received: from BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32]) by BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 07:50:50 +0000
From: Eugene Huang <eugeneh@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: Timer delays in VM
Thread-Topic: Timer delays in VM
Thread-Index: AdgszUnmuyWPbbQDTHiT7yyfAge0rQAGT+yAAC1xtPAAGrceAAAuDgAwABNiCYAA7FdAwA==
Date: Tue, 8 Mar 2022 07:50:50 +0000
Message-ID: <BYAPR12MB31928F0EECC9EDAEA01BA7F3D9099@BYAPR12MB3192.namprd12.prod.outlook.com>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
 <667c9f084b2d38725369de60daef6d58@misterjones.org>
 <BYAPR12MB3192EFEBABB1B31D9751C931D9029@BYAPR12MB3192.namprd12.prod.outlook.com>
 <87wnhc6cef.wl-maz@kernel.org>
 <BYAPR12MB3192AD55DF0B67DB2F7C78FFD9049@BYAPR12MB3192.namprd12.prod.outlook.com>
 <87v8wv14iq.wl-maz@kernel.org>
In-Reply-To: <87v8wv14iq.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6209fb4-f18d-40f0-59a3-08da00d85d2f
x-ms-traffictypediagnostic: DM6PR12MB4388:EE_
x-microsoft-antispam-prvs: <DM6PR12MB43882F075928F903CEFE83C4D9099@DM6PR12MB4388.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXRWIAeQL1LqA4lTjkp16UYGA5AmWaxTU6JhOh26Px+/omJ7KYeFV7VjhRBiKzAj7VwqmJjwzEpxn0zq4rXPbgDAiTnz60YpDeoa+CfJXqMSxRyRkHUiB1kg72JPr8yJrpqSsyHhE8JxsodvC+ScmSTj/y8Up68lorF47p/CFnB5WAcU9+Qilh/bO+O2GYItWajlVVypf7C1f6loLU2Qp5+VivS6vihCVuYYKBnEyXIsEOiNRgupVe16bece0V+X6WxSDYSnSxrvZlYam4E/hriSRV/xkzI0hoqw1adiyoXXqfVOPrISA2jl2VB8m+2xeWY9G+Pp8JDHltr8tr4hlo3RfZVIsSTuxLGBVjYrdbg6Vn5V2Xdizjrao5Q6j4yxuNYy6oKkDK7lBPTci18EPWA5mlr1LjgIvlY9Nfetj4C9EJp7jNfTsm3cpmoO3IXHfJvKpH1gRkpnJMRYCEQQxKR3Alcfq5E7Kyz3knks/bsXL/yHz+6seKMa3axO0sm9m2GeMmz5fPog1+BLYrRkVoCPxUfM9N63okOfycvipqdbduXtVByBrKrHfB0I75aoGHkxLfId1T8lpYytddy8Y6Fo7eyF18wT0XGU7mo2iAHSAdAjcx5tq7L/OdTFzCjvzbitAieBJTXkDtFZtgU5zW4hdckDc33YcCM9Q1xIaSLGE1jSH2qXkF1s/0IoiCJLtX7t8OvjsbdO0gQhXGX9dg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR12MB3192.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(71200400001)(6506007)(55016003)(7696005)(53546011)(38100700002)(3480700007)(83380400001)(38070700005)(2906002)(33656002)(5660300002)(316002)(26005)(8936002)(9686003)(52536014)(76116006)(66556008)(66946007)(86362001)(122000001)(6916009)(186003)(8676002)(66446008)(4326008)(64756008)(508600001)(66476007);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LkW6UZfinPitKeQwcWj5Dk8DN+6CnmqtnKiXpyjhKTS9vAfOQ6iO0sP5P3t4?=
 =?us-ascii?Q?o9DYYsDovKFm9lyAQAXGgFlhZjSX2zmS003Ucem+C6yt3yC+0l9nLjty0Dx2?=
 =?us-ascii?Q?BcFNAmyT1EJw012PRkjKZ8g9chy5Tt9NhjpSyc/XJn67eO5VIZkBdoKusa9Y?=
 =?us-ascii?Q?6tODhCLvbS1dad2BzTpjTmJ43sGPm+g6g7d8Dnib07j9Xu/LsmwapcTy4gJB?=
 =?us-ascii?Q?8OMlWeOMEoGN822G7fYpFVdfWzCj8BcBcCncfMIeidMeSQiBTH3VeehIiPSD?=
 =?us-ascii?Q?kYpfHzjJOtARBcCbHjoMmw14eV3TDpSLMTToID8+JQmiNOEL0GFMM5O8ntE5?=
 =?us-ascii?Q?gwsmavP6YHf1IJ5ZbsgchUO8q2nTMPSTKipcyPIqEhzKiWleCUBvciYL2Ash?=
 =?us-ascii?Q?O17xp99D9Z+WG26UvljFBMmbue1QqnKMs//kglvWr6/5ZGzQxPePuwLDQrzi?=
 =?us-ascii?Q?cRjFhkgkkt1lfZYY6ugc9dfucxAcHnhOzyI05r30aSRX8KlRNBB90r7gl3Ac?=
 =?us-ascii?Q?zYUcufeHE7KByFZxFig6OOQpTTTY9lTvXhfMR5gPu8QvsH3gecx4RurmFF2J?=
 =?us-ascii?Q?j1N1zHsEnjyii5JPs+CXCkntFpMHpJOeLq+YlDSN56zm1L3dME5LToWOJas0?=
 =?us-ascii?Q?GsRvKFVP9V/dVL34E3d2EhwspbAAVxSc9Tl7r3NTS5IM54L73HKSHH/JCqkq?=
 =?us-ascii?Q?qSmj6mUhx9ubFQOUPxeG/94W//Pdk8dafZWA8Yzc0rEM/MjvYyDjbsNTlPa7?=
 =?us-ascii?Q?6gXRPL/V9nIpoOtjU1TspW+kI3Q6hAozYFMbIY5k/vxbXZlirDEUnKlAO1fn?=
 =?us-ascii?Q?pmPHx3A52bTCGeYfl5SiEu2UXbmlP+DAlD7o3BSXkR6nH2+Omg10X2MF+4DY?=
 =?us-ascii?Q?HVrCFEC0ORxBwQQz+RWAnEQbxo5Os1quXKpdBn8TiFwTD75g5ZZi7SlmniI/?=
 =?us-ascii?Q?oSWdctd3X2jok/5tch0b5UhrYQLveXd4eKw0/AbJfmrOEDGb7qMlqbJ+Y4mo?=
 =?us-ascii?Q?3dCwDAgzemSoCjzFgeIUK0KxiDyMCGSnx0SlLn/2UNn/gYrRpnoB5WmWVHB0?=
 =?us-ascii?Q?lE2cSiS7PP5b5zgAdMO59xEh6+YaHK8pAX1dGr8JP4znLSTw1WCqpnBapNF7?=
 =?us-ascii?Q?BxYzcMa3fkqlf9OBDFRf0/us+hHks3T2KcZPCnDUnMc0X8rpKQtx+BMdMYOk?=
 =?us-ascii?Q?1FwFGtJSr7cpdCO/k3QvB4q0dwHCy0Kzk3seRj3oB45Oxg6vRe6gBvoFgnOK?=
 =?us-ascii?Q?xNxe2wC+lRhyCsgGuuA0N0Gu/r6dBLAMacCHzVHrlfc9fDJODFGuaoFY7s/c?=
 =?us-ascii?Q?iOmeoiGR+21tgZmZq0/8VF8IKHth+vCPQGkYXQl3KqJZrFf+wMaa31zAxGMk?=
 =?us-ascii?Q?1k0y0lKuiOpgzSze3pM2drBPi272TU2uU7sf4gKJdijfBfiGRaMqvtqZTFVQ?=
 =?us-ascii?Q?dX1lDWl+HeTz0h+fwUgzVFV3KhwDSb2RfpdAieUTGgkOKyiNEivbTLKqhaOL?=
 =?us-ascii?Q?Iql4mUS3DlsL7eYxb68SSo/Idn1r5dFGsaBZ8GCHP4gaAtpO7tlnqvPlM4ed?=
 =?us-ascii?Q?+g0ewgB4YhMsHTolpPBlB+vEARFJ+xrByIOGDQC/XVS/KkgQgUEiwBjbg25T?=
 =?us-ascii?Q?EkYlGjB/g5gm2fDKp09so4E=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6209fb4-f18d-40f0-59a3-08da00d85d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 07:50:50.2041 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BITVaO1B9q2fyugEqL4DRtmvrlxyUOrR0lchmOKdyqhbl0bijMbKJHJb5a4ZIiuugPGJUSFlO0SxlfPqsnpk7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388
X-Mailman-Approved-At: Tue, 08 Mar 2022 06:16:02 -0500
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Looks like to effectively troubleshoot, we need to upgrade our guest kernel to the latest version 5.17. I have these questions.

1. Can you please point out the kernel source that programs the arm virtual timer?
2. is The Generic Timer section in ARM Architecture Reference Manual ARMv8 the correct reference that we should refer to?
3. From the kernel community point of view, which kernel in the guest is the better - the Ubuntu one or the upstream one?

Thanks,
Eugene

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, March 3, 2022 6:43 AM
> To: Eugene Huang <eugeneh@nvidia.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Subject: Re: Timer delays in VM
> 
> External email: Use caution opening links or attachments
> 
> 
> On Thu, 03 Mar 2022 05:49:00 +0000,
> Eugene Huang <eugeneh@nvidia.com> wrote:
> >
> > <EH> We have the following further 1-to-1 mappings:
> > pcpu-20 - vcpu-0 is running your timer test, everything is fine
> > pcpu-21 - vcpu-1 starts some other workload, and this affects the
> > timer test on the other vcpu
> >
> > - Each vCPU thread is pinned to its individual pCPU on the host (vcpupin in
> libvirt).
> > - Each pCPU on which a vCPU thread runs is isolated on the host (isolcpus).
> > - Each vCPU that runs the workload is isolated in the guest VM (isolcpus).
> >
> > So we are pretty sure the workloads are separated.
> 
> Hmmm. Isolcpus certainly is something I never use. You may want to check
> whether this has an influence on what your test's behaviour. You may also
> want to post your full libvirt config, just in case someone spots an issue there
> (I won't, as I know next to nothing about libvirt).
> 
> >
> > >
> > > Also, please work out whether you exit because of a blocking WFI or
> > > WFE, as they are indicative of different guest behaviour.
> >
> > <EH> Will do. Somehow our current trace does not show this information.
> >
> > >
> > > > Since we pin that workload to its own vCPU, in theory, it should
> > > > not affect the timing of another vCPU.
> > >
> > > Why not? a vcpu is just a host thread, and if they share a physical
> > > CPU at some point, there is a knock-on effect.
> >
> > <EH> Again, because of vcpupin in libvirt, there is no sharing of a
> > pCPU among vCPUs. At least that is our configuration intention.
> 
> Which may or may not be what happens in reality. libvirt is largely opaque,
> and because you ask it to do something doesn't mean it happens the way
> you hope it does.
> 
> >
> > >
> > > > > You also don't mention what host kernel version you are running.
> > > > > In general, please try and reproduce the issue using the latest
> > > > > kernel version
> > > > > (5.16 at the moment). Please also indicate what HW you are using.
> > > >
> > > > <EH> Tried 5.15 and 5.4 kernels. Both have the issue. Do you think
> > > > 5.16 can make a difference? The HW is an Ampere Altra system.
> > >
> > > Unlikely. The Altra is a mostly sane system, as long as you make
> > > sure that VMs don't migrate across sockets (at which point it becomes
> laughably bad).
> > > Nothing to do with KVM though.
> >
> > <EH> Right, there is no migration of VMs.
> > I see kvm arm timer related code is very different between 5.4 and
> > 5.15/5.16.  Can we still use 5.4 for both the host and the guest?
> 
> That's your call. I've stopped looking at 5.4 a couple of minutes after it was
> released. If I'm going to look for something, that will be on top of upstream.
> 
>         M.
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
