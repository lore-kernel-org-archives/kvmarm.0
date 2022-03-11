Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2640CC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:21:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5914045D;
	Fri, 11 Mar 2022 12:21:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A8X7WxtMsf76; Fri, 11 Mar 2022 12:21:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1ED40AEA;
	Fri, 11 Mar 2022 12:21:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8B7404FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:21:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rK-xzihxg7zT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:21:44 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70082.outbound.protection.outlook.com [40.107.7.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C897E4045D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:21:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnR0/HhqtdIfFM8ekCW1bG8BP6eYQNcM3YvoYLlNKQM=;
 b=qPzxC5qfQ4YG5Gfg/1OTRLXE8quWq720+fzJSkDqQvHzTeouodCPcJ/ZhKQQo7PkmIM6iwexxFxfi9aWZyLUFSroQtnxhbqgwQmYLIB+FYBjzkPUMsDuHBfGt7jqvZZispbB/H61dV0JVFoa1W4/qnczjhk+q6vAyCK/kdvshFM=
Received: from AS9P194CA0020.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::20)
 by AS8PR08MB6615.eurprd08.prod.outlook.com (2603:10a6:20b:335::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 17:21:38 +0000
Received: from VE1EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46d:cafe::e6) by AS9P194CA0020.outlook.office365.com
 (2603:10a6:20b:46d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Fri, 11 Mar 2022 17:21:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT059.mail.protection.outlook.com (10.152.19.60) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.24 via Frontend Transport; Fri, 11 Mar 2022 17:21:38 +0000
Received: ("Tessian outbound 18e50a6f0513:v113");
 Fri, 11 Mar 2022 17:21:37 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8e8098db8cb5aab5
X-CR-MTA-TID: 64aa7808
Received: from cb137c28f097.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 EEECC8BA-A452-4B73-AD1E-3F742B885BFF.1; 
 Fri, 11 Mar 2022 17:21:26 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cb137c28f097.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 11 Mar 2022 17:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo80a0bhtN30/B3I3yGyG5nArkY7wqqQ4AQqDjuDOjaUtc/EihgfdXFwNG7bY+pPgDgTJv2XnDihZPG5klCDkhCwlzPw2RDeFp9W0mC5pVcszLBmOUktB2krmLotbuJKwp1lxc1r5iGKSVSNR3xPX/Pr2I71uIagQ0Ge+mBGXKFniUhLA8089mkGtHZgQ+0jNSjAQtpWUwOvtz2C7+gqVOjr1MoyhqXGKjEYnIaD2UXFdl3w4784VXORHzl+I0ri77080QJuMSRBbf9AGhkHOHCoj9UPQ2AwGWMnOeH5oPs3lbtZmnLsYv0S9Ob899l3R/TZaXaYGCtB3V6iWsUsgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnR0/HhqtdIfFM8ekCW1bG8BP6eYQNcM3YvoYLlNKQM=;
 b=ZzBUOyD++oewWZL8UIrbYGcXE54wICwFSt2NdQs+f0VB7XJc6vzibB79qbMfMYH2dRw1m8CEChngRa3teRSEYkbpDLyKd9fmfbHd3psYGqLZAcF0TKTxklM7w3bT9shT/DP8GXaDbdMuU0yu1W6Xq7TvbPu90uIXuusTMSn7Bpy/ravm3GAAfHIM/bMhX2YCnhOmlIRyBYNejDGv6RCvFldkv6HIjvEqS/LSUEKgPdcxUeXymZUxc23xxQCqfGclT68ccNmGhAzXI4/vXdbv4s1nchQOyYN1q5UuQ/g0rxQvsvjt07lAv8/yG9O3lyejbKQx0aKDXpwy+2ERrxoAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnR0/HhqtdIfFM8ekCW1bG8BP6eYQNcM3YvoYLlNKQM=;
 b=qPzxC5qfQ4YG5Gfg/1OTRLXE8quWq720+fzJSkDqQvHzTeouodCPcJ/ZhKQQo7PkmIM6iwexxFxfi9aWZyLUFSroQtnxhbqgwQmYLIB+FYBjzkPUMsDuHBfGt7jqvZZispbB/H61dV0JVFoa1W4/qnczjhk+q6vAyCK/kdvshFM=
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by VI1PR08MB4480.eurprd08.prod.outlook.com (2603:10a6:803:f6::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 11 Mar
 2022 17:21:21 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d6e:f858:129f:f240]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d6e:f858:129f:f240%4]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 17:21:21 +0000
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Thread-Topic: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Thread-Index: AQHYKm4CIV9MScju9UunLqTD29wmxKy6g9qA
Date: Fri, 11 Mar 2022 17:21:21 +0000
Message-ID: <20220311172051.GA257833@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-7-broonie@kernel.org>
In-Reply-To: <20220225165923.1474372-7-broonie@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-MS-Office365-Filtering-Correlation-Id: bb12d45c-2a37-44c9-75cd-08da038399db
x-ms-traffictypediagnostic: VI1PR08MB4480:EE_|VE1EUR03FT059:EE_|AS8PR08MB6615:EE_
X-Microsoft-Antispam-PRVS: <AS8PR08MB6615057E3B1FCEE5D101E40DED0C9@AS8PR08MB6615.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: dJjE/j60t/zriXZ11CyN+BJBQadBwsHw26JudFPmbHhNMkBPxtRNqn6OzWJrzLju6T898uxIcIhy8/nOTKAQSjVIvLECd94x8HU3yHM48UFHLrx0XzR7wDT7++bgcOtwMOc0EtzmrEw3i0QPg6YHGRT45/iGs0xQyggqIAzlUuCfTFHbBFG0KpbFlHIwWLs4TokPjAoiOt8TVUYasAWINxq2U+7OiYRghntx8jhM+iyNeMcDx+AGspu0op/o40Lhk8jfZ6TPTrQ9V/aQrSNi7LIy9TRem6qaUWxKw+m8aD3rxBMjIGnvYQ4VzmY+oQvxIa95Bn1+N+Fcu+p3aA3UTZz0bD3q/2UrVC4zANtoYnWzxNhFDfOtPBqVXqx+32FDXAjC2Y/Lb1CCIB4TJ9oasOWXszw9jdDWRBy00WE+d8eoINjoZlwgyEGmikkroigTm1PCydIjt4qEOKoLnttamudbdRUwMm6/GYi9i9ngZLyViVEh5gGGkLd6H46TTXYdBtsHJwjEkk0NqhVnvx1BMGvpsuDcUXaUa5rt9Ye7Xv5VUK5a+RzFNKkJD4fxZkfgx0I2/HDn0b9+uYF2HDRLCcsDOWm/H808LTIKM1dqVZyfPtMIJcwiQ8zxKk5foH3XEreTGhC1BCrjg3vWw5Vj+jteG//8nFYf5suRsbOxZ41kt1K1deSScZOup+xNbiEpgiNdesigPgmSseqUx6uhmO9ePEvjt3BuuGyIOtE9vm0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB9PR08MB7179.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(2616005)(1076003)(26005)(6506007)(2906002)(71200400001)(186003)(122000001)(36756003)(6512007)(54906003)(38100700002)(33656002)(83380400001)(508600001)(6486002)(5660300002)(66556008)(66476007)(66446008)(66946007)(30864003)(76116006)(38070700005)(91956017)(6916009)(8676002)(4326008)(8936002)(86362001)(316002)(64756008)(27376004)(559001)(579004);
 DIR:OUT; SFP:1101; 
Content-ID: <02E3452A64942A4FA788DFFE56A6A419@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4480
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3f0671f0-dbbb-4423-0e66-08da0383900d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULwdRBxW1UTFqN+hsGoi1XVLBeTQSerAt+vfesVEt/0oKeN6buuZQoMtOB8RZIvLITL4rKakpZhCoFcTJNU5QVQlYQDl/5dtKkFdeLLMm0TkFBjm7Pnex0hDvd6T5fZwiz853PDJ+GFFUUz4ii6biV9EQ1YXJiebpjQohuivXzgReWsxwEfoqLr5afW7CwnEYdbH3YOk3NWRwc5Tk00kSKbmytmL+73oQjbA/OX2/hEQWgAuFfdsjWbZqJaJvDNEe+PZe3t7gvSgPDppR7nFkxjsvw/bn9gHwE9s3NLYyrjlceCfUDq1Hj11SiLevcyo5GZq429HS4e53ZROiY8XSBf+tcmjdhVXtiOOH+ZM1Q/1ttXMF65+7Otxdz0wBThQVgtUn6x/nsv9x9JvMIBnho5ZD9ZikBFGqf7v28cOMP+8ODjGhR8cwyI2U5JD+rj2Yvr465Vb7riiO5Wi9ZuHaVqCst68ff4WInFQp5HTIWdOaCFrgc/S7/Q3d8crwE2T5+dt/Su8ccuIZ/gpQIy1PRvOKnBoCsGpQaswbH0PlRyNeqofiUx/DhBh3PUwoLuuT6DGReOzvmfqe38IFeUzqIZKUKRsdn7u9RKn5JaPvB43DjEb6MnFMsf0pA7Fc+KFOCJXVvZTjyGVJQ/eI7Hexs7Sl08d/YpNeB6R1/9B7TU42pf3DMNodpN9GVRGg85dzDNK3IKj/pQbGER9A05llw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70586007)(5660300002)(86362001)(2906002)(70206006)(6862004)(4326008)(6486002)(508600001)(8676002)(36756003)(2616005)(1076003)(33656002)(8936002)(83380400001)(316002)(186003)(26005)(356005)(6512007)(82310400004)(40460700003)(6506007)(47076005)(54906003)(81166007)(30864003)(36860700001)(336012)(27376004);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 17:21:38.1854 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb12d45c-2a37-44c9-75cd-08da038399db
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6615
Cc: Marc Zyngier <maz@kernel.org>,
 Basant KumarDwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <Luis.Machado@arm.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, Alan Hayward <Alan.Hayward@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

The 02/25/2022 16:58, Mark Brown wrote:
> Provide ABI documentation for SME similar to that for SVE. Due to the very
> large overlap around streaming SVE mode in both implementation and
> interfaces documentation for streaming mode SVE is added to the SVE
> document rather than the SME one.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
...
> +1.  General
> +-----------
> +
> +* PSTATE.SM, PSTATE.ZA, the streaming mode vector length, the ZA
> +  register state and TPIDR2_EL0 are tracked per thread.
> +
> +* The presence of SME is reported to userspace via HWCAP2_SME in the aux vector
> +  AT_HWCAP2 entry.  Presence of this flag implies the presence of the SME
> +  instructions and registers, and the Linux-specific system interfaces
> +  described in this document.  SME is reported in /proc/cpuinfo as "sme".
> +
> +* Support for the execution of SME instructions in userspace can also be
> +  detected by reading the CPU ID register ID_AA64PFR1_EL1 using an MRS
> +  instruction, and checking that the value of the SME field is nonzero. [3]
> +
> +  It does not guarantee the presence of the system interfaces described in the
> +  following sections: software that needs to verify that those interfaces are
> +  present must check for HWCAP2_SME instead.
> +
> +* There are a number of optional SME features, presence of these is reported
> +  through AT_HWCAP2 through:
> +
> +	HWCAP2_SME_I16I64
> +	HWCAP2_SME_F64F64
> +	HWCAP2_SME_I8I32
> +	HWCAP2_SME_F16F32
> +	HWCAP2_SME_B16F32
> +	HWCAP2_SME_F32F32
> +	HWCAP2_SME_FA64
> +
> +  This list may be extended over time as the SME architecture evolves.
> +
> +  These extensions are also reported via the CPU ID register ID_AA64SMFR0_EL1,
> +  which userspace can read using an MRS instruction.  See elf_hwcaps.txt and
> +  cpu-feature-registers.txt for details.
> +
> +* Debuggers should restrict themselves to interacting with the target via the
> +  NT_ARM_SVE, NT_ARM_SSVE and NT_ARM_ZA regsets.  The recommended way
> +  of detecting support for these regsets is to connect to a target process
> +  first and then attempt a
> +
> +	ptrace(PTRACE_GETREGSET, pid, NT_ARM_<regset>, &iov).
> +
> +* Whenever ZA register values are exchanged in memory between userspace and
> +  the kernel, the register value is encoded in memory as a series of horizontal
> +  vectors from 0 to VL/8-1 stored in the same endianness invariant format as is
> +  used for SVE vectors.
> +
> +* On thread creation TPIDR2_EL0 is preserved unless CLONE_SETTLS is specified,
> +  in which case it is set to 0.
> +

This looks OK.


> +2.  Vector lengths
> +------------------
> +
> +SME defines a second vector length similar to the SVE vector length which is
> +controls the size of the streaming mode SVE vectors and the ZA matrix array.
> +The ZA matrix is square with each side having as many bytes as a SVE vector.
> +

i would s/SVE vector/streaming mode SVE vector/
or give SME vector length some other name and use that throughout.

> +
> +3.  Sharing of streaming and non-streaming mode SVE state
> +---------------------------------------------------------
> +
> +It is implementation defined which if any parts of the SVE state are shared
> +between streaming and non-streaming modes.  When switching between modes
> +via software interfaces such as ptrace if no register content is provided as
> +part of switching no state will be assumed to be shared and everything will
> +be zeroed.
> +

OK.

> +
> +4.  System call behaviour
> +-------------------------
> +
> +* On syscall PSTATE.ZA is preserved, if PSTATE.ZA==1 then the contents of the
> +  ZA matrix are preserved.
> +
> +* On syscall PSTATE.SM will be cleared and the SVE registers will be handled
> +  as normal.
> +
> +* Neither the SVE registers nor ZA are used to pass arguments to or receive
> +  results from any syscall.
> +
> +* On creation fork() or clone() the newly created process will have PSTATE.SM
> +  and PSTATE.ZA cleared.

is there a reason why fork() clears ZA?

i think this is a minor issue, but the usual expectation is that
on thread creation thread local state is reset in the child, but
in a forked child the state is the same as in the parent (where
ZA is preserved according to the first rule).

> +
> +* All other SME state of a thread, including the currently configured vector
> +  length, the state of the PR_SME_VL_INHERIT flag, and the deferred vector
> +  length (if any), is preserved across all syscalls, subject to the specific
> +  exceptions for execve() described in section 6.
> +

OK other than the fork comment.

> +
> +5.  Signal handling
> +-------------------
> +
> +* Signal handlers are invoked with streaming mode and ZA disabled.
> +
> +* A new signal frame record za_context encodes the ZA register contents on
> +  signal delivery. [1]
> +
> +* The signal frame record for ZA always contains basic metadata, in particular
> +  the thread's vector length (in za_context.vl).
> +
> +* The ZA matrix may or may not be included in the record, depending on
> +  the value of PSTATE.ZA.  The registers are present if and only if:
> +  za_context.head.size >= ZA_SIG_CONTEXT_SIZE(sve_vq_from_vl(za_context.vl))
> +  in which case PSTATE.ZA == 1.
> +
> +* If matrix data is present, the remainder of the record has a vl-dependent
> +  size and layout.  Macros ZA_SIG_* are defined [1] to facilitate access to
> +  them.
> +
> +* The matrix is stored as a series of horizontal vectors in the same format as
> +  is used for SVE vectors.
> +
> +* If the ZA context is too big to fit in sigcontext.__reserved[], then extra
> +  space is allocated on the stack, an extra_context record is written in
> +  __reserved[] referencing this space.  za_context is then written in the
> +  extra space.  Refer to [1] for further details about this mechanism.
> +

OK.

> +
> +5.  Signal return
> +-----------------
> +
> +When returning from a signal handler:
> +
> +* If there is no za_context record in the signal frame, or if the record is
> +  present but contains no register data as described in the previous section,
> +  then ZA is disabled.
> +
> +* If za_context is present in the signal frame and contains matrix data then
> +  PSTATE.ZA is set to 1 and ZA is populated with the specified data.
> +
> +* The vector length cannot be changed via signal return.  If za_context.vl in
> +  the signal frame does not match the current vector length, the signal return
> +  attempt is treated as illegal, resulting in a forced SIGSEGV.
> +

OK.

> +
> +6.  prctl extensions
> +--------------------
> +
> +Some new prctl() calls are added to allow programs to manage the SME vector
> +length:
> +
> +prctl(PR_SME_SET_VL, unsigned long arg)
> +
> +    Sets the vector length of the calling thread and related flags, where
> +    arg == vl | flags.  Other threads of the calling process are unaffected.
> +
> +    vl is the desired vector length, where sve_vl_valid(vl) must be true.
> +
> +    flags:
> +
> +	PR_SME_VL_INHERIT
> +
> +	    Inherit the current vector length across execve().  Otherwise, the
> +	    vector length is reset to the system default at execve().  (See
> +	    Section 9.)
> +
> +	PR_SME_SET_VL_ONEXEC
> +
> +	    Defer the requested vector length change until the next execve()
> +	    performed by this thread.
> +
> +	    The effect is equivalent to implicit execution of the following
> +	    call immediately after the next execve() (if any) by the thread:
> +
> +		prctl(PR_SME_SET_VL, arg & ~PR_SME_SET_VL_ONEXEC)
> +
> +	    This allows launching of a new program with a different vector
> +	    length, while avoiding runtime side effects in the caller.
> +
> +	    Without PR_SME_SET_VL_ONEXEC, the requested change takes effect
> +	    immediately.
> +
> +
> +    Return value: a nonnegative on success, or a negative value on error:
> +	EINVAL: SME not supported, invalid vector length requested, or
> +	    invalid flags.
> +
> +
> +    On success:
> +
> +    * Either the calling thread's vector length or the deferred vector length
> +      to be applied at the next execve() by the thread (dependent on whether
> +      PR_SME_SET_VL_ONEXEC is present in arg), is set to the largest value
> +      supported by the system that is less than or equal to vl.  If vl ==
> +      SVE_VL_MAX, the value set will be the largest value supported by the
> +      system.
> +
> +    * Any previously outstanding deferred vector length change in the calling
> +      thread is cancelled.
> +
> +    * The returned value describes the resulting configuration, encoded as for
> +      PR_SME_GET_VL.  The vector length reported in this value is the new
> +      current vector length for this thread if PR_SME_SET_VL_ONEXEC was not
> +      present in arg; otherwise, the reported vector length is the deferred
> +      vector length that will be applied at the next execve() by the calling
> +      thread.
> +
> +    * Changing the vector length causes all of ZA, P0..P15, FFR and all bits of
> +      Z0..Z31 except for Z0 bits [127:0] .. Z31 bits [127:0] to become
> +      unspecified, including both streaming and non-streaming SVE state.
> +      Calling PR_SME_SET_VL with vl equal to the thread's current vector
> +      length, or calling PR_SME_SET_VL with the PR_SVE_SET_VL_ONEXEC flag,
> +      does not constitute a change to the vector length for this purpose.
> +
> +    * Changing the vector length causes PSTATE.ZA and PSTATE.SM to be cleared.
> +      Calling PR_SME_SET_VL with vl equal to the thread's current vector
> +      length, or calling PR_SME_SET_VL with the PR_SVE_SET_VL_ONEXEC flag,
> +      does not constitute a change to the vector length for this purpose.
> +
> +
> +prctl(PR_SME_GET_VL)
> +
> +    Gets the vector length of the calling thread.
> +
> +    The following flag may be OR-ed into the result:
> +
> +	PR_SME_VL_INHERIT
> +
> +	    Vector length will be inherited across execve().
> +
> +    There is no way to determine whether there is an outstanding deferred
> +    vector length change (which would only normally be the case between a
> +    fork() or vfork() and the corresponding execve() in typical use).
> +
> +    To extract the vector length from the result, bitwise and it with
> +    PR_SME_VL_LEN_MASK.
> +
> +    Return value: a nonnegative value on success, or a negative value on error:
> +	EINVAL: SME not supported.
> +

OK.

> +
> +7.  ptrace extensions
> +---------------------
> +
> +* A new regset NT_ARM_SSVE is defined for access to streaming mode SVE
> +  state via PTRACE_GETREGSET and  PTRACE_SETREGSET, this is documented in
> +  sve.rst.
> +
> +* A new regset NT_ARM_ZA is defined for ZA state for access to ZA state via
> +  PTRACE_GETREGSET and PTRACE_SETREGSET.
> +
> +  Refer to [2] for definitions.
> +
> +The regset data starts with struct user_za_header, containing:
> +
> +    size
> +
> +	Size of the complete regset, in bytes.
> +	This depends on vl and possibly on other things in the future.
> +
> +	If a call to PTRACE_GETREGSET requests less data than the value of
> +	size, the caller can allocate a larger buffer and retry in order to
> +	read the complete regset.
> +
> +    max_size
> +
> +	Maximum size in bytes that the regset can grow to for the target
> +	thread.  The regset won't grow bigger than this even if the target
> +	thread changes its vector length etc.
> +
> +    vl
> +
> +	Target thread's current streaming vector length, in bytes.
> +
> +    max_vl
> +
> +	Maximum possible streaming vector length for the target thread.
> +
> +    flags
> +
> +	Zero or more of the following flags, which have the same
> +	meaning and behaviour as the corresponding PR_SET_VL_* flags:
> +
> +	    SME_PT_VL_INHERIT
> +
> +	    SME_PT_VL_ONEXEC (SETREGSET only).
> +
> +* The effects of changing the vector length and/or flags are equivalent to
> +  those documented for PR_SME_SET_VL.
> +
> +  The caller must make a further GETREGSET call if it needs to know what VL is
> +  actually set by SETREGSET, unless is it known in advance that the requested
> +  VL is supported.
> +
> +* The size and layout of the payload depends on the header fields.  The
> +  SME_PT_ZA_*() macros are provided to facilitate access to the data.
> +
> +* In either case, for SETREGSET it is permissible to omit the payload, in which
> +  case the vector length and flags are changed and PSTATE.ZA is set to 0
> +  (along with any consequences of those changes).  If a payload is provided
> +  then PSTATE.ZA will be set to 1.
> +
> +* For SETREGSET, if the requested VL is not supported, the effect will be the
> +  same as if the payload were omitted, except that an EIO error is reported.
> +  No attempt is made to translate the payload data to the correct layout
> +  for the vector length actually set.  It is up to the caller to translate the
> +  payload layout for the actual VL and retry.
> +
> +* The effect of writing a partial, incomplete payload is unspecified.
> +

I'm not familiar with ptrace, but looks OK.

> +
> +8.  ELF coredump extensions
> +---------------------------
> +
> +* NT_ARM_SSVE notes will be added to each coredump for
> +  each thread of the dumped process.  The contents will be equivalent to the
> +  data that would have been read if a PTRACE_GETREGSET of the corresponding
> +  type were executed for each thread when the coredump was generated.
> +
> +* A NT_ARM_ZA note will be added to each coredump for each thread of the
> +  dumped process.  The contents will be equivalent to the data that would have
> +  been read if a PTRACE_GETREGSET of NT_ARM_ZA were executed for each thread
> +  when the coredump was generated.
> +

OK.

> +
> +9.  System runtime configuration
> +--------------------------------
> +
> +* To mitigate the ABI impact of expansion of the signal frame, a policy
> +  mechanism is provided for administrators, distro maintainers and developers
> +  to set the default vector length for userspace processes:
> +
> +/proc/sys/abi/sme_default_vector_length
> +
> +    Writing the text representation of an integer to this file sets the system
> +    default vector length to the specified value, unless the value is greater
> +    than the maximum vector length supported by the system in which case the
> +    default vector length is set to that maximum.
> +
> +    The result can be determined by reopening the file and reading its
> +    contents.
> +
> +    At boot, the default vector length is initially set to 32 or the maximum
> +    supported vector length, whichever is smaller and supported.  This
> +    determines the initial vector length of the init process (PID 1).
> +
> +    Reading this file returns the current system default vector length.
> +
> +* At every execve() call, the new vector length of the new process is set to
> +  the system default vector length, unless
> +
> +    * PR_SME_VL_INHERIT (or equivalently SME_PT_VL_INHERIT) is set for the
> +      calling thread, or
> +
> +    * a deferred vector length change is pending, established via the
> +      PR_SME_SET_VL_ONEXEC flag (or SME_PT_VL_ONEXEC).
> +
> +* Modifying the system default vector length does not affect the vector length
> +  of any existing process or thread that does not make an execve() call.
> +

OK.

> +
> +Appendix A.  SME programmer's model (informative)
> +=================================================
> +
> +This section provides a minimal description of the additions made by SVE to the
> +ARMv8-A programmer's model that are relevant to this document.
> +
> +Note: This section is for information only and not intended to be complete or
> +to replace any architectural specification.
> +
> +A.1.  Registers
> +---------------
> +
> +In A64 state, SME adds the following:
> +
> +* A new mode, streaming mode, in which a subset of the normal FPSIMD and SVE
> +  features are available.  When supported EL0 software may enter and leave
> +  streaming mode at any time.
> +
> +  For best system performance it is strongly encouraged for software to enable
> +  streaming mode only when it is actively being used.
> +
> +* A new vector length controlling the size of ZA and the Z registers when in
> +  streaming mode, separately to the vector length used for SVE when not in
> +  streaming mode.  There is no requirement that either the currently selected
> +  vector length or the set of vector lengths supported for the two modes in
> +  a given system have any relationship.  The streaming mode vector length
> +  is referred to as SVL.
> +
> +* A new ZA matrix register.  This is a square matrix of SVLxSVL bits.  Most
> +  operations on ZA require that streaming mode be enabled but ZA can be
> +  enabled without streaming mode in order to load, save and retain data.
> +
> +  For best system performance it is strongly encouraged for software to enable
> +  ZA only when it is actively being used.
> +
> +* Two new 1 bit fields in PSTATE which may be controlled via the SMSTART and
> +  SMSTOP instructions or by access to the SVCR system register:
> +
> +  * PSTATE.ZA, if this is 1 then the ZA matrix is accessible and has valid
> +    data while if it is 0 then ZA can not be accessed.  When PSTATE.ZA is
> +    changed from 0 to 1 all bits in ZA are cleared.
> +
> +  * PSTATE.SM, if this is 1 then the PE is in streaming mode.  When the value
> +    of PSTATE.SM is changed then it is implementation defined if the subset
> +    of the floating point register bits valid in both modes may be retained.
> +    Any other bits will be cleared.
> +

OK.

> +
> +References
> +==========
> +
> +[1] arch/arm64/include/uapi/asm/sigcontext.h
> +    AArch64 Linux signal ABI definitions
> +
> +[2] arch/arm64/include/uapi/asm/ptrace.h
> +    AArch64 Linux ptrace ABI definitions
> +
> +[3] Documentation/arm64/cpu-feature-registers.rst
> diff --git a/Documentation/arm64/sve.rst b/Documentation/arm64/sve.rst
> index 9d9a4de5bc34..93c2c2990584 100644
> --- a/Documentation/arm64/sve.rst
> +++ b/Documentation/arm64/sve.rst
> @@ -7,7 +7,9 @@ Author: Dave Martin <Dave.Martin@arm.com>
>  Date:   4 August 2017
>  
>  This document outlines briefly the interface provided to userspace by Linux in
> -order to support use of the ARM Scalable Vector Extension (SVE).
> +order to support use of the ARM Scalable Vector Extension (SVE), including
> +interactions with Streaming SVE mode added by the Scalable Matrix Extension
> +(SME).
>  
>  This is an outline of the most important features and issues only and not
>  intended to be exhaustive.
> @@ -23,6 +25,10 @@ model features for SVE is included in Appendix A.
>  * SVE registers Z0..Z31, P0..P15 and FFR and the current vector length VL, are
>    tracked per-thread.
>  
> +* In streaming mode FFR is not accessible unless HWCAP2_SME_FA64 is present
> +  in the system, when it is not supported and these interfaces are used to
> +  access streaming mode FFR is read and written as zero.
> +
>  * The presence of SVE is reported to userspace via HWCAP_SVE in the aux vector
>    AT_HWCAP entry.  Presence of this flag implies the presence of the SVE
>    instructions and registers, and the Linux-specific system interfaces
> @@ -53,10 +59,19 @@ model features for SVE is included in Appendix A.
>    which userspace can read using an MRS instruction.  See elf_hwcaps.txt and
>    cpu-feature-registers.txt for details.
>  
> +* On hardware that supports the SME extensions, HWCAP2_SME will also be
> +  reported in the AT_HWCAP2 aux vector entry.  Among other things SME adds
> +  streaming mode which provides a subset of the SVE feature set using a
> +  separate SME vector length and the same Z/V registers.  See sme.rst
> +  for more details.
> +
>  * Debuggers should restrict themselves to interacting with the target via the
>    NT_ARM_SVE regset.  The recommended way of detecting support for this regset
>    is to connect to a target process first and then attempt a
> -  ptrace(PTRACE_GETREGSET, pid, NT_ARM_SVE, &iov).
> +  ptrace(PTRACE_GETREGSET, pid, NT_ARM_SVE, &iov).  Note that when SME is
> +  present and streaming SVE mode is in use the FPSIMD subset of registers
> +  will be read via NT_ARM_SVE and NT_ARM_SVE writes will exit streaming mode
> +  in the target.
>  
>  * Whenever SVE scalable register values (Zn, Pn, FFR) are exchanged in memory
>    between userspace and the kernel, the register value is encoded in memory in
> @@ -126,6 +141,11 @@ the SVE instruction set architecture.
>    are only present in fpsimd_context.  For convenience, the content of V0..V31
>    is duplicated between sve_context and fpsimd_context.
>  
> +* The record contains a flag field which includes a flag SVE_SIG_FLAG_SM which
> +  if set indicates that the thread is in streaming mode and the vector length
> +  and register data (if present) describe the streaming SVE data and vector
> +  length.
> +
>  * The signal frame record for SVE always contains basic metadata, in particular
>    the thread's vector length (in sve_context.vl).
>  
> @@ -170,6 +190,11 @@ When returning from a signal handler:
>    the signal frame does not match the current vector length, the signal return
>    attempt is treated as illegal, resulting in a forced SIGSEGV.
>  
> +* It is permitted to enter or leave streaming mode by setting or clearing
> +  the SVE_SIG_FLAG_SM flag but applications should take care to ensure that
> +  when doing so sve_context.vl and any register data are appropriate for the
> +  vector length in the new mode.
> +
>  
>  6.  prctl extensions
>  --------------------
> @@ -265,8 +290,14 @@ prctl(PR_SVE_GET_VL)
>  7.  ptrace extensions
>  ---------------------
>  
> -* A new regset NT_ARM_SVE is defined for use with PTRACE_GETREGSET and
> -  PTRACE_SETREGSET.
> +* New regsets NT_ARM_SVE and NT_ARM_SSVE are defined for use with
> +  PTRACE_GETREGSET and PTRACE_SETREGSET. NT_ARM_SSVE describes the
> +  streaming mode SVE registers and NT_ARM_SVE describes the
> +  non-streaming mode SVE registers.
> +
> +  In this description a register set is referred to as being "live" when
> +  the target is in the appropriate streaming or non-streaming mode and is
> +  using data beyond the subset shared with the FPSIMD Vn registers.
>  
>    Refer to [2] for definitions.
>  
> @@ -297,7 +328,7 @@ The regset data starts with struct user_sve_header, containing:
>  
>      flags
>  
> -	either
> +	at most one of
>  
>  	    SVE_PT_REGS_FPSIMD
>  
> @@ -331,6 +362,10 @@ The regset data starts with struct user_sve_header, containing:
>  
>  	    SVE_PT_VL_ONEXEC (SETREGSET only).
>  
> +	If neither FPSIMD nor SVE flags are provided then no register
> +	payload is available, this is only possible when SME is implemented.
> +
> +
>  * The effects of changing the vector length and/or flags are equivalent to
>    those documented for PR_SVE_SET_VL.
>  
> @@ -346,6 +381,13 @@ The regset data starts with struct user_sve_header, containing:
>    case only the vector length and flags are changed (along with any
>    consequences of those changes).
>  
> +* In systems supporting SME when in streaming mode a GETREGSET for
> +  NT_REG_SVE will return only the user_sve_header with no register data,
> +  similarly a GETREGSET for NT_REG_SSVE will not return any register data
> +  when not in streaming mode.
> +
> +* A GETREGSET for NT_ARM_SSVE will never return SVE_PT_REGS_FPSIMD.
> +
>  * For SETREGSET, if an SVE_PT_REGS_SVE payload is present and the
>    requested VL is not supported, the effect will be the same as if the
>    payload were omitted, except that an EIO error is reported.  No
> @@ -355,17 +397,25 @@ The regset data starts with struct user_sve_header, containing:
>    unspecified.  It is up to the caller to translate the payload layout
>    for the actual VL and retry.
>  
> +* Where SME is implemented it is not possible to GETREGSET the register
> +  state for normal SVE when in streaming mode, nor the streaming mode
> +  register state when in normal mode, regardless of the implementation defined
> +  behaviour of the hardware for sharing data between the two modes.
> +
> +* Any SETREGSET of NT_ARM_SVE will exit streaming mode if the target was in
> +  streaming mode and any SETREGSET of NT_ARM_SSVE will enter streaming mode
> +  if the target was not in streaming mode.
> +
>  * The effect of writing a partial, incomplete payload is unspecified.
>  
>  
>  8.  ELF coredump extensions
>  ---------------------------
>  
> -* A NT_ARM_SVE note will be added to each coredump for each thread of the
> -  dumped process.  The contents will be equivalent to the data that would have
> -  been read if a PTRACE_GETREGSET of NT_ARM_SVE were executed for each thread
> -  when the coredump was generated.
> -
> +* NT_ARM_SVE and NT_ARM_SSVE notes will be added to each coredump for
> +  each thread of the dumped process.  The contents will be equivalent to the
> +  data that would have been read if a PTRACE_GETREGSET of the corresponding
> +  type were executed for each thread when the coredump was generated.
>  
>  9.  System runtime configuration
>  --------------------------------

OK.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
