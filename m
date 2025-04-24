Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38096296D01
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504074; cv=none; b=FZS5vluGDueGf/FZvAfxgYKWJ0RmR1D4fRRjGG7PGICqmjxNub0rsp2TzkTMYk5QAB9+RHKj0DLXA7AKkzfO3NF9BBRqu79w24LfXessh6U3pqWGjcF4ljGLRzEALiYrVXbrELW2+uRJoOEAOVDtx+M7JqqJxvsgu6uV9KVvJKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504074; c=relaxed/simple;
	bh=N53i4bFiZ0PwECXO+3O9PEZg7KbhghQli4Mhy0f7goE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KbEsX9wB7s3VmUoKVl/JES/4gLp2OoO1+y3xK0ZNCpupiIc4SAUc/XeF8ch8SpCwtsLNJ2qmmebnShHPEHI2iOWMvw9M1qKY8qlwbGQbBSHux8FwV3MfTOoLKt8Io6HNQ/iIUu4ML9iW9UDeJgLkf1zQTLSSdV4t2CcHZ4xQzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q7MjSFO8; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q7MjSFO8"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ee651e419so654402f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504070; x=1746108870; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3i+gLyWtr6XPiioNUTryX7U5TAHJs0bj5+QGltLz/R0=;
        b=Q7MjSFO8gm6SsY2esq2TLK+bnaJKI2jwkXdq1arCtMh3Cy8VdiewpUCIJqEqdc4IWC
         U89pP9pyAwazs6p3gb1d/pbGy7loqYPXfatmbCQ+UpTlpMbUIta2exGbHIkiT+NoDLy1
         khTSCVV6gOKG8KmCd8Sovvrmc1m4xywxfJJ0uJmVx8UxJzSm68qhKYnkWSaecf6YCxqB
         TS9HGqIH2K9v9ybi/uUL5131upLZpzP/oC/pHxKrMFaJ8pDX5YyTsre1nvsyUYMKttze
         89m2JNwVWA/MzeUmtjdvPM1Mv4AtUr624ryDO/sSzObM4USOU9tzjjUpmJEGjiFnw8S1
         jpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504070; x=1746108870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3i+gLyWtr6XPiioNUTryX7U5TAHJs0bj5+QGltLz/R0=;
        b=G9QHpBZDPHbFJY61DnQxR6iqiKmOzAYYplgRCofoMn6S6NKiYV56n9x4/Ulv3r5+8d
         aP9mfnLsnAudevfO18k4wcRS6bTa/nHD70Ajc/AAXzcK24WS13myQEDelHUbScD4fVld
         zndG2jXaEu9MsmRKKAiXoR/8CGskihG/obNVyEBBA6gIYMjXVMA6oLP0yI1rHB7tByfI
         PEbWvFjuFGmCeoXjsJxxXBX5rech0V+zpTfYSgu5RfC1qE5KYnqXA7g8pXGn2kEcYSbP
         lx2/6FQC4XC5hbXq96LBCOelu3dT2WV+l0c1MsX3bba15ttB5l9TW8eqmd5DmdlgBB4/
         8fNg==
X-Forwarded-Encrypted: i=1; AJvYcCVTOP+S5s+j6yW14D8Pf05KGgXBzMp4YIBpQ33krbMGAood/7EmIgI1ubi1dWvE90KY7/T0P80=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeiF8yZQX80Q6MV9nLPzBICBybGSTe4l61oZ7O6ovyRhlYmjh7
	cAjOfjTC3lsZEWADTXVdmqr85Ri1S6yAy2vANqNIc7ihIGc0DzFHyb2ki6X6u3Q=
X-Gm-Gg: ASbGnctMR3pTonELYxSH0M0qQefYuQu7x/W0NYAurbR292xNCjuojnJM3ygDc8Ye4lb
	rphWEGQh1tFaL3kBSxUz6x+vFRcrneDGFvTt3PcrCWzX71Jv4NGlZkp6taV6ZbD5/EWSvnfc/wr
	t+CdjWF4WEGXlPCz6xeDADdNaGuBdlnazlQucyL5RE/JFZ0n+JZ9mukVjmXo2vEsdKPZ3Qc/ZaC
	cEpqhZFrlrQXU46xsxAvP316+lCV5BeLtdlsFEb1QLwWVcqglwT3gVt0oB+eFNsysJ6NYEO3OHu
	Hc/Ep1WNYDci7VcN7On22tR7ww1XV1QxXFENTi7X//ENoIJzYIeSrhDLKo/LzLqfZerUbpOgtJL
	10huPCZaR/oimxkts
X-Google-Smtp-Source: AGHT+IFOk65S5hPF/j31g7Of/aiN0lBptA3ImD/zObUzEDJUJE+zLunCG1fROxNheO7aYYEMJ9HW0A==
X-Received: by 2002:a5d:5f87:0:b0:38d:b325:471f with SMTP id ffacd0b85a97d-3a06cf5ac50mr2557177f8f.15.1745504070317;
        Thu, 24 Apr 2025 07:14:30 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:29 -0700 (PDT)
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
Subject: [RFC PATCH 34/34] KVM: gunyah: enable KVM for Gunyah
Date: Thu, 24 Apr 2025 15:13:41 +0100
Message-Id: <20250424141341.841734-35-karim.manaouil@linaro.org>
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

Enable KVM to act as the interface to create and manage Qualcomm's
Gunyah-based virtual machines [1].

[1] https://www.qualcomm.com/developer/blog/2024/08/learn-about-gunyah--qualcomm-s-open-source--lightweight-hypervis

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c      | 12 ++++++++++++
 drivers/virt/gunyah/gunyah.c |  3 +++
 include/linux/gunyah.h       |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 23b9128bf5b1..91f0260ef3f5 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -2071,3 +2071,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 	kfree(ghvm);
 }
+
+int kvm_gunyah_init(void)
+{
+	int err;
+
+	err = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gunyah_init);
diff --git a/drivers/virt/gunyah/gunyah.c b/drivers/virt/gunyah/gunyah.c
index 3e795e3ba881..629c812fbac0 100644
--- a/drivers/virt/gunyah/gunyah.c
+++ b/drivers/virt/gunyah/gunyah.c
@@ -28,6 +28,9 @@ static int gunyah_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (!kvm_gunyah_init())
+		pr_info("KVM for Gunyah is available!\n");
+
 	return devm_of_platform_populate(&pdev->dev);
 }
 
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 26fdfa3174da..7d43449c4547 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -421,4 +421,5 @@ enum gunyah_error
 gunyah_hypercall_vcpu_run(u64 capid, unsigned long *resume_data,
 			  struct gunyah_hypercall_vcpu_run_resp *resp);
 
+int kvm_gunyah_init(void);
 #endif
-- 
2.39.5

