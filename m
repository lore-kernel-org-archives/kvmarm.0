Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FFBC2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 11:27:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D01BE20B7C
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 11:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D01BE20B7C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 884DA4A47A;
	Fri,  7 Jun 2019 07:27:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rECAG1JdeAZK; Fri,  7 Jun 2019 07:27:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D454A50D;
	Fri,  7 Jun 2019 07:27:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF694A3B2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 07:27:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7s-FXupE+o9j for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 07:27:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADC54A501
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 07:27:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1975B360;
 Fri,  7 Jun 2019 04:27:16 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 240973F246;
 Fri,  7 Jun 2019 04:28:55 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool v4 1/8] update_headers.sh: Add missing shell quoting
Date: Fri,  7 Jun 2019 12:26:22 +0100
Message-Id: <1559906789-20936-2-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1559906789-20936-1-git-send-email-Dave.Martin@arm.com>
References: <1559906789-20936-1-git-send-email-Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

update_headers.sh can break if the current working directory has a
funny name or if something odd is passed for LINUX_ROOT.

In the interest of cleanliness, quote where appropriate.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
---
 util/update_headers.sh | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 2d93646..4ba1b9f 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -11,17 +11,17 @@ if [ "$#" -ge 1 ]
 then
 	LINUX_ROOT="$1"
 else
-	LINUX_ROOT=/lib/modules/$(uname -r)/source
+	LINUX_ROOT="/lib/modules/$(uname -r)/source"
 fi
 
-if [ ! -d $LINUX_ROOT/include/uapi/linux ]
+if [ ! -d "$LINUX_ROOT/include/uapi/linux" ]
 then
 	echo "$LINUX_ROOT does not seem to be valid Linux source tree."
 	echo "usage: $0 [path-to-Linux-source-tree]"
 	exit 1
 fi
 
-cp $LINUX_ROOT/include/uapi/linux/kvm.h include/linux
+cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
 
 for arch in arm arm64 mips powerpc x86
 do
@@ -30,6 +30,6 @@ do
 		arm64) KVMTOOL_PATH=arm/aarch64 ;;
 		*) KVMTOOL_PATH=$arch ;;
 	esac
-	cp $LINUX_ROOT/arch/$arch/include/uapi/asm/kvm.h \
-		$KVMTOOL_PATH/include/asm
+	cp -- "$LINUX_ROOT/arch/$arch/include/uapi/asm/kvm.h" \
+		"$KVMTOOL_PATH/include/asm"
 done
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
