Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D82C43462
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 20:01:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC3C4613DA
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 20:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC3C4613DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4771E4B39B;
	Thu, 29 Apr 2021 16:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQDtE71dPjq4; Thu, 29 Apr 2021 16:01:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C04C04B3A9;
	Thu, 29 Apr 2021 16:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE894B2F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 15:14:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2H-EpRbhXsqS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 15:14:58 -0400 (EDT)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D3C14B2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 15:14:58 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne39nzxnJMPhErSlFk23QtilQ4uJk4ycxqN3VYr3irm6rjV+3QshkrYA3kLiCtyZUdDpOEXhO0GxjQMCVHVpUeLmI9u7g7fW+C0kVng7VtWT42fOEKmVHqeYH22qAPNXicEhJNMlNbj3hBYg31KMj+V94xWnbb3nA4v76wM1nEUMAHOuL/NuP/nfsjG9jtAaItjxvzo8ZeK3r3KnAO13nVEhzxA8z38/A9LmFIqM1vdFV9lXJ6LxEaSP0nlMgSVOQunJ0yA1kmjyP6HirtwFeA6V7i5z5FwG9KqrrclLgLwy+YbLqKmOGk9clXs0N1R/vYu6DOoaRyrc+4dzHHR9GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0r6l3fZwjf4ZW7F4orjcbw5rDBOLI8/QO5Zgiblx/Y=;
 b=HRpuDo9k9tNVMOt5POFEb18txI0o8YUBk7GUbSXseqlZEGQ4M7NuLG4mE2OImh+2An41v6/A/Y2X9BpHg6Y8kULzqwq9MFtklXQYmgueITpXjzIFFAZiG1AqY+UjKL9VWNYkH+vuow6dAFlco+103fkpKU2vvL3CFe2WgWfN7lzUS5o1t1DZ9R0xStIjvhjwhVvgBct5N6zgzUNvwI/Lz3s5IWOEGVBYD1gUGeFdPtPcwIbVoLE/O1sqVXk2M0FxEaEHRrnZVgtb3X7A0ICaMdFdcNJyzQGPkrGLSxUCJPpGVFZAavthGgMhgdf+OPftiRh3HMMwwDkvy0SrWLuOvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0r6l3fZwjf4ZW7F4orjcbw5rDBOLI8/QO5Zgiblx/Y=;
 b=SbOMgDLjw/55wg3AVnm0BEFwZJFaZaPe/jzJQpdZOJkaItCfM1OanrkykAf6in69kKCb/tbe9FxjvXp2q9ONp2fUoZv/QDX6OU3+WmSX6D9oYqli/9pf0UX+1fOPkcCvgkKHsjV+DTgURvhPPM5+VuzEiPDD6a9SjcGhEHeVTUf4V3lI5B8VOPZ+uhmx5H6r7k6ljZufsNcRh0sYzsYRu2Wjj80oVrBG/ECTafmlq9YSPQvPwmj8QJnwF1PSSbO+tKfVLEmPdT+Cg/diTHxqYIC2Iw946NzNufjXrDm4UHKjCXgRxwjvaiLx/vVLH/dbIz7qjC7WldZiOy+bKsbIiw==
Received: from BN9PR03CA0965.namprd03.prod.outlook.com (2603:10b6:408:109::10)
 by MWHPR12MB1471.namprd12.prod.outlook.com (2603:10b6:301:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 19:14:57 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::3c) by BN9PR03CA0965.outlook.office365.com
 (2603:10b6:408:109::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Thu, 29 Apr 2021 19:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 19:14:56 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 19:14:54 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To: Alex Williamson <alex.williamson@redhat.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
From: Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
Date: Thu, 29 Apr 2021 14:14:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210429122840.4f98f78e@redhat.com>
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b77357cf-9db4-4805-c185-08d90b431356
X-MS-TrafficTypeDiagnostic: MWHPR12MB1471:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14718F479ABC74D36BE4D188C75F9@MWHPR12MB1471.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bguPNV34ywz9UqJl5YLzH1FbSZKdc9+66BKkg+2WhO44Ln/E3RNRtbYUrsKfb3yPHEzBYsM7U7D1WCRUI4QUdO9EwRO4U3ScquPA9TAOIROs4l3qHkGUWQBVnQFIWNgN5fxh7sB3SrDJqSHK0YfLS/z2KtuB6SbPwVqBKEQ2nhrP6KUno9Q2dsUW6FK27EIRk9oLvmshAADxGKxqoHlcRrKgvKDYZb0rKkES8KIm8rXhzHg13AWUmQwi/GEJ9NoYFjhjlTCvYCPiu+MYl7kbfjc2hCgwXGN4wFNk1ATGtpE1ugW4JNkv6xlTpCzTnIOAuEoErCsq3fcdSJCWahJ+dVETmtlWsHBUIqtbcOTC472gS4ykTkN4lom4C1KmnIQFEaoG+USB8C1ZVO7E20djdZvBqkUdShBIKSdmnS+9kpE8ym1e9iKL0nzuq3v1gR2tLW2lnDX8bEYwAsyOoWVoMcj5v4j8pA4i2fVQV/lYY+wNP5IYma5x6pS5lWw+vtjxPNvQMTVamrTG0Ob+MpZ6SbuHZRalwEgMnANz8GZIS3Py+2fIx4EmDCZnNDbutxKVtDGAC7/vVFEqgaWUWAPhB87WlBbFqf87u/JD+WTsSm9rf+YA+FL1b+K2GugpdB94GVo/TvUbnfIIHGPoBRJm3dKUChIK7RlAb9DGSO+3WS8lCX4QxlllB7AZvlfUfPGcQy4+mh+TDGfqfVbadwp51g==
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com; CAT:NONE;
 SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966006)(36840700001)(7636003)(31696002)(107886003)(36756003)(36906005)(70586007)(426003)(478600001)(316002)(70206006)(6916009)(36860700001)(2906002)(86362001)(26005)(336012)(53546011)(54906003)(8936002)(82310400003)(5660300002)(6666004)(83380400001)(356005)(31686004)(186003)(16576012)(82740400003)(47076005)(8676002)(16526019)(4326008)(2616005)(3714002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 19:14:56.3023 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b77357cf-9db4-4805-c185-08d90b431356
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a; Ip=[216.228.112.34];
 Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1471
X-Mailman-Approved-At: Thu, 29 Apr 2021 16:01:37 -0400
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

VGhhbmtzIEFsZXggZm9yIHF1aWNrIHJlcGx5LgoKT24gNC8yOS8yMSAxOjI4IFBNLCBBbGV4IFdp
bGxpYW1zb24gd3JvdGU6Cj4gSWYgdGhpcyB3ZXJlIGEgdmFsaWQgdGhpbmcgdG8gZG8sIGl0IHNo
b3VsZCBiZSBkb25lIGZvciBhbGwKPiBhcmNoaXRlY3R1cmVzLCBub3QganVzdCBBUk02NC4gIEhv
d2V2ZXIsIGEgcHJlZmV0Y2hhYmxlIHJhbmdlIG9ubHkKPiBuZWNlc3NhcmlseSBhbGxvd3MgbWVy
Z2VkIHdyaXRlcywgd2hpY2ggc2VlbXMgbGlrZSBhIHN1YnNldCBvZiB0aGUKPiBzZW1hbnRpY3Mg
aW1wbGllZCBieSBhIFdDIGF0dHJpYnV0ZSwgdGhlcmVmb3JlIHRoaXMgZG9lc24ndCBzZWVtCj4g
dW5pdmVyc2FsbHkgdmFsaWQuCj4KPiBJJ20gYWxzbyBhIGJpdCBjb25mdXNlZCBieSB5b3VyIHBy
b2JsZW0gc3RhdGVtZW50IHRoYXQgaW5kaWNhdGVzIHRoYXQKPiB3aXRob3V0IFdDIHlvdSdyZSBz
ZWVpbmcgdW5hbGlnbmVkIGFjY2Vzc2VzLCBkb2VzIHRoaXMgc3VnZ2VzdCB0aGF0Cj4geW91ciBk
cml2ZXIgaXMgYWN0dWFsbHkgcmVseWluZyBvbiBXQyBzZW1hbnRpY3MgdG8gcGVyZm9ybSBtZXJn
aW5nIHRvCj4gYWNoaWV2ZSBhbGlnbm1lbnQ/ICBUaGF0IHNlZW1zIHJhdGhlciBsaWtlIGEgZHJp
dmVyIGJ1ZywgSSdkIGV4cGVjdCBVQwo+IHZzIFdDIGlzIGxhcmdlbHkgYSBkaWZmZXJlbmNlIGlu
IHBlcmZvcm1hbmNlLCBub3QgYSBtZWFucyB0byBlbmZvcmNlCj4gcHJvcGVyIGRyaXZlciBhY2Nl
c3MgcGF0dGVybnMuICBQZXIgdGhlIFBDSSBzcGVjLCB0aGUgYnJpZGdlIGl0c2VsZiBjYW4KPiBt
ZXJnZSB3cml0ZXMgdG8gcHJlZmV0Y2hhYmxlIGFyZWFzLCBwcmVzdW1hYmx5IHJlZ2FyZGxlc3Mg
b2YgdGhpcwo+IHByb2Nlc3NvciBhdHRyaWJ1dGUsIHBlcmhhcHMgdGhhdCdzIHRoZSBmZWF0dXJl
IHlvdXIgZHJpdmVyIGlzIHJlbHlpbmcKPiBvbiB0aGF0IG1pZ2h0IGJlIG1pc3NpbmcgaGVyZS4g
IFRoYW5rcywKVGhlIGRyaXZlciB1c2VzIFdDIHNlbWFudGljcywgSXQncyBtYXBwaW5nIFBDSSBw
cmVmZXRjaGFibGUgQkFSUyB1c2luZyBpb3JlbWFwX3djKCkuwqAgV2UgZG9uJ3Qgc2VlIGFueSBp
c3N1ZSBmb3IgeDg2IGFyY2hpdGVjdHVyZSzCoCBkcml2ZXIgd29ya3MgZmluZSBpbiB0aGUgaG9z
dCBhbmQgZ3Vlc3Qga2VybmVsLiBUaGUgc2FtZSBkcml2ZXIgd29ya3Mgb24gQVJNNjQga2VybmVs
IGJ1dCBjcmFzaGVzIGluc2lkZSBWTS4KR1BVIGRyaXZlciB1c2VzIHRoZSBhcmNoaXRlY3R1cmUg
YWdub3N0aWMgZnVuY3Rpb24gaW9yZW1hcF93YygpIGxpa2Ugb3RoZXIgZHJpdmVycy4gVGhpcyBs
aW1pdGF0aW9uIGFwcGxpZXMgdG8gYWxsIHRoZSBkcml2ZXJzIGlmIHRoZXkgdXNlIFdDIG1lbW9y
eSBhbmQgZm9sbG93IEFSTTY0IE5PUk1BTC1OQyBhY2Nlc3MgcnVsZXMuCgpPbiBBUk02NCwgaW9y
ZW1hcF93YygpIGlzIG1hcHBlZCB0byBub24tY2FjaGVhYmxlIG1lbW9yeS10eXBlLCBubyBzaWRl
IGVmZmVjdHMgb24gcmVhZHMgYW5kIHVuYWxpZ25lZCBhY2Nlc3NlcyBhcmUgYWxsb3dlZCBhcyBw
ZXIgQVJNLUFSTSBhcmNoaXRlY3R1cmUuIFRoZSBkcml2ZXIgYmVoYXZpb3IgaXMgZGlmZmVyZW50
IGluIGhvc3QgdnMgZ3Vlc3Qgb24gQVJNNjQuwqAKCkFSTSBDUFUgZ2VuZXJhdGluZyBhbGlnbm1l
bnQgZmF1bHRzIGJlZm9yZSB0cmFuc2FjdGlvbiByZWFjaGVzIHRoZSBQQ0ktUkMvc3dpdGNoL2Vu
ZC1wb2ludC1kZXZpY2UuCgpXZSd2ZSB0d28gY29uY2VybnMgaGVyZToKwqDCoCAtIFBlcmZvcm1h
bmNlIGltcGFjdHMgZm9yIHBhc3MtdGhyb3VnaCBkZXZpY2VzLgrCoMKgIC0gVGhlIGRlZmluaXRp
b24gb2YgaW9yZW1hcF93YygpIGZ1bmN0aW9uIGRvZXNuJ3QgbWF0Y2ggdGhlIGhvc3Qga2VybmVs
IG9uIEFSTTY0CgrCoAo+IEFsZXgKPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
