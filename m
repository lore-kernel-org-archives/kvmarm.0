Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0717E1CAA79
	for <kvmarm@lists.linux.dev>; Tue, 21 Oct 2025 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761007807; cv=none; b=pOwW1vbmLk0uNEIwbB9LK9tSzutUSXYo9ZRK+F+SJmVztIfkPIJhlKtA19ahw5VSSkqukhFtruoORJbaT0u4WfVE2LRmtsbVrDcC7pwdDlQqHNo739OASfht5+9M2IZiou8McZ8Yx/RcyySR9aC1aUENm/a9VCw5ke3Sa0tCAR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761007807; c=relaxed/simple;
	bh=ZGWivTpUYnZX7sHhix36ODIkKD97NtBaXgMM9UW09Z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fg78E5tYp5qgn3EoOWXOLjHcUV9kf0e6QsTtxOKiecJNZUva9Eqwlnbtdwd1ehFJ3s+STK9CPFfrccqQXCENyEqzfup6OjbnO8q3nEYGpZz9ODOR6bKxJ0uhT2/sy3dod90vrR9KuqNslgiiwFsl4x1zjeCYQykycn8q58P4gCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ph8z0Gln; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ph8z0Gln"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so4041055a91.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 17:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761007804; x=1761612604; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jElfUXW8wCp0wFBdm2MwcKv7Fj5XfZurPdvK1+KQDTc=;
        b=ph8z0GlnnrJxio/aXP2tKmY9wmFGeJoPbP+4MeGXkkJhUBjMQrn9u2yhHZV0wdyZMa
         PlClBb5P7fODoN7/rqA9PnPy6KFhWHpe3aD6sdaBWscS34jbq0m2voKuAsvb3gQ1v3oW
         fHzX1BU/hUHUFakpsSsjRfujICSrjqmEF9oc5tHec/Xcn4nNpfvdxKbc4xwUebbU7o94
         /d5uXCkL7Dd/z+O3NRJB7cWWfiXGS6vCwXt3ekeGSfs3WweWaSEu2no+KNnIV6c5aNKg
         P1LhFEpVFBaMJs+X6nmGwSh+etoyooJ7CS30G45vfl9Kb/zH5bi6Mxvk0p7uJt1/sUF/
         /SNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761007804; x=1761612604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jElfUXW8wCp0wFBdm2MwcKv7Fj5XfZurPdvK1+KQDTc=;
        b=WWZuqPBkHU7rPhEIBVSgB0E3EHdIWEdbjQHq5I9vJBnn74pWefVEH10/y6FieEmEla
         9eHsVHb3fa1YX/dEi71H/87M1VOkZj+0jaXk/CCZqXloGsQznwSXNNeMbwP57kgE1bK2
         RI4B6m4ZvEc2duuVr8qpn147bQ0OIS7v4UYSaHhnQY2Gq+ApbqjXopADsqfm9HDAa3ju
         Pkf1mm8w6pnY5LP/LriFP1RuEmlgmpgte2ittu7Knm8tPifZTgkrgfq+Th+/KFGWGNqn
         j+YCdeFv/GLTXei1H0FWWcnLLBQsDGJd0Yqh83OQ3JS98/lWgqaEWYgzVQe+IbaP3Pc8
         10Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWL+fdPIlgBxR7f6a9YK+Et4mqPPjoadPOk9Y5ijXNeLgeD9ADAReaz1ogqK/eJ8fsrNBpNtKo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyOJfQ+n7ELe9LG554VQBOVI7Uy7P6eHbiqHu+p+LHGt/bVBKE
	LWa1Av1GAMfZCOMjnE7PTfYWMaXDPMaUSjCv3aZ4CgZEDdb1QKg8DGWQwb1FpoclQCYt23bV9cr
	xmXNCtQ==
X-Google-Smtp-Source: AGHT+IHdLNrdOSrC/dgKGwuDlIyF6hKyTRHuSK/jL8AhomiAuV/wuXp+VqpnA+jc5SjQ69PU54+FpTq2Rlc=
X-Received: from pjbnc11.prod.google.com ([2002:a17:90b:37cb:b0:33b:caf7:2442])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c4:b0:32e:5646:d43f
 with SMTP id 98e67ed59e1d1-33bcf8e96d3mr20061024a91.19.1761007804269; Mon, 20
 Oct 2025 17:50:04 -0700 (PDT)
Date: Mon, 20 Oct 2025 17:50:02 -0700
In-Reply-To: <23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007160704.1673584-1-sascha.bischoff@arm.com> <23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk>
Message-ID: <aPbYuvlLzLENTCcP@google.com>
Subject: Re: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
 or v3 guests
From: Sean Christopherson <seanjc@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Aishwarya.TCV@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Mark Brown wrote:
> On Tue, Oct 07, 2025 at 04:07:13PM +0000, Sascha Bischoff wrote:
> > The ICH_HCR_EL2 traps are used when running on GICv3 hardware, or when
> > running a GICv3-based guest using FEAT_GCIE_LEGACY on GICv5
> > hardware. When running a GICv2 guest on GICv3 hardware the traps are
> > used to ensure that the guest never sees any part of GICv3 (only GICv2
> > is visible to the guest), and when running a GICv3 guest they are used
> > to trap in specific scenarios. They are not applicable for a
> > GICv2-native guest, and won't be applicable for a(n upcoming) GICv5
> > guest.
> 
> v6.18-rc2 introduces a failure in the KVM no-vgic-v3 selftest on what
> appears to be all arm64 platforms with a GICv3 in all of VHE, nVHE and
> pKVM modes:
> 
> # selftests: kvm: no-vgic-v3
> # Random seed: 0x6b8b4567
> # ==== Test Assertion Failure ====
> #   arm64/no-vgic-v3.c:66: handled
> #   pid=3469 tid=3469 errno=4 - Interrupted system call
> #      1	0x0000000000402ff7: test_run_vcpu at no-vgic-v3.c:128
> #      2	0x0000000000402213: test_guest_no_gicv3 at no-vgic-v3.c:155
> #      3	 (inlined by) main at no-vgic-v3.c:174
> #      4	0x0000ffff7fca7543: ?? ??:0
> #      5	0x0000ffff7fca7617: ?? ??:0
> #      6	0x00000000004023af: _start at ??:?
> #   ICC_PMR_EL1 no read trap
> not ok 25 selftests: kvm: no-vgic-v3 # exit=254
> 
> introduced by this patch, which is commit 3193287ddffb and which never
> appeared in -next prior to being merged into mainline.
> 
> It didn't appear in -next since the arm64 KVM fixes tree is not directly
> in -next and it was only pulled into Paolo's tree on Saturday, a few
> hours before Paolo sent his pull request to Linus, so there was no
> opportunity for it to be picked up.  As I've previously suggested it
> does seem like it would be a good idea to include the fixes branches for
> the KVM arch trees in -next (s390 is there, but I don't see the others),

FWIW, "kvm-x86 fixes" is in -next (unless I've screwed up recently), it just gets
routed in via "kvm-x86 next" via an octopus merge.

> and/or to have more cooking time between things being pulled into the
> main KVM fixes branch and being sent to Linus.
