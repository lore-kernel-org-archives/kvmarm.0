Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3DEC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 14:32:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B9249ED0;
	Wed, 13 Apr 2022 10:32:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R3NFl75n69aQ; Wed, 13 Apr 2022 10:32:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88234B0ED;
	Wed, 13 Apr 2022 10:32:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B4249F28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:32:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XqyJ4biKp9ln for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 10:31:55 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4971749ED0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:31:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeX6CdcDvBFz75ubqUKjPtDQHKTA8YoXmmKNPHcbXSI=;
 b=B0uLTzgK14Idum1BDximv5h2CcPSp/Cv0mQhHlHl7LsPwaI5YZSNS25mgDbxxPN1iaGV9MnqtoZ/aHooDRBPYbEbdhWJNKPyMICeYDHj6pg2p+chQ9G9eDUyt0+Tnn7D6g2PkjaeQza1ZpUWHBt4jsckyTsNKkh4jFtC1/+7dqU=
Received: from DB6PR1001CA0026.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:55::12)
 by GV2PR08MB8001.eurprd08.prod.outlook.com (2603:10a6:150:a9::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Wed, 13 Apr
 2022 14:31:48 +0000
Received: from DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:55:cafe::23) by DB6PR1001CA0026.outlook.office365.com
 (2603:10a6:4:55::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 14:31:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT004.mail.protection.outlook.com (10.152.20.128) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 14:31:47 +0000
Received: ("Tessian outbound 9613c00560a5:v118");
 Wed, 13 Apr 2022 14:31:46 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3b8ace3b9ad138d0
X-CR-MTA-TID: 64aa7808
Received: from 1cdb946d2832.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 3D74F195-8975-42AF-A94F-B26CBC81F1D8.1; 
 Wed, 13 Apr 2022 14:31:40 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1cdb946d2832.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 13 Apr 2022 14:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeAM8+ed2QIE7o6gz5bRyGEFpn+J8OzriyP+by8n/fY1YOSw5UMPyEpsuT7492xW4xJJgUVL3IvyeWcdAxkgfaZDpMHR07UoVuhNjoGwFlMIP8Fmd8Xdq27GYNwyIBl1RhvXWcLEfSR361vzsYgnG6YfZHXpxq7Aq7s3wAXNLWkKSsPXlIRG17eszLviHWX9KfiZOJuBoHHTLchNrDt1otT+0O5J3QmIGyBEOxKmgYgs3Kh/fCSK3Oy9txM9+QytwXoc/1Wtn8Wx63JTEeqnovTlhDEwt1GM7IWbEeBnwSPeCSqW7w2/bgGTG7gBsQZ3Ci54oP4Ccxu0oIRASjIPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeX6CdcDvBFz75ubqUKjPtDQHKTA8YoXmmKNPHcbXSI=;
 b=EGNAG992Sf+4hrfBPMu9ktz6dIp4yIklkQZci0EdGiGg+ByH2CZnsqgDhM4a8y5eQHBOVE0tPBCt2mv1pynmnzv4kSC/MilJB6uxvfb5DLGRr+9YaHcfRwJeIpCnO+gUJUZtlcfRfSyovX8ecqHWkZb3I0MyoAs9OzxQ5/nRaZGtuq7FC042/Ri54yTsfAo1YpBeeJhx2U73kXjdQ3xoRtYGOk4Q4M6dBX8MHPj6G5Zeb2KesirFYAHzr0vpQUfb9+3n+s39ml1RJi3bTrIhL0gpF5UxsSDWQj/F0JKwZHGaVjuaQ3ngokxNwdBt2RIakHCIgz8YFLUR1YXPEIkiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeX6CdcDvBFz75ubqUKjPtDQHKTA8YoXmmKNPHcbXSI=;
 b=B0uLTzgK14Idum1BDximv5h2CcPSp/Cv0mQhHlHl7LsPwaI5YZSNS25mgDbxxPN1iaGV9MnqtoZ/aHooDRBPYbEbdhWJNKPyMICeYDHj6pg2p+chQ9G9eDUyt0+Tnn7D6g2PkjaeQza1ZpUWHBt4jsckyTsNKkh4jFtC1/+7dqU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM6PR08MB3959.eurprd08.prod.outlook.com (2603:10a6:20b:aa::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 14:31:38 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::6092:f7f0:3af2:fbca]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::6092:f7f0:3af2:fbca%6]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 14:31:38 +0000
Date: Wed, 13 Apr 2022 14:31:24 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v13 04/39] arm64/sme: Provide ABI documentation for SME
Message-ID: <YlbevBvj05ys2vlm@arm.com>
References: <20220408114328.1401034-1-broonie@kernel.org>
 <20220408114328.1401034-5-broonie@kernel.org>
Content-Disposition: inline
In-Reply-To: <20220408114328.1401034-5-broonie@kernel.org>
X-ClientProxiedBy: LO4P123CA0482.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::19) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 4ce481b1-1f11-4f54-cadf-08da1d5a5749
X-MS-TrafficTypeDiagnostic: AM6PR08MB3959:EE_|DB5EUR03FT004:EE_|GV2PR08MB8001:EE_
X-Microsoft-Antispam-PRVS: <GV2PR08MB80010646FB1A300B3FCF33EBEDEC9@GV2PR08MB8001.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RMVwzZIbWpB+8UwgbZBZ8t/b84z5dpul/dkFbgDtCbrDsVzYVMPH2DNjkNaeWtJPdRm++2wX4K55Ba0xAHKtK4KGjwqaokj7CcFZH9PoBeXryYhXbzTehQDN4Tg86uUvQuAi1a9L2vFGgI9VlD05FiWzv+419jCwj2Hxpabk1PDy7ABVaLuZvHrkehVYY9FdMhCD/IRFCMbK2XJ0EF1U0na5aLKdw4OmCBoCeUKwPzA2DK6qDlmna9wVDZAZEoFBcWSe4U9OP0a7Jj/QMhMbmS785Gih13WDaQ5aDx1M/Dk88uDh77RpJoArIPjLRQWbor3qxRYAP/mG8fq4zTuJFUkejkkbBonQvmWzWhBEE/Kv1XrEv9wgUP+Gy7pwpDedKC/ZRQ8D2Jyic9rOQ5eq1+B64Qk1gmJpP14qc0TbLPEatEyqrUc4kaMaXS2evdWQWmTHlmREBzRMdQZ/ycvaplnT+p+kQ+6NSbnJ4Bl72Ut+1yJ3yB0g26QyQ1t2W7Ejq6jZr4gKouL+ZqboMEXee8dYmaM/jQuLJqyOWFdSIQoDJLi/pg40ynKOFTec8m1XcXwsP+aYM4xLoMcAtr92lQ6OPpekNT6HPIUqOsC2BHDjhdQXaDg7H3ksCNNNfDkJ5kToDisO/HjgKswfcDPIgA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB9PR08MB7179.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(6486002)(8676002)(2906002)(6512007)(2616005)(86362001)(26005)(186003)(6666004)(36756003)(6506007)(508600001)(38100700002)(4326008)(66946007)(66476007)(66556008)(8936002)(4744005)(5660300002)(44832011)(54906003)(6916009);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3959
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2c71a9cc-23aa-490b-ac83-08da1d5a51c5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ccjbQXxYaKcSLYVuadFqacJwF/J7BkL4re0qB1dspIWv3wv4KmGYLsuQJXkj5CKC2DSUrqkTfLQ9h6c5zQwz34VwI1ip+hcagh1xoQp8hup1rinD87S7o4LzxL6lg9CerZuoMaQNBSkd1DEZWplKHgJAxBf24/d+uoLnDWTeC6d+UbgrEOSAHEad+K1T91dJCIX8jhGXBYuF4BzS0oSMLW+c9DeGQ+uTKl0kqs9KHj7P+Dqcb1wy2E4+Wzn7DRiIMpdXJ/gk1VG4pxUuxmxRUcX3diu0s0GE2WhGzpPA6038zaJjeYdXbE5h1EACc3qG3zzC91ZT1wyB1fxlDvv23kbBy4IHcuNv4dB5uTVhalmP/gQaTRTUoYEDY0Wyp3ltJLOhMcHPTiXHIAp1Hqg8NVUku5vZbqgS9NNRsTx3HWXhWSgwK8Nc7saD7V4hRuB5dFZiPeE776pt81oBXCw34zwIP/N/z0TV5K6R4+1D5DNiz3Nu+M27QGJbLwsmdcX5WiVpWCs53oVdyaH9GVI+0yF44YWscbKy5ureQ8dQ/bNw1Lc/HJaD6F6NTZ4nhczliqSq+iL/w5/p1md17lfxUb5lhL+tSBeVFofCELGCiMXdHu2qrii+iKVe61FBRKQ6hkW2ugUZXT0JuC2TCvUUsu0juiqEhhuk7GzU4LJSKG5h5i2/vlgirXbvuYI72/b
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(44832011)(5660300002)(4326008)(6862004)(8676002)(70586007)(54906003)(6666004)(356005)(336012)(81166007)(36756003)(82310400005)(36860700001)(2616005)(6486002)(508600001)(6512007)(70206006)(6506007)(186003)(47076005)(4744005)(26005)(8936002)(86362001)(40460700003)(2906002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 14:31:47.4437 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce481b1-1f11-4f54-cadf-08da1d5a5749
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8001
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

The 04/08/2022 12:42, Mark Brown wrote:
> Provide ABI documentation for SME similar to that for SVE. Due to the very
> large overlap around streaming SVE mode in both implementation and
> interfaces documentation for streaming mode SVE is added to the SVE
> document rather than the SME one.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

looks good from userspace pov.

Reviewed-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
