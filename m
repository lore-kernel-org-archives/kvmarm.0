Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0944C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 09:01:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38B9D610CE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 09:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38B9D610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A265E4B11B;
	Wed, 13 Oct 2021 05:01:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EHpQSMFLy1ip; Wed, 13 Oct 2021 05:01:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75EDE4B101;
	Wed, 13 Oct 2021 05:01:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B814B0EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 05:01:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4xdJ73H9EsM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 05:01:43 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70045.outbound.protection.outlook.com [40.107.7.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BACC64B0E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 05:01:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCmRz6sQyqdJLwBkaVXI5y5SLdz1Nl/M7cmj9NRM1D0=;
 b=dzmUp5YkEEfiIl1NLhorG1Oiw+HNsyu0wtwJv4brMyBwQPIeND43PkrYN4EV6oeH6hr7g4RdqxgLTMWJeauAdE4hQALAg71FKhE10wjJOlAWxky8yfKzkpHEk4blIuJp3Sv96n3Pm+aW6S5i1kdEX3PS1CSOgZKHsJUZsh3fORY=
Received: from DB8PR09CA0025.eurprd09.prod.outlook.com (2603:10a6:10:a0::38)
 by DB7PR08MB3385.eurprd08.prod.outlook.com (2603:10a6:10:4b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 09:01:37 +0000
Received: from DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:a0:cafe::ae) by DB8PR09CA0025.outlook.office365.com
 (2603:10a6:10:a0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Wed, 13 Oct 2021 09:01:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT060.mail.protection.outlook.com (10.152.21.231) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18 via Frontend Transport; Wed, 13 Oct 2021 09:01:36 +0000
Received: ("Tessian outbound 16951d3c485e:v103");
 Wed, 13 Oct 2021 09:01:36 +0000
X-CR-MTA-TID: 64aa7808
Received: from 9335649f1979.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 DBF54D27-99BA-4CBD-BB4C-EC108DDB1754.1; 
 Wed, 13 Oct 2021 09:01:26 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9335649f1979.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 13 Oct 2021 09:01:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9BZ3vBhRJ0f3tUiSIOEIwtf5Bgzt5/r+JXWg5LscMbXrzd8W0FV0ni1PJZ6UMyb/XyicusDp2ZxwJsb8kdgxlPMOuFlQrkDCfXmIj0dD/rKh8oO1tJit+h8s2UjB1f+Wv9QUdVCEE4zZCapGVnvSxaHq01tl/D5z0MYbGcb/SuqgyH/KGQIbV+tM81AOAC8Vl7mq1G94kJC/8y381+0qtxFWHEHumAgFg9kP60N/J09FH+rLD8wUj8Q9qTIeVBmeCY7p0GSXm61TY46Fw1lLonWMa9GtkmmH98GiN/YcJDwsaAMhMOneeqskXsEulxjBczEZlJ68uMkXZ7mMpZXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCmRz6sQyqdJLwBkaVXI5y5SLdz1Nl/M7cmj9NRM1D0=;
 b=hxvLhUZjk7WQ319gHxZ2wVLUrBqDmEU0Cgt4uEDiy/fT8FI2LODufLlTLyl67ilk0KFCaUTWf3Twyopr9NQI6XzfbRoMw9SFngRnW9qGHFWKZoMJilL+LG1ir9nK216sWzGlSF274kz+ZgxL7onlggPsjPbhjNSxuN0kvxpecM9Cy6vO+Jp9Bt9I16AxJuyoq3q2IGYsJPMETiBydx2NoNE87IY90uPApumkBPQnJ7H/poJkHN5vYfXDXjd37zobWIEir4nmj6gPxH1ILiFTRJgGuVxBwL1JKSWLEeD6QwKh22OZ4Vmhj4mInnbSu2bJ/9hPwydOOvw5VEKUUrB4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCmRz6sQyqdJLwBkaVXI5y5SLdz1Nl/M7cmj9NRM1D0=;
 b=dzmUp5YkEEfiIl1NLhorG1Oiw+HNsyu0wtwJv4brMyBwQPIeND43PkrYN4EV6oeH6hr7g4RdqxgLTMWJeauAdE4hQALAg71FKhE10wjJOlAWxky8yfKzkpHEk4blIuJp3Sv96n3Pm+aW6S5i1kdEX3PS1CSOgZKHsJUZsh3fORY=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB5288.eurprd08.prod.outlook.com (2603:10a6:20b:ac::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.21; Wed, 13 Oct
 2021 09:01:24 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::80e1:922c:ad90:583d]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::80e1:922c:ad90:583d%3]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 09:01:24 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM allocations
Thread-Topic: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM
 allocations
Thread-Index: AQHXo+SXY1+Y7PRqPEOtXG6vaRVv1auZJ8aAgAI+QxCABoXbAIAu7Zgw
Date: Wed, 13 Oct 2021 09:01:24 +0000
Message-ID: <AM6PR08MB437604FBA3C47C4D70D2A9CDF7B79@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210907123112.10232-1-justin.he@arm.com>
 <20210907123112.10232-3-justin.he@arm.com>
 <CAOQ_QsjOmHw+545J0T9i-nWV2bVGGEwHq5SPVvBOM-SHMXpP5g@mail.gmail.com>
 <AM6PR08MB4376DB4B908AC37DF24290CFF7D59@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <CAOQ_QshF+N7Q=-cXAoMSW4Gcy7mr_oFVpye7fEBqPeR8+3mK0Q@mail.gmail.com>
In-Reply-To: <CAOQ_QshF+N7Q=-cXAoMSW4Gcy7mr_oFVpye7fEBqPeR8+3mK0Q@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A3B4FE0C01C5424FB1537B60F5CDDB0A.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 2d6c19db-a01e-4699-bd59-08d98e28101a
x-ms-traffictypediagnostic: AM6PR08MB5288:|DB7PR08MB3385:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3385F82EA91404F34ED4B23EF7B79@DB7PR08MB3385.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:5797;OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: aTbbbOn2+L+i9g9XJhanPlIghu7bpaJLni8td+Pelj9eksOHrhZ1tIjenLE7GpuRSLFuyu5Nu+61tvNviX//X7OtYpJ9CjVOzWfK7w9vuIJihYcNVEx4N9n2+PcsX6zprAB8iZpo206MkpxcTCiKE+OUYRk+piT8gCXYCXTq+Ngx3eLorG/XVssY4KTohMvjzYcPK9IzUWfg6YW0WnZtayo4qVTTLeXiwevExlDPXYHuifCMiu83snnR8VgHNT2URpMAMTBkOoQtBgmvoINnNCpWuV912Qt8p1D1JKEeuMmwUt3PG4iaFl4TVVtQQzkBr9CEArmgVF/dhW6sNlyDmZQ2CVw8ijLOuTdplnQeddmONKEx7e93pq9D1TqewSU7R7vzRe/gCcl/WeEr/fwIAcydQmEITQPR3jySpwx8YObQOGGNBRpyXmO/WRP0B1uSO2fgNEQLoLuFWRMVNLoFKUUtL8s86Ks57Eh+vURoRMzaukOo8y+omfG2dZJfIoqcXQGe1TE1JH41/JspfyQIqcMryOD31OEZU+9k8urvgCffJYpivdWh8KKomAR3Hj0DEbU6N0e5HlwQ0a6AN9wqI3pET77pXgr/WUQbBfGGdrqY0/EyAL+7iWXIy8JpVOHXK9/L1cJ0U7uHSwZV9+WCxp5GtKVP2PlzYIjzh0PcRiDaOj4wnjzsvqTL/Mt9pBuQ5+Fsk5agGWq3Z9Nasswjtg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM6PR08MB4376.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(86362001)(71200400001)(186003)(66446008)(508600001)(6916009)(122000001)(64756008)(66556008)(38100700002)(7416002)(33656002)(4326008)(9686003)(5660300002)(52536014)(66946007)(7696005)(8676002)(8936002)(4744005)(66476007)(316002)(76116006)(54906003)(26005)(53546011)(38070700005)(6506007)(15650500001)(55016002)(83380400001)(2906002);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5288
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 95314b44-c5f6-4177-7abb-08d98e28088b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJAgev02eoHhyELS4c5NuVcEZUc0NObVTkk44AO6HF91AvdeogqnNSZ25UXKAHIpn/8Z+msLIIbNMuuW4/ef5Dpyh75WWZFGvXCYYIKR+KuosSUUiT+TBuX1Yw6l6T9QamwSnzEQRbifmDNq9KV3nHjoj1tAlK38k0ORu0ElcnFSR1K93V87jLLcV7YhVRphaIsK/iGFTH6Aql5RI7DLqGUPPeDFQt1vBZKRiFrfbCW5TZNGP0okw7u3yqRaM24YH9MiB6N9oJ+hVo2Z2y//e1vWh4wwKXQdStm/ZrwvseKcCbLEXXuru+vCkdiRVcbZYh3cp7+o21A4PEgUg4+vEuK7vg+7aTyoZjUk7WODfQyNvhUSbaodfkJmPdAj4oLwvIXTB0lQDMAwRRhaSNELv3YydGyixeMySeGt7laDSCELdMfukm1iFWXhvZi8wY8Sn/gsVu5KnVzBWPHmkSBo8FkIvNk7cswZeIYI5t4aCYzKkfVJdwzzvgjau7X+dAzVHlnLgKSkLq30mpDdgChrzqti/wIZQa68z0qr+Fjm6qfQsUHKFfJkMDQNyg3MzTx9MQJHaMvAk9RONv4hW0ehlGe7TRwbgt91beHv+N4oN2Td2JjRyZkbbplkMVh3zj7q5q3+FUnNUOPNYO0rhKAmo37F/EwhYcQYzTf08cWc4qSUDdtCFjqAQ5hR/nDHhVicu+AXAQlAeJ3677WhA10zSA==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(36840700001)(46966006)(508600001)(36860700001)(356005)(7696005)(4326008)(6862004)(81166007)(86362001)(54906003)(55016002)(52536014)(53546011)(6506007)(9686003)(316002)(26005)(8936002)(70206006)(33656002)(5660300002)(8676002)(336012)(70586007)(186003)(82310400003)(47076005)(2906002)(15650500001)(83380400001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:01:36.9584 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6c19db-a01e-4699-bd59-08d98e28101a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3385
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Xiaoming Ni <nixiaoming@huawei.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, nd <nd@arm.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE9saXZlciBV
cHRvbiA8b3VwdG9uQGdvb2dsZS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgU2VwdGVtYmVyIDEzLCAy
MDIxIDg6MjEgUE0NCj4gVG86IEp1c3RpbiBIZSA8SnVzdGluLkhlQGFybS5jb20+DQo+IENjOiBN
YXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPjsgSmFtZXMgTW9yc2UgPEphbWVzLk1vcnNlQGFy
bS5jb20+Ow0KPiBBbGV4YW5kcnUgRWxpc2VpIDxBbGV4YW5kcnUuRWxpc2VpQGFybS5jb20+OyBT
dXp1a2kgUG91bG9zZQ0KPiA8U3V6dWtpLlBvdWxvc2VAYXJtLmNvbT47IFhpYW9taW5nIE5pIDxu
aXhpYW9taW5nQGh1YXdlaS5jb20+OyBMb3JlbnpvDQo+IFBpZXJhbGlzaSA8TG9yZW56by5QaWVy
YWxpc2lAYXJtLmNvbT47IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPjsNCj4gQ2F0
YWxpbiBNYXJpbmFzIDxDYXRhbGluLk1hcmluYXNAYXJtLmNvbT47IE5pY2sgRGVzYXVsbmllcnMN
Cj4gPG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgTGl1IFNoaXhpbg0KPiA8bGl1c2hpeGluMkBodWF3ZWkuY29tPjsgU2FtaSBUb2x2YW5lbiA8
c2FtaXRvbHZhbmVuQGdvb2dsZS5jb20+OyBXaWxsDQo+IERlYWNvbiA8d2lsbEBrZXJuZWwub3Jn
Pjsga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdTsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlz
dHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvMl0gS1ZNOiBhcm02
NDogQWRkIG1lbWNnIGFjY291bnRpbmcgdG8gS1ZNDQo+IGFsbG9jYXRpb25zDQo+IA0KWy4uLl0N
Cj4gPiBEbyB5b3UgbWVhbiBrdm1faHlwX3phbGxvY19wYWdlKCkgaGVyZT8NCj4gPiBTZWVtcyBr
dm1faHlwX3phbGxvY19wYWdlKCkgaXMgaW4gYm90aCBnbG9iYWwgYW5kIFZNIHNjb3Blcy4NCj4g
DQo+IERvaCEga3ZtX2h5cF96YWxsb2NfcGFnZSgpIGlzIG9ubHkgZm9yIHRoZSBoeXAncyBwYWdl
IHRhYmxlcywgaGVuY2UgSQ0KPiBiZWxpZXZlIHlvdXIgcGF0Y2ggaXMgY29ycmVjdCBhcyBpdCBz
dGFuZHMuIEFzIHN1Y2g6DQo+IA0KPiBSZXZpZXdlZC1ieTogT2xpdmVyIFVwdG9uIDxvdXB0b25A
Z29vZ2xlLmNvbT4NCktpbmRseSBwaW5nIGZvciB0aGUgd2hvbGUgc2VyaWVzLiDwn5iJDQoNCi0t
DQpDaGVlcnMsDQpKdXN0aW4gKEppYSBIZSkNCg0KIA0KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
