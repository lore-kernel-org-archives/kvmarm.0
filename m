Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C23D568B
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:53:20 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-63b656aacc6so2758013b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 09:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682095999; x=1684687999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDUI7xCr7dWf/FkK1CK1yXAqGXh9n1NZNFj54qb+KHU=;
        b=xTDct9zxZ9N8ALbPUp/viW7lM9BRRuwGhBUMNIpBcky3DENAIpUsYaKC4hxy6ElANa
         XJM0ALn9fzQGXWa5TwxvUayRtY+2kF+0hSFrS4Z13rLNDvpjdJ1bTkvnlg/aszqM3kw6
         JwtYRMMCwqvts/H9WPbPOWtINNCHPcx52iHlR+Mni7gOLO5npE1/M3beOvxeJdJAoVtK
         oYpcB0E2UWuNNPfDE3N6K7L1PsDilnRRB45iG1BH2Hs9bkLyvvb6zqJnC7OL6glGnKD+
         tqNazVeTkEV+I2VUzEqOogcJ5o+xCg88TmCeF1jcEtkdTpDT5v8zElAEZqy2mA1rdmJ4
         ZLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682095999; x=1684687999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDUI7xCr7dWf/FkK1CK1yXAqGXh9n1NZNFj54qb+KHU=;
        b=Afe88v7gyiW/slLaxqbeOBVRwxk1oVRmZ+zn08pZ09o5B+jv/PWXWBU4T5fH1yIMUW
         89ss8sgTU++7imS9csvU1bUUoRz9tJrmlyD6BzJIAuqu4MNwmPBlajyMl7V5jA7FxbGJ
         j80HCbSbcAIt1Bk4b8xY37SLoyK19qr2nwE7VlUtmSFVVb+Pw2wG4MgUzczCTLH+5y2u
         ywZvX5Ay8ZozM+JZWSjWtQi4KTDxBWONoNzssgRrfITeTfhULUYEgfLYIxPmXzLClnP6
         SjouLjHBArXY4G+AbhA96ZMFwJgzx3CqQgeucwFrvdh0rjAmxQaidgBQSvo0LVFcYzId
         9qUA==
X-Gm-Message-State: AAQBX9dcEcKN2dIsCWBMvNHtZrnFDCVA4wyqWloRFvV3t2nvb0u1DcsK
	X5ixx1kCLL9LeQhuh/Br+MenNlEx0iPU
X-Google-Smtp-Source: AKy350Y++Ixj3yZzgu1Tm9pviEO/066Z0jMSz5NI0cEsiZPMFyAUWWqVudz+4dZEwY3ZReh5ODp8Q4bxx5mF
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:134b:b0:63d:5dcd:bc06 with SMTP
 id k11-20020a056a00134b00b0063d5dcdbc06mr2146455pfu.5.1682095999596; Fri, 21
 Apr 2023 09:53:19 -0700 (PDT)
Date: Fri, 21 Apr 2023 09:53:02 -0700
In-Reply-To: <20230421165305.804301-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230421165305.804301-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421165305.804301-7-vipinsh@google.com>
Subject: [PATCH 6/9] KVM: arm64: Correct the kvm_pgtable_stage2_flush() documentation
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove _range suffix from kvm_pgtable_stage2_flush_range which is used
in documentation of kvm_pgtable_stage2_flush(). There is no function
named kvm_pgtable_stage2_flush_range().

Fixes: 93c66b40d728 ("KVM: arm64: Add support for stage-2 cache flushing in generic page-table")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..4cd62506c198 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -605,9 +605,8 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
 
 /**
- * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
- * 				      of Coherency for guest stage-2 address
- *				      range.
+ * kvm_pgtable_stage2_flush() - Clean and invalidate data cache to Point of
+ *				Coherency for guest stage-2 address range.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address from which to flush.
  * @size:	Size of the range.
-- 
2.40.0.634.g4ca3ef3211-goog

