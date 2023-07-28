Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95331641C
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:19:20 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d06d36b49f9so2286826276.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568359; x=1691173159;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rBQV49SOR42QKJzPhh41wMJSTrzIZuQ00mtidD8N2XM=;
        b=6opsBea8GRXD2We8vqmJWkRvqQH67+YaaVfYQUyvCA+puzndvhs0EI/ABVbhf/zf7w
         qihaG0zKmWaKGIh5XxdWzAl6zRWgDmdN2/ArETbiDmdnfcpWo9RtIGG4he5D3ol0SgXI
         IJa252lfqbfLczfYkvnWWiOebVg63oRkzURD70V74J0eXCiEv4EiB9LOcHdb8iC9h7Kj
         DYvqDUZe2IerZx+0JDp6C+SvGZK342OQtkdeznEO4dp3j5XvKeTU3pcEIzCbada7WrKB
         3tkzVb7SEc4KXKIba1OfiRyCsC+1iSLd4VR/srr4GfGI7pkSlAwotV7MqxU82qvNJZcw
         xL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568359; x=1691173159;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rBQV49SOR42QKJzPhh41wMJSTrzIZuQ00mtidD8N2XM=;
        b=GYYUFjAigldHhG71rJI8jdQWasVVwo35cWQg4cN8XP9UdjFYLcoVWwrRB3RDKpjPvl
         D4SPJ/3RzCByv2WENC5ZXRhjTtvcbzG4kQgbFDmyEalvPgEQtcQ8yjjQ8Jyv0Wmm4Owh
         T3uFiVohVUbbRirMAWNd2K1fW1FguBHsc6z/YMaYwwouvXbejPA+oo5w/qJ5rOMO0tj0
         tS7XtJRIjahiBKl4HSXjXHgBs8Qg4llCB9XCt2K4nUIjLFb8UlWj/OFRCbkK5GlbkWuv
         eZrws5LnF0Z4fcbSMnw5PMiGrfyQx6JUWliY8j4Vclgc6an4Azu5XKQVQ17MR56jHoso
         0QVg==
X-Gm-Message-State: ABy/qLb2E7Q5mAFc3CpqRoQRevI8g4qy5fQ5OuIq/B1dVdKmxHeRNi14
	EznqFWc0C3MK4bRf34KI9Ue8doClDjo=
X-Google-Smtp-Source: APBJJlHgy87ZIulzDCKRfOMr7SIddiJkpyFfJopQjGYNAQz1ySEW7Aq0RA9oddYeo/R8Mk0CnZ5/HTYiLsY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:69c6:0:b0:d0f:cf5:3282 with SMTP id
 e189-20020a2569c6000000b00d0f0cf53282mr14549ybc.1.1690568359638; Fri, 28 Jul
 2023 11:19:19 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:02 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-1-reijiw@google.com>
Subject: [PATCH v2 0/5] KVM: arm64: PMU: Fix PMUver related handling for vPMU support
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

This is a consolidated v2 of two separate series, [1] and [2].

On systems where the PMUVer is not uniform across all PEs,
KVM currently does not advertise PMUv3 to the guest,
even if userspace successfully runs KVM_ARM_VCPU_INIT with
KVM_ARM_VCPU_PMU_V3.
The patch-1 and patch-2 will address this inconsistent
behavior by disallowing userspace from configuring vPMU,
as such systems would be extremely uncommon and unlikely
to even use KVM (according to Marc [3]).

The patch-3 will fix improper use of the host's PMUver to
determine a valid range of PMU events for the guest (the
guest's PMUver should be used instead).

The patch-4 and patch-5 will try to hide the STALL_SLOT*
events unconditionally per Oliver's suggestion [4].

Presently, KVM hides the STALL_SLOT event depending on the
host PMU version, instead of the guest's PMU version, which
doesn't seem to be accurate, as it appears that older PMU than
PMUv3p4 could implement the event according to the Arm ARM.
Exposing the STALL_SLOT event without PMMIR_EL1 (supported
from PMUv3p4) for the guest won't be very useful though.
The patch-4 stops advertising the event for guest unconditionally,
rather than fixing or keeping the inaccurate checking to advertise
the event for the case, where it is not very useful.
The patch-5 stops advertising the STALL_SLOT_{FRONT,BACK}END
events to the guest, similar to the STALL_SLOT event, as when any
of these three events are implemented, all three of them should
be implemented, according to the Arm ARM.

This series is based on 6.5-rc3.

[1] https://lore.kernel.org/all/20230610061520.3026530-1-reijiw@google.com/
[2] https://lore.kernel.org/all/20230610194510.4146549-1-reijiw@google.com/
[3] https://lore.kernel.org/all/874jnqp73o.wl-maz@kernel.org/
[4] https://lore.kernel.org/all/ZIm1kdFBfXYMdfbV@linux.dev/

Reiji Watanabe (5):
  KVM: arm64: PMU: Use of pmuv3_implemented() instead of open-coded
    version
  KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
  KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
  KVM: arm64: PMU: Don't advertise the STALL_SLOT event
  KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}

 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c | 44 ++++++++++++++++++++++++++-------------
 include/kvm/arm_pmu.h     |  3 +++
 3 files changed, 34 insertions(+), 14 deletions(-)


base-commit: 6eaae198076080886b9e7d57f4ae06fa782f90ef
-- 
2.41.0.585.gd2178a4bd4-goog

