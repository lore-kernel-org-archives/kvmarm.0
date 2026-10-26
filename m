Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013287;
	b=i5hw86b5CuQX5Yb3ebbvTgp2392grdGSrCfOeIeVp3QcDu9VWwPX1pxwrpCPwdKEmsn7
	 qufBJRkmHPZV0nrW7WLZ47uDTEeZyfrRZs5dj5SMfEfwHFa/vB6W4PqtiFLK8iq6JdqJX
	 8CdztttQwk+36vcs0WFwVkzyIWaeNcxPgycCTAsG3jAsJrS7nMKufURNfakwe1pKzt8LC
	 izvaESe1PqxW2AR0S2VjRFE2ER6gytV2OHSXR7WcHz40sdTxSjVbCbtwpnV82Q+BamrEQ
	 5qCUQJKj7p7+cX4LQFkicA0etFR6sHWgNZV7p5F6l7CCLXqUyfJvKP6KqfroumoVBSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013287;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=D7xYMUq8jcHCw/udL91J2awlO7GtcxDGTY/T8x3DLkQ=;
	b=uY5uKsAeXq0sX+cguXK5BfwMZ7zEHoNr1eY8w3+S/EMQqvn94Pahd0lU5Zt0UIfjuFYA
	 ARKdiTtPMFvQfgsuCJkMgT5vrIQiHZEN00cDh1Tb5fT/gqWOkxWgLLSHMzqngTYzgE8dl
	 EktU7fxMiDKMmjbG+qMc34c99VLWNsR4/nxZQvykluqsqOR1vF0v4aswqVwllGPxvWcBN
	 d8E9tzif9dCCSTxgZX81iRF/JnNpIQ+F+xjXZiZdq2+OV0n8Qbn8B6TmIdsnCtcgBFGJE
	 W8LmhkZWTHOkG6xvbN+M98sH51fheoVnlv82nFZcXkNiqoRtiF+VUp9jn0XxoszgfPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=f8LHNjPJ;
	arc=none smtp.remote-ip=95.215.58.102
Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0256606F829
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 11:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0256606F829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=f8LHNjPJ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/kw6LIbxjBOzGprj6R15Znq++scfwHjoCNzPIlnqSgo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793013283; v=1; x=1793618083;
 b=f8LHNjPJG+AYfTQi323SFExct9Sbu8SlXKi+lKq13rL9sX2qgLZf12VxFIwHRjRCPGUOyQuw
 YcbR2bq8gGle+mP69DNYuH09HEiBq84CbVrHQUj1W8ywrSdZwPSEYPboPyJk6hIeqOZ5QH4rnht
 9U+fMTUumJiSSZlP5+tTCRm8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 35c3723e73a6d147;
	Mon, 26 Oct 2026 11:14:43 +0000
X-Mizu-Trace-ID: 35c3723e73a6d147
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso7331e87.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 04:14:38 -0700 (PDT)
X-Gm-Message-State: AFq9FYLE/SzqyeRhdNjnvUbMy5BRweP1NbebkaeKwoasBh8JGPFIWIX2
	y+lazWEaDDwj99QLp6y2FG1xvXnmeC2U0kDHry8j+dQQqg3rN7QH315pOyO69Jc9SHknLQcjD/e
	ewsfqz6EsRXNAtL5tzMcDvbUzdFbi7sXzNeRV3HX+
X-Received: by 2002:a05:6512:1056:b0:5bf:c3e1:532b with SMTP id
 2adb3069b0e04-5bfc3e1545fmr10691e87.5.1793013277753; Mon, 26 Oct 2026
 04:14:37 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
 <20261026092802.2636798-2-fuad.tabba@linux.dev> <sashiko-outbox-184898@kernel.org>
In-Reply-To: <sashiko-outbox-184898@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 11:14:01 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwG44zRA3c4UcZ3ynDsK-pqSG2LJ8Z8QCDLDLrZuQRaUg@mail.gmail.com>
X-Gm-Features: AclHuK9o2uKydOCj3eQ0PTMJbxnin7clpegfUuD7yjIGSfLi1gluUuhbM1DRizM
Message-ID: <CA+EHjTwG44zRA3c4UcZ3ynDsK-pqSG2LJ8Z8QCDLDLrZuQRaUg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Don't forward LPIs to a
 redistributor with LPIs disabled
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Oct 2026 10:13:14 +0000, sashiko-bot@kernel.org wrote:
[...]
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -293,28 +293,31 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
[...]
> > +                if (ctlr == GICR_CTLR_ENABLE_LPIS) {
> > +                        vgic_flush_pending_lpis(vcpu);
>
> [Severity: Medium]
> Is kvm_pause_vcpu() sufficient to prevent vgic_prune_ap_list() from seeing
> !vgic_lpis_enabled(vcpu) and dropping pending LPIs off an ap_list without
> clearing irq->pending_latch before vgic_flush_pending_lpis() retires them?
[...]

No. A prune on a KVM_REQ_VGIC_PROCESS_UPDATE request, or on the vCPU
the LPI was retargeted away from, can drop it with its latch set. The
guest still doesn't take it with EnableLPIs clear. Taking it after a
re-enable with PTZ set is a pre-existing bug, which I'll fix in its
own patch, not in this series.

> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -273,14 +273,18 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
[...]
> > +                if (unlikely(vcpu && irq_is_lpi(vcpu->kvm, irq->intid) && !vgic_lpis_enabled(vcpu)))
> >                          return NULL;
>
> [Severity: Medium]
> When an MSI injection races with clearing GICR_CTLR.EnableLPIs in
> vgic_mmio_write_v3r_ctlr(), can returning NULL here leave irq->pending_latch
> stuck at true and leave a live entry in its->translation_cache?
[...]

The same latch, with the same limit and the same separate fix.

Cheers,
/fuad
