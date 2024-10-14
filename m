Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF595A4D5
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728929880; cv=none; b=jSgn06Ccj8rpnD3H5VL12QV7pcvZYimjU+5bfI/0EcfdlWZnmSHCjYVhP9OdjQoFSMLAfBKnf1VG6Z0P1ZEdyrooa/tjUp2bw/6AVFCxjb5bdhtsx7YIc7HRRmPARYiniUUwrvyfEKEsIG2cgSm5VLa9tz2pZDHZFrbe4LKr/SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728929880; c=relaxed/simple;
	bh=UqdM8iJiSUoaDj7cPWuEp6sm1pvhJmo7d1IQTI5RJ3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O+qimqBy7vaUBdnM1FMWoJAzEIN7f1wkUQF6ihDRk03t6ctkIwQJoN/2bZNyGYBIGyPhmH07RIWR1IM8szYlf7NOp9+ckRlCWoetJbsxNm03yc4n3nU3ol6wZQFcAs+fte2uHlW06kQovzHGT2iIFlb7NJdTfJS8oK4IZXVQ/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTgZ4aNJ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTgZ4aNJ"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c93e9e701fso23340a12.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 11:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728929877; x=1729534677; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jp70ruadsBb6cOmj4rRhx8PCIS9NrTyo6/PVn8hWzjU=;
        b=GTgZ4aNJYXUgPi7anClTgCxBnCqtQa8EjknoA+VyYnx253LglUOWdmQAKmwT0QRH8K
         Cf42ON4ReMscw7Xqno3bYuMOYyoniduFqQGFlt5oCrO2jSQ1e3oWXaoz0RVbHLeHWDAP
         lxSv5IktUxSi3/SqJa38LSYS0DQKGPbPJV0AifRvfSyZZRLvyCKf09lXnI6GE5lA8UQf
         TGfZuwvOFzYGpCR0cJg8id27ZqYuFFuYZsGx0VukzkfQIppxHuMidJmiQayCcJFcq3jt
         T71udZ6OpqD8wK3bNtSbkaUAHE0K8xKI+bSS1RMFpvxHhqZShlmcRju3C323YcXBK8qU
         l5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728929877; x=1729534677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jp70ruadsBb6cOmj4rRhx8PCIS9NrTyo6/PVn8hWzjU=;
        b=AhrO0G0ogE2mZCvhS59SIzzmz67UTQX5LC58Odh4bAs3g8yKFjmvIaBF82b2FkpOwN
         UDO/Z/ja5VChYgptBv6iyzsDtBb9O/9Mmgqu+yQGUQ8QdPYqYj7l82x4eH0N7+Dpr3eR
         klunT0IN9pLKZ/rPO2ZiJOYdtlljPy6oJe8TrmAAfXj21/WX8eXNMX3/SWXEVHcHVe68
         GUnn0Nu74ncpWGZ3Sae2kSmSY7j+kYq2s9WBXJdz9OWZ42IKCdbihEt/LV7noHgEtU3O
         JDEcf4AzmCQzqqlQdFP1Csq2l2IACL5GsE6Aco2PsrIpgWMWUXx9s4nB29tv4aFVNuwp
         5/tA==
X-Gm-Message-State: AOJu0YwFu2obXX4gqYRmzx6RojKuhTqRs6yXFGhZBK7oGvEDX3qn+Tb6
	+26opIwqELU588OVEcvV9kwI3hL4rSj0mslxHJNfCNbzkZYyaXCuanl2KhlGCXWEcfKU/IBd726
	tbpMfD0GaAwObpxEuO44FOjRzoCxNJrAP0JBX
X-Google-Smtp-Source: AGHT+IGY80fjb7LNa8eMc0UXUH61GCcUyRs5b5l2o9DfCBmWPIBKufTjC5R1rAXSewOE/N3ALIXjacNOZ11Hbfl0tWs=
X-Received: by 2002:a05:6402:5251:b0:5c8:aefb:746d with SMTP id
 4fb4d7f45d1cf-5c95c5ee259mr306236a12.5.1728929877165; Mon, 14 Oct 2024
 11:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014165809.984883-1-tabba@google.com> <865xpu61v4.wl-maz@kernel.org>
In-Reply-To: <865xpu61v4.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Oct 2024 19:17:19 +0100
Message-ID: <CA+EHjTx--swGhnNMm1m-8wCA0HUKojv9R7R-UNCs67fCfVrDog@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] KVM: arm64: Update KVM_VCPU_MAX_FEATURES and
 refactor to avoid same issue
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 14 Oct 2024 at 18:17, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 14 Oct 2024 17:58:05 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The value of KVM_VCPU_MAX_FEATURES has not been updated since
> > adding new features in commit 89b0e7de3451 ("KVM: arm64: nv:
> > Introduce nested virtualization VCPU feature").
>
> Could you please expand on what is broken? 89b0e7de3451 makes a point
> in *not* exposing this to userspace, as outlined in the commit
> message -- this is done on purpose, because NV is not functional yet.

I understand. I was wondering how you would test NV when this feature
isn't settable, which is why I thought it was broken. That said, maybe
a comment by the definition of KVM_VCPU_MAX_FEATURES to that effect
might make things less confusing for people like me :)

With that, is it worth repinning this patch, or is it not worth the
complexity of trying to hide NV as long as it's not supported?

Thanks for clarifying this,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
