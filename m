Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A902BE7D0
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761573751; cv=none; b=aULVSaQ5y5HY7Z2/Ylroxk6TAFeAhkypFopbZ0z691Nki4LvoYKIINbI/t3njTbY3Ny/rpFLvXsSktPi5fKTKa7Y6yH2nGBGrfvrO77dJyeLZLMoll80/RpblbaGk4NY4yxXW5OrZFF1WU3lzGCtFKMqMzbv17AJyUgVfkPANyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761573751; c=relaxed/simple;
	bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AMjPhbYG6i/Lh0PTsXbAKoTbAmsGHMdSYbiqFCcmHPAPpVouH3Y4w5b9pDZkO+1bZYlrbs9MhLFJd+smY1ofi8jxb+e6jjaOsm3T3kp/n9YX0Nlul7Oc9+NXr22fvK+SPGCQVJC2y9bnw3H/ePk/f9WTGB5s+kvOaD7MP6VEeX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzKz6nUK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzKz6nUK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761573749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
	b=BzKz6nUKcUHLqAQG17WkfHbpxOAfvbSQq8e7ywRla27vQVzR/ELGcGz2B6M/jrONbWxtnG
	xBQku+QgkqRGlGZ6py3rShCc0fFpe47/nCMnyNWIbOi2vMrDcS69KjZNbkZgx9+1KW8Jba
	l4WMM28on6ISOfStEEB8DmNVzL7rS3c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-uhb2ZI4ZM3OexgAdds5EGg-1; Mon, 27 Oct 2025 10:02:27 -0400
X-MC-Unique: uhb2ZI4ZM3OexgAdds5EGg-1
X-Mimecast-MFC-AGG-ID: uhb2ZI4ZM3OexgAdds5EGg_1761573746
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee888281c3so3138618f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 07:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761573746; x=1762178546;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
        b=JkOHHso6DrGVfP3ADhQwjn1xMo6kbImlBcsAAD5AJALbIyFeXQD8b70hgLLe/2/hiX
         4ip6q65CLqEJ/T/p3iHwClRGRqD/0fZiggOqYfq8PVx5iKfLYyD2ylLZ4annh1Ozo0aF
         JDKAfSmxLlorYUkH7WWVJlQJvKjCp5R3OkjeIdSK8D9b35mOJ2TKcRpfrYgKyw6ALiXU
         gFq0Z3JAiOWPwqCU6ag4jEvJKeTclbqH34gCMMJDlb2s6s9NT8AYyNCT3eiBMi6xXOsp
         YqTLBcKjCj/B+vIt9vYEvAKy4JyD7Jp7y/WvjkA9sLkxLyLQ0wBlnebNQLcLeMG7+wsu
         q0LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb+D8aGXLOhOjH7xz8vN82QvpofoMq7btP8cCNG/erAM6+Ny/oecppn63DBD4bJQDYJrKQaH8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb/aTaLgKsh/nSPuXrvkj44ZUog9bIwqIwXX+p7MLidSDQOUsx
	3nre4Lnds6T7pW8gEbl0FU4n8wIZdxFV4EjSsjLhDXSI6lKV4OCbZjFz6jmfNhz+aR6op72pH0/
	/UauAV6nn1jV18HmnRhsVvpC4HXzfno+KqG7o68BE3ek59CjtrXTdAKMIqw==
X-Gm-Gg: ASbGncvLzP0IkGNpbYa1x0hPLR1NtxjmndqcXsYW2AsNcgJQqFq92qg1NTIKQ2uGgun
	S2Yyfu0PejjQoXYHp2RBdfhFVaSR6luRUlzgHdmpP0rbvawMsXnPL5oX0j+VerTKqCPMPKM0Sc9
	dR3QRbGLUOTU7Mq6WXX59OkOxVaUaORUDM6dwpYLN46SkaAfepUQqPeWMS0aFrt+Cti1E3QOerY
	fRGxFec3RpxalJAa8A1UwCHyXWIIfARw8pj9Fzyy6vw6K6pm7cRPrZYv2xRJzeUhGR6AA6ZY62x
	hJxTEV/SQnLoYgM1u5rZR5Tfu41rl4g3FSjTKMLo0/OnmfCbNTtQxSmsocGbcpRJ37hCAU/O97o
	rKPqUDoBhP/sazKx/D/B5hddKEk0bY8PigxgySR+eD7fvs4xv
X-Received: by 2002:a05:6000:288f:b0:427:a37:ea3e with SMTP id ffacd0b85a97d-42990755b87mr8916535f8f.52.1761573744793;
        Mon, 27 Oct 2025 07:02:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETyCrcEtLcl3q6Rbfg7qOzwYfycn5fPY5jgI68IwSrW44NCEA1DZHmuz8NQf54cnQJ3dYQ8g==
X-Received: by 2002:a05:6000:288f:b0:427:a37:ea3e with SMTP id ffacd0b85a97d-42990755b87mr8916495f8f.52.1761573744177;
        Mon, 27 Oct 2025 07:02:24 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79cbsm14242478f8f.4.2025.10.27.07.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 07:02:23 -0700 (PDT)
Date: Mon, 27 Oct 2025 15:02:22 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
    "maz@kernel.org" <maz@kernel.org>, 
    "broonie@kernel.org" <broonie@kernel.org>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
    "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
In-Reply-To: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Message-ID: <e2d3e614-4e5e-7ad9-5cc6-867d85dca5c0@redhat.com>
References: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: exU5m-axb8dDL1fHIihHcaJx41NzwAmuvg3LpPmCzVM_1761573746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 21 Oct 2025, Sascha Bischoff wrote:

> If there is no in-kernel irqchip for a GICv3 host set all of the trap
> bits to block all accesses. This fixes the no-vgic-v3 selftest again.
>
> Fixes: 3193287ddffb ("KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests")
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/all/23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

