Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEA9C48BCD
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDC286134F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDC286134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4520D407B0;
	Tue,  8 Jun 2021 11:54:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sC8zDVSjV1Oh; Tue,  8 Jun 2021 11:54:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A046040839;
	Tue,  8 Jun 2021 11:54:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A2840569
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XKoewma-KHTn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 11:54:01 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAAE64029F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:01 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 t4-20020a1c77040000b029019d22d84ebdso2303917wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 08:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=C1jCjSpZgNu1sKbBk9Z8ZrCdwYEpbza43XiihxyO/yE=;
 b=YVCJA0HAF6zcoQljEQXQ/+8Srt82oR65IyobeNyeO5y/m18Qqi4RIsm9oHDlODF9lS
 zu431MizjTDk9b2k3KaWWZoMvurqIXeQ0yR7fLtsexQHacAro307b4uZxXhKi/IArmsq
 wTVrqQD/MbY5QxGYp0Fut2zcaGFZ7CSTo02UvhWH+/ycUqxdTXL5VV1Hu78y+peQagbJ
 R5JulGFyoqhJYf09regXQGYwJev0/OSPbKIWBlJ3anSzPJ8SKdvGWB/qkgJeyXmF6LBt
 iNWz/38JdJLNRutIJ+qJE6hcE6aTVlRun55KTHvLG8pyT1add9uAtshT44k/Yt635hEU
 9q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=C1jCjSpZgNu1sKbBk9Z8ZrCdwYEpbza43XiihxyO/yE=;
 b=UB2QmfdNGRZeTPDbuK+bhdQpaV5N65kz0cUMSUsDbHzcUl29jwdPEJPyTYdn9H4uCI
 xvMaXL+GGLFev7xI1Iqhi1d3Y/1Dp5+tClYtgItqwGlnWZLbiVXictIuGdMTaB/9RNfe
 cu0Ah1sC92jfcX5kONkGEVKtWwt4epLB5zN72lL5mzBSDBEa5zPIhAliNlSbDyEbVdUo
 dX9XtF1eTFo5zoe3juMYQokiNyTVlrWk/4awksY143iWc+0nmwqcGNlDORdeOG71UdoK
 kpywyitRmkwHtrLoErhboumB4lMHAALxQNFRMsc2gjjOJF2M53hSZiaBxUebypR/3IGX
 agAQ==
X-Gm-Message-State: AOAM533JSls7P7rQBT2r1jxQj3vJM/3A6ankAi5F3KNKZO66+BxxLq2I
 sK5PZRFohBZh83Q5CFuy2etGYQ==
X-Google-Smtp-Source: ABdhPJzTKoQW6pZDrNtOKklfr6CHm5YnfNTU7QG7RonorQflw6aGjQRnHqaXJN0uACO8uwvZsD+KAw==
X-Received: by 2002:a1c:cc17:: with SMTP id h23mr22321567wmb.129.1623167640560; 
 Tue, 08 Jun 2021 08:54:00 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch.
 [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.53.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Jun 2021 08:53:59 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org
Subject: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Date: Tue,  8 Jun 2021 17:48:01 +0200
Message-Id: <20210608154805.216869-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, salil.mehta@huawei.com,
 lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, corbet@lwn.net,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
 jonathan.cameron@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Allow userspace to request handling PSCI calls from guests. Our goal is
to enable a vCPU hot-add solution for Arm where the VMM presents
possible resources to the guest at boot, and controls which vCPUs can be
brought up by allowing or denying PSCI CPU_ON calls. Passing HVC and
PSCI to userspace has been discussed on the list in the context of vCPU
hot-add [1,2] but it can also be useful for implementing other SMCCC and
vendor hypercalls [3,4,5].

Patches 1-3 allow userspace to request WFI to be executed in KVM. That
way the VMM can easily implement the PSCI CPU_SUSPEND function, which is
mandatory from PSCI v0.2 onwards (even if it doesn't have a more useful
implementation than WFI, natively available to the guest).

Patch 4 lets userspace request any HVC that isn't handled by KVM, and
patch 5 lets userspace request PSCI calls, disabling in-kernel PSCI
handling.

I'm focusing on the PSCI bits, but a complete prototype of vCPU hot-add
for arm64 on Linux and QEMU, most of it from Salil and James, is
available at [6].

[1] https://lore.kernel.org/kvmarm/82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20200625133757.22332-1-salil.mehta@huawei.com/
    (Followed by KVM forum and Linaro Open discussions)
[3] https://lore.kernel.org/linux-arm-kernel/f56cf420-affc-35f0-2355-801a924b8a35@arm.com/
[4] https://lore.kernel.org/kvm/bf7e83f1-c58e-8d65-edd0-d08f27b8b766@arm.com/
[5] https://lore.kernel.org/kvm/1569338454-26202-2-git-send-email-guoheyi@huawei.com/
[6] https://jpbrucker.net/git/linux/log/?h=cpuhp/devel
    https://jpbrucker.net/git/qemu/log/?h=cpuhp/devel    

Jean-Philippe Brucker (5):
  KVM: arm64: Replace power_off with mp_state in struct kvm_vcpu_arch
  KVM: arm64: Move WFI execution to check_vcpu_requests()
  KVM: arm64: Allow userspace to request WFI
  KVM: arm64: Pass hypercalls to userspace
  KVM: arm64: Pass PSCI calls to userspace

 Documentation/virt/kvm/api.rst      | 46 +++++++++++++++----
 Documentation/virt/kvm/arm/psci.rst |  1 +
 arch/arm64/include/asm/kvm_host.h   | 10 +++-
 include/kvm/arm_hypercalls.h        |  1 +
 include/kvm/arm_psci.h              |  4 ++
 include/uapi/linux/kvm.h            |  3 ++
 arch/arm64/kvm/arm.c                | 71 +++++++++++++++++++++--------
 arch/arm64/kvm/handle_exit.c        |  3 +-
 arch/arm64/kvm/hypercalls.c         | 28 +++++++++++-
 arch/arm64/kvm/psci.c               | 69 ++++++++++++++--------------
 10 files changed, 170 insertions(+), 66 deletions(-)

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
