Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047946;
	b=Y1YwVo4gmmS7sSYFdZ1+uiK+m8L6T5KrkHLc4sGvcJ7gVpvw3vxisl5hWJ9+Ral/uSgM
	 mLt91DuOQDLh1y4v6y2iWT79P34r7eCSIf8fwoM5mKU0BDL5zalmlf9R3s6PWy8jZGuiO
	 brmkllPdBTDJIVH6WE2D4W1ZFO4YVf2AIMJSC9mWdckHO0eGcZqrotWcT2OHJ3Ab84NJO
	 iOnquWX09PmSsg2Jy0ajyRKZh1FlT3FBw/9Xp45YO6igBJmfGv6+8+nfc8gwuW3uSa3hf
	 IHMrdh0qx8YHjtEvVylZexeKW3PyS92YcSfnrVGpQGQxVzdFTSlH7HThUaRADQ2fiaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=yb3RT/dSHycHHUvHrQYfX0MzmZ7Zlc0xT6PVwRVG2IA=;
	b=wyr/GeLq/BTOgL2gTwNXHQ7J7yrXmzNifpli2QuFLz3cxuXkTaWk9mZw4S6W9Ox65SAC
	 vwMr1MSsZ3bNwJwvoZbPiXUO+EPSa2zPRH3Ie9LxrPrerYiQC8wVxNccgFCKccLbaDt8l
	 6TwN/I0lBtu/Rm7KPHCk7/mhpILSy06QLu/PHujIG/KfFiIx9vvU3aeQV7rZ7KUvuPiUV
	 KVW082Dl3L/1XnVvUcsdpcxXxc2dCvmN8EQffBEkAejLPyLS5Xr0aBJbSmZwGpGd79kni
	 RB9bB2EEzLpwQOluhJ9wUX7vHrmz/zhq3wRBE8flQVAUr+DWbD8wfMnV0yrn8ns+r7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Ui3/TnLh";
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2487B606A32A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 00:25:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2487B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ui3/TnLh
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4f652f9bso1158906b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 16:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795047944; x=1795652744; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yb3RT/dSHycHHUvHrQYfX0MzmZ7Zlc0xT6PVwRVG2IA=;
        b=Ui3/TnLhSAs982VnU9PT+aIvABa03Mg5h2aMt9CWwIfF1YME172SeNw8TjPi6kULo4
         WLPvl2oOPQpI4pY3IlzlhHlibfM2Ee/wJsMsulv8R1OWVJ6bdj3VeGoM7wiU+N0XCgC/
         /UILluuhGMvD0fR2aqmlevDD8UxQ0HzdjZeuVyevZBldteEdOmfWCbOSsltKTEocabzl
         HuIE2JYYwa0Ab/BCYLtpWtaGQMq96JW1S3Y2nElF3dOTHYTyCjtkwWGWaqE9xPmTSsQJ
         ZOBic7VKgI4uuqahTJDTXgxL+gyPqRDzacBn10O4CILRI/A7ABbE8Z5f2mIbDsfxYHl1
         IIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795047944; x=1795652744;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yb3RT/dSHycHHUvHrQYfX0MzmZ7Zlc0xT6PVwRVG2IA=;
        b=LTReMYchGjF9h+NtSEY28pCjku8ps7Q6jh44xiSpkWajjHVIgBia0i6ZQztbNcmmgI
         LA3QriiPdwRVn3bnTVhEvfsrQqXOTxdQBva7cziy3RjxpR/COUoOi1q/ZxLA/WIcGvGF
         LY2qz4icZqOX1yZt576BxtXv/WbeegkDO1xE2o9vRhMA8pf8LwQIsMmWNNaH3xIHurV0
         TnhpB821hk+QhnMFsO7gEYhz4L2bhu8z1SejdMMWq7+XbRGpU4HWDyCbAOnKonQPb7nT
         IFD1V5riARMuWOkPTaJ8ngG8EvpQJykJrKeCbmo+XsR/AWLoHVuWbuAu+f8Ofaokf+gC
         MJGw==
X-Forwarded-Encrypted: i=1; AL+hErGiUHMO63OJ4SZiczOtPawsK6idmh72FPI29z/5gX//JQDDWGS0vGGHcDKvUSZ3PzmqYlUGnEc=@lists.linux.dev
X-Gm-Message-State: APuU4Z+q2Ca4bhAwotmj5I3a1y9RH//fLvBr5LzOz3JOMfY6ysQPRu3H
	+rnggti0H5+6WrS5SCerx42YoOHCXgTx0tfZiCmz+c1JI7MbdMv+ls7jZDYRuKWMHDh0Mw4G+rd
	RRJ/oQQ==
X-Received: from ioru16.prod.google.com ([2002:a5d:83d0:0:b0:9e2:9e82:a2e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:250c:b0:53a:8c5:d7de
 with SMTP id 5614622812f47-5773db2428bmr4568078b6e.1.1795047943693; Wed, 18
 Nov 2026 16:25:43 -0800 (PST)
Date: Wed, 18 Nov 2026 16:25:42 -0800
In-Reply-To: <CA+EHjTzUrDxLSMEo6X66XhKtQ-=ew3zZhMdFWR6U9Ga17WLWkw@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117074428.7544-1-fuad.tabba@linux.dev> <20261117074428.7544-2-fuad.tabba@linux.dev>
 <avxfgWNePsGPK9mm@gremlin> <CA+EHjTzUrDxLSMEo6X66XhKtQ-=ew3zZhMdFWR6U9Ga17WLWkw@mail.gmail.com>
Message-ID: <av5CBjbeidUUWiLq@seanjc-mac.roam.internal>
Subject: Re: [PATCH v2 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's
 dirty ring is full
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 17, 2026, Fuad Tabba wrote:
> > But the overflow bug only applies to x86 (see below), so is this something
> > we should worry about at all?
> 
> The ring overflows on arm64 too (below). As for exit_reason, I asked
> Sean about the arm64 MMIO case on v1, and his answer was that a VMM
> that pre-faults between a KVM_EXIT_MMIO return and the next KVM_RUN
> "gets to deal with the fallout" [1]. I think the same goes for riscv's
> exits.
> 
> [...]
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> [...]
> > >  The dirty ring can get full.  When it happens, the KVM_RUN of the
> > > -vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL.
> > > +vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL, and
> > > +KVM_PRE_FAULT_MEMORY on the vcpu will process no more pages until the
> > > +ring has been harvested and reset.
> >
> > Maybe worth mentioning the exit_reason thing if we keep this arch-generic?
> 
> Sure, I'll document that userspace should complete a pending exit with
> KVM_RUN before it pre-faults on that vCPU.

If we're going to do a documentation update, I vote to keep it vague and scary,
otherwise readers might think the exception proves the rule.  I.e. if we say
that KVM_PRE_FAULT_MEMORY isn't supported, then userspace might think all other
ioctls are safe, which is most definitely not the case.  E.g. something like

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e95c9cda085d..45dc1e3c0b03 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6971,10 +6971,13 @@ to the byte array.

       The pending state of the operation is not preserved in state which is
       visible to userspace, thus userspace should ensure that the operation is
-      completed before performing a live migration.  Userspace can re-enter the
-      guest with an unmasked signal pending or with the immediate_exit field set
-      to complete pending operations without allowing any further instructions
-      to be executed.
+      completed before performing a live migration.  In general, userspace should
+      exercise extreme caution when invoking ioctls other than KVM_RUN prior to
+      completing the original operation.
+
+      Userspace can re-enter the guest with an unmasked signal pending or with
+      the immediate_exit field set to complete pending operations without
+      allowing any further instructions to be executed.

 ::
