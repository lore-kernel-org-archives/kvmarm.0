Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C89AC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 03:02:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAC5464DD9
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 03:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAC5464DD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 345B44B1F8;
	Wed, 27 Jan 2021 22:02:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G8tTetRByONK; Wed, 27 Jan 2021 22:02:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 054054B1EA;
	Wed, 27 Jan 2021 22:02:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00DD4B1E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 22:02:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtEBQJFDpCwk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 22:02:05 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70077.outbound.protection.outlook.com [40.107.7.77])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C91284B1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 22:02:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyqe6JQ0UPuj2/+QjLzJRe42Bep9JdLfUfnTmhZ3cSg=;
 b=2XXOxzl148OlU29GwCj2/OFGJGnBWGEQiiURRtdSzdBScEFhlGwR6lDGDqqbp1D0JDcntiLqn+CiRwlxVCVI7rslV5haABJ4G96gMAMyZMB3p2o0MCHa8NIq+7a91WKHQe/R8jSlScwKFCUyYE7G/I3NKW04MyGHHXEwJW76oKk=
Received: from MR2P264CA0069.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::33)
 by VI1PR08MB3070.eurprd08.prod.outlook.com (2603:10a6:803:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Thu, 28 Jan
 2021 03:02:02 +0000
Received: from VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::3) by MR2P264CA0069.outlook.office365.com
 (2603:10a6:500:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17 via Frontend
 Transport; Thu, 28 Jan 2021 03:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT031.mail.protection.outlook.com (10.152.18.69) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Thu, 28 Jan 2021 03:02:01 +0000
Received: ("Tessian outbound 587c3d093005:v71");
 Thu, 28 Jan 2021 03:02:01 +0000
X-CR-MTA-TID: 64aa7808
Received: from 7cd256c76602.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 AB264964-10DE-47AB-BF02-761990F16986.1; 
 Thu, 28 Jan 2021 03:01:56 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 7cd256c76602.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 28 Jan 2021 03:01:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADuvQE2c97YoskjzUxyiODPWhG9bArNyFGLdtlEMdblDXAhKEqzx2sNh8HgrBNjdjvSfKnXQeQiL+jwiVYuDdDe4OkCgA7zjSgBCieGEPrud3W8gu1hTbnJIzZHj1NqS0NxfqUJAF7O151b3Ivp6vJn5tSJ6kVcXYDVfgDcArt7snKf5xoaRxBjxjDtzZjEJ3A/Dwg/zabII5yJj7aL5+ZdggNacNbOsxofpOS4iHpM/ZfczPPymGhDTwlYs1G/oPjmIJaLrKAR+Q/otsyb6a9WT7jXoLwcmOQUTvrrDs1aOcFLi8y3tOLdLtXpVuyHI6nv4qLMXC5QiHRblx+8p3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyqe6JQ0UPuj2/+QjLzJRe42Bep9JdLfUfnTmhZ3cSg=;
 b=VcbU4zBXMCbDIvgWiO2yvjs+2fwIZtz9QzU8XQjoPsfS7mT9AOSylmt587lLmWaQHDsX3sC121fYJQcQYufX1jbwFRLoZ5VMb/hpuqpDWjy2bc41MF0zCD8cHberbIkfEG2QyZxYWSgP34jOX0i2RUphGE6qN46H4HcGb6CdE6H9spJSYiFVaLF8+093tDvkrIm+ieP0BZJZpUYz4sX0yo1qIlcnARpFYjzBR3rUYeWK90haFSgTMol80kwODT5QwO9Bh3FC2AUOjR0iZY1sTWjCxiwEIi/Q5skpcIebZNKQzs3vRX8Y+hqf1D2Rnp7wUAk+XjWZ67Ag8lu9Sg/cBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyqe6JQ0UPuj2/+QjLzJRe42Bep9JdLfUfnTmhZ3cSg=;
 b=2XXOxzl148OlU29GwCj2/OFGJGnBWGEQiiURRtdSzdBScEFhlGwR6lDGDqqbp1D0JDcntiLqn+CiRwlxVCVI7rslV5haABJ4G96gMAMyZMB3p2o0MCHa8NIq+7a91WKHQe/R8jSlScwKFCUyYE7G/I3NKW04MyGHHXEwJW76oKk=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR08MB3997.eurprd08.prod.outlook.com (2603:10a6:803:e0::30)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 03:01:54 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1%4]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 03:01:54 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgA+gwQCAAYaYAIACtleQ
Date: Thu, 28 Jan 2021 03:01:53 +0000
Message-ID: <VE1PR08MB47665F987B86F85454434377F4BA9@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <73b606d9c49e05435113a40a534af133@kernel.org>
In-Reply-To: <73b606d9c49e05435113a40a534af133@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7145F13AA1DF904B99AB313BB67287AE.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4434384-50b2-4a2b-8450-08d8c33915d5
x-ms-traffictypediagnostic: VI1PR08MB3997:|VI1PR08MB3070:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB307062DE4541898EA7725A99F4BA9@VI1PR08MB3070.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:139;OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zbj2aFsruAwFIBAumuj02Jrsrqn7nxQosS2BiIm6sEvdQwxFS/P5t96XX5AqRpgTgTrAsqZemquFaalEHuBwfQw70jzxWqsdvdQl2ZDTFKxjYVHx4yletE+RnLWTR97GHQkutxYJDD3BCtPjcpnksojYaeiIhOzd2RL23jtCCw/KlvpJArLFOBW+wpLccsAu7nLOToQiPS/QyyKDtip8ItXL4gMPcFyiisbhr60pCADYrG2PWREBsoWB7dwCT10Ax0b7tETCJ8rbsX7/j/qvN/4eeLGrYkFpW7DbvkSLnYbvy+1qFQcNlIlXX46mCFVSiitHg0RVnfdDZ74OdqBFJyWYcGGG2J0Z4va1kdh+Jw/d0HQ2VqkVdgiMC1Kxe9H8g+pVcL3ym4ZME1elbAwQWIlcPZTzqlUrhTrZWQFKFmU4OPlslTSnV6c5p2yvXIxRkHXLMCz1tu/v+0KbYA3N2Sfty8Qr69cp+B9NZC+kpAPW67lMrQ1zLg8Z8/jWpUUfPm88cmPUwZ0S45aHHiksFQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(478600001)(9686003)(316002)(55016002)(8936002)(52536014)(5660300002)(6916009)(33656002)(8676002)(54906003)(186003)(4326008)(76116006)(26005)(86362001)(83380400001)(7696005)(6506007)(71200400001)(66946007)(66476007)(2906002)(64756008)(66446008)(53546011)(66556008);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/7UzkiwGLhbYuFprwXaI5lSM0xLUFOEEFIS+rS9k6M7H0/wPNG5NMEGDboK7?=
 =?us-ascii?Q?SW1xyUiKVAL94MMRUeRWsDMTgrSd/o95kraFjfYiXVvdJfY1GtB3JrfqT2ro?=
 =?us-ascii?Q?DVfnGa9ba7GxeDltWZT3XCKltplmkwe2TOVRP6P6B/0T7HsnSUYtwNivzomb?=
 =?us-ascii?Q?HHcA/3dmtsNiWcEbI2EHcwBCeGSNBY907brc4M2h2KH9rqhE1Ehp1zCRols5?=
 =?us-ascii?Q?Ap1CyX3kb7q3rhjS7U4tOHau8Q+/cHMA8fetTlZR/v8wEkKk5qoFODkbBexx?=
 =?us-ascii?Q?q5tngvFtVj7o4dXGgfVflVjatOnRR2uvgXDD9Prfdbqyp3x4lWjwY/zPblWE?=
 =?us-ascii?Q?XW42Q6KMIjCuxZXGanKzWtE3a8sPYkvvn2TrlkqI+yZUW/kdEgCRW7chiYSR?=
 =?us-ascii?Q?DgSTkvTDKqgEAVPKLAqUk6WFl9hgT4uI2gC0QITKAiwdLHIMP2/Ykbs+R0rb?=
 =?us-ascii?Q?Sgntb42eUE4FHlSx8Clfoz/TiNvwIW3OSWZ+KaTEVdyW1Ji3f6BBzv3GDT87?=
 =?us-ascii?Q?Wwh1IV5a9mMUKlCVEfo7eWv23rIj6kL4nneRE8/DENVWNjc9xT6xXHA59Hpw?=
 =?us-ascii?Q?qoNMJ/a3lUf4wrbTqvM7RtOTB/h2xzYkYHWqdcGDVEWVGjAuNnZhOLbGzjBp?=
 =?us-ascii?Q?htK+NX3PfiIWIIXx7eveIam4drPA13xFwuDEca4NjtI7SAJG6kPl562/UFaR?=
 =?us-ascii?Q?zSX391YFQOQuKGyMPsfMXaMn1/qme1TRCKvldNKghu/1OfOZTKPGSUXDhh78?=
 =?us-ascii?Q?DEU8R83YgfqdOqlU7o24wigiq7jI2jPztOT9+NiLHqnf+Me/DAmWTMM0DR5o?=
 =?us-ascii?Q?v9JhKFX0qj8s5q9wTXX0PBiEKzRQmxa7TT0F9WSTrN4tiRYE2V2U0JmyaBpK?=
 =?us-ascii?Q?tNFmffL/IKO2VTmYjSH6/98703Q5ZpX8jBc+GFAcMZ7Fx0WgdrtyJTWVEu8N?=
 =?us-ascii?Q?BZZ7vl9PNH77OckJpOtFUr4SDrhwLtiTKNX7f2/3KswE2Z9mbEJjRSsTvPJM?=
 =?us-ascii?Q?q7+UYmvYIo/JTvY703WIdCYWCm9cM13e8UG10E9g6XR4pkp9CqEtpb6j8KBE?=
 =?us-ascii?Q?VQ864JjZ?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3997
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 39d07d5f-5b79-4046-3db8-08d8c339116c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7r3t+2uB/d33W6SF9INvygh+4EPwexZdpAExbGDiwX0BM5CskVe9Y5lMwNPMZFt2e4KuIz0Lkr6PCeV76o9/n7kjbk6t4J9m8zdZj1SLi9XjKlLxWg4gsO/Ekcs7R8iyni1fz984YRQZY2poI0I5+0+x+q7exGqce7xesWqI0+2/SNONuCpLU7nYhOK8BZ5PqCzhnF3kLelYZO1jONrysMU9ZnRCN1UoKcTERDkFsLkNLl5NmYDwdaT9XpBCgaulUrBQ59e5Sw8KeTXGxK2PoLbrzfaUyOR/eg1yHI3Qsx4Q57mux+DZ4ewD+zJJZrg2k8zHLIhN+a9HC/4Ii/d7SFozp9ezf7hBvidOphcdFBqycS855P29F2YtxZqBtzlaR1O5FTXvlG80nNFhcwpr41rbvgQcnnVz+xzlAIMEoC2RMhnlUTM7vXINrom+AOfBiDvep2czCQnWz5Ynj+wXRi+sIVtcvd+whIAh5PZCFkLmq/195U7jVwUrP/RxgBWKsNgr8t7e+fURXr6sIo1jaXJR04hsuynGBeOOlLS0aMWQp/i2Fg6U+/j/VuSZA3dkZS3HPdVfrjy7WWaK+CJ6WdqBXI1uJAARZR7VOFC8KCI=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(7696005)(316002)(82740400003)(2906002)(33656002)(478600001)(6862004)(6506007)(8936002)(5660300002)(82310400003)(54906003)(8676002)(70206006)(26005)(52536014)(83380400001)(186003)(4326008)(70586007)(81166007)(53546011)(47076005)(336012)(9686003)(356005)(86362001)(55016002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 03:02:01.8542 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4434384-50b2-4a2b-8450-08d8c33915d5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3070
Cc: Justin He <Justin.He@arm.com>, nd <nd@arm.com>,
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

Hi Marc,

> 
>  From 8f2a919d6f13d36445974794c76821fbb6b40f88 Mon Sep 17 00:00:00
> 2001
>  From: Marc Zyngier <maz@kernel.org>
> Date: Sat, 16 Jan 2021 10:53:21 +0000
> Subject: [PATCH] CMO on RO memslot
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 51 +++++++++++++++++++++++++++++++++----
> -------
>   1 file changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> 7d2257cc5438..3c176b5b0a28 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -760,7 +760,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
> phys_addr_t fault_ipa,
>   	struct kvm_pgtable *pgt;
> 
>   	fault_granule = 1UL <<
> ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> -	write_fault = kvm_is_write_fault(vcpu);
> +	/*
> +	 * Treat translation faults on CMOs as read faults. Should
> +	 * this further generate a permission fault, it will be caught
> +	 * in kvm_handle_guest_abort(), with prejudice...
> +	 */
> +	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
> +		write_fault = false;
> +	else
> +		write_fault = kvm_is_write_fault(vcpu);
>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>   	VM_BUG_ON(write_fault && exec_fault);
> 
> @@ -1013,19 +1021,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> *vcpu)
>   		}
> 
>   		/*
> -		 * Check for a cache maintenance operation. Since we
> -		 * ended-up here, we know it is outside of any memory
> -		 * slot. But we can't find out if that is for a device,
> -		 * or if the guest is just being stupid. The only thing
> -		 * we know for sure is that this range cannot be cached.
> +		 * Check for a cache maintenance operation. Two cases:
> +		 *
> +		 * - It is outside of any memory slot. But we can't find out
> +		 *   if that is for a device, or if the guest is just being
> +		 *   stupid. The only thing we know for sure is that this
> +		 *   range cannot be cached.  So let's assume that the guest
> +		 *   is just being cautious, and skip the instruction.
> +		 *
> +		 * - Otherwise, check whether this is a permission fault.
> +		 *   If so, that's a DC IVAC on a R/O memslot, which is a
> +		 *   pretty bad idea, and we tell the guest so.
>   		 *
> -		 * So let's assume that the guest is just being
> -		 * cautious, and skip the instruction.
> +		 * - If this wasn't a permission fault, pass it along for
> +                 *   further handling (including faulting the page in
> if it
> +                 *   was a translation fault).
>   		 */
> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> {
> -			kvm_incr_pc(vcpu);
> -			ret = 1;
> -			goto out_unlock;
> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> +			if (kvm_is_error_hva(hva)) {
> +				kvm_incr_pc(vcpu);
> +				ret = 1;
> +				goto out_unlock;
> +			}
> +
> +			if (fault_status == FSC_PERM) {
> +				/* DC IVAC on a R/O memslot */
> +				kvm_inject_dabt(vcpu,
> kvm_vcpu_get_hfar(vcpu));

One question:
In general, the "DC" ops show up very early in guest. So what if the guest do this before interrupt initialization? If so, the guest may stuck here.

Thanks
Jianyong

> +				ret = 1;
> +				goto out_unlock;
> +			}
> +
> +			goto handle_access;
>   		}
> 
>   		/*
> @@ -1039,6 +1065,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> *vcpu)
>   		goto out_unlock;
>   	}
> 
> +handle_access:
>   	/* Userspace should not be able to register out-of-bounds IPAs */
>   	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
> 
> --
> 2.29.2
> 
> 
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
