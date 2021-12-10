Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B738C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 17:36:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E779C4B1FB;
	Fri, 10 Dec 2021 12:36:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amd.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w5f0RLvp9jXl; Fri, 10 Dec 2021 12:36:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511C64B20A;
	Fri, 10 Dec 2021 12:36:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9884B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:50:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSAeSR0quzl7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 11:50:25 -0500 (EST)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2946749FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:50:25 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=du3/ZEWx+ZIB9gl2P4p9Qs8bYlBeF+cCFudFv7grftAWkVp7j1GcY1ymg/y9J3ubwpPH1DrtOAQtd0sW3ifZ7GdG3xgb76Wdk8DfCw9Lb3a0k3UY2KQ5+fTcrQ6XFroWCHwlQoZyXmf0lk93m/qCecxxEqAWi+IBCx9rVlW3cq2COVBqsh3FyNNJW7by0Y76SiHCGcjq0zo7fIN8y4W8Zz6JmEUSxhdxBpRcxfMs9x9N3X+invAW+C2FDTXoROSH3lDtDqbE7khpyanlu/E6XyMn59M3VETn4FO4GICqno2DAnqCvqbGE8utTveAiOKyq+pjgUD+tvtRANy76FPUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4l9G+qjt85QqPOsGsYkXeCESx2XZ8ap5AIE6PkjoMM=;
 b=QaNZNn42mPRDT/O8Czz1W2s8D8sKx5mR9mz/MbwWTr8sP61AgrVRB5Xn8MwUSPS1zTfnsoTX9hG1GobcqIyWuP2gFHtVT6GA3p30R7LM1Vd9ox+52NLGnuTZ6njfkvV96kouZiU4do7TZpB8yfA8Ua2tDwdD+7YUag75cVK9TEe+u5AG06WW2OMI+oChn7y0xw6ksPTRWqYWA/7dGPitol41Rra2mpzP6okj33w4F6XPPx6AJySSpzw6cyvUm2SxrQGqTCRo5F1ox0bi4G40O8BxCK76kvox+XRP0I8I99RQz+phhHkF+ozY2lpMdsMnObX0mA9bzB0gx0IqJnG6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4l9G+qjt85QqPOsGsYkXeCESx2XZ8ap5AIE6PkjoMM=;
 b=EMVb7M3rLeOAfnpq+EpzPouYcj76PDoDgsGWTnmdE5HMGRsvmAegT2V78j+zHgD44ufXwMzpl1F3mbY9UnrH7tQZ7Lzffp2JjRf9ZIGCZzlbTUuI91f5ScWiU5pFgYMYHdkyKoZYt/+LcbqueihNqPekiAOpVAJcasmQ901tkYg=
Received: from DM5PR2201CA0004.namprd22.prod.outlook.com (2603:10b6:4:14::14)
 by BYAPR12MB3272.namprd12.prod.outlook.com (2603:10b6:a03:131::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 10 Dec
 2021 16:50:17 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::df) by DM5PR2201CA0004.outlook.office365.com
 (2603:10b6:4:14::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Fri, 10 Dec 2021 16:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Fri, 10 Dec 2021 16:50:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 10 Dec
 2021 10:50:16 -0600
From: Michael Roth <michael.roth@amd.com>
To: <linux-kselftest@vger.kernel.org>
Subject: [PATCH RFC 07/10] kvm: selftests: add ucall_shared ops for PIO
Date: Fri, 10 Dec 2021 10:46:17 -0600
Message-ID: <20211210164620.11636-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210164620.11636-1-michael.roth@amd.com>
References: <20211210164620.11636-1-michael.roth@amd.com>
MIME-Version: 1.0
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be49715d-8936-4960-5614-08d9bbfd2519
X-MS-TrafficTypeDiagnostic: BYAPR12MB3272:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3272E0B28F2411FAC063DB1795719@BYAPR12MB3272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7W7CFHDhxDzCG0z9KczymrXGCAFjQOmQatbPWGL4gwXbP1t1ulg36/Esmld4o4VWw/vDFAhgFr2oYsEwqXHbZz+HoJCfdam5Elq27dSfNFfLMgaIMRJQA/zme4Q00FezwUu+xWfAWs4m/7xQ4dIexC3OqMkK37rAAsY8O32+Ie5UHPSJg2sQd8MizFZrlf/KCn2nuj3rhaxNCsRTZ+V9gwkYuzRNhtRM4mf+96W940sbQffMW3qJs5X4SRCPrO29vkF3YFxD8Cn6x24tEPTpqXlKdBGzHG6UN8tl+v3rBrZPffwWuM80329rf16fjYDvOg0fQrbHlNTCRUE4C4Nuiq9FWBZx44gdJYJOeDT0WqhmFfYpH3UCbd2VRNm6yq9PfqNDjGlyfBFWD+MmN3RktR3ibfVtH9i6JChnRQVSiNzwvV/g238Sh5gTzvSqFgSpwUYaME1vK32yLu3yu66YSp2xvizwlyQOTCs8bSgbaziBNSEb/4GDr3C/p3ko72PFwIedKK1+r+VW3x3VFVFSeJii7uYiqy2vjq3L7Wdt9ARsiUILVGlmOiBkJi0/LbwJLKpt0vJ//QkZT0lPTB9Y75JZyInnEoonigPc7ONXvdb4/qyxl2xnOXVQ0oI3Tw3XWqxz9sxlluexneo7fjU1eDieg8zTi9tWLnxnMIvThH8yCDAP9L/kIyzcR1cOHBuq+CuF9B2GuxdGnzx7tgbrspAoFCAHXzWLRMApyLxoJPE/eMCuzeUj9C+863itmgJNVFJyJRe8l7DOJbjp+P89zsa3A6Yqy4cgkO6XfaXPCw=
X-Forefront-Antispam-Report: CIP:165.204.84.17; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:SATLEXMB03.amd.com; PTR:InfoDomainNonexistent; CAT:NONE;
 SFS:(4636009)(46966006)(36840700001)(40470700001)(5660300002)(36756003)(336012)(316002)(356005)(81166007)(40460700001)(1076003)(44832011)(8676002)(2906002)(54906003)(82310400004)(86362001)(8936002)(16526019)(6916009)(70586007)(186003)(36860700001)(4326008)(26005)(2616005)(508600001)(426003)(7416002)(70206006)(47076005)(36900700001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 16:50:17.2392 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be49715d-8936-4960-5614-08d9bbfd2519
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d; Ip=[165.204.84.17];
 Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3272
X-Mailman-Approved-At: Fri, 10 Dec 2021 12:36:33 -0500
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Nathan Tempelman <natet@google.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Mingwei Zhang <mizhang@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Varad Gautam <varad.gautam@suse.com>,
 Jim Mattson <jmattson@google.com>, Steve
 Rutherford <srutherford@google.com>, linux-kernel@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>
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

While the PIO-based ucall implementation won't actually be ideal for
SEV guests due to the requirements/constraints on how the guest code
would needed to handle resulting #VC exceptions generated by PIO
instructions, it does provide a simple way to write/convert tests
using the new ucall_shared() interfaces so that they can be more easily
transitioned to handle running as confidential guests in the future
by selecting a different ucall_ops implementation.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 tools/testing/selftests/kvm/lib/x86_64/ucall.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index f5d9aba0d803..157d2a102547 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -38,10 +38,23 @@ static uint64_t ucall_ops_pio_recv_cmd(struct kvm_vm *vm, uint32_t vcpu_id,
 	return ucall.cmd;
 }
 
+static uint64_t ucall_ops_pio_recv_cmd_shared(struct kvm_vm *vm, uint32_t vcpu_id,
+					      struct ucall *uc)
+{
+	struct kvm_run *run = vcpu_state(vm, vcpu_id);
+
+	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT)
+		vcpu_run_complete_io(vm, vcpu_id);
+
+	return uc->cmd;
+}
+
 const struct ucall_ops ucall_ops_pio = {
 	.name = "PIO",
 	.send_cmd = ucall_ops_pio_send_cmd,
 	.recv_cmd = ucall_ops_pio_recv_cmd,
+	.send_cmd_shared = ucall_ops_pio_send_cmd,
+	.recv_cmd_shared = ucall_ops_pio_recv_cmd_shared,
 };
 
 const struct ucall_ops ucall_ops_default = ucall_ops_pio;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
