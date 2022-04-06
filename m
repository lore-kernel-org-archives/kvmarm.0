Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A525C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 08:17:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7030A4B23B;
	Wed,  6 Apr 2022 04:17:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QINtO115oK5Y; Wed,  6 Apr 2022 04:17:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BF34B1F8;
	Wed,  6 Apr 2022 04:17:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DB74B1C4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 04:17:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cST9yID7wjWU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 04:17:06 -0400 (EDT)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A98FD4B1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 04:17:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1649233026; x=1680769026;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-transfer-encoding:mime-version;
 bh=bkKk7o1XYRdTXykDELtVl3JoUUa8hHd7RofStPtOB18=;
 b=iQXXI5G4fyAq7+jqkW77TzfPLhiRRmf5s4CCb5vB9IQ5ji8VwIXVfWxu
 jVbOMvUpmxd2sGb7SfK6keyJ4+teBDp91jgzqIcnRRCu3pWhxdhjGBgvb
 zT6tCdFHjwls1Wk2s4/PkWD78+DxNZgk82ExUpYt+rLz7N1TLJwuLOoVW
 ucbOPNkzH+RJHh5EEVx5rx+BP0B0SF2ZfeAe+iQGU8sAtM741s/WOMyCv
 4SNEQTUv3p5IvKT2URue4EoHQbAOya4L9uvTuKxncqZ5vn2eelokT9pp5
 O5aOWK9BBTF8/rqFAcCI05WqKgNCQJrbjrQnepuE+qj7jDdxhy/e4Mz/E g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="259817999"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; d="scan'208";a="259817999"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 06 Apr 2022 01:17:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; d="scan'208";a="608800505"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
 by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2022 01:17:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 01:17:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Apr 2022 01:17:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Apr 2022 01:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+YpBY0jb8HKE8hm2g4lzDSTqQ4F/1uTDWUCSGqGF3sazYbKDTrNM9jm4U1HmX+C3xGCTy5tE+n6/t4PpAGoRb8mUv/JXqNvaL9VRsNid9W0M5wKRn3vhYQO+4b3WpfRVDPyXfRzMg96N3+7V2fmo+MjDr7N3BgJ/b27IP4F196idM01BYoSxZk864QiWhxaxsNA3EZjGZFQfL8zky5M0KFmOanL83nNlmnPotX3+Rmf3un+dEMcYtyxOXFjR033j/W3QUsK5McfJ9SbJAo0NvvAF5ZYh358fkp7kxTowAopAUA84xTxhdjp7KNd3Yq1LwANfiJ2/Xi2ctL39oILTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEfTL2TF8EqVXUzATzlsMp5ulKVkt3KyH/x5B3oTXug=;
 b=PUquoaXbN7rLL4kcRhra1/+aAmAGGKsofzPePY1FScVHAhZsK2DmRio/cZLObUOlSvIbV7Ag96wWv5CJXjLsyEgw9ObV3KhZy6fuqnWOP80OWeeVgGowa25uZ396PuLTPVtUgfoGl479Ly4me4tSpro6rJKjFoI4/2YpM0iDD+UW2srJH0nttbZbohm7ipU7+GvC86XDfnOAmeUPZgKjavni0V/QT5OQISlKLITqvtujMazrJMfsB8hRO5oz+uWc0eaThT9TsNIufgiEwtXgu33Pmyup5x/Qtk8w6FBNo/+8/h+bibiadY2PyaT8pq4t2JqeCWcU0k9wSdnxEvL4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2593.namprd11.prod.outlook.com (2603:10b6:406:ab::27)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 08:17:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 08:17:00 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v2] kvm/arm64: fixed passthrough gpu into vm on arm64
Thread-Topic: [PATCH v2] kvm/arm64: fixed passthrough gpu into vm on arm64
Thread-Index: AQHYRbFhb+/o5gfYPEODwyIzUkp2lKzbRWGAgAR9v4CAABc4gIAAJa0AgAKH4mA=
Date: Wed, 6 Apr 2022 08:17:00 +0000
Message-ID: <BN9PR11MB52767F1DF0A3895C65F2A67B8CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220401090828.614167-1-xieming@kylinos.cn>
 <87tubcbvgk.wl-maz@kernel.org> <20220404132405.GQ64706@ziepe.ca>
 <87o81gc3dc.wl-maz@kernel.org> <20220404170202.GR64706@ziepe.ca>
In-Reply-To: <20220404170202.GR64706@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d71ff164-ae77-40e0-cdd1-08da17a5d312
x-ms-traffictypediagnostic: BN7PR11MB2593:EE_
x-microsoft-antispam-prvs: <BN7PR11MB2593FA6FB7CAAA26D6BF6F2D8CE79@BN7PR11MB2593.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uv2MdIfwVWlgPjtzDIAuSShlTHZDHH1YB3qTyw9CLh9Duvo8rL5DxyYFd46Piz4nnqmB2jNFp0esOSGB5rrRUF7LOnP60DT9F2R7R/6tabZMrffwVaKIwQnMQr4A0RuU4B4kZC3dF4CgAX8i4Bwp1SOzRLl14WMTee/+df5RJvrWr5uPfgPdGfaOehFTDaZe3zDTN+23ZzA/8FL7kTp8SS059Dy+oBih6oHoZQh1I7M6IToN2kp+gDXxmM5N8l3SQWCl3ZO4DnyP49+x6RYJmpYdj+ZO2foOeU3Rucs5rFoSJtfHLbrWvz8b9NFgVNXa/4XYnSeN1xbXDlLtD/IWr38oQU/E5hfRKDYHRkCLL+ZRV54kuDABllosuEsO88eIsnQBCcnQQOM/0yFyrvYXKWIWDxFctVFNNcLueNeVd5PzVbV0krdYHvG5jzQFD6//GJOu7qJ/5lOWcB9qDAQLwNAW7OSnteiGvTHKb6aEb4FDTO/BSQl7o567cwbZmfl1+PoVUhbjsMj4W/waXLtj53nYJDrhX1nj7QMLWaPxsN1KsH80OyNhVpmeuLr6TLqVwe0QhyCznmNhSdX7nqguJ+orgCUxzpKqIqnZ7wJMwJ9hRjfHcm0IHxSQJeAQkLFozNnelNa1of6UGfaYSSKG+t/Ve5oHz/1cRsnrDA72rwmR/4bcrNC2cMdryPwxgibrhcSopWRNzSfoNikjDc6OeQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BN9PR11MB5276.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66556008)(4326008)(8676002)(66476007)(86362001)(508600001)(64756008)(76116006)(66946007)(38100700002)(38070700005)(83380400001)(66446008)(26005)(186003)(110136005)(33656002)(316002)(54906003)(7416002)(6506007)(55016003)(5660300002)(7696005)(122000001)(8936002)(9686003)(82960400001)(52536014)(71200400001)(2906002);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N7Yzp6SAUgp5bLAsllTD3LVsjdP9i1aoDNpCh11iPFARprg8qsVzRYPL4SNL?=
 =?us-ascii?Q?Y8KGwXjLipwKJH9qYrjFqCFyCmcwS0JNNdmWMeAA//dTj/RRKFHFv+GawJ9z?=
 =?us-ascii?Q?pDfJjz9EY4bDj9b2kdUlRWJDlREaDGRh08ySCtUi8YrMJ/k5E2MiRK7DxqSo?=
 =?us-ascii?Q?cBl2c+tejNHs2qH57IZKRE9q2NpLmcqQz2rxJzYhez8oAcv0dWVGyc17HMSv?=
 =?us-ascii?Q?+tKLcFkBTd1gH+DWOgKdRFyUUd3/8j3/BpYotuqayU5FByaJQbkUDUQ9uaGp?=
 =?us-ascii?Q?p4RfFzC78i0JTzMLNmxNl+rx4HM58cKjszne7iV5m4JndULd/5OdRVTNzFLn?=
 =?us-ascii?Q?HXf9wiPgvFyEu73zxBxam20DveHhGKFi0kPFLS1J+MecaV/dJJDAdhR0YqnQ?=
 =?us-ascii?Q?Re6dmBYiZbU3hs8dK9yX3Kqyrl+VVmm6GppaA3Cjk019HS+SOCY7LzCo/mxQ?=
 =?us-ascii?Q?oklo9oXpjuLtR3HEc9uoI1izWLXGTUmWOTf5rOAXM/W7FbzuBlUTUZb0kUR1?=
 =?us-ascii?Q?9ouGxnhHKDhZGCeM59KbmDwz4GvBFjKIQukbsfOLeiO8WFnln6lnd2rJIw7X?=
 =?us-ascii?Q?lCKNX1Rrhd0q3r+vhLYv6ZzzhmnhnfCaBgdWD6wbjk7mtUe1MPN4XpaO6D6A?=
 =?us-ascii?Q?LcNMVlkGlSy5t0owlP1//WaG/Rb1KEpJ1WkpGVRVk8Cu8J2R3r9Sxs1YGiz5?=
 =?us-ascii?Q?0pXa/c3PjyR5bAAbxmCpLZjrK1yBeiCP/6mTkuET3p5HJzzNg6/2xPoNcsBx?=
 =?us-ascii?Q?bsfHrfGR93I3Fzbg1Lw9zm1dlxkxdvzK0/1Zd97BxpfEUd+2piKWK5eVjyLn?=
 =?us-ascii?Q?YIAUh4hXuz27WvMUhr0XTL0hfhMqo1CHg7sQwlyyLvCM4LTxNbT9ktqiVGjq?=
 =?us-ascii?Q?EuWsZU3qcqPqLOiUlFLW905NWpc4e0ZEhfotgD0QenqZdBze+N+PqO4Po9aO?=
 =?us-ascii?Q?FZjD+gznYkfuCAv7LV4trdmEMuL3ye8qCCYLvRdmSXAjELbfW1h65c6X0Ao3?=
 =?us-ascii?Q?5AaUIfqUCln/yGnTTJX6Dr/k6u/KTo9k/Mk7x64qvnUmPoRRxkZfsqfBGaTv?=
 =?us-ascii?Q?Q0r66Zefd4oHSYysTv0wnUvROds3Vrk9NMiG8lANxHxyvfsrZ4tk7+tZ2Oc4?=
 =?us-ascii?Q?0ObtFpDYYWqth4NIiob7Fm0nQaLkQ/UzAlscgSSHgVj7Agd5EZsSepr4IqO8?=
 =?us-ascii?Q?02ZxrTUDaM8IG6uATr1s6kSXJ168qE9o5UNDirVD9fiK6foJj0SkCVERcv+m?=
 =?us-ascii?Q?+ttrrbMHZQ/3Xv75xk+KOXpSwbxN+16PajRBBIzuMjlO3ddXADTMYUipv8TB?=
 =?us-ascii?Q?mZrcZJlDW9pvvjzRfdunDVVkKjlDkG20hWq1gh7Sgq6dhCZw4JQQ1ZmVTSgP?=
 =?us-ascii?Q?SjakQ342jdIahUZLLGhdJly5TtdkQDR4ZdYpAbtIdIAQCnYiOR4Yu91MOYfz?=
 =?us-ascii?Q?o13Cq6g5OH/4JhX9sOsm+Ce1214u7V8CJH/xwohGp2gNGZbWBqCM59PV4rj+?=
 =?us-ascii?Q?wZnfXH9TJwBhaJkGpbsC3eQyH54aqqiXsjdwKutSs7zVTqdqhXAe1BFtLmB4?=
 =?us-ascii?Q?+WEafTNhekVmCE8rrl+HWuA/Cf6P4VXPhbAGcswqHOHpRyKMdd6BeTjF8jnJ?=
 =?us-ascii?Q?nNn1qz1tFSRTNWHMtg1N1LFVHqNxOi29k1cVktaR0tjdrVjGdLFB2RieB3c6?=
 =?us-ascii?Q?OEmqPebuR9J4d7ByRL59THUytUDJiyQK9K3H5fovAIWnmFlndQQ96+sxUS6f?=
 =?us-ascii?Q?JP94+RzjtA=3D=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71ff164-ae77-40e0-cdd1-08da17a5d312
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 08:17:00.3833 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hv6vXaRKJEQY3CItvkLsl+Qy0ciN5Xwnp4WKoFuwhZfwJdNQ9MYgJgwXobypYAr9ui/2uydG7JUyggBgLdm3JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2593
X-OriginatorOrg: intel.com
Cc: "sashal@kernel.org" <sashal@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 xieming <xieming@kylinos.cn>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "will@kernel.org" <will@kernel.org>,
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

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, April 5, 2022 1:02 AM
> 
> On Mon, Apr 04, 2022 at 03:47:11PM +0100, Marc Zyngier wrote:
> > > I'm guessing it will turn into a SBSA like thing where the ARM ARM is
> > > kind of vauge but a SOC has to implement Normal-NC in a certain way to
> > > be functional for the server market.
> >
> > The main issue is that this equivalence isn't architected, so people
> > can build whatever they want. SBSA means nothing to KVM (or Linux at
> > large), and there is currently no way to describe which devices are
> > safe to map as Normal-NC vs Device.
> 
> And people have, we know of some ARM SOC's that don't work fully with
> NORMAL_NC for this usage. That is already a problem for baremetal
> Linux, let alone KVM..
> 
> That is why I likened it to SBSA - if you want to build a server SOC
> that works with existing server software, you have to support
> NORMAL_NC in this way. Even if it isn't architected.
> 
> The KVM challenge, at least, is to support a CPU with working
> NORMAL_NC to create VM that emulates the same CPU with working
> NORMAL_NC.
> 
> I didn't quite understand your other remarks though - is there a
> problem here? It seems like yes from the other thread you pointed at?
> 
> I would think that KVM should mirror the process page table
> configuration into the KVM page table and make this into a userspace
> problem?
> 
> That turns it into a VFIO problem to negotiate with userspace and set
> the proper pgprot. At least VFIO has a better chance than KVM to
> consult DT or something to learn about the specific device's
> properties.
> 
> I don't know how VFIO/qemu/etc can make this all work automatically
> correctly 100% of the time. It seems to me it is the same problem as
> just basic baremetal "WC" is troubled on ARM in general today. Maybe
> some tables and a command line option in qemu is the best we can hope
> for.
> 

Not knowing those ARM details and how they differ from x86. Just FYI
how it works on Intel platform.

If no assigned device the KVM page table (EPT) PTE is always set to
'forced WB' in a way overriding the guest cache attributes.

If having assigned device, EPT PTE is set to:

  1) UC for mmio regions. The effective memory type is UC or WC
     depending on guest attributes;

  2) forced WB for memory pages if the device cannot do noncoherent
     dma. Guest cache attributes are overridden (same as no device assigned);

  3) a type making the guest cache attributes effective for memory
     pages if noncoherent dma is possible.

All above logic is contained in vmx_get_mt_mask().

Thanks
Kevin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
