Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794331143;
	b=QhDBGFyrPx53deTxZI8oH40lLhLaOo/4OyIjCwoCiFSQqfQk//CyRQH4MPlUse5pa01v
	 SwSYph2BOjdmUUf5sZfS5OVAc1kP0dJSBKY0M+XoycOW+TEYDc1ybnyUiwxYwxKZxz+FN
	 5oyA6FXwoAiBiSUYsW4DJZIxdoi8iKw33eKOFCAmVd9gxNE/57+Fp0UcY4GsOvxESNlcj
	 hszypZjFofMdPH5AQws8UY0CXs/yjIC0hIIXxjEv22cAJoXBP+3zYBpecvA3lFk/bt5aT
	 p6gl7MVENdDV7PshVwSt8BAcQfiuY5LeMCdbMHuHQy0CEEDe6g1vMIiBH4j2N7HZ/VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794331143;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=V7fyh20lQdCfEvkMlKmFXdlszEDXLNAOR5UNt1WFBvY=;
	b=4EHMtH+WZ+G3yBDqencesfaaYPWkcHlWA0th/qR3mugA2LWTniX1cTyrekaeoDbnqKAu
	 nQJUkmcwQ64OQiBoCSFaDz0JKikd+pmOFiT+abBYTMFNhz+3RqxLDdxaSI8PiMOkHFJTU
	 mjv0gb4ypv37IVj7YCaARkO6/z25mShvs34HWOLVV9HvnR9OPbIDGEMMlMzyozJrEz8AD
	 wyUJx/GTCqkzr4TwXPb12lZsCHOhSX6cgMFJSAXZXf/tWopOHzq7Qr/S2LsuxLnt1SJCN
	 hYCFgPIklxYHLlTw7FYvVb+ja4FtXvt9wQnTlvSEvuI3vuRmPU0qrCBzkVnQEu5SSpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rvkkjfS1;
	arc=none smtp.remote-ip=95.215.58.81
Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18099606A321
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 17:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18099606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rvkkjfS1
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5N+pLaOxaXEBjI3kYto3LAKJTxf1OYPE2hTSsrnSYYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794331139; v=1; x=1794935939;
 b=rvkkjfS1tO691eMXSCwm0RVH4dzR0sapLkO05hgbNKIbA4SEccFQTs3REvRS6Wr8dm5M/Y7/
 qSP2VYnHhkJePE5hLJbQFIPx+m48QQEu9fpN1woNGxf7ExYgi5WRlrVtTYxrLtvENMIb/tolft5
 IGVCDdM5Ehzfg9gRtLXHJRHg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 45d7b9cdf1e94b7d;
	Tue, 10 Nov 2026 17:18:59 +0000
X-Mizu-Trace-ID: 45d7b9cdf1e94b7d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be58ad9600so9170e87.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:18:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHje5W12P6t/PO9CoDWu9HdxXfEru0UsoIF41IBawQyzskcFzuZocWSziUEGhdgfnAYEswbp9k=@lists.linux.dev
X-Gm-Message-State: APuU4Z+dvA8tpTQYFm8LGX2sNS0b318wPG75ASBue/0NZPhrsnEKv5Qa
	PcrPcYJRWhDhkUR/Il3rhxmrirSDg6jAsExggRv0mMGbbYNwn/iJMcSl+uaaMDtl2HUfXDH8Ruu
	2XfnTS8A0+omjjbcuWxFA5zf2WnVcr0BmG1d2jkpw
X-Received: by 2002:a05:6512:1153:b0:5c1:5361:4aae with SMTP id
 2adb3069b0e04-5c157dccb40mr145514e87.11.1794331138677; Tue, 10 Nov 2026
 09:18:58 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-2-fuad.tabba@linux.dev> <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
In-Reply-To: <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 10 Nov 2026 17:18:22 +0000
X-Gmail-Original-Message-ID: <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
X-Gm-Features: AclHuK8XEMs-LG2DuXG_orFbD_2iTQdN4-tg95UYPdRQQh0AwcU2lWY30uJCy0M
Message-ID: <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty
 ring is full
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Tue, 10 Nov 2026 15:48:37 +0000, Sean Christopherson
<seanjc@google.com> wrote:
> On Tue, Nov 10, 2026, Fuad Tabba wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
[...]
> > @@ -4461,6 +4461,12 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >                          break;
> >                  }
> >
> > +                /* Like KVM_RUN: only the iteration crossing the soft limit uses the reserve. */
>
> Please don't include AI comments verbatim.

The series is LLM-assisted, but the comment was actually me.

> > +                if (vcpu->kvm->dirty_ring_size && kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
>
> Eh, I vote to just use kvm_dirty_ring_check_request(), I don't see any harm in
> clobbering vcpu->run->exit_reason.

Will do.

> Side topic, kvm_dirty_ring_check_request() is rather confusing (clears and then
> re-sets the requests).  AFAICT, it can be this instead:
>
>         lockdep_assert_held(vcpu->mutex);
>
>         /*
>          * The vCPU isn't runnable when the dirty ring becomes soft full.  Keep
>          * the requests set until the dirty pages are harvested and the dirty
>          * ring is reset by userspace.  Note, checking if the ring is soft-full
>          * can get a false positive, but not a false negative, because only the
>          * vCPU can add entries to the ring, and its mutex is held.
>          */
>         if (kvm_test_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu) &&
>             kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
>                 vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
>                 trace_kvm_dirty_ring_exit(vcpu);
>                 return true;
>         }
>
>         kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
>         return false;

I'll send it as its own patch.

Cheers,
/fuad
