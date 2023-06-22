Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85CF174FA
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 12:49:27 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4f871c93a5fso6399559e87.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687438165; x=1690030165;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jSOgXdNBJl3+UNEs6gBjr4XRj57RQrK+CFFNorRFoi4=;
        b=o0hbOlB9k3j39/QBArVEgtk/EUXv3A/1aXxT58v6Xzr6r6z9vIJnMQiF65ZtksCspA
         yRGsZJamWZui5ahzLPR4cDkgHLFgqTTYkK2KX5a1O1ZtLBxWEJSg2pYDLaTtgebj2W/d
         e8MZyjTE3eL2Su0YfStWfcC9gnuZwraPDPxMkDybeW+54PlATz/B2fBOD/iRXsEYYuOF
         EQJ39uWrI594OOyqLYIFFNksZ5wi2mHksePXR7ktqeU1M6RwwZWMzlmUZCtoTVT9CFGt
         ZCd6DyWB/QJ2nimYWZe4fxzulBvhsbtOrcPPQHRUILMs4p20WVl2BPFt3kqVwO3R40CH
         k9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687438165; x=1690030165;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jSOgXdNBJl3+UNEs6gBjr4XRj57RQrK+CFFNorRFoi4=;
        b=GmfGlQXKsYk53veR/EIS8q57oM/ylEGWhlW2Pha3mx4BNoMlfhHyYxiqLPn5nH5XmH
         G7o0zSMlXioxKgXzrnN2h1Ghmz0l5tk+ayMIujH8WHcX5i4R2eAHjpm4jd0JfSs0nuxT
         fLdmsH6cgAe+P4sj21OHWsotM5Fc96oMzLfMmUf92YLAqi7eTDyIcj4q/Wp523hbtFHR
         MApwxnYo+adpHgGMIIEUtzmOIqA8exEzaiYDKJ/ZoABFTfjzL/iWqxx6COTq/ikzosM2
         Ua7siSI+1sK+K37UvBwxvN7orcYHtZpZwo3+/1iU0eeXF3Un2lggiY7f20tGcr54f2za
         jPJw==
X-Gm-Message-State: AC+VfDxbYEdK8GPYB4gW8HQBxLUgl3W/2sIjnlrYy88WHPe3GfT4zaW1
	X3E/NEOWvp/X5FbUdhiw3yuVsQ==
X-Google-Smtp-Source: ACHHUZ5/DLiXkOof/VszBGnlxq2aMwav2rPqDlALqhvgKlmKHxY1xo6wOjU+2990uupKY3AkkQoUvA==
X-Received: by 2002:a19:e059:0:b0:4f8:67aa:4f03 with SMTP id g25-20020a19e059000000b004f867aa4f03mr8409907lfj.1.1687438165649;
        Thu, 22 Jun 2023 05:49:25 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y20-20020a7bcd94000000b003f60e143d38sm7645301wmj.11.2023.06.22.05.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 05:49:24 -0700 (PDT)
Date: Thu, 22 Jun 2023 15:49:18 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev
Subject: [bug report] KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF
Message-ID: <50fed6cc-5772-4bb2-b72a-bc7e4f9e93d2@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Oliver Upton,

The patch e3c1c0cae31e: "KVM: arm64: Relax invariance of
KVM_ARM_VCPU_POWER_OFF" from Jun 9, 2023, leads to the following
Smatch static checker warning:

	arch/arm64/kvm/arm.c:1283 kvm_arch_vcpu_ioctl_vcpu_init()
	warn: bitwise AND condition is false here

arch/arm64/kvm/arm.c
    1272 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
    1273                                          struct kvm_vcpu_init *init)
    1274 {
    1275         bool power_off = false;
    1276         int ret;
    1277 
    1278         /*
    1279          * Treat the power-off vCPU feature as ephemeral. Clear the bit to avoid
    1280          * reflecting it in the finalized feature set, thus limiting its scope
    1281          * to a single KVM_ARM_VCPU_INIT call.
    1282          */
--> 1283         if (init->features[0] & KVM_ARM_VCPU_POWER_OFF) {

Prior to this commit KVM_ARM_VCPU_POWER_OFF was a bit number.  I think
it still should be.  As in:

#define KVM_ARM_VCPU_POWER_OFF BIT(0)

    1284                 init->features[0] &= ~KVM_ARM_VCPU_POWER_OFF;
    1285                 power_off = true;
    1286         }
    1287 
    1288         ret = kvm_vcpu_set_target(vcpu, init);
    1289         if (ret)
    1290                 return ret;
    1291 

regards,
dan carpenter
