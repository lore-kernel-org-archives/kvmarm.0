Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75986230278
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892555; cv=none; b=MGssqWvtmIIhaMqVL5epRCbLtyjW5STrXSxtF8xPAvw3Li6YXCl5eZTHyZ+30CyCrupAv3WN8Y50MATGKq7NVkFjAnOMLIl+NgoVUi/RVqJvZdU117O0xU7j7H7Z7gY1j03u7TjnLd9w3q+Zi5qrHj5JUhq2y/UKRu7leBDwJOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892555; c=relaxed/simple;
	bh=RyYQY6ZWwMFc6nT32sVnu5XE9OeBNCLMJOkY/XJHt/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bntBYBFiGsXZ4/ndpnjsY0cek2gyqwltYbfzZxffkoUBhuWY/0HrRTXynJReX9j6Jk8onbnnj6q4ZjXniswRDmWSPHS3Jboq3pnJSWPH71N/BG1RI9OXVAo9W8kR8Mg0hkHcM1VOzITFTD5lL5D65fSjM+aHItigKz06oWybnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a3Y04Xoi; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a3Y04Xoi"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3dd7587af8dso41697985ab.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892550; x=1749497350; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkgTT4wWRbZ1NUmf838c82NeTMr3HJQoA5BVqQ/v/iI=;
        b=a3Y04XoinOwTAMwGT+LirQ1C2RiRfzLUC40ipGH21JXLoZKVk2jwCAtitWe40OyfEW
         HzZb8o+tClNywUGEwt5oUMyth9RTPKFwufqGDdz7nA2/7oTxRzjGCPShXm85BHLczE4v
         +7GNg5lX9Xh0VjXM98ahWzFXkbhYbgB9yDQLTiKuMEhZGUjxouhOecemsr5tJBGLX3MX
         uccL7vh0QuKxydRf6Lu0bUuo/L6WWdOcecRki7YaSwzlMLxd0yoeu8JSr3cK653oTgSP
         N3WXmCUXa0UrvF+AiEJPrnEkE5r6bTTnTH4oGZXGeRT0aRKr70BxtEBDoT9z2A69zMhk
         1RHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892550; x=1749497350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkgTT4wWRbZ1NUmf838c82NeTMr3HJQoA5BVqQ/v/iI=;
        b=VRy3OHfi3X8/1cM8EomAoQH5aUtKFdGS0Nf/QhTfAr3fV3s2Le9p0FrICxLiAnSabf
         CTFr+YUCeNFoGGZ2zDLFr+1mJUU0mx3DkaRy3k4sQ7/VJzbLL00DnBCmDk/P4mviV5l8
         eq6oElfAwBh9POShdrzkx+wQEQt3EbdgAttXwjsDDQ3ChwwaKpNAdUstR4Rq7enKS3iV
         +d6VtH0IgIwGZp8m7zFTOp13dXHJCZv/dKUJ0wiixNFVQyjrkSmrhjSwPK2EbdrUbPRr
         4jPRA1SwO0VcnUOG0DZcmm9REerTGdoDXPa9Bur41udaS3GW1Gtyn1/GoTaFTXXmk0KX
         uFYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF5o9KOcaW9eoDWkYg9WXepk6wVmW/UqZ7O7QhthNwB79JZj/KQ3NLTCZBwVSF01lT3sd/pTI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHc1wwa8hFNzu+xmqKIgNKBB4vWRzFxVQl6m0K0H9As6xRsPrY
	i/av771IG4h3Wiyyk79ugTP1ZzklbNnrVw/lYItUP1kybSDdj/RralCIpwmDT7+45OUvciBcYZF
	3iVPOJVOmAAbyV71zJzWY+4ns6g==
X-Google-Smtp-Source: AGHT+IH/msiP+hJPT5a6q/xsva/w/itdMQOY/9ZqIFVxoo9pak9WnZnc3ACatvAhfPGVJEVfjUEYVcYY8x4wERvcsQ==
X-Received: from ilbbl7.prod.google.com ([2002:a05:6e02:32c7:b0:3dc:7303:c8cf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fec:b0:3dc:8b57:b76c with SMTP id e9e14a558f8ab-3dd99be4926mr150059925ab.9.1748892549700;
 Mon, 02 Jun 2025 12:29:09 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:57 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-13-coltonlewis@google.com>
Subject: [PATCH 12/17] KVM: arm64: Writethrough trapped PMOVS register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8eee8cb218ea..5d01ed25c4ef 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -142,6 +142,16 @@ static inline u64 read_pmicfiltr(void)
 	return read_sysreg_s(SYS_PMICFILTR_EL0);
 }
 
+static inline void write_pmovsset(u64 val)
+{
+	write_sysreg(val, pmovsset_el0);
+}
+
+static inline u64 read_pmovsset(void)
+{
+	return read_sysreg(pmovsset_el0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 377fa7867152..81a4ba7e6038 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1169,6 +1169,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void writethrough_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p, bool set)
+{
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+	if (set) {
+		__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
+		write_pmovsset(p->regval & mask);
+	} else {
+		__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
+		write_pmovsclr(~(p->regval & mask));
+	}
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1177,7 +1190,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmovs(vcpu, p, r->CRm & 0x2);
+	} else if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
 			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
-- 
2.49.0.1204.g71687c7c1d-goog

