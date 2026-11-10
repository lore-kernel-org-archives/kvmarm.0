Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335712;
	b=HFPrVIkN46vMRZK6XjxAEggREHswMNXhrWmxf5yckHMmrvUOkGzcnu7YxuxoBPoBdpxW
	 AHbI7apOeM6+PoNKi7Z3id9pkdXzos7Jil11JJME8UVNGeieUgrJYyerJmDnu+5LnloNJ
	 3xxz4G0UDV70xICk0leshP3RMmvntUrQcvZPXsrChCQjtLRKcaCylQ3cMF4go13QmM0XN
	 GFqOBviBw5rCr9S9RG3Y1qr61AGwemu4W8Pq98sHPE1cZ4hEA/e16PvMIlI4rngRhJc1g
	 ssSzrZEGID8u/mgrGSchAG95I3mEkmn9EUZZMrATyYQe+JkGl5qxZq50X3sZoOKuvZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335712;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=dCp0Db26sWh4sAbqSPzWp1M0J6ydStL+IzHoLsVEdug=;
	b=uzUHE4yFL6SRL9stD2v3NcBvKDpKzQFNk1O2/HbaTguDM/zs+Pj+3Io3xmnlsUNMqmLW
	 jv6YMqnV9LyN7SLPki6h4sh3jBh+MwAPUPMelOzR8UsklD+Qs0Fzf/X80tLZmkAN774O5
	 cV5ge0LA4Kgbdyiszdg5ep5emp59RxwLRfPvztHUuuEbjq6zeBwXAwW9ToR1rqbNBD05K
	 FqqCBqtEgcmJ/1OtsqvUyb0R7424Sj0xL2lvwD+4R/DKfdqFN76ivyTD8KeIVSiKM5g4J
	 u4uRNB3OnL9L32BU8s0CFu98de3/FCPwXhp+3nYGvBu817R0ij+LjRrNIeLt1I/nNFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gNZs4Zd4;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30018606A32A
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 18:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30018606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gNZs4Zd4
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdb869327e7so2011730a12.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 10:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794335711; x=1794940511; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dCp0Db26sWh4sAbqSPzWp1M0J6ydStL+IzHoLsVEdug=;
        b=gNZs4Zd44m37D5NwUccpUsbS/VBIPw137skVOePGVvn6wC2iOm4WiXhTJ8jJJWfDye
         RUkbzLbb0fOBpRGUTDyOmG29c+QaTzb09doXLncxzoVKfo+WglyLsoARv6Lg1ywgCXiM
         nicdfS5+dYDsCGwvSdhA1WvssUK/PQAQqdgnoZUAoV8e8rJGoQSCbWdzbW3DNWDyxmZS
         +Ux8lj1vVyaYOPUQCrR6KriOAOgF/+FL3Ikp/h+0scuUXkmrF/tZIpWeG5zRlM1So/Rw
         NIifDVEwGmRP9BMg8BpxZmFTS11VJNbXFoJUuxzTkXIKH7gO1/zF+j3nINI2AND6ImE0
         rbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335711; x=1794940511;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dCp0Db26sWh4sAbqSPzWp1M0J6ydStL+IzHoLsVEdug=;
        b=Xbm7+umqJL2Uh3pmx1KcuRvwUb1s0nQ4qLRuLeD7FshITtb3BnnWiJBmPtIDAtwvt/
         MR9S5dWo5sd9TBQhbTc6N+54HtLIV64SUGj9cUCGKWacNdrvgf0rmR3aFFe2b+oQvlg0
         VP6q/bdL3SEfPFcLwG+wuVv7zLGBk4Vr/Odt08IxXlvkU2g1TBLoUf4eqZX+ga7kaIjE
         MeLG8wpXgrupaMc0RctcszDyV9JO03xHgLJbaSIMlG+qdmooFhNLsx2A5r2m9mLwVQ0I
         9OryZFenAxw+WvqIPn6HcyXz/m89HdDzQ7yY5Dh/lq39OL6rwMmv05edW6pxIbr+hZxD
         Ad1w==
X-Forwarded-Encrypted: i=1; AL+hErGqAkk4mnEy63H2nv3xsISBHRWsgBZ2GnWfh8jzRDZS0HsQhGphrlN+fNuZ2zMTD+NS1Mo7Bb0=@lists.linux.dev
X-Gm-Message-State: APuU4Z81lp9O5yuDV9gt1/yslewX/2svoYp4bShKZhUWjmdOXv5YgwCT
	H9zFtiDilj9XkQPS/c9dvZwhV9LWp9SJ2mELV0VRp55qjtCDHyBt6beH8bC7ciKL6yUD56okBGB
	21r0D/g==
X-Received: from pgbbo3.prod.google.com ([2002:a05:6a02:383:b0:cd8:ba74:813f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7907:b0:3e1:bcb:1d19
 with SMTP id adf61e73a8af0-3f1901885e4mr3216153637.67.1794335711215; Tue, 10
 Nov 2026 10:35:11 -0800 (PST)
Date: Tue, 10 Nov 2026 10:35:10 -0800
In-Reply-To: <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-2-fuad.tabba@linux.dev> <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
 <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
Message-ID: <avNj3kdnvQiY_ity@seanjc-mac.roam.internal>
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
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 10, 2026, Fuad Tabba wrote:
> Hi Sean,
> 
> On Tue, 10 Nov 2026 15:48:37 +0000, Sean Christopherson
> <seanjc@google.com> wrote:
> > On Tue, Nov 10, 2026, Fuad Tabba wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> [...]
> > > @@ -4461,6 +4461,12 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >                          break;
> > >                  }
> > >
> > > +                /* Like KVM_RUN: only the iteration crossing the soft limit uses the reserve. */
> >
> > Please don't include AI comments verbatim.
> 
> The series is LLM-assisted, but the comment was actually me.

LOL, I think all of us are getting a bit corrupted.  :-)
