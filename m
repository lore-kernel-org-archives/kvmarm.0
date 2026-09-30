Received: from mail-yx2-f38.google.com (mail-yx2-f38.google.com [74.125.224.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE842AEEB
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768116; cv=pass; b=Zr20IjBA4l7hP8lPLTbiwgP2MIDUBm3qxLEMoho1NXJltMEiMjGuSN7rlXkiqQm9MckttDlSJufUxJQoek9nKt58eTHX8M7aMi8AF3FkhmiGYLTylcgjLEwz1x8ET2pnTQL4JvVnnCa7P74wui3wZKcGiOJLDVSPRa0HU5Tsug4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768116; c=relaxed/simple;
	bh=SeY6Z1jmk7ymRLBox8aezw1ZLI+jut6EQpLQBAspM3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J8kY9dtMW8c+AaBXMrwRRLHFzjf+78AD9qnqILMmpgxe+bi11Io9I8wmot0UZT9Lo1KdDF4iSyeI6HVjQBxDPP1ZxNzq1zruL1Z0TKJfFdk/sZgrz0jMmSch8TZUpkDLJOPi8zudEgEtCiTTKfbdJWDOf+oPyjk6eL65mxypx5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CgT7RmeG; arc=pass smtp.client-ip=74.125.224.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CgT7RmeG"
Received: by mail-yx2-f38.google.com with SMTP id 00721157ae682-8ac47074e38so2681617b3.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 04:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790768114; cv=none;
        d=google.com; s=arc-20260327;
        b=Dqg/vO0Ihcb7cd0QNovYjFdbmleqMHKnMlGfRvAH+0fvjCHssXh0NJq0qq7W0sJMcb
         WVh1IdlDth6BX3FB39VZz0p4sIUBIDmmGacBCv2aBNq7DedWVCBWYuPi3tw4C7HYKjoQ
         kpjb2RnUJGi4O99/WcMdDb9oIKq9btxweTjnEPn6i0fI+48LZjK2ym07FHVpYQr8E5kW
         z95VFAMlMlgPl17+KkQJBWH/C5nXEQBwgsCQh5RyZo7/Sp6wSZhW88GJ/KLUKsLuNiNB
         wtfzYN0S3+6QrrOaIMimdwesSn/ZBmFc2gSS3ku4mmIZVIRLe36fk/sQghnVpH8yNjOV
         RqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SeY6Z1jmk7ymRLBox8aezw1ZLI+jut6EQpLQBAspM3Y=;
        fh=qC2zI3EtmVc+YB98pA1e6rK/pIWZeseBh8OWQpfD7Tw=;
        b=gyPn0R5g4js3yMCYCB2WAoRGRZykpFHKhWLmw8Y98U2cTt2nYZ/z/4dL3JWgwtPK9y
         58POqVQDbqj82n1vp1bo70bUH/HZXyfjfl9bZ6dq9zqFWYBgeVd5SjFjl2yGtr0DtksQ
         JlRHLlBNLHYngYSbiHpYxOa+k8cPMPdmohjUtPJoNmxPm/teCo/TOOEQ+AYt0xZsoNKf
         yITkKqBnPfTlWVIOfr4ru3fPmC6vjnzzN1d/eJnvQ45jZv9WpkeoQzok0WdO4h1Jrt1F
         2m1LyxBJoIQvIL/3EWX7+VC0EfUHa1WxGfIkrsq89mK9JBi+87yNBply4XqJUr2s5YHF
         bdJQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790768114; x=1791372914; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SeY6Z1jmk7ymRLBox8aezw1ZLI+jut6EQpLQBAspM3Y=;
        b=CgT7RmeGTy0r6r/FfAZmtq2HHszOt2HcVMdBuiH0ycrOepxwSNPKQk1FNSJbvtFAoD
         p5paAGHK1OmLk/1XDwWjKEj593Twf0Fzvg5BubXqGuK/WyVEaHZn6JDdBL0MHmfpRpoS
         vzoXlsKSQHSEAWjQuJbVRVuR1v6AVLrHrLdwvBxdyIkuE+2lA4nIQ5BOnobaunW2wN9J
         WcLGvyfm8YPBoZMDnoyqHH2aT8bJN/2V0bYRjyT4c0aAMt9Vbmpl22e1xdXw+qGVUccS
         dXHuIcvPsVju+oG03u9S7NVtq0X2hw0jGQFpAaJeHBowvE4YpKcb+iDZWQlH3QNlYHJS
         43sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790768114; x=1791372914;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SeY6Z1jmk7ymRLBox8aezw1ZLI+jut6EQpLQBAspM3Y=;
        b=CvCPA75lVdT3J5XHvyb6QFTzLQCwncKi1PRJyYkDEhhrnouoQg868sAj/Dv/TQxD8n
         Z9Vfrdni786BjXOxsm/qjnXt7G70Qwpm9W5Y5mwXS1vryXC1BUSKXDgTao3WeZIdu4+M
         a3TcIevfDbCJ6YcylGMJm3P6HB19mUaRhZhwGHiAgi1Z1/cJFKsM0ZvaG3Ud+qvyEKXi
         fhIv7yird34l00KaMv6ncJUj6ydsgBAUtiHiP1eKxtulLB3eIKd1fVv/L8kCClVmlHMO
         L8T6pPiZqqY5IWu3eagXJvwj8aorwCLQoqA9QSbJMJC75zbxW0DgnFO3vrbGJUPZQhfR
         gGyw==
X-Forwarded-Encrypted: i=1; AKwUvBzwnQWIoly90+Rwem6jwRIDdagbzeBR1wisfScaLA1NaZIElcBJre+4GCqzzkphuNzudRQogBs=@lists.linux.dev
X-Gm-Message-State: AFq9FYKEJw4uSVn5/ZtJ779gT06HUbA1ofI8zxcjwyheLf/hrCopi4KC
	XKNe/H48h2xRvq7gBiKe7szd7MSALXxajZUGA1a4KTK0BJWkLHjC8H+krB3t4j3FoCayIF3f6E+
	fjIpekz0udNWnooaATG6bOERkPVE6Kf/JKdzFTogOWQ==
X-Gm-Gg: AYBFou1KgkEm5aT1Xa+9CY0nh+dEGxg+N5TOgTov9Xa2v7YDJBqKTUUor2IUJ1uzaff
	8tUueKLPzzhDbHpYoJgsFtrmqr1nObZ9bN6bJWZ7OvfksNbnOcGOV9aTXtc88HGiSDPSstr3aVo
	1skl4wDw2XJfD4ChxHr5jY3OhNhIcI984XwZFAasHTUNnJJ/ZU1BzBDuOH1bwSmDiK4zDnn2Bhq
	0ECVTLKns3TXqQ9KOmqtaV1QDTp8YBziHhgRvec5O19lO4+JLNU5fo3iF6+qJ4FwM/q6We8tqzP
	HqoHoZXQjJOz7h6rw61XaFWGA5seXIUxKlp9dJdjdnLeN3zes/OPZaDOHOebl7bd/BDXTGhBI5z
	FS0cSR1Dscz+7Lik4RYPQpFgTozE8tUG/z7QZuMI=
X-Received: by 2002:a05:690c:ec3:b0:885:cf67:95dd with SMTP id
 00721157ae682-8ac97909b55mr3191337b3.31.1790768114223; Wed, 30 Sep 2026
 04:35:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924173051.2117637-1-coltonlewis@google.com> <CAFEAcA9Rwrffx8bYiOxrtQGdg31QAz1oBm8okzpfqHZ6yK0Y7A@mail.gmail.com>
 <20260929212102.3659389-1-coltonlewis@google.com>
In-Reply-To: <20260929212102.3659389-1-coltonlewis@google.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 30 Sep 2026 12:35:02 +0100
X-Gm-Features: AclHuK8bFLv0KvzZpr3GNRdEy1zBXYO_hECfn1oR1UjooEwhow1ZvPDksGAca58
Message-ID: <CAFEAcA9DYo3GW_59eZjsk1qL0--3amYd7ufPqt80O2qv=Qm_pw@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Enable KVM PMU partitioning and counter limit
To: Colton Lewis <coltonlewis@google.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Will Deacon <will@kernel.org>, James Clark <james.clark@linaro.org>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Sept 2026 at 22:21, Colton Lewis <coltonlewis@google.com> wrote:
>
> Hi Peter,
>
> Thanks for reviewing!
>
> On Mon, Sep 28, 2026 at 03:01:32PM +0100, Peter Maydell wrote:
> > What should we do with these properties if we're not using KVM
> > (i.e. for TCG, hvf, etc) ?
>
> PMU partitioning is specific to KVM, so moving it into
> kvm_arm_add_vcpu_properties() (which is only called when kvm_enabled())
> and naming it "kvm-pmu-partition" per the KVM VCPU Features convention
> in docs/system/arm/cpu-features.rst seems to make the most sense.
>
> For the counter limit property, would you prefer that it also live in
> kvm_arm_add_vcpu_properties() as "kvm-pmu-num-counters" (KVM-only), or
> keep "pmu-num-counters" general so TCG can also use it to override
> PMCR_EL0.N in reset_pmcr_el0?

If it can reasonably easily be implemented (or potentially implemented)
for TCG, then I guess the general name makes most sense.

-- PMM
