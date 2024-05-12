Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214A7E556
	for <kvmarm@lists.linux.dev>; Sun, 12 May 2024 07:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498209; cv=none; b=m8ui5ytwI6OEsuGjADjQku60AFptEUMKUJyWs8XT+c+/0U+DDFR9SkRivIJbLTaXEJvSiKuWjDBywhdQxuiY14akL434hxUB9CmjIP3653aIpWQCRLXPdJxnDTxsfG7d8nCJiuPUhkqS1FDUYtqThfRayl2n4Rfzpdr+yEBaKok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498209; c=relaxed/simple;
	bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lg6/7GCMZHHiD8aM03L56ANDcFgM63AidVwwzRY3HYsAVCsNtIGndTpQiFBCJHRZIkc1/5OIeyDMxCdCfCV7Q7NlbxVlQFN5acETF5Uwm2YOLACqXGkZ/+aVEr0+YwpAH3h1Xo58yiF5UuCqbXDNNzZEic9i7wbP8q2Wg0Zmbk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQ3SZvxe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQ3SZvxe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715498207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
	b=JQ3SZvxeVuFA9XmmTIJxALS3BsJc1S9wG6QGECL05KExf1MZr7fWoZ0v+u5U0bd61YIG8B
	4bRStyhyYSr8F8Sh55cl1y6TvJi5pI85YuysUYDZJ83iGBOxiJCqUz+okNEU25WDIwtbHo
	JzGUF0qqbfCgyCc54xZdYywTaYQnXrc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-ps-5lkENNnG7p9o6fGZOmQ-1; Sun, 12 May 2024 03:16:43 -0400
X-MC-Unique: ps-5lkENNnG7p9o6fGZOmQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34d7a7585d7so2234533f8f.2
        for <kvmarm@lists.linux.dev>; Sun, 12 May 2024 00:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715498202; x=1716103002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
        b=nwEt5mICRlUqZezRG793iEoF7sQkBsyT7xH92gh6jX2Lm8bkROReyF4G83ItWp1W8G
         X33sKw+vsNlT9yFPZ/EybrFocDdI40EAvR73y4LHR4O/NizmILFL9OP26lV+Q412+GWV
         3+C/qhPtNgNnAq/qACapR0xa9ng6jZut7RcIAADF7t2l36/1lh/qpLxE9tAlZj2c2f7s
         alDribOUxeSMntw35JFlcAvdLh3KqejBwQpe0dcZB7dvtGYpC8Soro6hqx5B1P7Rr0xa
         VsRLel8fkwkRlTdT9uzBJxlcHMBvikbNjFnaLS65mwc7OjqUOWB7Hj+B//Jdg2enLVKE
         YPeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIqu65LrxBiQiOkPLn4a2yso/SoVSWOp52dDe32BMQ21AYs2ZhA67ZZEV8Q31s7y5GJ8D37HFkNenGz6B4pbHwvcMwPdIu
X-Gm-Message-State: AOJu0YyV38g28Kw9cHoY9pvexrD5HcsKCow3JPSlibMQ3e8nu988Xgdm
	t04NBi3Uv2lt0FeB6TAMsSTcZZrGIfRgZ4myjUOtTFooYXNcBGuE9RmNFx5ApKmLrdGBtc3KAEc
	LgmaAcAUE3urqxjQPoTYXIqW9CVi4ev1IYm0vKf+TM4KM0x828YYFafbBOBorSDzBFUHk8qBPWD
	A6XyHg6nndQhzQwdIJasqyi0p8haG7
X-Received: by 2002:a5d:4d43:0:b0:346:92d2:a496 with SMTP id ffacd0b85a97d-3504a7388demr4503667f8f.29.1715498202234;
        Sun, 12 May 2024 00:16:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6BcSwq6X8dx97vsGDZlMoQs6520j3e4edXNcZL3E4BuTPppqRk6MNDV9SpKfoH0O7ZE891G+pNO3dvQPK+1Q=
X-Received: by 2002:a5d:4d43:0:b0:346:92d2:a496 with SMTP id
 ffacd0b85a97d-3504a7388demr4503646f8f.29.1715498201833; Sun, 12 May 2024
 00:16:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240511095237.3993387-1-maz@kernel.org>
In-Reply-To: <20240511095237.3993387-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 12 May 2024 09:16:30 +0200
Message-ID: <CABgObfaMMb4f75nitSiCgYZvOU=dMoPh0Lrs-fz8WVxyxnOw5A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.10
To: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Colton Lewis <coltonlewis@google.com>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Russell King <rmk+kernel@armlinux.org.uk>, Sean Christopherson <seanjc@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <zenghui.yu@linux.dev>, 
	James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 11, 2024 at 11:52=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the set of KVM/arm64 updates for 6.10. No new feature exactly,
> but a lot of internal rework, improvements and bug fixes, However, it
> is pretty good to see that the Android folks are resuming the
> upstreaming effort after a long period of silence.
>
> As usual, details in the tag below.

Pulled, thanks.

Paolo

