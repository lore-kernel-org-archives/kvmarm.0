Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE9C1E0DCB
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730148337; cv=none; b=itPaGCBu6bmfUNQKiDyZuVgduxzUErcmEb0h3PZAQdpf67B6Ar91IO/mNnysouTvTFqqWjZqLRnptL3Fd9Synj3I50sybGT5/RWrzzO01DvOPyYFf1pJ6sZKUmNxkwmBX5x/Gcs8H3MdFge/+lJpPZR+nAqSEN2AxmTLeLGO+l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730148337; c=relaxed/simple;
	bh=ZpZwPefGlLKwfRcQr9eo4d8WzScWyn0cUDZORUV6UrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pAXDyWwA7hjfjPXJMmAEC5tDNs+3Y9yRvOC7psKhGUpXSrKn1JLNNNl0sQyOgFZGkvKNm7EbA3vL4u4eKMYEBVHkY2V5AEeysLbMgoIBCwnfh9tHH3O6BwMUVTLdNu7JPWq8i/OxHeSETSboBnFLNWxQO0x/9xf8bStCEgxriyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OhcKXmtc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OhcKXmtc"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30b8fd4ca1so994660276.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 13:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730148334; x=1730753134; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xKuNSIYTBR1rDIPTuHwqfwMTGhTV2i8TmyskVsFOfO4=;
        b=OhcKXmtcJiKhVXjhXCZikoAP9Q0KfJjRJ8fWoF3e1oxID0DizrubQsrIbdZBdqf7Kl
         UnxVTIjqV/HXxNo3NQKf+gX8ze5Bjw/OPg7Kk9GxlAC6ubJOWPUapuzYc6n8kvTA1HiW
         fIllNIpkViWIzlfSBFU2k5XxG3wInOaKsEvcrn/JpTCJ1GJDy+OCk0LayYErsKc8Gtwm
         AtUW7f+7W5ikXvHIUCUEbUns4kzh1aG4Kcw4F2eXd3nBPpZA9qGpEa1CkXvQJktcgyyE
         DsFXPiafcUGFwV/Iyw3aPnCa/xbzeHVOKL2YHQlY+WX4q2lG404vCFP/4qkHtA/3Muly
         Yv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730148334; x=1730753134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKuNSIYTBR1rDIPTuHwqfwMTGhTV2i8TmyskVsFOfO4=;
        b=WBKm5/Ll4e0mkl4BOMR0ZksHTzoctAbDavmXxtRLDXRc24D58G0uyz9x9eFfNslhky
         m8rw1pC5xv/fek7f8sBcq00yi+xrv0J+7inxMe9HcAkFAFS4kOYRVJavKInWp8LtZueQ
         lLSzKvKLutJEME56LhVonza2hhn8iNgSiRmawalC4u63dSD/KLpHdQ7XDzDSE9nlqRuM
         +LC+TBestRKunxt+Ovu12WD5FM6+DjX7LAzPClj9mjgu3YHfbsBDIttBs4YsswBeyiEj
         HgOLYxjiVEAsZDmB75R/IyeJwnHkwnOpecyvSizPvV7boi8pUU86TjubH9lTHQDygzzP
         gYGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFqPBvkTXH7K6udeIM1dxWIho7i4msByZVjSVFVNJnat6s2RhqVgftwaTVphFyd00QIl8No/4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqRHFq7r0tUbDLJ7gu92bY90SmgPAEksZyk2ga65WasqlW6pdz
	jVewSW+FpV1PrQqKorv0C5eT9ixb+jD1iz0PMifyrsY7Bn3R94K9r+/TMUtNBsb8vSzcme7INCd
	T1g==
X-Google-Smtp-Source: AGHT+IHUv/Dlq02qbqz0gjBFFfL25anLHCsRNYQi4mL1loTc7X5gbHLuxRGm93NhBDNRsTac4zgpo4TCt0s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:d43:0:b0:e29:7454:a4da with SMTP id
 3f1490d57ef6-e3087a705fcmr7090276.4.1730148333867; Mon, 28 Oct 2024 13:45:33
 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:45:32 +0000
In-Reply-To: <CADrL8HUEwnP8e700y2XYDgVhhUJuj1UEJmd2NLdtZ1dV845DNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-10-seanjc@google.com>
 <CADrL8HUEwnP8e700y2XYDgVhhUJuj1UEJmd2NLdtZ1dV845DNw@mail.gmail.com>
Message-ID: <Zx_37E9QY_PfBaTB@google.com>
Subject: Re: [PATCH v3 09/14] KVM: sefltests: Explicitly include
 ucall_common.h in mmu_stress_test.c
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+lists

Unless there is a good reason for off-list communication, please keep the Cc
list intact when responding, even for trivialities.

On Mon, Oct 28, 2024, James Houghton wrote:
> BTW, there is a typo in the shortlog: "sefltests". Guessing you've
> noticed that already.

I had not.  Thanks for the eyeballs!
