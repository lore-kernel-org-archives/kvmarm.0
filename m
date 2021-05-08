Return-Path: <SRS0=z9tc=KD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80135C433ED
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 18:45:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C570B6128C
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 18:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C570B6128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FCF14B1D8;
	Sat,  8 May 2021 14:45:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MWaIiVxuxSjV; Sat,  8 May 2021 14:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA6BE4B2EE;
	Sat,  8 May 2021 14:44:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E79E4B3E3
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 May 2021 12:33:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TSk0htGcErsf for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 May 2021 12:33:20 -0400 (EDT)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DDDD4A588
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 May 2021 12:33:20 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDeYybri3RIGGkm7yE5rKP5mw1IEKhyt7HcpaiAuKh0nalH0mhx8x5E1yVqhNO9oSJd45bCaWGO/+z2Z8L5T+DTWM8PsJwyXV/iQ7601nsmSouUBN92DKi7Oj02cy/oD1oBsS/Joa+rOm0iOE15RLfDT6edUDlgocEeX+eJq2a33dDZ1KeBdQeH9t3aEv9Dzsd22kJqzI5vIlQmBVIU3Q11jFiaA86Rum1ggNr/SeFb/GjdWP5+6cCSqf5Rtrioix++0TGFzm5YiqJlc1palk69LhvTvXpeJYIs2uu6uYD2KhwmhMmjz6utqAwSPgd/6f+Px1fFomL/fuqLw10FYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOX5jZLLuH/VgnoT2Hp+vaQgRDiX23wl94X5U30XQg=;
 b=W5kVQCLbmGlPpW1VayXZnamClInL67LYipDtzLUR8+Z/LS+UHxw/sFVj9l6E8hpRwu+Sr0769xrbbSqTrxRHDJyZCDIJN40yQSVu3rDXWVF+Q+M74hMKZqUBaiRtcT+OKwMSDK+w2gZSYktYlXuDpjuG/38i7whghCuFtWKWfFbIlAP6sicgOXOfjhv9mnhVnOUEJnEXIfpQ6sCFjktUHf6VUc4nrUSil/ybn8dJXr6auoIG9DTVlPn6Q3njbko8HBOAwJP1YTN8ptrGSBaLZ42yz8MjhxEVKJ64AoKbvRoXxM44sfQ/ATy2RB50vhI4ME6c+1ClasA5JirPLueqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=xs4all.nl smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOX5jZLLuH/VgnoT2Hp+vaQgRDiX23wl94X5U30XQg=;
 b=Eb1Ygo1/mkBc55DbQPHRNpDzgdheLi6Kzyzi3KcKlpSHKcOp25CtF6E36doNF6K5LbQaub/RR9oamfmc83Jvo60Gmyms7yt7PyNZAhvJEm/485fprCjcZkL18rS4eXkv0HkXJgh1t9qL7o1yS2zEgXYRfzDSnNoQZoBYH18qzg6Xtaa98rqtnrGyBatQ/Yg5ORSjHtEonNCSXFAfdViTGF8rKlZJ8lH4p/vK7ETCtJeEJnM0ma2CSvYeuH9uOjmtuV0J2mDvA5ocgrHnn/jOC0c3QmskwHMOTYkfpMzJnmJP8c6vka7lRisIUKfMnNDD4oIvwvHCxzDuNpGph43KFg==
Received: from BN0PR04CA0067.namprd04.prod.outlook.com (2603:10b6:408:ea::12)
 by DM6PR12MB3705.namprd12.prod.outlook.com (2603:10b6:5:14a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Sat, 8 May
 2021 16:33:18 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::a2) by BN0PR04CA0067.outlook.office365.com
 (2603:10b6:408:ea::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Sat, 8 May 2021 16:33:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; xs4all.nl; dkim=none (message not signed)
 header.d=none;xs4all.nl; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Sat, 8 May 2021 16:33:18 +0000
Received: from [10.20.23.38] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 8 May
 2021 16:33:15 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org> <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210504083005.GA12290@willie-the-truck> <20210505180228.GA3874@arm.com>
From: Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <273ba1c2-dfe6-7dc1-3e40-03398e82469b@nvidia.com>
Date: Sat, 8 May 2021 11:33:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505180228.GA3874@arm.com>
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1933258b-34ed-4da5-1154-08d9123efcb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3705:
X-Microsoft-Antispam-PRVS: <DM6PR12MB370599BE314CAC5594526251C7569@DM6PR12MB3705.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WvbMLr67Mje535X8RHWmEi0f+6+vuK6ydDHE9c1sGCE4gYk1wqln8zzeNwDP5/5v1lDo4h7dBkymH+O21p9S/Cc38XjpMpkpV4DzFdDkW3kmzCCEwxwvQPAFonUAG6rqw+Ov8giqpxOc+TEO/uhA3y8PHlFfiW0q1WjupSaFoKnpPPeljKTTl/cWnMYSNcJF8HFa4MvAbr2AuQtNy3eFTYEg9BhMQYvascZYT4mMG01JTu9/RihJLVJZQz2wS9wclr5xMxq5PC1CjW+Gd+aeXf1XPMT2Sw6El3J2QAReUgXV9EmM8nYP2+N8mxTRvYDt2CCPs3vI8jX5ZLKYRU2um3qGiPZf51CB++VuWpFqWMI7oGXjDI9wyeKXzdL1USNKDO8dLsvvCe7G0XAsubIVrgaSnwJ8x0+KMWAyDfzbZpYwx32IuZrfKL316p5oIzSGB6422lXPDJUJr/AA6DdhVPZtD0p23MgbA58r2aSfRHCUVISj2tbU6dlNF6bWvHzh2PEMGMyhVjLMTcFHW9yXCMI1SGdNAMZnONr/DbyDK4H9aQPVXc7AXWDOxkn/0mgNTFWtPDoU9lxRut6OlLhYu7zYXZrk6ZGL41emV6MThJtI/NkrjEl0qnbtrYG8PNOxUr21UgIyDMuwGezZxni+N5X/fahjCAUq1TnnyEyLlUVzQJ9WXz7yQ+PcLRPmSaOb
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com; CAT:NONE;
 SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(53546011)(16576012)(26005)(54906003)(36860700001)(31696002)(86362001)(8676002)(31686004)(316002)(110136005)(4326008)(82310400003)(107886003)(7416002)(8936002)(82740400003)(36906005)(478600001)(36756003)(356005)(7636003)(83380400001)(70206006)(2616005)(70586007)(2906002)(47076005)(16526019)(426003)(6666004)(186003)(336012)(5660300002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2021 16:33:18.4566 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1933258b-34ed-4da5-1154-08d9123efcb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a; Ip=[216.228.112.34];
 Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3705
X-Mailman-Approved-At: Sat, 08 May 2021 14:44:57 -0400
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Vikram Sethi <vsethi@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Sequeira <jsequeira@nvidia.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Mark Kettenis <mark.kettenis@xs4all.nl>
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

SGkgTWFyYywKCk9uIDUvNS8yMSAxOjAyIFBNLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6Cj4+PiBX
aWxsL0NhdGFsaW4sIHBlcmhhcHMgeW91IGNvdWxkIGV4cGxhaW4geW91ciB0aG91Z2h0IHByb2Nl
c3Mgb24gd2h5IHlvdSBjaG9zZQo+Pj4gTm9ybWFsIE5DIGZvciBpb3JlbWFwX3djIG9uIHRoZSBh
cm12OCBsaW51eCBwb3J0IGluc3RlYWQgb2YgRGV2aWNlIEdSRSBvciBvdGhlcgo+Pj4gRGV2aWNl
IEd4eC4KPj4gSSB0aGluayBhIGNvbWJpbmF0aW9uIG9mOiBjb21wYXRpYmlsaXR5IHdpdGggMzIt
Yml0IEFybSwgdGhlIG5lZWQgdG8KPj4gc3VwcG9ydCB1bmFsaWduZWQgYWNjZXNzZXMgYW5kIHRo
ZSBwb3RlbnRpYWwgZm9yIGhpZ2hlciBwZXJmb3JtYW5jZS4KPiBJSVJDIHRoZSBfd2Mgc3VmZml4
IGFsc28gbWF0Y2hlcyB0aGUgcGdwcm90X3dyaXRlY29tYmluZSgpIHVzZWQgYnkgc29tZQo+IGRy
aXZlcnMgdG8gbWFwIGEgdmlkZW8gZnJhbWVidWZmZXIgaW50byB1c2VyIHNwYWNlLiBBY2Nlc3Nl
cyB0byB0aGUKPiBmcmFtZWJ1ZmZlciBhcmUgbm90IGd1YXJhbnRlZWQgdG8gYmUgYWxpZ25lZCAo
bWVtc2V0L21lbWNweSBkb24ndCBlbnN1cmUKPiBhbGlnbm1lbnQgb24gYXJtNjQgYW5kIHRoZSB1
c2VyIGRvZXNuJ3QgaGF2ZSBhIG1lbXNldF9pbyBvciBtZW1jcHlfdG9pbykuCj4KPj4gRnVydGhl
cm1vcmUsIGlvcmVtYXAoKSBhbHJlYWR5IGdpdmVzIHlvdSBhIERldmljZSBtZW1vcnkgdHlwZSwg
YW5kIHdlJ3JlCj4+IHRpZ2h0IG9uIE1BSVIgc3BhY2UuCj4gV2UgaGF2ZSBNVF9ERVZJQ0VfR1JF
IGN1cnJlbnRseSByZXNlcnZlZCB0aG91Z2ggbm8gaW4ta2VybmVsIHVzZXIsIHdlCj4gbWlnaHQg
YXMgd2VsbCByZW1vdmUgaXQuCkBNYXJjLCBDb3VsZCB5b3UgcHJvdmlkZSB5b3VyIHRob3VnaHRz
L2d1aWRhbmNlIGZvciB0aGUgbmV4dCBzdGVwPyBUaGUKcHJvcG9zYWwgb2YgZ2V0dGluZyBoaW50
cyBmb3IgcHJlZmV0Y2hhYmxlIHJlZ2lvbnMgZnJvbSBWRklPL1FFTVUgaXMgbm90CnJlY29tbWVu
ZGVkLCBUaGUgb25seSBvcHRpb24gbGVmdCBpcyB0byBpbXBsZW1lbnQgQVJNNjQgZGVwZW5kZW50
IGxvZ2ljCmluIEtWTS4KCk9wdGlvbi0xOiBJIHRoaW5rIHdlIGNvdWxkIHRha2UgYWR2YW50YWdl
IG9mIHN0YWdlLTEvMiBjb21iaW5pbmcgcnVsZXMgdG8KYWxsb3cgTk9STUFMX05DIG1lbW9yeS10
eXBlIGZvciBkZXZpY2UgbWVtb3J5IGluIFZNLiBBbHdheXMgbWFwCmRldmljZSBtZW1vcnkgYXQg
c3RhZ2UtMiBhcyBOT1JNQUwtTkMgYW5kIHRydXN0IFZNJ3Mgc3RhZ2UtMSBNVC4KCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpT
dGFnZS0yIE1UwqDCoMKgwqAgU3RhZ2UtMSBNVMKgwqDCoCBSZXN1bHRhbnQgTVQgKGNvbWJpbmlu
Zy1ydWxlcy9GV0IpCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQpOb3JtYWwtTkPCoMKgwqDCoMKgIE5vcm1hbC1XVMKgwqDCoMKg
wqDCoMKgwqDCoMKgIE5vcm1hbC1OQwrCoMKgIC3CoMKgwqDCoMKgwqDCoMKgwqDCoCBOb3JtYWwt
V0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtCsKgwqAgLcKgwqDCoMKgwqDCoMKgwqDCoMKg
IE5vcm1hbC1OQ8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC0KwqDCoCAtwqDCoMKgwqDCoMKg
wqDCoMKgwqAgRGV2aWNlLTxhdHRyPsKgwqDCoMKgwqDCoCBEZXZpY2UtPGF0dHI+Ci0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoK
V2UndmUgYmVlbiB1c2luZyB0aGlzIG9wdGlvbiBpbnRlcm5hbGx5IGZvciB0ZXN0aW5nIHB1cnBv
c2UgYW5kIHZhbGlkYXRlZCB3aXRoCk5WTUUvTWVsbGFub3gvR1BVIHBhc3MtdGhyb3VnaCBkZXZp
Y2VzIG9uIE1hcnZlbGwtVGh1bmRleDIgcGxhdGZvcm0uCgpPcHRpb24tMjogR2V0IHJlc291cmNl
IHByb3BlcnRpZXMgYXNzb2NpYXRlZCB3aXRoIE1NSU8gdXNpbmcgbG9va3VwX3Jlc291cmNlKCkK
YW5kIG1hcCBhdCBzdGFnZS0yIGFzIE5vcm1hbC1OQyBpZiBJT1JFU09VUkNFX1BSRUZFVENIIGlz
IHNldCBpbiBmbGFncy4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
