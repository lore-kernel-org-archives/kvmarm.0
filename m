Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7B81DC070
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835277; cv=none; b=i/qICD92+kUZjKTrh22fvwPixMcMBCyRXlJugS3s0GlL8QJykjBoGOFRUUBwLRo1YDDmfGISlOZYFvtucgyzAL1VqYN9RQfYHLdNZjObnd8sU76J8H2LZRl6Wkg1iBB1MysMpJvodTT2bZ+W93l6QpZM3xShkODMClEbvmwT3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835277; c=relaxed/simple;
	bh=RjOB1weeIm0Fvad3NPlxI/Iwb9RCMfzoaaroDP6RpP4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PbcjSawuA8+FaP7iFOOGb3Jown7du7Gsxe6XFlsuj82zlwH9wbCjGNxxmw4VqYJVvAHb/SmZ9MW20L/NUmixYdqr1G9ZSXCYtfCXtTMbdUOsnTe+3+66tBYFsFvvEA4D69gOTO+ywX1JUdsCWzG8luQNJX905zS3j10DDynaKAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VMVuJ/wv; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VMVuJ/wv"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e3313b47a95so7987494276.3
        for <kvmarm@lists.linux.dev>; Tue, 05 Nov 2024 11:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730835274; x=1731440074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1kDemeRRcfLF2O+g89Ve347OTeAjaVFT/WyHCeg28DI=;
        b=VMVuJ/wvWHglIzZB0cLloeH/Pk4ZYwDz6zdMtSEZJVtPn23AGmeZqM4sRCax8i9Ovh
         2KvrYJzD4wYmuvEfDUoNHZL4y/y7bps9In1j/fQ7cbKSz0nz5JngDvlk9ovDFsC4/XD0
         WYKnIXmkAMIdGWCwQD9b63FLzGhwqOg5aM5UN2PAJ+oUawz06lIurxdnJojOunaGZB4+
         nmi/LpsOU6CcqDlkfYf7iOdWZYQHpac4m1qzWfknnw9VpnH9WdPjy48D4/8p9eGG3Xb4
         WVeTkBdsiIjBTfT+Tov7D6cNL47/r1/wVVx7Bp8EOatqiIBdbytKj7s28e61u9ymTUEG
         zaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730835274; x=1731440074;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1kDemeRRcfLF2O+g89Ve347OTeAjaVFT/WyHCeg28DI=;
        b=wdv4MBmevcKlUNlRKOHKEoDS3QBBtb9Erihl7gVrsRLZ7sODhxNruvDT1or2fcEzre
         v4WCNv9VCjIo6Jh6KpqaAlZIDIRHySEhqBx3JlRPBJY+qL2htMynEprFCk6y04q0wi97
         /VURLud7voTjmbDrfUd1RR0RIKXOkHPNO5zMIlc2MffApIhLSaGUMFrBAKa30afrYgBn
         Gz8DECUwMdFOuSr++iVBNp74LlzG6MIUbarnDqAYIwIFnyXvPQTtzEYsZEy1E3qg/5Uy
         AsgmG3NKBR6jNPlxgASidksO1dRHoLNPg8XXeDx0iKwYw/xWkO4ZtE5JPzL7q4cM+CTV
         Njpw==
X-Forwarded-Encrypted: i=1; AJvYcCVE1ZD98CqQFyHjxpN+DwSeNZP4mIKmakh1QYZURozPx55iZdXCtx4yBcuo5bog07EWMk5kDSM=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm0L/i71+k3+BA5R5FPI7qAOWIc2ofbFJcWgOYbFfo8ouIhnV2
	estDPdMA4c2rNJqDF2q7l41Pn1khi9IHkAVVXxkByNZvwpnD6HBYGV4sthKhw1mFAZ8zQjO55tA
	xmYWEO0irCWOW6z34ti5GEQ==
X-Google-Smtp-Source: AGHT+IEfQN1GX0nvXB8mRoHxNkSjhHGvcGwolBcEqfNEKCNyhhGmJmIBlngJwnRFkHrfsc5HAiabELF0rMUBpWgruw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:ff19:0:b0:e2b:d0e9:1cdc with SMTP
 id 3f1490d57ef6-e33110bc767mr17266276.10.1730835274324; Tue, 05 Nov 2024
 11:34:34 -0800 (PST)
Date: Tue,  5 Nov 2024 11:34:18 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241105193422.1094875-1-jingzhangos@google.com>
Subject: [PATCH v1 0/4] Fix a bug in VGIC ITS tables' save/restore
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.coma>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series addresses a critical issue in the VGIC ITS tables'
save/restore mechanism, accompanied by a comprehensive selftest for bug
reproduction and verification.

The identified bug manifests as a failure in VM suspend/resume operations.
The root cause lies in the repeated suspend attempts often required for
successful VM suspension, coupled with concurrent device interrupt registration
and freeing. This concurrency leads to inconsistencies in ITS mappings before
the save operation, potentially leaving orphaned Device Translation Entries
(DTEs) and Interrupt Translation Entries (ITEs) in the respective tables.

During the subsequent restore operation, encountering these orphaned entries
can result in two error scenarios:
* EINVAL Error: If an orphaned entry lacks a corresponding collection ID, the
  restore operation fails with an EINVAL error.
* Mapping Corruption: If an orphaned entry possesses a valid collection ID, the
  restore operation may succeed but with incorrect or lost mappings,
  compromising system integrity.

The provided selftest facilitates the reproduction of both error scenarios:
* EINVAL Reproduction: Execute ./vgic_its_tables without any options.
* Mapping Corruption Reproduction: Execute ./vgic_its_tables -s
  The -s option enforces identical collection IDs for all mappings.
* A workaround within the selftest involves clearing the tables before the save
  operation using the command ./vgic_its_tables -c. With this, we can run the
  the selftest successfully on host w/o the fix.

The core issue stems from the static linked list implementation of DTEs/ITEs,
requiring a full table scan to locate the list head during restoration. This
scan increases the likelihood of encountering orphaned entries.  To rectify
this, the patch series introduces a dummy head to the list, enabling immediate
access to the list head and bypassing the scan. This optimization not only
resolves the bug but also significantly enhances restore performance,
particularly in edge cases where valid entries reside at the end of the table.

Result from the test demonstrates a remarkable 1000x performance improvement in
such edge cases. For instance, with a single L2 device table (64KB) and 8192
mappings (one event per device at the table's end), the restore time is reduced
from 6 seconds to 6 milliseconds.

Importantly, these modifications maintain compatibility with the existing ITS
TABLE ABI REV0.
The table entry was a valid DTE/ITE, or an orphaned DTE/ITE, or an entry of 0.
The dummy entry added in this patch series presents a fourth kind, which is an
invalid entry w/ an offset field pointing to the first valid entry in the table.
The dummy head entry is always the first entry in the table if it exists.

An alternative solution, proposed in patch series [1], involves clearing
DTEs/ITEs during MAPD/DISCARD commands. While this approach requires fewer code
changes, it lacks the performance benefits offered by the dummy head solution
presented in this patch series.

---

* v1:
  - Based on v6.12-rc6

[1] https://lore.kernel.org/linux-arm-kernel/20240704142319.728-1-jiangkunkun@huawei.com

---

Jing Zhang (4):
  KVM: selftests: aarch64: Test VGIC ITS tables save/restore
  KVM: arm64: vgic-its: Add a dummy DTE/ITE if necessary in ITS tables
    save operation
  KVM: arm64: vgic-its: Return device/event id instead of offset in ITS
    tables restore
  KVM: arm64: vgic-its: Utilize the dummy entry in ITS tables restoring

 arch/arm64/kvm/vgic/vgic-its.c                | 154 +++--
 arch/arm64/kvm/vgic/vgic.h                    |   6 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 562 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 7 files changed, 713 insertions(+), 41 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.47.0.199.ga7371fff76-goog

