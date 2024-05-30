Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB78176ACB
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717075062; cv=none; b=XQYO3lb6B+0uGrB/JAGdEAG748r5j+w5bKYPlzcNxVojw3tlYXBL1lCTAAprF3LFdfRcEugwFlOcINLRoUkCWxKF3MxMvbFTTPfi/b0mkZuQGTL9OWTVFHROZLkbt7s7E0AFGz7XqVPSDRUFCsEqJpiMUu9AeKOkUBfiouE1004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717075062; c=relaxed/simple;
	bh=CxIUN3Lji7DY92hrj/+p0NzGO5O58oa5RSnHgOoDbkM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=h3SgNyPy1wNSf77TOO+v8osaYsC0NBF36c33gZRC29lMhpaQzMV7xO2NcalIw1xrikB5SzFMDcWD2foBqu+AYuM5tJwE6JS9sywqtrHJRwTm0IAIc82UhJqBIL8IqwHgheaM6wwSDOeBD/I6jf8winR7sluMrMprpC7sEd3ZTd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylXeD6jB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylXeD6jB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42128f7b5fbso4574145e9.2
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 06:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717075059; x=1717679859; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A2h19ypI6tOBSYk6uWwSlGYJAlpWcvaEZOfEyoOEcjk=;
        b=ylXeD6jB++zaCpvMDVYzZjr8YLHAtUzTg+ud+r9eIvAqNwyfn1goDy57UXzS9XlFOy
         5gg7uMZXMXmIcQATqqi5l/5SbHLturBv6UJ/iYh0DymS/6d/xmjRkfwZMGyzVBIx7tMX
         qipkWQcCLhSpW/VeY84PacI1um8nkL6jSO91ey+jC9LLGf0kTAYPEsnvg5oLGjXsdPi4
         W9E7z0RM1rmtNiGQySpKc97dkR6J7Y7WRS0LKGOgQlr7EhVK652NXQSKUw8hemYKhhDE
         VYc25YvkFIEIarweBF0q6VYbIpziBtBXYMYU0mhlpwaNqi2hI4I9yuTX8hRP7axR/Hq6
         T8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717075059; x=1717679859;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2h19ypI6tOBSYk6uWwSlGYJAlpWcvaEZOfEyoOEcjk=;
        b=LB3O6pSfGxqMXnf1C2Y8Qdct02zCcsJGDexFNj1Qj57SEZgVfIZ+rQc316cChvtU0q
         rQdk40BDGzLt/jSAmi48S5jee0zUAy4hoWOIQiVcyJ96W5DSAMGpJMtV0B7/DUxtLAEC
         RprWisMAGkXgXHLaHmxkJCx9rjTkK8sByeGCoRMLiM1k0VUqz7cj706YGV+M20ISFW2l
         z6DFDqz08SSiuo2gKrfkrJw8NFRklTZjZWeWqV00lKDcx4w6ZlzQzcSnlbHotEfLSqEp
         j3XN4nBr456eZXsWJdcwEHfjJAf81dzi54VqG1it8Gdj0bBApsZsCQG6Vmn4yYr2nMjU
         3lDA==
X-Forwarded-Encrypted: i=1; AJvYcCUJmu0iHFc6Wkasby5vuIosAIeiukrM/XsFPtAIY6LdaFI3iw0rw3cCoOkCReAXTyWFUvEJr5o5HkKzSF+ewZAsozEe0/VG
X-Gm-Message-State: AOJu0YyOwiYwNXLsYphRt7OXlc/F8MjrsZwyDcfytqoEvUKpz1ZYyE2/
	S5x0+INwjqmsh1T/PkKEtZjLdHs6M0bsqNXeaeD/Qo50mSR3ypQC8x8lgFnCtLE0BXFlgCcTQ76
	itLwg0egJB/NUZfqRKw==
X-Google-Smtp-Source: AGHT+IGh+KPdywzR45ey0MWLtb/lqdkOKtXl9CHjrK7tb6aGcEqLmSXkF7e0XyWNok1bVIvHaiwfYCYKB5tbSO2h
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:3b94:b0:421:29f2:7958 with
 SMTP id 5b1f17b1804b1-42129f27c40mr69125e9.1.1717075058922; Thu, 30 May 2024
 06:17:38 -0700 (PDT)
Date: Thu, 30 May 2024 14:17:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240530131734.2724454-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: FFA: Release hyp rx buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, sudeep.holla@arm.com
Cc: sebastianene@google.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

According to the FF-A spec (1.2 BET0 7.2.2.4.2), after a producer has
written into a buffer, it is "full" and now owned by the consumer until
it is read and "empty". This must be signaled by the consumer with the
RX_RELEASE invocation.

It is clear from the spec (7.2.2.4.2), that MEM_RETRIEVE_RESP is
transferring the ownership from producer (in our case SPM) to consumer
(hypervisor). We must then subsequently invoke RX_RELEASE to transfer
back the ownership (i.e. to let SPM mark the buffer as "empty").

It is less clear though what is happening with MEM_FRAG_TX. But this
invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
RX buffer. Also this is matching the TF-A implementation where the RX
buffer is marked "full" during a MEM_FRAG_RX.

Release the RX hypervisor buffer in those two cases. This will unblock
later invocations using this buffer which would otherwise fail.
(RETRIEVE_REQ, MEM_FRAG_RX and PARTITION_INFO_GET).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
2.45.1.288.g0e0cd299f1-goog

