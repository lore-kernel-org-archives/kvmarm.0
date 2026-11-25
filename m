Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598328;
	b=rGd4vcsFAspcDU40r8JeGwV+PPjDs7l2zk1ZBaNZR2Qj/OebDH5jXt1qBngUyZKOE74h
	 y2CE1t+9vBpLpvr8uGw3v9bRbSIsYEBq/A5KYQGUiM0qjC/XtNa4Yh+YhUcfeeAqq8s34
	 ZveiB/nb1BbEmm6FUE2u8WnrXtmkHt0JuCUnQtElGpOLNQ1SRY/bwJdAlpxotfn2YyRxl
	 qj20+Ikb+0QG4iqSNvGhqbOsanxuu3TQTVzvn3PV6/Fm7EhdfkFTd9l4s6z5uVzU44a1N
	 CbT7cmt0hR0jTa3QUzl4HJJxvuuZyMedYPIiSamNuIiXTeHG1gjPDvSCBoqhJN2yu6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598328;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7h2E6/RXXaN8qvTmARnXOrgPNEtAf1zGpXXBrvYlAFw=;
	b=EGZMDMnKak/EcyT0iZY4SW3+vcvcwvrWN2OiwwYbH8SntbaPuG6Hu/40SXIBrqADmPGr
	 uUA0G+E1z5yyY4S+f0ufiqBjzpW60M2dHJLKIRAjjkzxyL3SgqheBcw6DS8G4qoGVnq37
	 snC6GoinrYsS8gMhg2/6u29CmpmXVbkmvuTuvRZZwzdSUaxoUT1rqhKDX5fNKUbejkltJ
	 gHVpjLjma10iAFKoanMpSELKBxYYtvlq/459leo9AxqA1RFWYpzseH4eU33L/U011P3BP
	 2HS+LkrYQROWsD+J2TUUmj7gP66nivaWabqywrmoAT2uXb5fJojwSNS/BI36+DZwxrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Z7bJbGjC;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9E3606A33D
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:18:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D9E3606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Z7bJbGjC
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so50344975e9.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 01:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795598326; x=1796203126; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7h2E6/RXXaN8qvTmARnXOrgPNEtAf1zGpXXBrvYlAFw=;
        b=Z7bJbGjCHkHBzkUx2zIJuL3zEa/VxjXh8ZarU6lAURfzL+2N3BKxwcx0zfUZg0xQyO
         XNev0KjmzCFvIhmW1egJFNIKUxJQOK3R0tnTWS3D/gLUABIgS+pVy00nLfteRb0TqCU+
         26zjmaIRbKf3xLCYWsnvD49QYg+QAgwxn5VvqG4TSvRqHlGo4T97GC1RYAMXjXY7J+4r
         dSQFq2099gzdP9nn/7+gYJotOzKGgp9ox4ZjRMVkyD6W8cnY+nSWNN7EqnOfsg7+T9Nd
         O8jMaFujlxciVu+jRQT0NWX+vaL2eV7IMlKXwBKL0P+Z5Un3T5kxgorEYIQta+OVfe9Z
         et5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795598326; x=1796203126;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7h2E6/RXXaN8qvTmARnXOrgPNEtAf1zGpXXBrvYlAFw=;
        b=vU/YTF5TRCqJLebYpkBjZxdhaAkbtbFoJWUSg3BGsmeTphpTvlFHVUB4zCE29YEZtQ
         pvluleX2S08BS0NEq3po1QTpsP4Bf0GcaCeTmb3EnnXL/wOfjSZ3JHrSCVB7EwODI/DW
         pOZlE6Vr3yCEvQ8NJqFB3OlWIkDT2zjEH3BCU8rbR+VOPPkUUgHtwF4JWd7pIbN3WQQa
         fFBn3MSkwD6J/PV+XgTaCei1MLKRQDHzcyC0nMOj1o9XzgB4U44MAFsIGO3BR/i0MuaA
         mWkBSe/YXBeX7mU4augAwgDZdBx5xZUx/gmGF5IO36FraK3beI7nAry20haJYTMk1ZQX
         PRyg==
X-Gm-Message-State: APuU4Z+p/pifoxqvuwKGGgaEiMmOAED5l644yqy4ecFVI5Fw3+NFJuR2
	cTbnWizsi4u3KP20tiZhYNDbzQD3b0SmHwEho/H69MPzk9XDUIVhexGbXuB5eo6grsw=
X-Gm-Gg: AZFdTZcY+PsDC7T2jqO9mhLzcewhA0mb6xp4ZRKuaWDsT/hXRkTCW31koWkkUTCq22R
	yA4HSaiJ4qS6xI7Tcej6lalkJ4TGZMAt8xk6M6Epi3JF1fVQfRBpFjSKp9HwkiPEcBJR4q0n813
	DldLXS2GT/8+w3AVPVdut173ST3uGEY80J/qZsKNTwADw2KTaj38NDnq9cPerYhw7LDjpm46R9n
	gAraXVXnNBK3QQDB8NAgj6J5PNr+BEAcy8RGrG5tDHHXu8JVVT5Um/trBSe6hMIIz7NggBDH7wG
	hlFbmyd83TTORADcHPKrJdxUbEgi5HMjDQZp8bryiqwAENmZB6XO4DTh0IslxGZWpoMfHeSAcW1
	6mqg7jC78vH32ZQhpqJnNhBVuB8eKjGU0vezWeNdAiNku9FA9fkt3m0AwXRKyOl3Bm4WXlKexQ+
	k8ltzsVfOILRbrJgSW5MgomOGxFJWfyYDARn8M8L19Rvz3AM79ljLguBMfM5WNzTJnd6fTZ0AEw
	kyqjEODv3pLm5C1dnfCGXOoToqcOEFzDpzhWjBAFscz2u2KZ3OKPz5O6b9Nvor++9atsd4/hYqd
	2TyyB8s1aVOc07/L3oY=
X-Received: by 2002:a05:600c:3b1a:b0:4bb:875b:3d91 with SMTP id 5b1f17b1804b1-4bb88820bfamr364901185e9.30.1795598326473;
        Wed, 25 Nov 2026 01:18:46 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b34e9c3ffesm16850149f8f.19.2026.11.25.01.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:18:45 -0800 (PST)
Date: Wed, 25 Nov 2026 12:18:42 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-s390@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
Message-ID: <awan8mSx5cbzXzJ7@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
 <sashiko-outbox-232760@kernel.org>
 <awam4std0Zifdn9k@stanley.mountain>
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
In-Reply-To: <awam4std0Zifdn9k@stanley.mountain>

On Wed, Nov 25, 2026 at 12:14:10PM +0300, Dan Carpenter wrote:
> Let me add the s390 maintainers to the CC list.
> 
> I considered doing it the way Sashiko suggests but s390 doesn't have the
> __vcpu_assign_sys_reg() helpers so it broke the build.  The registers are
> not the same so, either way, some of this is going to be specific to
> arm64.  But Sashiko is correct that s390 probably keeps a stale SP_EL1
> across a reset.  The s390 maintainers could probably take the selftest in
> patch 8 and modify it for s390.  :)
> 

Actually, never mind.  This can be done in kvm_reset_vcpu_core() like
Suzuki Poulose suggests.

regards,
dan carpenter
