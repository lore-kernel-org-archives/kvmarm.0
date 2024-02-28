Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115CC5E068
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 20:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709151835; cv=none; b=dNyG7A1ygYWezw29oos6ZLxXqtm+VI93arBb8cmYBvlwWYl/L7LKenvZzlV6Eg5GXvze18lLWxbt0DHEGWSGdldDyMKBy5fn9YvOnWXEzJeSAGR/ACsQAftwrj98vQmq7iDPWMFhD5UgNHmi4rrjefEke/FbU9U+5bMVd3dUVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709151835; c=relaxed/simple;
	bh=+/y0MOsAPsrrWnSfCr0gCNcsbOWhyXpV3oZiVG4xLrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dApAoWbPcnZAyImyfbpkHi7aIyZAxA3K99gv6UuZaVmYo96XA1YfNYpS9xApyc+r64Z68PaBUaS/yCRfIlrk1t/jtonZDonI4s65MQYRnO3Povoch+KDSWRqiPTBbfocm4sxg2G2cFWDJsJ9XMXZBpesnUt+YgZz40rmZ7ZYFwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfzWYq41; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfzWYq41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709151832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9YSJTmobEonLxuWYMBJdTDiDvHqXtRlxRQICeiZpWeg=;
	b=SfzWYq414mvpX/Jj5UxMdCjpIHxUcBYuxi9X7XC0/CsS88DCnXdyUHyN9SgB5b2/wrHSUI
	Vu3ULxYIwdPD97CMt7i4eLEtOCmf/n/45ZiUOegwrEhtqo0AMSUnp0rTAzLMKVqNXxhMNT
	K2Ud4CjQgvEdU3Fz2ObUZBMILC7ZFfY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-PxF_97P5OceiSXjKq-_igg-1; Wed, 28 Feb 2024 15:23:51 -0500
X-MC-Unique: PxF_97P5OceiSXjKq-_igg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412b62f71c1so996235e9.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 12:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709151830; x=1709756630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9YSJTmobEonLxuWYMBJdTDiDvHqXtRlxRQICeiZpWeg=;
        b=V8gm8QjzuLmcPFStO10SRzHngGccUA7G8Z4ny8x3LvfeH7BSb1jLed6FOu2u16f24h
         sW1Sa1cL5WG2rYsWBsZtG8zSqt9V2FIkwN6ha3HUZRjJO/1/XLPLc3pvNw5jySSqxC7p
         ppfV5n21aO0x2Qeg/9ckd4Yz9r4YSoV/whCdM4FWCXFP9chpglKzKMv7g9CNQ8NQXB/E
         JMsFZ196DJ3yabxhsUUmHS7uboxq5kYgSQbcPyvBA2zWABAOG7pkmBt85fKtgXPBFsLA
         MXN5vE0bGVOmnaRj5srAmJN61hgCLOxqzGImgRt/khssNxgQ9d/DsyBl11mUH62USK6C
         mHiA==
X-Forwarded-Encrypted: i=1; AJvYcCUoGVWg9Lz8y7sqzBZ97YeVhygP8MBasFG6uVmUVlcSEKf0LoaDPJW1U5tDUqZqywjcIV0QOlQF1WyDtCjm2vQf6TKEG7BT
X-Gm-Message-State: AOJu0YxdUkaoveE5atAbfr6v4mQ1u3DXj6fzWnBa/Fxf2eOIarEwQEv8
	qFVzDbJ4iYVvSOhxtXwwc73k/YgAJ1Mrr4pArxpyWI+rBqgKfo2mvNRlA1QNQFnhrcIuZPDqV5W
	ASAWOFNnz7vOob9hlugpMj3JfbTGJghdVYBAk4QAt9KryRKlyjJjL80WUEHBuTsajUZw0P+AMKY
	HIMOYrpyqDVoh8oY5mqMHyfQFBM2C5
X-Received: by 2002:a05:600c:468a:b0:412:900e:84de with SMTP id p10-20020a05600c468a00b00412900e84demr222570wmo.38.1709151830339;
        Wed, 28 Feb 2024 12:23:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7juuxTDT6eXyNfj3M3GhMcLWpI6Il2XkllZh3BEJMwiq+YiUzqzXJEJwqueeC2t5hJWeOqXh58otRxpQXDTo=
X-Received: by 2002:a05:600c:468a:b0:412:900e:84de with SMTP id
 p10-20020a05600c468a00b00412900e84demr222561wmo.38.1709151830054; Wed, 28 Feb
 2024 12:23:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
 <20240227224249.2209194-2-oliver.upton@linux.dev> <Zd9q5KbkLnh5Wddf@google.com>
 <Zd92fobEy4HFOb24@linux.dev> <Zd-F8F9OTehNoQiq@google.com> <Zd-KDOLB4J1qyfYJ@linux.dev>
In-Reply-To: <Zd-KDOLB4J1qyfYJ@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 21:23:38 +0100
Message-ID: <CABgObfa7WpDayTg2xopH4VSrNWZ0RdtiHF2muytqnK5EM3u6VA@mail.gmail.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Eric Auger <eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 8:31=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Feb 28, 2024 at 11:13:52AM -0800, Sean Christopherson wrote:
> > I'm taking exception to the "Prepare by converting to an rculist." stat=
ement.
> > This is not an RCU-protected list, it's a list that abuses rcu_list_add=
() and
> > list_for_each_rcu() to allow readers to run concurrently with insertion=
.  E.g.
> > IIUC, if it weren't for PROVE_RCU, the rcu_read_(un)lock() in the reade=
r could
> > be omitted and everything would work just fine.
>
> Fair, if we wanted to be exact about it this change relies on the
> pointer assignment properties of RCU, but not necessarily full-blown RCU
> protection. But...
>
> > Ah, but it's a moot point, because kvm_device_release() does delete fro=
m the list,
> > and does not do so in an RCU-safe manner.  So that needs to be fixed, a=
nd then
> > this is indeed an RCU-protected list.
>
> Shows how much thought I threw at the problem :D Nice catch, I'll fold
> in a fix next time around.

You also need to adjust the error case of kvm_ioctl_create_device()
(not a thorough review, I did).

Also double check that it's okay for your concurrent reader to find
the device while ops->init runs (or, better, ensure that it only does
what it has to do after ops->init is finished, with the appropriate
store-release/load-acquire operations on the two sides).

Paolo

