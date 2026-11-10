Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325720;
	b=cLIHCgbWvG9zS4hfsAUNBpaGmKNAIAdR+/AxpcO7dPS56aNDGQvtVr3QwmhFFrWuLKkT
	 vi6E3hhcz72UzDvmEg28x2UNUf0lctBP2Cv6l0XeuX++QND9gIbKP7LjDPpv0oM0TFLW6
	 6b2ATgqFDejB/IlLN7xPIUvE8MTslkBVSRlz69S0Yi32Tr9RnetCimEVI9fT2/p8X8BxJ
	 CIZ7tEfj7Uh4CpwtLXRZOFft0T9E619FBgmKSqCv/i3dRROoPgdaJzGdoxrZ7Cwu12BGi
	 nKyA6nrGRBRh7TyNDjq+7MhxC4m1jHQcJu6Kf5ixZubfoqoc0v9TLP0x7AFyp7Duf7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=6krrngdHCsjiOW3bLfxtRylPnkwePlq//L1F5r6HtXs=;
	b=nBq6mtWSqUoFdWdyE6hHvNCn8Sp8TCljj2crwR+fUPEhOUvSgMkVAstSc3mvq0e7I+HI
	 95LzI9D2Q8vG8h2ysF9xbgNiDrm8lityczrJfLd/UleW2OoSVNhW8hm18U2i00zMtAuy6
	 kRdBrp3gAfdA1AEaIGseerchN/r1yEKE+IRFNYfV3F6U3VPyIf5HH+tDmxatM3OdgpcnF
	 oxbz/a9evmGI/r/zxhywDUj33bVeKzpjvsx2AztZHQe9ruKVEmP+DF3Oj/gDsaSyPRlud
	 TpfL1jN/20sxYQk6Lyedpb6aU4FW1hSjbjoZpA1rnUBcCh6On6qIfyZ7f2qBW667kfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pvUYjzCQ;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FD60A2613
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 434FD60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pvUYjzCQ
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2eb5375cd68so19253415ad.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 07:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794325719; x=1794930519; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6krrngdHCsjiOW3bLfxtRylPnkwePlq//L1F5r6HtXs=;
        b=pvUYjzCQPTFjpozL+CSqvUHt/pyrc2LRg840vydF7IaPkA4/f9VcgITAN/MPrfaauY
         I3mGFRNcRF4PB1UUG6f71vfg9a3fS2XhSczPoAqLGrZnw+9PpSnu9D0kh3y9glkYFWC8
         2jZI7Kywzo3H8ogKhKjpBOpPTCgKrrs1nZBBbaFHWsz3RMFGMXRcMxbpAZE43lmXIxRC
         DmVkwMCAzcAK7Lt+vbdJc/3B8tGXrdtfWNyyFd7niZdQTHBVVththpcBju90ejUmO+TD
         FuqMqS0cPi4lWPeyqwqropW6ENJlF1FE7lfU+umgmvfJz8N/AoGGPcL2xpEkIA0ov7M/
         8ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794325719; x=1794930519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6krrngdHCsjiOW3bLfxtRylPnkwePlq//L1F5r6HtXs=;
        b=RrvvK1o61HOcLhcKeILQPS+DpS6uXFqyn2vTAfuJ/Weu1IfccyMlRS+Yylz/rgFJGo
         i5+F32Iv0PBq/d9yp03Pg2vJB9p3tokYR17D2VMzwCp2zz0J/otMRYMJiIOpifgkduyp
         HtildmuV5v6wCCXOvvoF2+sLdpKqKr4pk6jTEWI5Rwi3iAS8FiUBU4FxuTTPC+IqJ4NI
         cG9lhpXrKOZsGhTu2wFHDCllmzjccOl6f1b+z0bR6F10+J2YnLLHWZuD+Ytw/0sEDUDX
         JGBMZSZ3/aSxwd4Fji8givErFC6kbf6StERWqWM8NbyEXGvKN+fmSfN+Nsw6k/kVUdm2
         aMCQ==
X-Forwarded-Encrypted: i=1; AL+hErEbZW6dxRPy/sPMu3uSmz1J3S0EX6wVsSSQV/9pWzMqlUVOeivEadar6lPxnChi/K5yemv18do=@lists.linux.dev
X-Gm-Message-State: APuU4Z/CQftEsguJj1nt3Hi5vsca9C98A0T13nj8o+f73PO+LyCAF8rp
	cSddSRaCW1l5E1HgkNzOaxFRBp1j37YSCRKL7BB+E/bWtrOdeZxMwosA0LNt28thfwPdmVeiTKW
	JWCBs6A==
X-Received: from plzu6.prod.google.com ([2002:a17:902:82c6:b0:2eb:809:b8ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d547:b0:2ed:218:6043
 with SMTP id d9443c01a7336-2edb93052e6mr23931165ad.59.1794325718280; Tue, 10
 Nov 2026 07:48:38 -0800 (PST)
Date: Tue, 10 Nov 2026 07:48:37 -0800
In-Reply-To: <20261110110724.3614412-2-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev> <20261110110724.3614412-2-fuad.tabba@linux.dev>
Message-ID: <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
Subject: Re: [PATCH 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty
 ring is full
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 10, 2026, Fuad Tabba wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf4cb586f1407..da1b76ceb65e3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4461,6 +4461,12 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  			break;
>  		}
>  
> +		/* Like KVM_RUN: only the iteration crossing the soft limit uses the reserve. */

Please don't include AI comments verbatim.

> +		if (vcpu->kvm->dirty_ring_size && kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {

Eh, I vote to just use kvm_dirty_ring_check_request(), I don't see any harm in
clobbering vcpu->run->exit_reason.

Side topic, kvm_dirty_ring_check_request() is rather confusing (clears and then
re-sets the requests).  AFAICT, it can be this instead:

	lockdep_assert_held(vcpu->mutex);

	/*
	 * The vCPU isn't runnable when the dirty ring becomes soft full.  Keep
	 * the requests set until the dirty pages are harvested and the dirty
	 * ring is reset by userspace.  Note, checking if the ring is soft-full
	 * can get a false positive, but not a false negative, because only the
	 * vCPU can add entries to the ring, and its mutex is held.
	 */
	if (kvm_test_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu) &&
	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
		trace_kvm_dirty_ring_exit(vcpu);
		return true;
	}

	kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
	return false;

> +			r = -ENOSPC;
> +			break;
> +		}
> +
>  		r = kvm_arch_vcpu_pre_fault_memory(vcpu, range);
>  		if (WARN_ON_ONCE(r == 0 || r == -EIO))
>  			break;
> -- 
> 2.47.3
> 
