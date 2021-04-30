Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826D5C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 11:50:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01BDD61474
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 11:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01BDD61474
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 976654B43A;
	Fri, 30 Apr 2021 07:50:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IOltoA0EQsoI; Fri, 30 Apr 2021 07:50:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DD54B427;
	Fri, 30 Apr 2021 07:50:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F704B421
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 07:25:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iGZQn+T0r0+y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 07:25:22 -0400 (EDT)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
 (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AC004B3DC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 07:25:22 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzcIZS1dVnqEvQ0Ij6Zn9Q5t/pSJ+0oUtA+2SxalrAaVdRPDSvaN1tZ4TV+5RIuY3St2hu+EC8ABgHcjOPf9f7jOOV/xr5BkXHKPCtmvDB69cnGf/CKIqjm6Oiz85voiUrV45DaVOiBESFY+uquj8G15foCTVBnbC9kTniUD785CD+WWYLZVmfphru2RuzH8lKdPRtCMjtTRkqgM2SpFYz8OKhpVkp5ouGCRNg6U8oSOrF79OncYkLL9NRiVpC4wV1dXmmrrNVljNSmcZJMozpTAbIRDA42soszo9b5n2ctazDgPeXJ3y9h1/ur3NjGDI9qO56ToUG/k7Hhk/m3dbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOg7mWXlvzqSZbaUzktvB1XOlz/XRYoTa/tgPQu2Jos=;
 b=RNhsaheIiw23J61MOZoYLw+RMOe4MU/W9ZC5JMVKWEeIF6HsE89FVZNznTSgZkdWEn3h20ci71CD6tgJ2gYY1YPYnIxeIv5AfDhXhh4p2npMCSDbzeZMmKtZ5ppfPccm8m/3Tn6F2t0CWp9fu7D0ta8pzUJIlLhV+D8Ra2jfPOLRxUlGSOTKBcfYPKh3oAY5I1SRnHVB+Hha0csG1wMD7Fy1Xu7wuYCtnEhgi6Q79iOXuwzuDFKSqYcSnGBwvLfzr1F5JYbDztuKJxBh1rJSn9tVlLdRZnfGA+d5Ez8MaW15o/aAUSOUBh2df7ka/kpuCjQVaPOuLjWovMq9E3y0jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOg7mWXlvzqSZbaUzktvB1XOlz/XRYoTa/tgPQu2Jos=;
 b=Qwcw4/9iwyksx3Q6CB/zn6K4q+XNr1TROuI4cK+qTf/TFG/5L0sMHkMBb7UvWlpHVUnMLWFrfE1dy6lyKnbZzx8oY8R5z7spVN9OukHRdeJTL3arAqmxQRMd0FMVpC+yaM7d9Hr97e+skla1SD99zXMRDPcc6gL+KQyfP5uSZ71CY+wp1S5E7+fFcmOFxCtZB5k3ujmEPwjHZv5noV688YgouauwIo3IEh27tIXv+IZle9epb/CRDhxGG9esiaWxwUliH6EKEWndbkOupDxjqV/gSATdMM7lyj+vTUE9zro4zUzWJ0yf6GiWiIDY5112GKhnxZg0NTFHbjz6y0A+0w==
Received: from DS7PR03CA0247.namprd03.prod.outlook.com (2603:10b6:5:3b3::12)
 by MN2PR12MB3776.namprd12.prod.outlook.com (2603:10b6:208:167::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 11:25:21 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::4b) by DS7PR03CA0247.outlook.office365.com
 (2603:10b6:5:3b3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Fri, 30 Apr 2021 11:25:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Fri, 30 Apr 2021 11:25:20 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 11:25:18 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To: Alex Williamson <alex.williamson@redhat.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
From: Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
Date: Fri, 30 Apr 2021 06:25:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210429134659.321a5c3c@redhat.com>
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c4336d8-031b-43ee-6d92-08d90bcaa3d2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3776:
X-Microsoft-Antispam-PRVS: <MN2PR12MB37768FB4AEAE765F79E44402C75E9@MN2PR12MB3776.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32lF2LvzgbnB/C9WMdTNi0+MIcqDqmvcIt/juyUdkf+jE8ooIZfoSkBJTyH+B2RnwfdFjH1RJ1V9YjJzAMuV2dBUoJRLP/Oybnq/SsvHye/LWBgeoMp7HLDNCcqfGhLBKSDhMYl8ZT5QWc03VNCnFg8u7fmRv/yLuL8xWo0nwhgfKvZ0Q7N74TJU7DQiZ5p0pBWto7m7GuJvqxFmqOGHrVF8fJ3Mq0kMJFfqp59gAvhutGcDzWRhzeA775IHl6wdy1KgoM0w1080bKHmiBSrkv7DFHQen1PuxBCodhBBklI40MYyvpWWhDW3eDCeM/Y3nFFvKQ8nLnjJxDcBdcOq/M07Nyw58WI1WSxBDmYu3SLHfg7DcC253pEBl7C94g7LnIzoAK0+6T6p5tVR7gAbwlq8kfx9FjFS7GMes2+GHD/5dTtD4fMTiG8g6DmXULPbTBclOMF8nKgBJ4t+Eh5nwYHHn1Z/gn93/TWVfJuHVDim0m1TfBCnglJYazBkpvs2G+MtLfdTgYUwh7PU3bYqBGytzt0bxc6Q1AtJlSsJi6RE+J0Dtf+oEX0eg/g/PFR0w5Mf/P/uOi7bzCbScwG0AWyFgI4v6Q3zILRAP4OC0XvYuGMcan9WkvtKURvRUAL6ZpfqLHbfy1sWUST9Jpk3fZvt/4+GTLSBrJ+qeG9i8+0nFHsTvfdgMJ8a+k5XIrm/
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com; CAT:NONE;
 SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(36860700001)(16526019)(36756003)(26005)(47076005)(426003)(82740400003)(36906005)(5660300002)(70586007)(53546011)(107886003)(70206006)(4326008)(31696002)(356005)(16576012)(2616005)(316002)(6666004)(7636003)(8936002)(54906003)(336012)(6916009)(31686004)(82310400003)(478600001)(83380400001)(86362001)(186003)(2906002)(8676002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 11:25:20.8272 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4336d8-031b-43ee-6d92-08d90bcaa3d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a; Ip=[216.228.112.34];
 Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3776
X-Mailman-Approved-At: Fri, 30 Apr 2021 07:50:49 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Vikram Sethi <vsethi@nvidia.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Jason Sequeira <jsequeira@nvidia.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgQWxleAoKT24gNC8yOS8yMSAyOjQ2IFBNLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6Cj4gSWYg
YW4gYWxpZ25tZW50IGZhdWx0IGlzIGZpeGVkIGJ5IGNvbmZpZ3VyaW5nIGEgV0MgbWFwcGluZywg
ZG9lc24ndAo+IHRoYXQgc3VnZ2VzdCB0aGF0IHRoZSBkcml2ZXIgcGVyZm9ybWVkIGFuIHVuYWxp
Z25lZCBhY2Nlc3MgaXRzZWxmIGFuZAo+IGlzIHJlbHlpbmcgb24gd3JpdGUgY29tYmluaW5nIGJ5
IHRoZSBwcm9jZXNzb3IgdG8gY29ycmVjdCB0aGF0IGVycm9yPwo+IFRoYXQncyB3cm9uZy4gIEZp
eCB0aGUgZHJpdmVyIG9yIHBsZWFzZSBvZmZlciBhbm90aGVyIGV4cGxhbmF0aW9uIG9mCj4gaG93
IHRoZSBXQyBtYXBwaW5nIHJlc29sdmVzIHRoaXMuICBJIHN1c3BlY3QgeW91IGNvdWxkIGVuYWJs
ZSB0cmFjaW5nCj4gaW4gUUVNVSwgZGlzYWJsZSBNTUlPIG1tYXBzIG9uIHRoZSB2ZmlvLXBjaSBk
ZXZpY2UgYW5kIGZpbmQgdGhlIGludmFsaWQKPiBhY2Nlc3MuCj4KPj4gV2UndmUgdHdvIGNvbmNl
cm5zIGhlcmU6Cj4+ICAgIC0gUGVyZm9ybWFuY2UgaW1wYWN0cyBmb3IgcGFzcy10aHJvdWdoIGRl
dmljZXMuCj4+ICAgIC0gVGhlIGRlZmluaXRpb24gb2YgaW9yZW1hcF93YygpIGZ1bmN0aW9uIGRv
ZXNuJ3QgbWF0Y2ggdGhlIGhvc3QKPj4ga2VybmVsIG9uIEFSTTY0Cj4gUGVyZm9ybWFuY2UgSSBj
YW4gdW5kZXJzdGFuZCwgYnV0IEkgdGhpbmsgeW91J3JlIGFsc28gdXNpbmcgaXQgdG8gbWFzawo+
IGEgZHJpdmVyIGJ1ZyB3aGljaCBzaG91bGQgYmUgcmVzb2x2ZWQgZmlyc3QuICBUaGFuawoKV2Xi
gJl2ZSBhbHJlYWR5IGluc3RydW1lbnRlZCB0aGUgZHJpdmVyIGNvZGUgYW5kIGZvdW5kIHRoZSBj
b2RlIHBhdGggZm9yIHRoZSB1bmFsaWduZWQKYWNjZXNzZXMuIFdl4oCZbGwgZml4IHRoaXMgaXNz
dWUgaWYgaXTigJlzIG5vdCBmb2xsb3dpbmcgV0Mgc2VtYW50aWNzLgoKRml4aW5nIHRoZSBwZXJm
b3JtYW5jZSBjb25jZXJuIHdpbGwgYmUgdW5kZXIgS1ZNIHN0YWdlLTIgcGFnZS10YWJsZSBjb250
cm9sLiBXZSdyZQpsb29raW5nIGZvciBhIGd1aWRhbmNlL3NvbHV0aW9uIGZvciB1cGRhdGluZyBz
dGFnZS0ywqAgUFRFIGJhc2VkIG9uIFBDSS1CQVIgYXR0cmlidXRlLgoKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
