Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25C20EC
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:56:08 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-26f3fce5b0bso412125a91.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656568; x=1695261368; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JU2E1RY5jYghlRVsn3OuL2a/W8MVmnBu3lS2NKbXZTA=;
        b=bArITb7MUBfFvcZZlXu113Zok+7meZqDioVz2Pfp/YfHY7Fv1LI1DS/w3QtFN/HK4A
         4VVnmhhJtwy/Ql+Npe9OcODiQL6sh4hJqR4y6aZtXR4eaxHQdVBsAIleQVFwZCLtM+lE
         cBB4HknHs+fZC+H0V1ddYNCWJq3wxmA/WjQnQrW/A7sI1YOuPdxGF0o3VHYDM5G6s+N/
         zRsoqsFxSvW/IrtAB5nkOOOBbAgqNTOWwOU4sF0jQptHizQ1FtRqlZoGmbhbwK0TDjQx
         JBrJBOve3dnlH6lE5SAyaV4JEg+OqLbc9e/4rzG6tgTVlpeeCvjlCLAzNOWeXYLEOeuY
         WcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656568; x=1695261368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JU2E1RY5jYghlRVsn3OuL2a/W8MVmnBu3lS2NKbXZTA=;
        b=hBsK86DTuvX9JvKuumqgOxSWQUrR4BoMmH9YjSg9j7ekATMKyQMcNXPG1zOCwQQjbR
         NjZa1B8kAf1siaj3Vdv0Gf0CNTBqnBUTidQI38MZGhh7igaXgpmjHEEP1LsEDK6Em8Gs
         BAAaVSlFDJKspnSxLyVKAUrX0rodzAGOAtRmFIlXMJQzAgn/IDgHfxwfomGzPqz0R2fI
         UbOvMFyVcMKP5fd5bUE0IiLyWHUMq6QieAau9CSD1iJCJpPb4fYNA4w5g/e2ewXNEgED
         f9sVOPwo59cvNVOyvg/pv1F+LOXXVGUmP+yVUOuqfV5/FJYuzXZaFXzY9KZ74h04tscu
         rfdw==
X-Gm-Message-State: AOJu0Yz18ZXj7O9kY8FsuVf60KD0u+Vs1e+8PVSMXC6WQTdAuYZjVu0W
	Pn3cLgXLSHyujgWtCBgUtf1IT1RrdMg=
X-Google-Smtp-Source: AGHT+IHMQPQ3k0d/UtHxD4b9hamrYXMHgCSNyIGKdggb9SAJfpQFP9N68H8VlXpWCI6NE2xrZ7HMeRXjSd4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8e:b0:1c0:e87e:52b9 with SMTP id
 j14-20020a170902da8e00b001c0e87e52b9mr204006plx.12.1694656567699; Wed, 13 Sep
 2023 18:56:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:14 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-17-seanjc@google.com>
Subject: [RFC PATCH v12 16/33] KVM: x86: "Reset" vcpu->run->exit_reason early
 in KVM_RUN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Initialize run->exit_reason to KVM_EXIT_UNKNOWN early in KVM_RUN to reduce
the probability of exiting to userspace with a stale run->exit_reason that
*appears* to be valid.

To support fd-based guest memory (guest memory without a corresponding
userspace virtual address), KVM will exit to userspace for various memory
related errors, which userspace *may* be able to resolve, instead of using
e.g. BUS_MCEERR_AR.  And in the more distant future, KVM will also likely
utilize the same functionality to let userspace "intercept" and handle
memory faults when the userspace mapping is missing, i.e. when fast gup()
fails.

Because many of KVM's internal APIs related to guest memory use '0' to
indicate "success, continue on" and not "exit to userspace", reporting
memory faults/errors to userspace will set run->exit_reason and
corresponding fields in the run structure fields in conjunction with a
a non-zero, negative return code, e.g. -EFAULT or -EHWPOISON.  And because
KVM already returns  -EFAULT in many paths, there's a relatively high
probability that KVM could return -EFAULT without setting run->exit_reason,
in which case reporting KVM_EXIT_UNKNOWN is much better than reporting
whatever exit reason happened to be in the run structure.

Note, KVM must wait until after run->immediate_exit is serviced to
sanitize run->exit_reason as KVM's ABI is that run->exit_reason is
preserved across KVM_RUN when run->immediate_exit is true.

Link: https://lore.kernel.org/all/20230908222905.1321305-1-amoorthy@google.com
Link: https://lore.kernel.org/all/ZFFbwOXZ5uI%2Fgdaf@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8356907079e1..8d21b7b09bb5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10951,6 +10951,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
-- 
2.42.0.283.g2d96d420d3-goog

