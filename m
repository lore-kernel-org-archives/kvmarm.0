Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114368;
	b=x9bpnv2oya+T5hfVLHM0pvaS+r8MLf9rSGwcymjcMyzXAHjshH5PUqTphYQl8rAXw1j+
	 mFGDpmnbOAuTu3UJmoaPtKzJIdYsdsvWftXveL0OQ+LvMyWn8V2cWD1dbsukHqa8RWEcU
	 PAXHXL8vGG3Wzt0aNvxhdqsX+q2G3NjNZXGcuCAUfowhroSVkU9YBa7ScH2jQUfHsaD+5
	 Yau+iuEw0lImxWsRT4cBFKx0bCDAmGz99A5/fgiW1rK68YiPiwbqkqLW3rYDBRN7q8k8t
	 6DyWzgq1ALYatoxPOzQvpXjXFarsbwtDm73sIjIRmuUWsHrc/DX10KzbW+8Bw5RsUPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114368;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=wgoC6kwXy8A/C0dx8SZHvUCPruFTOKn2cEN7Wk/LnjU=;
	b=qE9/oipV5eNvIbgc8kc61Jb9t5jAhEjkeLXB9hJQhagJPTSwEmRfoFI5leqBdmODZrL8
	 AekchyslSoGg3nvtqRtnZpkiMc96XcxewrKVuYbrX6e0hx5upfMH89QDS4Ihq5n4nNwq6
	 XFVFN/EAEhrbFuhVQp7JxPtOR7RYv4+7tutOC5YYrlMZ8CuIequUqCCVNt4Uko6+vU1mU
	 6C2xtQvVU+Qv3lleQeJNvfCFmEooFk8WeRzXMRmz2n5oBzWlhoC7JZ/mFhKbPUaOOOMgb
	 xc2fVp/B2Pd8WIvjJ3Yjm+Vo/UfQdCYKehG2hG1F13kxCEeF15/o0MPaGlk1g5g/Cnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L5mprdBw;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6AF607316B
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C6AF607316B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L5mprdBw
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b26d8d2498so172230b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114367; x=1795719167; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wgoC6kwXy8A/C0dx8SZHvUCPruFTOKn2cEN7Wk/LnjU=;
        b=L5mprdBwX8jf/iJu/TDJdTlRAxQTGiTux/o2NJWccqJoEmxiKRPlVwOe52PBngq+m7
         adfc7ZnMNanwxVF7lJUJHeEhJewMexJFIG0asVt2XazMq1pm9HWsnCHuwryQLd4xNZ5P
         6tox1gtcgX4OmOQdXK3ijXUYCe7wnhIn8s4ylhZlPid5K3/PQOjxOkMLeNk47aAl2mLc
         VLQR7+qz7Pku+PvcJeXJYJqtd68Dr58wlc9lrufGGF4cfBbA/BWyuMmhGBlXkKTpxYrm
         lpP3p47KsveKdsyD8mQ+bb4gSpy75Ayox9tUEdAFDGFdSGlBJtpUpwIz1USc3eA1O8c9
         IZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114367; x=1795719167;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wgoC6kwXy8A/C0dx8SZHvUCPruFTOKn2cEN7Wk/LnjU=;
        b=JH+v8d8RDqh+DOQo0GVu3hU3Q5IsGbXklq9zWHvJZC/2COwo9yeNAYQDB5n3zchDLE
         JyTWCZv7wSnUGx+43ej6p6MIeDz83RZWvS8vRtQBy63o4sMBkwuSfT3eCEYfo/XcVY/U
         EGWb98mRBG/W4Bq221hte6DQ1b6Um3yCXktSjdtRcSux94zCpqWVfF9rMafZgWU5BnwZ
         VG7S5sq6jdw9PaTQlyBdscXQTT8UkkKA3RRtlt31l9VMhmD5mk5uGEFRVwgj0Ie/hX7z
         MIt8KO96KsU4rXGJs8/V/g+Fe0I8fYJO5bKoKT/vT37o2INkXpvlHDU0PMahhQgelxaj
         utlQ==
X-Forwarded-Encrypted: i=1; AL+hErHb9b/eFBSx7g1TRQ2wnFuoAFfEnlqX3UJir1TbvRAjhhAxEFosWvdbydyB67rXW9/rqmbURu4=@lists.linux.dev
X-Gm-Message-State: APuU4Z/R0Sb6GtQ2v0UqBqq7C0UPSW7Are2h46QTOU8Q9GymNTfSGVvr
	5Ag1VNVANj84az8GnRTAT+kUatjbB8Hr8P3Lsxm6+/49BtAPmeaSMHfJ128EZh3RdagHR/yjtY8
	hYq9yklIs65ndFmZZ628Wn2qWtw==
X-Received: from iloo7-n2.prod.google.com ([2002:a05:6e02:6107:20b0:54e:86af:fe5d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:191a:b0:4d5:291b:b850 with SMTP id 5614622812f47-57a0c4b956amr1020128b6e.54.1795114366859;
 Thu, 19 Nov 2026 10:52:46 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:14 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-33-coltonlewis@google.com>
Subject: [PATCH v10 32/33] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add lib/find_bit.c to the KVM selftests build using the same wrapper
pattern as lib/rbtree.c so selftests that depend on find_bit helpers
link cleanly when built standalone.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm   | 1 +
 tools/testing/selftests/kvm/lib/find_bit.c | 2 ++
 2 files changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 17a4256e90819..79b67a86208c3 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -5,6 +5,7 @@ all:
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
+LIBKVM += lib/find_bit.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/lru_gen_util.c
diff --git a/tools/testing/selftests/kvm/lib/find_bit.c b/tools/testing/selftests/kvm/lib/find_bit.c
new file mode 100644
index 0000000000000..5534248c663f7
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/find_bit.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "../../../../lib/find_bit.c"
-- 
2.56.1.708.g77570a6a1d-goog

