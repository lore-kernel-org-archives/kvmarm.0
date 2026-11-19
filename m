Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092253;
	b=CMwz/nWC9UIo/TfyHDbVewY0Gbdpgt/ccaN1JMsJYjbapwdQoByhmI1b/Pex4dfwQiFW
	 gjbnf4XjBBaLfJcF60uJfPqItuBC4NHEGqIvChUZIsUm9X+qyvCILOaGIZoglLY19Cp2u
	 TEzpN2mD99SGDtMwumIBLle/pN/tVcTwCJs0KTCZdSc9ER3/KxTunRTYdX2JH1fI9Gdga
	 7xn3VSCcTh7DGZTIfOeNXjDmlqXTqN7eP52gaiXQVKzDBLD90vbzgOD6rAxMisNOTi7P5
	 7quZmLtaOCCI+aUz/p7EWrsPeOzuUCFo5V+SvpEqeSNalsqDFQnfs+XlivnMPYUmBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092253;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=odGKjtuO2fcSEp2Bw94sYra7hu3Cvd+3dwpUXKWdflc=;
	b=Tgk37tlEea5jwxOaTA/UDG1Xl5CsnsTV5YJNK9MFsRj3sq7bAlylq3dE8Ha58xbInZWz
	 aW9B9b6GaRHzQ5t8vBDPU/FeRUe1GnKAjitdsOTsVSviHi2NvHDe06Jgvx8VZ16iNh6la
	 edcQ6EYjwprmoaMGdFrsWR39H8Wyzo1ywEVhVf6Q6bzRozjL+zwPTI9ZLWY7IwkLwrT0V
	 TpOL4sq1Msqa8l26ZKVWM4o0Ib5kgfGdHU2j7hJkdgDonEkaHg5pQkDGss7OQmf4l+KWU
	 j10HsjJQT5w4J38IH0AqiTsAPHSX0A3D7MGe5CxHoGEuChtWyQsgRPNZJKm/q6YQ//Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Txr88EII;
	arc=none smtp.remote-ip=91.218.175.164
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368060A261B
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 12:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E368060A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Txr88EII
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=odGKjtuO2fcSEp2Bw94sYra7hu3Cvd+3dwpUXKWdflc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795092250; v=1; x=1795697050;
 b=Txr88EII8eXZ3BevEgepLqSR+jMiGMvjtzRJggX8o3nGTRQTo+fQQTx1REoBdJqI7joAdDG5
 uwviIaBbEpa/dfx77TEyep/BMu4/hGvWJ+/LJ4Z4sQxFV9UxsiMBhZftgc4TnRXnQ4+4Zr1XuSK
 TM12+YTiz8yM2FIUUSz+mzyw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bd1c3c6a795dbff7;
	Thu, 19 Nov 2026 12:44:10 +0000
X-Mizu-Trace-ID: bd1c3c6a795dbff7
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be58ad9600so8108e87.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 04:44:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH9S29MTyeTkh4h+/Vv46NTADic8NDoQEIHWkFVMB+V/VdnItZqHsJjSkAPD/KtQKjJQNsO6ps=@lists.linux.dev
X-Gm-Message-State: APuU4Z/12nkL5vHkPxCt+0kSzfb4iImFP8+6z2/KGN6Jckxv8xZ7bQiM
	dzYNTK0pvS6S6Dtz76xC1D2iPU8uVABvndbkjalRUezcvYGXFdgeAVeuCdmpl7btNDCHkfZiaTv
	QsKq/c9umcwuYuGAMA5irC9EfNgfj/rcgjU84lC0H
X-Received: by 2002:a05:6512:4011:b0:5c1:4d61:20ff with SMTP id
 2adb3069b0e04-5c1b6774040mr72185e87.10.1795092249237; Thu, 19 Nov 2026
 04:44:09 -0800 (PST)
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
 <av5CBjbeidUUWiLq@seanjc-mac.roam.internal> <av7bYb1geEGzaj8e@gremlin>
In-Reply-To: <av7bYb1geEGzaj8e@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 19 Nov 2026 12:43:32 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwzdsMKw2MFB9kpV=Xtm4JFpTbWRn0BOSwSB+x=RJhVMA@mail.gmail.com>
X-Gm-Features: AclHuK9ExBlvjAlpEcQpW7OIX1pR4w0klOAvsUXwgDHyVbn5Bw8uFWJCaQ8SOYE
Message-ID: <CA+EHjTwzdsMKw2MFB9kpV=Xtm4JFpTbWRn0BOSwSB+x=RJhVMA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's
 dirty ring is full
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Thu, 19 Nov 2026 11:18:48 +0000, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
[...]
> > > (note that it skips CSR, SBI also with a changed exit_reason).
> >
> > Ack.
>
> Probably worth referencing in commit msg I guess?

Will add one in v3.

Cheers,
/fuad
