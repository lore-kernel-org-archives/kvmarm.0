Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AB77C
	for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 17:29:30 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id e6-20020a25e706000000b00b7c653a0a4aso11955678ybh.23
        for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493370; x=1684085370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KPViUvkFxC3TgEpc/g+CHYNB1CL2Y9j6aLSEKzBNRU4=;
        b=bfUCUQuKiETTWlzQAbfjNWEznPFMMabCQwMyvFryGC5wRD7C7JsvkTJRpUdEZwuD3d
         EmNvtIVJ1PzWXZp48dtSC3Uqt+Qd7L6LI6SYR2R18kQn4tOvoKZvDTWk28yQdgjV/t+g
         aEQHdU35HFceLmkmPdsoDUlmW9uweT8xG74XVcOTweM7F/e4vvyBkpSw2ZfUszXVuX67
         16Y20IFlGTWB08vhSSrtkSoRM6c/HGCuncpoLyYgPWweOItK5ELHtnPUFzjbLrNEYcNm
         uWOezjyZmaPewp35SfIf/iN4YAyxULNabW1cY5mFVAaVM+373vhmIlEchR/iiRJYdrBd
         +lIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493370; x=1684085370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KPViUvkFxC3TgEpc/g+CHYNB1CL2Y9j6aLSEKzBNRU4=;
        b=AECaTDyaffACnJByuMar3m1XhPE40lUrfEtkev1hUbbYCPSnye/D9U7DXMENyoEmsJ
         Hp0+vK2p8gZBg8h1DJfuCbWptlh1vVDgu9u+LIzIZHdXisreNB7AtxZHGBgwkn61tA5P
         fq5eRAP4bxMvVU4G02B/cAMSRAJHWtXturyZK/pUJ176CHb0iiHM4poElQvV7kgqzrpZ
         akXK1Tw2xSLLjRLKHBHP0xgL5NUROAGB+6RxvtLEV6503bYdM2lCygDVguSs1D3/9Ify
         dNReHrHGnNyqEzYj2lOEjd1LwwXygF8tTcXezC4EZIR93zknj43Obg4xF/93mNf8oPRr
         ysRA==
X-Gm-Message-State: AAQBX9dxH0xxp9CqTgzIbkITWOw72MUi1o/mgISNZYRelBb8DN1GF/mQ
	YakCKy5cjGYsWzalrd5pJAtvIJQ60pFP
X-Google-Smtp-Source: AKy350aLcIkj/hYVjZbP05g2b5z8MsRd71+scXvLOlNSX4p4BB89Fk+7FtQuUnznnwYfU5yATegzNaTrdaKg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:c406:0:b0:54d:913b:c9e8 with SMTP id
 j6-20020a81c406000000b0054d913bc9e8mr3919984ywi.5.1681493369929; Fri, 14 Apr
 2023 10:29:29 -0700 (PDT)
Date: Fri, 14 Apr 2023 17:29:19 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-5-rananta@google.com>
Subject: [PATCH v3 4/7] KVM: arm64: Flush only the memslot after write-protect
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e3673b4c10292..2ea6eb4ea763e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -996,7 +996,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.40.0.634.g4ca3ef3211-goog

