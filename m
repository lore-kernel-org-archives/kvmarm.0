Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DECC433ED
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 15:08:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 410A36143D
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 15:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 410A36143D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C6C4B44D;
	Fri, 30 Apr 2021 11:08:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hL++nI2qXARB; Fri, 30 Apr 2021 11:08:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 762E84B43C;
	Fri, 30 Apr 2021 11:08:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A824B411
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 10:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oe1GGPUuLzZu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 10:58:26 -0400 (EDT)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C11C4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 10:58:26 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPDdFZgHiqRSuyGZ0ffYJdtCckByV2S00zJ/Cn6e5QbQ7kp7iqOhctyN7VRQStJj8BrHeGdDUcgDHQJsytxQi7I2+Rh5kXvig46PNSJZnUChSr37ml5gG+VAc4ihqXqI60csQpWrWr88OBD72mDx1QCgRr458tCHX3fjCFrNUaarT9br7dQAgiQl3coss/WRzkF9HTeQheDlKbjAtfoar9YRvw01hNT47FBGkqE6Cj1xUTbhBo/drlz8JPYJYx5f/Dcam4geNL5trYXP97GzsPh3RK62EBTRKugOjM5oaVcyl0C2ClU8yugBs0nxyzVhmnSvoEN652eNDdV2niqAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1R+l2CcKmd6vOAMVfDzaF/KTbDH7EQDEkqRh2CopLk=;
 b=f6FgepBsH0xR+XzrUSqaAggXC7ArnrzI5eoe+8NkTBpqG6lxCCCkaDEcbaT6xsso4T9/2Cnqf7wWeko9q5DaD3S3A0u9pOT1yuB+P/SDs1l8GlcRCAUFAgICKSfpcjSBRuPHLWZwOyMlAwY4XjI0yRsGezU1H6IoRAhUQx+Oy4Uj9mmfYDwnt3Pe2JUXAY1KUMfVduyp2IDKAcct3/F2Hfuj547EfDzNm5f+Wkgowf40vfvjzG6n0ZFo0cvI1Ybl5qoUVwoznEvUXdr7hOLDup0G06e/syvf2PZUcO1dYBPMQ7EvkpereX/swXsPQh1TO9pUnjABk5k6akDge3XwWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1R+l2CcKmd6vOAMVfDzaF/KTbDH7EQDEkqRh2CopLk=;
 b=LVqWKycIU3dKA5fzO0gVWuyom3bnixu/V5Lio01ZiHmI7/WhKFTMPc77Oi5kTYa5RENNKjpzoB246n7So6KqeaTDHMm5d7ML6RWdpkbPxBQMbvLaVOzSZL3ZBSPz46rs+4bqjkmfjEVuY1ETyb1oZwpd21eCgT9yD+TGE5s2r3TR2Qwt5KZyr8wBldnAJMVLaI7obR27btTdVBLTRUGAM93/9q0kyrIUy6DIrTkPTEXEcPcxIQJ4PuQHvhFi9hCW/6HFn9p7mOn04N6ZFSeXLC58HqrVisyNYqw0C4AmiqjKk2OnslAfqf09SgIB6QaAGjqe8XD8sAE5J0cWakZidw==
Received: from BN8PR15CA0051.namprd15.prod.outlook.com (2603:10b6:408:80::28)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Fri, 30 Apr
 2021 14:58:25 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::88) by BN8PR15CA0051.outlook.office365.com
 (2603:10b6:408:80::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Fri, 30 Apr 2021 14:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 14:58:24 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 14:58:23 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To: Marc Zyngier <maz@kernel.org>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
From: Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
Date: Fri, 30 Apr 2021 09:58:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87czucngdc.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12373b4a-c977-42be-468a-08d90be867cb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5080461DE98CB94BD7004EF5C75E9@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCDDbXwrInF+MnLksUxtX3x7Kfczd2RBg1eytWnKm1evtms4LtVRXvJVUWwDFyCCxUx22faiEz3+OTq5FYzommeVc8o/d7ZmwcQiHUmBqu429kHrcHmB7I85RHTEkV72zMphop2bCaVSP0+pXVBOrugMjQ13MJq9c9mpQA2qnSL0405RMpooYAq+4bTIpLSLFjh5P/mtQaGsSMTLJHStQebTa9vmrXcRP7XQIZ3OlQHZ4RM53i6wHcsXMgbBKYcul0G5z0+GrcYkcRle83yVIv3sYSf8JG3VzlM5XT7FtFE1pwOg9rL726GAHHBcRC6iG9POY0VSDd7U5iTXRi9dlU4YIDEJFy6ZTUUXFLJROW487kr+pl8Q2Z9T2gtx5mZdEsNHxPlDJpB4y7DkxMGOYtX6QD6IRuSrCwu6TAIAP5EuOB84GNsTuZq/wm5MCyTbFU1xnLUz9Wv9avvqLERo2KxBaFq0JZDCmJfR2viehW/ZhT4qMgPeP8N7D1lj5ZNv0si/TG35bFi1r3FDLtn8+Vn6j23m8dbEVm0gbW4bNCjryEWrzq1OapuhuuNQBSYOx4Myn07GYKhQm2I1zGCGtcrWiM/dmEQoXWHN4OGqRiaTsoQ5YStvCnD1a6U49ZHauH6jWoA2KnYCKMO4NRxGb+lkaiJ58euY7kqJUm1CIJtoKPG5PD6+51JL79YsS2fe
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com; CAT:NONE;
 SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(46966006)(36840700001)(4326008)(36860700001)(2906002)(6666004)(426003)(47076005)(36756003)(2616005)(336012)(16526019)(5660300002)(82310400003)(107886003)(478600001)(6916009)(26005)(31686004)(186003)(70586007)(54906003)(70206006)(316002)(83380400001)(8936002)(356005)(31696002)(8676002)(53546011)(7636003)(86362001)(82740400003)(36906005)(16576012)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 14:58:24.9470 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12373b4a-c977-42be-468a-08d90be867cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a; Ip=[216.228.112.34];
 Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
X-Mailman-Approved-At: Fri, 30 Apr 2021 11:08:25 -0400
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Vikram Sethi <vsethi@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Sequeira <jsequeira@nvidia.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDQvMzAvMjEgNjo0NyBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Cj4+Pj4g
V2UndmUgdHdvIGNvbmNlcm5zIGhlcmU6Cj4+Pj4gICAgLSBQZXJmb3JtYW5jZSBpbXBhY3RzIGZv
ciBwYXNzLXRocm91Z2ggZGV2aWNlcy4KPj4+PiAgICAtIFRoZSBkZWZpbml0aW9uIG9mIGlvcmVt
YXBfd2MoKSBmdW5jdGlvbiBkb2Vzbid0IG1hdGNoIHRoZSBob3N0Cj4+Pj4ga2VybmVsIG9uIEFS
TTY0Cj4+PiBQZXJmb3JtYW5jZSBJIGNhbiB1bmRlcnN0YW5kLCBidXQgSSB0aGluayB5b3UncmUg
YWxzbyB1c2luZyBpdCB0byBtYXNrCj4+PiBhIGRyaXZlciBidWcgd2hpY2ggc2hvdWxkIGJlIHJl
c29sdmVkIGZpcnN0LiAgVGhhbmsKPj4gV2XigJl2ZSBhbHJlYWR5IGluc3RydW1lbnRlZCB0aGUg
ZHJpdmVyIGNvZGUgYW5kIGZvdW5kIHRoZSBjb2RlIHBhdGgKPj4gZm9yIHRoZSB1bmFsaWduZWQg
YWNjZXNzZXMuIFdl4oCZbGwgZml4IHRoaXMgaXNzdWUgaWYgaXTigJlzIG5vdAo+PiBmb2xsb3dp
bmcgV0Mgc2VtYW50aWNzLgo+Pgo+PiBGaXhpbmcgdGhlIHBlcmZvcm1hbmNlIGNvbmNlcm4gd2ls
bCBiZSB1bmRlciBLVk0gc3RhZ2UtMiBwYWdlLXRhYmxlCj4+IGNvbnRyb2wuIFdlJ3JlIGxvb2tp
bmcgZm9yIGEgZ3VpZGFuY2Uvc29sdXRpb24gZm9yIHVwZGF0aW5nIHN0YWdlLTIKPj4gUFRFIGJh
c2VkIG9uIFBDSS1CQVIgYXR0cmlidXRlLgo+IEJlZm9yZSB3ZSBzdGFydCBkaXNjdXNzaW5nIHRo
ZSAqaG93KiwgSSdkIGxpa2UgdG8gY2xlYXJseSB1bmRlcnN0YW5kCj4gd2hhdCAqYXJtNjQqIG1l
bW9yeSBhdHRyaWJ1dGVzIHlvdSBhcmUgcmVseWluZyBvbi4gV2UgYWxyZWFkeSBoYXZlCj4gZXN0
YWJsaXNoZWQgdGhhdCB0aGUgdW5hbGlnbmVkIGFjY2VzcyB3YXMgYSBidWcsIHdoaWNoIHdhcyB0
aGUgYmlnZ2VzdAo+IGFyZ3VtZW50IGluIGZhdm91ciBvZiBOT1JNQUxfTkMuIFdoYXQgYXJlIHRo
ZSBvdGhlciByZXF1aXJlbWVudHM/ClNvcnJ5LCBteSBlYXJsaWVyIHJlc3BvbnNlIHdhcyBub3Qg
Y29tcGxldGUuLi4KCkFSTXY4IGFyY2hpdGVjdHVyZSBoYXMgdHdvIGZlYXR1cmVzIEdhdGhlcmlu
ZyBhbmQgUmVvcmRlciB0cmFuc2FjdGlvbnMsIHZlcnkKaW1wb3J0YW50IGZyb20gYSBwZXJmb3Jt
YW5jZSBwb2ludCBvZiB2aWV3LiBTbWFsbCBpbmxpbmUgcGFja2V0cyBmb3IgTklDIGNhcmRzCmFu
ZCBhY2Nlc3NlcyB0byBHUFUncyBmcmFtZSBidWZmZXIgYXJlIENQVS1ib3VuZCBvcGVyYXRpb25z
LiBXZSB3YW50IHRvIHRha2UKYWR2YW50YWdlcyBvZiBHUkUgZmVhdHVyZXMgdG8gYWNoaWV2ZSBo
aWdoZXIgcGVyZm9ybWFuY2UuCgpCb3RoIHRoZXNlIGZlYXR1cmVzIGFyZSBkaXNhYmxlZCBmb3Ig
cHJlZmV0Y2hhYmxlIEJBUnMgaW4gVk0gYmVjYXVzZSBtZW1vcnktdHlwZQpNVF9ERVZJQ0Vfbkdu
UkUgZW5mb3JjZWQgaW4gc3RhZ2UtMi4KPiBUaGFua3MsCj4KPiAgICAgICAgIE0uCj4KPiAtLQo+
IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5vdCBwb3NzaWJs
ZS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
