Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1C8C433B4
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 12:12:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC783611C2
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 12:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC783611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03CE14B470;
	Mon,  3 May 2021 08:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id slK31uE8q4ht; Mon,  3 May 2021 08:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5504B47F;
	Mon,  3 May 2021 08:12:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D11934B42C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 08:08:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8q3BWViEbW4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 08:08:20 -0400 (EDT)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA0514B377
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 08:08:20 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfivL4a7ZjuKmNNJfAmGAXvVbryz/0NIuduouqFHcJx8qRmjIkhG9WkksmIomvw/TUJCq7SylG1nSN3tGIklmuR+PtvXMPco0hf/Tmy3Vz042F9OhbPD3ryx1odYbXlkdFWwuip1yAPnm8U2lkXrwf0rjFHUCdDTBM6Oi9LafiXa5Zhh5WH/2AJBdggTzqGPU5+19tzKSVJcvrgr9xtZRhPJYQta6kyKigHuXjivVTa3lAbX5E6Bpp7Ua+Jt+m2FbWI5Ksm3HOMvZ9ST+MKTSpnQjKmV0zBpgWQKGuXV3nzSWk1hrbWd967r6UmFx01M948vUltNQ0ee/PdnzEYCUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Okk0d8HxcNPcwhwIKMcT2nO57+6T0VR68IWu0Ahzh5Q=;
 b=ODaYepuppYCImSntXTth/4AriJqOUU2bg3RhsaxXAWEM38SLuyNwjk7Enr1+PlVpCuex3G6iTcG1uLv4ce0fTIXhUEIzkHtRLIFWP+kUNSpxJ++COKiezM3frJA4N5OU9zLgRHE5OEbtfbHuI9NXZl1DtHq33qPeStnAGpH2BdORSeTlOvOpsbRRlHkwoQI23vFfXHtSVks3ffZhGEbriTdeFn9BJ2rZU8ORBxpSv91Tu5t4NmC3vhl9t+zwMglzWobMBhguHgWFBP+c+RSyMNWARcE6j03DgGHQI0CJkJ5fDsHcpTKNiQGXZ1MW/usSCpi+sv/UEeC7T8+xPZSWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Okk0d8HxcNPcwhwIKMcT2nO57+6T0VR68IWu0Ahzh5Q=;
 b=fZpCAzRpklcMd9lIsuVHoJ+tEnO3ifDSZkOvGmdpG4FMKtJQdvcoPBRZM5zmQVny82TtiPvAPITuCcQulkdUa2k2z6ZYkf4X5cYQtDNqHzdmp6g6Zbo2l63mQpb6ZI8GgDX5YIEdDvBibpHgb61zhx3M19GvO6oISDDuZPSYjApgG4LOZuiWUayRDKTCV/2csvroTT2I3wBgJ4+J6z29YVza/XLYFfLPKhvWWsqX2yhwO+SEnDpvPvSyuinGCJjp+WKZlWjazwqtNAKV/Z6zg/MHuTM71D/Gbss8pB77yUZC5abcVw2PRl4mKRe+MNIEs8eRF2UnBoJMABnXrHuBdA==
Received: from BN6PR22CA0040.namprd22.prod.outlook.com (2603:10b6:404:37::26)
 by DM6PR12MB2828.namprd12.prod.outlook.com (2603:10b6:5:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Mon, 3 May
 2021 12:08:18 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::24) by BN6PR22CA0040.outlook.office365.com
 (2603:10b6:404:37::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Mon, 3 May 2021 12:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Mon, 3 May 2021 12:08:18 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 May
 2021 12:08:17 +0000
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
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <49e26646-9f05-ccb8-f5c1-73a92ab79972@nvidia.com>
 <87czu8uowe.wl-maz@kernel.org>
From: Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <22e592c5-58e5-5456-311d-3d23303a91ac@nvidia.com>
Date: Mon, 3 May 2021 07:08:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87czu8uowe.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba67fa3-f649-435e-bb63-08d90e2c2381
X-MS-TrafficTypeDiagnostic: DM6PR12MB2828:
X-Microsoft-Antispam-PRVS: <DM6PR12MB282811F74097E33559311A95C75B9@DM6PR12MB2828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrGIY+u26JS0doy5wyCBq7WqD+rIMdrb1qw0A5Y+ZcMAn/rQp6gjY/OLEKTqBX7PkjQiOqeFoZRYkV0PQZ+2ju06NbhKAjmTapiVbDB2lOzOPY3sxkH7Tpu12GWPJ+KI+p57aFpDigvaFaqCwA6p7wBrLJnjUtUTmm6MDJ0NJ+j1E7VUQWa9jeAOu9+xkhC+HWDbVXKOE/TLdtd+uxm6RGCPHkAM1bm1vIM2d56n/HgjSGNQ0d6zZzGLEks57xQAzEWTFTCWmMRwXp+gcSDy+3nF4L24qLi54TwN8OSvGtXq3zZ23+LFbdxhRl7RK5XPWHe7AMSO3TYoRdP1T/BK3VQ6Mnjm3AkNVgaezldjQ1AWSfvumZUgZusGff0JGDS6E+0KMNt7fj6Nj3AfXMm9ARkbT/vcBharAErm/tayyjpqgl/v642XqqdtguDZyggRl1KVIEsGDbg5qjNt5sgurl4v4woGIR4saJ88koezS5NeS4WiNqpc6Q829iYM12Ai+/yiIPADdFS0OUF5/ioXAxXpFYdl3s7vzBO06vsaGnzFXOW9pIdQX5QezNKGyeB1aDxiAmcsbyZ1Y7iKyH5ez1cUgr+lBCWpYDIBmmjx8zE1yGYbnnBtjfq04llCcZQniI1wD7tvOz3kLkJM++H/LJ9xHGPq0wpbSOZ813VaQGM1I0IJoTW12JiYa5i6aqPw
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com; CAT:NONE;
 SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(16526019)(186003)(31686004)(7636003)(2616005)(86362001)(2906002)(4326008)(356005)(53546011)(16576012)(316002)(82740400003)(36756003)(26005)(82310400003)(426003)(4744005)(8676002)(107886003)(54906003)(36906005)(336012)(6916009)(5660300002)(70206006)(36860700001)(478600001)(8936002)(31696002)(70586007)(47076005)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 12:08:18.4931 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba67fa3-f649-435e-bb63-08d90e2c2381
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a; Ip=[216.228.112.34];
 Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2828
X-Mailman-Approved-At: Mon, 03 May 2021 08:12:21 -0400
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Vikram Sethi <vsethi@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Sequeira <jsequeira@nvidia.com>, Will Deacon <will@kernel.org>,
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

Hi Marc,

On 5/3/21 4:50 AM, Marc Zyngier wrote:
> You are mixing two things: what Linux/arm64 gives to kernel drivers,
> and what KVM, as an implementation of the ARMv8 architecture, gives to
> virtual machines. There is zero reason for the two to match if there
> is no definition of what we need to provide.
Suggestion here is memory-types PROT_NORMAL_NC and PROT_DEVICE_nGnRE
are applicable to braemetal only and don't use for device memory inside VM.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
