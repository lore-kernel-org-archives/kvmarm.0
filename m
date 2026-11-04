Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782135;
	b=lZvyvZ+Cm1aI9R5uSdnWsL9FoTw8ng2MGmVcKYLkbQDbYyKIgE6y63eO7YRx49Hhxntj
	 BjhZ/S0SOFWLAhyeDncP8+KgsQsZiR128rXa4TFaEqDob4dWpGNhk/Eh+B53tI9HlUmmQ
	 DcBpUu0Or8ggvq712lpmMuVoAkgWpFg4C80aNosNN+HdW39QEazcZ9e5LeoFbSFOmL6ft
	 ZbSP1uyDrkYmfXZ0KmJDbC9VV/8R1pJw8dmuZDKQdHFeT1k3tad5PEPMTB8CcCQYM5TZW
	 ArQDW5nwgJ+ySu1ICbpnkhaJgONK8fh4b7QbGpzZvi2vjlJyueeYH3iabe856217hUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782135;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n7dKS3uLxqz3hFWxQ/Hr/z79HJ4aXd4+1+IODE3lfqg=;
	b=PLhqlqPsmb5FFuljLRitXobnpCq2q5aUHVW9NQy73kwVLyG3F7WJv+XqMTbvmr2+EjAx
	 bGOs2wl51fjHVUccKXBPkXXpeOo32HyF5gH/1zvl/D8BD1nok2SILHi+wXcUqBl5FBRnp
	 7z3Yuj8G5kDd6Jf3jfJVLhAiWPx+XCsy6y5tNy2IjZ6vXudJP4fIZKx+f1IlVSnutcEma
	 p3F8yEzSXmtPBPuaTiWbN0oG5TmMTpfUsp4nXm92/r6SFI3MwgvEjqdx8YX4JoNY7AFAa
	 yjSTY2A19ibT93TlNMAxM21pVqeIeraBZ+3m+koJtr7xL/GnR9Hhaif4/R5e6jbV55w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="T4d6Fo3/";
	arc=none smtp.remote-ip=95.215.58.16
Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB8606A331
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16EB8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T4d6Fo3/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZJp1sWID1Y8h4yq9sHvxEkK5gbfl1wOQbzOgvALLC6k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782132; v=1; x=1794386932;
 b=T4d6Fo3/hNK2uXQwUMot6YCj/ZodRvUBFeb4ywWwwFOHQd+itPMsvqE0eoQFVuWo4k4ZxXAH
 VXJxBPVgI1or6TMyiVonLMWqIPE3PdDPPrTEHiXOS+trnFekxJc11CSwT8Nv+7FSCn9XkGlz8f0
 cY2klbT9eiG/jGq6/4tqq70g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fbd8c9a40e5de126;
	Wed, 04 Nov 2026 08:48:52 +0000
X-Mizu-Trace-ID: fbd8c9a40e5de126
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] KVM: arm64: selftests: Inject an abort before a vCPU's first run
Date: Wed,  4 Nov 2026 08:48:27 +0000
Message-ID: <20261104084842.132944-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104084842.132944-1-fuad.tabba@linux.dev>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM commits an external abort injected with KVM_SET_VCPU_EVENTS
immediately, even before the vCPU's first run. For a normal VM on a pKVM
host that path panicked the hypervisor until commit a2bb5f5c67a95
("KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM"). No
test injects before the first run.

Add one, checking that the guest takes the abort at its entry point.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/external_aborts.c     | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 1a858d0d82968..45c9300b2ca0e 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -113,6 +113,26 @@ static void vcpu_run_expect_sync(struct kvm_vcpu *vcpu)
 	__vcpu_run_expect(vcpu, UCALL_SYNC);
 }
 
+static void test_sea_before_run_guest(void)
+{
+	GUEST_FAIL("Guest ran before taking the injected abort");
+}
+
+/* Test that an abort injected before the vCPU's first run is taken at its entry point. */
+static void test_sea_before_run(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_sea_before_run_guest,
+							expect_sea_handler);
+
+	expected_abort_pc = (u64)test_sea_before_run_guest;
+	sync_global_to_guest(vm, expected_abort_pc);
+
+	vcpu_inject_sea(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 extern char test_mmio_abort_insn;
 
 static noinline void test_mmio_abort_guest(void)
@@ -420,6 +440,7 @@ static void test_serror_amo(void)
 
 int main(void)
 {
+	test_sea_before_run();
 	test_mmio_abort();
 	test_mmio_nisv();
 	test_mmio_nisv_abort();
-- 
2.47.3

