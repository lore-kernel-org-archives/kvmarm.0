Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794849538;
	b=1vwqyS9j0LIqK6OxSjubrS91dzoxUEcVEw/1ZcnZyHd1ZJWnICY3/gis3zhIFllfMxta
	 MjORzhFDVXGzSKhYoRXLu0euRsvcaTKZ/ocM92H6X3fYHd/k8+EVWGMKDRrxSaJcWN9gc
	 p7bFxvkeQvQStfYTfcQL+8dZ5rD/rzEeU3cwJvMOvfs1S7xk3YUVFaVF6KY/6deDUy5Qe
	 NFZV6xdrZZ/s+s6vpcbbvW2THg9QrEtPom9J7hpyQ7xdjMVnuIG7QueO0aVDRWdS9Gime
	 Pa0q3uaRnQaX2/Y0iXrvxNWQEv1LCAwJ3P76RtcIWPP+TZo5IaQXIuJuevaHwoYIWqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849538;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=OzaqIXPqhSSG4ejd/hB4U1AFDk/wquty1pyzaNNEA1Y=;
	b=fv5QuAZ/IJK3q+Ork8Hz9SUJxJ9fZxe24zyn07/0VAqtmMb68ocIQjLg3fiKcHD2BUQF
	 VziS1Wm/bQgr2zuh8kOq5T4RDSKjHDgZLqc7LfMqiLrfaxwVljDgNuFiMK4zVazkQQ0uX
	 N9kQO3BS+Gwlurqpemqq6zU8IGaOpJapse5uFmRP2EO3IyEtcNEVgZNuoj29NvLxKoiIa
	 XRyk179xElTWYtGT8tLkINWQ+WtWip/d76I938balbiqDX1Skqw3gqm77B/uv+nWDadOp
	 DD62azVzwNUkM9vx2jFN3foPccRUX0eke2gWMt1rDF/8u7uGqyVKZb8z9gjJdLvleOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FATMERdt;
	arc=none smtp.remote-ip=91.218.175.126
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4D606A31C
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 17:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99F4D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FATMERdt
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PAxYfgYQrRbaE3T1nWWUCpJHJViNiRZaZVomuIz4tHw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794849534; v=1; x=1795454334;
 b=FATMERdtHEkIxQuVYTDRMjGA4XlQokYJ5by/XGC2YU5+kSidab0BPiR252bWzT+JpQdUmT39
 MJ4SmbWieRhc6nVIktUSYNIMkuT4OhjycI+a1dfVDRoxNAmTzOXQ8h/Ssyh7x1ultz7gPYCll/U
 XP91kEnGCVo5uGpKesh7s9Eo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 202814663b1c0c35;
	Mon, 16 Nov 2026 17:18:54 +0000
X-Mizu-Trace-ID: 202814663b1c0c35
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so9681e87.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 09:18:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFweGPgQ7vTt1+P6+uXeFAlzVq4LizTru76YbadaUXZ6kncE/h70Ga4dZCNvAfULvWJ0iHdHs0=@lists.linux.dev
X-Gm-Message-State: APuU4Z/lia4pcuSYhPmYbhCNcSDigk77K+8dcfFYLga5G7xMLHVPlSfh
	iF9ThOSNOWKb+osoCSTY/NgIX+6IYXvd3ny39H2mizuKLZJ/BYXeK/IPwPZ1RU3CMpDhsv8Enhg
	kL9hasgEjmD/g9fU+DbO9oKGbge9VRLoGs4c1L8jy
X-Received: by 2002:a05:6512:110b:b0:5bf:f84f:1d74 with SMTP id
 2adb3069b0e04-5c17e52e81emr262285e87.13.1794849533007; Mon, 16 Nov 2026
 09:18:53 -0800 (PST)
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
 <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
 <CA+EHjTyqJfGS+5UajX=RYTAG-qfhZ-vmGi=1SixXydWhwGHLUA@mail.gmail.com> <avs5UD79FB_DG1Vs@seanjc-mac.roam.internal>
In-Reply-To: <avs5UD79FB_DG1Vs@seanjc-mac.roam.internal>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 17:18:16 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwXO_Ym1+ErHT9Si6FwHtDaPDmMRwY+RS8LDNK421rchA@mail.gmail.com>
X-Gm-Features: AclHuK9xW32VPDT60mgyMDdb5wXbr3ChwJoDPUUlo1Wmi2N2JEJM_TMFlrp_0kc
Message-ID: <CA+EHjTwXO_Ym1+ErHT9Si6FwHtDaPDmMRwY+RS8LDNK421rchA@mail.gmail.com>
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

On Mon, 16 Nov 2026 at 17:11, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 16, 2026, Fuad Tabba wrote:
> > Hi Sean,
> >
> > On Tue, 10 Nov 2026 17:18:22 +0000, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> > [...]
> > > > Eh, I vote to just use kvm_dirty_ring_check_request(), I don't see any harm in
> > > > clobbering vcpu->run->exit_reason.
> > >
> > > Will do.
> >
> > After taking a closer look, the clobber is problematic on arm64, where
> > KVM_RUN completes a pending MMIO exit only if run->exit_reason is
> > still KVM_EXIT_MMIO. If a pre-fault stops on a full ring after an MMIO
> > exit, the helper overwrites exit_reason, so the next KVM_RUN doesn't
> > complete the exit and the guest repeats the MMIO access. The ring can
> > be full at that point if the pre-fault dirties pages, or with NV, if
> > the stage-2 walk for the MMIO access does.
>
> Wouldn't that require userspace to do KVM_PRE_FAULT_MEMORY after KVM_RUN with a
> KVM_EXIT_MMIO return?  If so, userspace gets to deal with the fallout of being
> stupid.

Ack, so v2 will be as you suggested.

/fuad
