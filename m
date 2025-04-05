Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E3366
	for <kvmarm@lists.linux.dev>; Sat,  5 Apr 2025 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811846; cv=none; b=kAx/OTc8qDbssSMzfQ8b31KlQnSGeHa4/eDQJswFkJPZsIuWW0CpBAa6zu6rvRXm59T+0kkOpqmRE5sntEiqd4M9OBocPkDGFIsaI65EyjAWxxj7YJrqPjYa5a0vIBln/gIOIMzJZLjgaXQx6/jPUI6wlh5In95L2ekkPCT/Q5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811846; c=relaxed/simple;
	bh=9OLt6CxBIy6kqbClRlpyjmlyZ3nlZBIi/b6vLEkxDsk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kOLmu2rWJ59IeufD0zy8KH+qiT9k8whUYpF/rYGAPePfIROB1kB6TPQa6jjmsvImvyYEZzLixWjj2wlLiqntX1zywy2Lqt/1ZSU0dC8xpW5q9BFC5jPmj+eW3PIIJCNhbP+4HiDDAd9BMf+xxb2L1nhq5Iot01VpV2g4QDAe8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eKzy7HsR; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eKzy7HsR"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-85dac327403so474133739f.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 17:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811844; x=1744416644; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DNvYO0bTfj7X+8PQ13cmGZGTNT4dkdJknnzMC9cIXk=;
        b=eKzy7HsRAY39ANCv70U7Q9ABvQP8k5I4Yl4d5+Pc58H2GjeE2bL24gOxnae0qCeYrl
         iOXlNSfx1Q8DPC9Oii1cVccnMu/HBwWn8WyGJS6zQfixPUlJD6MBq5+c5tchde6uDMHk
         4f++EWvCZ43Jxkedi8/DvGda9tdGxZfzpmAdRjUIIi3nAA5Zkkm5vgSYFrhuO+jx2mVA
         t1zrOXICUMV75rWUM5guxHXun1REgmK2iR6k+T0GpnFLt0mIZxAWwNR9xpT2jo6zDuc8
         CrfEM20FEQCk2itn7wCRQKgqopHKWhmPi9DbU6yxJTko09W38IYBH/XdwSGOpgKZELjn
         bCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811844; x=1744416644;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DNvYO0bTfj7X+8PQ13cmGZGTNT4dkdJknnzMC9cIXk=;
        b=oTkmFbO3LZM3PaRILtFS/CLoHEqIKAw4MDtmVJn5iWmi3NrR5rokxj91eWRecsGZaF
         ki1X7FaFG6LWWuF8AOQ1D9t0jXM66EKR7KkFvSRQv9Cz4j80USadUKZldsRWL0WV0oRD
         +QEI9m461guw2SDK6Sa6ReVRl5RNw2YO9vPEUq1ckZKvcpZ3oBEyWaf5+RyiC66UJ/vN
         GhLFkHhgmusjGIOXH5jHOZOkR7EvW1qBFtCkD7NEU3gcShjKir/GyA2jcywRnj3p1CvK
         9Hg5arXb/qR4U0ijI1tpoet5niu8xFNthF5iG0FoWSUFRWy0on7yhrcpohBuGEp74HoZ
         j3Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXhxGVwt191hkLl2lEVNqmaXh5PIj01IZO1POhmd2i2rjw0hKencLdApz+l5uiL+w7ZL3UU3IY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwCvaiueQf064ei2eK0sMqeYG3Atea+V0oimT+H/YZ7kOsoRLw
	JeLHMJ5gqeGPIdN0KqtKXeV9jcBXvULteb1KHoU6EH1ACoF+5tYTMyw7oeRi8HJFd5i93dLEydm
	S1v1QJg==
X-Google-Smtp-Source: AGHT+IESzYBYMsy8TcNeSXmOCuIMcY0rfkLLxruZnkYbIer8gFLQRo6rMLnXbA8I1jN134maNpjGU7IZC4nb
X-Received: from iobbk9.prod.google.com ([2002:a05:6602:4009:b0:85b:3e10:d317])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a12:b0:85d:a211:9883
 with SMTP id ca18e2360f4ac-8611c3bae5bmr467620239f.10.1743811844346; Fri, 04
 Apr 2025 17:10:44 -0700 (PDT)
Date: Sat,  5 Apr 2025 00:10:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250405001042.1470552-1-rananta@google.com>
Subject: [PATCH v2 0/2] KVM : selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The series fixes a conflict in memory attributes in some
implementations,
such as Neoverse-N3, that causes a data abort in guest EL1 with FSC
0x35 (IMPLEMENTATION DEFINED fault (Unsupported Exclusive or Atomic
access)).

Patch-1 is a cleanup patch that replaces numbers (and comments) to
using proper macros for hardware configuration, such as registers and
page-table entries.

Patch-2 fixes the actual bug and sets the page attrs to Inner-Shareable
by default for the VMs created in the selftests. More details are
presented in the commit text.

v1: https://lore.kernel.org/all/20250404220659.1312465-1-rananta@google.com/

v1 -> v2: Addressed Oliver's comments (thank you)
 - Moved the TCR_* macros from tools' sysreg.h to selftests' local processor.h
   in patch-1.
 - Adjsted the citations to describe the issue more appropriately in
   patch-2.

Raghavendra Rao Ananta (2):
  KVM: selftests: arm64: Introduce and use hardware-definition macros
  KVM: selftests: arm64: Explicitly set the page attrs to
    Inner-Shareable

 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../selftests/kvm/include/arm64/processor.h   | 67 +++++++++++++++++--
 .../selftests/kvm/lib/arm64/processor.c       | 60 ++++++++++-------
 3 files changed, 96 insertions(+), 33 deletions(-)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.49.0.504.g3bcea36a83-goog

