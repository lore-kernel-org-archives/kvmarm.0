Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2041.outbound.protection.outlook.com [40.107.14.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5B828F0;
	Fri, 27 Jan 2023 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=F64np7L4+bDEloIPHFej39lAO0BGHOjRFa7kho6aZaq8WgygQ3x+UwmYR8wAilzbuKHS6GZbkAAZjS5ivlDvul2yhCIUN/pOstmbgVijrZPrRvGnzuHOlcl/KH8QXGqx3pQN2h5BCSfV2nJiS62zgpL9aklmfwnQD0qIhuwdpS4=
Received: from DB9PR01CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::9) by DU0PR08MB7566.eurprd08.prod.outlook.com
 (2603:10a6:10:31e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:43:26 +0000
Received: from DBAEUR03FT055.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1d8:cafe::29) by DB9PR01CA0004.outlook.office365.com
 (2603:10a6:10:1d8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT055.mail.protection.outlook.com (100.127.142.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:43:26 +0000
Received: ("Tessian outbound 43b0faad5a68:v132"); Fri, 27 Jan 2023 11:43:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 328f40782be5ee90
X-CR-MTA-TID: 64aa7808
Received: from a446c2399be5.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2356810A-096C-4C8B-9DC8-612C047184FD.1;
	Fri, 27 Jan 2023 11:43:19 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a446c2399be5.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOPePCEXhhynwWV/BAlesTuY2yvHTH57WvYqiQh8DaUfc0UHcObtA+1M/uPshV+ConiYe46kRqgfIQdz8UlUoUtDCuFenuwliSImXQYM3t4v/0IIzGhoArxwycFc+PUzxEWeppL5VApCK9rWn4Ae66GkhqABUyE+tGrypNidoruWBw7YcNO0FVE6Uvuiv8GYF0Q7WvZatDfwZSl024ATlshJkPccyWWot1Cf06kM6C82nFkpePbAGQe7rua50vd0XxGZLe1F3Jeh8bLPhX1YXRjpwnpALIFLgBuAuzlVxgwgypaHDKdYAKy8QUEJNhtXPtNrGvkYurvwzpwCfsyOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=jQU1ahQlo4Ke6Pb2xZEZdR+BCyictohj9pUSJ/a4AF3eH1Qpv5S3d1RMNeWGu5IMMRwUmHsN5rkbRDBi73zmmY6ltXVb+lw3l/hTSCARDOlPjQ/FVNTqFis1sHz/DrUGctajxfwhQ7UvAipEFZa30oCt9ZubfrBLI3f3Mb17amCJKxbzo2BEzHiFFd8QZEx6wNIoL5lHNtcp/Ps29bSbs++H4cQqWWMwpi/GN+CcFDkzTT7mNgQdMswrjU3xaB7BUPRHYcODt2qi4ephmtPHZh5oWp19osj4pl4LbbJoYObRubhT5rx4Bn9PNllgZUrHahyN4StYhhJUaWY92TnasA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUevxZg1UcpjeMjHy2JelqYsn9dKIor7hu3sqpFhgSU=;
 b=F64np7L4+bDEloIPHFej39lAO0BGHOjRFa7kho6aZaq8WgygQ3x+UwmYR8wAilzbuKHS6GZbkAAZjS5ivlDvul2yhCIUN/pOstmbgVijrZPrRvGnzuHOlcl/KH8QXGqx3pQN2h5BCSfV2nJiS62zgpL9aklmfwnQD0qIhuwdpS4=
Received: from AM6PR10CA0103.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::44)
 by AS2PR08MB9295.eurprd08.prod.outlook.com (2603:10a6:20b:599::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:16 +0000
Received: from AM7EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::4d) by AM6PR10CA0103.outlook.office365.com
 (2603:10a6:209:8c::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT059.mail.protection.outlook.com (100.127.140.215) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:43:15 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:14 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:09 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>
CC: <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joey Gouly
	<Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
	<pbonzini@redhat.com>, Quentin Perret <qperret@google.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Thomas
 Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 21/27] arm: Add build steps for QCBOR library
Date: Fri, 27 Jan 2023 11:41:02 +0000
Message-ID: <20230127114108.10025-22-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT059:EE_|AS2PR08MB9295:EE_|DBAEUR03FT055:EE_|DU0PR08MB7566:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a9b32a-ff1a-4be7-a32c-08db005bb403
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 6Pb/yAI+dMoySgWPV1ESXU1C2voGE4GuzhZPXTv6ithvZsU/Gtm10HiNA08QRjRA6wUyqBAFXOCL1LB4L+faNiVe/vtaW6OEkJQ2JAKBgZ2GhqisIHcHYXzQ+mrCZ7aK+VpQj0CU4mvEBO6y91YiCcDq4DbBHyGYX7/RQmOED4lnudve+LTBViSkrDmP1QioCSvmw8ZVHGwXUZ+/HvbzPUr++y6k+2cCXiP/GAvoGqPxaNwOtJ59NQE+fwoqbTuGEMHYF1BOoI8fJyJAFpVP8zmczAccPfJy9/dr7ZnTZFP3iCIDRwgsLtOstauOMy+G2HVmTllEDiKwgRHAnO8uFyVaUwYk8WkoggSqGkdip20c7CTkiLeT+mN7zyqgMNE3cEbqwQetVdwct3cbSF9+dFcIYxfGSL6AM1CBv3Jr5JHNM8j7BIwdIY/Q7pLWrooDAqpE1Nx/qYC4lFMuK/EaThGS4oPske/9kClCF7pcK7EUPPhQdiWOAJeUBPvVlRXeJHc3pwkpg3DALzf2yMo4twx4elkJ+qyToa2zGaPbky/o0i07JPT1u1GyxqHlHNg+mTq2yAy9IHsKPVZ3YaJwq/CYkjPd8TUlxveyD13aWXoU6ngN5H1EE1Xp4eH6k52J2YSP8V8U4H2DWQjT+5xePZzao2hE5wEiXhAQQ3UHwUwkre2/AVUlymtdbAYwfOgxhmEQG41v/7QjudMwMqjuQtk+kc4awzIdwJEw9H3EM6Dfygyvx7QDoUemqqYntlH3
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(46966006)(40470700004)(36840700001)(2906002)(44832011)(336012)(36860700001)(426003)(5660300002)(8936002)(41300700001)(7416002)(478600001)(2616005)(8676002)(26005)(4326008)(186003)(1076003)(6666004)(356005)(86362001)(40480700001)(81166007)(82740400003)(47076005)(83380400001)(40460700003)(70206006)(70586007)(7696005)(54906003)(316002)(110136005)(36756003)(82310400005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9295
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ffcf11f7-c067-4ec1-9755-08db005bad9e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wrKvXjpwOrDWx7bYAnlTghVhMuRU0GdB/IfIoWvQaplvEuGxBNX87Mh2ePSS1MBQ5m8RGJisfglfm9xA57HINHQ2bE0zQzpar9hgztlnmAaQlovl35mG6/g9Uwh8xAfranCDJzKmvqMrFJEiMcdPCfIy5aGcPEPDxX+lsKgS9KIr2Po7W6v3CUaheV44y9JJqcmtLv2oBwCDODO/cGSMaX4HXpZ1KIEH17nl26mRna/RZimHL5x0tLmLNfRmI/0RaXiMFQlIlctS5VEfSmoJ69UoL9T70Cy3fDj4Xn++1gtGjlJigIs1swjFAKC8HS1k3z/l+5ZNjile36ZoPkXnuSx6gKrsPKt8i37w93OgeDnuDr0GJ8tuuOpAER0Te9zVt1a0nk8R7QYHmHdFCkex1WJ2SheS3P3Mz4pGPC3qrItR6jRG7Z13vA55w59youIczbViMUlWYh01R6G807bwZrQhxaVIDnDZmpSfM/0AVPu22kMMU/K9tz85pckxkBs5Ej8bkPFurXFe9oZLyqsL6cOGgpJOz474IZRbZSlwwZYFmb7Ckv6FIqEVsd59nRBMKu+k771A5KjczGQYeJi6utMOkm5E87pa/P0Ez98vlddv6hK7Ww42oOHpZ/XrXEU/vBF48ffYQ0OLtbQnN4gT4Hxl7gn/UfoUCVzW6d8o/PYbZJl0hl77Brfvhe5gE32UxQjO5uMvbJhIsnWthlxLCsEBe1Qqw/skhRKrAHguQ2A=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(186003)(8936002)(4326008)(70586007)(5660300002)(70206006)(8676002)(2616005)(316002)(81166007)(426003)(40480700001)(41300700001)(110136005)(36860700001)(107886003)(7696005)(1076003)(6666004)(2906002)(82310400005)(44832011)(83380400001)(40460700003)(450100002)(82740400003)(36756003)(47076005)(478600001)(336012)(86362001)(54906003)(26005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:26.4905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a9b32a-ff1a-4be7-a32c-08db005bb403
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7566

From: Suzuki K Poulose <suzuki.poulose@arm.com>

The QCBOR library will be used for Realm attestation.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 8448af36..8d450de9 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,8 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
+CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
+CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
@@ -25,6 +27,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
+cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
 
 OBJDIRS += lib/arm64
 
@@ -40,4 +43,5 @@ tests += $(TEST_DIR)/realm-sea.flat
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
-	$(RM) lib/arm64/.*.d
+	$(RM) lib/arm64/.*.d		\
+	      lib/qcbor/src/.*.d
-- 
2.17.1

