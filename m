Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9083BBFAD
	for <kvmarm@lists.linux.dev>; Sun, 30 Aug 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788114553; cv=none; b=c8OY/saHtYVPeCiOCBvd2hdVJuEdQviZGyWnD7FrwWX01ViMNDiFr3u1AJOl/SRdneA/ZfQyiaqrkKoDaB1mRA+GiMqn6iPg3G3mfC/ZKRdXmbY6wIrpqBTsYkuzt+JLzdLAs9UrVHdlsSDEITWw/acqFI86ZpvdpJcBE426jjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788114553; c=relaxed/simple;
	bh=9NKDnSEWfPvKPtUsA/Wf/uYwNlKYFsZ8Y0VhVrZy9KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8CFSCYOfk0NBnlltu5AHtD7BRlWKZnb2ILcrHn6v4brqB3l/X9GMsoCXyh/ZRgu/+cV/9AOEKqHJZK3/TB0f8o7ISPbP6OcDoY1ldN0yDOX0AxSdki8P5+QQTAiHsawiayNlXpAlX9PK5CaBrdfDrJKXedKoIf2ubKQzyIgWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHg43heT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHg43heT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so25812535e9.1
        for <kvmarm@lists.linux.dev>; Sun, 30 Aug 2026 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788114550; x=1788719350; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Ptf7lkzRK2cEQa7tXSLbtyDvUDpbM17dkTmOc5wvcM=;
        b=UHg43heTD5cFV+GOoznh9rNGemORuRuOWJwiWVX7DD1hDdB+dtKbwyu0UYxBbqM/Ax
         QzgYg0T7AJCT+RwGsHZ0KRcYdYrui89R1CXqnMVEnAiq1spHIT000fM3OcSwCZ8a8wBe
         s3+3GR1OknfDc+xUqFyDgVVLu5qS3r/T6IX/fDuaBBDGrA8gPkIrz8qqLJtpJPZ6NA0p
         sE/obJmzBf+ybKH1WQAWshy4AKT0dVaorbhG+6b86D5IdSM/a8y/lNGPp7YFeucQPdOS
         CxKikcTYW/MCKXY3+dHJoaudN9XOKDzMhEKhjvkYyfG2nIqB3vuW+v+zJ/NyYPrSplkq
         vcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788114550; x=1788719350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3Ptf7lkzRK2cEQa7tXSLbtyDvUDpbM17dkTmOc5wvcM=;
        b=ovo1tW3DbBfGLA6/1Qwn011kNy7UU8SzOx0vqPWermfrDzGPxOnlDre3H0Jbq4Izw8
         w7PtcGI3FiCi+RHj7k04RSrUb3itoG6Xv0slQ7tVVrGPGjEtCbsLzbaFvTshxNSx7bzq
         rcYChKwj0XcQs7mP1x/PdfthiLCTDQ5Pv3IoudR7GVn4iTEHa+MApJNAoLRs48RcR8Cr
         9uJ1QVhnKo4YHpZf0q7EplQAfVfOH2VQLzyDkndKeI15ZVvjoHWMFuLrhTW4cJCHbmG+
         WlGxnvw1xGTN2RQNIkuL0X6X9kAyCHNCPpP7PjdKPNegt/s7YdEfaG3x024TbrSEmbkn
         NKhw==
X-Forwarded-Encrypted: i=1; AHgh+Rpxp5YYd2jJwi24X8UfeljbX7isBiM+NoXFjJV+PfFQMu00tPtXhdkT3gAnCiFV2pqqtQpo3T0=@lists.linux.dev
X-Gm-Message-State: AFuF++nSfGEWK+6MZLyu8I6J38rqwEM31cE+K0GkE1VRntrdu78fyXvN
	nVsnMT+BP7rHUV1RqEFIbuktJXxxE1k0Gd2LoR8bVQ7B03ZVRmhosRn+
X-Gm-Gg: AR+sD10FmDMLJfJwpxO+YEi3po3jrBFHEjRvTt4H5l5VcxwRMBN1bjvhQS0Ri3srXMw
	9OFqfEyQwY1Wsyd+zH/5Fv5KXdCkh34h9aMChYiYlh8bn/U4lZegPXWVRq0676msDu94Vl/P9Fw
	Rjihw1hBBFiQG4q1zM/YEAKvQA1UX/unhFW77JlIGWyiSeRVoNiHgMLcXPKiOi8Lyd3ep+dvuac
	BlwwmTPqTmqlTvFhfbWqRwv2qJEEa3wcnrp0K66vspWr2WWwK5kNgSZ6s2qK8SUa4a8qW/go11z
	54qcGWWzhwCn5V8wblFKmbxa38m78ANs//RgdDA2QMWWQ8JmQKRF7wzil0BAO6S3FOjdvMg8Giv
	1CYmAVowB02NLBRIQs8lVa684WlIIGjEW4FydD2Er6g1PjgfmGXpjRxyaMqOAkTs9Rjv8neu+VA
	c6t/EuTOat/mynfLHvmYrXwwQoYSiKN1m+JXzD7MIpKoumBAPxrxxSwvlcdkXlKr99FluCAbUWn
	YT/H1tFnc2uGi+C+DjfK6HHLUmuaJAo9tGNvVN3jUkBhMl7yCaOuf8V5SvoUeCiCKsIFvzc3tQ3
	++TBpJVCaBtljATcWBVOeWb7LvxgZC1BNTzX/YY8AMbNLMl1vrWr0cawM4zG2AOMyKBtk9vMJAT
	YpfxGQM7/0s4=
X-Received: by 2002:a05:600c:4744:b0:499:8b13:3a98 with SMTP id 5b1f17b1804b1-49b91c2479amr317299235e9.4.1788114549893;
        Sun, 30 Aug 2026 11:29:09 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-adda-dc01-edc7-8a6f-c6f3-73e0.310.pool.telefonica.de. [2a02:3100:adda:dc01:edc7:8a6f:c6f3:73e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b961939ddsm102089915e9.4.2026.08.30.11.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 11:29:09 -0700 (PDT)
Date: Sun, 30 Aug 2026 20:29:07 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 0/5] KVM: arm64: fix VGICv3 redistributor rollback
Message-ID: <apR2SFrwBa9tCS5y@gmail.com>
References: <20260822095346.53882-1-kmehltretter@gmail.com>
 <87zey4m2qy.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zey4m2qy.wl-maz@kernel.org>

On Sun, Aug 30, 2026 at 09:28:05AM +0100, Marc Zyngier wrote:
> I really don't understand why this is such a massive departure from
> v2, which was pretty close to what I wanted to see.
> 
> Honestly, you are making things harder for everyone by over-designing
> (or more probably under-filtering) things that should be *fixes*, and
> just that.
> 
> If you want to rework all of the vgic init/destroy, fine by me. Do
> that as a separate series. But for fixes that carry a Cc stable and
> require backporting to 6 year old kernels, that's not on.
> 
> The hack below is what I have against your v2 to make it acceptable.

Okay, thanks. I’ll adapt your suggestion and send a much more minimal v4.

Karl
