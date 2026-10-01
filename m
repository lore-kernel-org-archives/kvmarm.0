Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C374FD270
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890455; cv=none; b=d3VJV5+Ij8mYNeTPXHtyAuXEqz7kyXdExKC2frOWuBGMnhBZKxui/19N+w0EoEBnBz8EHpU96T9nY8aT2mMSnru+SLqHtMw6WprblZyj2emmEYYEguyJk/HW1eJz4kjY5uE5/2G7Xjrzghk2M3qCuK2xSyFRuFSihslOxmCxkVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890455; c=relaxed/simple;
	bh=bZc4ogm5/WT7GTGjXs62z4TP6S2W3GOrNVtANWpbLNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OtoutFAfRK0XzAkYtHLsMxaeOqd5KAzqWHxlUY8+IhvHlnZuAuVaDzm+DPC5WgSd8TkwPGW8CkaUnyQIp2R2vEKPOlrUaF5Xa8f+itZX6+YnsIlsWVfg4zg6KzBFjWJ+wLbAXFZPK95vJk27T7gRfeDtPvXqTCsauCZ7GAwoI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gfu9YmXF; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gfu9YmXF"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c734afb8deso11389731b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 14:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790890451; x=1791495251; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bZc4ogm5/WT7GTGjXs62z4TP6S2W3GOrNVtANWpbLNc=;
        b=Gfu9YmXFJajubFtz0fw4CTVYXb7UiDyMYjAM0dwFRBUIHw/LYEcgGQ6/Xf8QaIl12w
         5NCRgoUppER3u7KGrTvbcNYyX4P/SLlcqXOQgDaEq7YoHzkdob7j/UfiCz8C9hT+2rG0
         wkyNfYfG1C7Fjeuf8mcU462AfYaNeBp9AifChtQViFIQOAkJn7QqRMi6brgZ//m9rb+h
         J/bAKIf1AaPkf9q8AIfjINWEIzo072jy4VEScOO8dFjyLVPyZFGZr8p//X1mYClX2Khu
         /snRCRmQyj91T3iGmH7h9U29DY+gPf++dVyrMIKo4/wrncFo/kLR/jHb7QAHyE7ZfBIs
         oGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790890451; x=1791495251;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZc4ogm5/WT7GTGjXs62z4TP6S2W3GOrNVtANWpbLNc=;
        b=WR5trrnq9JkL28tdpa1+mZVa3fstIdTb9LXY5rD9E5m4ZGXYu6QufBut4cdvJ3Rhf5
         fEHMn3F2z3dFGY+elmtauiQiOBF4peESq5doPiw5vzCr/E69WOJATNK+AygqKDNrm01B
         zum6WXCaMYDWSwPAX6zh+WfhvuY53hSaIfU4Y5yawA3i/6EzEGW9C4igLxtfr78GR14R
         uq23iQphZInNGQqOt2rc+TOvvWIoBkhIgkTcvjDHCZA8D9Ifynk/JMU48VM7Mw2d2Wos
         xeeo4Ybf/UbbAf7hXAUKg2c/D1FReFV8KnsPAQ5aaeLv2dWK3L+WpH2jODjAfwq1vgOv
         LpHA==
X-Forwarded-Encrypted: i=1; AKwUvBz5+DlhCY9x/yhnkrRegxQeJqZ9DO7mhbHzoE9mcADuOr3hCelw1gE+b92ZGvagewZuF3am/50=@lists.linux.dev
X-Gm-Message-State: AFuF++nBI5yqnp51iYhJ2/YcXTVLrb29+CplqrHG5hNqnaO89T9nX4U0
	q+GZYmbLhdamdGkDK/yo4ON3CerrnoVCNWH6g5+K2PL+lZPjykKD25/5im0oKfhB2GWKz3/bbVz
	IfX4XE29Bskc8f0+l5ZtZTMtOPg==
X-Received: from iou20.prod.google.com ([2002:a05:6602:64d4:b0:9c7:5697:9ad7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1583:b0:4c5:12a4:ec8a with SMTP id 5614622812f47-4f52aa86098mr422937b6e.36.1790890450368;
 Thu, 01 Oct 2026 14:34:10 -0700 (PDT)
Date: Thu,  1 Oct 2026 21:34:09 +0000
In-Reply-To: <CAFEAcA9DYo3GW_59eZjsk1qL0--3amYd7ufPqt80O2qv=Qm_pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924173051.2117637-1-coltonlewis@google.com> <CAFEAcA9Rwrffx8bYiOxrtQGdg31QAz1oBm8okzpfqHZ6yK0Y7A@mail.gmail.com>
 <20260929212102.3659389-1-coltonlewis@google.com> <CAFEAcA9DYo3GW_59eZjsk1qL0--3amYd7ufPqt80O2qv=Qm_pw@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001213409.2090008-1-coltonlewis@google.com>
Subject: Re: [PATCH] target/arm: Enable KVM PMU partitioning and counter limit
From: Colton Lewis <coltonlewis@google.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Colton Lewis <coltonlewis@google.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	James Clark <james.clark@linaro.org>, Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

On Wed, Sep 30, 2026 at 12:35:02PM +0100, Peter Maydell wrote:
> On Tue, 29 Sept 2026 at 22:21, Colton Lewis <coltonlewis@google.com> wrote:
> > For the counter limit property, would you prefer that it also live in
> > kvm_arm_add_vcpu_properties() as "kvm-pmu-num-counters" (KVM-only), or
> > keep "pmu-num-counters" general so TCG can also use it to override
> > PMCR_EL0.N in reset_pmcr_el0?
>
> If it can reasonably easily be implemented (or potentially implemented)
> for TCG, then I guess the general name makes most sense.

Sounds good. I will keep "pmu-num-counters" general (and wire it up to
override PMCR_EL0.N for TCG as well) and move the partitioning toggle
into kvm_arm_add_vcpu_properties() as "kvm-pmu-partition" in RFC v2.

Thanks,
Colton
