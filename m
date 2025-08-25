Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D930E288522
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152391; cv=none; b=rdf1S21ej2p9dpX1EXQO/Kk6WjLngKxp9/bBRn1BIQIsYjqpufE1MM7Eylc17n51akn5G3mO2t47ipi3A1YgWhLH9cuYhx1sUSqGlqp8IDsn4CoEva4yHp7Oec1utTDLOo++N8S38Mz/AD16+i3/vx8AOmprhh4r+D7PeCRu7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152391; c=relaxed/simple;
	bh=CPxGdk0WNt19VUixP2aZz/PEan9gfYpnqsgV+WcH6LI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jwtXc7DT4rVRsBwL0mvLt3T5pWjxfFBw6fP4wkJJfLXYH1qEMbnrd0C2WWQz4DJNYBzjYpZjVCQF24GRzKWRlUdCVpopHxVow6g/UGPCUNzzxUewnrozyi3x6iVdNhAcCQAdsonM10OLZDFBemSQRJM8/d6c89NH0heZZL9jSAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CA2BHukP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CA2BHukP"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47253319b8so3580414a12.3
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 13:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756152389; x=1756757189; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+oyHFbNT6msf6glrd5KFIdZcOF0+oR5scj5fBrCtJpc=;
        b=CA2BHukPaZACMO/TvovuwN4Uxl226tQBLeHgkYMXNigYKsO/BH0tvb1Hd+88AgHLaH
         NhmoZ0NdXiyGJzWQX5YvrbJGLveqtKgBkP4S8eQMPD/1yDoEQUCLrZTGK8rTd5eSZPPa
         pwh1gxM7XX17SjmEuBsSKP6bln3oyhNOneZtbsdNu9citofBeQU4AadIZGo0riR2diZs
         TyN1pJ6inxAKQCTQUfdXkhgBwTmsuxCbkm/j7QGprAxoeC1+EmETXDEA1rYv85mAPqAY
         R09VjF7mxo9TjLdy1iKP4n3D1nSaxcRmShtKODV1yzwVOcI2k9fPUYwbWphKudhQIEDo
         1TMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152389; x=1756757189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oyHFbNT6msf6glrd5KFIdZcOF0+oR5scj5fBrCtJpc=;
        b=BOd7+b/WgB/FP1jclQWzcgB+hghiLprDUxyzIICtwBFATuIJHPN+fSg/CWH/nchV+K
         IEPYSpUfuc01oP3bp8WI9JuDe++Rv8P6fM19aiMkvnui+8xdOhR0196E4/c64fKvVGIE
         RDlEdfWa88VJgg4/upmU3lunukqYPX/zSlWo+3j3EQUensGRenpxPhOWhJRw76+fsKJe
         BdA3Xm7adhMw/bk6pYv+aLxBMCiFf7MNR2i4DT5mjI3zXIdvyu+uW2JXDzpE/ptlMQvQ
         8SvBiJyffF7o+nPSIGBRPXeIldE78KEPOb6WnZRProcC8kezMIBX52HKNO1o/Nhzjd+e
         367g==
X-Forwarded-Encrypted: i=1; AJvYcCVM1VFomYgqQoAKCZiMsSTNNCmCoeFodkgjESynCJa2mAHLD6WvyRXOlOALGaJmZ5NfuIGRwbE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyV8WRjPnuGUpmrhtZBVCHqvE10tsSHr3VA7IClCIbY0XAs4TPp
	XaflsMZY1FplhgodABUnPL9MiY1tdG23IH7BRjkWqDbnydCIZg29sJ3qGQIk5An1K6bUbhM1zkF
	7XQvLfw==
X-Google-Smtp-Source: AGHT+IHf2Zj5lnIbPMIr1AZKuHUHSE22v55RmD47MKsgM79RfmKmA7vJz/pJwEChfBNBSyo/bobLCf+GttQ=
X-Received: from pjbpq16.prod.google.com ([2002:a17:90b:3d90:b0:325:7fbe:1c64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0f:b0:243:78a:8289
 with SMTP id adf61e73a8af0-24340def606mr21242988637.48.1756152389107; Mon, 25
 Aug 2025 13:06:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 13:06:19 -0700
In-Reply-To: <20250825200622.3759571-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825200622.3759571-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250825200622.3759571-3-seanjc@google.com>
Subject: [PATCH 2/5] Drivers: hv: Handle NEED_RESCHED_LAZY before transferring
 to guest
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Check for NEED_RESCHED_LAZY, not just NEED_RESCHED, prior to transferring
control to a guest.  Failure to check for lazy resched can unnecessarily
delay rescheduling until the next tick when using a lazy preemption model.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
index 1acc47c4be0d..b953b5e21110 100644
--- a/drivers/hv/mshv_common.c
+++ b/drivers/hv/mshv_common.c
@@ -151,7 +151,7 @@ static int __mshv_do_pre_guest_mode_work(ulong th_flags)
 	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		return -EINTR;
 
-	if (th_flags & _TIF_NEED_RESCHED)
+	if (th_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY))
 		schedule();
 
 	if (th_flags & _TIF_NOTIFY_RESUME)
@@ -163,7 +163,8 @@ static int __mshv_do_pre_guest_mode_work(ulong th_flags)
 int mshv_do_pre_guest_mode_work(void)
 {
 	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
-				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
+				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
+				 _TIF_NOTIFY_RESUME;
 	ulong th_flags;
 
 	th_flags = read_thread_flags();
-- 
2.51.0.261.g7ce5a0a67e-goog

