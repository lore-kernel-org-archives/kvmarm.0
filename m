Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3179528E8;
	Fri, 27 Jan 2023 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=SAvWSnN98f2hb9mw6rrD+Z8Q8+BgvgYk8FPgwqjl+d0IpFb2GFkQnh0bJraTYGz2Tv00EHHaJeOHV+MnhbCWsR3MXuXUVQuz75S3MmtAWbJJUJU3ML+Xx3lRRxcI8OQkPloDNjggRQt86Y66Xt+0o4br182JegpjmeuOlI/tUCQ=
Received: from AS9PR06CA0207.eurprd06.prod.outlook.com (2603:10a6:20b:45d::34)
 by DB4PR08MB8200.eurprd08.prod.outlook.com (2603:10a6:10:380::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:21 +0000
Received: from AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45d:cafe::61) by AS9PR06CA0207.outlook.office365.com
 (2603:10a6:20b:45d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT058.mail.protection.outlook.com (100.127.140.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:21 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 27 Jan 2023 11:42:21 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6c64ba3becf4f171
X-CR-MTA-TID: 64aa7808
Received: from b0a773cadefd.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 448B61F0-7F96-44A2-A403-35D6918DEF7C.1;
	Fri, 27 Jan 2023 11:42:14 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b0a773cadefd.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhXKrKTOXLunmpbCtIdiL/niGVW2nmU9SPyzCWwQAFliHuFsRjS+7KX4mxb24cgljXUcdStWgSC2jIuKWLHPfZwZT0gSSIii/rXa0Ca7kSYED7BFFVXLCuLX+gaejOcFuhBqwd7p3HzlkSNmXckq9yzn0sGbn+8pw4EskrmJ+nckKBYpzmiL2TfMcYK+5NrX4aMaCr5Hoig3Aj9ehr2X0hxv9sJBMikHsK3ZxSsC6P6sdfqekyFHCY0CUloDEhYYLlYEqGlMB8H/HxGQrX6MAbKdVsHN/t8LSje/oy5RvaJP+qyhWHZPXLMI/Ffp9DF0exW/ZuZdCoNOHJMlQ1HIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=mC94RW0PfzLraKBdD/pO2kqjRt6y+f+EgeIm6VugklubWGFTfqPqxZKcBN01d+DXQ3QlDW01uo9vBl0n4IppfuxtfdjYWixru0DQVDz6TxNtWTUPsKuSmh7I2zL1sIQnv5P+8FAR8CW8/aYEIaHE0iw3EcI7i4puKr9ALYI0diYEm5ObOi+TEXtgRYEH7juyCyVvTY5HbvlxJqFkJ7SO/d9WJfHczVka9oEBOugZXI6cfUJ5VHETrKHs8IGuSkPrLJLHLMGJ45c84kaikMULnCtIJBHUTCeG3XtjzmfCDbSg59HY/RXs6rO+CWql8OTtpD5LZVR0zg5LLc1N6jLRTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKUc6k5BydLVdfAhCZDW2BV1A+Pf2tNjyrVVfOkNRBk=;
 b=SAvWSnN98f2hb9mw6rrD+Z8Q8+BgvgYk8FPgwqjl+d0IpFb2GFkQnh0bJraTYGz2Tv00EHHaJeOHV+MnhbCWsR3MXuXUVQuz75S3MmtAWbJJUJU3ML+Xx3lRRxcI8OQkPloDNjggRQt86Y66Xt+0o4br182JegpjmeuOlI/tUCQ=
Received: from AS9PR0301CA0043.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::35) by DU0PR08MB8422.eurprd08.prod.outlook.com
 (2603:10a6:10:406::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:13 +0000
Received: from AM7EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:469:cafe::6b) by AS9PR0301CA0043.outlook.office365.com
 (2603:10a6:20b:469::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT029.mail.protection.outlook.com (100.127.140.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:13 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:12 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:07 +0000
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
Subject: [RFC kvm-unit-tests 10/27] arm: realm: Set RIPAS state for RAM
Date: Fri, 27 Jan 2023 11:40:51 +0000
Message-ID: <20230127114108.10025-11-joey.gouly@arm.com>
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
	AM7EUR03FT029:EE_|DU0PR08MB8422:EE_|AM7EUR03FT058:EE_|DB4PR08MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: dcc6efbb-3126-4011-fbd7-08db005b8d56
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 hhtDTy6STJ9a9QEZL8zimAoI431SQb3ajffRVUwOzB2azBv+DpuOUmqM+RiuF3PS1oYf9egQTcmaOmeUGK/TsGedqJvL0rt0jf+mEy3HpHwoFV0OVsgkVsF/gdt6qfgcr5XW8FdU9CqNJpshXKN9VaKmHimY+WLgbM1SEmF1fhE3AYaPzofWgRyO4T+/4/kukYHyhpKkdZ9ImwfWL/+iCxEaYdR5YZPDKxWlZR1PY8etGHY1JEROMdeeSyu/2ESSK0NjuQSKYi3iYJyzcrV52y9gupsTIcD8HlIH0LL00cn7QRyPKzQltircLKMVmm5SAqMlJ1NMfE0H94w5ttFNEINA4h+WFsgi/zzLLgTnExUjyy+lFNR3ge4TMElHf/f1R1ex2zvWH3MSaC8qaWgb0LkFiYyV28a2b7SXnt57cuKHsfwdJrnfRGklWBuxeuheykeHwqa8o+tTXZlImScG6tZZI+7RY3TAsvb8t5qOzPL9WpNqBHPr9r6d3xhRCq67WSpGfXGprxgG7rLCa/sPz471SOvhs9FoUfE5VDW6X4N5fGNz6yW8kkBiaZgZlw35zkn7lx7ry422F+zSrfZBIb8x5rMY/3uXj+0x3r8X5CkNKLQT5/M7NfLY2nbdKXoKshS/fABOxxdWWAczM+BxuqZV8C6fkEu/1+8BThjHjJtP7vQ0k9bOaV0z08XukMzAbdy/lhJ1w3pZvBru4hqey0IC/HSFWasxtAntWH39sX6DKHswIOxYAaa/Z6ftsPCY
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(7416002)(316002)(426003)(47076005)(82740400003)(336012)(40460700003)(6666004)(40480700001)(478600001)(82310400005)(70586007)(8676002)(186003)(54906003)(26005)(8936002)(1076003)(7696005)(2616005)(2906002)(41300700001)(36756003)(86362001)(5660300002)(81166007)(70206006)(4326008)(110136005)(36860700001)(356005)(44832011)(83380400001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8422
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93c97a55-017d-4a7d-2a0c-08db005b888a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RpQqJ5Q3NGMnw05M+p4qNL2HqzNwg+9Jy7jyUnWDYbic//GwCwYP8boKt+UDiVVdotJqP/V78fU6pJU9u0eMb4n+lG3jnEZgpIjacURupVS54DhovxfjGH+p9LK/Xpvu3ld4jkBL9oiyetnXWVtuK6nKTY3Nf5E6CrxLm6O33TBUgsII6yp8i3VyioiSZdp+ghNv61fiTpIeWiKo9U77HuSQzZdwjmleeAkRtFKSByxtVBSgCYuwKRBkTyKJhfzvWu4NLjUMXO767WKKxooUkjXxFJXm5LCKKu3peGByijNLHjD2I6O7Iy5jvJfEO7FbJ/TmT0qqggn9LDLNTWe0CURiM0O5EOPFFK4GZ38kPq+Yw9SZ0dAgPOGMApZXsO7qP/kJWVV30LuwnRTDe2p69mldjvqbbQnrChIiNwau3olGuKS+WlRvY2tVYrjXFk0NUW//lNLm0bBLyyqQ/33dJ1hbBoJoZr6qXm7vEBYQ6rgq6f2ddKNDKCtOMwCL0s7yL/ubjK1l4HtC/yQ+OPtqgf1oiSYCAKXgVoSdl89mH5As2kn7/DgMBt/uNhxlQAWbY+lgRHsmrQg/+TWkX1f7hmb5y9rhxUF6QkF6ALh0btWOX0LN/mUWTZV7uDSDRmHcfUrRiqCnPmkEYUs5RXtvqRglJd0kJJIOclhLhIG7N+mR3bEGlMdDSs4CCEaFp0+DmluYdWhdIfnRpiS5DvTTXmStEDFC8dSVKgWtNjG1Pvo=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(5660300002)(8936002)(47076005)(426003)(41300700001)(36860700001)(107886003)(26005)(336012)(478600001)(2616005)(6666004)(186003)(1076003)(82740400003)(83380400001)(450100002)(70206006)(40460700003)(81166007)(7696005)(86362001)(40480700001)(4326008)(70586007)(36756003)(82310400005)(8676002)(54906003)(316002)(110136005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:21.5587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc6efbb-3126-4011-fbd7-08db005b8d56
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8200

From: Suzuki K Poulose <suzuki.poulose@arm.com>

A Realm must ensure that the "RAM" region is set to RIPAS_RAM, before any
access is made. This patch makes sure that all memory blocks are marked as
RIPAS_RAM. Also, before we relocate the "FDT" and "initrd", make sure the
target location is marked too. This happens before we parse the memory blocks.

It is OK to do this operation on a given IPA multiple times. So, we don't
exclude the inital image areas from the "target" list.

Also, this operation doesn't require the host to commit physical memory to back
the IPAs yet. It can be done on demand via fault handling.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/setup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 36d4d826..7b3dc0b8 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -181,6 +181,7 @@ static void mem_init(phys_addr_t freemem_start)
 	while (r && r->end != mem.end)
 		r = mem_region_find(r->end);
 	assert(r);
+	arm_set_memory_protected(r->start, r->end - r->start);
 
 	/* Ensure our selected freemem range is somewhere in our full range */
 	assert(freemem_start >= mem.start && freemem->end <= mem.end);
@@ -252,6 +253,11 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	/* Move the FDT to the base of free memory */
 	fdt_size = fdt_totalsize(fdt);
+	/*
+	 * Before we touch the memory @freemem, make sure it
+	 * is set to protected for Realms.
+	 */
+	arm_set_memory_protected((unsigned long)freemem, fdt_size);
 	ret = fdt_move(fdt, freemem, fdt_size);
 	assert(ret == 0);
 	ret = dt_init(freemem);
@@ -263,6 +269,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
 		initrd = freemem;
+		arm_set_memory_protected((unsigned long)initrd, initrd_size);
 		memmove(initrd, tmp, initrd_size);
 		freemem += initrd_size;
 	}
-- 
2.17.1

