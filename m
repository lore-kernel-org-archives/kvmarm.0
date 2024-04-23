Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9D13BAF6
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884773; cv=none; b=JwTtvP9/C/KKQRjGZTcdsnNNBEteuIg+Dmg3j2fuxClhau0G9TTAYukMI8HpKBxIqe/AzT/QPLW4k6csM7mksbdYCHDakBYy71g4mOfn2ffP4LWtBNqs7CtIUYuhEUWqzJmHiWdjk3a8Rx6/DF2ELlwbOytZykIaPnQNawH2hTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884773; c=relaxed/simple;
	bh=q0c8lIPISRC2zgYR3QRg99POexDAPNNVN8nZ07rNwm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qCWRxbHmpbQ1nP0KR5gAvC537xbOK5RzjFWyFMOfZuIHdSf4TCqnttgmd9CzveE5JOYZdndZMWDtDlVdXe6EO5Nafy5elqW49hFJas9HWlGR7fVw5+JQtaaPRV/b2DGySaw1Rbc3BQiEvKU/kaG8LHW0CnTyogehHPfN7dGkkz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b5JbQDcn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b5JbQDcn"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so8252994276.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884771; x=1714489571; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlJbzAGB5rwzDf9vcn6vhM7P59YJhMDFjOqGlol9fsE=;
        b=b5JbQDcn+GJyWiFVYVKd19TcZAKooFBSGJm26IHCCk9YEQjYEBxNuf5R09wVU5vxjC
         D5uFVj8WNwIiq6U5kwsHcJGPCsd7jrjzqrrkDTSGKBi+OD8aDAqjmj6aR7exlXVoSfIh
         lQnkBsQv314BN43Bo4Ey6ECTqI4LUfTRZItKdvUbGSxxlDYdaoREE0NbgytnoW/BHLAb
         shCijGxR6HMJywEsfFojT5sh/ZHtuUwprORiBMqyo+fU10rKRYZy5m1vlncu1nyw/Slp
         75f2X/KgLieWO3M/id4D8AestrnOpYTTuQSTQ9nQkira1mb8jJ6VuUAY2NMWjzgK5Wcb
         Lnjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884771; x=1714489571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlJbzAGB5rwzDf9vcn6vhM7P59YJhMDFjOqGlol9fsE=;
        b=k16fqFWa7dJdBTsbCJiCHFzN3Q2hXO26wTmEqNgjf9HaymjSjM3W3J8REZQ+TexI+L
         t8SHoUA4FhdUgsUbO4PD6/+32u34uvgt2nyr8ooR3cRuRFkbr03WXvGGYfevQKpsXbly
         35pT1xZPdJmjLXcFVY/6QSg1/yljkY1eJ7ByVEZi7gcsejSSIbogdvnlW9pMcuadWbwq
         qwG4/6HbWyfIUB2Za1Wuni8QSF8DzaWL4mnWnJ5LtNsJcsWI1LWSWa6YGkq1zC7X0trh
         ih3T3/0jpB8k9WowcnWQbZwcEG8yM8uDiI3KGwNZI/7+NoSsYk3UhfJxvk1dISkvFxK6
         RzdQ==
X-Gm-Message-State: AOJu0YxpnYdE3S5GjLOi6AdhRGCnEHpfm++KTVlS+NhAhB3naEl0L+TW
	Kh2yJMluBXTAcUf0BOpZpw8Tl8J/niNYWKSyrFzPutda8Ppi1io4tdBnOsjxxpf6wfkAU4sjU6x
	pYIpUdwAQuyMRR4xCnVtip8whtsszGQ7mgQKVf4GuGgvHfBcl96x6fjR3ztcf5LR9D4HVLIPMPR
	4qpZTqF0r7TV79usE37ZrNMgnu+aE=
X-Google-Smtp-Source: AGHT+IFjZCkJs1wphRKtWO+SRh1RiFzDZoRAuYmAshk+rfl3A/VyogGjHZ4+zbKG6QaiEHUqQ2w7kmCuwg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:989:b0:dcd:3a37:65 with SMTP id
 bv9-20020a056902098900b00dcd3a370065mr923109ybb.7.1713884771017; Tue, 23 Apr
 2024 08:06:11 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:21 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-14-tabba@google.com>
Subject: [PATCH v4 13/30] KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Fix the comment to clarify that __pkvm_vcpu_init_traps()
initializes traps for all VMs in protected mode, and not only
for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 315d4ebe1d6a..16aa4875ddb8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -200,7 +200,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values for protected VMs.
+ * Initialize trap register values in protected mode.
  */
 void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0.769.g3c40516874-goog

