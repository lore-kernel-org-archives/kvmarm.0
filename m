Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8231135504D
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371251; cv=none; b=t3SLF5ygMAUeO6ejT8dIVCrpRiSDlB0kYNP3hve276hIne+ro7lVqFBViuOSNA6h7Nk+z1ic8oihDg7oywN130EnLdKMj0j80CdbV0tjasQmsEvVErvFN00WKnGCKO+7eAcrrFwHSJIaQkgRZWl2OPTzKrl6lqRlg5OlWRbY2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371251; c=relaxed/simple;
	bh=8TEJxnfV5vd+BoURyhPm3NVl9yBTSRiCIgEdiyBq0ug=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AmmC8T8XklqZoN8bi6jH2G27ym5g4QUgtcF6w5i513hPGqPME7lCAm2oFJmSe8OCYph0SznaKMlnDlzFEk+fJEUYPhyG5/dmBrPxvo4kr/uCY1FiEtV6LOmn6dxQZtUJaYiF+YHVk43bjP5iwjK3BEDL6Rr/Gu9b5GiNYdv7c2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AHDQIwn7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHDQIwn7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779371249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8TEJxnfV5vd+BoURyhPm3NVl9yBTSRiCIgEdiyBq0ug=;
	b=AHDQIwn7XcKc6Huy8ChMi1ymQMGDeife+tynoO2Sx7uLZKj6j17403cz/1RWlA0+IooLw9
	ruTNqZjvEG7X14Rfgx4P1ycwVGDiiGMJyhTlcORtpUuF0U5Mp3YQH2CrHOhmjmms1uzW1q
	l/x5bx2EWAShSoUUPv47A3C22M1pnVg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-66yrIkX2NO6k-eoKjuqi-Q-1; Thu, 21 May 2026 09:47:19 -0400
X-MC-Unique: 66yrIkX2NO6k-eoKjuqi-Q-1
X-Mimecast-MFC-AGG-ID: 66yrIkX2NO6k-eoKjuqi-Q_1779371239
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44bf1ac8893so4854745f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371238; x=1779976038;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8TEJxnfV5vd+BoURyhPm3NVl9yBTSRiCIgEdiyBq0ug=;
        b=eOaqQ7J50CqUNqp37Ur10gBYx29KavOs7VKMNpQsYW1pp6YeebDrcAuFxHnPDZ5UrV
         fRWLe6ZjHLPyblyl+mk8VxIJPj1x/ALJkmeZ1pU7FU8z7o7ZQAUOTSWLK5pwDs4Dv0Bh
         YnqGfJA2jYKGX1u0/3Wh17wvRa8T0dhqQ6zKHArwJm14yMbhxuIBuNgKXMmtcCo0VSzl
         G/w0Hw1BxRJS2GKRwvyaEOypuTqf429CjtmKGfgFHN/eVw0ahYwIY8PkyYUKZo0M+BbW
         wx9NNJELo+bVe0oz3yjtip4VKByLr8QljN5jlOGYT+yxkIjJ4pkcxGH+Jb9qKL4AfF5r
         L9pQ==
X-Forwarded-Encrypted: i=1; AFNElJ8aVJpYQc99BfqSFqlDCHCFIbh4cAGfmiEiVfax2mGr2S6ZfLX2a3+3trTDCqikv5emzCcgzvg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKgrAOAWrVWgp2asGgGZVpQFiW50zvs19zfM7fkhSt3gksnGNu
	0blVovHB7TTHtyMc4EP12+0+fk2b3WLQ5QM9mMWF9c3zzt/QpiPubFe1gXDDUT9dG2xSKQy9lm9
	fDepTyqhwWYihXrMOT4Cauqc5YJHbiYt6DssvQGf7vufccqM+o8ltFa7LFQ==
X-Gm-Gg: Acq92OEG3SyggaPCAeOIGElfFCXKgmaMGle3Ny15ZDxh2oo/2SlvXbl1eDENJVOo0ad
	a+0/ssAR7uFYWTfzV6Hk5rx0xRBoXmdrDd06kCQxxEcYQ22HxeU9DuuEYxpSYBABlkpQhhr/lUs
	GPgTvJQC6qvtIhABZi9bg8tLJ6HJf7Hww5uwq6O3f4zgy/+inRvxFTU47uYVw0xLvICerQPq2ZT
	C0dSzIkFTnkReeQF5TWpm8/mJ4pGOaQQPdpqM7mgzyz/qEA/7sypVOrxEB1OQKz2YTMtbizG7wU
	86zDMUEBJZDgvFGQM3+tDvFCL+xQ/BWrRbK2EbFnZfrFfovBYzQWs4K15XlfsvWPeFcdnPlw48R
	yR1SHLtHeTl36My5Z/9b/pGKb1YWRksASzFPbXlK4vJ5wH89f1j0Co8cLOaLu51cVxjIXCPo=
X-Received: by 2002:a5d:5f91:0:b0:45e:73b4:85cc with SMTP id ffacd0b85a97d-45ea40f36ddmr4620328f8f.35.1779371238628;
        Thu, 21 May 2026 06:47:18 -0700 (PDT)
X-Received: by 2002:a5d:5f91:0:b0:45e:73b4:85cc with SMTP id ffacd0b85a97d-45ea40f36ddmr4620285f8f.35.1779371238237;
        Thu, 21 May 2026 06:47:18 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa7cd815sm4410866f8f.6.2026.05.21.06.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:47:17 -0700 (PDT)
Date: Thu, 21 May 2026 15:47:16 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 10/18] target/arm/cpu64: Retrieve writable ID reg map
 in aarch64_host_initfn()
In-Reply-To: <20260519132905.145643-11-eric.auger@redhat.com>
Message-ID: <23dd2f71-d5d8-952e-c32c-cfb3537f89c0@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-11-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6S34VAbUd0sD9gfVEnl6BfX5nZPf1YIvZVjum8WGi1I_1779371239
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:

> Store the writable_map array in the CPU state and populate it
> in aarch64_host_initfn(). In case the retrieval fails we simply
> free and null the pointer: this will indicate that the writable_map
> is not usable in subsequent patches.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

