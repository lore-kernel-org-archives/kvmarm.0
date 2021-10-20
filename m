Return-Path: <SRS0=uoKB=PI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C982C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CA816135E
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CA816135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A6FD4B101;
	Wed, 20 Oct 2021 10:27:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dp7XT6LLxF8X; Wed, 20 Oct 2021 10:27:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9734B11A;
	Wed, 20 Oct 2021 10:27:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC214B0A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:04:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdnfYb1Hc4mw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Oct 2021 08:04:48 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BB4D4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:04:48 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 e5-20020a17090a804500b001a116ad95caso2293827pjw.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 05:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=BCKWEoi8FeeBRDvl5EymVEm69MjyykXFzH9HAs/kyO4=;
 b=cuiutl2QAAxfwD56hLItqR8kvhCEQ7NLO3pkxhfHS9+G/fMLr1/t8rKVJEqmHJiNpb
 CZ21EE6qwrk20h7kpm27tNC/c4jVdseWv2S9gIsftsOTHCsJLoVZJc0mJkI8+oObIRwY
 pMNdJZGPHl1m5HRFt9dwroghBaTQXLkVX66aE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=BCKWEoi8FeeBRDvl5EymVEm69MjyykXFzH9HAs/kyO4=;
 b=GEM2o5Ulo61ZyIERKDz7tfimFmm5ixeE7sSKccrB/OhjvoHwBFSYS0CPaXEJEIp62b
 P8Ln0fTloyHuS7jBI3gDbkajvpd29eGWf6Hv9jJ3scDt1DwRvTIv9sphhyTSipYZ8IrQ
 XYviSAGrCj5NJRClTM7NqbScjmpeVOV11IianyJsYXuMLIHr6BJBQAHR3XEsqkrZCoQo
 CNa4PUv/cGC7MDTqiENUA0a64niOYUruiVyd62wqG9bKGx4rqnHKYQ1UXQuk+PpQNPM5
 ygyqwKgBacvFA12VM30Sfen7gCyfQUEjnHkbLQqWxz29xWc35Skmq7OqyZOHDxQO3xUu
 0gvg==
X-Gm-Message-State: AOAM530yo8rI0L8zGNDBCW9yzReyElPglXHHkroLLRCqqcGIhukEZVxK
 wLarKQCwzkV8B7qBDLHyJ0pCAQ==
X-Google-Smtp-Source: ABdhPJzr2LjWMqwdO+RhWupttHiFUwdUh98FJ2jVhkMKr665jMBIQfRoeEZuFCiB3w1/PLoDsOA18Q==
X-Received: by 2002:a17:90a:c206:: with SMTP id
 e6mr6827339pjt.193.1634731487726; 
 Wed, 20 Oct 2021 05:04:47 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
 by smtp.gmail.com with UTF8SMTPSA id fh3sm5721784pjb.8.2021.10.20.05.04.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 20 Oct 2021 05:04:47 -0700 (PDT)
From: Hikaru Nishida <hikalium@chromium.org>
To: linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
 mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
 vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Subject: [RFC PATCH v3 0/5] x86/kvm: Virtual suspend time injection support
Date: Wed, 20 Oct 2021 21:04:25 +0900
Message-Id: <20211020120431.776494-1-hikalium@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 20 Oct 2021 10:27:47 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 senozhatsky@google.com, Ingo Molnar <mingo@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jonathan Corbet <corbet@lwn.net>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Hikaru Nishida <hikalium@chromium.org>, Ingo Molnar <mingo@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, suleiman@google.com,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Lai Jiangshan <laijs@linux.alibaba.com>, John Stultz <john.stultz@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Juergen Gross <jgross@suse.com>,
 Stephen Boyd <sboyd@kernel.org>, Borislav Petkov <bp@alien8.de>
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


Hi,

This patch series adds virtual suspend time injection support to KVM.
It is an updated version of the following series:
v2:
https://lore.kernel.org/kvm/20210806100710.2425336-1-hikalium@chromium.org/
v1:
https://lore.kernel.org/kvm/20210426090644.2218834-1-hikalium@chromium.org/

Please take a look again.

To kvm/arm64 folks:
I'm going to implement this mechanism to ARM64 as well but not
sure which function should be used to make an IRQ (like kvm_apic_set_irq
in x86) and if it is okay to use kvm_gfn_to_hva_cache /
kvm_write_guest_cached for sharing the suspend duration.
Please let me know if there is other suitable way or any suggestions.

Thanks,

Hikaru Nishida


Changes in v3:
- Used PM notifier instead of modifying timekeeping_resume()
  - This avoids holding kvm_lock under interrupt disabled context.
- Used KVM_REQ_* to make a request for vcpus.
- Reused HYPERVISOR_CALLBACK_VECTOR IRQ instead of adding a new one.
- Extracted arch-independent parts.
- Fixed other reviewed points.

Hikaru Nishida (5):
  timekeeping: Expose tk->offs_boot via ktime_get_offs_boot_ns
  kvm/x86: Include asm/pvclock.h in asm/kvmclock.h
  kvm/x86: virtual suspend time injection: Add common definitions
  kvm/x86: virtual suspend time injection: Implement host side
  kvm/x86: virtual suspend time injection: Implement guest side

 Documentation/virt/kvm/cpuid.rst     |   3 +
 Documentation/virt/kvm/msr.rst       |  30 ++++++++
 arch/x86/Kconfig                     |  13 ++++
 arch/x86/include/asm/idtentry.h      |   2 +-
 arch/x86/include/asm/kvm_host.h      |   2 +
 arch/x86/include/asm/kvmclock.h      |  11 +++
 arch/x86/include/uapi/asm/kvm_para.h |   6 ++
 arch/x86/kernel/kvm.c                |  14 +++-
 arch/x86/kernel/kvmclock.c           |  26 +++++++
 arch/x86/kvm/Kconfig                 |  13 ++++
 arch/x86/kvm/cpuid.c                 |   4 +
 arch/x86/kvm/x86.c                   | 109 +++++++++++++++++++++++++++
 arch/x86/mm/fault.c                  |   2 +-
 include/linux/kvm_host.h             |  48 ++++++++++++
 include/linux/timekeeper_internal.h  |   5 ++
 include/linux/timekeeping.h          |   6 ++
 kernel/time/timekeeping.c            |  56 ++++++++++++++
 virt/kvm/kvm_main.c                  |  88 +++++++++++++++++++++
 18 files changed, 432 insertions(+), 6 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
