Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2090CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67A84B092;
	Thu,  3 Nov 2022 21:11:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jVX-Mf8Och7u; Thu,  3 Nov 2022 21:11:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87EB04B0BA;
	Thu,  3 Nov 2022 21:11:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E34924965C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aJ7YDvzIWbnY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:18 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCA8340D23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:18 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 h9-20020a25e209000000b006cbc4084f2eso3602933ybe.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=DVyQMJ/hVRvvulqgoMW2WeWXC7WT0Qk0m1EuDV5v41A=;
 b=PQ01Z/eWCROdg6wptfL9xDEZzpuwG0L8Xm+zs8jhf8zCDIKQHzgHS2nYXtnxlIotzm
 QK0pJhfhkSTRdHdGFphaXaLW1wNck7vtuv15Cz3sELQBwWxIVmgfSSbPdHUXVm+F1NXE
 VACBoH2MK+PRd3kTd/87J0HS5jB+JpvZeWsto5Z+1PvCcYoxya2SDs7W63OS/SkKAqYk
 e4h+LHQ+zRqw6B5kSDX/xzaRtYzuRalDlXNp5zcoGD+hmpQUwJhImh32C5LnLg34BwTP
 LJ+wnwtZsSakJ7QaJglHzffQdgmQkl/8eLWdd7P/evkLEdw1ajSbxO19hQL9wfyUwZnS
 +e7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=DVyQMJ/hVRvvulqgoMW2WeWXC7WT0Qk0m1EuDV5v41A=;
 b=X4QQTQVkjJSd255npDGA5ZHyzAfxBCMIpSRpzq90ArWYaYYfsN/bAbnj4QZBYQo47M
 vn4NUfPGTihRbu8eYJ19PZAyseMZcHQc0TskSdApunvM9WhWdPRiozcyxPx85mSL4tbB
 syxbGrpuJ0RMsXUpHTbZDAqdz/QQ9yNynlW/+iAqCfoKSktXrSm1H+SOh9qRTir/x12X
 l5pmKy/jJ/xdx3Bx5F7syrgSlkqKPB3gWOZFIpidrTTgLoPOktmGvd6sPqsFTD6+8ALo
 1P90kW5SDwzjoNn6RBb9voU9VKxVLRKYWF60bhFha6zJ6qa2KVf2/A85vE90HdeB+f3z
 /CsQ==
X-Gm-Message-State: ACrzQf0mspX41Sdcgou6PNL7C7HiHFHx0yvNCncwVFTNwABGpz9GAjhD
 1/KG8v9UEjKPSWN2m+LeuQnnLBo=
X-Google-Smtp-Source: AMsMyM5iy+9LxEdaoz+PBI8tytwaj51kRKgjlikY6ojuKPepInTV3TsN3lEgpA/59HjnDyluctdWXjE=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a81:7094:0:b0:370:4592:dffe with SMTP id
 l142-20020a817094000000b003704592dffemr219576ywc.345.1667524278368; Thu, 03
 Nov 2022 18:11:18 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:41 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-9-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 8/8] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..b55f80dadcfe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7385,8 +7385,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
