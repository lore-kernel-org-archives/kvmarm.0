Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A29C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6DE64B1B4;
	Tue, 14 Dec 2021 12:28:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 03FPN7cHwnDm; Tue, 14 Dec 2021 12:28:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680494B223;
	Tue, 14 Dec 2021 12:28:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2D04B1B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cCZl7iEtKWNK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:18 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B13F4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:18 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 h10-20020a056e021b8a00b002a3f246adeaso18338391ili.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EylPoIwJHu5cp6KovczhslrKEkEYeADu9LS/s52w9YE=;
 b=WptfY3NUSXg/+ge/bSycAdDXNGBatjC9Ty3fRvRO/naZtajLtOnCel1J92sJl+ffyB
 gn+26lozgkVnDFQXpBa6gsCcYi+iyY4OuU7RAGOitBJmuO5NpueNu8HQNe2wJsQlV6mb
 s7HQwUbg5T382xCMHMjdkKxRgEijgNNkXxlDoC+ukK9aQYxusDSDlIbvu7hlEhqY3DzV
 PXKES3uS5RaC0dZXWqfEbw+aUVIHfHv1KsCCPV6Bv9GfSPLPIO74l8okr9dVLvECSxr6
 aLA1+JI2wnVQl0R+IFRqmZ5wRbK2MPHwT1vTHXV+IlorXhALZmCfzJ++Gt7rw6BYo9I0
 i7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EylPoIwJHu5cp6KovczhslrKEkEYeADu9LS/s52w9YE=;
 b=QPclRenqxrT8SNoLboM8OrH/Zmm66n0IokjrGtZSx9zqhjsIxVqgvzu37ezAAirvad
 97QbI6KCd48btDxYpfsi9jX8d4nflpAHicUwoHRLIAksZVVOgDPffIujRl08GoM0u/Hr
 ZXo0Bmaehi5OfbubxjfuePTbUz2jSGgBXxYOtwxWLRJ/PGi52rv29RTxquA7Jkwitqec
 B+FaGf3yUul91/WyF7XyNeRnmr6GmW+X+5YlPCLwMq2M1444CkBK2S+bczkKD7niW/oj
 xSOCxmXtFaylP5I5PDLWJVBIl19nvdA5DXAnEe4/6VtTDkKOqpdUelJ+SHS2VTElh2YD
 dDXg==
X-Gm-Message-State: AOAM5305LN4TP0HY+pZyjmHuMc0iJmDfP8ic6In50LSJn9tm2QunPLG9
 xpW94F4nunmdrQ5N0Mw4Pr6lzNUzNmD4HAYufI+soYPNmyFPXN+AHBlO6K6E34GDITJ3Y/KWYzp
 7dzKobS4JGqilPa4K6uq5HcExB5Sbvu6VHxoXis/CZjhv6Mi+uKs+nsh3ZfxozhdE42IIfw==
X-Google-Smtp-Source: ABdhPJxlHuYVYQeqSWOyzJfDt70mmril4aeZVLx8iWFQhBCjg4s0ijgzuxjSVPZcN3dObuSd5rcGMlUpWSY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2d84:: with SMTP id
 k4mr4567077iow.168.1639502898040; Tue, 14 Dec 2021 09:28:18 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:07 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-2-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as
 undefined
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

Any valid implementation of the architecture should generate an
undefined exception for writes to a read-only register, such as
OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
behavior.

Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
write ever traps to EL2, inject an undef into the guest and print a
warning.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..11b4212c2036 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		return ignore_write(vcpu, p);
+		return write_to_read_only(vcpu, p, r);
 	} else {
 		p->regval = (1 << 3);
 		return true;
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
