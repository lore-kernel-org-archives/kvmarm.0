Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4FDC4332F
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 17:40:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B74854B2B7;
	Sat,  2 Apr 2022 13:40:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6oKtjaumQaiJ; Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B05074B2CD;
	Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 502A14B2AD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VuVRCGYTMz6o for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 13:40:51 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32B7A4B26B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:51 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 q137-20020a6b8e8f000000b006495204b061so3606649iod.14
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 10:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EDhTuekQtNdm8MWzZ4rgwl9Zuy6sown5y5t0K60oNeM=;
 b=B8kXE1B9TLeU0fkKkRjLEwnu0j64XSm51isipBSezaI+aW4AtZHnIwm8TGZj11qhjH
 fZQIml2v0tbIQEfE+Rdi8YKENmjgZx3JLnbDQpunt+Lhb02W6Vt4aMuEdjjmWuAMIpU/
 qpWP9KDaobTe+W3uOxEt+HSwNp7VpmQMyoKm+GSu+CZFLH6hjzjaKFfyU2AcF0kukXvm
 QDYThdKrd3I540B7S51JbBoxsphYIIH++HAYKwcqXN8Ak3NZOiSQbOk768apsr0G4RTv
 RVSLI2Pn5gd7HrzXW15CZPCcJCKrOG3MkeCDtxEhDwRuVNo6aCWkbdOKa9xeJ/7BVvad
 afww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EDhTuekQtNdm8MWzZ4rgwl9Zuy6sown5y5t0K60oNeM=;
 b=NJZEhapWzxF2F+7loZubNdnjwNYV+AFMuZN+RRet7B7LC/T9qB81O9VLOGRRW/4oej
 T0o3DwYLIG0P3jIhFlD0Sr7FvReGv/76dNr9Z4Zc/0lHXAaWqOhflz+wmXLx7HdBhyk3
 blpvYP6Lz0VVM39hu8qWyTMFlS0KP+GsgQpQ0RzkA/4NoOKScY+PEbVQJXY1WOhVvDBH
 +0KERFcCryRQZhCjQ0uAceglOIiFSTNp8sO0HwHffhqHxc91P4qXBGBCVtmlTCzCaBRo
 2oQxpVipSLbvQ4cPKs9mNvQVXQaT20JlRoy2g47zK2UuQ/MJ6EqSS2W2uo6jbRdAH5Zm
 K9NQ==
X-Gm-Message-State: AOAM531koZoheq5tmAXL+Go21hsgOmVhUxu8AEzs+TEewsIIIalAeu6Q
 uDm0NlCyh+7u7sKEF3NMK5YM80cWj8KCCzw7J2SD5lO8IL2LjJPfoGE4kTh81ivHyq401dUXDz2
 zG6pqDhJeXT+OQP/btwxBrG5IrmyG2W3pp/vkXkUWdP6nbpd9f4UON8avBKGmsJXwA46YmQ==
X-Google-Smtp-Source: ABdhPJwx6B48zoyhRzOI+UWoY4wiun1eWGRgsGjvJOKksNdUx4f7qTvuv/CNaHpOREGjQo9q8Bk2CyZ29n4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2c8b:b0:649:e67c:9202
 with SMTP id
 i11-20020a0566022c8b00b00649e67c9202mr2148843iow.75.1648921250592; Sat, 02
 Apr 2022 10:40:50 -0700 (PDT)
Date: Sat,  2 Apr 2022 17:40:42 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-3-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 2/4] KVM: Only log about debugfs directory collision once
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

In all likelihood, a debugfs directory name collision is the result of a
userspace bug. If userspace closes the VM fd without releasing all
references to said VM then the debugfs directory is never cleaned.

Even a ratelimited print statement can fill up dmesg, making it
particularly annoying for the person debugging what exactly went wrong.
Furthermore, a userspace that wants to be a nuisance could clog up the
logs by deliberately holding a VM reference after closing the VM fd.

Dial back logging to print at most once, given that userspace is most
likely to blame. Leave the statement in place for the small chance that
KVM actually got it wrong.

Cc: stable@kernel.org
Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69c318fdff61..38b30bd60f34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
-		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
+		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);
 		dput(dent);
 		mutex_unlock(&kvm_debugfs_lock);
 		return 0;
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
