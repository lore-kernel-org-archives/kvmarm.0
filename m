Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3A38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:36:58 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d1ef70d6a02so2490133276.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591017; x=1691195817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yrzuMhAa5ZwKSNV65AbGOyhxR2CbeFJJoK4NwSTk8zA=;
        b=dN9YT0VxVpTnTjGk/rv/FxwHOjp1VRvYhtyRfTVCAOoulkUZDNhTZRIAQk8NOYfzZZ
         GWEnyWCXZ+uS6SH++isxPQAlqFS/lA6695c9u+iCiY2gzPBkcDkFB1xdiizMtZDxh38s
         JhdAaexpefMPKDWwwntmojHOAbSw2wFqTgQFuSAyMXENyvM48ivs3AXaTMZ82Kx5J4jW
         1kfdHVfh4dZh8FWhvcm03R9vowpN+JAwtXDm6Wy6OKafqBDFo6Zl0dqWCqKvEmo3qZ+L
         Tw0U7sTciY5PsfKaJJzXUgwKlmw8zZcjJQZ7mmloZZWEM4wOySbaCh0bwzOyHfTy2Dw+
         qQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591017; x=1691195817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrzuMhAa5ZwKSNV65AbGOyhxR2CbeFJJoK4NwSTk8zA=;
        b=LEpR5NLyqrVBqh2Ug+r349KoZqTG3CjZyCUCNUhxyyzKgd61Sqbtl3/omtkS4OlDQo
         TKEf27Q5kVurUk8dUQFTT/FAYiKB4wWIbTnuY4iwrB4AmifRYAolQ8u+3hQ1n5JyYZAw
         ZluA+/PCbRM5rU1rjij49OREEhh8aTR/+k5W4YR868iRtGtuMKA4cLImSYKsSOzonLXt
         bAsF+sZlz2b2OR175BZLcYurWHhVfJ99/4QV3+2swSeHjs5XsashF5uxtSEr/cGU9YNX
         cy0mzSPjYBeFbHnuUg6+ptW1VhDnLaBpSWLBP2M0NeX+rrhFZQO3yeiXwDBViR3f/0nN
         fX2w==
X-Gm-Message-State: ABy/qLbbnObHv7+bkXyCydZhrmNUZBQPQ1UvN+IF/fxi/kjv2X5gz/XC
	ASW5/MeKgPQ4EX9+80r8cU5Od9M2ItE=
X-Google-Smtp-Source: APBJJlEZT09RPLsuDS5f8Sg2OFhpONKGw2AX4nW13KrfxH17cPvEic/pdQPcg0HACBrHFD9tkqER2tbLXyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ccd1:0:b0:d1c:5506:9761 with SMTP id
 l200-20020a25ccd1000000b00d1c55069761mr23062ybf.1.1690591017810; Fri, 28 Jul
 2023 17:36:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:15 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-7-seanjc@google.com>
Subject: [PATCH v4 06/34] KVM: selftests: Add additional pages to the guest to
 accommodate ucall
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Aaron Lewis <aaronlewis@google.com>

Add additional pages to the guest to account for the number of pages
the ucall headers need.  The only reason things worked before is the
ucall headers are fairly small.  If they were ever to increase in
size the guest could run out of memory.

This is done in preparation for adding string formatting options to
the guest through the ucall framework which increases the size of
the ucall headers.

Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 4 ++++
 tools/testing/selftests/kvm/lib/ucall_common.c     | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1a6aaef5ccae..bcbb362aa77f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -34,6 +34,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+int ucall_nr_pages_required(uint64_t page_size);
 
 /*
  * Perform userspace call without any associated data.  This bare call avoids
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3170d7a4520b..7a8af1821f5d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -312,6 +312,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
+	uint64_t page_size = vm_guest_mode_params[mode].page_size;
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
@@ -340,6 +341,9 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	 */
 	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
 
+	/* Account for the number of pages needed by ucall. */
+	nr_pages += ucall_nr_pages_required(page_size);
+
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..77ada362273d 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -11,6 +11,11 @@ struct ucall_header {
 	struct ucall ucalls[KVM_MAX_VCPUS];
 };
 
+int ucall_nr_pages_required(uint64_t page_size)
+{
+	return align_up(sizeof(struct ucall_header), page_size) / page_size;
+}
+
 /*
  * ucall_pool holds per-VM values (global data is duplicated by each VM), it
  * must not be accessed from host code.
-- 
2.41.0.487.g6d72f3e995-goog

