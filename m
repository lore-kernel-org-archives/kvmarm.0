Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8417DC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 05:27:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FA2C60EFD
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 05:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FA2C60EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7502E4B0F9;
	Fri, 23 Jul 2021 01:27:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1bjnGeJa7QiI; Fri, 23 Jul 2021 01:27:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3090C4B152;
	Fri, 23 Jul 2021 01:27:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713B54A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 01:27:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZB9xYTGAijXf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 01:27:37 -0400 (EDT)
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40080.outbound.protection.outlook.com [40.107.4.80])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 386BF4A19A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 01:27:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8c58wkxU80oVDJsmu8MOu5pNkz9PxJYsYtN0vqXfDY=;
 b=CWvEkLSwGTJz0rwnZcq6JkJJu6OjSGhZW5wkKYQxDiULLEJiIvwWJN8+UJ5/piWyi8ChIGDDpUnLm2jaYnh0uKIaNiILiJE262N8+BezQGBpBmUiDU6ioRr+XhlWGMpm1S66Hqi0IsqdoxGRCpRlsDrohSlv+fBXVMREP9YUa8Y=
Received: from AM5PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:206:1::16)
 by DB9PR08MB6412.eurprd08.prod.outlook.com (2603:10a6:10:23d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Fri, 23 Jul
 2021 05:27:34 +0000
Received: from AM5EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:1:cafe::74) by AM5PR04CA0003.outlook.office365.com
 (2603:10a6:206:1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Fri, 23 Jul 2021 05:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT061.mail.protection.outlook.com (10.152.16.247) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 05:27:28 +0000
Received: ("Tessian outbound ef2da60907d5:v99");
 Fri, 23 Jul 2021 05:27:27 +0000
X-CR-MTA-TID: 64aa7808
Received: from e68d2352d1ee.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 B97919CB-DBE1-4279-8DD4-C450B95AAD7B.1; 
 Fri, 23 Jul 2021 05:27:17 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e68d2352d1ee.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 23 Jul 2021 05:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj/4jCbYljjwIO0wcoCapfpo1VZ7fsUpReVgPCkMyToRSpQvniz1upcREieBL5fVFd1ZnAJMdHdmjDw9mJahQZgcb/2BsHRBlwCMfUYm2z6yVmSqaKBrjaPAr9O34XNbVT4+Ik8utCBPIoDjHMU5rQmWkCqDxkDt4OnGcpjNj9t/kQEytYrN75ZjuLvHsdfVC4yRIhc1lR6RCNp7Qw6y9+2w+ARQrpn2xrnv/tFqYIMlDSN2k87zC/6TLbF5evRw4yjXvcvSlah4GjEyMVx/CrCuZaScZdXo2HwtX2RkwkyIgZEJ1oWkqi7RDxtGg9gOXQy4+PVBCaD3nJnF+BndTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8c58wkxU80oVDJsmu8MOu5pNkz9PxJYsYtN0vqXfDY=;
 b=fzHFoumGFlr4I1kva2xWcEySkWNfZQ8MstTew8pTdoyzFElIw804TI5muDhtdOy454D8UZOPxf/ZtryLZwZGfnNZfGduW31QqHeLbTETH7uxn+5IgazP+YER6DmYZg7Ll4NGuVa2wKAdughtpSjpHcf7QxZ1IoaCxxBkhz3txH7MZd1Oqsb0nR2LhjEfNxcsLeZwPxvjsP7yrn5puF9ZvlDAnHoMO61UGPkoDJMiTyloQFeBs6u7Jd9tmlg/jyVa9eDz80/TimscoyqvfI6TqqK8BWMpeBKpnW6F/d9OAJ98U6Luyquea+2yiw0uju2aCVuH233HIdPZT5vEY8ZgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8c58wkxU80oVDJsmu8MOu5pNkz9PxJYsYtN0vqXfDY=;
 b=CWvEkLSwGTJz0rwnZcq6JkJJu6OjSGhZW5wkKYQxDiULLEJiIvwWJN8+UJ5/piWyi8ChIGDDpUnLm2jaYnh0uKIaNiILiJE262N8+BezQGBpBmUiDU6ioRr+XhlWGMpm1S66Hqi0IsqdoxGRCpRlsDrohSlv+fBXVMREP9YUa8Y=
Received: from AM9PR08MB7276.eurprd08.prod.outlook.com (2603:10a6:20b:437::11)
 by AM9PR08MB7276.eurprd08.prod.outlook.com (2603:10a6:20b:437::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Fri, 23 Jul
 2021 05:27:15 +0000
Received: from AM9PR08MB7276.eurprd08.prod.outlook.com
 ([fe80::418f:7877:8c88:5b6e]) by AM9PR08MB7276.eurprd08.prod.outlook.com
 ([fe80::418f:7877:8c88:5b6e%7]) with mapi id 15.20.4352.028; Fri, 23 Jul 2021
 05:27:13 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Thread-Topic: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Thread-Index: AQHXfhHId+GcJ7DQt0CbtBH7VL2wwqtNMGmAgAETNNCAAGJ4AIABY9DA
Date: Fri, 23 Jul 2021 05:27:13 +0000
Message-ID: <AM9PR08MB7276B650897536DF9511E357F4E59@AM9PR08MB7276.eurprd08.prod.outlook.com>
References: <20210721092019.144088-1-jianyong.wu@arm.com>
 <87czrc2dsu.wl-maz@kernel.org>
 <AM9PR08MB727690189F03ED71450B8EB3F4E49@AM9PR08MB7276.eurprd08.prod.outlook.com>
 <875yx23h0p.wl-maz@kernel.org>
In-Reply-To: <875yx23h0p.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: D22A5EBE8FD70347A2F96F11E7CFEA45.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 37a1029b-b3f4-43ea-de96-08d94d9a8fc1
x-ms-traffictypediagnostic: AM9PR08MB7276:|DB9PR08MB6412:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB9PR08MB64129C7A688980E77E310BE2F4E59@DB9PR08MB6412.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2887;OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Qqh028PQOzY8bwxbLec4NcFjT7lsfW8+0tC7ZahsWeAjEsq0hQ0lD9jWVeV31TLszHDD9QFIbE7+wymCLCo5SBL/KrAGhD5WIZ5lmoLjxjbZiddI+v0JblHPi6mZ/W4FElnxnrA+V2VtAsVXVgFcc0DIk1hjMNZYlgJ391TJeEci/suRw+xYLl0tY+2/rUXxC9bbnuLPnV+3zrNIM6gcniFoC5d4zYPztgkQGkkzXiM5OTJ9ZPYdB95zpMkm/3HEuxvNGF61O1YG9oFfQ0+CxT81WK50bpsbVfRM511K0XMSPqBwVN6nujtmEH0Gpyv5SdpIcASsT3R/sKWTAPgZu229h6Lsyko7my1OJOlvrQPbG7VPAOMbbPwtUdZ+uWOD9uxRx6x5/XyCx6tihf+1qOnCaSm3eEIxwxFrhtIPbXtY6v90bF8hLtRBi2a1l0YL1oC4H+IYNAI3QhJGX/378V4bq7byUbImQO6DIVISm+zQ14WSy+wtUtLaUMlHzJdGcGPzBGk8P/g1ICsn/tmscPtBbKNMioiSmj0xWDq5SAwosnJ1D/+3bNK4NpnCRQIN3BNmXbuEds3rOy7kjzf5WBiOBfbGeJy6sRU679J3YnFBRdFJGwhPKbC1JkJ+RsdGiH9Mgvy/T3vfw/iNHeiDToc3QubFmXYMx5GEQhyGENktVPw+5mccgwGda/8mOYnb6H4ofA4tFcpgUaj98eM147BfF3xfp7o6vYDg4/35wxk=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM9PR08MB7276.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(346002)(39850400004)(136003)(376002)(366004)(76116006)(316002)(7696005)(5660300002)(66556008)(64756008)(66476007)(53546011)(52536014)(9686003)(66446008)(54906003)(2906002)(186003)(71200400001)(33656002)(8936002)(6916009)(83380400001)(8676002)(55016002)(6506007)(66946007)(478600001)(122000001)(4326008)(38100700002)(86362001)(90184004)(38070700004);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l1PYbqMpifL2B6+qQkmckpoK0CXNIdJq7v6PV4bRTXWMemSS7M+T3d8hlse6?=
 =?us-ascii?Q?jgookrTYsU601j2ZbPJ800CTTfeYvtlZV5uZ3ymkuHs116S3OvXJB4CorShI?=
 =?us-ascii?Q?acDhggPPBVM/QMX24qDWyzfX5qvgSrJr16Bvocm4OdmXVfMGqYYHAYZ+hMfN?=
 =?us-ascii?Q?3uhYQO9eKv/fWd5X9ktq0IDFbj/nNn/fESIr+8A/VmFGNuox+kCR3W7WaPf1?=
 =?us-ascii?Q?eFX6WxoQeD9Tec3ksw7i6WVCzcvBiX4+ADacEjhVM5+VePz6GDz3G/d5aPCs?=
 =?us-ascii?Q?+ffJkF1KTtT46XAWheEMquyYSISdkn4yO73in1m88miTyVTaNNRFy5Sf7YMV?=
 =?us-ascii?Q?dN/Ccrg9cCAVi0ZXMDYzHT4lVb0zJKZi1DWOExJL4EVkQ1PyqbPrAiDIjDLR?=
 =?us-ascii?Q?bgEIIoAEzBuKdjp4+LkfLkRTXUtrpBWHvSuGAoqLu+oSPI76oZgDKXxI+6Ww?=
 =?us-ascii?Q?QtUZ28UYjh6RrKfFmkkln8fALqCIIJuxvEx82m/Gzml6tOQDe9ZRG+UGpPB/?=
 =?us-ascii?Q?58o0XcGhL2LYlEUuj/ZBc9xHy/S74I+jR0gA3QRkU3oSZpe3uT6qsbuOjsNv?=
 =?us-ascii?Q?R5XP2gfSl6nWj2PFexWi6RM+bJgmMg0fMgTbmMgLgiLBKienpSdYpVfUInvV?=
 =?us-ascii?Q?MMzr4BZO608LIrHnJ3wRVZBRMhRPcPqTQzP4hbz2uYY1ttYdICheMwDygKnZ?=
 =?us-ascii?Q?u+nrq9++YerwRZ9q8Nc0Do4RmpdRM1ueJVMF7FNL5gKDi136CtLrrH8zBUdf?=
 =?us-ascii?Q?vDH0YBqpdfUVbX+fquqkEgFPQR31M8hqh3+mbgp3uO/2uhTftbrQp8Wjy8ON?=
 =?us-ascii?Q?6Dv/5YlJElJjkOyKWrFADrmCrmbnF62b8bMD+vIy6WbD7KE+pEEP1d40s9CK?=
 =?us-ascii?Q?xkxiYUr17cFzookcFwzV3ZJtvwp6x2JcI+zb9sNuW+kqdTZULwDDQseDG8vN?=
 =?us-ascii?Q?wl5syZ2lreP8NirKV7zZygmFUxhNBULP5pyHbtOoFr7Jx1Nv2Mb2+QOwOXnY?=
 =?us-ascii?Q?RZ0YKCrN3GIEtFDxMh5qkH7QhvuIOhERJyll7K0zelEf14aBqz5mO7AO3YG/?=
 =?us-ascii?Q?XBdmFzY7BCBI29QT9mOxYbiF+JxMIcAfzep5R/dQNIeLJsmeLpBXg2iFJqCC?=
 =?us-ascii?Q?30E/lxEDESPpGTobhoLi59s3tQ2b/0d4osYprs9CqP8CM7l2hH5usIlThT4D?=
 =?us-ascii?Q?dokpWCJixeQqIHpMRZE8k2gheiufV7IlJE1h+keYp+sXqCJAilxkV3fAbqMy?=
 =?us-ascii?Q?14T130amJb5C224RlAGzQkv4/Egz7SdF7Byn4MMTGY6nfPwBPZSaxJYZ26KO?=
 =?us-ascii?Q?Wr3mnCZksqIX3hX7/FwCBali4HYjoszbczbK5/ZRPDxRs4GDmyhh1RPYX+cn?=
 =?us-ascii?Q?H6vMQqsDMaIsQ4/K7zwvvEvS6Yyc?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB7276
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: ab70076a-2b33-445c-f0f4-08d94d9a875b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aujtR+D634ac+znNWZSXRqJtjnT/T8ul1MIltzDSgHxZj50z4Erj0vDyzV1ZuOM7i4UfRYsbenRfw6ksBLrtJMxvRljK1ze/srXcgBiICA2kHKdh75oQYfXWPES8hbjLQde08Nw2lAyJcycFAg1AjVii+R1GnYO7j/o/la89U9B2rYn4eeVTfNyE6iA6oSvtRQsnpIMBH4rdVrkbzqXmSiRnROx8lgqEdg9Jd7iGDC/XIkGYRpTVgk+PZ3q6Y5cvHn/y9TotOKel2e4ko0EFQAdLjcIcDRc09OZYgTG4p6jQZIBigPjAV1M6+jLi5gwFBu0OEzlDBWXfhr8upDmt7gbMN4odDIFY11NrgrJz4J/Jw8y14zqzTLWfksiVer8I07jrjd2F9zj2VT7Htd7se4PZXPEONTD5F26+S0tSw+LCVnqqSWI3SIIjY2bDo3yq/0Qoum8zT4LVECSioY6ihf5Qy5PareCChNLlxGwE1ea5xKVVFs0Kk2pONvRTbT2bSYH+ISNTXOWVdrAjLoHtFV8Cr15OieB2CsTRNW0glE9BaMKpiJlZ7YnknJDigUyW9A6wg5RnomJKhik7zRPlMxFhhFFShoGCbrgM6ePqD27v5SL5jGHnsIYF+pJc/YnU+l9UjER2hg0+SB2A/gE8LKN7nDisHd7NLgMYHHYxVsbKI/1Oy8mw3iaGpmGqi9N2mH8gsRpPkRSJb5ZnCzlAAKWybJoB+2h+iguIePU+k4k=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(39850400004)(376002)(396003)(346002)(36840700001)(46966006)(70206006)(47076005)(52536014)(356005)(81166007)(186003)(8676002)(82740400003)(6506007)(316002)(9686003)(82310400003)(55016002)(53546011)(4326008)(7696005)(336012)(33656002)(6862004)(83380400001)(86362001)(5660300002)(478600001)(26005)(8936002)(70586007)(2906002)(54906003)(36860700001)(90184004);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 05:27:28.1205 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a1029b-b3f4-43ea-de96-08d94d9a8fc1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6412
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 Andre Przywara <Andre.Przywara@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lushenming@huawei.com" <lushenming@huawei.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Get it! Thanks for your explanation.

Thanks
Jianyong

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, July 22, 2021 4:11 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: James Morse <James.Morse@arm.com>; Andre Przywara
> <Andre.Przywara@arm.com>; lushenming@huawei.com;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> <Justin.He@arm.com>
> Subject: Re: [PATCH] doc/arm: take care restore order of GICR_* in ITS
> restore
>
> On Thu, 22 Jul 2021 03:49:52 +0100,
> Jianyong Wu <Jianyong.Wu@arm.com> wrote:
> >
> > Hello Marc,
> >
> > > -----Original Message-----
> > > From: Marc Zyngier <maz@kernel.org>
> > > Sent: Wednesday, July 21, 2021 5:54 PM
> > > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > > Cc: James Morse <James.Morse@arm.com>; Andre Przywara
> > > <Andre.Przywara@arm.com>; lushenming@huawei.com;
> > > kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; linux-
> > > doc@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > <Justin.He@arm.com>
> > > Subject: Re: [PATCH] doc/arm: take care restore order of GICR_* in
> > > ITS restore
> > >
> > > On Wed, 21 Jul 2021 10:20:19 +0100,
> > > Jianyong Wu <jianyong.wu@arm.com> wrote:
> > > >
> > > > When restore GIC/ITS, GICR_CTLR must be restored after
> > > > GICR_PROPBASER and GICR_PENDBASER. That is important, as both of
> > > > GICR_PROPBASER and GICR_PENDBASER will fail to be loaded when lpi
> > > > has enabled yet in GICR_CTLR. Keep the restore order above will avoid
> that issue.
> > > > Shout it out at the doc is very helpful that may avoid lots of debug work.
> > >
> > > But that's something that is already mandated by the architecture, isn't it?
> > > See "5.1 LPIs" in the architecture spec:
> > >
> > > <quote>
> > >
> > > If GICR_PROPBASER is updated when GICR_CTLR.EnableLPIs == 1, the
> > > effects are UNPREDICTABLE.
> > >
> > > [...]
> > >
> > > If GICR_PENDBASER is updated when GICR_CTLR.EnableLPIs == 1, the
> > > effects are UNPREDICTABLE.
> > >
> >
> > I think this "UNPREDICTABLE" related with the "physical machine". Am I
> > right?
>
> No, you are unfortunately wrong. The architecture applies to *any*
> implementation, and makes no distinction between a HW implementation of
> a SW version. This is why we call it an architecture, and not an
> implementation.
>
> > In virtualization environment, kernel gives the definite answer that
> > we should not enable GICR_CTLR.EnableLPIs before restoring
> > GICR_PROPBASER(GICR_PENDBASER either) when restore GIC ITS in VMM,
> see
> > [1]. Thus, should we consider the virtualization environment as a
> > special case?
>
> Absolutely not.  If you start special casing things, then we end-up having
> stupidly designed SW that tries to do stupid things based on the supposed
> properties of an implementation.
>
> We follow the architecture, all the architecture, nothing but the architecture.
> The architecture is the only barrier between insanity and pure madness! ;-)
>
> >
> > [1] linux/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
> >                                      gpa_t addr, unsigned int len,
> >                                      unsigned long val) {
> >         struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >         struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >         u64 old_propbaser, propbaser;
> >
> >         /* Storing a value with LPIs already enabled is undefined */
> >         if (vgic_cpu->lpis_enabled)
> >            return;
> > ...
> > }
>
> Do you see how the kernel does exactly what the architecture says we can do?
> Ignoring the write is a perfectly valid implementation of UNPREDICTABLE.
>
> So what we do is completely in line with the architecture. As such, no need to
> document it any further, everything is already where it should be. If
> someone tries to write code dealing with the GIC without understanding the
> architecture, no amount of additional documentation will help.
>
> Thanks,
>
>       M.
>
> --
> Without deviation from the norm, progress is not possible.
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
