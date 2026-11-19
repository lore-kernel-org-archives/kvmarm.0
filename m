Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795074892;
	b=Fyia97Gz8ilGzNfl83sxXT4XQETBomrBxonxM49ezWUJwKMwJWeWHWu1/1Y/wbEiXYFw
	 m5FH9nXJEUEtPtB4evuMe3LceVbCLbS+dWAHwc1x9iptwgBfoZUPnzdcUWCYmf1UFlN+i
	 sNInia9fGLY4d30SY3bfo8Tw+aVz3/fLKYQCOFHs+hxBiZUp3bdKBQtZsFHJs/hGletUH
	 Vw6ZIVJ40RssMWrbtKwLo3TDlFoUDJCHpkNVHRTPoXLqZI77eRm2+czFIml7u8TybpGD8
	 WjJTlU3cMwdu9K/iRpt1MC3JgO7BkAs9Up1RXAyJNaxFCrP/147ZPQ3dQD0DyQx7tiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074892;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=+H4AVHAkxU3vkubZcic9ja82r8a7H7wKS0//pc/pxSA=;
	b=d5qDQ3pTceCI20493XGprsbAxMdcUTrXAZKeD4Mn5qyYbn1EC/5Z0ABRyw+I5A7R3T2N
	 jBqm320lNUuBmZVpQ2mCE43+Q5MqqGA+hvApyfIx2fkerBvyf9H/m3sc0pQ7R7i7F0nuW
	 w4CJpHz35ra4LH1MzlZvzwIhojm5q6fjr187yMs67xrHBM9sI7AqnkZOYP1n89wQ2eTnJ
	 HuxkvByjcnLARwieDqJ0B+BBhmHMVOXuIEsnTj4dgxbRrMUhzNkwhVM4XiYanAAsJ5Rto
	 +hy1jL9pOZNAH90zN7Xm1/dsJf9xnoUxPG6Dpi5NxoTgujdnISCaL7g3rbwCRBbg3fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KuJGoeNK;
	arc=none smtp.remote-ip=95.215.58.243
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B8606A324
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 07:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD9B8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KuJGoeNK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IUkhtioo34/vN9L4UPndwkkOKppLGI8BNNMRdeeG/sE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795074890; v=1; x=1795679690;
 b=KuJGoeNKfp8ZRX9z1xtwdyg5UlGXJB3V95N2p1KhrINQPMX5k/e7NTz/tTSFBejPEz4lBSZw
 umhNa0f00PkOVbNYUyFwKbNgkVImWn/9wNDHixJGKG22PbAmnwANSzYXsCZBmnwycP7lWA3q9Qt
 f383rBgzQc/il6irhBZKKOMk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 84f08bc060dfb7a2;
	Thu, 19 Nov 2026 07:54:49 +0000
X-Mizu-Trace-ID: 84f08bc060dfb7a2
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so3772e87.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 23:54:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGv01G0DbBmc84Izx+YLro6smfLoQosQRw18rfRMHV7r8XvkqRZEheqOtPxc4iWOF7bJabvzaI=@lists.linux.dev
X-Gm-Message-State: APuU4Z8395vaw6N2185DYI/KHy4kcy9bWT+OxF9gn/XXjqkm9j7yUgcl
	ijz/5LCVzWbGlC4q5k0VUASb8/wX4+SpHvHCT/cfYGDbcwvw7qiMUbmZMmo543OS29iLQPQciDK
	u2mDUlRuXsya2Kf44FO4KQ1wMwStu5FuDU+Qp5pBn
X-Received: by 2002:a05:6512:3d20:b0:5c1:ac33:5a4a with SMTP id
 2adb3069b0e04-5c1b67303bcmr26361e87.14.1795074884909; Wed, 18 Nov 2026
 23:54:44 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117074428.7544-1-fuad.tabba@linux.dev> <20261117074428.7544-2-fuad.tabba@linux.dev>
 <avxfgWNePsGPK9mm@gremlin> <CA+EHjTzUrDxLSMEo6X66XhKtQ-=ew3zZhMdFWR6U9Ga17WLWkw@mail.gmail.com>
 <av5CBjbeidUUWiLq@seanjc-mac.roam.internal>
In-Reply-To: <av5CBjbeidUUWiLq@seanjc-mac.roam.internal>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 19 Nov 2026 07:54:08 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwdkbx=1yQNP5=-BhE=S0uaoQnO3F-83d2WbYC=j9fd6A@mail.gmail.com>
X-Gm-Features: AclHuK9mtkqv6V--RBoHl1Fg-Xb2-fd2-ZgaHzAt1DD9Kl83ENlFhqESP2uZHtY
Message-ID: <CA+EHjTwdkbx=1yQNP5=-BhE=S0uaoQnO3F-83d2WbYC=j9fd6A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's
 dirty ring is full
To: Sean Christopherson <seanjc@google.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Thu, 19 Nov 2026 at 00:25, Sean Christopherson <seanjc@google.com> wrote:
[...]
> > > Maybe worth mentioning the exit_reason thing if we keep this arch-generic?
> >
> > Sure, I'll document that userspace should complete a pending exit with
> > KVM_RUN before it pre-faults on that vCPU.
>
> If we're going to do a documentation update, I vote to keep it vague and scary,
> otherwise readers might think the exception proves the rule.  I.e. if we say
> that KVM_PRE_FAULT_MEMORY isn't supported, then userspace might think all other
> ioctls are safe, which is most definitely not the case.  E.g. something like

I'll go with that in v3.

Thanks,
/fuad
