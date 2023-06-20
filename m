Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550212A00C
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 16:34:38 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687278876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gzht6CT1X9IZD7roVpf6k8MHtu0w2z5eWGk4eof8mU=;
	b=jzkqbC7lHAGbYcCiWYHbOnQJM6LZ7fRWroB49gh9fFxVZ/vL3q6rmNoxc6W94uR0nkK4tk
	QNFLQD/4a0j6riMSpz6CUWljTdCNX9kRQAtDDZaKfRmti5TqHcQej4kbtWIKYuTfakaiS0
	5Az+pR6AFfRi07v/tZfF3XUoCMXO2Uk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 11/20] Add helpers to pause the VM from vCPU thread
Date: Tue, 20 Jun 2023 11:33:44 -0500
Message-ID: <20230620163353.2688567-12-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Pausing the VM from a vCPU thread is perilous with the current helpers,
as it waits indefinitely for a signal that never comes when invoked from
a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
working around the issue by explicitly marking the caller as paused
before proceeding.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/kvm/kvm-cpu.h |  3 +++
 kvm-cpu.c             | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d..9a4901b 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
 void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
 
+void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
+void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
+
 #endif /* KVM__KVM_CPU_H */
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..0fc1efe 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -141,6 +141,22 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
 	mutex_unlock(&task_lock);
 }
 
+void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
+{
+	/*
+	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
+	 * signal exit.
+	 */
+	vcpu->paused = true;
+	kvm__pause(vcpu->kvm);
+}
+
+void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
+{
+	vcpu->paused = false;
+	kvm__continue(vcpu->kvm);
+}
+
 int kvm_cpu__start(struct kvm_cpu *cpu)
 {
 	sigset_t sigset;
-- 
2.41.0.162.gfafddb0af9-goog

