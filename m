Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923023D388
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718128408; cv=none; b=oY9mztGlWHXyr3h5Ro4PReSQxB1IHi8zAmfUeeYk/96qbSffnSLgxM9GrMWk5T2W6qLLloi2HE0jc3GGLJl4UlyVRrnWtiEtZ+p3reHaT2xhyQ6dmuKIk/iV+R3qGWbIoFNwuVlyK+vL4lWwBAafcEVUllx0sqmkh2R1M1WDOj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718128408; c=relaxed/simple;
	bh=dmI95Cul7108EcOi02xjBpwOW8/tKDjJJw9BB7Ft/qo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N3A7DgfuuNzpD7pVAubKCLjzDKKxbSZjVfy0BbfIzTITfuZLSktBJe3Nm1elTeT0RuCSdzrE6G5rW1E4PjbwKHrD0LIWEIeQdFxGkKPGaEmgye6aL9azXztlU4NfEAOu35oDsbdwSAM2hyHQfZteHiFPtfATBS+sXSbIPQMOESo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMyKwQyU; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMyKwQyU"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4212e2a3a1bso44878535e9.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 10:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718128405; x=1718733205; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jNNUQKkDrCnecnYCTT00rCZOmSlFkAs3089jG7rC2ac=;
        b=XMyKwQyU4znIH7wMbW8r61UpbpUVRaSjLYO6idX0mZdXL/jRlLYSm23+cZAKyqdpHp
         5bRTIbkT5C7vuWG/vaps5G+ImkwvHHWC8EMJ2YiWNWQtYnrbpzbpV6eapczlWkgqYfx5
         Yl76qbrOm4JYBi9JPsSPqK518S1s0ApwYrmxCghAa7h7gRaGEczLnNskaD2iuVueS+BP
         Zq0CWUJCugitDIaMGnh7qaqeHqxOEYVsNNcIGr4xEs6VIeW2JrjWm+t94IOamspmf9zj
         +B258IBC2nNjDMRbVV6VVB9VzY3CfSWzvgjwSc5Tk0FFdgcpHiveYVI4VNBqVr8EIG9M
         nigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718128405; x=1718733205;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNNUQKkDrCnecnYCTT00rCZOmSlFkAs3089jG7rC2ac=;
        b=L79ce2jRyC6g9WeNs4V0CzhpN0rMeHjHljZZ2hZ8KWTrXD2ZB6HMesARUBc4zwntfM
         8xwSSq2yytSHLbUZvDfeY11HT5xiuUv0qR0ivnoXcWNEzNztSA6EylXUC/zsb//Z/poP
         YU+woqzPwTmUzp4ulvlMa3JQZUGOpeTtxGD6gjvcm9iZsbedYjs1AJ6NmFzoXJ8mvu6d
         pO9bmfxlbsDhMUZ1G3gph0UqvHmBGGCYTteUeL6Z9fYQlXGJAbCH2eRf4A90H+HJPUiT
         0YvxoxxzahXNCSFhhhfAButiXOIxYXZlXXw43pJX9bpSfFwX7/oM/Td3btOBO1EOmYMN
         qbhA==
X-Forwarded-Encrypted: i=1; AJvYcCVwzP1bGB24+dzbq8UgsrDNX6UjHLEj+4BejHXC6iBdhoVcCvQuV5veCB/s3JZoYoO4mFi6EvFWiEvTooWEeVbeRrCS/SW3
X-Gm-Message-State: AOJu0YyoxIBTTD13NGWPHVlHRn1OOcKtR+yU3gVMOq9NlxB06HVoGsQ0
	cM33UqL+8yKBuj1wX/CA/0iKXNSNXd0+NgnsqcNGAJGMbtiOsUxqk58yWFKWsqbsJUR3wbUcvcm
	qr1jMnvgMFzLbl81PNg==
X-Google-Smtp-Source: AGHT+IEdZAfoZ4LDqjGnbpGpQjreFI4VULQxzKYqfTIseY0dz3/8fUXV0eI6QWfpdii1eUzbGB8RM1wSDTdOnXqx
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:1c10:b0:41f:cec2:f853 with
 SMTP id 5b1f17b1804b1-42164a3bdeamr2236685e9.7.1718128404863; Tue, 11 Jun
 2024 10:53:24 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:53:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240611175317.1220842-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: FFA: Release hyp rx buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, sudeep.holla@arm.com
Cc: sebastianene@google.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

According to the FF-A spec (Buffer states and ownership), after a
producer has written into a buffer, it is "full" and now owned by the
consumer. The producer won't be able to use that buffer, until the
consumer hands it over with an invocation such as RX_RELEASE.

It is clear in the following paragraph (Transfer of buffer ownership),
that MEM_RETRIEVE_RESP is transferring the ownership from producer (in
our case SPM) to consumer (hypervisor). RX_RELEASE is therefore
mandatory here.

It is less clear though what is happening with MEM_FRAG_TX. But this
invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
RX buffer (see paragraph "Transmission of transaction descriptor in
fragments"). Also this is matching the TF-A implementation where the RX
buffer is marked "full" during a MEM_FRAG_RX.

Release the RX hypervisor buffer in those two cases. This will unblock
later invocations using this buffer which would otherwise fail.
(RETRIEVE_REQ, MEM_FRAG_RX and PARTITION_INFO_GET).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

---

v1 -> v2: 
  * Use FF-A paragraph names instead of numbers
  * Reword commit 
  * Collect Reviewed-by 

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 02746f9d0980..efb053af331c 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -177,6 +177,14 @@ static void ffa_retrieve_req(struct arm_smccc_res *res, u32 len)
 			  res);
 }
 
+static void ffa_rx_release(struct arm_smccc_res *res)
+{
+	arm_smccc_1_1_smc(FFA_RX_RELEASE,
+			  0, 0,
+			  0, 0, 0, 0, 0,
+			  res);
+}
+
 static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -543,16 +551,19 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	if (WARN_ON(offset > len ||
 		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
 		ret = FFA_RET_ABORTED;
+		ffa_rx_release(res);
 		goto out_unlock;
 	}
 
 	if (len > ffa_desc_buf.len) {
 		ret = FFA_RET_NO_MEMORY;
+		ffa_rx_release(res);
 		goto out_unlock;
 	}
 
 	buf = ffa_desc_buf.buf;
 	memcpy(buf, hyp_buffers.rx, fraglen);
+	ffa_rx_release(res);
 
 	for (fragoff = fraglen; fragoff < len; fragoff += fraglen) {
 		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
@@ -563,6 +574,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 
 		fraglen = res->a3;
 		memcpy((void *)buf + fragoff, hyp_buffers.rx, fraglen);
+		ffa_rx_release(res);
 	}
 
 	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);

base-commit: 6d69b6c12fce479fde7bc06f686212451688a102
-- 
2.45.2.627.g7a2c4fd464-goog

