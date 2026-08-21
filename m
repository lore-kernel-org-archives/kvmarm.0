Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B81F37C92D
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787339378; cv=none; b=T6+nOjlH1iFrHQUMCWDz6Tb3lHAPQ+X/Phh/Pn+MDee7mloXLGuveBN/MJ7TAXMD5UP3tDI4HRReZJtE0VjkoHwMMOMAVLIA18NBHTJtw5fL9qKt4/OEZ67ygNX+kac/SuIku9U7JhShh+sWz5LW1GsPaRTTF5+WLHmUsRZcitU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787339378; c=relaxed/simple;
	bh=m4AbHNYOybKycCffk+1NRelRi+xxrvqfKKYJ+6qV4UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9T8ydLmxuNqNy/lcArbzGty3foRvKhgDqviSzQP50QAWJUJiPXLVbmXIn5QA17NVFky/4Fs/OeL1saCiBEKHTByx1JLSOhJSbFobcDHdqiWjvkBIHxJJ+EOMGHtTVKMpnDD8AowHbEKhgvHWROiuHsPD2m6+dziI28Ss/6x0Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qpbgJFB3; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpbgJFB3"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c214e625259so196947766b.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787339375; x=1787944175; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m4AbHNYOybKycCffk+1NRelRi+xxrvqfKKYJ+6qV4UY=;
        b=qpbgJFB3WGPckK2Yx7R9rhrzJhvh96BLvf8jWXp6R3AIHg4yIj4z2tcSZgrMY62gPu
         8QH2Y+dqJXhI9nc7DOVOGwlHmr76m1N8lL/37YCLLleN1d82iRGTOBKLcbkKNkYFa6yy
         073brxrmvGmHuPqvTZQkIK3MrOtkC/i+B5PrRsDZpX6nBRhv6346xU5E47APMMuG2+hG
         AjC4zfnmJ9f5NIYcUSCAnuaH1wlB7wF0xnXFqYe4BRHezv/w+v9D9ZGTK+cTCgXFiyWn
         QpKXyHJO4mb/DTKjMdz6DW01QqNBM8rTrShJWrLks8qx7uyRKgTBHBsGqMgLO8v1e/N5
         UT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787339375; x=1787944175;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m4AbHNYOybKycCffk+1NRelRi+xxrvqfKKYJ+6qV4UY=;
        b=NPO13kiSHP+o9ykfcS+wi2czYnLg/E/KIkTehGkQwEmiP1xuZcWKKuRy6h0O38ReY9
         wdnNsydRiYdZrFMhyl6ccTBQR9Zrs7gRl9xYNcPz2+IpbS640Ro9NRffIshc74j/pHd2
         C6tb7/XIzOeHCfEFYiwqs8K/tQ8iCbY+0UKmI1av9LH0WJvZ3dTJiEURmnAEsq5rB/O4
         sQgYvGBNwFhYujSHI3IuKgNLFlshyKHxAZuRpuJ7tWN2iIPXEELDecKal9wsUxZ+Mpnn
         X7dmM3OsO3rU3ahSS+zw8dZxL09eY1RkRBNwK6VKhxNucCpw8WvTGnnHXQlS2Jdpt9yr
         pSUQ==
X-Forwarded-Encrypted: i=1; AHgh+RpxLehVQN1Ulgii5MHd60gdSeNsO54pZrq6l6NTcL3LEm3HnGAlZMk/13PP6ZwUpUsZhZr6XW8=@lists.linux.dev
X-Gm-Message-State: AFuF++lyVRz04m+xfZY57II5PYPRu0VxfQACRgGYohOduARJkJMCfLrg
	BkFsqCLxVlPa6au4JujKvj2OlG0xLaiLyNk+5XID8Cc5bGMLtybVMayG
X-Gm-Gg: AR+sD10n2ib4avOjdd3TZYfZRtRLcUgRMg9lHCpHggTu6A4JRb+eiSg6DbajXPUXais
	SZa8h1SIc6UiISaPzOqV04A+RRxxWglFhjUHcZ+1lorfNe0gIsLwDaqwdhram/cQ1ijgz3YXORq
	E8O0PACARlcNkavvq7e0Xc7N83GKxd8Yvb1FM7qAFmTFBp2tcNP9awPquZBE1m+ugrWSmN9v4bX
	qOh0adOg7cr7tut+IlexBnrDj24C0pTXi4r33u1som9V2921upLOQAtQ4vIGh+j2IBQCnK27Q0t
	t0G4D08D20QAOIvMZ+QLwr/NyZRU076ObBl9/V2+Mhvq4jtfL2ylR7UdAUKVqfSipfwYIRNMmSq
	ZwzCSUhf2U+EGlSCMDxqjRrsksPnqpHCKHNr3XUWjEuGnfaN8x64wHYOaADdViLxfSdgOgV+7uc
	DsyMPckjDiAAhGTya/Y36Maoq1U8YXW+3+Yh3bE4+eLVpD97uFdkMsTbTMZxQ9ZHX2yZ3vg/XSe
	7pWSqTwmN4zTJqac0l5QTXfPvrFKrw8LPKvC/SNhgVWcmdc3CcawOmXjmEjGZEmB0Ob5jqHJsLF
	2of4aP7XYgOtlrnFwGkAJbbuESUySBZj8WWd6TWiYx4VlEoBiDy4a51GbD3kdaMLXxc6NlR5E67
	6Zg==
X-Received: by 2002:a17:907:97d5:b0:c20:21be:ea75 with SMTP id a640c23a62f3a-c246a33ea8bmr796814866b.8.1787339375197;
        Fri, 21 Aug 2026 12:09:35 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a103-bf01-4ca5-89c5-9aa3-9754.310.pool.telefonica.de. [2a02:3100:a103:bf01:4ca5:89c5:9aa3:9754])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24589e2ab2sm584196866b.7.2026.08.21.12.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 12:09:34 -0700 (PDT)
Date: Fri, 21 Aug 2026 21:09:32 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: arm64: vgic-v3: Unregister redistributors
 before freeing regions
Message-ID: <aoiiHw4hBHB7C5uL@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
 <20260819224229.82948-4-kmehltretter@gmail.com>
 <874igpp3qm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874igpp3qm.wl-maz@kernel.org>

On Thu, Aug 20, 2026 at 09:58:57AM +0100, Marc Zyngier wrote:
> The other bit of interest is in __kvm_vgic_vcpu_destroy(), and its
> conditional removal of the RD iodevs. Can't we just get rid of this
> whole block altogether now that we have a saner failing path?

I tested removing that block.
It reintroduces the use-after-free fixed by ae8f8b376102
(“KVM: arm64: Unregister redistributor for failed vCPU creation”).

Karl
