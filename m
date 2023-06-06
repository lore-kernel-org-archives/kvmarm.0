Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9DA468F
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686047857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4KMnL3g6L7UfqVOiJLSwGrD+RRorX7NHeH1AseOGRLI=;
	b=hO1ue1XeQ7zx9yU8/jxrnHZFh1O5xeYxGacmokdulsDZfrkrLjW0UxJeWQPLNR0QY5FMem
	PnkIEFn+7O33WwKN53vFzx8bWUR6jlYRYyVCbhXfgT6RFIC6y45Gu8iEstrkYPgSCLwdXW
	IHcxr4GCQE0bbc7Z1w2VeDKOBiTGXbc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-mtU_e6atPvaB16omegftLQ-1; Tue, 06 Jun 2023 06:37:35 -0400
X-MC-Unique: mtU_e6atPvaB16omegftLQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-62856d3d316so62130016d6.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 03:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686047855; x=1688639855;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4KMnL3g6L7UfqVOiJLSwGrD+RRorX7NHeH1AseOGRLI=;
        b=FL0QtMN2A9hg6Pso9uQPRR63dSg20EsAZuMkG4n2d60T4Y1ytNzjmrXNGVTclYCD89
         cp1LJ6iajjSX+dW3U53WhyUAokLvGzJwimyyW5nmThVecCvGstPZ99zKyBSQ9j/P2Mgo
         qcs0aiFWtPaqHTren5R6yXl9liNWkrFOFGK0pJumWNfwpoVWK6A5IH4N06ZbzgUEvCri
         inV9nRNO+4TMknGs9qyNTcBYEpofwf9bLGFkDAeAxr+Jud/j0fwD9hNXlD44zed0dBJj
         VLT6MT8iPatmyzVtualPfqsGoutV7T6TLlzx797WoJabwpv7rcmiv6M5FIfO2CZahdmW
         SFRA==
X-Gm-Message-State: AC+VfDwYb1G3DGB5P2GPwFkcL5dffMpeCUWaWZXqz3br1+9YHNiFFrYP
	jwE2ouw4iVjbJts4W1g0AvEaLTLgtYs5SIwGF5r3611e4VOLOkzR4PGAJ8UmKInde7CHLjU4ub6
	vrHX82YKjnZ30D96Yz61rR9+FclIuhMYCeEIB6PsJFIPU7nj5l9JwtiBeemy2QCRlTk+HRXcxlw
	==
X-Received: by 2002:a05:6214:ccd:b0:628:474b:aae3 with SMTP id 13-20020a0562140ccd00b00628474baae3mr2005214qvx.56.1686047855089;
        Tue, 06 Jun 2023 03:37:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Fnoh5EPJQcdGxF8wYBBRgI2/kwJhla0tSeyQUZqahEbjELaHGgoKcsfvZVCwLchTjXGiBRw==
X-Received: by 2002:a05:6214:ccd:b0:628:474b:aae3 with SMTP id 13-20020a0562140ccd00b00628474baae3mr2005200qvx.56.1686047854769;
        Tue, 06 Jun 2023 03:37:34 -0700 (PDT)
Received: from rh (p200300c93f2d6400aa29c1eaa0912abc.dip0.t-ipconnect.de. [2003:c9:3f2d:6400:aa29:c1ea:a091:2abc])
        by smtp.gmail.com with ESMTPSA id ep12-20020a05621418ec00b0061b731bf3c2sm5244560qvb.80.2023.06.06.03.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:37:34 -0700 (PDT)
Date: Tue, 6 Jun 2023 12:37:30 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
Message-ID: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Commit 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for
default PMU") introduced a smp_processor_id() call in preemtible context:

[70506.110187] BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-aar/3078242
[70506.119077] caller is debug_smp_processor_id+0x20/0x30
[70506.124229] CPU: 129 PID: 3078242 Comm: qemu-system-aar Tainted: G        W          6.4.0-rc5 #25
[70506.133176] Hardware name: GIGABYTE R181-T92-00/MT91-FS4-00, BIOS F34 08/13/2020
[70506.140559] Call trace:
[70506.142993]  dump_backtrace+0xa4/0x130
[70506.146737]  show_stack+0x20/0x38
[70506.150040]  dump_stack_lvl+0x48/0x60
[70506.153704]  dump_stack+0x18/0x28
[70506.157007]  check_preemption_disabled+0xe4/0x108
[70506.161701]  debug_smp_processor_id+0x20/0x30
[70506.166046]  kvm_arm_pmu_v3_set_attr+0x460/0x628
[70506.170662]  kvm_arm_vcpu_arch_set_attr+0x88/0xd8
[70506.175363]  kvm_arch_vcpu_ioctl+0x258/0x4a8
[70506.179632]  kvm_vcpu_ioctl+0x32c/0x6b8
[70506.183465]  __arm64_sys_ioctl+0xb4/0x100
[70506.187467]  invoke_syscall+0x78/0x108
[70506.191205]  el0_svc_common.constprop.0+0x4c/0x100
[70506.195984]  do_el0_svc+0x34/0x50
[70506.199287]  el0_svc+0x34/0x108
[70506.202416]  el0t_64_sync_handler+0xf4/0x120
[70506.206674]  el0t_64_sync+0x194/0x198

Just disable preemption for this section.

Fixes: 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for default PMU")
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
  arch/arm64/kvm/pmu-emul.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..f9e4e4334875 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -700,6 +700,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)

  	mutex_lock(&arm_pmus_lock);

+	preempt_disable();
  	cpu = smp_processor_id();
  	list_for_each_entry(entry, &arm_pmus, entry) {
  		tmp = entry->arm_pmu;
@@ -709,7 +710,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
  			break;
  		}
  	}
-
+	preempt_enable();
  	mutex_unlock(&arm_pmus_lock);

  	return pmu;
-- 
2.40.1

