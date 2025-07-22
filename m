Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AED2E11C0
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195200; cv=none; b=a250nx3zYYYwSCLBKR41Kg5TJnPOkULfCLY0s8KPgcKnG6xBKG7Q2vDQMC237lhBXTnRidXw1CbMpNc0sDJ2EydYxGTly3nBRbithOzyGRTPbiHic7ebxGUHm4kcKe/bc5lpgk2LD+CRKAPWWw1FPTin6LTRkj/XHoXqLykoZ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195200; c=relaxed/simple;
	bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K2dfP+reJTtKiKC5BJ8G+KGgcE1kQ53QsboKG2Aq+ffpSrzGaI7hb/l8HjoXdzrEQj0aDbzyLpMo9unlcCGOTRGxfNRKx8Se8xGV7upQZYq+SCr4JWoRqC2rJ7m7WBFUKSGxYictKp5SPxAq5JFnUwFz/9+FgXD963gJshypJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhF9v5wH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhF9v5wH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753195198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
	b=IhF9v5wHeF8Y+tmLH7oyO+rBm+p85ooUP8ImchqGEInIJ3WOoCSw+9JZ075ZwX/2v5n3Ye
	BRkZSQCcCC8LyM7MPn86EsWSxPwYRZIaR7o98p/QO2oqlAFTd7UBD6hcCVTe/fbI/iVaed
	whRvg2kri9tS0hJEXxuubiiOeOm+36U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-GlmzRa6eNdaAKZRvgQmmbw-1; Tue, 22 Jul 2025 10:39:53 -0400
X-MC-Unique: GlmzRa6eNdaAKZRvgQmmbw-1
X-Mimecast-MFC-AGG-ID: GlmzRa6eNdaAKZRvgQmmbw_1753195192
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4538f375e86so51788885e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 07:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195192; x=1753799992;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
        b=EuDioQEUNXP8AzI7qCmt75Ul8f43VHN42L05UbhKXUQyCfYUSIJt1i4dLFr14Z+5QX
         P3hyPg9xD72a4z63KMNRzPiXUkn8rwmGpC+Cx/Ye40qN9BP7t8VGrbg6OIs36/SJr1nW
         ipJLF2JiKAX5ovtq7/G6IyyKnD+onP6uHcSryEvAbZmbaHgwVvAU4pGXxYoXMkHQaTJM
         gSjMDtMH3uu+SKxxlcO8690k0Xku/cEtSnuFqKMeWGs9bps/JmNCrAaF1JClbrVZDUvW
         FjQopr8D15Pppph1ADSfRupgUzo7gtU4FMXCG49b005VQLyNCaTK8CPURpmBgIi9ZJ12
         pHxQ==
X-Gm-Message-State: AOJu0YxUV0TrZMReBB7OVKmrHpcRHFSJ7QLYd11goJcfJ6EhJCECO7nI
	uByN2Jcq1z1yD2OixpcKZA9uyhNBeNXmX15s5oN+7c4geNwJMjxVKxu6KNTSP9pFivTMPhEuG+H
	8iEmWDqOAkrPug7FVW5OL6J5ooeCaJNjMvRPjsLmftZ0fEqAH2L7teeDAKg==
X-Gm-Gg: ASbGncseo4kfRTY7xS/CCj8J9NFJ2aemnhnwoHdnMSE3k9gBnUJuBAozadCsFbKWpU5
	YbdCTs+fHAPsKwKwQpwad4K5oV4zSj6VqS6bjRrdY8bKGsj8wOgLuIs7wfABg33dHoaTojof9k6
	LXi2OLLlieO58T4cxt2ZJ3OxsrdOxnN9uoRH6LBc8X9y1le+so9UryWpC3g4VzVID75/gdpykf6
	dGlTaaVr2AUrhFHwZWOaZWA2KHOJMEyvkP8b2lAoPLrIp9M0kuw11HbzP1TDMAKIYkEQZ1V/xl+
	PN+mIO0mL3uTqJPWjUTdvZt23cU7i9WBG6eCD0su8XYRxUcMhRMY04vP2eO9iQ7DgpummB4bF0P
	VcStiCmBG81lQ
X-Received: by 2002:a05:600c:310b:b0:453:9b7:c214 with SMTP id 5b1f17b1804b1-4562e29c33emr210945135e9.29.1753195192081;
        Tue, 22 Jul 2025 07:39:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiFVJztAJAsGCwFkVWQjDHWa5km7SIwfTibnU0fsbIHs3oWXWzepmUGBqcNc5EYazTcDWqmA==
X-Received: by 2002:a05:600c:310b:b0:453:9b7:c214 with SMTP id 5b1f17b1804b1-4562e29c33emr210944865e9.29.1753195191605;
        Tue, 22 Jul 2025 07:39:51 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e886113sm196183095e9.23.2025.07.22.07.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 07:39:51 -0700 (PDT)
Date: Tue, 22 Jul 2025 16:39:49 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
    jackabt@amazon.com
Subject: Re: [PATCH] KVM: arm64: selftest: Add standalone test checking for
 KVM's own UUID
In-Reply-To: <20250721155136.892255-1-maz@kernel.org>
Message-ID: <aa2bbb09-c9bb-100e-b4dd-a3010c8458eb@redhat.com>
References: <20250721155136.892255-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E7rMg1UoMVBzPjPTi-KIk8O2DemEJXJcji9CIWOeUpE_1753195192
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 21 Jul 2025, Marc Zyngier wrote:
> Tinkering with UUIDs is a perilious task, and the KVM UUID gets
> broken at times. In order to spot this early enough, add a selftest
> that will shout if the expected value isn't found.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250721130558.50823-1-jackabt.amazon@gmail.com

Reviewed-by: Sebastian Ott <sebott@redhat.com>

