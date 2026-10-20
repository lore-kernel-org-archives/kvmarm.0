Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792505751;
	b=pzN8NVrgp3I8qq16d8BRMa9ucKKrMQsQ7Kf3JQ/SXfxDH9GJwD0HMVYubfCVxrSkfGmA
	 0l23YhKr5Gtk7BJ1u9gdv19Z6DcG4kMtSt0TQSGyouZYiAL9bRnBSxuYD7n1tnmvqTZG+
	 AWr5Qt0S8YIf1kmAtvDJ8YID9tqrcGsiQqA1XnfS3gfWepgDkqfX9rL048hA8SeUL6SB9
	 PDLvYzU2f2g1vj97AFiYK66QNAhBbzoV60H7+HTF8jY4lXUyIIxhkzIUbpt4keYXaw8q8
	 XXKwDWchL5OSpwbYTV3sswjTBfGJhwR48wFqvoydN8aoo8KpbaO00vSAMuMddztoTTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505751;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1Grl+442tVBj2zWWfCC/7XqCpgD8fo8OS8qWEbvBQgo=;
	b=bQ2HdO6b/L/GuJFi1KWojTkeTyrm9Kcq41SRGkIbZ9v/EsAgRk6+8lbz5nOjdD7VLKTU
	 1nftBB8pa+s23itVmwHQ8I/GD+V4/jSLyA2KKhABiznvJjrz1Ui+/lBoghzaqG4aKlrfs
	 qooYCShpsX7jgJIJwLaGIXTuJCAt5Jr2Ou9KrYwtOZ1UNEOYh10E1rV6+uK1RKvsqkwwV
	 wkbtXvNUur7wTdWD+Q3z86eGwHDkgJgCrb5biNmcBDc+LHKBRHwnuFq+iYqna/lRAzuu2
	 EzwQ3Jj3dg7NPazrKGAy1yM4qjhN0dd88grkN9lBXyBr50FOzH5fjqfNyy0Zzod6KXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dFq3AiwW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.62
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013062.outbound.protection.outlook.com [40.93.196.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3402C606A321
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3402C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dFq3AiwW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSr09M7SO0pyp2onnvFQJV7hw7LegJ13MFiJcWqB4cHfJTBpOYBCcYLFUvj2OrpSVvEWzov7glTxVeIsAtXEX4C3PKQvxCPpwD/UmROyBmfLX0HmlmBCbSgEhBpxQRQ+FLcpU9t5UuDnWTlru7IF1Gs5uUaLgFdRNnpVrrDHGVQx97U2f9AQz4XuWfUV+nQTpqXlVxlaF4jf0QoEbIdOBbCVh31DaHPHwTnEisHYcT5GDsolpJimUmUrHQ5wH3P6vWlpcI9stTiDKbQsTJe0KBRrP2eiGECV13ihUQ9RNfQN7keAKDUO/GH8e+MhuprKqKrE00EN9tH+BlWzWRiHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Grl+442tVBj2zWWfCC/7XqCpgD8fo8OS8qWEbvBQgo=;
 b=gzqoHm3XIRP7YIzl94IJ9UFBlkbBAyRhhHKBmgdtm6U12xGWOEK4fpN456mc5qVrn8xFWBpSpOGkrsT/o8J+ReZsex92yHYWvgwKONcje4c9z0z+Yi1RLxjNOI7Ts83Lj0CBHsLr4kOkuPdLfQD+gNeuom3MMCdo6RcpLiGpIgMEVcBamyJ+3lwUn+oK8ZG/+J7GeC8f29wJ7Mdqk6DZ7nAvEWJGwhlFm8aOZ422VPnm9+mK4sC3kbEf3vvBthMiM6T8GplcFGr97POPoaoAu60G9ng+RtdFg5BLSxD6dyuwrENZG8q9oI/DMo/AWL5F2Y0Cx44RHM89fhqPK/4k+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Grl+442tVBj2zWWfCC/7XqCpgD8fo8OS8qWEbvBQgo=;
 b=dFq3AiwWD2G1EFflfWRVgemvol67s7m8jjWWK85phcemDFFEoppxB/0umTaDSZgjU/Gc8DX2IfHjmmfiSyb/va35d/fggsKYVDW5nMA0bTUuyrB7TX+49FNxkRlamSr6Epb2n70xedC32LtJVRuRWVyJPe+Emoj6MvVvVemBPlQYd/GKVW64JQk6OSlB20r55fw+OKoqIeA57ck2mLrkTb+uGfNTYf5F7QK9UyJBPRwH8LflVzy3VZRO5wtAA6iTiw1qOpI1jk1TUVSTfUEY9x1cV4WbhLhaSkrnC6kQJZxYkXt1F4YkDmFSVOUmrR91DqnV4zZ7XCxSkTAN2QMvCQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY1PR12MB9583.namprd12.prod.outlook.com
 (2603:10b6:930:fe::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 14:15:41 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 14:15:41 +0000
Date: Tue, 20 Oct 2026 11:15:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jean-Philippe Brucker <jpb@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
Message-ID: <20261020141540.GB3008132@nvidia.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-16-ryan.roberts@arm.com>
 <20261015164102.GC13920@nvidia.com>
 <CABCqBse_aZL-EH0us2uA5X10q6E4WP02MoHTYf+M9ezRZr26WQ@mail.gmail.com>
 <20261016144202.GG13920@nvidia.com>
 <375868af-d0bd-4278-83e6-f8429df130e9@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <375868af-d0bd-4278-83e6-f8429df130e9@arm.com>
X-ClientProxiedBy: BL1PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:208:256::28) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY1PR12MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 69e80da7-28cd-4f62-b2b5-08df2eb49f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|22082099003|18002099003|4143699003|5023799004|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4Nt8u2cbK+o6nWThaHKXJuGX9KrXU2VLuuGZXpMoleT4i3VjKxil+dHrTUQKD/hwTKgGmozBTib50a82CR5fN3XNE23HryxVsIifk+J7KgjzgOqqglIKgwMs0KmcMGpIlMkAoV/h6RhNWC1TTQr9S8kTh9cD9oRaaTfZezZR4xUQf3/g5K+LUt7/OsS4Z6b+z3e3KTRgCGMNJ/E4hovU5jYMlZSJxtPn5xO5eCjTiwQwcEspjeYHFD/XmkajzlvEH4qI8P7Ckdc4s7Eg1va1aeewkv74sSHffH3mfPGieLCKo4KCDT2wek3oRRkHW9hsTtaGtJb5PZ/7kUUhHRbVDXSVKpEDB3svtWsQ+U5NJuS/3vOFVkRRI4OAOWwFnJyRGWYIpfgS0huOPtFtsKTf/PMnnU3QN4ivVtMvmEhnzV4+JT6qcp+exh2vNEC8zcRdkQryVFpwHhk0diwjqAMDQEGzx2luj6VIwWXU2pFYWTgHYVm2e7VYtb3ROFwXRqzHeZAVicBuF+fwiXCr0LiJ0c95YNB0wTDp28ErHSCmwfbOgNzsXzKhH6rpYQPJTWpjD3f7hxtq+p84lOO/Jbys0Imp+J1PQb4yy8QnK9yUbDq5qz+i8ckyOHW6UlbtWGIskd9IaV3CSDP5haGqtpttYfnxqbbjJAF3/aCql8wAmjk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(22082099003)(18002099003)(4143699003)(5023799004)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aq5cgkkCcscL0cw72xNQ5KIz3KgvbqwEGmvCbcKlqDKFuAfyKsVNkYApO6zq?=
 =?us-ascii?Q?VJchVlc3qM7WaxUXzer0IU9sSRUZ0Jhc0nRc0HbSyY2Mk1Jz4NnpruEWkRq0?=
 =?us-ascii?Q?vSyu8dSmSAa9Ctfcfuw/GjAHe2wH67riE0pRl0qx8P/v2OqUB5Q3LLLaDi9t?=
 =?us-ascii?Q?bJ2x6NEVRPz5kIXRrOxXudyyfsI3nv/hC3k4nJxtLBU1LMFOOzo/InX7FdSE?=
 =?us-ascii?Q?+HcZ9Dwn8zYZrR6TEOdi9l8DPa5JLzpC1KgqUtUZeKbGlPTsLzSajZKmOfP6?=
 =?us-ascii?Q?Mqa77OpBuLMa6xHxSENL9MLC6oFaHa/0qOqOyes5ihBmot6HVDDEKQ+gcORl?=
 =?us-ascii?Q?26fCKwuS2HJ0qPXpPO7PgC7/9QFbtqKkMYSxY1drVRvLM0QnSbPhkz05R+hk?=
 =?us-ascii?Q?dLSFlZY0tSav4aNPhVfYhbZgLjAjQFO/Lbr17kvBXDu5P1+IWo1hJlP+xf5G?=
 =?us-ascii?Q?+63qDdpOBcTETZIUh7gwDs5kq1y5yQxsTLgl+aGeXYYWyjvjcZ/h3YPUmQjS?=
 =?us-ascii?Q?mRJTDlI6+CKn8rbqTI/sTk8djUKpNXujDjqDC0gknAYFbbMO+Sh+zk5wvqZ0?=
 =?us-ascii?Q?s0tXk73E6ompsQYFMd+e/zr2Kzb4DiJAeqdZUVDpLXRJaH3au5G+WZ6t5bXC?=
 =?us-ascii?Q?rITz8cXvhFPPRPeEHux6aOVFJCVvfelN1vOq7eHkRLMXe6oSFoipEisIs3le?=
 =?us-ascii?Q?jE1XUker14IygqF5gDdMasQAAYxnhL9ihBWXzRH9nkXADNCWpSpO6smZ8ZP4?=
 =?us-ascii?Q?JdsIqYRsEcjfNIFqf2xCAjFdJgj70BxfZQFzUVOGM/z3bzz2uJjYKpjt4obC?=
 =?us-ascii?Q?WFPkG1ZTC1CtJo7LwGX8LIyMZGjVOKseaD+rueclEMazNVto6HVQ1zee/14v?=
 =?us-ascii?Q?ilu0+7vVeQsGbdS+yz4Nh2l7LFiDYt60lCAa72lC3xy2l6M3cnjJ1B3uiwBZ?=
 =?us-ascii?Q?11LxoQxKtiX247fOEZd7OpHMWqAgysWSLkkXFDYkTdnsFogs6nhD0NCLLwTg?=
 =?us-ascii?Q?0LJSjj9GgMDGDl+cb5bsBIZXDk66bpS+WbF3dBcTjX25zHtPwJgYkZ1dH8zN?=
 =?us-ascii?Q?SCr9jh50Di3BtTLJA3vy9elGDq/q9ZyETud+8qPoa9ryZdc2zFPVMncR0Rv3?=
 =?us-ascii?Q?xEoMCd7PEZbQ8epo8zcNJOeDXfimPdWiLWtm5GqeKpPna4wVYtpsWbpqNXeT?=
 =?us-ascii?Q?7UySdXNo8kjmUVRCOkniatWewDXWibnpIObkzSNSxerz+Eq3wRMjVeHTORjH?=
 =?us-ascii?Q?QmxUfyNdyePpgM2KtvE+igKxJcb1NOi7JcCw/SgMoBh+HWYcTo688Z0NnIyi?=
 =?us-ascii?Q?yw4xPMBdieRM9KQIVz+46fj2oJkaDHT3dkDRlpzfOTh1I0zENQA9aRQEMYHV?=
 =?us-ascii?Q?P7xHRDtkMoEhHa2b0v2HxGNTWfi15K1JYdSX3/4K1mp8RP9mt+BYfgFJR6ae?=
 =?us-ascii?Q?KPsIyEqOjjbOBeJiMS0InFFnjOubNrPeMjAptzAjnUGvMJGDu45rKeirliHw?=
 =?us-ascii?Q?iwj50y4gGPOO7WGR+dEbgMoUW6aKNuP76bCJNJQyVGOH3tEpn/o1F61s7eN2?=
 =?us-ascii?Q?byZ7JmEooUF6znvssMHpJj+biZHrdpCq8A7q6djRJ9ZVGGhCcT2cU/Ojjisd?=
 =?us-ascii?Q?Iw+LlU/HFQ2ft4iIWhyxqm7kut1TcQroq0MOapKAsFxqcZ8p+ib7pj8hQh7N?=
 =?us-ascii?Q?JxI675dCPUAjfQoNQ42EokMr7x4S0QM/rNzv4W7Hd3IJySxa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e80da7-28cd-4f62-b2b5-08df2eb49f8b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 14:15:41.6548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bs8WEqf6cya3k34FoXK1TQLK0hDME/Bt3xtKwYK243gytr3DtdlbB1yjiBEPEPlF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9583

On Tue, Oct 20, 2026 at 11:41:57AM +0100, Ryan Roberts wrote:
> On 16/10/2026 15:42, Jason Gunthorpe wrote:
> > On Fri, Oct 16, 2026 at 03:22:00PM +0100, Jean-Philippe Brucker wrote:
> >> On Thu, 15 Oct 2026 at 17:41, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>> I think I said this last time, please don't use vfio mdev for
> >>> anything. There is nothing mediated about this.
> >>
> >> We don't multiplex a device between guests, but the host driver must
> >> control part of the device registers while the remainder is assigned to
> >> a guest. The host configures accelerator access, stage-2 translation,
> >> handles CPUHP and context save/restore. So we can't bind the device to
> >> vfio-platform.
> > 
> > That's fine, you can make a proper vfio-cla driver.
> 
> Hi Jason,
>
> Thanks for taking a look at this! I've been chewing on this comment and trying
> to educate myself deeper on the subject. I have a proposal...
> 
> Currently we create a struct device per CLA device instance. But multiple CLA
> device instances cooperate within a domain and the domain is the "unit of
> isolation"; 

Well that's weird and a bit confusing.

> we can't have some CLAs from a domain assigned to a VM, while others
> from the same domain are used by the host. Therefore it didn't feel like the
> correct model to unbind one of these devices from the native driver and rebind
> it to a cla-vfio driver. mdev seemed to solve this problem nicely for us.
> 
> But looking into it in more detail, I guess something like this might be a bit
> more standard:
> 
>  - Split the existing CLA driver into three components:
>     - cla-core: Hardware discovery, domain configuration, struct device
>       registration and CPU hotplug
>     - cla-native driver: Provides the user space accelerator interfaces
>     - cla-vfio driver: Enables domains to be assigned to virtual machines
>  - Each domain has a struct device (created by the core)
>     - An individual CLA is not represented by a struct device
>  - Either cla-native or cla-vfio can then bind to a domain device
>     - cla-native exposes a char device per domain, per accelerator class
>     - cla-vfio
> 
> For VFIO, I guess we could use one VFIO region per CLA, which would allow the
> VMM to construct a device tree. But it would need to additionally determine
> which CPU each CLA is bound to; perhaps that's a sysfs interface that cla-core
> could expose?

I don't know alot about your CLA, but this sounds reasonable. There
may be uses with containers to have the split exposed like this too.

Jason
