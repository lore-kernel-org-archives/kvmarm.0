Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23837C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 13:43:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A66434B13E;
	Wed,  8 Dec 2021 08:43:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xSO0sehhBJuT; Wed,  8 Dec 2021 08:42:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1579C4B149;
	Wed,  8 Dec 2021 08:42:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4694B128
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 07:56:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BeYSRPwwBIBW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 07:56:26 -0500 (EST)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAF714B11A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 07:56:25 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIbVunckKPa28LeVCQFQj7y3r+NESta0ODk9DUO72Iaol1TxT860ncALohPG+R+JiGwvBn9k+JVhNO0eJZ1QERohLafc64W6RG+luuM8OmlF8QwkNoSoW3tnR9NMv5+i0wndjoDstSYaEigTHYoYNHM0vb2Cdv62O2RMeg5JQEo7M2t3KJD3Ess1r4a0zf779xnQdRzuwSz+rGsqvn2VLjsRBdmhvKqx+EZtXHJVE2+RhyuY7itrW+ZAAph77J1vzV/rXRzU8Dv029JuXD7QC8fj7ZyGST+2Tt8o96BiGcjSCYoZe4yPep6t1R5Ox9aVrb+znyMm7F7Q2VRd6BU7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW/nNdFZuZ7IvlRvNTo8icfrO+jKXCS/ewjI60GXteo=;
 b=kMs/b/QlOImivCkY9tBhbC8tZCzXtZe9oQac5zMSVhqw25AvXpab/PDKhCdD5S0DdvJj5eRakVpgwmqQpxZl74VSJx46ajeDZrTJhLscPNEofH0AWAzTFNZgNFBesE6KgUdQ0thUfNCbjqgoOR95QqJCEtPUvvhE6RV76PF7iLOl0/eL3Jyq2Rfcb3cu0CmpYInZ60mAiaSMW8GnkBw+ZvRBkc9Gy1LayPGdrAqgP+o75J2Iil+NZUGaaihNNDu6NGJ04lJ2hkj9YaV273sL8ar9iAgsZoiQUHI2iMgkSyJxrmlNlb7coArehDi3Bb5QZBv3D3n2lQ3G3ZtAJr2c4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW/nNdFZuZ7IvlRvNTo8icfrO+jKXCS/ewjI60GXteo=;
 b=cGl2nY2ygNWmhDggJiNPSNMhLd9Gvc5r9zZk6v+xCScfK/g+aK1BWtL5QGYLXpcqwFQdzkbDWhJCijELJNIhS1129Ta50j1+EJxKwPc2mi32ukoJaj7wv3hI0HcoDMjWgjn6nMFV1W/ORbT3qw4od8zyqRux+SZX+O7shV1kjsfzLnbbyPXnfMIABuANXUtw14LzC0c+LrKEZuGck8ILkpqCGCtV/UQWMRQ48wAMjdgXyZJ31df5QaT/eYI5CMxsv8rdBJOAXOPrv8NCxThVGsA+aXEk9hNPmCvfjvbHmk2mQr7HwPyoURafROIPgYKljubaDxht1EfOHPz/gtRcXw==
Received: from BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20)
 by BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Wed, 8 Dec
 2021 12:56:23 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 12:56:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.013; Wed, 8 Dec 2021
 12:56:18 +0000
Date: Wed, 8 Dec 2021 08:56:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <20211208125616.GN6385@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
Content-Disposition: inline
In-Reply-To: <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
X-ClientProxiedBy: YTXPR0101CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bc2534f-fdc7-4769-6c9e-08d9ba4a207a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:EE_|BL1PR12MB5064:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318790FDF5C4F5181284D9BC26F9@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTOWXrzL9pegxtxBcdSXTgUQUN+w1f72NZoO6T3ollx94nOyGZhEUOrTvyZ43Z/LqTHxg6c9H4afPyYQasqzZfUSpign+W7aq5tpZqSYXSXwlCBhtcS6BLFy/sohbFgSGeEpx3EGDRzOPoJWdcGSHywnZnReLn3xhcsv78cxyZwWgX13zoHYQSmA7+yDHS54vyTfhJJG1EDhqAbIpej/9mVY3ZGMAuwW19eYIdQmnNrDK3BOKj87U61trN5V+seKKsDHQs10S8PqnmhE920UZOahZJM1E/QguQ1C2RmXczBnxRaomTQt4MtlaofCoZsO8j4pV8iSlRyFDbyO1ptzyM9A5QKStC4+O6cotAmr08VMAgPqKOJPfqForDwp21fdLysRyQbbVkoFM1OjwoZPT6UY+xRM4h6u2SdcHNXEfuQhyllEzZhVV+81TElXIY7IyirhWUSMdkWJDiKyBowbyB9qawyY9p0pbcv2XkCjWsk46UwjpvE15xSqj6hlMrAkf78mU2xqGOI/G8ktcCPC64BB9vzsuOVSP1TAHqxpYLerrLdQyZQG6s9OpPgofjUzegHhlTcxlKhY0gLTq1oJ/Bqw6Vfk7KY2bjfd29FvNteVZ5Acoor9wHXL4j76QwotQEMc8RRaqvCSN4WWn3X9LnSTFZPwYTN3SRYWIu8DudJ3RpQKqUkdewr272QG7SNgGYwyMZVQTVAThebfURt84Pt66E3Wn88xe9NcwBDJPgoWvR5QTxSFh75XDAMKRzdKNzn9gerwuF3s0MqvXv5IUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL1PR12MB5318.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(366004)(54906003)(316002)(4326008)(7416002)(33656002)(8936002)(8676002)(6512007)(186003)(83380400001)(86362001)(2616005)(6916009)(2906002)(66476007)(6486002)(508600001)(5660300002)(36756003)(966005)(66556008)(1076003)(66946007)(38100700002)(6506007)(26005)(53546011);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWNjekFsd1F6V3dsRUk4NmNGMk5zdVFMTE93SzZ3dWxzS1hLU21halJXSmVq?=
 =?utf-8?B?dFViMjgzU0YyMk1pdTVqell3L3NweklaM2x4RWNCTjEycmgxSUJLZHRRbzNH?=
 =?utf-8?B?WlFWQzlWSzgwTDl1cmhXR2Y1VTZtUTYzNjVSVDVkcHB6aklUYnh3Ny9ORkp0?=
 =?utf-8?B?dTN5bExRTjZGU1hhM0tvcC96QWMrZ3J6SVUrNXkyOGl2OFkyYWVkOWpmNEZh?=
 =?utf-8?B?Y1J2L1Yrc2ZSbktoWHQxTEppRGJGNnllaGVPY2x0TUdKaWladmJGYnZ0RzZ3?=
 =?utf-8?B?R2hQMUl0cU8rTFpZTGJ0Rll5VXVOQkppUHVLdDlHdC9CUkNhS1htLzBuM1NU?=
 =?utf-8?B?ek5hdVVpM2w2QWplU2ZMeDhLZWxuRjVXeHI4VDRwMnJpcVpiTko1cWVqekdN?=
 =?utf-8?B?V0FqdzY3b0piR2ZDRVNIb0pGUkNoU1JpVkdEMEhIc203dzNKT1BRcUw4M3A1?=
 =?utf-8?B?T2JWWWxjWFVGankxTFpIRzJCL1M1QU4yUnV3R1hES01wRXp2S2I0RTZ5cFd2?=
 =?utf-8?B?QWF1SE92VkV1MkxtdjI3dmRBbVhtamtZeUY3TTVqL0tQK2o0WklPV2h2QVRK?=
 =?utf-8?B?UUllVEpDZVZoSCtpKyttdlliaTc5bndreUlleXJSZVZDbXduKytBUVpYOWlp?=
 =?utf-8?B?VzZDMk5VMXpkSHVnaFU0S0dNK2VaS3FCOEpHSUk4WTgrcnZFTGFtZnE4dGFq?=
 =?utf-8?B?ZVh4ZGNQRWgyczluRU9uWEdBTHd1SjluNko0dHA1OE9MWmpZZGlpa3BYeEl1?=
 =?utf-8?B?YUgyMUdmSVJVMVpCL25VM2p0WWdpZVpBUlpoVFd5cWp0US9ocmdhUjVyRktX?=
 =?utf-8?B?dXJDN2thREd2aEw3VGtOdEZlM2xSWHNvekhPT2dxUEtOenp0bkgrNHZFZ0c4?=
 =?utf-8?B?cUcrd21XSktzOHFxeXJITWUyekpwMzNmSUFVTFQ1TmloY1p5VnNVUFlaZ0dv?=
 =?utf-8?B?OC9xY1h4QTJtYVRVR0RWUVNKeDVEc1hLZG1Dd09HWklEUWlxOFMvOVdNS0Vs?=
 =?utf-8?B?VlQxZXZBcE1FN25XZlZEcXphVTVGWmg2dnFueU1xbVNwZVBOaTlmOCtobW9k?=
 =?utf-8?B?TW1vVGJwa0wxWTliR2pkM3BMNWhQR3pOK0RVMktBa3o1S1I3dTdDM3pIdC92?=
 =?utf-8?B?T1dFaTFuVWt1NW16d1NsbldYVHRWbzcrK2VkZm5Gc1FtK09MWXFEMDFmeHZL?=
 =?utf-8?B?RmtnOEhaTnMzeWZJcDVWRk96YWpvM2xPNzloZUZXQXdmelEreTZyNnlGZEdM?=
 =?utf-8?B?Ymx1WU43SmJqeFZXcW8xSytXNWU2WXhHWUxoaUlXZjZlNUJtb2kvM0EyK1Bj?=
 =?utf-8?B?V250SnVscDVUTGVDU3Rib3RaQURqT3NNMzd1d252bG03dkp0R28vd3ErQk5t?=
 =?utf-8?B?OTljalNSazc1eGE1S1NYbmd4dEFlcTdxUi9QM1dxM2tIUmVTeCtvVXRJMzEw?=
 =?utf-8?B?bnNtQWgycVhUekM3aW9IT2dtVExTNnIzUTlsZmpSNlk5M3lSemZnQTJ1WmFQ?=
 =?utf-8?B?N1gvR0kwV01CbUpqdldNcXRKYUd5QjVmOG1jWHREaGpsVG1XenNNbytkampK?=
 =?utf-8?B?cm5FNFpjRy85b0M0NUN2UVR3a0VjY0dTc1VzRzVBNnV0MDNoRDZlLzdFWUww?=
 =?utf-8?B?WExvaGJzV1Q1ZHlDVm5INUo0Nm1BekxtU0QxYVZhdGV3WlFDRHVqT0dCTzJs?=
 =?utf-8?B?SmY1Rnc4UUVkclVGak9DM3VSQXk1SzZwN2dFeXdzbVZUL0VWSHkyM3c1d0dv?=
 =?utf-8?B?RHlMcU1CRXV5b053ZjRLNUt4bnZsUFlBRnpqcHNxVWd1V2RVRTVlNlk2N1BT?=
 =?utf-8?B?QXRZcEFtVGZjY2VVQk5YdlE0ckhyZTEyUXhTekhzb2E0dExLMThMZFRzbFM1?=
 =?utf-8?B?cFdJbFNkVk5mdThtczF3U1k0QjNUWEdPUWw4ZWZ1bW94VnZwMEc4Mkk5MDVE?=
 =?utf-8?B?UVpSa3BFN0lhQ1huWFBOdE1CSUk0d255OGppY3BUOS82amRLYVJHa3BGaWE5?=
 =?utf-8?B?VGdwSDNBOG1zM0NKakJpMXg3ZDY2OVVxRElPMWFpV3F3bUhVOVlZT3lFZ081?=
 =?utf-8?B?ang2L2xzR0szZnNqYUpYbGZmZFRJdUEzREU0bG1mWTd5Yzg5UXk4QWNBck1v?=
 =?utf-8?Q?nuM0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc2534f-fdc7-4769-6c9e-08d9ba4a207a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 12:56:18.7688 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHk2qywAppr9lYzU02HL2Of0ONvf54e1j/Fy/VKREL33Cx5FhvuGw1vNi1mdm6Uo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
X-Mailman-Approved-At: Wed, 08 Dec 2021 08:42:58 -0500
Cc: kevin.tian@intel.com, lushenming@huawei.com, robin.murphy@arm.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, jean-philippe@linaro.org,
 maz@kernel.org, Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, zhangfei.gao@linaro.org,
 eric.auger.pro@gmail.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gV2VkLCBEZWMgMDgsIDIwMjEgYXQgMDg6MzM6MzNBTSArMDEwMCwgRXJpYyBBdWdlciB3cm90
ZToKPiBIaSBCYW9sdSwKPiAKPiBPbiAxMi84LzIxIDM6NDQgQU0sIEx1IEJhb2x1IHdyb3RlOgo+
ID4gSGkgRXJpYywKPiA+Cj4gPiBPbiAxMi83LzIxIDY6MjIgUE0sIEVyaWMgQXVnZXIgd3JvdGU6
Cj4gPj4gT24gMTIvNi8yMSAxMTo0OCBBTSwgSm9lcmcgUm9lZGVsIHdyb3RlOgo+ID4+PiBPbiBX
ZWQsIE9jdCAyNywgMjAyMSBhdCAxMjo0NDoyMFBNICswMjAwLCBFcmljIEF1Z2VyIHdyb3RlOgo+
ID4+Pj4gU2lnbmVkLW9mZi1ieTogSmVhbi1QaGlsaXBwZSBCcnVja2VyPGplYW4tcGhpbGlwcGUu
YnJ1Y2tlckBhcm0uY29tPgo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogTGl1LCBZaSBMPHlpLmwubGl1
QGxpbnV4LmludGVsLmNvbT4KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6IEFzaG9rIFJhajxhc2hvay5y
YWpAaW50ZWwuY29tPgo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuPGphY29iLmp1bi5w
YW5AbGludXguaW50ZWwuY29tPgo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlcjxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+Cj4gPj4+IFRoaXMgU2lnbmVkLW9mLWJ5IGNoYWluIGxvb2tzIGR1
YmlvdXMsIHlvdSBhcmUgdGhlIGF1dGhvciBidXQgdGhlIGxhc3QKPiA+Pj4gb25lIGluIHRoZSBj
aGFpbj8KPiA+PiBUaGUgMXN0IFJGQyBpbiBBdWcgMjAxOAo+ID4+IChodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9waXBlcm1haWwva3ZtYXJtLzIwMTgtQXVndXN0LzAzMjQ3OC5odG1sKQo+
ID4+IHNhaWQgdGhpcyB3YXMgYSBnZW5lcmFsaXphdGlvbiBvZiBKYWNvYidzIHBhdGNoCj4gPj4K
PiA+Pgo+ID4+IMKgwqAgW1BBVENIIHY1IDAxLzIzXSBpb21tdTogaW50cm9kdWNlIGJpbmRfcGFz
aWRfdGFibGUgQVBJIGZ1bmN0aW9uCj4gPj4KPiA+Pgo+ID4+IMKgwqAKPiA+PiBodHRwczovL2xp
c3RzLmxpbnV4Zm91bmRhdGlvbi5vcmcvcGlwZXJtYWlsL2lvbW11LzIwMTgtTWF5LzAyNzY0Ny5o
dG1sCj4gPj4KPiA+PiBTbyBpbmRlZWQgSmFjb2Igc2hvdWxkIGJlIHRoZSBhdXRob3IuIEkgZ3Vl
c3MgdGhlIG11bHRpcGxlIHJlYmFzZXMgZ290Cj4gPj4gdGhpcyBldmVudHVhbGx5IHJlcGxhY2Vk
IGF0IHNvbWUgcG9pbnQsIHdoaWNoIGlzIG5vdCBhbiBleGN1c2UuIFBsZWFzZQo+ID4+IGZvcmdp
dmUgbWUgZm9yIHRoYXQuCj4gPj4gTm93IHRoZSBvcmlnaW5hbCBwYXRjaCBhbHJlYWR5IGhhZCB0
aGlzIGxpc3Qgb2YgU29CIHNvIEkgZG9uJ3Qga25vdyBpZiBJCj4gPj4gc2hhbGwgc2ltcGxpZnkg
aXQuCj4gPgo+ID4gQXMgd2UgaGF2ZSBkZWNpZGVkIHRvIG1vdmUgdGhlIG5lc3RlZCBtb2RlIChk
dWFsIHN0YWdlcykgaW1wbGVtZW50YXRpb24KPiA+IG9udG8gdGhlIGRldmVsb3BpbmcgaW9tbXVm
ZCBmcmFtZXdvcmssIHdoYXQncyB0aGUgdmFsdWUgb2YgYWRkaW5nIHRoaXMKPiA+IGludG8gaW9t
bXUgY29yZT8KPiAKPiBUaGUgaW9tbXVfdWFwaV9hdHRhY2hfcGFzaWRfdGFibGUgdWFwaSBzaG91
bGQgZGlzYXBwZWFyIGluZGVlZCBhcyBpdCBpcwo+IGlzIGJvdW5kIHRvIGJlIHJlcGxhY2VkIGJ5
IC9kZXYvaW9tbXUgZmVsbG93IEFQSS4KPiBIb3dldmVyIHVudGlsIEkgY2FuIHJlYmFzZSBvbiAv
ZGV2L2lvbW11IGNvZGUgSSBhbSBvYmxpZ2VkIHRvIGtlZXAgaXQgdG8KPiBtYWludGFpbiB0aGlz
IGludGVncmF0aW9uLCBoZW5jZSB0aGUgUkZDLgoKSW5kZWVkLCB3ZSBhcmUgZ2V0dGluZyBwcmV0
dHkgY2xvc2UgdG8gaGF2aW5nIHRoZSBiYXNlIGlvbW11ZmQgdGhhdCB3ZQpjYW4gc3RhcnQgYWRk
aW5nIHN0dWZmIGxpa2UgdGhpcyBpbnRvLiBNYXliZSBpbiBKYW51YXJ5LCB5b3UgY2FuIGxvb2sK
YXQgc29tZSBwYXJ0cyBvZiB3aGF0IGlzIGV2b2x2aW5nIGhlcmU6CgpodHRwczovL2dpdGh1Yi5j
b20vamd1bnRob3JwZS9saW51eC9jb21taXRzL2lvbW11ZmQKaHR0cHM6Ly9naXRodWIuY29tL0x1
QmFvbHUvaW50ZWwtaW9tbXUvY29tbWl0cy9pb21tdS1kbWEtb3duZXJzaGlwLXYyCmh0dHBzOi8v
Z2l0aHViLmNvbS9sdXhpczE5OTkvaW9tbXVmZC9jb21taXRzL2lvbW11ZmQtdjUuMTYtcmMyCgpG
cm9tIGEgcHJvZ3Jlc3MgcGVyc3BlY3RpdmUgSSB3b3VsZCBsaWtlIHRvIHN0YXJ0IHdpdGggc2lt
cGxlICdwYWdlCnRhYmxlcyBpbiB1c2Vyc3BhY2UnLCBpZSBubyBQQVNJRCBpbiB0aGlzIHN0ZXAu
CgoncGFnZSB0YWJsZXMgaW4gdXNlcnNwYWNlJyBtZWFucyBhbiBpb21tdWZkIGlvY3RsIHRvIGNy
ZWF0ZSBhbgppb21tdV9kb21haW4gd2hlcmUgdGhlIElPTU1VIEhXIGlzIGRpcmVjdGx5IHRyYXZl
c2VyaW5nIGEKZGV2aWNlLXNwZWNpZmljIHBhZ2UgdGFibGUgc3RydWN0dXJlIGluIHVzZXIgc3Bh
Y2UgbWVtb3J5LiBBbGwgdGhlIEhXCnRvZGF5IGltcGxlbWVudHMgdGhpcyBieSB1c2luZyBhbm90
aGVyIGlvbW11X2RvbWFpbiB0byBhbGxvdyB0aGUgSU9NTVUKSFcgRE1BIGFjY2VzcyB0byB1c2Vy
IG1lbW9yeSAtIGllIG5lc3Rpbmcgb3IgbXVsdGktc3RhZ2Ugb3Igd2hhdGV2ZXIuCgpUaGlzIHdv
dWxkIGNvbWUgYWxvbmcgd2l0aCBzb21lIGlvY3RscyB0byBpbnZhbGlkYXRlIHRoZSBJT1RMQi4K
CkknbSBpbWFnaW5pbmcgdGhpcyBzdGVwIGFzIGEgaW9tbXVfZ3JvdXAtPm9wLT5jcmVhdGVfdXNl
cl9kb21haW4oKQpkcml2ZXIgY2FsbGJhY2sgd2hpY2ggd2lsbCBjcmVhdGUgYSBuZXcga2luZCBv
ZiBkb21haW4gd2l0aApkb21haW4tdW5pcXVlIG9wcy4gSWUgbWFwL3VubWFwIHJlbGF0ZWQgc2hv
dWxkIGFsbCBiZSBOVUxMIGFzIHRob3NlCmFyZSBpbXBvc3NpYmxlIG9wZXJhdGlvbnMuCgpGcm9t
IHRoZXJlIHRoZSB1c3VhbCBzdHJ1Y3QgZGV2aWNlIChpZSBSSUQpIGF0dGFjaC9kZXRhdGNoIHN0
dWZmIG5lZWRzCnRvIHRha2UgY2FyZSBvZiByb3V0aW5nIERNQXMgdG8gdGhpcyBpb21tdV9kb21h
aW4uCgpTdGVwIHR3byB3b3VsZCBiZSB0byBhZGQgdGhlIGFiaWxpdHkgZm9yIGFuIGlvbW11ZmQg
dXNpbmcgZHJpdmVyIHRvCnJlcXVlc3QgdGhhdCBhIFJJRCZQQVNJRCBpcyBjb25uZWN0ZWQgdG8g
YW4gaW9tbXVfZG9tYWluLiBUaGlzCmNvbm5lY3Rpb24gY2FuIGJlIHJlcXVlc3RlZCBmb3IgYW55
IGtpbmQgb2YgaW9tbXVfZG9tYWluLCBrZXJuZWwgb3duZWQKb3IgdXNlciBvd25lZC4KCkkgZG9u
J3QgcXVpdGUgaGF2ZSBhbiBhbnN3ZXIgaG93IGV4YWN0bHkgdGhlIFNNTVV2MyB2cyBJbnRlbApk
aWZmZXJlbmNlIGluIFBBU0lEIHJvdXRpbmcgc2hvdWxkIGJlIHJlc29sdmVkLgoKdG8gZ2V0IGFu
c3dlcnMgSSdtIGhvcGluZyB0byBzdGFydCBidWlsZGluZyBzb21lIHNrZXRjaCBSRkNzIGZvciB0
aGVzZQpkaWZmZXJlbnQgdGhpbmdzIG9uIGlvbW11ZmQsIGhvcGVmdWxseSBpbiBKYW51YXJ5LiBJ
J20gbG9va2luZyBhdCB1c2VyCnBhZ2UgdGFibGVzLCBQQVNJRCwgZGlydHkgdHJhY2tpbmcgYW5k
IHVzZXJzcGFjZSBJTyBmYXVsdCBoYW5kbGluZyBhcwp0aGUgbWFpbiBmZWF0dXJlcyBpb21tdWZk
IG11c3QgdGFja2xlLgoKVGhlIHB1cnBvc2Ugb2YgdGhlIHNrZXRjaGVzIHdvdWxkIGJlIHRvIHZh
bGlkYXRlIHRoYXQgdGhlIEhXIGZlYXR1cmVzCndlIHdhbnQgdG8gZXhwb3NlZCBjYW4gd29yayB3
aWxsIHdpdGggdGhlIGNob2ljZXMgdGhlIGJhc2UgaXMgbWFraW5nLgoKSmFzb24KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
