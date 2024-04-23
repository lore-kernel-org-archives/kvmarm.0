Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD82E13BAEF
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884776; cv=none; b=hgADnqoe3/VaWgAyJ81b+0y7zqOcfORqraz9cgg3iBoy2bNt03zon7uoQiR1EOqy7KXztA541eX9286A6jIqRcG/XjGmh4tRoioVNOsRagPmmy7+zUG8KNFu4E/E5ULeH8UbXwaO0sWVKTpj/ElOhk1LdETdXbjA1aFE/kjW/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884776; c=relaxed/simple;
	bh=ASKP8itz38sbqIeWyw8hZsWe/v8PjvsyXVx2zQEuFsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FrrzNuefLQvKZaU0KKY2VwNOn+gotI6PWFNaO5nUIcnfTDBBiIRtW2YY7VFUwWQ5J65dDFw0cBDREmV8IW3bIgdRAIWKjFVSSy1bYoWy2xWnHFtRxIV1z97jevHyoniy3jxSBfd5oT0v3BWXwgyW3yI/2kq70yF+hMOK8wOMQeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JtFmcDxU; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JtFmcDxU"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343d6732721so3597418f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884773; x=1714489573; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1OCSEJ6pFhZc3rA/0JI7TRjB/vxDcbXpYYvD1ntLBLo=;
        b=JtFmcDxUn3UH14x0Ftd41CREaYPWewX5tmiG1GK9sp+0EjxL+ST2rCMf4SVssvtDQ9
         dhX8rq+Vr6hJz+SqtjxrsRNF2AALZupDsNQUYOsj1oHX0UWgeR0mVAvCo8iwQ+jkRmh5
         U31OYpee7F1y416dYA8EwHL2UK3aKXhPWw9jLWXLqYluzbB9t06X0kUmUsDDX5ctpJCF
         u8p3c1btto3vjGxhmNTjvPlPtO6MnB30+LLILJMYX+yMbmiWttRaFBbCwKy/I/2NepsU
         UG0VxoafSDbLrdumtasLupzq/0JnPLrwt5gEzgtc+WL+49xhJiVeTj4k/lxiMqVz+mq8
         AiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884773; x=1714489573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1OCSEJ6pFhZc3rA/0JI7TRjB/vxDcbXpYYvD1ntLBLo=;
        b=k+BgspAVqjA8ypNCJYZezcjJmw8vKrlcW4mwH4sIDZsDN0fPOBJRBBkrU5DPxi8RAM
         I7FJKpcWtQswNi9WnFkkqvi7ao9fkc5gd/ugIyJqO02bH+dteiZ2YnRjdMC+MHLddx6o
         k55It0gmNHkrBkCUCghkxGllqnKQAXRFERR5hyCZZb9qABAnFXUvhj6+abkHy20XTFd8
         +EHtxkqwOrJ05p35tzawKj9B+hBF5sZi9dBp16UjVxPR5cA2MgiqyaP2j3/qkEkDLMFf
         ID+0yZidoe+c7L1E6jAqDr1X3Oqn5Ab4pgdrjK3UxS7D42KYtFlOoAZdUBscI0wka5fI
         vszA==
X-Gm-Message-State: AOJu0Ywa2HNGPxFvHN4ozpz/eDqMEpIZzrp0i7ymqI59dSWJP/UD1/xk
	Gr2vrtoArFtVbb+CGDqeFgYxbmpDp+VGPwxNOFMv4uqaf2QUW8b1XLF0OZ4BbGl1M+Zc8+g3AEg
	nSj2wHNjh7XakjNAZ7gr77C/wa8J/6kVAEVstpNUggwi77Z0laLNvptlt22/362F5YJOjNqISWM
	741gc8exWVhDiG8GuLPYcu/1fbLCs=
X-Google-Smtp-Source: AGHT+IHFYa6n2jCRvTD8Sfyn6DpWM3ahJBLPR2+goGWfh2lLdJrf+9iV7GTf9Zk6efdffrTxWLFiIn0+/Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ea90:0:b0:34a:d53f:6a5c with SMTP id
 s16-20020adfea90000000b0034ad53f6a5cmr21364wrm.2.1713884773204; Tue, 23 Apr
 2024 08:06:13 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:22 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-15-tabba@google.com>
Subject: [PATCH v4 14/30] KVM: arm64: Change kvm_handle_mmio_return() return polarity
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Most exit handlers return <= 0 to indicate that the host needs to
handle the exit. Make kvm_handle_mmio_return() consistent with
the exit handlers in handle_exit(). This makes the code easier to
reason about, and makes it easier to add other handlers in future
patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c  | 2 +-
 arch/arm64/kvm/mmio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c93ac8a77c27..e9eab8f2c6db 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1047,7 +1047,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret)
+		if (ret <= 0)
 			return ret;
 	}
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 200c8019a82a..5e1ffb0d5363 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -86,7 +86,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
-		return 0;
+		return 1;
 
 	vcpu->mmio_needed = 0;
 
@@ -117,7 +117,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 */
 	kvm_incr_pc(vcpu);
 
-	return 0;
+	return 1;
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
-- 
2.44.0.769.g3c40516874-goog

