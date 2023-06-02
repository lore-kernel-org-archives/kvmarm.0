Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF42332E1
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 17:02:51 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-565a33c35b1so30870687b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 10:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685725370; x=1688317370;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yIiKOLGKczROWKwulUVtZ2M9/BiqL1vWmyT9WxaSM60=;
        b=pgEp6VvqA7aBhrJuKZzQ4zBVM03oPZHiD+4ylV7AFMyKOKMZY+kiaxDz5l0Ypk+iO2
         MUF7c2eCaBHPpjtDiRh4GgjpTtJsKr/1ezP7uIgCNumlJZWWgEbgxSkLBGDTITBINiP0
         h/+lY9p5RUWI1mm3RgI0TT6fMDQdeLaT406FqAvUvjluat/s5sl9h9AAkK/1H2Hx1sPb
         TIkOmqDFjvVeSWe6Fnaup3uBKk9/wxZeRRXAEAdCIgNMknlLeaSgWKp6DPYDAKTDliwK
         r7EIWTuWCPHj9hwA5oafkO5VzVh8JjN1pTIPxJYZHGvkqCYUIOhocoXxB+jqaTvCi1vw
         DqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725370; x=1688317370;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIiKOLGKczROWKwulUVtZ2M9/BiqL1vWmyT9WxaSM60=;
        b=ld7+sOSjiEz0hMYLcYGfj5qEnv3oIc8EblxZWNSNJib9y9nEf6RU2x1d/huTSa69+Q
         f/s0fK58oeFsP/JaJ4EDJw4FruSPygvMKLREc/+++VRNEAR1cXKGye9LZ1578wq2gUn4
         LKynoqPsX+QCAUAx81iaS3kTcasrvrCAbYm5iUBSaf/fZLnCM7SkLvnAjWFJHTdkmzf6
         Y1xW84B2Cp5x7LhstRnZgpjltD1jo/yp3H/Jwv1soieE6t/5ghCNKaP1JwB+zzTKbEaM
         oRRy5d3f2cTaAhQPJi6j9DLQXDV7j26wT+Tqjfv6KLANOW5N+SrOfCbHHYrsd4ujEynH
         T5nQ==
X-Gm-Message-State: AC+VfDyz7uS+FUKoc9/lf2sEhBRTtvflZn/J6EKJ4B1T+9SGkRCekeFH
	652NivssWKLVWxHte5GK4U2khH6fjdC1nsn8qA==
X-Google-Smtp-Source: ACHHUZ6Vu7NrmZDIrdvPM8A+x+HDDvlXsWN3Wbj3yjrPjyPq4Je9swBQszqmoLNylUJ2YOeY/0U1p8/9fWz27M9x5g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:114b:b0:bad:89:29d5 with SMTP
 id p11-20020a056902114b00b00bad008929d5mr1364181ybu.2.1685725370603; Fri, 02
 Jun 2023 10:02:50 -0700 (PDT)
Date: Fri,  2 Jun 2023 17:01:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602170147.1541355-1-coltonlewis@google.com>
Subject: [PATCH 0/3] Relax break-before-make use with FEAT_BBM
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently KVM follows the lengthy break-before-make process every time
the page size changes, which requires KVM to do a broadcast TLB
invalidation and data serialization for every affected page table
entry. This is expensive.

FEAT_BBM Level 2 support precludes the need to follow the whole
process when page size is the only thing that changed. This series
detects said support and avoids the unnecessary expensive operations,
speeding up the execution of the stage2 page table walkers.

Considerable time and effort has been spent trying to measure the
performance benefit, mainly using dirty_log_perf_test with huge pages,
but nothing was seen that stood out from ordinary variation between
runs. This is puzzling, but getting the series reviewed anyway may
spark some ideas.

This is based on kvmarm-6.4 + Ricardo's eager page splitting series
[1] to cover the eager splitting case as well. Similar changes were
originally part of that series but it was suggested FEAT_BBM should be
its own series.

[1] https://lore.kernel.org/kvmarm/20230426172330.1439644-1-ricarkol@google.com/

Colton Lewis (2):
  KVM: arm64: Clear possible conflict aborts
  KVM: arm64: Skip break phase when we have FEAT_BBM level 2

Ricardo Koller (1):
  arm64: Add a capability for FEAT_BBM level 2

 arch/arm64/include/asm/esr.h   |  1 +
 arch/arm64/kernel/cpufeature.c | 11 +++++++
 arch/arm64/kvm/hyp/pgtable.c   | 58 ++++++++++++++++++++++++++++++----
 arch/arm64/kvm/mmu.c           |  6 ++++
 arch/arm64/tools/cpucaps       |  1 +
 5 files changed, 70 insertions(+), 7 deletions(-)

--
2.41.0.rc0.172.g3f132b7071-goog
