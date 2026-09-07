Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C9E51FCA5
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801582; cv=none; b=kapOIEbWYOhkGySBFyZDUHzZ/XdCCs/RCk6iWv3zzE0Go5Du/+amudzZamsAQXK0KH8Yw8EGyriW/F3esQs1BUj6Tx+vYfTAK3eZQubecKlp4j0kk1UGbtHa7CbJofuah02EX93kqDMGbGk82QFTMNa474iNouFf+yYCH9IcNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801582; c=relaxed/simple;
	bh=2k/WVnGhr9Q5gGIcYxANFK+tJ+UnkdoNdQN+SRoygi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gSyh/2xyzANbVlixN8eYk7dkTYT/+PM56shX6I4We6u26iC38m2U0p8Q///RTP+rXw+JXJb7zspBRa5ofUoBSj4K016pNgvL6cgp/jOlBsERub5vW8hANLAf4d2pIdo/Qzi6GPvIHsUlxqwg/4C3JAQAItampQwFPh9Yg1nUiz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=upFv4kkz; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="upFv4kkz"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a22bf0so847574a12.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801579; x=1789406379; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t0Sf8m75gFeh91WC+y7QYQ8hJssugbj/b/PWhI9KP38=;
        b=upFv4kkzLQeE4l5CwqY9TjNltuyZ4DHyJOFu5N1OK9HzZ9vJyXGMtbkPIrDCvMakch
         BlbyL1cHxhEo28EQWEu1BFyDfPF6DLl06Ho/4J2dzjTTZxLb6KFt993ReQiY0dnat/09
         bTvb2MeV5tGAgsOLXevU8Nu5D0kCOYvghXO9pzl8Z0N0DisABmvcmJhJ2dKdM0twsS6B
         VA9CnL0l+m8GqVmLO79zk4o341Sc/Ho3tYoaE4/+YA12vGfmyygJ8aFnIZfNRDSj4ZaT
         WgQ1Qnz2lnqSpJ9G748yWlP6zOu6D1JBUhQ+iw4o2Kw8ROqD4l57hmezVowev0prtzA3
         Y9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801579; x=1789406379;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0Sf8m75gFeh91WC+y7QYQ8hJssugbj/b/PWhI9KP38=;
        b=HvQ4BlEcEGM6ljowj/AcX6TDe/FuPFfe8CCC2UcyLMMaoKMC/6+646MiQS0TzlK8Ah
         WjYnUwCR3fxVSQ7EpkgT2oKIl4MYb0YjvWMphBHByY9kQzp35Lxh6ZFC7YNXaDh8NxDN
         buo1Rj+bjGw+XrhpUGCwRfPmMtwMs5VAXJJx2w8EWt7RPtO/PeKD/hobZMDkcfaUs8Ny
         KJ6I6940jtQUE8534Kn2PSuD9s/rrLxtHgyrkyL2OO25UWuUJxIXrin1il101vrQIHWj
         qvHyZGlh7Dqhr4xzmNYAMP3m9a9YD+aeXwm8kRjKwYHkuXjNfUxbuP7Dt43vYAXB1jM4
         5Epg==
X-Forwarded-Encrypted: i=1; AKwUvBy5iWSBs1keB5V/xRBxeGXhb/sXSCThhncrP50CYRTjAT7ANCPTYleHRxP+ROCtY7utjJfr51Q=@lists.linux.dev
X-Gm-Message-State: AFuF++kqjXz4PvUcYWEdkTkuvp6hsdB54ovc/8zNoT6YJJz5V++8912f
	XwVsHy3nAtbXUw98+aZMj8YK4vEw3l0/1tEXhgMGjmIIQECJrWFipWzPi/XX7NIFOZxAO6GvM51
	LTnb/+SZ4wkLwYbCwcX43wxgW1mvJFA==
X-Received: from edyg17.prod.google.com ([2002:a05:6402:1811:b0:6a6:781e:6d4a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13d1:b0:6a8:30a:7ceb with SMTP id 4fb4d7f45d1cf-6a8030a7d90mr5253391a12.32.1788801579063;
 Mon, 07 Sep 2026 10:19:39 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:24 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-3-sebastianene@google.com>
Subject: [PATCH v9 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification bind call and forward the
message to Trustzone.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index aa82c58380a8..89872e12f9d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,8 @@
  */
 #define HOST_FFA_ID	0
 
+#define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
  * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
@@ -692,7 +694,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -891,6 +892,27 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags > 1) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res = {0};
@@ -953,6 +975,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.979.g7e5102b832-goog

