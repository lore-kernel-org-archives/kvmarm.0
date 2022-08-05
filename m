Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96EE7C00140
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 10:33:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1694DCB8;
	Fri,  5 Aug 2022 06:33:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C96pmP3JvQff; Fri,  5 Aug 2022 06:33:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2B44DC9A;
	Fri,  5 Aug 2022 06:33:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A08304E005
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 06:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kzYlOpvdMWcu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 06:18:45 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 861534DFB3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 06:18:45 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=go/Kyf6kE0TBZV/z+YbmSZureNVmcotORBAP/xLmLt6EmMg9E+v20E4ONo0jdlQsQKTpmGzONbEeBiXZyMG9jzKm96jaoSEzrYuNO2VsEIjFMNpY9N6yenJadyCpDvOupHiOKnVYpHGb6NDNBg8uEP5nCOCGaJ1DFLmD2fTG7AcUYMF8GC3QmmqhnqkH+DJ3rKaciXu0ab9aRZ5QmrRlqlx/epBFQLi9wSr5zsVjEIvPWThTNVV1E0/WRYs6xll81vJCJ1IGAYLX0BzdJt57b8E5PXf06hV0alcmVflsVuvD2mJk6SfBsDqs8Y+SeGlUqvcmxWtfunRXwEK58aa5/Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5Z4uuc8//0yI+LqlknEsQkpuJX1hNeff3QehyEIC/U=;
 b=J5QdEBBenqtC270gRDId9OmlJDDTSV/m+LPMAqT9A73uI3jEYGryRcWSoxQNawX8e0eob4i+rGhLkMgPzReIAEYHey4SoKvfjRmsrM0Z/rI28kfwu0kIaUwZF1e2cgI4wD8NS047B/oDwu9XLvRjYP36X2M0o0wksi4Pc3qGVBBN2x9YVtHVnEaJIFSrFS19IDReM7GKL1284il2MQoiWzGhQpbJm9M0hbY1GKD12s5CYGZJ9l6H4KAdCxuaakrpzl6irtSOFywYL8EfeNiCsGRF4R0ZPGpUx/OH9+HlMzGaJ/ZPvLDvmAxiux3ae4PIUJLe1yjZSbAhfp9ZiDAE2g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5Z4uuc8//0yI+LqlknEsQkpuJX1hNeff3QehyEIC/U=;
 b=uvD/TcLArrn56R7f64zXvVnpRZ4AW+LtMhCgOmv10EaTFlNJ6yT1uHvO3oN4nrpd1gMdYLY4tGVGcARbBH3wu5J79GBNa4oRcb0M81HOhE/RufV1Mw1TphrZ5eJgDUjokLyHpWOnIqajTBnCj9rIZHulUt1eEBVxsh/sD4xWWSU=
Received: from AM5PR0601CA0037.eurprd06.prod.outlook.com
 (2603:10a6:203:68::23) by AM6PR08MB3960.eurprd08.prod.outlook.com
 (2603:10a6:20b:ad::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 10:18:41 +0000
Received: from AM5EUR03FT019.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:68:cafe::93) by AM5PR0601CA0037.outlook.office365.com
 (2603:10a6:203:68::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15 via Frontend
 Transport; Fri, 5 Aug 2022 10:18:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT019.mail.protection.outlook.com (10.152.16.104) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16 via Frontend Transport; Fri, 5 Aug 2022 10:18:40 +0000
Received: ("Tessian outbound fa99bf31ee7d:v123");
 Fri, 05 Aug 2022 10:18:40 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9cbaa70b9bdd6e2d
X-CR-MTA-TID: 64aa7808
Received: from 65659bf3460b.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 A173F2A4-C13E-4486-96B7-2CFED9D74B7D.1; 
 Fri, 05 Aug 2022 10:18:30 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 65659bf3460b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 05 Aug 2022 10:18:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+jfp+l0yMNa2zGlV/P9vWdYQuwwhG3nWqK1+C6/QEw8TrZ/bj6IWNajC2CrY6DlD/yKOdEFpFmWmutDLPm/tpjkx/toIAeCywpg84Lt03BLTq2mTEOi5iIM13AiFIy25p6kGz7PcfijoJm+soJn2GhArrPeVnnGY3aKTTYgZgPQWm1P6snHpzQDtqr16IEgT74PQz+lhVH84B+osMs68ih+/OM6F9/vj/g/86IC1nAw3my2WEcoGLnBR7QkDafPJqu4utBgFkw+cgr11fdJVIbm3x9px49hOKAkfE7zZQSjYP++4TVNJEYTwI1Od3vxyNJZCKjhBHWaxELE8e6oIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5Z4uuc8//0yI+LqlknEsQkpuJX1hNeff3QehyEIC/U=;
 b=CVH35o/mW+7HO02pVV4VJ+ARu1FG8D5yV+Yx954bO5yKbSN18NrbxShuYa1wLo3sJ6YTDXrQqmApZP2IfjeQJRI/E/r2UwSo2p46Z1ILWEkpMellFlawXlOpZLywjCykx+7eIEsX9xuXZMUIcPDS6MtJ03jxu2WaVJvS61UbZDbwnqpvEOCqMiRvQD8okHIjWOichVDhKU82+KS4bcEZzoJ193se+/NJumeODP44jgz2bJO/qKielRC+sPsMWwAZBKjMOwLQkPQ0TK60CfRXLkcdMejqHuVhkUFlSj49hCfE0jgQGqdSOahpc1c9QEgSQdgnykVDrA5JlMw9YHQWQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5Z4uuc8//0yI+LqlknEsQkpuJX1hNeff3QehyEIC/U=;
 b=uvD/TcLArrn56R7f64zXvVnpRZ4AW+LtMhCgOmv10EaTFlNJ6yT1uHvO3oN4nrpd1gMdYLY4tGVGcARbBH3wu5J79GBNa4oRcb0M81HOhE/RufV1Mw1TphrZ5eJgDUjokLyHpWOnIqajTBnCj9rIZHulUt1eEBVxsh/sD4xWWSU=
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com (2603:10a6:803:7c::27)
 by VI1PR08MB5472.eurprd08.prod.outlook.com (2603:10a6:803:13b::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 10:18:28 +0000
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c]) by VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c%4]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 10:18:27 +0000
From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "drjones@redhat.com"
 <drjones@redhat.com>
Subject: [PATCH] arm: psci: Add psci-off functionality
Thread-Topic: [PATCH] arm: psci: Add psci-off functionality
Thread-Index: AQHYqLS0QhGIHprrL0iQrENo3u755A==
Date: Fri, 5 Aug 2022 10:18:27 +0000
Message-ID: <20220805101812.400235-1-Nikita.Venkatesh@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-MS-Office365-Filtering-Correlation-Id: ecbf5ec9-bc8c-4c13-c419-08da76cbde7f
x-ms-traffictypediagnostic: VI1PR08MB5472:EE_|AM5EUR03FT019:EE_|AM6PR08MB3960:EE_
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 515SbVDgLFkinSkDAmMBsHPOaBWvq8YzdArZxkhLhNzDzKBunfAh+o5SEaLFF+zhcJNx4B8qoTAMk7Kxc9gjGeZzVt09Eh6/0+UFj763RHSJigV50jXyScfxCHwp+5pf1dFV4eJ5vpSimzxAAO7tcfr5BXhVP81EwBjFcqlFHE4QuAS4aP8uUqomPJbxf7M14T3Ot26ZzXXzdBwh5cWQDhm+WP/OfON35hwBvwU6jV4nrR6/jSZcPH7nk+JkyNjYDY2Rs90QujRSLZdocgfT1ISzdcrty0Rj6ecHHkSBN4A8hTuXq0dNTZhGn+/9oJZfUoisPFACDKpNA4v3vwOQI8bdNv0aDFxdKLXLQ/yqiBHL4jqLqbFesKIv0RJQFfMFdWhYP178F5CFdOrpGq7rUdE/+9XD7ZkNrqI3jUHrW/AvQlVKxvEzRfbxAQLSQuWFOHA3K5ADgcPhSLr30VUJYvCzEaQUlNXAct7fGhqjr30MSBNeGvncnknKjZT8MI+lRuzWOa8ewzvPvOmSOVHGoL7zuZMUIvTMxDf2v1rrL7+ZgVJ1GXPotKbSa+5UuQ1ifSdEy0Tmv5Eb4XckGlWEEVXRZUgQQ0eOeCq7Llbt42Aob+Ojy32FtV4YmMbqUWLanbhGRQSgAQ7MxPSfh0tgnP/FgRA7UodG4s8YxQRR44d0Imj+EWCLplsrl16m5dZ+jURYP3eA5BJoVmPSJz+PiimoRaqY2gOgtZcQpLFiC+TiDExbdaMUvQq5GKnHvBSaTQTJG2qosA7HA6htxjmtNw/+/7EaesiW5sNMieZh1Uag+qVG/ii3Kw9P9sMrsFdo
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3485.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(316002)(54906003)(110136005)(8676002)(66446008)(66476007)(4326008)(83380400001)(66556008)(5660300002)(2906002)(8936002)(86362001)(64756008)(66946007)(2616005)(1076003)(186003)(91956017)(76116006)(41300700001)(38100700002)(6486002)(71200400001)(478600001)(36756003)(122000001)(38070700005)(26005)(6512007)(6506007);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5472
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9f8695d3-cc94-4627-1c3c-08da76cbd6b7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50k3vvG4X7Xw0jcA+JN6qmaE2KE2ieyG5UoOnkB+PEV257iC4Fpp+GZYDrAoNOHsAvqe2iVTvqT0v7qAUqEWHUo9Ni31Xd7ZrejcDd9FBpkKypcbEvcOO6Q0KwM9yQdPF6sh8AD9kVJADiKI3O9fhlcu0DbW/YfpdYRv+FKCiK/dEsKGIlnHT/5oy7Nv32zWaWsHmKhKhCc/dxZ6WtLfxkp7fUhdTjqL/bR8uVpowNYS3JsO6gGoc8kXlSCvjwJwikCfZ7PTZOFTSbPFgbEjuFnmkihZVS7LfhCLoXxXcze8rALaCSBn2Kv2pvUaXhJCQfBZrddUrXXxNVLen5ZSAYlPkObltOta7YfSnrFfO8+VRcRly653CbeuznZKVEJr8+KlRuEj08rv2RrOlZ+KdMuAtpai5cXanLYMOvQEvploF6AQ/rVvhKiUgb6RMDz6YHv4457hIn/VETgPkd8yMBjJ4wfQyHZRipZpo2UaPBHuadkpof+Z1P6QmRNHIm6YQO05CXhVJF+5Xvbx7GX2GwakziGu/Gd4M/sHFvHEOytVdZlLR+cDjunxDxImSOJv6hjtTPXW1axsfBLmeAPC93ZpbD37yCBLNNHKhuk1wYQcbXHZyB78jv9/nGuCP8P11fVLk2CYj0+aJ6cAKesr059cgo9jqP9dd94zMpcEtkl0hYcgUpVRy2Cqp76pJaaMKIQc72TtynMrDLgH/1dFIee7PTnhB1feU2kuknjM/KpMNdFd5kN0RyOFj5I82PSI3NMWfjdQUndvmqerdOiJqbxAmnDsYd1MXSq2UZHjBEICmSpRJL76ZQFJLZzdVTvr
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(46966006)(40470700004)(316002)(110136005)(36756003)(54906003)(41300700001)(6506007)(6512007)(26005)(6486002)(478600001)(2906002)(86362001)(40480700001)(82310400005)(40460700003)(70206006)(70586007)(4326008)(8676002)(8936002)(5660300002)(1076003)(186003)(2616005)(47076005)(81166007)(82740400003)(356005)(336012)(83380400001)(36860700001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 10:18:40.8919 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbf5ec9-bc8c-4c13-c419-08da76cbde7f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3960
X-Mailman-Approved-At: Fri, 05 Aug 2022 06:33:46 -0400
Cc: Nikita Venkatesh <Nikita.Venkatesh@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
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

From: Nikita Venkatesh <nikita.venkatesh@arm.com>

Add PSCI_CPU_OFF testscase to  arm/psci testsuite. The test uses the
following method.

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

Signed-off-by: Nikita Venkatesh <nikita.venkatesh@arm.com>
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
+#define CPU_OFF_TEST_WAIT_TIME 1000

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
+       int cpu = smp_processor_id();
+       while (!cpu_off_start)
+               cpu_relax();
+       /* On to the CPU off test */
+       cpu_off_success[cpu] = true;
+       cpumask_set_cpu(cpu, &cpu_off_done);
+       cpu_psci_cpu_die();
+       /* The CPU shouldn't execute the next steps. */
+       cpu_off_success[cpu] = false;
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
+       bool failed = false;
+       int cpu;
+
+       for_each_present_cpu(cpu) {
+               if (cpu < 1)
+                       continue;
+               smp_boot_secondary(cpu, cpu_off_secondary_test);
+       }
+
+       cpumask_set_cpu(0, &cpu_off_done);
+
+       report_info("PSCI OFF Test");
+
+       /* Release the CPUs */
+       cpu_off_start = 1;
+
+       /* Wait until all are done */
+       while (!cpumask_full(&cpu_off_done))
+               cpu_relax();
+
+       /* Allow all the other CPUs to complete the operation */
+       mdelay(CPU_OFF_TEST_WAIT_TIME);
+
+       for_each_present_cpu(cpu) {
+               if (cpu == 0)
+                       continue;
+
+               if (!cpu_off_success[cpu]) {
+                       report_info("CPU%d could not be turned off", cpu);
+                       failed = true;
+               }
+       }
+       return !failed;
+}
+
+static void run_default_psci_tests(void)
+{
+       report(psci_invalid_function(), "invalid-function");
+       report(psci_affinity_info_on(), "affinity-info-on");
+       report(psci_affinity_info_off(), "affinity-info-off");
+       if (ERRATA(6c7a5dce22b3)){
+               report(psci_cpu_on_test(), "cpu-on");
+       } else {
+               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
+       }
+}
+
+int main(int argc, char **argv)
 {
        int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);

@@ -143,15 +210,15 @@ int main(void)

        report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
                                          PSCI_VERSION_MINOR(ver));
-       report(psci_invalid_function(), "invalid-function");
-       report(psci_affinity_info_on(), "affinity-info-on");
-       report(psci_affinity_info_off(), "affinity-info-off");
-
-       if (ERRATA(6c7a5dce22b3))
-               report(psci_cpu_on_test(), "cpu-on");
-       else
-               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");

+       if (argc < 2) {
+               run_default_psci_tests();
+       } else if (strcmp(argv[1], "cpu-off") == 0) {
+               report(psci_cpu_off_test(), "cpu-off");
+       } else {
+               printf("Unknown subtest\n");
+               abort();
+       }
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
2.17.1
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
