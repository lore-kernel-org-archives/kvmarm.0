Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C972E2957DA
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504073; cv=none; b=nue8IKfsVNHBN9PwPOA6n4a0B7nj//ZpmhoTahWW9rzoCAhCqLm9NHgrj9Ti5szCRKqRzO2YBcea2eIB4bEfaPbbq5CCl8FV6umHasxdxlYIyvxqBe4rdvsEvwHKEM/YsAlqO5ry9jYSEZmECz+2TPNJxffweIY+4+S6iPjOb+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504073; c=relaxed/simple;
	bh=fw0dWabNAHpVG50PP6u8LJhYKTqtfzfYN79tONhSgqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mf1FMgBxBPxEgJnk6wivspOjWrCJJvPwVajjSye6LBKzSdwkmQm6bI0t+jkXTVIT8HWqQCSLlv2RtqsJh0wMqGBi/BYQXHUoaBTetMe7bq+HiIW45VD5VcGjYhAf3iq2Tlo1l4nLqJoqQMUevU27AK6iIPDeEua3E0ncB8+jz5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iniqu7Ej; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iniqu7Ej"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39149bccb69so1004928f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504069; x=1746108869; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXvNlcutyMXVdoUVJkL/Ta8/a2mdxRJrpPZQuCyEfUg=;
        b=iniqu7Ejgg9Gkr9FS6T0WJ6JdfDwJlneoOMgOPQ77dtwlCDvQrk+rxoQbtpAD1L3kf
         pELKEbhAzrbefyPsdV2F54XI/nf0S+m1B7aprrbTDGOpZ2AcqZYNUaOYMc0mkVqM9WYl
         G80f4pZkAUvO6d40b3mk+1td9TNsXZuvY6LPQuRr3lIb1l2mhZk2ky5eOWVYo3XJ0CmP
         h/DSaYAn5p+QadmF1V1eFkLkvjBoBHzk9QD/WdFKZP7Bxz6QGEpqqefHu/RL8JSzxdby
         3MhjfKi/JIEimxAeD+lPx1/gbn9Q/kg/FK5eQ+PKE1zUvazJC2wInGQngsSj0MkmI7pw
         Vm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504069; x=1746108869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXvNlcutyMXVdoUVJkL/Ta8/a2mdxRJrpPZQuCyEfUg=;
        b=Rn+8jw3cGYBn57wKydcoRjPh6JM+0VNhjOUybF0unYIpCDunjzadul1zaV1hQaBloQ
         MQJHKzki/3VI7F2ahXDiBM9ZqbU/VondknVBQo0VaibkX5gZ82KwDMqJKJMkzRgZCRei
         DN4yXR0xtNh0nUtVr0Wil3eGRki8UsHe+DmVPLrfMe3j6eMF2O3vkYHHwdJwsBAyEd4D
         Ta+rLRCO1JnoHfZcC/EJQgVNfBB+KkHZvnYURx4WLQqzvWoIRpxW2nZCBR62fA+fLr6o
         RiOAg9eqS+fT+E6w3SQOawjFZPPRFmxYZQ+k0t4rJT//xAWIO0K2s2XGY5skT6JYD9sL
         0fFw==
X-Forwarded-Encrypted: i=1; AJvYcCUtDyw1dlQWu2ZJ8+CW/lSczHyeOuaT5qxgZARZpoXDhCYiw3EjPIUqScnWrljTRXWuaWoSxCc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHdO/7rLRKS8IpzcWL5y2aitHpjlF8xQ34erRTXSQOnmYB+es1
	TJTGC60QSK6Hi2HMrG1GYL6rHYC+Bqz0KGVGyxwkjv41y47fmo0i6it792v0l7Y=
X-Gm-Gg: ASbGncuTV0qc/Y7Qn1B3uFB4RM7zSW4ROK7yvupjrvDbFVbbAPPJLLpK7YD+8QAfSoY
	pSH7hIKWLkSu66ex/albTUrvSh3qE6BtJvuQ+NdKWBpnMWOfmEf/7TUqNdenw4US99L9MI2Skto
	y7puw27mZvAwrEpIuTqEFIjos886Ssl2CJU8Apxhpqdg2FYLHy/j80Rj7DqikZgq4LCoybDdRKS
	lDoVPLFgr8daNcIX/KULSEwyqI7a5N8gkNhComSgyjeP5IHMfyQav7AmwSkdEL5kPhvPGiR+9k5
	w0K90dczp03ZXuYr6G8/QcEMiZgkfo9cgE0smnSMoSxLlthnn9vAzwEJi+AX/9qhygUmJnlloAk
	64+bEmcX6ns32QbA8
X-Google-Smtp-Source: AGHT+IH0tCAHy+56/cv4ZEG1Nkj43NDfif06A0s6QNH24+K7YCAgJ/1BfT2MGE/c41oOF+y78aq+Lw==
X-Received: by 2002:a5d:4092:0:b0:39a:c80b:8288 with SMTP id ffacd0b85a97d-3a06cf635f7mr2018268f8f.33.1745504069033;
        Thu, 24 Apr 2025 07:14:29 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:28 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 33/34] KVM: gunyah: Implement irqfd interface
Date: Thu, 24 Apr 2025 15:13:40 +0100
Message-Id: <20250424141341.841734-34-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enables support for injecting interrupts into guest vCPUs via KVM's
irqfd interface. Irqfds are requested from userspace via KVM_IRQFD
ioctl. kvm_arch_irqfd_init() implementation, in Gunyah, then creates
a resource ticket for the irqfd. The userspace must also create a
devicetree node to create a doorbell with the corresponding label.
Later after VM configuration (in gunyah_vm_start()), the resource ticket
will be populated and the irqfd instance will be bound to its
corresponding doorbell (identified with a capability id). When userspace
asserts the irq line, irqfd->set_irq() callback is called to inject an
interrupt into the guest via a hypercall.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 100 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index df922be2429e..23b9128bf5b1 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -29,6 +29,14 @@
 #define WRITE_TAG (1 << 0)
 #define SHARE_TAG (1 << 1)
 
+struct gunyah_irqfd {
+	struct gunyah_vm *ghvm;
+	struct gunyah_resource *ghrsc;
+	struct gunyah_vm_resource_ticket ticket;
+	struct kvm_kernel_irqfd irqfd;
+	bool level;
+};
+
 static int gunyah_vm_start(struct gunyah_vm *ghvm);
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
@@ -852,6 +860,98 @@ static int gunyah_start_paging(struct gunyah_vm *ghvm)
 	return ret;
 }
 
+static bool gunyah_irqfd_populate(struct gunyah_vm_resource_ticket *ticket,
+				  struct gunyah_resource *ghrsc)
+{
+	struct gunyah_irqfd *irqfd =
+		container_of(ticket, struct gunyah_irqfd, ticket);
+	int ret;
+
+	if (irqfd->ghrsc) {
+		pr_warn("irqfd%d already got a Gunyah resource", irqfd->ticket.label);
+		return false;
+	}
+
+	irqfd->ghrsc = ghrsc;
+	if (irqfd->level) {
+		/* Configure the bell to trigger when bit 0 is asserted (see
+		 * irq_wakeup) and for bell to automatically clear bit 0 once
+		 * received by the VM (ack_mask).  need to make sure bit 0 is cleared right away,
+		 * otherwise the line will never be deasserted. Emulating edge
+		 * trigger interrupt does not need to set either mask
+		 * because irq is listed only once per gunyah_hypercall_bell_send
+		 */
+		ret = gunyah_hypercall_bell_set_mask(irqfd->ghrsc->capid, 1, 1);
+		if (ret)
+			pr_warn("irq %d couldn't be set as level triggered."
+				"Might cause IRQ storm if asserted\n",
+				irqfd->ticket.label);
+	}
+
+	return true;
+}
+
+static void gunyah_irqfd_unpopulate(struct gunyah_vm_resource_ticket *ticket,
+				    struct gunyah_resource *ghrsc)
+{
+}
+
+static int gunyah_set_irq(struct kvm_kernel_irqfd *kvm_irqfd)
+{
+	int ret;
+	struct gunyah_irqfd *irqfd =
+		container_of(kvm_irqfd, struct gunyah_irqfd, irqfd);
+
+	if (irqfd->ghrsc) {
+		if (gunyah_hypercall_bell_send(irqfd->ghrsc->capid, 1, NULL)) {
+			pr_err_ratelimited("Failed to inject interrupt %d: %d\n",
+					irqfd->ticket.label, ret);
+			return -1;
+		}
+	} else {
+		pr_err_ratelimited("Premature injection of interrupt\n");
+		return -1;
+	}
+
+	return 1;
+}
+
+struct kvm_kernel_irqfd *kvm_arch_irqfd_alloc(void)
+{
+	struct gunyah_irqfd *irqfd;
+
+	irqfd = kzalloc(sizeof(struct gunyah_irqfd), GFP_KERNEL);
+	if (!irqfd)
+		return NULL;
+
+	return &irqfd->irqfd;
+}
+
+void kvm_arch_irqfd_free(struct kvm_kernel_irqfd *kvm_irqfd)
+{
+	struct gunyah_irqfd *irqfd = container_of(kvm_irqfd, struct gunyah_irqfd, irqfd);
+
+	gunyah_vm_remove_resource_ticket(irqfd->ghvm, &irqfd->ticket);
+	kfree(irqfd);
+}
+
+int kvm_arch_irqfd_init(struct kvm_kernel_irqfd *kvm_irqfd)
+{
+	struct gunyah_vm *ghvm = container_of(kvm_irqfd->kvm, struct gunyah_vm, kvm);
+	struct gunyah_irqfd *irqfd = container_of(kvm_irqfd, struct gunyah_irqfd, irqfd);
+
+	kvm_irqfd->set_irq = gunyah_set_irq;
+
+	irqfd->ghvm = ghvm;
+
+	irqfd->ticket.resource_type = GUNYAH_RESOURCE_TYPE_BELL_TX;
+	irqfd->ticket.label = kvm_irqfd->gsi;
+	irqfd->ticket.populate = gunyah_irqfd_populate;
+	irqfd->ticket.unpopulate = gunyah_irqfd_unpopulate;
+
+	return gunyah_vm_add_resource_ticket(ghvm, &irqfd->ticket);
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
-- 
2.39.5

