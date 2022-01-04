Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51F5C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B5FC49F39;
	Tue,  4 Jan 2022 14:49:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gutYnDTeE4Bh; Tue,  4 Jan 2022 14:49:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5616C4B103;
	Tue,  4 Jan 2022 14:49:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7702E49F39
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MIv9nY0sAmW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:48 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 755AD49F57
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:48 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 o13-20020a17090ab88d00b001b2080bbfaaso2548018pjr.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T6hXHkZPRWaJl03x2QXMcgYQnVlGJ4p7Dp80AmXpDqA=;
 b=AJ0bPZ1NpwYWYRZhLndCTSqogOo7XiUaZ/UjLqVU7cHLs9Mdi7SUhYWX2x/576gx2r
 tCLIGd6Pr6yHqtDaYDXsqcwF6ITe6QPsyRqxaOReY21N7Kl6+Sx0+V0uK2csFJY6XybX
 0xVsPtfmN+qRC5kGYfgt0H1p8vYf+hx+DY3VgQn157Yrt9QxI7PwsTwKW/eYXwq/OMsP
 Se9XKtz2lEF3/2kC0pimss9ZxccQiX4bCZtcruP4575qQvSGJySRVLFi2vqkcLM772ha
 kFILLe4Btz7d++g14WBdW4sIHMdzE6yJ71iPC6HdvWb7M4xW8tOAl5X7Pubxi3+fJov5
 AKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T6hXHkZPRWaJl03x2QXMcgYQnVlGJ4p7Dp80AmXpDqA=;
 b=VzXTU7NHTLTB+bj8C35Ghy2sfiDZrMPK5s+mWYbw3eBqZLtjSsQ5zv4aj1FBWAm/Xm
 8F0+SpLa3TO56ciafZQpbxmX/KTP0mzuMCE/uVZ7KEfTX7AxhlWWwce7KhJioO2P05a/
 OyBofQmfpm8B5rCSHUB3ec/AuaoK26DlxFAHDbF9ferEOQjC+PwV9ZpIXwDkI6AJAeT4
 EUpOxo2EmU/3VlNIBwn80zLUizBgJIhd3q53Fs48g+6A0fg4YFErqOW7ahttHmqnvYt2
 5E6VXvmQEQVAm2NLZxJWLfuFZ/1r/saVFzok21QovG6ZqX32RdewjXwb8EIJrWqHz4jb
 kG+g==
X-Gm-Message-State: AOAM532uzg78zK28q++yHXW5WlvjV3hXfln6GH//pzryE63BjWKCpV6c
 NxfLJ2kMIGWDCGpfQLt6PISXfeZL5voq
X-Google-Smtp-Source: ABdhPJwQF9Sh0A8e10VxttETJKJYLzfkIBz9hQW4ADfKatROuxTA+/JgjcWs4dTYR/RUwb0w/HuKzInAFEzp
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:139b:b0:4ba:a476:364e with SMTP
 id t27-20020a056a00139b00b004baa476364emr52491553pfg.59.1641325787730; Tue,
 04 Jan 2022 11:49:47 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:15 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-9-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 08/11] Docs: KVM: Rename psci.rst to hypercalls.rst
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Since the doc now covers more of general hypercalls'
details, rather than just PSCI, rename the file to a
more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
