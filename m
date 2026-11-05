Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.63
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876838;
	b=ePmv9o04HeegOHoWBFA62HIUuFwynK7zZemTSqBPw9bP/XRhrONxMHuT8YuEhW/3kXh3
	 6eMRmlLgVk4x+nOMN7xmGpm9lcoB2ZhdMLRukby/hjvfGM8EmPjH5qvJ6lSGQflXigJM7
	 KXBBVyXYlDeq4Hk2ymUBomek3AqaYlXjB012v+Yit9BAOuA1Lkis1sYzwSb39KVkKv3YF
	 sG4GG8maRMS3grX7NNIHU/F2Nd10Q1VAaz6QV0yJ42zS2Hdhh9zNh15TIsmIP6KlA4J3q
	 0JsL9Y4Lr3N/VMPCBe9l9ucoOBIW/uL7gfrnfKRWJShhRIF9rPDiy6I1Rsrgz5CBSnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876838;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ropK3m1T6/3AAvbHU3cjiTXYKF8W9vyhn7j6GYWwVws=;
	b=bfEbI1S80BQQkxT3gnwyqwXgkid9ua9o3xVhKOsKWTRt7gAY/NOTyOJferJKa5h4pE2Q
	 8S29eAYF80CeYIX/DcfjLUQUU7G4BgT/a0BNnRMlnNHcodn9AGqExmlrfwCHM9iBBZuDL
	 mVefyWNgRovtYVrnTPG7tPpGar8T42mbOvro6x7IkqZJxNfz2GwQzykVCVVMRHSFTUvzm
	 cC2rSK0OKwIfnxafhmCT4X9OnVmyivzmD+GAf20Prt8nJhjP3Fm6UdrYcvhIlQoYGEEGY
	 GFYMBQms/nwrhjwcqUVWVKzGuvKgP/Y5XW0IiEljrrOyM4sTWDbtCu4fnxVEFcqcVng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T2WIrlIO;
	arc=none smtp.remote-ip=91.218.175.63
Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E64606A32F
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 11:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20E64606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T2WIrlIO
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mxFi/NyYTfA8yYXfuMYDhLBMuAD3UI4RsO03kk+Phpo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793876835; v=1; x=1794481635;
 b=T2WIrlIOIDnNf47D6OdvjPvCVrBN2oBK1xqubZmKCzE2EmpB+G41yG2JOaZDNgmNlVWdVI/V
 vSACM6nVPjYNv7LrwUiuUkxkX0xycZ7i+hCamwIB3C5jiX8L/OTGomjVDZu3XQ3vbonAgTGXjRX
 deEt47Cu+cUUJKwzLWAda6yU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dec29cf7e218bf69;
	Thu, 05 Nov 2026 11:07:15 +0000
X-Mizu-Trace-ID: dec29cf7e218bf69
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so6152e87.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Nov 2026 03:07:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxa4EZcB887oEeOKgc5sIaK8GfPHYDJ6LHdDJLPCDONQpZLz80su0dZFhTDWf0sPQu7o47Fd7Q=@lists.linux.dev
X-Gm-Message-State: APuU4Z9SLirg5N00YIPDOtbvWzTvh9prO5z1OtVSfjPHU0+fP+NCAbh+
	k/AQruyo9M7PTDqrkz1wCmzycW1qNRyVFoGqsZXwEdrvGXFrhG7ccX1WgAfvNHGrlQQsUrIYT4b
	RAbZoaeMdAGNbeJgO+RzTMfl7Tfmybrmw7RJb3EOu
X-Received: by 2002:a05:6512:3095:b0:5bf:c3e1:532b with SMTP id
 2adb3069b0e04-5bffa4dbd87mr143654e87.5.1793876833801; Thu, 05 Nov 2026
 03:07:13 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
 <20261104124451.2148724-3-fuad.tabba@linux.dev> <auxQMCboC9bhfW7h@google.com>
In-Reply-To: <auxQMCboC9bhfW7h@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 5 Nov 2026 11:06:37 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzGijxFgv8Wr2DEGB82UUbA6HqK2n-JgNh2b-7jNHn1hQ@mail.gmail.com>
X-Gm-Features: AclHuK83MrhWtqS0VanllDqm6DgNhbZ5WWUV6AmGa7VFC3MdfNbrKHk581c5qiE
Message-ID: <CA+EHjTzGijxFgv8Wr2DEGB82UUbA6HqK2n-JgNh2b-7jNHn1hQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Resume a pKVM stage-2 teardown at the
 next mapping
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 09:45, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> > -     return addr + size;
> > +     /* Mappings left by a failed release are still in the tree, so look past the range. */
>
> Hum, not sure I understand that comment. Which release are we talking about? The
> _reclaim or _unshare? If yes, we don't propagate the error and WARN if any of
> them fails. So we don't expect any failure here and I'd say there's nothing
> special to do?
>
> Additionally, in any case, iter_first(addr + size) seems like the right thing to
> do and is self-explanatory.

Yes, a leftover mapping would be returned again from addr. But since
that already WARNs, I'll drop the comment.

> > +     mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr + size, U64_MAX);
> > +
> > +     return mapping ? gfn_to_gpa(mapping->gfn) : U64_MAX;
> >  }
> >
> >  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> > --
> > 2.47.3
> >
>
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Thanks!
/fuad
