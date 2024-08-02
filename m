Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070C7CF33
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 22:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638464; cv=none; b=Tmo6+61dCUU5Wd9zfL0fUhnXxeGdy7lSlM8bUrgIY02qPtv+RJ+ME7VzmdIviyv/y2V2MZ72KH6c1SUeDKLltRDLZkwmLE5R6DVPM7/i9Zf7TQ73O6SWW1duxGpocyBfIMtPJoCGfaCu9fEyUrXrnbDTdYV57Qu0JMthEU8+iFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638464; c=relaxed/simple;
	bh=+8PWqUn5v8ELFuwRLcfeynpHGo4ajB+2U+KO7lA8yMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ILcmlBC6vyWRnIVpNYwTyFEXAeq/fcKIkrrAq8/LF+TDbKXk/ljg4wgEAXm6su0G1ivOoAzMnh3wUARTdNVVLHwoIMBal59KtZJemlsxWvNx9BpsxLWObqSXFQ2gPeao4b/ZC6gs0CmIpQ91CaEm2W/ri/TW12jVR/fpty47wHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iV4aEAnI; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iV4aEAnI"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b6584bbdcso12612182276.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 15:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638462; x=1723243262; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wQg/YvoMgl7FyNj9U0nitSnR849bmsnUb2Q2PwwvwGA=;
        b=iV4aEAnI/zf3D7S6LnYpw2VctzFJLPnO7z1AjTHnUklcmiOQzTMzKkTI+VxVT3aK+e
         zDaBF+ijup57hYnafiFUUWQNLCgqmylf1TjsF+gtDAxSOEGaEEEONsSoXjwdp7AsO+VJ
         A7mbv+LK+P7MeDU9UniyQ8mxnw9qA8KLLp39LHZ8x60NHID45aYsl+3P9/BXm3fhf/oD
         XHGN6hdFFLf38i7vF6EBknwfu3cUka+7viOQHkdI2DTnkgAUuA/uZ5aTu/r5TMxYejbK
         Y12LS3wENQE6CXuEagvHG8kC5838K6BUzsLh4xh35njjG2SijCk59MY4QRJllqldKvt4
         BK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638462; x=1723243262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQg/YvoMgl7FyNj9U0nitSnR849bmsnUb2Q2PwwvwGA=;
        b=gi/uS4SyiR5F5Y9nK4k2ZK0TZqpcs4QEnOrGJv+lhyPEZZ7BqCOmI8hIXG3HQprLEY
         AgsMjPosLP+FNE5FPwDyk9V5JWZsQ8hmc21q57IVTaoMk+6/Olr5HAE/L9oLCT/bdQC5
         B7L33XDkXlIbXdxrPcMxcdg5TXRzfXDF8ebNgK5keD4DeR2gd/ljaT9xTQ5kdUOgTADD
         X7oIESBkBotq9YwyEGkDI8Q7xoGCqVyJJAj4yIVpi/FTaKG+akjK10c1emcB2Wd5P2hP
         47a6kH/4EMG2drMHlEgiJSiCxhQ4xHZlnSTVbHeLRCOKYotqhPsva/cXnL5x6wgR5Dao
         gZwg==
X-Forwarded-Encrypted: i=1; AJvYcCX0gMJIG04JSp8ZOlwRcnjinFSUDPlbfLk6gvzoFOn03LhXbyoxUz73hJwO3S2dyP8h/aRqhAxIJyOnosaBQPC2t5riImcH
X-Gm-Message-State: AOJu0Yw19enfyq1qwvliFB+BiRmBajmShj2Gmg5avBVgAxvN0yg1pqDV
	N5YkuBJFBbtQ+lVfk443USCmMZ+rbiitu5pBu1Ct3oXSyf8WXBVb6vcFFxACTckyZv0EtfGXbOG
	HQaPZrNt6yQ==
X-Google-Smtp-Source: AGHT+IGtFaFx4zh5naUYBzERvzjQFXAsvrg5mgn76ZrbuxK1hvekubdwutq95TgJoPA0V0wp7mG5L6tjyEmn4g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:100c:b0:e0b:4dd5:3995 with SMTP
 id 3f1490d57ef6-e0bde4abb59mr7845276.7.1722638461690; Fri, 02 Aug 2024
 15:41:01 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:29 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-2-amoorthy@google.com>
Subject: [PATCH 1/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault
 handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a memory fault exit
when this happens, which at the very least eases debugging and might
also let userspace decide on/take some specific action other than
crashing the VM.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..c22c807696ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3264,6 +3264,7 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 	return -EFAULT;
 }
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog

