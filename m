Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC78DC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 16:20:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E7749F07;
	Wed,  9 Mar 2022 11:20:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P0vgH5s1oRU2; Wed,  9 Mar 2022 11:20:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0308649ED0;
	Wed,  9 Mar 2022 11:20:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B4449EAA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lDIVE1cSbLmZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 11:20:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 219D9411C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:20:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DF89168F;
 Wed,  9 Mar 2022 08:20:52 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 762AA3F7F5;
 Wed,  9 Mar 2022 08:20:51 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] arm: 32 bit tests improvements
Date: Wed,  9 Mar 2022 16:21:15 +0000
Message-Id: <20220309162117.56681-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

First patch is to allow the 32 bit tests to run under kvmtool; second patch
fixes running the 32 bit tests on an arm64 machine with KVM. Both patches
came out of a discussion on the list [1].

[1] https://www.spinics.net/lists/kvm/msg267391.html

Alexandru Elisei (1):
  arm: Change text base address for 32 bit tests when running under
    kvmtool

Andrew Jones (1):
  arm/run: Fix using qemu-system-aarch64 to run aarch32 tests on aarch64

 arm/Makefile.arm | 6 ++++++
 arm/run          | 5 +++++
 2 files changed, 11 insertions(+)

-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
