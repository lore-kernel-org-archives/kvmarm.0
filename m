Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CBC47D447
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327218; cv=none; b=JDs1m395X+lQvfTPsDGBGlROuzT08DNAkUd3XjBaW89I+yFUcvnuf9INxI+99DyxbYQzv7jWYYBeNHE3GHfAOs/VpxHqcfFbZGFbhSX6QtUwTctPS+P8fkQxvm4QMjMR4rfMo00UnTu3N8f1e4MY+5+6suoGNpNKBHSsjWozv5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327218; c=relaxed/simple;
	bh=lgOplRN0tHytyivKvtFZJvWXXvEfmoCMeCw067F/2/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E7e7jQ5YKh762/E0u+UtpPrvvp36QagO8IvRgg8A5RB6P/LbK3DC7y0QSQ3WU+jYVLwDrsKi1fNa95fgM3DOwuy6RuUYJw3CkfX0MydGCHolhyo2teZMXRRI/P10in9MFsvsOLh08db2wfH3q0c1ax++xhdlmp0u8xM3DBWt1X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BRJcrPdc; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BRJcrPdc"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15cec1ccb6so98827066b.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327215; x=1785932015; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7K7ZYeh7lQNhDrmBvEZsQ9iIG9GUxmgOrfHofOc6bGs=;
        b=BRJcrPdcDx617qtqpLRotJ9neTtdKB1jXeB07b6XK6/WjDMML0t+2SjBjigIRy8/FT
         i6waaQDYHPGwW4VeSfTLUI6bCwtQuln8UiQrh+iOCiqC0XkoutTOYKclk86iknIJovFY
         axODjOIG+tyuhI97cG0rpgZW6d5Xqzc/9X/5M3jImBqNG+XvU1CKfspnQkWTImG4mCkC
         rQ31tCbxBe6QGcQN1McAOSVcynf7BhLgYtutQotPOUXVZq5ujtH1l/LNH49FhxLDholC
         7ZK4rl09wYCk5gdw/YHtSFKu+nwNlbv6Im8vsU8wGKK21Evo9lPKnBO5GJZ2MBTc6/bh
         gp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327215; x=1785932015;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7K7ZYeh7lQNhDrmBvEZsQ9iIG9GUxmgOrfHofOc6bGs=;
        b=NKUKqqkl/qKd7qsSVzheALq1TcRDVYFOO5367uR1V1sy5EjrBpZE0zqlBSuKnVmPUw
         nQo60AuvVvMt3rOYQcl8ihis5jo+oFm15b2Whb72IsFKOdS79PkOkAuSussnjmvtTZ1D
         zjFXM5/MXQYNURMCD7sVG1N8jfNZGDvwo9Oh+Kqn6JtwHWG3I3REV3amcY+ZtnwzFlwD
         1Hn+c7xKXU9LCuR6vEU8eovEGGG7fSJLM403NJSiJmLoX54d7h8DAiSeE+Cq6UWcpWoZ
         O937ELgcTBPpPw0AukbSEXCdFePu50x4SdzcFRPpMFzHFHwxhLmPFzF3l76uh586DyNx
         wO+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpHr08R5lbFNjgarXjEycDXity69outv3N81+v82U3Aze6dKY9qd3jXPctqexf0Kd26yjWSANE=@lists.linux.dev
X-Gm-Message-State: AOJu0YywMGwIdZacU+MDcRE+1FxL527uXkwewTZvq1pXk3BmNJS0zOfp
	LJ325d3oUDTjTp2bhRSR/zM/ocgwaV43mVjCbW69V9Dq86Ppxe13gCNto8yWK7bkXWsv7wrgSlh
	D+Vm5OQi2AqGEX4ZIb5QpWVU1FwyZLg==
X-Received: from ejchk15.prod.google.com ([2002:a17:907:3ccf:b0:c12:5229:7355])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:960c:b0:c1c:2ee9:5e6d with SMTP id a640c23a62f3a-c1f71d7baf9mr364618066b.17.1785327214844;
 Wed, 29 Jul 2026 05:13:34 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:02 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-4-sebastianene@google.com>
Subject: [PATCH v8 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification bind call and forward the
message to Trustzone.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index ecc13b795f2c..331d9d0d8287 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,8 @@
  */
 #define HOST_FFA_ID	0
 
+#define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
  * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
@@ -676,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -875,6 +876,27 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt)
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
+	if (flags > 1) {
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
 	struct arm_smccc_1_2_regs res;
@@ -937,6 +959,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.487.gaf234c4eb3-goog

