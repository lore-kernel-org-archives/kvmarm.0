Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188E051FCC4
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801588; cv=none; b=mY+AcAMWRVozguMBcj+UXZrySOoLSwIj3Q4HurwhnZ3X7RAP150TPFDSaCKgziJtSgxjDVormWadfc4O9kPB/YvtkuWcQU7sgVULiDaCFIxZvYpfCArH2n01gF72dXHt/aR9uggFSLC4D22S/abhguSfaCrE7PXaEqCkSKJjmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801588; c=relaxed/simple;
	bh=ynbSWc5hwfhoV4Dk2YButIF26Cwed7fkSyPCp3V2/0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qp5PKnWq/ElPg3SEtn6ndN6FMYV/l8owJDwPsfT93UQvoU2NqQn+WtE/H02JtrZhjDtbfD0AE+YZ+oFsFYXfX72LahCZv1ASDmNkYaOkFOQYDle0Gpah9/FuFjPiKSxZLGNqgZIK+kRyIwUIK94rhpADBQVpdZSerU7KLNukg+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YoMelIIo; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YoMelIIo"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-482f763db88so2129111f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801584; x=1789406384; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=azXNvPaknVBy0Syf3YnOWO2EVMjwE6S1Z11nRdavFo0=;
        b=YoMelIIoznM2M8+l3prtS+3iaEkhTi5r6dLgjYzKxJwxRdvIcC7I47BZIWs0vbnc3Q
         nSGwZ1PP68NIhI04AsB/knmpOuMnnpMEDZqGfipOo2Aj1GDWDJho65IfcBZyZfl5+N+H
         sYjCE0wx/Ef7Omcfqku6521yEqGSfZ3hNkyqvD94mSmJZO1uV8fT7CQ4BCRatgrz9hxy
         733PwD6jwKyAC8v6YfgVLaoSEQPpstP5kzdFKPJOPp0f80lrK+XaGigzCE0oxVellMEb
         JAvvLRA3ntyY2OAlgarvFBwcXrQifjNHfE5DKZLB/tKq8c6xL4Fws2o1CY/g9TqpA7Ft
         DAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801584; x=1789406384;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=azXNvPaknVBy0Syf3YnOWO2EVMjwE6S1Z11nRdavFo0=;
        b=S5zbKJ4bleX12efs2cURW0tm8Q2xV8ZU7OycMwYqUz3x6AXuGozJuq5he4qP0RXA90
         Sk7W0SbVPIonA/Z+fX5tSM+q3CpJvhlSVNb85UDXs5d0EmdFtzXvvuCHdtsX+cdm5AtD
         wvq8oXyYh6hFL4ip1xKbjcka6W9pWYkbWop+iks8h+yr3bbww/To2FtxpPvAk+ylmXGI
         F2WEwRasYgrH4WMxE1rYOo+CCm+UAHIOlkCLzKbbQx952YctnjSediJOQ9OfMgdbJ9nv
         7HLqq/sk5haYhScvPn/0EgrfBug89lV9TkTyyJ9kW43sBYoJz+MX22WcEiOdBugw/P0Z
         XyEg==
X-Forwarded-Encrypted: i=1; AKwUvBzAg7knAoeLVcGXT7IBfENCgLtW6QymEUOhAGvSuGFwmvvnhsMYPyVh7wdyXWqbqOsLVnD2DQc=@lists.linux.dev
X-Gm-Message-State: AFuF++klbu9gWAV5XhmRWRk9O9JD/BuFPbIvb6VB+6Uz9RDrHpkDZxk3
	Dn8oosKamGlD+KeQyG+yMP9Br4mb6Skb+uBQLanE9JzJpse8U+L17z4Rk35jJMOAOwc3WxIdxu6
	p6P69jTN8DY3sNiN3ae6eof7SiptzzA==
X-Received: from wrwc18.prod.google.com ([2002:a5d:63d2:0:b0:484:3922:d684])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:993:b0:485:847f:fd7d with SMTP id ffacd0b85a97d-485872d5061mr24058104f8f.24.1788801583354;
 Mon, 07 Sep 2026 10:19:43 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:27 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-6-sebastianene@google.com>
Subject: [PATCH v9 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification GET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments sent from the host
driver.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 923f32caa04b..e11fb06df63d 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -695,7 +695,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -954,6 +953,27 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
+			     struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags & GENMASK(31, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res = {0};
@@ -1025,6 +1045,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.979.g7e5102b832-goog

