Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604758;
	b=EVoQMqIywFGUsOoY9smuyOypbn9xDA1rOJwR0jT00GQMZIBdRSZvoH0PWcXn/GAt1v+X
	 q8oKJ/e813RZuRk6z0OmaMUjTtqw58JcdqBf+oGJjYDGV+P5nrdq7VMd0KA72Djoe4Qyn
	 agRjkAUTiLX7tg0Y4m/Ch6Fl2mTWyxRWGwOT17B3wYwxaW5F53+hnjU5AE0oS6/CeXKBs
	 IyVO/na6lzRPGR9yBGMvr31dKEMBn2JF02isekPLk1LsDy06e2umxLKtUCtATP3NN3JxH
	 KDeVElV4NgouqL8o/0RWIexOZFrygm3AZTzpV9RffXak/cKg+iBZniqb1Z1I45tkcrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604758;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=oS2GSG0gTbNBdIcy/EYt/+8Op7NtDzRF0d79hf39B2Y=;
	b=mvaL71vgCKiwA269BxbL0oZjoKATXbxH82+vbOobmDGR/1bJsR4Cm1iZPkxw910B+Dgg
	 SM5EOw7xhPaV8x8YdlUIKbB3wkSgOWIxF7wHqh/0rPEqQhEjFzVrevS7Gtr1TDF8lCUE9
	 kFWl09o5V4tF/daFNpJ6IfsfduBex8QvYGGHeNpwza9+DVKNknxM2v5Oje/6epZBd6uOt
	 lrEYRO1BgVwfgkHjZ/eo64I7ifkci0B3KYoeavwiqDBMmhkqsYfNr3pTsuyCYIp5DQdm8
	 P9H/WSIBOxwShtNx+96jXcgaK9p/+0R9IUB5wGV5FDgUG3yDo5n/J8F9ewfFnn1l1OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ZiLoNCI3;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD769606A333
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 11:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD769606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=ZiLoNCI3
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4ac08f4a0b2so3963602f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 03:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795604756; x=1796209556; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oS2GSG0gTbNBdIcy/EYt/+8Op7NtDzRF0d79hf39B2Y=;
        b=ZiLoNCI3vO7e03Ce6enupaLbQEjPd7/V2CGlrieSFvMF4fMA3qvMiykEH6+G78YcxC
         PxvxIM9LDL5YYg34uyiMFh6V3gX3KpXok0ADHibfyi0CTzKUS4AdxF5GZOzbS8SW0IUn
         XHIb+bfD3hTjGOwwF9ojseSdXsluYASM+o0ljpnvyZefLcrsDV++c1YrGi2k1xKakunE
         Uqt0Leo+RWOjY92izypNiDaNWm/6EVFY9SU8Y9MEDrPFhD7eo/oH9pSnro1CmFUrVaNP
         aFVkOgOFzZab21Pnc7x6krlqsCtyaYif9JoF4kUCiJTicG7d/K3LWWLlHmkKUt4AVHAI
         wQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795604756; x=1796209556;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oS2GSG0gTbNBdIcy/EYt/+8Op7NtDzRF0d79hf39B2Y=;
        b=dhnCXMkaCaz1i5bORa7Uw6WsfMz/ZYisbQKkKvKDaGm0HaPAADCPSTvDsCLOB5pytK
         OdYYW2bv70KdJUEeVe57SrWhAl1JrCUF0SweuW5yS34ZEw/gXHLPJYdGI5NNuw2U3enw
         mge1QE/z27we3h6T4Sp8gY82dcyGlU+IiAB01ZNbQ/EzbtAHaGx7QJLothFNuYzNE1Z/
         fECTcnrm6GC3QAK5JCKtn/6OjS1rb39xaBGqGkocTfjbJ7J/UBnMn6it6fiGrBrlcXFo
         Hymchnrgeqleq2D3xXWe1ukv9ANBY1Svd7dY0EPaWKRHesuYGulZu5UCIYPD/7NcqmsQ
         lsyw==
X-Gm-Message-State: APuU4Z+R/5QQa8EpOu0lVgirkb5WJRLC/tmujh6XRyUPLRLsnU7FU575
	2I2BsTtiaDsO4Jqfh3gTRCCZyFCmUhZHP0oW+x8/T+2dg5LHQNUEu7vxrw4IE0Mnojc=
X-Gm-Gg: AZFdTZeOsiaZ7CRMvOH2ymrEUzzyqS+zK5WdvNeJgd18HiqsZNaIAJBqB5qqy2ZcGrC
	ArgQz3pofqp0ZuBGoZpilJsXn0MIL1uAyJnalM9pPAbjOCKNRxuClXF+cRmGgnC8v89r2u8Y9jJ
	orXz4gdDiQ8ri67/ySUvf5vsjBZNkhOjEZO0RWWxIQ9FkTa0ad4sfvLoYrqkIrxXFcCovcAjHJU
	UK3dPn28xd1BLftBG17F+MwIAUagqQ66f5U+3HzuGstNK9R9bDcT5NxHfkZerdsQ4MQ9Sxan+E8
	jlDEDT+V7tD7UZfOZC6w9miM9pRfoGXdmRbOMCdSJ44zrc6lsfHZGqBquHcM++ZFm2APU6sF2Ft
	gsh6psRlg4FqmVpViRFMz+eNSzPjJxRWNkkODTz/DR4g6mjJG+nZUudFixY/tWsXEUfggUCKWgt
	wmtym7UQSeRz6QHWKFNVV92sSzCgUD6nhaGo+aa10w01NTNmAV5uXL0AtIX7E5Htf08f1tS5teF
	x5xcLcG4S39pmoDMi2dc0dmbKA5u3uoYq4FyBYoGXHvHImJhk15aBFpZiPtTAOJ0PBXC7HqmhXJ
	pJuErhzPe/WwjTHKtvI=
X-Received: by 2002:a05:6000:990:b0:493:ec0:861c with SMTP id ffacd0b85a97d-4abb0c5d53fmr32529130f8f.16.1795604756007;
        Wed, 25 Nov 2026 03:05:56 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b2c9sm34833647f8f.31.2026.11.25.03.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 03:05:55 -0800 (PST)
Date: Wed, 25 Nov 2026 14:05:51 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 6/8] KVM: arm64: nv: Don't deliver a pending SError to
 the wrong guest
Message-ID: <awbBD_8rLYZ9aJTK@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
 <sashiko-outbox-232776@kernel.org>
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
In-Reply-To: <sashiko-outbox-232776@kernel.org>

On Wed, Nov 25, 2026 at 07:24:38AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] KVM: arm64: nv: sleeping in atomic context via
>   kvm_nested_flush_hwstate()
> --

This is an existing bug but my patchset makes it worse.

I didn't have CONFIG_DEBUG_ATOMIC_SLEEP enabled when I tested my patch
but I have enabled it now (although it wouldn't have caught the bug
anyway).

Claude says Smatch probably would have caught this bug, but I haven't
been rebuilding the cross function DB since I started using AI for
static analysis...  I guess I will do that again.

Anyway, I will also add checking for sleeping in atomic to the standard
review.

regards,
dan carpenter


