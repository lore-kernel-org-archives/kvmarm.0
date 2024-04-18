Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F2171085
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457910; cv=none; b=PsKtSLLP34OxTSfb2Y/ZByPLTPDQXOSIHPPkeor4jSwzBFg+OWmSfhkdY+QdI43P2nlDaVIBoDhFn44FRxYUALPX2gOSC4K5TN6Zs8xit3rveiosNCGoMOq5RTv0h1OgT6yfBL6WoPmrDG7E2ATSv6IPebEyJ4iyNlT30ikx3ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457910; c=relaxed/simple;
	bh=bwRIdgpsHW/V76+UX+Cj8GF/pMxY2YesRhoOXmNznx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d9Ci64L9DF61Mtb5bh/VN8C9ImHQHO8rRrxtusjQT3RaYVokumirlI0ghZwfq6wiZ/qWvGxSx0gMVqg81YNJThdHHQKuchhvQxYhV+5E8Z4zQY2LACIriHRF2cGHs5rpmXMeg006MZqxwoCddF0hQI1lpL0ePp7dDRyY7S12HaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rBsHHHnV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rBsHHHnV"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de4645bee83so1732658276.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 09:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713457907; x=1714062707; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8p9c64neWTEzUroG7YZesoYglVijCCcHGMdjez+sjDY=;
        b=rBsHHHnVIraKqek7sEMj9XNe8b9s19itarGXqjhYsVvpW4ox7tuSt8pqflhp/550uf
         1c9qDKk/nU1i9V+ICA8gdpwsNVDOHPXKZV4DlT+Loc2G1WmqJfGmfmECTh717RMpUmzZ
         FLyyXVXeI90dyWmQ/mwZT4ZETe/ZudEE0F1iKdusloIs6+pizhff3eXTz7A1btTolECl
         uBDK6zeUwAEfalZaz6aMTAspyEZ1tsK1EHCty9oejXEUNYKuSmwxg+A9pL6UyDCwYX2E
         kdBrV8dVmWE2Lk9tzWyw1IY/flw1Gakut2nqIJUVjDM1bK1s52ixM123UPl9nk4CEIIR
         a8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457907; x=1714062707;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8p9c64neWTEzUroG7YZesoYglVijCCcHGMdjez+sjDY=;
        b=SU6DYnOGBnc54hTls2NfeM8lXBrfciIh+jqhAT6IP9yZd9b8HXwScqSiUDWmif8ukf
         GQIFS+Ytz8J8AGOxxBrU6GyXQSpxRHTkhr9UOHZzFg2k73aT7TtyMWNFkYVDcjL5pFus
         HevYkS2XOxeZ8x+cCsKoU7YIb3/KQwd07WxSeJ6djMqgq6OUT51Ac/Db1RgFJd+UNJEs
         AaDgUIrCVvh5+JiTdmPF9oxv6ooD1bmRDmhKsxczqrqoAZILALJZvi3Op/BAsp20cYia
         g3ykN1/GwjHjuElpzjbB4gJg5JurcZlgYNJxJ52BJpwqeB6mu9pnEc+75FLNjsTectr/
         hLuw==
X-Gm-Message-State: AOJu0YzPzWWtBtfEbzV+URO3aKAHE197kBXECV1pHV/bekeg5CUzZJjF
	JhO1kEG3cfW7jdViI5tKDjzve7mJVGHvNkJsi7AFo7++mvG9TtvDZuavU10NGirn978AjjJNJfP
	FjNltyHYoTIEbDRTv7rQRMIUPAA==
X-Google-Smtp-Source: AGHT+IHpX3+77ZV25mCqXIANfzu2cm+jHFm8blOeRGiipeMLfzcogzWLO4ECeP8t8lYr9QlOgIVIHYowhRuQKDsITVs=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b8e:b0:dd9:1b94:edb5 with
 SMTP id fj14-20020a0569022b8e00b00dd91b94edb5mr293032ybb.10.1713457906943;
 Thu, 18 Apr 2024 09:31:46 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:30:24 +0000
In-Reply-To: <20240418163025.1193763-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240418163025.1193763-2-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240418163025.1193763-4-sebastianene@google.com>
Subject: [PATCH 2/4] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
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
 arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 023712e8beeb..d53f50c73acb 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -674,6 +674,49 @@ static void do_ffa_version(struct arm_smccc_res *res,
 	hyp_spin_unlock(&host_buffers.lock);
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
+	if (host_buffers.ffa_version > FFA_VERSION_1_0) {
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
@@ -723,6 +766,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_VERSION:
 		do_ffa_version(&res, host_ctxt);
 		goto out_handled;
+	case FFA_PARTITION_INFO_GET:
+		do_ffa_part_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.44.0.769.g3c40516874-goog

