Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21837EA6
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:32:03 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59bdb9fe821so35133357b3.0
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824323; x=1695429123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kZSgVl8Q+hmlGcu9E42B+6nCYbsSFCH4k+E/cwlLEa8=;
        b=YdCHNbla0Ffj5bbR+IQf/Rlho8DYSsJi2jgIZiT+G1jRKSV0W61mvq/d3f+vB+CTrM
         m9CGhbua90tMy8QCofwzr6ARHt6Iw6zNeQojpM/yMYB0Wa4hLvmAE6s4glQinZsxpalu
         MQF56bZQw3mZOT5Ki1tpjE3bnyhsgMSYB5D+AabUy8uMA4A/J8fhdcYbsLntRZam518F
         St69sMIchzfwc/IO2JLLPgeA+YqNl24gBjVRV2TEIyd9hYWM9XNG0MvbeBCy7X6fBVG3
         kXKVaEPYH/ByR4XEslhQdMVPI9kJh5cifKOB1FhNJbY1nFLdcZWC5NUWSqSi6kG0xVW6
         SjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824323; x=1695429123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZSgVl8Q+hmlGcu9E42B+6nCYbsSFCH4k+E/cwlLEa8=;
        b=jTj79wsXxLEwHh+/aH2HAfEhs0QPjcuvKvOD5lWYGNg0spmjGM1ilJyTjgcZAQedwy
         NNvk90qp4vwgWDREuxuShdiVcW73w9BrKMupFtDfe/s0IZha0gy5S/OB72lvfaOUlaHu
         LmtaOUU1hAhH8sh/O88+Fw7D1Y9MTH+nwU3kDcFtxtiHd+QkpzWdkl1OWEC3U3cxGRce
         js3rHPatLn9Bx4NpjzMVoTtTY9ylpZcVHxVfQERW80iALqxb/FqbZjzH+d31Ehmsuo9F
         dWeaJcmXqbjN8J4s1U7bImZ69QvkzwSeWsS3hXsKiLRQhe+K+Q1sp2QNukPVTsT0CiRE
         jDng==
X-Gm-Message-State: AOJu0YzfV4Rb+6ld/qcJVNa0dwYw9WDb6lSggnHcDeKXhKMb5/bReEHc
	0VvkxqvDg3iUUWfDbQl55Bdz/1ZxDn4=
X-Google-Smtp-Source: AGHT+IGvK90kPH1o5bQH0EPib2Mktorl92L52Xc3vYMLm3HoBq+aka+3/3i87f2Q/TuhX6d+6vnq3Y1BBZw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b60c:0:b0:586:a58d:2e24 with SMTP id
 u12-20020a81b60c000000b00586a58d2e24mr95790ywh.5.1694824323076; Fri, 15 Sep
 2023 17:32:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:13 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-22-seanjc@google.com>
Subject: [PATCH 21/26] entry/kvm: Drop @vcpu param from arch_xfer_to_guest_mode_handle_work()
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "struct kvm_vcpu" parameter from
arch_xfer_to_guest_mode_handle_work() as a preparatory step towards
removing the vCPU parameter from xfer_to_guest_mode_work() as well.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/entry-kvm.h | 7 ++-----
 kernel/entry/kvm.c        | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 6813171afccb..e7d90d06e566 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -25,18 +25,15 @@ struct kvm_vcpu;
 /**
  * arch_xfer_to_guest_mode_handle_work - Architecture specific xfer to guest
  *					 mode work handling function.
- * @vcpu:	Pointer to current's VCPU data
  * @ti_work:	Cached TIF flags gathered in xfer_to_guest_mode_handle_work()
  *
  * Invoked from xfer_to_guest_mode_handle_work(). Defaults to NOOP. Can be
  * replaced by architecture specific code.
  */
-static inline int arch_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu,
-						      unsigned long ti_work);
+static inline int arch_xfer_to_guest_mode_handle_work(unsigned long ti_work);
 
 #ifndef arch_xfer_to_guest_mode_work
-static inline int arch_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu,
-						      unsigned long ti_work)
+static inline int arch_xfer_to_guest_mode_handle_work(unsigned long ti_work)
 {
 	return 0;
 }
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 2e0f75bcb7fd..c2fc39824157 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -19,7 +19,7 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		if (ti_work & _TIF_NOTIFY_RESUME)
 			resume_user_mode_work(NULL);
 
-		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
+		ret = arch_xfer_to_guest_mode_handle_work(ti_work);
 		if (ret)
 			return ret;
 
-- 
2.42.0.459.ge4e396fd5e-goog

