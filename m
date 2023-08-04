Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083F161
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 00:42:29 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-56477c00ef8so1281458a12.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Aug 2023 17:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109748; x=1691714548;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vujMrPLoi5NFJy2gDTZldPvTGUeu9cCAa9LViNvzt/o=;
        b=XpCFpMvQd4gQvh5gquWQ2ZftAaXrBB47AdVh0lLXrYmERl4lD3tY2Oi2S5FLElr5kD
         criOJo8gVbtB4NFndShfIfXdRyq3hnbrsejCWk0QGXOzcK75QYhrXoPTI3JLxnKLsYtr
         twzk19agPK7WenGVGKqUaiqYW963b5aEsEAadUrL+1G5/6aeheEHuC3KoixXoqFlgZ+n
         LhOpmawTNHJuzxuxo5tH1UygVMDE5unyPCqT25hnvArOLk7TdoaMyK24G/6Zhd53jdxM
         l2h2/SNBHXg1gLP1ignbuQE8H/XS+yIxT8uRZbkocTzCvQ/YWzcy4KoPpD4d/xyARQj8
         h03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109748; x=1691714548;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vujMrPLoi5NFJy2gDTZldPvTGUeu9cCAa9LViNvzt/o=;
        b=S2ZKX5d9/rXfLIkTk8DlonBHdQeCmG24jg0sCUX1E12PM8clLTa0phYOxe9PBiOnGG
         l9WgcXrO6ULx5K5pzOg56lODfqPF4ImKQviHhidlVZrfo3zVAhDQoyRhjf4BQktK0zqB
         hMMSMo0n2ffWAyTk9ljVIOKBI+Aa1gVhsp6NZ834mV3buAIVce/ytoyE5qU+KJmDUGKH
         QNFmSP/whQMisd21j9rZA9rk0su/eqbKiwUhF3IG5FcpL4RqmQg1HcrtTIMEL32zLH5M
         Q6fp4goGvEYDtu8GkiUktTT+rGW5BnzBXWIVOr2l67vi+k5hX6pQbaDBi6MHy8EXABoC
         zGgw==
X-Gm-Message-State: AOJu0Yw00lyFd7G49vy7st0VQ9wjnK4b9hBqI8A4UCXDKUgKGZIC5Hea
	9doDMsrjeSpCOlQRAG5eAOYa5k/8zZA=
X-Google-Smtp-Source: AGHT+IEQjsVrWEka9KrysAVqongS+7aQWrT2bXGIhy4ffbBau7Yhoew+SCgRy4QDDK8SjLRgYnzvVZ01CJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2349:b0:1bc:4c3d:eb08 with SMTP id
 c9-20020a170903234900b001bc4c3deb08mr1147plh.8.1691109748457; Thu, 03 Aug
 2023 17:42:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Aug 2023 17:42:22 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230804004226.1984505-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: selftests: ioctl() macro cleanups
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"

Do some minor housekeeping on the ioctl() macros, and then teach them
to detect and report when an ioctl() unexpectedly fails because KVM has
killed and/or bugged the VM.

Note, I'm 50/50 on whether or not the ARM patch is worthwhile, though I
spent a stupid amount of time on it (don't ask), so darn it I'm at least
posting it.

Oh, and the To: will probably show up funky, but I'd like to take this
through kvm-x86/selftests, not the ARM tree.

Thanks!

Sean Christopherson (4):
  KVM: selftests: Drop the single-underscore ioctl() helpers
  KVM: selftests: Add helper macros for ioctl()s that return file
    descriptors
  KVM: selftests: Use asserting kvm_ioctl() macros when getting ARM page
    sizes
  KVM: selftests: Add logic to detect if ioctl() failed because VM was
    killed

 .../selftests/kvm/include/kvm_util_base.h     | 101 ++++++++++++------
 .../selftests/kvm/lib/aarch64/processor.c     |  18 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +--
 3 files changed, 84 insertions(+), 52 deletions(-)


base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0.585.gd2178a4bd4-goog

