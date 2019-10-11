Return-Path: <SRS0=GvsF=YE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F072ECE58E
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:37:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 430E021A4A
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Hck08CYv";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Mwsi3iYP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 430E021A4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEC514A8CC;
	Fri, 11 Oct 2019 07:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QnvZRFsLON4j; Fri, 11 Oct 2019 07:37:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A14B4A8C2;
	Fri, 11 Oct 2019 07:37:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C92EE4A85B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 06:35:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YkWbgtmpcNJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Oct 2019 06:35:35 -0400 (EDT)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com
 [67.231.156.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD3A64A891
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 06:35:35 -0400 (EDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
 by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 x9BAZRGm013225; Fri, 11 Oct 2019 03:35:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=87JPA48dvGJKVdSdPQvFlc9iaktmFk15a+O4ywqObeM=;
 b=Hck08CYvApYnnZnDyYqwyyWUEaUaXXFT0ZOcSIsOahhJguBZse5HEUYeQpU1XQCc1F9i
 DUfJSnn8iixjg2J7OlcrViTS4Mm+LsygzeYl3AgkdmDcjpbdLjS3kTAIgdJf9SokwaLI
 D0hEkZ1Mnzhg9O2UUNpHeMEY5+F+XQkos3Ns5cRlochTI+tZzYMyOrSM5W3CwvPGpAb6
 S2jUOCY7LP8jswybiYllkBNaDBLbNr95EL6zMV/499LhYRlLJzopJLgbcbIZObT6H+cu
 CLFgi6KJNtBoFEnlpvdETzXYHmC5EDu0qUDXHd1c8hR1uAI8++ChLQUto5tWXUA1ANXE pQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
 by mx0b-0016f401.pphosted.com with ESMTP id 2vhdxc1867-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Fri, 11 Oct 2019 03:35:26 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 11 Oct
 2019 03:35:24 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server
 (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 11 Oct 2019 03:35:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmbL+1v8ABG3mDP9LL/tWIJfGGvcG6PyGb5dH+22aLPyJb9idxmzBE1y4Y7D2KCr+pKQmutwMrBkgdiOi3hC9RDahqPYHBUXkoprCf0ZKOishpTGM1XbSzNYpSMbdc6vptCrxYM1/es401a8Cv5J6hAp3vweAejhV2ZztQbAZlZlkElPG955/5UB+6eoXBljkODwmghXyfV9hMO7j+b0gNF219ooxtmr0v1C5XAH0s0mOTzK3hte8v0cyrWEwN9yQ9wccf00H6xAgzcno3l9EceTdol8TN639cXwGG4O7UJlAiFwDe7gChvPfF1WN7i8KzkhofvL+ife/Bdlz7ETTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87JPA48dvGJKVdSdPQvFlc9iaktmFk15a+O4ywqObeM=;
 b=n96piyqfHrpeRtttGgI1tm0qljXS6dbgWAUv9ZZniPtsCl2Q9sQZ7V4izivHUH/R20t9RJuN/NnxcmAqX4A0454QtE+3pdbunipa9HWHwVY54AoKCfpczwbRqjyFk0UcIpSHiftAWjVS5YxZdS8GXspq5wlCXQnkEAYy2jzSTinFv1sbnv1n8p73uP19DmPYRq1AK+/ZvJN8VUOLeK0cna9qNcFQs6w/1X32vEm0iwlQNEsegmkcV1BvUFHkrxkB3q3c4H3d5MmYHFZvmo7a0wDmxbjvkfBewB0ajBx5AdctOp9XINpo0UBfwl/763ilgtYAIHjMyRaOejAojuBgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87JPA48dvGJKVdSdPQvFlc9iaktmFk15a+O4ywqObeM=;
 b=Mwsi3iYPlCS5WDSjifxB16HXnE74XtM4JLrcAsOj9Ht85NBf/31EreRlnU9dka2OCIxxjamtEBEvq5fluTdOWN6b/vJLN1t88eN4JcR9HJ60msiNMfJS10P4jBPyKxixajHO9Ayl2pGXE99fBciclfKzW8E1QrQknCOdn/6D/Fc=
Received: from CY4PR1801MB1895.namprd18.prod.outlook.com (10.171.254.153) by
 CY4PR1801MB2006.namprd18.prod.outlook.com (10.165.89.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 11 Oct 2019 10:35:22 +0000
Received: from CY4PR1801MB1895.namprd18.prod.outlook.com
 ([fe80::95d8:1a9a:a3b4:616b]) by CY4PR1801MB1895.namprd18.prod.outlook.com
 ([fe80::95d8:1a9a:a3b4:616b%7]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 10:35:22 +0000
From: Jayachandran Chandrasekharan Nair <jnair@marvell.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH 0/2] Workaround for Cavium ThunderX2 erratum 219
Thread-Topic: [PATCH 0/2] Workaround for Cavium ThunderX2 erratum 219
Thread-Index: AQHVgB+Vbftzc36XPk2eg+jEtD33lA==
Date: Fri, 11 Oct 2019 10:35:21 +0000
Message-ID: <1570790105-31829-1-git-send-email-jnair@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:40::28) To CY4PR1801MB1895.namprd18.prod.outlook.com
 (2603:10b6:910:79::25)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [199.233.59.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32584ae4-3165-4480-edf5-08d74e36b7eb
x-ms-traffictypediagnostic: CY4PR1801MB2006:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1801MB200670DCDAF853D9081AA8C9A6970@CY4PR1801MB2006.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(199004)(189003)(2616005)(4326008)(14454004)(305945005)(8676002)(6486002)(316002)(6436002)(8936002)(81166006)(5660300002)(102836004)(81156014)(386003)(26005)(52116002)(66066001)(6116002)(2906002)(7736002)(2501003)(99286004)(476003)(4720700003)(256004)(107886003)(478600001)(3846002)(64756008)(66446008)(2171002)(66476007)(66556008)(110136005)(6506007)(486006)(71190400001)(66946007)(186003)(54906003)(25786009)(86362001)(2201001)(71200400001)(50226002)(36756003)(6512007)(14444005);
 DIR:OUT; SFP:1101; SCL:1; SRVR:CY4PR1801MB2006;
 H:CY4PR1801MB1895.namprd18.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xE/YEduyEeZhzoVUnRqPMQSWrEng4GKkYEMcIE0ers9bcGVGez+iaz0UjGOcR1CujnRd+y60Ry/TowceqiNdMANzJFf4Q4BzAipnGpzKKbhq9J+TDp5f73hEubFLP7e7SuXzXZ2g/r7Spkjxy0S9GAFvJJt5VrpXSX4SU6oIOL/m52Vp1RwFV9sR8PSc9IZ0GWoBSOokg1ht12Ku6L+sdKYOrw54d0JsYASLk98PhKpS50iUmFP3U1U8l+2ZynIZqxE2C6/zWOtuJryHXYmdF4kgnaTY4DrRlHqgLXCndl4XaeKGo+1RYY4FOY7u05Ue6Bxz1iikXI/Ruc9QsoLdU6J/EfqHEN9eNcp4Uggm4IGGDgESC3n6uPvLyW1nYq9K1EZfnPNbIZGitMUHGuY/ZpbOVhNUFa3FrdpkCf3ZtDY=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 32584ae4-3165-4480-edf5-08d74e36b7eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 10:35:21.9056 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I17ip6wUNdFt6hzAP6Lr5yT2w4msFICCJkSO+KCJwbWrfQGLLgZ3nJy2Wj7VxKtS6CMh6SvjnNiaebUK3YmRwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1801MB2006
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_07:2019-10-10,2019-10-11 signatures=0
X-Mailman-Approved-At: Fri, 11 Oct 2019 07:37:53 -0400
Cc: Tomasz Nowicki <tnowicki@marvell.com>,
 Robert Richter <rrichter@marvell.com>,
 Jayachandran Chandrasekharan Nair <jnair@marvell.com>
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

These two patches are based on the work by Marc Zyngier and addresses
Cavium ThunderX2 erratum 219.

This erratum (originally reported by ARM folks) is from an interesting
use of the prefetch instruction in the KPTI patchset. The prefetch
was done between a TTBR change and the corresponding ISB, and this
occasionally caused a crash on ThunderX2.

The first patch removes the troublesome prefetch for ThunderX2.
The second patch addresses the case where the issue can be triggered
from a guest kernel. The workaround in this case is to trap TTBR
accesses by setting HCR_EL2.TVM for guests and doing the system
register update from EL2 in a fast path.

Due to the nature of the erratum, the trap-and-emulate is only
needed when SMT is enabled.

The overhead of trap-and-emulate is expected to be negligible on most
workloads. A command line option kvm-arm.vm_msr_trap has been
provided to override trapping on guest TTBR updates.  This is to
address a very limited case where a user wants to run SMT enabled,
with a trustworthy guest kernel, and wants to avoid the performance
overhead associated with emulating the address translation register
changes.

JC

Jayachandran Chandrasekharan Nair (1):
  arm64: KVM: Add option to trap and emulate guest VM sysreg updates

Marc Zyngier (1):
  arm64: Workaround for Cavium ThunderX2 erratum 219

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/arm64/silicon-errata.rst        |   2 +
 arch/arm/include/asm/kvm_host.h               |   1 +
 arch/arm64/Kconfig                            |  12 ++
 arch/arm64/include/asm/cpucaps.h              |   3 +-
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/kernel/cpu_errata.c                |  15 +++
 arch/arm64/kernel/entry.S                     |   2 +
 arch/arm64/kvm/hyp/switch.c                   | 115 +++++++++++++++++-
 virt/kvm/arm/arm.c                            |   2 +
 10 files changed, 156 insertions(+), 3 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
