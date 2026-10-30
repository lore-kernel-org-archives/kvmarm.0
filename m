Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362121;
	b=UK8HO3+bcNZrbjiHNVZZn8+uPMf+hEe3LIhiHZagdDGHoXXvcgJz+oNrZySJ6VZ8Iu3N
	 sCabQP2hEnv0caeCIZDbXN8a0nxelP1J1bTPXYH+e5XPkwuF07BLiuAiVoxdmd07/qOAw
	 cMryCMgWEEuQc4KzXcD7vnVLteRPmQ0vDnYGhrxfc7j9seYtPj9x5sqK93WtwhF8jUsgP
	 KZkSsUlaw1SczxEoFx/BhY/xQrK4DBzNp43rZVTUhGkfK60oSfG43M7vG7Q39rU2QQH7y
	 Ryjd5sHcoiGfCz6w7PFSLiS27kBrWr9xowcO9SC9r9jFTdCxlM2kD5YFZ9+I2Y9zHCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362121;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YHvdax8jNIqrjAvG+iPoCTwsX8ltDDoKhgA9s8mwwew=;
	b=AUleGNWzz2TZivSYaYGdilp1ZodarENF/MdW2KuVaI0DtgLJ81lko11wxp1/vJSX6ehZ
	 n3P04ypG2L5CL5k0+zhs6QMXSBddrTX6gxmRuNGfyAcKJ+jp72gk8HZqk3Nw3IzwXl/gq
	 76Jou6ziI48qYAoXovwxzf3o4B5P0p6z6AP/Bpk3GGqANwjFdqNTczZV4XWZyGVvs7L/n
	 29pjifcKsjCZhDHaKvF0sRLJAbYR+tVutxnByN9OMmFC6rNcFlH7NIR7eVYv1hG9erO8e
	 SBNgQUTrGAEmC990CkfyIIYnLSg8jcFuyLMNOv6lX7ERpeqSbLSryW8rTfH0HbYZmWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QCOP9HPp;
	arc=none smtp.remote-ip=95.215.58.243
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC467606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 12:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC467606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QCOP9HPp
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Cc4U2874y8LkEiqSaDLuX6mELblZR/FqjhEmKbomCeE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793362117; v=1; x=1793966917;
 b=QCOP9HPpAJsjaLmb71l0+gCmO6SqrOivO9uLYQqMQ6bqEk0/Bn86v06DdeZ2zf4lttwN9x/B
 zqaAv0l2qde83hbp+u9szYs610Tu5PwC5bISihqJFnKBQ9GSU3zLDnnicL86gzUmTxj6A4jjAov
 zY2mTw2v9jIHFpcDOsEE7rQk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2ed175903d55f33c;
	Fri, 30 Oct 2026 12:08:37 +0000
X-Mizu-Trace-ID: 2ed175903d55f33c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: sashiko-bot@kernel.org
Cc: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
Date: Fri, 30 Oct 2026 12:08:37 +0000
Message-ID: <20261030120837.3752397-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-190923@kernel.org>
References: <20261030105139.3543230-1-fuad.tabba@linux.dev> <sashiko-outbox-190923@kernel.org>
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

On Fri, 30 Oct 2026 11:09:43 +0000, sashiko-bot@kernel.org wrote:
[...]
> Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
> fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48), won't
> kvm_handle_guest_abort() fall through to kvm_inject_sea() and inject a
> synchronous external abort into the guest instead of calling
> kvm_inject_size_fault() to inject a stage-1 level 0 address size fault?

Yes. I'll fold this into v2:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 705f6d84770e9..2a05c7cf8552a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2440,8 +2440,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	is_iabt = esr_trap_is_iabt(esr);
 
 	if (esr_fsc_is_translation_fault(esr)) {
-		/* Beyond sanitised PARange (which is the IPA limit) */
-		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
+		/* Beyond sanitised PARange */
+		if (fault_ipa >= BIT_ULL(kvm_get_pa_bits(kvm))) {
 			kvm_inject_size_fault(vcpu);
 			return 1;
 		}

[...]
> Should setup_s1_walk() and setup_s2_walk() use kvm_get_pa_bits(vcpu->kvm)
> instead of get_kvm_ipa_limit() so that check_output_size() raises a
> stage-1 address size fault for TTBR base addresses and descriptors with
> bits [51:48] set rather than letting walk_s1() and __kvm_at_s12() truncate
> those bits when passing the address to stage-2?

No. setup_s2_walk() passes pa52bit=false, so its output size is
already at most 48. setup_s1_walk()'s output size can only exceed 48
because, on an LPA2 host, NV guests see stage-1 TGRAN4/TGRAN16 at
52_BIT, which Wei-Lin's patch [1] stops advertising.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261029223732.103785-2-oupton@kernel.org/
