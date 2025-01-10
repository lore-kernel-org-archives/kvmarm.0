Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5A520B806
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 12:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736511582; cv=none; b=USe/XhOt+GLbOj6ERLtfSef6IcUwM1JX/yKG1KTSX5gw9Moob7sxnLTGizttjtM/yg/Nrcocrc6JagajfJEaT/hw3Lif/N6NXu6XGEz8VIxH8eGxn22WmOTrUyOlxRNyjRqi+Gq8L81/I4Zm6tMVmAICF0uuKbizn5/nykWO6UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736511582; c=relaxed/simple;
	bh=jPPYxI0QGS+aGeaOC87mgF0DAk/ei7BLA4n40IrJGWI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kEjHd2MHNfu7kRiqt3N/ZEaMZQ7BDZhXlXVILY9IflA0rdhfsfZ34BoVnxBRcn4Lm6fl4knuev9Zb3wiyx16V12b+4w/qrHpqxejGBYGwbWn4FzJTer4TvY8U93nDPefH1HNT/J6FlAS8Y02m9F/rs60sIM1APZB6uOywyOOm40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2+mlrD9g; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2+mlrD9g"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3d9d6293fso1756893a12.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736511579; x=1737116379; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UzIA+H5wuzkNSSs8ypYnf254qfQr3qGIN47AimFa5yo=;
        b=2+mlrD9gLJ/lZJkWqUyJqwfJnPv6d6cluy8Clp2pzVaXhf0hVUM+isuB7LWvhEiICv
         vpOgWaIOnUW/nqgMBNuvRR7iqbDznomGNlhOw+YS7IqOKu6MQkPgdyaWHvKIFvM8p4hy
         r9bRXXzSXbSJi/SK3/o1HZOOxxkSpv0lm/fuZEREm5smG2N5E9JkSkKB9tdDNjsklhjq
         4EkGNkD5nYrmkiG0Ful8AUxwtVDsSV9nuaXpKwNWo919pq1TblSQpU6e81EIc3BFoMW/
         z5/kPUPmNI9ULE7CxSeaA7jTNDoB9CMxyEolWk83EHkBViRaJrhDx5RoA0sCe+iDXG7o
         YuzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736511579; x=1737116379;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzIA+H5wuzkNSSs8ypYnf254qfQr3qGIN47AimFa5yo=;
        b=tDNz3fYwOZKMMuSdOQ9Mc4Pgtm/k5ITmcvvSj6X3juW6NImTPl+4O2veyi1BcadRmt
         L8N0XRqzZgYAElZKK5NGrX/Io3w3zPtc3rebkHf+IBY4oDhjF1AR9LeHM8smNVJUdQkh
         VyGxp/lFNIrllbWXDoizu9k4faN/30O2vYvMw4EcBZfZ+5o1BYUQdmVOazGvhv3eaaYl
         CSfvUqdU0M2cjG6KnejpS01ZUBJlhJKLmdjtLgG422xt6gMvwwryduLK38vQ+zG2RJjz
         N/lsy/l0mkm1DElFGxRGluPt4hoSZ12of4ztiJPlu1KDm35uLJYME0ucsqlwJCpBhd4I
         W7Mg==
X-Forwarded-Encrypted: i=1; AJvYcCUU4yRCfYXh0can3El/tXD1d9yJpCxO1fQf9VzNQe3w3JPfsTJt8eIDxs6qpnhmAajrI4IqjyI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx39c/AUmNykIlk4YkDlDS7ALHF+1XUIKgUVznRAb9r/qkCOp3V
	zqXIJmXG39BN17hXlbZNQhXG1GUKLn49bAgYwmGAGPxP28D7teHgczUCWNeO39aQy3ROAucrGE0
	+Ic0Jyw==
X-Google-Smtp-Source: AGHT+IGkGANyUq4Shs3jRgORa03NUzS4pqhfTUeC/iJcTMOHEUTfabfbJYGdVRZfbZG4wkvfE8dsnSXrOaYh
X-Received: from edx29.prod.google.com ([2002:a50:8e5d:0:b0:5d8:5ec7:f252])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:358d:b0:5d1:1024:978c
 with SMTP id 4fb4d7f45d1cf-5d972dfbc2cmr8663097a12.2.1736511578923; Fri, 10
 Jan 2025 04:19:38 -0800 (PST)
Date: Fri, 10 Jan 2025 12:19:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250110121936.1559655-1-qperret@google.com>
Subject: [PATCH 0/3] KVM: arm64: Simplify pKVM memory transitions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since its early days, pKVM has formalized memory 'transitions' (shares
and donations) using 'struct pkvm_mem_transition' and bunch of helpers
to manipulate it. The intention was for all transitions to use this
machinery to ensure we're checking things consistently. However, as
development progressed, it became clear that the rigidity of this model
made it really difficult to use in some use-cases which ended-up
side-stepping it entirely. That is the case for the
hyp_{un}pin_shared_mem() and host_{un}share_guest() paths upstream which
use lower level helpers directly, as well as for several other pKVM
features that should land upstream in the future (ex: when a guest
relinquishes a page during ballooning, when annotating a page that is
being DMA'd to, ...). On top of this, the pkvm_mem_transition machinery
requires a lot of boilerplate which makes the code hard to read, but
also adds layers of indirection that no compilers seems to see through,
hence leading to suboptimal generated code.

Given all the above, this series removes the pkvm_mem_transition
machinery from mem_protect.c, and converts all its users to use
__*_{check,set}_page_state_range() low-level helpers directly.

A few things to note:

 - the existing helpers to request, ack, initiate and complete
   transitions were mostly wrappers around
   __*_{check,set}_page_state_range() anyways, so we're not losing that
   much in terms of consistency

 - the pkvm_mem_transition machinery did not suffice to avoid bugs such
   as [1]. The pkvm selftest [2] should do a much better job at that

 - see diffstat ;-)

This series depends on support for NP guest stage-2 for pKVM [3] as well
as the fix in [1]. I've pushed a branch with all the goodies applied [4]
if that can be useful.

Thanks,
Quentin

[1] https://lore.kernel.org/kvmarm/20241128154406.602875-1-qperret@google.com/
[2] https://lore.kernel.org/kvmarm/20241129125800.992468-1-qperret@google.com/
[3] https://lore.kernel.org/kvmarm/20241218194059.3670226-1-qperret@google.com/
[4] https://android-kvm.googlesource.com/linux/+/refs/heads/qperret/no-mem-tx

Quentin Perret (3):
  KVM: arm64: Drop pkvm_mem_transition for FF-A
  KVM: arm64: Drop pkvm_mem_transition for host/hyp sharing
  KVM: arm64: Drop pkvm_mem_transition for host/hyp donations

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 640 +++-----------------------
 1 file changed, 76 insertions(+), 564 deletions(-)

-- 
2.47.1.688.g23fc6f90ad-goog

