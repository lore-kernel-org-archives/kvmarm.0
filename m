Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009051F61C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVoWYHMQcX5LFp8POkjXMK8ACJ6uEom3LEhUEexHH4s=;
 b=Ut0XBGmKgLu6cNap0G99Z8i/W4X2PvLYjOZQoFjkGFpLNH9NqhhPAAosjX3R0lM5mk/9OKWohjQxoD4ooZ6WeEIO9CoXFT4lM0mS/0ADmqdHPr3UmZ8Z6dSA9hzUpF45UlXlbeZOz3QJRO00N5WBV5wkzrDue5L7cd/B9aBLehA=
Received: from AM7PR03CA0006.eurprd03.prod.outlook.com (2603:10a6:20b:130::16)
 by GV2PR08MB7954.eurprd08.prod.outlook.com (2603:10a6:150:a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:12:50 +0000
Received: from AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:130:cafe::60) by AM7PR03CA0006.outlook.office365.com
 (2603:10a6:20b:130::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:12:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT005.mail.protection.outlook.com (100.127.140.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:12:49 +0000
Received: ("Tessian outbound d219f9a4f5c9:v211"); Wed, 27 Sep 2023 14:12:49 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8680f253fca9f365
X-CR-MTA-TID: 64aa7808
Received: from 56cd42496307.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id BD77DB7B-7D9B-4214-A879-AE631469B97F.1;
	Wed, 27 Sep 2023 14:01:38 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 56cd42496307.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Axwwro8FvbUoEUHE1P2YtbVW4ulMJtv8dTqFFwNVuoiLx4tdkZ0R3zDybug+9C69g5WyD6LKeMga6nhkBM/3ubc1mpMmIyxszF2+886bq8aempn+PTg2KlEKnWC05BdEiLTHTEW+nqpnPpd3Vj3Fwo9VSrChqRXs7/HDVeF/3GGuS5+zp7GCkWKJGnemW0ZmsR0CdoOgPiwpuyVwvmVoM3YGgw1AXu151gpdT/715LTiUlna0W9zuQYssN8n55mH8IzJG/8nrnxm3mucdN2/0HedNvFsSpqNj7hMTKb7ibsn/qxu+9Dj4MLXwYf9yasPkWyG84Wq/7WndobJTFWEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVoWYHMQcX5LFp8POkjXMK8ACJ6uEom3LEhUEexHH4s=;
 b=UFLLBUaF5mMBwt8H2F/zI+2GPURLGaPfnv3GcVgjalAMkXMIoxAS+iatYtzrwOv55vgYnYyimUuCOptURVXHQ3ockVZWUoMimV5pU18SPIPqzT4cQ08l5dzHZGumfaMDXS8heWd2Qq2sd4ttWVPX5j0rsr1DJzmDwWN//OGcvqkygGHu8XKEAICJtwDvdKfgRguyUybAtVinnHBOoxDRDSrli5nCdkCtH6r83yAnNNdePXMcL4v/Aw8Dn+wn/GNni0yWluRJbRoGOyNKkMl8TTlQh3h+Xeghw0t/vMglmV+YQfZ0klTYg6p/TVOq2igigHCuazqU8+6Cbg7iMut6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVoWYHMQcX5LFp8POkjXMK8ACJ6uEom3LEhUEexHH4s=;
 b=Ut0XBGmKgLu6cNap0G99Z8i/W4X2PvLYjOZQoFjkGFpLNH9NqhhPAAosjX3R0lM5mk/9OKWohjQxoD4ooZ6WeEIO9CoXFT4lM0mS/0ADmqdHPr3UmZ8Z6dSA9hzUpF45UlXlbeZOz3QJRO00N5WBV5wkzrDue5L7cd/B9aBLehA=
Received: from AS9PR07CA0053.eurprd07.prod.outlook.com (2603:10a6:20b:46b::20)
 by VI1PR08MB5405.eurprd08.prod.outlook.com (2603:10a6:803:12f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Wed, 27 Sep
 2023 14:01:35 +0000
Received: from AM7EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46b:cafe::95) by AS9PR07CA0053.outlook.office365.com
 (2603:10a6:20b:46b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT007.mail.protection.outlook.com (100.127.140.242) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:35 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:34 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:33 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 00/20] Permission Overlay Extension
Date: Wed, 27 Sep 2023 15:01:03 +0100
Message-ID: <20230927140123.5283-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT007:EE_|VI1PR08MB5405:EE_|AM7EUR03FT005:EE_|GV2PR08MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cd7d196-bef6-41ce-a077-08dbbf63d500
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 49ZRb9FACtwHwO01o8ndvLJNjlM8sqXwMm/tHTS6vDpecslcbvI0rVMspBg8/7G2lx5+b326tORkaCCRzQPZAPL3mpH6Hqda15wv1jFd8gY90UhSGJkNa7B3mxV5MyxZb/l09Qsb4ESl7OX+EruEn15EYNrOsHIKIa8mT/QELtwkYRxMMwK08i0EbF5vgTon5oRZtStDa0NnBe2ycWIB8CxIc+d9yYUx/MZwpQfc1jNGNGhMrw0LGyIYAOtyUDxMmtIrwSpsEIP4LRrTa2Aq5peyiJ0OcrQI3B/GFoXyIeVlEhIit9Dd0bFedDBnOMAYlzdUtpLDYjGDhI3XNbWBHXseZp63q4Eq5nYZKyy2MjVeMXdmG62X0t5SjN1DFoliaK+iNPI75qVqYmY9BPmPh8IBMibpj3BcUeFXSRFHmgMvzHVetMlmds3E4GehqEAAeswgyS+FCTZBYUe8vnMm5qq03qYzFy19MI+9jLFXAsCUwmKzwiGyaKudrlXxlHVUPEopyOXUUSa2b1RomCSqeerdJcyt5alaCl3qPEYhIZIeICthJThrsqy4DSWw0ZuEX1eMfs3tl/S7CNI7NJ1Q/itM8QgUfxVvmQmw7LOimsgk4Kx28pftT/DMdvEO/cprTNmqkr8qgiXGVsaGizsNa/DCjJO7pyw4/UWda7exFAT43GpK49MDs7hMYOSy3Nf2VzdwTNIiXe1dhX1+n4ZFOKyIISRt27rdDsQEvfMmVTpkbUYI0A5bT7dQ+7eIvExQ
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(46966006)(36840700001)(7696005)(478600001)(6666004)(83380400001)(70586007)(54906003)(70206006)(8676002)(8936002)(316002)(6916009)(5660300002)(36860700001)(41300700001)(1076003)(2616005)(36756003)(40480700001)(426003)(86362001)(82740400003)(44832011)(4326008)(2906002)(81166007)(47076005)(336012)(26005)(7416002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5405
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2d15f12f-8171-451f-d9cc-08dbbf624322
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lWzGlKJouEQKFIhAqwgOn+LWjHnPuEWAzmLkdlSr7SjgtzZGJ+zoPyEn8clPWafBNQO7/4/aYhj/UQjMLR51L+l5jRO4bYgJRQWLd0+Q/po/NaR5xt4WBZ9YUNZygz0xkU03OM22SmmrH+WDyVvfQg/123tdD1I9IaihhmdOzdkgtZi++8T9iUcF6VD6ItYt43fISoXtICrmbc6ifyCfBUkoSqoOcEg6QPmTl/Vzf/uG/UifY826bg4NWz78VnlbZmukVZMJ5pzdCiVf1qi9iDrf658kPcEhfUgCBxwCDNROomcSzg0asazoINthFosrVVwkK3Ha2Z5R66jtr0UQTI95ETryoeEEPRQteZ7aIu5XtrQjpQemS3IKweoJHql3GmfazAbP0XMD5+94BpkdEdj1yxgLnYbnrPkyte5QDYqPEVlzHFD0VpUu8A4EJSbu6eTlg3jHTctwi7vNXUuJyPzCExPh02ynPJ8Viogby9KIr6z12D/kDRKj7xTJAm03D9+V3NHiBRwwN7+f+SaEoLZVFGB1htJb1vU7BwGsQAZBGZlAfhcDeutknFf5w/5mwu+3jc0RRp10KVV4pjyJH/h0FeYHa/d2raHZ3ElQMUEfVky9/Xf31D8EHU10Y23GJZQ1nJ6CsTpk8AEuQ/28rHz2s4GGo4MAqDF8FKOQrdyHS+e3PzgkId8vLiqs6kAMq2kro/W6uzZyQtd37T+FVbklkB1yqVAhnPAr+N9TEuOM5fHTcQkAUbM1//L4ptbc
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(82310400011)(36840700001)(46966006)(40470700004)(2906002)(44832011)(70206006)(54906003)(5660300002)(70586007)(478600001)(6666004)(2616005)(107886003)(1076003)(7696005)(336012)(426003)(26005)(6862004)(8936002)(81166007)(316002)(8676002)(40460700003)(4326008)(41300700001)(83380400001)(82740400003)(36756003)(86362001)(40480700001)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:12:49.8531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd7d196-bef6-41ce-a077-08dbbf63d500
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7954

Hi all,

This series implements the Permission Overlay Extension introduced in 2022
VMSA enhancements [1]. It is based on v6.6-rc3.

The Permission Overlay Extension allows to constrain permissions on memory
regions. This can be used from userspace (EL0) without a system call or TLB
invalidation.

POE is used to implement the Memory Protection Keys [2] Linux syscall.

The first few patches add the basic framework, then the PKEYS interface is
implemented, and then the selftests are made to work on arm64.

There was discussion about what the 'default' protection key value should be,
I used disallow-all (apart from pkey 0), which matches what x86 does.

Patch 15 contains a call to cpus_have_const_cap(), which I couldn't avoid
until Mark's patch to re-order when the alternatives were applied [3] is
committed.

The KVM part isn't tested yet.

I have tested the modified protection_keys test on x86_64 [4], but not PPC.


Hopefully I have CC'd everyone correctly.

Thanks,
Joey

Joey Gouly (20):
  arm64/sysreg: add system register POR_EL{0,1}
  arm64/sysreg: update CPACR_EL1 register
  arm64: cpufeature: add Permission Overlay Extension cpucap
  arm64: disable trapping of POR_EL0 to EL2
  arm64: context switch POR_EL0 register
  KVM: arm64: Save/restore POE registers
  arm64: enable the Permission Overlay Extension for EL0
  arm64: add POIndex defines
  arm64: define VM_PKEY_BIT* for arm64
  arm64: mask out POIndex when modifying a PTE
  arm64: enable ARCH_HAS_PKEYS on arm64
  arm64: handle PKEY/POE faults
  arm64: stop using generic mm_hooks.h
  arm64: implement PKEYS support
  arm64: add POE signal support
  arm64: enable PKEY support for CPUs with S1POE
  arm64: enable POE and PIE to coexist
  kselftest/arm64: move get_header()
  selftests: mm: move fpregs printing
  selftests: mm: make protection_keys test work on arm64

 Documentation/arch/arm64/elf_hwcaps.rst       |   3 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/el2_setup.h            |  10 +-
 arch/arm64/include/asm/hwcap.h                |   1 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/include/asm/mman.h                 |   6 +-
 arch/arm64/include/asm/mmu.h                  |   2 +
 arch/arm64/include/asm/mmu_context.h          |  51 ++++++-
 arch/arm64/include/asm/pgtable-hwdef.h        |  10 ++
 arch/arm64/include/asm/pgtable-prot.h         |   8 +-
 arch/arm64/include/asm/pgtable.h              |  28 +++-
 arch/arm64/include/asm/pkeys.h                | 110 ++++++++++++++
 arch/arm64/include/asm/por.h                  |  33 +++++
 arch/arm64/include/asm/processor.h            |   1 +
 arch/arm64/include/asm/sysreg.h               |  16 ++
 arch/arm64/include/asm/traps.h                |   1 +
 arch/arm64/include/uapi/asm/hwcap.h           |   1 +
 arch/arm64/include/uapi/asm/sigcontext.h      |   7 +
 arch/arm64/kernel/cpufeature.c                |  15 ++
 arch/arm64/kernel/cpuinfo.c                   |   1 +
 arch/arm64/kernel/process.c                   |  16 ++
 arch/arm64/kernel/signal.c                    |  51 +++++++
 arch/arm64/kernel/traps.c                     |  12 +-
 arch/arm64/kvm/sys_regs.c                     |   2 +
 arch/arm64/mm/fault.c                         |  44 +++++-
 arch/arm64/mm/mmap.c                          |   7 +
 arch/arm64/mm/mmu.c                           |  38 +++++
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |  11 +-
 fs/proc/task_mmu.c                            |   2 +
 include/linux/mm.h                            |  11 +-
 .../arm64/signal/testcases/testcases.c        |  23 ---
 .../arm64/signal/testcases/testcases.h        |  26 +++-
 tools/testing/selftests/mm/Makefile           |   2 +-
 tools/testing/selftests/mm/pkey-arm64.h       | 138 ++++++++++++++++++
 tools/testing/selftests/mm/pkey-helpers.h     |   8 +
 tools/testing/selftests/mm/pkey-powerpc.h     |   3 +
 tools/testing/selftests/mm/pkey-x86.h         |   4 +
 tools/testing/selftests/mm/protection_keys.c  |  29 ++--
 39 files changed, 685 insertions(+), 52 deletions(-)
 create mode 100644 arch/arm64/include/asm/pkeys.h
 create mode 100644 arch/arm64/include/asm/por.h
 create mode 100644 tools/testing/selftests/mm/pkey-arm64.h

-- 
2.25.1

