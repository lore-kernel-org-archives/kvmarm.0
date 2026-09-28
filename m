Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05AA4BD0E0
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612144; cv=none; b=Jqd1KCSWzzP8ZIChQYznIM5DbhrCh1hmczP8uydbewnw7R4yvutgYmjE9fQa/lbz7nNqjsqXkUWY50MvttSejKC0W6spn8fNAqbmQEAryBWbZyQsvLb1+RqkFYf5Z+ZZYM17MgeqbQut8CxNFUc0rKvRfw5KzZuxQRzDqtkmmRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612144; c=relaxed/simple;
	bh=c06SVugHWJJNDeT83SdkPtIHJEt16Y1SGd4fojskXEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KV/HZGbk0WzO54EorS42lUVVwV93IuSHz6SH85wMS8mAQSVGlLzHxLLZCy1SF2IYYDX+A1TSmMTEL6GUe2mJa/EEddw1UhGdpyoYOchR87XZk9AJXDufJRiDAcNtgGk6LybmfbKP617ezOh3vafjSqJdjCEwq0GPkUbwap5H4+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vKluE1yj; arc=none smtp.client-ip=91.218.175.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vKluE1yj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=c06SVugHWJJNDeT83SdkPtIHJEt16Y1SGd4fojskXEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790612134; v=1; x=1791216934;
 b=vKluE1yjdGr+r63jTd2Z5NMfzdedKowkOL8KxBqleTza0glCdut4v4F5iYoDrXrlaIE/4VUb
 VQIdGCiAax8It5F2ChRL9ILVuxjFUtruH7PSD7Sx5yLip2njcAgO/00nviDUw9o7GqB3NDC0Ndc
 m/joe0oB1pXyw6nIq4qYAt68=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5bfebf2c2ae7ea9f;
	Mon, 28 Sep 2026 16:15:34 +0000
X-Mizu-Trace-ID: 5bfebf2c2ae7ea9f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b8ea0ca5baso11813e87.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:15:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBygAiY5YWADOm1FDAt8SQgBlb2lzXjIhrdM8UZ2qImheanQlAbfS8zny5+ItBTs/epJ7AlruSE=@lists.linux.dev
X-Gm-Message-State: AFq9FYKR+PXGgmbPazLkJdNceB0bjzKdLiVFYg0w8q0D6xuv6ShtqLNN
	+WrilMU3zIpLgoirh1RIH8C+Rg6sOB5S0hL2ce8UwEZHIIWKenVsGu+bH4lCj7hFmcb0Fxr+hnE
	jwDvXydGT2RzCVRSl0a6lZfFqZe0E2hJZyt2SPqRE
X-Received: by 2002:a05:6512:220c:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b8ef277c63mr220456e87.8.1790612128596; Mon, 28 Sep 2026
 09:15:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
 <20260928152507.2116110-2-fuad.tabba@linux.dev> <arqNu0rSxIz4-Mue@kernel.org>
In-Reply-To: <arqNu0rSxIz4-Mue@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 17:14:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwiqsvxXV7fm8emQHWW7qYrQ79J4V+5Erot5Df2=YaLXQ@mail.gmail.com>
X-Gm-Features: AclHuK89NS8J3Mx20bby02ytOoblOsUcBV9_SKsrfeTNez43AkDgos1HN6Dw7f0
Message-ID: <CA+EHjTwiqsvxXV7fm8emQHWW7qYrQ79J4V+5Erot5Df2=YaLXQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] KVM: arm64: Don't WARN on SMCCC filter reserved
 range allocation failure
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Karl Mehltretter <kmehltretter@gmail.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 28 Sep 2026 16:54:35 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Eh, the warn is still useful. You could potentially add a check for
> -ENOMEM but any other return value is a sign of something wrong in
> KVM.

Ack, I'll keep the WARN and exempt -ENOMEM in v2 (or the new series
this becomes part of).

Cheers,
/fuad
