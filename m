Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF051C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:26 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2566b668cc5so1567372a91.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722166; x=1688314166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U16a7SsqQ7yjyv5J8Y2N4u7Ylkl11H9qatwpuhmZUgo=;
        b=636YoGkhL1EaD07rsMfPK9rB926Ht76M8pVZszNcRp8cSFBaHFxW4ESJErvKH1m1wQ
         b8SVVb+49Lm4c7lpuGUxvabzksatMUh3aHtTfXuucGjqsfAbB7x8jB5X+IIkfWd/B+pM
         hI1Jypk91JlkfEFB2dbGzi8Bjd9QmphZBvbPzeFfXopwyd64oFIEk7hcFeTi49fzsYb0
         jMhjapC0h8n44W4QCQ7q/RI4lKIJPywJjobPFbGliUK4+jwpyLj3v9rdAbRrHTavotzv
         jSbTLKdo3Rd++6WRrKKX3ZluUSmLDy9wL6sxwwb/x/fXUrLPPNX7BCJ2JivFRXiwGY+V
         XR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722166; x=1688314166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U16a7SsqQ7yjyv5J8Y2N4u7Ylkl11H9qatwpuhmZUgo=;
        b=FGuAfTMLdJuSGYyJ2dVsW9NsCSPMs3fwggXcVOUegYTew5ckkxyrRJK932wiVi+ffW
         89LZr7Mpc92fL3SoRnXbh7VTSX8k26QtJbQQ+XTpaV8MzZdsotxxNQ1MQozfAwqa90Nr
         LyEZIiqThakHay/hn388nSjFZzWkWUV5SRuBhc1nMZRD7RdBYytOPLoNxg2gTTlO/5BT
         tXlqQ/g1fj3svRiwyLr4tXj8iwlauM3O96t9ikjlw1VRCxI7CGubkUifp3S+iQc0inDI
         1aqA2CcKgG9AEHMtD/xkIjiDRt7nqpoKq+R+pPRciUKV9+8Qo7JhPm5338A2M6WuhDYX
         GqAQ==
X-Gm-Message-State: AC+VfDxGaAAGEYFqTgdfXv9Z+iVx4bnU6wsI/1ahmlKtOoZrAd6HDDLm
	B1Nu2KcBSChFjFSsqTq5qNMq0kuKkqdd
X-Google-Smtp-Source: ACHHUZ5ZPLDaNjdv6ql0/d9oDMUgHRd2fE1fBqzKriMYD3yXbiA53bpGux4rVDyMUkeRamgRC/kjMfQm5qU6
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:de04:b0:24e:18ff:5bad with SMTP id
 m4-20020a17090ade0400b0024e18ff5badmr42850pjv.0.1685722165847; Fri, 02 Jun
 2023 09:09:25 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:01 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-4-vipinsh@google.com>
Subject: [PATCH v2 03/16] KVM: selftests: Pass the count of read and write
 accesses from guest to host
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

Pass the number of read and write accesses done in the memstress guest
code to userspace.

These counts will provide a  way to measure vCPUs performance during
memstress and dirty logging related tests. For example, in
dirty_log_perf_test this can be used to measure how much progress vCPUs
are able to do while VMM is getting and clearing dirty logs.

In dirty_log_perf_test, each vCPU runs once and then waits until
iteration value is incremented by main thread, therefore, these access
counts will not provide much useful information except for observing
read vs write counts.

However, in future commits, dirty_log_perf_test behavior will be changed
to allow vCPUs to execute independent of userspace iterations. This will
mimic real world workload where guest keeps on executing while VMM is
collecting and clearing dirty logs separately. With read and write
accesses known for each vCPU, impact of get and clear dirty log APIs can
be quantified.

Note that access counts will not be 100% reliable in knowing vCPUs
performances. Few things which can affect vCPU progress:
1. vCPUs are scheduled less by host
2. Userspace operations run for longer time which end up giving vCPUs
   more time to execute.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/lib/memstress.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 5f1d3173c238..ac53cc6e36d7 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -49,6 +49,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	struct guest_random_state rand_state;
+	uint64_t write_access;
+	uint64_t read_access;
 	uint64_t gva;
 	uint64_t pages;
 	uint64_t addr;
@@ -64,6 +66,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
 
 	while (true) {
+		write_access = 0;
+		read_access = 0;
 		for (i = 0; i < pages; i++) {
 			if (args->random_access)
 				page = guest_random_u32(&rand_state) % pages;
@@ -72,13 +76,16 @@ void memstress_guest_code(uint32_t vcpu_idx)
 
 			addr = gva + (page * args->guest_page_size);
 
-			if (guest_random_u32(&rand_state) % 100 < args->write_percent)
+			if (guest_random_u32(&rand_state) % 100 < args->write_percent) {
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
-			else
+				write_access++;
+			} else {
 				READ_ONCE(*(uint64_t *)addr);
+				read_access++;
+			}
 		}
 
-		GUEST_SYNC(1);
+		GUEST_SYNC_ARGS(1, read_access, write_access, 0, 0);
 	}
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

