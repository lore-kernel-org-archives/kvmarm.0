Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC07F44C656
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327215; cv=none; b=bhnBo4qoumwRgnZEoetShsKDg8SuVC3wRRlf8HMxVi7cGmnBafFqbdetconMnwjRm1YVFYrGAIPZrQhEdtUZo9wUecUMrpYA2jSc8+NWKpp1h+43IwBzzuKsRdL7JOjfiGswQUq1auZcEMnZo+x7j0bGZyuWANTnOOi7eEeS5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327215; c=relaxed/simple;
	bh=0vSlXApgAyjRAeE/Jq/97aOoxSyLLWWwUFaphULImKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C0phsz6VQVvyXIwlzYQJ80CvT+D1hcQHDrmLBXPXR+ijAp9f3GjMiqGj9l3nNXRXJIKcx+3eGK3xlMYYnRc1AtA/nbmy5NuRlCChWRQxQBZGOEOM3Nc0sbnT8Pm5WsR7kfPIpHcOxHHLtfyxY1m/PTgpUFFhKJWkkpgz6J+6yqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jBmAjlZG; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jBmAjlZG"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495569acf8dso6329425e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327212; x=1785932012; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thsyczRLbjXAiylyvIOhzxaR9c8IJTQiSChj+R7W6P4=;
        b=jBmAjlZGKxxr9xMTfbnwInNiSzJtml0iqGcCn/ws+klEml+ZjscEdEZddZl3l6KW5b
         w1OBU+wo+gR77PcOdKklvog/jlIzISNlweZJatSs7WC8WKQ7OvTHL1C7lCGKJAfAUDju
         mwZCUVrDj9dIEPjg4dEgH7JJdDIwoaeoM9eGYzKZweqILXMHBKbAs9uQzta1rVlbRU8a
         d1romDofGZPcP3tGj3LB3SwH2KshFZLiQSjBpvFQxaUqEQQqAt8lyGovDpRGX+OoVvxF
         yNyOcXDhZYQ6v1Sw4BQE7BN0kv0PoUrbSXqJ2aYlMrhmDIq5mmTlsEIlxDKOvfNPG8N/
         OBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327212; x=1785932012;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=thsyczRLbjXAiylyvIOhzxaR9c8IJTQiSChj+R7W6P4=;
        b=Hu6r2yLn+sU8PrlSLJkZCyYmJF6ONcKUZYMd7NPKgdzphcEiBJiyXebJqEzqtyEif3
         N9e6rx/bYsZ18LBdwYeFc6SSmouVyoEltIGhrHG5mvavejMKcenQmXQwXQrrgzHeREg9
         OmT79SsYqKn6llTtv+mly8wyxZ+IMrxAeVYhy7w0mRYkcpWbq+PkFDlGEpZwv4RA8EUV
         WZfBizOVVv7KtItBq2jd/vKFsPOpGB0KPN2S6CHL/P/iQOv01emChXu104gFvJTFJ8kF
         LNNGlKnsBe8tc5sa3WEpvkrrMNkc8XPZLWhsMMJM/1RInjnvREAInBENmd4op5CkhtMN
         DjmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rptuf4gu4mVcXQwnAR+KTprpvDtqg7/N/S+M/yd618LSfhQA+udQ4nUI3mJQFwUs85m4c743jk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH6X4JMPOSZUxauQoEpyk6MgbKnpLoV4raz3M19lFtaEP3lIl4
	8NJhopgH/+S4n9o0J7SmGFaJj4cPMbVqOqdF949S/GVYezLe+DhLXy5Fi5DazJnNCeZgl4cQz7J
	iRmhhyPxccD3bnb5D4NAiyUr8t5iVvw==
X-Received: from wmby12.prod.google.com ([2002:a05:600c:c04c:b0:493:e006:3161])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8010:b0:495:3f5e:e7a with SMTP id 5b1f17b1804b1-496c6588a7cmr78133495e9.34.1785327211938;
 Wed, 29 Jul 2026 05:13:31 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:01 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-3-sebastianene@google.com>
Subject: [PATCH v8 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver and enforce the host vmid
check.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..ecc13b795f2c 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -676,8 +676,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -862,6 +860,21 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (vmid != HOST_FFA_ID) {
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
 	struct arm_smccc_1_2_regs res;
@@ -920,6 +933,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+		do_ffa_notif_bitmap(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.487.gaf234c4eb3-goog

