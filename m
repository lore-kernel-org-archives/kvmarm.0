Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C419B
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675969; cv=none; b=DedwKXqh9vMhrX83ylZn5096r4ob+puMbe+pthW0s6G8mgtalPq3ZB9g0nZTnE/Y206I97dJmg3kz40PvfoLXuwe6ooX7R8Bm9Lq7DGKo0Zfwb7ZxEYZ2snLP3StExPA39OFYSIGUvU6TDTIeixhaR4nPgcv7ab/e/YoKHkefLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675969; c=relaxed/simple;
	bh=v/3JnFuZEeNbAoBilPBOf74HrLJIohEfF4qbTOBiOkE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DfD0Y8shpqUVD7zynOU7GgkPZW8mvxjKUV2MBjS4HckWpjaDNmiUAoPV2siWDjOpEDrNfnkDpG2Mk8SoA8+0NlFkeL6UGyRezHZl+hV9OXVs25W6/CxjFwFpkcfJfYnBouky00sNwm5CpsL+n2MIBr4zJzXk5cbrKmeKhA7a8KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b+a3IBaE; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b+a3IBaE"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3418412a734so3949206f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712675966; x=1713280766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rfLKcjfj+XVvS9PzbzE1iRQzwMkmoIsOxyakIn1NJAE=;
        b=b+a3IBaEAo1wuxzZW2lO09pzLzm4b9i73WhLFzz0+PHVlN0r4tUXn0gHgion1lZRGv
         GirRXso9yPU/8Zh3NPTLtOacWWghsHMCyZ9PgCZDI39vvxfhLx0juduzzB5KHnOedpja
         f8+IwsbY5VQzNOXuYwmkXwsaxQlM0RCGWzUR+2Xo66VZqU3OnwB48Gkcy3HwfDyufb22
         yHrG9nZ2YQWFfglWCNKUhjl66WtkndkKEh2zfuZIZL3fhcJkKfzfO8Q/jhAVUK8ZG24+
         WH4smbLp74fUmrba07DkWB2SVEoS039VvxdJEoAyIk/VUtShq2H6GXmTKDOUOFJ8mDCy
         3EaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712675966; x=1713280766;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rfLKcjfj+XVvS9PzbzE1iRQzwMkmoIsOxyakIn1NJAE=;
        b=tg0ltKsgxZ+jd3ajmPVdlrB77Gv96sZZl0gOn5nvDDjk7uUxjna5A1jbI3/CtLW1WQ
         zDeL3/j1OEfCJloCz24hAf0quw4WRamA8y0VaWMngDn71B8munVqMUwYa4dtxP1h1qxo
         mjnHiGerowoYNhif+P2X4VplRF7jdAXN2rst7awblF6O3Og5bCg0YbrmnrsTNBxbpriT
         +y8O77FmONn/L4mKEOx5rH39SNwbAH7LWFEFp1eozwnODuymmbbCFhE484DwjAiPfNTQ
         zBw/ZV4Kz3YXEOzMkU/71ousAR5AHO/RliSGfLHSMG2UX2XC5W87ZZeqQA/MNeulGT/c
         xHzQ==
X-Gm-Message-State: AOJu0Yyec4momiyYox9rkE+ZjGPYxUaqy9VYDTywAM6h7efW6y6Sy9n4
	7M/oz9y0maApbBjREhJJF/6q7fd8WGBSWQsCcatpj6N2/kKk27h8+egP4KaLJPIbkxb+H9JjdK0
	+xK56Yb4GHiui3oBMmjEt59z06g==
X-Google-Smtp-Source: AGHT+IGHvEApjIEO0DRVEt1Bw/UBZ1HmWAyKiDAFHhRF+TTiaNI0l7ccuCy8aYTQBRfw/ptwRlzeTLQxeA4pxCCDt3Q=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a5d:5a8e:0:b0:345:e93b:37fc with SMTP
 id bp14-20020a5d5a8e000000b00345e93b37fcmr82wrb.0.1712675965766; Tue, 09 Apr
 2024 08:19:25 -0700 (PDT)
Date: Tue,  9 Apr 2024 15:19:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240409151908.541589-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	vdonnefort@google.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
and copy the response message back to the host buffers. Save the
returned FF-A version as we will need it later to interpret the response
from the TEE.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 320f2eaa14a9..72fc365bc7a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -67,6 +67,7 @@ struct kvm_ffa_buffers {
  */
 static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
+static u32 ffa_version;
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -640,6 +641,49 @@ static bool do_ffa_features(struct arm_smccc_res *res,
 	return true;
 }
 
+static void do_ffa_part_get(struct arm_smccc_res *res,
+			    struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, uuid0, ctxt, 1);
+	DECLARE_REG(u32, uuid1, ctxt, 2);
+	DECLARE_REG(u32, uuid2, ctxt, 3);
+	DECLARE_REG(u32, uuid3, ctxt, 4);
+	DECLARE_REG(u32, flags, ctxt, 5);
+	u32 off, count, sz, buf_sz;
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (!host_buffers.rx) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		goto out_unlock;
+	}
+
+	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
+			  uuid2, uuid3, flags, 0, 0,
+			  res);
+
+	if (res->a0 != FFA_SUCCESS)
+		goto out_unlock;
+
+	count = res->a2;
+	if (!count)
+		goto out_unlock;
+
+	if (ffa_version > FFA_VERSION_1_0) {
+		buf_sz = sz = res->a3;
+		if (sz > sizeof(struct ffa_partition_info))
+			buf_sz = sizeof(struct ffa_partition_info);
+	} else {
+		/* FFA_VERSION_1_0 lacks the size in the response */
+		buf_sz = sz = 8;
+	}
+
+	WARN_ON((count - 1) * sz + buf_sz > PAGE_SIZE);
+	for (off = 0; off < count * sz; off += sz)
+		memcpy(host_buffers.rx + off, hyp_buffers.rx + off, buf_sz);
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_res res;
@@ -686,6 +730,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_FRAG_TX:
 		do_ffa_mem_frag_tx(&res, host_ctxt);
 		goto out_handled;
+	case FFA_PARTITION_INFO_GET:
+		do_ffa_part_get(&res, host_ctxt);
+		break;
 	}
 
 	if (ffa_call_supported(func_id))
@@ -726,6 +773,8 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
+	ffa_version = res.a0;
+
 	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
-- 
2.44.0.478.gd926399ef9-goog

