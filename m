Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABC1C00140
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 13:26:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAFDF4D989;
	Fri,  5 Aug 2022 09:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z9RbwQA-QhEz; Fri,  5 Aug 2022 09:26:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F074DB25;
	Fri,  5 Aug 2022 09:26:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 847DE4D986
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFvGvIyQlLAK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 09:26:30 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60073.outbound.protection.outlook.com [40.107.6.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94FE24D779
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:26:30 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=IV9lPEyGvyBCVoFZH6rrnoc4z3942SIixCBcrmkqUw52boE0TpFHLZFFTdB2ta+RBNhwB9C2Opd6vn2qNQxo+K4EjoGXi4PrcPzXxJuIfAM1m8Bpp/SLrtNhGAglXhuNQITaZfs2SA4fRlDP+qwoyB5NHBBnF1fIwW6NQM+PPg+1Fot8KVkd3s4tU9vlPr3SIlzJN5+mxzSCqanwI0nWjvmVFTQDe93LTZlPHSeL4H0g05kj2q22j35IcX0SQeCj7jPyMKJjrarNaqKPyKSqfyMfKvUMM7bLEo5EuB6Gau1IN1DNoCiANe+wpClfElUrgUVyuokN1+D2RO1oLZm+JA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=nBColfHpxtVoPeKXMSY34tnGvo4VtPV7JallyOtyiP5hY8cMcapKHMqgOsz+tgqSTidbhLTMlhlWZNMGEv22KENYeIBLDfNXmHlEpuPwLP79Yt4Lt20EdhFvphH2AvJlfIV4DEbbDgdqHzfT5+E/lgKpZdrQXUHZwGTJcVDvqZcEE2t9UfnKuJUEYy4NqCxKLDIEtTocXagBbdy67csmBSmqBNBRc1X5ncyAk6BNWcMCjxY9I0bkymuytyJBC+l9ZqYCCNZACeVmkNggxgkjMmxoZBXybeMK6F9JvXLQpZ8pGj6JyMkb3Uhq/zv3KabcVagG8655T35VGIkthNXdNA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=G9t/htXVfON41/BR9Kbkqmau9a7aWU9aC4B4saIlDAQ1vtLYbNIf+ajofNKc2DVE5h8zLreLVz9pIDcsQT58p9+KQ6uRscIJTjieAAv6a1Hlxrx2XwfeaeUew/ya8G8MFuatb+9NQXXUHQI3hi0Db/JxSMefkjMLd1Cpkjt1cAY=
Received: from FR3P281CA0141.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:95::14)
 by DU0PR08MB8185.eurprd08.prod.outlook.com (2603:10a6:10:3ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 13:26:26 +0000
Received: from VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:d10:95:cafe::e) by FR3P281CA0141.outlook.office365.com
 (2603:10a6:d10:95::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.7 via Frontend
 Transport; Fri, 5 Aug 2022 13:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT003.mail.protection.outlook.com (10.152.18.108) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16 via Frontend Transport; Fri, 5 Aug 2022 13:26:25 +0000
Received: ("Tessian outbound 73dd6a25223d:v123");
 Fri, 05 Aug 2022 13:26:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9491291f008b9d32
X-CR-MTA-TID: 64aa7808
Received: from 77fc60f9276d.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 39190DC3-7FF2-4B09-AD31-5346C30EB702.1; 
 Fri, 05 Aug 2022 13:26:14 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 77fc60f9276d.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 05 Aug 2022 13:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS35MbdOfJeXlfsVMx68tRr4m718veBZVcpAhvQnzeH0uAdLg7Pma2vTihPlnfTCV8iUH35fzSWedzuhX74LUeb9mJC6Ho59h/hh3ey+6S0T90IFdFG9qMUNZAGVOgZXG43qPZlgfLwmmOBQZgmbYQRIz2hOMmAkVOh9k2fbJyq+vcLvSZquLYlOmUaVdyx2OP669hl2Q6tnURKpJTRo7wZdJyT9MilMveLLdSe8hOPxHVxpFGOn3TVST2yIyLVOsjX471Wm1731kJlLfDH9qkxaYARq3bdVoedePYMuWeywSRfgR6JzuoI+lMU2IJiqWmfd8Jth4Qub3GCcPBUmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=KDoKryvDexi09ZcJ5Zu6ZCsxhqGH0DLBKt29s9/VUr0A1wXU4qHP3DnY5valw+4XrCeLnDOqMr+Q7PqUZN9yiIcsACn/75Yvf2FoxlcZE8vAdHS5bj5F20yE1yuwiLKISyW/n2IdxFZP8N2T/uzWX5b8amPeIU9JmeqTeQF+M8QZkbQ9IRotxf6D7r4nn+kcooFl4LBpf27C5k9pahIhm+BY+TFEvQLfyNxVV2x2XRrVnvAnD/ahLacDpq4QQoIICqkMpI/He+emlZPwGxOsfpHCBmWvoZ4E7Yvm8heTCIkiMES8hbGvDWtVDIxZsuHbiaN2DPLc03nKSHbrQL4GGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=G9t/htXVfON41/BR9Kbkqmau9a7aWU9aC4B4saIlDAQ1vtLYbNIf+ajofNKc2DVE5h8zLreLVz9pIDcsQT58p9+KQ6uRscIJTjieAAv6a1Hlxrx2XwfeaeUew/ya8G8MFuatb+9NQXXUHQI3hi0Db/JxSMefkjMLd1Cpkjt1cAY=
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com (2603:10a6:803:7c::27)
 by PR2PR08MB4697.eurprd08.prod.outlook.com (2603:10a6:101:18::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 13:26:12 +0000
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c]) by VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c%4]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 13:26:11 +0000
From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "thuth@redhat.com"
 <thuth@redhat.com>, "andrew.jones@linux.dev" <andrew.jones@linux.dev>
Subject: [PATCH] arm:Add PSCI_CPU_OFF testscase to  arm/psci testsuite.
Thread-Topic: [PATCH] arm:Add PSCI_CPU_OFF testscase to  arm/psci testsuite.
Thread-Index: AQHYqM7ulxgdpWdTN06xVkGrefvctA==
Date: Fri, 5 Aug 2022 13:26:11 +0000
Message-ID: <20220805132601.461751-1-Nikita.Venkatesh@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-MS-Office365-Filtering-Correlation-Id: 963bdbcf-5f52-4cb4-ed63-08da76e618e1
x-ms-traffictypediagnostic: PR2PR08MB4697:EE_|VE1EUR03FT003:EE_|DU0PR08MB8185:EE_
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: S6UaC1Y8hxlbGfUg+H6nNHPm5NtyrwSleyJjVtwxBgGoS0M1ZjeUwSdU0v0jEkwj2xyOKAYUK6eACSf2ce0MNENcrVskHTfOPtUzB5fJKoMml2vmdU/psYjrqkrEDfwPXUVhFD+3Deh4vFO8Z7sawEK2eI7OBqJR+reTsEKwpJHdXvD41ZJ9jHn9aB8JBKCud1XMOYeiuV6wcbSx3d8ciPPMjYRElxM4gUBl5732du8eJ4IC1kB6IWGYmP8fq++hQimrVdRLlbHWyJcdL2I+Q9t4b1zyVDJqHWzRLTa24DlNCPPLi3FDBtSCW6wjPJWFnWFRD88DVU9iAvGAlgVXgejxWNG7qnBubSUvPKi/tUaPYYXDQMs9tK2HPhVNOg7ka/GcNKOhAYVIZdve6DhG6wSik9jReDBNeTXpa4L4dx0RlJM0jkMGR+eXWl46DmWx6QQTrqGmSN2ovxZRwg/AJA2FZyX62rvTZ+Ai1mwUvKxGCd4mAT7dlNmlcRqy5fK2hZLwKK5fOudeZw9y8s70xBmAWK+odFJZvet/diQq0LsN8UTktCDOWQPu5bY+PUJX+FYxqgbmtI1NNEqWv/zcREm4t1BFxsTEQC+C/Lh8M/iXITPNEVMH/UgYv0m9IrqAJs7SvAnS1caTNlUV/TAK4AZuBnxNn6bYWACOtSU6m6UK+CYeA4DF2zj0lUbOTbvGT6B6synbfQcJKtfJv48+aRzMCTQt7I9ZLj7SuuoUaT0GChafIVbPzaEVpfITmkR5n/6w4lmvsTABU/yc61vwb0ZvWeqpHkTvNVw/SJNiFU/anmlRsEgoCXAeyslOUqYc
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3485.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(316002)(2616005)(1076003)(186003)(83380400001)(36756003)(86362001)(2906002)(38100700002)(64756008)(66446008)(76116006)(66476007)(8676002)(4326008)(122000001)(91956017)(38070700005)(8936002)(5660300002)(26005)(6512007)(41300700001)(6486002)(478600001)(71200400001)(66556008)(66946007)(54906003)(110136005)(6506007);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4697
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 948e0042-d565-4b93-63a4-08da76e6108b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Cx/at5iy62q0PcGnmm+J3w/ylD0nsmN5OqWZerma6ai7jkduzFlo6fYcUn+mNMxAG0Um7fhMU8fiBVjkF8Qdpd16nom/xAmGTFhujxqpX/1gCvQLgSKGbtdFzYcv343OxWzZiVNl8Jm9eE08itReXap4wmyWnN4XlugXs22W6LUHRCK3XtBCZMgHlkpzibsxHveLSxR92tjqIo+2ibnv5OtVFQLTmljAe34XvbIfMTdot+oCAotmhmjQfFuea6RCSGQbxs66IUOfMgX4jlY+cj3GIjVQGqZJpaEA18gXyHpYO7gHizZiW9e7qQmVY9F7nh8YnIGrOODemnMH/F6Nli2oizL5i9oy9GqvUty9Jr6tZCvcilanvhlzyB4SZYfac1zms0S3MCV5FCutoU8/D5fpF0TZ+UNNwBoamdzfPBeLp3B/D8T9waTTJMQA9OsiyCd0LDQs49AUPmpM7NCYY1Qx4ErhnPIFBpmuXcjDVeNrfQcvhCoiujjc9gQ0G2U4qDLCi1i7n/+iwN967zKKSTbJ7X9Yo5ko5845ZhaZK7DHopqjAyv8vLeuLIeqQiiE6aMhvK8H1RWOji9ZZ7B/UjTk7C91YrObD364ku9W3FTITCV0RxCClzSe1N5AqBe30wLqCwsW6tWXrc9bp6k3v69wIYjoTWPdfBhEFhbJNVRQWfdztwNIg6DRFfdC1qbkl8XzKLRJwlOwCflW/mpVqP/dQ9TlVHEN6KAhjKDVhYAY8OqYycfWEc6JaShaVA6s7YloWBPrP/gYTzYpV+Tygc5/9+Spu+oB3Slud1G8RQgdZM6h6KIyAaN3jlnCJ4z
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(40470700004)(47076005)(81166007)(336012)(110136005)(2616005)(186003)(1076003)(356005)(82740400003)(26005)(41300700001)(6506007)(6512007)(2906002)(5660300002)(36756003)(8936002)(40480700001)(8676002)(4326008)(86362001)(70206006)(70586007)(82310400005)(6486002)(478600001)(36860700001)(40460700003)(316002)(54906003)(83380400001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 13:26:25.7111 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 963bdbcf-5f52-4cb4-ed63-08da76e618e1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8185
Cc: Nikita Venkatesh <Nikita.Venkatesh@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 nd <nd@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

The test uses the following method.

The primary CPU brings up all the secondary CPUs, which are held in a wait
loop. Once the primary releases the CPUs, each of the secondary CPUs
proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
the status of the call is updated by the secondary CPU in cpu_off_done[].

The primary CPU waits for all the secondary CPUs to update the cpumask
and then proceeds to check for the status of the individual CPU CPU_OFF
request. There is a chance that some CPUs might fail at the CPU_OFF
request and come back and update the status once the primary CPU has
finished the scan. There is no fool proof method to handle this. As of
now, we add a 1sec delay between the cpumask check and the scan for the
status.

The test can be triggered by "cpu-off" command line argument.

Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
---
 arm/psci.c        | 87 +++++++++++++++++++++++++++++++++++++++++------
 arm/unittests.cfg |  6 ++++
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722..5485718 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -12,6 +12,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
+#include <asm/delay.h>
+
+#define CPU_OFF_TEST_WAIT_TIME	1000
 
 static bool invalid_function_exception;
 
@@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
 }
 
 static int cpu_on_ret[NR_CPUS];
-static cpumask_t cpu_on_ready, cpu_on_done;
+static bool cpu_off_success[NR_CPUS];
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
 static volatile int cpu_on_start;
+static volatile int cpu_off_start;
 
 static void cpu_on_secondary_entry(void)
 {
@@ -83,6 +88,19 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
+static void cpu_off_secondary_test(void)
+{
+	int cpu = smp_processor_id();
+	while (!cpu_off_start)
+		cpu_relax();
+	/* On to the CPU off test */
+	cpu_off_success[cpu] = true;
+	cpumask_set_cpu(cpu, &cpu_off_done);
+	cpu_psci_cpu_die();
+	/* The CPU shouldn't execute the next steps. */
+	cpu_off_success[cpu] = false;
+}
+
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
@@ -130,7 +148,56 @@ static bool psci_cpu_on_test(void)
 	return !failed;
 }
 
-int main(void)
+static bool psci_cpu_off_test(void)
+{
+	bool failed = false;
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		if (cpu < 1)
+			continue;
+		smp_boot_secondary(cpu, cpu_off_secondary_test);
+	}
+
+	cpumask_set_cpu(0, &cpu_off_done);
+
+	report_info("PSCI OFF Test");
+
+	/* Release the CPUs */
+	cpu_off_start = 1;
+
+	/* Wait until all are done */
+	while (!cpumask_full(&cpu_off_done))
+		cpu_relax();
+
+	/* Allow all the other CPUs to complete the operation */
+	mdelay(CPU_OFF_TEST_WAIT_TIME);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+
+		if (!cpu_off_success[cpu]) {
+			report_info("CPU%d could not be turned off", cpu);
+			failed = true;
+		}
+	}
+	return !failed;
+}
+
+static void run_default_psci_tests(void)
+{
+	report(psci_invalid_function(), "invalid-function");
+	report(psci_affinity_info_on(), "affinity-info-on");
+	report(psci_affinity_info_off(), "affinity-info-off");
+	if (ERRATA(6c7a5dce22b3)){
+		report(psci_cpu_on_test(), "cpu-on");
+	} else {
+		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
+	}
+}
+
+int main(int argc, char **argv)
 {
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 
@@ -143,15 +210,15 @@ int main(void)
 
 	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
 					  PSCI_VERSION_MINOR(ver));
-	report(psci_invalid_function(), "invalid-function");
-	report(psci_affinity_info_on(), "affinity-info-on");
-	report(psci_affinity_info_off(), "affinity-info-off");
-
-	if (ERRATA(6c7a5dce22b3))
-		report(psci_cpu_on_test(), "cpu-on");
-	else
-		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
 
+	if (argc < 2) {
+		run_default_psci_tests();
+	} else if (strcmp(argv[1], "cpu-off") == 0) {
+		report(psci_cpu_off_test(), "cpu-off");
+	} else {
+		printf("Unknown subtest\n");
+		abort();
+	}
 done:
 #if 0
 	report_summary();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b55..02ffbcd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -218,6 +218,12 @@ file = psci.flat
 smp = $MAX_SMP
 groups = psci
 
+[psci-cpu-off]
+file = psci.flat
+groups = psci
+smp = $MAX_SMP
+extra_params = -append 'cpu-off'
+
 # Timer tests
 [timer]
 file = timer.flat
-- 
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
