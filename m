Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE86C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 04:00:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E89A4B104;
	Wed,  8 Dec 2021 23:00:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@intel.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t2d+uVu2XkGM; Wed,  8 Dec 2021 23:00:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CCB24B11A;
	Wed,  8 Dec 2021 23:00:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C714B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 23:00:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x7QEaFDC+nUx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 23:00:03 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7F3E4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 23:00:02 -0500 (EST)
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="225271410"
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; d="scan'208";a="225271410"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 Dec 2021 20:00:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; d="scan'208";a="480185219"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by orsmga002.jf.intel.com with ESMTP; 08 Dec 2021 20:00:01 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 20:00:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 20:00:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 20:00:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iumkQN2dKaH3S33g2oMv42iQNkh21WZx2sFTsoDQ588PK9K5/GwW9XqcBdMit3uObX/ZIX3q5fdJUNXTfBb+bhQKVuQE7zqDinT72mzUVz5D2UH4BRG881d4BIyPgTxVkiaFmN1gqC5PythZowudwjM+j6ma4VIVj4jfII/3VgpucCLYymGUwnoVtPHZcWRcZ5FWgaDRs8OlVex4yV03q1vf3hmlWrLN5rtDRK37eeuq8rdqLFXC90EFhsjcqWW4w3fT5sSsyM6qFgRwNMVksGsIUc+R7ITDt84DmX8zf37SmK/uNybuJdjzSs2TKG3kH+cjX12jaGgDdRX4ymIc7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2jGW3g3qMHyW4C6KnZETbnozOfgbM9qqMlBUvHC52w=;
 b=gLuBhiyz7Cz7QZtQEhDHRTYXIFxqDOOlFQPD++hksj4BFOLJxAkxY+oGRdc9n+loSvmsf036yn1hrxrL0W4CU9Sl8N/HJFevqC6+IaJTFMrxXTdTdEyXJm2KrQHA5nD3A6DFfJa0jt5itWN9rKzxUuba7kSk2Rk8YDOSadKfPRviENU8FqX3ZlVCSnXM/dhj41kBswwWtz6kmnhKjIEdP655i8MiLrAQM9RydARYh+Fgsf3W+bmFq2sQ7K1ZQ4bD9Xzdj0jnc5ZbCApvxAbfYp0YTofQEQhAIYj3zHXB8YyiO5DbztuK9da4iEd0a72HQRMVKt5SelxCm5AHLwh/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2jGW3g3qMHyW4C6KnZETbnozOfgbM9qqMlBUvHC52w=;
 b=McASSVdjg8xO4Wmk1gkeLknDbyTP9c3jEGx2jzpH0lDXtAyN2cY5FNXmve4CwTzQLhSYxDwL9In9Vke+BwLM23uQmZHaHfelVP7w2A2txw53gWexm9ptfT8koYoNj4idkvwGZib8xOn3tlV0+ejv4tmcuXJ8HMnka16komq7eTY=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1649.namprd11.prod.outlook.com (2603:10b6:405:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 03:59:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Thu, 9 Dec 2021
 03:59:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAEnegIAAE6oAgACHsjCAABVZoA==
Date: Thu, 9 Dec 2021 03:59:57 +0000
Message-ID: <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 977906b2-e362-4760-46ee-08d9bac85d4d
x-ms-traffictypediagnostic: BN6PR11MB1649:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1649D0A8522C4BA3E38E4A228C709@BN6PR11MB1649.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nzxELOWCoi5Ks6oRFrN81NzjS56s7kZLGWsOpCRlJpuaqY3HA6CUYiqbPDsnaerub9akjS/prcoLxo5GcDtYyl34z7YbWEMC4uVgLD3G6h7oUc2UiboMj3MMpGXpBLastSGFB3xGzD1p8c2cJyk4lbsEpK7tiIu8z6CJPNrpQUgdY7VYAh7E8aAD/cGX/362c1MYOuT2RflVmNTzRSA7bEW8DeMhc/c8UChazCY+5lUH0BVDxN3Ig/QE/PdidaxtOMa08KuqVYAJLu7yDDJ+qV9JBWyO1jwvI3fO8cr9YaqJwv9+ANH2zZdP6ECwiycPxT2RAKiqpMZO8PNZdj7Zkz79ECv/0DFbvKLZI4gJVQhJsWDeggm3av/9P6wxBpnNunvJchwYrJFB+5oDMLuoYmUZDbxJX4hPbLc7P7RMxTgVMfC1REM9ACxWlEhmUkCC1suarcdwlN79mnNmB22muXM4wbTc82CPnrEpln5jmcbj6DGSIxTNUmkhXNf6nMIDuRs4ExnPU+uxciGgGkEC/nP/zh8xZYyTy5R1Q+Ee1XhggpNShwKgTzadb/mp37na3fcGMGEbcOe3tyZxymP8XXp65Cc7cWrKNAHW0Sy5wpXVTZBpA1eWiYj1wkPRxbwWm07SmXid7/O15aN7pzDkbZc81Xl1/Ytwdfqmpl/pIizaGoci441ZwH7SLPasoOjtdRcXvoMy+lnEtXJvNxiChg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BN9PR11MB5276.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(366004)(38100700002)(5660300002)(2940100002)(66946007)(122000001)(55016003)(4744005)(82960400001)(38070700005)(316002)(110136005)(508600001)(26005)(54906003)(7696005)(86362001)(64756008)(71200400001)(66556008)(66476007)(66446008)(186003)(9686003)(52536014)(6506007)(8676002)(8936002)(33656002)(4326008)(7416002)(2906002)(76116006);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BPWeg1gU1qkXjLpegH7iQ8xAPbDViTVwHp6gRJhsjVrwaozh8+KNW8/JFRzf?=
 =?us-ascii?Q?hLKjCSnGDcIV2VmhiHyKN/Q3tP4suSAAk6li/k0XwjYVfkD2rdqbCYJ9mMT/?=
 =?us-ascii?Q?nOmBuIytrNGA+84BRy2KXrkZfTgBkStlYn9C6ISkWT/9LzebDoylfFYfj/jQ?=
 =?us-ascii?Q?dDPc3cyMLovqQlt74E8DJsx8oFxt07360/aft0FDl67fH8NvhhMmTR2fUzPE?=
 =?us-ascii?Q?1XN1pOr2buyo6osrPV+5bqrWsIRUnjqpvSk+rxIWlMk4DM2ybtOaC17TA7fZ?=
 =?us-ascii?Q?BEdv/OycYMtmsDaBJESfAwjJk39/HHQWpwQFtKxyHZEDrgg6eXBh57zJG/DQ?=
 =?us-ascii?Q?hy0AV/BoNkdHc1tJXcYsE7GhV5w8741zMb1FUDB3AZe4YK82EVSZUqcccaK0?=
 =?us-ascii?Q?fXJj0Ob3sIqlUce8lJJzQmQXfLtRcoW9jAjj6Zk4JEHNj6iEZLKI+eQJ8hIV?=
 =?us-ascii?Q?qqGhonvSfLJjBTSl0QAhALzKFrZb8TWSmHDn/3Ms5s4VYELrlyWeOsJdPf5j?=
 =?us-ascii?Q?UWnbnsKRRBRe9+kAGv7s1wsYBIIiAi6tyXAPwt8vIHVK67YbrA4Mt1+Cs1lt?=
 =?us-ascii?Q?1UyxHkaRW/r1mN4EEFN18wOUJRI05QwjfLyJUfKnPho8RRXVFqRxcUGpr6yn?=
 =?us-ascii?Q?MlmZojJVFtYrrYMYEyENWAacDYexCO9jrM+kwMAjhIjzJhS7DVTPYHK6MNZQ?=
 =?us-ascii?Q?SjwtV8eytd6sEAbdMVW0/nFG8ro9gJdTF0iL27wvlranfsoW8qi7ocHc0GnA?=
 =?us-ascii?Q?PVfpszM5i+wub4HkIJJ8pCkzUPxQH5NYXW39A9wWeyw4hRJf9D3qtBPMiyjp?=
 =?us-ascii?Q?aotUgAQzGmJjOZtAK5pAuwrGFZtg7sbS42iZ5P5JRDPDOppGL9QvpH7lFIso?=
 =?us-ascii?Q?oYpuVJduRJDJux3Mbo7ey6dugTYU4sLx+R2XCFrygima3WeZ75Y9kVt907uV?=
 =?us-ascii?Q?g/HAwmn5qVbWb3vp+32po5uFiqalhu/LoYvVCurnYKsZYy5ILTKRaU8N3kQ+?=
 =?us-ascii?Q?FTwO+qHipX8GZ6rtDnk+OrqyMpZ5VbIm1NxuY35a9A/GvLnjNUdcMefLVEY6?=
 =?us-ascii?Q?ZDkGQJbEi4qdVzFpYkpxOI62f4OEWy2lb1CW+YniA55G0Yv/CdxL9aDuBG5w?=
 =?us-ascii?Q?D5+Eh0a81Cz024husj6Kl8BW5y8aGLtFh18lnZDRJO9Pge+E0s9NGw9Gcxqi?=
 =?us-ascii?Q?8XPiQRwTrg34TfCN7Rrjo4cDNoOEna6ynvudxkARmQcRC82KlT1MJqCDBppO?=
 =?us-ascii?Q?w3s2F4EtmA6IclYQJm6rR5B+ODiom70GtJ0Smi7XIwOorTB8ggOkoZyhFiFk?=
 =?us-ascii?Q?SAqj7qPEFJHGRxwfinFouuALU/+uTaR8XgCXGHnaXZM5VbdOveMqG3HVnWVK?=
 =?us-ascii?Q?YEssz7rJ3h7he5axXpt5I4nSUi1ai374h7M61lUJ/kAO4efi76IcyuFBZouI?=
 =?us-ascii?Q?4g+chYVw2pLbkrZ/Mbmv2JiMa+NLTaQeg7P9GLtQShW5qu0q+w+ef4SfoTUJ?=
 =?us-ascii?Q?Fj+J+9wZrNcdekERpKRrXeb04S+RO6gL+yTIuELxf1i3QKucR5cXH8l6dCVx?=
 =?us-ascii?Q?vTNbxxdJjK6ZMv61/sUMpWQ4Ud8oMSPCBvEm7iOCt6MGSdgZVqGw4aAqsNfo?=
 =?us-ascii?Q?EVUh87MQd1a4GzNKusCwEac=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977906b2-e362-4760-46ee-08d9bac85d4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 03:59:57.0360 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ezBm8mY4wEvJBfog7IMUNkuxBIOTAYxDFhD1Wa8ZDmSuweHR25VaHg2dhAt8BAh+8pALzPsoBvuEKaNyEgtww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1649
X-OriginatorOrg: intel.com
Cc: "lushenming@huawei.com" <lushenming@huawei.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>, "Raj,
 Ashok" <ashok.raj@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "maz@kernel.org" <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "vsethi@nvidia.com" <vsethi@nvidia.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Lu Baolu <baolu.lu@linux.intel.com>
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

> From: Tian, Kevin
> Sent: Thursday, December 9, 2021 10:58 AM
> 
> For ARM it's SMMU's PASID table format. There is no step-2 since PASID
> is already within the address space covered by the user PASID table.
> 

One correction here. 'no step-2' is definitely wrong here as it means
more than user page table in your plan (e.g. dpdk).

To simplify it what I meant is:

iommufd reports how many 'user page tables' are supported given a device.

ARM always reports only one can be supported, and it must be created in 
PASID table format. tagged by RID.

Intel reports one in step1 (tagged by RID), and N in step2 (tagged by
RID+PASID). A special flag in attach call allows the user to specify the
additional PASID routing info for a 'user page table'.

Thanks
Kevin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
