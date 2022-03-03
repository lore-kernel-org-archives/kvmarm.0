Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4073BC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  3 Mar 2022 11:20:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E57CC49EE8;
	Thu,  3 Mar 2022 06:20:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tpj6IPUib9AR; Thu,  3 Mar 2022 06:20:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D40F49EF8;
	Thu,  3 Mar 2022 06:20:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD0749673
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2022 00:49:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ks92fCPNkO8d for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2022 00:49:03 -0500 (EST)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0666440D2E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2022 00:49:02 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnmS+2WpRszS17rlo67gZ7cHwVEEiOxNbptPZgZ2mxTtGywUeyuQoZmsTNEzsBVx2nfw2jw140UmZis+zuNPEFP4TlKqYDju5q/l97939+sf5PO05/xgkVXPKt5lF8GNgd5AYPwq3UzTuhMEFhLbokYEHmWRckW1YIb57xkGaXVUV3eoYu+gzROqW/21DBsi8bL68XGF3HkFWwzZASjAjvM1RF9bMb5B5Co7E7DZpbHb/8FS8sG17EjfU+d7i1Re40qxGtLJV7YAur3ti2OyVE3Jd3GHF/VQ0IqlOLUpJkEuy7qEIBaa3yT+s24pdol/1uTLBLzjgQi6NdDLOF77kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CK0hQGO5ibYBU4WkVfvEtDQVISuezYFEo1QPh+SHJLU=;
 b=F974kehazyRIIS5YN+yPPvIizpty3eJEN+sAmPYLCWkZBb+1eBxHFyoyMdeZNmyrfZb3ZBuS0AhW4Gw078WnL1mB90tFNKvqKiFshEQ1HGLiFCYna12CYuG6MZ/jsllmeibER7AAJ7YKmoaHAhlOEFvHkQ0UANq/3CQQdNZrz4jsFsFK3MXnaTgtYOwffUUYbV2ZZVIltMVhwgFksnUNOkAeMBGj1GbVxrjgGBQPm0Q1MuXy1KfoBuNwiUxwfDGeMCTazZNHSTZv3GOKQUd9LC4+2rHJ2ZG2vCGuTcRW6WysPHPWCwZIzG3b7oM/TDxDgcOur3Xilxqtg19KnGy9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CK0hQGO5ibYBU4WkVfvEtDQVISuezYFEo1QPh+SHJLU=;
 b=L9wGdATDfO/DOs5G0jcDxPES3Tn2YD6ZfoTVsFGCdjsXPjdamyP2Q4QNF5xgvThERQOiXlvaEnjnJ7Lo0r/Y20NgEQ9UfK4PLnRLp2dy9nyrpVTOnN9AZNQ0feduYCIeISLGeY8VirUCXfZlfm034VbAT/8wUMv7cV6fl+b/pm/GcU/OyAYDDSz6/lWLdGs1utrKzesSLrWwBanrevlv8V2Pt0QJC01X/xqdJwAUwpXOgGs3uPStGShcmHWUoGuZnEeUdkq9vYJzzggrU7MgIA1HkboQUtyZ94hMoXAKARm56LuU7tuji1TRUWAeNGnPd1pGFlSl/bs+ClmQjyeT8A==
Received: from BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14)
 by DM6PR12MB3290.namprd12.prod.outlook.com (2603:10b6:5:189::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 3 Mar
 2022 05:49:01 +0000
Received: from BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32]) by BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32%4]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 05:49:01 +0000
From: Eugene Huang <eugeneh@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: Timer delays in VM
Thread-Topic: Timer delays in VM
Thread-Index: AdgszUnmuyWPbbQDTHiT7yyfAge0rQAGT+yAAC1xtPAAGrceAAAuDgAw
Date: Thu, 3 Mar 2022 05:49:00 +0000
Message-ID: <BYAPR12MB3192AD55DF0B67DB2F7C78FFD9049@BYAPR12MB3192.namprd12.prod.outlook.com>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
 <667c9f084b2d38725369de60daef6d58@misterjones.org>
 <BYAPR12MB3192EFEBABB1B31D9751C931D9029@BYAPR12MB3192.namprd12.prod.outlook.com>
 <87wnhc6cef.wl-maz@kernel.org>
In-Reply-To: <87wnhc6cef.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22faae95-1748-448f-ab75-08d9fcd98483
x-ms-traffictypediagnostic: DM6PR12MB3290:EE_
x-microsoft-antispam-prvs: <DM6PR12MB32907E2D6A8EFFBA7749912BD9049@DM6PR12MB3290.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yG8+oBUm4VPvcjAJ7koB+am7Hrws+gcWqE10jJe2maEiJ4fvyVsIw7D1jwfGhXToMBcmkY7Ycm/wpK+zLK8x9dHafxze0QDjTHnCzCKsgVduZ6kaZRaMbNgSnRKE2jd1xzyiFsLtEZ4+3z6azmbZymRST34RkNWzYXX/lVCBVcVgOef6relOB/n1nV3ZVQxsoMGnBSPfZ3AJKVW9nkne2zllALZPQbeSKTo2H/ibThXSXALz0pKEFf8Fz01ODiBQLLr9BL0cvCDGXsWwHUAjGtcsex253DwO/XmozD5ETy5ThYSd8nPwragb4cCRgpZIEGCekYgVQlMyETLPb6TW5BrrQumt1Zzn20MsMde3I9dJ0JcAGwOJcywnShtUfVfM7Bg+Bdfo0zxTBKMbF7/5SWS5yeoi6cB5eozkyukJg1mz3RM87KmXfdBszQgWo//utFsqJ7YR/7jEmPwYa20spPH3CCHUWWJVpvZ+B+pQ0npmAw02HmT6IJXl6KwXljnQbO14YjGvZdSrVBPmSehxDOCtdcET5gPw9Kdkde5fCZU/DvAdTXYux4G9FxLO7rjkccbLBEgymJSt0CVJ4Syg+9zKcxx0HyASpP8q/KuuJ579ZoglvqeWbP2UOUo50qEC6FHSdv16KhZrShJzzXOAEOZ1MwhVMM5KPAlmHQgGSAI4lyPBDvfl2a3QmhNVlHuQV2DYgJw8zlFwdRiwq9ZPvw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR12MB3192.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(9686003)(3480700007)(53546011)(6916009)(38100700002)(33656002)(55016003)(83380400001)(2906002)(5660300002)(66946007)(52536014)(8676002)(4326008)(66556008)(66476007)(64756008)(66446008)(76116006)(86362001)(122000001)(316002)(71200400001)(38070700005)(508600001)(186003)(7696005)(26005)(6506007)(8936002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rDVSRC5AkfkS4zgYLcWeQrBamamXunAC/GT27D5Vx8oqB3lCMBwBQQT3Yc80?=
 =?us-ascii?Q?tesQlUkk7iuBdYu+rP4+CThSVz4saTTWLtiYt2rioU7VZMz2Ci217KJ9jwpH?=
 =?us-ascii?Q?YLqo/rSqlkPDbk/yGBfvV3iDQ8qUxLsI+JlFfh8Hru99jUHESVUV0Kc6MOmV?=
 =?us-ascii?Q?lXcxxIrWt1I8l+PScx0jDJ+cHVupOjXJ5WmyMHekdd9E7Qeku77o9jOoJl5a?=
 =?us-ascii?Q?oe90UogryEn4b/my8waXfe587KSVa9MfTjMMEXXoMeLbGIyhG3AonfPcETLa?=
 =?us-ascii?Q?UdHA0lASTdIFNeneTsKTE+Pr/a67Gp2PY5pWXXbJYFZWs2Vqwwe01Pak0uaF?=
 =?us-ascii?Q?a49CEQ47uonoCZHSWoc47uv4xyhFI+9unFUgNnEhcZC/rJLN9ZExYecHMBG1?=
 =?us-ascii?Q?3Hvx+f7PZ7wLX4woPHlAlmGjL4YoAA4Y0TTsVCNsXyj0ZmN3bwoRnSuDWLjG?=
 =?us-ascii?Q?HWbFnVxmXoiyszB+iw20/6rLQ0azqUKcvNW5+XrhlJxJs+WUOPm5G5nAw31s?=
 =?us-ascii?Q?ID7bQlxVFhl1DFf8+dvnIBT8wiqRpZpYx3tbip1vok1DkPhiMg32ssOVrWFW?=
 =?us-ascii?Q?tIK2SeN1dogMQZeuNSSdeeNn5HgHdG/hZu1YvitTPcI8H1ktbZGWaIXY7uC9?=
 =?us-ascii?Q?y+ZSsGY1JBeFViUdfpVIu5nVxoEUlAD/ehf8BdrlAa7cZ5mOdDiLoaQgkEGc?=
 =?us-ascii?Q?pAdZ4XdY0FUjPog7j0CKZeu7m0RyRl3qZi8DsLCZAfg8Kta/q0XPpTBvYYUm?=
 =?us-ascii?Q?YG6Hxe5PKNdS2SXbMuPiyMel91fpx/rhsfKKWSQ3qgpCDvHkPo3dYvwnMmsM?=
 =?us-ascii?Q?Bi5rY05a4G3LXqNFQ9Q3vj5gmt0rRANqXtwWHO/3Xic+BC4Eiqo3SlDBm+MZ?=
 =?us-ascii?Q?B88SQL00dVLzccdlza0HI5yKpAg62+dy6sAYfbQMG5ha+1gODLIAYs/1139T?=
 =?us-ascii?Q?F+J0VI2Swx+5WjpkdDJF+ecb6uXrEzMCW8cEhkHWkE00pzBLqs5ZkIkoTNvF?=
 =?us-ascii?Q?+glBaQjjiz95W3rZhRSLHHD3hMPshUufsDEyJPblQrQJIsH3z7HKKKSLnL5s?=
 =?us-ascii?Q?nP8NJjT11yk2B8eu05ph6KQPg+xwEXGzM7jQpJ9d0luKSmteOOIejEOIs1yF?=
 =?us-ascii?Q?+Halp/9sIKVrFT5s8b4uoXZQ3kKbpwfq0X8yDQVlJsmAUhlLYE3LArQkfaI1?=
 =?us-ascii?Q?CXnLmcRH06c44TgsIfMwYCIVHUrxhU5ash7sCqajnUFwO/J1REOC3x4CRg3g?=
 =?us-ascii?Q?MmwXcTeRqfoAIoHmwW5XtoRMtYbx99feEKbSgW7lOxQdhUx3eQFyNXd2WWhZ?=
 =?us-ascii?Q?TXiGjxJbZeKc8rNvqqpcs3LLyy2kDY2ZG+IDKzAfnDT1rGChcJSMTodEkQvM?=
 =?us-ascii?Q?APDJiJaC+AwbeK0WurIlH5KMlkQbF82Q1VzSfWRlZYfhCFStH42Y8gv4kxJx?=
 =?us-ascii?Q?CuxJYmHNonT6U4s5U9Yluo6Jzw8eGfwG+nOHCBCYqdN75GGVH4BQ7HFsU5dO?=
 =?us-ascii?Q?AZpqMEsjdQ9CbUjtk9PrvE1UYUD+fd5Vfz0uSqvWQFQWjguFv0Yp2LUVVAYo?=
 =?us-ascii?Q?uc/PVSNICf7vCee46Kogagb8CLuqv07nLVNRZHuaVO12gxxteuXt48M07jVf?=
 =?us-ascii?Q?P4Rq2SQCxRmTf+wY3CLhGWI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22faae95-1748-448f-ab75-08d9fcd98483
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 05:49:00.9866 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g54KazG0rs8T7l7x1hcvVLFWscUo0gOVp+HZNTM/izYRc/qwLGy60LnWE7rDvXhDRksCLmHfEKNAmCjUaXiPYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3290
X-Mailman-Approved-At: Thu, 03 Mar 2022 06:20:26 -0500
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

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Tuesday, March 1, 2022 11:29 PM
> To: Eugene Huang <eugeneh@nvidia.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Subject: Re: Timer delays in VM
> 
> 
> On Tue, 01 Mar 2022 19:03:33 +0000,
> Eugene Huang <eugeneh@nvidia.com> wrote:
> >
> > > >       * Does this timer rely on kvm timer irq injection?
> > >
> > > Yes. A timer interrupt is always injected in SW. But the timer
> > > interrupt can either come from the HW timer itself (the VM was
> > > running while the timer expired), or from a SW timer that KVM as
> > > setup if the guest was blocked on WFI.
> >
> > <EH> Here for arm64, EL1Virtual Timer is used. EL1 Virtual Timer is a
> > HW timer, correct?  There is an armvtimer implementation in QEMU 6.1+.
> > Does this armvtimer make a difference?
> 
> KVM only deals with the EL1 timers (both physical and virtual). I guess that by
> 'armvtimer', you mean libvirt's front-end for the stolen time feature to
> expose to the guest how wall clock and CPU time diverge (i.e. it isn't a timer
> at all, but a dynamic correction for it).

<EH> Yes, I mean the libvirt front-end setting.  Okay, got it. Thanks.

> 
> > > >       * What can be any possible causes for the timer delay? Are
> > > > there some locking mechanisms which can cause the delay?
> > >
> > > This completely depend on how loaded your host is, the respective
> > > priorities of the various processes, and a million of other things.
> > > This is no different from the same userspace running on the host.
> > > It also depends on the *guest* kernel, by the way.
> >
> > <EH> Our guest kernel is 5.4. How is the *guest* kernel involved?
> > Can you give an example? Do you have suggestions on the guest kernel
> > version as well.
> 
> It is the guest kernel that programs the timer, and KVM isn't involved at all,
> specially on your HW (direct access to both timers on VHE-capable systems).
> 
> > > >       * What parameters can tune this timer?
> > >
> > > None. You may want to check whether the delay is observed when the
> > > VM has hit WFI or not.
> >
> > <EH> Yes, delay is observed after vm_exit because of WFx (not sure WFI
> > or WFE) but only when on a different vCPU in the same VM some workload
> > is started.
> 
> Let me see if I understand what you mean:
> 
> - vcpu-0 is running your timer test, everything is fine
> - vcpu-1 starts some other workload, and this affects the timer test
>   on the other vcpu
> 
> Is that correct? It so, this would tend to indicate that both vcpu share some
> physical resources such as a physical CPU. How do you run your VM?

<EH> We have the following further 1-to-1 mappings:
pcpu-20 - vcpu-0 is running your timer test, everything is fine
pcpu-21 - vcpu-1 starts some other workload, and this affects the timer test
on the other vcpu

- Each vCPU thread is pinned to its individual pCPU on the host (vcpupin in libvirt).
- Each pCPU on which a vCPU thread runs is isolated on the host (isolcpus).
- Each vCPU that runs the workload is isolated in the guest VM (isolcpus).

So we are pretty sure the workloads are separated.

> 
> Also, please work out whether you exit because of a blocking WFI or WFE, as
> they are indicative of different guest behaviour.

<EH> Will do. Somehow our current trace does not show this information.

> 
> > Since we pin that workload to its own vCPU, in theory, it should not
> > affect the timing of another vCPU.
> 
> Why not? a vcpu is just a host thread, and if they share a physical CPU at
> some point, there is a knock-on effect.

<EH> Again, because of vcpupin in libvirt, there is no sharing of a pCPU among vCPUs. At least that is our configuration intention.

> 
> > > You also don't mention what host kernel version you are running.
> > > In general, please try and reproduce the issue using the latest
> > > kernel version
> > > (5.16 at the moment). Please also indicate what HW you are using.
> >
> > <EH> Tried 5.15 and 5.4 kernels. Both have the issue. Do you think
> > 5.16 can make a difference? The HW is an Ampere Altra system.
> 
> Unlikely. The Altra is a mostly sane system, as long as you make sure that
> VMs don't migrate across sockets (at which point it becomes laughably bad).
> Nothing to do with KVM though.

<EH> Right, there is no migration of VMs.
I see kvm arm timer related code is very different between 5.4 and 5.15/5.16.  Can we still use 5.4 for both the host and the guest?

> 
> Are these kernels compiled from scratch? Or are they whatever the distro
> ships? Same question for the guest.

<EH> Yes. Both host and guest kernels are compiled from scratch. 

Thanks,
Eugene

> 
> Thanks,
> 
>         M.
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
