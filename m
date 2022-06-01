Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DA8C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 13:41:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F46949EFF;
	Wed,  1 Jun 2022 09:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQ+XfcWvSESi; Wed,  1 Jun 2022 09:41:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7D304B206;
	Wed,  1 Jun 2022 09:41:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3C04A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:41:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YcJ3YRPBVFC8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 09:41:08 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECF9D49EFF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:41:07 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=Z1GFbojOA53VR8cBUY/avrlrBxo9On7bVC4pgXBXY04rG5JdT+C4KVwNCJ2KP89pvTxNxOPmEhodzRGW5HQqcnOWVyj3uYVwacSaV0AFQTZRsnrymXON66hRJb1KPIGvY247HG66A7CmSgE9J1HRfVPOZsyyMxXeAL+sloHSvfwh3qd2x1+wcMQQGbhOSU131aKYuOmBiPMFmCN6La8Md8UavSNe96mzmOUg98g5+y0Ngsd7ZZoSY4LxzIM2aJYlLYxaKd9KpRVTiLGaJeBn9aZnpkeVxNRlS4xyEJhy4eF0EWaIZ4kVMz2/QztCsss2zOsn+8Nxn02/0Wbo+lcZyQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3WqEUZG+d3VzqqL/z7IPps46fiyucIyl+MFuLUGc5Q=;
 b=g62gFYYt5ClkvqQPWzMmVcSPbVSn7AC+Qd9lxKZ331/s7rojf9DnMIzDA/y/NR3CWUdqjp64kOMVrmslucTV/eiptDeTOd9+zzRax9ebZ5s6ieaZ1MAw1mCPJ0cfToMZgrQQtlNDXI7YeQetck0/YwDHWhhIbGNg/W+c/Att7XDk2m9QHtFLNJGWpq3BF8zJGJ2pQcJhPyW9nvYRv4aB8ce0s05bdu3l4SFga/cqOjDK035BhMJyFeAR4pXITOmhZKJl40E55/chp+CmP46JH0MNV20RoxS6rkAFUM8Max/7BfrGUYxzULlWqG/+SiiTOprOVZBfAuv4Wpn4+WlJoA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3WqEUZG+d3VzqqL/z7IPps46fiyucIyl+MFuLUGc5Q=;
 b=tZBlSa8CV6c9EY3mt5RMMUt3XQXtcfVPn2ndTgz+Pkh54r29/u/nliN57CAXAmNuJ40A649QrZxo38ojlfp7f98XmagOT4fL31K2xImQqkGUDeyxzUWB3Vntln+5KVdUPVhkOCdVJjJneAWqkOtPcmi2FxPXeiYbPfxPzX538HU=
Received: from AM4PR0501CA0053.eurprd05.prod.outlook.com
 (2603:10a6:200:68::21) by AM6PR08MB3253.eurprd08.prod.outlook.com
 (2603:10a6:209:49::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 1 Jun
 2022 13:41:04 +0000
Received: from VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:200:68:cafe::a5) by AM4PR0501CA0053.outlook.office365.com
 (2603:10a6:200:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Wed, 1 Jun 2022 13:41:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT058.mail.protection.outlook.com (10.152.19.86) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Wed, 1 Jun 2022 13:41:03 +0000
Received: ("Tessian outbound 01afcf8ccfad:v120");
 Wed, 01 Jun 2022 13:41:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8c5b7d0bd4a3d5e8
X-CR-MTA-TID: 64aa7808
Received: from 1c81e86d7496.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 9F077053-2CB1-4ACC-B160-223071160FCD.1; 
 Wed, 01 Jun 2022 13:40:52 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1c81e86d7496.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 01 Jun 2022 13:40:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihCYqA5UbqtOjJHXpIBOLtZuR5fECjmCnas7fs+nj2v+OVF+uP4lZdHjVba5/VfMAu4EGk/SQnY/B3o3dNPeWl+UjA+iH/MyYxyidM5RM0Z0UOui6gv9PWNLKuCYmngvlvvc0RdeFAwMjIn6F6QpgFXwwvviCeMfQQgu5/T0u9nWASaceg5mBG3Z05IUvy437BKc5xqsFGcytSuLe4GeaW69wZU5khcIFbRJ99kE3/r7nLlQlDb3M3IyKKWboldw7C8genunYyG/6LD++I8Mf2vLqc5DVeLeHegLfYd78cghGHKq5TomLstedqQrImA6LlGvG/uQvV3hNZfYtLE5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3WqEUZG+d3VzqqL/z7IPps46fiyucIyl+MFuLUGc5Q=;
 b=IdLTpjdOGejHVz70FmuzY2ivKIEwO+cYyVPxpEkHuiZdkTJpkWVzJh3rRY1oLg3p64GWplm6Qp4wiOIO3CvHPDJSCHHwaycgEGJjEW9z2OLhsBIhbkrE8yA7XMRL69rzS7tS6BfrB7DnOtu8/HQLonTM6ToJQsjHqiwx3eD5uokODS6dSxyxnc4TqQ0nyDK6K0AENOU0W6Pj/8DPQLPl1VezBHedVkeWHq/qA3pBc2OpvJ45qIpL8RXHFqFk+ZAG8le/AzooVCXBVwLw+dFhAAO8Kv6YYjOL58x5vShFilEY6N1+Ek4kGLAsNe6KhGDyfxGXIA0r7+9AwmwiS5TBEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3WqEUZG+d3VzqqL/z7IPps46fiyucIyl+MFuLUGc5Q=;
 b=tZBlSa8CV6c9EY3mt5RMMUt3XQXtcfVPn2ndTgz+Pkh54r29/u/nliN57CAXAmNuJ40A649QrZxo38ojlfp7f98XmagOT4fL31K2xImQqkGUDeyxzUWB3Vntln+5KVdUPVhkOCdVJjJneAWqkOtPcmi2FxPXeiYbPfxPzX538HU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB3762.eurprd08.prod.outlook.com (2603:10a6:208:100::25)
 by PAXPR08MB7140.eurprd08.prod.outlook.com (2603:10a6:102:208::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 13:40:50 +0000
Received: from AM0PR08MB3762.eurprd08.prod.outlook.com
 ([fe80::c585:5b5:f572:e75c]) by AM0PR08MB3762.eurprd08.prod.outlook.com
 ([fe80::c585:5b5:f572:e75c%5]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 13:40:50 +0000
Date: Wed, 1 Jun 2022 12:09:06 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 kvmtool 06/13] arm/arm64: Fail if RAM size is too
 large for 32-bit guests
Message-ID: <20220601120906.3f844254@donnerap.cambridge.arm.com>
In-Reply-To: <20220525112345.121321-7-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-7-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
X-ClientProxiedBy: LO4P265CA0161.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::8) To AM0PR08MB3762.eurprd08.prod.outlook.com
 (2603:10a6:208:100::25)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 1cc51dc0-dea0-471c-cd98-08da43d45f7b
X-MS-TrafficTypeDiagnostic: PAXPR08MB7140:EE_|VE1EUR03FT058:EE_|AM6PR08MB3253:EE_
X-Microsoft-Antispam-PRVS: <AM6PR08MB325315ABEA82F473F078C6239DDF9@AM6PR08MB3253.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Vj4pgyZYJymOV9mQ2K1L9FCmc5rJh9im32AEe8G4nxFthB28K/oRskiOHKU/IG4SOFYdLzSjDCdOgZ8vHf4uKUxCE8nvNV+x895Tw6lSIK/tygxrcqiZy50oiRKXAgKZlKkShMOpN/kTzNE/gHIAhm6l/8Hskjr+ZJdKvAeQOyZyxLoAfEN5FWjqApHMLof8VuhssRLibtxhaBKdUx1h7VlgnRwggo+rDQgsMNGtFcWHfGjyea/Z9/0rTh43Yn3PffdzLL3im8Ip39RdRpYO1UFZh2oMjlKNFNFP4glhd9+xjKoGXiyzFY29pt+1ifIxqhWxTF4BLIOfT6vNJVSFGzOarErmSM3rq+6T1TweDOV2nNsLlZtJMhjE+LZhC3AlFcWu3GyWhvxNIV7AFOCDSJvSjybXlARBlQmhjUiCTj/wPsx/v9hS/c8znvuRMiLepH5gq5WjH0ebLbQ4j9ONgZ6Zleqg9s9mJBP+VuBF8lxUNBMP3jx+Q12YgM832OyEa4bm0hNttKz2O4d3WSmBIcXvs82KCGr2R5FqUlW0wveMLLXm0CjQ5YqzvanpOEmW+QYIE9fUcLVq52MRLjq0twNlzX4cvAvW6aPkfCfJeZskGWg5sPgklHuGZOEoheZ+xexuqALGZP575OrIj8qU7A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM0PR08MB3762.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(6862004)(8676002)(4326008)(6512007)(66556008)(66946007)(6506007)(66476007)(186003)(26005)(5660300002)(6636002)(316002)(6666004)(8936002)(36916002)(44832011)(83380400001)(38100700002)(1076003)(2906002)(6486002)(508600001)(86362001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7140
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9d92875-5d31-419d-d02d-08da43d456f4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRAyvYYT1n5Wgx7XbbP0kbWgXPNq298pLCsqRc1XqZTEhMWltQ2KaTFnCKItKpL+GWEQc1x5uWOA05te8fVFOBPBc2jsWPy43uuniEnX3Qou7F2UFSYN4CmIRWzMkwbdJecCdK5EFNYOKXhPh38Wkg1mCac/2bkyzQHlQE3X1DilbOcTWr8KaumNtjCK92jaFIxM0weRJxdtnX+Bv16NCGK1YsCtsiypXs5tGJu0YIXo/k0kHuTnyExIJLCh33B+Tr9tJLSdOZZla0glJ+xQPCRwI+OGMZE1ABhY3ExtwMGV+Ss51CthzYSlN0hEWpJEWoBcB/UwfYct1KBpwc6GoaNLjJVToSU0Jtg7q2pjdX3NB9nauWdAespAmnOQr6dSSYsKQk1S5cgGr20TESwHyRaUokH0IZdqF3xbNuy5PdElDcHY3yyXsRXBaokPAx9Uw99bRR5UMvQCSvaDo5SsgVB/hIyDBl0rvbkAHMTo1+biQzeXen7N7bMKh8DTVThIDV5kWq6VSA/+/wwRkEumIm5+cQyf5h5EVn4OlPtcj65hmD3fAaEQSA904SfV6+alDJ+3gmOB5RpG9Wi5c9uj5gStjqteDDhRUpzWIJh5CdUHU5jZk+0/tjWB3FgfyYnLhfAK0rOEVXrDVYTPXAJbR6C6wLymp5tO7nyPQDWWAKj4mPraZwBQSV3F3Te8LiCU
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2906002)(8676002)(6636002)(6506007)(44832011)(26005)(6512007)(316002)(5660300002)(36860700001)(6486002)(508600001)(47076005)(356005)(336012)(36916002)(81166007)(86362001)(6666004)(186003)(40460700003)(8936002)(83380400001)(70206006)(6862004)(70586007)(4326008)(1076003)(82310400005);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 13:41:03.9345 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc51dc0-dea0-471c-cd98-08da43d45f7b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3253
Cc: julien@xen.org, maz@kernel.org, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 25 May 2022 12:23:38 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> For 64-bit guests, kvmtool exists with an error in kvm__get_vm_type() if
> the memory size is larger than what KVM supports. For 32-bit guests, the
> RAM size is silently rounded down to ARM_LOMAP_MAX_MEMORY in
> kvm__arch_init().
> 
> Be consistent and exit with an error when the user has configured the
> wrong RAM size for 32-bit guests.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

This patch looks fine, as it improves the situation and maintains the
current support level, but it turns out that the AArch32 memory limitation
is bogus: With LPAE (which is mandatory for any system supporting KVM),
there is no reason we can't have memory beyond 4GB of guest PA.
In fact, after removing this check, I managed to boot a 32GB AArch32 guest
just fine (on a Juno), and a 2919MB guest on an ARMv7 box.
It might be useful to lift this limit, as this allows easy testing of the
arm(32) kernel's highmem support, but this would be a separate patch, I
guess.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre
 

> ---
>  arm/aarch32/kvm.c | 4 ++++
>  arm/aarch64/kvm.c | 5 +++++
>  arm/kvm.c         | 2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
> index ae33ac92479a..9d68d7a15ee2 100644
> --- a/arm/aarch32/kvm.c
> +++ b/arm/aarch32/kvm.c
> @@ -2,4 +2,8 @@
>  
>  void kvm__arch_validate_cfg(struct kvm *kvm)
>  {
> +	if (kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
> +		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
> +		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
> +	}
>  }
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index ca348f118a56..2134528bf7f2 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -39,6 +39,11 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
>  
>  void kvm__arch_validate_cfg(struct kvm *kvm)
>  {
> +	if (kvm->cfg.arch.aarch32_guest &&
> +	    kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
> +		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
> +		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
> +	}
>  }
>  
>  /*
> diff --git a/arm/kvm.c b/arm/kvm.c
> index c5913000e1ed..af0feae495d7 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -65,7 +65,7 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  	 * If using THP, then our minimal alignment becomes 2M.
>  	 * 2M trumps 64K, so let's go with that.
>  	 */
> -	kvm->ram_size = min(ram_size, (u64)ARM_MAX_MEMORY(kvm));
> +	kvm->ram_size = ram_size;
>  	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
>  	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
>  						kvm->arch.ram_alloc_size);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
