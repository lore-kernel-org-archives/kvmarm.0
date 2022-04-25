Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58C4C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:55:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2369D4B14C;
	Mon, 25 Apr 2022 14:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bf91QzPkYNkQ; Mon, 25 Apr 2022 14:55:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B884B176;
	Mon, 25 Apr 2022 14:55:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B31834B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BT7+rdpQD821 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:55:38 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79A6949F21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:38 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 bj12-20020a056a02018c00b003a9eebaad34so9709570pgb.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9uTx7aTaC/NLaRkZRYuxSBWgFNaFafQzTssLeV88+wE=;
 b=Vi135yAFeO7udOCeaAa8g8PncqQD2Ti8D7eIsZ9O8PAJC26ERr+D4WKGvoixtnbZ2L
 dS/iSNj7XHFYkqFy8Up8eXFm+y0Vo2GhK8LiEqFwVmQ477NM8lLnuXifuwtpL0QP/XXG
 SzNIiUEB1BdR+K/o5y5QHPjTqjl5BoqbnrmC5CcG+ZZJ/Myi9hPqtJdr0iYNQWvP/QCA
 n3Ssf09NH9HuWxTyV+oBoDu7wA1mzHvbyq6fKKnncF9StIwEtFO43Ni5HD8NkkLpyWjg
 FSTGxuZcQ7GCPGA/GOHjKIBWWf20DAtfZOTBBIxRK/a1cdrWcUXsuxwzCkI2qwKNHRj8
 i64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9uTx7aTaC/NLaRkZRYuxSBWgFNaFafQzTssLeV88+wE=;
 b=HHjHKUDwSEPOrX4pcUxv295pfVcobsekqiCdUWP1ZfVRVM0dCOQ7jVipUPk1TA6it1
 yUbSr8FpTMCnX/kvr4DEx+YEzeD/tzojgrcWrawi+e44yMA/tFP2FUVuS+S5epoGQLCA
 /Z96y8TZXfho9wrVeHV9NEO3ThlwiW+BcI8diZNnB6fC7+VGrdLMxo3EV4lV/mX89fsp
 979Ds2pkwrgLa9zBD8jUpJNsK4EadE3bJl64FiAuK/Ndw2R3sSrJzXVs9fM/P7h3rOBN
 xNcGqO63B8NxqKm8DqqWfHMpXxA/8FH9F/Vcucbl21xi+xaFqhUB+cu53nzrYnNn9VCL
 AjMg==
X-Gm-Message-State: AOAM530dTw300heUhiJzX00+wTgL53zwVmiixtw/f4bG4nky8RM0L+Cl
 Rit/yFyJwURPCKqunVbpy1eYQ3wylwtnHA==
X-Google-Smtp-Source: ABdhPJzOSq9KMsDtiV7Cd14lQTX8+JymxLFUZW8dIG/X1TgjjURDXo3mDbViGv4RE7oF9qVFy4VQIL1bAyTxdw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP
 id w6-20020a17090ac98600b001d956e74e83mr692123pjt.1.1650912936913; Mon, 25
 Apr 2022 11:55:36 -0700 (PDT)
Date: Mon, 25 Apr 2022 11:55:30 -0700
Message-Id: <20220425185534.57011-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 0/4] KVM: arm64: vgic: Misc ITS fixes
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
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

The purpose of this series is to help debugging failed ITS saves and
restores.  Failures can be due to misconfiguration on the guest side:
tables with bogus base addresses, or the guest overwriting L1 indirect
tables. KVM can't do much in these cases, but one thing it can do to help
is raising errors as soon as possible. Here are a couple of cases where
KVM could do more:

- A command that adds an entry into an ITS table that is not in guest
  memory should fail, as any command should be treated as if it was
  actually saving entries in guest memory (KVM doesn't until saving).  KVM
  does this check for collections and devices (using vgic_its_check_id),
  but it doesn't for the ITT (Interrupt Translation Table). Commit #1 adds
  the missing check.

- Restoring the ITS tables does some checks for corrupted tables, but not
  as many as in a save.  For example, a device ID overflowing the table
  will be detected on save but not on restore.  The consequence is that
  restoring a corrupted table won't be detected until the next save;
  including the ITS not working as expected after the restore. As an
  example, if the guest sets tables overlapping each other, this would most
  likely result in some corrupted table; and this is what we would see from
  the host point of view:

	guest sets bogus baser addresses
	save ioctl
	restore ioctl
	save ioctl (fails)

  This failed save could happen many days after the first operation, so it
  would be hard to track down. Commit #2 adds some checks into restore:
  like checking that the ITE entries are not repeated.

- Restoring a corrupted collection entry is being ignored. Commit #3 fixes
  this while trying to organize the code so to make the bug more obvious
  next time.

Finally, failed restores should clean up all intermediate state. Commit #4
takes care of cleaning up everything created until the restore was deemed a
failure.

Tested with kvm-unit-tests ITS tests.

Ricardo Koller (4):
  KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
  KVM: arm64: vgic: Add more checks when restoring ITS tables
  KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
  KVM: arm64: vgic: Undo work in failed ITS restores

 arch/arm64/kvm/vgic/vgic-its.c | 91 ++++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 11 deletions(-)

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
