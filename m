Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795600296;
	b=mBsKGIhdwgSeomXUFesho31vYv4l5mfW4xia+7LSc5p75OxJh7bjxy2GnaOp6tixBUnd
	 vbTKhYRylbgOdpZOPmA/O+EY+UNMghkieCdyDehVXflfgXaDrSLzEwf/JdLXcDxQfMw0j
	 a2KaLDIH0zA30zj/Hjl/xime0wjPZ26vgnoud7ybugyw84UeVtsmXWh8+fcq9mDjnBnNR
	 GDJML3bYW3AuiX1jgW9e0Y1+8duqeL22+5UKfWbA7d9GCvOMhooWkS6cfiibBEEtNJCBn
	 aohtLzgUJBUoMy3pp7yS6w4l2WQ9PL9nKI7GxqOAWvJG9LMOAkdgf/yge4eIhDycCPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795600296;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ExEdfB9WwLHoUe7nHSiClkfqem+8Ndsrh2CmQFmZ+3c=;
	b=plpu4RtQDeKdO0SQ27YblX+LnpcK8uo0VJxaE6XDlAPjVm6iFop6anW3GvAluYHSt4JU
	 Kw/QNCOPYOmV7zzOhK4CvD4i1dfAPPByNdPCscTyOPvz/S0sx9/RwhV55ksyPk9X6Sm2c
	 hr+mgdzO1EHXIorei3e1rAxz2omszHp7jtU2mn+Pd4JDrMSZbQ8QUQ0b5K7LGGEC0RxOE
	 F0pGuwxwX2QkRnQnytoHA5jahQAyTBcWSKK3QZtYgbPKC2cpSiD7YFqpsF3XWVRdruLw0
	 wLOVPVkpqBccmVUlYtDkiAXL5GTfVExdOVjOOXu9OuIkVWE1HxVvUyoUQkNLM4bg0iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LkoI54Oa;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512E8606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 512E8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LkoI54Oa
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so4256554f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 01:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795600295; x=1796205095; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ExEdfB9WwLHoUe7nHSiClkfqem+8Ndsrh2CmQFmZ+3c=;
        b=LkoI54OaNo4gu0uKHA5sT9y7/wWRxnUphk72JawVA23Us+PsDkmfYl9MQyUYMnI8iI
         j3XrQhKufseSttKmoUZdLXlcutV0vLperFno257Uw67rucikcXzdr7bLMvY0TGDyBhPE
         Yf1sLeSIeNfcUdZkwWfPvJhXX98h7l+5v1lOW74HEgUq6uTsZW27gOvWbW6x/y0cxiSx
         apL2WMx+cjX0Eijb7Y0NIeJMQ/9e2xLCCPYc4hheAsrohb3hgKMozHovwTKNIqGsKwFk
         Ymcpy4yBmFBCNCHDOtlp5TIqREIyev9hgXax4xanXLAYbsTzO4jiktKYt7pb1A6pAEOz
         KM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600295; x=1796205095;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ExEdfB9WwLHoUe7nHSiClkfqem+8Ndsrh2CmQFmZ+3c=;
        b=nHPJ3Jx6ouTfET7Hi3kCehu1nz2nycwdaEcYtfFOpvKrNnb5WdHkc6cgvnBH/SYQJi
         bjX1AblYgxNqH9reiqNIlumoo8smcbANvO49ezQzo8dgAL02HSFdeN+k8xyO4QJoDa5x
         bcwItl7YL2O7BbkAeupPqZti3IRTxCbBbbt2+yVm3Djc+WhpLWFyCHpicE7QAY229T0b
         gPKlVBU0EZBF5SwtS5nXfb6NuB/mbwNQT6wfgpyftusXlt9FJ4IEfHGsukY5urdxR1E4
         HZrntJk4v5iNkHn4668u493gfCviqONLfX1bcG/Zb4DLtgdLJaFhg8B/UfwybQFNQbY4
         6r2g==
X-Forwarded-Encrypted: i=1; AL+hErGDnnelTw1yGFrIpTjYcTmkdDeRC1Ti5XWk2kkQJvmLpWaQCx6DJjnBbC71oOI2x78JdG5ZfUE=@lists.linux.dev
X-Gm-Message-State: APuU4Z/h5fcvUWNQfxOL7OiUlAXLM9ENHDQGgyW2iyZ81yiyn6c2zvaK
	ToVAVsfb1mh1jMot6dREXLDPJZRWw/CcUSrJ5IF1kYM+caQEvD1rOd8FhfjnAn75uR8=
X-Gm-Gg: AZFdTZcAc4TPMZZIaK4ii9Fnv5EXnQ/Vm5ArP/Gz7wMzXJgdq0QIMHmQfg1tMGM/p9o
	WYYeYrIsekpH8cPuYs0KMPZ1W7mHdez35kb+r6rKirB2xzxWVXG2t0gjwPJnu1Ksg+BEIuqkaS4
	RZFr0xcMgxD0EtmktWJGjAU9XW/6YMNwXXfQucswNizS0FNU2c5R2rXNc1a2BWekT9zE9AerxYJ
	cX2YuQJghFYuhIqMQFfz1xCo8LGi4RKIsulrlOhs2Nug+FF8HQjkskACsiaevLjTxcbaqyqrveJ
	/Qhu4ywIxHcdb43POQlS7l8wvWv7xONZLrIp79uv7GfzfYuNuNZzIMYbNuvbyGeJRy9nEc9Qlsj
	s8glXWRzBTb21Ajz60IX2+N33KV/0K+6KDCW+n3mGu45WfluVZTPvSHk2KWFCGMxAjoKB+VrXWO
	7mqDLVK7VpE2N4ibeNPEN4vWwGVNfEP8ZfP9p86oEpP9n4iIqPnf/ymuPwukQMjA080mHTGkTMj
	mcitYqkLdUmxDmFZ5F/m9/vgFUPH1v0xJburdVPdqol7ulKVKB3X26futfSmEWPH8WTqFoi0SV4
	ne7WlkTg7phLABUvz2M=
X-Received: by 2002:a05:6000:4617:b0:4a9:760f:1824 with SMTP id ffacd0b85a97d-4abb19c153bmr33040480f8f.21.1795600294485;
        Wed, 25 Nov 2026 01:51:34 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b8b7888sm32867213f8f.42.2026.11.25.01.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:51:34 -0800 (PST)
Date: Wed, 25 Nov 2026 12:51:30 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <c.dall@virtualopensystems.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 5/8] KVM: arm64: nv: Replace a pending SError when
 injecting a new one
Message-ID: <awavokPJT7G8J2fX@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-5-224689d8a764@pereq.eu>
 <awaVj0Aa6dMSksxX@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awaVj0Aa6dMSksxX@kernel.org>

On Wed, Nov 25, 2026 at 12:00:15AM -0800, Oliver Upton wrote:
> Hi Dan,
> 
> On Wed, Nov 25, 2026 at 09:56:20AM +0300, Dan Carpenter wrote:
> > The kvm_inject_serror_esr() function injects SErrors as the name
> > implies.  The bug is that it doesn't handle already pending errors
> > correctly in nested virtualization.
> > 
> > In vanilla KVM the kvm_inject_serror_esr() function always sets
> > the SError to pending.  However with nested KVM, it might set it
> > to pending or it might deliver the SError directly.  We can only
> > have one pending error at a time.  Imagine we enter the function
> > with an SError pending already.  In the current code if we decide
> > to pend the new error that's fine, everything works.  However if
> > we decide to deliver it directly then the pend flags should be
> > cleared but they are not.  So we deliver the SError directly and
> > then the SError that was pending on the next exit or entry.
> 
> I could use a bit more color on how we got here. From what I can tell
> this state is only possible if userspace changed the routing / masking
> of the SError outside the context of a KVM_RUN. Otherwise, if the SError
> is deliverable on guest exit we perform the injection prior to exiting
> to userspace.
> 

Yes, but the main reason is that I'm changing the way
kvm_nested_sync_hwstate() works in patch 7.  Now every stored SError
stays in NESTED_SERROR_PENDING across handle_exit() so this situation
will become more common.

I will include that in the commit message when I resend.

regards,
dan carpenter

