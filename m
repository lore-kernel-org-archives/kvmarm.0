Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D92C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 17:40:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D384B2D2;
	Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LqALztifSjgO; Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 944B44B2B7;
	Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A374B285
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rIRqzbpjbVBw for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 13:40:50 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24E7D4B270
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:50 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 h10-20020a05660224ca00b0064c77aa4477so3601102ioe.17
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 10:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gTC6wbFjulJGpnpdlR2cK65pyxNM9FH8zxgBPKIedMA=;
 b=IWfMP6PPwTJ7suUb8PtMClWLhu9Q7lmuLZmLxHUiZhB7qG4ONiUnCn55RSteRI6Lj5
 WnEriAXO/P4p+M1csdNAB/x8uJiummx6Y0/TAZvBpSRquz7KG9vvI9Z6+/yhFBG80bUu
 39n7syXyAT1fsyP29qR+jYISRWRnLync2LwfFqLxLJaprc1qfO6clU6/t+z5WaogkP/5
 pF2RgGe/XeZ5vptUf4kb+iPKSZrA25QUiVI1NECCavK79JLnaNP1nDRCJ8PGXkQUIXcp
 9MIuPc1dQkdbiiC/Rw1s3I6v/S07jCmPozzTf7mjzKbEIjMM3oXDFA7NbxxInFHCcbGP
 OarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gTC6wbFjulJGpnpdlR2cK65pyxNM9FH8zxgBPKIedMA=;
 b=B/suGboHhM81EdFDt8aeBsv0euVK6N5S+grd35w1EjnOX5hio56QFuTmlXhGx9BhGQ
 VwHlmRyVuRiQvLu98KhPmN6NxQzBEv6Ll+YZ77nnzSsWwcFHNZeyrxQB3x8nPDSO1fwG
 WOy3Q+1gqyueRxtWs5+RE6yMjgkq3MOQ69SpfO2i5NL3zCDXn0ULaBtrkSyLElkItAQL
 WnAJK1pB0V3uOXPfoyam+MEObqP1msPVG3c+vS2lYe5NsOW4UKDQLDdL+xGohKYXVv71
 WhT5ems55qU2xckLK+7P3fdhU4G7VJg57x2IheDv8WXOdGMcvd3c5Ek4c2vcYjD/Zl9v
 zAsg==
X-Gm-Message-State: AOAM5303aK+Oe/0BJuLVa4GU7eelJlDqX8uAhrXy23vCiAs9bEDR/pj9
 3HnGbIYTiOVdX9uCYVkTZrgJb9o2pm+ygzzbTJz4iHRrHevf1i/mIlmXw/SPcuZNYuRsg7QmTkE
 kYUrBWR0FEa2x7Sh1r6YsaGBqRqxTVJytrZ2LG7bzzjfXxwE6EydTGnX36eRH+3dq/48UaA==
X-Google-Smtp-Source: ABdhPJxh22igukLOyB7xjQIkB7xrRakZ5rtTFEJOHvXCH6QTQaKRf4Vev65C2RCw3Khe1CzIiG7PGVWShMA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:6810:0:b0:2ca:1ff:e32e with
 SMTP id
 d16-20020a926810000000b002ca01ffe32emr2313380ilc.212.1648921249504; Sat, 02
 Apr 2022 10:40:49 -0700 (PDT)
Date: Sat,  2 Apr 2022 17:40:41 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-2-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 1/4] KVM: arm64: vgic: Don't assume the VM debugfs directory
 exists
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 stable@kernel.org, linux-arm-kernel@lists.infradead.org
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

Unfortunately, there is no guarantee that KVM was able to instantiate a
debugfs directory for a particular VM. To that end, KVM shouldn't even
attempt to create new debugfs files in this case. If the specified
parent dentry is NULL, debugfs_create_file() will instantiate files at
the root of debugfs.

Since it is possible to create the vgic-state file outside of a VM
directory, the file is not cleaned up when a VM is destroyed.
Nonetheless, the corresponding struct kvm is freed when the VM is
destroyed.

Plug the use-after-free by plainly refusing to create vgic-state when
KVM fails to create a VM debugfs dir.

Cc: stable@kernel.org
Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a76251..cf1364a6fabc 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -271,6 +271,9 @@ DEFINE_SEQ_ATTRIBUTE(vgic_debug);
 
 void vgic_debug_init(struct kvm *kvm)
 {
+	if (!kvm->debugfs_dentry)
+		return;
+
 	debugfs_create_file("vgic-state", 0444, kvm->debugfs_dentry, kvm,
 			    &vgic_debug_fops);
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
