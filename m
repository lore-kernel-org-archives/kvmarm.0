Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53FB13C3EE
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 22:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638463; cv=none; b=e2U962bBnzlnDwV8xgQlbsZ5BNhzv8y1U4aVJqSV/p9d7KVlLCacyLOBjrROYoyTT1QRqOuAgYxkCzCMZgkbCAoIn8r9VfAHyyNzYvimMw4tSj/zOnc7vUZSr59+Z2YUGZw/Vuy3DB7rqwR/tj2JXtlfEUH58Wm+rPiLcw36hko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638463; c=relaxed/simple;
	bh=qr5BTy+0rP4m99VwQ0GuNK/YeJP/WBSk49NkTt1nPdc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X7Aj2PjVIRT5ZqdWEn2EV3oTtAYuGfSufURS/jJ07niBm+zat52Zz/I791ZzEncqzojmwCzrAN6f5MUX6Qinjy1pkaM4YN0InkKkLPrTQL1gfqgAQtFY+6k57FE+RZtJYgDEmK6eiC9Bg5S0LD/OXnL0L/VWwQjLbGlUz4nqhv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MrSEVG3f; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MrSEVG3f"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-664b7a67ad4so177621887b3.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 15:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638460; x=1723243260; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XoExkem0pI3PQlrsfFLGIInPgK2Os7OnG4xaWi9xIB0=;
        b=MrSEVG3fp5E5PdALDGoHZeK5L+Gnft42Z2T/gJAdvO7if1FUjYZPNopQ/gl+cP0mt4
         IB8JSlh1arxYfUsWCa3Fj/Ap96R4iNbS4mXuMz+qZi+Bn4KVbA1VcuuMM/7nlyFEKNkl
         J1A1myelxjnJFbZpFM00xm10Qj72PWTn/eFKNyD4Ehm0hli7hOEy6oN7ZEhyBm5f6pOq
         Qxq8LrCqWt3RPnpqgVzM7uB+yxY6xE2ZSFDDncwP1S1DfXzfJEZr2q+WQAHSrNKGewN9
         WHhVIXz9EZaOLKc9z9Ix4k6AaZpu0/pEfKQFkMNIDP5x7pIofA1Ba0UZgII4anAGArxJ
         bNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638460; x=1723243260;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XoExkem0pI3PQlrsfFLGIInPgK2Os7OnG4xaWi9xIB0=;
        b=SUxRMxR9CvHlFQnEZLqNr9yYW27IibmL3NXC/aizE8s+V3iD/Rim0oHSyo6krtgipU
         SDizoGm+ivofpMug7ECjandEc1nDkkbxyaiZaWiaseNRiIrdhxSG3Wd9S1Mmn1nf0Z52
         mcZ2GKDYgFXWqyaIHvsAbnOMgTYlw7jEK8rGhPSpWaTum3jSVg6Q5ygk3wAapeNq0CZe
         cuQO/AdvlBfC350UQSkl5PGz6n9M3ia3dwM7tlt1jOcoCYZHd1caVLiEXSSv86+45UQ7
         XFwFwoQ2eZlS+jUwqbmm9U+1R2zmHH1regui9Xdvol/wBlNtt5fyhilLtPm+Cjc2AzaG
         LkIg==
X-Forwarded-Encrypted: i=1; AJvYcCXXML/H/vBNg7V/cmxKVclCzVhN7TQXAeesJ0EImCJzdIxZiJrLFOLblTOXsLv8lDJL6qKOmag=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ2t8tP6ByandwYv+M8kj4O1t/HuAzZK2CMB/065S3Q4zvZ6sH
	y80zwyJ8CibaVHLG3IJU0absnOJqCZgd3QImGu+a9C/NnW9jywbZI+3p+tKtiPwmWdCFQh2fIYP
	UpIbGVlaB7Q==
X-Google-Smtp-Source: AGHT+IHWsNULlr0OmaF5l6nZ9yDeq3lPANgbS+u1ex6NibNf4/8aS9SuVg1An9LGCqPy2z4RP/nXzJOyr2/9rQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:86:b0:673:b39a:92ce with SMTP id
 00721157ae682-689601ab898mr265957b3.3.1722638460490; Fri, 02 Aug 2024
 15:41:00 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-1-amoorthy@google.com>
Subject: [PATCH 0/3] Set up KVM_EXIT_MEMORY_FAULTs when arm64/x86 stage-2
 fault handlers fail
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Memory fault exits were originally conceived for the stage-2 fault
handlers in the first place: it's probably time they were actually added
there :)

Sean and Oliver: you guys were having a discussion on the arm64 patch
the last time I posted it: here's the link in case you need it.
https://lore.kernel.org/kvm/20240215235405.368539-9-amoorthy@google.com/

Anish Moorthy (3):
  KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault handler
    EFAULTs
  KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
  KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2 fault handler
    EFAULTs

 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 arch/arm64/kvm/mmu.c           | 5 ++++-
 arch/x86/kvm/mmu/mmu.c         | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog

