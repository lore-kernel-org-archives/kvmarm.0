Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21F15A8
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 02:19:09 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-552f169d85eso51570627b3.13
        for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870748; x=1684462748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOVoOXEuKgQg2tBCLrjO+Ie6Feguqmtzji3r08inyQ8=;
        b=GBpDxzuZ8iJftmRFbQ4u416CLpAaocgcZ258FLuBJdT5LXUXVoFni09Eq8Jyypgsdi
         i3e3mWkR61bQcOBiE2Na5nyLZ9Vodg+T18Ab03ypVpChrLseDg7l+pl9A/nIiyCxU2oa
         rXUs/G8SdfeIcRJ9MrRo96XWQfkkPzlaaoYvG8YVrySHFFhSYSJlQNXpboOcNU7QnRi2
         N23NYdPybyffUM3dTo4131YLhg/3VGFXDfAx0oFFH9pojA5Pwdv2A7+FS+yWFrvLJImB
         EZfnFhoF34L7GoYAEWgrIRv2pu3Dzo4nE9mWrei7GCzVdLnkXrcmMY5eeBzO40mvwy/g
         rw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870748; x=1684462748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOVoOXEuKgQg2tBCLrjO+Ie6Feguqmtzji3r08inyQ8=;
        b=l2JvtU3eFqSCahWpggt5EDTkiz9ld2du0BoZQI+RJVQ/hdrkDNgiKIJKz7BYLsfGrl
         7b6xnRW0PAe3nQdwrBmwGiXt4XfLkFoY3b1jR5cef/KMKH+JN6STq7Wfzgw9pxDOBc2f
         cUwXvNnepIgfu25cT3nY8y0g3F8LNUvkzrvRzJP1d204Yo76JxEX65a6BaTKRk5M3jM+
         hLRszaqd+VN889aLYZcpMZhcUZde9x0DIBWpj56SRxrdJT+YbIcs8EsiG73/4Rnm9v+x
         BpXXD+P6sGvuG2qA6Joe/JNU8WfIZSjR9svA7Gz5h5G9HOhAzUXbcaXQcgGDdNANv2RG
         QNyA==
X-Gm-Message-State: AAQBX9dyGDzO4OWiCkwnvLADFHno6KDqaQzh1Ld5RRkhixm+OzHREIzZ
	SuSOrD2o288tL3A+fddhS7GbZ9fmx8U=
X-Google-Smtp-Source: AKy350ZAJNC+m10rAkRY8MhHkLcGAFWbMx7c2WWQF2YMC1seAPFdQ+q3ICVHOmnhHJFjhA4DMarFTvB+Emo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d68c:0:b0:b92:25bf:a6ba with SMTP id
 n134-20020a25d68c000000b00b9225bfa6bamr7234069ybg.6.1681870748829; Tue, 18
 Apr 2023 19:19:08 -0700 (PDT)
Date: Tue, 18 Apr 2023 19:18:52 -0700
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-3-reijiw@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE()
 to update mp_state
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

All accessors of kvm_vcpu_arch::mp_state should be {READ,WRITE}_ONCE(),
since readers of the mp_state don't acquire the mp_state_lock.
Nonetheless, kvm_psci_vcpu_on() updates the mp_state without using
WRITE_ONCE(). So, fix the code to update the mp_state using WRITE_ONCE.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/psci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 5767e6baa61a..d046e82e3723 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -110,7 +110,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	smp_wmb();
 
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 
 out_unlock:
-- 
2.40.0.396.gfff15efe05-goog

