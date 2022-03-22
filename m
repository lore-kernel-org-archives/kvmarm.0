Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CF9C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 17:23:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C9349F1F;
	Tue, 22 Mar 2022 13:23:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6RemknLL6S3B; Tue, 22 Mar 2022 13:23:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4E849EF1;
	Tue, 22 Mar 2022 13:23:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E4249EEF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xphrwmuQDIqo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 13:23:23 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 930EE49EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:23 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 n12-20020a1709026a8c00b001538f557d52so7447022plk.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 10:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=UeIt97cm1BRk6/PsYhB1LZn33tpqzrs0+uoJF47O1VA=;
 b=h9KxQnjhkxAfeU5hS3Bb2LHL5TmRVM1hLrf/f828/4dpBa0R1bpbOUBDaw62jbWOVm
 MrmGHyiDNEq2lqWab+oonCHuy1DD4q6J5ltQurZ3QOyJnPRah0ZTZq5DUW9M1dQuHfFv
 txl1OLK1476sSMKGofvd1ECM5eovOFHVw8l4iOIBE08e2gWyDr3tSEAVxDuikIF3HbvL
 0JPD3PkqKnJy67BR/FGhZgBqdZTq6I8hxP4okdS4E0jWbX8NLTZ/IhwG5mCletRIuxiU
 Q7P7TDLbrEpbcqPnV0o5N3DALwqHjsQZ3pb/wxlF1ahzePyG5BPRoYp74izk3zUPlNjR
 xe3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=UeIt97cm1BRk6/PsYhB1LZn33tpqzrs0+uoJF47O1VA=;
 b=UwvG+Aqkb7SVnP1nQZ6phCmYyJwY+YgsL1KvDRF7ArVUvO8GIgn9xa2Sx9jNad9IDE
 9byfcloaQWkTz69+JQpl4+Dww3AY0QmtHNtXpM6xPf+2w4fxcVpOT2/FKxgjee70610Y
 7bf4WuvrDghbJotEgzN0ZMPkNeTa2zWq5fmpxMz00/tbI0P0jnGED6t/XCS73OuHYQUo
 kRx+uWRhGjDfCnapZ9gIL8/UlGYt4Ja97oiS0Z6+JqwFyfEpmiqVGqPCy9e2OL31lTwf
 wsY31PJTN5vTALZOfZgVlFotu1Xk3rJygujFPkI+ngupcDR/PI1odg2+/C5OWqmodL1H
 9tiw==
X-Gm-Message-State: AOAM5305bxQ4BIYdCakkC+nhUbR2LxDrJOqK5nLxLpxmx9eakwpiO4kG
 Mr2z6UG0u7XkYWf5eFOxXC8Mu9wVLRwnUA==
X-Google-Smtp-Source: ABdhPJwR2LEhQxUGrhAGf+33uw31jUQRxS9+Gf1ipPFzFOQGFcAaO0HtkQJ9SAD981hJNcbkoBCeMCztgTXsWQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f682:b0:154:8500:80bf with SMTP
 id l2-20020a170902f68200b00154850080bfmr4553264plg.112.1647969802560; Tue, 22
 Mar 2022 10:23:22 -0700 (PDT)
Date: Tue, 22 Mar 2022 10:23:15 -0700
Message-Id: <20220322172319.2943101-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 0/4] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

v2 -> v3:
- Add missing isb when polling for IRQ being handled. [Oliver, Marc]
- Wait for a counter pass by polling on it (instead of the previous isb).
  [Oliver, Marc]
- Edits in some comments. [Oliver]
- Dropping the msecs_to_usecs macro. [Oliver]
- Skipping test if desired pcpus are not online. This needed adding a
  library function (is_cpu_online). [Oliver]

v1 -> v2: https://lore.kernel.org/kvmarm/20220317045127.124602-1-ricarkol@google.com/
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

Ricardo Koller (4):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: selftests: add is_cpu_online() utility function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 904 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/test_util.c   |  16 +
 6 files changed, 941 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
