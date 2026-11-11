Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=FwIYFd4OLA620TjiBC6QGZs3pa6jftC9NU8Vlw2EoyeR+2Fn7YcKr4VyUcsUCPpl+kx2
	 nnTeDYEs5WJ22A6hyGPNKNxFv9ZZKJkoRSEWjgTZTjH9n/o5SiL/+9r3v6HzXmczw2EbQ
	 PYTfgolZd0r+SxP+YJ5jvxon2CiPNE1uEKPIg+YaZCYkWve+boOiQwbc8K9N46wAZqWtR
	 jV3odtsM+6X6ItulBebRjCW3L6+/TFyJC5mFKp3bJDqO5SfECXRIAxPN03yZrdNtG+fOC
	 lBv+MMsWE3jE01bWaGeXpCc4GC1gVsHCCAQnCOpYrN0LW64VUl0FEUim1VJrFJYLkkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=TIWrijKrA2nzOaHIkh2rqMVDBQWKHuqynjXpx+Gqrqk=;
	b=DJXGXLe4bHQrRyNC+Tb/DSzkE0SRE+p8cFDsoKzHiQiWayv+EXkIciRRliy+fB1ANSDg
	 t6e5eza1UdJ3AO8/jusJIR/YALM1t8EPV1scLwmZV9eTjMTEgXyYLw2C4eZFCqnkWWsUA
	 B7/bgIq+Q9LBSf4HxrFyKhNkxcgWjOzSATYeulrNuJB/fH+W0jGM7GV2omrtK8djspRoo
	 k8PvVqU/70lof3q0xDP1PUBLAGnsOXpVfv59yMfoX4TZUPwwqp9/QKuLrTc2tAScbUDEH
	 GMx3vvnz1Vt02UWar9ZFeECDiEVNC82My89LxkEHwkd8sfbdkPhwx8Mlet9GYvdrV/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=qev54AsB;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DEE60A262D;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8DEE60A262D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=qev54AsB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TIWrijKrA2nzOaHIkh2rqMVDBQWKHuqynjXpx+Gqrqk=; b=qev54AsBLwMlGevexDKrvoAopr
	bmK3FXCOynS6kTZwXv1841vKQ0VxD6TKzQlVlWsn41Z44yt4LSwScwK+kGhFUF6Kp8wFQvA2hirve
	HTJoMiv7NPn5wNqfyLS7G0zpfux6Kqyh6HFsvsJDAA6N7jPgAX3OA/B59uV3JNiVe0BclpBEPTgE1
	ez+2bWZ7WYHQgt1N2vXADndRKiBdZFCWjKC/f7KnYtH+0jbEecXjeHtsq3Xo5a5npcZzXvhWFICWq
	+GOMC/s/9jv1FtOuG4XPGcnSuz5o8FkD7IKQ26T+gl4tp0kAGKdNkRCYLHyW14n4RTVLcybSyu6tl
	4on1K8SQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dbc-2AlK;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-0000000008O-45AQ;
	Wed, 11 Nov 2026 22:29:11 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 09/16] KVM: planes: Kick the running twin's pCPU, not the request target's
Date: Wed, 11 Nov 2026 14:29:04 -0800
Message-ID: <20261111222911.477-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261111222911.477-1-dwmw2@infradead.org>
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
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The remote kick paths (kvm_make_vcpus_request_mask(),
kvm_make_all_cpus_request(), __kvm_vcpu_kick()) read
READ_ONCE(vcpu->cpu) of the plane-0 vCPU. But vcpu->cpu is per plane
vCPU (kvm_arch_vcpu_load() refreshes only the loaded twin's copy),
while vcpu->mode is shared in kvm_vcpu_common. When the vCPU thread
has migrated pCPUs while a non-zero plane was loaded, the shared mode
reads IN_GUEST_MODE but the IPI goes to plane 0's stale pCPU: a
waiting request such as a remote TLB flush completes while the twin
keeps running on stale translations.

Read the pCPU from common->current_vcpu in both kick paths. It names
the loaded twin, so its cpu field tracks where the vCPU thread runs
(on x86, kvm_arch_vcpu_load() refreshes it).

Found by a local Sashiko review.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d256bbf301f4..24d2291b60a2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -244,7 +244,14 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
 	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
 	 */
 	if (kvm_request_needs_ipi(vcpu, req)) {
-		cpu = READ_ONCE(vcpu->cpu);
+		/*
+		 * vcpu->cpu is per plane vCPU and kvm_arch_vcpu_load()
+		 * refreshes only the loaded twin's, so this plane's copy
+		 * can point at a pCPU the thread has long left while a
+		 * twin runs elsewhere.  The mode just checked is shared;
+		 * the IPI must go where the running twin actually is.
+		 */
+		cpu = READ_ONCE(READ_ONCE(vcpu->common->current_vcpu)->cpu);
 		if (cpu != -1 && cpu != current_cpu)
 			__cpumask_set_cpu(cpu, tmp);
 	}
@@ -4129,7 +4136,13 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
 	 * vCPU also requires it to leave IN_GUEST_MODE.
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
-		cpu = READ_ONCE(vcpu->cpu);
+		/*
+		 * Target the running twin's pCPU: this plane's vcpu->cpu
+		 * goes stale whenever the thread migrates while another
+		 * plane is loaded, and the IN_GUEST_MODE just observed is
+		 * the (shared) mode of whichever twin runs.
+		 */
+		cpu = READ_ONCE(READ_ONCE(vcpu->common->current_vcpu)->cpu);
 		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu)) {
 			/*
 			 * Use a reschedule IPI to kick the vCPU if the caller
-- 
2.50.1

