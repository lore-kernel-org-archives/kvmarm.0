Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F16AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:15:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3363D49B12;
	Mon, 24 Jan 2022 19:15:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sKu29TMihlzA; Mon, 24 Jan 2022 19:15:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7F649DF6;
	Mon, 24 Jan 2022 19:15:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8CF4086C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:15:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFUGDSPIBKkA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:15:36 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B6DD49B13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:15:36 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CF44EB81229;
 Tue, 25 Jan 2022 00:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7BCC340E8;
 Tue, 25 Jan 2022 00:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069734;
 bh=cINPFgKL2Ut8k3Oy2wD5fkInRC1CnwPrnusLBuDdThE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rCK1SZunrWXe+7ZyudtrRKUAZGI+kJyrnmNoVMEdUOtL/RfLAkTHpM/6MDHGdL148
 sidTPKmV5jxBIUlw6SA3zLaARUWmyQTAs+aZE4vo/4g7jWdbSKgCsa3rtpgYnxqRrX
 8WhlsoTEYa04CxRAaeBaKEDxoLbkoTDXuDR9oKfRv3yiPH6jEVSe4+simzqW9nTmY9
 KUsZKJIB7YUurz/6wdd8vcW2+m77AXo1wZ7QRMWYRJJ5UkgZPid6TsIZpDAPbUXPql
 FKpcO12EfbrC87YWAjy8hSzYSA86nN6G3BMJPdpDgzeIVdBlsBBB+FusmZh2xt0zUF
 9TkIWDDMu86dg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 03/38] kselftest/arm64: Remove local ARRAY_SIZE()
 definitions
Date: Tue, 25 Jan 2022 00:10:39 +0000
Message-Id: <20220125001114.193425-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1265; h=from:subject;
 bh=cINPFgKL2Ut8k3Oy2wD5fkInRC1CnwPrnusLBuDdThE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70ADgEzITa3c+LpcX6BANIKS7MW2GTUq48+G78Hk
 TYKq/JWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9AAwAKCRAk1otyXVSH0B33B/
 4jGPTVDPXx5T6RrRQk+H/OZk4Q5FhydGJNUZltYSbxp2FS8RmrhFNNw1esXn0AlycrgQ9rwwowrbKe
 CiKGCDLRViQNPTdUV3LJw+Y0Vcek/EMZ8jt/V2gvTgJBPV2T81jU3c1rKM+M9EcGoZgVFkS9achgIB
 vFQzDbxFI+CBqoHoZKaQtIeZQf980w5QM9F8UOXwBYRrGy6upxq4ak3soifhA1pEMUtpOacjYsmfUV
 MZ7azYBToWAPWAZwtE3h3nIs98uAc7o2Cim8vVpB5spVWhpWWUOcRFdlia6mg3oIeb2O3NACwlYtoP
 gBS121Zj9RX2yGvS5iudEdvG2O3DbR
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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

An ARRAY_SIZE() has been added to kselftest.h so remove the local versions
in some of the arm64 selftests.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/abi/syscall-abi.c | 1 -
 tools/testing/selftests/arm64/fp/sve-ptrace.c   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/syscall-abi.c b/tools/testing/selftests/arm64/abi/syscall-abi.c
index d8eeeafb50dc..1e13b7523918 100644
--- a/tools/testing/selftests/arm64/abi/syscall-abi.c
+++ b/tools/testing/selftests/arm64/abi/syscall-abi.c
@@ -18,7 +18,6 @@
 
 #include "../../kselftest.h"
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
 #define NUM_VL ((SVE_VQ_MAX - SVE_VQ_MIN) + 1)
 
 extern void do_syscall(int sve_vl);
diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index af798b9d232c..90ba1d6a6781 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -21,8 +21,6 @@
 
 #include "../../kselftest.h"
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
-
 /* <linux/elf.h> and <sys/auxv.h> don't like each other, so: */
 #ifndef NT_ARM_SVE
 #define NT_ARM_SVE 0x405
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
